
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
  80005c:	68 a0 3d 80 00       	push   $0x803da0
  800061:	6a 13                	push   $0x13
  800063:	68 bc 3d 80 00       	push   $0x803dbc
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
  800085:	68 d4 3d 80 00       	push   $0x803dd4
  80008a:	e8 7a 07 00 00       	call   800809 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800092:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800099:	e8 ed 1a 00 00       	call   801b8b <sys_calculate_free_frames>
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	6a 01                	push   $0x1
  8000a6:	68 00 10 00 00       	push   $0x1000
  8000ab:	68 10 3e 80 00       	push   $0x803e10
  8000b0:	e8 21 18 00 00       	call   8018d6 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000c1:	74 17                	je     8000da <_main+0xa2>
  8000c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 14 3e 80 00       	push   $0x803e14
  8000d2:	e8 32 07 00 00       	call   800809 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8000da:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8000e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000e4:	e8 a2 1a 00 00       	call   801b8b <sys_calculate_free_frames>
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
  80010f:	e8 77 1a 00 00       	call   801b8b <sys_calculate_free_frames>
  800114:	29 c3                	sub    %eax,%ebx
  800116:	89 d8                	mov    %ebx,%eax
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	68 80 3e 80 00       	push   $0x803e80
  800124:	e8 e0 06 00 00       	call   800809 <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80012c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800130:	74 04                	je     800136 <_main+0xfe>
  800132:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  800136:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80013d:	e8 49 1a 00 00       	call   801b8b <sys_calculate_free_frames>
  800142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	6a 01                	push   $0x1
  80014a:	68 04 10 00 00       	push   $0x1004
  80014f:	68 18 3f 80 00       	push   $0x803f18
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
  800176:	68 14 3e 80 00       	push   $0x803e14
  80017b:	e8 89 06 00 00       	call   800809 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2pages*/
  800183:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80018a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80018d:	e8 f9 19 00 00       	call   801b8b <sys_calculate_free_frames>
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
  8001b8:	e8 ce 19 00 00       	call   801b8b <sys_calculate_free_frames>
  8001bd:	29 c3                	sub    %eax,%ebx
  8001bf:	89 d8                	mov    %ebx,%eax
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c7:	50                   	push   %eax
  8001c8:	68 80 3e 80 00       	push   $0x803e80
  8001cd:	e8 37 06 00 00       	call   800809 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  8001d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d9:	74 04                	je     8001df <_main+0x1a7>
  8001db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  8001df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001e6:	e8 a0 19 00 00       	call   801b8b <sys_calculate_free_frames>
  8001eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		y = smalloc("y", 4, 1);
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 01                	push   $0x1
  8001f3:	6a 04                	push   $0x4
  8001f5:	68 1a 3f 80 00       	push   $0x803f1a
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
  80021c:	68 14 3e 80 00       	push   $0x803e14
  800221:	e8 e3 05 00 00       	call   800809 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1page*/
  800229:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800230:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800233:	e8 53 19 00 00       	call   801b8b <sys_calculate_free_frames>
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
  80025e:	e8 28 19 00 00       	call   801b8b <sys_calculate_free_frames>
  800263:	29 c3                	sub    %eax,%ebx
  800265:	89 d8                	mov    %ebx,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	ff 75 dc             	pushl  -0x24(%ebp)
  80026d:	50                   	push   %eax
  80026e:	68 80 3e 80 00       	push   $0x803e80
  800273:	e8 91 05 00 00       	call   800809 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80027b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80027f:	74 04                	je     800285 <_main+0x24d>
  800281:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 1c 3f 80 00       	push   $0x803f1c
  80028d:	e8 77 05 00 00       	call   800809 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp

	is_correct = 1;
  800295:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP B: checking reading & writing... [40%]\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 44 3f 80 00       	push   $0x803f44
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
  800329:	68 74 3f 80 00       	push   $0x803f74
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
  80034f:	68 74 3f 80 00       	push   $0x803f74
  800354:	e8 b0 04 00 00       	call   800809 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
		if( y[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80035c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	83 f8 ff             	cmp    $0xffffffff,%eax
  800364:	74 17                	je     80037d <_main+0x345>
  800366:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 74 3f 80 00       	push   $0x803f74
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
  800396:	68 74 3f 80 00       	push   $0x803f74
  80039b:	e8 69 04 00 00       	call   800809 <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003ab:	74 17                	je     8003c4 <_main+0x38c>
  8003ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 74 3f 80 00       	push   $0x803f74
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
  8003dd:	68 74 3f 80 00       	push   $0x803f74
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
  8003fa:	68 a0 3f 80 00       	push   $0x803fa0
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
  800413:	e8 3c 19 00 00       	call   801d54 <sys_getenvindex>
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
  800481:	e8 52 16 00 00       	call   801ad8 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	68 fc 3f 80 00       	push   $0x803ffc
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
  8004b1:	68 24 40 80 00       	push   $0x804024
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
  8004e2:	68 4c 40 80 00       	push   $0x80404c
  8004e7:	e8 1d 03 00 00       	call   800809 <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f4:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	50                   	push   %eax
  8004fe:	68 a4 40 80 00       	push   $0x8040a4
  800503:	e8 01 03 00 00       	call   800809 <cprintf>
  800508:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	68 fc 3f 80 00       	push   $0x803ffc
  800513:	e8 f1 02 00 00       	call   800809 <cprintf>
  800518:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80051b:	e8 d2 15 00 00       	call   801af2 <sys_unlock_cons>
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
  800533:	e8 e8 17 00 00       	call   801d20 <sys_destroy_env>
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
  800544:	e8 3d 18 00 00       	call   801d86 <sys_exit_env>
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
  80056d:	68 b8 40 80 00       	push   $0x8040b8
  800572:	e8 92 02 00 00       	call   800809 <cprintf>
  800577:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80057a:	a1 00 50 80 00       	mov    0x805000,%eax
  80057f:	ff 75 0c             	pushl  0xc(%ebp)
  800582:	ff 75 08             	pushl  0x8(%ebp)
  800585:	50                   	push   %eax
  800586:	68 bd 40 80 00       	push   $0x8040bd
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
  8005aa:	68 d9 40 80 00       	push   $0x8040d9
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
  8005d9:	68 dc 40 80 00       	push   $0x8040dc
  8005de:	6a 26                	push   $0x26
  8005e0:	68 28 41 80 00       	push   $0x804128
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
  8006ae:	68 34 41 80 00       	push   $0x804134
  8006b3:	6a 3a                	push   $0x3a
  8006b5:	68 28 41 80 00       	push   $0x804128
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
  800721:	68 88 41 80 00       	push   $0x804188
  800726:	6a 44                	push   $0x44
  800728:	68 28 41 80 00       	push   $0x804128
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
  80077b:	e8 16 13 00 00       	call   801a96 <sys_cputs>
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
  8007f2:	e8 9f 12 00 00       	call   801a96 <sys_cputs>
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
  80083c:	e8 97 12 00 00       	call   801ad8 <sys_lock_cons>
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
  80085c:	e8 91 12 00 00       	call   801af2 <sys_unlock_cons>
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
  8008a6:	e8 85 32 00 00       	call   803b30 <__udivdi3>
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
  8008f6:	e8 45 33 00 00       	call   803c40 <__umoddi3>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	05 f4 43 80 00       	add    $0x8043f4,%eax
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
  800a51:	8b 04 85 18 44 80 00 	mov    0x804418(,%eax,4),%eax
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
  800b32:	8b 34 9d 60 42 80 00 	mov    0x804260(,%ebx,4),%esi
  800b39:	85 f6                	test   %esi,%esi
  800b3b:	75 19                	jne    800b56 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b3d:	53                   	push   %ebx
  800b3e:	68 05 44 80 00       	push   $0x804405
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
  800b57:	68 0e 44 80 00       	push   $0x80440e
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
  800b84:	be 11 44 80 00       	mov    $0x804411,%esi
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
  80158f:	68 88 45 80 00       	push   $0x804588
  801594:	68 3f 01 00 00       	push   $0x13f
  801599:	68 aa 45 80 00       	push   $0x8045aa
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
  8015af:	e8 8d 0a 00 00       	call   802041 <sys_sbrk>
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
  80162a:	e8 96 08 00 00       	call   801ec5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162f:	85 c0                	test   %eax,%eax
  801631:	74 16                	je     801649 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 d6 0d 00 00       	call   802414 <alloc_block_FF>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801644:	e9 8a 01 00 00       	jmp    8017d3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801649:	e8 a8 08 00 00       	call   801ef6 <sys_isUHeapPlacementStrategyBESTFIT>
  80164e:	85 c0                	test   %eax,%eax
  801650:	0f 84 7d 01 00 00    	je     8017d3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	e8 6f 12 00 00       	call   8028d0 <alloc_block_BF>
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
  8016ac:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  8016f9:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801750:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  8017b2:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8017b9:	83 ec 08             	sub    $0x8,%esp
  8017bc:	ff 75 08             	pushl  0x8(%ebp)
  8017bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8017c2:	e8 b1 08 00 00       	call   802078 <sys_allocate_user_mem>
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
  80180a:	e8 85 08 00 00       	call   802094 <get_block_size>
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801815:	83 ec 0c             	sub    $0xc,%esp
  801818:	ff 75 08             	pushl  0x8(%ebp)
  80181b:	e8 b8 1a 00 00       	call   8032d8 <free_block>
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
  801855:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801892:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  8018b2:	e8 a5 07 00 00       	call   80205c <sys_free_user_mem>
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
  8018c0:	68 b8 45 80 00       	push   $0x8045b8
  8018c5:	68 84 00 00 00       	push   $0x84
  8018ca:	68 e2 45 80 00       	push   $0x8045e2
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
  8018e6:	75 07                	jne    8018ef <smalloc+0x19>
  8018e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ed:	eb 64                	jmp    801953 <smalloc+0x7d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8018ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018f5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801902:	39 d0                	cmp    %edx,%eax
  801904:	73 02                	jae    801908 <smalloc+0x32>
  801906:	89 d0                	mov    %edx,%eax
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	50                   	push   %eax
  80190c:	e8 a8 fc ff ff       	call   8015b9 <malloc>
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801917:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80191b:	75 07                	jne    801924 <smalloc+0x4e>
  80191d:	b8 00 00 00 00       	mov    $0x0,%eax
  801922:	eb 2f                	jmp    801953 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801924:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801928:	ff 75 ec             	pushl  -0x14(%ebp)
  80192b:	50                   	push   %eax
  80192c:	ff 75 0c             	pushl  0xc(%ebp)
  80192f:	ff 75 08             	pushl  0x8(%ebp)
  801932:	e8 2c 03 00 00       	call   801c63 <sys_createSharedObject>
  801937:	83 c4 10             	add    $0x10,%esp
  80193a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80193d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801941:	74 06                	je     801949 <smalloc+0x73>
  801943:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801947:	75 07                	jne    801950 <smalloc+0x7a>
  801949:	b8 00 00 00 00       	mov    $0x0,%eax
  80194e:	eb 03                	jmp    801953 <smalloc+0x7d>
	 return ptr;
  801950:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80195b:	83 ec 08             	sub    $0x8,%esp
  80195e:	ff 75 0c             	pushl  0xc(%ebp)
  801961:	ff 75 08             	pushl  0x8(%ebp)
  801964:	e8 24 03 00 00       	call   801c8d <sys_getSizeOfSharedObject>
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80196f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801973:	75 07                	jne    80197c <sget+0x27>
  801975:	b8 00 00 00 00       	mov    $0x0,%eax
  80197a:	eb 5c                	jmp    8019d8 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80197c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801982:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801989:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80198c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198f:	39 d0                	cmp    %edx,%eax
  801991:	7d 02                	jge    801995 <sget+0x40>
  801993:	89 d0                	mov    %edx,%eax
  801995:	83 ec 0c             	sub    $0xc,%esp
  801998:	50                   	push   %eax
  801999:	e8 1b fc ff ff       	call   8015b9 <malloc>
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8019a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019a8:	75 07                	jne    8019b1 <sget+0x5c>
  8019aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8019af:	eb 27                	jmp    8019d8 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	ff 75 08             	pushl  0x8(%ebp)
  8019bd:	e8 e8 02 00 00       	call   801caa <sys_getSharedObject>
  8019c2:	83 c4 10             	add    $0x10,%esp
  8019c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8019c8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8019cc:	75 07                	jne    8019d5 <sget+0x80>
  8019ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d3:	eb 03                	jmp    8019d8 <sget+0x83>
	return ptr;
  8019d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019e0:	83 ec 04             	sub    $0x4,%esp
  8019e3:	68 f0 45 80 00       	push   $0x8045f0
  8019e8:	68 c1 00 00 00       	push   $0xc1
  8019ed:	68 e2 45 80 00       	push   $0x8045e2
  8019f2:	e8 55 eb ff ff       	call   80054c <_panic>

008019f7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	68 14 46 80 00       	push   $0x804614
  801a05:	68 d8 00 00 00       	push   $0xd8
  801a0a:	68 e2 45 80 00       	push   $0x8045e2
  801a0f:	e8 38 eb ff ff       	call   80054c <_panic>

00801a14 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a1a:	83 ec 04             	sub    $0x4,%esp
  801a1d:	68 3a 46 80 00       	push   $0x80463a
  801a22:	68 e4 00 00 00       	push   $0xe4
  801a27:	68 e2 45 80 00       	push   $0x8045e2
  801a2c:	e8 1b eb ff ff       	call   80054c <_panic>

00801a31 <shrink>:

}
void shrink(uint32 newSize)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a37:	83 ec 04             	sub    $0x4,%esp
  801a3a:	68 3a 46 80 00       	push   $0x80463a
  801a3f:	68 e9 00 00 00       	push   $0xe9
  801a44:	68 e2 45 80 00       	push   $0x8045e2
  801a49:	e8 fe ea ff ff       	call   80054c <_panic>

00801a4e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a54:	83 ec 04             	sub    $0x4,%esp
  801a57:	68 3a 46 80 00       	push   $0x80463a
  801a5c:	68 ee 00 00 00       	push   $0xee
  801a61:	68 e2 45 80 00       	push   $0x8045e2
  801a66:	e8 e1 ea ff ff       	call   80054c <_panic>

00801a6b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	57                   	push   %edi
  801a6f:	56                   	push   %esi
  801a70:	53                   	push   %ebx
  801a71:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a7d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a80:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a83:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a86:	cd 30                	int    $0x30
  801a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	5b                   	pop    %ebx
  801a92:	5e                   	pop    %esi
  801a93:	5f                   	pop    %edi
  801a94:	5d                   	pop    %ebp
  801a95:	c3                   	ret    

00801a96 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 04             	sub    $0x4,%esp
  801a9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801aa2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	52                   	push   %edx
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	50                   	push   %eax
  801ab2:	6a 00                	push   $0x0
  801ab4:	e8 b2 ff ff ff       	call   801a6b <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	90                   	nop
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_cgetc>:

int
sys_cgetc(void)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 02                	push   $0x2
  801ace:	e8 98 ff ff ff       	call   801a6b <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 03                	push   $0x3
  801ae7:	e8 7f ff ff ff       	call   801a6b <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	90                   	nop
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 04                	push   $0x4
  801b01:	e8 65 ff ff ff       	call   801a6b <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	90                   	nop
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	52                   	push   %edx
  801b1c:	50                   	push   %eax
  801b1d:	6a 08                	push   $0x8
  801b1f:	e8 47 ff ff ff       	call   801a6b <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	56                   	push   %esi
  801b2d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b2e:	8b 75 18             	mov    0x18(%ebp),%esi
  801b31:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	56                   	push   %esi
  801b3e:	53                   	push   %ebx
  801b3f:	51                   	push   %ecx
  801b40:	52                   	push   %edx
  801b41:	50                   	push   %eax
  801b42:	6a 09                	push   $0x9
  801b44:	e8 22 ff ff ff       	call   801a6b <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    

00801b53 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	52                   	push   %edx
  801b63:	50                   	push   %eax
  801b64:	6a 0a                	push   $0xa
  801b66:	e8 00 ff ff ff       	call   801a6b <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	ff 75 08             	pushl  0x8(%ebp)
  801b7f:	6a 0b                	push   $0xb
  801b81:	e8 e5 fe ff ff       	call   801a6b <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 0c                	push   $0xc
  801b9a:	e8 cc fe ff ff       	call   801a6b <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 0d                	push   $0xd
  801bb3:	e8 b3 fe ff ff       	call   801a6b <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 0e                	push   $0xe
  801bcc:	e8 9a fe ff ff       	call   801a6b <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 0f                	push   $0xf
  801be5:	e8 81 fe ff ff       	call   801a6b <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	ff 75 08             	pushl  0x8(%ebp)
  801bfd:	6a 10                	push   $0x10
  801bff:	e8 67 fe ff ff       	call   801a6b <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 11                	push   $0x11
  801c18:	e8 4e fe ff ff       	call   801a6b <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	90                   	nop
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 04             	sub    $0x4,%esp
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c2f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	50                   	push   %eax
  801c3c:	6a 01                	push   $0x1
  801c3e:	e8 28 fe ff ff       	call   801a6b <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	90                   	nop
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 14                	push   $0x14
  801c58:	e8 0e fe ff ff       	call   801a6b <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	90                   	nop
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c6f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c72:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	6a 00                	push   $0x0
  801c7b:	51                   	push   %ecx
  801c7c:	52                   	push   %edx
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	50                   	push   %eax
  801c81:	6a 15                	push   $0x15
  801c83:	e8 e3 fd ff ff       	call   801a6b <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	52                   	push   %edx
  801c9d:	50                   	push   %eax
  801c9e:	6a 16                	push   $0x16
  801ca0:	e8 c6 fd ff ff       	call   801a6b <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	51                   	push   %ecx
  801cbb:	52                   	push   %edx
  801cbc:	50                   	push   %eax
  801cbd:	6a 17                	push   $0x17
  801cbf:	e8 a7 fd ff ff       	call   801a6b <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	52                   	push   %edx
  801cd9:	50                   	push   %eax
  801cda:	6a 18                	push   $0x18
  801cdc:	e8 8a fd ff ff       	call   801a6b <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	6a 00                	push   $0x0
  801cee:	ff 75 14             	pushl  0x14(%ebp)
  801cf1:	ff 75 10             	pushl  0x10(%ebp)
  801cf4:	ff 75 0c             	pushl  0xc(%ebp)
  801cf7:	50                   	push   %eax
  801cf8:	6a 19                	push   $0x19
  801cfa:	e8 6c fd ff ff       	call   801a6b <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	50                   	push   %eax
  801d13:	6a 1a                	push   $0x1a
  801d15:	e8 51 fd ff ff       	call   801a6b <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	90                   	nop
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	50                   	push   %eax
  801d2f:	6a 1b                	push   $0x1b
  801d31:	e8 35 fd ff ff       	call   801a6b <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 05                	push   $0x5
  801d4a:	e8 1c fd ff ff       	call   801a6b <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 06                	push   $0x6
  801d63:	e8 03 fd ff ff       	call   801a6b <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 07                	push   $0x7
  801d7c:	e8 ea fc ff ff       	call   801a6b <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_exit_env>:


void sys_exit_env(void)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 1c                	push   $0x1c
  801d95:	e8 d1 fc ff ff       	call   801a6b <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
}
  801d9d:	90                   	nop
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801da6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801da9:	8d 50 04             	lea    0x4(%eax),%edx
  801dac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	52                   	push   %edx
  801db6:	50                   	push   %eax
  801db7:	6a 1d                	push   $0x1d
  801db9:	e8 ad fc ff ff       	call   801a6b <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
	return result;
  801dc1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dca:	89 01                	mov    %eax,(%ecx)
  801dcc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	c9                   	leave  
  801dd3:	c2 04 00             	ret    $0x4

