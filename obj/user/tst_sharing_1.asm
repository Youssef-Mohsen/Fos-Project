
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
  80005c:	68 80 3e 80 00       	push   $0x803e80
  800061:	6a 13                	push   $0x13
  800063:	68 9c 3e 80 00       	push   $0x803e9c
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
  800085:	68 b4 3e 80 00       	push   $0x803eb4
  80008a:	e8 7a 07 00 00       	call   800809 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800092:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800099:	e8 58 1b 00 00       	call   801bf6 <sys_calculate_free_frames>
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	6a 01                	push   $0x1
  8000a6:	68 00 10 00 00       	push   $0x1000
  8000ab:	68 f0 3e 80 00       	push   $0x803ef0
  8000b0:	e8 22 18 00 00       	call   8018d7 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000c1:	74 17                	je     8000da <_main+0xa2>
  8000c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 f4 3e 80 00       	push   $0x803ef4
  8000d2:	e8 32 07 00 00       	call   800809 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8000da:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8000e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000e4:	e8 0d 1b 00 00       	call   801bf6 <sys_calculate_free_frames>
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
  80010f:	e8 e2 1a 00 00       	call   801bf6 <sys_calculate_free_frames>
  800114:	29 c3                	sub    %eax,%ebx
  800116:	89 d8                	mov    %ebx,%eax
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	68 60 3f 80 00       	push   $0x803f60
  800124:	e8 e0 06 00 00       	call   800809 <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80012c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800130:	74 04                	je     800136 <_main+0xfe>
  800132:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  800136:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80013d:	e8 b4 1a 00 00       	call   801bf6 <sys_calculate_free_frames>
  800142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	6a 01                	push   $0x1
  80014a:	68 04 10 00 00       	push   $0x1004
  80014f:	68 f8 3f 80 00       	push   $0x803ff8
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
  800176:	68 f4 3e 80 00       	push   $0x803ef4
  80017b:	e8 89 06 00 00       	call   800809 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2pages*/
  800183:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80018a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80018d:	e8 64 1a 00 00       	call   801bf6 <sys_calculate_free_frames>
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
  8001b8:	e8 39 1a 00 00       	call   801bf6 <sys_calculate_free_frames>
  8001bd:	29 c3                	sub    %eax,%ebx
  8001bf:	89 d8                	mov    %ebx,%eax
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c7:	50                   	push   %eax
  8001c8:	68 60 3f 80 00       	push   $0x803f60
  8001cd:	e8 37 06 00 00       	call   800809 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  8001d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d9:	74 04                	je     8001df <_main+0x1a7>
  8001db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  8001df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001e6:	e8 0b 1a 00 00       	call   801bf6 <sys_calculate_free_frames>
  8001eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		y = smalloc("y", 4, 1);
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 01                	push   $0x1
  8001f3:	6a 04                	push   $0x4
  8001f5:	68 fa 3f 80 00       	push   $0x803ffa
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
  80021c:	68 f4 3e 80 00       	push   $0x803ef4
  800221:	e8 e3 05 00 00       	call   800809 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1page*/
  800229:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800230:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800233:	e8 be 19 00 00       	call   801bf6 <sys_calculate_free_frames>
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
  80025e:	e8 93 19 00 00       	call   801bf6 <sys_calculate_free_frames>
  800263:	29 c3                	sub    %eax,%ebx
  800265:	89 d8                	mov    %ebx,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	ff 75 dc             	pushl  -0x24(%ebp)
  80026d:	50                   	push   %eax
  80026e:	68 60 3f 80 00       	push   $0x803f60
  800273:	e8 91 05 00 00       	call   800809 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80027b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80027f:	74 04                	je     800285 <_main+0x24d>
  800281:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 fc 3f 80 00       	push   $0x803ffc
  80028d:	e8 77 05 00 00       	call   800809 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp

	is_correct = 1;
  800295:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP B: checking reading & writing... [40%]\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 24 40 80 00       	push   $0x804024
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
  800329:	68 54 40 80 00       	push   $0x804054
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
  80034f:	68 54 40 80 00       	push   $0x804054
  800354:	e8 b0 04 00 00       	call   800809 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
		if( y[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80035c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	83 f8 ff             	cmp    $0xffffffff,%eax
  800364:	74 17                	je     80037d <_main+0x345>
  800366:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 54 40 80 00       	push   $0x804054
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
  800396:	68 54 40 80 00       	push   $0x804054
  80039b:	e8 69 04 00 00       	call   800809 <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003ab:	74 17                	je     8003c4 <_main+0x38c>
  8003ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 54 40 80 00       	push   $0x804054
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
  8003dd:	68 54 40 80 00       	push   $0x804054
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
  8003fa:	68 80 40 80 00       	push   $0x804080
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
  800413:	e8 a7 19 00 00       	call   801dbf <sys_getenvindex>
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
  800481:	e8 bd 16 00 00       	call   801b43 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	68 dc 40 80 00       	push   $0x8040dc
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
  8004b1:	68 04 41 80 00       	push   $0x804104
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
  8004e2:	68 2c 41 80 00       	push   $0x80412c
  8004e7:	e8 1d 03 00 00       	call   800809 <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	50                   	push   %eax
  8004fe:	68 84 41 80 00       	push   $0x804184
  800503:	e8 01 03 00 00       	call   800809 <cprintf>
  800508:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	68 dc 40 80 00       	push   $0x8040dc
  800513:	e8 f1 02 00 00       	call   800809 <cprintf>
  800518:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80051b:	e8 3d 16 00 00       	call   801b5d <sys_unlock_cons>
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
  800533:	e8 53 18 00 00       	call   801d8b <sys_destroy_env>
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
  800544:	e8 a8 18 00 00       	call   801df1 <sys_exit_env>
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
  80056d:	68 98 41 80 00       	push   $0x804198
  800572:	e8 92 02 00 00       	call   800809 <cprintf>
  800577:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80057a:	a1 00 50 80 00       	mov    0x805000,%eax
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	ff 75 08             	pushl  0x8(%ebp)
  800585:	50                   	push   %eax
  800586:	68 9d 41 80 00       	push   $0x80419d
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
  8005aa:	68 b9 41 80 00       	push   $0x8041b9
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
  8005d9:	68 bc 41 80 00       	push   $0x8041bc
  8005de:	6a 26                	push   $0x26
  8005e0:	68 08 42 80 00       	push   $0x804208
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
  8006ae:	68 14 42 80 00       	push   $0x804214
  8006b3:	6a 3a                	push   $0x3a
  8006b5:	68 08 42 80 00       	push   $0x804208
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
  800721:	68 68 42 80 00       	push   $0x804268
  800726:	6a 44                	push   $0x44
  800728:	68 08 42 80 00       	push   $0x804208
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
  80077b:	e8 81 13 00 00       	call   801b01 <sys_cputs>
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
  8007f2:	e8 0a 13 00 00       	call   801b01 <sys_cputs>
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
  80083c:	e8 02 13 00 00       	call   801b43 <sys_lock_cons>
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
  80085c:	e8 fc 12 00 00       	call   801b5d <sys_unlock_cons>
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
  8008a6:	e8 59 33 00 00       	call   803c04 <__udivdi3>
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
  8008f6:	e8 19 34 00 00       	call   803d14 <__umoddi3>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	05 d4 44 80 00       	add    $0x8044d4,%eax
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
  800a51:	8b 04 85 f8 44 80 00 	mov    0x8044f8(,%eax,4),%eax
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
  800b32:	8b 34 9d 40 43 80 00 	mov    0x804340(,%ebx,4),%esi
  800b39:	85 f6                	test   %esi,%esi
  800b3b:	75 19                	jne    800b56 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b3d:	53                   	push   %ebx
  800b3e:	68 e5 44 80 00       	push   $0x8044e5
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
  800b57:	68 ee 44 80 00       	push   $0x8044ee
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
  800b84:	be f1 44 80 00       	mov    $0x8044f1,%esi
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
  80158f:	68 68 46 80 00       	push   $0x804668
  801594:	68 3f 01 00 00       	push   $0x13f
  801599:	68 8a 46 80 00       	push   $0x80468a
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
  8015af:	e8 f8 0a 00 00       	call   8020ac <sys_sbrk>
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
  80162a:	e8 01 09 00 00       	call   801f30 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162f:	85 c0                	test   %eax,%eax
  801631:	74 16                	je     801649 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 dd 0e 00 00       	call   80251b <alloc_block_FF>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801644:	e9 8a 01 00 00       	jmp    8017d3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801649:	e8 13 09 00 00       	call   801f61 <sys_isUHeapPlacementStrategyBESTFIT>
  80164e:	85 c0                	test   %eax,%eax
  801650:	0f 84 7d 01 00 00    	je     8017d3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	e8 76 13 00 00       	call   8029d7 <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  8016bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016be:	05 00 10 00 00       	add    $0x1000,%eax
  8016c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8016c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  801766:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80176a:	75 16                	jne    801782 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  80176c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801773:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80177a:	0f 86 15 ff ff ff    	jbe    801695 <malloc+0xdc>
  801780:	eb 01                	jmp    801783 <malloc+0x1ca>
				}
				

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
  8017c2:	e8 1c 09 00 00       	call   8020e3 <sys_allocate_user_mem>
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	eb 07                	jmp    8017d3 <malloc+0x21a>
		
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
  80180a:	e8 8c 09 00 00       	call   80219b <get_block_size>
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801815:	83 ec 0c             	sub    $0xc,%esp
  801818:	ff 75 08             	pushl  0x8(%ebp)
  80181b:	e8 9c 1b 00 00       	call   8033bc <free_block>
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
  801855:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801892:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801899:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  80189d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	83 ec 08             	sub    $0x8,%esp
  8018a6:	52                   	push   %edx
  8018a7:	50                   	push   %eax
  8018a8:	e8 1a 08 00 00       	call   8020c7 <sys_free_user_mem>
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
  8018c0:	68 98 46 80 00       	push   $0x804698
  8018c5:	68 87 00 00 00       	push   $0x87
  8018ca:	68 c2 46 80 00       	push   $0x8046c2
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
  8018ee:	e9 87 00 00 00       	jmp    80197a <smalloc+0xa3>
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
  80191f:	75 07                	jne    801928 <smalloc+0x51>
  801921:	b8 00 00 00 00       	mov    $0x0,%eax
  801926:	eb 52                	jmp    80197a <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801928:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80192c:	ff 75 ec             	pushl  -0x14(%ebp)
  80192f:	50                   	push   %eax
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	ff 75 08             	pushl  0x8(%ebp)
  801936:	e8 93 03 00 00       	call   801cce <sys_createSharedObject>
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801941:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801945:	74 06                	je     80194d <smalloc+0x76>
  801947:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80194b:	75 07                	jne    801954 <smalloc+0x7d>
  80194d:	b8 00 00 00 00       	mov    $0x0,%eax
  801952:	eb 26                	jmp    80197a <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801954:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801957:	a1 20 50 80 00       	mov    0x805020,%eax
  80195c:	8b 40 78             	mov    0x78(%eax),%eax
  80195f:	29 c2                	sub    %eax,%edx
  801961:	89 d0                	mov    %edx,%eax
  801963:	2d 00 10 00 00       	sub    $0x1000,%eax
  801968:	c1 e8 0c             	shr    $0xc,%eax
  80196b:	89 c2                	mov    %eax,%edx
  80196d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801970:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801977:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801982:	83 ec 08             	sub    $0x8,%esp
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	e8 68 03 00 00       	call   801cf8 <sys_getSizeOfSharedObject>
  801990:	83 c4 10             	add    $0x10,%esp
  801993:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801996:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80199a:	75 07                	jne    8019a3 <sget+0x27>
  80199c:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a1:	eb 7f                	jmp    801a22 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8019a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b6:	39 d0                	cmp    %edx,%eax
  8019b8:	73 02                	jae    8019bc <sget+0x40>
  8019ba:	89 d0                	mov    %edx,%eax
  8019bc:	83 ec 0c             	sub    $0xc,%esp
  8019bf:	50                   	push   %eax
  8019c0:	e8 f4 fb ff ff       	call   8015b9 <malloc>
  8019c5:	83 c4 10             	add    $0x10,%esp
  8019c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8019cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019cf:	75 07                	jne    8019d8 <sget+0x5c>
  8019d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d6:	eb 4a                	jmp    801a22 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8019d8:	83 ec 04             	sub    $0x4,%esp
  8019db:	ff 75 e8             	pushl  -0x18(%ebp)
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	e8 2c 03 00 00       	call   801d15 <sys_getSharedObject>
  8019e9:	83 c4 10             	add    $0x10,%esp
  8019ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8019ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8019f7:	8b 40 78             	mov    0x78(%eax),%eax
  8019fa:	29 c2                	sub    %eax,%edx
  8019fc:	89 d0                	mov    %edx,%eax
  8019fe:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a03:	c1 e8 0c             	shr    $0xc,%eax
  801a06:	89 c2                	mov    %eax,%edx
  801a08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a0b:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801a12:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801a16:	75 07                	jne    801a1f <sget+0xa3>
  801a18:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1d:	eb 03                	jmp    801a22 <sget+0xa6>
	return ptr;
  801a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801a2a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a2d:	a1 20 50 80 00       	mov    0x805020,%eax
  801a32:	8b 40 78             	mov    0x78(%eax),%eax
  801a35:	29 c2                	sub    %eax,%edx
  801a37:	89 d0                	mov    %edx,%eax
  801a39:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a3e:	c1 e8 0c             	shr    $0xc,%eax
  801a41:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801a4b:	83 ec 08             	sub    $0x8,%esp
  801a4e:	ff 75 08             	pushl  0x8(%ebp)
  801a51:	ff 75 f4             	pushl  -0xc(%ebp)
  801a54:	e8 db 02 00 00       	call   801d34 <sys_freeSharedObject>
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801a5f:	90                   	nop
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a68:	83 ec 04             	sub    $0x4,%esp
  801a6b:	68 d0 46 80 00       	push   $0x8046d0
  801a70:	68 e4 00 00 00       	push   $0xe4
  801a75:	68 c2 46 80 00       	push   $0x8046c2
  801a7a:	e8 cd ea ff ff       	call   80054c <_panic>

00801a7f <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a85:	83 ec 04             	sub    $0x4,%esp
  801a88:	68 f6 46 80 00       	push   $0x8046f6
  801a8d:	68 f0 00 00 00       	push   $0xf0
  801a92:	68 c2 46 80 00       	push   $0x8046c2
  801a97:	e8 b0 ea ff ff       	call   80054c <_panic>

00801a9c <shrink>:

}
void shrink(uint32 newSize)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	68 f6 46 80 00       	push   $0x8046f6
  801aaa:	68 f5 00 00 00       	push   $0xf5
  801aaf:	68 c2 46 80 00       	push   $0x8046c2
  801ab4:	e8 93 ea ff ff       	call   80054c <_panic>

00801ab9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801abf:	83 ec 04             	sub    $0x4,%esp
  801ac2:	68 f6 46 80 00       	push   $0x8046f6
  801ac7:	68 fa 00 00 00       	push   $0xfa
  801acc:	68 c2 46 80 00       	push   $0x8046c2
  801ad1:	e8 76 ea ff ff       	call   80054c <_panic>

00801ad6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	57                   	push   %edi
  801ada:	56                   	push   %esi
  801adb:	53                   	push   %ebx
  801adc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aeb:	8b 7d 18             	mov    0x18(%ebp),%edi
  801aee:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801af1:	cd 30                	int    $0x30
  801af3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801af9:	83 c4 10             	add    $0x10,%esp
  801afc:	5b                   	pop    %ebx
  801afd:	5e                   	pop    %esi
  801afe:	5f                   	pop    %edi
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 04             	sub    $0x4,%esp
  801b07:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b0d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	52                   	push   %edx
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	50                   	push   %eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	e8 b2 ff ff ff       	call   801ad6 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	90                   	nop
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_cgetc>:

