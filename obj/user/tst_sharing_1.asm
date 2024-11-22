
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
  800031:	e8 4f 04 00 00       	call   800485 <libmain>
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
  80005c:	68 c0 3d 80 00       	push   $0x803dc0
  800061:	6a 13                	push   $0x13
  800063:	68 dc 3d 80 00       	push   $0x803ddc
  800068:	e8 57 05 00 00       	call   8005c4 <_panic>
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
  800085:	68 f4 3d 80 00       	push   $0x803df4
  80008a:	e8 f2 07 00 00       	call   800881 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800092:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800099:	e8 0d 1b 00 00       	call   801bab <sys_calculate_free_frames>
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	6a 01                	push   $0x1
  8000a6:	68 00 10 00 00       	push   $0x1000
  8000ab:	68 30 3e 80 00       	push   $0x803e30
  8000b0:	e8 99 18 00 00       	call   80194e <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000c1:	74 17                	je     8000da <_main+0xa2>
  8000c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 34 3e 80 00       	push   $0x803e34
  8000d2:	e8 aa 07 00 00       	call   800881 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8000da:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8000e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000e4:	e8 c2 1a 00 00       	call   801bab <sys_calculate_free_frames>
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
  80010f:	e8 97 1a 00 00       	call   801bab <sys_calculate_free_frames>
  800114:	29 c3                	sub    %eax,%ebx
  800116:	89 d8                	mov    %ebx,%eax
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	68 a0 3e 80 00       	push   $0x803ea0
  800124:	e8 58 07 00 00       	call   800881 <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80012c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800130:	74 04                	je     800136 <_main+0xfe>
  800132:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  800136:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80013d:	e8 69 1a 00 00       	call   801bab <sys_calculate_free_frames>
  800142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	6a 01                	push   $0x1
  80014a:	68 04 10 00 00       	push   $0x1004
  80014f:	68 38 3f 80 00       	push   $0x803f38
  800154:	e8 f5 17 00 00       	call   80194e <smalloc>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  80015f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800162:	05 00 10 00 00       	add    $0x1000,%eax
  800167:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80016a:	74 17                	je     800183 <_main+0x14b>
  80016c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 34 3e 80 00       	push   $0x803e34
  80017b:	e8 01 07 00 00       	call   800881 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2pages*/
  800183:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80018a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80018d:	e8 19 1a 00 00       	call   801bab <sys_calculate_free_frames>
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
  8001b8:	e8 ee 19 00 00       	call   801bab <sys_calculate_free_frames>
  8001bd:	29 c3                	sub    %eax,%ebx
  8001bf:	89 d8                	mov    %ebx,%eax
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c7:	50                   	push   %eax
  8001c8:	68 a0 3e 80 00       	push   $0x803ea0
  8001cd:	e8 af 06 00 00       	call   800881 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  8001d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d9:	74 04                	je     8001df <_main+0x1a7>
  8001db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  8001df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001e6:	e8 c0 19 00 00       	call   801bab <sys_calculate_free_frames>
  8001eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		y = smalloc("y", 4, 1);
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 01                	push   $0x1
  8001f3:	6a 04                	push   $0x4
  8001f5:	68 3a 3f 80 00       	push   $0x803f3a
  8001fa:	e8 4f 17 00 00       	call   80194e <smalloc>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800208:	05 00 30 00 00       	add    $0x3000,%eax
  80020d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800210:	74 17                	je     800229 <_main+0x1f1>
  800212:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 34 3e 80 00       	push   $0x803e34
  800221:	e8 5b 06 00 00       	call   800881 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1page*/
  800229:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800230:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800233:	e8 73 19 00 00       	call   801bab <sys_calculate_free_frames>
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
  80025e:	e8 48 19 00 00       	call   801bab <sys_calculate_free_frames>
  800263:	29 c3                	sub    %eax,%ebx
  800265:	89 d8                	mov    %ebx,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	ff 75 dc             	pushl  -0x24(%ebp)
  80026d:	50                   	push   %eax
  80026e:	68 a0 3e 80 00       	push   $0x803ea0
  800273:	e8 09 06 00 00       	call   800881 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80027b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80027f:	74 04                	je     800285 <_main+0x24d>
  800281:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 3c 3f 80 00       	push   $0x803f3c
  80028d:	e8 ef 05 00 00       	call   800881 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp

	is_correct = 1;
  800295:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP B: checking reading & writing... [40%]\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 64 3f 80 00       	push   $0x803f64
  8002a4:	e8 d8 05 00 00       	call   800881 <cprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  8002ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		cprintf("68\n");
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	68 91 3f 80 00       	push   $0x803f91
  8002bb:	e8 c1 05 00 00       	call   800881 <cprintf>
  8002c0:	83 c4 10             	add    $0x10,%esp
		for(;i<PAGE_SIZE/4;i++)
  8002c3:	eb 75                	jmp    80033a <_main+0x302>
		{
			cprintf("I: %d\n",i);
  8002c5:	83 ec 08             	sub    $0x8,%esp
  8002c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8002cb:	68 95 3f 80 00       	push   $0x803f95
  8002d0:	e8 ac 05 00 00       	call   800881 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
			cprintf("X: %x\n",x);
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	ff 75 e0             	pushl  -0x20(%ebp)
  8002de:	68 9c 3f 80 00       	push   $0x803f9c
  8002e3:	e8 99 05 00 00       	call   800881 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
			cprintf("x[i]: %x\n",x[i]);
  8002eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f8:	01 d0                	add    %edx,%eax
  8002fa:	8b 00                	mov    (%eax),%eax
  8002fc:	83 ec 08             	sub    $0x8,%esp
  8002ff:	50                   	push   %eax
  800300:	68 a3 3f 80 00       	push   $0x803fa3
  800305:	e8 77 05 00 00       	call   800881 <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
			x[i] = -1;
  80030d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800310:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800317:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80031a:	01 d0                	add    %edx,%eax
  80031c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800322:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800325:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80032f:	01 d0                	add    %edx,%eax
  800331:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
	is_correct = 1;
	cprintf("STEP B: checking reading & writing... [40%]\n");
	{
		int i=0;
		cprintf("68\n");
		for(;i<PAGE_SIZE/4;i++)
  800337:	ff 45 ec             	incl   -0x14(%ebp)
  80033a:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  800341:	7e 82                	jle    8002c5 <_main+0x28d>
			cprintf("x[i]: %x\n",x[i]);
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  800343:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  80034a:	eb 18                	jmp    800364 <_main+0x32c>
		{
			z[i] = -1;
  80034c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80034f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800356:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800361:	ff 45 ec             	incl   -0x14(%ebp)
  800364:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  80036b:	7e df                	jle    80034c <_main+0x314>
		{
			z[i] = -1;
		}
		cprintf("80\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 ad 3f 80 00       	push   $0x803fad
  800375:	e8 07 05 00 00       	call   800881 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		if( x[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80037d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800380:	8b 00                	mov    (%eax),%eax
  800382:	83 f8 ff             	cmp    $0xffffffff,%eax
  800385:	74 17                	je     80039e <_main+0x366>
  800387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80038e:	83 ec 0c             	sub    $0xc,%esp
  800391:	68 b4 3f 80 00       	push   $0x803fb4
  800396:	e8 e6 04 00 00       	call   800881 <cprintf>
  80039b:	83 c4 10             	add    $0x10,%esp
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80039e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a1:	05 fc 0f 00 00       	add    $0xffc,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003ab:	74 17                	je     8003c4 <_main+0x38c>
  8003ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 b4 3f 80 00       	push   $0x803fb4
  8003bc:	e8 c0 04 00 00       	call   800881 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
		cprintf("83\n");
  8003c4:	83 ec 0c             	sub    $0xc,%esp
  8003c7:	68 df 3f 80 00       	push   $0x803fdf
  8003cc:	e8 b0 04 00 00       	call   800881 <cprintf>
  8003d1:	83 c4 10             	add    $0x10,%esp
		if( y[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003d7:	8b 00                	mov    (%eax),%eax
  8003d9:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003dc:	74 17                	je     8003f5 <_main+0x3bd>
  8003de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	68 b4 3f 80 00       	push   $0x803fb4
  8003ed:	e8 8f 04 00 00       	call   800881 <cprintf>
  8003f2:	83 c4 10             	add    $0x10,%esp
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003f8:	05 fc 0f 00 00       	add    $0xffc,%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	83 f8 ff             	cmp    $0xffffffff,%eax
  800402:	74 17                	je     80041b <_main+0x3e3>
  800404:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80040b:	83 ec 0c             	sub    $0xc,%esp
  80040e:	68 b4 3f 80 00       	push   $0x803fb4
  800413:	e8 69 04 00 00       	call   800881 <cprintf>
  800418:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80041b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	83 f8 ff             	cmp    $0xffffffff,%eax
  800423:	74 17                	je     80043c <_main+0x404>
  800425:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 b4 3f 80 00       	push   $0x803fb4
  800434:	e8 48 04 00 00       	call   800881 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80043c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043f:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	83 f8 ff             	cmp    $0xffffffff,%eax
  800449:	74 17                	je     800462 <_main+0x42a>
  80044b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800452:	83 ec 0c             	sub    $0xc,%esp
  800455:	68 b4 3f 80 00       	push   $0x803fb4
  80045a:	e8 22 04 00 00       	call   800881 <cprintf>
  80045f:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  800462:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800466:	74 04                	je     80046c <_main+0x434>
		eval += 40 ;
  800468:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	cprintf("\n%~Test of Shared Variables [Create] [1] completed. Eval = %d%%\n\n", eval);
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	ff 75 f4             	pushl  -0xc(%ebp)
  800472:	68 e4 3f 80 00       	push   $0x803fe4
  800477:	e8 05 04 00 00       	call   800881 <cprintf>
  80047c:	83 c4 10             	add    $0x10,%esp

	return;
  80047f:	90                   	nop
}
  800480:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800483:	c9                   	leave  
  800484:	c3                   	ret    

00800485 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800485:	55                   	push   %ebp
  800486:	89 e5                	mov    %esp,%ebp
  800488:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80048b:	e8 e4 18 00 00       	call   801d74 <sys_getenvindex>
  800490:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800493:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800496:	89 d0                	mov    %edx,%eax
  800498:	c1 e0 03             	shl    $0x3,%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8004a4:	01 c8                	add    %ecx,%eax
  8004a6:	01 c0                	add    %eax,%eax
  8004a8:	01 d0                	add    %edx,%eax
  8004aa:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8004b1:	01 c8                	add    %ecx,%eax
  8004b3:	01 d0                	add    %edx,%eax
  8004b5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004ba:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c4:	8a 40 20             	mov    0x20(%eax),%al
  8004c7:	84 c0                	test   %al,%al
  8004c9:	74 0d                	je     8004d8 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8004cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d0:	83 c0 20             	add    $0x20,%eax
  8004d3:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004dc:	7e 0a                	jle    8004e8 <libmain+0x63>
		binaryname = argv[0];
  8004de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e1:	8b 00                	mov    (%eax),%eax
  8004e3:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	ff 75 0c             	pushl  0xc(%ebp)
  8004ee:	ff 75 08             	pushl  0x8(%ebp)
  8004f1:	e8 42 fb ff ff       	call   800038 <_main>
  8004f6:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8004f9:	e8 fa 15 00 00       	call   801af8 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004fe:	83 ec 0c             	sub    $0xc,%esp
  800501:	68 40 40 80 00       	push   $0x804040
  800506:	e8 76 03 00 00       	call   800881 <cprintf>
  80050b:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80050e:	a1 20 50 80 00       	mov    0x805020,%eax
  800513:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800519:	a1 20 50 80 00       	mov    0x805020,%eax
  80051e:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800524:	83 ec 04             	sub    $0x4,%esp
  800527:	52                   	push   %edx
  800528:	50                   	push   %eax
  800529:	68 68 40 80 00       	push   $0x804068
  80052e:	e8 4e 03 00 00       	call   800881 <cprintf>
  800533:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800536:	a1 20 50 80 00       	mov    0x805020,%eax
  80053b:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800541:	a1 20 50 80 00       	mov    0x805020,%eax
  800546:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80054c:	a1 20 50 80 00       	mov    0x805020,%eax
  800551:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800557:	51                   	push   %ecx
  800558:	52                   	push   %edx
  800559:	50                   	push   %eax
  80055a:	68 90 40 80 00       	push   $0x804090
  80055f:	e8 1d 03 00 00       	call   800881 <cprintf>
  800564:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800567:	a1 20 50 80 00       	mov    0x805020,%eax
  80056c:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	50                   	push   %eax
  800576:	68 e8 40 80 00       	push   $0x8040e8
  80057b:	e8 01 03 00 00       	call   800881 <cprintf>
  800580:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800583:	83 ec 0c             	sub    $0xc,%esp
  800586:	68 40 40 80 00       	push   $0x804040
  80058b:	e8 f1 02 00 00       	call   800881 <cprintf>
  800590:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800593:	e8 7a 15 00 00       	call   801b12 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800598:	e8 19 00 00 00       	call   8005b6 <exit>
}
  80059d:	90                   	nop
  80059e:	c9                   	leave  
  80059f:	c3                   	ret    

008005a0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005a6:	83 ec 0c             	sub    $0xc,%esp
  8005a9:	6a 00                	push   $0x0
  8005ab:	e8 90 17 00 00       	call   801d40 <sys_destroy_env>
  8005b0:	83 c4 10             	add    $0x10,%esp
}
  8005b3:	90                   	nop
  8005b4:	c9                   	leave  
  8005b5:	c3                   	ret    

008005b6 <exit>:

void
exit(void)
{
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005bc:	e8 e5 17 00 00       	call   801da6 <sys_exit_env>
}
  8005c1:	90                   	nop
  8005c2:	c9                   	leave  
  8005c3:	c3                   	ret    

008005c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005c4:	55                   	push   %ebp
  8005c5:	89 e5                	mov    %esp,%ebp
  8005c7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005ca:	8d 45 10             	lea    0x10(%ebp),%eax
  8005cd:	83 c0 04             	add    $0x4,%eax
  8005d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005d3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8005d8:	85 c0                	test   %eax,%eax
  8005da:	74 16                	je     8005f2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005dc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8005e1:	83 ec 08             	sub    $0x8,%esp
  8005e4:	50                   	push   %eax
  8005e5:	68 fc 40 80 00       	push   $0x8040fc
  8005ea:	e8 92 02 00 00       	call   800881 <cprintf>
  8005ef:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005f2:	a1 00 50 80 00       	mov    0x805000,%eax
  8005f7:	ff 75 0c             	pushl  0xc(%ebp)
  8005fa:	ff 75 08             	pushl  0x8(%ebp)
  8005fd:	50                   	push   %eax
  8005fe:	68 01 41 80 00       	push   $0x804101
  800603:	e8 79 02 00 00       	call   800881 <cprintf>
  800608:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80060b:	8b 45 10             	mov    0x10(%ebp),%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 f4             	pushl  -0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	e8 fc 01 00 00       	call   800816 <vcprintf>
  80061a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	6a 00                	push   $0x0
  800622:	68 1d 41 80 00       	push   $0x80411d
  800627:	e8 ea 01 00 00       	call   800816 <vcprintf>
  80062c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80062f:	e8 82 ff ff ff       	call   8005b6 <exit>

	// should not return here
	while (1) ;
  800634:	eb fe                	jmp    800634 <_panic+0x70>

00800636 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80063c:	a1 20 50 80 00       	mov    0x805020,%eax
  800641:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800647:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064a:	39 c2                	cmp    %eax,%edx
  80064c:	74 14                	je     800662 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80064e:	83 ec 04             	sub    $0x4,%esp
  800651:	68 20 41 80 00       	push   $0x804120
  800656:	6a 26                	push   $0x26
  800658:	68 6c 41 80 00       	push   $0x80416c
  80065d:	e8 62 ff ff ff       	call   8005c4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800662:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800669:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800670:	e9 c5 00 00 00       	jmp    80073a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800678:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	01 d0                	add    %edx,%eax
  800684:	8b 00                	mov    (%eax),%eax
  800686:	85 c0                	test   %eax,%eax
  800688:	75 08                	jne    800692 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80068a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80068d:	e9 a5 00 00 00       	jmp    800737 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800692:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800699:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8006a0:	eb 69                	jmp    80070b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8006a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a7:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8006ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b0:	89 d0                	mov    %edx,%eax
  8006b2:	01 c0                	add    %eax,%eax
  8006b4:	01 d0                	add    %edx,%eax
  8006b6:	c1 e0 03             	shl    $0x3,%eax
  8006b9:	01 c8                	add    %ecx,%eax
  8006bb:	8a 40 04             	mov    0x4(%eax),%al
  8006be:	84 c0                	test   %al,%al
  8006c0:	75 46                	jne    800708 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c7:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8006cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006d0:	89 d0                	mov    %edx,%eax
  8006d2:	01 c0                	add    %eax,%eax
  8006d4:	01 d0                	add    %edx,%eax
  8006d6:	c1 e0 03             	shl    $0x3,%eax
  8006d9:	01 c8                	add    %ecx,%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006e8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	01 c8                	add    %ecx,%eax
  8006f9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006fb:	39 c2                	cmp    %eax,%edx
  8006fd:	75 09                	jne    800708 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006ff:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800706:	eb 15                	jmp    80071d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800708:	ff 45 e8             	incl   -0x18(%ebp)
  80070b:	a1 20 50 80 00       	mov    0x805020,%eax
  800710:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800716:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800719:	39 c2                	cmp    %eax,%edx
  80071b:	77 85                	ja     8006a2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80071d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800721:	75 14                	jne    800737 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800723:	83 ec 04             	sub    $0x4,%esp
  800726:	68 78 41 80 00       	push   $0x804178
  80072b:	6a 3a                	push   $0x3a
  80072d:	68 6c 41 80 00       	push   $0x80416c
  800732:	e8 8d fe ff ff       	call   8005c4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800737:	ff 45 f0             	incl   -0x10(%ebp)
  80073a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800740:	0f 8c 2f ff ff ff    	jl     800675 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800746:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80074d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800754:	eb 26                	jmp    80077c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800756:	a1 20 50 80 00       	mov    0x805020,%eax
  80075b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800761:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800764:	89 d0                	mov    %edx,%eax
  800766:	01 c0                	add    %eax,%eax
  800768:	01 d0                	add    %edx,%eax
  80076a:	c1 e0 03             	shl    $0x3,%eax
  80076d:	01 c8                	add    %ecx,%eax
  80076f:	8a 40 04             	mov    0x4(%eax),%al
  800772:	3c 01                	cmp    $0x1,%al
  800774:	75 03                	jne    800779 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800776:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800779:	ff 45 e0             	incl   -0x20(%ebp)
  80077c:	a1 20 50 80 00       	mov    0x805020,%eax
  800781:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800787:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80078a:	39 c2                	cmp    %eax,%edx
  80078c:	77 c8                	ja     800756 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800791:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800794:	74 14                	je     8007aa <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800796:	83 ec 04             	sub    $0x4,%esp
  800799:	68 cc 41 80 00       	push   $0x8041cc
  80079e:	6a 44                	push   $0x44
  8007a0:	68 6c 41 80 00       	push   $0x80416c
  8007a5:	e8 1a fe ff ff       	call   8005c4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8007aa:	90                   	nop
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	8d 48 01             	lea    0x1(%eax),%ecx
  8007bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007be:	89 0a                	mov    %ecx,(%edx)
  8007c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8007c3:	88 d1                	mov    %dl,%cl
  8007c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007d6:	75 2c                	jne    800804 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007d8:	a0 28 50 80 00       	mov    0x805028,%al
  8007dd:	0f b6 c0             	movzbl %al,%eax
  8007e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e3:	8b 12                	mov    (%edx),%edx
  8007e5:	89 d1                	mov    %edx,%ecx
  8007e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ea:	83 c2 08             	add    $0x8,%edx
  8007ed:	83 ec 04             	sub    $0x4,%esp
  8007f0:	50                   	push   %eax
  8007f1:	51                   	push   %ecx
  8007f2:	52                   	push   %edx
  8007f3:	e8 be 12 00 00       	call   801ab6 <sys_cputs>
  8007f8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800804:	8b 45 0c             	mov    0xc(%ebp),%eax
  800807:	8b 40 04             	mov    0x4(%eax),%eax
  80080a:	8d 50 01             	lea    0x1(%eax),%edx
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800810:	89 50 04             	mov    %edx,0x4(%eax)
}
  800813:	90                   	nop
  800814:	c9                   	leave  
  800815:	c3                   	ret    

00800816 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80081f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800826:	00 00 00 
	b.cnt = 0;
  800829:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800830:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 08             	pushl  0x8(%ebp)
  800839:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80083f:	50                   	push   %eax
  800840:	68 ad 07 80 00       	push   $0x8007ad
  800845:	e8 11 02 00 00       	call   800a5b <vprintfmt>
  80084a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80084d:	a0 28 50 80 00       	mov    0x805028,%al
  800852:	0f b6 c0             	movzbl %al,%eax
  800855:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80085b:	83 ec 04             	sub    $0x4,%esp
  80085e:	50                   	push   %eax
  80085f:	52                   	push   %edx
  800860:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800866:	83 c0 08             	add    $0x8,%eax
  800869:	50                   	push   %eax
  80086a:	e8 47 12 00 00       	call   801ab6 <sys_cputs>
  80086f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800872:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800879:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80087f:	c9                   	leave  
  800880:	c3                   	ret    

00800881 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800887:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  80088e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800891:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	83 ec 08             	sub    $0x8,%esp
  80089a:	ff 75 f4             	pushl  -0xc(%ebp)
  80089d:	50                   	push   %eax
  80089e:	e8 73 ff ff ff       	call   800816 <vcprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
  8008a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008ac:	c9                   	leave  
  8008ad:	c3                   	ret    

008008ae <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8008b4:	e8 3f 12 00 00       	call   801af8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8008b9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c8:	50                   	push   %eax
  8008c9:	e8 48 ff ff ff       	call   800816 <vcprintf>
  8008ce:	83 c4 10             	add    $0x10,%esp
  8008d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8008d4:	e8 39 12 00 00       	call   801b12 <sys_unlock_cons>
	return cnt;
  8008d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008dc:	c9                   	leave  
  8008dd:	c3                   	ret    

008008de <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	53                   	push   %ebx
  8008e2:	83 ec 14             	sub    $0x14,%esp
  8008e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008f1:	8b 45 18             	mov    0x18(%ebp),%eax
  8008f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008fc:	77 55                	ja     800953 <printnum+0x75>
  8008fe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800901:	72 05                	jb     800908 <printnum+0x2a>
  800903:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800906:	77 4b                	ja     800953 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800908:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80090b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80090e:	8b 45 18             	mov    0x18(%ebp),%eax
  800911:	ba 00 00 00 00       	mov    $0x0,%edx
  800916:	52                   	push   %edx
  800917:	50                   	push   %eax
  800918:	ff 75 f4             	pushl  -0xc(%ebp)
  80091b:	ff 75 f0             	pushl  -0x10(%ebp)
  80091e:	e8 2d 32 00 00       	call   803b50 <__udivdi3>
  800923:	83 c4 10             	add    $0x10,%esp
  800926:	83 ec 04             	sub    $0x4,%esp
  800929:	ff 75 20             	pushl  0x20(%ebp)
  80092c:	53                   	push   %ebx
  80092d:	ff 75 18             	pushl  0x18(%ebp)
  800930:	52                   	push   %edx
  800931:	50                   	push   %eax
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	ff 75 08             	pushl  0x8(%ebp)
  800938:	e8 a1 ff ff ff       	call   8008de <printnum>
  80093d:	83 c4 20             	add    $0x20,%esp
  800940:	eb 1a                	jmp    80095c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	ff 75 20             	pushl  0x20(%ebp)
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	ff d0                	call   *%eax
  800950:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800953:	ff 4d 1c             	decl   0x1c(%ebp)
  800956:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80095a:	7f e6                	jg     800942 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80095c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80095f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80096a:	53                   	push   %ebx
  80096b:	51                   	push   %ecx
  80096c:	52                   	push   %edx
  80096d:	50                   	push   %eax
  80096e:	e8 ed 32 00 00       	call   803c60 <__umoddi3>
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	05 34 44 80 00       	add    $0x804434,%eax
  80097b:	8a 00                	mov    (%eax),%al
  80097d:	0f be c0             	movsbl %al,%eax
  800980:	83 ec 08             	sub    $0x8,%esp
  800983:	ff 75 0c             	pushl  0xc(%ebp)
  800986:	50                   	push   %eax
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	ff d0                	call   *%eax
  80098c:	83 c4 10             	add    $0x10,%esp
}
  80098f:	90                   	nop
  800990:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800998:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80099c:	7e 1c                	jle    8009ba <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	8b 00                	mov    (%eax),%eax
  8009a3:	8d 50 08             	lea    0x8(%eax),%edx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	89 10                	mov    %edx,(%eax)
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	83 e8 08             	sub    $0x8,%eax
  8009b3:	8b 50 04             	mov    0x4(%eax),%edx
  8009b6:	8b 00                	mov    (%eax),%eax
  8009b8:	eb 40                	jmp    8009fa <getuint+0x65>
	else if (lflag)
  8009ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009be:	74 1e                	je     8009de <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	8d 50 04             	lea    0x4(%eax),%edx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 10                	mov    %edx,(%eax)
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	83 e8 04             	sub    $0x4,%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009dc:	eb 1c                	jmp    8009fa <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 00                	mov    (%eax),%eax
  8009e3:	8d 50 04             	lea    0x4(%eax),%edx
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	89 10                	mov    %edx,(%eax)
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 00                	mov    (%eax),%eax
  8009f0:	83 e8 04             	sub    $0x4,%eax
  8009f3:	8b 00                	mov    (%eax),%eax
  8009f5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009ff:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a03:	7e 1c                	jle    800a21 <getint+0x25>
		return va_arg(*ap, long long);
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	8b 00                	mov    (%eax),%eax
  800a0a:	8d 50 08             	lea    0x8(%eax),%edx
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	89 10                	mov    %edx,(%eax)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	83 e8 08             	sub    $0x8,%eax
  800a1a:	8b 50 04             	mov    0x4(%eax),%edx
  800a1d:	8b 00                	mov    (%eax),%eax
  800a1f:	eb 38                	jmp    800a59 <getint+0x5d>
	else if (lflag)
  800a21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a25:	74 1a                	je     800a41 <getint+0x45>
		return va_arg(*ap, long);
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8b 00                	mov    (%eax),%eax
  800a2c:	8d 50 04             	lea    0x4(%eax),%edx
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	89 10                	mov    %edx,(%eax)
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 00                	mov    (%eax),%eax
  800a3e:	99                   	cltd   
  800a3f:	eb 18                	jmp    800a59 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	8d 50 04             	lea    0x4(%eax),%edx
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	89 10                	mov    %edx,(%eax)
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	8b 00                	mov    (%eax),%eax
  800a53:	83 e8 04             	sub    $0x4,%eax
  800a56:	8b 00                	mov    (%eax),%eax
  800a58:	99                   	cltd   
}
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	56                   	push   %esi
  800a5f:	53                   	push   %ebx
  800a60:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a63:	eb 17                	jmp    800a7c <vprintfmt+0x21>
			if (ch == '\0')
  800a65:	85 db                	test   %ebx,%ebx
  800a67:	0f 84 c1 03 00 00    	je     800e2e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	53                   	push   %ebx
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7f:	8d 50 01             	lea    0x1(%eax),%edx
  800a82:	89 55 10             	mov    %edx,0x10(%ebp)
  800a85:	8a 00                	mov    (%eax),%al
  800a87:	0f b6 d8             	movzbl %al,%ebx
  800a8a:	83 fb 25             	cmp    $0x25,%ebx
  800a8d:	75 d6                	jne    800a65 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a8f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a93:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a9a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800aa1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800aa8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aaf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab2:	8d 50 01             	lea    0x1(%eax),%edx
  800ab5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ab8:	8a 00                	mov    (%eax),%al
  800aba:	0f b6 d8             	movzbl %al,%ebx
  800abd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ac0:	83 f8 5b             	cmp    $0x5b,%eax
  800ac3:	0f 87 3d 03 00 00    	ja     800e06 <vprintfmt+0x3ab>
  800ac9:	8b 04 85 58 44 80 00 	mov    0x804458(,%eax,4),%eax
  800ad0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ad2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ad6:	eb d7                	jmp    800aaf <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ad8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800adc:	eb d1                	jmp    800aaf <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ade:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ae5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ae8:	89 d0                	mov    %edx,%eax
  800aea:	c1 e0 02             	shl    $0x2,%eax
  800aed:	01 d0                	add    %edx,%eax
  800aef:	01 c0                	add    %eax,%eax
  800af1:	01 d8                	add    %ebx,%eax
  800af3:	83 e8 30             	sub    $0x30,%eax
  800af6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800af9:	8b 45 10             	mov    0x10(%ebp),%eax
  800afc:	8a 00                	mov    (%eax),%al
  800afe:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b01:	83 fb 2f             	cmp    $0x2f,%ebx
  800b04:	7e 3e                	jle    800b44 <vprintfmt+0xe9>
  800b06:	83 fb 39             	cmp    $0x39,%ebx
  800b09:	7f 39                	jg     800b44 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b0b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b0e:	eb d5                	jmp    800ae5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b10:	8b 45 14             	mov    0x14(%ebp),%eax
  800b13:	83 c0 04             	add    $0x4,%eax
  800b16:	89 45 14             	mov    %eax,0x14(%ebp)
  800b19:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1c:	83 e8 04             	sub    $0x4,%eax
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b24:	eb 1f                	jmp    800b45 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	79 83                	jns    800aaf <vprintfmt+0x54>
				width = 0;
  800b2c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b33:	e9 77 ff ff ff       	jmp    800aaf <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b38:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b3f:	e9 6b ff ff ff       	jmp    800aaf <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b44:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b49:	0f 89 60 ff ff ff    	jns    800aaf <vprintfmt+0x54>
				width = precision, precision = -1;
  800b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b55:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b5c:	e9 4e ff ff ff       	jmp    800aaf <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b61:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b64:	e9 46 ff ff ff       	jmp    800aaf <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b69:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6c:	83 c0 04             	add    $0x4,%eax
  800b6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b72:	8b 45 14             	mov    0x14(%ebp),%eax
  800b75:	83 e8 04             	sub    $0x4,%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	ff 75 0c             	pushl  0xc(%ebp)
  800b80:	50                   	push   %eax
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	ff d0                	call   *%eax
  800b86:	83 c4 10             	add    $0x10,%esp
			break;
  800b89:	e9 9b 02 00 00       	jmp    800e29 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b91:	83 c0 04             	add    $0x4,%eax
  800b94:	89 45 14             	mov    %eax,0x14(%ebp)
  800b97:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9a:	83 e8 04             	sub    $0x4,%eax
  800b9d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b9f:	85 db                	test   %ebx,%ebx
  800ba1:	79 02                	jns    800ba5 <vprintfmt+0x14a>
				err = -err;
  800ba3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ba5:	83 fb 64             	cmp    $0x64,%ebx
  800ba8:	7f 0b                	jg     800bb5 <vprintfmt+0x15a>
  800baa:	8b 34 9d a0 42 80 00 	mov    0x8042a0(,%ebx,4),%esi
  800bb1:	85 f6                	test   %esi,%esi
  800bb3:	75 19                	jne    800bce <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800bb5:	53                   	push   %ebx
  800bb6:	68 45 44 80 00       	push   $0x804445
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	ff 75 08             	pushl  0x8(%ebp)
  800bc1:	e8 70 02 00 00       	call   800e36 <printfmt>
  800bc6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bc9:	e9 5b 02 00 00       	jmp    800e29 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bce:	56                   	push   %esi
  800bcf:	68 4e 44 80 00       	push   $0x80444e
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	ff 75 08             	pushl  0x8(%ebp)
  800bda:	e8 57 02 00 00       	call   800e36 <printfmt>
  800bdf:	83 c4 10             	add    $0x10,%esp
			break;
  800be2:	e9 42 02 00 00       	jmp    800e29 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800be7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bea:	83 c0 04             	add    $0x4,%eax
  800bed:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf3:	83 e8 04             	sub    $0x4,%eax
  800bf6:	8b 30                	mov    (%eax),%esi
  800bf8:	85 f6                	test   %esi,%esi
  800bfa:	75 05                	jne    800c01 <vprintfmt+0x1a6>
				p = "(null)";
  800bfc:	be 51 44 80 00       	mov    $0x804451,%esi
			if (width > 0 && padc != '-')
  800c01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c05:	7e 6d                	jle    800c74 <vprintfmt+0x219>
  800c07:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c0b:	74 67                	je     800c74 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	50                   	push   %eax
  800c14:	56                   	push   %esi
  800c15:	e8 1e 03 00 00       	call   800f38 <strnlen>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c20:	eb 16                	jmp    800c38 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c22:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 0c             	pushl  0xc(%ebp)
  800c2c:	50                   	push   %eax
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	ff d0                	call   *%eax
  800c32:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c35:	ff 4d e4             	decl   -0x1c(%ebp)
  800c38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3c:	7f e4                	jg     800c22 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c3e:	eb 34                	jmp    800c74 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c40:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c44:	74 1c                	je     800c62 <vprintfmt+0x207>
  800c46:	83 fb 1f             	cmp    $0x1f,%ebx
  800c49:	7e 05                	jle    800c50 <vprintfmt+0x1f5>
  800c4b:	83 fb 7e             	cmp    $0x7e,%ebx
  800c4e:	7e 12                	jle    800c62 <vprintfmt+0x207>
					putch('?', putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	6a 3f                	push   $0x3f
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
  800c60:	eb 0f                	jmp    800c71 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	53                   	push   %ebx
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	ff d0                	call   *%eax
  800c6e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c71:	ff 4d e4             	decl   -0x1c(%ebp)
  800c74:	89 f0                	mov    %esi,%eax
  800c76:	8d 70 01             	lea    0x1(%eax),%esi
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	0f be d8             	movsbl %al,%ebx
  800c7e:	85 db                	test   %ebx,%ebx
  800c80:	74 24                	je     800ca6 <vprintfmt+0x24b>
  800c82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c86:	78 b8                	js     800c40 <vprintfmt+0x1e5>
  800c88:	ff 4d e0             	decl   -0x20(%ebp)
  800c8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c8f:	79 af                	jns    800c40 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c91:	eb 13                	jmp    800ca6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 0c             	pushl  0xc(%ebp)
  800c99:	6a 20                	push   $0x20
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	ff d0                	call   *%eax
  800ca0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ca3:	ff 4d e4             	decl   -0x1c(%ebp)
  800ca6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800caa:	7f e7                	jg     800c93 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800cac:	e9 78 01 00 00       	jmp    800e29 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800cb1:	83 ec 08             	sub    $0x8,%esp
  800cb4:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb7:	8d 45 14             	lea    0x14(%ebp),%eax
  800cba:	50                   	push   %eax
  800cbb:	e8 3c fd ff ff       	call   8009fc <getint>
  800cc0:	83 c4 10             	add    $0x10,%esp
  800cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ccc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ccf:	85 d2                	test   %edx,%edx
  800cd1:	79 23                	jns    800cf6 <vprintfmt+0x29b>
				putch('-', putdat);
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	6a 2d                	push   $0x2d
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	ff d0                	call   *%eax
  800ce0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ce9:	f7 d8                	neg    %eax
  800ceb:	83 d2 00             	adc    $0x0,%edx
  800cee:	f7 da                	neg    %edx
  800cf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cf6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cfd:	e9 bc 00 00 00       	jmp    800dbe <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d02:	83 ec 08             	sub    $0x8,%esp
  800d05:	ff 75 e8             	pushl  -0x18(%ebp)
  800d08:	8d 45 14             	lea    0x14(%ebp),%eax
  800d0b:	50                   	push   %eax
  800d0c:	e8 84 fc ff ff       	call   800995 <getuint>
  800d11:	83 c4 10             	add    $0x10,%esp
  800d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d1a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d21:	e9 98 00 00 00       	jmp    800dbe <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d26:	83 ec 08             	sub    $0x8,%esp
  800d29:	ff 75 0c             	pushl  0xc(%ebp)
  800d2c:	6a 58                	push   $0x58
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	ff d0                	call   *%eax
  800d33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	6a 58                	push   $0x58
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	ff 75 0c             	pushl  0xc(%ebp)
  800d4c:	6a 58                	push   $0x58
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	ff d0                	call   *%eax
  800d53:	83 c4 10             	add    $0x10,%esp
			break;
  800d56:	e9 ce 00 00 00       	jmp    800e29 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d5b:	83 ec 08             	sub    $0x8,%esp
  800d5e:	ff 75 0c             	pushl  0xc(%ebp)
  800d61:	6a 30                	push   $0x30
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	ff d0                	call   *%eax
  800d68:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d6b:	83 ec 08             	sub    $0x8,%esp
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	6a 78                	push   $0x78
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	ff d0                	call   *%eax
  800d78:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7e:	83 c0 04             	add    $0x4,%eax
  800d81:	89 45 14             	mov    %eax,0x14(%ebp)
  800d84:	8b 45 14             	mov    0x14(%ebp),%eax
  800d87:	83 e8 04             	sub    $0x4,%eax
  800d8a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d96:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d9d:	eb 1f                	jmp    800dbe <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d9f:	83 ec 08             	sub    $0x8,%esp
  800da2:	ff 75 e8             	pushl  -0x18(%ebp)
  800da5:	8d 45 14             	lea    0x14(%ebp),%eax
  800da8:	50                   	push   %eax
  800da9:	e8 e7 fb ff ff       	call   800995 <getuint>
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800db7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dbe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800dc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dc5:	83 ec 04             	sub    $0x4,%esp
  800dc8:	52                   	push   %edx
  800dc9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dcc:	50                   	push   %eax
  800dcd:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd0:	ff 75 f0             	pushl  -0x10(%ebp)
  800dd3:	ff 75 0c             	pushl  0xc(%ebp)
  800dd6:	ff 75 08             	pushl  0x8(%ebp)
  800dd9:	e8 00 fb ff ff       	call   8008de <printnum>
  800dde:	83 c4 20             	add    $0x20,%esp
			break;
  800de1:	eb 46                	jmp    800e29 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800de3:	83 ec 08             	sub    $0x8,%esp
  800de6:	ff 75 0c             	pushl  0xc(%ebp)
  800de9:	53                   	push   %ebx
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	ff d0                	call   *%eax
  800def:	83 c4 10             	add    $0x10,%esp
			break;
  800df2:	eb 35                	jmp    800e29 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800df4:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800dfb:	eb 2c                	jmp    800e29 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800dfd:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800e04:	eb 23                	jmp    800e29 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e06:	83 ec 08             	sub    $0x8,%esp
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	6a 25                	push   $0x25
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	ff d0                	call   *%eax
  800e13:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e16:	ff 4d 10             	decl   0x10(%ebp)
  800e19:	eb 03                	jmp    800e1e <vprintfmt+0x3c3>
  800e1b:	ff 4d 10             	decl   0x10(%ebp)
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	48                   	dec    %eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3c 25                	cmp    $0x25,%al
  800e26:	75 f3                	jne    800e1b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e28:	90                   	nop
		}
	}
  800e29:	e9 35 fc ff ff       	jmp    800a63 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e2e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e32:	5b                   	pop    %ebx
  800e33:	5e                   	pop    %esi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e3c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e3f:	83 c0 04             	add    $0x4,%eax
  800e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	ff 75 f4             	pushl  -0xc(%ebp)
  800e4b:	50                   	push   %eax
  800e4c:	ff 75 0c             	pushl  0xc(%ebp)
  800e4f:	ff 75 08             	pushl  0x8(%ebp)
  800e52:	e8 04 fc ff ff       	call   800a5b <vprintfmt>
  800e57:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e5a:	90                   	nop
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8b 40 08             	mov    0x8(%eax),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	8b 10                	mov    (%eax),%edx
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	8b 40 04             	mov    0x4(%eax),%eax
  800e7a:	39 c2                	cmp    %eax,%edx
  800e7c:	73 12                	jae    800e90 <sprintputch+0x33>
		*b->buf++ = ch;
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	8b 00                	mov    (%eax),%eax
  800e83:	8d 48 01             	lea    0x1(%eax),%ecx
  800e86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e89:	89 0a                	mov    %ecx,(%edx)
  800e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8e:	88 10                	mov    %dl,(%eax)
}
  800e90:	90                   	nop
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	01 d0                	add    %edx,%eax
  800eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ead:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800eb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eb8:	74 06                	je     800ec0 <vsnprintf+0x2d>
  800eba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebe:	7f 07                	jg     800ec7 <vsnprintf+0x34>
		return -E_INVAL;
  800ec0:	b8 03 00 00 00       	mov    $0x3,%eax
  800ec5:	eb 20                	jmp    800ee7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ec7:	ff 75 14             	pushl  0x14(%ebp)
  800eca:	ff 75 10             	pushl  0x10(%ebp)
  800ecd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ed0:	50                   	push   %eax
  800ed1:	68 5d 0e 80 00       	push   $0x800e5d
  800ed6:	e8 80 fb ff ff       	call   800a5b <vprintfmt>
  800edb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ede:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ee1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800eef:	8d 45 10             	lea    0x10(%ebp),%eax
  800ef2:	83 c0 04             	add    $0x4,%eax
  800ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  800efb:	ff 75 f4             	pushl  -0xc(%ebp)
  800efe:	50                   	push   %eax
  800eff:	ff 75 0c             	pushl  0xc(%ebp)
  800f02:	ff 75 08             	pushl  0x8(%ebp)
  800f05:	e8 89 ff ff ff       	call   800e93 <vsnprintf>
  800f0a:	83 c4 10             	add    $0x10,%esp
  800f0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f22:	eb 06                	jmp    800f2a <strlen+0x15>
		n++;
  800f24:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f27:	ff 45 08             	incl   0x8(%ebp)
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	84 c0                	test   %al,%al
  800f31:	75 f1                	jne    800f24 <strlen+0xf>
		n++;
	return n;
  800f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f45:	eb 09                	jmp    800f50 <strnlen+0x18>
		n++;
  800f47:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f4a:	ff 45 08             	incl   0x8(%ebp)
  800f4d:	ff 4d 0c             	decl   0xc(%ebp)
  800f50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f54:	74 09                	je     800f5f <strnlen+0x27>
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	84 c0                	test   %al,%al
  800f5d:	75 e8                	jne    800f47 <strnlen+0xf>
		n++;
	return n;
  800f5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f70:	90                   	nop
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8d 50 01             	lea    0x1(%eax),%edx
  800f77:	89 55 08             	mov    %edx,0x8(%ebp)
  800f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f7d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f80:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f83:	8a 12                	mov    (%edx),%dl
  800f85:	88 10                	mov    %dl,(%eax)
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	84 c0                	test   %al,%al
  800f8b:	75 e4                	jne    800f71 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fa5:	eb 1f                	jmp    800fc6 <strncpy+0x34>
		*dst++ = *src;
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8d 50 01             	lea    0x1(%eax),%edx
  800fad:	89 55 08             	mov    %edx,0x8(%ebp)
  800fb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb3:	8a 12                	mov    (%edx),%dl
  800fb5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	84 c0                	test   %al,%al
  800fbe:	74 03                	je     800fc3 <strncpy+0x31>
			src++;
  800fc0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fc3:	ff 45 fc             	incl   -0x4(%ebp)
  800fc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fcc:	72 d9                	jb     800fa7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fce:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	74 30                	je     801015 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fe5:	eb 16                	jmp    800ffd <strlcpy+0x2a>
			*dst++ = *src++;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8d 50 01             	lea    0x1(%eax),%edx
  800fed:	89 55 08             	mov    %edx,0x8(%ebp)
  800ff0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ff6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ff9:	8a 12                	mov    (%edx),%dl
  800ffb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ffd:	ff 4d 10             	decl   0x10(%ebp)
  801000:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801004:	74 09                	je     80100f <strlcpy+0x3c>
  801006:	8b 45 0c             	mov    0xc(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	84 c0                	test   %al,%al
  80100d:	75 d8                	jne    800fe7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101b:	29 c2                	sub    %eax,%edx
  80101d:	89 d0                	mov    %edx,%eax
}
  80101f:	c9                   	leave  
  801020:	c3                   	ret    

