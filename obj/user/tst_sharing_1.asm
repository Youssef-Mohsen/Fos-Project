
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
  800031:	e8 f7 03 00 00       	call   80042d <libmain>
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
  80005c:	68 e0 3d 80 00       	push   $0x803de0
  800061:	6a 13                	push   $0x13
  800063:	68 fc 3d 80 00       	push   $0x803dfc
  800068:	e8 ff 04 00 00       	call   80056c <_panic>
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
  800085:	68 14 3e 80 00       	push   $0x803e14
  80008a:	e8 9a 07 00 00       	call   800829 <cprintf>
  80008f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800092:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800099:	e8 1d 1b 00 00       	call   801bbb <sys_calculate_free_frames>
  80009e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000a1:	83 ec 04             	sub    $0x4,%esp
  8000a4:	6a 01                	push   $0x1
  8000a6:	68 00 10 00 00       	push   $0x1000
  8000ab:	68 50 3e 80 00       	push   $0x803e50
  8000b0:	e8 41 18 00 00       	call   8018f6 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (x != (uint32*)pagealloc_start) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  8000c1:	74 17                	je     8000da <_main+0xa2>
  8000c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 54 3e 80 00       	push   $0x803e54
  8000d2:	e8 52 07 00 00       	call   800829 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8000da:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8000e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000e4:	e8 d2 1a 00 00       	call   801bbb <sys_calculate_free_frames>
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
  80010f:	e8 a7 1a 00 00       	call   801bbb <sys_calculate_free_frames>
  800114:	29 c3                	sub    %eax,%ebx
  800116:	89 d8                	mov    %ebx,%eax
  800118:	83 ec 04             	sub    $0x4,%esp
  80011b:	ff 75 dc             	pushl  -0x24(%ebp)
  80011e:	50                   	push   %eax
  80011f:	68 c0 3e 80 00       	push   $0x803ec0
  800124:	e8 00 07 00 00       	call   800829 <cprintf>
  800129:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80012c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800130:	74 04                	je     800136 <_main+0xfe>
  800132:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  800136:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80013d:	e8 79 1a 00 00       	call   801bbb <sys_calculate_free_frames>
  800142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	6a 01                	push   $0x1
  80014a:	68 04 10 00 00       	push   $0x1004
  80014f:	68 58 3f 80 00       	push   $0x803f58
  800154:	e8 9d 17 00 00       	call   8018f6 <smalloc>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  80015f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800162:	05 00 10 00 00       	add    $0x1000,%eax
  800167:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80016a:	74 17                	je     800183 <_main+0x14b>
  80016c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 54 3e 80 00       	push   $0x803e54
  80017b:	e8 a9 06 00 00       	call   800829 <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2pages*/
  800183:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80018a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80018d:	e8 29 1a 00 00       	call   801bbb <sys_calculate_free_frames>
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
  8001b8:	e8 fe 19 00 00       	call   801bbb <sys_calculate_free_frames>
  8001bd:	29 c3                	sub    %eax,%ebx
  8001bf:	89 d8                	mov    %ebx,%eax
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c7:	50                   	push   %eax
  8001c8:	68 c0 3e 80 00       	push   $0x803ec0
  8001cd:	e8 57 06 00 00       	call   800829 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  8001d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8001d9:	74 04                	je     8001df <_main+0x1a7>
  8001db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  8001df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  8001e6:	e8 d0 19 00 00       	call   801bbb <sys_calculate_free_frames>
  8001eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		y = smalloc("y", 4, 1);
  8001ee:	83 ec 04             	sub    $0x4,%esp
  8001f1:	6a 01                	push   $0x1
  8001f3:	6a 04                	push   $0x4
  8001f5:	68 5a 3f 80 00       	push   $0x803f5a
  8001fa:	e8 f7 16 00 00       	call   8018f6 <smalloc>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {is_correct = 0; cprintf("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800208:	05 00 30 00 00       	add    $0x3000,%eax
  80020d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800210:	74 17                	je     800229 <_main+0x1f1>
  800212:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 54 3e 80 00       	push   $0x803e54
  800221:	e8 03 06 00 00       	call   800829 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1page*/
  800229:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800230:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800233:	e8 83 19 00 00       	call   801bbb <sys_calculate_free_frames>
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
  80025e:	e8 58 19 00 00       	call   801bbb <sys_calculate_free_frames>
  800263:	29 c3                	sub    %eax,%ebx
  800265:	89 d8                	mov    %ebx,%eax
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	ff 75 dc             	pushl  -0x24(%ebp)
  80026d:	50                   	push   %eax
  80026e:	68 c0 3e 80 00       	push   $0x803ec0
  800273:	e8 b1 05 00 00       	call   800829 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80027b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80027f:	74 04                	je     800285 <_main+0x24d>
  800281:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  800285:	83 ec 0c             	sub    $0xc,%esp
  800288:	68 5c 3f 80 00       	push   $0x803f5c
  80028d:	e8 97 05 00 00       	call   800829 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp

	is_correct = 1;
  800295:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP B: checking reading & writing... [40%]\n");
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	68 84 3f 80 00       	push   $0x803f84
  8002a4:	e8 80 05 00 00       	call   800829 <cprintf>
  8002a9:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  8002ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  8002b3:	eb 2d                	jmp    8002e2 <_main+0x2aa>
		{
			/*cprintf("I: %d\n",i);
			cprintf("X: %x\n",x);
			cprintf("x[i]: %x\n",x[i]);*/
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
			cprintf("x[i]: %x\n",x[i]);*/
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
		cprintf("80\n");
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	68 b1 3f 80 00       	push   $0x803fb1
  80031d:	e8 07 05 00 00       	call   800829 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp
		if( x[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  800325:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800328:	8b 00                	mov    (%eax),%eax
  80032a:	83 f8 ff             	cmp    $0xffffffff,%eax
  80032d:	74 17                	je     800346 <_main+0x30e>
  80032f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 b8 3f 80 00       	push   $0x803fb8
  80033e:	e8 e6 04 00 00       	call   800829 <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  800346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800349:	05 fc 0f 00 00       	add    $0xffc,%eax
  80034e:	8b 00                	mov    (%eax),%eax
  800350:	83 f8 ff             	cmp    $0xffffffff,%eax
  800353:	74 17                	je     80036c <_main+0x334>
  800355:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 b8 3f 80 00       	push   $0x803fb8
  800364:	e8 c0 04 00 00       	call   800829 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
		cprintf("83\n");
  80036c:	83 ec 0c             	sub    $0xc,%esp
  80036f:	68 e3 3f 80 00       	push   $0x803fe3
  800374:	e8 b0 04 00 00       	call   800829 <cprintf>
  800379:	83 c4 10             	add    $0x10,%esp
		if( y[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80037c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80037f:	8b 00                	mov    (%eax),%eax
  800381:	83 f8 ff             	cmp    $0xffffffff,%eax
  800384:	74 17                	je     80039d <_main+0x365>
  800386:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80038d:	83 ec 0c             	sub    $0xc,%esp
  800390:	68 b8 3f 80 00       	push   $0x803fb8
  800395:	e8 8f 04 00 00       	call   800829 <cprintf>
  80039a:	83 c4 10             	add    $0x10,%esp
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  80039d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003a0:	05 fc 0f 00 00       	add    $0xffc,%eax
  8003a5:	8b 00                	mov    (%eax),%eax
  8003a7:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003aa:	74 17                	je     8003c3 <_main+0x38b>
  8003ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	68 b8 3f 80 00       	push   $0x803fb8
  8003bb:	e8 69 04 00 00       	call   800829 <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c6:	8b 00                	mov    (%eax),%eax
  8003c8:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003cb:	74 17                	je     8003e4 <_main+0x3ac>
  8003cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d4:	83 ec 0c             	sub    $0xc,%esp
  8003d7:	68 b8 3f 80 00       	push   $0x803fb8
  8003dc:	e8 48 04 00 00       	call   800829 <cprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf("Reading/Writing of shared object is failed");}
  8003e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e7:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  8003ec:	8b 00                	mov    (%eax),%eax
  8003ee:	83 f8 ff             	cmp    $0xffffffff,%eax
  8003f1:	74 17                	je     80040a <_main+0x3d2>
  8003f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003fa:	83 ec 0c             	sub    $0xc,%esp
  8003fd:	68 b8 3f 80 00       	push   $0x803fb8
  800402:	e8 22 04 00 00       	call   800829 <cprintf>
  800407:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  80040a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80040e:	74 04                	je     800414 <_main+0x3dc>
		eval += 40 ;
  800410:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	cprintf("\n%~Test of Shared Variables [Create] [1] completed. Eval = %d%%\n\n", eval);
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	ff 75 f4             	pushl  -0xc(%ebp)
  80041a:	68 e8 3f 80 00       	push   $0x803fe8
  80041f:	e8 05 04 00 00       	call   800829 <cprintf>
  800424:	83 c4 10             	add    $0x10,%esp

	return;
  800427:	90                   	nop
}
  800428:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80042b:	c9                   	leave  
  80042c:	c3                   	ret    

0080042d <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800433:	e8 4c 19 00 00       	call   801d84 <sys_getenvindex>
  800438:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80043b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80043e:	89 d0                	mov    %edx,%eax
  800440:	c1 e0 03             	shl    $0x3,%eax
  800443:	01 d0                	add    %edx,%eax
  800445:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80044c:	01 c8                	add    %ecx,%eax
  80044e:	01 c0                	add    %eax,%eax
  800450:	01 d0                	add    %edx,%eax
  800452:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800459:	01 c8                	add    %ecx,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800462:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800467:	a1 20 50 80 00       	mov    0x805020,%eax
  80046c:	8a 40 20             	mov    0x20(%eax),%al
  80046f:	84 c0                	test   %al,%al
  800471:	74 0d                	je     800480 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800473:	a1 20 50 80 00       	mov    0x805020,%eax
  800478:	83 c0 20             	add    $0x20,%eax
  80047b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800480:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800484:	7e 0a                	jle    800490 <libmain+0x63>
		binaryname = argv[0];
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	8b 00                	mov    (%eax),%eax
  80048b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	ff 75 0c             	pushl  0xc(%ebp)
  800496:	ff 75 08             	pushl  0x8(%ebp)
  800499:	e8 9a fb ff ff       	call   800038 <_main>
  80049e:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8004a1:	e8 62 16 00 00       	call   801b08 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004a6:	83 ec 0c             	sub    $0xc,%esp
  8004a9:	68 44 40 80 00       	push   $0x804044
  8004ae:	e8 76 03 00 00       	call   800829 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8004bb:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8004c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c6:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	52                   	push   %edx
  8004d0:	50                   	push   %eax
  8004d1:	68 6c 40 80 00       	push   $0x80406c
  8004d6:	e8 4e 03 00 00       	call   800829 <cprintf>
  8004db:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004de:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e3:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8004e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ee:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8004f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f9:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8004ff:	51                   	push   %ecx
  800500:	52                   	push   %edx
  800501:	50                   	push   %eax
  800502:	68 94 40 80 00       	push   $0x804094
  800507:	e8 1d 03 00 00       	call   800829 <cprintf>
  80050c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80050f:	a1 20 50 80 00       	mov    0x805020,%eax
  800514:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	50                   	push   %eax
  80051e:	68 ec 40 80 00       	push   $0x8040ec
  800523:	e8 01 03 00 00       	call   800829 <cprintf>
  800528:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80052b:	83 ec 0c             	sub    $0xc,%esp
  80052e:	68 44 40 80 00       	push   $0x804044
  800533:	e8 f1 02 00 00       	call   800829 <cprintf>
  800538:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80053b:	e8 e2 15 00 00       	call   801b22 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800540:	e8 19 00 00 00       	call   80055e <exit>
}
  800545:	90                   	nop
  800546:	c9                   	leave  
  800547:	c3                   	ret    

00800548 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80054e:	83 ec 0c             	sub    $0xc,%esp
  800551:	6a 00                	push   $0x0
  800553:	e8 f8 17 00 00       	call   801d50 <sys_destroy_env>
  800558:	83 c4 10             	add    $0x10,%esp
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <exit>:

void
exit(void)
{
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800564:	e8 4d 18 00 00       	call   801db6 <sys_exit_env>
}
  800569:	90                   	nop
  80056a:	c9                   	leave  
  80056b:	c3                   	ret    

0080056c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800572:	8d 45 10             	lea    0x10(%ebp),%eax
  800575:	83 c0 04             	add    $0x4,%eax
  800578:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80057b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800580:	85 c0                	test   %eax,%eax
  800582:	74 16                	je     80059a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800584:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	50                   	push   %eax
  80058d:	68 00 41 80 00       	push   $0x804100
  800592:	e8 92 02 00 00       	call   800829 <cprintf>
  800597:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80059a:	a1 00 50 80 00       	mov    0x805000,%eax
  80059f:	ff 75 0c             	pushl  0xc(%ebp)
  8005a2:	ff 75 08             	pushl  0x8(%ebp)
  8005a5:	50                   	push   %eax
  8005a6:	68 05 41 80 00       	push   $0x804105
  8005ab:	e8 79 02 00 00       	call   800829 <cprintf>
  8005b0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b6:	83 ec 08             	sub    $0x8,%esp
  8005b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bc:	50                   	push   %eax
  8005bd:	e8 fc 01 00 00       	call   8007be <vcprintf>
  8005c2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	6a 00                	push   $0x0
  8005ca:	68 21 41 80 00       	push   $0x804121
  8005cf:	e8 ea 01 00 00       	call   8007be <vcprintf>
  8005d4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005d7:	e8 82 ff ff ff       	call   80055e <exit>

	// should not return here
	while (1) ;
  8005dc:	eb fe                	jmp    8005dc <_panic+0x70>

008005de <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005de:	55                   	push   %ebp
  8005df:	89 e5                	mov    %esp,%ebp
  8005e1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f2:	39 c2                	cmp    %eax,%edx
  8005f4:	74 14                	je     80060a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005f6:	83 ec 04             	sub    $0x4,%esp
  8005f9:	68 24 41 80 00       	push   $0x804124
  8005fe:	6a 26                	push   $0x26
  800600:	68 70 41 80 00       	push   $0x804170
  800605:	e8 62 ff ff ff       	call   80056c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80060a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800611:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800618:	e9 c5 00 00 00       	jmp    8006e2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80061d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800620:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	01 d0                	add    %edx,%eax
  80062c:	8b 00                	mov    (%eax),%eax
  80062e:	85 c0                	test   %eax,%eax
  800630:	75 08                	jne    80063a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800632:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800635:	e9 a5 00 00 00       	jmp    8006df <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80063a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800641:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800648:	eb 69                	jmp    8006b3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80064a:	a1 20 50 80 00       	mov    0x805020,%eax
  80064f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800655:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800658:	89 d0                	mov    %edx,%eax
  80065a:	01 c0                	add    %eax,%eax
  80065c:	01 d0                	add    %edx,%eax
  80065e:	c1 e0 03             	shl    $0x3,%eax
  800661:	01 c8                	add    %ecx,%eax
  800663:	8a 40 04             	mov    0x4(%eax),%al
  800666:	84 c0                	test   %al,%al
  800668:	75 46                	jne    8006b0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80066a:	a1 20 50 80 00       	mov    0x805020,%eax
  80066f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800675:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800678:	89 d0                	mov    %edx,%eax
  80067a:	01 c0                	add    %eax,%eax
  80067c:	01 d0                	add    %edx,%eax
  80067e:	c1 e0 03             	shl    $0x3,%eax
  800681:	01 c8                	add    %ecx,%eax
  800683:	8b 00                	mov    (%eax),%eax
  800685:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800688:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80068b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800690:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800695:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	01 c8                	add    %ecx,%eax
  8006a1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006a3:	39 c2                	cmp    %eax,%edx
  8006a5:	75 09                	jne    8006b0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006a7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006ae:	eb 15                	jmp    8006c5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b0:	ff 45 e8             	incl   -0x18(%ebp)
  8006b3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	77 85                	ja     80064a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006c9:	75 14                	jne    8006df <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006cb:	83 ec 04             	sub    $0x4,%esp
  8006ce:	68 7c 41 80 00       	push   $0x80417c
  8006d3:	6a 3a                	push   $0x3a
  8006d5:	68 70 41 80 00       	push   $0x804170
  8006da:	e8 8d fe ff ff       	call   80056c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006df:	ff 45 f0             	incl   -0x10(%ebp)
  8006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006e8:	0f 8c 2f ff ff ff    	jl     80061d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006fc:	eb 26                	jmp    800724 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800703:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800709:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80070c:	89 d0                	mov    %edx,%eax
  80070e:	01 c0                	add    %eax,%eax
  800710:	01 d0                	add    %edx,%eax
  800712:	c1 e0 03             	shl    $0x3,%eax
  800715:	01 c8                	add    %ecx,%eax
  800717:	8a 40 04             	mov    0x4(%eax),%al
  80071a:	3c 01                	cmp    $0x1,%al
  80071c:	75 03                	jne    800721 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80071e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800721:	ff 45 e0             	incl   -0x20(%ebp)
  800724:	a1 20 50 80 00       	mov    0x805020,%eax
  800729:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80072f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800732:	39 c2                	cmp    %eax,%edx
  800734:	77 c8                	ja     8006fe <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800739:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80073c:	74 14                	je     800752 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80073e:	83 ec 04             	sub    $0x4,%esp
  800741:	68 d0 41 80 00       	push   $0x8041d0
  800746:	6a 44                	push   $0x44
  800748:	68 70 41 80 00       	push   $0x804170
  80074d:	e8 1a fe ff ff       	call   80056c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800752:	90                   	nop
  800753:	c9                   	leave  
  800754:	c3                   	ret    

00800755 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
  800758:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	8d 48 01             	lea    0x1(%eax),%ecx
  800763:	8b 55 0c             	mov    0xc(%ebp),%edx
  800766:	89 0a                	mov    %ecx,(%edx)
  800768:	8b 55 08             	mov    0x8(%ebp),%edx
  80076b:	88 d1                	mov    %dl,%cl
  80076d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800770:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800774:	8b 45 0c             	mov    0xc(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	3d ff 00 00 00       	cmp    $0xff,%eax
  80077e:	75 2c                	jne    8007ac <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800780:	a0 28 50 80 00       	mov    0x805028,%al
  800785:	0f b6 c0             	movzbl %al,%eax
  800788:	8b 55 0c             	mov    0xc(%ebp),%edx
  80078b:	8b 12                	mov    (%edx),%edx
  80078d:	89 d1                	mov    %edx,%ecx
  80078f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800792:	83 c2 08             	add    $0x8,%edx
  800795:	83 ec 04             	sub    $0x4,%esp
  800798:	50                   	push   %eax
  800799:	51                   	push   %ecx
  80079a:	52                   	push   %edx
  80079b:	e8 26 13 00 00       	call   801ac6 <sys_cputs>
  8007a0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007af:	8b 40 04             	mov    0x4(%eax),%eax
  8007b2:	8d 50 01             	lea    0x1(%eax),%edx
  8007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007bb:	90                   	nop
  8007bc:	c9                   	leave  
  8007bd:	c3                   	ret    

008007be <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007be:	55                   	push   %ebp
  8007bf:	89 e5                	mov    %esp,%ebp
  8007c1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007ce:	00 00 00 
	b.cnt = 0;
  8007d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007d8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007db:	ff 75 0c             	pushl  0xc(%ebp)
  8007de:	ff 75 08             	pushl  0x8(%ebp)
  8007e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e7:	50                   	push   %eax
  8007e8:	68 55 07 80 00       	push   $0x800755
  8007ed:	e8 11 02 00 00       	call   800a03 <vprintfmt>
  8007f2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007f5:	a0 28 50 80 00       	mov    0x805028,%al
  8007fa:	0f b6 c0             	movzbl %al,%eax
  8007fd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	50                   	push   %eax
  800807:	52                   	push   %edx
  800808:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80080e:	83 c0 08             	add    $0x8,%eax
  800811:	50                   	push   %eax
  800812:	e8 af 12 00 00       	call   801ac6 <sys_cputs>
  800817:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80081a:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800821:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800827:	c9                   	leave  
  800828:	c3                   	ret    

00800829 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
  80082c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80082f:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800836:	8d 45 0c             	lea    0xc(%ebp),%eax
  800839:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 f4             	pushl  -0xc(%ebp)
  800845:	50                   	push   %eax
  800846:	e8 73 ff ff ff       	call   8007be <vcprintf>
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800851:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800854:	c9                   	leave  
  800855:	c3                   	ret    

00800856 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80085c:	e8 a7 12 00 00       	call   801b08 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800861:	8d 45 0c             	lea    0xc(%ebp),%eax
  800864:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 f4             	pushl  -0xc(%ebp)
  800870:	50                   	push   %eax
  800871:	e8 48 ff ff ff       	call   8007be <vcprintf>
  800876:	83 c4 10             	add    $0x10,%esp
  800879:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80087c:	e8 a1 12 00 00       	call   801b22 <sys_unlock_cons>
	return cnt;
  800881:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800884:	c9                   	leave  
  800885:	c3                   	ret    

00800886 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	53                   	push   %ebx
  80088a:	83 ec 14             	sub    $0x14,%esp
  80088d:	8b 45 10             	mov    0x10(%ebp),%eax
  800890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800893:	8b 45 14             	mov    0x14(%ebp),%eax
  800896:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800899:	8b 45 18             	mov    0x18(%ebp),%eax
  80089c:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008a4:	77 55                	ja     8008fb <printnum+0x75>
  8008a6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008a9:	72 05                	jb     8008b0 <printnum+0x2a>
  8008ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008ae:	77 4b                	ja     8008fb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008b0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008b3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008b6:	8b 45 18             	mov    0x18(%ebp),%eax
  8008b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008be:	52                   	push   %edx
  8008bf:	50                   	push   %eax
  8008c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8008c6:	e8 95 32 00 00       	call   803b60 <__udivdi3>
  8008cb:	83 c4 10             	add    $0x10,%esp
  8008ce:	83 ec 04             	sub    $0x4,%esp
  8008d1:	ff 75 20             	pushl  0x20(%ebp)
  8008d4:	53                   	push   %ebx
  8008d5:	ff 75 18             	pushl  0x18(%ebp)
  8008d8:	52                   	push   %edx
  8008d9:	50                   	push   %eax
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	ff 75 08             	pushl  0x8(%ebp)
  8008e0:	e8 a1 ff ff ff       	call   800886 <printnum>
  8008e5:	83 c4 20             	add    $0x20,%esp
  8008e8:	eb 1a                	jmp    800904 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	ff 75 0c             	pushl  0xc(%ebp)
  8008f0:	ff 75 20             	pushl  0x20(%ebp)
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	ff d0                	call   *%eax
  8008f8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008fb:	ff 4d 1c             	decl   0x1c(%ebp)
  8008fe:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800902:	7f e6                	jg     8008ea <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800904:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800907:	bb 00 00 00 00       	mov    $0x0,%ebx
  80090c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800912:	53                   	push   %ebx
  800913:	51                   	push   %ecx
  800914:	52                   	push   %edx
  800915:	50                   	push   %eax
  800916:	e8 55 33 00 00       	call   803c70 <__umoddi3>
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	05 34 44 80 00       	add    $0x804434,%eax
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be c0             	movsbl %al,%eax
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	50                   	push   %eax
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	ff d0                	call   *%eax
  800934:	83 c4 10             	add    $0x10,%esp
}
  800937:	90                   	nop
  800938:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093b:	c9                   	leave  
  80093c:	c3                   	ret    

0080093d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80093d:	55                   	push   %ebp
  80093e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800940:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800944:	7e 1c                	jle    800962 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 00                	mov    (%eax),%eax
  80094b:	8d 50 08             	lea    0x8(%eax),%edx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 10                	mov    %edx,(%eax)
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	83 e8 08             	sub    $0x8,%eax
  80095b:	8b 50 04             	mov    0x4(%eax),%edx
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	eb 40                	jmp    8009a2 <getuint+0x65>
	else if (lflag)
  800962:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800966:	74 1e                	je     800986 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	8d 50 04             	lea    0x4(%eax),%edx
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	89 10                	mov    %edx,(%eax)
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	83 e8 04             	sub    $0x4,%eax
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	ba 00 00 00 00       	mov    $0x0,%edx
  800984:	eb 1c                	jmp    8009a2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	8d 50 04             	lea    0x4(%eax),%edx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	89 10                	mov    %edx,(%eax)
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	83 e8 04             	sub    $0x4,%eax
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009a7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009ab:	7e 1c                	jle    8009c9 <getint+0x25>
		return va_arg(*ap, long long);
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	8d 50 08             	lea    0x8(%eax),%edx
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	89 10                	mov    %edx,(%eax)
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	8b 00                	mov    (%eax),%eax
  8009bf:	83 e8 08             	sub    $0x8,%eax
  8009c2:	8b 50 04             	mov    0x4(%eax),%edx
  8009c5:	8b 00                	mov    (%eax),%eax
  8009c7:	eb 38                	jmp    800a01 <getint+0x5d>
	else if (lflag)
  8009c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009cd:	74 1a                	je     8009e9 <getint+0x45>
		return va_arg(*ap, long);
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	8d 50 04             	lea    0x4(%eax),%edx
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	89 10                	mov    %edx,(%eax)
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	8b 00                	mov    (%eax),%eax
  8009e1:	83 e8 04             	sub    $0x4,%eax
  8009e4:	8b 00                	mov    (%eax),%eax
  8009e6:	99                   	cltd   
  8009e7:	eb 18                	jmp    800a01 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	8d 50 04             	lea    0x4(%eax),%edx
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	89 10                	mov    %edx,(%eax)
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	83 e8 04             	sub    $0x4,%eax
  8009fe:	8b 00                	mov    (%eax),%eax
  800a00:	99                   	cltd   
}
  800a01:	5d                   	pop    %ebp
  800a02:	c3                   	ret    

00800a03 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	56                   	push   %esi
  800a07:	53                   	push   %ebx
  800a08:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a0b:	eb 17                	jmp    800a24 <vprintfmt+0x21>
			if (ch == '\0')
  800a0d:	85 db                	test   %ebx,%ebx
  800a0f:	0f 84 c1 03 00 00    	je     800dd6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	53                   	push   %ebx
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	ff d0                	call   *%eax
  800a21:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a24:	8b 45 10             	mov    0x10(%ebp),%eax
  800a27:	8d 50 01             	lea    0x1(%eax),%edx
  800a2a:	89 55 10             	mov    %edx,0x10(%ebp)
  800a2d:	8a 00                	mov    (%eax),%al
  800a2f:	0f b6 d8             	movzbl %al,%ebx
  800a32:	83 fb 25             	cmp    $0x25,%ebx
  800a35:	75 d6                	jne    800a0d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a37:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a3b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a42:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a49:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a50:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a57:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5a:	8d 50 01             	lea    0x1(%eax),%edx
  800a5d:	89 55 10             	mov    %edx,0x10(%ebp)
  800a60:	8a 00                	mov    (%eax),%al
  800a62:	0f b6 d8             	movzbl %al,%ebx
  800a65:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a68:	83 f8 5b             	cmp    $0x5b,%eax
  800a6b:	0f 87 3d 03 00 00    	ja     800dae <vprintfmt+0x3ab>
  800a71:	8b 04 85 58 44 80 00 	mov    0x804458(,%eax,4),%eax
  800a78:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a7a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a7e:	eb d7                	jmp    800a57 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a80:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a84:	eb d1                	jmp    800a57 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a86:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a90:	89 d0                	mov    %edx,%eax
  800a92:	c1 e0 02             	shl    $0x2,%eax
  800a95:	01 d0                	add    %edx,%eax
  800a97:	01 c0                	add    %eax,%eax
  800a99:	01 d8                	add    %ebx,%eax
  800a9b:	83 e8 30             	sub    $0x30,%eax
  800a9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800aa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa4:	8a 00                	mov    (%eax),%al
  800aa6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aa9:	83 fb 2f             	cmp    $0x2f,%ebx
  800aac:	7e 3e                	jle    800aec <vprintfmt+0xe9>
  800aae:	83 fb 39             	cmp    $0x39,%ebx
  800ab1:	7f 39                	jg     800aec <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ab3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ab6:	eb d5                	jmp    800a8d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ab8:	8b 45 14             	mov    0x14(%ebp),%eax
  800abb:	83 c0 04             	add    $0x4,%eax
  800abe:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac4:	83 e8 04             	sub    $0x4,%eax
  800ac7:	8b 00                	mov    (%eax),%eax
  800ac9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800acc:	eb 1f                	jmp    800aed <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ace:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad2:	79 83                	jns    800a57 <vprintfmt+0x54>
				width = 0;
  800ad4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800adb:	e9 77 ff ff ff       	jmp    800a57 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ae0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ae7:	e9 6b ff ff ff       	jmp    800a57 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aec:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af1:	0f 89 60 ff ff ff    	jns    800a57 <vprintfmt+0x54>
				width = precision, precision = -1;
  800af7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800afd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b04:	e9 4e ff ff ff       	jmp    800a57 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b09:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b0c:	e9 46 ff ff ff       	jmp    800a57 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b11:	8b 45 14             	mov    0x14(%ebp),%eax
  800b14:	83 c0 04             	add    $0x4,%eax
  800b17:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1d:	83 e8 04             	sub    $0x4,%eax
  800b20:	8b 00                	mov    (%eax),%eax
  800b22:	83 ec 08             	sub    $0x8,%esp
  800b25:	ff 75 0c             	pushl  0xc(%ebp)
  800b28:	50                   	push   %eax
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	ff d0                	call   *%eax
  800b2e:	83 c4 10             	add    $0x10,%esp
			break;
  800b31:	e9 9b 02 00 00       	jmp    800dd1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b36:	8b 45 14             	mov    0x14(%ebp),%eax
  800b39:	83 c0 04             	add    $0x4,%eax
  800b3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b42:	83 e8 04             	sub    $0x4,%eax
  800b45:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b47:	85 db                	test   %ebx,%ebx
  800b49:	79 02                	jns    800b4d <vprintfmt+0x14a>
				err = -err;
  800b4b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b4d:	83 fb 64             	cmp    $0x64,%ebx
  800b50:	7f 0b                	jg     800b5d <vprintfmt+0x15a>
  800b52:	8b 34 9d a0 42 80 00 	mov    0x8042a0(,%ebx,4),%esi
  800b59:	85 f6                	test   %esi,%esi
  800b5b:	75 19                	jne    800b76 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b5d:	53                   	push   %ebx
  800b5e:	68 45 44 80 00       	push   $0x804445
  800b63:	ff 75 0c             	pushl  0xc(%ebp)
  800b66:	ff 75 08             	pushl  0x8(%ebp)
  800b69:	e8 70 02 00 00       	call   800dde <printfmt>
  800b6e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b71:	e9 5b 02 00 00       	jmp    800dd1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b76:	56                   	push   %esi
  800b77:	68 4e 44 80 00       	push   $0x80444e
  800b7c:	ff 75 0c             	pushl  0xc(%ebp)
  800b7f:	ff 75 08             	pushl  0x8(%ebp)
  800b82:	e8 57 02 00 00       	call   800dde <printfmt>
  800b87:	83 c4 10             	add    $0x10,%esp
			break;
  800b8a:	e9 42 02 00 00       	jmp    800dd1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b92:	83 c0 04             	add    $0x4,%eax
  800b95:	89 45 14             	mov    %eax,0x14(%ebp)
  800b98:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9b:	83 e8 04             	sub    $0x4,%eax
  800b9e:	8b 30                	mov    (%eax),%esi
  800ba0:	85 f6                	test   %esi,%esi
  800ba2:	75 05                	jne    800ba9 <vprintfmt+0x1a6>
				p = "(null)";
  800ba4:	be 51 44 80 00       	mov    $0x804451,%esi
			if (width > 0 && padc != '-')
  800ba9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bad:	7e 6d                	jle    800c1c <vprintfmt+0x219>
  800baf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bb3:	74 67                	je     800c1c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	50                   	push   %eax
  800bbc:	56                   	push   %esi
  800bbd:	e8 1e 03 00 00       	call   800ee0 <strnlen>
  800bc2:	83 c4 10             	add    $0x10,%esp
  800bc5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bc8:	eb 16                	jmp    800be0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bca:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	50                   	push   %eax
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	ff d0                	call   *%eax
  800bda:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bdd:	ff 4d e4             	decl   -0x1c(%ebp)
  800be0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be4:	7f e4                	jg     800bca <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be6:	eb 34                	jmp    800c1c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800be8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bec:	74 1c                	je     800c0a <vprintfmt+0x207>
  800bee:	83 fb 1f             	cmp    $0x1f,%ebx
  800bf1:	7e 05                	jle    800bf8 <vprintfmt+0x1f5>
  800bf3:	83 fb 7e             	cmp    $0x7e,%ebx
  800bf6:	7e 12                	jle    800c0a <vprintfmt+0x207>
					putch('?', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 3f                	push   $0x3f
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	eb 0f                	jmp    800c19 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	53                   	push   %ebx
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	ff d0                	call   *%eax
  800c16:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c19:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1c:	89 f0                	mov    %esi,%eax
  800c1e:	8d 70 01             	lea    0x1(%eax),%esi
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	0f be d8             	movsbl %al,%ebx
  800c26:	85 db                	test   %ebx,%ebx
  800c28:	74 24                	je     800c4e <vprintfmt+0x24b>
  800c2a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c2e:	78 b8                	js     800be8 <vprintfmt+0x1e5>
  800c30:	ff 4d e0             	decl   -0x20(%ebp)
  800c33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c37:	79 af                	jns    800be8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c39:	eb 13                	jmp    800c4e <vprintfmt+0x24b>
				putch(' ', putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	6a 20                	push   $0x20
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	ff d0                	call   *%eax
  800c48:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c4b:	ff 4d e4             	decl   -0x1c(%ebp)
  800c4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c52:	7f e7                	jg     800c3b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c54:	e9 78 01 00 00       	jmp    800dd1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c5f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c62:	50                   	push   %eax
  800c63:	e8 3c fd ff ff       	call   8009a4 <getint>
  800c68:	83 c4 10             	add    $0x10,%esp
  800c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c77:	85 d2                	test   %edx,%edx
  800c79:	79 23                	jns    800c9e <vprintfmt+0x29b>
				putch('-', putdat);
  800c7b:	83 ec 08             	sub    $0x8,%esp
  800c7e:	ff 75 0c             	pushl  0xc(%ebp)
  800c81:	6a 2d                	push   $0x2d
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c91:	f7 d8                	neg    %eax
  800c93:	83 d2 00             	adc    $0x0,%edx
  800c96:	f7 da                	neg    %edx
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c9e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ca5:	e9 bc 00 00 00       	jmp    800d66 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800caa:	83 ec 08             	sub    $0x8,%esp
  800cad:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb0:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb3:	50                   	push   %eax
  800cb4:	e8 84 fc ff ff       	call   80093d <getuint>
  800cb9:	83 c4 10             	add    $0x10,%esp
  800cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cc2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cc9:	e9 98 00 00 00       	jmp    800d66 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	6a 58                	push   $0x58
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cde:	83 ec 08             	sub    $0x8,%esp
  800ce1:	ff 75 0c             	pushl  0xc(%ebp)
  800ce4:	6a 58                	push   $0x58
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	ff d0                	call   *%eax
  800ceb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cee:	83 ec 08             	sub    $0x8,%esp
  800cf1:	ff 75 0c             	pushl  0xc(%ebp)
  800cf4:	6a 58                	push   $0x58
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	ff d0                	call   *%eax
  800cfb:	83 c4 10             	add    $0x10,%esp
			break;
  800cfe:	e9 ce 00 00 00       	jmp    800dd1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	ff 75 0c             	pushl  0xc(%ebp)
  800d09:	6a 30                	push   $0x30
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	ff d0                	call   *%eax
  800d10:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d13:	83 ec 08             	sub    $0x8,%esp
  800d16:	ff 75 0c             	pushl  0xc(%ebp)
  800d19:	6a 78                	push   $0x78
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	ff d0                	call   *%eax
  800d20:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d23:	8b 45 14             	mov    0x14(%ebp),%eax
  800d26:	83 c0 04             	add    $0x4,%eax
  800d29:	89 45 14             	mov    %eax,0x14(%ebp)
  800d2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2f:	83 e8 04             	sub    $0x4,%eax
  800d32:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d3e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d45:	eb 1f                	jmp    800d66 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d47:	83 ec 08             	sub    $0x8,%esp
  800d4a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d4d:	8d 45 14             	lea    0x14(%ebp),%eax
  800d50:	50                   	push   %eax
  800d51:	e8 e7 fb ff ff       	call   80093d <getuint>
  800d56:	83 c4 10             	add    $0x10,%esp
  800d59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d5c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d5f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d66:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d6d:	83 ec 04             	sub    $0x4,%esp
  800d70:	52                   	push   %edx
  800d71:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d74:	50                   	push   %eax
  800d75:	ff 75 f4             	pushl  -0xc(%ebp)
  800d78:	ff 75 f0             	pushl  -0x10(%ebp)
  800d7b:	ff 75 0c             	pushl  0xc(%ebp)
  800d7e:	ff 75 08             	pushl  0x8(%ebp)
  800d81:	e8 00 fb ff ff       	call   800886 <printnum>
  800d86:	83 c4 20             	add    $0x20,%esp
			break;
  800d89:	eb 46                	jmp    800dd1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d8b:	83 ec 08             	sub    $0x8,%esp
  800d8e:	ff 75 0c             	pushl  0xc(%ebp)
  800d91:	53                   	push   %ebx
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	ff d0                	call   *%eax
  800d97:	83 c4 10             	add    $0x10,%esp
			break;
  800d9a:	eb 35                	jmp    800dd1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d9c:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800da3:	eb 2c                	jmp    800dd1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800da5:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800dac:	eb 23                	jmp    800dd1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dae:	83 ec 08             	sub    $0x8,%esp
  800db1:	ff 75 0c             	pushl  0xc(%ebp)
  800db4:	6a 25                	push   $0x25
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	ff d0                	call   *%eax
  800dbb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dbe:	ff 4d 10             	decl   0x10(%ebp)
  800dc1:	eb 03                	jmp    800dc6 <vprintfmt+0x3c3>
  800dc3:	ff 4d 10             	decl   0x10(%ebp)
  800dc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc9:	48                   	dec    %eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	3c 25                	cmp    $0x25,%al
  800dce:	75 f3                	jne    800dc3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800dd0:	90                   	nop
		}
	}
  800dd1:	e9 35 fc ff ff       	jmp    800a0b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dd6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    

00800dde <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800de4:	8d 45 10             	lea    0x10(%ebp),%eax
  800de7:	83 c0 04             	add    $0x4,%eax
  800dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	ff 75 f4             	pushl  -0xc(%ebp)
  800df3:	50                   	push   %eax
  800df4:	ff 75 0c             	pushl  0xc(%ebp)
  800df7:	ff 75 08             	pushl  0x8(%ebp)
  800dfa:	e8 04 fc ff ff       	call   800a03 <vprintfmt>
  800dff:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e02:	90                   	nop
  800e03:	c9                   	leave  
  800e04:	c3                   	ret    

00800e05 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0b:	8b 40 08             	mov    0x8(%eax),%eax
  800e0e:	8d 50 01             	lea    0x1(%eax),%edx
  800e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e14:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	8b 10                	mov    (%eax),%edx
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	8b 40 04             	mov    0x4(%eax),%eax
  800e22:	39 c2                	cmp    %eax,%edx
  800e24:	73 12                	jae    800e38 <sprintputch+0x33>
		*b->buf++ = ch;
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	8d 48 01             	lea    0x1(%eax),%ecx
  800e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e31:	89 0a                	mov    %ecx,(%edx)
  800e33:	8b 55 08             	mov    0x8(%ebp),%edx
  800e36:	88 10                	mov    %dl,(%eax)
}
  800e38:	90                   	nop
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    

00800e3b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	01 d0                	add    %edx,%eax
  800e52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e60:	74 06                	je     800e68 <vsnprintf+0x2d>
  800e62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e66:	7f 07                	jg     800e6f <vsnprintf+0x34>
		return -E_INVAL;
  800e68:	b8 03 00 00 00       	mov    $0x3,%eax
  800e6d:	eb 20                	jmp    800e8f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e6f:	ff 75 14             	pushl  0x14(%ebp)
  800e72:	ff 75 10             	pushl  0x10(%ebp)
  800e75:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e78:	50                   	push   %eax
  800e79:	68 05 0e 80 00       	push   $0x800e05
  800e7e:	e8 80 fb ff ff       	call   800a03 <vprintfmt>
  800e83:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e89:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e8f:	c9                   	leave  
  800e90:	c3                   	ret    

00800e91 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e91:	55                   	push   %ebp
  800e92:	89 e5                	mov    %esp,%ebp
  800e94:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e97:	8d 45 10             	lea    0x10(%ebp),%eax
  800e9a:	83 c0 04             	add    $0x4,%eax
  800e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea6:	50                   	push   %eax
  800ea7:	ff 75 0c             	pushl  0xc(%ebp)
  800eaa:	ff 75 08             	pushl  0x8(%ebp)
  800ead:	e8 89 ff ff ff       	call   800e3b <vsnprintf>
  800eb2:	83 c4 10             	add    $0x10,%esp
  800eb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ebb:	c9                   	leave  
  800ebc:	c3                   	ret    

00800ebd <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ec3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eca:	eb 06                	jmp    800ed2 <strlen+0x15>
		n++;
  800ecc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ecf:	ff 45 08             	incl   0x8(%ebp)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	84 c0                	test   %al,%al
  800ed9:	75 f1                	jne    800ecc <strlen+0xf>
		n++;
	return n;
  800edb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ee6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eed:	eb 09                	jmp    800ef8 <strnlen+0x18>
		n++;
  800eef:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ef2:	ff 45 08             	incl   0x8(%ebp)
  800ef5:	ff 4d 0c             	decl   0xc(%ebp)
  800ef8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800efc:	74 09                	je     800f07 <strnlen+0x27>
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	84 c0                	test   %al,%al
  800f05:	75 e8                	jne    800eef <strnlen+0xf>
		n++;
	return n;
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f0a:	c9                   	leave  
  800f0b:	c3                   	ret    

00800f0c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f18:	90                   	nop
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8d 50 01             	lea    0x1(%eax),%edx
  800f1f:	89 55 08             	mov    %edx,0x8(%ebp)
  800f22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f28:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f2b:	8a 12                	mov    (%edx),%dl
  800f2d:	88 10                	mov    %dl,(%eax)
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	84 c0                	test   %al,%al
  800f33:	75 e4                	jne    800f19 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f38:	c9                   	leave  
  800f39:	c3                   	ret    

00800f3a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f4d:	eb 1f                	jmp    800f6e <strncpy+0x34>
		*dst++ = *src;
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8d 50 01             	lea    0x1(%eax),%edx
  800f55:	89 55 08             	mov    %edx,0x8(%ebp)
  800f58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5b:	8a 12                	mov    (%edx),%dl
  800f5d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	84 c0                	test   %al,%al
  800f66:	74 03                	je     800f6b <strncpy+0x31>
			src++;
  800f68:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f6b:	ff 45 fc             	incl   -0x4(%ebp)
  800f6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f71:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f74:	72 d9                	jb     800f4f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f79:	c9                   	leave  
  800f7a:	c3                   	ret    

00800f7b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8b:	74 30                	je     800fbd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f8d:	eb 16                	jmp    800fa5 <strlcpy+0x2a>
			*dst++ = *src++;
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8d 50 01             	lea    0x1(%eax),%edx
  800f95:	89 55 08             	mov    %edx,0x8(%ebp)
  800f98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f9e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fa1:	8a 12                	mov    (%edx),%dl
  800fa3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fa5:	ff 4d 10             	decl   0x10(%ebp)
  800fa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fac:	74 09                	je     800fb7 <strlcpy+0x3c>
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	84 c0                	test   %al,%al
  800fb5:	75 d8                	jne    800f8f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc3:	29 c2                	sub    %eax,%edx
  800fc5:	89 d0                	mov    %edx,%eax
}
  800fc7:	c9                   	leave  
  800fc8:	c3                   	ret    

00800fc9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fcc:	eb 06                	jmp    800fd4 <strcmp+0xb>
		p++, q++;
  800fce:	ff 45 08             	incl   0x8(%ebp)
  800fd1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	84 c0                	test   %al,%al
  800fdb:	74 0e                	je     800feb <strcmp+0x22>
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	8a 10                	mov    (%eax),%dl
  800fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	38 c2                	cmp    %al,%dl
  800fe9:	74 e3                	je     800fce <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	0f b6 d0             	movzbl %al,%edx
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	0f b6 c0             	movzbl %al,%eax
  800ffb:	29 c2                	sub    %eax,%edx
  800ffd:	89 d0                	mov    %edx,%eax
}
  800fff:	5d                   	pop    %ebp
  801000:	c3                   	ret    