int
sys_cgetc(void)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 02                	push   $0x2
  801b39:	e8 98 ff ff ff       	call   801ad6 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 03                	push   $0x3
  801b52:	e8 7f ff ff ff       	call   801ad6 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	90                   	nop
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 04                	push   $0x4
  801b6c:	e8 65 ff ff ff       	call   801ad6 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	90                   	nop
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	52                   	push   %edx
  801b87:	50                   	push   %eax
  801b88:	6a 08                	push   $0x8
  801b8a:	e8 47 ff ff ff       	call   801ad6 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	56                   	push   %esi
  801b98:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b99:	8b 75 18             	mov    0x18(%ebp),%esi
  801b9c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	56                   	push   %esi
  801ba9:	53                   	push   %ebx
  801baa:	51                   	push   %ecx
  801bab:	52                   	push   %edx
  801bac:	50                   	push   %eax
  801bad:	6a 09                	push   $0x9
  801baf:	e8 22 ff ff ff       	call   801ad6 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bba:	5b                   	pop    %ebx
  801bbb:	5e                   	pop    %esi
  801bbc:	5d                   	pop    %ebp
  801bbd:	c3                   	ret    

00801bbe <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	52                   	push   %edx
  801bce:	50                   	push   %eax
  801bcf:	6a 0a                	push   $0xa
  801bd1:	e8 00 ff ff ff       	call   801ad6 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	ff 75 0c             	pushl  0xc(%ebp)
  801be7:	ff 75 08             	pushl  0x8(%ebp)
  801bea:	6a 0b                	push   $0xb
  801bec:	e8 e5 fe ff ff       	call   801ad6 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 0c                	push   $0xc
  801c05:	e8 cc fe ff ff       	call   801ad6 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 0d                	push   $0xd
  801c1e:	e8 b3 fe ff ff       	call   801ad6 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 0e                	push   $0xe
  801c37:	e8 9a fe ff ff       	call   801ad6 <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 0f                	push   $0xf
  801c50:	e8 81 fe ff ff       	call   801ad6 <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	6a 10                	push   $0x10
  801c6a:	e8 67 fe ff ff       	call   801ad6 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 11                	push   $0x11
  801c83:	e8 4e fe ff ff       	call   801ad6 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	90                   	nop
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_cputc>:

void
sys_cputc(const char c)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 04             	sub    $0x4,%esp
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c9a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	50                   	push   %eax
  801ca7:	6a 01                	push   $0x1
  801ca9:	e8 28 fe ff ff       	call   801ad6 <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
}
  801cb1:	90                   	nop
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 14                	push   $0x14
  801cc3:	e8 0e fe ff ff       	call   801ad6 <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	90                   	nop
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cda:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cdd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	6a 00                	push   $0x0
  801ce6:	51                   	push   %ecx
  801ce7:	52                   	push   %edx
  801ce8:	ff 75 0c             	pushl  0xc(%ebp)
  801ceb:	50                   	push   %eax
  801cec:	6a 15                	push   $0x15
  801cee:	e8 e3 fd ff ff       	call   801ad6 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	52                   	push   %edx
  801d08:	50                   	push   %eax
  801d09:	6a 16                	push   $0x16
  801d0b:	e8 c6 fd ff ff       	call   801ad6 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	51                   	push   %ecx
  801d26:	52                   	push   %edx
  801d27:	50                   	push   %eax
  801d28:	6a 17                	push   $0x17
  801d2a:	e8 a7 fd ff ff       	call   801ad6 <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	52                   	push   %edx
  801d44:	50                   	push   %eax
  801d45:	6a 18                	push   $0x18
  801d47:	e8 8a fd ff ff       	call   801ad6 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	6a 00                	push   $0x0
  801d59:	ff 75 14             	pushl  0x14(%ebp)
  801d5c:	ff 75 10             	pushl  0x10(%ebp)
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	50                   	push   %eax
  801d63:	6a 19                	push   $0x19
  801d65:	e8 6c fd ff ff       	call   801ad6 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	50                   	push   %eax
  801d7e:	6a 1a                	push   $0x1a
  801d80:	e8 51 fd ff ff       	call   801ad6 <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	90                   	nop
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	50                   	push   %eax
  801d9a:	6a 1b                	push   $0x1b
  801d9c:	e8 35 fd ff ff       	call   801ad6 <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 05                	push   $0x5
  801db5:	e8 1c fd ff ff       	call   801ad6 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 06                	push   $0x6
  801dce:	e8 03 fd ff ff       	call   801ad6 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 07                	push   $0x7
  801de7:	e8 ea fc ff ff       	call   801ad6 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_exit_env>:


void sys_exit_env(void)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 1c                	push   $0x1c
  801e00:	e8 d1 fc ff ff       	call   801ad6 <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
}
  801e08:	90                   	nop
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e11:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e14:	8d 50 04             	lea    0x4(%eax),%edx
  801e17:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	52                   	push   %edx
  801e21:	50                   	push   %eax
  801e22:	6a 1d                	push   $0x1d
  801e24:	e8 ad fc ff ff       	call   801ad6 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
	return result;
  801e2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e35:	89 01                	mov    %eax,(%ecx)
  801e37:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3d:	c9                   	leave  
  801e3e:	c2 04 00             	ret    $0x4

00801e41 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	ff 75 10             	pushl  0x10(%ebp)
  801e4b:	ff 75 0c             	pushl  0xc(%ebp)
  801e4e:	ff 75 08             	pushl  0x8(%ebp)
  801e51:	6a 13                	push   $0x13
  801e53:	e8 7e fc ff ff       	call   801ad6 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5b:	90                   	nop
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_rcr2>:
uint32 sys_rcr2()
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 1e                	push   $0x1e
  801e6d:	e8 64 fc ff ff       	call   801ad6 <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 04             	sub    $0x4,%esp
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e83:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	50                   	push   %eax
  801e90:	6a 1f                	push   $0x1f
  801e92:	e8 3f fc ff ff       	call   801ad6 <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9a:	90                   	nop
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <rsttst>:
void rsttst()
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 21                	push   $0x21
  801eac:	e8 25 fc ff ff       	call   801ad6 <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb4:	90                   	nop
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ec3:	8b 55 18             	mov    0x18(%ebp),%edx
  801ec6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eca:	52                   	push   %edx
  801ecb:	50                   	push   %eax
  801ecc:	ff 75 10             	pushl  0x10(%ebp)
  801ecf:	ff 75 0c             	pushl  0xc(%ebp)
  801ed2:	ff 75 08             	pushl  0x8(%ebp)
  801ed5:	6a 20                	push   $0x20
  801ed7:	e8 fa fb ff ff       	call   801ad6 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
	return ;
  801edf:	90                   	nop
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <chktst>:
void chktst(uint32 n)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	ff 75 08             	pushl  0x8(%ebp)
  801ef0:	6a 22                	push   $0x22
  801ef2:	e8 df fb ff ff       	call   801ad6 <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
	return ;
  801efa:	90                   	nop
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <inctst>:

void inctst()
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 23                	push   $0x23
  801f0c:	e8 c5 fb ff ff       	call   801ad6 <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
	return ;
  801f14:	90                   	nop
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <gettst>:
uint32 gettst()
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 24                	push   $0x24
  801f26:	e8 ab fb ff ff       	call   801ad6 <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 25                	push   $0x25
  801f42:	e8 8f fb ff ff       	call   801ad6 <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
  801f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f4d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f51:	75 07                	jne    801f5a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f53:	b8 01 00 00 00       	mov    $0x1,%eax
  801f58:	eb 05                	jmp    801f5f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 25                	push   $0x25
  801f73:	e8 5e fb ff ff       	call   801ad6 <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
  801f7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f7e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f82:	75 07                	jne    801f8b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f84:	b8 01 00 00 00       	mov    $0x1,%eax
  801f89:	eb 05                	jmp    801f90 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 25                	push   $0x25
  801fa4:	e8 2d fb ff ff       	call   801ad6 <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
  801fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801faf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fb3:	75 07                	jne    801fbc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801fba:	eb 05                	jmp    801fc1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 25                	push   $0x25
  801fd5:	e8 fc fa ff ff       	call   801ad6 <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
  801fdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fe0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fe4:	75 07                	jne    801fed <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fe6:	b8 01 00 00 00       	mov    $0x1,%eax
  801feb:	eb 05                	jmp    801ff2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	ff 75 08             	pushl  0x8(%ebp)
  802002:	6a 26                	push   $0x26
  802004:	e8 cd fa ff ff       	call   801ad6 <syscall>
  802009:	83 c4 18             	add    $0x18,%esp
	return ;
  80200c:	90                   	nop
}
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802013:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802016:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802019:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	6a 00                	push   $0x0
  802021:	53                   	push   %ebx
  802022:	51                   	push   %ecx
  802023:	52                   	push   %edx
  802024:	50                   	push   %eax
  802025:	6a 27                	push   $0x27
  802027:	e8 aa fa ff ff       	call   801ad6 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802037:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	52                   	push   %edx
  802044:	50                   	push   %eax
  802045:	6a 28                	push   $0x28
  802047:	e8 8a fa ff ff       	call   801ad6 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802054:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802057:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	6a 00                	push   $0x0
  80205f:	51                   	push   %ecx
  802060:	ff 75 10             	pushl  0x10(%ebp)
  802063:	52                   	push   %edx
  802064:	50                   	push   %eax
  802065:	6a 29                	push   $0x29
  802067:	e8 6a fa ff ff       	call   801ad6 <syscall>
  80206c:	83 c4 18             	add    $0x18,%esp
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	ff 75 10             	pushl  0x10(%ebp)
  80207b:	ff 75 0c             	pushl  0xc(%ebp)
  80207e:	ff 75 08             	pushl  0x8(%ebp)
  802081:	6a 12                	push   $0x12
  802083:	e8 4e fa ff ff       	call   801ad6 <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
	return ;
  80208b:	90                   	nop
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802091:	8b 55 0c             	mov    0xc(%ebp),%edx
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	52                   	push   %edx
  80209e:	50                   	push   %eax
  80209f:	6a 2a                	push   $0x2a
  8020a1:	e8 30 fa ff ff       	call   801ad6 <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
	return;
  8020a9:	90                   	nop
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	50                   	push   %eax
  8020bb:	6a 2b                	push   $0x2b
  8020bd:	e8 14 fa ff ff       	call   801ad6 <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	ff 75 0c             	pushl  0xc(%ebp)
  8020d3:	ff 75 08             	pushl  0x8(%ebp)
  8020d6:	6a 2c                	push   $0x2c
  8020d8:	e8 f9 f9 ff ff       	call   801ad6 <syscall>
  8020dd:	83 c4 18             	add    $0x18,%esp
	return;
  8020e0:	90                   	nop
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	ff 75 0c             	pushl  0xc(%ebp)
  8020ef:	ff 75 08             	pushl  0x8(%ebp)
  8020f2:	6a 2d                	push   $0x2d
  8020f4:	e8 dd f9 ff ff       	call   801ad6 <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
	return;
  8020fc:	90                   	nop
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 2e                	push   $0x2e
  802111:	e8 c0 f9 ff ff       	call   801ad6 <syscall>
  802116:	83 c4 18             	add    $0x18,%esp
  802119:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80211c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	50                   	push   %eax
  802130:	6a 2f                	push   $0x2f
  802132:	e8 9f f9 ff ff       	call   801ad6 <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
	return;
  80213a:	90                   	nop
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  802140:	8b 55 0c             	mov    0xc(%ebp),%edx
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	52                   	push   %edx
  80214d:	50                   	push   %eax
  80214e:	6a 30                	push   $0x30
  802150:	e8 81 f9 ff ff       	call   801ad6 <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
	return;
  802158:	90                   	nop
}
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	50                   	push   %eax
  80216d:	6a 31                	push   $0x31
  80216f:	e8 62 f9 ff ff       	call   801ad6 <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
  802177:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  80217a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	50                   	push   %eax
  80218e:	6a 32                	push   $0x32
  802190:	e8 41 f9 ff ff       	call   801ad6 <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
	return;
  802198:	90                   	nop
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	83 e8 04             	sub    $0x4,%eax
  8021a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8021aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ad:	8b 00                	mov    (%eax),%eax
  8021af:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	83 e8 04             	sub    $0x4,%eax
  8021c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8021c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c6:	8b 00                	mov    (%eax),%eax
  8021c8:	83 e0 01             	and    $0x1,%eax
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	0f 94 c0             	sete   %al
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8021d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8021df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e2:	83 f8 02             	cmp    $0x2,%eax
  8021e5:	74 2b                	je     802212 <alloc_block+0x40>
  8021e7:	83 f8 02             	cmp    $0x2,%eax
  8021ea:	7f 07                	jg     8021f3 <alloc_block+0x21>
  8021ec:	83 f8 01             	cmp    $0x1,%eax
  8021ef:	74 0e                	je     8021ff <alloc_block+0x2d>
  8021f1:	eb 58                	jmp    80224b <alloc_block+0x79>
  8021f3:	83 f8 03             	cmp    $0x3,%eax
  8021f6:	74 2d                	je     802225 <alloc_block+0x53>
  8021f8:	83 f8 04             	cmp    $0x4,%eax
  8021fb:	74 3b                	je     802238 <alloc_block+0x66>
  8021fd:	eb 4c                	jmp    80224b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8021ff:	83 ec 0c             	sub    $0xc,%esp
  802202:	ff 75 08             	pushl  0x8(%ebp)
  802205:	e8 11 03 00 00       	call   80251b <alloc_block_FF>
  80220a:	83 c4 10             	add    $0x10,%esp
  80220d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802210:	eb 4a                	jmp    80225c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802212:	83 ec 0c             	sub    $0xc,%esp
  802215:	ff 75 08             	pushl  0x8(%ebp)
  802218:	e8 c7 19 00 00       	call   803be4 <alloc_block_NF>
  80221d:	83 c4 10             	add    $0x10,%esp
  802220:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802223:	eb 37                	jmp    80225c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802225:	83 ec 0c             	sub    $0xc,%esp
  802228:	ff 75 08             	pushl  0x8(%ebp)
  80222b:	e8 a7 07 00 00       	call   8029d7 <alloc_block_BF>
  802230:	83 c4 10             	add    $0x10,%esp
  802233:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802236:	eb 24                	jmp    80225c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	ff 75 08             	pushl  0x8(%ebp)
  80223e:	e8 84 19 00 00       	call   803bc7 <alloc_block_WF>
  802243:	83 c4 10             	add    $0x10,%esp
  802246:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802249:	eb 11                	jmp    80225c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80224b:	83 ec 0c             	sub    $0xc,%esp
  80224e:	68 08 47 80 00       	push   $0x804708
  802253:	e8 b1 e5 ff ff       	call   800809 <cprintf>
  802258:	83 c4 10             	add    $0x10,%esp
		break;
  80225b:	90                   	nop
	}
	return va;
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	53                   	push   %ebx
  802265:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802268:	83 ec 0c             	sub    $0xc,%esp
  80226b:	68 28 47 80 00       	push   $0x804728
  802270:	e8 94 e5 ff ff       	call   800809 <cprintf>
  802275:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802278:	83 ec 0c             	sub    $0xc,%esp
  80227b:	68 53 47 80 00       	push   $0x804753
  802280:	e8 84 e5 ff ff       	call   800809 <cprintf>
  802285:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80228e:	eb 37                	jmp    8022c7 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802290:	83 ec 0c             	sub    $0xc,%esp
  802293:	ff 75 f4             	pushl  -0xc(%ebp)
  802296:	e8 19 ff ff ff       	call   8021b4 <is_free_block>
  80229b:	83 c4 10             	add    $0x10,%esp
  80229e:	0f be d8             	movsbl %al,%ebx
  8022a1:	83 ec 0c             	sub    $0xc,%esp
  8022a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8022a7:	e8 ef fe ff ff       	call   80219b <get_block_size>
  8022ac:	83 c4 10             	add    $0x10,%esp
  8022af:	83 ec 04             	sub    $0x4,%esp
  8022b2:	53                   	push   %ebx
  8022b3:	50                   	push   %eax
  8022b4:	68 6b 47 80 00       	push   $0x80476b
  8022b9:	e8 4b e5 ff ff       	call   800809 <cprintf>
  8022be:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8022c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022cb:	74 07                	je     8022d4 <print_blocks_list+0x73>
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	8b 00                	mov    (%eax),%eax
  8022d2:	eb 05                	jmp    8022d9 <print_blocks_list+0x78>
  8022d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d9:	89 45 10             	mov    %eax,0x10(%ebp)
  8022dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	75 ad                	jne    802290 <print_blocks_list+0x2f>
  8022e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e7:	75 a7                	jne    802290 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8022e9:	83 ec 0c             	sub    $0xc,%esp
  8022ec:	68 28 47 80 00       	push   $0x804728
  8022f1:	e8 13 e5 ff ff       	call   800809 <cprintf>
  8022f6:	83 c4 10             	add    $0x10,%esp

}
  8022f9:	90                   	nop
  8022fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802305:	8b 45 0c             	mov    0xc(%ebp),%eax
  802308:	83 e0 01             	and    $0x1,%eax
  80230b:	85 c0                	test   %eax,%eax
  80230d:	74 03                	je     802312 <initialize_dynamic_allocator+0x13>
  80230f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802312:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802316:	0f 84 c7 01 00 00    	je     8024e3 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80231c:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802323:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802326:	8b 55 08             	mov    0x8(%ebp),%edx
  802329:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232c:	01 d0                	add    %edx,%eax
  80232e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802333:	0f 87 ad 01 00 00    	ja     8024e6 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	0f 89 a5 01 00 00    	jns    8024e9 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802344:	8b 55 08             	mov    0x8(%ebp),%edx
  802347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234a:	01 d0                	add    %edx,%eax
  80234c:	83 e8 04             	sub    $0x4,%eax
  80234f:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802354:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80235b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802360:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802363:	e9 87 00 00 00       	jmp    8023ef <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236c:	75 14                	jne    802382 <initialize_dynamic_allocator+0x83>
  80236e:	83 ec 04             	sub    $0x4,%esp
  802371:	68 83 47 80 00       	push   $0x804783
  802376:	6a 79                	push   $0x79
  802378:	68 a1 47 80 00       	push   $0x8047a1
  80237d:	e8 ca e1 ff ff       	call   80054c <_panic>
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 00                	mov    (%eax),%eax
  802387:	85 c0                	test   %eax,%eax
  802389:	74 10                	je     80239b <initialize_dynamic_allocator+0x9c>
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	8b 00                	mov    (%eax),%eax
  802390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802393:	8b 52 04             	mov    0x4(%edx),%edx
  802396:	89 50 04             	mov    %edx,0x4(%eax)
  802399:	eb 0b                	jmp    8023a6 <initialize_dynamic_allocator+0xa7>
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	8b 40 04             	mov    0x4(%eax),%eax
  8023a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 40 04             	mov    0x4(%eax),%eax
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	74 0f                	je     8023bf <initialize_dynamic_allocator+0xc0>
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	8b 40 04             	mov    0x4(%eax),%eax
  8023b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b9:	8b 12                	mov    (%edx),%edx
  8023bb:	89 10                	mov    %edx,(%eax)
  8023bd:	eb 0a                	jmp    8023c9 <initialize_dynamic_allocator+0xca>
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 00                	mov    (%eax),%eax
  8023c4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023dc:	a1 38 50 80 00       	mov    0x805038,%eax
  8023e1:	48                   	dec    %eax
  8023e2:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8023e7:	a1 34 50 80 00       	mov    0x805034,%eax
  8023ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f3:	74 07                	je     8023fc <initialize_dynamic_allocator+0xfd>
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 00                	mov    (%eax),%eax
  8023fa:	eb 05                	jmp    802401 <initialize_dynamic_allocator+0x102>
  8023fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802401:	a3 34 50 80 00       	mov    %eax,0x805034
  802406:	a1 34 50 80 00       	mov    0x805034,%eax
  80240b:	85 c0                	test   %eax,%eax
  80240d:	0f 85 55 ff ff ff    	jne    802368 <initialize_dynamic_allocator+0x69>
  802413:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802417:	0f 85 4b ff ff ff    	jne    802368 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802426:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80242c:	a1 44 50 80 00       	mov    0x805044,%eax
  802431:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802436:	a1 40 50 80 00       	mov    0x805040,%eax
  80243b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802441:	8b 45 08             	mov    0x8(%ebp),%eax
  802444:	83 c0 08             	add    $0x8,%eax
  802447:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80244a:	8b 45 08             	mov    0x8(%ebp),%eax
  80244d:	83 c0 04             	add    $0x4,%eax
  802450:	8b 55 0c             	mov    0xc(%ebp),%edx
  802453:	83 ea 08             	sub    $0x8,%edx
  802456:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80245b:	8b 45 08             	mov    0x8(%ebp),%eax
  80245e:	01 d0                	add    %edx,%eax
  802460:	83 e8 08             	sub    $0x8,%eax
  802463:	8b 55 0c             	mov    0xc(%ebp),%edx
  802466:	83 ea 08             	sub    $0x8,%edx
  802469:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80246b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80246e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802474:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802477:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80247e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802482:	75 17                	jne    80249b <initialize_dynamic_allocator+0x19c>
  802484:	83 ec 04             	sub    $0x4,%esp
  802487:	68 bc 47 80 00       	push   $0x8047bc
  80248c:	68 90 00 00 00       	push   $0x90
  802491:	68 a1 47 80 00       	push   $0x8047a1
  802496:	e8 b1 e0 ff ff       	call   80054c <_panic>
  80249b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8024a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a4:	89 10                	mov    %edx,(%eax)
  8024a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a9:	8b 00                	mov    (%eax),%eax
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	74 0d                	je     8024bc <initialize_dynamic_allocator+0x1bd>
  8024af:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024b7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ba:	eb 08                	jmp    8024c4 <initialize_dynamic_allocator+0x1c5>
  8024bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8024c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8024db:	40                   	inc    %eax
  8024dc:	a3 38 50 80 00       	mov    %eax,0x805038
  8024e1:	eb 07                	jmp    8024ea <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8024e3:	90                   	nop
  8024e4:	eb 04                	jmp    8024ea <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8024e6:	90                   	nop
  8024e7:	eb 01                	jmp    8024ea <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8024e9:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8024ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f2:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8024f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8024fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fe:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802500:	8b 45 08             	mov    0x8(%ebp),%eax
  802503:	83 e8 04             	sub    $0x4,%eax
  802506:	8b 00                	mov    (%eax),%eax
  802508:	83 e0 fe             	and    $0xfffffffe,%eax
  80250b:	8d 50 f8             	lea    -0x8(%eax),%edx
  80250e:	8b 45 08             	mov    0x8(%ebp),%eax
  802511:	01 c2                	add    %eax,%edx
  802513:	8b 45 0c             	mov    0xc(%ebp),%eax
  802516:	89 02                	mov    %eax,(%edx)
}
  802518:	90                   	nop
  802519:	5d                   	pop    %ebp
  80251a:	c3                   	ret    