00801dd6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	ff 75 10             	pushl  0x10(%ebp)
  801de0:	ff 75 0c             	pushl  0xc(%ebp)
  801de3:	ff 75 08             	pushl  0x8(%ebp)
  801de6:	6a 13                	push   $0x13
  801de8:	e8 7e fc ff ff       	call   801a6b <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
	return ;
  801df0:	90                   	nop
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 1e                	push   $0x1e
  801e02:	e8 64 fc ff ff       	call   801a6b <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 04             	sub    $0x4,%esp
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e18:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	50                   	push   %eax
  801e25:	6a 1f                	push   $0x1f
  801e27:	e8 3f fc ff ff       	call   801a6b <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2f:	90                   	nop
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <rsttst>:
void rsttst()
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 21                	push   $0x21
  801e41:	e8 25 fc ff ff       	call   801a6b <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
	return ;
  801e49:	90                   	nop
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	83 ec 04             	sub    $0x4,%esp
  801e52:	8b 45 14             	mov    0x14(%ebp),%eax
  801e55:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e58:	8b 55 18             	mov    0x18(%ebp),%edx
  801e5b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e5f:	52                   	push   %edx
  801e60:	50                   	push   %eax
  801e61:	ff 75 10             	pushl  0x10(%ebp)
  801e64:	ff 75 0c             	pushl  0xc(%ebp)
  801e67:	ff 75 08             	pushl  0x8(%ebp)
  801e6a:	6a 20                	push   $0x20
  801e6c:	e8 fa fb ff ff       	call   801a6b <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
	return ;
  801e74:	90                   	nop
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <chktst>:
void chktst(uint32 n)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	ff 75 08             	pushl  0x8(%ebp)
  801e85:	6a 22                	push   $0x22
  801e87:	e8 df fb ff ff       	call   801a6b <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8f:	90                   	nop
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <inctst>:

void inctst()
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 23                	push   $0x23
  801ea1:	e8 c5 fb ff ff       	call   801a6b <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea9:	90                   	nop
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <gettst>:
uint32 gettst()
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 24                	push   $0x24
  801ebb:	e8 ab fb ff ff       	call   801a6b <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 25                	push   $0x25
  801ed7:	e8 8f fb ff ff       	call   801a6b <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
  801edf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ee2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ee6:	75 07                	jne    801eef <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ee8:	b8 01 00 00 00       	mov    $0x1,%eax
  801eed:	eb 05                	jmp    801ef4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 25                	push   $0x25
  801f08:	e8 5e fb ff ff       	call   801a6b <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
  801f10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f13:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f17:	75 07                	jne    801f20 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f19:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1e:	eb 05                	jmp    801f25 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 25                	push   $0x25
  801f39:	e8 2d fb ff ff       	call   801a6b <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
  801f41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f44:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f48:	75 07                	jne    801f51 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4f:	eb 05                	jmp    801f56 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
  801f5b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 25                	push   $0x25
  801f6a:	e8 fc fa ff ff       	call   801a6b <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
  801f72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f75:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f79:	75 07                	jne    801f82 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f7b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f80:	eb 05                	jmp    801f87 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	ff 75 08             	pushl  0x8(%ebp)
  801f97:	6a 26                	push   $0x26
  801f99:	e8 cd fa ff ff       	call   801a6b <syscall>
  801f9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa1:	90                   	nop
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fa8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	6a 00                	push   $0x0
  801fb6:	53                   	push   %ebx
  801fb7:	51                   	push   %ecx
  801fb8:	52                   	push   %edx
  801fb9:	50                   	push   %eax
  801fba:	6a 27                	push   $0x27
  801fbc:	e8 aa fa ff ff       	call   801a6b <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	52                   	push   %edx
  801fd9:	50                   	push   %eax
  801fda:	6a 28                	push   $0x28
  801fdc:	e8 8a fa ff ff       	call   801a6b <syscall>
  801fe1:	83 c4 18             	add    $0x18,%esp
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801fe9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	6a 00                	push   $0x0
  801ff4:	51                   	push   %ecx
  801ff5:	ff 75 10             	pushl  0x10(%ebp)
  801ff8:	52                   	push   %edx
  801ff9:	50                   	push   %eax
  801ffa:	6a 29                	push   $0x29
  801ffc:	e8 6a fa ff ff       	call   801a6b <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	ff 75 10             	pushl  0x10(%ebp)
  802010:	ff 75 0c             	pushl  0xc(%ebp)
  802013:	ff 75 08             	pushl  0x8(%ebp)
  802016:	6a 12                	push   $0x12
  802018:	e8 4e fa ff ff       	call   801a6b <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
	return ;
  802020:	90                   	nop
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802026:	8b 55 0c             	mov    0xc(%ebp),%edx
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	52                   	push   %edx
  802033:	50                   	push   %eax
  802034:	6a 2a                	push   $0x2a
  802036:	e8 30 fa ff ff       	call   801a6b <syscall>
  80203b:	83 c4 18             	add    $0x18,%esp
	return;
  80203e:	90                   	nop
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	50                   	push   %eax
  802050:	6a 2b                	push   $0x2b
  802052:	e8 14 fa ff ff       	call   801a6b <syscall>
  802057:	83 c4 18             	add    $0x18,%esp
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	ff 75 0c             	pushl  0xc(%ebp)
  802068:	ff 75 08             	pushl  0x8(%ebp)
  80206b:	6a 2c                	push   $0x2c
  80206d:	e8 f9 f9 ff ff       	call   801a6b <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
	return;
  802075:	90                   	nop
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	ff 75 0c             	pushl  0xc(%ebp)
  802084:	ff 75 08             	pushl  0x8(%ebp)
  802087:	6a 2d                	push   $0x2d
  802089:	e8 dd f9 ff ff       	call   801a6b <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
	return;
  802091:	90                   	nop
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	83 e8 04             	sub    $0x4,%eax
  8020a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a6:	8b 00                	mov    (%eax),%eax
  8020a8:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	83 e8 04             	sub    $0x4,%eax
  8020b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8020bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020bf:	8b 00                	mov    (%eax),%eax
  8020c1:	83 e0 01             	and    $0x1,%eax
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	0f 94 c0             	sete   %al
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020db:	83 f8 02             	cmp    $0x2,%eax
  8020de:	74 2b                	je     80210b <alloc_block+0x40>
  8020e0:	83 f8 02             	cmp    $0x2,%eax
  8020e3:	7f 07                	jg     8020ec <alloc_block+0x21>
  8020e5:	83 f8 01             	cmp    $0x1,%eax
  8020e8:	74 0e                	je     8020f8 <alloc_block+0x2d>
  8020ea:	eb 58                	jmp    802144 <alloc_block+0x79>
  8020ec:	83 f8 03             	cmp    $0x3,%eax
  8020ef:	74 2d                	je     80211e <alloc_block+0x53>
  8020f1:	83 f8 04             	cmp    $0x4,%eax
  8020f4:	74 3b                	je     802131 <alloc_block+0x66>
  8020f6:	eb 4c                	jmp    802144 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020f8:	83 ec 0c             	sub    $0xc,%esp
  8020fb:	ff 75 08             	pushl  0x8(%ebp)
  8020fe:	e8 11 03 00 00       	call   802414 <alloc_block_FF>
  802103:	83 c4 10             	add    $0x10,%esp
  802106:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802109:	eb 4a                	jmp    802155 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80210b:	83 ec 0c             	sub    $0xc,%esp
  80210e:	ff 75 08             	pushl  0x8(%ebp)
  802111:	e8 fa 19 00 00       	call   803b10 <alloc_block_NF>
  802116:	83 c4 10             	add    $0x10,%esp
  802119:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80211c:	eb 37                	jmp    802155 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80211e:	83 ec 0c             	sub    $0xc,%esp
  802121:	ff 75 08             	pushl  0x8(%ebp)
  802124:	e8 a7 07 00 00       	call   8028d0 <alloc_block_BF>
  802129:	83 c4 10             	add    $0x10,%esp
  80212c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80212f:	eb 24                	jmp    802155 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802131:	83 ec 0c             	sub    $0xc,%esp
  802134:	ff 75 08             	pushl  0x8(%ebp)
  802137:	e8 b7 19 00 00       	call   803af3 <alloc_block_WF>
  80213c:	83 c4 10             	add    $0x10,%esp
  80213f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802142:	eb 11                	jmp    802155 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802144:	83 ec 0c             	sub    $0xc,%esp
  802147:	68 4c 46 80 00       	push   $0x80464c
  80214c:	e8 b8 e6 ff ff       	call   800809 <cprintf>
  802151:	83 c4 10             	add    $0x10,%esp
		break;
  802154:	90                   	nop
	}
	return va;
  802155:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	53                   	push   %ebx
  80215e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802161:	83 ec 0c             	sub    $0xc,%esp
  802164:	68 6c 46 80 00       	push   $0x80466c
  802169:	e8 9b e6 ff ff       	call   800809 <cprintf>
  80216e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802171:	83 ec 0c             	sub    $0xc,%esp
  802174:	68 97 46 80 00       	push   $0x804697
  802179:	e8 8b e6 ff ff       	call   800809 <cprintf>
  80217e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802187:	eb 37                	jmp    8021c0 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802189:	83 ec 0c             	sub    $0xc,%esp
  80218c:	ff 75 f4             	pushl  -0xc(%ebp)
  80218f:	e8 19 ff ff ff       	call   8020ad <is_free_block>
  802194:	83 c4 10             	add    $0x10,%esp
  802197:	0f be d8             	movsbl %al,%ebx
  80219a:	83 ec 0c             	sub    $0xc,%esp
  80219d:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a0:	e8 ef fe ff ff       	call   802094 <get_block_size>
  8021a5:	83 c4 10             	add    $0x10,%esp
  8021a8:	83 ec 04             	sub    $0x4,%esp
  8021ab:	53                   	push   %ebx
  8021ac:	50                   	push   %eax
  8021ad:	68 af 46 80 00       	push   $0x8046af
  8021b2:	e8 52 e6 ff ff       	call   800809 <cprintf>
  8021b7:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8021bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c4:	74 07                	je     8021cd <print_blocks_list+0x73>
  8021c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c9:	8b 00                	mov    (%eax),%eax
  8021cb:	eb 05                	jmp    8021d2 <print_blocks_list+0x78>
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d2:	89 45 10             	mov    %eax,0x10(%ebp)
  8021d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d8:	85 c0                	test   %eax,%eax
  8021da:	75 ad                	jne    802189 <print_blocks_list+0x2f>
  8021dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e0:	75 a7                	jne    802189 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8021e2:	83 ec 0c             	sub    $0xc,%esp
  8021e5:	68 6c 46 80 00       	push   $0x80466c
  8021ea:	e8 1a e6 ff ff       	call   800809 <cprintf>
  8021ef:	83 c4 10             	add    $0x10,%esp

}
  8021f2:	90                   	nop
  8021f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802201:	83 e0 01             	and    $0x1,%eax
  802204:	85 c0                	test   %eax,%eax
  802206:	74 03                	je     80220b <initialize_dynamic_allocator+0x13>
  802208:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80220b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80220f:	0f 84 c7 01 00 00    	je     8023dc <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802215:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80221c:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80221f:	8b 55 08             	mov    0x8(%ebp),%edx
  802222:	8b 45 0c             	mov    0xc(%ebp),%eax
  802225:	01 d0                	add    %edx,%eax
  802227:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80222c:	0f 87 ad 01 00 00    	ja     8023df <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	85 c0                	test   %eax,%eax
  802237:	0f 89 a5 01 00 00    	jns    8023e2 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80223d:	8b 55 08             	mov    0x8(%ebp),%edx
  802240:	8b 45 0c             	mov    0xc(%ebp),%eax
  802243:	01 d0                	add    %edx,%eax
  802245:	83 e8 04             	sub    $0x4,%eax
  802248:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80224d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802254:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802259:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225c:	e9 87 00 00 00       	jmp    8022e8 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802261:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802265:	75 14                	jne    80227b <initialize_dynamic_allocator+0x83>
  802267:	83 ec 04             	sub    $0x4,%esp
  80226a:	68 c7 46 80 00       	push   $0x8046c7
  80226f:	6a 79                	push   $0x79
  802271:	68 e5 46 80 00       	push   $0x8046e5
  802276:	e8 d1 e2 ff ff       	call   80054c <_panic>
  80227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227e:	8b 00                	mov    (%eax),%eax
  802280:	85 c0                	test   %eax,%eax
  802282:	74 10                	je     802294 <initialize_dynamic_allocator+0x9c>
  802284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802287:	8b 00                	mov    (%eax),%eax
  802289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228c:	8b 52 04             	mov    0x4(%edx),%edx
  80228f:	89 50 04             	mov    %edx,0x4(%eax)
  802292:	eb 0b                	jmp    80229f <initialize_dynamic_allocator+0xa7>
  802294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802297:	8b 40 04             	mov    0x4(%eax),%eax
  80229a:	a3 30 50 80 00       	mov    %eax,0x805030
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 40 04             	mov    0x4(%eax),%eax
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	74 0f                	je     8022b8 <initialize_dynamic_allocator+0xc0>
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 40 04             	mov    0x4(%eax),%eax
  8022af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b2:	8b 12                	mov    (%edx),%edx
  8022b4:	89 10                	mov    %edx,(%eax)
  8022b6:	eb 0a                	jmp    8022c2 <initialize_dynamic_allocator+0xca>
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 00                	mov    (%eax),%eax
  8022bd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8022da:	48                   	dec    %eax
  8022db:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8022e0:	a1 34 50 80 00       	mov    0x805034,%eax
  8022e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ec:	74 07                	je     8022f5 <initialize_dynamic_allocator+0xfd>
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 00                	mov    (%eax),%eax
  8022f3:	eb 05                	jmp    8022fa <initialize_dynamic_allocator+0x102>
  8022f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fa:	a3 34 50 80 00       	mov    %eax,0x805034
  8022ff:	a1 34 50 80 00       	mov    0x805034,%eax
  802304:	85 c0                	test   %eax,%eax
  802306:	0f 85 55 ff ff ff    	jne    802261 <initialize_dynamic_allocator+0x69>
  80230c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802310:	0f 85 4b ff ff ff    	jne    802261 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80231c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802325:	a1 44 50 80 00       	mov    0x805044,%eax
  80232a:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80232f:	a1 40 50 80 00       	mov    0x805040,%eax
  802334:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	83 c0 08             	add    $0x8,%eax
  802340:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	83 c0 04             	add    $0x4,%eax
  802349:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234c:	83 ea 08             	sub    $0x8,%edx
  80234f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802351:	8b 55 0c             	mov    0xc(%ebp),%edx
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	01 d0                	add    %edx,%eax
  802359:	83 e8 08             	sub    $0x8,%eax
  80235c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235f:	83 ea 08             	sub    $0x8,%edx
  802362:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802367:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80236d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802370:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802377:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80237b:	75 17                	jne    802394 <initialize_dynamic_allocator+0x19c>
  80237d:	83 ec 04             	sub    $0x4,%esp
  802380:	68 00 47 80 00       	push   $0x804700
  802385:	68 90 00 00 00       	push   $0x90
  80238a:	68 e5 46 80 00       	push   $0x8046e5
  80238f:	e8 b8 e1 ff ff       	call   80054c <_panic>
  802394:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80239a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239d:	89 10                	mov    %edx,(%eax)
  80239f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	74 0d                	je     8023b5 <initialize_dynamic_allocator+0x1bd>
  8023a8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023b0:	89 50 04             	mov    %edx,0x4(%eax)
  8023b3:	eb 08                	jmp    8023bd <initialize_dynamic_allocator+0x1c5>
  8023b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8023bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8023d4:	40                   	inc    %eax
  8023d5:	a3 38 50 80 00       	mov    %eax,0x805038
  8023da:	eb 07                	jmp    8023e3 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8023dc:	90                   	nop
  8023dd:	eb 04                	jmp    8023e3 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8023df:	90                   	nop
  8023e0:	eb 01                	jmp    8023e3 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8023e2:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8023e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8023eb:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f7:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	83 e8 04             	sub    $0x4,%eax
  8023ff:	8b 00                	mov    (%eax),%eax
  802401:	83 e0 fe             	and    $0xfffffffe,%eax
  802404:	8d 50 f8             	lea    -0x8(%eax),%edx
  802407:	8b 45 08             	mov    0x8(%ebp),%eax
  80240a:	01 c2                	add    %eax,%edx
  80240c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240f:	89 02                	mov    %eax,(%edx)
}
  802411:	90                   	nop
  802412:	5d                   	pop    %ebp
  802413:	c3                   	ret    