00801001 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801004:	eb 09                	jmp    80100f <strncmp+0xe>
		n--, p++, q++;
  801006:	ff 4d 10             	decl   0x10(%ebp)
  801009:	ff 45 08             	incl   0x8(%ebp)
  80100c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80100f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801013:	74 17                	je     80102c <strncmp+0x2b>
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	84 c0                	test   %al,%al
  80101c:	74 0e                	je     80102c <strncmp+0x2b>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 10                	mov    (%eax),%dl
  801023:	8b 45 0c             	mov    0xc(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	38 c2                	cmp    %al,%dl
  80102a:	74 da                	je     801006 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80102c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801030:	75 07                	jne    801039 <strncmp+0x38>
		return 0;
  801032:	b8 00 00 00 00       	mov    $0x0,%eax
  801037:	eb 14                	jmp    80104d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	0f b6 d0             	movzbl %al,%edx
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	0f b6 c0             	movzbl %al,%eax
  801049:	29 c2                	sub    %eax,%edx
  80104b:	89 d0                	mov    %edx,%eax
}
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 04             	sub    $0x4,%esp
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80105b:	eb 12                	jmp    80106f <strchr+0x20>
		if (*s == c)
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801065:	75 05                	jne    80106c <strchr+0x1d>
			return (char *) s;
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	eb 11                	jmp    80107d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80106c:	ff 45 08             	incl   0x8(%ebp)
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	8a 00                	mov    (%eax),%al
  801074:	84 c0                	test   %al,%al
  801076:	75 e5                	jne    80105d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801078:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80107d:	c9                   	leave  
  80107e:	c3                   	ret    