0080251b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	83 e0 01             	and    $0x1,%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	74 03                	je     80252e <alloc_block_FF+0x13>
  80252b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80252e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802532:	77 07                	ja     80253b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802534:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80253b:	a1 24 50 80 00       	mov    0x805024,%eax
  802540:	85 c0                	test   %eax,%eax
  802542:	75 73                	jne    8025b7 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	83 c0 10             	add    $0x10,%eax
  80254a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80254d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802554:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255a:	01 d0                	add    %edx,%eax
  80255c:	48                   	dec    %eax
  80255d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802560:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802563:	ba 00 00 00 00       	mov    $0x0,%edx
  802568:	f7 75 ec             	divl   -0x14(%ebp)
  80256b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80256e:	29 d0                	sub    %edx,%eax
  802570:	c1 e8 0c             	shr    $0xc,%eax
  802573:	83 ec 0c             	sub    $0xc,%esp
  802576:	50                   	push   %eax
  802577:	e8 27 f0 ff ff       	call   8015a3 <sbrk>
  80257c:	83 c4 10             	add    $0x10,%esp
  80257f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802582:	83 ec 0c             	sub    $0xc,%esp
  802585:	6a 00                	push   $0x0
  802587:	e8 17 f0 ff ff       	call   8015a3 <sbrk>
  80258c:	83 c4 10             	add    $0x10,%esp
  80258f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802592:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802595:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802598:	83 ec 08             	sub    $0x8,%esp
  80259b:	50                   	push   %eax
  80259c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80259f:	e8 5b fd ff ff       	call   8022ff <initialize_dynamic_allocator>
  8025a4:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8025a7:	83 ec 0c             	sub    $0xc,%esp
  8025aa:	68 df 47 80 00       	push   $0x8047df
  8025af:	e8 55 e2 ff ff       	call   800809 <cprintf>
  8025b4:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8025b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025bb:	75 0a                	jne    8025c7 <alloc_block_FF+0xac>
	        return NULL;
  8025bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c2:	e9 0e 04 00 00       	jmp    8029d5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8025c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8025ce:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d6:	e9 f3 02 00 00       	jmp    8028ce <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8025e1:	83 ec 0c             	sub    $0xc,%esp
  8025e4:	ff 75 bc             	pushl  -0x44(%ebp)
  8025e7:	e8 af fb ff ff       	call   80219b <get_block_size>
  8025ec:	83 c4 10             	add    $0x10,%esp
  8025ef:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8025f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f5:	83 c0 08             	add    $0x8,%eax
  8025f8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8025fb:	0f 87 c5 02 00 00    	ja     8028c6 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	83 c0 18             	add    $0x18,%eax
  802607:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80260a:	0f 87 19 02 00 00    	ja     802829 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802610:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802613:	2b 45 08             	sub    0x8(%ebp),%eax
  802616:	83 e8 08             	sub    $0x8,%eax
  802619:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80261c:	8b 45 08             	mov    0x8(%ebp),%eax
  80261f:	8d 50 08             	lea    0x8(%eax),%edx
  802622:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802625:	01 d0                	add    %edx,%eax
  802627:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80262a:	8b 45 08             	mov    0x8(%ebp),%eax
  80262d:	83 c0 08             	add    $0x8,%eax
  802630:	83 ec 04             	sub    $0x4,%esp
  802633:	6a 01                	push   $0x1
  802635:	50                   	push   %eax
  802636:	ff 75 bc             	pushl  -0x44(%ebp)
  802639:	e8 ae fe ff ff       	call   8024ec <set_block_data>
  80263e:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 40 04             	mov    0x4(%eax),%eax
  802647:	85 c0                	test   %eax,%eax
  802649:	75 68                	jne    8026b3 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80264b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80264f:	75 17                	jne    802668 <alloc_block_FF+0x14d>
  802651:	83 ec 04             	sub    $0x4,%esp
  802654:	68 bc 47 80 00       	push   $0x8047bc
  802659:	68 d7 00 00 00       	push   $0xd7
  80265e:	68 a1 47 80 00       	push   $0x8047a1
  802663:	e8 e4 de ff ff       	call   80054c <_panic>
  802668:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80266e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802671:	89 10                	mov    %edx,(%eax)
  802673:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802676:	8b 00                	mov    (%eax),%eax
  802678:	85 c0                	test   %eax,%eax
  80267a:	74 0d                	je     802689 <alloc_block_FF+0x16e>
  80267c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802681:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802684:	89 50 04             	mov    %edx,0x4(%eax)
  802687:	eb 08                	jmp    802691 <alloc_block_FF+0x176>
  802689:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80268c:	a3 30 50 80 00       	mov    %eax,0x805030
  802691:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802694:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802699:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80269c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a3:	a1 38 50 80 00       	mov    0x805038,%eax
  8026a8:	40                   	inc    %eax
  8026a9:	a3 38 50 80 00       	mov    %eax,0x805038
  8026ae:	e9 dc 00 00 00       	jmp    80278f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 00                	mov    (%eax),%eax
  8026b8:	85 c0                	test   %eax,%eax
  8026ba:	75 65                	jne    802721 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026bc:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8026c0:	75 17                	jne    8026d9 <alloc_block_FF+0x1be>
  8026c2:	83 ec 04             	sub    $0x4,%esp
  8026c5:	68 f0 47 80 00       	push   $0x8047f0
  8026ca:	68 db 00 00 00       	push   $0xdb
  8026cf:	68 a1 47 80 00       	push   $0x8047a1
  8026d4:	e8 73 de ff ff       	call   80054c <_panic>
  8026d9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8026df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e2:	89 50 04             	mov    %edx,0x4(%eax)
  8026e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026e8:	8b 40 04             	mov    0x4(%eax),%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	74 0c                	je     8026fb <alloc_block_FF+0x1e0>
  8026ef:	a1 30 50 80 00       	mov    0x805030,%eax
  8026f4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8026f7:	89 10                	mov    %edx,(%eax)
  8026f9:	eb 08                	jmp    802703 <alloc_block_FF+0x1e8>
  8026fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026fe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802703:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802706:	a3 30 50 80 00       	mov    %eax,0x805030
  80270b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80270e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802714:	a1 38 50 80 00       	mov    0x805038,%eax
  802719:	40                   	inc    %eax
  80271a:	a3 38 50 80 00       	mov    %eax,0x805038
  80271f:	eb 6e                	jmp    80278f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802721:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802725:	74 06                	je     80272d <alloc_block_FF+0x212>
  802727:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80272b:	75 17                	jne    802744 <alloc_block_FF+0x229>
  80272d:	83 ec 04             	sub    $0x4,%esp
  802730:	68 14 48 80 00       	push   $0x804814
  802735:	68 df 00 00 00       	push   $0xdf
  80273a:	68 a1 47 80 00       	push   $0x8047a1
  80273f:	e8 08 de ff ff       	call   80054c <_panic>
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	8b 10                	mov    (%eax),%edx
  802749:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80274c:	89 10                	mov    %edx,(%eax)
  80274e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	74 0b                	je     802762 <alloc_block_FF+0x247>
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 00                	mov    (%eax),%eax
  80275c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80275f:	89 50 04             	mov    %edx,0x4(%eax)
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802768:	89 10                	mov    %edx,(%eax)
  80276a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80276d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802770:	89 50 04             	mov    %edx,0x4(%eax)
  802773:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802776:	8b 00                	mov    (%eax),%eax
  802778:	85 c0                	test   %eax,%eax
  80277a:	75 08                	jne    802784 <alloc_block_FF+0x269>
  80277c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80277f:	a3 30 50 80 00       	mov    %eax,0x805030
  802784:	a1 38 50 80 00       	mov    0x805038,%eax
  802789:	40                   	inc    %eax
  80278a:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80278f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802793:	75 17                	jne    8027ac <alloc_block_FF+0x291>
  802795:	83 ec 04             	sub    $0x4,%esp
  802798:	68 83 47 80 00       	push   $0x804783
  80279d:	68 e1 00 00 00       	push   $0xe1
  8027a2:	68 a1 47 80 00       	push   $0x8047a1
  8027a7:	e8 a0 dd ff ff       	call   80054c <_panic>
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 00                	mov    (%eax),%eax
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	74 10                	je     8027c5 <alloc_block_FF+0x2aa>
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 00                	mov    (%eax),%eax
  8027ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bd:	8b 52 04             	mov    0x4(%edx),%edx
  8027c0:	89 50 04             	mov    %edx,0x4(%eax)
  8027c3:	eb 0b                	jmp    8027d0 <alloc_block_FF+0x2b5>
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 40 04             	mov    0x4(%eax),%eax
  8027cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 40 04             	mov    0x4(%eax),%eax
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	74 0f                	je     8027e9 <alloc_block_FF+0x2ce>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 40 04             	mov    0x4(%eax),%eax
  8027e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e3:	8b 12                	mov    (%edx),%edx
  8027e5:	89 10                	mov    %edx,(%eax)
  8027e7:	eb 0a                	jmp    8027f3 <alloc_block_FF+0x2d8>
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
				set_block_data(new_block_va, remaining_size, 0);
  802811:	83 ec 04             	sub    $0x4,%esp
  802814:	6a 00                	push   $0x0
  802816:	ff 75 b4             	pushl  -0x4c(%ebp)
  802819:	ff 75 b0             	pushl  -0x50(%ebp)
  80281c:	e8 cb fc ff ff       	call   8024ec <set_block_data>
  802821:	83 c4 10             	add    $0x10,%esp
  802824:	e9 95 00 00 00       	jmp    8028be <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802829:	83 ec 04             	sub    $0x4,%esp
  80282c:	6a 01                	push   $0x1
  80282e:	ff 75 b8             	pushl  -0x48(%ebp)
  802831:	ff 75 bc             	pushl  -0x44(%ebp)
  802834:	e8 b3 fc ff ff       	call   8024ec <set_block_data>
  802839:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80283c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802840:	75 17                	jne    802859 <alloc_block_FF+0x33e>
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	68 83 47 80 00       	push   $0x804783
  80284a:	68 e8 00 00 00       	push   $0xe8
  80284f:	68 a1 47 80 00       	push   $0x8047a1
  802854:	e8 f3 dc ff ff       	call   80054c <_panic>
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 00                	mov    (%eax),%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	74 10                	je     802872 <alloc_block_FF+0x357>
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 00                	mov    (%eax),%eax
  802867:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286a:	8b 52 04             	mov    0x4(%edx),%edx
  80286d:	89 50 04             	mov    %edx,0x4(%eax)
  802870:	eb 0b                	jmp    80287d <alloc_block_FF+0x362>
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 40 04             	mov    0x4(%eax),%eax
  802878:	a3 30 50 80 00       	mov    %eax,0x805030
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 40 04             	mov    0x4(%eax),%eax
  802883:	85 c0                	test   %eax,%eax
  802885:	74 0f                	je     802896 <alloc_block_FF+0x37b>
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 40 04             	mov    0x4(%eax),%eax
  80288d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802890:	8b 12                	mov    (%edx),%edx
  802892:	89 10                	mov    %edx,(%eax)
  802894:	eb 0a                	jmp    8028a0 <alloc_block_FF+0x385>
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 00                	mov    (%eax),%eax
  80289b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8028b8:	48                   	dec    %eax
  8028b9:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8028be:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8028c1:	e9 0f 01 00 00       	jmp    8029d5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8028c6:	a1 34 50 80 00       	mov    0x805034,%eax
  8028cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d2:	74 07                	je     8028db <alloc_block_FF+0x3c0>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	eb 05                	jmp    8028e0 <alloc_block_FF+0x3c5>
  8028db:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e0:	a3 34 50 80 00       	mov    %eax,0x805034
  8028e5:	a1 34 50 80 00       	mov    0x805034,%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	0f 85 e9 fc ff ff    	jne    8025db <alloc_block_FF+0xc0>
  8028f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f6:	0f 85 df fc ff ff    	jne    8025db <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	83 c0 08             	add    $0x8,%eax
  802902:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802905:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80290c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80290f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802912:	01 d0                	add    %edx,%eax
  802914:	48                   	dec    %eax
  802915:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802918:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80291b:	ba 00 00 00 00       	mov    $0x0,%edx
  802920:	f7 75 d8             	divl   -0x28(%ebp)
  802923:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802926:	29 d0                	sub    %edx,%eax
  802928:	c1 e8 0c             	shr    $0xc,%eax
  80292b:	83 ec 0c             	sub    $0xc,%esp
  80292e:	50                   	push   %eax
  80292f:	e8 6f ec ff ff       	call   8015a3 <sbrk>
  802934:	83 c4 10             	add    $0x10,%esp
  802937:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80293a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80293e:	75 0a                	jne    80294a <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802940:	b8 00 00 00 00       	mov    $0x0,%eax
  802945:	e9 8b 00 00 00       	jmp    8029d5 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80294a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802951:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802954:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802957:	01 d0                	add    %edx,%eax
  802959:	48                   	dec    %eax
  80295a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80295d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802960:	ba 00 00 00 00       	mov    $0x0,%edx
  802965:	f7 75 cc             	divl   -0x34(%ebp)
  802968:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80296b:	29 d0                	sub    %edx,%eax
  80296d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802970:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802973:	01 d0                	add    %edx,%eax
  802975:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80297a:	a1 40 50 80 00       	mov    0x805040,%eax
  80297f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802985:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80298c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80298f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802992:	01 d0                	add    %edx,%eax
  802994:	48                   	dec    %eax
  802995:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802998:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80299b:	ba 00 00 00 00       	mov    $0x0,%edx
  8029a0:	f7 75 c4             	divl   -0x3c(%ebp)
  8029a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029a6:	29 d0                	sub    %edx,%eax
  8029a8:	83 ec 04             	sub    $0x4,%esp
  8029ab:	6a 01                	push   $0x1
  8029ad:	50                   	push   %eax
  8029ae:	ff 75 d0             	pushl  -0x30(%ebp)
  8029b1:	e8 36 fb ff ff       	call   8024ec <set_block_data>
  8029b6:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8029b9:	83 ec 0c             	sub    $0xc,%esp
  8029bc:	ff 75 d0             	pushl  -0x30(%ebp)
  8029bf:	e8 f8 09 00 00       	call   8033bc <free_block>
  8029c4:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8029c7:	83 ec 0c             	sub    $0xc,%esp
  8029ca:	ff 75 08             	pushl  0x8(%ebp)
  8029cd:	e8 49 fb ff ff       	call   80251b <alloc_block_FF>
  8029d2:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8029d5:	c9                   	leave  
  8029d6:	c3                   	ret    