00801021 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801024:	eb 06                	jmp    80102c <strcmp+0xb>
		p++, q++;
  801026:	ff 45 08             	incl   0x8(%ebp)
  801029:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	74 0e                	je     801043 <strcmp+0x22>
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 10                	mov    (%eax),%dl
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	38 c2                	cmp    %al,%dl
  801041:	74 e3                	je     801026 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	0f b6 d0             	movzbl %al,%edx
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f b6 c0             	movzbl %al,%eax
  801053:	29 c2                	sub    %eax,%edx
  801055:	89 d0                	mov    %edx,%eax
}
  801057:	5d                   	pop    %ebp
  801058:	c3                   	ret    

00801059 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80105c:	eb 09                	jmp    801067 <strncmp+0xe>
		n--, p++, q++;
  80105e:	ff 4d 10             	decl   0x10(%ebp)
  801061:	ff 45 08             	incl   0x8(%ebp)
  801064:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801067:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106b:	74 17                	je     801084 <strncmp+0x2b>
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	84 c0                	test   %al,%al
  801074:	74 0e                	je     801084 <strncmp+0x2b>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 10                	mov    (%eax),%dl
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	38 c2                	cmp    %al,%dl
  801082:	74 da                	je     80105e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801084:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801088:	75 07                	jne    801091 <strncmp+0x38>
		return 0;
  80108a:	b8 00 00 00 00       	mov    $0x0,%eax
  80108f:	eb 14                	jmp    8010a5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	0f b6 d0             	movzbl %al,%edx
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	0f b6 c0             	movzbl %al,%eax
  8010a1:	29 c2                	sub    %eax,%edx
  8010a3:	89 d0                	mov    %edx,%eax
}
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    

008010a7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010b3:	eb 12                	jmp    8010c7 <strchr+0x20>
		if (*s == c)
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010bd:	75 05                	jne    8010c4 <strchr+0x1d>
			return (char *) s;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	eb 11                	jmp    8010d5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	84 c0                	test   %al,%al
  8010ce:	75 e5                	jne    8010b5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    