0080107f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 04             	sub    $0x4,%esp
  801085:	8b 45 0c             	mov    0xc(%ebp),%eax
  801088:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80108b:	eb 0d                	jmp    80109a <strfind+0x1b>
		if (*s == c)
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801095:	74 0e                	je     8010a5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801097:	ff 45 08             	incl   0x8(%ebp)
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	84 c0                	test   %al,%al
  8010a1:	75 ea                	jne    80108d <strfind+0xe>
  8010a3:	eb 01                	jmp    8010a6 <strfind+0x27>
		if (*s == c)
			break;
  8010a5:	90                   	nop
	return (char *) s;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010bd:	eb 0e                	jmp    8010cd <memset+0x22>
		*p++ = c;
  8010bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c2:	8d 50 01             	lea    0x1(%eax),%edx
  8010c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010cd:	ff 4d f8             	decl   -0x8(%ebp)
  8010d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010d4:	79 e9                	jns    8010bf <memset+0x14>
		*p++ = c;

	return v;
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d9:	c9                   	leave  
  8010da:	c3                   	ret    

008010db <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010ed:	eb 16                	jmp    801105 <memcpy+0x2a>
		*d++ = *s++;
  8010ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f2:	8d 50 01             	lea    0x1(%eax),%edx
  8010f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801101:	8a 12                	mov    (%edx),%dl
  801103:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110b:	89 55 10             	mov    %edx,0x10(%ebp)
  80110e:	85 c0                	test   %eax,%eax
  801110:	75 dd                	jne    8010ef <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801115:	c9                   	leave  
  801116:	c3                   	ret    

00801117 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801129:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80112f:	73 50                	jae    801181 <memmove+0x6a>
  801131:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801134:	8b 45 10             	mov    0x10(%ebp),%eax
  801137:	01 d0                	add    %edx,%eax
  801139:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80113c:	76 43                	jbe    801181 <memmove+0x6a>
		s += n;
  80113e:	8b 45 10             	mov    0x10(%ebp),%eax
  801141:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80114a:	eb 10                	jmp    80115c <memmove+0x45>
			*--d = *--s;
  80114c:	ff 4d f8             	decl   -0x8(%ebp)
  80114f:	ff 4d fc             	decl   -0x4(%ebp)
  801152:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801155:	8a 10                	mov    (%eax),%dl
  801157:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80115c:	8b 45 10             	mov    0x10(%ebp),%eax
  80115f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801162:	89 55 10             	mov    %edx,0x10(%ebp)
  801165:	85 c0                	test   %eax,%eax
  801167:	75 e3                	jne    80114c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801169:	eb 23                	jmp    80118e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80116b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116e:	8d 50 01             	lea    0x1(%eax),%edx
  801171:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801174:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801177:	8d 4a 01             	lea    0x1(%edx),%ecx
  80117a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80117d:	8a 12                	mov    (%edx),%dl
  80117f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801181:	8b 45 10             	mov    0x10(%ebp),%eax
  801184:	8d 50 ff             	lea    -0x1(%eax),%edx
  801187:	89 55 10             	mov    %edx,0x10(%ebp)
  80118a:	85 c0                	test   %eax,%eax
  80118c:	75 dd                	jne    80116b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801191:	c9                   	leave  
  801192:	c3                   	ret    

00801193 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80119f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011a5:	eb 2a                	jmp    8011d1 <memcmp+0x3e>
		if (*s1 != *s2)
  8011a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011aa:	8a 10                	mov    (%eax),%dl
  8011ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	38 c2                	cmp    %al,%dl
  8011b3:	74 16                	je     8011cb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	0f b6 d0             	movzbl %al,%edx
  8011bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f b6 c0             	movzbl %al,%eax
  8011c5:	29 c2                	sub    %eax,%edx
  8011c7:	89 d0                	mov    %edx,%eax
  8011c9:	eb 18                	jmp    8011e3 <memcmp+0x50>
		s1++, s2++;
  8011cb:	ff 45 fc             	incl   -0x4(%ebp)
  8011ce:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011da:	85 c0                	test   %eax,%eax
  8011dc:	75 c9                	jne    8011a7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011f6:	eb 15                	jmp    80120d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	0f b6 d0             	movzbl %al,%edx
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	0f b6 c0             	movzbl %al,%eax
  801206:	39 c2                	cmp    %eax,%edx
  801208:	74 0d                	je     801217 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80120a:	ff 45 08             	incl   0x8(%ebp)
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801213:	72 e3                	jb     8011f8 <memfind+0x13>
  801215:	eb 01                	jmp    801218 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801217:	90                   	nop
	return (void *) s;
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80122a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801231:	eb 03                	jmp    801236 <strtol+0x19>
		s++;
  801233:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	3c 20                	cmp    $0x20,%al
  80123d:	74 f4                	je     801233 <strtol+0x16>
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	3c 09                	cmp    $0x9,%al
  801246:	74 eb                	je     801233 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	3c 2b                	cmp    $0x2b,%al
  80124f:	75 05                	jne    801256 <strtol+0x39>
		s++;
  801251:	ff 45 08             	incl   0x8(%ebp)
  801254:	eb 13                	jmp    801269 <strtol+0x4c>
	else if (*s == '-')
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	3c 2d                	cmp    $0x2d,%al
  80125d:	75 0a                	jne    801269 <strtol+0x4c>
		s++, neg = 1;
  80125f:	ff 45 08             	incl   0x8(%ebp)
  801262:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801269:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80126d:	74 06                	je     801275 <strtol+0x58>
  80126f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801273:	75 20                	jne    801295 <strtol+0x78>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 30                	cmp    $0x30,%al
  80127c:	75 17                	jne    801295 <strtol+0x78>
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	40                   	inc    %eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 78                	cmp    $0x78,%al
  801286:	75 0d                	jne    801295 <strtol+0x78>
		s += 2, base = 16;
  801288:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80128c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801293:	eb 28                	jmp    8012bd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801295:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801299:	75 15                	jne    8012b0 <strtol+0x93>
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	8a 00                	mov    (%eax),%al
  8012a0:	3c 30                	cmp    $0x30,%al
  8012a2:	75 0c                	jne    8012b0 <strtol+0x93>
		s++, base = 8;
  8012a4:	ff 45 08             	incl   0x8(%ebp)
  8012a7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012ae:	eb 0d                	jmp    8012bd <strtol+0xa0>
	else if (base == 0)
  8012b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b4:	75 07                	jne    8012bd <strtol+0xa0>
		base = 10;
  8012b6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	3c 2f                	cmp    $0x2f,%al
  8012c4:	7e 19                	jle    8012df <strtol+0xc2>
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	3c 39                	cmp    $0x39,%al
  8012cd:	7f 10                	jg     8012df <strtol+0xc2>
			dig = *s - '0';
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	0f be c0             	movsbl %al,%eax
  8012d7:	83 e8 30             	sub    $0x30,%eax
  8012da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012dd:	eb 42                	jmp    801321 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	3c 60                	cmp    $0x60,%al
  8012e6:	7e 19                	jle    801301 <strtol+0xe4>
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	3c 7a                	cmp    $0x7a,%al
  8012ef:	7f 10                	jg     801301 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	0f be c0             	movsbl %al,%eax
  8012f9:	83 e8 57             	sub    $0x57,%eax
  8012fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ff:	eb 20                	jmp    801321 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8a 00                	mov    (%eax),%al
  801306:	3c 40                	cmp    $0x40,%al
  801308:	7e 39                	jle    801343 <strtol+0x126>
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	3c 5a                	cmp    $0x5a,%al
  801311:	7f 30                	jg     801343 <strtol+0x126>
			dig = *s - 'A' + 10;
  801313:	8b 45 08             	mov    0x8(%ebp),%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	83 e8 37             	sub    $0x37,%eax
  80131e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801324:	3b 45 10             	cmp    0x10(%ebp),%eax
  801327:	7d 19                	jge    801342 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801329:	ff 45 08             	incl   0x8(%ebp)
  80132c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801333:	89 c2                	mov    %eax,%edx
  801335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801338:	01 d0                	add    %edx,%eax
  80133a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80133d:	e9 7b ff ff ff       	jmp    8012bd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801342:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801343:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801347:	74 08                	je     801351 <strtol+0x134>
		*endptr = (char *) s;
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	8b 55 08             	mov    0x8(%ebp),%edx
  80134f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801355:	74 07                	je     80135e <strtol+0x141>
  801357:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135a:	f7 d8                	neg    %eax
  80135c:	eb 03                	jmp    801361 <strtol+0x144>
  80135e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801361:	c9                   	leave  
  801362:	c3                   	ret    

00801363 <ltostr>:

void
ltostr(long value, char *str)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801369:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801370:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801377:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80137b:	79 13                	jns    801390 <ltostr+0x2d>
	{
		neg = 1;
  80137d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80138a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80138d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801398:	99                   	cltd   
  801399:	f7 f9                	idiv   %ecx
  80139b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80139e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a1:	8d 50 01             	lea    0x1(%eax),%edx
  8013a4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a7:	89 c2                	mov    %eax,%edx
  8013a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ac:	01 d0                	add    %edx,%eax
  8013ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013b1:	83 c2 30             	add    $0x30,%edx
  8013b4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013be:	f7 e9                	imul   %ecx
  8013c0:	c1 fa 02             	sar    $0x2,%edx
  8013c3:	89 c8                	mov    %ecx,%eax
  8013c5:	c1 f8 1f             	sar    $0x1f,%eax
  8013c8:	29 c2                	sub    %eax,%edx
  8013ca:	89 d0                	mov    %edx,%eax
  8013cc:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013d3:	75 bb                	jne    801390 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013df:	48                   	dec    %eax
  8013e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013e7:	74 3d                	je     801426 <ltostr+0xc3>
		start = 1 ;
  8013e9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013f0:	eb 34                	jmp    801426 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f8:	01 d0                	add    %edx,%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801402:	8b 45 0c             	mov    0xc(%ebp),%eax
  801405:	01 c2                	add    %eax,%edx
  801407:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80140a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140d:	01 c8                	add    %ecx,%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801413:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801416:	8b 45 0c             	mov    0xc(%ebp),%eax
  801419:	01 c2                	add    %eax,%edx
  80141b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80141e:	88 02                	mov    %al,(%edx)
		start++ ;
  801420:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801423:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801429:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80142c:	7c c4                	jl     8013f2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80142e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	01 d0                	add    %edx,%eax
  801436:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801439:	90                   	nop
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    

0080143c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801442:	ff 75 08             	pushl  0x8(%ebp)
  801445:	e8 73 fa ff ff       	call   800ebd <strlen>
  80144a:	83 c4 04             	add    $0x4,%esp
  80144d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801450:	ff 75 0c             	pushl  0xc(%ebp)
  801453:	e8 65 fa ff ff       	call   800ebd <strlen>
  801458:	83 c4 04             	add    $0x4,%esp
  80145b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80145e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801465:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80146c:	eb 17                	jmp    801485 <strcconcat+0x49>
		final[s] = str1[s] ;
  80146e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801471:	8b 45 10             	mov    0x10(%ebp),%eax
  801474:	01 c2                	add    %eax,%edx
  801476:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	01 c8                	add    %ecx,%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801482:	ff 45 fc             	incl   -0x4(%ebp)
  801485:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801488:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80148b:	7c e1                	jl     80146e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80148d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801494:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80149b:	eb 1f                	jmp    8014bc <strcconcat+0x80>
		final[s++] = str2[i] ;
  80149d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a0:	8d 50 01             	lea    0x1(%eax),%edx
  8014a3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014a6:	89 c2                	mov    %eax,%edx
  8014a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ab:	01 c2                	add    %eax,%edx
  8014ad:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	01 c8                	add    %ecx,%eax
  8014b5:	8a 00                	mov    (%eax),%al
  8014b7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014b9:	ff 45 f8             	incl   -0x8(%ebp)
  8014bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014c2:	7c d9                	jl     80149d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ca:	01 d0                	add    %edx,%eax
  8014cc:	c6 00 00             	movb   $0x0,(%eax)
}
  8014cf:	90                   	nop
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014de:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e1:	8b 00                	mov    (%eax),%eax
  8014e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ed:	01 d0                	add    %edx,%eax
  8014ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014f5:	eb 0c                	jmp    801503 <strsplit+0x31>
			*string++ = 0;
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	8d 50 01             	lea    0x1(%eax),%edx
  8014fd:	89 55 08             	mov    %edx,0x8(%ebp)
  801500:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	8a 00                	mov    (%eax),%al
  801508:	84 c0                	test   %al,%al
  80150a:	74 18                	je     801524 <strsplit+0x52>
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	8a 00                	mov    (%eax),%al
  801511:	0f be c0             	movsbl %al,%eax
  801514:	50                   	push   %eax
  801515:	ff 75 0c             	pushl  0xc(%ebp)
  801518:	e8 32 fb ff ff       	call   80104f <strchr>
  80151d:	83 c4 08             	add    $0x8,%esp
  801520:	85 c0                	test   %eax,%eax
  801522:	75 d3                	jne    8014f7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8a 00                	mov    (%eax),%al
  801529:	84 c0                	test   %al,%al
  80152b:	74 5a                	je     801587 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80152d:	8b 45 14             	mov    0x14(%ebp),%eax
  801530:	8b 00                	mov    (%eax),%eax
  801532:	83 f8 0f             	cmp    $0xf,%eax
  801535:	75 07                	jne    80153e <strsplit+0x6c>
		{
			return 0;
  801537:	b8 00 00 00 00       	mov    $0x0,%eax
  80153c:	eb 66                	jmp    8015a4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80153e:	8b 45 14             	mov    0x14(%ebp),%eax
  801541:	8b 00                	mov    (%eax),%eax
  801543:	8d 48 01             	lea    0x1(%eax),%ecx
  801546:	8b 55 14             	mov    0x14(%ebp),%edx
  801549:	89 0a                	mov    %ecx,(%edx)
  80154b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801552:	8b 45 10             	mov    0x10(%ebp),%eax
  801555:	01 c2                	add    %eax,%edx
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80155c:	eb 03                	jmp    801561 <strsplit+0x8f>
			string++;
  80155e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	8a 00                	mov    (%eax),%al
  801566:	84 c0                	test   %al,%al
  801568:	74 8b                	je     8014f5 <strsplit+0x23>
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	8a 00                	mov    (%eax),%al
  80156f:	0f be c0             	movsbl %al,%eax
  801572:	50                   	push   %eax
  801573:	ff 75 0c             	pushl  0xc(%ebp)
  801576:	e8 d4 fa ff ff       	call   80104f <strchr>
  80157b:	83 c4 08             	add    $0x8,%esp
  80157e:	85 c0                	test   %eax,%eax
  801580:	74 dc                	je     80155e <strsplit+0x8c>
			string++;
	}
  801582:	e9 6e ff ff ff       	jmp    8014f5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801587:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801588:	8b 45 14             	mov    0x14(%ebp),%eax
  80158b:	8b 00                	mov    (%eax),%eax
  80158d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801594:	8b 45 10             	mov    0x10(%ebp),%eax
  801597:	01 d0                	add    %edx,%eax
  801599:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80159f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	68 c8 45 80 00       	push   $0x8045c8
  8015b4:	68 3f 01 00 00       	push   $0x13f
  8015b9:	68 ea 45 80 00       	push   $0x8045ea
  8015be:	e8 a9 ef ff ff       	call   80056c <_panic>

008015c3 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8015c9:	83 ec 0c             	sub    $0xc,%esp
  8015cc:	ff 75 08             	pushl  0x8(%ebp)
  8015cf:	e8 9d 0a 00 00       	call   802071 <sys_sbrk>
  8015d4:	83 c4 10             	add    $0x10,%esp
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8015df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e3:	75 0a                	jne    8015ef <malloc+0x16>
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ea:	e9 07 02 00 00       	jmp    8017f6 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8015ef:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8015f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	48                   	dec    %eax
  8015ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801602:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801605:	ba 00 00 00 00       	mov    $0x0,%edx
  80160a:	f7 75 dc             	divl   -0x24(%ebp)
  80160d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801610:	29 d0                	sub    %edx,%eax
  801612:	c1 e8 0c             	shr    $0xc,%eax
  801615:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801618:	a1 20 50 80 00       	mov    0x805020,%eax
  80161d:	8b 40 78             	mov    0x78(%eax),%eax
  801620:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801625:	29 c2                	sub    %eax,%edx
  801627:	89 d0                	mov    %edx,%eax
  801629:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80162c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80162f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801634:	c1 e8 0c             	shr    $0xc,%eax
  801637:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  80163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801641:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801648:	77 42                	ja     80168c <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80164a:	e8 a6 08 00 00       	call   801ef5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80164f:	85 c0                	test   %eax,%eax
  801651:	74 16                	je     801669 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801653:	83 ec 0c             	sub    $0xc,%esp
  801656:	ff 75 08             	pushl  0x8(%ebp)
  801659:	e8 e6 0d 00 00       	call   802444 <alloc_block_FF>
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801664:	e9 8a 01 00 00       	jmp    8017f3 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801669:	e8 b8 08 00 00       	call   801f26 <sys_isUHeapPlacementStrategyBESTFIT>
  80166e:	85 c0                	test   %eax,%eax
  801670:	0f 84 7d 01 00 00    	je     8017f3 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801676:	83 ec 0c             	sub    $0xc,%esp
  801679:	ff 75 08             	pushl  0x8(%ebp)
  80167c:	e8 7f 12 00 00       	call   802900 <alloc_block_BF>
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801687:	e9 67 01 00 00       	jmp    8017f3 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  80168c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80168f:	48                   	dec    %eax
  801690:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801693:	0f 86 53 01 00 00    	jbe    8017ec <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801699:	a1 20 50 80 00       	mov    0x805020,%eax
  80169e:	8b 40 78             	mov    0x78(%eax),%eax
  8016a1:	05 00 10 00 00       	add    $0x1000,%eax
  8016a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8016a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8016b0:	e9 de 00 00 00       	jmp    801793 <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8016b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8016ba:	8b 40 78             	mov    0x78(%eax),%eax
  8016bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016c0:	29 c2                	sub    %eax,%edx
  8016c2:	89 d0                	mov    %edx,%eax
  8016c4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016c9:	c1 e8 0c             	shr    $0xc,%eax
  8016cc:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	0f 85 ab 00 00 00    	jne    801786 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8016db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016de:	05 00 10 00 00       	add    $0x1000,%eax
  8016e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8016e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8016ed:	eb 47                	jmp    801736 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  8016ef:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8016f6:	76 0a                	jbe    801702 <malloc+0x129>
  8016f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fd:	e9 f4 00 00 00       	jmp    8017f6 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801702:	a1 20 50 80 00       	mov    0x805020,%eax
  801707:	8b 40 78             	mov    0x78(%eax),%eax
  80170a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80170d:	29 c2                	sub    %eax,%edx
  80170f:	89 d0                	mov    %edx,%eax
  801711:	2d 00 10 00 00       	sub    $0x1000,%eax
  801716:	c1 e8 0c             	shr    $0xc,%eax
  801719:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801720:	85 c0                	test   %eax,%eax
  801722:	74 08                	je     80172c <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801724:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801727:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  80172a:	eb 5a                	jmp    801786 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  80172c:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801733:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801736:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801739:	48                   	dec    %eax
  80173a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80173d:	77 b0                	ja     8016ef <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  80173f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801746:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80174d:	eb 2f                	jmp    80177e <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  80174f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801752:	c1 e0 0c             	shl    $0xc,%eax
  801755:	89 c2                	mov    %eax,%edx
  801757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175a:	01 c2                	add    %eax,%edx
  80175c:	a1 20 50 80 00       	mov    0x805020,%eax
  801761:	8b 40 78             	mov    0x78(%eax),%eax
  801764:	29 c2                	sub    %eax,%edx
  801766:	89 d0                	mov    %edx,%eax
  801768:	2d 00 10 00 00       	sub    $0x1000,%eax
  80176d:	c1 e8 0c             	shr    $0xc,%eax
  801770:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  801777:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  80177b:	ff 45 e0             	incl   -0x20(%ebp)
  80177e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801781:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801784:	72 c9                	jb     80174f <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801786:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80178a:	75 16                	jne    8017a2 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  80178c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801793:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  80179a:	0f 86 15 ff ff ff    	jbe    8016b5 <malloc+0xdc>
  8017a0:	eb 01                	jmp    8017a3 <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8017a2:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8017a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017a7:	75 07                	jne    8017b0 <malloc+0x1d7>
  8017a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ae:	eb 46                	jmp    8017f6 <malloc+0x21d>
		ptr = (void*)i;
  8017b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8017b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8017bb:	8b 40 78             	mov    0x78(%eax),%eax
  8017be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017c1:	29 c2                	sub    %eax,%edx
  8017c3:	89 d0                	mov    %edx,%eax
  8017c5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017ca:	c1 e8 0c             	shr    $0xc,%eax
  8017cd:	89 c2                	mov    %eax,%edx
  8017cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017d2:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8017d9:	83 ec 08             	sub    $0x8,%esp
  8017dc:	ff 75 08             	pushl  0x8(%ebp)
  8017df:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e2:	e8 c1 08 00 00       	call   8020a8 <sys_allocate_user_mem>
  8017e7:	83 c4 10             	add    $0x10,%esp
  8017ea:	eb 07                	jmp    8017f3 <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  8017ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f1:	eb 03                	jmp    8017f6 <malloc+0x21d>
	}
	return ptr;
  8017f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  8017fe:	a1 20 50 80 00       	mov    0x805020,%eax
  801803:	8b 40 78             	mov    0x78(%eax),%eax
  801806:	05 00 10 00 00       	add    $0x1000,%eax
  80180b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  80180e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801815:	a1 20 50 80 00       	mov    0x805020,%eax
  80181a:	8b 50 78             	mov    0x78(%eax),%edx
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	39 c2                	cmp    %eax,%edx
  801822:	76 24                	jbe    801848 <free+0x50>
		size = get_block_size(va);
  801824:	83 ec 0c             	sub    $0xc,%esp
  801827:	ff 75 08             	pushl  0x8(%ebp)
  80182a:	e8 95 08 00 00       	call   8020c4 <get_block_size>
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801835:	83 ec 0c             	sub    $0xc,%esp
  801838:	ff 75 08             	pushl  0x8(%ebp)
  80183b:	e8 c8 1a 00 00       	call   803308 <free_block>
  801840:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801843:	e9 ac 00 00 00       	jmp    8018f4 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184e:	0f 82 89 00 00 00    	jb     8018dd <free+0xe5>
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  80185c:	77 7f                	ja     8018dd <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  80185e:	8b 55 08             	mov    0x8(%ebp),%edx
  801861:	a1 20 50 80 00       	mov    0x805020,%eax
  801866:	8b 40 78             	mov    0x78(%eax),%eax
  801869:	29 c2                	sub    %eax,%edx
  80186b:	89 d0                	mov    %edx,%eax
  80186d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801872:	c1 e8 0c             	shr    $0xc,%eax
  801875:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  80187c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  80187f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801882:	c1 e0 0c             	shl    $0xc,%eax
  801885:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801888:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80188f:	eb 2f                	jmp    8018c0 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801894:	c1 e0 0c             	shl    $0xc,%eax
  801897:	89 c2                	mov    %eax,%edx
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	01 c2                	add    %eax,%edx
  80189e:	a1 20 50 80 00       	mov    0x805020,%eax
  8018a3:	8b 40 78             	mov    0x78(%eax),%eax
  8018a6:	29 c2                	sub    %eax,%edx
  8018a8:	89 d0                	mov    %edx,%eax
  8018aa:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018af:	c1 e8 0c             	shr    $0xc,%eax
  8018b2:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  8018b9:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8018bd:	ff 45 f4             	incl   -0xc(%ebp)
  8018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018c6:	72 c9                	jb     801891 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	83 ec 08             	sub    $0x8,%esp
  8018ce:	ff 75 ec             	pushl  -0x14(%ebp)
  8018d1:	50                   	push   %eax
  8018d2:	e8 b5 07 00 00       	call   80208c <sys_free_user_mem>
  8018d7:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8018da:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8018db:	eb 17                	jmp    8018f4 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	68 f8 45 80 00       	push   $0x8045f8
  8018e5:	68 84 00 00 00       	push   $0x84
  8018ea:	68 22 46 80 00       	push   $0x804622
  8018ef:	e8 78 ec ff ff       	call   80056c <_panic>
	}
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	83 ec 28             	sub    $0x28,%esp
  8018fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ff:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801902:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801906:	75 07                	jne    80190f <smalloc+0x19>
  801908:	b8 00 00 00 00       	mov    $0x0,%eax
  80190d:	eb 74                	jmp    801983 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80190f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801912:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801915:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80191c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801922:	39 d0                	cmp    %edx,%eax
  801924:	73 02                	jae    801928 <smalloc+0x32>
  801926:	89 d0                	mov    %edx,%eax
  801928:	83 ec 0c             	sub    $0xc,%esp
  80192b:	50                   	push   %eax
  80192c:	e8 a8 fc ff ff       	call   8015d9 <malloc>
  801931:	83 c4 10             	add    $0x10,%esp
  801934:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801937:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80193b:	75 07                	jne    801944 <smalloc+0x4e>
  80193d:	b8 00 00 00 00       	mov    $0x0,%eax
  801942:	eb 3f                	jmp    801983 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801944:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801948:	ff 75 ec             	pushl  -0x14(%ebp)
  80194b:	50                   	push   %eax
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	ff 75 08             	pushl  0x8(%ebp)
  801952:	e8 3c 03 00 00       	call   801c93 <sys_createSharedObject>
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80195d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801961:	74 06                	je     801969 <smalloc+0x73>
  801963:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801967:	75 07                	jne    801970 <smalloc+0x7a>
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
  80196e:	eb 13                	jmp    801983 <smalloc+0x8d>
	 cprintf("153\n");
  801970:	83 ec 0c             	sub    $0xc,%esp
  801973:	68 2e 46 80 00       	push   $0x80462e
  801978:	e8 ac ee ff ff       	call   800829 <cprintf>
  80197d:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801980:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80198b:	83 ec 08             	sub    $0x8,%esp
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	ff 75 08             	pushl  0x8(%ebp)
  801994:	e8 24 03 00 00       	call   801cbd <sys_getSizeOfSharedObject>
  801999:	83 c4 10             	add    $0x10,%esp
  80199c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80199f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019a3:	75 07                	jne    8019ac <sget+0x27>
  8019a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019aa:	eb 5c                	jmp    801a08 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8019ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019b2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bf:	39 d0                	cmp    %edx,%eax
  8019c1:	7d 02                	jge    8019c5 <sget+0x40>
  8019c3:	89 d0                	mov    %edx,%eax
  8019c5:	83 ec 0c             	sub    $0xc,%esp
  8019c8:	50                   	push   %eax
  8019c9:	e8 0b fc ff ff       	call   8015d9 <malloc>
  8019ce:	83 c4 10             	add    $0x10,%esp
  8019d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8019d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8019d8:	75 07                	jne    8019e1 <sget+0x5c>
  8019da:	b8 00 00 00 00       	mov    $0x0,%eax
  8019df:	eb 27                	jmp    801a08 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8019e1:	83 ec 04             	sub    $0x4,%esp
  8019e4:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ea:	ff 75 08             	pushl  0x8(%ebp)
  8019ed:	e8 e8 02 00 00       	call   801cda <sys_getSharedObject>
  8019f2:	83 c4 10             	add    $0x10,%esp
  8019f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8019f8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8019fc:	75 07                	jne    801a05 <sget+0x80>
  8019fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801a03:	eb 03                	jmp    801a08 <sget+0x83>
	return ptr;
  801a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a10:	83 ec 04             	sub    $0x4,%esp
  801a13:	68 34 46 80 00       	push   $0x804634
  801a18:	68 c2 00 00 00       	push   $0xc2
  801a1d:	68 22 46 80 00       	push   $0x804622
  801a22:	e8 45 eb ff ff       	call   80056c <_panic>