008029d7 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8029d7:	55                   	push   %ebp
  8029d8:	89 e5                	mov    %esp,%ebp
  8029da:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	83 e0 01             	and    $0x1,%eax
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	74 03                	je     8029ea <alloc_block_BF+0x13>
  8029e7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8029ea:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8029ee:	77 07                	ja     8029f7 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8029f0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8029f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	75 73                	jne    802a73 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	83 c0 10             	add    $0x10,%eax
  802a06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a09:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802a10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a16:	01 d0                	add    %edx,%eax
  802a18:	48                   	dec    %eax
  802a19:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802a1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a24:	f7 75 e0             	divl   -0x20(%ebp)
  802a27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a2a:	29 d0                	sub    %edx,%eax
  802a2c:	c1 e8 0c             	shr    $0xc,%eax
  802a2f:	83 ec 0c             	sub    $0xc,%esp
  802a32:	50                   	push   %eax
  802a33:	e8 6b eb ff ff       	call   8015a3 <sbrk>
  802a38:	83 c4 10             	add    $0x10,%esp
  802a3b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a3e:	83 ec 0c             	sub    $0xc,%esp
  802a41:	6a 00                	push   $0x0
  802a43:	e8 5b eb ff ff       	call   8015a3 <sbrk>
  802a48:	83 c4 10             	add    $0x10,%esp
  802a4b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802a51:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802a54:	83 ec 08             	sub    $0x8,%esp
  802a57:	50                   	push   %eax
  802a58:	ff 75 d8             	pushl  -0x28(%ebp)
  802a5b:	e8 9f f8 ff ff       	call   8022ff <initialize_dynamic_allocator>
  802a60:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802a63:	83 ec 0c             	sub    $0xc,%esp
  802a66:	68 df 47 80 00       	push   $0x8047df
  802a6b:	e8 99 dd ff ff       	call   800809 <cprintf>
  802a70:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802a73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802a7a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802a81:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802a88:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802a8f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a97:	e9 1d 01 00 00       	jmp    802bb9 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802aa2:	83 ec 0c             	sub    $0xc,%esp
  802aa5:	ff 75 a8             	pushl  -0x58(%ebp)
  802aa8:	e8 ee f6 ff ff       	call   80219b <get_block_size>
  802aad:	83 c4 10             	add    $0x10,%esp
  802ab0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	83 c0 08             	add    $0x8,%eax
  802ab9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802abc:	0f 87 ef 00 00 00    	ja     802bb1 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	83 c0 18             	add    $0x18,%eax
  802ac8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802acb:	77 1d                	ja     802aea <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ad3:	0f 86 d8 00 00 00    	jbe    802bb1 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802ad9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802adf:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ae2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ae5:	e9 c7 00 00 00       	jmp    802bb1 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	83 c0 08             	add    $0x8,%eax
  802af0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802af3:	0f 85 9d 00 00 00    	jne    802b96 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802af9:	83 ec 04             	sub    $0x4,%esp
  802afc:	6a 01                	push   $0x1
  802afe:	ff 75 a4             	pushl  -0x5c(%ebp)
  802b01:	ff 75 a8             	pushl  -0x58(%ebp)
  802b04:	e8 e3 f9 ff ff       	call   8024ec <set_block_data>
  802b09:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802b0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b10:	75 17                	jne    802b29 <alloc_block_BF+0x152>
  802b12:	83 ec 04             	sub    $0x4,%esp
  802b15:	68 83 47 80 00       	push   $0x804783
  802b1a:	68 2c 01 00 00       	push   $0x12c
  802b1f:	68 a1 47 80 00       	push   $0x8047a1
  802b24:	e8 23 da ff ff       	call   80054c <_panic>
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	8b 00                	mov    (%eax),%eax
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	74 10                	je     802b42 <alloc_block_BF+0x16b>
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	8b 00                	mov    (%eax),%eax
  802b37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3a:	8b 52 04             	mov    0x4(%edx),%edx
  802b3d:	89 50 04             	mov    %edx,0x4(%eax)
  802b40:	eb 0b                	jmp    802b4d <alloc_block_BF+0x176>
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 40 04             	mov    0x4(%eax),%eax
  802b48:	a3 30 50 80 00       	mov    %eax,0x805030
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 40 04             	mov    0x4(%eax),%eax
  802b53:	85 c0                	test   %eax,%eax
  802b55:	74 0f                	je     802b66 <alloc_block_BF+0x18f>
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	8b 40 04             	mov    0x4(%eax),%eax
  802b5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b60:	8b 12                	mov    (%edx),%edx
  802b62:	89 10                	mov    %edx,(%eax)
  802b64:	eb 0a                	jmp    802b70 <alloc_block_BF+0x199>
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 00                	mov    (%eax),%eax
  802b6b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b83:	a1 38 50 80 00       	mov    0x805038,%eax
  802b88:	48                   	dec    %eax
  802b89:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802b8e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802b91:	e9 01 04 00 00       	jmp    802f97 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b99:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802b9c:	76 13                	jbe    802bb1 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802b9e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802ba5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ba8:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802bab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802bae:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802bb1:	a1 34 50 80 00       	mov    0x805034,%eax
  802bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbd:	74 07                	je     802bc6 <alloc_block_BF+0x1ef>
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 00                	mov    (%eax),%eax
  802bc4:	eb 05                	jmp    802bcb <alloc_block_BF+0x1f4>
  802bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcb:	a3 34 50 80 00       	mov    %eax,0x805034
  802bd0:	a1 34 50 80 00       	mov    0x805034,%eax
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	0f 85 bf fe ff ff    	jne    802a9c <alloc_block_BF+0xc5>
  802bdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be1:	0f 85 b5 fe ff ff    	jne    802a9c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802be7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802beb:	0f 84 26 02 00 00    	je     802e17 <alloc_block_BF+0x440>
  802bf1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bf5:	0f 85 1c 02 00 00    	jne    802e17 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfe:	2b 45 08             	sub    0x8(%ebp),%eax
  802c01:	83 e8 08             	sub    $0x8,%eax
  802c04:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	8d 50 08             	lea    0x8(%eax),%edx
  802c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c10:	01 d0                	add    %edx,%eax
  802c12:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	83 c0 08             	add    $0x8,%eax
  802c1b:	83 ec 04             	sub    $0x4,%esp
  802c1e:	6a 01                	push   $0x1
  802c20:	50                   	push   %eax
  802c21:	ff 75 f0             	pushl  -0x10(%ebp)
  802c24:	e8 c3 f8 ff ff       	call   8024ec <set_block_data>
  802c29:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	8b 40 04             	mov    0x4(%eax),%eax
  802c32:	85 c0                	test   %eax,%eax
  802c34:	75 68                	jne    802c9e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802c36:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c3a:	75 17                	jne    802c53 <alloc_block_BF+0x27c>
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	68 bc 47 80 00       	push   $0x8047bc
  802c44:	68 45 01 00 00       	push   $0x145
  802c49:	68 a1 47 80 00       	push   $0x8047a1
  802c4e:	e8 f9 d8 ff ff       	call   80054c <_panic>
  802c53:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802c59:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c5c:	89 10                	mov    %edx,(%eax)
  802c5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c61:	8b 00                	mov    (%eax),%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	74 0d                	je     802c74 <alloc_block_BF+0x29d>
  802c67:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802c6c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c6f:	89 50 04             	mov    %edx,0x4(%eax)
  802c72:	eb 08                	jmp    802c7c <alloc_block_BF+0x2a5>
  802c74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c77:	a3 30 50 80 00       	mov    %eax,0x805030
  802c7c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c7f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c84:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8e:	a1 38 50 80 00       	mov    0x805038,%eax
  802c93:	40                   	inc    %eax
  802c94:	a3 38 50 80 00       	mov    %eax,0x805038
  802c99:	e9 dc 00 00 00       	jmp    802d7a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca1:	8b 00                	mov    (%eax),%eax
  802ca3:	85 c0                	test   %eax,%eax
  802ca5:	75 65                	jne    802d0c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ca7:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802cab:	75 17                	jne    802cc4 <alloc_block_BF+0x2ed>
  802cad:	83 ec 04             	sub    $0x4,%esp
  802cb0:	68 f0 47 80 00       	push   $0x8047f0
  802cb5:	68 4a 01 00 00       	push   $0x14a
  802cba:	68 a1 47 80 00       	push   $0x8047a1
  802cbf:	e8 88 d8 ff ff       	call   80054c <_panic>
  802cc4:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802cca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ccd:	89 50 04             	mov    %edx,0x4(%eax)
  802cd0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cd3:	8b 40 04             	mov    0x4(%eax),%eax
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	74 0c                	je     802ce6 <alloc_block_BF+0x30f>
  802cda:	a1 30 50 80 00       	mov    0x805030,%eax
  802cdf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ce2:	89 10                	mov    %edx,(%eax)
  802ce4:	eb 08                	jmp    802cee <alloc_block_BF+0x317>
  802ce6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ce9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cf1:	a3 30 50 80 00       	mov    %eax,0x805030
  802cf6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802cf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cff:	a1 38 50 80 00       	mov    0x805038,%eax
  802d04:	40                   	inc    %eax
  802d05:	a3 38 50 80 00       	mov    %eax,0x805038
  802d0a:	eb 6e                	jmp    802d7a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802d0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d10:	74 06                	je     802d18 <alloc_block_BF+0x341>
  802d12:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802d16:	75 17                	jne    802d2f <alloc_block_BF+0x358>
  802d18:	83 ec 04             	sub    $0x4,%esp
  802d1b:	68 14 48 80 00       	push   $0x804814
  802d20:	68 4f 01 00 00       	push   $0x14f
  802d25:	68 a1 47 80 00       	push   $0x8047a1
  802d2a:	e8 1d d8 ff ff       	call   80054c <_panic>
  802d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d32:	8b 10                	mov    (%eax),%edx
  802d34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 0b                	je     802d4d <alloc_block_BF+0x376>
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d4a:	89 50 04             	mov    %edx,0x4(%eax)
  802d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d50:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5b:	89 50 04             	mov    %edx,0x4(%eax)
  802d5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	75 08                	jne    802d6f <alloc_block_BF+0x398>
  802d67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d6a:	a3 30 50 80 00       	mov    %eax,0x805030
  802d6f:	a1 38 50 80 00       	mov    0x805038,%eax
  802d74:	40                   	inc    %eax
  802d75:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802d7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d7e:	75 17                	jne    802d97 <alloc_block_BF+0x3c0>
  802d80:	83 ec 04             	sub    $0x4,%esp
  802d83:	68 83 47 80 00       	push   $0x804783
  802d88:	68 51 01 00 00       	push   $0x151
  802d8d:	68 a1 47 80 00       	push   $0x8047a1
  802d92:	e8 b5 d7 ff ff       	call   80054c <_panic>
  802d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	74 10                	je     802db0 <alloc_block_BF+0x3d9>
  802da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da3:	8b 00                	mov    (%eax),%eax
  802da5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da8:	8b 52 04             	mov    0x4(%edx),%edx
  802dab:	89 50 04             	mov    %edx,0x4(%eax)
  802dae:	eb 0b                	jmp    802dbb <alloc_block_BF+0x3e4>
  802db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db3:	8b 40 04             	mov    0x4(%eax),%eax
  802db6:	a3 30 50 80 00       	mov    %eax,0x805030
  802dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbe:	8b 40 04             	mov    0x4(%eax),%eax
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	74 0f                	je     802dd4 <alloc_block_BF+0x3fd>
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	8b 40 04             	mov    0x4(%eax),%eax
  802dcb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dce:	8b 12                	mov    (%edx),%edx
  802dd0:	89 10                	mov    %edx,(%eax)
  802dd2:	eb 0a                	jmp    802dde <alloc_block_BF+0x407>
  802dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df1:	a1 38 50 80 00       	mov    0x805038,%eax
  802df6:	48                   	dec    %eax
  802df7:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802dfc:	83 ec 04             	sub    $0x4,%esp
  802dff:	6a 00                	push   $0x0
  802e01:	ff 75 d0             	pushl  -0x30(%ebp)
  802e04:	ff 75 cc             	pushl  -0x34(%ebp)
  802e07:	e8 e0 f6 ff ff       	call   8024ec <set_block_data>
  802e0c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e12:	e9 80 01 00 00       	jmp    802f97 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802e17:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802e1b:	0f 85 9d 00 00 00    	jne    802ebe <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802e21:	83 ec 04             	sub    $0x4,%esp
  802e24:	6a 01                	push   $0x1
  802e26:	ff 75 ec             	pushl  -0x14(%ebp)
  802e29:	ff 75 f0             	pushl  -0x10(%ebp)
  802e2c:	e8 bb f6 ff ff       	call   8024ec <set_block_data>
  802e31:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802e34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e38:	75 17                	jne    802e51 <alloc_block_BF+0x47a>
  802e3a:	83 ec 04             	sub    $0x4,%esp
  802e3d:	68 83 47 80 00       	push   $0x804783
  802e42:	68 58 01 00 00       	push   $0x158
  802e47:	68 a1 47 80 00       	push   $0x8047a1
  802e4c:	e8 fb d6 ff ff       	call   80054c <_panic>
  802e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e54:	8b 00                	mov    (%eax),%eax
  802e56:	85 c0                	test   %eax,%eax
  802e58:	74 10                	je     802e6a <alloc_block_BF+0x493>
  802e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5d:	8b 00                	mov    (%eax),%eax
  802e5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e62:	8b 52 04             	mov    0x4(%edx),%edx
  802e65:	89 50 04             	mov    %edx,0x4(%eax)
  802e68:	eb 0b                	jmp    802e75 <alloc_block_BF+0x49e>
  802e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6d:	8b 40 04             	mov    0x4(%eax),%eax
  802e70:	a3 30 50 80 00       	mov    %eax,0x805030
  802e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e78:	8b 40 04             	mov    0x4(%eax),%eax
  802e7b:	85 c0                	test   %eax,%eax
  802e7d:	74 0f                	je     802e8e <alloc_block_BF+0x4b7>
  802e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e82:	8b 40 04             	mov    0x4(%eax),%eax
  802e85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e88:	8b 12                	mov    (%edx),%edx
  802e8a:	89 10                	mov    %edx,(%eax)
  802e8c:	eb 0a                	jmp    802e98 <alloc_block_BF+0x4c1>
  802e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e91:	8b 00                	mov    (%eax),%eax
  802e93:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eab:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb0:	48                   	dec    %eax
  802eb1:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb9:	e9 d9 00 00 00       	jmp    802f97 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	83 c0 08             	add    $0x8,%eax
  802ec4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ec7:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ece:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ed1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ed4:	01 d0                	add    %edx,%eax
  802ed6:	48                   	dec    %eax
  802ed7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802eda:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802edd:	ba 00 00 00 00       	mov    $0x0,%edx
  802ee2:	f7 75 c4             	divl   -0x3c(%ebp)
  802ee5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ee8:	29 d0                	sub    %edx,%eax
  802eea:	c1 e8 0c             	shr    $0xc,%eax
  802eed:	83 ec 0c             	sub    $0xc,%esp
  802ef0:	50                   	push   %eax
  802ef1:	e8 ad e6 ff ff       	call   8015a3 <sbrk>
  802ef6:	83 c4 10             	add    $0x10,%esp
  802ef9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802efc:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802f00:	75 0a                	jne    802f0c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802f02:	b8 00 00 00 00       	mov    $0x0,%eax
  802f07:	e9 8b 00 00 00       	jmp    802f97 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802f0c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802f13:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f16:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802f19:	01 d0                	add    %edx,%eax
  802f1b:	48                   	dec    %eax
  802f1c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802f1f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f22:	ba 00 00 00 00       	mov    $0x0,%edx
  802f27:	f7 75 b8             	divl   -0x48(%ebp)
  802f2a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802f2d:	29 d0                	sub    %edx,%eax
  802f2f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802f32:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802f35:	01 d0                	add    %edx,%eax
  802f37:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802f3c:	a1 40 50 80 00       	mov    0x805040,%eax
  802f41:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802f47:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802f4e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802f51:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802f54:	01 d0                	add    %edx,%eax
  802f56:	48                   	dec    %eax
  802f57:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802f5a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f5d:	ba 00 00 00 00       	mov    $0x0,%edx
  802f62:	f7 75 b0             	divl   -0x50(%ebp)
  802f65:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802f68:	29 d0                	sub    %edx,%eax
  802f6a:	83 ec 04             	sub    $0x4,%esp
  802f6d:	6a 01                	push   $0x1
  802f6f:	50                   	push   %eax
  802f70:	ff 75 bc             	pushl  -0x44(%ebp)
  802f73:	e8 74 f5 ff ff       	call   8024ec <set_block_data>
  802f78:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802f7b:	83 ec 0c             	sub    $0xc,%esp
  802f7e:	ff 75 bc             	pushl  -0x44(%ebp)
  802f81:	e8 36 04 00 00       	call   8033bc <free_block>
  802f86:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802f89:	83 ec 0c             	sub    $0xc,%esp
  802f8c:	ff 75 08             	pushl  0x8(%ebp)
  802f8f:	e8 43 fa ff ff       	call   8029d7 <alloc_block_BF>
  802f94:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802f97:	c9                   	leave  
  802f98:	c3                   	ret    