008010d7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	83 ec 04             	sub    $0x4,%esp
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010e3:	eb 0d                	jmp    8010f2 <strfind+0x1b>
		if (*s == c)
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010ed:	74 0e                	je     8010fd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010ef:	ff 45 08             	incl   0x8(%ebp)
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	84 c0                	test   %al,%al
  8010f9:	75 ea                	jne    8010e5 <strfind+0xe>
  8010fb:	eb 01                	jmp    8010fe <strfind+0x27>
		if (*s == c)
			break;
  8010fd:	90                   	nop
	return (char *) s;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80110f:	8b 45 10             	mov    0x10(%ebp),%eax
  801112:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801115:	eb 0e                	jmp    801125 <memset+0x22>
		*p++ = c;
  801117:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111a:	8d 50 01             	lea    0x1(%eax),%edx
  80111d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801120:	8b 55 0c             	mov    0xc(%ebp),%edx
  801123:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801125:	ff 4d f8             	decl   -0x8(%ebp)
  801128:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80112c:	79 e9                	jns    801117 <memset+0x14>
		*p++ = c;

	return v;
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801131:	c9                   	leave  
  801132:	c3                   	ret    

00801133 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801145:	eb 16                	jmp    80115d <memcpy+0x2a>
		*d++ = *s++;
  801147:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114a:	8d 50 01             	lea    0x1(%eax),%edx
  80114d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801150:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801153:	8d 4a 01             	lea    0x1(%edx),%ecx
  801156:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801159:	8a 12                	mov    (%edx),%dl
  80115b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80115d:	8b 45 10             	mov    0x10(%ebp),%eax
  801160:	8d 50 ff             	lea    -0x1(%eax),%edx
  801163:	89 55 10             	mov    %edx,0x10(%ebp)
  801166:	85 c0                	test   %eax,%eax
  801168:	75 dd                	jne    801147 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801175:	8b 45 0c             	mov    0xc(%ebp),%eax
  801178:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80117b:	8b 45 08             	mov    0x8(%ebp),%eax
  80117e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801181:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801184:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801187:	73 50                	jae    8011d9 <memmove+0x6a>
  801189:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801194:	76 43                	jbe    8011d9 <memmove+0x6a>
		s += n;
  801196:	8b 45 10             	mov    0x10(%ebp),%eax
  801199:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80119c:	8b 45 10             	mov    0x10(%ebp),%eax
  80119f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011a2:	eb 10                	jmp    8011b4 <memmove+0x45>
			*--d = *--s;
  8011a4:	ff 4d f8             	decl   -0x8(%ebp)
  8011a7:	ff 4d fc             	decl   -0x4(%ebp)
  8011aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ad:	8a 10                	mov    (%eax),%dl
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	75 e3                	jne    8011a4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011c1:	eb 23                	jmp    8011e6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c6:	8d 50 01             	lea    0x1(%eax),%edx
  8011c9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011d5:	8a 12                	mov    (%edx),%dl
  8011d7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011df:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e2:	85 c0                	test   %eax,%eax
  8011e4:	75 dd                	jne    8011c3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    

008011eb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011fd:	eb 2a                	jmp    801229 <memcmp+0x3e>
		if (*s1 != *s2)
  8011ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801202:	8a 10                	mov    (%eax),%dl
  801204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801207:	8a 00                	mov    (%eax),%al
  801209:	38 c2                	cmp    %al,%dl
  80120b:	74 16                	je     801223 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80120d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	0f b6 d0             	movzbl %al,%edx
  801215:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f b6 c0             	movzbl %al,%eax
  80121d:	29 c2                	sub    %eax,%edx
  80121f:	89 d0                	mov    %edx,%eax
  801221:	eb 18                	jmp    80123b <memcmp+0x50>
		s1++, s2++;
  801223:	ff 45 fc             	incl   -0x4(%ebp)
  801226:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80122f:	89 55 10             	mov    %edx,0x10(%ebp)
  801232:	85 c0                	test   %eax,%eax
  801234:	75 c9                	jne    8011ff <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801236:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123b:	c9                   	leave  
  80123c:	c3                   	ret    

0080123d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
  801246:	8b 45 10             	mov    0x10(%ebp),%eax
  801249:	01 d0                	add    %edx,%eax
  80124b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80124e:	eb 15                	jmp    801265 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	0f b6 d0             	movzbl %al,%edx
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	0f b6 c0             	movzbl %al,%eax
  80125e:	39 c2                	cmp    %eax,%edx
  801260:	74 0d                	je     80126f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801262:	ff 45 08             	incl   0x8(%ebp)
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80126b:	72 e3                	jb     801250 <memfind+0x13>
  80126d:	eb 01                	jmp    801270 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80126f:	90                   	nop
	return (void *) s;
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801282:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801289:	eb 03                	jmp    80128e <strtol+0x19>
		s++;
  80128b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	3c 20                	cmp    $0x20,%al
  801295:	74 f4                	je     80128b <strtol+0x16>
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	3c 09                	cmp    $0x9,%al
  80129e:	74 eb                	je     80128b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	3c 2b                	cmp    $0x2b,%al
  8012a7:	75 05                	jne    8012ae <strtol+0x39>
		s++;
  8012a9:	ff 45 08             	incl   0x8(%ebp)
  8012ac:	eb 13                	jmp    8012c1 <strtol+0x4c>
	else if (*s == '-')
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	3c 2d                	cmp    $0x2d,%al
  8012b5:	75 0a                	jne    8012c1 <strtol+0x4c>
		s++, neg = 1;
  8012b7:	ff 45 08             	incl   0x8(%ebp)
  8012ba:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c5:	74 06                	je     8012cd <strtol+0x58>
  8012c7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012cb:	75 20                	jne    8012ed <strtol+0x78>
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	3c 30                	cmp    $0x30,%al
  8012d4:	75 17                	jne    8012ed <strtol+0x78>
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	40                   	inc    %eax
  8012da:	8a 00                	mov    (%eax),%al
  8012dc:	3c 78                	cmp    $0x78,%al
  8012de:	75 0d                	jne    8012ed <strtol+0x78>
		s += 2, base = 16;
  8012e0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012e4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012eb:	eb 28                	jmp    801315 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f1:	75 15                	jne    801308 <strtol+0x93>
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	8a 00                	mov    (%eax),%al
  8012f8:	3c 30                	cmp    $0x30,%al
  8012fa:	75 0c                	jne    801308 <strtol+0x93>
		s++, base = 8;
  8012fc:	ff 45 08             	incl   0x8(%ebp)
  8012ff:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801306:	eb 0d                	jmp    801315 <strtol+0xa0>
	else if (base == 0)
  801308:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80130c:	75 07                	jne    801315 <strtol+0xa0>
		base = 10;
  80130e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	8a 00                	mov    (%eax),%al
  80131a:	3c 2f                	cmp    $0x2f,%al
  80131c:	7e 19                	jle    801337 <strtol+0xc2>
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	3c 39                	cmp    $0x39,%al
  801325:	7f 10                	jg     801337 <strtol+0xc2>
			dig = *s - '0';
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	8a 00                	mov    (%eax),%al
  80132c:	0f be c0             	movsbl %al,%eax
  80132f:	83 e8 30             	sub    $0x30,%eax
  801332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801335:	eb 42                	jmp    801379 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	3c 60                	cmp    $0x60,%al
  80133e:	7e 19                	jle    801359 <strtol+0xe4>
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	3c 7a                	cmp    $0x7a,%al
  801347:	7f 10                	jg     801359 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 00                	mov    (%eax),%al
  80134e:	0f be c0             	movsbl %al,%eax
  801351:	83 e8 57             	sub    $0x57,%eax
  801354:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801357:	eb 20                	jmp    801379 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	3c 40                	cmp    $0x40,%al
  801360:	7e 39                	jle    80139b <strtol+0x126>
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	3c 5a                	cmp    $0x5a,%al
  801369:	7f 30                	jg     80139b <strtol+0x126>
			dig = *s - 'A' + 10;
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	0f be c0             	movsbl %al,%eax
  801373:	83 e8 37             	sub    $0x37,%eax
  801376:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80137f:	7d 19                	jge    80139a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801381:	ff 45 08             	incl   0x8(%ebp)
  801384:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801387:	0f af 45 10          	imul   0x10(%ebp),%eax
  80138b:	89 c2                	mov    %eax,%edx
  80138d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801390:	01 d0                	add    %edx,%eax
  801392:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801395:	e9 7b ff ff ff       	jmp    801315 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80139a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80139b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139f:	74 08                	je     8013a9 <strtol+0x134>
		*endptr = (char *) s;
  8013a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013ad:	74 07                	je     8013b6 <strtol+0x141>
  8013af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b2:	f7 d8                	neg    %eax
  8013b4:	eb 03                	jmp    8013b9 <strtol+0x144>
  8013b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <ltostr>:

void
ltostr(long value, char *str)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013d3:	79 13                	jns    8013e8 <ltostr+0x2d>
	{
		neg = 1;
  8013d5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013df:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013e2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013e5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013f0:	99                   	cltd   
  8013f1:	f7 f9                	idiv   %ecx
  8013f3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f9:	8d 50 01             	lea    0x1(%eax),%edx
  8013fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013ff:	89 c2                	mov    %eax,%edx
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	01 d0                	add    %edx,%eax
  801406:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801409:	83 c2 30             	add    $0x30,%edx
  80140c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80140e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801411:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801416:	f7 e9                	imul   %ecx
  801418:	c1 fa 02             	sar    $0x2,%edx
  80141b:	89 c8                	mov    %ecx,%eax
  80141d:	c1 f8 1f             	sar    $0x1f,%eax
  801420:	29 c2                	sub    %eax,%edx
  801422:	89 d0                	mov    %edx,%eax
  801424:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801427:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80142b:	75 bb                	jne    8013e8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80142d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801434:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801437:	48                   	dec    %eax
  801438:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80143b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80143f:	74 3d                	je     80147e <ltostr+0xc3>
		start = 1 ;
  801441:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801448:	eb 34                	jmp    80147e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80144a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	01 d0                	add    %edx,%eax
  801452:	8a 00                	mov    (%eax),%al
  801454:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801457:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145d:	01 c2                	add    %eax,%edx
  80145f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
  801465:	01 c8                	add    %ecx,%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80146b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80146e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801471:	01 c2                	add    %eax,%edx
  801473:	8a 45 eb             	mov    -0x15(%ebp),%al
  801476:	88 02                	mov    %al,(%edx)
		start++ ;
  801478:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80147b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80147e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801481:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801484:	7c c4                	jl     80144a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801486:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	01 d0                	add    %edx,%eax
  80148e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801491:	90                   	nop
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80149a:	ff 75 08             	pushl  0x8(%ebp)
  80149d:	e8 73 fa ff ff       	call   800f15 <strlen>
  8014a2:	83 c4 04             	add    $0x4,%esp
  8014a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	e8 65 fa ff ff       	call   800f15 <strlen>
  8014b0:	83 c4 04             	add    $0x4,%esp
  8014b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c4:	eb 17                	jmp    8014dd <strcconcat+0x49>
		final[s] = str1[s] ;
  8014c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	01 c2                	add    %eax,%edx
  8014ce:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	01 c8                	add    %ecx,%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014da:	ff 45 fc             	incl   -0x4(%ebp)
  8014dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014e3:	7c e1                	jl     8014c6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014f3:	eb 1f                	jmp    801514 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f8:	8d 50 01             	lea    0x1(%eax),%edx
  8014fb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014fe:	89 c2                	mov    %eax,%edx
  801500:	8b 45 10             	mov    0x10(%ebp),%eax
  801503:	01 c2                	add    %eax,%edx
  801505:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	01 c8                	add    %ecx,%eax
  80150d:	8a 00                	mov    (%eax),%al
  80150f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801511:	ff 45 f8             	incl   -0x8(%ebp)
  801514:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801517:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80151a:	7c d9                	jl     8014f5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80151c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151f:	8b 45 10             	mov    0x10(%ebp),%eax
  801522:	01 d0                	add    %edx,%eax
  801524:	c6 00 00             	movb   $0x0,(%eax)
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80152d:	8b 45 14             	mov    0x14(%ebp),%eax
  801530:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801536:	8b 45 14             	mov    0x14(%ebp),%eax
  801539:	8b 00                	mov    (%eax),%eax
  80153b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801542:	8b 45 10             	mov    0x10(%ebp),%eax
  801545:	01 d0                	add    %edx,%eax
  801547:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154d:	eb 0c                	jmp    80155b <strsplit+0x31>
			*string++ = 0;
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	8d 50 01             	lea    0x1(%eax),%edx
  801555:	89 55 08             	mov    %edx,0x8(%ebp)
  801558:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	8a 00                	mov    (%eax),%al
  801560:	84 c0                	test   %al,%al
  801562:	74 18                	je     80157c <strsplit+0x52>
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	0f be c0             	movsbl %al,%eax
  80156c:	50                   	push   %eax
  80156d:	ff 75 0c             	pushl  0xc(%ebp)
  801570:	e8 32 fb ff ff       	call   8010a7 <strchr>
  801575:	83 c4 08             	add    $0x8,%esp
  801578:	85 c0                	test   %eax,%eax
  80157a:	75 d3                	jne    80154f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	8a 00                	mov    (%eax),%al
  801581:	84 c0                	test   %al,%al
  801583:	74 5a                	je     8015df <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801585:	8b 45 14             	mov    0x14(%ebp),%eax
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	83 f8 0f             	cmp    $0xf,%eax
  80158d:	75 07                	jne    801596 <strsplit+0x6c>
		{
			return 0;
  80158f:	b8 00 00 00 00       	mov    $0x0,%eax
  801594:	eb 66                	jmp    8015fc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801596:	8b 45 14             	mov    0x14(%ebp),%eax
  801599:	8b 00                	mov    (%eax),%eax
  80159b:	8d 48 01             	lea    0x1(%eax),%ecx
  80159e:	8b 55 14             	mov    0x14(%ebp),%edx
  8015a1:	89 0a                	mov    %ecx,(%edx)
  8015a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ad:	01 c2                	add    %eax,%edx
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015b4:	eb 03                	jmp    8015b9 <strsplit+0x8f>
			string++;
  8015b6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	84 c0                	test   %al,%al
  8015c0:	74 8b                	je     80154d <strsplit+0x23>
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	0f be c0             	movsbl %al,%eax
  8015ca:	50                   	push   %eax
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	e8 d4 fa ff ff       	call   8010a7 <strchr>
  8015d3:	83 c4 08             	add    $0x8,%esp
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	74 dc                	je     8015b6 <strsplit+0x8c>
			string++;
	}
  8015da:	e9 6e ff ff ff       	jmp    80154d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015df:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e3:	8b 00                	mov    (%eax),%eax
  8015e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ef:	01 d0                	add    %edx,%eax
  8015f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015f7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801604:	83 ec 04             	sub    $0x4,%esp
  801607:	68 c8 45 80 00       	push   $0x8045c8
  80160c:	68 3f 01 00 00       	push   $0x13f
  801611:	68 ea 45 80 00       	push   $0x8045ea
  801616:	e8 a9 ef ff ff       	call   8005c4 <_panic>

0080161b <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801621:	83 ec 0c             	sub    $0xc,%esp
  801624:	ff 75 08             	pushl  0x8(%ebp)
  801627:	e8 35 0a 00 00       	call   802061 <sys_sbrk>
  80162c:	83 c4 10             	add    $0x10,%esp
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801637:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80163b:	75 0a                	jne    801647 <malloc+0x16>
  80163d:	b8 00 00 00 00       	mov    $0x0,%eax
  801642:	e9 07 02 00 00       	jmp    80184e <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801647:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80164e:	8b 55 08             	mov    0x8(%ebp),%edx
  801651:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801654:	01 d0                	add    %edx,%eax
  801656:	48                   	dec    %eax
  801657:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80165a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80165d:	ba 00 00 00 00       	mov    $0x0,%edx
  801662:	f7 75 dc             	divl   -0x24(%ebp)
  801665:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801668:	29 d0                	sub    %edx,%eax
  80166a:	c1 e8 0c             	shr    $0xc,%eax
  80166d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801670:	a1 20 50 80 00       	mov    0x805020,%eax
  801675:	8b 40 78             	mov    0x78(%eax),%eax
  801678:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80167d:	29 c2                	sub    %eax,%edx
  80167f:	89 d0                	mov    %edx,%eax
  801681:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801684:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801687:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80168c:	c1 e8 0c             	shr    $0xc,%eax
  80168f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801692:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801699:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8016a0:	77 42                	ja     8016e4 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016a2:	e8 3e 08 00 00       	call   801ee5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	74 16                	je     8016c1 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8016ab:	83 ec 0c             	sub    $0xc,%esp
  8016ae:	ff 75 08             	pushl  0x8(%ebp)
  8016b1:	e8 7e 0d 00 00       	call   802434 <alloc_block_FF>
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016bc:	e9 8a 01 00 00       	jmp    80184b <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8016c1:	e8 50 08 00 00       	call   801f16 <sys_isUHeapPlacementStrategyBESTFIT>
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	0f 84 7d 01 00 00    	je     80184b <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8016ce:	83 ec 0c             	sub    $0xc,%esp
  8016d1:	ff 75 08             	pushl  0x8(%ebp)
  8016d4:	e8 17 12 00 00       	call   8028f0 <alloc_block_BF>
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016df:	e9 67 01 00 00       	jmp    80184b <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8016e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8016e7:	48                   	dec    %eax
  8016e8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8016eb:	0f 86 53 01 00 00    	jbe    801844 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8016f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8016f6:	8b 40 78             	mov    0x78(%eax),%eax
  8016f9:	05 00 10 00 00       	add    $0x1000,%eax
  8016fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801701:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801708:	e9 de 00 00 00       	jmp    8017eb <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80170d:	a1 20 50 80 00       	mov    0x805020,%eax
  801712:	8b 40 78             	mov    0x78(%eax),%eax
  801715:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801718:	29 c2                	sub    %eax,%edx
  80171a:	89 d0                	mov    %edx,%eax
  80171c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801721:	c1 e8 0c             	shr    $0xc,%eax
  801724:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80172b:	85 c0                	test   %eax,%eax
  80172d:	0f 85 ab 00 00 00    	jne    8017de <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801736:	05 00 10 00 00       	add    $0x1000,%eax
  80173b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80173e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801745:	eb 47                	jmp    80178e <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801747:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80174e:	76 0a                	jbe    80175a <malloc+0x129>
  801750:	b8 00 00 00 00       	mov    $0x0,%eax
  801755:	e9 f4 00 00 00       	jmp    80184e <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  80175a:	a1 20 50 80 00       	mov    0x805020,%eax
  80175f:	8b 40 78             	mov    0x78(%eax),%eax
  801762:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801765:	29 c2                	sub    %eax,%edx
  801767:	89 d0                	mov    %edx,%eax
  801769:	2d 00 10 00 00       	sub    $0x1000,%eax
  80176e:	c1 e8 0c             	shr    $0xc,%eax
  801771:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801778:	85 c0                	test   %eax,%eax
  80177a:	74 08                	je     801784 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  80177c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80177f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801782:	eb 5a                	jmp    8017de <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801784:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80178b:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  80178e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801791:	48                   	dec    %eax
  801792:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801795:	77 b0                	ja     801747 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801797:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  80179e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8017a5:	eb 2f                	jmp    8017d6 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8017a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017aa:	c1 e0 0c             	shl    $0xc,%eax
  8017ad:	89 c2                	mov    %eax,%edx
  8017af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b2:	01 c2                	add    %eax,%edx
  8017b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8017b9:	8b 40 78             	mov    0x78(%eax),%eax
  8017bc:	29 c2                	sub    %eax,%edx
  8017be:	89 d0                	mov    %edx,%eax
  8017c0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017c5:	c1 e8 0c             	shr    $0xc,%eax
  8017c8:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  8017cf:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8017d3:	ff 45 e0             	incl   -0x20(%ebp)
  8017d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017d9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017dc:	72 c9                	jb     8017a7 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8017de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017e2:	75 16                	jne    8017fa <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8017e4:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8017eb:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8017f2:	0f 86 15 ff ff ff    	jbe    80170d <malloc+0xdc>
  8017f8:	eb 01                	jmp    8017fb <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8017fa:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8017fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ff:	75 07                	jne    801808 <malloc+0x1d7>
  801801:	b8 00 00 00 00       	mov    $0x0,%eax
  801806:	eb 46                	jmp    80184e <malloc+0x21d>
		ptr = (void*)i;
  801808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  80180e:	a1 20 50 80 00       	mov    0x805020,%eax
  801813:	8b 40 78             	mov    0x78(%eax),%eax
  801816:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801819:	29 c2                	sub    %eax,%edx
  80181b:	89 d0                	mov    %edx,%eax
  80181d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801822:	c1 e8 0c             	shr    $0xc,%eax
  801825:	89 c2                	mov    %eax,%edx
  801827:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80182a:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801831:	83 ec 08             	sub    $0x8,%esp
  801834:	ff 75 08             	pushl  0x8(%ebp)
  801837:	ff 75 f0             	pushl  -0x10(%ebp)
  80183a:	e8 59 08 00 00       	call   802098 <sys_allocate_user_mem>
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	eb 07                	jmp    80184b <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801844:	b8 00 00 00 00       	mov    $0x0,%eax
  801849:	eb 03                	jmp    80184e <malloc+0x21d>
	}
	return ptr;
  80184b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801856:	a1 20 50 80 00       	mov    0x805020,%eax
  80185b:	8b 40 78             	mov    0x78(%eax),%eax
  80185e:	05 00 10 00 00       	add    $0x1000,%eax
  801863:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801866:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80186d:	a1 20 50 80 00       	mov    0x805020,%eax
  801872:	8b 50 78             	mov    0x78(%eax),%edx
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	39 c2                	cmp    %eax,%edx
  80187a:	76 24                	jbe    8018a0 <free+0x50>
		size = get_block_size(va);
  80187c:	83 ec 0c             	sub    $0xc,%esp
  80187f:	ff 75 08             	pushl  0x8(%ebp)
  801882:	e8 2d 08 00 00       	call   8020b4 <get_block_size>
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80188d:	83 ec 0c             	sub    $0xc,%esp
  801890:	ff 75 08             	pushl  0x8(%ebp)
  801893:	e8 60 1a 00 00       	call   8032f8 <free_block>
  801898:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80189b:	e9 ac 00 00 00       	jmp    80194c <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018a6:	0f 82 89 00 00 00    	jb     801935 <free+0xe5>
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8018b4:	77 7f                	ja     801935 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  8018b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8018be:	8b 40 78             	mov    0x78(%eax),%eax
  8018c1:	29 c2                	sub    %eax,%edx
  8018c3:	89 d0                	mov    %edx,%eax
  8018c5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018ca:	c1 e8 0c             	shr    $0xc,%eax
  8018cd:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8018d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8018d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018da:	c1 e0 0c             	shl    $0xc,%eax
  8018dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8018e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8018e7:	eb 2f                	jmp    801918 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8018e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ec:	c1 e0 0c             	shl    $0xc,%eax
  8018ef:	89 c2                	mov    %eax,%edx
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	01 c2                	add    %eax,%edx
  8018f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8018fb:	8b 40 78             	mov    0x78(%eax),%eax
  8018fe:	29 c2                	sub    %eax,%edx
  801900:	89 d0                	mov    %edx,%eax
  801902:	2d 00 10 00 00       	sub    $0x1000,%eax
  801907:	c1 e8 0c             	shr    $0xc,%eax
  80190a:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  801911:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801915:	ff 45 f4             	incl   -0xc(%ebp)
  801918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80191e:	72 c9                	jb     8018e9 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	83 ec 08             	sub    $0x8,%esp
  801926:	ff 75 ec             	pushl  -0x14(%ebp)
  801929:	50                   	push   %eax
  80192a:	e8 4d 07 00 00       	call   80207c <sys_free_user_mem>
  80192f:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801932:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801933:	eb 17                	jmp    80194c <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801935:	83 ec 04             	sub    $0x4,%esp
  801938:	68 f8 45 80 00       	push   $0x8045f8
  80193d:	68 84 00 00 00       	push   $0x84
  801942:	68 22 46 80 00       	push   $0x804622
  801947:	e8 78 ec ff ff       	call   8005c4 <_panic>
	}
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 28             	sub    $0x28,%esp
  801954:	8b 45 10             	mov    0x10(%ebp),%eax
  801957:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80195a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80195e:	75 07                	jne    801967 <smalloc+0x19>
  801960:	b8 00 00 00 00       	mov    $0x0,%eax
  801965:	eb 74                	jmp    8019db <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80196d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801974:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197a:	39 d0                	cmp    %edx,%eax
  80197c:	73 02                	jae    801980 <smalloc+0x32>
  80197e:	89 d0                	mov    %edx,%eax
  801980:	83 ec 0c             	sub    $0xc,%esp
  801983:	50                   	push   %eax
  801984:	e8 a8 fc ff ff       	call   801631 <malloc>
  801989:	83 c4 10             	add    $0x10,%esp
  80198c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80198f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801993:	75 07                	jne    80199c <smalloc+0x4e>
  801995:	b8 00 00 00 00       	mov    $0x0,%eax
  80199a:	eb 3f                	jmp    8019db <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80199c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8019a0:	ff 75 ec             	pushl  -0x14(%ebp)
  8019a3:	50                   	push   %eax
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	ff 75 08             	pushl  0x8(%ebp)
  8019aa:	e8 d4 02 00 00       	call   801c83 <sys_createSharedObject>
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8019b5:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8019b9:	74 06                	je     8019c1 <smalloc+0x73>
  8019bb:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8019bf:	75 07                	jne    8019c8 <smalloc+0x7a>
  8019c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c6:	eb 13                	jmp    8019db <smalloc+0x8d>
	 cprintf("153\n");
  8019c8:	83 ec 0c             	sub    $0xc,%esp
  8019cb:	68 2e 46 80 00       	push   $0x80462e
  8019d0:	e8 ac ee ff ff       	call   800881 <cprintf>
  8019d5:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8019d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	68 34 46 80 00       	push   $0x804634
  8019eb:	68 a4 00 00 00       	push   $0xa4
  8019f0:	68 22 46 80 00       	push   $0x804622
  8019f5:	e8 ca eb ff ff       	call   8005c4 <_panic>