00801a27 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a2d:	83 ec 04             	sub    $0x4,%esp
  801a30:	68 58 46 80 00       	push   $0x804658
  801a35:	68 d9 00 00 00       	push   $0xd9
  801a3a:	68 22 46 80 00       	push   $0x804622
  801a3f:	e8 28 eb ff ff       	call   80056c <_panic>

00801a44 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a4a:	83 ec 04             	sub    $0x4,%esp
  801a4d:	68 7e 46 80 00       	push   $0x80467e
  801a52:	68 e5 00 00 00       	push   $0xe5
  801a57:	68 22 46 80 00       	push   $0x804622
  801a5c:	e8 0b eb ff ff       	call   80056c <_panic>

00801a61 <shrink>:

}
void shrink(uint32 newSize)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a67:	83 ec 04             	sub    $0x4,%esp
  801a6a:	68 7e 46 80 00       	push   $0x80467e
  801a6f:	68 ea 00 00 00       	push   $0xea
  801a74:	68 22 46 80 00       	push   $0x804622
  801a79:	e8 ee ea ff ff       	call   80056c <_panic>

00801a7e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	68 7e 46 80 00       	push   $0x80467e
  801a8c:	68 ef 00 00 00       	push   $0xef
  801a91:	68 22 46 80 00       	push   $0x804622
  801a96:	e8 d1 ea ff ff       	call   80056c <_panic>

00801a9b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	57                   	push   %edi
  801a9f:	56                   	push   %esi
  801aa0:	53                   	push   %ebx
  801aa1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ab3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ab6:	cd 30                	int    $0x30
  801ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801abe:	83 c4 10             	add    $0x10,%esp
  801ac1:	5b                   	pop    %ebx
  801ac2:	5e                   	pop    %esi
  801ac3:	5f                   	pop    %edi
  801ac4:	5d                   	pop    %ebp
  801ac5:	c3                   	ret    

00801ac6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 04             	sub    $0x4,%esp
  801acc:	8b 45 10             	mov    0x10(%ebp),%eax
  801acf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ad2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	52                   	push   %edx
  801ade:	ff 75 0c             	pushl  0xc(%ebp)
  801ae1:	50                   	push   %eax
  801ae2:	6a 00                	push   $0x0
  801ae4:	e8 b2 ff ff ff       	call   801a9b <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	90                   	nop
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_cgetc>:

int
sys_cgetc(void)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 02                	push   $0x2
  801afe:	e8 98 ff ff ff       	call   801a9b <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 03                	push   $0x3
  801b17:	e8 7f ff ff ff       	call   801a9b <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	90                   	nop
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 04                	push   $0x4
  801b31:	e8 65 ff ff ff       	call   801a9b <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	90                   	nop
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	52                   	push   %edx
  801b4c:	50                   	push   %eax
  801b4d:	6a 08                	push   $0x8
  801b4f:	e8 47 ff ff ff       	call   801a9b <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	56                   	push   %esi
  801b5d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b5e:	8b 75 18             	mov    0x18(%ebp),%esi
  801b61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	56                   	push   %esi
  801b6e:	53                   	push   %ebx
  801b6f:	51                   	push   %ecx
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 09                	push   $0x9
  801b74:	e8 22 ff ff ff       	call   801a9b <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    

00801b83 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	52                   	push   %edx
  801b93:	50                   	push   %eax
  801b94:	6a 0a                	push   $0xa
  801b96:	e8 00 ff ff ff       	call   801a9b <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	ff 75 0c             	pushl  0xc(%ebp)
  801bac:	ff 75 08             	pushl  0x8(%ebp)
  801baf:	6a 0b                	push   $0xb
  801bb1:	e8 e5 fe ff ff       	call   801a9b <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 0c                	push   $0xc
  801bca:	e8 cc fe ff ff       	call   801a9b <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 0d                	push   $0xd
  801be3:	e8 b3 fe ff ff       	call   801a9b <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 0e                	push   $0xe
  801bfc:	e8 9a fe ff ff       	call   801a9b <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 0f                	push   $0xf
  801c15:	e8 81 fe ff ff       	call   801a9b <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	ff 75 08             	pushl  0x8(%ebp)
  801c2d:	6a 10                	push   $0x10
  801c2f:	e8 67 fe ff ff       	call   801a9b <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 11                	push   $0x11
  801c48:	e8 4e fe ff ff       	call   801a9b <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	90                   	nop
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_cputc>:

void
sys_cputc(const char c)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	83 ec 04             	sub    $0x4,%esp
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c5f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	50                   	push   %eax
  801c6c:	6a 01                	push   $0x1
  801c6e:	e8 28 fe ff ff       	call   801a9b <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	90                   	nop
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 14                	push   $0x14
  801c88:	e8 0e fe ff ff       	call   801a9b <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
}
  801c90:	90                   	nop
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c9f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ca2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	6a 00                	push   $0x0
  801cab:	51                   	push   %ecx
  801cac:	52                   	push   %edx
  801cad:	ff 75 0c             	pushl  0xc(%ebp)
  801cb0:	50                   	push   %eax
  801cb1:	6a 15                	push   $0x15
  801cb3:	e8 e3 fd ff ff       	call   801a9b <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	52                   	push   %edx
  801ccd:	50                   	push   %eax
  801cce:	6a 16                	push   $0x16
  801cd0:	e8 c6 fd ff ff       	call   801a9b <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cdd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	51                   	push   %ecx
  801ceb:	52                   	push   %edx
  801cec:	50                   	push   %eax
  801ced:	6a 17                	push   $0x17
  801cef:	e8 a7 fd ff ff       	call   801a9b <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	52                   	push   %edx
  801d09:	50                   	push   %eax
  801d0a:	6a 18                	push   $0x18
  801d0c:	e8 8a fd ff ff       	call   801a9b <syscall>
  801d11:	83 c4 18             	add    $0x18,%esp
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	6a 00                	push   $0x0
  801d1e:	ff 75 14             	pushl  0x14(%ebp)
  801d21:	ff 75 10             	pushl  0x10(%ebp)
  801d24:	ff 75 0c             	pushl  0xc(%ebp)
  801d27:	50                   	push   %eax
  801d28:	6a 19                	push   $0x19
  801d2a:	e8 6c fd ff ff       	call   801a9b <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	50                   	push   %eax
  801d43:	6a 1a                	push   $0x1a
  801d45:	e8 51 fd ff ff       	call   801a9b <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	90                   	nop
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	50                   	push   %eax
  801d5f:	6a 1b                	push   $0x1b
  801d61:	e8 35 fd ff ff       	call   801a9b <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 05                	push   $0x5
  801d7a:	e8 1c fd ff ff       	call   801a9b <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 06                	push   $0x6
  801d93:	e8 03 fd ff ff       	call   801a9b <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 07                	push   $0x7
  801dac:	e8 ea fc ff ff       	call   801a9b <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_exit_env>:


void sys_exit_env(void)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 1c                	push   $0x1c
  801dc5:	e8 d1 fc ff ff       	call   801a9b <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
}
  801dcd:	90                   	nop
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dd6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dd9:	8d 50 04             	lea    0x4(%eax),%edx
  801ddc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	52                   	push   %edx
  801de6:	50                   	push   %eax
  801de7:	6a 1d                	push   $0x1d
  801de9:	e8 ad fc ff ff       	call   801a9b <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
	return result;
  801df1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801df7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dfa:	89 01                	mov    %eax,(%ecx)
  801dfc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	c9                   	leave  
  801e03:	c2 04 00             	ret    $0x4

00801e06 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	ff 75 10             	pushl  0x10(%ebp)
  801e10:	ff 75 0c             	pushl  0xc(%ebp)
  801e13:	ff 75 08             	pushl  0x8(%ebp)
  801e16:	6a 13                	push   $0x13
  801e18:	e8 7e fc ff ff       	call   801a9b <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e20:	90                   	nop
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 1e                	push   $0x1e
  801e32:	e8 64 fc ff ff       	call   801a9b <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 04             	sub    $0x4,%esp
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e48:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	50                   	push   %eax
  801e55:	6a 1f                	push   $0x1f
  801e57:	e8 3f fc ff ff       	call   801a9b <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5f:	90                   	nop
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <rsttst>:
void rsttst()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 21                	push   $0x21
  801e71:	e8 25 fc ff ff       	call   801a9b <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
	return ;
  801e79:	90                   	nop
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	8b 45 14             	mov    0x14(%ebp),%eax
  801e85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e88:	8b 55 18             	mov    0x18(%ebp),%edx
  801e8b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e8f:	52                   	push   %edx
  801e90:	50                   	push   %eax
  801e91:	ff 75 10             	pushl  0x10(%ebp)
  801e94:	ff 75 0c             	pushl  0xc(%ebp)
  801e97:	ff 75 08             	pushl  0x8(%ebp)
  801e9a:	6a 20                	push   $0x20
  801e9c:	e8 fa fb ff ff       	call   801a9b <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea4:	90                   	nop
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <chktst>:
void chktst(uint32 n)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	ff 75 08             	pushl  0x8(%ebp)
  801eb5:	6a 22                	push   $0x22
  801eb7:	e8 df fb ff ff       	call   801a9b <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebf:	90                   	nop
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <inctst>:

void inctst()
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 23                	push   $0x23
  801ed1:	e8 c5 fb ff ff       	call   801a9b <syscall>
  801ed6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed9:	90                   	nop
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <gettst>:
uint32 gettst()
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 24                	push   $0x24
  801eeb:	e8 ab fb ff ff       	call   801a9b <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 25                	push   $0x25
  801f07:	e8 8f fb ff ff       	call   801a9b <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
  801f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f12:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f16:	75 07                	jne    801f1f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f18:	b8 01 00 00 00       	mov    $0x1,%eax
  801f1d:	eb 05                	jmp    801f24 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 25                	push   $0x25
  801f38:	e8 5e fb ff ff       	call   801a9b <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
  801f40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f43:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f47:	75 07                	jne    801f50 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f49:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4e:	eb 05                	jmp    801f55 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 25                	push   $0x25
  801f69:	e8 2d fb ff ff       	call   801a9b <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
  801f71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f74:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f78:	75 07                	jne    801f81 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7f:	eb 05                	jmp    801f86 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 25                	push   $0x25
  801f9a:	e8 fc fa ff ff       	call   801a9b <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
  801fa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fa5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fa9:	75 07                	jne    801fb2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fab:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb0:	eb 05                	jmp    801fb7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	ff 75 08             	pushl  0x8(%ebp)
  801fc7:	6a 26                	push   $0x26
  801fc9:	e8 cd fa ff ff       	call   801a9b <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd1:	90                   	nop
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fd8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe4:	6a 00                	push   $0x0
  801fe6:	53                   	push   %ebx
  801fe7:	51                   	push   %ecx
  801fe8:	52                   	push   %edx
  801fe9:	50                   	push   %eax
  801fea:	6a 27                	push   $0x27
  801fec:	e8 aa fa ff ff       	call   801a9b <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
}
  801ff4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	52                   	push   %edx
  802009:	50                   	push   %eax
  80200a:	6a 28                	push   $0x28
  80200c:	e8 8a fa ff ff       	call   801a9b <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802019:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80201c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	6a 00                	push   $0x0
  802024:	51                   	push   %ecx
  802025:	ff 75 10             	pushl  0x10(%ebp)
  802028:	52                   	push   %edx
  802029:	50                   	push   %eax
  80202a:	6a 29                	push   $0x29
  80202c:	e8 6a fa ff ff       	call   801a9b <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	ff 75 10             	pushl  0x10(%ebp)
  802040:	ff 75 0c             	pushl  0xc(%ebp)
  802043:	ff 75 08             	pushl  0x8(%ebp)
  802046:	6a 12                	push   $0x12
  802048:	e8 4e fa ff ff       	call   801a9b <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
	return ;
  802050:	90                   	nop
}
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802056:	8b 55 0c             	mov    0xc(%ebp),%edx
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	52                   	push   %edx
  802063:	50                   	push   %eax
  802064:	6a 2a                	push   $0x2a
  802066:	e8 30 fa ff ff       	call   801a9b <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
	return;
  80206e:	90                   	nop
}
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	50                   	push   %eax
  802080:	6a 2b                	push   $0x2b
  802082:	e8 14 fa ff ff       	call   801a9b <syscall>
  802087:	83 c4 18             	add    $0x18,%esp
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	ff 75 0c             	pushl  0xc(%ebp)
  802098:	ff 75 08             	pushl  0x8(%ebp)
  80209b:	6a 2c                	push   $0x2c
  80209d:	e8 f9 f9 ff ff       	call   801a9b <syscall>
  8020a2:	83 c4 18             	add    $0x18,%esp
	return;
  8020a5:	90                   	nop
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	ff 75 0c             	pushl  0xc(%ebp)
  8020b4:	ff 75 08             	pushl  0x8(%ebp)
  8020b7:	6a 2d                	push   $0x2d
  8020b9:	e8 dd f9 ff ff       	call   801a9b <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
	return;
  8020c1:	90                   	nop
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	83 e8 04             	sub    $0x4,%eax
  8020d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8020d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d6:	8b 00                	mov    (%eax),%eax
  8020d8:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
  8020e0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	83 e8 04             	sub    $0x4,%eax
  8020e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8020ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ef:	8b 00                	mov    (%eax),%eax
  8020f1:	83 e0 01             	and    $0x1,%eax
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	0f 94 c0             	sete   %al
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
  8020fe:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802101:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210b:	83 f8 02             	cmp    $0x2,%eax
  80210e:	74 2b                	je     80213b <alloc_block+0x40>
  802110:	83 f8 02             	cmp    $0x2,%eax
  802113:	7f 07                	jg     80211c <alloc_block+0x21>
  802115:	83 f8 01             	cmp    $0x1,%eax
  802118:	74 0e                	je     802128 <alloc_block+0x2d>
  80211a:	eb 58                	jmp    802174 <alloc_block+0x79>
  80211c:	83 f8 03             	cmp    $0x3,%eax
  80211f:	74 2d                	je     80214e <alloc_block+0x53>
  802121:	83 f8 04             	cmp    $0x4,%eax
  802124:	74 3b                	je     802161 <alloc_block+0x66>
  802126:	eb 4c                	jmp    802174 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802128:	83 ec 0c             	sub    $0xc,%esp
  80212b:	ff 75 08             	pushl  0x8(%ebp)
  80212e:	e8 11 03 00 00       	call   802444 <alloc_block_FF>
  802133:	83 c4 10             	add    $0x10,%esp
  802136:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802139:	eb 4a                	jmp    802185 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80213b:	83 ec 0c             	sub    $0xc,%esp
  80213e:	ff 75 08             	pushl  0x8(%ebp)
  802141:	e8 fa 19 00 00       	call   803b40 <alloc_block_NF>
  802146:	83 c4 10             	add    $0x10,%esp
  802149:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80214c:	eb 37                	jmp    802185 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80214e:	83 ec 0c             	sub    $0xc,%esp
  802151:	ff 75 08             	pushl  0x8(%ebp)
  802154:	e8 a7 07 00 00       	call   802900 <alloc_block_BF>
  802159:	83 c4 10             	add    $0x10,%esp
  80215c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80215f:	eb 24                	jmp    802185 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802161:	83 ec 0c             	sub    $0xc,%esp
  802164:	ff 75 08             	pushl  0x8(%ebp)
  802167:	e8 b7 19 00 00       	call   803b23 <alloc_block_WF>
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802172:	eb 11                	jmp    802185 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802174:	83 ec 0c             	sub    $0xc,%esp
  802177:	68 90 46 80 00       	push   $0x804690
  80217c:	e8 a8 e6 ff ff       	call   800829 <cprintf>
  802181:	83 c4 10             	add    $0x10,%esp
		break;
  802184:	90                   	nop
	}
	return va;
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	53                   	push   %ebx
  80218e:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802191:	83 ec 0c             	sub    $0xc,%esp
  802194:	68 b0 46 80 00       	push   $0x8046b0
  802199:	e8 8b e6 ff ff       	call   800829 <cprintf>
  80219e:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8021a1:	83 ec 0c             	sub    $0xc,%esp
  8021a4:	68 db 46 80 00       	push   $0x8046db
  8021a9:	e8 7b e6 ff ff       	call   800829 <cprintf>
  8021ae:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b7:	eb 37                	jmp    8021f0 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8021b9:	83 ec 0c             	sub    $0xc,%esp
  8021bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8021bf:	e8 19 ff ff ff       	call   8020dd <is_free_block>
  8021c4:	83 c4 10             	add    $0x10,%esp
  8021c7:	0f be d8             	movsbl %al,%ebx
  8021ca:	83 ec 0c             	sub    $0xc,%esp
  8021cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d0:	e8 ef fe ff ff       	call   8020c4 <get_block_size>
  8021d5:	83 c4 10             	add    $0x10,%esp
  8021d8:	83 ec 04             	sub    $0x4,%esp
  8021db:	53                   	push   %ebx
  8021dc:	50                   	push   %eax
  8021dd:	68 f3 46 80 00       	push   $0x8046f3
  8021e2:	e8 42 e6 ff ff       	call   800829 <cprintf>
  8021e7:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8021ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f4:	74 07                	je     8021fd <print_blocks_list+0x73>
  8021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f9:	8b 00                	mov    (%eax),%eax
  8021fb:	eb 05                	jmp    802202 <print_blocks_list+0x78>
  8021fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802202:	89 45 10             	mov    %eax,0x10(%ebp)
  802205:	8b 45 10             	mov    0x10(%ebp),%eax
  802208:	85 c0                	test   %eax,%eax
  80220a:	75 ad                	jne    8021b9 <print_blocks_list+0x2f>
  80220c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802210:	75 a7                	jne    8021b9 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802212:	83 ec 0c             	sub    $0xc,%esp
  802215:	68 b0 46 80 00       	push   $0x8046b0
  80221a:	e8 0a e6 ff ff       	call   800829 <cprintf>
  80221f:	83 c4 10             	add    $0x10,%esp

}
  802222:	90                   	nop
  802223:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80222e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802231:	83 e0 01             	and    $0x1,%eax
  802234:	85 c0                	test   %eax,%eax
  802236:	74 03                	je     80223b <initialize_dynamic_allocator+0x13>
  802238:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80223b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80223f:	0f 84 c7 01 00 00    	je     80240c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802245:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80224c:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80224f:	8b 55 08             	mov    0x8(%ebp),%edx
  802252:	8b 45 0c             	mov    0xc(%ebp),%eax
  802255:	01 d0                	add    %edx,%eax
  802257:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80225c:	0f 87 ad 01 00 00    	ja     80240f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	85 c0                	test   %eax,%eax
  802267:	0f 89 a5 01 00 00    	jns    802412 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80226d:	8b 55 08             	mov    0x8(%ebp),%edx
  802270:	8b 45 0c             	mov    0xc(%ebp),%eax
  802273:	01 d0                	add    %edx,%eax
  802275:	83 e8 04             	sub    $0x4,%eax
  802278:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80227d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802284:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802289:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80228c:	e9 87 00 00 00       	jmp    802318 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802295:	75 14                	jne    8022ab <initialize_dynamic_allocator+0x83>
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	68 0b 47 80 00       	push   $0x80470b
  80229f:	6a 79                	push   $0x79
  8022a1:	68 29 47 80 00       	push   $0x804729
  8022a6:	e8 c1 e2 ff ff       	call   80056c <_panic>
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	8b 00                	mov    (%eax),%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	74 10                	je     8022c4 <initialize_dynamic_allocator+0x9c>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 00                	mov    (%eax),%eax
  8022b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bc:	8b 52 04             	mov    0x4(%edx),%edx
  8022bf:	89 50 04             	mov    %edx,0x4(%eax)
  8022c2:	eb 0b                	jmp    8022cf <initialize_dynamic_allocator+0xa7>
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 40 04             	mov    0x4(%eax),%eax
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	74 0f                	je     8022e8 <initialize_dynamic_allocator+0xc0>
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	8b 40 04             	mov    0x4(%eax),%eax
  8022df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e2:	8b 12                	mov    (%edx),%edx
  8022e4:	89 10                	mov    %edx,(%eax)
  8022e6:	eb 0a                	jmp    8022f2 <initialize_dynamic_allocator+0xca>
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 00                	mov    (%eax),%eax
  8022ed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802305:	a1 38 50 80 00       	mov    0x805038,%eax
  80230a:	48                   	dec    %eax
  80230b:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802310:	a1 34 50 80 00       	mov    0x805034,%eax
  802315:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802318:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231c:	74 07                	je     802325 <initialize_dynamic_allocator+0xfd>
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	8b 00                	mov    (%eax),%eax
  802323:	eb 05                	jmp    80232a <initialize_dynamic_allocator+0x102>
  802325:	b8 00 00 00 00       	mov    $0x0,%eax
  80232a:	a3 34 50 80 00       	mov    %eax,0x805034
  80232f:	a1 34 50 80 00       	mov    0x805034,%eax
  802334:	85 c0                	test   %eax,%eax
  802336:	0f 85 55 ff ff ff    	jne    802291 <initialize_dynamic_allocator+0x69>
  80233c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802340:	0f 85 4b ff ff ff    	jne    802291 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80234c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802355:	a1 44 50 80 00       	mov    0x805044,%eax
  80235a:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80235f:	a1 40 50 80 00       	mov    0x805040,%eax
  802364:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80236a:	8b 45 08             	mov    0x8(%ebp),%eax
  80236d:	83 c0 08             	add    $0x8,%eax
  802370:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	83 c0 04             	add    $0x4,%eax
  802379:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237c:	83 ea 08             	sub    $0x8,%edx
  80237f:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802381:	8b 55 0c             	mov    0xc(%ebp),%edx
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	01 d0                	add    %edx,%eax
  802389:	83 e8 08             	sub    $0x8,%eax
  80238c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238f:	83 ea 08             	sub    $0x8,%edx
  802392:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802394:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802397:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80239d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8023a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023ab:	75 17                	jne    8023c4 <initialize_dynamic_allocator+0x19c>
  8023ad:	83 ec 04             	sub    $0x4,%esp
  8023b0:	68 44 47 80 00       	push   $0x804744
  8023b5:	68 90 00 00 00       	push   $0x90
  8023ba:	68 29 47 80 00       	push   $0x804729
  8023bf:	e8 a8 e1 ff ff       	call   80056c <_panic>
  8023c4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cd:	89 10                	mov    %edx,(%eax)
  8023cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d2:	8b 00                	mov    (%eax),%eax
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	74 0d                	je     8023e5 <initialize_dynamic_allocator+0x1bd>
  8023d8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023e0:	89 50 04             	mov    %edx,0x4(%eax)
  8023e3:	eb 08                	jmp    8023ed <initialize_dynamic_allocator+0x1c5>
  8023e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ff:	a1 38 50 80 00       	mov    0x805038,%eax
  802404:	40                   	inc    %eax
  802405:	a3 38 50 80 00       	mov    %eax,0x805038
  80240a:	eb 07                	jmp    802413 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80240c:	90                   	nop
  80240d:	eb 04                	jmp    802413 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80240f:	90                   	nop
  802410:	eb 01                	jmp    802413 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802412:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802418:	8b 45 10             	mov    0x10(%ebp),%eax
  80241b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	8d 50 fc             	lea    -0x4(%eax),%edx
  802424:	8b 45 0c             	mov    0xc(%ebp),%eax
  802427:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	83 e8 04             	sub    $0x4,%eax
  80242f:	8b 00                	mov    (%eax),%eax
  802431:	83 e0 fe             	and    $0xfffffffe,%eax
  802434:	8d 50 f8             	lea    -0x8(%eax),%edx
  802437:	8b 45 08             	mov    0x8(%ebp),%eax
  80243a:	01 c2                	add    %eax,%edx
  80243c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243f:	89 02                	mov    %eax,(%edx)
}
  802441:	90                   	nop
  802442:	5d                   	pop    %ebp
  802443:	c3                   	ret    