00802f99 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802f99:	55                   	push   %ebp
  802f9a:	89 e5                	mov    %esp,%ebp
  802f9c:	53                   	push   %ebx
  802f9d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802fa0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802fa7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802fae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb2:	74 1e                	je     802fd2 <merging+0x39>
  802fb4:	ff 75 08             	pushl  0x8(%ebp)
  802fb7:	e8 df f1 ff ff       	call   80219b <get_block_size>
  802fbc:	83 c4 04             	add    $0x4,%esp
  802fbf:	89 c2                	mov    %eax,%edx
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	01 d0                	add    %edx,%eax
  802fc6:	3b 45 10             	cmp    0x10(%ebp),%eax
  802fc9:	75 07                	jne    802fd2 <merging+0x39>
		prev_is_free = 1;
  802fcb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802fd2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fd6:	74 1e                	je     802ff6 <merging+0x5d>
  802fd8:	ff 75 10             	pushl  0x10(%ebp)
  802fdb:	e8 bb f1 ff ff       	call   80219b <get_block_size>
  802fe0:	83 c4 04             	add    $0x4,%esp
  802fe3:	89 c2                	mov    %eax,%edx
  802fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  802fe8:	01 d0                	add    %edx,%eax
  802fea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802fed:	75 07                	jne    802ff6 <merging+0x5d>
		next_is_free = 1;
  802fef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ff6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ffa:	0f 84 cc 00 00 00    	je     8030cc <merging+0x133>
  803000:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803004:	0f 84 c2 00 00 00    	je     8030cc <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80300a:	ff 75 08             	pushl  0x8(%ebp)
  80300d:	e8 89 f1 ff ff       	call   80219b <get_block_size>
  803012:	83 c4 04             	add    $0x4,%esp
  803015:	89 c3                	mov    %eax,%ebx
  803017:	ff 75 10             	pushl  0x10(%ebp)
  80301a:	e8 7c f1 ff ff       	call   80219b <get_block_size>
  80301f:	83 c4 04             	add    $0x4,%esp
  803022:	01 c3                	add    %eax,%ebx
  803024:	ff 75 0c             	pushl  0xc(%ebp)
  803027:	e8 6f f1 ff ff       	call   80219b <get_block_size>
  80302c:	83 c4 04             	add    $0x4,%esp
  80302f:	01 d8                	add    %ebx,%eax
  803031:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803034:	6a 00                	push   $0x0
  803036:	ff 75 ec             	pushl  -0x14(%ebp)
  803039:	ff 75 08             	pushl  0x8(%ebp)
  80303c:	e8 ab f4 ff ff       	call   8024ec <set_block_data>
  803041:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803044:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803048:	75 17                	jne    803061 <merging+0xc8>
  80304a:	83 ec 04             	sub    $0x4,%esp
  80304d:	68 83 47 80 00       	push   $0x804783
  803052:	68 7d 01 00 00       	push   $0x17d
  803057:	68 a1 47 80 00       	push   $0x8047a1
  80305c:	e8 eb d4 ff ff       	call   80054c <_panic>
  803061:	8b 45 0c             	mov    0xc(%ebp),%eax
  803064:	8b 00                	mov    (%eax),%eax
  803066:	85 c0                	test   %eax,%eax
  803068:	74 10                	je     80307a <merging+0xe1>
  80306a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803072:	8b 52 04             	mov    0x4(%edx),%edx
  803075:	89 50 04             	mov    %edx,0x4(%eax)
  803078:	eb 0b                	jmp    803085 <merging+0xec>
  80307a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80307d:	8b 40 04             	mov    0x4(%eax),%eax
  803080:	a3 30 50 80 00       	mov    %eax,0x805030
  803085:	8b 45 0c             	mov    0xc(%ebp),%eax
  803088:	8b 40 04             	mov    0x4(%eax),%eax
  80308b:	85 c0                	test   %eax,%eax
  80308d:	74 0f                	je     80309e <merging+0x105>
  80308f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803092:	8b 40 04             	mov    0x4(%eax),%eax
  803095:	8b 55 0c             	mov    0xc(%ebp),%edx
  803098:	8b 12                	mov    (%edx),%edx
  80309a:	89 10                	mov    %edx,(%eax)
  80309c:	eb 0a                	jmp    8030a8 <merging+0x10f>
  80309e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a1:	8b 00                	mov    (%eax),%eax
  8030a3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8030c0:	48                   	dec    %eax
  8030c1:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8030c6:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8030c7:	e9 ea 02 00 00       	jmp    8033b6 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8030cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d0:	74 3b                	je     80310d <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8030d2:	83 ec 0c             	sub    $0xc,%esp
  8030d5:	ff 75 08             	pushl  0x8(%ebp)
  8030d8:	e8 be f0 ff ff       	call   80219b <get_block_size>
  8030dd:	83 c4 10             	add    $0x10,%esp
  8030e0:	89 c3                	mov    %eax,%ebx
  8030e2:	83 ec 0c             	sub    $0xc,%esp
  8030e5:	ff 75 10             	pushl  0x10(%ebp)
  8030e8:	e8 ae f0 ff ff       	call   80219b <get_block_size>
  8030ed:	83 c4 10             	add    $0x10,%esp
  8030f0:	01 d8                	add    %ebx,%eax
  8030f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8030f5:	83 ec 04             	sub    $0x4,%esp
  8030f8:	6a 00                	push   $0x0
  8030fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8030fd:	ff 75 08             	pushl  0x8(%ebp)
  803100:	e8 e7 f3 ff ff       	call   8024ec <set_block_data>
  803105:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803108:	e9 a9 02 00 00       	jmp    8033b6 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80310d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803111:	0f 84 2d 01 00 00    	je     803244 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803117:	83 ec 0c             	sub    $0xc,%esp
  80311a:	ff 75 10             	pushl  0x10(%ebp)
  80311d:	e8 79 f0 ff ff       	call   80219b <get_block_size>
  803122:	83 c4 10             	add    $0x10,%esp
  803125:	89 c3                	mov    %eax,%ebx
  803127:	83 ec 0c             	sub    $0xc,%esp
  80312a:	ff 75 0c             	pushl  0xc(%ebp)
  80312d:	e8 69 f0 ff ff       	call   80219b <get_block_size>
  803132:	83 c4 10             	add    $0x10,%esp
  803135:	01 d8                	add    %ebx,%eax
  803137:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80313a:	83 ec 04             	sub    $0x4,%esp
  80313d:	6a 00                	push   $0x0
  80313f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803142:	ff 75 10             	pushl  0x10(%ebp)
  803145:	e8 a2 f3 ff ff       	call   8024ec <set_block_data>
  80314a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80314d:	8b 45 10             	mov    0x10(%ebp),%eax
  803150:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803153:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803157:	74 06                	je     80315f <merging+0x1c6>
  803159:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80315d:	75 17                	jne    803176 <merging+0x1dd>
  80315f:	83 ec 04             	sub    $0x4,%esp
  803162:	68 48 48 80 00       	push   $0x804848
  803167:	68 8d 01 00 00       	push   $0x18d
  80316c:	68 a1 47 80 00       	push   $0x8047a1
  803171:	e8 d6 d3 ff ff       	call   80054c <_panic>
  803176:	8b 45 0c             	mov    0xc(%ebp),%eax
  803179:	8b 50 04             	mov    0x4(%eax),%edx
  80317c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80317f:	89 50 04             	mov    %edx,0x4(%eax)
  803182:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803185:	8b 55 0c             	mov    0xc(%ebp),%edx
  803188:	89 10                	mov    %edx,(%eax)
  80318a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318d:	8b 40 04             	mov    0x4(%eax),%eax
  803190:	85 c0                	test   %eax,%eax
  803192:	74 0d                	je     8031a1 <merging+0x208>
  803194:	8b 45 0c             	mov    0xc(%ebp),%eax
  803197:	8b 40 04             	mov    0x4(%eax),%eax
  80319a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80319d:	89 10                	mov    %edx,(%eax)
  80319f:	eb 08                	jmp    8031a9 <merging+0x210>
  8031a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031a4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031af:	89 50 04             	mov    %edx,0x4(%eax)
  8031b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8031b7:	40                   	inc    %eax
  8031b8:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8031bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031c1:	75 17                	jne    8031da <merging+0x241>
  8031c3:	83 ec 04             	sub    $0x4,%esp
  8031c6:	68 83 47 80 00       	push   $0x804783
  8031cb:	68 8e 01 00 00       	push   $0x18e
  8031d0:	68 a1 47 80 00       	push   $0x8047a1
  8031d5:	e8 72 d3 ff ff       	call   80054c <_panic>
  8031da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	85 c0                	test   %eax,%eax
  8031e1:	74 10                	je     8031f3 <merging+0x25a>
  8031e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031eb:	8b 52 04             	mov    0x4(%edx),%edx
  8031ee:	89 50 04             	mov    %edx,0x4(%eax)
  8031f1:	eb 0b                	jmp    8031fe <merging+0x265>
  8031f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f6:	8b 40 04             	mov    0x4(%eax),%eax
  8031f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8031fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  803201:	8b 40 04             	mov    0x4(%eax),%eax
  803204:	85 c0                	test   %eax,%eax
  803206:	74 0f                	je     803217 <merging+0x27e>
  803208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80320b:	8b 40 04             	mov    0x4(%eax),%eax
  80320e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803211:	8b 12                	mov    (%edx),%edx
  803213:	89 10                	mov    %edx,(%eax)
  803215:	eb 0a                	jmp    803221 <merging+0x288>
  803217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80321a:	8b 00                	mov    (%eax),%eax
  80321c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803221:	8b 45 0c             	mov    0xc(%ebp),%eax
  803224:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80322a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80322d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803234:	a1 38 50 80 00       	mov    0x805038,%eax
  803239:	48                   	dec    %eax
  80323a:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80323f:	e9 72 01 00 00       	jmp    8033b6 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803244:	8b 45 10             	mov    0x10(%ebp),%eax
  803247:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80324a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80324e:	74 79                	je     8032c9 <merging+0x330>
  803250:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803254:	74 73                	je     8032c9 <merging+0x330>
  803256:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325a:	74 06                	je     803262 <merging+0x2c9>
  80325c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803260:	75 17                	jne    803279 <merging+0x2e0>
  803262:	83 ec 04             	sub    $0x4,%esp
  803265:	68 14 48 80 00       	push   $0x804814
  80326a:	68 94 01 00 00       	push   $0x194
  80326f:	68 a1 47 80 00       	push   $0x8047a1
  803274:	e8 d3 d2 ff ff       	call   80054c <_panic>
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	8b 10                	mov    (%eax),%edx
  80327e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803281:	89 10                	mov    %edx,(%eax)
  803283:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803286:	8b 00                	mov    (%eax),%eax
  803288:	85 c0                	test   %eax,%eax
  80328a:	74 0b                	je     803297 <merging+0x2fe>
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	8b 00                	mov    (%eax),%eax
  803291:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803294:	89 50 04             	mov    %edx,0x4(%eax)
  803297:	8b 45 08             	mov    0x8(%ebp),%eax
  80329a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80329d:	89 10                	mov    %edx,(%eax)
  80329f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a5:	89 50 04             	mov    %edx,0x4(%eax)
  8032a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ab:	8b 00                	mov    (%eax),%eax
  8032ad:	85 c0                	test   %eax,%eax
  8032af:	75 08                	jne    8032b9 <merging+0x320>
  8032b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8032b9:	a1 38 50 80 00       	mov    0x805038,%eax
  8032be:	40                   	inc    %eax
  8032bf:	a3 38 50 80 00       	mov    %eax,0x805038
  8032c4:	e9 ce 00 00 00       	jmp    803397 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8032c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032cd:	74 65                	je     803334 <merging+0x39b>
  8032cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8032d3:	75 17                	jne    8032ec <merging+0x353>
  8032d5:	83 ec 04             	sub    $0x4,%esp
  8032d8:	68 f0 47 80 00       	push   $0x8047f0
  8032dd:	68 95 01 00 00       	push   $0x195
  8032e2:	68 a1 47 80 00       	push   $0x8047a1
  8032e7:	e8 60 d2 ff ff       	call   80054c <_panic>
  8032ec:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032f5:	89 50 04             	mov    %edx,0x4(%eax)
  8032f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032fb:	8b 40 04             	mov    0x4(%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	74 0c                	je     80330e <merging+0x375>
  803302:	a1 30 50 80 00       	mov    0x805030,%eax
  803307:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80330a:	89 10                	mov    %edx,(%eax)
  80330c:	eb 08                	jmp    803316 <merging+0x37d>
  80330e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803311:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803316:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803319:	a3 30 50 80 00       	mov    %eax,0x805030
  80331e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803321:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803327:	a1 38 50 80 00       	mov    0x805038,%eax
  80332c:	40                   	inc    %eax
  80332d:	a3 38 50 80 00       	mov    %eax,0x805038
  803332:	eb 63                	jmp    803397 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803334:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803338:	75 17                	jne    803351 <merging+0x3b8>
  80333a:	83 ec 04             	sub    $0x4,%esp
  80333d:	68 bc 47 80 00       	push   $0x8047bc
  803342:	68 98 01 00 00       	push   $0x198
  803347:	68 a1 47 80 00       	push   $0x8047a1
  80334c:	e8 fb d1 ff ff       	call   80054c <_panic>
  803351:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803357:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80335a:	89 10                	mov    %edx,(%eax)
  80335c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80335f:	8b 00                	mov    (%eax),%eax
  803361:	85 c0                	test   %eax,%eax
  803363:	74 0d                	je     803372 <merging+0x3d9>
  803365:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80336a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80336d:	89 50 04             	mov    %edx,0x4(%eax)
  803370:	eb 08                	jmp    80337a <merging+0x3e1>
  803372:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803375:	a3 30 50 80 00       	mov    %eax,0x805030
  80337a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80337d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803385:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338c:	a1 38 50 80 00       	mov    0x805038,%eax
  803391:	40                   	inc    %eax
  803392:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803397:	83 ec 0c             	sub    $0xc,%esp
  80339a:	ff 75 10             	pushl  0x10(%ebp)
  80339d:	e8 f9 ed ff ff       	call   80219b <get_block_size>
  8033a2:	83 c4 10             	add    $0x10,%esp
  8033a5:	83 ec 04             	sub    $0x4,%esp
  8033a8:	6a 00                	push   $0x0
  8033aa:	50                   	push   %eax
  8033ab:	ff 75 10             	pushl  0x10(%ebp)
  8033ae:	e8 39 f1 ff ff       	call   8024ec <set_block_data>
  8033b3:	83 c4 10             	add    $0x10,%esp
	}
}
  8033b6:	90                   	nop
  8033b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033ba:	c9                   	leave  
  8033bb:	c3                   	ret    