008019fa <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	68 58 46 80 00       	push   $0x804658
  801a08:	68 bc 00 00 00       	push   $0xbc
  801a0d:	68 22 46 80 00       	push   $0x804622
  801a12:	e8 ad eb ff ff       	call   8005c4 <_panic>

00801a17 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a1d:	83 ec 04             	sub    $0x4,%esp
  801a20:	68 7c 46 80 00       	push   $0x80467c
  801a25:	68 d3 00 00 00       	push   $0xd3
  801a2a:	68 22 46 80 00       	push   $0x804622
  801a2f:	e8 90 eb ff ff       	call   8005c4 <_panic>

00801a34 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	68 a2 46 80 00       	push   $0x8046a2
  801a42:	68 df 00 00 00       	push   $0xdf
  801a47:	68 22 46 80 00       	push   $0x804622
  801a4c:	e8 73 eb ff ff       	call   8005c4 <_panic>

00801a51 <shrink>:

}
void shrink(uint32 newSize)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a57:	83 ec 04             	sub    $0x4,%esp
  801a5a:	68 a2 46 80 00       	push   $0x8046a2
  801a5f:	68 e4 00 00 00       	push   $0xe4
  801a64:	68 22 46 80 00       	push   $0x804622
  801a69:	e8 56 eb ff ff       	call   8005c4 <_panic>

00801a6e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a74:	83 ec 04             	sub    $0x4,%esp
  801a77:	68 a2 46 80 00       	push   $0x8046a2
  801a7c:	68 e9 00 00 00       	push   $0xe9
  801a81:	68 22 46 80 00       	push   $0x804622
  801a86:	e8 39 eb ff ff       	call   8005c4 <_panic>

00801a8b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	57                   	push   %edi
  801a8f:	56                   	push   %esi
  801a90:	53                   	push   %ebx
  801a91:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aa0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801aa3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801aa6:	cd 30                	int    $0x30
  801aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	5b                   	pop    %ebx
  801ab2:	5e                   	pop    %esi
  801ab3:	5f                   	pop    %edi
  801ab4:	5d                   	pop    %ebp
  801ab5:	c3                   	ret    

00801ab6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 04             	sub    $0x4,%esp
  801abc:	8b 45 10             	mov    0x10(%ebp),%eax
  801abf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ac2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	52                   	push   %edx
  801ace:	ff 75 0c             	pushl  0xc(%ebp)
  801ad1:	50                   	push   %eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	e8 b2 ff ff ff       	call   801a8b <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	90                   	nop
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_cgetc>:

int
sys_cgetc(void)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 02                	push   $0x2
  801aee:	e8 98 ff ff ff       	call   801a8b <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 03                	push   $0x3
  801b07:	e8 7f ff ff ff       	call   801a8b <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 04                	push   $0x4
  801b21:	e8 65 ff ff ff       	call   801a8b <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	90                   	nop
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	52                   	push   %edx
  801b3c:	50                   	push   %eax
  801b3d:	6a 08                	push   $0x8
  801b3f:	e8 47 ff ff ff       	call   801a8b <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	56                   	push   %esi
  801b4d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b4e:	8b 75 18             	mov    0x18(%ebp),%esi
  801b51:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b54:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	56                   	push   %esi
  801b5e:	53                   	push   %ebx
  801b5f:	51                   	push   %ecx
  801b60:	52                   	push   %edx
  801b61:	50                   	push   %eax
  801b62:	6a 09                	push   $0x9
  801b64:	e8 22 ff ff ff       	call   801a8b <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b6f:	5b                   	pop    %ebx
  801b70:	5e                   	pop    %esi
  801b71:	5d                   	pop    %ebp
  801b72:	c3                   	ret    

00801b73 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	52                   	push   %edx
  801b83:	50                   	push   %eax
  801b84:	6a 0a                	push   $0xa
  801b86:	e8 00 ff ff ff       	call   801a8b <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	ff 75 08             	pushl  0x8(%ebp)
  801b9f:	6a 0b                	push   $0xb
  801ba1:	e8 e5 fe ff ff       	call   801a8b <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 0c                	push   $0xc
  801bba:	e8 cc fe ff ff       	call   801a8b <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 0d                	push   $0xd
  801bd3:	e8 b3 fe ff ff       	call   801a8b <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 0e                	push   $0xe
  801bec:	e8 9a fe ff ff       	call   801a8b <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 0f                	push   $0xf
  801c05:	e8 81 fe ff ff       	call   801a8b <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	ff 75 08             	pushl  0x8(%ebp)
  801c1d:	6a 10                	push   $0x10
  801c1f:	e8 67 fe ff ff       	call   801a8b <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 11                	push   $0x11
  801c38:	e8 4e fe ff ff       	call   801a8b <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	90                   	nop
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 04             	sub    $0x4,%esp
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c4f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	50                   	push   %eax
  801c5c:	6a 01                	push   $0x1
  801c5e:	e8 28 fe ff ff       	call   801a8b <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	90                   	nop
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 14                	push   $0x14
  801c78:	e8 0e fe ff ff       	call   801a8b <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	90                   	nop
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 04             	sub    $0x4,%esp
  801c89:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c8f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c92:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	6a 00                	push   $0x0
  801c9b:	51                   	push   %ecx
  801c9c:	52                   	push   %edx
  801c9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ca0:	50                   	push   %eax
  801ca1:	6a 15                	push   $0x15
  801ca3:	e8 e3 fd ff ff       	call   801a8b <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	52                   	push   %edx
  801cbd:	50                   	push   %eax
  801cbe:	6a 16                	push   $0x16
  801cc0:	e8 c6 fd ff ff       	call   801a8b <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ccd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	51                   	push   %ecx
  801cdb:	52                   	push   %edx
  801cdc:	50                   	push   %eax
  801cdd:	6a 17                	push   $0x17
  801cdf:	e8 a7 fd ff ff       	call   801a8b <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	52                   	push   %edx
  801cf9:	50                   	push   %eax
  801cfa:	6a 18                	push   $0x18
  801cfc:	e8 8a fd ff ff       	call   801a8b <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	ff 75 14             	pushl  0x14(%ebp)
  801d11:	ff 75 10             	pushl  0x10(%ebp)
  801d14:	ff 75 0c             	pushl  0xc(%ebp)
  801d17:	50                   	push   %eax
  801d18:	6a 19                	push   $0x19
  801d1a:	e8 6c fd ff ff       	call   801a8b <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	50                   	push   %eax
  801d33:	6a 1a                	push   $0x1a
  801d35:	e8 51 fd ff ff       	call   801a8b <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
}
  801d3d:	90                   	nop
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	50                   	push   %eax
  801d4f:	6a 1b                	push   $0x1b
  801d51:	e8 35 fd ff ff       	call   801a8b <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 05                	push   $0x5
  801d6a:	e8 1c fd ff ff       	call   801a8b <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 06                	push   $0x6
  801d83:	e8 03 fd ff ff       	call   801a8b <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 07                	push   $0x7
  801d9c:	e8 ea fc ff ff       	call   801a8b <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <sys_exit_env>:


void sys_exit_env(void)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 1c                	push   $0x1c
  801db5:	e8 d1 fc ff ff       	call   801a8b <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	90                   	nop
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dc6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dc9:	8d 50 04             	lea    0x4(%eax),%edx
  801dcc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	52                   	push   %edx
  801dd6:	50                   	push   %eax
  801dd7:	6a 1d                	push   $0x1d
  801dd9:	e8 ad fc ff ff       	call   801a8b <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
	return result;
  801de1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801de7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dea:	89 01                	mov    %eax,(%ecx)
  801dec:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	c9                   	leave  
  801df3:	c2 04 00             	ret    $0x4

00801df6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	ff 75 10             	pushl  0x10(%ebp)
  801e00:	ff 75 0c             	pushl  0xc(%ebp)
  801e03:	ff 75 08             	pushl  0x8(%ebp)
  801e06:	6a 13                	push   $0x13
  801e08:	e8 7e fc ff ff       	call   801a8b <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e10:	90                   	nop
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 1e                	push   $0x1e
  801e22:	e8 64 fc ff ff       	call   801a8b <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 04             	sub    $0x4,%esp
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e38:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	50                   	push   %eax
  801e45:	6a 1f                	push   $0x1f
  801e47:	e8 3f fc ff ff       	call   801a8b <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4f:	90                   	nop
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <rsttst>:
void rsttst()
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 21                	push   $0x21
  801e61:	e8 25 fc ff ff       	call   801a8b <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
	return ;
  801e69:	90                   	nop
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 04             	sub    $0x4,%esp
  801e72:	8b 45 14             	mov    0x14(%ebp),%eax
  801e75:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e78:	8b 55 18             	mov    0x18(%ebp),%edx
  801e7b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e7f:	52                   	push   %edx
  801e80:	50                   	push   %eax
  801e81:	ff 75 10             	pushl  0x10(%ebp)
  801e84:	ff 75 0c             	pushl  0xc(%ebp)
  801e87:	ff 75 08             	pushl  0x8(%ebp)
  801e8a:	6a 20                	push   $0x20
  801e8c:	e8 fa fb ff ff       	call   801a8b <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
	return ;
  801e94:	90                   	nop
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <chktst>:
void chktst(uint32 n)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	ff 75 08             	pushl  0x8(%ebp)
  801ea5:	6a 22                	push   $0x22
  801ea7:	e8 df fb ff ff       	call   801a8b <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
	return ;
  801eaf:	90                   	nop
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <inctst>:

void inctst()
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 23                	push   $0x23
  801ec1:	e8 c5 fb ff ff       	call   801a8b <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec9:	90                   	nop
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <gettst>:
uint32 gettst()
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 24                	push   $0x24
  801edb:	e8 ab fb ff ff       	call   801a8b <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 25                	push   $0x25
  801ef7:	e8 8f fb ff ff       	call   801a8b <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
  801eff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f02:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f06:	75 07                	jne    801f0f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f08:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0d:	eb 05                	jmp    801f14 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 25                	push   $0x25
  801f28:	e8 5e fb ff ff       	call   801a8b <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
  801f30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f33:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f37:	75 07                	jne    801f40 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f39:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3e:	eb 05                	jmp    801f45 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 25                	push   $0x25
  801f59:	e8 2d fb ff ff       	call   801a8b <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
  801f61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f64:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f68:	75 07                	jne    801f71 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6f:	eb 05                	jmp    801f76 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 25                	push   $0x25
  801f8a:	e8 fc fa ff ff       	call   801a8b <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
  801f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f95:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f99:	75 07                	jne    801fa2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa0:	eb 05                	jmp    801fa7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	ff 75 08             	pushl  0x8(%ebp)
  801fb7:	6a 26                	push   $0x26
  801fb9:	e8 cd fa ff ff       	call   801a8b <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc1:	90                   	nop
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fc8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	6a 00                	push   $0x0
  801fd6:	53                   	push   %ebx
  801fd7:	51                   	push   %ecx
  801fd8:	52                   	push   %edx
  801fd9:	50                   	push   %eax
  801fda:	6a 27                	push   $0x27
  801fdc:	e8 aa fa ff ff       	call   801a8b <syscall>
  801fe1:	83 c4 18             	add    $0x18,%esp
}
  801fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	52                   	push   %edx
  801ff9:	50                   	push   %eax
  801ffa:	6a 28                	push   $0x28
  801ffc:	e8 8a fa ff ff       	call   801a8b <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802009:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80200c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	6a 00                	push   $0x0
  802014:	51                   	push   %ecx
  802015:	ff 75 10             	pushl  0x10(%ebp)
  802018:	52                   	push   %edx
  802019:	50                   	push   %eax
  80201a:	6a 29                	push   $0x29
  80201c:	e8 6a fa ff ff       	call   801a8b <syscall>
  802021:	83 c4 18             	add    $0x18,%esp
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	ff 75 10             	pushl  0x10(%ebp)
  802030:	ff 75 0c             	pushl  0xc(%ebp)
  802033:	ff 75 08             	pushl  0x8(%ebp)
  802036:	6a 12                	push   $0x12
  802038:	e8 4e fa ff ff       	call   801a8b <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
	return ;
  802040:	90                   	nop
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802046:	8b 55 0c             	mov    0xc(%ebp),%edx
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	52                   	push   %edx
  802053:	50                   	push   %eax
  802054:	6a 2a                	push   $0x2a
  802056:	e8 30 fa ff ff       	call   801a8b <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
	return;
  80205e:	90                   	nop
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	50                   	push   %eax
  802070:	6a 2b                	push   $0x2b
  802072:	e8 14 fa ff ff       	call   801a8b <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	ff 75 0c             	pushl  0xc(%ebp)
  802088:	ff 75 08             	pushl  0x8(%ebp)
  80208b:	6a 2c                	push   $0x2c
  80208d:	e8 f9 f9 ff ff       	call   801a8b <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
	return;
  802095:	90                   	nop
}
  802096:	c9                   	leave  
  802097:	c3                   	ret    

00802098 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	ff 75 0c             	pushl  0xc(%ebp)
  8020a4:	ff 75 08             	pushl  0x8(%ebp)
  8020a7:	6a 2d                	push   $0x2d
  8020a9:	e8 dd f9 ff ff       	call   801a8b <syscall>
  8020ae:	83 c4 18             	add    $0x18,%esp
	return;
  8020b1:	90                   	nop
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	83 e8 04             	sub    $0x4,%eax
  8020c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c6:	8b 00                	mov    (%eax),%eax
  8020c8:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	83 e8 04             	sub    $0x4,%eax
  8020d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8020dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020df:	8b 00                	mov    (%eax),%eax
  8020e1:	83 e0 01             	and    $0x1,%eax
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	0f 94 c0             	sete   %al
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8020f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8020f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fb:	83 f8 02             	cmp    $0x2,%eax
  8020fe:	74 2b                	je     80212b <alloc_block+0x40>
  802100:	83 f8 02             	cmp    $0x2,%eax
  802103:	7f 07                	jg     80210c <alloc_block+0x21>
  802105:	83 f8 01             	cmp    $0x1,%eax
  802108:	74 0e                	je     802118 <alloc_block+0x2d>
  80210a:	eb 58                	jmp    802164 <alloc_block+0x79>
  80210c:	83 f8 03             	cmp    $0x3,%eax
  80210f:	74 2d                	je     80213e <alloc_block+0x53>
  802111:	83 f8 04             	cmp    $0x4,%eax
  802114:	74 3b                	je     802151 <alloc_block+0x66>
  802116:	eb 4c                	jmp    802164 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802118:	83 ec 0c             	sub    $0xc,%esp
  80211b:	ff 75 08             	pushl  0x8(%ebp)
  80211e:	e8 11 03 00 00       	call   802434 <alloc_block_FF>
  802123:	83 c4 10             	add    $0x10,%esp
  802126:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802129:	eb 4a                	jmp    802175 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80212b:	83 ec 0c             	sub    $0xc,%esp
  80212e:	ff 75 08             	pushl  0x8(%ebp)
  802131:	e8 fa 19 00 00       	call   803b30 <alloc_block_NF>
  802136:	83 c4 10             	add    $0x10,%esp
  802139:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80213c:	eb 37                	jmp    802175 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80213e:	83 ec 0c             	sub    $0xc,%esp
  802141:	ff 75 08             	pushl  0x8(%ebp)
  802144:	e8 a7 07 00 00       	call   8028f0 <alloc_block_BF>
  802149:	83 c4 10             	add    $0x10,%esp
  80214c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80214f:	eb 24                	jmp    802175 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802151:	83 ec 0c             	sub    $0xc,%esp
  802154:	ff 75 08             	pushl  0x8(%ebp)
  802157:	e8 b7 19 00 00       	call   803b13 <alloc_block_WF>
  80215c:	83 c4 10             	add    $0x10,%esp
  80215f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802162:	eb 11                	jmp    802175 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802164:	83 ec 0c             	sub    $0xc,%esp
  802167:	68 b4 46 80 00       	push   $0x8046b4
  80216c:	e8 10 e7 ff ff       	call   800881 <cprintf>
  802171:	83 c4 10             	add    $0x10,%esp
		break;
  802174:	90                   	nop
	}
	return va;
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	53                   	push   %ebx
  80217e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802181:	83 ec 0c             	sub    $0xc,%esp
  802184:	68 d4 46 80 00       	push   $0x8046d4
  802189:	e8 f3 e6 ff ff       	call   800881 <cprintf>
  80218e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802191:	83 ec 0c             	sub    $0xc,%esp
  802194:	68 ff 46 80 00       	push   $0x8046ff
  802199:	e8 e3 e6 ff ff       	call   800881 <cprintf>
  80219e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a7:	eb 37                	jmp    8021e0 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021a9:	83 ec 0c             	sub    $0xc,%esp
  8021ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8021af:	e8 19 ff ff ff       	call   8020cd <is_free_block>
  8021b4:	83 c4 10             	add    $0x10,%esp
  8021b7:	0f be d8             	movsbl %al,%ebx
  8021ba:	83 ec 0c             	sub    $0xc,%esp
  8021bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8021c0:	e8 ef fe ff ff       	call   8020b4 <get_block_size>
  8021c5:	83 c4 10             	add    $0x10,%esp
  8021c8:	83 ec 04             	sub    $0x4,%esp
  8021cb:	53                   	push   %ebx
  8021cc:	50                   	push   %eax
  8021cd:	68 17 47 80 00       	push   $0x804717
  8021d2:	e8 aa e6 ff ff       	call   800881 <cprintf>
  8021d7:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021da:	8b 45 10             	mov    0x10(%ebp),%eax
  8021dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e4:	74 07                	je     8021ed <print_blocks_list+0x73>
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 00                	mov    (%eax),%eax
  8021eb:	eb 05                	jmp    8021f2 <print_blocks_list+0x78>
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f2:	89 45 10             	mov    %eax,0x10(%ebp)
  8021f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	75 ad                	jne    8021a9 <print_blocks_list+0x2f>
  8021fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802200:	75 a7                	jne    8021a9 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802202:	83 ec 0c             	sub    $0xc,%esp
  802205:	68 d4 46 80 00       	push   $0x8046d4
  80220a:	e8 72 e6 ff ff       	call   800881 <cprintf>
  80220f:	83 c4 10             	add    $0x10,%esp

}
  802212:	90                   	nop
  802213:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80221e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802221:	83 e0 01             	and    $0x1,%eax
  802224:	85 c0                	test   %eax,%eax
  802226:	74 03                	je     80222b <initialize_dynamic_allocator+0x13>
  802228:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80222b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80222f:	0f 84 c7 01 00 00    	je     8023fc <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802235:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80223c:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80223f:	8b 55 08             	mov    0x8(%ebp),%edx
  802242:	8b 45 0c             	mov    0xc(%ebp),%eax
  802245:	01 d0                	add    %edx,%eax
  802247:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80224c:	0f 87 ad 01 00 00    	ja     8023ff <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	85 c0                	test   %eax,%eax
  802257:	0f 89 a5 01 00 00    	jns    802402 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80225d:	8b 55 08             	mov    0x8(%ebp),%edx
  802260:	8b 45 0c             	mov    0xc(%ebp),%eax
  802263:	01 d0                	add    %edx,%eax
  802265:	83 e8 04             	sub    $0x4,%eax
  802268:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80226d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802274:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802279:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80227c:	e9 87 00 00 00       	jmp    802308 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802285:	75 14                	jne    80229b <initialize_dynamic_allocator+0x83>
  802287:	83 ec 04             	sub    $0x4,%esp
  80228a:	68 2f 47 80 00       	push   $0x80472f
  80228f:	6a 79                	push   $0x79
  802291:	68 4d 47 80 00       	push   $0x80474d
  802296:	e8 29 e3 ff ff       	call   8005c4 <_panic>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	74 10                	je     8022b4 <initialize_dynamic_allocator+0x9c>
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 00                	mov    (%eax),%eax
  8022a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ac:	8b 52 04             	mov    0x4(%edx),%edx
  8022af:	89 50 04             	mov    %edx,0x4(%eax)
  8022b2:	eb 0b                	jmp    8022bf <initialize_dynamic_allocator+0xa7>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	8b 40 04             	mov    0x4(%eax),%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 0f                	je     8022d8 <initialize_dynamic_allocator+0xc0>
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	8b 40 04             	mov    0x4(%eax),%eax
  8022cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d2:	8b 12                	mov    (%edx),%edx
  8022d4:	89 10                	mov    %edx,(%eax)
  8022d6:	eb 0a                	jmp    8022e2 <initialize_dynamic_allocator+0xca>
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 00                	mov    (%eax),%eax
  8022dd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8022fa:	48                   	dec    %eax
  8022fb:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802300:	a1 34 50 80 00       	mov    0x805034,%eax
  802305:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802308:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230c:	74 07                	je     802315 <initialize_dynamic_allocator+0xfd>
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 00                	mov    (%eax),%eax
  802313:	eb 05                	jmp    80231a <initialize_dynamic_allocator+0x102>
  802315:	b8 00 00 00 00       	mov    $0x0,%eax
  80231a:	a3 34 50 80 00       	mov    %eax,0x805034
  80231f:	a1 34 50 80 00       	mov    0x805034,%eax
  802324:	85 c0                	test   %eax,%eax
  802326:	0f 85 55 ff ff ff    	jne    802281 <initialize_dynamic_allocator+0x69>
  80232c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802330:	0f 85 4b ff ff ff    	jne    802281 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80233c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802345:	a1 44 50 80 00       	mov    0x805044,%eax
  80234a:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80234f:	a1 40 50 80 00       	mov    0x805040,%eax
  802354:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	83 c0 08             	add    $0x8,%eax
  802360:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	83 c0 04             	add    $0x4,%eax
  802369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236c:	83 ea 08             	sub    $0x8,%edx
  80236f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802371:	8b 55 0c             	mov    0xc(%ebp),%edx
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	01 d0                	add    %edx,%eax
  802379:	83 e8 08             	sub    $0x8,%eax
  80237c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237f:	83 ea 08             	sub    $0x8,%edx
  802382:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802387:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80238d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802390:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802397:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80239b:	75 17                	jne    8023b4 <initialize_dynamic_allocator+0x19c>
  80239d:	83 ec 04             	sub    $0x4,%esp
  8023a0:	68 68 47 80 00       	push   $0x804768
  8023a5:	68 90 00 00 00       	push   $0x90
  8023aa:	68 4d 47 80 00       	push   $0x80474d
  8023af:	e8 10 e2 ff ff       	call   8005c4 <_panic>
  8023b4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bd:	89 10                	mov    %edx,(%eax)
  8023bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c2:	8b 00                	mov    (%eax),%eax
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	74 0d                	je     8023d5 <initialize_dynamic_allocator+0x1bd>
  8023c8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023d0:	89 50 04             	mov    %edx,0x4(%eax)
  8023d3:	eb 08                	jmp    8023dd <initialize_dynamic_allocator+0x1c5>
  8023d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8023dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8023f4:	40                   	inc    %eax
  8023f5:	a3 38 50 80 00       	mov    %eax,0x805038
  8023fa:	eb 07                	jmp    802403 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8023fc:	90                   	nop
  8023fd:	eb 04                	jmp    802403 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8023ff:	90                   	nop
  802400:	eb 01                	jmp    802403 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802402:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802408:	8b 45 10             	mov    0x10(%ebp),%eax
  80240b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	8d 50 fc             	lea    -0x4(%eax),%edx
  802414:	8b 45 0c             	mov    0xc(%ebp),%eax
  802417:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	83 e8 04             	sub    $0x4,%eax
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	83 e0 fe             	and    $0xfffffffe,%eax
  802424:	8d 50 f8             	lea    -0x8(%eax),%edx
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	01 c2                	add    %eax,%edx
  80242c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242f:	89 02                	mov    %eax,(%edx)
}
  802431:	90                   	nop
  802432:	5d                   	pop    %ebp
  802433:	c3                   	ret    