00802414 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	83 e0 01             	and    $0x1,%eax
  802420:	85 c0                	test   %eax,%eax
  802422:	74 03                	je     802427 <alloc_block_FF+0x13>
  802424:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802427:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80242b:	77 07                	ja     802434 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80242d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802434:	a1 24 50 80 00       	mov    0x805024,%eax
  802439:	85 c0                	test   %eax,%eax
  80243b:	75 73                	jne    8024b0 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	83 c0 10             	add    $0x10,%eax
  802443:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802446:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80244d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802453:	01 d0                	add    %edx,%eax
  802455:	48                   	dec    %eax
  802456:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80245c:	ba 00 00 00 00       	mov    $0x0,%edx
  802461:	f7 75 ec             	divl   -0x14(%ebp)
  802464:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802467:	29 d0                	sub    %edx,%eax
  802469:	c1 e8 0c             	shr    $0xc,%eax
  80246c:	83 ec 0c             	sub    $0xc,%esp
  80246f:	50                   	push   %eax
  802470:	e8 2e f1 ff ff       	call   8015a3 <sbrk>
  802475:	83 c4 10             	add    $0x10,%esp
  802478:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80247b:	83 ec 0c             	sub    $0xc,%esp
  80247e:	6a 00                	push   $0x0
  802480:	e8 1e f1 ff ff       	call   8015a3 <sbrk>
  802485:	83 c4 10             	add    $0x10,%esp
  802488:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80248b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80248e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802491:	83 ec 08             	sub    $0x8,%esp
  802494:	50                   	push   %eax
  802495:	ff 75 e4             	pushl  -0x1c(%ebp)
  802498:	e8 5b fd ff ff       	call   8021f8 <initialize_dynamic_allocator>
  80249d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024a0:	83 ec 0c             	sub    $0xc,%esp
  8024a3:	68 23 47 80 00       	push   $0x804723
  8024a8:	e8 5c e3 ff ff       	call   800809 <cprintf>
  8024ad:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8024b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024b4:	75 0a                	jne    8024c0 <alloc_block_FF+0xac>
	        return NULL;
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bb:	e9 0e 04 00 00       	jmp    8028ce <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8024c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024c7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cf:	e9 f3 02 00 00       	jmp    8027c7 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8024da:	83 ec 0c             	sub    $0xc,%esp
  8024dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8024e0:	e8 af fb ff ff       	call   802094 <get_block_size>
  8024e5:	83 c4 10             	add    $0x10,%esp
  8024e8:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	83 c0 08             	add    $0x8,%eax
  8024f1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8024f4:	0f 87 c5 02 00 00    	ja     8027bf <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	83 c0 18             	add    $0x18,%eax
  802500:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802503:	0f 87 19 02 00 00    	ja     802722 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802509:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80250c:	2b 45 08             	sub    0x8(%ebp),%eax
  80250f:	83 e8 08             	sub    $0x8,%eax
  802512:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	8d 50 08             	lea    0x8(%eax),%edx
  80251b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80251e:	01 d0                	add    %edx,%eax
  802520:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	83 c0 08             	add    $0x8,%eax
  802529:	83 ec 04             	sub    $0x4,%esp
  80252c:	6a 01                	push   $0x1
  80252e:	50                   	push   %eax
  80252f:	ff 75 bc             	pushl  -0x44(%ebp)
  802532:	e8 ae fe ff ff       	call   8023e5 <set_block_data>
  802537:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 40 04             	mov    0x4(%eax),%eax
  802540:	85 c0                	test   %eax,%eax
  802542:	75 68                	jne    8025ac <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802544:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802548:	75 17                	jne    802561 <alloc_block_FF+0x14d>
  80254a:	83 ec 04             	sub    $0x4,%esp
  80254d:	68 00 47 80 00       	push   $0x804700
  802552:	68 d7 00 00 00       	push   $0xd7
  802557:	68 e5 46 80 00       	push   $0x8046e5
  80255c:	e8 eb df ff ff       	call   80054c <_panic>
  802561:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802567:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256a:	89 10                	mov    %edx,(%eax)
  80256c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	85 c0                	test   %eax,%eax
  802573:	74 0d                	je     802582 <alloc_block_FF+0x16e>
  802575:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80257a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80257d:	89 50 04             	mov    %edx,0x4(%eax)
  802580:	eb 08                	jmp    80258a <alloc_block_FF+0x176>
  802582:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802585:	a3 30 50 80 00       	mov    %eax,0x805030
  80258a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80258d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802592:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802595:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259c:	a1 38 50 80 00       	mov    0x805038,%eax
  8025a1:	40                   	inc    %eax
  8025a2:	a3 38 50 80 00       	mov    %eax,0x805038
  8025a7:	e9 dc 00 00 00       	jmp    802688 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 00                	mov    (%eax),%eax
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	75 65                	jne    80261a <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025b5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025b9:	75 17                	jne    8025d2 <alloc_block_FF+0x1be>
  8025bb:	83 ec 04             	sub    $0x4,%esp
  8025be:	68 34 47 80 00       	push   $0x804734
  8025c3:	68 db 00 00 00       	push   $0xdb
  8025c8:	68 e5 46 80 00       	push   $0x8046e5
  8025cd:	e8 7a df ff ff       	call   80054c <_panic>
  8025d2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8025d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025db:	89 50 04             	mov    %edx,0x4(%eax)
  8025de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025e1:	8b 40 04             	mov    0x4(%eax),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 0c                	je     8025f4 <alloc_block_FF+0x1e0>
  8025e8:	a1 30 50 80 00       	mov    0x805030,%eax
  8025ed:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025f0:	89 10                	mov    %edx,(%eax)
  8025f2:	eb 08                	jmp    8025fc <alloc_block_FF+0x1e8>
  8025f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025f7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ff:	a3 30 50 80 00       	mov    %eax,0x805030
  802604:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802607:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260d:	a1 38 50 80 00       	mov    0x805038,%eax
  802612:	40                   	inc    %eax
  802613:	a3 38 50 80 00       	mov    %eax,0x805038
  802618:	eb 6e                	jmp    802688 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80261a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261e:	74 06                	je     802626 <alloc_block_FF+0x212>
  802620:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802624:	75 17                	jne    80263d <alloc_block_FF+0x229>
  802626:	83 ec 04             	sub    $0x4,%esp
  802629:	68 58 47 80 00       	push   $0x804758
  80262e:	68 df 00 00 00       	push   $0xdf
  802633:	68 e5 46 80 00       	push   $0x8046e5
  802638:	e8 0f df ff ff       	call   80054c <_panic>
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 10                	mov    (%eax),%edx
  802642:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802645:	89 10                	mov    %edx,(%eax)
  802647:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80264a:	8b 00                	mov    (%eax),%eax
  80264c:	85 c0                	test   %eax,%eax
  80264e:	74 0b                	je     80265b <alloc_block_FF+0x247>
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 00                	mov    (%eax),%eax
  802655:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802658:	89 50 04             	mov    %edx,0x4(%eax)
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802661:	89 10                	mov    %edx,(%eax)
  802663:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802666:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802669:	89 50 04             	mov    %edx,0x4(%eax)
  80266c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	85 c0                	test   %eax,%eax
  802673:	75 08                	jne    80267d <alloc_block_FF+0x269>
  802675:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802678:	a3 30 50 80 00       	mov    %eax,0x805030
  80267d:	a1 38 50 80 00       	mov    0x805038,%eax
  802682:	40                   	inc    %eax
  802683:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802688:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268c:	75 17                	jne    8026a5 <alloc_block_FF+0x291>
  80268e:	83 ec 04             	sub    $0x4,%esp
  802691:	68 c7 46 80 00       	push   $0x8046c7
  802696:	68 e1 00 00 00       	push   $0xe1
  80269b:	68 e5 46 80 00       	push   $0x8046e5
  8026a0:	e8 a7 de ff ff       	call   80054c <_panic>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	74 10                	je     8026be <alloc_block_FF+0x2aa>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b6:	8b 52 04             	mov    0x4(%edx),%edx
  8026b9:	89 50 04             	mov    %edx,0x4(%eax)
  8026bc:	eb 0b                	jmp    8026c9 <alloc_block_FF+0x2b5>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 40 04             	mov    0x4(%eax),%eax
  8026c4:	a3 30 50 80 00       	mov    %eax,0x805030
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 04             	mov    0x4(%eax),%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	74 0f                	je     8026e2 <alloc_block_FF+0x2ce>
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 40 04             	mov    0x4(%eax),%eax
  8026d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026dc:	8b 12                	mov    (%edx),%edx
  8026de:	89 10                	mov    %edx,(%eax)
  8026e0:	eb 0a                	jmp    8026ec <alloc_block_FF+0x2d8>
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 00                	mov    (%eax),%eax
  8026e7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ff:	a1 38 50 80 00       	mov    0x805038,%eax
  802704:	48                   	dec    %eax
  802705:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80270a:	83 ec 04             	sub    $0x4,%esp
  80270d:	6a 00                	push   $0x0
  80270f:	ff 75 b4             	pushl  -0x4c(%ebp)
  802712:	ff 75 b0             	pushl  -0x50(%ebp)
  802715:	e8 cb fc ff ff       	call   8023e5 <set_block_data>
  80271a:	83 c4 10             	add    $0x10,%esp
  80271d:	e9 95 00 00 00       	jmp    8027b7 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802722:	83 ec 04             	sub    $0x4,%esp
  802725:	6a 01                	push   $0x1
  802727:	ff 75 b8             	pushl  -0x48(%ebp)
  80272a:	ff 75 bc             	pushl  -0x44(%ebp)
  80272d:	e8 b3 fc ff ff       	call   8023e5 <set_block_data>
  802732:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802735:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802739:	75 17                	jne    802752 <alloc_block_FF+0x33e>
  80273b:	83 ec 04             	sub    $0x4,%esp
  80273e:	68 c7 46 80 00       	push   $0x8046c7
  802743:	68 e8 00 00 00       	push   $0xe8
  802748:	68 e5 46 80 00       	push   $0x8046e5
  80274d:	e8 fa dd ff ff       	call   80054c <_panic>
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 00                	mov    (%eax),%eax
  802757:	85 c0                	test   %eax,%eax
  802759:	74 10                	je     80276b <alloc_block_FF+0x357>
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 00                	mov    (%eax),%eax
  802760:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802763:	8b 52 04             	mov    0x4(%edx),%edx
  802766:	89 50 04             	mov    %edx,0x4(%eax)
  802769:	eb 0b                	jmp    802776 <alloc_block_FF+0x362>
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	8b 40 04             	mov    0x4(%eax),%eax
  802771:	a3 30 50 80 00       	mov    %eax,0x805030
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 40 04             	mov    0x4(%eax),%eax
  80277c:	85 c0                	test   %eax,%eax
  80277e:	74 0f                	je     80278f <alloc_block_FF+0x37b>
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 40 04             	mov    0x4(%eax),%eax
  802786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802789:	8b 12                	mov    (%edx),%edx
  80278b:	89 10                	mov    %edx,(%eax)
  80278d:	eb 0a                	jmp    802799 <alloc_block_FF+0x385>
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 00                	mov    (%eax),%eax
  802794:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8027b1:	48                   	dec    %eax
  8027b2:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8027b7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027ba:	e9 0f 01 00 00       	jmp    8028ce <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027bf:	a1 34 50 80 00       	mov    0x805034,%eax
  8027c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cb:	74 07                	je     8027d4 <alloc_block_FF+0x3c0>
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 00                	mov    (%eax),%eax
  8027d2:	eb 05                	jmp    8027d9 <alloc_block_FF+0x3c5>
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d9:	a3 34 50 80 00       	mov    %eax,0x805034
  8027de:	a1 34 50 80 00       	mov    0x805034,%eax
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	0f 85 e9 fc ff ff    	jne    8024d4 <alloc_block_FF+0xc0>
  8027eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ef:	0f 85 df fc ff ff    	jne    8024d4 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f8:	83 c0 08             	add    $0x8,%eax
  8027fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8027fe:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802805:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802808:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80280b:	01 d0                	add    %edx,%eax
  80280d:	48                   	dec    %eax
  80280e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802811:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802814:	ba 00 00 00 00       	mov    $0x0,%edx
  802819:	f7 75 d8             	divl   -0x28(%ebp)
  80281c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80281f:	29 d0                	sub    %edx,%eax
  802821:	c1 e8 0c             	shr    $0xc,%eax
  802824:	83 ec 0c             	sub    $0xc,%esp
  802827:	50                   	push   %eax
  802828:	e8 76 ed ff ff       	call   8015a3 <sbrk>
  80282d:	83 c4 10             	add    $0x10,%esp
  802830:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802833:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802837:	75 0a                	jne    802843 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802839:	b8 00 00 00 00       	mov    $0x0,%eax
  80283e:	e9 8b 00 00 00       	jmp    8028ce <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802843:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80284a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80284d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802850:	01 d0                	add    %edx,%eax
  802852:	48                   	dec    %eax
  802853:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802856:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802859:	ba 00 00 00 00       	mov    $0x0,%edx
  80285e:	f7 75 cc             	divl   -0x34(%ebp)
  802861:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802864:	29 d0                	sub    %edx,%eax
  802866:	8d 50 fc             	lea    -0x4(%eax),%edx
  802869:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80286c:	01 d0                	add    %edx,%eax
  80286e:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802873:	a1 40 50 80 00       	mov    0x805040,%eax
  802878:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80287e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802885:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802888:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80288b:	01 d0                	add    %edx,%eax
  80288d:	48                   	dec    %eax
  80288e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802891:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802894:	ba 00 00 00 00       	mov    $0x0,%edx
  802899:	f7 75 c4             	divl   -0x3c(%ebp)
  80289c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80289f:	29 d0                	sub    %edx,%eax
  8028a1:	83 ec 04             	sub    $0x4,%esp
  8028a4:	6a 01                	push   $0x1
  8028a6:	50                   	push   %eax
  8028a7:	ff 75 d0             	pushl  -0x30(%ebp)
  8028aa:	e8 36 fb ff ff       	call   8023e5 <set_block_data>
  8028af:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8028b2:	83 ec 0c             	sub    $0xc,%esp
  8028b5:	ff 75 d0             	pushl  -0x30(%ebp)
  8028b8:	e8 1b 0a 00 00       	call   8032d8 <free_block>
  8028bd:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8028c0:	83 ec 0c             	sub    $0xc,%esp
  8028c3:	ff 75 08             	pushl  0x8(%ebp)
  8028c6:	e8 49 fb ff ff       	call   802414 <alloc_block_FF>
  8028cb:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8028ce:	c9                   	leave  
  8028cf:	c3                   	ret    