00802444 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80244a:	8b 45 08             	mov    0x8(%ebp),%eax
  80244d:	83 e0 01             	and    $0x1,%eax
  802450:	85 c0                	test   %eax,%eax
  802452:	74 03                	je     802457 <alloc_block_FF+0x13>
  802454:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802457:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80245b:	77 07                	ja     802464 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80245d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802464:	a1 24 50 80 00       	mov    0x805024,%eax
  802469:	85 c0                	test   %eax,%eax
  80246b:	75 73                	jne    8024e0 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	83 c0 10             	add    $0x10,%eax
  802473:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802476:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80247d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802480:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802483:	01 d0                	add    %edx,%eax
  802485:	48                   	dec    %eax
  802486:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802489:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80248c:	ba 00 00 00 00       	mov    $0x0,%edx
  802491:	f7 75 ec             	divl   -0x14(%ebp)
  802494:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802497:	29 d0                	sub    %edx,%eax
  802499:	c1 e8 0c             	shr    $0xc,%eax
  80249c:	83 ec 0c             	sub    $0xc,%esp
  80249f:	50                   	push   %eax
  8024a0:	e8 1e f1 ff ff       	call   8015c3 <sbrk>
  8024a5:	83 c4 10             	add    $0x10,%esp
  8024a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024ab:	83 ec 0c             	sub    $0xc,%esp
  8024ae:	6a 00                	push   $0x0
  8024b0:	e8 0e f1 ff ff       	call   8015c3 <sbrk>
  8024b5:	83 c4 10             	add    $0x10,%esp
  8024b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024be:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8024c1:	83 ec 08             	sub    $0x8,%esp
  8024c4:	50                   	push   %eax
  8024c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8024c8:	e8 5b fd ff ff       	call   802228 <initialize_dynamic_allocator>
  8024cd:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024d0:	83 ec 0c             	sub    $0xc,%esp
  8024d3:	68 67 47 80 00       	push   $0x804767
  8024d8:	e8 4c e3 ff ff       	call   800829 <cprintf>
  8024dd:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8024e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e4:	75 0a                	jne    8024f0 <alloc_block_FF+0xac>
	        return NULL;
  8024e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024eb:	e9 0e 04 00 00       	jmp    8028fe <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8024f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ff:	e9 f3 02 00 00       	jmp    8027f7 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80250a:	83 ec 0c             	sub    $0xc,%esp
  80250d:	ff 75 bc             	pushl  -0x44(%ebp)
  802510:	e8 af fb ff ff       	call   8020c4 <get_block_size>
  802515:	83 c4 10             	add    $0x10,%esp
  802518:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	83 c0 08             	add    $0x8,%eax
  802521:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802524:	0f 87 c5 02 00 00    	ja     8027ef <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	83 c0 18             	add    $0x18,%eax
  802530:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802533:	0f 87 19 02 00 00    	ja     802752 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802539:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80253c:	2b 45 08             	sub    0x8(%ebp),%eax
  80253f:	83 e8 08             	sub    $0x8,%eax
  802542:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802545:	8b 45 08             	mov    0x8(%ebp),%eax
  802548:	8d 50 08             	lea    0x8(%eax),%edx
  80254b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80254e:	01 d0                	add    %edx,%eax
  802550:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	83 c0 08             	add    $0x8,%eax
  802559:	83 ec 04             	sub    $0x4,%esp
  80255c:	6a 01                	push   $0x1
  80255e:	50                   	push   %eax
  80255f:	ff 75 bc             	pushl  -0x44(%ebp)
  802562:	e8 ae fe ff ff       	call   802415 <set_block_data>
  802567:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 40 04             	mov    0x4(%eax),%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	75 68                	jne    8025dc <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802574:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802578:	75 17                	jne    802591 <alloc_block_FF+0x14d>
  80257a:	83 ec 04             	sub    $0x4,%esp
  80257d:	68 44 47 80 00       	push   $0x804744
  802582:	68 d7 00 00 00       	push   $0xd7
  802587:	68 29 47 80 00       	push   $0x804729
  80258c:	e8 db df ff ff       	call   80056c <_panic>
  802591:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802597:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80259a:	89 10                	mov    %edx,(%eax)
  80259c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	74 0d                	je     8025b2 <alloc_block_FF+0x16e>
  8025a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025aa:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8025ad:	89 50 04             	mov    %edx,0x4(%eax)
  8025b0:	eb 08                	jmp    8025ba <alloc_block_FF+0x176>
  8025b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8025ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025bd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8025c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8025d1:	40                   	inc    %eax
  8025d2:	a3 38 50 80 00       	mov    %eax,0x805038
  8025d7:	e9 dc 00 00 00       	jmp    8026b8 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 00                	mov    (%eax),%eax
  8025e1:	85 c0                	test   %eax,%eax
  8025e3:	75 65                	jne    80264a <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8025e5:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8025e9:	75 17                	jne    802602 <alloc_block_FF+0x1be>
  8025eb:	83 ec 04             	sub    $0x4,%esp
  8025ee:	68 78 47 80 00       	push   $0x804778
  8025f3:	68 db 00 00 00       	push   $0xdb
  8025f8:	68 29 47 80 00       	push   $0x804729
  8025fd:	e8 6a df ff ff       	call   80056c <_panic>
  802602:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802608:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80260b:	89 50 04             	mov    %edx,0x4(%eax)
  80260e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802611:	8b 40 04             	mov    0x4(%eax),%eax
  802614:	85 c0                	test   %eax,%eax
  802616:	74 0c                	je     802624 <alloc_block_FF+0x1e0>
  802618:	a1 30 50 80 00       	mov    0x805030,%eax
  80261d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802620:	89 10                	mov    %edx,(%eax)
  802622:	eb 08                	jmp    80262c <alloc_block_FF+0x1e8>
  802624:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802627:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80262c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80262f:	a3 30 50 80 00       	mov    %eax,0x805030
  802634:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802637:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263d:	a1 38 50 80 00       	mov    0x805038,%eax
  802642:	40                   	inc    %eax
  802643:	a3 38 50 80 00       	mov    %eax,0x805038
  802648:	eb 6e                	jmp    8026b8 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80264a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264e:	74 06                	je     802656 <alloc_block_FF+0x212>
  802650:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802654:	75 17                	jne    80266d <alloc_block_FF+0x229>
  802656:	83 ec 04             	sub    $0x4,%esp
  802659:	68 9c 47 80 00       	push   $0x80479c
  80265e:	68 df 00 00 00       	push   $0xdf
  802663:	68 29 47 80 00       	push   $0x804729
  802668:	e8 ff de ff ff       	call   80056c <_panic>
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 10                	mov    (%eax),%edx
  802672:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802675:	89 10                	mov    %edx,(%eax)
  802677:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80267a:	8b 00                	mov    (%eax),%eax
  80267c:	85 c0                	test   %eax,%eax
  80267e:	74 0b                	je     80268b <alloc_block_FF+0x247>
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 00                	mov    (%eax),%eax
  802685:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802688:	89 50 04             	mov    %edx,0x4(%eax)
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802691:	89 10                	mov    %edx,(%eax)
  802693:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802696:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802699:	89 50 04             	mov    %edx,0x4(%eax)
  80269c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	85 c0                	test   %eax,%eax
  8026a3:	75 08                	jne    8026ad <alloc_block_FF+0x269>
  8026a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026a8:	a3 30 50 80 00       	mov    %eax,0x805030
  8026ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8026b2:	40                   	inc    %eax
  8026b3:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8026b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bc:	75 17                	jne    8026d5 <alloc_block_FF+0x291>
  8026be:	83 ec 04             	sub    $0x4,%esp
  8026c1:	68 0b 47 80 00       	push   $0x80470b
  8026c6:	68 e1 00 00 00       	push   $0xe1
  8026cb:	68 29 47 80 00       	push   $0x804729
  8026d0:	e8 97 de ff ff       	call   80056c <_panic>
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 00                	mov    (%eax),%eax
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	74 10                	je     8026ee <alloc_block_FF+0x2aa>
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e6:	8b 52 04             	mov    0x4(%edx),%edx
  8026e9:	89 50 04             	mov    %edx,0x4(%eax)
  8026ec:	eb 0b                	jmp    8026f9 <alloc_block_FF+0x2b5>
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 40 04             	mov    0x4(%eax),%eax
  8026f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 40 04             	mov    0x4(%eax),%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	74 0f                	je     802712 <alloc_block_FF+0x2ce>
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 40 04             	mov    0x4(%eax),%eax
  802709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270c:	8b 12                	mov    (%edx),%edx
  80270e:	89 10                	mov    %edx,(%eax)
  802710:	eb 0a                	jmp    80271c <alloc_block_FF+0x2d8>
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	8b 00                	mov    (%eax),%eax
  802717:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272f:	a1 38 50 80 00       	mov    0x805038,%eax
  802734:	48                   	dec    %eax
  802735:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80273a:	83 ec 04             	sub    $0x4,%esp
  80273d:	6a 00                	push   $0x0
  80273f:	ff 75 b4             	pushl  -0x4c(%ebp)
  802742:	ff 75 b0             	pushl  -0x50(%ebp)
  802745:	e8 cb fc ff ff       	call   802415 <set_block_data>
  80274a:	83 c4 10             	add    $0x10,%esp
  80274d:	e9 95 00 00 00       	jmp    8027e7 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802752:	83 ec 04             	sub    $0x4,%esp
  802755:	6a 01                	push   $0x1
  802757:	ff 75 b8             	pushl  -0x48(%ebp)
  80275a:	ff 75 bc             	pushl  -0x44(%ebp)
  80275d:	e8 b3 fc ff ff       	call   802415 <set_block_data>
  802762:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802765:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802769:	75 17                	jne    802782 <alloc_block_FF+0x33e>
  80276b:	83 ec 04             	sub    $0x4,%esp
  80276e:	68 0b 47 80 00       	push   $0x80470b
  802773:	68 e8 00 00 00       	push   $0xe8
  802778:	68 29 47 80 00       	push   $0x804729
  80277d:	e8 ea dd ff ff       	call   80056c <_panic>
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	74 10                	je     80279b <alloc_block_FF+0x357>
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 00                	mov    (%eax),%eax
  802790:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802793:	8b 52 04             	mov    0x4(%edx),%edx
  802796:	89 50 04             	mov    %edx,0x4(%eax)
  802799:	eb 0b                	jmp    8027a6 <alloc_block_FF+0x362>
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 40 04             	mov    0x4(%eax),%eax
  8027a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	74 0f                	je     8027bf <alloc_block_FF+0x37b>
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 40 04             	mov    0x4(%eax),%eax
  8027b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b9:	8b 12                	mov    (%edx),%edx
  8027bb:	89 10                	mov    %edx,(%eax)
  8027bd:	eb 0a                	jmp    8027c9 <alloc_block_FF+0x385>
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027dc:	a1 38 50 80 00       	mov    0x805038,%eax
  8027e1:	48                   	dec    %eax
  8027e2:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8027e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027ea:	e9 0f 01 00 00       	jmp    8028fe <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8027ef:	a1 34 50 80 00       	mov    0x805034,%eax
  8027f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fb:	74 07                	je     802804 <alloc_block_FF+0x3c0>
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 00                	mov    (%eax),%eax
  802802:	eb 05                	jmp    802809 <alloc_block_FF+0x3c5>
  802804:	b8 00 00 00 00       	mov    $0x0,%eax
  802809:	a3 34 50 80 00       	mov    %eax,0x805034
  80280e:	a1 34 50 80 00       	mov    0x805034,%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	0f 85 e9 fc ff ff    	jne    802504 <alloc_block_FF+0xc0>
  80281b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281f:	0f 85 df fc ff ff    	jne    802504 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802825:	8b 45 08             	mov    0x8(%ebp),%eax
  802828:	83 c0 08             	add    $0x8,%eax
  80282b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80282e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802835:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802838:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80283b:	01 d0                	add    %edx,%eax
  80283d:	48                   	dec    %eax
  80283e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802841:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802844:	ba 00 00 00 00       	mov    $0x0,%edx
  802849:	f7 75 d8             	divl   -0x28(%ebp)
  80284c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80284f:	29 d0                	sub    %edx,%eax
  802851:	c1 e8 0c             	shr    $0xc,%eax
  802854:	83 ec 0c             	sub    $0xc,%esp
  802857:	50                   	push   %eax
  802858:	e8 66 ed ff ff       	call   8015c3 <sbrk>
  80285d:	83 c4 10             	add    $0x10,%esp
  802860:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802863:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802867:	75 0a                	jne    802873 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802869:	b8 00 00 00 00       	mov    $0x0,%eax
  80286e:	e9 8b 00 00 00       	jmp    8028fe <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802873:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80287a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80287d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802880:	01 d0                	add    %edx,%eax
  802882:	48                   	dec    %eax
  802883:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802886:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802889:	ba 00 00 00 00       	mov    $0x0,%edx
  80288e:	f7 75 cc             	divl   -0x34(%ebp)
  802891:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802894:	29 d0                	sub    %edx,%eax
  802896:	8d 50 fc             	lea    -0x4(%eax),%edx
  802899:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80289c:	01 d0                	add    %edx,%eax
  80289e:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8028a3:	a1 40 50 80 00       	mov    0x805040,%eax
  8028a8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8028ae:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8028b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028bb:	01 d0                	add    %edx,%eax
  8028bd:	48                   	dec    %eax
  8028be:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8028c1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c9:	f7 75 c4             	divl   -0x3c(%ebp)
  8028cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028cf:	29 d0                	sub    %edx,%eax
  8028d1:	83 ec 04             	sub    $0x4,%esp
  8028d4:	6a 01                	push   $0x1
  8028d6:	50                   	push   %eax
  8028d7:	ff 75 d0             	pushl  -0x30(%ebp)
  8028da:	e8 36 fb ff ff       	call   802415 <set_block_data>
  8028df:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8028e2:	83 ec 0c             	sub    $0xc,%esp
  8028e5:	ff 75 d0             	pushl  -0x30(%ebp)
  8028e8:	e8 1b 0a 00 00       	call   803308 <free_block>
  8028ed:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8028f0:	83 ec 0c             	sub    $0xc,%esp
  8028f3:	ff 75 08             	pushl  0x8(%ebp)
  8028f6:	e8 49 fb ff ff       	call   802444 <alloc_block_FF>
  8028fb:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8028fe:	c9                   	leave  
  8028ff:	c3                   	ret    