00802434 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	83 e0 01             	and    $0x1,%eax
  802440:	85 c0                	test   %eax,%eax
  802442:	74 03                	je     802447 <alloc_block_FF+0x13>
  802444:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802447:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80244b:	77 07                	ja     802454 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80244d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802454:	a1 24 50 80 00       	mov    0x805024,%eax
  802459:	85 c0                	test   %eax,%eax
  80245b:	75 73                	jne    8024d0 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	83 c0 10             	add    $0x10,%eax
  802463:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802466:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80246d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802470:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802473:	01 d0                	add    %edx,%eax
  802475:	48                   	dec    %eax
  802476:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802479:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80247c:	ba 00 00 00 00       	mov    $0x0,%edx
  802481:	f7 75 ec             	divl   -0x14(%ebp)
  802484:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802487:	29 d0                	sub    %edx,%eax
  802489:	c1 e8 0c             	shr    $0xc,%eax
  80248c:	83 ec 0c             	sub    $0xc,%esp
  80248f:	50                   	push   %eax
  802490:	e8 86 f1 ff ff       	call   80161b <sbrk>
  802495:	83 c4 10             	add    $0x10,%esp
  802498:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80249b:	83 ec 0c             	sub    $0xc,%esp
  80249e:	6a 00                	push   $0x0
  8024a0:	e8 76 f1 ff ff       	call   80161b <sbrk>
  8024a5:	83 c4 10             	add    $0x10,%esp
  8024a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ae:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8024b1:	83 ec 08             	sub    $0x8,%esp
  8024b4:	50                   	push   %eax
  8024b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8024b8:	e8 5b fd ff ff       	call   802218 <initialize_dynamic_allocator>
  8024bd:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024c0:	83 ec 0c             	sub    $0xc,%esp
  8024c3:	68 8b 47 80 00       	push   $0x80478b
  8024c8:	e8 b4 e3 ff ff       	call   800881 <cprintf>
  8024cd:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8024d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024d4:	75 0a                	jne    8024e0 <alloc_block_FF+0xac>
	        return NULL;
  8024d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024db:	e9 0e 04 00 00       	jmp    8028ee <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8024e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024e7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ef:	e9 f3 02 00 00       	jmp    8027e7 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8024fa:	83 ec 0c             	sub    $0xc,%esp
  8024fd:	ff 75 bc             	pushl  -0x44(%ebp)
  802500:	e8 af fb ff ff       	call   8020b4 <get_block_size>
  802505:	83 c4 10             	add    $0x10,%esp
  802508:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	83 c0 08             	add    $0x8,%eax
  802511:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802514:	0f 87 c5 02 00 00    	ja     8027df <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	83 c0 18             	add    $0x18,%eax
  802520:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802523:	0f 87 19 02 00 00    	ja     802742 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802529:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80252c:	2b 45 08             	sub    0x8(%ebp),%eax
  80252f:	83 e8 08             	sub    $0x8,%eax
  802532:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802535:	8b 45 08             	mov    0x8(%ebp),%eax
  802538:	8d 50 08             	lea    0x8(%eax),%edx
  80253b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80253e:	01 d0                	add    %edx,%eax
  802540:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	83 c0 08             	add    $0x8,%eax
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	6a 01                	push   $0x1
  80254e:	50                   	push   %eax
  80254f:	ff 75 bc             	pushl  -0x44(%ebp)
  802552:	e8 ae fe ff ff       	call   802405 <set_block_data>
  802557:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 40 04             	mov    0x4(%eax),%eax
  802560:	85 c0                	test   %eax,%eax
  802562:	75 68                	jne    8025cc <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802564:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802568:	75 17                	jne    802581 <alloc_block_FF+0x14d>
  80256a:	83 ec 04             	sub    $0x4,%esp
  80256d:	68 68 47 80 00       	push   $0x804768
  802572:	68 d7 00 00 00       	push   $0xd7
  802577:	68 4d 47 80 00       	push   $0x80474d
  80257c:	e8 43 e0 ff ff       	call   8005c4 <_panic>
  802581:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802587:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80258a:	89 10                	mov    %edx,(%eax)
  80258c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80258f:	8b 00                	mov    (%eax),%eax
  802591:	85 c0                	test   %eax,%eax
  802593:	74 0d                	je     8025a2 <alloc_block_FF+0x16e>
  802595:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80259a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80259d:	89 50 04             	mov    %edx,0x4(%eax)
  8025a0:	eb 08                	jmp    8025aa <alloc_block_FF+0x176>
  8025a2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025a5:	a3 30 50 80 00       	mov    %eax,0x805030
  8025aa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025ad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8025c1:	40                   	inc    %eax
  8025c2:	a3 38 50 80 00       	mov    %eax,0x805038
  8025c7:	e9 dc 00 00 00       	jmp    8026a8 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 00                	mov    (%eax),%eax
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	75 65                	jne    80263a <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025d5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025d9:	75 17                	jne    8025f2 <alloc_block_FF+0x1be>
  8025db:	83 ec 04             	sub    $0x4,%esp
  8025de:	68 9c 47 80 00       	push   $0x80479c
  8025e3:	68 db 00 00 00       	push   $0xdb
  8025e8:	68 4d 47 80 00       	push   $0x80474d
  8025ed:	e8 d2 df ff ff       	call   8005c4 <_panic>
  8025f2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8025f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025fb:	89 50 04             	mov    %edx,0x4(%eax)
  8025fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802601:	8b 40 04             	mov    0x4(%eax),%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	74 0c                	je     802614 <alloc_block_FF+0x1e0>
  802608:	a1 30 50 80 00       	mov    0x805030,%eax
  80260d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802610:	89 10                	mov    %edx,(%eax)
  802612:	eb 08                	jmp    80261c <alloc_block_FF+0x1e8>
  802614:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802617:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80261c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80261f:	a3 30 50 80 00       	mov    %eax,0x805030
  802624:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802627:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262d:	a1 38 50 80 00       	mov    0x805038,%eax
  802632:	40                   	inc    %eax
  802633:	a3 38 50 80 00       	mov    %eax,0x805038
  802638:	eb 6e                	jmp    8026a8 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80263a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263e:	74 06                	je     802646 <alloc_block_FF+0x212>
  802640:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802644:	75 17                	jne    80265d <alloc_block_FF+0x229>
  802646:	83 ec 04             	sub    $0x4,%esp
  802649:	68 c0 47 80 00       	push   $0x8047c0
  80264e:	68 df 00 00 00       	push   $0xdf
  802653:	68 4d 47 80 00       	push   $0x80474d
  802658:	e8 67 df ff ff       	call   8005c4 <_panic>
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 10                	mov    (%eax),%edx
  802662:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802665:	89 10                	mov    %edx,(%eax)
  802667:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	74 0b                	je     80267b <alloc_block_FF+0x247>
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802678:	89 50 04             	mov    %edx,0x4(%eax)
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802681:	89 10                	mov    %edx,(%eax)
  802683:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802686:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802689:	89 50 04             	mov    %edx,0x4(%eax)
  80268c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	75 08                	jne    80269d <alloc_block_FF+0x269>
  802695:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802698:	a3 30 50 80 00       	mov    %eax,0x805030
  80269d:	a1 38 50 80 00       	mov    0x805038,%eax
  8026a2:	40                   	inc    %eax
  8026a3:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8026a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ac:	75 17                	jne    8026c5 <alloc_block_FF+0x291>
  8026ae:	83 ec 04             	sub    $0x4,%esp
  8026b1:	68 2f 47 80 00       	push   $0x80472f
  8026b6:	68 e1 00 00 00       	push   $0xe1
  8026bb:	68 4d 47 80 00       	push   $0x80474d
  8026c0:	e8 ff de ff ff       	call   8005c4 <_panic>
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 00                	mov    (%eax),%eax
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	74 10                	je     8026de <alloc_block_FF+0x2aa>
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 00                	mov    (%eax),%eax
  8026d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d6:	8b 52 04             	mov    0x4(%edx),%edx
  8026d9:	89 50 04             	mov    %edx,0x4(%eax)
  8026dc:	eb 0b                	jmp    8026e9 <alloc_block_FF+0x2b5>
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 40 04             	mov    0x4(%eax),%eax
  8026e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 40 04             	mov    0x4(%eax),%eax
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	74 0f                	je     802702 <alloc_block_FF+0x2ce>
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	8b 40 04             	mov    0x4(%eax),%eax
  8026f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fc:	8b 12                	mov    (%edx),%edx
  8026fe:	89 10                	mov    %edx,(%eax)
  802700:	eb 0a                	jmp    80270c <alloc_block_FF+0x2d8>
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 00                	mov    (%eax),%eax
  802707:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271f:	a1 38 50 80 00       	mov    0x805038,%eax
  802724:	48                   	dec    %eax
  802725:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80272a:	83 ec 04             	sub    $0x4,%esp
  80272d:	6a 00                	push   $0x0
  80272f:	ff 75 b4             	pushl  -0x4c(%ebp)
  802732:	ff 75 b0             	pushl  -0x50(%ebp)
  802735:	e8 cb fc ff ff       	call   802405 <set_block_data>
  80273a:	83 c4 10             	add    $0x10,%esp
  80273d:	e9 95 00 00 00       	jmp    8027d7 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802742:	83 ec 04             	sub    $0x4,%esp
  802745:	6a 01                	push   $0x1
  802747:	ff 75 b8             	pushl  -0x48(%ebp)
  80274a:	ff 75 bc             	pushl  -0x44(%ebp)
  80274d:	e8 b3 fc ff ff       	call   802405 <set_block_data>
  802752:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802755:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802759:	75 17                	jne    802772 <alloc_block_FF+0x33e>
  80275b:	83 ec 04             	sub    $0x4,%esp
  80275e:	68 2f 47 80 00       	push   $0x80472f
  802763:	68 e8 00 00 00       	push   $0xe8
  802768:	68 4d 47 80 00       	push   $0x80474d
  80276d:	e8 52 de ff ff       	call   8005c4 <_panic>
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	74 10                	je     80278b <alloc_block_FF+0x357>
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802783:	8b 52 04             	mov    0x4(%edx),%edx
  802786:	89 50 04             	mov    %edx,0x4(%eax)
  802789:	eb 0b                	jmp    802796 <alloc_block_FF+0x362>
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 40 04             	mov    0x4(%eax),%eax
  802791:	a3 30 50 80 00       	mov    %eax,0x805030
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 40 04             	mov    0x4(%eax),%eax
  80279c:	85 c0                	test   %eax,%eax
  80279e:	74 0f                	je     8027af <alloc_block_FF+0x37b>
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	8b 40 04             	mov    0x4(%eax),%eax
  8027a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a9:	8b 12                	mov    (%edx),%edx
  8027ab:	89 10                	mov    %edx,(%eax)
  8027ad:	eb 0a                	jmp    8027b9 <alloc_block_FF+0x385>
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8027d1:	48                   	dec    %eax
  8027d2:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8027d7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027da:	e9 0f 01 00 00       	jmp    8028ee <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027df:	a1 34 50 80 00       	mov    0x805034,%eax
  8027e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027eb:	74 07                	je     8027f4 <alloc_block_FF+0x3c0>
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 00                	mov    (%eax),%eax
  8027f2:	eb 05                	jmp    8027f9 <alloc_block_FF+0x3c5>
  8027f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f9:	a3 34 50 80 00       	mov    %eax,0x805034
  8027fe:	a1 34 50 80 00       	mov    0x805034,%eax
  802803:	85 c0                	test   %eax,%eax
  802805:	0f 85 e9 fc ff ff    	jne    8024f4 <alloc_block_FF+0xc0>
  80280b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280f:	0f 85 df fc ff ff    	jne    8024f4 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802815:	8b 45 08             	mov    0x8(%ebp),%eax
  802818:	83 c0 08             	add    $0x8,%eax
  80281b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80281e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802825:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802828:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80282b:	01 d0                	add    %edx,%eax
  80282d:	48                   	dec    %eax
  80282e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802831:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802834:	ba 00 00 00 00       	mov    $0x0,%edx
  802839:	f7 75 d8             	divl   -0x28(%ebp)
  80283c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80283f:	29 d0                	sub    %edx,%eax
  802841:	c1 e8 0c             	shr    $0xc,%eax
  802844:	83 ec 0c             	sub    $0xc,%esp
  802847:	50                   	push   %eax
  802848:	e8 ce ed ff ff       	call   80161b <sbrk>
  80284d:	83 c4 10             	add    $0x10,%esp
  802850:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802853:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802857:	75 0a                	jne    802863 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802859:	b8 00 00 00 00       	mov    $0x0,%eax
  80285e:	e9 8b 00 00 00       	jmp    8028ee <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802863:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80286a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80286d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802870:	01 d0                	add    %edx,%eax
  802872:	48                   	dec    %eax
  802873:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802876:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802879:	ba 00 00 00 00       	mov    $0x0,%edx
  80287e:	f7 75 cc             	divl   -0x34(%ebp)
  802881:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802884:	29 d0                	sub    %edx,%eax
  802886:	8d 50 fc             	lea    -0x4(%eax),%edx
  802889:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80288c:	01 d0                	add    %edx,%eax
  80288e:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802893:	a1 40 50 80 00       	mov    0x805040,%eax
  802898:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80289e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028a8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028ab:	01 d0                	add    %edx,%eax
  8028ad:	48                   	dec    %eax
  8028ae:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8028b1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b9:	f7 75 c4             	divl   -0x3c(%ebp)
  8028bc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028bf:	29 d0                	sub    %edx,%eax
  8028c1:	83 ec 04             	sub    $0x4,%esp
  8028c4:	6a 01                	push   $0x1
  8028c6:	50                   	push   %eax
  8028c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8028ca:	e8 36 fb ff ff       	call   802405 <set_block_data>
  8028cf:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8028d2:	83 ec 0c             	sub    $0xc,%esp
  8028d5:	ff 75 d0             	pushl  -0x30(%ebp)
  8028d8:	e8 1b 0a 00 00       	call   8032f8 <free_block>
  8028dd:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8028e0:	83 ec 0c             	sub    $0xc,%esp
  8028e3:	ff 75 08             	pushl  0x8(%ebp)
  8028e6:	e8 49 fb ff ff       	call   802434 <alloc_block_FF>
  8028eb:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8028ee:	c9                   	leave  
  8028ef:	c3                   	ret    