008033bc <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8033bc:	55                   	push   %ebp
  8033bd:	89 e5                	mov    %esp,%ebp
  8033bf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8033c2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8033ca:	a1 30 50 80 00       	mov    0x805030,%eax
  8033cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033d2:	73 1b                	jae    8033ef <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8033d4:	a1 30 50 80 00       	mov    0x805030,%eax
  8033d9:	83 ec 04             	sub    $0x4,%esp
  8033dc:	ff 75 08             	pushl  0x8(%ebp)
  8033df:	6a 00                	push   $0x0
  8033e1:	50                   	push   %eax
  8033e2:	e8 b2 fb ff ff       	call   802f99 <merging>
  8033e7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033ea:	e9 8b 00 00 00       	jmp    80347a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8033ef:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033f7:	76 18                	jbe    803411 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8033f9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033fe:	83 ec 04             	sub    $0x4,%esp
  803401:	ff 75 08             	pushl  0x8(%ebp)
  803404:	50                   	push   %eax
  803405:	6a 00                	push   $0x0
  803407:	e8 8d fb ff ff       	call   802f99 <merging>
  80340c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80340f:	eb 69                	jmp    80347a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803411:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803416:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803419:	eb 39                	jmp    803454 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80341b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803421:	73 29                	jae    80344c <free_block+0x90>
  803423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	3b 45 08             	cmp    0x8(%ebp),%eax
  80342b:	76 1f                	jbe    80344c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80342d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803430:	8b 00                	mov    (%eax),%eax
  803432:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803435:	83 ec 04             	sub    $0x4,%esp
  803438:	ff 75 08             	pushl  0x8(%ebp)
  80343b:	ff 75 f0             	pushl  -0x10(%ebp)
  80343e:	ff 75 f4             	pushl  -0xc(%ebp)
  803441:	e8 53 fb ff ff       	call   802f99 <merging>
  803446:	83 c4 10             	add    $0x10,%esp
			break;
  803449:	90                   	nop
		}
	}
}
  80344a:	eb 2e                	jmp    80347a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80344c:	a1 34 50 80 00       	mov    0x805034,%eax
  803451:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803458:	74 07                	je     803461 <free_block+0xa5>
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	8b 00                	mov    (%eax),%eax
  80345f:	eb 05                	jmp    803466 <free_block+0xaa>
  803461:	b8 00 00 00 00       	mov    $0x0,%eax
  803466:	a3 34 50 80 00       	mov    %eax,0x805034
  80346b:	a1 34 50 80 00       	mov    0x805034,%eax
  803470:	85 c0                	test   %eax,%eax
  803472:	75 a7                	jne    80341b <free_block+0x5f>
  803474:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803478:	75 a1                	jne    80341b <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80347a:	90                   	nop
  80347b:	c9                   	leave  
  80347c:	c3                   	ret    

0080347d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80347d:	55                   	push   %ebp
  80347e:	89 e5                	mov    %esp,%ebp
  803480:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803483:	ff 75 08             	pushl  0x8(%ebp)
  803486:	e8 10 ed ff ff       	call   80219b <get_block_size>
  80348b:	83 c4 04             	add    $0x4,%esp
  80348e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803498:	eb 17                	jmp    8034b1 <copy_data+0x34>
  80349a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80349d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a0:	01 c2                	add    %eax,%edx
  8034a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	01 c8                	add    %ecx,%eax
  8034aa:	8a 00                	mov    (%eax),%al
  8034ac:	88 02                	mov    %al,(%edx)
  8034ae:	ff 45 fc             	incl   -0x4(%ebp)
  8034b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8034b7:	72 e1                	jb     80349a <copy_data+0x1d>
}
  8034b9:	90                   	nop
  8034ba:	c9                   	leave  
  8034bb:	c3                   	ret    