008028d0 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028d0:	55                   	push   %ebp
  8028d1:	89 e5                	mov    %esp,%ebp
  8028d3:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d9:	83 e0 01             	and    $0x1,%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	74 03                	je     8028e3 <alloc_block_BF+0x13>
  8028e0:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028e3:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028e7:	77 07                	ja     8028f0 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028e9:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028f0:	a1 24 50 80 00       	mov    0x805024,%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	75 73                	jne    80296c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	83 c0 10             	add    $0x10,%eax
  8028ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802902:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802909:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80290c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290f:	01 d0                	add    %edx,%eax
  802911:	48                   	dec    %eax
  802912:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802915:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802918:	ba 00 00 00 00       	mov    $0x0,%edx
  80291d:	f7 75 e0             	divl   -0x20(%ebp)
  802920:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802923:	29 d0                	sub    %edx,%eax
  802925:	c1 e8 0c             	shr    $0xc,%eax
  802928:	83 ec 0c             	sub    $0xc,%esp
  80292b:	50                   	push   %eax
  80292c:	e8 72 ec ff ff       	call   8015a3 <sbrk>
  802931:	83 c4 10             	add    $0x10,%esp
  802934:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802937:	83 ec 0c             	sub    $0xc,%esp
  80293a:	6a 00                	push   $0x0
  80293c:	e8 62 ec ff ff       	call   8015a3 <sbrk>
  802941:	83 c4 10             	add    $0x10,%esp
  802944:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802947:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80294a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80294d:	83 ec 08             	sub    $0x8,%esp
  802950:	50                   	push   %eax
  802951:	ff 75 d8             	pushl  -0x28(%ebp)
  802954:	e8 9f f8 ff ff       	call   8021f8 <initialize_dynamic_allocator>
  802959:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80295c:	83 ec 0c             	sub    $0xc,%esp
  80295f:	68 23 47 80 00       	push   $0x804723
  802964:	e8 a0 de ff ff       	call   800809 <cprintf>
  802969:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80296c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802973:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80297a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802981:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802988:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80298d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802990:	e9 1d 01 00 00       	jmp    802ab2 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80299b:	83 ec 0c             	sub    $0xc,%esp
  80299e:	ff 75 a8             	pushl  -0x58(%ebp)
  8029a1:	e8 ee f6 ff ff       	call   802094 <get_block_size>
  8029a6:	83 c4 10             	add    $0x10,%esp
  8029a9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	83 c0 08             	add    $0x8,%eax
  8029b2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029b5:	0f 87 ef 00 00 00    	ja     802aaa <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	83 c0 18             	add    $0x18,%eax
  8029c1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029c4:	77 1d                	ja     8029e3 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8029c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029cc:	0f 86 d8 00 00 00    	jbe    802aaa <alloc_block_BF+0x1da>
				{
					best_va = va;
  8029d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8029d8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029de:	e9 c7 00 00 00       	jmp    802aaa <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	83 c0 08             	add    $0x8,%eax
  8029e9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029ec:	0f 85 9d 00 00 00    	jne    802a8f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8029f2:	83 ec 04             	sub    $0x4,%esp
  8029f5:	6a 01                	push   $0x1
  8029f7:	ff 75 a4             	pushl  -0x5c(%ebp)
  8029fa:	ff 75 a8             	pushl  -0x58(%ebp)
  8029fd:	e8 e3 f9 ff ff       	call   8023e5 <set_block_data>
  802a02:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a09:	75 17                	jne    802a22 <alloc_block_BF+0x152>
  802a0b:	83 ec 04             	sub    $0x4,%esp
  802a0e:	68 c7 46 80 00       	push   $0x8046c7
  802a13:	68 2c 01 00 00       	push   $0x12c
  802a18:	68 e5 46 80 00       	push   $0x8046e5
  802a1d:	e8 2a db ff ff       	call   80054c <_panic>
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	74 10                	je     802a3b <alloc_block_BF+0x16b>
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 00                	mov    (%eax),%eax
  802a30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a33:	8b 52 04             	mov    0x4(%edx),%edx
  802a36:	89 50 04             	mov    %edx,0x4(%eax)
  802a39:	eb 0b                	jmp    802a46 <alloc_block_BF+0x176>
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 40 04             	mov    0x4(%eax),%eax
  802a41:	a3 30 50 80 00       	mov    %eax,0x805030
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 40 04             	mov    0x4(%eax),%eax
  802a4c:	85 c0                	test   %eax,%eax
  802a4e:	74 0f                	je     802a5f <alloc_block_BF+0x18f>
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	8b 40 04             	mov    0x4(%eax),%eax
  802a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a59:	8b 12                	mov    (%edx),%edx
  802a5b:	89 10                	mov    %edx,(%eax)
  802a5d:	eb 0a                	jmp    802a69 <alloc_block_BF+0x199>
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 00                	mov    (%eax),%eax
  802a64:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7c:	a1 38 50 80 00       	mov    0x805038,%eax
  802a81:	48                   	dec    %eax
  802a82:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802a87:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a8a:	e9 24 04 00 00       	jmp    802eb3 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a92:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a95:	76 13                	jbe    802aaa <alloc_block_BF+0x1da>
					{
						internal = 1;
  802a97:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802a9e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802aa4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802aa7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802aaa:	a1 34 50 80 00       	mov    0x805034,%eax
  802aaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab6:	74 07                	je     802abf <alloc_block_BF+0x1ef>
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 00                	mov    (%eax),%eax
  802abd:	eb 05                	jmp    802ac4 <alloc_block_BF+0x1f4>
  802abf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac4:	a3 34 50 80 00       	mov    %eax,0x805034
  802ac9:	a1 34 50 80 00       	mov    0x805034,%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	0f 85 bf fe ff ff    	jne    802995 <alloc_block_BF+0xc5>
  802ad6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ada:	0f 85 b5 fe ff ff    	jne    802995 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802ae0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae4:	0f 84 26 02 00 00    	je     802d10 <alloc_block_BF+0x440>
  802aea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aee:	0f 85 1c 02 00 00    	jne    802d10 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802af4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af7:	2b 45 08             	sub    0x8(%ebp),%eax
  802afa:	83 e8 08             	sub    $0x8,%eax
  802afd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	8d 50 08             	lea    0x8(%eax),%edx
  802b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b09:	01 d0                	add    %edx,%eax
  802b0b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	83 c0 08             	add    $0x8,%eax
  802b14:	83 ec 04             	sub    $0x4,%esp
  802b17:	6a 01                	push   $0x1
  802b19:	50                   	push   %eax
  802b1a:	ff 75 f0             	pushl  -0x10(%ebp)
  802b1d:	e8 c3 f8 ff ff       	call   8023e5 <set_block_data>
  802b22:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b28:	8b 40 04             	mov    0x4(%eax),%eax
  802b2b:	85 c0                	test   %eax,%eax
  802b2d:	75 68                	jne    802b97 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b2f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b33:	75 17                	jne    802b4c <alloc_block_BF+0x27c>
  802b35:	83 ec 04             	sub    $0x4,%esp
  802b38:	68 00 47 80 00       	push   $0x804700
  802b3d:	68 45 01 00 00       	push   $0x145
  802b42:	68 e5 46 80 00       	push   $0x8046e5
  802b47:	e8 00 da ff ff       	call   80054c <_panic>
  802b4c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b52:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b55:	89 10                	mov    %edx,(%eax)
  802b57:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b5a:	8b 00                	mov    (%eax),%eax
  802b5c:	85 c0                	test   %eax,%eax
  802b5e:	74 0d                	je     802b6d <alloc_block_BF+0x29d>
  802b60:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b65:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b68:	89 50 04             	mov    %edx,0x4(%eax)
  802b6b:	eb 08                	jmp    802b75 <alloc_block_BF+0x2a5>
  802b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b70:	a3 30 50 80 00       	mov    %eax,0x805030
  802b75:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b78:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b87:	a1 38 50 80 00       	mov    0x805038,%eax
  802b8c:	40                   	inc    %eax
  802b8d:	a3 38 50 80 00       	mov    %eax,0x805038
  802b92:	e9 dc 00 00 00       	jmp    802c73 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	75 65                	jne    802c05 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ba0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ba4:	75 17                	jne    802bbd <alloc_block_BF+0x2ed>
  802ba6:	83 ec 04             	sub    $0x4,%esp
  802ba9:	68 34 47 80 00       	push   $0x804734
  802bae:	68 4a 01 00 00       	push   $0x14a
  802bb3:	68 e5 46 80 00       	push   $0x8046e5
  802bb8:	e8 8f d9 ff ff       	call   80054c <_panic>
  802bbd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802bc3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bc6:	89 50 04             	mov    %edx,0x4(%eax)
  802bc9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bcc:	8b 40 04             	mov    0x4(%eax),%eax
  802bcf:	85 c0                	test   %eax,%eax
  802bd1:	74 0c                	je     802bdf <alloc_block_BF+0x30f>
  802bd3:	a1 30 50 80 00       	mov    0x805030,%eax
  802bd8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bdb:	89 10                	mov    %edx,(%eax)
  802bdd:	eb 08                	jmp    802be7 <alloc_block_BF+0x317>
  802bdf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802be7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bea:	a3 30 50 80 00       	mov    %eax,0x805030
  802bef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf8:	a1 38 50 80 00       	mov    0x805038,%eax
  802bfd:	40                   	inc    %eax
  802bfe:	a3 38 50 80 00       	mov    %eax,0x805038
  802c03:	eb 6e                	jmp    802c73 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c09:	74 06                	je     802c11 <alloc_block_BF+0x341>
  802c0b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c0f:	75 17                	jne    802c28 <alloc_block_BF+0x358>
  802c11:	83 ec 04             	sub    $0x4,%esp
  802c14:	68 58 47 80 00       	push   $0x804758
  802c19:	68 4f 01 00 00       	push   $0x14f
  802c1e:	68 e5 46 80 00       	push   $0x8046e5
  802c23:	e8 24 d9 ff ff       	call   80054c <_panic>
  802c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2b:	8b 10                	mov    (%eax),%edx
  802c2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c30:	89 10                	mov    %edx,(%eax)
  802c32:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	85 c0                	test   %eax,%eax
  802c39:	74 0b                	je     802c46 <alloc_block_BF+0x376>
  802c3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c43:	89 50 04             	mov    %edx,0x4(%eax)
  802c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c49:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c4c:	89 10                	mov    %edx,(%eax)
  802c4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c54:	89 50 04             	mov    %edx,0x4(%eax)
  802c57:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c5a:	8b 00                	mov    (%eax),%eax
  802c5c:	85 c0                	test   %eax,%eax
  802c5e:	75 08                	jne    802c68 <alloc_block_BF+0x398>
  802c60:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c63:	a3 30 50 80 00       	mov    %eax,0x805030
  802c68:	a1 38 50 80 00       	mov    0x805038,%eax
  802c6d:	40                   	inc    %eax
  802c6e:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c77:	75 17                	jne    802c90 <alloc_block_BF+0x3c0>
  802c79:	83 ec 04             	sub    $0x4,%esp
  802c7c:	68 c7 46 80 00       	push   $0x8046c7
  802c81:	68 51 01 00 00       	push   $0x151
  802c86:	68 e5 46 80 00       	push   $0x8046e5
  802c8b:	e8 bc d8 ff ff       	call   80054c <_panic>
  802c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	85 c0                	test   %eax,%eax
  802c97:	74 10                	je     802ca9 <alloc_block_BF+0x3d9>
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca1:	8b 52 04             	mov    0x4(%edx),%edx
  802ca4:	89 50 04             	mov    %edx,0x4(%eax)
  802ca7:	eb 0b                	jmp    802cb4 <alloc_block_BF+0x3e4>
  802ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cac:	8b 40 04             	mov    0x4(%eax),%eax
  802caf:	a3 30 50 80 00       	mov    %eax,0x805030
  802cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb7:	8b 40 04             	mov    0x4(%eax),%eax
  802cba:	85 c0                	test   %eax,%eax
  802cbc:	74 0f                	je     802ccd <alloc_block_BF+0x3fd>
  802cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc1:	8b 40 04             	mov    0x4(%eax),%eax
  802cc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc7:	8b 12                	mov    (%edx),%edx
  802cc9:	89 10                	mov    %edx,(%eax)
  802ccb:	eb 0a                	jmp    802cd7 <alloc_block_BF+0x407>
  802ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd0:	8b 00                	mov    (%eax),%eax
  802cd2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cea:	a1 38 50 80 00       	mov    0x805038,%eax
  802cef:	48                   	dec    %eax
  802cf0:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802cf5:	83 ec 04             	sub    $0x4,%esp
  802cf8:	6a 00                	push   $0x0
  802cfa:	ff 75 d0             	pushl  -0x30(%ebp)
  802cfd:	ff 75 cc             	pushl  -0x34(%ebp)
  802d00:	e8 e0 f6 ff ff       	call   8023e5 <set_block_data>
  802d05:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0b:	e9 a3 01 00 00       	jmp    802eb3 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d10:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d14:	0f 85 9d 00 00 00    	jne    802db7 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d1a:	83 ec 04             	sub    $0x4,%esp
  802d1d:	6a 01                	push   $0x1
  802d1f:	ff 75 ec             	pushl  -0x14(%ebp)
  802d22:	ff 75 f0             	pushl  -0x10(%ebp)
  802d25:	e8 bb f6 ff ff       	call   8023e5 <set_block_data>
  802d2a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d31:	75 17                	jne    802d4a <alloc_block_BF+0x47a>
  802d33:	83 ec 04             	sub    $0x4,%esp
  802d36:	68 c7 46 80 00       	push   $0x8046c7
  802d3b:	68 58 01 00 00       	push   $0x158
  802d40:	68 e5 46 80 00       	push   $0x8046e5
  802d45:	e8 02 d8 ff ff       	call   80054c <_panic>
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	85 c0                	test   %eax,%eax
  802d51:	74 10                	je     802d63 <alloc_block_BF+0x493>
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5b:	8b 52 04             	mov    0x4(%edx),%edx
  802d5e:	89 50 04             	mov    %edx,0x4(%eax)
  802d61:	eb 0b                	jmp    802d6e <alloc_block_BF+0x49e>
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	8b 40 04             	mov    0x4(%eax),%eax
  802d69:	a3 30 50 80 00       	mov    %eax,0x805030
  802d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d71:	8b 40 04             	mov    0x4(%eax),%eax
  802d74:	85 c0                	test   %eax,%eax
  802d76:	74 0f                	je     802d87 <alloc_block_BF+0x4b7>
  802d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7b:	8b 40 04             	mov    0x4(%eax),%eax
  802d7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d81:	8b 12                	mov    (%edx),%edx
  802d83:	89 10                	mov    %edx,(%eax)
  802d85:	eb 0a                	jmp    802d91 <alloc_block_BF+0x4c1>
  802d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8a:	8b 00                	mov    (%eax),%eax
  802d8c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da4:	a1 38 50 80 00       	mov    0x805038,%eax
  802da9:	48                   	dec    %eax
  802daa:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db2:	e9 fc 00 00 00       	jmp    802eb3 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	83 c0 08             	add    $0x8,%eax
  802dbd:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802dc0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802dc7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dca:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802dcd:	01 d0                	add    %edx,%eax
  802dcf:	48                   	dec    %eax
  802dd0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802dd3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802dd6:	ba 00 00 00 00       	mov    $0x0,%edx
  802ddb:	f7 75 c4             	divl   -0x3c(%ebp)
  802dde:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802de1:	29 d0                	sub    %edx,%eax
  802de3:	c1 e8 0c             	shr    $0xc,%eax
  802de6:	83 ec 0c             	sub    $0xc,%esp
  802de9:	50                   	push   %eax
  802dea:	e8 b4 e7 ff ff       	call   8015a3 <sbrk>
  802def:	83 c4 10             	add    $0x10,%esp
  802df2:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802df5:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802df9:	75 0a                	jne    802e05 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  802e00:	e9 ae 00 00 00       	jmp    802eb3 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e05:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e0c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e0f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e12:	01 d0                	add    %edx,%eax
  802e14:	48                   	dec    %eax
  802e15:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e18:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e1b:	ba 00 00 00 00       	mov    $0x0,%edx
  802e20:	f7 75 b8             	divl   -0x48(%ebp)
  802e23:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e26:	29 d0                	sub    %edx,%eax
  802e28:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e2b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e2e:	01 d0                	add    %edx,%eax
  802e30:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e35:	a1 40 50 80 00       	mov    0x805040,%eax
  802e3a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e40:	83 ec 0c             	sub    $0xc,%esp
  802e43:	68 8c 47 80 00       	push   $0x80478c
  802e48:	e8 bc d9 ff ff       	call   800809 <cprintf>
  802e4d:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e50:	83 ec 08             	sub    $0x8,%esp
  802e53:	ff 75 bc             	pushl  -0x44(%ebp)
  802e56:	68 91 47 80 00       	push   $0x804791
  802e5b:	e8 a9 d9 ff ff       	call   800809 <cprintf>
  802e60:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e63:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e6a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e6d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e70:	01 d0                	add    %edx,%eax
  802e72:	48                   	dec    %eax
  802e73:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e76:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e79:	ba 00 00 00 00       	mov    $0x0,%edx
  802e7e:	f7 75 b0             	divl   -0x50(%ebp)
  802e81:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e84:	29 d0                	sub    %edx,%eax
  802e86:	83 ec 04             	sub    $0x4,%esp
  802e89:	6a 01                	push   $0x1
  802e8b:	50                   	push   %eax
  802e8c:	ff 75 bc             	pushl  -0x44(%ebp)
  802e8f:	e8 51 f5 ff ff       	call   8023e5 <set_block_data>
  802e94:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802e97:	83 ec 0c             	sub    $0xc,%esp
  802e9a:	ff 75 bc             	pushl  -0x44(%ebp)
  802e9d:	e8 36 04 00 00       	call   8032d8 <free_block>
  802ea2:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ea5:	83 ec 0c             	sub    $0xc,%esp
  802ea8:	ff 75 08             	pushl  0x8(%ebp)
  802eab:	e8 20 fa ff ff       	call   8028d0 <alloc_block_BF>
  802eb0:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802eb3:	c9                   	leave  
  802eb4:	c3                   	ret    

00802eb5 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802eb5:	55                   	push   %ebp
  802eb6:	89 e5                	mov    %esp,%ebp
  802eb8:	53                   	push   %ebx
  802eb9:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ebc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ec3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802eca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ece:	74 1e                	je     802eee <merging+0x39>
  802ed0:	ff 75 08             	pushl  0x8(%ebp)
  802ed3:	e8 bc f1 ff ff       	call   802094 <get_block_size>
  802ed8:	83 c4 04             	add    $0x4,%esp
  802edb:	89 c2                	mov    %eax,%edx
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	01 d0                	add    %edx,%eax
  802ee2:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ee5:	75 07                	jne    802eee <merging+0x39>
		prev_is_free = 1;
  802ee7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802eee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ef2:	74 1e                	je     802f12 <merging+0x5d>
  802ef4:	ff 75 10             	pushl  0x10(%ebp)
  802ef7:	e8 98 f1 ff ff       	call   802094 <get_block_size>
  802efc:	83 c4 04             	add    $0x4,%esp
  802eff:	89 c2                	mov    %eax,%edx
  802f01:	8b 45 10             	mov    0x10(%ebp),%eax
  802f04:	01 d0                	add    %edx,%eax
  802f06:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f09:	75 07                	jne    802f12 <merging+0x5d>
		next_is_free = 1;
  802f0b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f16:	0f 84 cc 00 00 00    	je     802fe8 <merging+0x133>
  802f1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f20:	0f 84 c2 00 00 00    	je     802fe8 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f26:	ff 75 08             	pushl  0x8(%ebp)
  802f29:	e8 66 f1 ff ff       	call   802094 <get_block_size>
  802f2e:	83 c4 04             	add    $0x4,%esp
  802f31:	89 c3                	mov    %eax,%ebx
  802f33:	ff 75 10             	pushl  0x10(%ebp)
  802f36:	e8 59 f1 ff ff       	call   802094 <get_block_size>
  802f3b:	83 c4 04             	add    $0x4,%esp
  802f3e:	01 c3                	add    %eax,%ebx
  802f40:	ff 75 0c             	pushl  0xc(%ebp)
  802f43:	e8 4c f1 ff ff       	call   802094 <get_block_size>
  802f48:	83 c4 04             	add    $0x4,%esp
  802f4b:	01 d8                	add    %ebx,%eax
  802f4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f50:	6a 00                	push   $0x0
  802f52:	ff 75 ec             	pushl  -0x14(%ebp)
  802f55:	ff 75 08             	pushl  0x8(%ebp)
  802f58:	e8 88 f4 ff ff       	call   8023e5 <set_block_data>
  802f5d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f64:	75 17                	jne    802f7d <merging+0xc8>
  802f66:	83 ec 04             	sub    $0x4,%esp
  802f69:	68 c7 46 80 00       	push   $0x8046c7
  802f6e:	68 7d 01 00 00       	push   $0x17d
  802f73:	68 e5 46 80 00       	push   $0x8046e5
  802f78:	e8 cf d5 ff ff       	call   80054c <_panic>
  802f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	85 c0                	test   %eax,%eax
  802f84:	74 10                	je     802f96 <merging+0xe1>
  802f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f8e:	8b 52 04             	mov    0x4(%edx),%edx
  802f91:	89 50 04             	mov    %edx,0x4(%eax)
  802f94:	eb 0b                	jmp    802fa1 <merging+0xec>
  802f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f99:	8b 40 04             	mov    0x4(%eax),%eax
  802f9c:	a3 30 50 80 00       	mov    %eax,0x805030
  802fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa4:	8b 40 04             	mov    0x4(%eax),%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	74 0f                	je     802fba <merging+0x105>
  802fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fae:	8b 40 04             	mov    0x4(%eax),%eax
  802fb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb4:	8b 12                	mov    (%edx),%edx
  802fb6:	89 10                	mov    %edx,(%eax)
  802fb8:	eb 0a                	jmp    802fc4 <merging+0x10f>
  802fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd7:	a1 38 50 80 00       	mov    0x805038,%eax
  802fdc:	48                   	dec    %eax
  802fdd:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802fe2:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fe3:	e9 ea 02 00 00       	jmp    8032d2 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802fe8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fec:	74 3b                	je     803029 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802fee:	83 ec 0c             	sub    $0xc,%esp
  802ff1:	ff 75 08             	pushl  0x8(%ebp)
  802ff4:	e8 9b f0 ff ff       	call   802094 <get_block_size>
  802ff9:	83 c4 10             	add    $0x10,%esp
  802ffc:	89 c3                	mov    %eax,%ebx
  802ffe:	83 ec 0c             	sub    $0xc,%esp
  803001:	ff 75 10             	pushl  0x10(%ebp)
  803004:	e8 8b f0 ff ff       	call   802094 <get_block_size>
  803009:	83 c4 10             	add    $0x10,%esp
  80300c:	01 d8                	add    %ebx,%eax
  80300e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803011:	83 ec 04             	sub    $0x4,%esp
  803014:	6a 00                	push   $0x0
  803016:	ff 75 e8             	pushl  -0x18(%ebp)
  803019:	ff 75 08             	pushl  0x8(%ebp)
  80301c:	e8 c4 f3 ff ff       	call   8023e5 <set_block_data>
  803021:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803024:	e9 a9 02 00 00       	jmp    8032d2 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803029:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80302d:	0f 84 2d 01 00 00    	je     803160 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803033:	83 ec 0c             	sub    $0xc,%esp
  803036:	ff 75 10             	pushl  0x10(%ebp)
  803039:	e8 56 f0 ff ff       	call   802094 <get_block_size>
  80303e:	83 c4 10             	add    $0x10,%esp
  803041:	89 c3                	mov    %eax,%ebx
  803043:	83 ec 0c             	sub    $0xc,%esp
  803046:	ff 75 0c             	pushl  0xc(%ebp)
  803049:	e8 46 f0 ff ff       	call   802094 <get_block_size>
  80304e:	83 c4 10             	add    $0x10,%esp
  803051:	01 d8                	add    %ebx,%eax
  803053:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803056:	83 ec 04             	sub    $0x4,%esp
  803059:	6a 00                	push   $0x0
  80305b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80305e:	ff 75 10             	pushl  0x10(%ebp)
  803061:	e8 7f f3 ff ff       	call   8023e5 <set_block_data>
  803066:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803069:	8b 45 10             	mov    0x10(%ebp),%eax
  80306c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80306f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803073:	74 06                	je     80307b <merging+0x1c6>
  803075:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803079:	75 17                	jne    803092 <merging+0x1dd>
  80307b:	83 ec 04             	sub    $0x4,%esp
  80307e:	68 a0 47 80 00       	push   $0x8047a0
  803083:	68 8d 01 00 00       	push   $0x18d
  803088:	68 e5 46 80 00       	push   $0x8046e5
  80308d:	e8 ba d4 ff ff       	call   80054c <_panic>
  803092:	8b 45 0c             	mov    0xc(%ebp),%eax
  803095:	8b 50 04             	mov    0x4(%eax),%edx
  803098:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80309b:	89 50 04             	mov    %edx,0x4(%eax)
  80309e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030a4:	89 10                	mov    %edx,(%eax)
  8030a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030a9:	8b 40 04             	mov    0x4(%eax),%eax
  8030ac:	85 c0                	test   %eax,%eax
  8030ae:	74 0d                	je     8030bd <merging+0x208>
  8030b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b3:	8b 40 04             	mov    0x4(%eax),%eax
  8030b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030b9:	89 10                	mov    %edx,(%eax)
  8030bb:	eb 08                	jmp    8030c5 <merging+0x210>
  8030bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030cb:	89 50 04             	mov    %edx,0x4(%eax)
  8030ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8030d3:	40                   	inc    %eax
  8030d4:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8030d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030dd:	75 17                	jne    8030f6 <merging+0x241>
  8030df:	83 ec 04             	sub    $0x4,%esp
  8030e2:	68 c7 46 80 00       	push   $0x8046c7
  8030e7:	68 8e 01 00 00       	push   $0x18e
  8030ec:	68 e5 46 80 00       	push   $0x8046e5
  8030f1:	e8 56 d4 ff ff       	call   80054c <_panic>
  8030f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 10                	je     80310f <merging+0x25a>
  8030ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803102:	8b 00                	mov    (%eax),%eax
  803104:	8b 55 0c             	mov    0xc(%ebp),%edx
  803107:	8b 52 04             	mov    0x4(%edx),%edx
  80310a:	89 50 04             	mov    %edx,0x4(%eax)
  80310d:	eb 0b                	jmp    80311a <merging+0x265>
  80310f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803112:	8b 40 04             	mov    0x4(%eax),%eax
  803115:	a3 30 50 80 00       	mov    %eax,0x805030
  80311a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311d:	8b 40 04             	mov    0x4(%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0f                	je     803133 <merging+0x27e>
  803124:	8b 45 0c             	mov    0xc(%ebp),%eax
  803127:	8b 40 04             	mov    0x4(%eax),%eax
  80312a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80312d:	8b 12                	mov    (%edx),%edx
  80312f:	89 10                	mov    %edx,(%eax)
  803131:	eb 0a                	jmp    80313d <merging+0x288>
  803133:	8b 45 0c             	mov    0xc(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80313d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803140:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803146:	8b 45 0c             	mov    0xc(%ebp),%eax
  803149:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803150:	a1 38 50 80 00       	mov    0x805038,%eax
  803155:	48                   	dec    %eax
  803156:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80315b:	e9 72 01 00 00       	jmp    8032d2 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803160:	8b 45 10             	mov    0x10(%ebp),%eax
  803163:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316a:	74 79                	je     8031e5 <merging+0x330>
  80316c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803170:	74 73                	je     8031e5 <merging+0x330>
  803172:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803176:	74 06                	je     80317e <merging+0x2c9>
  803178:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80317c:	75 17                	jne    803195 <merging+0x2e0>
  80317e:	83 ec 04             	sub    $0x4,%esp
  803181:	68 58 47 80 00       	push   $0x804758
  803186:	68 94 01 00 00       	push   $0x194
  80318b:	68 e5 46 80 00       	push   $0x8046e5
  803190:	e8 b7 d3 ff ff       	call   80054c <_panic>
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	8b 10                	mov    (%eax),%edx
  80319a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319d:	89 10                	mov    %edx,(%eax)
  80319f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031a2:	8b 00                	mov    (%eax),%eax
  8031a4:	85 c0                	test   %eax,%eax
  8031a6:	74 0b                	je     8031b3 <merging+0x2fe>
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	8b 00                	mov    (%eax),%eax
  8031ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031b0:	89 50 04             	mov    %edx,0x4(%eax)
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031b9:	89 10                	mov    %edx,(%eax)
  8031bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031be:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c1:	89 50 04             	mov    %edx,0x4(%eax)
  8031c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	75 08                	jne    8031d5 <merging+0x320>
  8031cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d0:	a3 30 50 80 00       	mov    %eax,0x805030
  8031d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8031da:	40                   	inc    %eax
  8031db:	a3 38 50 80 00       	mov    %eax,0x805038
  8031e0:	e9 ce 00 00 00       	jmp    8032b3 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8031e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e9:	74 65                	je     803250 <merging+0x39b>
  8031eb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031ef:	75 17                	jne    803208 <merging+0x353>
  8031f1:	83 ec 04             	sub    $0x4,%esp
  8031f4:	68 34 47 80 00       	push   $0x804734
  8031f9:	68 95 01 00 00       	push   $0x195
  8031fe:	68 e5 46 80 00       	push   $0x8046e5
  803203:	e8 44 d3 ff ff       	call   80054c <_panic>
  803208:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80320e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803211:	89 50 04             	mov    %edx,0x4(%eax)
  803214:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803217:	8b 40 04             	mov    0x4(%eax),%eax
  80321a:	85 c0                	test   %eax,%eax
  80321c:	74 0c                	je     80322a <merging+0x375>
  80321e:	a1 30 50 80 00       	mov    0x805030,%eax
  803223:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803226:	89 10                	mov    %edx,(%eax)
  803228:	eb 08                	jmp    803232 <merging+0x37d>
  80322a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80322d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803232:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803235:	a3 30 50 80 00       	mov    %eax,0x805030
  80323a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803243:	a1 38 50 80 00       	mov    0x805038,%eax
  803248:	40                   	inc    %eax
  803249:	a3 38 50 80 00       	mov    %eax,0x805038
  80324e:	eb 63                	jmp    8032b3 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803250:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803254:	75 17                	jne    80326d <merging+0x3b8>
  803256:	83 ec 04             	sub    $0x4,%esp
  803259:	68 00 47 80 00       	push   $0x804700
  80325e:	68 98 01 00 00       	push   $0x198
  803263:	68 e5 46 80 00       	push   $0x8046e5
  803268:	e8 df d2 ff ff       	call   80054c <_panic>
  80326d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803273:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803276:	89 10                	mov    %edx,(%eax)
  803278:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80327b:	8b 00                	mov    (%eax),%eax
  80327d:	85 c0                	test   %eax,%eax
  80327f:	74 0d                	je     80328e <merging+0x3d9>
  803281:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803286:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803289:	89 50 04             	mov    %edx,0x4(%eax)
  80328c:	eb 08                	jmp    803296 <merging+0x3e1>
  80328e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803291:	a3 30 50 80 00       	mov    %eax,0x805030
  803296:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803299:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80329e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a8:	a1 38 50 80 00       	mov    0x805038,%eax
  8032ad:	40                   	inc    %eax
  8032ae:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8032b3:	83 ec 0c             	sub    $0xc,%esp
  8032b6:	ff 75 10             	pushl  0x10(%ebp)
  8032b9:	e8 d6 ed ff ff       	call   802094 <get_block_size>
  8032be:	83 c4 10             	add    $0x10,%esp
  8032c1:	83 ec 04             	sub    $0x4,%esp
  8032c4:	6a 00                	push   $0x0
  8032c6:	50                   	push   %eax
  8032c7:	ff 75 10             	pushl  0x10(%ebp)
  8032ca:	e8 16 f1 ff ff       	call   8023e5 <set_block_data>
  8032cf:	83 c4 10             	add    $0x10,%esp
	}
}
  8032d2:	90                   	nop
  8032d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032d6:	c9                   	leave  
  8032d7:	c3                   	ret    

008032d8 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8032d8:	55                   	push   %ebp
  8032d9:	89 e5                	mov    %esp,%ebp
  8032db:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8032de:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032e3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8032e6:	a1 30 50 80 00       	mov    0x805030,%eax
  8032eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032ee:	73 1b                	jae    80330b <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8032f0:	a1 30 50 80 00       	mov    0x805030,%eax
  8032f5:	83 ec 04             	sub    $0x4,%esp
  8032f8:	ff 75 08             	pushl  0x8(%ebp)
  8032fb:	6a 00                	push   $0x0
  8032fd:	50                   	push   %eax
  8032fe:	e8 b2 fb ff ff       	call   802eb5 <merging>
  803303:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803306:	e9 8b 00 00 00       	jmp    803396 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80330b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803310:	3b 45 08             	cmp    0x8(%ebp),%eax
  803313:	76 18                	jbe    80332d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803315:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80331a:	83 ec 04             	sub    $0x4,%esp
  80331d:	ff 75 08             	pushl  0x8(%ebp)
  803320:	50                   	push   %eax
  803321:	6a 00                	push   $0x0
  803323:	e8 8d fb ff ff       	call   802eb5 <merging>
  803328:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80332b:	eb 69                	jmp    803396 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80332d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803335:	eb 39                	jmp    803370 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80333d:	73 29                	jae    803368 <free_block+0x90>
  80333f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803342:	8b 00                	mov    (%eax),%eax
  803344:	3b 45 08             	cmp    0x8(%ebp),%eax
  803347:	76 1f                	jbe    803368 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803351:	83 ec 04             	sub    $0x4,%esp
  803354:	ff 75 08             	pushl  0x8(%ebp)
  803357:	ff 75 f0             	pushl  -0x10(%ebp)
  80335a:	ff 75 f4             	pushl  -0xc(%ebp)
  80335d:	e8 53 fb ff ff       	call   802eb5 <merging>
  803362:	83 c4 10             	add    $0x10,%esp
			break;
  803365:	90                   	nop
		}
	}
}
  803366:	eb 2e                	jmp    803396 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803368:	a1 34 50 80 00       	mov    0x805034,%eax
  80336d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803370:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803374:	74 07                	je     80337d <free_block+0xa5>
  803376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803379:	8b 00                	mov    (%eax),%eax
  80337b:	eb 05                	jmp    803382 <free_block+0xaa>
  80337d:	b8 00 00 00 00       	mov    $0x0,%eax
  803382:	a3 34 50 80 00       	mov    %eax,0x805034
  803387:	a1 34 50 80 00       	mov    0x805034,%eax
  80338c:	85 c0                	test   %eax,%eax
  80338e:	75 a7                	jne    803337 <free_block+0x5f>
  803390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803394:	75 a1                	jne    803337 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803396:	90                   	nop
  803397:	c9                   	leave  
  803398:	c3                   	ret    