008028f0 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028f0:	55                   	push   %ebp
  8028f1:	89 e5                	mov    %esp,%ebp
  8028f3:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f9:	83 e0 01             	and    $0x1,%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	74 03                	je     802903 <alloc_block_BF+0x13>
  802900:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802903:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802907:	77 07                	ja     802910 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802909:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802910:	a1 24 50 80 00       	mov    0x805024,%eax
  802915:	85 c0                	test   %eax,%eax
  802917:	75 73                	jne    80298c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	83 c0 10             	add    $0x10,%eax
  80291f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802922:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802929:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80292c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80292f:	01 d0                	add    %edx,%eax
  802931:	48                   	dec    %eax
  802932:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802935:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802938:	ba 00 00 00 00       	mov    $0x0,%edx
  80293d:	f7 75 e0             	divl   -0x20(%ebp)
  802940:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802943:	29 d0                	sub    %edx,%eax
  802945:	c1 e8 0c             	shr    $0xc,%eax
  802948:	83 ec 0c             	sub    $0xc,%esp
  80294b:	50                   	push   %eax
  80294c:	e8 ca ec ff ff       	call   80161b <sbrk>
  802951:	83 c4 10             	add    $0x10,%esp
  802954:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802957:	83 ec 0c             	sub    $0xc,%esp
  80295a:	6a 00                	push   $0x0
  80295c:	e8 ba ec ff ff       	call   80161b <sbrk>
  802961:	83 c4 10             	add    $0x10,%esp
  802964:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802967:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80296a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80296d:	83 ec 08             	sub    $0x8,%esp
  802970:	50                   	push   %eax
  802971:	ff 75 d8             	pushl  -0x28(%ebp)
  802974:	e8 9f f8 ff ff       	call   802218 <initialize_dynamic_allocator>
  802979:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80297c:	83 ec 0c             	sub    $0xc,%esp
  80297f:	68 8b 47 80 00       	push   $0x80478b
  802984:	e8 f8 de ff ff       	call   800881 <cprintf>
  802989:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80298c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802993:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80299a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8029a8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b0:	e9 1d 01 00 00       	jmp    802ad2 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8029bb:	83 ec 0c             	sub    $0xc,%esp
  8029be:	ff 75 a8             	pushl  -0x58(%ebp)
  8029c1:	e8 ee f6 ff ff       	call   8020b4 <get_block_size>
  8029c6:	83 c4 10             	add    $0x10,%esp
  8029c9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	83 c0 08             	add    $0x8,%eax
  8029d2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029d5:	0f 87 ef 00 00 00    	ja     802aca <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029db:	8b 45 08             	mov    0x8(%ebp),%eax
  8029de:	83 c0 18             	add    $0x18,%eax
  8029e1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029e4:	77 1d                	ja     802a03 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8029e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029ec:	0f 86 d8 00 00 00    	jbe    802aca <alloc_block_BF+0x1da>
				{
					best_va = va;
  8029f2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8029f8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029fe:	e9 c7 00 00 00       	jmp    802aca <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a03:	8b 45 08             	mov    0x8(%ebp),%eax
  802a06:	83 c0 08             	add    $0x8,%eax
  802a09:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a0c:	0f 85 9d 00 00 00    	jne    802aaf <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a12:	83 ec 04             	sub    $0x4,%esp
  802a15:	6a 01                	push   $0x1
  802a17:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a1a:	ff 75 a8             	pushl  -0x58(%ebp)
  802a1d:	e8 e3 f9 ff ff       	call   802405 <set_block_data>
  802a22:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a29:	75 17                	jne    802a42 <alloc_block_BF+0x152>
  802a2b:	83 ec 04             	sub    $0x4,%esp
  802a2e:	68 2f 47 80 00       	push   $0x80472f
  802a33:	68 2c 01 00 00       	push   $0x12c
  802a38:	68 4d 47 80 00       	push   $0x80474d
  802a3d:	e8 82 db ff ff       	call   8005c4 <_panic>
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 10                	je     802a5b <alloc_block_BF+0x16b>
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a53:	8b 52 04             	mov    0x4(%edx),%edx
  802a56:	89 50 04             	mov    %edx,0x4(%eax)
  802a59:	eb 0b                	jmp    802a66 <alloc_block_BF+0x176>
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 40 04             	mov    0x4(%eax),%eax
  802a61:	a3 30 50 80 00       	mov    %eax,0x805030
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 40 04             	mov    0x4(%eax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	74 0f                	je     802a7f <alloc_block_BF+0x18f>
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 40 04             	mov    0x4(%eax),%eax
  802a76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a79:	8b 12                	mov    (%edx),%edx
  802a7b:	89 10                	mov    %edx,(%eax)
  802a7d:	eb 0a                	jmp    802a89 <alloc_block_BF+0x199>
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9c:	a1 38 50 80 00       	mov    0x805038,%eax
  802aa1:	48                   	dec    %eax
  802aa2:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802aa7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802aaa:	e9 24 04 00 00       	jmp    802ed3 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ab5:	76 13                	jbe    802aca <alloc_block_BF+0x1da>
					{
						internal = 1;
  802ab7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802abe:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ac1:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802ac4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ac7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802aca:	a1 34 50 80 00       	mov    0x805034,%eax
  802acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad6:	74 07                	je     802adf <alloc_block_BF+0x1ef>
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	eb 05                	jmp    802ae4 <alloc_block_BF+0x1f4>
  802adf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae4:	a3 34 50 80 00       	mov    %eax,0x805034
  802ae9:	a1 34 50 80 00       	mov    0x805034,%eax
  802aee:	85 c0                	test   %eax,%eax
  802af0:	0f 85 bf fe ff ff    	jne    8029b5 <alloc_block_BF+0xc5>
  802af6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afa:	0f 85 b5 fe ff ff    	jne    8029b5 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b04:	0f 84 26 02 00 00    	je     802d30 <alloc_block_BF+0x440>
  802b0a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b0e:	0f 85 1c 02 00 00    	jne    802d30 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b17:	2b 45 08             	sub    0x8(%ebp),%eax
  802b1a:	83 e8 08             	sub    $0x8,%eax
  802b1d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	8d 50 08             	lea    0x8(%eax),%edx
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	01 d0                	add    %edx,%eax
  802b2b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b31:	83 c0 08             	add    $0x8,%eax
  802b34:	83 ec 04             	sub    $0x4,%esp
  802b37:	6a 01                	push   $0x1
  802b39:	50                   	push   %eax
  802b3a:	ff 75 f0             	pushl  -0x10(%ebp)
  802b3d:	e8 c3 f8 ff ff       	call   802405 <set_block_data>
  802b42:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 40 04             	mov    0x4(%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	75 68                	jne    802bb7 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b4f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b53:	75 17                	jne    802b6c <alloc_block_BF+0x27c>
  802b55:	83 ec 04             	sub    $0x4,%esp
  802b58:	68 68 47 80 00       	push   $0x804768
  802b5d:	68 45 01 00 00       	push   $0x145
  802b62:	68 4d 47 80 00       	push   $0x80474d
  802b67:	e8 58 da ff ff       	call   8005c4 <_panic>
  802b6c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b72:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b75:	89 10                	mov    %edx,(%eax)
  802b77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	74 0d                	je     802b8d <alloc_block_BF+0x29d>
  802b80:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b85:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b88:	89 50 04             	mov    %edx,0x4(%eax)
  802b8b:	eb 08                	jmp    802b95 <alloc_block_BF+0x2a5>
  802b8d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b90:	a3 30 50 80 00       	mov    %eax,0x805030
  802b95:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b98:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba7:	a1 38 50 80 00       	mov    0x805038,%eax
  802bac:	40                   	inc    %eax
  802bad:	a3 38 50 80 00       	mov    %eax,0x805038
  802bb2:	e9 dc 00 00 00       	jmp    802c93 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bba:	8b 00                	mov    (%eax),%eax
  802bbc:	85 c0                	test   %eax,%eax
  802bbe:	75 65                	jne    802c25 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bc0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bc4:	75 17                	jne    802bdd <alloc_block_BF+0x2ed>
  802bc6:	83 ec 04             	sub    $0x4,%esp
  802bc9:	68 9c 47 80 00       	push   $0x80479c
  802bce:	68 4a 01 00 00       	push   $0x14a
  802bd3:	68 4d 47 80 00       	push   $0x80474d
  802bd8:	e8 e7 d9 ff ff       	call   8005c4 <_panic>
  802bdd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802be3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802be6:	89 50 04             	mov    %edx,0x4(%eax)
  802be9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bec:	8b 40 04             	mov    0x4(%eax),%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	74 0c                	je     802bff <alloc_block_BF+0x30f>
  802bf3:	a1 30 50 80 00       	mov    0x805030,%eax
  802bf8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802bfb:	89 10                	mov    %edx,(%eax)
  802bfd:	eb 08                	jmp    802c07 <alloc_block_BF+0x317>
  802bff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c02:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c07:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c0a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c18:	a1 38 50 80 00       	mov    0x805038,%eax
  802c1d:	40                   	inc    %eax
  802c1e:	a3 38 50 80 00       	mov    %eax,0x805038
  802c23:	eb 6e                	jmp    802c93 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c29:	74 06                	je     802c31 <alloc_block_BF+0x341>
  802c2b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c2f:	75 17                	jne    802c48 <alloc_block_BF+0x358>
  802c31:	83 ec 04             	sub    $0x4,%esp
  802c34:	68 c0 47 80 00       	push   $0x8047c0
  802c39:	68 4f 01 00 00       	push   $0x14f
  802c3e:	68 4d 47 80 00       	push   $0x80474d
  802c43:	e8 7c d9 ff ff       	call   8005c4 <_panic>
  802c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4b:	8b 10                	mov    (%eax),%edx
  802c4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c50:	89 10                	mov    %edx,(%eax)
  802c52:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	74 0b                	je     802c66 <alloc_block_BF+0x376>
  802c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c63:	89 50 04             	mov    %edx,0x4(%eax)
  802c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c69:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c6c:	89 10                	mov    %edx,(%eax)
  802c6e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c74:	89 50 04             	mov    %edx,0x4(%eax)
  802c77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	75 08                	jne    802c88 <alloc_block_BF+0x398>
  802c80:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c83:	a3 30 50 80 00       	mov    %eax,0x805030
  802c88:	a1 38 50 80 00       	mov    0x805038,%eax
  802c8d:	40                   	inc    %eax
  802c8e:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802c93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c97:	75 17                	jne    802cb0 <alloc_block_BF+0x3c0>
  802c99:	83 ec 04             	sub    $0x4,%esp
  802c9c:	68 2f 47 80 00       	push   $0x80472f
  802ca1:	68 51 01 00 00       	push   $0x151
  802ca6:	68 4d 47 80 00       	push   $0x80474d
  802cab:	e8 14 d9 ff ff       	call   8005c4 <_panic>
  802cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb3:	8b 00                	mov    (%eax),%eax
  802cb5:	85 c0                	test   %eax,%eax
  802cb7:	74 10                	je     802cc9 <alloc_block_BF+0x3d9>
  802cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbc:	8b 00                	mov    (%eax),%eax
  802cbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc1:	8b 52 04             	mov    0x4(%edx),%edx
  802cc4:	89 50 04             	mov    %edx,0x4(%eax)
  802cc7:	eb 0b                	jmp    802cd4 <alloc_block_BF+0x3e4>
  802cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccc:	8b 40 04             	mov    0x4(%eax),%eax
  802ccf:	a3 30 50 80 00       	mov    %eax,0x805030
  802cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd7:	8b 40 04             	mov    0x4(%eax),%eax
  802cda:	85 c0                	test   %eax,%eax
  802cdc:	74 0f                	je     802ced <alloc_block_BF+0x3fd>
  802cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce1:	8b 40 04             	mov    0x4(%eax),%eax
  802ce4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce7:	8b 12                	mov    (%edx),%edx
  802ce9:	89 10                	mov    %edx,(%eax)
  802ceb:	eb 0a                	jmp    802cf7 <alloc_block_BF+0x407>
  802ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf0:	8b 00                	mov    (%eax),%eax
  802cf2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0a:	a1 38 50 80 00       	mov    0x805038,%eax
  802d0f:	48                   	dec    %eax
  802d10:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d15:	83 ec 04             	sub    $0x4,%esp
  802d18:	6a 00                	push   $0x0
  802d1a:	ff 75 d0             	pushl  -0x30(%ebp)
  802d1d:	ff 75 cc             	pushl  -0x34(%ebp)
  802d20:	e8 e0 f6 ff ff       	call   802405 <set_block_data>
  802d25:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2b:	e9 a3 01 00 00       	jmp    802ed3 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d30:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d34:	0f 85 9d 00 00 00    	jne    802dd7 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d3a:	83 ec 04             	sub    $0x4,%esp
  802d3d:	6a 01                	push   $0x1
  802d3f:	ff 75 ec             	pushl  -0x14(%ebp)
  802d42:	ff 75 f0             	pushl  -0x10(%ebp)
  802d45:	e8 bb f6 ff ff       	call   802405 <set_block_data>
  802d4a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d51:	75 17                	jne    802d6a <alloc_block_BF+0x47a>
  802d53:	83 ec 04             	sub    $0x4,%esp
  802d56:	68 2f 47 80 00       	push   $0x80472f
  802d5b:	68 58 01 00 00       	push   $0x158
  802d60:	68 4d 47 80 00       	push   $0x80474d
  802d65:	e8 5a d8 ff ff       	call   8005c4 <_panic>
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	74 10                	je     802d83 <alloc_block_BF+0x493>
  802d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d76:	8b 00                	mov    (%eax),%eax
  802d78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d7b:	8b 52 04             	mov    0x4(%edx),%edx
  802d7e:	89 50 04             	mov    %edx,0x4(%eax)
  802d81:	eb 0b                	jmp    802d8e <alloc_block_BF+0x49e>
  802d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d86:	8b 40 04             	mov    0x4(%eax),%eax
  802d89:	a3 30 50 80 00       	mov    %eax,0x805030
  802d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d91:	8b 40 04             	mov    0x4(%eax),%eax
  802d94:	85 c0                	test   %eax,%eax
  802d96:	74 0f                	je     802da7 <alloc_block_BF+0x4b7>
  802d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9b:	8b 40 04             	mov    0x4(%eax),%eax
  802d9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da1:	8b 12                	mov    (%edx),%edx
  802da3:	89 10                	mov    %edx,(%eax)
  802da5:	eb 0a                	jmp    802db1 <alloc_block_BF+0x4c1>
  802da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc4:	a1 38 50 80 00       	mov    0x805038,%eax
  802dc9:	48                   	dec    %eax
  802dca:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd2:	e9 fc 00 00 00       	jmp    802ed3 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	83 c0 08             	add    $0x8,%eax
  802ddd:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802de0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802de7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ded:	01 d0                	add    %edx,%eax
  802def:	48                   	dec    %eax
  802df0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802df3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802df6:	ba 00 00 00 00       	mov    $0x0,%edx
  802dfb:	f7 75 c4             	divl   -0x3c(%ebp)
  802dfe:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e01:	29 d0                	sub    %edx,%eax
  802e03:	c1 e8 0c             	shr    $0xc,%eax
  802e06:	83 ec 0c             	sub    $0xc,%esp
  802e09:	50                   	push   %eax
  802e0a:	e8 0c e8 ff ff       	call   80161b <sbrk>
  802e0f:	83 c4 10             	add    $0x10,%esp
  802e12:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e15:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e19:	75 0a                	jne    802e25 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e20:	e9 ae 00 00 00       	jmp    802ed3 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e25:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e2c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e2f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e32:	01 d0                	add    %edx,%eax
  802e34:	48                   	dec    %eax
  802e35:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e38:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e3b:	ba 00 00 00 00       	mov    $0x0,%edx
  802e40:	f7 75 b8             	divl   -0x48(%ebp)
  802e43:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e46:	29 d0                	sub    %edx,%eax
  802e48:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e4b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e4e:	01 d0                	add    %edx,%eax
  802e50:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e55:	a1 40 50 80 00       	mov    0x805040,%eax
  802e5a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e60:	83 ec 0c             	sub    $0xc,%esp
  802e63:	68 f4 47 80 00       	push   $0x8047f4
  802e68:	e8 14 da ff ff       	call   800881 <cprintf>
  802e6d:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e70:	83 ec 08             	sub    $0x8,%esp
  802e73:	ff 75 bc             	pushl  -0x44(%ebp)
  802e76:	68 f9 47 80 00       	push   $0x8047f9
  802e7b:	e8 01 da ff ff       	call   800881 <cprintf>
  802e80:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e83:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e8a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e8d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802e90:	01 d0                	add    %edx,%eax
  802e92:	48                   	dec    %eax
  802e93:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802e96:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802e99:	ba 00 00 00 00       	mov    $0x0,%edx
  802e9e:	f7 75 b0             	divl   -0x50(%ebp)
  802ea1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ea4:	29 d0                	sub    %edx,%eax
  802ea6:	83 ec 04             	sub    $0x4,%esp
  802ea9:	6a 01                	push   $0x1
  802eab:	50                   	push   %eax
  802eac:	ff 75 bc             	pushl  -0x44(%ebp)
  802eaf:	e8 51 f5 ff ff       	call   802405 <set_block_data>
  802eb4:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802eb7:	83 ec 0c             	sub    $0xc,%esp
  802eba:	ff 75 bc             	pushl  -0x44(%ebp)
  802ebd:	e8 36 04 00 00       	call   8032f8 <free_block>
  802ec2:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ec5:	83 ec 0c             	sub    $0xc,%esp
  802ec8:	ff 75 08             	pushl  0x8(%ebp)
  802ecb:	e8 20 fa ff ff       	call   8028f0 <alloc_block_BF>
  802ed0:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802ed3:	c9                   	leave  
  802ed4:	c3                   	ret    

00802ed5 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802ed5:	55                   	push   %ebp
  802ed6:	89 e5                	mov    %esp,%ebp
  802ed8:	53                   	push   %ebx
  802ed9:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802edc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ee3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802eea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eee:	74 1e                	je     802f0e <merging+0x39>
  802ef0:	ff 75 08             	pushl  0x8(%ebp)
  802ef3:	e8 bc f1 ff ff       	call   8020b4 <get_block_size>
  802ef8:	83 c4 04             	add    $0x4,%esp
  802efb:	89 c2                	mov    %eax,%edx
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	01 d0                	add    %edx,%eax
  802f02:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f05:	75 07                	jne    802f0e <merging+0x39>
		prev_is_free = 1;
  802f07:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f12:	74 1e                	je     802f32 <merging+0x5d>
  802f14:	ff 75 10             	pushl  0x10(%ebp)
  802f17:	e8 98 f1 ff ff       	call   8020b4 <get_block_size>
  802f1c:	83 c4 04             	add    $0x4,%esp
  802f1f:	89 c2                	mov    %eax,%edx
  802f21:	8b 45 10             	mov    0x10(%ebp),%eax
  802f24:	01 d0                	add    %edx,%eax
  802f26:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f29:	75 07                	jne    802f32 <merging+0x5d>
		next_is_free = 1;
  802f2b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f36:	0f 84 cc 00 00 00    	je     803008 <merging+0x133>
  802f3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f40:	0f 84 c2 00 00 00    	je     803008 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f46:	ff 75 08             	pushl  0x8(%ebp)
  802f49:	e8 66 f1 ff ff       	call   8020b4 <get_block_size>
  802f4e:	83 c4 04             	add    $0x4,%esp
  802f51:	89 c3                	mov    %eax,%ebx
  802f53:	ff 75 10             	pushl  0x10(%ebp)
  802f56:	e8 59 f1 ff ff       	call   8020b4 <get_block_size>
  802f5b:	83 c4 04             	add    $0x4,%esp
  802f5e:	01 c3                	add    %eax,%ebx
  802f60:	ff 75 0c             	pushl  0xc(%ebp)
  802f63:	e8 4c f1 ff ff       	call   8020b4 <get_block_size>
  802f68:	83 c4 04             	add    $0x4,%esp
  802f6b:	01 d8                	add    %ebx,%eax
  802f6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f70:	6a 00                	push   $0x0
  802f72:	ff 75 ec             	pushl  -0x14(%ebp)
  802f75:	ff 75 08             	pushl  0x8(%ebp)
  802f78:	e8 88 f4 ff ff       	call   802405 <set_block_data>
  802f7d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f84:	75 17                	jne    802f9d <merging+0xc8>
  802f86:	83 ec 04             	sub    $0x4,%esp
  802f89:	68 2f 47 80 00       	push   $0x80472f
  802f8e:	68 7d 01 00 00       	push   $0x17d
  802f93:	68 4d 47 80 00       	push   $0x80474d
  802f98:	e8 27 d6 ff ff       	call   8005c4 <_panic>
  802f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa0:	8b 00                	mov    (%eax),%eax
  802fa2:	85 c0                	test   %eax,%eax
  802fa4:	74 10                	je     802fb6 <merging+0xe1>
  802fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa9:	8b 00                	mov    (%eax),%eax
  802fab:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fae:	8b 52 04             	mov    0x4(%edx),%edx
  802fb1:	89 50 04             	mov    %edx,0x4(%eax)
  802fb4:	eb 0b                	jmp    802fc1 <merging+0xec>
  802fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb9:	8b 40 04             	mov    0x4(%eax),%eax
  802fbc:	a3 30 50 80 00       	mov    %eax,0x805030
  802fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc4:	8b 40 04             	mov    0x4(%eax),%eax
  802fc7:	85 c0                	test   %eax,%eax
  802fc9:	74 0f                	je     802fda <merging+0x105>
  802fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fce:	8b 40 04             	mov    0x4(%eax),%eax
  802fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd4:	8b 12                	mov    (%edx),%edx
  802fd6:	89 10                	mov    %edx,(%eax)
  802fd8:	eb 0a                	jmp    802fe4 <merging+0x10f>
  802fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff7:	a1 38 50 80 00       	mov    0x805038,%eax
  802ffc:	48                   	dec    %eax
  802ffd:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803002:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803003:	e9 ea 02 00 00       	jmp    8032f2 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803008:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300c:	74 3b                	je     803049 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80300e:	83 ec 0c             	sub    $0xc,%esp
  803011:	ff 75 08             	pushl  0x8(%ebp)
  803014:	e8 9b f0 ff ff       	call   8020b4 <get_block_size>
  803019:	83 c4 10             	add    $0x10,%esp
  80301c:	89 c3                	mov    %eax,%ebx
  80301e:	83 ec 0c             	sub    $0xc,%esp
  803021:	ff 75 10             	pushl  0x10(%ebp)
  803024:	e8 8b f0 ff ff       	call   8020b4 <get_block_size>
  803029:	83 c4 10             	add    $0x10,%esp
  80302c:	01 d8                	add    %ebx,%eax
  80302e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803031:	83 ec 04             	sub    $0x4,%esp
  803034:	6a 00                	push   $0x0
  803036:	ff 75 e8             	pushl  -0x18(%ebp)
  803039:	ff 75 08             	pushl  0x8(%ebp)
  80303c:	e8 c4 f3 ff ff       	call   802405 <set_block_data>
  803041:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803044:	e9 a9 02 00 00       	jmp    8032f2 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803049:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80304d:	0f 84 2d 01 00 00    	je     803180 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803053:	83 ec 0c             	sub    $0xc,%esp
  803056:	ff 75 10             	pushl  0x10(%ebp)
  803059:	e8 56 f0 ff ff       	call   8020b4 <get_block_size>
  80305e:	83 c4 10             	add    $0x10,%esp
  803061:	89 c3                	mov    %eax,%ebx
  803063:	83 ec 0c             	sub    $0xc,%esp
  803066:	ff 75 0c             	pushl  0xc(%ebp)
  803069:	e8 46 f0 ff ff       	call   8020b4 <get_block_size>
  80306e:	83 c4 10             	add    $0x10,%esp
  803071:	01 d8                	add    %ebx,%eax
  803073:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803076:	83 ec 04             	sub    $0x4,%esp
  803079:	6a 00                	push   $0x0
  80307b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80307e:	ff 75 10             	pushl  0x10(%ebp)
  803081:	e8 7f f3 ff ff       	call   802405 <set_block_data>
  803086:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803089:	8b 45 10             	mov    0x10(%ebp),%eax
  80308c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80308f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803093:	74 06                	je     80309b <merging+0x1c6>
  803095:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803099:	75 17                	jne    8030b2 <merging+0x1dd>
  80309b:	83 ec 04             	sub    $0x4,%esp
  80309e:	68 08 48 80 00       	push   $0x804808
  8030a3:	68 8d 01 00 00       	push   $0x18d
  8030a8:	68 4d 47 80 00       	push   $0x80474d
  8030ad:	e8 12 d5 ff ff       	call   8005c4 <_panic>
  8030b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b5:	8b 50 04             	mov    0x4(%eax),%edx
  8030b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030bb:	89 50 04             	mov    %edx,0x4(%eax)
  8030be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c4:	89 10                	mov    %edx,(%eax)
  8030c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c9:	8b 40 04             	mov    0x4(%eax),%eax
  8030cc:	85 c0                	test   %eax,%eax
  8030ce:	74 0d                	je     8030dd <merging+0x208>
  8030d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d3:	8b 40 04             	mov    0x4(%eax),%eax
  8030d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030d9:	89 10                	mov    %edx,(%eax)
  8030db:	eb 08                	jmp    8030e5 <merging+0x210>
  8030dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030eb:	89 50 04             	mov    %edx,0x4(%eax)
  8030ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8030f3:	40                   	inc    %eax
  8030f4:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  8030f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030fd:	75 17                	jne    803116 <merging+0x241>
  8030ff:	83 ec 04             	sub    $0x4,%esp
  803102:	68 2f 47 80 00       	push   $0x80472f
  803107:	68 8e 01 00 00       	push   $0x18e
  80310c:	68 4d 47 80 00       	push   $0x80474d
  803111:	e8 ae d4 ff ff       	call   8005c4 <_panic>
  803116:	8b 45 0c             	mov    0xc(%ebp),%eax
  803119:	8b 00                	mov    (%eax),%eax
  80311b:	85 c0                	test   %eax,%eax
  80311d:	74 10                	je     80312f <merging+0x25a>
  80311f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803122:	8b 00                	mov    (%eax),%eax
  803124:	8b 55 0c             	mov    0xc(%ebp),%edx
  803127:	8b 52 04             	mov    0x4(%edx),%edx
  80312a:	89 50 04             	mov    %edx,0x4(%eax)
  80312d:	eb 0b                	jmp    80313a <merging+0x265>
  80312f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803132:	8b 40 04             	mov    0x4(%eax),%eax
  803135:	a3 30 50 80 00       	mov    %eax,0x805030
  80313a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313d:	8b 40 04             	mov    0x4(%eax),%eax
  803140:	85 c0                	test   %eax,%eax
  803142:	74 0f                	je     803153 <merging+0x27e>
  803144:	8b 45 0c             	mov    0xc(%ebp),%eax
  803147:	8b 40 04             	mov    0x4(%eax),%eax
  80314a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80314d:	8b 12                	mov    (%edx),%edx
  80314f:	89 10                	mov    %edx,(%eax)
  803151:	eb 0a                	jmp    80315d <merging+0x288>
  803153:	8b 45 0c             	mov    0xc(%ebp),%eax
  803156:	8b 00                	mov    (%eax),%eax
  803158:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80315d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803160:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803166:	8b 45 0c             	mov    0xc(%ebp),%eax
  803169:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803170:	a1 38 50 80 00       	mov    0x805038,%eax
  803175:	48                   	dec    %eax
  803176:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80317b:	e9 72 01 00 00       	jmp    8032f2 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803180:	8b 45 10             	mov    0x10(%ebp),%eax
  803183:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803186:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318a:	74 79                	je     803205 <merging+0x330>
  80318c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803190:	74 73                	je     803205 <merging+0x330>
  803192:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803196:	74 06                	je     80319e <merging+0x2c9>
  803198:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80319c:	75 17                	jne    8031b5 <merging+0x2e0>
  80319e:	83 ec 04             	sub    $0x4,%esp
  8031a1:	68 c0 47 80 00       	push   $0x8047c0
  8031a6:	68 94 01 00 00       	push   $0x194
  8031ab:	68 4d 47 80 00       	push   $0x80474d
  8031b0:	e8 0f d4 ff ff       	call   8005c4 <_panic>
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	8b 10                	mov    (%eax),%edx
  8031ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031bd:	89 10                	mov    %edx,(%eax)
  8031bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c2:	8b 00                	mov    (%eax),%eax
  8031c4:	85 c0                	test   %eax,%eax
  8031c6:	74 0b                	je     8031d3 <merging+0x2fe>
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	8b 00                	mov    (%eax),%eax
  8031cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031d0:	89 50 04             	mov    %edx,0x4(%eax)
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031d9:	89 10                	mov    %edx,(%eax)
  8031db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031de:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e1:	89 50 04             	mov    %edx,0x4(%eax)
  8031e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031e7:	8b 00                	mov    (%eax),%eax
  8031e9:	85 c0                	test   %eax,%eax
  8031eb:	75 08                	jne    8031f5 <merging+0x320>
  8031ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8031f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8031fa:	40                   	inc    %eax
  8031fb:	a3 38 50 80 00       	mov    %eax,0x805038
  803200:	e9 ce 00 00 00       	jmp    8032d3 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803205:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803209:	74 65                	je     803270 <merging+0x39b>
  80320b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80320f:	75 17                	jne    803228 <merging+0x353>
  803211:	83 ec 04             	sub    $0x4,%esp
  803214:	68 9c 47 80 00       	push   $0x80479c
  803219:	68 95 01 00 00       	push   $0x195
  80321e:	68 4d 47 80 00       	push   $0x80474d
  803223:	e8 9c d3 ff ff       	call   8005c4 <_panic>
  803228:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80322e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803231:	89 50 04             	mov    %edx,0x4(%eax)
  803234:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803237:	8b 40 04             	mov    0x4(%eax),%eax
  80323a:	85 c0                	test   %eax,%eax
  80323c:	74 0c                	je     80324a <merging+0x375>
  80323e:	a1 30 50 80 00       	mov    0x805030,%eax
  803243:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803246:	89 10                	mov    %edx,(%eax)
  803248:	eb 08                	jmp    803252 <merging+0x37d>
  80324a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80324d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803252:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803255:	a3 30 50 80 00       	mov    %eax,0x805030
  80325a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803263:	a1 38 50 80 00       	mov    0x805038,%eax
  803268:	40                   	inc    %eax
  803269:	a3 38 50 80 00       	mov    %eax,0x805038
  80326e:	eb 63                	jmp    8032d3 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803270:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803274:	75 17                	jne    80328d <merging+0x3b8>
  803276:	83 ec 04             	sub    $0x4,%esp
  803279:	68 68 47 80 00       	push   $0x804768
  80327e:	68 98 01 00 00       	push   $0x198
  803283:	68 4d 47 80 00       	push   $0x80474d
  803288:	e8 37 d3 ff ff       	call   8005c4 <_panic>
  80328d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803293:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803296:	89 10                	mov    %edx,(%eax)
  803298:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80329b:	8b 00                	mov    (%eax),%eax
  80329d:	85 c0                	test   %eax,%eax
  80329f:	74 0d                	je     8032ae <merging+0x3d9>
  8032a1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032a9:	89 50 04             	mov    %edx,0x4(%eax)
  8032ac:	eb 08                	jmp    8032b6 <merging+0x3e1>
  8032ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b1:	a3 30 50 80 00       	mov    %eax,0x805030
  8032b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c8:	a1 38 50 80 00       	mov    0x805038,%eax
  8032cd:	40                   	inc    %eax
  8032ce:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8032d3:	83 ec 0c             	sub    $0xc,%esp
  8032d6:	ff 75 10             	pushl  0x10(%ebp)
  8032d9:	e8 d6 ed ff ff       	call   8020b4 <get_block_size>
  8032de:	83 c4 10             	add    $0x10,%esp
  8032e1:	83 ec 04             	sub    $0x4,%esp
  8032e4:	6a 00                	push   $0x0
  8032e6:	50                   	push   %eax
  8032e7:	ff 75 10             	pushl  0x10(%ebp)
  8032ea:	e8 16 f1 ff ff       	call   802405 <set_block_data>
  8032ef:	83 c4 10             	add    $0x10,%esp
	}
}
  8032f2:	90                   	nop
  8032f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032f6:	c9                   	leave  
  8032f7:	c3                   	ret    

008032f8 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8032f8:	55                   	push   %ebp
  8032f9:	89 e5                	mov    %esp,%ebp
  8032fb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8032fe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803303:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803306:	a1 30 50 80 00       	mov    0x805030,%eax
  80330b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80330e:	73 1b                	jae    80332b <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803310:	a1 30 50 80 00       	mov    0x805030,%eax
  803315:	83 ec 04             	sub    $0x4,%esp
  803318:	ff 75 08             	pushl  0x8(%ebp)
  80331b:	6a 00                	push   $0x0
  80331d:	50                   	push   %eax
  80331e:	e8 b2 fb ff ff       	call   802ed5 <merging>
  803323:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803326:	e9 8b 00 00 00       	jmp    8033b6 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80332b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803330:	3b 45 08             	cmp    0x8(%ebp),%eax
  803333:	76 18                	jbe    80334d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803335:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80333a:	83 ec 04             	sub    $0x4,%esp
  80333d:	ff 75 08             	pushl  0x8(%ebp)
  803340:	50                   	push   %eax
  803341:	6a 00                	push   $0x0
  803343:	e8 8d fb ff ff       	call   802ed5 <merging>
  803348:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80334b:	eb 69                	jmp    8033b6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80334d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803352:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803355:	eb 39                	jmp    803390 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80335d:	73 29                	jae    803388 <free_block+0x90>
  80335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803362:	8b 00                	mov    (%eax),%eax
  803364:	3b 45 08             	cmp    0x8(%ebp),%eax
  803367:	76 1f                	jbe    803388 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803371:	83 ec 04             	sub    $0x4,%esp
  803374:	ff 75 08             	pushl  0x8(%ebp)
  803377:	ff 75 f0             	pushl  -0x10(%ebp)
  80337a:	ff 75 f4             	pushl  -0xc(%ebp)
  80337d:	e8 53 fb ff ff       	call   802ed5 <merging>
  803382:	83 c4 10             	add    $0x10,%esp
			break;
  803385:	90                   	nop
		}
	}
}
  803386:	eb 2e                	jmp    8033b6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803388:	a1 34 50 80 00       	mov    0x805034,%eax
  80338d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803394:	74 07                	je     80339d <free_block+0xa5>
  803396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803399:	8b 00                	mov    (%eax),%eax
  80339b:	eb 05                	jmp    8033a2 <free_block+0xaa>
  80339d:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a2:	a3 34 50 80 00       	mov    %eax,0x805034
  8033a7:	a1 34 50 80 00       	mov    0x805034,%eax
  8033ac:	85 c0                	test   %eax,%eax
  8033ae:	75 a7                	jne    803357 <free_block+0x5f>
  8033b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b4:	75 a1                	jne    803357 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033b6:	90                   	nop
  8033b7:	c9                   	leave  
  8033b8:	c3                   	ret    