00802900 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802906:	8b 45 08             	mov    0x8(%ebp),%eax
  802909:	83 e0 01             	and    $0x1,%eax
  80290c:	85 c0                	test   %eax,%eax
  80290e:	74 03                	je     802913 <alloc_block_BF+0x13>
  802910:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802913:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802917:	77 07                	ja     802920 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802919:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802920:	a1 24 50 80 00       	mov    0x805024,%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	75 73                	jne    80299c <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802929:	8b 45 08             	mov    0x8(%ebp),%eax
  80292c:	83 c0 10             	add    $0x10,%eax
  80292f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802932:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802939:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80293c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293f:	01 d0                	add    %edx,%eax
  802941:	48                   	dec    %eax
  802942:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802945:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802948:	ba 00 00 00 00       	mov    $0x0,%edx
  80294d:	f7 75 e0             	divl   -0x20(%ebp)
  802950:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802953:	29 d0                	sub    %edx,%eax
  802955:	c1 e8 0c             	shr    $0xc,%eax
  802958:	83 ec 0c             	sub    $0xc,%esp
  80295b:	50                   	push   %eax
  80295c:	e8 62 ec ff ff       	call   8015c3 <sbrk>
  802961:	83 c4 10             	add    $0x10,%esp
  802964:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802967:	83 ec 0c             	sub    $0xc,%esp
  80296a:	6a 00                	push   $0x0
  80296c:	e8 52 ec ff ff       	call   8015c3 <sbrk>
  802971:	83 c4 10             	add    $0x10,%esp
  802974:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802977:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80297a:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80297d:	83 ec 08             	sub    $0x8,%esp
  802980:	50                   	push   %eax
  802981:	ff 75 d8             	pushl  -0x28(%ebp)
  802984:	e8 9f f8 ff ff       	call   802228 <initialize_dynamic_allocator>
  802989:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80298c:	83 ec 0c             	sub    $0xc,%esp
  80298f:	68 67 47 80 00       	push   $0x804767
  802994:	e8 90 de ff ff       	call   800829 <cprintf>
  802999:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80299c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8029a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8029aa:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8029b1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8029b8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c0:	e9 1d 01 00 00       	jmp    802ae2 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8029cb:	83 ec 0c             	sub    $0xc,%esp
  8029ce:	ff 75 a8             	pushl  -0x58(%ebp)
  8029d1:	e8 ee f6 ff ff       	call   8020c4 <get_block_size>
  8029d6:	83 c4 10             	add    $0x10,%esp
  8029d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	83 c0 08             	add    $0x8,%eax
  8029e2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029e5:	0f 87 ef 00 00 00    	ja     802ada <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	83 c0 18             	add    $0x18,%eax
  8029f1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029f4:	77 1d                	ja     802a13 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8029f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029fc:	0f 86 d8 00 00 00    	jbe    802ada <alloc_block_BF+0x1da>
				{
					best_va = va;
  802a02:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802a05:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802a08:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a0e:	e9 c7 00 00 00       	jmp    802ada <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	83 c0 08             	add    $0x8,%eax
  802a19:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802a1c:	0f 85 9d 00 00 00    	jne    802abf <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802a22:	83 ec 04             	sub    $0x4,%esp
  802a25:	6a 01                	push   $0x1
  802a27:	ff 75 a4             	pushl  -0x5c(%ebp)
  802a2a:	ff 75 a8             	pushl  -0x58(%ebp)
  802a2d:	e8 e3 f9 ff ff       	call   802415 <set_block_data>
  802a32:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802a35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a39:	75 17                	jne    802a52 <alloc_block_BF+0x152>
  802a3b:	83 ec 04             	sub    $0x4,%esp
  802a3e:	68 0b 47 80 00       	push   $0x80470b
  802a43:	68 2c 01 00 00       	push   $0x12c
  802a48:	68 29 47 80 00       	push   $0x804729
  802a4d:	e8 1a db ff ff       	call   80056c <_panic>
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	74 10                	je     802a6b <alloc_block_BF+0x16b>
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a63:	8b 52 04             	mov    0x4(%edx),%edx
  802a66:	89 50 04             	mov    %edx,0x4(%eax)
  802a69:	eb 0b                	jmp    802a76 <alloc_block_BF+0x176>
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 40 04             	mov    0x4(%eax),%eax
  802a71:	a3 30 50 80 00       	mov    %eax,0x805030
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	8b 40 04             	mov    0x4(%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 0f                	je     802a8f <alloc_block_BF+0x18f>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 40 04             	mov    0x4(%eax),%eax
  802a86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a89:	8b 12                	mov    (%edx),%edx
  802a8b:	89 10                	mov    %edx,(%eax)
  802a8d:	eb 0a                	jmp    802a99 <alloc_block_BF+0x199>
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aac:	a1 38 50 80 00       	mov    0x805038,%eax
  802ab1:	48                   	dec    %eax
  802ab2:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802ab7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802aba:	e9 24 04 00 00       	jmp    802ee3 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ac5:	76 13                	jbe    802ada <alloc_block_BF+0x1da>
					{
						internal = 1;
  802ac7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802ace:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802ad4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ad7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802ada:	a1 34 50 80 00       	mov    0x805034,%eax
  802adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae6:	74 07                	je     802aef <alloc_block_BF+0x1ef>
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	eb 05                	jmp    802af4 <alloc_block_BF+0x1f4>
  802aef:	b8 00 00 00 00       	mov    $0x0,%eax
  802af4:	a3 34 50 80 00       	mov    %eax,0x805034
  802af9:	a1 34 50 80 00       	mov    0x805034,%eax
  802afe:	85 c0                	test   %eax,%eax
  802b00:	0f 85 bf fe ff ff    	jne    8029c5 <alloc_block_BF+0xc5>
  802b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0a:	0f 85 b5 fe ff ff    	jne    8029c5 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802b10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b14:	0f 84 26 02 00 00    	je     802d40 <alloc_block_BF+0x440>
  802b1a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b1e:	0f 85 1c 02 00 00    	jne    802d40 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b27:	2b 45 08             	sub    0x8(%ebp),%eax
  802b2a:	83 e8 08             	sub    $0x8,%eax
  802b2d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	8d 50 08             	lea    0x8(%eax),%edx
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	01 d0                	add    %edx,%eax
  802b3b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	83 c0 08             	add    $0x8,%eax
  802b44:	83 ec 04             	sub    $0x4,%esp
  802b47:	6a 01                	push   $0x1
  802b49:	50                   	push   %eax
  802b4a:	ff 75 f0             	pushl  -0x10(%ebp)
  802b4d:	e8 c3 f8 ff ff       	call   802415 <set_block_data>
  802b52:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b58:	8b 40 04             	mov    0x4(%eax),%eax
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	75 68                	jne    802bc7 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802b5f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b63:	75 17                	jne    802b7c <alloc_block_BF+0x27c>
  802b65:	83 ec 04             	sub    $0x4,%esp
  802b68:	68 44 47 80 00       	push   $0x804744
  802b6d:	68 45 01 00 00       	push   $0x145
  802b72:	68 29 47 80 00       	push   $0x804729
  802b77:	e8 f0 d9 ff ff       	call   80056c <_panic>
  802b7c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802b82:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b85:	89 10                	mov    %edx,(%eax)
  802b87:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b8a:	8b 00                	mov    (%eax),%eax
  802b8c:	85 c0                	test   %eax,%eax
  802b8e:	74 0d                	je     802b9d <alloc_block_BF+0x29d>
  802b90:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802b95:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b98:	89 50 04             	mov    %edx,0x4(%eax)
  802b9b:	eb 08                	jmp    802ba5 <alloc_block_BF+0x2a5>
  802b9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb7:	a1 38 50 80 00       	mov    0x805038,%eax
  802bbc:	40                   	inc    %eax
  802bbd:	a3 38 50 80 00       	mov    %eax,0x805038
  802bc2:	e9 dc 00 00 00       	jmp    802ca3 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bca:	8b 00                	mov    (%eax),%eax
  802bcc:	85 c0                	test   %eax,%eax
  802bce:	75 65                	jne    802c35 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802bd0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802bd4:	75 17                	jne    802bed <alloc_block_BF+0x2ed>
  802bd6:	83 ec 04             	sub    $0x4,%esp
  802bd9:	68 78 47 80 00       	push   $0x804778
  802bde:	68 4a 01 00 00       	push   $0x14a
  802be3:	68 29 47 80 00       	push   $0x804729
  802be8:	e8 7f d9 ff ff       	call   80056c <_panic>
  802bed:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802bf3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bf6:	89 50 04             	mov    %edx,0x4(%eax)
  802bf9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bfc:	8b 40 04             	mov    0x4(%eax),%eax
  802bff:	85 c0                	test   %eax,%eax
  802c01:	74 0c                	je     802c0f <alloc_block_BF+0x30f>
  802c03:	a1 30 50 80 00       	mov    0x805030,%eax
  802c08:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c0b:	89 10                	mov    %edx,(%eax)
  802c0d:	eb 08                	jmp    802c17 <alloc_block_BF+0x317>
  802c0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c12:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c1a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c28:	a1 38 50 80 00       	mov    0x805038,%eax
  802c2d:	40                   	inc    %eax
  802c2e:	a3 38 50 80 00       	mov    %eax,0x805038
  802c33:	eb 6e                	jmp    802ca3 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802c35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c39:	74 06                	je     802c41 <alloc_block_BF+0x341>
  802c3b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802c3f:	75 17                	jne    802c58 <alloc_block_BF+0x358>
  802c41:	83 ec 04             	sub    $0x4,%esp
  802c44:	68 9c 47 80 00       	push   $0x80479c
  802c49:	68 4f 01 00 00       	push   $0x14f
  802c4e:	68 29 47 80 00       	push   $0x804729
  802c53:	e8 14 d9 ff ff       	call   80056c <_panic>
  802c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5b:	8b 10                	mov    (%eax),%edx
  802c5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c60:	89 10                	mov    %edx,(%eax)
  802c62:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c65:	8b 00                	mov    (%eax),%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	74 0b                	je     802c76 <alloc_block_BF+0x376>
  802c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c73:	89 50 04             	mov    %edx,0x4(%eax)
  802c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c79:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802c7c:	89 10                	mov    %edx,(%eax)
  802c7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c84:	89 50 04             	mov    %edx,0x4(%eax)
  802c87:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c8a:	8b 00                	mov    (%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	75 08                	jne    802c98 <alloc_block_BF+0x398>
  802c90:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c93:	a3 30 50 80 00       	mov    %eax,0x805030
  802c98:	a1 38 50 80 00       	mov    0x805038,%eax
  802c9d:	40                   	inc    %eax
  802c9e:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802ca3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca7:	75 17                	jne    802cc0 <alloc_block_BF+0x3c0>
  802ca9:	83 ec 04             	sub    $0x4,%esp
  802cac:	68 0b 47 80 00       	push   $0x80470b
  802cb1:	68 51 01 00 00       	push   $0x151
  802cb6:	68 29 47 80 00       	push   $0x804729
  802cbb:	e8 ac d8 ff ff       	call   80056c <_panic>
  802cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc3:	8b 00                	mov    (%eax),%eax
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	74 10                	je     802cd9 <alloc_block_BF+0x3d9>
  802cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccc:	8b 00                	mov    (%eax),%eax
  802cce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd1:	8b 52 04             	mov    0x4(%edx),%edx
  802cd4:	89 50 04             	mov    %edx,0x4(%eax)
  802cd7:	eb 0b                	jmp    802ce4 <alloc_block_BF+0x3e4>
  802cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdc:	8b 40 04             	mov    0x4(%eax),%eax
  802cdf:	a3 30 50 80 00       	mov    %eax,0x805030
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	85 c0                	test   %eax,%eax
  802cec:	74 0f                	je     802cfd <alloc_block_BF+0x3fd>
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 40 04             	mov    0x4(%eax),%eax
  802cf4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf7:	8b 12                	mov    (%edx),%edx
  802cf9:	89 10                	mov    %edx,(%eax)
  802cfb:	eb 0a                	jmp    802d07 <alloc_block_BF+0x407>
  802cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d00:	8b 00                	mov    (%eax),%eax
  802d02:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1a:	a1 38 50 80 00       	mov    0x805038,%eax
  802d1f:	48                   	dec    %eax
  802d20:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802d25:	83 ec 04             	sub    $0x4,%esp
  802d28:	6a 00                	push   $0x0
  802d2a:	ff 75 d0             	pushl  -0x30(%ebp)
  802d2d:	ff 75 cc             	pushl  -0x34(%ebp)
  802d30:	e8 e0 f6 ff ff       	call   802415 <set_block_data>
  802d35:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3b:	e9 a3 01 00 00       	jmp    802ee3 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802d40:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802d44:	0f 85 9d 00 00 00    	jne    802de7 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802d4a:	83 ec 04             	sub    $0x4,%esp
  802d4d:	6a 01                	push   $0x1
  802d4f:	ff 75 ec             	pushl  -0x14(%ebp)
  802d52:	ff 75 f0             	pushl  -0x10(%ebp)
  802d55:	e8 bb f6 ff ff       	call   802415 <set_block_data>
  802d5a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802d5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d61:	75 17                	jne    802d7a <alloc_block_BF+0x47a>
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	68 0b 47 80 00       	push   $0x80470b
  802d6b:	68 58 01 00 00       	push   $0x158
  802d70:	68 29 47 80 00       	push   $0x804729
  802d75:	e8 f2 d7 ff ff       	call   80056c <_panic>
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	74 10                	je     802d93 <alloc_block_BF+0x493>
  802d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8b:	8b 52 04             	mov    0x4(%edx),%edx
  802d8e:	89 50 04             	mov    %edx,0x4(%eax)
  802d91:	eb 0b                	jmp    802d9e <alloc_block_BF+0x49e>
  802d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d96:	8b 40 04             	mov    0x4(%eax),%eax
  802d99:	a3 30 50 80 00       	mov    %eax,0x805030
  802d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da1:	8b 40 04             	mov    0x4(%eax),%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	74 0f                	je     802db7 <alloc_block_BF+0x4b7>
  802da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dab:	8b 40 04             	mov    0x4(%eax),%eax
  802dae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db1:	8b 12                	mov    (%edx),%edx
  802db3:	89 10                	mov    %edx,(%eax)
  802db5:	eb 0a                	jmp    802dc1 <alloc_block_BF+0x4c1>
  802db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dba:	8b 00                	mov    (%eax),%eax
  802dbc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd4:	a1 38 50 80 00       	mov    0x805038,%eax
  802dd9:	48                   	dec    %eax
  802dda:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de2:	e9 fc 00 00 00       	jmp    802ee3 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802de7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dea:	83 c0 08             	add    $0x8,%eax
  802ded:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802df0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802df7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802dfa:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802dfd:	01 d0                	add    %edx,%eax
  802dff:	48                   	dec    %eax
  802e00:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802e03:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e06:	ba 00 00 00 00       	mov    $0x0,%edx
  802e0b:	f7 75 c4             	divl   -0x3c(%ebp)
  802e0e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e11:	29 d0                	sub    %edx,%eax
  802e13:	c1 e8 0c             	shr    $0xc,%eax
  802e16:	83 ec 0c             	sub    $0xc,%esp
  802e19:	50                   	push   %eax
  802e1a:	e8 a4 e7 ff ff       	call   8015c3 <sbrk>
  802e1f:	83 c4 10             	add    $0x10,%esp
  802e22:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802e25:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802e29:	75 0a                	jne    802e35 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e30:	e9 ae 00 00 00       	jmp    802ee3 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802e35:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802e3c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e3f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802e42:	01 d0                	add    %edx,%eax
  802e44:	48                   	dec    %eax
  802e45:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802e48:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e4b:	ba 00 00 00 00       	mov    $0x0,%edx
  802e50:	f7 75 b8             	divl   -0x48(%ebp)
  802e53:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802e56:	29 d0                	sub    %edx,%eax
  802e58:	8d 50 fc             	lea    -0x4(%eax),%edx
  802e5b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802e5e:	01 d0                	add    %edx,%eax
  802e60:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802e65:	a1 40 50 80 00       	mov    0x805040,%eax
  802e6a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802e70:	83 ec 0c             	sub    $0xc,%esp
  802e73:	68 d0 47 80 00       	push   $0x8047d0
  802e78:	e8 ac d9 ff ff       	call   800829 <cprintf>
  802e7d:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802e80:	83 ec 08             	sub    $0x8,%esp
  802e83:	ff 75 bc             	pushl  -0x44(%ebp)
  802e86:	68 d5 47 80 00       	push   $0x8047d5
  802e8b:	e8 99 d9 ff ff       	call   800829 <cprintf>
  802e90:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802e93:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802e9a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802e9d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ea0:	01 d0                	add    %edx,%eax
  802ea2:	48                   	dec    %eax
  802ea3:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ea6:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ea9:	ba 00 00 00 00       	mov    $0x0,%edx
  802eae:	f7 75 b0             	divl   -0x50(%ebp)
  802eb1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802eb4:	29 d0                	sub    %edx,%eax
  802eb6:	83 ec 04             	sub    $0x4,%esp
  802eb9:	6a 01                	push   $0x1
  802ebb:	50                   	push   %eax
  802ebc:	ff 75 bc             	pushl  -0x44(%ebp)
  802ebf:	e8 51 f5 ff ff       	call   802415 <set_block_data>
  802ec4:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802ec7:	83 ec 0c             	sub    $0xc,%esp
  802eca:	ff 75 bc             	pushl  -0x44(%ebp)
  802ecd:	e8 36 04 00 00       	call   803308 <free_block>
  802ed2:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ed5:	83 ec 0c             	sub    $0xc,%esp
  802ed8:	ff 75 08             	pushl  0x8(%ebp)
  802edb:	e8 20 fa ff ff       	call   802900 <alloc_block_BF>
  802ee0:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802ee3:	c9                   	leave  
  802ee4:	c3                   	ret    

00802ee5 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802ee5:	55                   	push   %ebp
  802ee6:	89 e5                	mov    %esp,%ebp
  802ee8:	53                   	push   %ebx
  802ee9:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802eec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ef3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802efa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802efe:	74 1e                	je     802f1e <merging+0x39>
  802f00:	ff 75 08             	pushl  0x8(%ebp)
  802f03:	e8 bc f1 ff ff       	call   8020c4 <get_block_size>
  802f08:	83 c4 04             	add    $0x4,%esp
  802f0b:	89 c2                	mov    %eax,%edx
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	01 d0                	add    %edx,%eax
  802f12:	3b 45 10             	cmp    0x10(%ebp),%eax
  802f15:	75 07                	jne    802f1e <merging+0x39>
		prev_is_free = 1;
  802f17:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802f1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f22:	74 1e                	je     802f42 <merging+0x5d>
  802f24:	ff 75 10             	pushl  0x10(%ebp)
  802f27:	e8 98 f1 ff ff       	call   8020c4 <get_block_size>
  802f2c:	83 c4 04             	add    $0x4,%esp
  802f2f:	89 c2                	mov    %eax,%edx
  802f31:	8b 45 10             	mov    0x10(%ebp),%eax
  802f34:	01 d0                	add    %edx,%eax
  802f36:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f39:	75 07                	jne    802f42 <merging+0x5d>
		next_is_free = 1;
  802f3b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802f42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f46:	0f 84 cc 00 00 00    	je     803018 <merging+0x133>
  802f4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f50:	0f 84 c2 00 00 00    	je     803018 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802f56:	ff 75 08             	pushl  0x8(%ebp)
  802f59:	e8 66 f1 ff ff       	call   8020c4 <get_block_size>
  802f5e:	83 c4 04             	add    $0x4,%esp
  802f61:	89 c3                	mov    %eax,%ebx
  802f63:	ff 75 10             	pushl  0x10(%ebp)
  802f66:	e8 59 f1 ff ff       	call   8020c4 <get_block_size>
  802f6b:	83 c4 04             	add    $0x4,%esp
  802f6e:	01 c3                	add    %eax,%ebx
  802f70:	ff 75 0c             	pushl  0xc(%ebp)
  802f73:	e8 4c f1 ff ff       	call   8020c4 <get_block_size>
  802f78:	83 c4 04             	add    $0x4,%esp
  802f7b:	01 d8                	add    %ebx,%eax
  802f7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f80:	6a 00                	push   $0x0
  802f82:	ff 75 ec             	pushl  -0x14(%ebp)
  802f85:	ff 75 08             	pushl  0x8(%ebp)
  802f88:	e8 88 f4 ff ff       	call   802415 <set_block_data>
  802f8d:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802f90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f94:	75 17                	jne    802fad <merging+0xc8>
  802f96:	83 ec 04             	sub    $0x4,%esp
  802f99:	68 0b 47 80 00       	push   $0x80470b
  802f9e:	68 7d 01 00 00       	push   $0x17d
  802fa3:	68 29 47 80 00       	push   $0x804729
  802fa8:	e8 bf d5 ff ff       	call   80056c <_panic>
  802fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	74 10                	je     802fc6 <merging+0xe1>
  802fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb9:	8b 00                	mov    (%eax),%eax
  802fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fbe:	8b 52 04             	mov    0x4(%edx),%edx
  802fc1:	89 50 04             	mov    %edx,0x4(%eax)
  802fc4:	eb 0b                	jmp    802fd1 <merging+0xec>
  802fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc9:	8b 40 04             	mov    0x4(%eax),%eax
  802fcc:	a3 30 50 80 00       	mov    %eax,0x805030
  802fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd4:	8b 40 04             	mov    0x4(%eax),%eax
  802fd7:	85 c0                	test   %eax,%eax
  802fd9:	74 0f                	je     802fea <merging+0x105>
  802fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fde:	8b 40 04             	mov    0x4(%eax),%eax
  802fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe4:	8b 12                	mov    (%edx),%edx
  802fe6:	89 10                	mov    %edx,(%eax)
  802fe8:	eb 0a                	jmp    802ff4 <merging+0x10f>
  802fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803000:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803007:	a1 38 50 80 00       	mov    0x805038,%eax
  80300c:	48                   	dec    %eax
  80300d:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803012:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803013:	e9 ea 02 00 00       	jmp    803302 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  803018:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301c:	74 3b                	je     803059 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  80301e:	83 ec 0c             	sub    $0xc,%esp
  803021:	ff 75 08             	pushl  0x8(%ebp)
  803024:	e8 9b f0 ff ff       	call   8020c4 <get_block_size>
  803029:	83 c4 10             	add    $0x10,%esp
  80302c:	89 c3                	mov    %eax,%ebx
  80302e:	83 ec 0c             	sub    $0xc,%esp
  803031:	ff 75 10             	pushl  0x10(%ebp)
  803034:	e8 8b f0 ff ff       	call   8020c4 <get_block_size>
  803039:	83 c4 10             	add    $0x10,%esp
  80303c:	01 d8                	add    %ebx,%eax
  80303e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803041:	83 ec 04             	sub    $0x4,%esp
  803044:	6a 00                	push   $0x0
  803046:	ff 75 e8             	pushl  -0x18(%ebp)
  803049:	ff 75 08             	pushl  0x8(%ebp)
  80304c:	e8 c4 f3 ff ff       	call   802415 <set_block_data>
  803051:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803054:	e9 a9 02 00 00       	jmp    803302 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  803059:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80305d:	0f 84 2d 01 00 00    	je     803190 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  803063:	83 ec 0c             	sub    $0xc,%esp
  803066:	ff 75 10             	pushl  0x10(%ebp)
  803069:	e8 56 f0 ff ff       	call   8020c4 <get_block_size>
  80306e:	83 c4 10             	add    $0x10,%esp
  803071:	89 c3                	mov    %eax,%ebx
  803073:	83 ec 0c             	sub    $0xc,%esp
  803076:	ff 75 0c             	pushl  0xc(%ebp)
  803079:	e8 46 f0 ff ff       	call   8020c4 <get_block_size>
  80307e:	83 c4 10             	add    $0x10,%esp
  803081:	01 d8                	add    %ebx,%eax
  803083:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  803086:	83 ec 04             	sub    $0x4,%esp
  803089:	6a 00                	push   $0x0
  80308b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80308e:	ff 75 10             	pushl  0x10(%ebp)
  803091:	e8 7f f3 ff ff       	call   802415 <set_block_data>
  803096:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  803099:	8b 45 10             	mov    0x10(%ebp),%eax
  80309c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80309f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030a3:	74 06                	je     8030ab <merging+0x1c6>
  8030a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030a9:	75 17                	jne    8030c2 <merging+0x1dd>
  8030ab:	83 ec 04             	sub    $0x4,%esp
  8030ae:	68 e4 47 80 00       	push   $0x8047e4
  8030b3:	68 8d 01 00 00       	push   $0x18d
  8030b8:	68 29 47 80 00       	push   $0x804729
  8030bd:	e8 aa d4 ff ff       	call   80056c <_panic>
  8030c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c5:	8b 50 04             	mov    0x4(%eax),%edx
  8030c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030cb:	89 50 04             	mov    %edx,0x4(%eax)
  8030ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030d4:	89 10                	mov    %edx,(%eax)
  8030d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d9:	8b 40 04             	mov    0x4(%eax),%eax
  8030dc:	85 c0                	test   %eax,%eax
  8030de:	74 0d                	je     8030ed <merging+0x208>
  8030e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e3:	8b 40 04             	mov    0x4(%eax),%eax
  8030e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030e9:	89 10                	mov    %edx,(%eax)
  8030eb:	eb 08                	jmp    8030f5 <merging+0x210>
  8030ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030fb:	89 50 04             	mov    %edx,0x4(%eax)
  8030fe:	a1 38 50 80 00       	mov    0x805038,%eax
  803103:	40                   	inc    %eax
  803104:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  803109:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80310d:	75 17                	jne    803126 <merging+0x241>
  80310f:	83 ec 04             	sub    $0x4,%esp
  803112:	68 0b 47 80 00       	push   $0x80470b
  803117:	68 8e 01 00 00       	push   $0x18e
  80311c:	68 29 47 80 00       	push   $0x804729
  803121:	e8 46 d4 ff ff       	call   80056c <_panic>
  803126:	8b 45 0c             	mov    0xc(%ebp),%eax
  803129:	8b 00                	mov    (%eax),%eax
  80312b:	85 c0                	test   %eax,%eax
  80312d:	74 10                	je     80313f <merging+0x25a>
  80312f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803132:	8b 00                	mov    (%eax),%eax
  803134:	8b 55 0c             	mov    0xc(%ebp),%edx
  803137:	8b 52 04             	mov    0x4(%edx),%edx
  80313a:	89 50 04             	mov    %edx,0x4(%eax)
  80313d:	eb 0b                	jmp    80314a <merging+0x265>
  80313f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803142:	8b 40 04             	mov    0x4(%eax),%eax
  803145:	a3 30 50 80 00       	mov    %eax,0x805030
  80314a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80314d:	8b 40 04             	mov    0x4(%eax),%eax
  803150:	85 c0                	test   %eax,%eax
  803152:	74 0f                	je     803163 <merging+0x27e>
  803154:	8b 45 0c             	mov    0xc(%ebp),%eax
  803157:	8b 40 04             	mov    0x4(%eax),%eax
  80315a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80315d:	8b 12                	mov    (%edx),%edx
  80315f:	89 10                	mov    %edx,(%eax)
  803161:	eb 0a                	jmp    80316d <merging+0x288>
  803163:	8b 45 0c             	mov    0xc(%ebp),%eax
  803166:	8b 00                	mov    (%eax),%eax
  803168:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80316d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803176:	8b 45 0c             	mov    0xc(%ebp),%eax
  803179:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803180:	a1 38 50 80 00       	mov    0x805038,%eax
  803185:	48                   	dec    %eax
  803186:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80318b:	e9 72 01 00 00       	jmp    803302 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803190:	8b 45 10             	mov    0x10(%ebp),%eax
  803193:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80319a:	74 79                	je     803215 <merging+0x330>
  80319c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031a0:	74 73                	je     803215 <merging+0x330>
  8031a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a6:	74 06                	je     8031ae <merging+0x2c9>
  8031a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031ac:	75 17                	jne    8031c5 <merging+0x2e0>
  8031ae:	83 ec 04             	sub    $0x4,%esp
  8031b1:	68 9c 47 80 00       	push   $0x80479c
  8031b6:	68 94 01 00 00       	push   $0x194
  8031bb:	68 29 47 80 00       	push   $0x804729
  8031c0:	e8 a7 d3 ff ff       	call   80056c <_panic>
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	8b 10                	mov    (%eax),%edx
  8031ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031cd:	89 10                	mov    %edx,(%eax)
  8031cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031d2:	8b 00                	mov    (%eax),%eax
  8031d4:	85 c0                	test   %eax,%eax
  8031d6:	74 0b                	je     8031e3 <merging+0x2fe>
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	8b 00                	mov    (%eax),%eax
  8031dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e0:	89 50 04             	mov    %edx,0x4(%eax)
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e9:	89 10                	mov    %edx,(%eax)
  8031eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f1:	89 50 04             	mov    %edx,0x4(%eax)
  8031f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	75 08                	jne    803205 <merging+0x320>
  8031fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803200:	a3 30 50 80 00       	mov    %eax,0x805030
  803205:	a1 38 50 80 00       	mov    0x805038,%eax
  80320a:	40                   	inc    %eax
  80320b:	a3 38 50 80 00       	mov    %eax,0x805038
  803210:	e9 ce 00 00 00       	jmp    8032e3 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803215:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803219:	74 65                	je     803280 <merging+0x39b>
  80321b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80321f:	75 17                	jne    803238 <merging+0x353>
  803221:	83 ec 04             	sub    $0x4,%esp
  803224:	68 78 47 80 00       	push   $0x804778
  803229:	68 95 01 00 00       	push   $0x195
  80322e:	68 29 47 80 00       	push   $0x804729
  803233:	e8 34 d3 ff ff       	call   80056c <_panic>
  803238:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80323e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803241:	89 50 04             	mov    %edx,0x4(%eax)
  803244:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803247:	8b 40 04             	mov    0x4(%eax),%eax
  80324a:	85 c0                	test   %eax,%eax
  80324c:	74 0c                	je     80325a <merging+0x375>
  80324e:	a1 30 50 80 00       	mov    0x805030,%eax
  803253:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803256:	89 10                	mov    %edx,(%eax)
  803258:	eb 08                	jmp    803262 <merging+0x37d>
  80325a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803262:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803265:	a3 30 50 80 00       	mov    %eax,0x805030
  80326a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80326d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803273:	a1 38 50 80 00       	mov    0x805038,%eax
  803278:	40                   	inc    %eax
  803279:	a3 38 50 80 00       	mov    %eax,0x805038
  80327e:	eb 63                	jmp    8032e3 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803280:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803284:	75 17                	jne    80329d <merging+0x3b8>
  803286:	83 ec 04             	sub    $0x4,%esp
  803289:	68 44 47 80 00       	push   $0x804744
  80328e:	68 98 01 00 00       	push   $0x198
  803293:	68 29 47 80 00       	push   $0x804729
  803298:	e8 cf d2 ff ff       	call   80056c <_panic>
  80329d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a6:	89 10                	mov    %edx,(%eax)
  8032a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ab:	8b 00                	mov    (%eax),%eax
  8032ad:	85 c0                	test   %eax,%eax
  8032af:	74 0d                	je     8032be <merging+0x3d9>
  8032b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032b9:	89 50 04             	mov    %edx,0x4(%eax)
  8032bc:	eb 08                	jmp    8032c6 <merging+0x3e1>
  8032be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c1:	a3 30 50 80 00       	mov    %eax,0x805030
  8032c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d8:	a1 38 50 80 00       	mov    0x805038,%eax
  8032dd:	40                   	inc    %eax
  8032de:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8032e3:	83 ec 0c             	sub    $0xc,%esp
  8032e6:	ff 75 10             	pushl  0x10(%ebp)
  8032e9:	e8 d6 ed ff ff       	call   8020c4 <get_block_size>
  8032ee:	83 c4 10             	add    $0x10,%esp
  8032f1:	83 ec 04             	sub    $0x4,%esp
  8032f4:	6a 00                	push   $0x0
  8032f6:	50                   	push   %eax
  8032f7:	ff 75 10             	pushl  0x10(%ebp)
  8032fa:	e8 16 f1 ff ff       	call   802415 <set_block_data>
  8032ff:	83 c4 10             	add    $0x10,%esp
	}
}
  803302:	90                   	nop
  803303:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803306:	c9                   	leave  
  803307:	c3                   	ret    

00803308 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803308:	55                   	push   %ebp
  803309:	89 e5                	mov    %esp,%ebp
  80330b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80330e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803313:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803316:	a1 30 50 80 00       	mov    0x805030,%eax
  80331b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80331e:	73 1b                	jae    80333b <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803320:	a1 30 50 80 00       	mov    0x805030,%eax
  803325:	83 ec 04             	sub    $0x4,%esp
  803328:	ff 75 08             	pushl  0x8(%ebp)
  80332b:	6a 00                	push   $0x0
  80332d:	50                   	push   %eax
  80332e:	e8 b2 fb ff ff       	call   802ee5 <merging>
  803333:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803336:	e9 8b 00 00 00       	jmp    8033c6 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80333b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803340:	3b 45 08             	cmp    0x8(%ebp),%eax
  803343:	76 18                	jbe    80335d <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803345:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80334a:	83 ec 04             	sub    $0x4,%esp
  80334d:	ff 75 08             	pushl  0x8(%ebp)
  803350:	50                   	push   %eax
  803351:	6a 00                	push   $0x0
  803353:	e8 8d fb ff ff       	call   802ee5 <merging>
  803358:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80335b:	eb 69                	jmp    8033c6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80335d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803365:	eb 39                	jmp    8033a0 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80336d:	73 29                	jae    803398 <free_block+0x90>
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	8b 00                	mov    (%eax),%eax
  803374:	3b 45 08             	cmp    0x8(%ebp),%eax
  803377:	76 1f                	jbe    803398 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337c:	8b 00                	mov    (%eax),%eax
  80337e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803381:	83 ec 04             	sub    $0x4,%esp
  803384:	ff 75 08             	pushl  0x8(%ebp)
  803387:	ff 75 f0             	pushl  -0x10(%ebp)
  80338a:	ff 75 f4             	pushl  -0xc(%ebp)
  80338d:	e8 53 fb ff ff       	call   802ee5 <merging>
  803392:	83 c4 10             	add    $0x10,%esp
			break;
  803395:	90                   	nop
		}
	}
}
  803396:	eb 2e                	jmp    8033c6 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803398:	a1 34 50 80 00       	mov    0x805034,%eax
  80339d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a4:	74 07                	je     8033ad <free_block+0xa5>
  8033a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a9:	8b 00                	mov    (%eax),%eax
  8033ab:	eb 05                	jmp    8033b2 <free_block+0xaa>
  8033ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b2:	a3 34 50 80 00       	mov    %eax,0x805034
  8033b7:	a1 34 50 80 00       	mov    0x805034,%eax
  8033bc:	85 c0                	test   %eax,%eax
  8033be:	75 a7                	jne    803367 <free_block+0x5f>
  8033c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c4:	75 a1                	jne    803367 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8033c6:	90                   	nop
  8033c7:	c9                   	leave  
  8033c8:	c3                   	ret    