00803399 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803399:	55                   	push   %ebp
  80339a:	89 e5                	mov    %esp,%ebp
  80339c:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80339f:	ff 75 08             	pushl  0x8(%ebp)
  8033a2:	e8 ed ec ff ff       	call   802094 <get_block_size>
  8033a7:	83 c4 04             	add    $0x4,%esp
  8033aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8033ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033b4:	eb 17                	jmp    8033cd <copy_data+0x34>
  8033b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bc:	01 c2                	add    %eax,%edx
  8033be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8033c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c4:	01 c8                	add    %ecx,%eax
  8033c6:	8a 00                	mov    (%eax),%al
  8033c8:	88 02                	mov    %al,(%edx)
  8033ca:	ff 45 fc             	incl   -0x4(%ebp)
  8033cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8033d3:	72 e1                	jb     8033b6 <copy_data+0x1d>
}
  8033d5:	90                   	nop
  8033d6:	c9                   	leave  
  8033d7:	c3                   	ret    

008033d8 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8033d8:	55                   	push   %ebp
  8033d9:	89 e5                	mov    %esp,%ebp
  8033db:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8033de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e2:	75 23                	jne    803407 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8033e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033e8:	74 13                	je     8033fd <realloc_block_FF+0x25>
  8033ea:	83 ec 0c             	sub    $0xc,%esp
  8033ed:	ff 75 0c             	pushl  0xc(%ebp)
  8033f0:	e8 1f f0 ff ff       	call   802414 <alloc_block_FF>
  8033f5:	83 c4 10             	add    $0x10,%esp
  8033f8:	e9 f4 06 00 00       	jmp    803af1 <realloc_block_FF+0x719>
		return NULL;
  8033fd:	b8 00 00 00 00       	mov    $0x0,%eax
  803402:	e9 ea 06 00 00       	jmp    803af1 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803407:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80340b:	75 18                	jne    803425 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80340d:	83 ec 0c             	sub    $0xc,%esp
  803410:	ff 75 08             	pushl  0x8(%ebp)
  803413:	e8 c0 fe ff ff       	call   8032d8 <free_block>
  803418:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80341b:	b8 00 00 00 00       	mov    $0x0,%eax
  803420:	e9 cc 06 00 00       	jmp    803af1 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803425:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803429:	77 07                	ja     803432 <realloc_block_FF+0x5a>
  80342b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803432:	8b 45 0c             	mov    0xc(%ebp),%eax
  803435:	83 e0 01             	and    $0x1,%eax
  803438:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80343b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80343e:	83 c0 08             	add    $0x8,%eax
  803441:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803444:	83 ec 0c             	sub    $0xc,%esp
  803447:	ff 75 08             	pushl  0x8(%ebp)
  80344a:	e8 45 ec ff ff       	call   802094 <get_block_size>
  80344f:	83 c4 10             	add    $0x10,%esp
  803452:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803455:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803458:	83 e8 08             	sub    $0x8,%eax
  80345b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80345e:	8b 45 08             	mov    0x8(%ebp),%eax
  803461:	83 e8 04             	sub    $0x4,%eax
  803464:	8b 00                	mov    (%eax),%eax
  803466:	83 e0 fe             	and    $0xfffffffe,%eax
  803469:	89 c2                	mov    %eax,%edx
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	01 d0                	add    %edx,%eax
  803470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803473:	83 ec 0c             	sub    $0xc,%esp
  803476:	ff 75 e4             	pushl  -0x1c(%ebp)
  803479:	e8 16 ec ff ff       	call   802094 <get_block_size>
  80347e:	83 c4 10             	add    $0x10,%esp
  803481:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803484:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803487:	83 e8 08             	sub    $0x8,%eax
  80348a:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80348d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803490:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803493:	75 08                	jne    80349d <realloc_block_FF+0xc5>
	{
		 return va;
  803495:	8b 45 08             	mov    0x8(%ebp),%eax
  803498:	e9 54 06 00 00       	jmp    803af1 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80349d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034a3:	0f 83 e5 03 00 00    	jae    80388e <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ac:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034af:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034b2:	83 ec 0c             	sub    $0xc,%esp
  8034b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034b8:	e8 f0 eb ff ff       	call   8020ad <is_free_block>
  8034bd:	83 c4 10             	add    $0x10,%esp
  8034c0:	84 c0                	test   %al,%al
  8034c2:	0f 84 3b 01 00 00    	je     803603 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8034c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034ce:	01 d0                	add    %edx,%eax
  8034d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8034d3:	83 ec 04             	sub    $0x4,%esp
  8034d6:	6a 01                	push   $0x1
  8034d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8034db:	ff 75 08             	pushl  0x8(%ebp)
  8034de:	e8 02 ef ff ff       	call   8023e5 <set_block_data>
  8034e3:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8034e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e9:	83 e8 04             	sub    $0x4,%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	83 e0 fe             	and    $0xfffffffe,%eax
  8034f1:	89 c2                	mov    %eax,%edx
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	01 d0                	add    %edx,%eax
  8034f8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8034fb:	83 ec 04             	sub    $0x4,%esp
  8034fe:	6a 00                	push   $0x0
  803500:	ff 75 cc             	pushl  -0x34(%ebp)
  803503:	ff 75 c8             	pushl  -0x38(%ebp)
  803506:	e8 da ee ff ff       	call   8023e5 <set_block_data>
  80350b:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80350e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803512:	74 06                	je     80351a <realloc_block_FF+0x142>
  803514:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803518:	75 17                	jne    803531 <realloc_block_FF+0x159>
  80351a:	83 ec 04             	sub    $0x4,%esp
  80351d:	68 58 47 80 00       	push   $0x804758
  803522:	68 f6 01 00 00       	push   $0x1f6
  803527:	68 e5 46 80 00       	push   $0x8046e5
  80352c:	e8 1b d0 ff ff       	call   80054c <_panic>
  803531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803534:	8b 10                	mov    (%eax),%edx
  803536:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803539:	89 10                	mov    %edx,(%eax)
  80353b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80353e:	8b 00                	mov    (%eax),%eax
  803540:	85 c0                	test   %eax,%eax
  803542:	74 0b                	je     80354f <realloc_block_FF+0x177>
  803544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803547:	8b 00                	mov    (%eax),%eax
  803549:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80354c:	89 50 04             	mov    %edx,0x4(%eax)
  80354f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803552:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803555:	89 10                	mov    %edx,(%eax)
  803557:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80355a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80355d:	89 50 04             	mov    %edx,0x4(%eax)
  803560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803563:	8b 00                	mov    (%eax),%eax
  803565:	85 c0                	test   %eax,%eax
  803567:	75 08                	jne    803571 <realloc_block_FF+0x199>
  803569:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80356c:	a3 30 50 80 00       	mov    %eax,0x805030
  803571:	a1 38 50 80 00       	mov    0x805038,%eax
  803576:	40                   	inc    %eax
  803577:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80357c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803580:	75 17                	jne    803599 <realloc_block_FF+0x1c1>
  803582:	83 ec 04             	sub    $0x4,%esp
  803585:	68 c7 46 80 00       	push   $0x8046c7
  80358a:	68 f7 01 00 00       	push   $0x1f7
  80358f:	68 e5 46 80 00       	push   $0x8046e5
  803594:	e8 b3 cf ff ff       	call   80054c <_panic>
  803599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359c:	8b 00                	mov    (%eax),%eax
  80359e:	85 c0                	test   %eax,%eax
  8035a0:	74 10                	je     8035b2 <realloc_block_FF+0x1da>
  8035a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a5:	8b 00                	mov    (%eax),%eax
  8035a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035aa:	8b 52 04             	mov    0x4(%edx),%edx
  8035ad:	89 50 04             	mov    %edx,0x4(%eax)
  8035b0:	eb 0b                	jmp    8035bd <realloc_block_FF+0x1e5>
  8035b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b5:	8b 40 04             	mov    0x4(%eax),%eax
  8035b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8035bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c0:	8b 40 04             	mov    0x4(%eax),%eax
  8035c3:	85 c0                	test   %eax,%eax
  8035c5:	74 0f                	je     8035d6 <realloc_block_FF+0x1fe>
  8035c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ca:	8b 40 04             	mov    0x4(%eax),%eax
  8035cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d0:	8b 12                	mov    (%edx),%edx
  8035d2:	89 10                	mov    %edx,(%eax)
  8035d4:	eb 0a                	jmp    8035e0 <realloc_block_FF+0x208>
  8035d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d9:	8b 00                	mov    (%eax),%eax
  8035db:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f8:	48                   	dec    %eax
  8035f9:	a3 38 50 80 00       	mov    %eax,0x805038
  8035fe:	e9 83 02 00 00       	jmp    803886 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803603:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803607:	0f 86 69 02 00 00    	jbe    803876 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80360d:	83 ec 04             	sub    $0x4,%esp
  803610:	6a 01                	push   $0x1
  803612:	ff 75 f0             	pushl  -0x10(%ebp)
  803615:	ff 75 08             	pushl  0x8(%ebp)
  803618:	e8 c8 ed ff ff       	call   8023e5 <set_block_data>
  80361d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803620:	8b 45 08             	mov    0x8(%ebp),%eax
  803623:	83 e8 04             	sub    $0x4,%eax
  803626:	8b 00                	mov    (%eax),%eax
  803628:	83 e0 fe             	and    $0xfffffffe,%eax
  80362b:	89 c2                	mov    %eax,%edx
  80362d:	8b 45 08             	mov    0x8(%ebp),%eax
  803630:	01 d0                	add    %edx,%eax
  803632:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803635:	a1 38 50 80 00       	mov    0x805038,%eax
  80363a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80363d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803641:	75 68                	jne    8036ab <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803643:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803647:	75 17                	jne    803660 <realloc_block_FF+0x288>
  803649:	83 ec 04             	sub    $0x4,%esp
  80364c:	68 00 47 80 00       	push   $0x804700
  803651:	68 06 02 00 00       	push   $0x206
  803656:	68 e5 46 80 00       	push   $0x8046e5
  80365b:	e8 ec ce ff ff       	call   80054c <_panic>
  803660:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803666:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803669:	89 10                	mov    %edx,(%eax)
  80366b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366e:	8b 00                	mov    (%eax),%eax
  803670:	85 c0                	test   %eax,%eax
  803672:	74 0d                	je     803681 <realloc_block_FF+0x2a9>
  803674:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803679:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80367c:	89 50 04             	mov    %edx,0x4(%eax)
  80367f:	eb 08                	jmp    803689 <realloc_block_FF+0x2b1>
  803681:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803684:	a3 30 50 80 00       	mov    %eax,0x805030
  803689:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803691:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803694:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80369b:	a1 38 50 80 00       	mov    0x805038,%eax
  8036a0:	40                   	inc    %eax
  8036a1:	a3 38 50 80 00       	mov    %eax,0x805038
  8036a6:	e9 b0 01 00 00       	jmp    80385b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8036ab:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036b0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036b3:	76 68                	jbe    80371d <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036b9:	75 17                	jne    8036d2 <realloc_block_FF+0x2fa>
  8036bb:	83 ec 04             	sub    $0x4,%esp
  8036be:	68 00 47 80 00       	push   $0x804700
  8036c3:	68 0b 02 00 00       	push   $0x20b
  8036c8:	68 e5 46 80 00       	push   $0x8046e5
  8036cd:	e8 7a ce ff ff       	call   80054c <_panic>
  8036d2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036db:	89 10                	mov    %edx,(%eax)
  8036dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e0:	8b 00                	mov    (%eax),%eax
  8036e2:	85 c0                	test   %eax,%eax
  8036e4:	74 0d                	je     8036f3 <realloc_block_FF+0x31b>
  8036e6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036ee:	89 50 04             	mov    %edx,0x4(%eax)
  8036f1:	eb 08                	jmp    8036fb <realloc_block_FF+0x323>
  8036f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f6:	a3 30 50 80 00       	mov    %eax,0x805030
  8036fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803703:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803706:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80370d:	a1 38 50 80 00       	mov    0x805038,%eax
  803712:	40                   	inc    %eax
  803713:	a3 38 50 80 00       	mov    %eax,0x805038
  803718:	e9 3e 01 00 00       	jmp    80385b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80371d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803722:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803725:	73 68                	jae    80378f <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803727:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80372b:	75 17                	jne    803744 <realloc_block_FF+0x36c>
  80372d:	83 ec 04             	sub    $0x4,%esp
  803730:	68 34 47 80 00       	push   $0x804734
  803735:	68 10 02 00 00       	push   $0x210
  80373a:	68 e5 46 80 00       	push   $0x8046e5
  80373f:	e8 08 ce ff ff       	call   80054c <_panic>
  803744:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80374a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80374d:	89 50 04             	mov    %edx,0x4(%eax)
  803750:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803753:	8b 40 04             	mov    0x4(%eax),%eax
  803756:	85 c0                	test   %eax,%eax
  803758:	74 0c                	je     803766 <realloc_block_FF+0x38e>
  80375a:	a1 30 50 80 00       	mov    0x805030,%eax
  80375f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803762:	89 10                	mov    %edx,(%eax)
  803764:	eb 08                	jmp    80376e <realloc_block_FF+0x396>
  803766:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803769:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80376e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803771:	a3 30 50 80 00       	mov    %eax,0x805030
  803776:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80377f:	a1 38 50 80 00       	mov    0x805038,%eax
  803784:	40                   	inc    %eax
  803785:	a3 38 50 80 00       	mov    %eax,0x805038
  80378a:	e9 cc 00 00 00       	jmp    80385b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80378f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803796:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80379b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80379e:	e9 8a 00 00 00       	jmp    80382d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037a9:	73 7a                	jae    803825 <realloc_block_FF+0x44d>
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	8b 00                	mov    (%eax),%eax
  8037b0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037b3:	73 70                	jae    803825 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b9:	74 06                	je     8037c1 <realloc_block_FF+0x3e9>
  8037bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037bf:	75 17                	jne    8037d8 <realloc_block_FF+0x400>
  8037c1:	83 ec 04             	sub    $0x4,%esp
  8037c4:	68 58 47 80 00       	push   $0x804758
  8037c9:	68 1a 02 00 00       	push   $0x21a
  8037ce:	68 e5 46 80 00       	push   $0x8046e5
  8037d3:	e8 74 cd ff ff       	call   80054c <_panic>
  8037d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037db:	8b 10                	mov    (%eax),%edx
  8037dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e0:	89 10                	mov    %edx,(%eax)
  8037e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e5:	8b 00                	mov    (%eax),%eax
  8037e7:	85 c0                	test   %eax,%eax
  8037e9:	74 0b                	je     8037f6 <realloc_block_FF+0x41e>
  8037eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ee:	8b 00                	mov    (%eax),%eax
  8037f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037f3:	89 50 04             	mov    %edx,0x4(%eax)
  8037f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037fc:	89 10                	mov    %edx,(%eax)
  8037fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803801:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803804:	89 50 04             	mov    %edx,0x4(%eax)
  803807:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80380a:	8b 00                	mov    (%eax),%eax
  80380c:	85 c0                	test   %eax,%eax
  80380e:	75 08                	jne    803818 <realloc_block_FF+0x440>
  803810:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803813:	a3 30 50 80 00       	mov    %eax,0x805030
  803818:	a1 38 50 80 00       	mov    0x805038,%eax
  80381d:	40                   	inc    %eax
  80381e:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803823:	eb 36                	jmp    80385b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803825:	a1 34 50 80 00       	mov    0x805034,%eax
  80382a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80382d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803831:	74 07                	je     80383a <realloc_block_FF+0x462>
  803833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803836:	8b 00                	mov    (%eax),%eax
  803838:	eb 05                	jmp    80383f <realloc_block_FF+0x467>
  80383a:	b8 00 00 00 00       	mov    $0x0,%eax
  80383f:	a3 34 50 80 00       	mov    %eax,0x805034
  803844:	a1 34 50 80 00       	mov    0x805034,%eax
  803849:	85 c0                	test   %eax,%eax
  80384b:	0f 85 52 ff ff ff    	jne    8037a3 <realloc_block_FF+0x3cb>
  803851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803855:	0f 85 48 ff ff ff    	jne    8037a3 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80385b:	83 ec 04             	sub    $0x4,%esp
  80385e:	6a 00                	push   $0x0
  803860:	ff 75 d8             	pushl  -0x28(%ebp)
  803863:	ff 75 d4             	pushl  -0x2c(%ebp)
  803866:	e8 7a eb ff ff       	call   8023e5 <set_block_data>
  80386b:	83 c4 10             	add    $0x10,%esp
				return va;
  80386e:	8b 45 08             	mov    0x8(%ebp),%eax
  803871:	e9 7b 02 00 00       	jmp    803af1 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803876:	83 ec 0c             	sub    $0xc,%esp
  803879:	68 d5 47 80 00       	push   $0x8047d5
  80387e:	e8 86 cf ff ff       	call   800809 <cprintf>
  803883:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803886:	8b 45 08             	mov    0x8(%ebp),%eax
  803889:	e9 63 02 00 00       	jmp    803af1 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80388e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803891:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803894:	0f 86 4d 02 00 00    	jbe    803ae7 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80389a:	83 ec 0c             	sub    $0xc,%esp
  80389d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038a0:	e8 08 e8 ff ff       	call   8020ad <is_free_block>
  8038a5:	83 c4 10             	add    $0x10,%esp
  8038a8:	84 c0                	test   %al,%al
  8038aa:	0f 84 37 02 00 00    	je     803ae7 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038b9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038bf:	76 38                	jbe    8038f9 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8038c1:	83 ec 0c             	sub    $0xc,%esp
  8038c4:	ff 75 08             	pushl  0x8(%ebp)
  8038c7:	e8 0c fa ff ff       	call   8032d8 <free_block>
  8038cc:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8038cf:	83 ec 0c             	sub    $0xc,%esp
  8038d2:	ff 75 0c             	pushl  0xc(%ebp)
  8038d5:	e8 3a eb ff ff       	call   802414 <alloc_block_FF>
  8038da:	83 c4 10             	add    $0x10,%esp
  8038dd:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8038e0:	83 ec 08             	sub    $0x8,%esp
  8038e3:	ff 75 c0             	pushl  -0x40(%ebp)
  8038e6:	ff 75 08             	pushl  0x8(%ebp)
  8038e9:	e8 ab fa ff ff       	call   803399 <copy_data>
  8038ee:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8038f1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038f4:	e9 f8 01 00 00       	jmp    803af1 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8038f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038fc:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8038ff:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803902:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803906:	0f 87 a0 00 00 00    	ja     8039ac <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80390c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803910:	75 17                	jne    803929 <realloc_block_FF+0x551>
  803912:	83 ec 04             	sub    $0x4,%esp
  803915:	68 c7 46 80 00       	push   $0x8046c7
  80391a:	68 38 02 00 00       	push   $0x238
  80391f:	68 e5 46 80 00       	push   $0x8046e5
  803924:	e8 23 cc ff ff       	call   80054c <_panic>
  803929:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392c:	8b 00                	mov    (%eax),%eax
  80392e:	85 c0                	test   %eax,%eax
  803930:	74 10                	je     803942 <realloc_block_FF+0x56a>
  803932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803935:	8b 00                	mov    (%eax),%eax
  803937:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80393a:	8b 52 04             	mov    0x4(%edx),%edx
  80393d:	89 50 04             	mov    %edx,0x4(%eax)
  803940:	eb 0b                	jmp    80394d <realloc_block_FF+0x575>
  803942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803945:	8b 40 04             	mov    0x4(%eax),%eax
  803948:	a3 30 50 80 00       	mov    %eax,0x805030
  80394d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803950:	8b 40 04             	mov    0x4(%eax),%eax
  803953:	85 c0                	test   %eax,%eax
  803955:	74 0f                	je     803966 <realloc_block_FF+0x58e>
  803957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395a:	8b 40 04             	mov    0x4(%eax),%eax
  80395d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803960:	8b 12                	mov    (%edx),%edx
  803962:	89 10                	mov    %edx,(%eax)
  803964:	eb 0a                	jmp    803970 <realloc_block_FF+0x598>
  803966:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803969:	8b 00                	mov    (%eax),%eax
  80396b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803970:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803973:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803983:	a1 38 50 80 00       	mov    0x805038,%eax
  803988:	48                   	dec    %eax
  803989:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80398e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803991:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803994:	01 d0                	add    %edx,%eax
  803996:	83 ec 04             	sub    $0x4,%esp
  803999:	6a 01                	push   $0x1
  80399b:	50                   	push   %eax
  80399c:	ff 75 08             	pushl  0x8(%ebp)
  80399f:	e8 41 ea ff ff       	call   8023e5 <set_block_data>
  8039a4:	83 c4 10             	add    $0x10,%esp
  8039a7:	e9 36 01 00 00       	jmp    803ae2 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039af:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039b2:	01 d0                	add    %edx,%eax
  8039b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039b7:	83 ec 04             	sub    $0x4,%esp
  8039ba:	6a 01                	push   $0x1
  8039bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8039bf:	ff 75 08             	pushl  0x8(%ebp)
  8039c2:	e8 1e ea ff ff       	call   8023e5 <set_block_data>
  8039c7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cd:	83 e8 04             	sub    $0x4,%eax
  8039d0:	8b 00                	mov    (%eax),%eax
  8039d2:	83 e0 fe             	and    $0xfffffffe,%eax
  8039d5:	89 c2                	mov    %eax,%edx
  8039d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039da:	01 d0                	add    %edx,%eax
  8039dc:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039e3:	74 06                	je     8039eb <realloc_block_FF+0x613>
  8039e5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8039e9:	75 17                	jne    803a02 <realloc_block_FF+0x62a>
  8039eb:	83 ec 04             	sub    $0x4,%esp
  8039ee:	68 58 47 80 00       	push   $0x804758
  8039f3:	68 44 02 00 00       	push   $0x244
  8039f8:	68 e5 46 80 00       	push   $0x8046e5
  8039fd:	e8 4a cb ff ff       	call   80054c <_panic>
  803a02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a05:	8b 10                	mov    (%eax),%edx
  803a07:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a0a:	89 10                	mov    %edx,(%eax)
  803a0c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a0f:	8b 00                	mov    (%eax),%eax
  803a11:	85 c0                	test   %eax,%eax
  803a13:	74 0b                	je     803a20 <realloc_block_FF+0x648>
  803a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a18:	8b 00                	mov    (%eax),%eax
  803a1a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a1d:	89 50 04             	mov    %edx,0x4(%eax)
  803a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a23:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a26:	89 10                	mov    %edx,(%eax)
  803a28:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a2e:	89 50 04             	mov    %edx,0x4(%eax)
  803a31:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a34:	8b 00                	mov    (%eax),%eax
  803a36:	85 c0                	test   %eax,%eax
  803a38:	75 08                	jne    803a42 <realloc_block_FF+0x66a>
  803a3a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a3d:	a3 30 50 80 00       	mov    %eax,0x805030
  803a42:	a1 38 50 80 00       	mov    0x805038,%eax
  803a47:	40                   	inc    %eax
  803a48:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a51:	75 17                	jne    803a6a <realloc_block_FF+0x692>
  803a53:	83 ec 04             	sub    $0x4,%esp
  803a56:	68 c7 46 80 00       	push   $0x8046c7
  803a5b:	68 45 02 00 00       	push   $0x245
  803a60:	68 e5 46 80 00       	push   $0x8046e5
  803a65:	e8 e2 ca ff ff       	call   80054c <_panic>
  803a6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6d:	8b 00                	mov    (%eax),%eax
  803a6f:	85 c0                	test   %eax,%eax
  803a71:	74 10                	je     803a83 <realloc_block_FF+0x6ab>
  803a73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a76:	8b 00                	mov    (%eax),%eax
  803a78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a7b:	8b 52 04             	mov    0x4(%edx),%edx
  803a7e:	89 50 04             	mov    %edx,0x4(%eax)
  803a81:	eb 0b                	jmp    803a8e <realloc_block_FF+0x6b6>
  803a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a86:	8b 40 04             	mov    0x4(%eax),%eax
  803a89:	a3 30 50 80 00       	mov    %eax,0x805030
  803a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a91:	8b 40 04             	mov    0x4(%eax),%eax
  803a94:	85 c0                	test   %eax,%eax
  803a96:	74 0f                	je     803aa7 <realloc_block_FF+0x6cf>
  803a98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9b:	8b 40 04             	mov    0x4(%eax),%eax
  803a9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aa1:	8b 12                	mov    (%edx),%edx
  803aa3:	89 10                	mov    %edx,(%eax)
  803aa5:	eb 0a                	jmp    803ab1 <realloc_block_FF+0x6d9>
  803aa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aaa:	8b 00                	mov    (%eax),%eax
  803aac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ab1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803abd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ac4:	a1 38 50 80 00       	mov    0x805038,%eax
  803ac9:	48                   	dec    %eax
  803aca:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803acf:	83 ec 04             	sub    $0x4,%esp
  803ad2:	6a 00                	push   $0x0
  803ad4:	ff 75 bc             	pushl  -0x44(%ebp)
  803ad7:	ff 75 b8             	pushl  -0x48(%ebp)
  803ada:	e8 06 e9 ff ff       	call   8023e5 <set_block_data>
  803adf:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae5:	eb 0a                	jmp    803af1 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803ae7:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803aee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803af1:	c9                   	leave  
  803af2:	c3                   	ret    

00803af3 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803af3:	55                   	push   %ebp
  803af4:	89 e5                	mov    %esp,%ebp
  803af6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803af9:	83 ec 04             	sub    $0x4,%esp
  803afc:	68 dc 47 80 00       	push   $0x8047dc
  803b01:	68 58 02 00 00       	push   $0x258
  803b06:	68 e5 46 80 00       	push   $0x8046e5
  803b0b:	e8 3c ca ff ff       	call   80054c <_panic>

00803b10 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b10:	55                   	push   %ebp
  803b11:	89 e5                	mov    %esp,%ebp
  803b13:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b16:	83 ec 04             	sub    $0x4,%esp
  803b19:	68 04 48 80 00       	push   $0x804804
  803b1e:	68 61 02 00 00       	push   $0x261
  803b23:	68 e5 46 80 00       	push   $0x8046e5
  803b28:	e8 1f ca ff ff       	call   80054c <_panic>
  803b2d:	66 90                	xchg   %ax,%ax
  803b2f:	90                   	nop

00803b30 <__udivdi3>:
  803b30:	55                   	push   %ebp
  803b31:	57                   	push   %edi
  803b32:	56                   	push   %esi
  803b33:	53                   	push   %ebx
  803b34:	83 ec 1c             	sub    $0x1c,%esp
  803b37:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b3b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b47:	89 ca                	mov    %ecx,%edx
  803b49:	89 f8                	mov    %edi,%eax
  803b4b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b4f:	85 f6                	test   %esi,%esi
  803b51:	75 2d                	jne    803b80 <__udivdi3+0x50>
  803b53:	39 cf                	cmp    %ecx,%edi
  803b55:	77 65                	ja     803bbc <__udivdi3+0x8c>
  803b57:	89 fd                	mov    %edi,%ebp
  803b59:	85 ff                	test   %edi,%edi
  803b5b:	75 0b                	jne    803b68 <__udivdi3+0x38>
  803b5d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b62:	31 d2                	xor    %edx,%edx
  803b64:	f7 f7                	div    %edi
  803b66:	89 c5                	mov    %eax,%ebp
  803b68:	31 d2                	xor    %edx,%edx
  803b6a:	89 c8                	mov    %ecx,%eax
  803b6c:	f7 f5                	div    %ebp
  803b6e:	89 c1                	mov    %eax,%ecx
  803b70:	89 d8                	mov    %ebx,%eax
  803b72:	f7 f5                	div    %ebp
  803b74:	89 cf                	mov    %ecx,%edi
  803b76:	89 fa                	mov    %edi,%edx
  803b78:	83 c4 1c             	add    $0x1c,%esp
  803b7b:	5b                   	pop    %ebx
  803b7c:	5e                   	pop    %esi
  803b7d:	5f                   	pop    %edi
  803b7e:	5d                   	pop    %ebp
  803b7f:	c3                   	ret    
  803b80:	39 ce                	cmp    %ecx,%esi
  803b82:	77 28                	ja     803bac <__udivdi3+0x7c>
  803b84:	0f bd fe             	bsr    %esi,%edi
  803b87:	83 f7 1f             	xor    $0x1f,%edi
  803b8a:	75 40                	jne    803bcc <__udivdi3+0x9c>
  803b8c:	39 ce                	cmp    %ecx,%esi
  803b8e:	72 0a                	jb     803b9a <__udivdi3+0x6a>
  803b90:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b94:	0f 87 9e 00 00 00    	ja     803c38 <__udivdi3+0x108>
  803b9a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b9f:	89 fa                	mov    %edi,%edx
  803ba1:	83 c4 1c             	add    $0x1c,%esp
  803ba4:	5b                   	pop    %ebx
  803ba5:	5e                   	pop    %esi
  803ba6:	5f                   	pop    %edi
  803ba7:	5d                   	pop    %ebp
  803ba8:	c3                   	ret    
  803ba9:	8d 76 00             	lea    0x0(%esi),%esi
  803bac:	31 ff                	xor    %edi,%edi
  803bae:	31 c0                	xor    %eax,%eax
  803bb0:	89 fa                	mov    %edi,%edx
  803bb2:	83 c4 1c             	add    $0x1c,%esp
  803bb5:	5b                   	pop    %ebx
  803bb6:	5e                   	pop    %esi
  803bb7:	5f                   	pop    %edi
  803bb8:	5d                   	pop    %ebp
  803bb9:	c3                   	ret    
  803bba:	66 90                	xchg   %ax,%ax
  803bbc:	89 d8                	mov    %ebx,%eax
  803bbe:	f7 f7                	div    %edi
  803bc0:	31 ff                	xor    %edi,%edi
  803bc2:	89 fa                	mov    %edi,%edx
  803bc4:	83 c4 1c             	add    $0x1c,%esp
  803bc7:	5b                   	pop    %ebx
  803bc8:	5e                   	pop    %esi
  803bc9:	5f                   	pop    %edi
  803bca:	5d                   	pop    %ebp
  803bcb:	c3                   	ret    
  803bcc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bd1:	89 eb                	mov    %ebp,%ebx
  803bd3:	29 fb                	sub    %edi,%ebx
  803bd5:	89 f9                	mov    %edi,%ecx
  803bd7:	d3 e6                	shl    %cl,%esi
  803bd9:	89 c5                	mov    %eax,%ebp
  803bdb:	88 d9                	mov    %bl,%cl
  803bdd:	d3 ed                	shr    %cl,%ebp
  803bdf:	89 e9                	mov    %ebp,%ecx
  803be1:	09 f1                	or     %esi,%ecx
  803be3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803be7:	89 f9                	mov    %edi,%ecx
  803be9:	d3 e0                	shl    %cl,%eax
  803beb:	89 c5                	mov    %eax,%ebp
  803bed:	89 d6                	mov    %edx,%esi
  803bef:	88 d9                	mov    %bl,%cl
  803bf1:	d3 ee                	shr    %cl,%esi
  803bf3:	89 f9                	mov    %edi,%ecx
  803bf5:	d3 e2                	shl    %cl,%edx
  803bf7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bfb:	88 d9                	mov    %bl,%cl
  803bfd:	d3 e8                	shr    %cl,%eax
  803bff:	09 c2                	or     %eax,%edx
  803c01:	89 d0                	mov    %edx,%eax
  803c03:	89 f2                	mov    %esi,%edx
  803c05:	f7 74 24 0c          	divl   0xc(%esp)
  803c09:	89 d6                	mov    %edx,%esi
  803c0b:	89 c3                	mov    %eax,%ebx
  803c0d:	f7 e5                	mul    %ebp
  803c0f:	39 d6                	cmp    %edx,%esi
  803c11:	72 19                	jb     803c2c <__udivdi3+0xfc>
  803c13:	74 0b                	je     803c20 <__udivdi3+0xf0>
  803c15:	89 d8                	mov    %ebx,%eax
  803c17:	31 ff                	xor    %edi,%edi
  803c19:	e9 58 ff ff ff       	jmp    803b76 <__udivdi3+0x46>
  803c1e:	66 90                	xchg   %ax,%ax
  803c20:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c24:	89 f9                	mov    %edi,%ecx
  803c26:	d3 e2                	shl    %cl,%edx
  803c28:	39 c2                	cmp    %eax,%edx
  803c2a:	73 e9                	jae    803c15 <__udivdi3+0xe5>
  803c2c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c2f:	31 ff                	xor    %edi,%edi
  803c31:	e9 40 ff ff ff       	jmp    803b76 <__udivdi3+0x46>
  803c36:	66 90                	xchg   %ax,%ax
  803c38:	31 c0                	xor    %eax,%eax
  803c3a:	e9 37 ff ff ff       	jmp    803b76 <__udivdi3+0x46>
  803c3f:	90                   	nop

00803c40 <__umoddi3>:
  803c40:	55                   	push   %ebp
  803c41:	57                   	push   %edi
  803c42:	56                   	push   %esi
  803c43:	53                   	push   %ebx
  803c44:	83 ec 1c             	sub    $0x1c,%esp
  803c47:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c4b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c53:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c5f:	89 f3                	mov    %esi,%ebx
  803c61:	89 fa                	mov    %edi,%edx
  803c63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c67:	89 34 24             	mov    %esi,(%esp)
  803c6a:	85 c0                	test   %eax,%eax
  803c6c:	75 1a                	jne    803c88 <__umoddi3+0x48>
  803c6e:	39 f7                	cmp    %esi,%edi
  803c70:	0f 86 a2 00 00 00    	jbe    803d18 <__umoddi3+0xd8>
  803c76:	89 c8                	mov    %ecx,%eax
  803c78:	89 f2                	mov    %esi,%edx
  803c7a:	f7 f7                	div    %edi
  803c7c:	89 d0                	mov    %edx,%eax
  803c7e:	31 d2                	xor    %edx,%edx
  803c80:	83 c4 1c             	add    $0x1c,%esp
  803c83:	5b                   	pop    %ebx
  803c84:	5e                   	pop    %esi
  803c85:	5f                   	pop    %edi
  803c86:	5d                   	pop    %ebp
  803c87:	c3                   	ret    
  803c88:	39 f0                	cmp    %esi,%eax
  803c8a:	0f 87 ac 00 00 00    	ja     803d3c <__umoddi3+0xfc>
  803c90:	0f bd e8             	bsr    %eax,%ebp
  803c93:	83 f5 1f             	xor    $0x1f,%ebp
  803c96:	0f 84 ac 00 00 00    	je     803d48 <__umoddi3+0x108>
  803c9c:	bf 20 00 00 00       	mov    $0x20,%edi
  803ca1:	29 ef                	sub    %ebp,%edi
  803ca3:	89 fe                	mov    %edi,%esi
  803ca5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ca9:	89 e9                	mov    %ebp,%ecx
  803cab:	d3 e0                	shl    %cl,%eax
  803cad:	89 d7                	mov    %edx,%edi
  803caf:	89 f1                	mov    %esi,%ecx
  803cb1:	d3 ef                	shr    %cl,%edi
  803cb3:	09 c7                	or     %eax,%edi
  803cb5:	89 e9                	mov    %ebp,%ecx
  803cb7:	d3 e2                	shl    %cl,%edx
  803cb9:	89 14 24             	mov    %edx,(%esp)
  803cbc:	89 d8                	mov    %ebx,%eax
  803cbe:	d3 e0                	shl    %cl,%eax
  803cc0:	89 c2                	mov    %eax,%edx
  803cc2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cc6:	d3 e0                	shl    %cl,%eax
  803cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ccc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cd0:	89 f1                	mov    %esi,%ecx
  803cd2:	d3 e8                	shr    %cl,%eax
  803cd4:	09 d0                	or     %edx,%eax
  803cd6:	d3 eb                	shr    %cl,%ebx
  803cd8:	89 da                	mov    %ebx,%edx
  803cda:	f7 f7                	div    %edi
  803cdc:	89 d3                	mov    %edx,%ebx
  803cde:	f7 24 24             	mull   (%esp)
  803ce1:	89 c6                	mov    %eax,%esi
  803ce3:	89 d1                	mov    %edx,%ecx
  803ce5:	39 d3                	cmp    %edx,%ebx
  803ce7:	0f 82 87 00 00 00    	jb     803d74 <__umoddi3+0x134>
  803ced:	0f 84 91 00 00 00    	je     803d84 <__umoddi3+0x144>
  803cf3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cf7:	29 f2                	sub    %esi,%edx
  803cf9:	19 cb                	sbb    %ecx,%ebx
  803cfb:	89 d8                	mov    %ebx,%eax
  803cfd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d01:	d3 e0                	shl    %cl,%eax
  803d03:	89 e9                	mov    %ebp,%ecx
  803d05:	d3 ea                	shr    %cl,%edx
  803d07:	09 d0                	or     %edx,%eax
  803d09:	89 e9                	mov    %ebp,%ecx
  803d0b:	d3 eb                	shr    %cl,%ebx
  803d0d:	89 da                	mov    %ebx,%edx
  803d0f:	83 c4 1c             	add    $0x1c,%esp
  803d12:	5b                   	pop    %ebx
  803d13:	5e                   	pop    %esi
  803d14:	5f                   	pop    %edi
  803d15:	5d                   	pop    %ebp
  803d16:	c3                   	ret    
  803d17:	90                   	nop
  803d18:	89 fd                	mov    %edi,%ebp
  803d1a:	85 ff                	test   %edi,%edi
  803d1c:	75 0b                	jne    803d29 <__umoddi3+0xe9>
  803d1e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d23:	31 d2                	xor    %edx,%edx
  803d25:	f7 f7                	div    %edi
  803d27:	89 c5                	mov    %eax,%ebp
  803d29:	89 f0                	mov    %esi,%eax
  803d2b:	31 d2                	xor    %edx,%edx
  803d2d:	f7 f5                	div    %ebp
  803d2f:	89 c8                	mov    %ecx,%eax
  803d31:	f7 f5                	div    %ebp
  803d33:	89 d0                	mov    %edx,%eax
  803d35:	e9 44 ff ff ff       	jmp    803c7e <__umoddi3+0x3e>
  803d3a:	66 90                	xchg   %ax,%ax
  803d3c:	89 c8                	mov    %ecx,%eax
  803d3e:	89 f2                	mov    %esi,%edx
  803d40:	83 c4 1c             	add    $0x1c,%esp
  803d43:	5b                   	pop    %ebx
  803d44:	5e                   	pop    %esi
  803d45:	5f                   	pop    %edi
  803d46:	5d                   	pop    %ebp
  803d47:	c3                   	ret    
  803d48:	3b 04 24             	cmp    (%esp),%eax
  803d4b:	72 06                	jb     803d53 <__umoddi3+0x113>
  803d4d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d51:	77 0f                	ja     803d62 <__umoddi3+0x122>
  803d53:	89 f2                	mov    %esi,%edx
  803d55:	29 f9                	sub    %edi,%ecx
  803d57:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d5b:	89 14 24             	mov    %edx,(%esp)
  803d5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d62:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d66:	8b 14 24             	mov    (%esp),%edx
  803d69:	83 c4 1c             	add    $0x1c,%esp
  803d6c:	5b                   	pop    %ebx
  803d6d:	5e                   	pop    %esi
  803d6e:	5f                   	pop    %edi
  803d6f:	5d                   	pop    %ebp
  803d70:	c3                   	ret    
  803d71:	8d 76 00             	lea    0x0(%esi),%esi
  803d74:	2b 04 24             	sub    (%esp),%eax
  803d77:	19 fa                	sbb    %edi,%edx
  803d79:	89 d1                	mov    %edx,%ecx
  803d7b:	89 c6                	mov    %eax,%esi
  803d7d:	e9 71 ff ff ff       	jmp    803cf3 <__umoddi3+0xb3>
  803d82:	66 90                	xchg   %ax,%ax
  803d84:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d88:	72 ea                	jb     803d74 <__umoddi3+0x134>
  803d8a:	89 d9                	mov    %ebx,%ecx
  803d8c:	e9 62 ff ff ff       	jmp    803cf3 <__umoddi3+0xb3>