008033b9 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8033b9:	55                   	push   %ebp
  8033ba:	89 e5                	mov    %esp,%ebp
  8033bc:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8033bf:	ff 75 08             	pushl  0x8(%ebp)
  8033c2:	e8 ed ec ff ff       	call   8020b4 <get_block_size>
  8033c7:	83 c4 04             	add    $0x4,%esp
  8033ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8033cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033d4:	eb 17                	jmp    8033ed <copy_data+0x34>
  8033d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033dc:	01 c2                	add    %eax,%edx
  8033de:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	01 c8                	add    %ecx,%eax
  8033e6:	8a 00                	mov    (%eax),%al
  8033e8:	88 02                	mov    %al,(%edx)
  8033ea:	ff 45 fc             	incl   -0x4(%ebp)
  8033ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8033f3:	72 e1                	jb     8033d6 <copy_data+0x1d>
}
  8033f5:	90                   	nop
  8033f6:	c9                   	leave  
  8033f7:	c3                   	ret    

008033f8 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8033f8:	55                   	push   %ebp
  8033f9:	89 e5                	mov    %esp,%ebp
  8033fb:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8033fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803402:	75 23                	jne    803427 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803404:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803408:	74 13                	je     80341d <realloc_block_FF+0x25>
  80340a:	83 ec 0c             	sub    $0xc,%esp
  80340d:	ff 75 0c             	pushl  0xc(%ebp)
  803410:	e8 1f f0 ff ff       	call   802434 <alloc_block_FF>
  803415:	83 c4 10             	add    $0x10,%esp
  803418:	e9 f4 06 00 00       	jmp    803b11 <realloc_block_FF+0x719>
		return NULL;
  80341d:	b8 00 00 00 00       	mov    $0x0,%eax
  803422:	e9 ea 06 00 00       	jmp    803b11 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803427:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80342b:	75 18                	jne    803445 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80342d:	83 ec 0c             	sub    $0xc,%esp
  803430:	ff 75 08             	pushl  0x8(%ebp)
  803433:	e8 c0 fe ff ff       	call   8032f8 <free_block>
  803438:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80343b:	b8 00 00 00 00       	mov    $0x0,%eax
  803440:	e9 cc 06 00 00       	jmp    803b11 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803445:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803449:	77 07                	ja     803452 <realloc_block_FF+0x5a>
  80344b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803452:	8b 45 0c             	mov    0xc(%ebp),%eax
  803455:	83 e0 01             	and    $0x1,%eax
  803458:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80345b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80345e:	83 c0 08             	add    $0x8,%eax
  803461:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803464:	83 ec 0c             	sub    $0xc,%esp
  803467:	ff 75 08             	pushl  0x8(%ebp)
  80346a:	e8 45 ec ff ff       	call   8020b4 <get_block_size>
  80346f:	83 c4 10             	add    $0x10,%esp
  803472:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803475:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803478:	83 e8 08             	sub    $0x8,%eax
  80347b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	83 e8 04             	sub    $0x4,%eax
  803484:	8b 00                	mov    (%eax),%eax
  803486:	83 e0 fe             	and    $0xfffffffe,%eax
  803489:	89 c2                	mov    %eax,%edx
  80348b:	8b 45 08             	mov    0x8(%ebp),%eax
  80348e:	01 d0                	add    %edx,%eax
  803490:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803493:	83 ec 0c             	sub    $0xc,%esp
  803496:	ff 75 e4             	pushl  -0x1c(%ebp)
  803499:	e8 16 ec ff ff       	call   8020b4 <get_block_size>
  80349e:	83 c4 10             	add    $0x10,%esp
  8034a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a7:	83 e8 08             	sub    $0x8,%eax
  8034aa:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8034ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034b3:	75 08                	jne    8034bd <realloc_block_FF+0xc5>
	{
		 return va;
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	e9 54 06 00 00       	jmp    803b11 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8034bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034c3:	0f 83 e5 03 00 00    	jae    8038ae <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034d2:	83 ec 0c             	sub    $0xc,%esp
  8034d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034d8:	e8 f0 eb ff ff       	call   8020cd <is_free_block>
  8034dd:	83 c4 10             	add    $0x10,%esp
  8034e0:	84 c0                	test   %al,%al
  8034e2:	0f 84 3b 01 00 00    	je     803623 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8034e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034ee:	01 d0                	add    %edx,%eax
  8034f0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8034f3:	83 ec 04             	sub    $0x4,%esp
  8034f6:	6a 01                	push   $0x1
  8034f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8034fb:	ff 75 08             	pushl  0x8(%ebp)
  8034fe:	e8 02 ef ff ff       	call   802405 <set_block_data>
  803503:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	83 e8 04             	sub    $0x4,%eax
  80350c:	8b 00                	mov    (%eax),%eax
  80350e:	83 e0 fe             	and    $0xfffffffe,%eax
  803511:	89 c2                	mov    %eax,%edx
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	01 d0                	add    %edx,%eax
  803518:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80351b:	83 ec 04             	sub    $0x4,%esp
  80351e:	6a 00                	push   $0x0
  803520:	ff 75 cc             	pushl  -0x34(%ebp)
  803523:	ff 75 c8             	pushl  -0x38(%ebp)
  803526:	e8 da ee ff ff       	call   802405 <set_block_data>
  80352b:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80352e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803532:	74 06                	je     80353a <realloc_block_FF+0x142>
  803534:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803538:	75 17                	jne    803551 <realloc_block_FF+0x159>
  80353a:	83 ec 04             	sub    $0x4,%esp
  80353d:	68 c0 47 80 00       	push   $0x8047c0
  803542:	68 f6 01 00 00       	push   $0x1f6
  803547:	68 4d 47 80 00       	push   $0x80474d
  80354c:	e8 73 d0 ff ff       	call   8005c4 <_panic>
  803551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803554:	8b 10                	mov    (%eax),%edx
  803556:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803559:	89 10                	mov    %edx,(%eax)
  80355b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	85 c0                	test   %eax,%eax
  803562:	74 0b                	je     80356f <realloc_block_FF+0x177>
  803564:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803567:	8b 00                	mov    (%eax),%eax
  803569:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80356c:	89 50 04             	mov    %edx,0x4(%eax)
  80356f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803572:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803575:	89 10                	mov    %edx,(%eax)
  803577:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80357a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80357d:	89 50 04             	mov    %edx,0x4(%eax)
  803580:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803583:	8b 00                	mov    (%eax),%eax
  803585:	85 c0                	test   %eax,%eax
  803587:	75 08                	jne    803591 <realloc_block_FF+0x199>
  803589:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80358c:	a3 30 50 80 00       	mov    %eax,0x805030
  803591:	a1 38 50 80 00       	mov    0x805038,%eax
  803596:	40                   	inc    %eax
  803597:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80359c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a0:	75 17                	jne    8035b9 <realloc_block_FF+0x1c1>
  8035a2:	83 ec 04             	sub    $0x4,%esp
  8035a5:	68 2f 47 80 00       	push   $0x80472f
  8035aa:	68 f7 01 00 00       	push   $0x1f7
  8035af:	68 4d 47 80 00       	push   $0x80474d
  8035b4:	e8 0b d0 ff ff       	call   8005c4 <_panic>
  8035b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035bc:	8b 00                	mov    (%eax),%eax
  8035be:	85 c0                	test   %eax,%eax
  8035c0:	74 10                	je     8035d2 <realloc_block_FF+0x1da>
  8035c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c5:	8b 00                	mov    (%eax),%eax
  8035c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035ca:	8b 52 04             	mov    0x4(%edx),%edx
  8035cd:	89 50 04             	mov    %edx,0x4(%eax)
  8035d0:	eb 0b                	jmp    8035dd <realloc_block_FF+0x1e5>
  8035d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d5:	8b 40 04             	mov    0x4(%eax),%eax
  8035d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e0:	8b 40 04             	mov    0x4(%eax),%eax
  8035e3:	85 c0                	test   %eax,%eax
  8035e5:	74 0f                	je     8035f6 <realloc_block_FF+0x1fe>
  8035e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ea:	8b 40 04             	mov    0x4(%eax),%eax
  8035ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f0:	8b 12                	mov    (%edx),%edx
  8035f2:	89 10                	mov    %edx,(%eax)
  8035f4:	eb 0a                	jmp    803600 <realloc_block_FF+0x208>
  8035f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f9:	8b 00                	mov    (%eax),%eax
  8035fb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803613:	a1 38 50 80 00       	mov    0x805038,%eax
  803618:	48                   	dec    %eax
  803619:	a3 38 50 80 00       	mov    %eax,0x805038
  80361e:	e9 83 02 00 00       	jmp    8038a6 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803623:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803627:	0f 86 69 02 00 00    	jbe    803896 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80362d:	83 ec 04             	sub    $0x4,%esp
  803630:	6a 01                	push   $0x1
  803632:	ff 75 f0             	pushl  -0x10(%ebp)
  803635:	ff 75 08             	pushl  0x8(%ebp)
  803638:	e8 c8 ed ff ff       	call   802405 <set_block_data>
  80363d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803640:	8b 45 08             	mov    0x8(%ebp),%eax
  803643:	83 e8 04             	sub    $0x4,%eax
  803646:	8b 00                	mov    (%eax),%eax
  803648:	83 e0 fe             	and    $0xfffffffe,%eax
  80364b:	89 c2                	mov    %eax,%edx
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	01 d0                	add    %edx,%eax
  803652:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803655:	a1 38 50 80 00       	mov    0x805038,%eax
  80365a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80365d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803661:	75 68                	jne    8036cb <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803663:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803667:	75 17                	jne    803680 <realloc_block_FF+0x288>
  803669:	83 ec 04             	sub    $0x4,%esp
  80366c:	68 68 47 80 00       	push   $0x804768
  803671:	68 06 02 00 00       	push   $0x206
  803676:	68 4d 47 80 00       	push   $0x80474d
  80367b:	e8 44 cf ff ff       	call   8005c4 <_panic>
  803680:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803689:	89 10                	mov    %edx,(%eax)
  80368b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368e:	8b 00                	mov    (%eax),%eax
  803690:	85 c0                	test   %eax,%eax
  803692:	74 0d                	je     8036a1 <realloc_block_FF+0x2a9>
  803694:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803699:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80369c:	89 50 04             	mov    %edx,0x4(%eax)
  80369f:	eb 08                	jmp    8036a9 <realloc_block_FF+0x2b1>
  8036a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036a4:	a3 30 50 80 00       	mov    %eax,0x805030
  8036a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036bb:	a1 38 50 80 00       	mov    0x805038,%eax
  8036c0:	40                   	inc    %eax
  8036c1:	a3 38 50 80 00       	mov    %eax,0x805038
  8036c6:	e9 b0 01 00 00       	jmp    80387b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8036cb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036d0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036d3:	76 68                	jbe    80373d <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036d5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036d9:	75 17                	jne    8036f2 <realloc_block_FF+0x2fa>
  8036db:	83 ec 04             	sub    $0x4,%esp
  8036de:	68 68 47 80 00       	push   $0x804768
  8036e3:	68 0b 02 00 00       	push   $0x20b
  8036e8:	68 4d 47 80 00       	push   $0x80474d
  8036ed:	e8 d2 ce ff ff       	call   8005c4 <_panic>
  8036f2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8036f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036fb:	89 10                	mov    %edx,(%eax)
  8036fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803700:	8b 00                	mov    (%eax),%eax
  803702:	85 c0                	test   %eax,%eax
  803704:	74 0d                	je     803713 <realloc_block_FF+0x31b>
  803706:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80370b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80370e:	89 50 04             	mov    %edx,0x4(%eax)
  803711:	eb 08                	jmp    80371b <realloc_block_FF+0x323>
  803713:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803716:	a3 30 50 80 00       	mov    %eax,0x805030
  80371b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80371e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803723:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803726:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80372d:	a1 38 50 80 00       	mov    0x805038,%eax
  803732:	40                   	inc    %eax
  803733:	a3 38 50 80 00       	mov    %eax,0x805038
  803738:	e9 3e 01 00 00       	jmp    80387b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80373d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803742:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803745:	73 68                	jae    8037af <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803747:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80374b:	75 17                	jne    803764 <realloc_block_FF+0x36c>
  80374d:	83 ec 04             	sub    $0x4,%esp
  803750:	68 9c 47 80 00       	push   $0x80479c
  803755:	68 10 02 00 00       	push   $0x210
  80375a:	68 4d 47 80 00       	push   $0x80474d
  80375f:	e8 60 ce ff ff       	call   8005c4 <_panic>
  803764:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80376a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80376d:	89 50 04             	mov    %edx,0x4(%eax)
  803770:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803773:	8b 40 04             	mov    0x4(%eax),%eax
  803776:	85 c0                	test   %eax,%eax
  803778:	74 0c                	je     803786 <realloc_block_FF+0x38e>
  80377a:	a1 30 50 80 00       	mov    0x805030,%eax
  80377f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803782:	89 10                	mov    %edx,(%eax)
  803784:	eb 08                	jmp    80378e <realloc_block_FF+0x396>
  803786:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803789:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80378e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803791:	a3 30 50 80 00       	mov    %eax,0x805030
  803796:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803799:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379f:	a1 38 50 80 00       	mov    0x805038,%eax
  8037a4:	40                   	inc    %eax
  8037a5:	a3 38 50 80 00       	mov    %eax,0x805038
  8037aa:	e9 cc 00 00 00       	jmp    80387b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8037af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8037b6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037be:	e9 8a 00 00 00       	jmp    80384d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037c9:	73 7a                	jae    803845 <realloc_block_FF+0x44d>
  8037cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ce:	8b 00                	mov    (%eax),%eax
  8037d0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037d3:	73 70                	jae    803845 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d9:	74 06                	je     8037e1 <realloc_block_FF+0x3e9>
  8037db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037df:	75 17                	jne    8037f8 <realloc_block_FF+0x400>
  8037e1:	83 ec 04             	sub    $0x4,%esp
  8037e4:	68 c0 47 80 00       	push   $0x8047c0
  8037e9:	68 1a 02 00 00       	push   $0x21a
  8037ee:	68 4d 47 80 00       	push   $0x80474d
  8037f3:	e8 cc cd ff ff       	call   8005c4 <_panic>
  8037f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fb:	8b 10                	mov    (%eax),%edx
  8037fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803800:	89 10                	mov    %edx,(%eax)
  803802:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803805:	8b 00                	mov    (%eax),%eax
  803807:	85 c0                	test   %eax,%eax
  803809:	74 0b                	je     803816 <realloc_block_FF+0x41e>
  80380b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380e:	8b 00                	mov    (%eax),%eax
  803810:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803813:	89 50 04             	mov    %edx,0x4(%eax)
  803816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803819:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80381c:	89 10                	mov    %edx,(%eax)
  80381e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803824:	89 50 04             	mov    %edx,0x4(%eax)
  803827:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80382a:	8b 00                	mov    (%eax),%eax
  80382c:	85 c0                	test   %eax,%eax
  80382e:	75 08                	jne    803838 <realloc_block_FF+0x440>
  803830:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803833:	a3 30 50 80 00       	mov    %eax,0x805030
  803838:	a1 38 50 80 00       	mov    0x805038,%eax
  80383d:	40                   	inc    %eax
  80383e:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803843:	eb 36                	jmp    80387b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803845:	a1 34 50 80 00       	mov    0x805034,%eax
  80384a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80384d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803851:	74 07                	je     80385a <realloc_block_FF+0x462>
  803853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803856:	8b 00                	mov    (%eax),%eax
  803858:	eb 05                	jmp    80385f <realloc_block_FF+0x467>
  80385a:	b8 00 00 00 00       	mov    $0x0,%eax
  80385f:	a3 34 50 80 00       	mov    %eax,0x805034
  803864:	a1 34 50 80 00       	mov    0x805034,%eax
  803869:	85 c0                	test   %eax,%eax
  80386b:	0f 85 52 ff ff ff    	jne    8037c3 <realloc_block_FF+0x3cb>
  803871:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803875:	0f 85 48 ff ff ff    	jne    8037c3 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80387b:	83 ec 04             	sub    $0x4,%esp
  80387e:	6a 00                	push   $0x0
  803880:	ff 75 d8             	pushl  -0x28(%ebp)
  803883:	ff 75 d4             	pushl  -0x2c(%ebp)
  803886:	e8 7a eb ff ff       	call   802405 <set_block_data>
  80388b:	83 c4 10             	add    $0x10,%esp
				return va;
  80388e:	8b 45 08             	mov    0x8(%ebp),%eax
  803891:	e9 7b 02 00 00       	jmp    803b11 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803896:	83 ec 0c             	sub    $0xc,%esp
  803899:	68 3d 48 80 00       	push   $0x80483d
  80389e:	e8 de cf ff ff       	call   800881 <cprintf>
  8038a3:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8038a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a9:	e9 63 02 00 00       	jmp    803b11 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8038ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038b4:	0f 86 4d 02 00 00    	jbe    803b07 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8038ba:	83 ec 0c             	sub    $0xc,%esp
  8038bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038c0:	e8 08 e8 ff ff       	call   8020cd <is_free_block>
  8038c5:	83 c4 10             	add    $0x10,%esp
  8038c8:	84 c0                	test   %al,%al
  8038ca:	0f 84 37 02 00 00    	je     803b07 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038d3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038dc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038df:	76 38                	jbe    803919 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8038e1:	83 ec 0c             	sub    $0xc,%esp
  8038e4:	ff 75 08             	pushl  0x8(%ebp)
  8038e7:	e8 0c fa ff ff       	call   8032f8 <free_block>
  8038ec:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8038ef:	83 ec 0c             	sub    $0xc,%esp
  8038f2:	ff 75 0c             	pushl  0xc(%ebp)
  8038f5:	e8 3a eb ff ff       	call   802434 <alloc_block_FF>
  8038fa:	83 c4 10             	add    $0x10,%esp
  8038fd:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803900:	83 ec 08             	sub    $0x8,%esp
  803903:	ff 75 c0             	pushl  -0x40(%ebp)
  803906:	ff 75 08             	pushl  0x8(%ebp)
  803909:	e8 ab fa ff ff       	call   8033b9 <copy_data>
  80390e:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803911:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803914:	e9 f8 01 00 00       	jmp    803b11 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803919:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80391c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80391f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803922:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803926:	0f 87 a0 00 00 00    	ja     8039cc <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80392c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803930:	75 17                	jne    803949 <realloc_block_FF+0x551>
  803932:	83 ec 04             	sub    $0x4,%esp
  803935:	68 2f 47 80 00       	push   $0x80472f
  80393a:	68 38 02 00 00       	push   $0x238
  80393f:	68 4d 47 80 00       	push   $0x80474d
  803944:	e8 7b cc ff ff       	call   8005c4 <_panic>
  803949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	85 c0                	test   %eax,%eax
  803950:	74 10                	je     803962 <realloc_block_FF+0x56a>
  803952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803955:	8b 00                	mov    (%eax),%eax
  803957:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80395a:	8b 52 04             	mov    0x4(%edx),%edx
  80395d:	89 50 04             	mov    %edx,0x4(%eax)
  803960:	eb 0b                	jmp    80396d <realloc_block_FF+0x575>
  803962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803965:	8b 40 04             	mov    0x4(%eax),%eax
  803968:	a3 30 50 80 00       	mov    %eax,0x805030
  80396d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803970:	8b 40 04             	mov    0x4(%eax),%eax
  803973:	85 c0                	test   %eax,%eax
  803975:	74 0f                	je     803986 <realloc_block_FF+0x58e>
  803977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397a:	8b 40 04             	mov    0x4(%eax),%eax
  80397d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803980:	8b 12                	mov    (%edx),%edx
  803982:	89 10                	mov    %edx,(%eax)
  803984:	eb 0a                	jmp    803990 <realloc_block_FF+0x598>
  803986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803989:	8b 00                	mov    (%eax),%eax
  80398b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803993:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a3:	a1 38 50 80 00       	mov    0x805038,%eax
  8039a8:	48                   	dec    %eax
  8039a9:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039b4:	01 d0                	add    %edx,%eax
  8039b6:	83 ec 04             	sub    $0x4,%esp
  8039b9:	6a 01                	push   $0x1
  8039bb:	50                   	push   %eax
  8039bc:	ff 75 08             	pushl  0x8(%ebp)
  8039bf:	e8 41 ea ff ff       	call   802405 <set_block_data>
  8039c4:	83 c4 10             	add    $0x10,%esp
  8039c7:	e9 36 01 00 00       	jmp    803b02 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039d2:	01 d0                	add    %edx,%eax
  8039d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039d7:	83 ec 04             	sub    $0x4,%esp
  8039da:	6a 01                	push   $0x1
  8039dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8039df:	ff 75 08             	pushl  0x8(%ebp)
  8039e2:	e8 1e ea ff ff       	call   802405 <set_block_data>
  8039e7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ed:	83 e8 04             	sub    $0x4,%eax
  8039f0:	8b 00                	mov    (%eax),%eax
  8039f2:	83 e0 fe             	and    $0xfffffffe,%eax
  8039f5:	89 c2                	mov    %eax,%edx
  8039f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fa:	01 d0                	add    %edx,%eax
  8039fc:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a03:	74 06                	je     803a0b <realloc_block_FF+0x613>
  803a05:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a09:	75 17                	jne    803a22 <realloc_block_FF+0x62a>
  803a0b:	83 ec 04             	sub    $0x4,%esp
  803a0e:	68 c0 47 80 00       	push   $0x8047c0
  803a13:	68 44 02 00 00       	push   $0x244
  803a18:	68 4d 47 80 00       	push   $0x80474d
  803a1d:	e8 a2 cb ff ff       	call   8005c4 <_panic>
  803a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a25:	8b 10                	mov    (%eax),%edx
  803a27:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a2a:	89 10                	mov    %edx,(%eax)
  803a2c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a2f:	8b 00                	mov    (%eax),%eax
  803a31:	85 c0                	test   %eax,%eax
  803a33:	74 0b                	je     803a40 <realloc_block_FF+0x648>
  803a35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a38:	8b 00                	mov    (%eax),%eax
  803a3a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a3d:	89 50 04             	mov    %edx,0x4(%eax)
  803a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a43:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a46:	89 10                	mov    %edx,(%eax)
  803a48:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a4b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a4e:	89 50 04             	mov    %edx,0x4(%eax)
  803a51:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a54:	8b 00                	mov    (%eax),%eax
  803a56:	85 c0                	test   %eax,%eax
  803a58:	75 08                	jne    803a62 <realloc_block_FF+0x66a>
  803a5a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a5d:	a3 30 50 80 00       	mov    %eax,0x805030
  803a62:	a1 38 50 80 00       	mov    0x805038,%eax
  803a67:	40                   	inc    %eax
  803a68:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a71:	75 17                	jne    803a8a <realloc_block_FF+0x692>
  803a73:	83 ec 04             	sub    $0x4,%esp
  803a76:	68 2f 47 80 00       	push   $0x80472f
  803a7b:	68 45 02 00 00       	push   $0x245
  803a80:	68 4d 47 80 00       	push   $0x80474d
  803a85:	e8 3a cb ff ff       	call   8005c4 <_panic>
  803a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8d:	8b 00                	mov    (%eax),%eax
  803a8f:	85 c0                	test   %eax,%eax
  803a91:	74 10                	je     803aa3 <realloc_block_FF+0x6ab>
  803a93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a96:	8b 00                	mov    (%eax),%eax
  803a98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a9b:	8b 52 04             	mov    0x4(%edx),%edx
  803a9e:	89 50 04             	mov    %edx,0x4(%eax)
  803aa1:	eb 0b                	jmp    803aae <realloc_block_FF+0x6b6>
  803aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa6:	8b 40 04             	mov    0x4(%eax),%eax
  803aa9:	a3 30 50 80 00       	mov    %eax,0x805030
  803aae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab1:	8b 40 04             	mov    0x4(%eax),%eax
  803ab4:	85 c0                	test   %eax,%eax
  803ab6:	74 0f                	je     803ac7 <realloc_block_FF+0x6cf>
  803ab8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803abb:	8b 40 04             	mov    0x4(%eax),%eax
  803abe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ac1:	8b 12                	mov    (%edx),%edx
  803ac3:	89 10                	mov    %edx,(%eax)
  803ac5:	eb 0a                	jmp    803ad1 <realloc_block_FF+0x6d9>
  803ac7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aca:	8b 00                	mov    (%eax),%eax
  803acc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ad4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ada:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803add:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ae4:	a1 38 50 80 00       	mov    0x805038,%eax
  803ae9:	48                   	dec    %eax
  803aea:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803aef:	83 ec 04             	sub    $0x4,%esp
  803af2:	6a 00                	push   $0x0
  803af4:	ff 75 bc             	pushl  -0x44(%ebp)
  803af7:	ff 75 b8             	pushl  -0x48(%ebp)
  803afa:	e8 06 e9 ff ff       	call   802405 <set_block_data>
  803aff:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b02:	8b 45 08             	mov    0x8(%ebp),%eax
  803b05:	eb 0a                	jmp    803b11 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b07:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b0e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b11:	c9                   	leave  
  803b12:	c3                   	ret    

00803b13 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b13:	55                   	push   %ebp
  803b14:	89 e5                	mov    %esp,%ebp
  803b16:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b19:	83 ec 04             	sub    $0x4,%esp
  803b1c:	68 44 48 80 00       	push   $0x804844
  803b21:	68 58 02 00 00       	push   $0x258
  803b26:	68 4d 47 80 00       	push   $0x80474d
  803b2b:	e8 94 ca ff ff       	call   8005c4 <_panic>

00803b30 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b30:	55                   	push   %ebp
  803b31:	89 e5                	mov    %esp,%ebp
  803b33:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b36:	83 ec 04             	sub    $0x4,%esp
  803b39:	68 6c 48 80 00       	push   $0x80486c
  803b3e:	68 61 02 00 00       	push   $0x261
  803b43:	68 4d 47 80 00       	push   $0x80474d
  803b48:	e8 77 ca ff ff       	call   8005c4 <_panic>
  803b4d:	66 90                	xchg   %ax,%ax
  803b4f:	90                   	nop

00803b50 <__udivdi3>:
  803b50:	55                   	push   %ebp
  803b51:	57                   	push   %edi
  803b52:	56                   	push   %esi
  803b53:	53                   	push   %ebx
  803b54:	83 ec 1c             	sub    $0x1c,%esp
  803b57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b67:	89 ca                	mov    %ecx,%edx
  803b69:	89 f8                	mov    %edi,%eax
  803b6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b6f:	85 f6                	test   %esi,%esi
  803b71:	75 2d                	jne    803ba0 <__udivdi3+0x50>
  803b73:	39 cf                	cmp    %ecx,%edi
  803b75:	77 65                	ja     803bdc <__udivdi3+0x8c>
  803b77:	89 fd                	mov    %edi,%ebp
  803b79:	85 ff                	test   %edi,%edi
  803b7b:	75 0b                	jne    803b88 <__udivdi3+0x38>
  803b7d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b82:	31 d2                	xor    %edx,%edx
  803b84:	f7 f7                	div    %edi
  803b86:	89 c5                	mov    %eax,%ebp
  803b88:	31 d2                	xor    %edx,%edx
  803b8a:	89 c8                	mov    %ecx,%eax
  803b8c:	f7 f5                	div    %ebp
  803b8e:	89 c1                	mov    %eax,%ecx
  803b90:	89 d8                	mov    %ebx,%eax
  803b92:	f7 f5                	div    %ebp
  803b94:	89 cf                	mov    %ecx,%edi
  803b96:	89 fa                	mov    %edi,%edx
  803b98:	83 c4 1c             	add    $0x1c,%esp
  803b9b:	5b                   	pop    %ebx
  803b9c:	5e                   	pop    %esi
  803b9d:	5f                   	pop    %edi
  803b9e:	5d                   	pop    %ebp
  803b9f:	c3                   	ret    
  803ba0:	39 ce                	cmp    %ecx,%esi
  803ba2:	77 28                	ja     803bcc <__udivdi3+0x7c>
  803ba4:	0f bd fe             	bsr    %esi,%edi
  803ba7:	83 f7 1f             	xor    $0x1f,%edi
  803baa:	75 40                	jne    803bec <__udivdi3+0x9c>
  803bac:	39 ce                	cmp    %ecx,%esi
  803bae:	72 0a                	jb     803bba <__udivdi3+0x6a>
  803bb0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bb4:	0f 87 9e 00 00 00    	ja     803c58 <__udivdi3+0x108>
  803bba:	b8 01 00 00 00       	mov    $0x1,%eax
  803bbf:	89 fa                	mov    %edi,%edx
  803bc1:	83 c4 1c             	add    $0x1c,%esp
  803bc4:	5b                   	pop    %ebx
  803bc5:	5e                   	pop    %esi
  803bc6:	5f                   	pop    %edi
  803bc7:	5d                   	pop    %ebp
  803bc8:	c3                   	ret    
  803bc9:	8d 76 00             	lea    0x0(%esi),%esi
  803bcc:	31 ff                	xor    %edi,%edi
  803bce:	31 c0                	xor    %eax,%eax
  803bd0:	89 fa                	mov    %edi,%edx
  803bd2:	83 c4 1c             	add    $0x1c,%esp
  803bd5:	5b                   	pop    %ebx
  803bd6:	5e                   	pop    %esi
  803bd7:	5f                   	pop    %edi
  803bd8:	5d                   	pop    %ebp
  803bd9:	c3                   	ret    
  803bda:	66 90                	xchg   %ax,%ax
  803bdc:	89 d8                	mov    %ebx,%eax
  803bde:	f7 f7                	div    %edi
  803be0:	31 ff                	xor    %edi,%edi
  803be2:	89 fa                	mov    %edi,%edx
  803be4:	83 c4 1c             	add    $0x1c,%esp
  803be7:	5b                   	pop    %ebx
  803be8:	5e                   	pop    %esi
  803be9:	5f                   	pop    %edi
  803bea:	5d                   	pop    %ebp
  803beb:	c3                   	ret    
  803bec:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bf1:	89 eb                	mov    %ebp,%ebx
  803bf3:	29 fb                	sub    %edi,%ebx
  803bf5:	89 f9                	mov    %edi,%ecx
  803bf7:	d3 e6                	shl    %cl,%esi
  803bf9:	89 c5                	mov    %eax,%ebp
  803bfb:	88 d9                	mov    %bl,%cl
  803bfd:	d3 ed                	shr    %cl,%ebp
  803bff:	89 e9                	mov    %ebp,%ecx
  803c01:	09 f1                	or     %esi,%ecx
  803c03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c07:	89 f9                	mov    %edi,%ecx
  803c09:	d3 e0                	shl    %cl,%eax
  803c0b:	89 c5                	mov    %eax,%ebp
  803c0d:	89 d6                	mov    %edx,%esi
  803c0f:	88 d9                	mov    %bl,%cl
  803c11:	d3 ee                	shr    %cl,%esi
  803c13:	89 f9                	mov    %edi,%ecx
  803c15:	d3 e2                	shl    %cl,%edx
  803c17:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c1b:	88 d9                	mov    %bl,%cl
  803c1d:	d3 e8                	shr    %cl,%eax
  803c1f:	09 c2                	or     %eax,%edx
  803c21:	89 d0                	mov    %edx,%eax
  803c23:	89 f2                	mov    %esi,%edx
  803c25:	f7 74 24 0c          	divl   0xc(%esp)
  803c29:	89 d6                	mov    %edx,%esi
  803c2b:	89 c3                	mov    %eax,%ebx
  803c2d:	f7 e5                	mul    %ebp
  803c2f:	39 d6                	cmp    %edx,%esi
  803c31:	72 19                	jb     803c4c <__udivdi3+0xfc>
  803c33:	74 0b                	je     803c40 <__udivdi3+0xf0>
  803c35:	89 d8                	mov    %ebx,%eax
  803c37:	31 ff                	xor    %edi,%edi
  803c39:	e9 58 ff ff ff       	jmp    803b96 <__udivdi3+0x46>
  803c3e:	66 90                	xchg   %ax,%ax
  803c40:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c44:	89 f9                	mov    %edi,%ecx
  803c46:	d3 e2                	shl    %cl,%edx
  803c48:	39 c2                	cmp    %eax,%edx
  803c4a:	73 e9                	jae    803c35 <__udivdi3+0xe5>
  803c4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c4f:	31 ff                	xor    %edi,%edi
  803c51:	e9 40 ff ff ff       	jmp    803b96 <__udivdi3+0x46>
  803c56:	66 90                	xchg   %ax,%ax
  803c58:	31 c0                	xor    %eax,%eax
  803c5a:	e9 37 ff ff ff       	jmp    803b96 <__udivdi3+0x46>
  803c5f:	90                   	nop

00803c60 <__umoddi3>:
  803c60:	55                   	push   %ebp
  803c61:	57                   	push   %edi
  803c62:	56                   	push   %esi
  803c63:	53                   	push   %ebx
  803c64:	83 ec 1c             	sub    $0x1c,%esp
  803c67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c7f:	89 f3                	mov    %esi,%ebx
  803c81:	89 fa                	mov    %edi,%edx
  803c83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c87:	89 34 24             	mov    %esi,(%esp)
  803c8a:	85 c0                	test   %eax,%eax
  803c8c:	75 1a                	jne    803ca8 <__umoddi3+0x48>
  803c8e:	39 f7                	cmp    %esi,%edi
  803c90:	0f 86 a2 00 00 00    	jbe    803d38 <__umoddi3+0xd8>
  803c96:	89 c8                	mov    %ecx,%eax
  803c98:	89 f2                	mov    %esi,%edx
  803c9a:	f7 f7                	div    %edi
  803c9c:	89 d0                	mov    %edx,%eax
  803c9e:	31 d2                	xor    %edx,%edx
  803ca0:	83 c4 1c             	add    $0x1c,%esp
  803ca3:	5b                   	pop    %ebx
  803ca4:	5e                   	pop    %esi
  803ca5:	5f                   	pop    %edi
  803ca6:	5d                   	pop    %ebp
  803ca7:	c3                   	ret    
  803ca8:	39 f0                	cmp    %esi,%eax
  803caa:	0f 87 ac 00 00 00    	ja     803d5c <__umoddi3+0xfc>
  803cb0:	0f bd e8             	bsr    %eax,%ebp
  803cb3:	83 f5 1f             	xor    $0x1f,%ebp
  803cb6:	0f 84 ac 00 00 00    	je     803d68 <__umoddi3+0x108>
  803cbc:	bf 20 00 00 00       	mov    $0x20,%edi
  803cc1:	29 ef                	sub    %ebp,%edi
  803cc3:	89 fe                	mov    %edi,%esi
  803cc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cc9:	89 e9                	mov    %ebp,%ecx
  803ccb:	d3 e0                	shl    %cl,%eax
  803ccd:	89 d7                	mov    %edx,%edi
  803ccf:	89 f1                	mov    %esi,%ecx
  803cd1:	d3 ef                	shr    %cl,%edi
  803cd3:	09 c7                	or     %eax,%edi
  803cd5:	89 e9                	mov    %ebp,%ecx
  803cd7:	d3 e2                	shl    %cl,%edx
  803cd9:	89 14 24             	mov    %edx,(%esp)
  803cdc:	89 d8                	mov    %ebx,%eax
  803cde:	d3 e0                	shl    %cl,%eax
  803ce0:	89 c2                	mov    %eax,%edx
  803ce2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ce6:	d3 e0                	shl    %cl,%eax
  803ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cec:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cf0:	89 f1                	mov    %esi,%ecx
  803cf2:	d3 e8                	shr    %cl,%eax
  803cf4:	09 d0                	or     %edx,%eax
  803cf6:	d3 eb                	shr    %cl,%ebx
  803cf8:	89 da                	mov    %ebx,%edx
  803cfa:	f7 f7                	div    %edi
  803cfc:	89 d3                	mov    %edx,%ebx
  803cfe:	f7 24 24             	mull   (%esp)
  803d01:	89 c6                	mov    %eax,%esi
  803d03:	89 d1                	mov    %edx,%ecx
  803d05:	39 d3                	cmp    %edx,%ebx
  803d07:	0f 82 87 00 00 00    	jb     803d94 <__umoddi3+0x134>
  803d0d:	0f 84 91 00 00 00    	je     803da4 <__umoddi3+0x144>
  803d13:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d17:	29 f2                	sub    %esi,%edx
  803d19:	19 cb                	sbb    %ecx,%ebx
  803d1b:	89 d8                	mov    %ebx,%eax
  803d1d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d21:	d3 e0                	shl    %cl,%eax
  803d23:	89 e9                	mov    %ebp,%ecx
  803d25:	d3 ea                	shr    %cl,%edx
  803d27:	09 d0                	or     %edx,%eax
  803d29:	89 e9                	mov    %ebp,%ecx
  803d2b:	d3 eb                	shr    %cl,%ebx
  803d2d:	89 da                	mov    %ebx,%edx
  803d2f:	83 c4 1c             	add    $0x1c,%esp
  803d32:	5b                   	pop    %ebx
  803d33:	5e                   	pop    %esi
  803d34:	5f                   	pop    %edi
  803d35:	5d                   	pop    %ebp
  803d36:	c3                   	ret    
  803d37:	90                   	nop
  803d38:	89 fd                	mov    %edi,%ebp
  803d3a:	85 ff                	test   %edi,%edi
  803d3c:	75 0b                	jne    803d49 <__umoddi3+0xe9>
  803d3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d43:	31 d2                	xor    %edx,%edx
  803d45:	f7 f7                	div    %edi
  803d47:	89 c5                	mov    %eax,%ebp
  803d49:	89 f0                	mov    %esi,%eax
  803d4b:	31 d2                	xor    %edx,%edx
  803d4d:	f7 f5                	div    %ebp
  803d4f:	89 c8                	mov    %ecx,%eax
  803d51:	f7 f5                	div    %ebp
  803d53:	89 d0                	mov    %edx,%eax
  803d55:	e9 44 ff ff ff       	jmp    803c9e <__umoddi3+0x3e>
  803d5a:	66 90                	xchg   %ax,%ax
  803d5c:	89 c8                	mov    %ecx,%eax
  803d5e:	89 f2                	mov    %esi,%edx
  803d60:	83 c4 1c             	add    $0x1c,%esp
  803d63:	5b                   	pop    %ebx
  803d64:	5e                   	pop    %esi
  803d65:	5f                   	pop    %edi
  803d66:	5d                   	pop    %ebp
  803d67:	c3                   	ret    
  803d68:	3b 04 24             	cmp    (%esp),%eax
  803d6b:	72 06                	jb     803d73 <__umoddi3+0x113>
  803d6d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d71:	77 0f                	ja     803d82 <__umoddi3+0x122>
  803d73:	89 f2                	mov    %esi,%edx
  803d75:	29 f9                	sub    %edi,%ecx
  803d77:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d7b:	89 14 24             	mov    %edx,(%esp)
  803d7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d82:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d86:	8b 14 24             	mov    (%esp),%edx
  803d89:	83 c4 1c             	add    $0x1c,%esp
  803d8c:	5b                   	pop    %ebx
  803d8d:	5e                   	pop    %esi
  803d8e:	5f                   	pop    %edi
  803d8f:	5d                   	pop    %ebp
  803d90:	c3                   	ret    
  803d91:	8d 76 00             	lea    0x0(%esi),%esi
  803d94:	2b 04 24             	sub    (%esp),%eax
  803d97:	19 fa                	sbb    %edi,%edx
  803d99:	89 d1                	mov    %edx,%ecx
  803d9b:	89 c6                	mov    %eax,%esi
  803d9d:	e9 71 ff ff ff       	jmp    803d13 <__umoddi3+0xb3>
  803da2:	66 90                	xchg   %ax,%ax
  803da4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803da8:	72 ea                	jb     803d94 <__umoddi3+0x134>
  803daa:	89 d9                	mov    %ebx,%ecx
  803dac:	e9 62 ff ff ff       	jmp    803d13 <__umoddi3+0xb3>