008034bc <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8034bc:	55                   	push   %ebp
  8034bd:	89 e5                	mov    %esp,%ebp
  8034bf:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8034c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034c6:	75 23                	jne    8034eb <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8034c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034cc:	74 13                	je     8034e1 <realloc_block_FF+0x25>
  8034ce:	83 ec 0c             	sub    $0xc,%esp
  8034d1:	ff 75 0c             	pushl  0xc(%ebp)
  8034d4:	e8 42 f0 ff ff       	call   80251b <alloc_block_FF>
  8034d9:	83 c4 10             	add    $0x10,%esp
  8034dc:	e9 e4 06 00 00       	jmp    803bc5 <realloc_block_FF+0x709>
		return NULL;
  8034e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e6:	e9 da 06 00 00       	jmp    803bc5 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8034eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8034ef:	75 18                	jne    803509 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8034f1:	83 ec 0c             	sub    $0xc,%esp
  8034f4:	ff 75 08             	pushl  0x8(%ebp)
  8034f7:	e8 c0 fe ff ff       	call   8033bc <free_block>
  8034fc:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8034ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803504:	e9 bc 06 00 00       	jmp    803bc5 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803509:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80350d:	77 07                	ja     803516 <realloc_block_FF+0x5a>
  80350f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803516:	8b 45 0c             	mov    0xc(%ebp),%eax
  803519:	83 e0 01             	and    $0x1,%eax
  80351c:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80351f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803522:	83 c0 08             	add    $0x8,%eax
  803525:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803528:	83 ec 0c             	sub    $0xc,%esp
  80352b:	ff 75 08             	pushl  0x8(%ebp)
  80352e:	e8 68 ec ff ff       	call   80219b <get_block_size>
  803533:	83 c4 10             	add    $0x10,%esp
  803536:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803539:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353c:	83 e8 08             	sub    $0x8,%eax
  80353f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	83 e8 04             	sub    $0x4,%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	83 e0 fe             	and    $0xfffffffe,%eax
  80354d:	89 c2                	mov    %eax,%edx
  80354f:	8b 45 08             	mov    0x8(%ebp),%eax
  803552:	01 d0                	add    %edx,%eax
  803554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803557:	83 ec 0c             	sub    $0xc,%esp
  80355a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80355d:	e8 39 ec ff ff       	call   80219b <get_block_size>
  803562:	83 c4 10             	add    $0x10,%esp
  803565:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80356b:	83 e8 08             	sub    $0x8,%eax
  80356e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803571:	8b 45 0c             	mov    0xc(%ebp),%eax
  803574:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803577:	75 08                	jne    803581 <realloc_block_FF+0xc5>
	{
		 return va;
  803579:	8b 45 08             	mov    0x8(%ebp),%eax
  80357c:	e9 44 06 00 00       	jmp    803bc5 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803581:	8b 45 0c             	mov    0xc(%ebp),%eax
  803584:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803587:	0f 83 d5 03 00 00    	jae    803962 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80358d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803590:	2b 45 0c             	sub    0xc(%ebp),%eax
  803593:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803596:	83 ec 0c             	sub    $0xc,%esp
  803599:	ff 75 e4             	pushl  -0x1c(%ebp)
  80359c:	e8 13 ec ff ff       	call   8021b4 <is_free_block>
  8035a1:	83 c4 10             	add    $0x10,%esp
  8035a4:	84 c0                	test   %al,%al
  8035a6:	0f 84 3b 01 00 00    	je     8036e7 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8035ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035b2:	01 d0                	add    %edx,%eax
  8035b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8035b7:	83 ec 04             	sub    $0x4,%esp
  8035ba:	6a 01                	push   $0x1
  8035bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8035bf:	ff 75 08             	pushl  0x8(%ebp)
  8035c2:	e8 25 ef ff ff       	call   8024ec <set_block_data>
  8035c7:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8035ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cd:	83 e8 04             	sub    $0x4,%eax
  8035d0:	8b 00                	mov    (%eax),%eax
  8035d2:	83 e0 fe             	and    $0xfffffffe,%eax
  8035d5:	89 c2                	mov    %eax,%edx
  8035d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035da:	01 d0                	add    %edx,%eax
  8035dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8035df:	83 ec 04             	sub    $0x4,%esp
  8035e2:	6a 00                	push   $0x0
  8035e4:	ff 75 cc             	pushl  -0x34(%ebp)
  8035e7:	ff 75 c8             	pushl  -0x38(%ebp)
  8035ea:	e8 fd ee ff ff       	call   8024ec <set_block_data>
  8035ef:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8035f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035f6:	74 06                	je     8035fe <realloc_block_FF+0x142>
  8035f8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8035fc:	75 17                	jne    803615 <realloc_block_FF+0x159>
  8035fe:	83 ec 04             	sub    $0x4,%esp
  803601:	68 14 48 80 00       	push   $0x804814
  803606:	68 f6 01 00 00       	push   $0x1f6
  80360b:	68 a1 47 80 00       	push   $0x8047a1
  803610:	e8 37 cf ff ff       	call   80054c <_panic>
  803615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803618:	8b 10                	mov    (%eax),%edx
  80361a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80361d:	89 10                	mov    %edx,(%eax)
  80361f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803622:	8b 00                	mov    (%eax),%eax
  803624:	85 c0                	test   %eax,%eax
  803626:	74 0b                	je     803633 <realloc_block_FF+0x177>
  803628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362b:	8b 00                	mov    (%eax),%eax
  80362d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803630:	89 50 04             	mov    %edx,0x4(%eax)
  803633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803636:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803639:	89 10                	mov    %edx,(%eax)
  80363b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80363e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803641:	89 50 04             	mov    %edx,0x4(%eax)
  803644:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803647:	8b 00                	mov    (%eax),%eax
  803649:	85 c0                	test   %eax,%eax
  80364b:	75 08                	jne    803655 <realloc_block_FF+0x199>
  80364d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803650:	a3 30 50 80 00       	mov    %eax,0x805030
  803655:	a1 38 50 80 00       	mov    0x805038,%eax
  80365a:	40                   	inc    %eax
  80365b:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803660:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803664:	75 17                	jne    80367d <realloc_block_FF+0x1c1>
  803666:	83 ec 04             	sub    $0x4,%esp
  803669:	68 83 47 80 00       	push   $0x804783
  80366e:	68 f7 01 00 00       	push   $0x1f7
  803673:	68 a1 47 80 00       	push   $0x8047a1
  803678:	e8 cf ce ff ff       	call   80054c <_panic>
  80367d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803680:	8b 00                	mov    (%eax),%eax
  803682:	85 c0                	test   %eax,%eax
  803684:	74 10                	je     803696 <realloc_block_FF+0x1da>
  803686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803689:	8b 00                	mov    (%eax),%eax
  80368b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80368e:	8b 52 04             	mov    0x4(%edx),%edx
  803691:	89 50 04             	mov    %edx,0x4(%eax)
  803694:	eb 0b                	jmp    8036a1 <realloc_block_FF+0x1e5>
  803696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803699:	8b 40 04             	mov    0x4(%eax),%eax
  80369c:	a3 30 50 80 00       	mov    %eax,0x805030
  8036a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a4:	8b 40 04             	mov    0x4(%eax),%eax
  8036a7:	85 c0                	test   %eax,%eax
  8036a9:	74 0f                	je     8036ba <realloc_block_FF+0x1fe>
  8036ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ae:	8b 40 04             	mov    0x4(%eax),%eax
  8036b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036b4:	8b 12                	mov    (%edx),%edx
  8036b6:	89 10                	mov    %edx,(%eax)
  8036b8:	eb 0a                	jmp    8036c4 <realloc_block_FF+0x208>
  8036ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036bd:	8b 00                	mov    (%eax),%eax
  8036bf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8036dc:	48                   	dec    %eax
  8036dd:	a3 38 50 80 00       	mov    %eax,0x805038
  8036e2:	e9 73 02 00 00       	jmp    80395a <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8036e7:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8036eb:	0f 86 69 02 00 00    	jbe    80395a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8036f1:	83 ec 04             	sub    $0x4,%esp
  8036f4:	6a 01                	push   $0x1
  8036f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8036f9:	ff 75 08             	pushl  0x8(%ebp)
  8036fc:	e8 eb ed ff ff       	call   8024ec <set_block_data>
  803701:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	83 e8 04             	sub    $0x4,%eax
  80370a:	8b 00                	mov    (%eax),%eax
  80370c:	83 e0 fe             	and    $0xfffffffe,%eax
  80370f:	89 c2                	mov    %eax,%edx
  803711:	8b 45 08             	mov    0x8(%ebp),%eax
  803714:	01 d0                	add    %edx,%eax
  803716:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803719:	a1 38 50 80 00       	mov    0x805038,%eax
  80371e:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803721:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803725:	75 68                	jne    80378f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803727:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80372b:	75 17                	jne    803744 <realloc_block_FF+0x288>
  80372d:	83 ec 04             	sub    $0x4,%esp
  803730:	68 bc 47 80 00       	push   $0x8047bc
  803735:	68 06 02 00 00       	push   $0x206
  80373a:	68 a1 47 80 00       	push   $0x8047a1
  80373f:	e8 08 ce ff ff       	call   80054c <_panic>
  803744:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80374a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80374d:	89 10                	mov    %edx,(%eax)
  80374f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803752:	8b 00                	mov    (%eax),%eax
  803754:	85 c0                	test   %eax,%eax
  803756:	74 0d                	je     803765 <realloc_block_FF+0x2a9>
  803758:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80375d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803760:	89 50 04             	mov    %edx,0x4(%eax)
  803763:	eb 08                	jmp    80376d <realloc_block_FF+0x2b1>
  803765:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803768:	a3 30 50 80 00       	mov    %eax,0x805030
  80376d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803770:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803775:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803778:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80377f:	a1 38 50 80 00       	mov    0x805038,%eax
  803784:	40                   	inc    %eax
  803785:	a3 38 50 80 00       	mov    %eax,0x805038
  80378a:	e9 b0 01 00 00       	jmp    80393f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80378f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803794:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803797:	76 68                	jbe    803801 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803799:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80379d:	75 17                	jne    8037b6 <realloc_block_FF+0x2fa>
  80379f:	83 ec 04             	sub    $0x4,%esp
  8037a2:	68 bc 47 80 00       	push   $0x8047bc
  8037a7:	68 0b 02 00 00       	push   $0x20b
  8037ac:	68 a1 47 80 00       	push   $0x8047a1
  8037b1:	e8 96 cd ff ff       	call   80054c <_panic>
  8037b6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8037bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037bf:	89 10                	mov    %edx,(%eax)
  8037c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037c4:	8b 00                	mov    (%eax),%eax
  8037c6:	85 c0                	test   %eax,%eax
  8037c8:	74 0d                	je     8037d7 <realloc_block_FF+0x31b>
  8037ca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037d2:	89 50 04             	mov    %edx,0x4(%eax)
  8037d5:	eb 08                	jmp    8037df <realloc_block_FF+0x323>
  8037d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037da:	a3 30 50 80 00       	mov    %eax,0x805030
  8037df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f1:	a1 38 50 80 00       	mov    0x805038,%eax
  8037f6:	40                   	inc    %eax
  8037f7:	a3 38 50 80 00       	mov    %eax,0x805038
  8037fc:	e9 3e 01 00 00       	jmp    80393f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803801:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803806:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803809:	73 68                	jae    803873 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80380b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80380f:	75 17                	jne    803828 <realloc_block_FF+0x36c>
  803811:	83 ec 04             	sub    $0x4,%esp
  803814:	68 f0 47 80 00       	push   $0x8047f0
  803819:	68 10 02 00 00       	push   $0x210
  80381e:	68 a1 47 80 00       	push   $0x8047a1
  803823:	e8 24 cd ff ff       	call   80054c <_panic>
  803828:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80382e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803831:	89 50 04             	mov    %edx,0x4(%eax)
  803834:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803837:	8b 40 04             	mov    0x4(%eax),%eax
  80383a:	85 c0                	test   %eax,%eax
  80383c:	74 0c                	je     80384a <realloc_block_FF+0x38e>
  80383e:	a1 30 50 80 00       	mov    0x805030,%eax
  803843:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803846:	89 10                	mov    %edx,(%eax)
  803848:	eb 08                	jmp    803852 <realloc_block_FF+0x396>
  80384a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80384d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803852:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803855:	a3 30 50 80 00       	mov    %eax,0x805030
  80385a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80385d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803863:	a1 38 50 80 00       	mov    0x805038,%eax
  803868:	40                   	inc    %eax
  803869:	a3 38 50 80 00       	mov    %eax,0x805038
  80386e:	e9 cc 00 00 00       	jmp    80393f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803873:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80387a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80387f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803882:	e9 8a 00 00 00       	jmp    803911 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80388d:	73 7a                	jae    803909 <realloc_block_FF+0x44d>
  80388f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803892:	8b 00                	mov    (%eax),%eax
  803894:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803897:	73 70                	jae    803909 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803899:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80389d:	74 06                	je     8038a5 <realloc_block_FF+0x3e9>
  80389f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8038a3:	75 17                	jne    8038bc <realloc_block_FF+0x400>
  8038a5:	83 ec 04             	sub    $0x4,%esp
  8038a8:	68 14 48 80 00       	push   $0x804814
  8038ad:	68 1a 02 00 00       	push   $0x21a
  8038b2:	68 a1 47 80 00       	push   $0x8047a1
  8038b7:	e8 90 cc ff ff       	call   80054c <_panic>
  8038bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bf:	8b 10                	mov    (%eax),%edx
  8038c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038c4:	89 10                	mov    %edx,(%eax)
  8038c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038c9:	8b 00                	mov    (%eax),%eax
  8038cb:	85 c0                	test   %eax,%eax
  8038cd:	74 0b                	je     8038da <realloc_block_FF+0x41e>
  8038cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d2:	8b 00                	mov    (%eax),%eax
  8038d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038d7:	89 50 04             	mov    %edx,0x4(%eax)
  8038da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8038e0:	89 10                	mov    %edx,(%eax)
  8038e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038e8:	89 50 04             	mov    %edx,0x4(%eax)
  8038eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038ee:	8b 00                	mov    (%eax),%eax
  8038f0:	85 c0                	test   %eax,%eax
  8038f2:	75 08                	jne    8038fc <realloc_block_FF+0x440>
  8038f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038f7:	a3 30 50 80 00       	mov    %eax,0x805030
  8038fc:	a1 38 50 80 00       	mov    0x805038,%eax
  803901:	40                   	inc    %eax
  803902:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803907:	eb 36                	jmp    80393f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803909:	a1 34 50 80 00       	mov    0x805034,%eax
  80390e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803911:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803915:	74 07                	je     80391e <realloc_block_FF+0x462>
  803917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	eb 05                	jmp    803923 <realloc_block_FF+0x467>
  80391e:	b8 00 00 00 00       	mov    $0x0,%eax
  803923:	a3 34 50 80 00       	mov    %eax,0x805034
  803928:	a1 34 50 80 00       	mov    0x805034,%eax
  80392d:	85 c0                	test   %eax,%eax
  80392f:	0f 85 52 ff ff ff    	jne    803887 <realloc_block_FF+0x3cb>
  803935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803939:	0f 85 48 ff ff ff    	jne    803887 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80393f:	83 ec 04             	sub    $0x4,%esp
  803942:	6a 00                	push   $0x0
  803944:	ff 75 d8             	pushl  -0x28(%ebp)
  803947:	ff 75 d4             	pushl  -0x2c(%ebp)
  80394a:	e8 9d eb ff ff       	call   8024ec <set_block_data>
  80394f:	83 c4 10             	add    $0x10,%esp
				return va;
  803952:	8b 45 08             	mov    0x8(%ebp),%eax
  803955:	e9 6b 02 00 00       	jmp    803bc5 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  80395a:	8b 45 08             	mov    0x8(%ebp),%eax
  80395d:	e9 63 02 00 00       	jmp    803bc5 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803962:	8b 45 0c             	mov    0xc(%ebp),%eax
  803965:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803968:	0f 86 4d 02 00 00    	jbe    803bbb <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  80396e:	83 ec 0c             	sub    $0xc,%esp
  803971:	ff 75 e4             	pushl  -0x1c(%ebp)
  803974:	e8 3b e8 ff ff       	call   8021b4 <is_free_block>
  803979:	83 c4 10             	add    $0x10,%esp
  80397c:	84 c0                	test   %al,%al
  80397e:	0f 84 37 02 00 00    	je     803bbb <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803984:	8b 45 0c             	mov    0xc(%ebp),%eax
  803987:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80398a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80398d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803990:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803993:	76 38                	jbe    8039cd <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803995:	83 ec 0c             	sub    $0xc,%esp
  803998:	ff 75 0c             	pushl  0xc(%ebp)
  80399b:	e8 7b eb ff ff       	call   80251b <alloc_block_FF>
  8039a0:	83 c4 10             	add    $0x10,%esp
  8039a3:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8039a6:	83 ec 08             	sub    $0x8,%esp
  8039a9:	ff 75 c0             	pushl  -0x40(%ebp)
  8039ac:	ff 75 08             	pushl  0x8(%ebp)
  8039af:	e8 c9 fa ff ff       	call   80347d <copy_data>
  8039b4:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  8039b7:	83 ec 0c             	sub    $0xc,%esp
  8039ba:	ff 75 08             	pushl  0x8(%ebp)
  8039bd:	e8 fa f9 ff ff       	call   8033bc <free_block>
  8039c2:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8039c5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8039c8:	e9 f8 01 00 00       	jmp    803bc5 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8039cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039d0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8039d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8039d6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8039da:	0f 87 a0 00 00 00    	ja     803a80 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8039e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039e4:	75 17                	jne    8039fd <realloc_block_FF+0x541>
  8039e6:	83 ec 04             	sub    $0x4,%esp
  8039e9:	68 83 47 80 00       	push   $0x804783
  8039ee:	68 38 02 00 00       	push   $0x238
  8039f3:	68 a1 47 80 00       	push   $0x8047a1
  8039f8:	e8 4f cb ff ff       	call   80054c <_panic>
  8039fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a00:	8b 00                	mov    (%eax),%eax
  803a02:	85 c0                	test   %eax,%eax
  803a04:	74 10                	je     803a16 <realloc_block_FF+0x55a>
  803a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a09:	8b 00                	mov    (%eax),%eax
  803a0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a0e:	8b 52 04             	mov    0x4(%edx),%edx
  803a11:	89 50 04             	mov    %edx,0x4(%eax)
  803a14:	eb 0b                	jmp    803a21 <realloc_block_FF+0x565>
  803a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a19:	8b 40 04             	mov    0x4(%eax),%eax
  803a1c:	a3 30 50 80 00       	mov    %eax,0x805030
  803a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a24:	8b 40 04             	mov    0x4(%eax),%eax
  803a27:	85 c0                	test   %eax,%eax
  803a29:	74 0f                	je     803a3a <realloc_block_FF+0x57e>
  803a2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a2e:	8b 40 04             	mov    0x4(%eax),%eax
  803a31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a34:	8b 12                	mov    (%edx),%edx
  803a36:	89 10                	mov    %edx,(%eax)
  803a38:	eb 0a                	jmp    803a44 <realloc_block_FF+0x588>
  803a3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a3d:	8b 00                	mov    (%eax),%eax
  803a3f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803a44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a57:	a1 38 50 80 00       	mov    0x805038,%eax
  803a5c:	48                   	dec    %eax
  803a5d:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803a62:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a68:	01 d0                	add    %edx,%eax
  803a6a:	83 ec 04             	sub    $0x4,%esp
  803a6d:	6a 01                	push   $0x1
  803a6f:	50                   	push   %eax
  803a70:	ff 75 08             	pushl  0x8(%ebp)
  803a73:	e8 74 ea ff ff       	call   8024ec <set_block_data>
  803a78:	83 c4 10             	add    $0x10,%esp
  803a7b:	e9 36 01 00 00       	jmp    803bb6 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803a80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a83:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a86:	01 d0                	add    %edx,%eax
  803a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803a8b:	83 ec 04             	sub    $0x4,%esp
  803a8e:	6a 01                	push   $0x1
  803a90:	ff 75 f0             	pushl  -0x10(%ebp)
  803a93:	ff 75 08             	pushl  0x8(%ebp)
  803a96:	e8 51 ea ff ff       	call   8024ec <set_block_data>
  803a9b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa1:	83 e8 04             	sub    $0x4,%eax
  803aa4:	8b 00                	mov    (%eax),%eax
  803aa6:	83 e0 fe             	and    $0xfffffffe,%eax
  803aa9:	89 c2                	mov    %eax,%edx
  803aab:	8b 45 08             	mov    0x8(%ebp),%eax
  803aae:	01 d0                	add    %edx,%eax
  803ab0:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ab3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ab7:	74 06                	je     803abf <realloc_block_FF+0x603>
  803ab9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803abd:	75 17                	jne    803ad6 <realloc_block_FF+0x61a>
  803abf:	83 ec 04             	sub    $0x4,%esp
  803ac2:	68 14 48 80 00       	push   $0x804814
  803ac7:	68 44 02 00 00       	push   $0x244
  803acc:	68 a1 47 80 00       	push   $0x8047a1
  803ad1:	e8 76 ca ff ff       	call   80054c <_panic>
  803ad6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad9:	8b 10                	mov    (%eax),%edx
  803adb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ade:	89 10                	mov    %edx,(%eax)
  803ae0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ae3:	8b 00                	mov    (%eax),%eax
  803ae5:	85 c0                	test   %eax,%eax
  803ae7:	74 0b                	je     803af4 <realloc_block_FF+0x638>
  803ae9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aec:	8b 00                	mov    (%eax),%eax
  803aee:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803af1:	89 50 04             	mov    %edx,0x4(%eax)
  803af4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803af7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803afa:	89 10                	mov    %edx,(%eax)
  803afc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803aff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b02:	89 50 04             	mov    %edx,0x4(%eax)
  803b05:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b08:	8b 00                	mov    (%eax),%eax
  803b0a:	85 c0                	test   %eax,%eax
  803b0c:	75 08                	jne    803b16 <realloc_block_FF+0x65a>
  803b0e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803b11:	a3 30 50 80 00       	mov    %eax,0x805030
  803b16:	a1 38 50 80 00       	mov    0x805038,%eax
  803b1b:	40                   	inc    %eax
  803b1c:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803b21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b25:	75 17                	jne    803b3e <realloc_block_FF+0x682>
  803b27:	83 ec 04             	sub    $0x4,%esp
  803b2a:	68 83 47 80 00       	push   $0x804783
  803b2f:	68 45 02 00 00       	push   $0x245
  803b34:	68 a1 47 80 00       	push   $0x8047a1
  803b39:	e8 0e ca ff ff       	call   80054c <_panic>
  803b3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b41:	8b 00                	mov    (%eax),%eax
  803b43:	85 c0                	test   %eax,%eax
  803b45:	74 10                	je     803b57 <realloc_block_FF+0x69b>
  803b47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b4a:	8b 00                	mov    (%eax),%eax
  803b4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b4f:	8b 52 04             	mov    0x4(%edx),%edx
  803b52:	89 50 04             	mov    %edx,0x4(%eax)
  803b55:	eb 0b                	jmp    803b62 <realloc_block_FF+0x6a6>
  803b57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b5a:	8b 40 04             	mov    0x4(%eax),%eax
  803b5d:	a3 30 50 80 00       	mov    %eax,0x805030
  803b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b65:	8b 40 04             	mov    0x4(%eax),%eax
  803b68:	85 c0                	test   %eax,%eax
  803b6a:	74 0f                	je     803b7b <realloc_block_FF+0x6bf>
  803b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b6f:	8b 40 04             	mov    0x4(%eax),%eax
  803b72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b75:	8b 12                	mov    (%edx),%edx
  803b77:	89 10                	mov    %edx,(%eax)
  803b79:	eb 0a                	jmp    803b85 <realloc_block_FF+0x6c9>
  803b7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b7e:	8b 00                	mov    (%eax),%eax
  803b80:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803b85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b98:	a1 38 50 80 00       	mov    0x805038,%eax
  803b9d:	48                   	dec    %eax
  803b9e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803ba3:	83 ec 04             	sub    $0x4,%esp
  803ba6:	6a 00                	push   $0x0
  803ba8:	ff 75 bc             	pushl  -0x44(%ebp)
  803bab:	ff 75 b8             	pushl  -0x48(%ebp)
  803bae:	e8 39 e9 ff ff       	call   8024ec <set_block_data>
  803bb3:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb9:	eb 0a                	jmp    803bc5 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803bbb:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803bc2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803bc5:	c9                   	leave  
  803bc6:	c3                   	ret    

00803bc7 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803bc7:	55                   	push   %ebp
  803bc8:	89 e5                	mov    %esp,%ebp
  803bca:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803bcd:	83 ec 04             	sub    $0x4,%esp
  803bd0:	68 80 48 80 00       	push   $0x804880
  803bd5:	68 58 02 00 00       	push   $0x258
  803bda:	68 a1 47 80 00       	push   $0x8047a1
  803bdf:	e8 68 c9 ff ff       	call   80054c <_panic>

00803be4 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803be4:	55                   	push   %ebp
  803be5:	89 e5                	mov    %esp,%ebp
  803be7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803bea:	83 ec 04             	sub    $0x4,%esp
  803bed:	68 a8 48 80 00       	push   $0x8048a8
  803bf2:	68 61 02 00 00       	push   $0x261
  803bf7:	68 a1 47 80 00       	push   $0x8047a1
  803bfc:	e8 4b c9 ff ff       	call   80054c <_panic>
  803c01:	66 90                	xchg   %ax,%ax
  803c03:	90                   	nop

00803c04 <__udivdi3>:
  803c04:	55                   	push   %ebp
  803c05:	57                   	push   %edi
  803c06:	56                   	push   %esi
  803c07:	53                   	push   %ebx
  803c08:	83 ec 1c             	sub    $0x1c,%esp
  803c0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c1b:	89 ca                	mov    %ecx,%edx
  803c1d:	89 f8                	mov    %edi,%eax
  803c1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c23:	85 f6                	test   %esi,%esi
  803c25:	75 2d                	jne    803c54 <__udivdi3+0x50>
  803c27:	39 cf                	cmp    %ecx,%edi
  803c29:	77 65                	ja     803c90 <__udivdi3+0x8c>
  803c2b:	89 fd                	mov    %edi,%ebp
  803c2d:	85 ff                	test   %edi,%edi
  803c2f:	75 0b                	jne    803c3c <__udivdi3+0x38>
  803c31:	b8 01 00 00 00       	mov    $0x1,%eax
  803c36:	31 d2                	xor    %edx,%edx
  803c38:	f7 f7                	div    %edi
  803c3a:	89 c5                	mov    %eax,%ebp
  803c3c:	31 d2                	xor    %edx,%edx
  803c3e:	89 c8                	mov    %ecx,%eax
  803c40:	f7 f5                	div    %ebp
  803c42:	89 c1                	mov    %eax,%ecx
  803c44:	89 d8                	mov    %ebx,%eax
  803c46:	f7 f5                	div    %ebp
  803c48:	89 cf                	mov    %ecx,%edi
  803c4a:	89 fa                	mov    %edi,%edx
  803c4c:	83 c4 1c             	add    $0x1c,%esp
  803c4f:	5b                   	pop    %ebx
  803c50:	5e                   	pop    %esi
  803c51:	5f                   	pop    %edi
  803c52:	5d                   	pop    %ebp
  803c53:	c3                   	ret    
  803c54:	39 ce                	cmp    %ecx,%esi
  803c56:	77 28                	ja     803c80 <__udivdi3+0x7c>
  803c58:	0f bd fe             	bsr    %esi,%edi
  803c5b:	83 f7 1f             	xor    $0x1f,%edi
  803c5e:	75 40                	jne    803ca0 <__udivdi3+0x9c>
  803c60:	39 ce                	cmp    %ecx,%esi
  803c62:	72 0a                	jb     803c6e <__udivdi3+0x6a>
  803c64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c68:	0f 87 9e 00 00 00    	ja     803d0c <__udivdi3+0x108>
  803c6e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c73:	89 fa                	mov    %edi,%edx
  803c75:	83 c4 1c             	add    $0x1c,%esp
  803c78:	5b                   	pop    %ebx
  803c79:	5e                   	pop    %esi
  803c7a:	5f                   	pop    %edi
  803c7b:	5d                   	pop    %ebp
  803c7c:	c3                   	ret    
  803c7d:	8d 76 00             	lea    0x0(%esi),%esi
  803c80:	31 ff                	xor    %edi,%edi
  803c82:	31 c0                	xor    %eax,%eax
  803c84:	89 fa                	mov    %edi,%edx
  803c86:	83 c4 1c             	add    $0x1c,%esp
  803c89:	5b                   	pop    %ebx
  803c8a:	5e                   	pop    %esi
  803c8b:	5f                   	pop    %edi
  803c8c:	5d                   	pop    %ebp
  803c8d:	c3                   	ret    
  803c8e:	66 90                	xchg   %ax,%ax
  803c90:	89 d8                	mov    %ebx,%eax
  803c92:	f7 f7                	div    %edi
  803c94:	31 ff                	xor    %edi,%edi
  803c96:	89 fa                	mov    %edi,%edx
  803c98:	83 c4 1c             	add    $0x1c,%esp
  803c9b:	5b                   	pop    %ebx
  803c9c:	5e                   	pop    %esi
  803c9d:	5f                   	pop    %edi
  803c9e:	5d                   	pop    %ebp
  803c9f:	c3                   	ret    
  803ca0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ca5:	89 eb                	mov    %ebp,%ebx
  803ca7:	29 fb                	sub    %edi,%ebx
  803ca9:	89 f9                	mov    %edi,%ecx
  803cab:	d3 e6                	shl    %cl,%esi
  803cad:	89 c5                	mov    %eax,%ebp
  803caf:	88 d9                	mov    %bl,%cl
  803cb1:	d3 ed                	shr    %cl,%ebp
  803cb3:	89 e9                	mov    %ebp,%ecx
  803cb5:	09 f1                	or     %esi,%ecx
  803cb7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803cbb:	89 f9                	mov    %edi,%ecx
  803cbd:	d3 e0                	shl    %cl,%eax
  803cbf:	89 c5                	mov    %eax,%ebp
  803cc1:	89 d6                	mov    %edx,%esi
  803cc3:	88 d9                	mov    %bl,%cl
  803cc5:	d3 ee                	shr    %cl,%esi
  803cc7:	89 f9                	mov    %edi,%ecx
  803cc9:	d3 e2                	shl    %cl,%edx
  803ccb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ccf:	88 d9                	mov    %bl,%cl
  803cd1:	d3 e8                	shr    %cl,%eax
  803cd3:	09 c2                	or     %eax,%edx
  803cd5:	89 d0                	mov    %edx,%eax
  803cd7:	89 f2                	mov    %esi,%edx
  803cd9:	f7 74 24 0c          	divl   0xc(%esp)
  803cdd:	89 d6                	mov    %edx,%esi
  803cdf:	89 c3                	mov    %eax,%ebx
  803ce1:	f7 e5                	mul    %ebp
  803ce3:	39 d6                	cmp    %edx,%esi
  803ce5:	72 19                	jb     803d00 <__udivdi3+0xfc>
  803ce7:	74 0b                	je     803cf4 <__udivdi3+0xf0>
  803ce9:	89 d8                	mov    %ebx,%eax
  803ceb:	31 ff                	xor    %edi,%edi
  803ced:	e9 58 ff ff ff       	jmp    803c4a <__udivdi3+0x46>
  803cf2:	66 90                	xchg   %ax,%ax
  803cf4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803cf8:	89 f9                	mov    %edi,%ecx
  803cfa:	d3 e2                	shl    %cl,%edx
  803cfc:	39 c2                	cmp    %eax,%edx
  803cfe:	73 e9                	jae    803ce9 <__udivdi3+0xe5>
  803d00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d03:	31 ff                	xor    %edi,%edi
  803d05:	e9 40 ff ff ff       	jmp    803c4a <__udivdi3+0x46>
  803d0a:	66 90                	xchg   %ax,%ax
  803d0c:	31 c0                	xor    %eax,%eax
  803d0e:	e9 37 ff ff ff       	jmp    803c4a <__udivdi3+0x46>
  803d13:	90                   	nop

00803d14 <__umoddi3>:
  803d14:	55                   	push   %ebp
  803d15:	57                   	push   %edi
  803d16:	56                   	push   %esi
  803d17:	53                   	push   %ebx
  803d18:	83 ec 1c             	sub    $0x1c,%esp
  803d1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d33:	89 f3                	mov    %esi,%ebx
  803d35:	89 fa                	mov    %edi,%edx
  803d37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d3b:	89 34 24             	mov    %esi,(%esp)
  803d3e:	85 c0                	test   %eax,%eax
  803d40:	75 1a                	jne    803d5c <__umoddi3+0x48>
  803d42:	39 f7                	cmp    %esi,%edi
  803d44:	0f 86 a2 00 00 00    	jbe    803dec <__umoddi3+0xd8>
  803d4a:	89 c8                	mov    %ecx,%eax
  803d4c:	89 f2                	mov    %esi,%edx
  803d4e:	f7 f7                	div    %edi
  803d50:	89 d0                	mov    %edx,%eax
  803d52:	31 d2                	xor    %edx,%edx
  803d54:	83 c4 1c             	add    $0x1c,%esp
  803d57:	5b                   	pop    %ebx
  803d58:	5e                   	pop    %esi
  803d59:	5f                   	pop    %edi
  803d5a:	5d                   	pop    %ebp
  803d5b:	c3                   	ret    
  803d5c:	39 f0                	cmp    %esi,%eax
  803d5e:	0f 87 ac 00 00 00    	ja     803e10 <__umoddi3+0xfc>
  803d64:	0f bd e8             	bsr    %eax,%ebp
  803d67:	83 f5 1f             	xor    $0x1f,%ebp
  803d6a:	0f 84 ac 00 00 00    	je     803e1c <__umoddi3+0x108>
  803d70:	bf 20 00 00 00       	mov    $0x20,%edi
  803d75:	29 ef                	sub    %ebp,%edi
  803d77:	89 fe                	mov    %edi,%esi
  803d79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d7d:	89 e9                	mov    %ebp,%ecx
  803d7f:	d3 e0                	shl    %cl,%eax
  803d81:	89 d7                	mov    %edx,%edi
  803d83:	89 f1                	mov    %esi,%ecx
  803d85:	d3 ef                	shr    %cl,%edi
  803d87:	09 c7                	or     %eax,%edi
  803d89:	89 e9                	mov    %ebp,%ecx
  803d8b:	d3 e2                	shl    %cl,%edx
  803d8d:	89 14 24             	mov    %edx,(%esp)
  803d90:	89 d8                	mov    %ebx,%eax
  803d92:	d3 e0                	shl    %cl,%eax
  803d94:	89 c2                	mov    %eax,%edx
  803d96:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d9a:	d3 e0                	shl    %cl,%eax
  803d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803da0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803da4:	89 f1                	mov    %esi,%ecx
  803da6:	d3 e8                	shr    %cl,%eax
  803da8:	09 d0                	or     %edx,%eax
  803daa:	d3 eb                	shr    %cl,%ebx
  803dac:	89 da                	mov    %ebx,%edx
  803dae:	f7 f7                	div    %edi
  803db0:	89 d3                	mov    %edx,%ebx
  803db2:	f7 24 24             	mull   (%esp)
  803db5:	89 c6                	mov    %eax,%esi
  803db7:	89 d1                	mov    %edx,%ecx
  803db9:	39 d3                	cmp    %edx,%ebx
  803dbb:	0f 82 87 00 00 00    	jb     803e48 <__umoddi3+0x134>
  803dc1:	0f 84 91 00 00 00    	je     803e58 <__umoddi3+0x144>
  803dc7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803dcb:	29 f2                	sub    %esi,%edx
  803dcd:	19 cb                	sbb    %ecx,%ebx
  803dcf:	89 d8                	mov    %ebx,%eax
  803dd1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803dd5:	d3 e0                	shl    %cl,%eax
  803dd7:	89 e9                	mov    %ebp,%ecx
  803dd9:	d3 ea                	shr    %cl,%edx
  803ddb:	09 d0                	or     %edx,%eax
  803ddd:	89 e9                	mov    %ebp,%ecx
  803ddf:	d3 eb                	shr    %cl,%ebx
  803de1:	89 da                	mov    %ebx,%edx
  803de3:	83 c4 1c             	add    $0x1c,%esp
  803de6:	5b                   	pop    %ebx
  803de7:	5e                   	pop    %esi
  803de8:	5f                   	pop    %edi
  803de9:	5d                   	pop    %ebp
  803dea:	c3                   	ret    
  803deb:	90                   	nop
  803dec:	89 fd                	mov    %edi,%ebp
  803dee:	85 ff                	test   %edi,%edi
  803df0:	75 0b                	jne    803dfd <__umoddi3+0xe9>
  803df2:	b8 01 00 00 00       	mov    $0x1,%eax
  803df7:	31 d2                	xor    %edx,%edx
  803df9:	f7 f7                	div    %edi
  803dfb:	89 c5                	mov    %eax,%ebp
  803dfd:	89 f0                	mov    %esi,%eax
  803dff:	31 d2                	xor    %edx,%edx
  803e01:	f7 f5                	div    %ebp
  803e03:	89 c8                	mov    %ecx,%eax
  803e05:	f7 f5                	div    %ebp
  803e07:	89 d0                	mov    %edx,%eax
  803e09:	e9 44 ff ff ff       	jmp    803d52 <__umoddi3+0x3e>
  803e0e:	66 90                	xchg   %ax,%ax
  803e10:	89 c8                	mov    %ecx,%eax
  803e12:	89 f2                	mov    %esi,%edx
  803e14:	83 c4 1c             	add    $0x1c,%esp
  803e17:	5b                   	pop    %ebx
  803e18:	5e                   	pop    %esi
  803e19:	5f                   	pop    %edi
  803e1a:	5d                   	pop    %ebp
  803e1b:	c3                   	ret    
  803e1c:	3b 04 24             	cmp    (%esp),%eax
  803e1f:	72 06                	jb     803e27 <__umoddi3+0x113>
  803e21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e25:	77 0f                	ja     803e36 <__umoddi3+0x122>
  803e27:	89 f2                	mov    %esi,%edx
  803e29:	29 f9                	sub    %edi,%ecx
  803e2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e2f:	89 14 24             	mov    %edx,(%esp)
  803e32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e36:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e3a:	8b 14 24             	mov    (%esp),%edx
  803e3d:	83 c4 1c             	add    $0x1c,%esp
  803e40:	5b                   	pop    %ebx
  803e41:	5e                   	pop    %esi
  803e42:	5f                   	pop    %edi
  803e43:	5d                   	pop    %ebp
  803e44:	c3                   	ret    
  803e45:	8d 76 00             	lea    0x0(%esi),%esi
  803e48:	2b 04 24             	sub    (%esp),%eax
  803e4b:	19 fa                	sbb    %edi,%edx
  803e4d:	89 d1                	mov    %edx,%ecx
  803e4f:	89 c6                	mov    %eax,%esi
  803e51:	e9 71 ff ff ff       	jmp    803dc7 <__umoddi3+0xb3>
  803e56:	66 90                	xchg   %ax,%ax
  803e58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e5c:	72 ea                	jb     803e48 <__umoddi3+0x134>
  803e5e:	89 d9                	mov    %ebx,%ecx
  803e60:	e9 62 ff ff ff       	jmp    803dc7 <__umoddi3+0xb3>