008033c9 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8033c9:	55                   	push   %ebp
  8033ca:	89 e5                	mov    %esp,%ebp
  8033cc:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8033cf:	ff 75 08             	pushl  0x8(%ebp)
  8033d2:	e8 ed ec ff ff       	call   8020c4 <get_block_size>
  8033d7:	83 c4 04             	add    $0x4,%esp
  8033da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8033dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8033e4:	eb 17                	jmp    8033fd <copy_data+0x34>
  8033e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8033e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ec:	01 c2                	add    %eax,%edx
  8033ee:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	01 c8                	add    %ecx,%eax
  8033f6:	8a 00                	mov    (%eax),%al
  8033f8:	88 02                	mov    %al,(%edx)
  8033fa:	ff 45 fc             	incl   -0x4(%ebp)
  8033fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803400:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803403:	72 e1                	jb     8033e6 <copy_data+0x1d>
}
  803405:	90                   	nop
  803406:	c9                   	leave  
  803407:	c3                   	ret    

00803408 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803408:	55                   	push   %ebp
  803409:	89 e5                	mov    %esp,%ebp
  80340b:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80340e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803412:	75 23                	jne    803437 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803418:	74 13                	je     80342d <realloc_block_FF+0x25>
  80341a:	83 ec 0c             	sub    $0xc,%esp
  80341d:	ff 75 0c             	pushl  0xc(%ebp)
  803420:	e8 1f f0 ff ff       	call   802444 <alloc_block_FF>
  803425:	83 c4 10             	add    $0x10,%esp
  803428:	e9 f4 06 00 00       	jmp    803b21 <realloc_block_FF+0x719>
		return NULL;
  80342d:	b8 00 00 00 00       	mov    $0x0,%eax
  803432:	e9 ea 06 00 00       	jmp    803b21 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803437:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80343b:	75 18                	jne    803455 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80343d:	83 ec 0c             	sub    $0xc,%esp
  803440:	ff 75 08             	pushl  0x8(%ebp)
  803443:	e8 c0 fe ff ff       	call   803308 <free_block>
  803448:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80344b:	b8 00 00 00 00       	mov    $0x0,%eax
  803450:	e9 cc 06 00 00       	jmp    803b21 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803455:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803459:	77 07                	ja     803462 <realloc_block_FF+0x5a>
  80345b:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803462:	8b 45 0c             	mov    0xc(%ebp),%eax
  803465:	83 e0 01             	and    $0x1,%eax
  803468:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80346b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346e:	83 c0 08             	add    $0x8,%eax
  803471:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803474:	83 ec 0c             	sub    $0xc,%esp
  803477:	ff 75 08             	pushl  0x8(%ebp)
  80347a:	e8 45 ec ff ff       	call   8020c4 <get_block_size>
  80347f:	83 c4 10             	add    $0x10,%esp
  803482:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803485:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803488:	83 e8 08             	sub    $0x8,%eax
  80348b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80348e:	8b 45 08             	mov    0x8(%ebp),%eax
  803491:	83 e8 04             	sub    $0x4,%eax
  803494:	8b 00                	mov    (%eax),%eax
  803496:	83 e0 fe             	and    $0xfffffffe,%eax
  803499:	89 c2                	mov    %eax,%edx
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	01 d0                	add    %edx,%eax
  8034a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8034a3:	83 ec 0c             	sub    $0xc,%esp
  8034a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034a9:	e8 16 ec ff ff       	call   8020c4 <get_block_size>
  8034ae:	83 c4 10             	add    $0x10,%esp
  8034b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8034b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b7:	83 e8 08             	sub    $0x8,%eax
  8034ba:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8034bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034c3:	75 08                	jne    8034cd <realloc_block_FF+0xc5>
	{
		 return va;
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	e9 54 06 00 00       	jmp    803b21 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8034cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034d3:	0f 83 e5 03 00 00    	jae    8038be <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8034d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034dc:	2b 45 0c             	sub    0xc(%ebp),%eax
  8034df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8034e2:	83 ec 0c             	sub    $0xc,%esp
  8034e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034e8:	e8 f0 eb ff ff       	call   8020dd <is_free_block>
  8034ed:	83 c4 10             	add    $0x10,%esp
  8034f0:	84 c0                	test   %al,%al
  8034f2:	0f 84 3b 01 00 00    	je     803633 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8034f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034fe:	01 d0                	add    %edx,%eax
  803500:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803503:	83 ec 04             	sub    $0x4,%esp
  803506:	6a 01                	push   $0x1
  803508:	ff 75 f0             	pushl  -0x10(%ebp)
  80350b:	ff 75 08             	pushl  0x8(%ebp)
  80350e:	e8 02 ef ff ff       	call   802415 <set_block_data>
  803513:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803516:	8b 45 08             	mov    0x8(%ebp),%eax
  803519:	83 e8 04             	sub    $0x4,%eax
  80351c:	8b 00                	mov    (%eax),%eax
  80351e:	83 e0 fe             	and    $0xfffffffe,%eax
  803521:	89 c2                	mov    %eax,%edx
  803523:	8b 45 08             	mov    0x8(%ebp),%eax
  803526:	01 d0                	add    %edx,%eax
  803528:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80352b:	83 ec 04             	sub    $0x4,%esp
  80352e:	6a 00                	push   $0x0
  803530:	ff 75 cc             	pushl  -0x34(%ebp)
  803533:	ff 75 c8             	pushl  -0x38(%ebp)
  803536:	e8 da ee ff ff       	call   802415 <set_block_data>
  80353b:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80353e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803542:	74 06                	je     80354a <realloc_block_FF+0x142>
  803544:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803548:	75 17                	jne    803561 <realloc_block_FF+0x159>
  80354a:	83 ec 04             	sub    $0x4,%esp
  80354d:	68 9c 47 80 00       	push   $0x80479c
  803552:	68 f6 01 00 00       	push   $0x1f6
  803557:	68 29 47 80 00       	push   $0x804729
  80355c:	e8 0b d0 ff ff       	call   80056c <_panic>
  803561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803564:	8b 10                	mov    (%eax),%edx
  803566:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803569:	89 10                	mov    %edx,(%eax)
  80356b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	85 c0                	test   %eax,%eax
  803572:	74 0b                	je     80357f <realloc_block_FF+0x177>
  803574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803577:	8b 00                	mov    (%eax),%eax
  803579:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80357c:	89 50 04             	mov    %edx,0x4(%eax)
  80357f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803582:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803585:	89 10                	mov    %edx,(%eax)
  803587:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80358a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80358d:	89 50 04             	mov    %edx,0x4(%eax)
  803590:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	85 c0                	test   %eax,%eax
  803597:	75 08                	jne    8035a1 <realloc_block_FF+0x199>
  803599:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80359c:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8035a6:	40                   	inc    %eax
  8035a7:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035b0:	75 17                	jne    8035c9 <realloc_block_FF+0x1c1>
  8035b2:	83 ec 04             	sub    $0x4,%esp
  8035b5:	68 0b 47 80 00       	push   $0x80470b
  8035ba:	68 f7 01 00 00       	push   $0x1f7
  8035bf:	68 29 47 80 00       	push   $0x804729
  8035c4:	e8 a3 cf ff ff       	call   80056c <_panic>
  8035c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035cc:	8b 00                	mov    (%eax),%eax
  8035ce:	85 c0                	test   %eax,%eax
  8035d0:	74 10                	je     8035e2 <realloc_block_FF+0x1da>
  8035d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d5:	8b 00                	mov    (%eax),%eax
  8035d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035da:	8b 52 04             	mov    0x4(%edx),%edx
  8035dd:	89 50 04             	mov    %edx,0x4(%eax)
  8035e0:	eb 0b                	jmp    8035ed <realloc_block_FF+0x1e5>
  8035e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e5:	8b 40 04             	mov    0x4(%eax),%eax
  8035e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8035ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f0:	8b 40 04             	mov    0x4(%eax),%eax
  8035f3:	85 c0                	test   %eax,%eax
  8035f5:	74 0f                	je     803606 <realloc_block_FF+0x1fe>
  8035f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fa:	8b 40 04             	mov    0x4(%eax),%eax
  8035fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803600:	8b 12                	mov    (%edx),%edx
  803602:	89 10                	mov    %edx,(%eax)
  803604:	eb 0a                	jmp    803610 <realloc_block_FF+0x208>
  803606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803609:	8b 00                	mov    (%eax),%eax
  80360b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803613:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803623:	a1 38 50 80 00       	mov    0x805038,%eax
  803628:	48                   	dec    %eax
  803629:	a3 38 50 80 00       	mov    %eax,0x805038
  80362e:	e9 83 02 00 00       	jmp    8038b6 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803633:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803637:	0f 86 69 02 00 00    	jbe    8038a6 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80363d:	83 ec 04             	sub    $0x4,%esp
  803640:	6a 01                	push   $0x1
  803642:	ff 75 f0             	pushl  -0x10(%ebp)
  803645:	ff 75 08             	pushl  0x8(%ebp)
  803648:	e8 c8 ed ff ff       	call   802415 <set_block_data>
  80364d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803650:	8b 45 08             	mov    0x8(%ebp),%eax
  803653:	83 e8 04             	sub    $0x4,%eax
  803656:	8b 00                	mov    (%eax),%eax
  803658:	83 e0 fe             	and    $0xfffffffe,%eax
  80365b:	89 c2                	mov    %eax,%edx
  80365d:	8b 45 08             	mov    0x8(%ebp),%eax
  803660:	01 d0                	add    %edx,%eax
  803662:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803665:	a1 38 50 80 00       	mov    0x805038,%eax
  80366a:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80366d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803671:	75 68                	jne    8036db <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803673:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803677:	75 17                	jne    803690 <realloc_block_FF+0x288>
  803679:	83 ec 04             	sub    $0x4,%esp
  80367c:	68 44 47 80 00       	push   $0x804744
  803681:	68 06 02 00 00       	push   $0x206
  803686:	68 29 47 80 00       	push   $0x804729
  80368b:	e8 dc ce ff ff       	call   80056c <_panic>
  803690:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803696:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803699:	89 10                	mov    %edx,(%eax)
  80369b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80369e:	8b 00                	mov    (%eax),%eax
  8036a0:	85 c0                	test   %eax,%eax
  8036a2:	74 0d                	je     8036b1 <realloc_block_FF+0x2a9>
  8036a4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036ac:	89 50 04             	mov    %edx,0x4(%eax)
  8036af:	eb 08                	jmp    8036b9 <realloc_block_FF+0x2b1>
  8036b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8036b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8036d0:	40                   	inc    %eax
  8036d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8036d6:	e9 b0 01 00 00       	jmp    80388b <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8036db:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8036e0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036e3:	76 68                	jbe    80374d <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8036e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036e9:	75 17                	jne    803702 <realloc_block_FF+0x2fa>
  8036eb:	83 ec 04             	sub    $0x4,%esp
  8036ee:	68 44 47 80 00       	push   $0x804744
  8036f3:	68 0b 02 00 00       	push   $0x20b
  8036f8:	68 29 47 80 00       	push   $0x804729
  8036fd:	e8 6a ce ff ff       	call   80056c <_panic>
  803702:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803708:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80370b:	89 10                	mov    %edx,(%eax)
  80370d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803710:	8b 00                	mov    (%eax),%eax
  803712:	85 c0                	test   %eax,%eax
  803714:	74 0d                	je     803723 <realloc_block_FF+0x31b>
  803716:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80371b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80371e:	89 50 04             	mov    %edx,0x4(%eax)
  803721:	eb 08                	jmp    80372b <realloc_block_FF+0x323>
  803723:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803726:	a3 30 50 80 00       	mov    %eax,0x805030
  80372b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80372e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803733:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803736:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373d:	a1 38 50 80 00       	mov    0x805038,%eax
  803742:	40                   	inc    %eax
  803743:	a3 38 50 80 00       	mov    %eax,0x805038
  803748:	e9 3e 01 00 00       	jmp    80388b <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80374d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803752:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803755:	73 68                	jae    8037bf <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803757:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80375b:	75 17                	jne    803774 <realloc_block_FF+0x36c>
  80375d:	83 ec 04             	sub    $0x4,%esp
  803760:	68 78 47 80 00       	push   $0x804778
  803765:	68 10 02 00 00       	push   $0x210
  80376a:	68 29 47 80 00       	push   $0x804729
  80376f:	e8 f8 cd ff ff       	call   80056c <_panic>
  803774:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80377a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80377d:	89 50 04             	mov    %edx,0x4(%eax)
  803780:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803783:	8b 40 04             	mov    0x4(%eax),%eax
  803786:	85 c0                	test   %eax,%eax
  803788:	74 0c                	je     803796 <realloc_block_FF+0x38e>
  80378a:	a1 30 50 80 00       	mov    0x805030,%eax
  80378f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803792:	89 10                	mov    %edx,(%eax)
  803794:	eb 08                	jmp    80379e <realloc_block_FF+0x396>
  803796:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803799:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80379e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8037a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037af:	a1 38 50 80 00       	mov    0x805038,%eax
  8037b4:	40                   	inc    %eax
  8037b5:	a3 38 50 80 00       	mov    %eax,0x805038
  8037ba:	e9 cc 00 00 00       	jmp    80388b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8037bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8037c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8037cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037ce:	e9 8a 00 00 00       	jmp    80385d <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8037d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037d9:	73 7a                	jae    803855 <realloc_block_FF+0x44d>
  8037db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037de:	8b 00                	mov    (%eax),%eax
  8037e0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8037e3:	73 70                	jae    803855 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8037e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e9:	74 06                	je     8037f1 <realloc_block_FF+0x3e9>
  8037eb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8037ef:	75 17                	jne    803808 <realloc_block_FF+0x400>
  8037f1:	83 ec 04             	sub    $0x4,%esp
  8037f4:	68 9c 47 80 00       	push   $0x80479c
  8037f9:	68 1a 02 00 00       	push   $0x21a
  8037fe:	68 29 47 80 00       	push   $0x804729
  803803:	e8 64 cd ff ff       	call   80056c <_panic>
  803808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380b:	8b 10                	mov    (%eax),%edx
  80380d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803810:	89 10                	mov    %edx,(%eax)
  803812:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803815:	8b 00                	mov    (%eax),%eax
  803817:	85 c0                	test   %eax,%eax
  803819:	74 0b                	je     803826 <realloc_block_FF+0x41e>
  80381b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381e:	8b 00                	mov    (%eax),%eax
  803820:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803823:	89 50 04             	mov    %edx,0x4(%eax)
  803826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803829:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80382c:	89 10                	mov    %edx,(%eax)
  80382e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803831:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803834:	89 50 04             	mov    %edx,0x4(%eax)
  803837:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80383a:	8b 00                	mov    (%eax),%eax
  80383c:	85 c0                	test   %eax,%eax
  80383e:	75 08                	jne    803848 <realloc_block_FF+0x440>
  803840:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803843:	a3 30 50 80 00       	mov    %eax,0x805030
  803848:	a1 38 50 80 00       	mov    0x805038,%eax
  80384d:	40                   	inc    %eax
  80384e:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803853:	eb 36                	jmp    80388b <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803855:	a1 34 50 80 00       	mov    0x805034,%eax
  80385a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80385d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803861:	74 07                	je     80386a <realloc_block_FF+0x462>
  803863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803866:	8b 00                	mov    (%eax),%eax
  803868:	eb 05                	jmp    80386f <realloc_block_FF+0x467>
  80386a:	b8 00 00 00 00       	mov    $0x0,%eax
  80386f:	a3 34 50 80 00       	mov    %eax,0x805034
  803874:	a1 34 50 80 00       	mov    0x805034,%eax
  803879:	85 c0                	test   %eax,%eax
  80387b:	0f 85 52 ff ff ff    	jne    8037d3 <realloc_block_FF+0x3cb>
  803881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803885:	0f 85 48 ff ff ff    	jne    8037d3 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80388b:	83 ec 04             	sub    $0x4,%esp
  80388e:	6a 00                	push   $0x0
  803890:	ff 75 d8             	pushl  -0x28(%ebp)
  803893:	ff 75 d4             	pushl  -0x2c(%ebp)
  803896:	e8 7a eb ff ff       	call   802415 <set_block_data>
  80389b:	83 c4 10             	add    $0x10,%esp
				return va;
  80389e:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a1:	e9 7b 02 00 00       	jmp    803b21 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8038a6:	83 ec 0c             	sub    $0xc,%esp
  8038a9:	68 19 48 80 00       	push   $0x804819
  8038ae:	e8 76 cf ff ff       	call   800829 <cprintf>
  8038b3:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8038b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b9:	e9 63 02 00 00       	jmp    803b21 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8038be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038c1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038c4:	0f 86 4d 02 00 00    	jbe    803b17 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8038ca:	83 ec 0c             	sub    $0xc,%esp
  8038cd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8038d0:	e8 08 e8 ff ff       	call   8020dd <is_free_block>
  8038d5:	83 c4 10             	add    $0x10,%esp
  8038d8:	84 c0                	test   %al,%al
  8038da:	0f 84 37 02 00 00    	je     803b17 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8038e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e3:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8038e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8038e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8038ef:	76 38                	jbe    803929 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8038f1:	83 ec 0c             	sub    $0xc,%esp
  8038f4:	ff 75 08             	pushl  0x8(%ebp)
  8038f7:	e8 0c fa ff ff       	call   803308 <free_block>
  8038fc:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8038ff:	83 ec 0c             	sub    $0xc,%esp
  803902:	ff 75 0c             	pushl  0xc(%ebp)
  803905:	e8 3a eb ff ff       	call   802444 <alloc_block_FF>
  80390a:	83 c4 10             	add    $0x10,%esp
  80390d:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803910:	83 ec 08             	sub    $0x8,%esp
  803913:	ff 75 c0             	pushl  -0x40(%ebp)
  803916:	ff 75 08             	pushl  0x8(%ebp)
  803919:	e8 ab fa ff ff       	call   8033c9 <copy_data>
  80391e:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803921:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803924:	e9 f8 01 00 00       	jmp    803b21 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80392c:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80392f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803932:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803936:	0f 87 a0 00 00 00    	ja     8039dc <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80393c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803940:	75 17                	jne    803959 <realloc_block_FF+0x551>
  803942:	83 ec 04             	sub    $0x4,%esp
  803945:	68 0b 47 80 00       	push   $0x80470b
  80394a:	68 38 02 00 00       	push   $0x238
  80394f:	68 29 47 80 00       	push   $0x804729
  803954:	e8 13 cc ff ff       	call   80056c <_panic>
  803959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395c:	8b 00                	mov    (%eax),%eax
  80395e:	85 c0                	test   %eax,%eax
  803960:	74 10                	je     803972 <realloc_block_FF+0x56a>
  803962:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803965:	8b 00                	mov    (%eax),%eax
  803967:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80396a:	8b 52 04             	mov    0x4(%edx),%edx
  80396d:	89 50 04             	mov    %edx,0x4(%eax)
  803970:	eb 0b                	jmp    80397d <realloc_block_FF+0x575>
  803972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803975:	8b 40 04             	mov    0x4(%eax),%eax
  803978:	a3 30 50 80 00       	mov    %eax,0x805030
  80397d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803980:	8b 40 04             	mov    0x4(%eax),%eax
  803983:	85 c0                	test   %eax,%eax
  803985:	74 0f                	je     803996 <realloc_block_FF+0x58e>
  803987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398a:	8b 40 04             	mov    0x4(%eax),%eax
  80398d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803990:	8b 12                	mov    (%edx),%edx
  803992:	89 10                	mov    %edx,(%eax)
  803994:	eb 0a                	jmp    8039a0 <realloc_block_FF+0x598>
  803996:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803999:	8b 00                	mov    (%eax),%eax
  80399b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8039a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8039b8:	48                   	dec    %eax
  8039b9:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8039be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039c4:	01 d0                	add    %edx,%eax
  8039c6:	83 ec 04             	sub    $0x4,%esp
  8039c9:	6a 01                	push   $0x1
  8039cb:	50                   	push   %eax
  8039cc:	ff 75 08             	pushl  0x8(%ebp)
  8039cf:	e8 41 ea ff ff       	call   802415 <set_block_data>
  8039d4:	83 c4 10             	add    $0x10,%esp
  8039d7:	e9 36 01 00 00       	jmp    803b12 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8039dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8039df:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039e2:	01 d0                	add    %edx,%eax
  8039e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8039e7:	83 ec 04             	sub    $0x4,%esp
  8039ea:	6a 01                	push   $0x1
  8039ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8039ef:	ff 75 08             	pushl  0x8(%ebp)
  8039f2:	e8 1e ea ff ff       	call   802415 <set_block_data>
  8039f7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8039fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fd:	83 e8 04             	sub    $0x4,%eax
  803a00:	8b 00                	mov    (%eax),%eax
  803a02:	83 e0 fe             	and    $0xfffffffe,%eax
  803a05:	89 c2                	mov    %eax,%edx
  803a07:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0a:	01 d0                	add    %edx,%eax
  803a0c:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803a0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a13:	74 06                	je     803a1b <realloc_block_FF+0x613>
  803a15:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803a19:	75 17                	jne    803a32 <realloc_block_FF+0x62a>
  803a1b:	83 ec 04             	sub    $0x4,%esp
  803a1e:	68 9c 47 80 00       	push   $0x80479c
  803a23:	68 44 02 00 00       	push   $0x244
  803a28:	68 29 47 80 00       	push   $0x804729
  803a2d:	e8 3a cb ff ff       	call   80056c <_panic>
  803a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a35:	8b 10                	mov    (%eax),%edx
  803a37:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a3a:	89 10                	mov    %edx,(%eax)
  803a3c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a3f:	8b 00                	mov    (%eax),%eax
  803a41:	85 c0                	test   %eax,%eax
  803a43:	74 0b                	je     803a50 <realloc_block_FF+0x648>
  803a45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a48:	8b 00                	mov    (%eax),%eax
  803a4a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a4d:	89 50 04             	mov    %edx,0x4(%eax)
  803a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a53:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803a56:	89 10                	mov    %edx,(%eax)
  803a58:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a5e:	89 50 04             	mov    %edx,0x4(%eax)
  803a61:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a64:	8b 00                	mov    (%eax),%eax
  803a66:	85 c0                	test   %eax,%eax
  803a68:	75 08                	jne    803a72 <realloc_block_FF+0x66a>
  803a6a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803a6d:	a3 30 50 80 00       	mov    %eax,0x805030
  803a72:	a1 38 50 80 00       	mov    0x805038,%eax
  803a77:	40                   	inc    %eax
  803a78:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a81:	75 17                	jne    803a9a <realloc_block_FF+0x692>
  803a83:	83 ec 04             	sub    $0x4,%esp
  803a86:	68 0b 47 80 00       	push   $0x80470b
  803a8b:	68 45 02 00 00       	push   $0x245
  803a90:	68 29 47 80 00       	push   $0x804729
  803a95:	e8 d2 ca ff ff       	call   80056c <_panic>
  803a9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9d:	8b 00                	mov    (%eax),%eax
  803a9f:	85 c0                	test   %eax,%eax
  803aa1:	74 10                	je     803ab3 <realloc_block_FF+0x6ab>
  803aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa6:	8b 00                	mov    (%eax),%eax
  803aa8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aab:	8b 52 04             	mov    0x4(%edx),%edx
  803aae:	89 50 04             	mov    %edx,0x4(%eax)
  803ab1:	eb 0b                	jmp    803abe <realloc_block_FF+0x6b6>
  803ab3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab6:	8b 40 04             	mov    0x4(%eax),%eax
  803ab9:	a3 30 50 80 00       	mov    %eax,0x805030
  803abe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac1:	8b 40 04             	mov    0x4(%eax),%eax
  803ac4:	85 c0                	test   %eax,%eax
  803ac6:	74 0f                	je     803ad7 <realloc_block_FF+0x6cf>
  803ac8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803acb:	8b 40 04             	mov    0x4(%eax),%eax
  803ace:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ad1:	8b 12                	mov    (%edx),%edx
  803ad3:	89 10                	mov    %edx,(%eax)
  803ad5:	eb 0a                	jmp    803ae1 <realloc_block_FF+0x6d9>
  803ad7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ada:	8b 00                	mov    (%eax),%eax
  803adc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803ae1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ae4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af4:	a1 38 50 80 00       	mov    0x805038,%eax
  803af9:	48                   	dec    %eax
  803afa:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803aff:	83 ec 04             	sub    $0x4,%esp
  803b02:	6a 00                	push   $0x0
  803b04:	ff 75 bc             	pushl  -0x44(%ebp)
  803b07:	ff 75 b8             	pushl  -0x48(%ebp)
  803b0a:	e8 06 e9 ff ff       	call   802415 <set_block_data>
  803b0f:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803b12:	8b 45 08             	mov    0x8(%ebp),%eax
  803b15:	eb 0a                	jmp    803b21 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803b17:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803b1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803b21:	c9                   	leave  
  803b22:	c3                   	ret    

00803b23 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803b23:	55                   	push   %ebp
  803b24:	89 e5                	mov    %esp,%ebp
  803b26:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803b29:	83 ec 04             	sub    $0x4,%esp
  803b2c:	68 20 48 80 00       	push   $0x804820
  803b31:	68 58 02 00 00       	push   $0x258
  803b36:	68 29 47 80 00       	push   $0x804729
  803b3b:	e8 2c ca ff ff       	call   80056c <_panic>

00803b40 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803b40:	55                   	push   %ebp
  803b41:	89 e5                	mov    %esp,%ebp
  803b43:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803b46:	83 ec 04             	sub    $0x4,%esp
  803b49:	68 48 48 80 00       	push   $0x804848
  803b4e:	68 61 02 00 00       	push   $0x261
  803b53:	68 29 47 80 00       	push   $0x804729
  803b58:	e8 0f ca ff ff       	call   80056c <_panic>
  803b5d:	66 90                	xchg   %ax,%ax
  803b5f:	90                   	nop

00803b60 <__udivdi3>:
  803b60:	55                   	push   %ebp
  803b61:	57                   	push   %edi
  803b62:	56                   	push   %esi
  803b63:	53                   	push   %ebx
  803b64:	83 ec 1c             	sub    $0x1c,%esp
  803b67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b77:	89 ca                	mov    %ecx,%edx
  803b79:	89 f8                	mov    %edi,%eax
  803b7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b7f:	85 f6                	test   %esi,%esi
  803b81:	75 2d                	jne    803bb0 <__udivdi3+0x50>
  803b83:	39 cf                	cmp    %ecx,%edi
  803b85:	77 65                	ja     803bec <__udivdi3+0x8c>
  803b87:	89 fd                	mov    %edi,%ebp
  803b89:	85 ff                	test   %edi,%edi
  803b8b:	75 0b                	jne    803b98 <__udivdi3+0x38>
  803b8d:	b8 01 00 00 00       	mov    $0x1,%eax
  803b92:	31 d2                	xor    %edx,%edx
  803b94:	f7 f7                	div    %edi
  803b96:	89 c5                	mov    %eax,%ebp
  803b98:	31 d2                	xor    %edx,%edx
  803b9a:	89 c8                	mov    %ecx,%eax
  803b9c:	f7 f5                	div    %ebp
  803b9e:	89 c1                	mov    %eax,%ecx
  803ba0:	89 d8                	mov    %ebx,%eax
  803ba2:	f7 f5                	div    %ebp
  803ba4:	89 cf                	mov    %ecx,%edi
  803ba6:	89 fa                	mov    %edi,%edx
  803ba8:	83 c4 1c             	add    $0x1c,%esp
  803bab:	5b                   	pop    %ebx
  803bac:	5e                   	pop    %esi
  803bad:	5f                   	pop    %edi
  803bae:	5d                   	pop    %ebp
  803baf:	c3                   	ret    
  803bb0:	39 ce                	cmp    %ecx,%esi
  803bb2:	77 28                	ja     803bdc <__udivdi3+0x7c>
  803bb4:	0f bd fe             	bsr    %esi,%edi
  803bb7:	83 f7 1f             	xor    $0x1f,%edi
  803bba:	75 40                	jne    803bfc <__udivdi3+0x9c>
  803bbc:	39 ce                	cmp    %ecx,%esi
  803bbe:	72 0a                	jb     803bca <__udivdi3+0x6a>
  803bc0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bc4:	0f 87 9e 00 00 00    	ja     803c68 <__udivdi3+0x108>
  803bca:	b8 01 00 00 00       	mov    $0x1,%eax
  803bcf:	89 fa                	mov    %edi,%edx
  803bd1:	83 c4 1c             	add    $0x1c,%esp
  803bd4:	5b                   	pop    %ebx
  803bd5:	5e                   	pop    %esi
  803bd6:	5f                   	pop    %edi
  803bd7:	5d                   	pop    %ebp
  803bd8:	c3                   	ret    
  803bd9:	8d 76 00             	lea    0x0(%esi),%esi
  803bdc:	31 ff                	xor    %edi,%edi
  803bde:	31 c0                	xor    %eax,%eax
  803be0:	89 fa                	mov    %edi,%edx
  803be2:	83 c4 1c             	add    $0x1c,%esp
  803be5:	5b                   	pop    %ebx
  803be6:	5e                   	pop    %esi
  803be7:	5f                   	pop    %edi
  803be8:	5d                   	pop    %ebp
  803be9:	c3                   	ret    
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	89 d8                	mov    %ebx,%eax
  803bee:	f7 f7                	div    %edi
  803bf0:	31 ff                	xor    %edi,%edi
  803bf2:	89 fa                	mov    %edi,%edx
  803bf4:	83 c4 1c             	add    $0x1c,%esp
  803bf7:	5b                   	pop    %ebx
  803bf8:	5e                   	pop    %esi
  803bf9:	5f                   	pop    %edi
  803bfa:	5d                   	pop    %ebp
  803bfb:	c3                   	ret    
  803bfc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c01:	89 eb                	mov    %ebp,%ebx
  803c03:	29 fb                	sub    %edi,%ebx
  803c05:	89 f9                	mov    %edi,%ecx
  803c07:	d3 e6                	shl    %cl,%esi
  803c09:	89 c5                	mov    %eax,%ebp
  803c0b:	88 d9                	mov    %bl,%cl
  803c0d:	d3 ed                	shr    %cl,%ebp
  803c0f:	89 e9                	mov    %ebp,%ecx
  803c11:	09 f1                	or     %esi,%ecx
  803c13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c17:	89 f9                	mov    %edi,%ecx
  803c19:	d3 e0                	shl    %cl,%eax
  803c1b:	89 c5                	mov    %eax,%ebp
  803c1d:	89 d6                	mov    %edx,%esi
  803c1f:	88 d9                	mov    %bl,%cl
  803c21:	d3 ee                	shr    %cl,%esi
  803c23:	89 f9                	mov    %edi,%ecx
  803c25:	d3 e2                	shl    %cl,%edx
  803c27:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c2b:	88 d9                	mov    %bl,%cl
  803c2d:	d3 e8                	shr    %cl,%eax
  803c2f:	09 c2                	or     %eax,%edx
  803c31:	89 d0                	mov    %edx,%eax
  803c33:	89 f2                	mov    %esi,%edx
  803c35:	f7 74 24 0c          	divl   0xc(%esp)
  803c39:	89 d6                	mov    %edx,%esi
  803c3b:	89 c3                	mov    %eax,%ebx
  803c3d:	f7 e5                	mul    %ebp
  803c3f:	39 d6                	cmp    %edx,%esi
  803c41:	72 19                	jb     803c5c <__udivdi3+0xfc>
  803c43:	74 0b                	je     803c50 <__udivdi3+0xf0>
  803c45:	89 d8                	mov    %ebx,%eax
  803c47:	31 ff                	xor    %edi,%edi
  803c49:	e9 58 ff ff ff       	jmp    803ba6 <__udivdi3+0x46>
  803c4e:	66 90                	xchg   %ax,%ax
  803c50:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c54:	89 f9                	mov    %edi,%ecx
  803c56:	d3 e2                	shl    %cl,%edx
  803c58:	39 c2                	cmp    %eax,%edx
  803c5a:	73 e9                	jae    803c45 <__udivdi3+0xe5>
  803c5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c5f:	31 ff                	xor    %edi,%edi
  803c61:	e9 40 ff ff ff       	jmp    803ba6 <__udivdi3+0x46>
  803c66:	66 90                	xchg   %ax,%ax
  803c68:	31 c0                	xor    %eax,%eax
  803c6a:	e9 37 ff ff ff       	jmp    803ba6 <__udivdi3+0x46>
  803c6f:	90                   	nop

00803c70 <__umoddi3>:
  803c70:	55                   	push   %ebp
  803c71:	57                   	push   %edi
  803c72:	56                   	push   %esi
  803c73:	53                   	push   %ebx
  803c74:	83 ec 1c             	sub    $0x1c,%esp
  803c77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c8f:	89 f3                	mov    %esi,%ebx
  803c91:	89 fa                	mov    %edi,%edx
  803c93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c97:	89 34 24             	mov    %esi,(%esp)
  803c9a:	85 c0                	test   %eax,%eax
  803c9c:	75 1a                	jne    803cb8 <__umoddi3+0x48>
  803c9e:	39 f7                	cmp    %esi,%edi
  803ca0:	0f 86 a2 00 00 00    	jbe    803d48 <__umoddi3+0xd8>
  803ca6:	89 c8                	mov    %ecx,%eax
  803ca8:	89 f2                	mov    %esi,%edx
  803caa:	f7 f7                	div    %edi
  803cac:	89 d0                	mov    %edx,%eax
  803cae:	31 d2                	xor    %edx,%edx
  803cb0:	83 c4 1c             	add    $0x1c,%esp
  803cb3:	5b                   	pop    %ebx
  803cb4:	5e                   	pop    %esi
  803cb5:	5f                   	pop    %edi
  803cb6:	5d                   	pop    %ebp
  803cb7:	c3                   	ret    
  803cb8:	39 f0                	cmp    %esi,%eax
  803cba:	0f 87 ac 00 00 00    	ja     803d6c <__umoddi3+0xfc>
  803cc0:	0f bd e8             	bsr    %eax,%ebp
  803cc3:	83 f5 1f             	xor    $0x1f,%ebp
  803cc6:	0f 84 ac 00 00 00    	je     803d78 <__umoddi3+0x108>
  803ccc:	bf 20 00 00 00       	mov    $0x20,%edi
  803cd1:	29 ef                	sub    %ebp,%edi
  803cd3:	89 fe                	mov    %edi,%esi
  803cd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cd9:	89 e9                	mov    %ebp,%ecx
  803cdb:	d3 e0                	shl    %cl,%eax
  803cdd:	89 d7                	mov    %edx,%edi
  803cdf:	89 f1                	mov    %esi,%ecx
  803ce1:	d3 ef                	shr    %cl,%edi
  803ce3:	09 c7                	or     %eax,%edi
  803ce5:	89 e9                	mov    %ebp,%ecx
  803ce7:	d3 e2                	shl    %cl,%edx
  803ce9:	89 14 24             	mov    %edx,(%esp)
  803cec:	89 d8                	mov    %ebx,%eax
  803cee:	d3 e0                	shl    %cl,%eax
  803cf0:	89 c2                	mov    %eax,%edx
  803cf2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cf6:	d3 e0                	shl    %cl,%eax
  803cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d00:	89 f1                	mov    %esi,%ecx
  803d02:	d3 e8                	shr    %cl,%eax
  803d04:	09 d0                	or     %edx,%eax
  803d06:	d3 eb                	shr    %cl,%ebx
  803d08:	89 da                	mov    %ebx,%edx
  803d0a:	f7 f7                	div    %edi
  803d0c:	89 d3                	mov    %edx,%ebx
  803d0e:	f7 24 24             	mull   (%esp)
  803d11:	89 c6                	mov    %eax,%esi
  803d13:	89 d1                	mov    %edx,%ecx
  803d15:	39 d3                	cmp    %edx,%ebx
  803d17:	0f 82 87 00 00 00    	jb     803da4 <__umoddi3+0x134>
  803d1d:	0f 84 91 00 00 00    	je     803db4 <__umoddi3+0x144>
  803d23:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d27:	29 f2                	sub    %esi,%edx
  803d29:	19 cb                	sbb    %ecx,%ebx
  803d2b:	89 d8                	mov    %ebx,%eax
  803d2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d31:	d3 e0                	shl    %cl,%eax
  803d33:	89 e9                	mov    %ebp,%ecx
  803d35:	d3 ea                	shr    %cl,%edx
  803d37:	09 d0                	or     %edx,%eax
  803d39:	89 e9                	mov    %ebp,%ecx
  803d3b:	d3 eb                	shr    %cl,%ebx
  803d3d:	89 da                	mov    %ebx,%edx
  803d3f:	83 c4 1c             	add    $0x1c,%esp
  803d42:	5b                   	pop    %ebx
  803d43:	5e                   	pop    %esi
  803d44:	5f                   	pop    %edi
  803d45:	5d                   	pop    %ebp
  803d46:	c3                   	ret    
  803d47:	90                   	nop
  803d48:	89 fd                	mov    %edi,%ebp
  803d4a:	85 ff                	test   %edi,%edi
  803d4c:	75 0b                	jne    803d59 <__umoddi3+0xe9>
  803d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d53:	31 d2                	xor    %edx,%edx
  803d55:	f7 f7                	div    %edi
  803d57:	89 c5                	mov    %eax,%ebp
  803d59:	89 f0                	mov    %esi,%eax
  803d5b:	31 d2                	xor    %edx,%edx
  803d5d:	f7 f5                	div    %ebp
  803d5f:	89 c8                	mov    %ecx,%eax
  803d61:	f7 f5                	div    %ebp
  803d63:	89 d0                	mov    %edx,%eax
  803d65:	e9 44 ff ff ff       	jmp    803cae <__umoddi3+0x3e>
  803d6a:	66 90                	xchg   %ax,%ax
  803d6c:	89 c8                	mov    %ecx,%eax
  803d6e:	89 f2                	mov    %esi,%edx
  803d70:	83 c4 1c             	add    $0x1c,%esp
  803d73:	5b                   	pop    %ebx
  803d74:	5e                   	pop    %esi
  803d75:	5f                   	pop    %edi
  803d76:	5d                   	pop    %ebp
  803d77:	c3                   	ret    
  803d78:	3b 04 24             	cmp    (%esp),%eax
  803d7b:	72 06                	jb     803d83 <__umoddi3+0x113>
  803d7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d81:	77 0f                	ja     803d92 <__umoddi3+0x122>
  803d83:	89 f2                	mov    %esi,%edx
  803d85:	29 f9                	sub    %edi,%ecx
  803d87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d8b:	89 14 24             	mov    %edx,(%esp)
  803d8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d92:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d96:	8b 14 24             	mov    (%esp),%edx
  803d99:	83 c4 1c             	add    $0x1c,%esp
  803d9c:	5b                   	pop    %ebx
  803d9d:	5e                   	pop    %esi
  803d9e:	5f                   	pop    %edi
  803d9f:	5d                   	pop    %ebp
  803da0:	c3                   	ret    
  803da1:	8d 76 00             	lea    0x0(%esi),%esi
  803da4:	2b 04 24             	sub    (%esp),%eax
  803da7:	19 fa                	sbb    %edi,%edx
  803da9:	89 d1                	mov    %edx,%ecx
  803dab:	89 c6                	mov    %eax,%esi
  803dad:	e9 71 ff ff ff       	jmp    803d23 <__umoddi3+0xb3>
  803db2:	66 90                	xchg   %ax,%ax
  803db4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803db8:	72 ea                	jb     803da4 <__umoddi3+0x134>
  803dba:	89 d9                	mov    %ebx,%ecx
  803dbc:	e9 62 ff ff ff       	jmp    803d23 <__umoddi3+0xb3>
