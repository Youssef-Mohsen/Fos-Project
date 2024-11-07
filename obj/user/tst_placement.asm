
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 1e 05 00 00       	call   800554 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x200000, 0x201000, 0x202000, 0x203000, 0x204000, 0x205000, 0x206000,0x207000,	//Data
		0x800000, 0x801000, 0x802000, 0x803000,		//Code
		0xeebfd000, 0xedbfd000 /*will be created during the call of sys_check_WS_list*/} ;//Stack

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 74 00 00 01    	sub    $0x1000074,%esp

	char arr[PAGE_SIZE*1024*4];
	bool found ;
	//("STEP 0: checking Initial WS entries ...\n");
	{
		found = sys_check_WS_list(expectedInitialVAs, 14, 0, 1);
  800042:	6a 01                	push   $0x1
  800044:	6a 00                	push   $0x0
  800046:	6a 0e                	push   $0xe
  800048:	68 00 30 80 00       	push   $0x803000
  80004d:	e8 0b 1c 00 00       	call   801c5d <sys_check_WS_list>
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800058:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 80 1f 80 00       	push   $0x801f80
  800066:	6a 15                	push   $0x15
  800068:	68 c1 1f 80 00       	push   $0x801fc1
  80006d:	e8 19 06 00 00       	call   80068b <_panic>

		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if( myEnv->page_last_WS_element !=  NULL)
  800072:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800077:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
  80007d:	85 c0                	test   %eax,%eax
  80007f:	74 14                	je     800095 <_main+0x5d>
			panic("INITIAL PAGE last WS checking failed! Review size of the WS..!!");
  800081:	83 ec 04             	sub    $0x4,%esp
  800084:	68 d8 1f 80 00       	push   $0x801fd8
  800089:	6a 19                	push   $0x19
  80008b:	68 c1 1f 80 00       	push   $0x801fc1
  800090:	e8 f6 05 00 00       	call   80068b <_panic>
		/*====================================*/
	}
	int eval = 0;
  800095:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  80009c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000a3:	e8 a5 17 00 00       	call   80184d <sys_pf_calculate_allocated_pages>
  8000a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freePages = sys_calculate_free_frames();
  8000ab:	e8 52 17 00 00       	call   801802 <sys_calculate_free_frames>
  8000b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i=0;
  8000b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	for(;i<=PAGE_SIZE;i++)
  8000ba:	eb 11                	jmp    8000cd <_main+0x95>
	{
		arr[i] = 1;
  8000bc:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  8000c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	c6 00 01             	movb   $0x1,(%eax)
	int eval = 0;
	bool is_correct = 1;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();
	int i=0;
	for(;i<=PAGE_SIZE;i++)
  8000ca:	ff 45 ec             	incl   -0x14(%ebp)
  8000cd:	81 7d ec 00 10 00 00 	cmpl   $0x1000,-0x14(%ebp)
  8000d4:	7e e6                	jle    8000bc <_main+0x84>
	{
		arr[i] = 1;
	}

	i=PAGE_SIZE*1024;
  8000d6:	c7 45 ec 00 00 40 00 	movl   $0x400000,-0x14(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8000dd:	eb 11                	jmp    8000f0 <_main+0xb8>
	{
		arr[i] = 2;
  8000df:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  8000e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e8:	01 d0                	add    %edx,%eax
  8000ea:	c6 00 02             	movb   $0x2,(%eax)
	{
		arr[i] = 1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  8000ed:	ff 45 ec             	incl   -0x14(%ebp)
  8000f0:	81 7d ec 00 10 40 00 	cmpl   $0x401000,-0x14(%ebp)
  8000f7:	7e e6                	jle    8000df <_main+0xa7>
	{
		arr[i] = 2;
	}

	i=PAGE_SIZE*1024*2;
  8000f9:	c7 45 ec 00 00 80 00 	movl   $0x800000,-0x14(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800100:	eb 11                	jmp    800113 <_main+0xdb>
	{
		arr[i] = 3;
  800102:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  800108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80010b:	01 d0                	add    %edx,%eax
  80010d:	c6 00 03             	movb   $0x3,(%eax)
	{
		arr[i] = 2;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800110:	ff 45 ec             	incl   -0x14(%ebp)
  800113:	81 7d ec 00 10 80 00 	cmpl   $0x801000,-0x14(%ebp)
  80011a:	7e e6                	jle    800102 <_main+0xca>
	{
		arr[i] = 3;
	}

	is_correct = 1;
  80011c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP A: checking PLACEMENT fault handling... [40%] \n");
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 18 20 80 00       	push   $0x802018
  80012b:	e8 18 08 00 00       	call   800948 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800133:	8a 85 dc ff ff fe    	mov    -0x1000024(%ebp),%al
  800139:	3c 01                	cmp    $0x1,%al
  80013b:	74 17                	je     800154 <_main+0x11c>
  80013d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	68 50 20 80 00       	push   $0x802050
  80014c:	e8 f7 07 00 00       	call   800948 <cprintf>
  800151:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800154:	8a 85 dc 0f 00 ff    	mov    -0xfff024(%ebp),%al
  80015a:	3c 01                	cmp    $0x1,%al
  80015c:	74 17                	je     800175 <_main+0x13d>
  80015e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 50 20 80 00       	push   $0x802050
  80016d:	e8 d6 07 00 00       	call   800948 <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  2)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800175:	8a 85 dc ff 3f ff    	mov    -0xc00024(%ebp),%al
  80017b:	3c 02                	cmp    $0x2,%al
  80017d:	74 17                	je     800196 <_main+0x15e>
  80017f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 50 20 80 00       	push   $0x802050
  80018e:	e8 b5 07 00 00       	call   800948 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  2)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800196:	8a 85 dc 0f 40 ff    	mov    -0xbff024(%ebp),%al
  80019c:	3c 02                	cmp    $0x2,%al
  80019e:	74 17                	je     8001b7 <_main+0x17f>
  8001a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 50 20 80 00       	push   $0x802050
  8001af:	e8 94 07 00 00       	call   800948 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  3)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001b7:	8a 85 dc ff 7f ff    	mov    -0x800024(%ebp),%al
  8001bd:	3c 03                	cmp    $0x3,%al
  8001bf:	74 17                	je     8001d8 <_main+0x1a0>
  8001c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	68 50 20 80 00       	push   $0x802050
  8001d0:	e8 73 07 00 00       	call   800948 <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  3)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001d8:	8a 85 dc 0f 80 ff    	mov    -0x7ff024(%ebp),%al
  8001de:	3c 03                	cmp    $0x3,%al
  8001e0:	74 17                	je     8001f9 <_main+0x1c1>
  8001e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e9:	83 ec 0c             	sub    $0xc,%esp
  8001ec:	68 50 20 80 00       	push   $0x802050
  8001f1:	e8 52 07 00 00       	call   800948 <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT be written to Page File until evicted as victim\n");}
  8001f9:	e8 4f 16 00 00       	call   80184d <sys_pf_calculate_allocated_pages>
  8001fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800201:	74 17                	je     80021a <_main+0x1e2>
  800203:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	68 70 20 80 00       	push   $0x802070
  800212:	e8 31 07 00 00       	call   800948 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp

		int expected = 5 /*pages*/ + 2 /*tables*/;
  80021a:	c7 45 dc 07 00 00 00 	movl   $0x7,-0x24(%ebp)
		if( (freePages - sys_calculate_free_frames() ) != expected )
  800221:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800224:	e8 d9 15 00 00       	call   801802 <sys_calculate_free_frames>
  800229:	29 c3                	sub    %eax,%ebx
  80022b:	89 da                	mov    %ebx,%edx
  80022d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800230:	39 c2                	cmp    %eax,%edx
  800232:	74 27                	je     80025b <_main+0x223>
		{ is_correct = 0; cprintf("allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", expected, (freePages - sys_calculate_free_frames() ));}
  800234:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80023b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80023e:	e8 bf 15 00 00       	call   801802 <sys_calculate_free_frames>
  800243:	29 c3                	sub    %eax,%ebx
  800245:	89 d8                	mov    %ebx,%eax
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	50                   	push   %eax
  80024b:	ff 75 dc             	pushl  -0x24(%ebp)
  80024e:	68 bc 20 80 00       	push   $0x8020bc
  800253:	e8 f0 06 00 00       	call   800948 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A finished: PLACEMENT fault handling !\n\n\n");
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 04 21 80 00       	push   $0x802104
  800263:	e8 e0 06 00 00       	call   800948 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp

	if (is_correct)
  80026b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80026f:	74 04                	je     800275 <_main+0x23d>
	{
		eval += 40;
  800271:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	}
	is_correct = 1;
  800275:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("STEP B: checking WS entries... [30%]\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 34 21 80 00       	push   $0x802134
  800284:	e8 bf 06 00 00       	call   800948 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
		//				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
		//				0x800000,0x801000,0x802000,0x803000,
		//				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000};
		uint32 expectedPages[19] ;
		{
			expectedPages[0] = 0x200000 ;
  80028c:	c7 85 90 ff ff fe 00 	movl   $0x200000,-0x1000070(%ebp)
  800293:	00 20 00 
			expectedPages[1] = 0x201000 ;
  800296:	c7 85 94 ff ff fe 00 	movl   $0x201000,-0x100006c(%ebp)
  80029d:	10 20 00 
			expectedPages[2] = 0x202000 ;
  8002a0:	c7 85 98 ff ff fe 00 	movl   $0x202000,-0x1000068(%ebp)
  8002a7:	20 20 00 
			expectedPages[3] = 0x203000 ;
  8002aa:	c7 85 9c ff ff fe 00 	movl   $0x203000,-0x1000064(%ebp)
  8002b1:	30 20 00 
			expectedPages[4] = 0x204000 ;
  8002b4:	c7 85 a0 ff ff fe 00 	movl   $0x204000,-0x1000060(%ebp)
  8002bb:	40 20 00 
			expectedPages[5] = 0x205000 ;
  8002be:	c7 85 a4 ff ff fe 00 	movl   $0x205000,-0x100005c(%ebp)
  8002c5:	50 20 00 
			expectedPages[6] = 0x206000 ;
  8002c8:	c7 85 a8 ff ff fe 00 	movl   $0x206000,-0x1000058(%ebp)
  8002cf:	60 20 00 
			expectedPages[7] = 0x207000 ;
  8002d2:	c7 85 ac ff ff fe 00 	movl   $0x207000,-0x1000054(%ebp)
  8002d9:	70 20 00 
			expectedPages[8] = 0x800000 ;
  8002dc:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  8002e3:	00 80 00 
			expectedPages[9] = 0x801000 ;
  8002e6:	c7 85 b4 ff ff fe 00 	movl   $0x801000,-0x100004c(%ebp)
  8002ed:	10 80 00 
			expectedPages[10] = 0x802000 ;
  8002f0:	c7 85 b8 ff ff fe 00 	movl   $0x802000,-0x1000048(%ebp)
  8002f7:	20 80 00 
			expectedPages[11] = 0x803000 ;
  8002fa:	c7 85 bc ff ff fe 00 	movl   $0x803000,-0x1000044(%ebp)
  800301:	30 80 00 
			expectedPages[12] = 0xeebfd000 ;
  800304:	c7 85 c0 ff ff fe 00 	movl   $0xeebfd000,-0x1000040(%ebp)
  80030b:	d0 bf ee 
			expectedPages[13] = 0xedbfd000 ;
  80030e:	c7 85 c4 ff ff fe 00 	movl   $0xedbfd000,-0x100003c(%ebp)
  800315:	d0 bf ed 
			expectedPages[14] = 0xedbfe000 ;
  800318:	c7 85 c8 ff ff fe 00 	movl   $0xedbfe000,-0x1000038(%ebp)
  80031f:	e0 bf ed 
			expectedPages[15] = 0xedffd000 ;
  800322:	c7 85 cc ff ff fe 00 	movl   $0xedffd000,-0x1000034(%ebp)
  800329:	d0 ff ed 
			expectedPages[16] = 0xedffe000 ;
  80032c:	c7 85 d0 ff ff fe 00 	movl   $0xedffe000,-0x1000030(%ebp)
  800333:	e0 ff ed 
			expectedPages[17] = 0xee3fd000 ;
  800336:	c7 85 d4 ff ff fe 00 	movl   $0xee3fd000,-0x100002c(%ebp)
  80033d:	d0 3f ee 
			expectedPages[18] = 0xee3fe000 ;
  800340:	c7 85 d8 ff ff fe 00 	movl   $0xee3fe000,-0x1000028(%ebp)
  800347:	e0 3f ee 
		}
		found = sys_check_WS_list(expectedPages, 19, 0, 1);
  80034a:	6a 01                	push   $0x1
  80034c:	6a 00                	push   $0x0
  80034e:	6a 13                	push   $0x13
  800350:	8d 85 90 ff ff fe    	lea    -0x1000070(%ebp),%eax
  800356:	50                   	push   %eax
  800357:	e8 01 19 00 00       	call   801c5d <sys_check_WS_list>
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1)
  800362:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800366:	74 17                	je     80037f <_main+0x347>
		{ is_correct = 0; cprintf("PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	68 5c 21 80 00       	push   $0x80215c
  800377:	e8 cc 05 00 00       	call   800948 <cprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B finished: WS entries test \n\n\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 b0 21 80 00       	push   $0x8021b0
  800387:	e8 bc 05 00 00       	call   800948 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  80038f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800393:	74 04                	je     800399 <_main+0x361>
	{
		eval += 30;
  800395:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	is_correct = 1;
  800399:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("STEP C: checking working sets WHEN BECOMES FULL... [30%]\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 d8 21 80 00       	push   $0x8021d8
  8003a8:	e8 9b 05 00 00       	call   800948 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
	{
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if(myEnv->page_last_WS_element != NULL)
  8003b0:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8003b5:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	74 17                	je     8003d6 <_main+0x39e>
		{ is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}
  8003bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003c6:	83 ec 0c             	sub    $0xc,%esp
  8003c9:	68 14 22 80 00       	push   $0x802214
  8003ce:	e8 75 05 00 00       	call   800948 <cprintf>
  8003d3:	83 c4 10             	add    $0x10,%esp

		i=PAGE_SIZE*1024*3;
  8003d6:	c7 45 ec 00 00 c0 00 	movl   $0xc00000,-0x14(%ebp)
		for(;i<=(PAGE_SIZE*1024*3);i++)
  8003dd:	eb 11                	jmp    8003f0 <_main+0x3b8>
		{
			arr[i] = 4;
  8003df:	8d 95 dc ff ff fe    	lea    -0x1000024(%ebp),%edx
  8003e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	c6 00 04             	movb   $0x4,(%eax)
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if(myEnv->page_last_WS_element != NULL)
		{ is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}

		i=PAGE_SIZE*1024*3;
		for(;i<=(PAGE_SIZE*1024*3);i++)
  8003ed:	ff 45 ec             	incl   -0x14(%ebp)
  8003f0:	81 7d ec 00 00 c0 00 	cmpl   $0xc00000,-0x14(%ebp)
  8003f7:	7e e6                	jle    8003df <_main+0x3a7>
		{
			arr[i] = 4;
		}

		if( arr[PAGE_SIZE*1024*3] != 4)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8003f9:	8a 85 dc ff bf ff    	mov    -0x400024(%ebp),%al
  8003ff:	3c 04                	cmp    $0x4,%al
  800401:	74 17                	je     80041a <_main+0x3e2>
  800403:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	68 50 20 80 00       	push   $0x802050
  800412:	e8 31 05 00 00       	call   800948 <cprintf>
  800417:	83 c4 10             	add    $0x10,%esp
//				0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,
//				0x800000,0x801000,0x802000,0x803000,
//				0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000,0xee7fd000};
		uint32 expectedPages[19] ;
		{
			expectedPages[0] = 0x200000 ;
  80041a:	c7 85 90 ff ff fe 00 	movl   $0x200000,-0x1000070(%ebp)
  800421:	00 20 00 
			expectedPages[1] = 0x201000 ;
  800424:	c7 85 94 ff ff fe 00 	movl   $0x201000,-0x100006c(%ebp)
  80042b:	10 20 00 
			expectedPages[2] = 0x202000 ;
  80042e:	c7 85 98 ff ff fe 00 	movl   $0x202000,-0x1000068(%ebp)
  800435:	20 20 00 
			expectedPages[3] = 0x203000 ;
  800438:	c7 85 9c ff ff fe 00 	movl   $0x203000,-0x1000064(%ebp)
  80043f:	30 20 00 
			expectedPages[4] = 0x204000 ;
  800442:	c7 85 a0 ff ff fe 00 	movl   $0x204000,-0x1000060(%ebp)
  800449:	40 20 00 
			expectedPages[5] = 0x205000 ;
  80044c:	c7 85 a4 ff ff fe 00 	movl   $0x205000,-0x100005c(%ebp)
  800453:	50 20 00 
			expectedPages[6] = 0x206000 ;
  800456:	c7 85 a8 ff ff fe 00 	movl   $0x206000,-0x1000058(%ebp)
  80045d:	60 20 00 
			expectedPages[7] = 0x207000 ;
  800460:	c7 85 ac ff ff fe 00 	movl   $0x207000,-0x1000054(%ebp)
  800467:	70 20 00 
			expectedPages[8] = 0x800000 ;
  80046a:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  800471:	00 80 00 
			expectedPages[9] = 0x801000 ;
  800474:	c7 85 b4 ff ff fe 00 	movl   $0x801000,-0x100004c(%ebp)
  80047b:	10 80 00 
			expectedPages[10] = 0x802000 ;
  80047e:	c7 85 b8 ff ff fe 00 	movl   $0x802000,-0x1000048(%ebp)
  800485:	20 80 00 
			expectedPages[11] = 0x803000 ;
  800488:	c7 85 bc ff ff fe 00 	movl   $0x803000,-0x1000044(%ebp)
  80048f:	30 80 00 
			expectedPages[12] = 0xeebfd000 ;
  800492:	c7 85 c0 ff ff fe 00 	movl   $0xeebfd000,-0x1000040(%ebp)
  800499:	d0 bf ee 
			expectedPages[13] = 0xedbfd000 ;
  80049c:	c7 85 c4 ff ff fe 00 	movl   $0xedbfd000,-0x100003c(%ebp)
  8004a3:	d0 bf ed 
			expectedPages[14] = 0xedbfe000 ;
  8004a6:	c7 85 c8 ff ff fe 00 	movl   $0xedbfe000,-0x1000038(%ebp)
  8004ad:	e0 bf ed 
			expectedPages[15] = 0xedffd000 ;
  8004b0:	c7 85 cc ff ff fe 00 	movl   $0xedffd000,-0x1000034(%ebp)
  8004b7:	d0 ff ed 
			expectedPages[16] = 0xedffe000 ;
  8004ba:	c7 85 d0 ff ff fe 00 	movl   $0xedffe000,-0x1000030(%ebp)
  8004c1:	e0 ff ed 
			expectedPages[17] = 0xee3fd000 ;
  8004c4:	c7 85 d4 ff ff fe 00 	movl   $0xee3fd000,-0x100002c(%ebp)
  8004cb:	d0 3f ee 
			expectedPages[18] = 0xee3fe000 ;
  8004ce:	c7 85 d8 ff ff fe 00 	movl   $0xee3fe000,-0x1000028(%ebp)
  8004d5:	e0 3f ee 
			expectedPages[19] = 0xee7fd000 ;
  8004d8:	c7 85 dc ff ff fe 00 	movl   $0xee7fd000,-0x1000024(%ebp)
  8004df:	d0 7f ee 
		}
		found = sys_check_WS_list(expectedPages, 20, 0x200000, 1);
  8004e2:	6a 01                	push   $0x1
  8004e4:	68 00 00 20 00       	push   $0x200000
  8004e9:	6a 14                	push   $0x14
  8004eb:	8d 85 90 ff ff fe    	lea    -0x1000070(%ebp),%eax
  8004f1:	50                   	push   %eax
  8004f2:	e8 66 17 00 00       	call   801c5d <sys_check_WS_list>
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1)
  8004fd:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800501:	74 17                	je     80051a <_main+0x4e2>
		{ is_correct = 0; cprintf("PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800503:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80050a:	83 ec 0c             	sub    $0xc,%esp
  80050d:	68 5c 21 80 00       	push   $0x80215c
  800512:	e8 31 04 00 00       	call   800948 <cprintf>
  800517:	83 c4 10             	add    $0x10,%esp
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		//if(myEnv->page_last_WS_index != 0) { is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}

	}
	cprintf("STEP C finished: WS is FULL now\n\n\n");
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 6c 22 80 00       	push   $0x80226c
  800522:	e8 21 04 00 00       	call   800948 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  80052a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80052e:	74 04                	je     800534 <_main+0x4fc>
	{
		eval += 30;
  800530:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	is_correct = 1;
  800534:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf("%~\nTest of PAGE PLACEMENT completed. Eval = %d\n\n", eval);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	68 90 22 80 00       	push   $0x802290
  800546:	e8 fd 03 00 00       	call   800948 <cprintf>
  80054b:	83 c4 10             	add    $0x10,%esp

	return;
  80054e:	90                   	nop
#endif
}
  80054f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800552:	c9                   	leave  
  800553:	c3                   	ret    

00800554 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800554:	55                   	push   %ebp
  800555:	89 e5                	mov    %esp,%ebp
  800557:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80055a:	e8 6c 14 00 00       	call   8019cb <sys_getenvindex>
  80055f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800562:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800565:	89 d0                	mov    %edx,%eax
  800567:	c1 e0 02             	shl    $0x2,%eax
  80056a:	01 d0                	add    %edx,%eax
  80056c:	01 c0                	add    %eax,%eax
  80056e:	01 d0                	add    %edx,%eax
  800570:	c1 e0 02             	shl    $0x2,%eax
  800573:	01 d0                	add    %edx,%eax
  800575:	01 c0                	add    %eax,%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	c1 e0 04             	shl    $0x4,%eax
  80057c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800581:	a3 3c 30 80 00       	mov    %eax,0x80303c

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800586:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80058b:	8a 40 20             	mov    0x20(%eax),%al
  80058e:	84 c0                	test   %al,%al
  800590:	74 0d                	je     80059f <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800592:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800597:	83 c0 20             	add    $0x20,%eax
  80059a:	a3 38 30 80 00       	mov    %eax,0x803038

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80059f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005a3:	7e 0a                	jle    8005af <libmain+0x5b>
		binaryname = argv[0];
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	a3 38 30 80 00       	mov    %eax,0x803038

	// call user main routine
	_main(argc, argv);
  8005af:	83 ec 08             	sub    $0x8,%esp
  8005b2:	ff 75 0c             	pushl  0xc(%ebp)
  8005b5:	ff 75 08             	pushl  0x8(%ebp)
  8005b8:	e8 7b fa ff ff       	call   800038 <_main>
  8005bd:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8005c0:	e8 8a 11 00 00       	call   80174f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8005c5:	83 ec 0c             	sub    $0xc,%esp
  8005c8:	68 dc 22 80 00       	push   $0x8022dc
  8005cd:	e8 76 03 00 00       	call   800948 <cprintf>
  8005d2:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005d5:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8005da:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8005e0:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8005e5:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8005eb:	83 ec 04             	sub    $0x4,%esp
  8005ee:	52                   	push   %edx
  8005ef:	50                   	push   %eax
  8005f0:	68 04 23 80 00       	push   $0x802304
  8005f5:	e8 4e 03 00 00       	call   800948 <cprintf>
  8005fa:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005fd:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800602:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800608:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80060d:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800613:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800618:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80061e:	51                   	push   %ecx
  80061f:	52                   	push   %edx
  800620:	50                   	push   %eax
  800621:	68 2c 23 80 00       	push   $0x80232c
  800626:	e8 1d 03 00 00       	call   800948 <cprintf>
  80062b:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80062e:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800633:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	50                   	push   %eax
  80063d:	68 84 23 80 00       	push   $0x802384
  800642:	e8 01 03 00 00       	call   800948 <cprintf>
  800647:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80064a:	83 ec 0c             	sub    $0xc,%esp
  80064d:	68 dc 22 80 00       	push   $0x8022dc
  800652:	e8 f1 02 00 00       	call   800948 <cprintf>
  800657:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80065a:	e8 0a 11 00 00       	call   801769 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80065f:	e8 19 00 00 00       	call   80067d <exit>
}
  800664:	90                   	nop
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80066d:	83 ec 0c             	sub    $0xc,%esp
  800670:	6a 00                	push   $0x0
  800672:	e8 20 13 00 00       	call   801997 <sys_destroy_env>
  800677:	83 c4 10             	add    $0x10,%esp
}
  80067a:	90                   	nop
  80067b:	c9                   	leave  
  80067c:	c3                   	ret    

0080067d <exit>:

void
exit(void)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
  800680:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800683:	e8 75 13 00 00       	call   8019fd <sys_exit_env>
}
  800688:	90                   	nop
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800691:	8d 45 10             	lea    0x10(%ebp),%eax
  800694:	83 c0 04             	add    $0x4,%eax
  800697:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80069a:	a1 5c 30 80 00       	mov    0x80305c,%eax
  80069f:	85 c0                	test   %eax,%eax
  8006a1:	74 16                	je     8006b9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006a3:	a1 5c 30 80 00       	mov    0x80305c,%eax
  8006a8:	83 ec 08             	sub    $0x8,%esp
  8006ab:	50                   	push   %eax
  8006ac:	68 98 23 80 00       	push   $0x802398
  8006b1:	e8 92 02 00 00       	call   800948 <cprintf>
  8006b6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006b9:	a1 38 30 80 00       	mov    0x803038,%eax
  8006be:	ff 75 0c             	pushl  0xc(%ebp)
  8006c1:	ff 75 08             	pushl  0x8(%ebp)
  8006c4:	50                   	push   %eax
  8006c5:	68 9d 23 80 00       	push   $0x80239d
  8006ca:	e8 79 02 00 00       	call   800948 <cprintf>
  8006cf:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006db:	50                   	push   %eax
  8006dc:	e8 fc 01 00 00       	call   8008dd <vcprintf>
  8006e1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	6a 00                	push   $0x0
  8006e9:	68 b9 23 80 00       	push   $0x8023b9
  8006ee:	e8 ea 01 00 00       	call   8008dd <vcprintf>
  8006f3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8006f6:	e8 82 ff ff ff       	call   80067d <exit>

	// should not return here
	while (1) ;
  8006fb:	eb fe                	jmp    8006fb <_panic+0x70>

008006fd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800703:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800708:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80070e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800711:	39 c2                	cmp    %eax,%edx
  800713:	74 14                	je     800729 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800715:	83 ec 04             	sub    $0x4,%esp
  800718:	68 bc 23 80 00       	push   $0x8023bc
  80071d:	6a 26                	push   $0x26
  80071f:	68 08 24 80 00       	push   $0x802408
  800724:	e8 62 ff ff ff       	call   80068b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800729:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800737:	e9 c5 00 00 00       	jmp    800801 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80073c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	01 d0                	add    %edx,%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	85 c0                	test   %eax,%eax
  80074f:	75 08                	jne    800759 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800751:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800754:	e9 a5 00 00 00       	jmp    8007fe <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800759:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800760:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800767:	eb 69                	jmp    8007d2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800769:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80076e:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800774:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800777:	89 d0                	mov    %edx,%eax
  800779:	01 c0                	add    %eax,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	c1 e0 03             	shl    $0x3,%eax
  800780:	01 c8                	add    %ecx,%eax
  800782:	8a 40 04             	mov    0x4(%eax),%al
  800785:	84 c0                	test   %al,%al
  800787:	75 46                	jne    8007cf <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800789:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80078e:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800794:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800797:	89 d0                	mov    %edx,%eax
  800799:	01 c0                	add    %eax,%eax
  80079b:	01 d0                	add    %edx,%eax
  80079d:	c1 e0 03             	shl    $0x3,%eax
  8007a0:	01 c8                	add    %ecx,%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007af:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	01 c8                	add    %ecx,%eax
  8007c0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007c2:	39 c2                	cmp    %eax,%edx
  8007c4:	75 09                	jne    8007cf <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8007c6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007cd:	eb 15                	jmp    8007e4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007cf:	ff 45 e8             	incl   -0x18(%ebp)
  8007d2:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8007d7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	77 85                	ja     800769 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8007e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8007e8:	75 14                	jne    8007fe <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8007ea:	83 ec 04             	sub    $0x4,%esp
  8007ed:	68 14 24 80 00       	push   $0x802414
  8007f2:	6a 3a                	push   $0x3a
  8007f4:	68 08 24 80 00       	push   $0x802408
  8007f9:	e8 8d fe ff ff       	call   80068b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8007fe:	ff 45 f0             	incl   -0x10(%ebp)
  800801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800804:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800807:	0f 8c 2f ff ff ff    	jl     80073c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80080d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800814:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80081b:	eb 26                	jmp    800843 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80081d:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800822:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800828:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80082b:	89 d0                	mov    %edx,%eax
  80082d:	01 c0                	add    %eax,%eax
  80082f:	01 d0                	add    %edx,%eax
  800831:	c1 e0 03             	shl    $0x3,%eax
  800834:	01 c8                	add    %ecx,%eax
  800836:	8a 40 04             	mov    0x4(%eax),%al
  800839:	3c 01                	cmp    $0x1,%al
  80083b:	75 03                	jne    800840 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80083d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800840:	ff 45 e0             	incl   -0x20(%ebp)
  800843:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800848:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80084e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800851:	39 c2                	cmp    %eax,%edx
  800853:	77 c8                	ja     80081d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800858:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80085b:	74 14                	je     800871 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80085d:	83 ec 04             	sub    $0x4,%esp
  800860:	68 68 24 80 00       	push   $0x802468
  800865:	6a 44                	push   $0x44
  800867:	68 08 24 80 00       	push   $0x802408
  80086c:	e8 1a fe ff ff       	call   80068b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800871:	90                   	nop
  800872:	c9                   	leave  
  800873:	c3                   	ret    

00800874 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80087a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	8d 48 01             	lea    0x1(%eax),%ecx
  800882:	8b 55 0c             	mov    0xc(%ebp),%edx
  800885:	89 0a                	mov    %ecx,(%edx)
  800887:	8b 55 08             	mov    0x8(%ebp),%edx
  80088a:	88 d1                	mov    %dl,%cl
  80088c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800893:	8b 45 0c             	mov    0xc(%ebp),%eax
  800896:	8b 00                	mov    (%eax),%eax
  800898:	3d ff 00 00 00       	cmp    $0xff,%eax
  80089d:	75 2c                	jne    8008cb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80089f:	a0 40 30 80 00       	mov    0x803040,%al
  8008a4:	0f b6 c0             	movzbl %al,%eax
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008aa:	8b 12                	mov    (%edx),%edx
  8008ac:	89 d1                	mov    %edx,%ecx
  8008ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b1:	83 c2 08             	add    $0x8,%edx
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	50                   	push   %eax
  8008b8:	51                   	push   %ecx
  8008b9:	52                   	push   %edx
  8008ba:	e8 4e 0e 00 00       	call   80170d <sys_cputs>
  8008bf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ce:	8b 40 04             	mov    0x4(%eax),%eax
  8008d1:	8d 50 01             	lea    0x1(%eax),%edx
  8008d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008da:	90                   	nop
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8008e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008ed:	00 00 00 
	b.cnt = 0;
  8008f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008f7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	ff 75 08             	pushl  0x8(%ebp)
  800900:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800906:	50                   	push   %eax
  800907:	68 74 08 80 00       	push   $0x800874
  80090c:	e8 11 02 00 00       	call   800b22 <vprintfmt>
  800911:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800914:	a0 40 30 80 00       	mov    0x803040,%al
  800919:	0f b6 c0             	movzbl %al,%eax
  80091c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	50                   	push   %eax
  800926:	52                   	push   %edx
  800927:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80092d:	83 c0 08             	add    $0x8,%eax
  800930:	50                   	push   %eax
  800931:	e8 d7 0d 00 00       	call   80170d <sys_cputs>
  800936:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800939:	c6 05 40 30 80 00 00 	movb   $0x0,0x803040
	return b.cnt;
  800940:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800946:	c9                   	leave  
  800947:	c3                   	ret    

00800948 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80094e:	c6 05 40 30 80 00 01 	movb   $0x1,0x803040
	va_start(ap, fmt);
  800955:	8d 45 0c             	lea    0xc(%ebp),%eax
  800958:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	83 ec 08             	sub    $0x8,%esp
  800961:	ff 75 f4             	pushl  -0xc(%ebp)
  800964:	50                   	push   %eax
  800965:	e8 73 ff ff ff       	call   8008dd <vcprintf>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800970:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800973:	c9                   	leave  
  800974:	c3                   	ret    

00800975 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80097b:	e8 cf 0d 00 00       	call   80174f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800980:	8d 45 0c             	lea    0xc(%ebp),%eax
  800983:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	83 ec 08             	sub    $0x8,%esp
  80098c:	ff 75 f4             	pushl  -0xc(%ebp)
  80098f:	50                   	push   %eax
  800990:	e8 48 ff ff ff       	call   8008dd <vcprintf>
  800995:	83 c4 10             	add    $0x10,%esp
  800998:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80099b:	e8 c9 0d 00 00       	call   801769 <sys_unlock_cons>
	return cnt;
  8009a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009a3:	c9                   	leave  
  8009a4:	c3                   	ret    

008009a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	53                   	push   %ebx
  8009a9:	83 ec 14             	sub    $0x14,%esp
  8009ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8009af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8009bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009c3:	77 55                	ja     800a1a <printnum+0x75>
  8009c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009c8:	72 05                	jb     8009cf <printnum+0x2a>
  8009ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009cd:	77 4b                	ja     800a1a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009cf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009d2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8009d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8009dd:	52                   	push   %edx
  8009de:	50                   	push   %eax
  8009df:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8009e5:	e8 22 13 00 00       	call   801d0c <__udivdi3>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	ff 75 20             	pushl  0x20(%ebp)
  8009f3:	53                   	push   %ebx
  8009f4:	ff 75 18             	pushl  0x18(%ebp)
  8009f7:	52                   	push   %edx
  8009f8:	50                   	push   %eax
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	ff 75 08             	pushl  0x8(%ebp)
  8009ff:	e8 a1 ff ff ff       	call   8009a5 <printnum>
  800a04:	83 c4 20             	add    $0x20,%esp
  800a07:	eb 1a                	jmp    800a23 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	ff 75 20             	pushl  0x20(%ebp)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	ff d0                	call   *%eax
  800a17:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a1a:	ff 4d 1c             	decl   0x1c(%ebp)
  800a1d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a21:	7f e6                	jg     800a09 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a23:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a31:	53                   	push   %ebx
  800a32:	51                   	push   %ecx
  800a33:	52                   	push   %edx
  800a34:	50                   	push   %eax
  800a35:	e8 e2 13 00 00       	call   801e1c <__umoddi3>
  800a3a:	83 c4 10             	add    $0x10,%esp
  800a3d:	05 d4 26 80 00       	add    $0x8026d4,%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	0f be c0             	movsbl %al,%eax
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	50                   	push   %eax
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	ff d0                	call   *%eax
  800a53:	83 c4 10             	add    $0x10,%esp
}
  800a56:	90                   	nop
  800a57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a5a:	c9                   	leave  
  800a5b:	c3                   	ret    

00800a5c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a5f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a63:	7e 1c                	jle    800a81 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8b 00                	mov    (%eax),%eax
  800a6a:	8d 50 08             	lea    0x8(%eax),%edx
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	89 10                	mov    %edx,(%eax)
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	8b 00                	mov    (%eax),%eax
  800a77:	83 e8 08             	sub    $0x8,%eax
  800a7a:	8b 50 04             	mov    0x4(%eax),%edx
  800a7d:	8b 00                	mov    (%eax),%eax
  800a7f:	eb 40                	jmp    800ac1 <getuint+0x65>
	else if (lflag)
  800a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a85:	74 1e                	je     800aa5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	8d 50 04             	lea    0x4(%eax),%edx
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	89 10                	mov    %edx,(%eax)
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8b 00                	mov    (%eax),%eax
  800a99:	83 e8 04             	sub    $0x4,%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa3:	eb 1c                	jmp    800ac1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8b 00                	mov    (%eax),%eax
  800aaa:	8d 50 04             	lea    0x4(%eax),%edx
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	89 10                	mov    %edx,(%eax)
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 00                	mov    (%eax),%eax
  800ab7:	83 e8 04             	sub    $0x4,%eax
  800aba:	8b 00                	mov    (%eax),%eax
  800abc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    

00800ac3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ac6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aca:	7e 1c                	jle    800ae8 <getint+0x25>
		return va_arg(*ap, long long);
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	8b 00                	mov    (%eax),%eax
  800ad1:	8d 50 08             	lea    0x8(%eax),%edx
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	89 10                	mov    %edx,(%eax)
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	83 e8 08             	sub    $0x8,%eax
  800ae1:	8b 50 04             	mov    0x4(%eax),%edx
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	eb 38                	jmp    800b20 <getint+0x5d>
	else if (lflag)
  800ae8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aec:	74 1a                	je     800b08 <getint+0x45>
		return va_arg(*ap, long);
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8b 00                	mov    (%eax),%eax
  800af3:	8d 50 04             	lea    0x4(%eax),%edx
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	89 10                	mov    %edx,(%eax)
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	8b 00                	mov    (%eax),%eax
  800b00:	83 e8 04             	sub    $0x4,%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	99                   	cltd   
  800b06:	eb 18                	jmp    800b20 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	8b 00                	mov    (%eax),%eax
  800b0d:	8d 50 04             	lea    0x4(%eax),%edx
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	89 10                	mov    %edx,(%eax)
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8b 00                	mov    (%eax),%eax
  800b1a:	83 e8 04             	sub    $0x4,%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	99                   	cltd   
}
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	56                   	push   %esi
  800b26:	53                   	push   %ebx
  800b27:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b2a:	eb 17                	jmp    800b43 <vprintfmt+0x21>
			if (ch == '\0')
  800b2c:	85 db                	test   %ebx,%ebx
  800b2e:	0f 84 c1 03 00 00    	je     800ef5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 0c             	pushl  0xc(%ebp)
  800b3a:	53                   	push   %ebx
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	ff d0                	call   *%eax
  800b40:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b43:	8b 45 10             	mov    0x10(%ebp),%eax
  800b46:	8d 50 01             	lea    0x1(%eax),%edx
  800b49:	89 55 10             	mov    %edx,0x10(%ebp)
  800b4c:	8a 00                	mov    (%eax),%al
  800b4e:	0f b6 d8             	movzbl %al,%ebx
  800b51:	83 fb 25             	cmp    $0x25,%ebx
  800b54:	75 d6                	jne    800b2c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b56:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b5a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b61:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b68:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b6f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b76:	8b 45 10             	mov    0x10(%ebp),%eax
  800b79:	8d 50 01             	lea    0x1(%eax),%edx
  800b7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800b7f:	8a 00                	mov    (%eax),%al
  800b81:	0f b6 d8             	movzbl %al,%ebx
  800b84:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b87:	83 f8 5b             	cmp    $0x5b,%eax
  800b8a:	0f 87 3d 03 00 00    	ja     800ecd <vprintfmt+0x3ab>
  800b90:	8b 04 85 f8 26 80 00 	mov    0x8026f8(,%eax,4),%eax
  800b97:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b99:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b9d:	eb d7                	jmp    800b76 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b9f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ba3:	eb d1                	jmp    800b76 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ba5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800baf:	89 d0                	mov    %edx,%eax
  800bb1:	c1 e0 02             	shl    $0x2,%eax
  800bb4:	01 d0                	add    %edx,%eax
  800bb6:	01 c0                	add    %eax,%eax
  800bb8:	01 d8                	add    %ebx,%eax
  800bba:	83 e8 30             	sub    $0x30,%eax
  800bbd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc3:	8a 00                	mov    (%eax),%al
  800bc5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bc8:	83 fb 2f             	cmp    $0x2f,%ebx
  800bcb:	7e 3e                	jle    800c0b <vprintfmt+0xe9>
  800bcd:	83 fb 39             	cmp    $0x39,%ebx
  800bd0:	7f 39                	jg     800c0b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bd2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bd5:	eb d5                	jmp    800bac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bda:	83 c0 04             	add    $0x4,%eax
  800bdd:	89 45 14             	mov    %eax,0x14(%ebp)
  800be0:	8b 45 14             	mov    0x14(%ebp),%eax
  800be3:	83 e8 04             	sub    $0x4,%eax
  800be6:	8b 00                	mov    (%eax),%eax
  800be8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800beb:	eb 1f                	jmp    800c0c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800bed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf1:	79 83                	jns    800b76 <vprintfmt+0x54>
				width = 0;
  800bf3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800bfa:	e9 77 ff ff ff       	jmp    800b76 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800bff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c06:	e9 6b ff ff ff       	jmp    800b76 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c0b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c10:	0f 89 60 ff ff ff    	jns    800b76 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c1c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c23:	e9 4e ff ff ff       	jmp    800b76 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c28:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c2b:	e9 46 ff ff ff       	jmp    800b76 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c30:	8b 45 14             	mov    0x14(%ebp),%eax
  800c33:	83 c0 04             	add    $0x4,%eax
  800c36:	89 45 14             	mov    %eax,0x14(%ebp)
  800c39:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3c:	83 e8 04             	sub    $0x4,%eax
  800c3f:	8b 00                	mov    (%eax),%eax
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	50                   	push   %eax
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	ff d0                	call   *%eax
  800c4d:	83 c4 10             	add    $0x10,%esp
			break;
  800c50:	e9 9b 02 00 00       	jmp    800ef0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 e8 04             	sub    $0x4,%eax
  800c64:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c66:	85 db                	test   %ebx,%ebx
  800c68:	79 02                	jns    800c6c <vprintfmt+0x14a>
				err = -err;
  800c6a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c6c:	83 fb 64             	cmp    $0x64,%ebx
  800c6f:	7f 0b                	jg     800c7c <vprintfmt+0x15a>
  800c71:	8b 34 9d 40 25 80 00 	mov    0x802540(,%ebx,4),%esi
  800c78:	85 f6                	test   %esi,%esi
  800c7a:	75 19                	jne    800c95 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c7c:	53                   	push   %ebx
  800c7d:	68 e5 26 80 00       	push   $0x8026e5
  800c82:	ff 75 0c             	pushl  0xc(%ebp)
  800c85:	ff 75 08             	pushl  0x8(%ebp)
  800c88:	e8 70 02 00 00       	call   800efd <printfmt>
  800c8d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c90:	e9 5b 02 00 00       	jmp    800ef0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c95:	56                   	push   %esi
  800c96:	68 ee 26 80 00       	push   $0x8026ee
  800c9b:	ff 75 0c             	pushl  0xc(%ebp)
  800c9e:	ff 75 08             	pushl  0x8(%ebp)
  800ca1:	e8 57 02 00 00       	call   800efd <printfmt>
  800ca6:	83 c4 10             	add    $0x10,%esp
			break;
  800ca9:	e9 42 02 00 00       	jmp    800ef0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cae:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb1:	83 c0 04             	add    $0x4,%eax
  800cb4:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cba:	83 e8 04             	sub    $0x4,%eax
  800cbd:	8b 30                	mov    (%eax),%esi
  800cbf:	85 f6                	test   %esi,%esi
  800cc1:	75 05                	jne    800cc8 <vprintfmt+0x1a6>
				p = "(null)";
  800cc3:	be f1 26 80 00       	mov    $0x8026f1,%esi
			if (width > 0 && padc != '-')
  800cc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ccc:	7e 6d                	jle    800d3b <vprintfmt+0x219>
  800cce:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cd2:	74 67                	je     800d3b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cd7:	83 ec 08             	sub    $0x8,%esp
  800cda:	50                   	push   %eax
  800cdb:	56                   	push   %esi
  800cdc:	e8 1e 03 00 00       	call   800fff <strnlen>
  800ce1:	83 c4 10             	add    $0x10,%esp
  800ce4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ce7:	eb 16                	jmp    800cff <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ce9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ced:	83 ec 08             	sub    $0x8,%esp
  800cf0:	ff 75 0c             	pushl  0xc(%ebp)
  800cf3:	50                   	push   %eax
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	ff d0                	call   *%eax
  800cf9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800cfc:	ff 4d e4             	decl   -0x1c(%ebp)
  800cff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d03:	7f e4                	jg     800ce9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d05:	eb 34                	jmp    800d3b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d07:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d0b:	74 1c                	je     800d29 <vprintfmt+0x207>
  800d0d:	83 fb 1f             	cmp    $0x1f,%ebx
  800d10:	7e 05                	jle    800d17 <vprintfmt+0x1f5>
  800d12:	83 fb 7e             	cmp    $0x7e,%ebx
  800d15:	7e 12                	jle    800d29 <vprintfmt+0x207>
					putch('?', putdat);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	6a 3f                	push   $0x3f
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	ff d0                	call   *%eax
  800d24:	83 c4 10             	add    $0x10,%esp
  800d27:	eb 0f                	jmp    800d38 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d29:	83 ec 08             	sub    $0x8,%esp
  800d2c:	ff 75 0c             	pushl  0xc(%ebp)
  800d2f:	53                   	push   %ebx
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	ff d0                	call   *%eax
  800d35:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d38:	ff 4d e4             	decl   -0x1c(%ebp)
  800d3b:	89 f0                	mov    %esi,%eax
  800d3d:	8d 70 01             	lea    0x1(%eax),%esi
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f be d8             	movsbl %al,%ebx
  800d45:	85 db                	test   %ebx,%ebx
  800d47:	74 24                	je     800d6d <vprintfmt+0x24b>
  800d49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d4d:	78 b8                	js     800d07 <vprintfmt+0x1e5>
  800d4f:	ff 4d e0             	decl   -0x20(%ebp)
  800d52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d56:	79 af                	jns    800d07 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d58:	eb 13                	jmp    800d6d <vprintfmt+0x24b>
				putch(' ', putdat);
  800d5a:	83 ec 08             	sub    $0x8,%esp
  800d5d:	ff 75 0c             	pushl  0xc(%ebp)
  800d60:	6a 20                	push   $0x20
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	ff d0                	call   *%eax
  800d67:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d6a:	ff 4d e4             	decl   -0x1c(%ebp)
  800d6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d71:	7f e7                	jg     800d5a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d73:	e9 78 01 00 00       	jmp    800ef0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d78:	83 ec 08             	sub    $0x8,%esp
  800d7b:	ff 75 e8             	pushl  -0x18(%ebp)
  800d7e:	8d 45 14             	lea    0x14(%ebp),%eax
  800d81:	50                   	push   %eax
  800d82:	e8 3c fd ff ff       	call   800ac3 <getint>
  800d87:	83 c4 10             	add    $0x10,%esp
  800d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d8d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d96:	85 d2                	test   %edx,%edx
  800d98:	79 23                	jns    800dbd <vprintfmt+0x29b>
				putch('-', putdat);
  800d9a:	83 ec 08             	sub    $0x8,%esp
  800d9d:	ff 75 0c             	pushl  0xc(%ebp)
  800da0:	6a 2d                	push   $0x2d
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	ff d0                	call   *%eax
  800da7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db0:	f7 d8                	neg    %eax
  800db2:	83 d2 00             	adc    $0x0,%edx
  800db5:	f7 da                	neg    %edx
  800db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800dbd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dc4:	e9 bc 00 00 00       	jmp    800e85 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dc9:	83 ec 08             	sub    $0x8,%esp
  800dcc:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcf:	8d 45 14             	lea    0x14(%ebp),%eax
  800dd2:	50                   	push   %eax
  800dd3:	e8 84 fc ff ff       	call   800a5c <getuint>
  800dd8:	83 c4 10             	add    $0x10,%esp
  800ddb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dde:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800de1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de8:	e9 98 00 00 00       	jmp    800e85 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ded:	83 ec 08             	sub    $0x8,%esp
  800df0:	ff 75 0c             	pushl  0xc(%ebp)
  800df3:	6a 58                	push   $0x58
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	ff d0                	call   *%eax
  800dfa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800dfd:	83 ec 08             	sub    $0x8,%esp
  800e00:	ff 75 0c             	pushl  0xc(%ebp)
  800e03:	6a 58                	push   $0x58
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	ff d0                	call   *%eax
  800e0a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e0d:	83 ec 08             	sub    $0x8,%esp
  800e10:	ff 75 0c             	pushl  0xc(%ebp)
  800e13:	6a 58                	push   $0x58
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	ff d0                	call   *%eax
  800e1a:	83 c4 10             	add    $0x10,%esp
			break;
  800e1d:	e9 ce 00 00 00       	jmp    800ef0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e22:	83 ec 08             	sub    $0x8,%esp
  800e25:	ff 75 0c             	pushl  0xc(%ebp)
  800e28:	6a 30                	push   $0x30
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	ff d0                	call   *%eax
  800e2f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e32:	83 ec 08             	sub    $0x8,%esp
  800e35:	ff 75 0c             	pushl  0xc(%ebp)
  800e38:	6a 78                	push   $0x78
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	ff d0                	call   *%eax
  800e3f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e42:	8b 45 14             	mov    0x14(%ebp),%eax
  800e45:	83 c0 04             	add    $0x4,%eax
  800e48:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4e:	83 e8 04             	sub    $0x4,%eax
  800e51:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e5d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e64:	eb 1f                	jmp    800e85 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e66:	83 ec 08             	sub    $0x8,%esp
  800e69:	ff 75 e8             	pushl  -0x18(%ebp)
  800e6c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6f:	50                   	push   %eax
  800e70:	e8 e7 fb ff ff       	call   800a5c <getuint>
  800e75:	83 c4 10             	add    $0x10,%esp
  800e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e7e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e85:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e8c:	83 ec 04             	sub    $0x4,%esp
  800e8f:	52                   	push   %edx
  800e90:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e93:	50                   	push   %eax
  800e94:	ff 75 f4             	pushl  -0xc(%ebp)
  800e97:	ff 75 f0             	pushl  -0x10(%ebp)
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	ff 75 08             	pushl  0x8(%ebp)
  800ea0:	e8 00 fb ff ff       	call   8009a5 <printnum>
  800ea5:	83 c4 20             	add    $0x20,%esp
			break;
  800ea8:	eb 46                	jmp    800ef0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800eaa:	83 ec 08             	sub    $0x8,%esp
  800ead:	ff 75 0c             	pushl  0xc(%ebp)
  800eb0:	53                   	push   %ebx
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	ff d0                	call   *%eax
  800eb6:	83 c4 10             	add    $0x10,%esp
			break;
  800eb9:	eb 35                	jmp    800ef0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ebb:	c6 05 40 30 80 00 00 	movb   $0x0,0x803040
			break;
  800ec2:	eb 2c                	jmp    800ef0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ec4:	c6 05 40 30 80 00 01 	movb   $0x1,0x803040
			break;
  800ecb:	eb 23                	jmp    800ef0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ecd:	83 ec 08             	sub    $0x8,%esp
  800ed0:	ff 75 0c             	pushl  0xc(%ebp)
  800ed3:	6a 25                	push   $0x25
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	ff d0                	call   *%eax
  800eda:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800edd:	ff 4d 10             	decl   0x10(%ebp)
  800ee0:	eb 03                	jmp    800ee5 <vprintfmt+0x3c3>
  800ee2:	ff 4d 10             	decl   0x10(%ebp)
  800ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee8:	48                   	dec    %eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	3c 25                	cmp    $0x25,%al
  800eed:	75 f3                	jne    800ee2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800eef:	90                   	nop
		}
	}
  800ef0:	e9 35 fc ff ff       	jmp    800b2a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ef5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ef6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f03:	8d 45 10             	lea    0x10(%ebp),%eax
  800f06:	83 c0 04             	add    $0x4,%eax
  800f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f12:	50                   	push   %eax
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	ff 75 08             	pushl  0x8(%ebp)
  800f19:	e8 04 fc ff ff       	call   800b22 <vprintfmt>
  800f1e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f21:	90                   	nop
  800f22:	c9                   	leave  
  800f23:	c3                   	ret    

00800f24 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8b 40 08             	mov    0x8(%eax),%eax
  800f2d:	8d 50 01             	lea    0x1(%eax),%edx
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	8b 10                	mov    (%eax),%edx
  800f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3e:	8b 40 04             	mov    0x4(%eax),%eax
  800f41:	39 c2                	cmp    %eax,%edx
  800f43:	73 12                	jae    800f57 <sprintputch+0x33>
		*b->buf++ = ch;
  800f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f48:	8b 00                	mov    (%eax),%eax
  800f4a:	8d 48 01             	lea    0x1(%eax),%ecx
  800f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f50:	89 0a                	mov    %ecx,(%edx)
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	88 10                	mov    %dl,(%eax)
}
  800f57:	90                   	nop
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	01 d0                	add    %edx,%eax
  800f71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f7f:	74 06                	je     800f87 <vsnprintf+0x2d>
  800f81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f85:	7f 07                	jg     800f8e <vsnprintf+0x34>
		return -E_INVAL;
  800f87:	b8 03 00 00 00       	mov    $0x3,%eax
  800f8c:	eb 20                	jmp    800fae <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f8e:	ff 75 14             	pushl  0x14(%ebp)
  800f91:	ff 75 10             	pushl  0x10(%ebp)
  800f94:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f97:	50                   	push   %eax
  800f98:	68 24 0f 80 00       	push   $0x800f24
  800f9d:	e8 80 fb ff ff       	call   800b22 <vprintfmt>
  800fa2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fa8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fae:	c9                   	leave  
  800faf:	c3                   	ret    

00800fb0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb9:	83 c0 04             	add    $0x4,%eax
  800fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc5:	50                   	push   %eax
  800fc6:	ff 75 0c             	pushl  0xc(%ebp)
  800fc9:	ff 75 08             	pushl  0x8(%ebp)
  800fcc:	e8 89 ff ff ff       	call   800f5a <vsnprintf>
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fe9:	eb 06                	jmp    800ff1 <strlen+0x15>
		n++;
  800feb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	84 c0                	test   %al,%al
  800ff8:	75 f1                	jne    800feb <strlen+0xf>
		n++;
	return n;
  800ffa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ffd:	c9                   	leave  
  800ffe:	c3                   	ret    

00800fff <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801005:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80100c:	eb 09                	jmp    801017 <strnlen+0x18>
		n++;
  80100e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801011:	ff 45 08             	incl   0x8(%ebp)
  801014:	ff 4d 0c             	decl   0xc(%ebp)
  801017:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101b:	74 09                	je     801026 <strnlen+0x27>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	84 c0                	test   %al,%al
  801024:	75 e8                	jne    80100e <strnlen+0xf>
		n++;
	return n;
  801026:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801029:	c9                   	leave  
  80102a:	c3                   	ret    

0080102b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801037:	90                   	nop
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8d 50 01             	lea    0x1(%eax),%edx
  80103e:	89 55 08             	mov    %edx,0x8(%ebp)
  801041:	8b 55 0c             	mov    0xc(%ebp),%edx
  801044:	8d 4a 01             	lea    0x1(%edx),%ecx
  801047:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80104a:	8a 12                	mov    (%edx),%dl
  80104c:	88 10                	mov    %dl,(%eax)
  80104e:	8a 00                	mov    (%eax),%al
  801050:	84 c0                	test   %al,%al
  801052:	75 e4                	jne    801038 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801054:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801065:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80106c:	eb 1f                	jmp    80108d <strncpy+0x34>
		*dst++ = *src;
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8d 50 01             	lea    0x1(%eax),%edx
  801074:	89 55 08             	mov    %edx,0x8(%ebp)
  801077:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107a:	8a 12                	mov    (%edx),%dl
  80107c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80107e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	84 c0                	test   %al,%al
  801085:	74 03                	je     80108a <strncpy+0x31>
			src++;
  801087:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80108a:	ff 45 fc             	incl   -0x4(%ebp)
  80108d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801090:	3b 45 10             	cmp    0x10(%ebp),%eax
  801093:	72 d9                	jb     80106e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801095:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010aa:	74 30                	je     8010dc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010ac:	eb 16                	jmp    8010c4 <strlcpy+0x2a>
			*dst++ = *src++;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8d 50 01             	lea    0x1(%eax),%edx
  8010b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c0:	8a 12                	mov    (%edx),%dl
  8010c2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010c4:	ff 4d 10             	decl   0x10(%ebp)
  8010c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cb:	74 09                	je     8010d6 <strlcpy+0x3c>
  8010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	84 c0                	test   %al,%al
  8010d4:	75 d8                	jne    8010ae <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e2:	29 c2                	sub    %eax,%edx
  8010e4:	89 d0                	mov    %edx,%eax
}
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010eb:	eb 06                	jmp    8010f3 <strcmp+0xb>
		p++, q++;
  8010ed:	ff 45 08             	incl   0x8(%ebp)
  8010f0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	8a 00                	mov    (%eax),%al
  8010f8:	84 c0                	test   %al,%al
  8010fa:	74 0e                	je     80110a <strcmp+0x22>
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	8a 10                	mov    (%eax),%dl
  801101:	8b 45 0c             	mov    0xc(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	38 c2                	cmp    %al,%dl
  801108:	74 e3                	je     8010ed <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f b6 d0             	movzbl %al,%edx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	0f b6 c0             	movzbl %al,%eax
  80111a:	29 c2                	sub    %eax,%edx
  80111c:	89 d0                	mov    %edx,%eax
}
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    

00801120 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801123:	eb 09                	jmp    80112e <strncmp+0xe>
		n--, p++, q++;
  801125:	ff 4d 10             	decl   0x10(%ebp)
  801128:	ff 45 08             	incl   0x8(%ebp)
  80112b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80112e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801132:	74 17                	je     80114b <strncmp+0x2b>
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	84 c0                	test   %al,%al
  80113b:	74 0e                	je     80114b <strncmp+0x2b>
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 10                	mov    (%eax),%dl
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	38 c2                	cmp    %al,%dl
  801149:	74 da                	je     801125 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80114b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114f:	75 07                	jne    801158 <strncmp+0x38>
		return 0;
  801151:	b8 00 00 00 00       	mov    $0x0,%eax
  801156:	eb 14                	jmp    80116c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	0f b6 d0             	movzbl %al,%edx
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	0f b6 c0             	movzbl %al,%eax
  801168:	29 c2                	sub    %eax,%edx
  80116a:	89 d0                	mov    %edx,%eax
}
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 04             	sub    $0x4,%esp
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80117a:	eb 12                	jmp    80118e <strchr+0x20>
		if (*s == c)
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801184:	75 05                	jne    80118b <strchr+0x1d>
			return (char *) s;
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	eb 11                	jmp    80119c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80118b:	ff 45 08             	incl   0x8(%ebp)
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	84 c0                	test   %al,%al
  801195:	75 e5                	jne    80117c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801197:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    

0080119e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	83 ec 04             	sub    $0x4,%esp
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011aa:	eb 0d                	jmp    8011b9 <strfind+0x1b>
		if (*s == c)
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011b4:	74 0e                	je     8011c4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011b6:	ff 45 08             	incl   0x8(%ebp)
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	84 c0                	test   %al,%al
  8011c0:	75 ea                	jne    8011ac <strfind+0xe>
  8011c2:	eb 01                	jmp    8011c5 <strfind+0x27>
		if (*s == c)
			break;
  8011c4:	90                   	nop
	return (char *) s;
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011dc:	eb 0e                	jmp    8011ec <memset+0x22>
		*p++ = c;
  8011de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e1:	8d 50 01             	lea    0x1(%eax),%edx
  8011e4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ea:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011ec:	ff 4d f8             	decl   -0x8(%ebp)
  8011ef:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8011f3:	79 e9                	jns    8011de <memset+0x14>
		*p++ = c;

	return v;
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80120c:	eb 16                	jmp    801224 <memcpy+0x2a>
		*d++ = *s++;
  80120e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801211:	8d 50 01             	lea    0x1(%eax),%edx
  801214:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801217:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80121d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801220:	8a 12                	mov    (%edx),%dl
  801222:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801224:	8b 45 10             	mov    0x10(%ebp),%eax
  801227:	8d 50 ff             	lea    -0x1(%eax),%edx
  80122a:	89 55 10             	mov    %edx,0x10(%ebp)
  80122d:	85 c0                	test   %eax,%eax
  80122f:	75 dd                	jne    80120e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801248:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80124e:	73 50                	jae    8012a0 <memmove+0x6a>
  801250:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801253:	8b 45 10             	mov    0x10(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80125b:	76 43                	jbe    8012a0 <memmove+0x6a>
		s += n;
  80125d:	8b 45 10             	mov    0x10(%ebp),%eax
  801260:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801263:	8b 45 10             	mov    0x10(%ebp),%eax
  801266:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801269:	eb 10                	jmp    80127b <memmove+0x45>
			*--d = *--s;
  80126b:	ff 4d f8             	decl   -0x8(%ebp)
  80126e:	ff 4d fc             	decl   -0x4(%ebp)
  801271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801274:	8a 10                	mov    (%eax),%dl
  801276:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801279:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80127b:	8b 45 10             	mov    0x10(%ebp),%eax
  80127e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801281:	89 55 10             	mov    %edx,0x10(%ebp)
  801284:	85 c0                	test   %eax,%eax
  801286:	75 e3                	jne    80126b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801288:	eb 23                	jmp    8012ad <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80128a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128d:	8d 50 01             	lea    0x1(%eax),%edx
  801290:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801293:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801296:	8d 4a 01             	lea    0x1(%edx),%ecx
  801299:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80129c:	8a 12                	mov    (%edx),%dl
  80129e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	75 dd                	jne    80128a <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012c4:	eb 2a                	jmp    8012f0 <memcmp+0x3e>
		if (*s1 != *s2)
  8012c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c9:	8a 10                	mov    (%eax),%dl
  8012cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	38 c2                	cmp    %al,%dl
  8012d2:	74 16                	je     8012ea <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d7:	8a 00                	mov    (%eax),%al
  8012d9:	0f b6 d0             	movzbl %al,%edx
  8012dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	0f b6 c0             	movzbl %al,%eax
  8012e4:	29 c2                	sub    %eax,%edx
  8012e6:	89 d0                	mov    %edx,%eax
  8012e8:	eb 18                	jmp    801302 <memcmp+0x50>
		s1++, s2++;
  8012ea:	ff 45 fc             	incl   -0x4(%ebp)
  8012ed:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	75 c9                	jne    8012c6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801302:	c9                   	leave  
  801303:	c3                   	ret    

00801304 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80130a:	8b 55 08             	mov    0x8(%ebp),%edx
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801315:	eb 15                	jmp    80132c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f b6 d0             	movzbl %al,%edx
  80131f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801322:	0f b6 c0             	movzbl %al,%eax
  801325:	39 c2                	cmp    %eax,%edx
  801327:	74 0d                	je     801336 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801329:	ff 45 08             	incl   0x8(%ebp)
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801332:	72 e3                	jb     801317 <memfind+0x13>
  801334:	eb 01                	jmp    801337 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801336:	90                   	nop
	return (void *) s;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801349:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801350:	eb 03                	jmp    801355 <strtol+0x19>
		s++;
  801352:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	8a 00                	mov    (%eax),%al
  80135a:	3c 20                	cmp    $0x20,%al
  80135c:	74 f4                	je     801352 <strtol+0x16>
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	3c 09                	cmp    $0x9,%al
  801365:	74 eb                	je     801352 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	3c 2b                	cmp    $0x2b,%al
  80136e:	75 05                	jne    801375 <strtol+0x39>
		s++;
  801370:	ff 45 08             	incl   0x8(%ebp)
  801373:	eb 13                	jmp    801388 <strtol+0x4c>
	else if (*s == '-')
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	8a 00                	mov    (%eax),%al
  80137a:	3c 2d                	cmp    $0x2d,%al
  80137c:	75 0a                	jne    801388 <strtol+0x4c>
		s++, neg = 1;
  80137e:	ff 45 08             	incl   0x8(%ebp)
  801381:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801388:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138c:	74 06                	je     801394 <strtol+0x58>
  80138e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801392:	75 20                	jne    8013b4 <strtol+0x78>
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	3c 30                	cmp    $0x30,%al
  80139b:	75 17                	jne    8013b4 <strtol+0x78>
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	40                   	inc    %eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	3c 78                	cmp    $0x78,%al
  8013a5:	75 0d                	jne    8013b4 <strtol+0x78>
		s += 2, base = 16;
  8013a7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013ab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013b2:	eb 28                	jmp    8013dc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b8:	75 15                	jne    8013cf <strtol+0x93>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	3c 30                	cmp    $0x30,%al
  8013c1:	75 0c                	jne    8013cf <strtol+0x93>
		s++, base = 8;
  8013c3:	ff 45 08             	incl   0x8(%ebp)
  8013c6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013cd:	eb 0d                	jmp    8013dc <strtol+0xa0>
	else if (base == 0)
  8013cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d3:	75 07                	jne    8013dc <strtol+0xa0>
		base = 10;
  8013d5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	3c 2f                	cmp    $0x2f,%al
  8013e3:	7e 19                	jle    8013fe <strtol+0xc2>
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	3c 39                	cmp    $0x39,%al
  8013ec:	7f 10                	jg     8013fe <strtol+0xc2>
			dig = *s - '0';
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	0f be c0             	movsbl %al,%eax
  8013f6:	83 e8 30             	sub    $0x30,%eax
  8013f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013fc:	eb 42                	jmp    801440 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	3c 60                	cmp    $0x60,%al
  801405:	7e 19                	jle    801420 <strtol+0xe4>
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	8a 00                	mov    (%eax),%al
  80140c:	3c 7a                	cmp    $0x7a,%al
  80140e:	7f 10                	jg     801420 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	8a 00                	mov    (%eax),%al
  801415:	0f be c0             	movsbl %al,%eax
  801418:	83 e8 57             	sub    $0x57,%eax
  80141b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80141e:	eb 20                	jmp    801440 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 40                	cmp    $0x40,%al
  801427:	7e 39                	jle    801462 <strtol+0x126>
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	3c 5a                	cmp    $0x5a,%al
  801430:	7f 30                	jg     801462 <strtol+0x126>
			dig = *s - 'A' + 10;
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	0f be c0             	movsbl %al,%eax
  80143a:	83 e8 37             	sub    $0x37,%eax
  80143d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801443:	3b 45 10             	cmp    0x10(%ebp),%eax
  801446:	7d 19                	jge    801461 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801448:	ff 45 08             	incl   0x8(%ebp)
  80144b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801452:	89 c2                	mov    %eax,%edx
  801454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801457:	01 d0                	add    %edx,%eax
  801459:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80145c:	e9 7b ff ff ff       	jmp    8013dc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801461:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801462:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801466:	74 08                	je     801470 <strtol+0x134>
		*endptr = (char *) s;
  801468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146b:	8b 55 08             	mov    0x8(%ebp),%edx
  80146e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801470:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801474:	74 07                	je     80147d <strtol+0x141>
  801476:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801479:	f7 d8                	neg    %eax
  80147b:	eb 03                	jmp    801480 <strtol+0x144>
  80147d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <ltostr>:

void
ltostr(long value, char *str)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801488:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80148f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801496:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80149a:	79 13                	jns    8014af <ltostr+0x2d>
	{
		neg = 1;
  80149c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014a9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014ac:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014b7:	99                   	cltd   
  8014b8:	f7 f9                	idiv   %ecx
  8014ba:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014c6:	89 c2                	mov    %eax,%edx
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014d0:	83 c2 30             	add    $0x30,%edx
  8014d3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014d8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014dd:	f7 e9                	imul   %ecx
  8014df:	c1 fa 02             	sar    $0x2,%edx
  8014e2:	89 c8                	mov    %ecx,%eax
  8014e4:	c1 f8 1f             	sar    $0x1f,%eax
  8014e7:	29 c2                	sub    %eax,%edx
  8014e9:	89 d0                	mov    %edx,%eax
  8014eb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8014ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f2:	75 bb                	jne    8014af <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8014f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8014fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fe:	48                   	dec    %eax
  8014ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801502:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801506:	74 3d                	je     801545 <ltostr+0xc3>
		start = 1 ;
  801508:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80150f:	eb 34                	jmp    801545 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801511:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801514:	8b 45 0c             	mov    0xc(%ebp),%eax
  801517:	01 d0                	add    %edx,%eax
  801519:	8a 00                	mov    (%eax),%al
  80151b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80151e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	01 c2                	add    %eax,%edx
  801526:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152c:	01 c8                	add    %ecx,%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801532:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801535:	8b 45 0c             	mov    0xc(%ebp),%eax
  801538:	01 c2                	add    %eax,%edx
  80153a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80153d:	88 02                	mov    %al,(%edx)
		start++ ;
  80153f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801542:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801548:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80154b:	7c c4                	jl     801511 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80154d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801550:	8b 45 0c             	mov    0xc(%ebp),%eax
  801553:	01 d0                	add    %edx,%eax
  801555:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801558:	90                   	nop
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801561:	ff 75 08             	pushl  0x8(%ebp)
  801564:	e8 73 fa ff ff       	call   800fdc <strlen>
  801569:	83 c4 04             	add    $0x4,%esp
  80156c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	e8 65 fa ff ff       	call   800fdc <strlen>
  801577:	83 c4 04             	add    $0x4,%esp
  80157a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80157d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801584:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80158b:	eb 17                	jmp    8015a4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80158d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801590:	8b 45 10             	mov    0x10(%ebp),%eax
  801593:	01 c2                	add    %eax,%edx
  801595:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	01 c8                	add    %ecx,%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015a1:	ff 45 fc             	incl   -0x4(%ebp)
  8015a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015aa:	7c e1                	jl     80158d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015ba:	eb 1f                	jmp    8015db <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015bf:	8d 50 01             	lea    0x1(%eax),%edx
  8015c2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015c5:	89 c2                	mov    %eax,%edx
  8015c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ca:	01 c2                	add    %eax,%edx
  8015cc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d2:	01 c8                	add    %ecx,%eax
  8015d4:	8a 00                	mov    (%eax),%al
  8015d6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015d8:	ff 45 f8             	incl   -0x8(%ebp)
  8015db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e1:	7c d9                	jl     8015bc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e9:	01 d0                	add    %edx,%eax
  8015eb:	c6 00 00             	movb   $0x0,(%eax)
}
  8015ee:	90                   	nop
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8015f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8015fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801600:	8b 00                	mov    (%eax),%eax
  801602:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801609:	8b 45 10             	mov    0x10(%ebp),%eax
  80160c:	01 d0                	add    %edx,%eax
  80160e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801614:	eb 0c                	jmp    801622 <strsplit+0x31>
			*string++ = 0;
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	8d 50 01             	lea    0x1(%eax),%edx
  80161c:	89 55 08             	mov    %edx,0x8(%ebp)
  80161f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	8a 00                	mov    (%eax),%al
  801627:	84 c0                	test   %al,%al
  801629:	74 18                	je     801643 <strsplit+0x52>
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	0f be c0             	movsbl %al,%eax
  801633:	50                   	push   %eax
  801634:	ff 75 0c             	pushl  0xc(%ebp)
  801637:	e8 32 fb ff ff       	call   80116e <strchr>
  80163c:	83 c4 08             	add    $0x8,%esp
  80163f:	85 c0                	test   %eax,%eax
  801641:	75 d3                	jne    801616 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	8a 00                	mov    (%eax),%al
  801648:	84 c0                	test   %al,%al
  80164a:	74 5a                	je     8016a6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80164c:	8b 45 14             	mov    0x14(%ebp),%eax
  80164f:	8b 00                	mov    (%eax),%eax
  801651:	83 f8 0f             	cmp    $0xf,%eax
  801654:	75 07                	jne    80165d <strsplit+0x6c>
		{
			return 0;
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
  80165b:	eb 66                	jmp    8016c3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80165d:	8b 45 14             	mov    0x14(%ebp),%eax
  801660:	8b 00                	mov    (%eax),%eax
  801662:	8d 48 01             	lea    0x1(%eax),%ecx
  801665:	8b 55 14             	mov    0x14(%ebp),%edx
  801668:	89 0a                	mov    %ecx,(%edx)
  80166a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	01 c2                	add    %eax,%edx
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80167b:	eb 03                	jmp    801680 <strsplit+0x8f>
			string++;
  80167d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8a 00                	mov    (%eax),%al
  801685:	84 c0                	test   %al,%al
  801687:	74 8b                	je     801614 <strsplit+0x23>
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	8a 00                	mov    (%eax),%al
  80168e:	0f be c0             	movsbl %al,%eax
  801691:	50                   	push   %eax
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	e8 d4 fa ff ff       	call   80116e <strchr>
  80169a:	83 c4 08             	add    $0x8,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	74 dc                	je     80167d <strsplit+0x8c>
			string++;
	}
  8016a1:	e9 6e ff ff ff       	jmp    801614 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016a6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016aa:	8b 00                	mov    (%eax),%eax
  8016ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b6:	01 d0                	add    %edx,%eax
  8016b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	68 68 28 80 00       	push   $0x802868
  8016d3:	68 3f 01 00 00       	push   $0x13f
  8016d8:	68 8a 28 80 00       	push   $0x80288a
  8016dd:	e8 a9 ef ff ff       	call   80068b <_panic>

008016e2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	57                   	push   %edi
  8016e6:	56                   	push   %esi
  8016e7:	53                   	push   %ebx
  8016e8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016fa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016fd:	cd 30                	int    $0x30
  8016ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801702:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	5b                   	pop    %ebx
  801709:	5e                   	pop    %esi
  80170a:	5f                   	pop    %edi
  80170b:	5d                   	pop    %ebp
  80170c:	c3                   	ret    

0080170d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	8b 45 10             	mov    0x10(%ebp),%eax
  801716:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801719:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	52                   	push   %edx
  801725:	ff 75 0c             	pushl  0xc(%ebp)
  801728:	50                   	push   %eax
  801729:	6a 00                	push   $0x0
  80172b:	e8 b2 ff ff ff       	call   8016e2 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	90                   	nop
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sys_cgetc>:

int
sys_cgetc(void)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 02                	push   $0x2
  801745:	e8 98 ff ff ff       	call   8016e2 <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 03                	push   $0x3
  80175e:	e8 7f ff ff ff       	call   8016e2 <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	90                   	nop
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 04                	push   $0x4
  801778:	e8 65 ff ff ff       	call   8016e2 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	90                   	nop
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801786:	8b 55 0c             	mov    0xc(%ebp),%edx
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	52                   	push   %edx
  801793:	50                   	push   %eax
  801794:	6a 08                	push   $0x8
  801796:	e8 47 ff ff ff       	call   8016e2 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	56                   	push   %esi
  8017a4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017a5:	8b 75 18             	mov    0x18(%ebp),%esi
  8017a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	56                   	push   %esi
  8017b5:	53                   	push   %ebx
  8017b6:	51                   	push   %ecx
  8017b7:	52                   	push   %edx
  8017b8:	50                   	push   %eax
  8017b9:	6a 09                	push   $0x9
  8017bb:	e8 22 ff ff ff       	call   8016e2 <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c6:	5b                   	pop    %ebx
  8017c7:	5e                   	pop    %esi
  8017c8:	5d                   	pop    %ebp
  8017c9:	c3                   	ret    

008017ca <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	52                   	push   %edx
  8017da:	50                   	push   %eax
  8017db:	6a 0a                	push   $0xa
  8017dd:	e8 00 ff ff ff       	call   8016e2 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	ff 75 0c             	pushl  0xc(%ebp)
  8017f3:	ff 75 08             	pushl  0x8(%ebp)
  8017f6:	6a 0b                	push   $0xb
  8017f8:	e8 e5 fe ff ff       	call   8016e2 <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 0c                	push   $0xc
  801811:	e8 cc fe ff ff       	call   8016e2 <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 0d                	push   $0xd
  80182a:	e8 b3 fe ff ff       	call   8016e2 <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 0e                	push   $0xe
  801843:	e8 9a fe ff ff       	call   8016e2 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 0f                	push   $0xf
  80185c:	e8 81 fe ff ff       	call   8016e2 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	6a 10                	push   $0x10
  801876:	e8 67 fe ff ff       	call   8016e2 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 11                	push   $0x11
  80188f:	e8 4e fe ff ff       	call   8016e2 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	90                   	nop
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_cputc>:

void
sys_cputc(const char c)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 04             	sub    $0x4,%esp
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	50                   	push   %eax
  8018b3:	6a 01                	push   $0x1
  8018b5:	e8 28 fe ff ff       	call   8016e2 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	90                   	nop
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 14                	push   $0x14
  8018cf:	e8 0e fe ff ff       	call   8016e2 <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	90                   	nop
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018e6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018e9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	6a 00                	push   $0x0
  8018f2:	51                   	push   %ecx
  8018f3:	52                   	push   %edx
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	50                   	push   %eax
  8018f8:	6a 15                	push   $0x15
  8018fa:	e8 e3 fd ff ff       	call   8016e2 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	52                   	push   %edx
  801914:	50                   	push   %eax
  801915:	6a 16                	push   $0x16
  801917:	e8 c6 fd ff ff       	call   8016e2 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801924:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	51                   	push   %ecx
  801932:	52                   	push   %edx
  801933:	50                   	push   %eax
  801934:	6a 17                	push   $0x17
  801936:	e8 a7 fd ff ff       	call   8016e2 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 18                	push   $0x18
  801953:	e8 8a fd ff ff       	call   8016e2 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	6a 00                	push   $0x0
  801965:	ff 75 14             	pushl  0x14(%ebp)
  801968:	ff 75 10             	pushl  0x10(%ebp)
  80196b:	ff 75 0c             	pushl  0xc(%ebp)
  80196e:	50                   	push   %eax
  80196f:	6a 19                	push   $0x19
  801971:	e8 6c fd ff ff       	call   8016e2 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	50                   	push   %eax
  80198a:	6a 1a                	push   $0x1a
  80198c:	e8 51 fd ff ff       	call   8016e2 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	90                   	nop
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	50                   	push   %eax
  8019a6:	6a 1b                	push   $0x1b
  8019a8:	e8 35 fd ff ff       	call   8016e2 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 05                	push   $0x5
  8019c1:	e8 1c fd ff ff       	call   8016e2 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 06                	push   $0x6
  8019da:	e8 03 fd ff ff       	call   8016e2 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 07                	push   $0x7
  8019f3:	e8 ea fc ff ff       	call   8016e2 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_exit_env>:


void sys_exit_env(void)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 1c                	push   $0x1c
  801a0c:	e8 d1 fc ff ff       	call   8016e2 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	90                   	nop
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a20:	8d 50 04             	lea    0x4(%eax),%edx
  801a23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	52                   	push   %edx
  801a2d:	50                   	push   %eax
  801a2e:	6a 1d                	push   $0x1d
  801a30:	e8 ad fc ff ff       	call   8016e2 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
	return result;
  801a38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a41:	89 01                	mov    %eax,(%ecx)
  801a43:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	c9                   	leave  
  801a4a:	c2 04 00             	ret    $0x4

00801a4d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	ff 75 10             	pushl  0x10(%ebp)
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	ff 75 08             	pushl  0x8(%ebp)
  801a5d:	6a 13                	push   $0x13
  801a5f:	e8 7e fc ff ff       	call   8016e2 <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
	return ;
  801a67:	90                   	nop
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_rcr2>:
uint32 sys_rcr2()
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 1e                	push   $0x1e
  801a79:	e8 64 fc ff ff       	call   8016e2 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a8f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	50                   	push   %eax
  801a9c:	6a 1f                	push   $0x1f
  801a9e:	e8 3f fc ff ff       	call   8016e2 <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa6:	90                   	nop
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <rsttst>:
void rsttst()
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 21                	push   $0x21
  801ab8:	e8 25 fc ff ff       	call   8016e2 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac0:	90                   	nop
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 04             	sub    $0x4,%esp
  801ac9:	8b 45 14             	mov    0x14(%ebp),%eax
  801acc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801acf:	8b 55 18             	mov    0x18(%ebp),%edx
  801ad2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad6:	52                   	push   %edx
  801ad7:	50                   	push   %eax
  801ad8:	ff 75 10             	pushl  0x10(%ebp)
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	ff 75 08             	pushl  0x8(%ebp)
  801ae1:	6a 20                	push   $0x20
  801ae3:	e8 fa fb ff ff       	call   8016e2 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
	return ;
  801aeb:	90                   	nop
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <chktst>:
void chktst(uint32 n)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 08             	pushl  0x8(%ebp)
  801afc:	6a 22                	push   $0x22
  801afe:	e8 df fb ff ff       	call   8016e2 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
	return ;
  801b06:	90                   	nop
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <inctst>:

void inctst()
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 23                	push   $0x23
  801b18:	e8 c5 fb ff ff       	call   8016e2 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b20:	90                   	nop
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <gettst>:
uint32 gettst()
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 24                	push   $0x24
  801b32:	e8 ab fb ff ff       	call   8016e2 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 25                	push   $0x25
  801b4e:	e8 8f fb ff ff       	call   8016e2 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
  801b56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b59:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b5d:	75 07                	jne    801b66 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b64:	eb 05                	jmp    801b6b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 25                	push   $0x25
  801b7f:	e8 5e fb ff ff       	call   8016e2 <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
  801b87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b8a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b8e:	75 07                	jne    801b97 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b90:	b8 01 00 00 00       	mov    $0x1,%eax
  801b95:	eb 05                	jmp    801b9c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 25                	push   $0x25
  801bb0:	e8 2d fb ff ff       	call   8016e2 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
  801bb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bbb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bbf:	75 07                	jne    801bc8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc6:	eb 05                	jmp    801bcd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 25                	push   $0x25
  801be1:	e8 fc fa ff ff       	call   8016e2 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
  801be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bf0:	75 07                	jne    801bf9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf7:	eb 05                	jmp    801bfe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	ff 75 08             	pushl  0x8(%ebp)
  801c0e:	6a 26                	push   $0x26
  801c10:	e8 cd fa ff ff       	call   8016e2 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
	return ;
  801c18:	90                   	nop
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	6a 00                	push   $0x0
  801c2d:	53                   	push   %ebx
  801c2e:	51                   	push   %ecx
  801c2f:	52                   	push   %edx
  801c30:	50                   	push   %eax
  801c31:	6a 27                	push   $0x27
  801c33:	e8 aa fa ff ff       	call   8016e2 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	52                   	push   %edx
  801c50:	50                   	push   %eax
  801c51:	6a 28                	push   $0x28
  801c53:	e8 8a fa ff ff       	call   8016e2 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c60:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	6a 00                	push   $0x0
  801c6b:	51                   	push   %ecx
  801c6c:	ff 75 10             	pushl  0x10(%ebp)
  801c6f:	52                   	push   %edx
  801c70:	50                   	push   %eax
  801c71:	6a 29                	push   $0x29
  801c73:	e8 6a fa ff ff       	call   8016e2 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	ff 75 10             	pushl  0x10(%ebp)
  801c87:	ff 75 0c             	pushl  0xc(%ebp)
  801c8a:	ff 75 08             	pushl  0x8(%ebp)
  801c8d:	6a 12                	push   $0x12
  801c8f:	e8 4e fa ff ff       	call   8016e2 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
	return ;
  801c97:	90                   	nop
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	52                   	push   %edx
  801caa:	50                   	push   %eax
  801cab:	6a 2a                	push   $0x2a
  801cad:	e8 30 fa ff ff       	call   8016e2 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
	return;
  801cb5:	90                   	nop
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	50                   	push   %eax
  801cc7:	6a 2b                	push   $0x2b
  801cc9:	e8 14 fa ff ff       	call   8016e2 <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	ff 75 0c             	pushl  0xc(%ebp)
  801cdf:	ff 75 08             	pushl  0x8(%ebp)
  801ce2:	6a 2c                	push   $0x2c
  801ce4:	e8 f9 f9 ff ff       	call   8016e2 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
	return;
  801cec:	90                   	nop
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	ff 75 0c             	pushl  0xc(%ebp)
  801cfb:	ff 75 08             	pushl  0x8(%ebp)
  801cfe:	6a 2d                	push   $0x2d
  801d00:	e8 dd f9 ff ff       	call   8016e2 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
	return;
  801d08:	90                   	nop
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    
  801d0b:	90                   	nop

00801d0c <__udivdi3>:
  801d0c:	55                   	push   %ebp
  801d0d:	57                   	push   %edi
  801d0e:	56                   	push   %esi
  801d0f:	53                   	push   %ebx
  801d10:	83 ec 1c             	sub    $0x1c,%esp
  801d13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d23:	89 ca                	mov    %ecx,%edx
  801d25:	89 f8                	mov    %edi,%eax
  801d27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d2b:	85 f6                	test   %esi,%esi
  801d2d:	75 2d                	jne    801d5c <__udivdi3+0x50>
  801d2f:	39 cf                	cmp    %ecx,%edi
  801d31:	77 65                	ja     801d98 <__udivdi3+0x8c>
  801d33:	89 fd                	mov    %edi,%ebp
  801d35:	85 ff                	test   %edi,%edi
  801d37:	75 0b                	jne    801d44 <__udivdi3+0x38>
  801d39:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3e:	31 d2                	xor    %edx,%edx
  801d40:	f7 f7                	div    %edi
  801d42:	89 c5                	mov    %eax,%ebp
  801d44:	31 d2                	xor    %edx,%edx
  801d46:	89 c8                	mov    %ecx,%eax
  801d48:	f7 f5                	div    %ebp
  801d4a:	89 c1                	mov    %eax,%ecx
  801d4c:	89 d8                	mov    %ebx,%eax
  801d4e:	f7 f5                	div    %ebp
  801d50:	89 cf                	mov    %ecx,%edi
  801d52:	89 fa                	mov    %edi,%edx
  801d54:	83 c4 1c             	add    $0x1c,%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5f                   	pop    %edi
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    
  801d5c:	39 ce                	cmp    %ecx,%esi
  801d5e:	77 28                	ja     801d88 <__udivdi3+0x7c>
  801d60:	0f bd fe             	bsr    %esi,%edi
  801d63:	83 f7 1f             	xor    $0x1f,%edi
  801d66:	75 40                	jne    801da8 <__udivdi3+0x9c>
  801d68:	39 ce                	cmp    %ecx,%esi
  801d6a:	72 0a                	jb     801d76 <__udivdi3+0x6a>
  801d6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d70:	0f 87 9e 00 00 00    	ja     801e14 <__udivdi3+0x108>
  801d76:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7b:	89 fa                	mov    %edi,%edx
  801d7d:	83 c4 1c             	add    $0x1c,%esp
  801d80:	5b                   	pop    %ebx
  801d81:	5e                   	pop    %esi
  801d82:	5f                   	pop    %edi
  801d83:	5d                   	pop    %ebp
  801d84:	c3                   	ret    
  801d85:	8d 76 00             	lea    0x0(%esi),%esi
  801d88:	31 ff                	xor    %edi,%edi
  801d8a:	31 c0                	xor    %eax,%eax
  801d8c:	89 fa                	mov    %edi,%edx
  801d8e:	83 c4 1c             	add    $0x1c,%esp
  801d91:	5b                   	pop    %ebx
  801d92:	5e                   	pop    %esi
  801d93:	5f                   	pop    %edi
  801d94:	5d                   	pop    %ebp
  801d95:	c3                   	ret    
  801d96:	66 90                	xchg   %ax,%ax
  801d98:	89 d8                	mov    %ebx,%eax
  801d9a:	f7 f7                	div    %edi
  801d9c:	31 ff                	xor    %edi,%edi
  801d9e:	89 fa                	mov    %edi,%edx
  801da0:	83 c4 1c             	add    $0x1c,%esp
  801da3:	5b                   	pop    %ebx
  801da4:	5e                   	pop    %esi
  801da5:	5f                   	pop    %edi
  801da6:	5d                   	pop    %ebp
  801da7:	c3                   	ret    
  801da8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801dad:	89 eb                	mov    %ebp,%ebx
  801daf:	29 fb                	sub    %edi,%ebx
  801db1:	89 f9                	mov    %edi,%ecx
  801db3:	d3 e6                	shl    %cl,%esi
  801db5:	89 c5                	mov    %eax,%ebp
  801db7:	88 d9                	mov    %bl,%cl
  801db9:	d3 ed                	shr    %cl,%ebp
  801dbb:	89 e9                	mov    %ebp,%ecx
  801dbd:	09 f1                	or     %esi,%ecx
  801dbf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801dc3:	89 f9                	mov    %edi,%ecx
  801dc5:	d3 e0                	shl    %cl,%eax
  801dc7:	89 c5                	mov    %eax,%ebp
  801dc9:	89 d6                	mov    %edx,%esi
  801dcb:	88 d9                	mov    %bl,%cl
  801dcd:	d3 ee                	shr    %cl,%esi
  801dcf:	89 f9                	mov    %edi,%ecx
  801dd1:	d3 e2                	shl    %cl,%edx
  801dd3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dd7:	88 d9                	mov    %bl,%cl
  801dd9:	d3 e8                	shr    %cl,%eax
  801ddb:	09 c2                	or     %eax,%edx
  801ddd:	89 d0                	mov    %edx,%eax
  801ddf:	89 f2                	mov    %esi,%edx
  801de1:	f7 74 24 0c          	divl   0xc(%esp)
  801de5:	89 d6                	mov    %edx,%esi
  801de7:	89 c3                	mov    %eax,%ebx
  801de9:	f7 e5                	mul    %ebp
  801deb:	39 d6                	cmp    %edx,%esi
  801ded:	72 19                	jb     801e08 <__udivdi3+0xfc>
  801def:	74 0b                	je     801dfc <__udivdi3+0xf0>
  801df1:	89 d8                	mov    %ebx,%eax
  801df3:	31 ff                	xor    %edi,%edi
  801df5:	e9 58 ff ff ff       	jmp    801d52 <__udivdi3+0x46>
  801dfa:	66 90                	xchg   %ax,%ax
  801dfc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e00:	89 f9                	mov    %edi,%ecx
  801e02:	d3 e2                	shl    %cl,%edx
  801e04:	39 c2                	cmp    %eax,%edx
  801e06:	73 e9                	jae    801df1 <__udivdi3+0xe5>
  801e08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e0b:	31 ff                	xor    %edi,%edi
  801e0d:	e9 40 ff ff ff       	jmp    801d52 <__udivdi3+0x46>
  801e12:	66 90                	xchg   %ax,%ax
  801e14:	31 c0                	xor    %eax,%eax
  801e16:	e9 37 ff ff ff       	jmp    801d52 <__udivdi3+0x46>
  801e1b:	90                   	nop

00801e1c <__umoddi3>:
  801e1c:	55                   	push   %ebp
  801e1d:	57                   	push   %edi
  801e1e:	56                   	push   %esi
  801e1f:	53                   	push   %ebx
  801e20:	83 ec 1c             	sub    $0x1c,%esp
  801e23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e27:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e3b:	89 f3                	mov    %esi,%ebx
  801e3d:	89 fa                	mov    %edi,%edx
  801e3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e43:	89 34 24             	mov    %esi,(%esp)
  801e46:	85 c0                	test   %eax,%eax
  801e48:	75 1a                	jne    801e64 <__umoddi3+0x48>
  801e4a:	39 f7                	cmp    %esi,%edi
  801e4c:	0f 86 a2 00 00 00    	jbe    801ef4 <__umoddi3+0xd8>
  801e52:	89 c8                	mov    %ecx,%eax
  801e54:	89 f2                	mov    %esi,%edx
  801e56:	f7 f7                	div    %edi
  801e58:	89 d0                	mov    %edx,%eax
  801e5a:	31 d2                	xor    %edx,%edx
  801e5c:	83 c4 1c             	add    $0x1c,%esp
  801e5f:	5b                   	pop    %ebx
  801e60:	5e                   	pop    %esi
  801e61:	5f                   	pop    %edi
  801e62:	5d                   	pop    %ebp
  801e63:	c3                   	ret    
  801e64:	39 f0                	cmp    %esi,%eax
  801e66:	0f 87 ac 00 00 00    	ja     801f18 <__umoddi3+0xfc>
  801e6c:	0f bd e8             	bsr    %eax,%ebp
  801e6f:	83 f5 1f             	xor    $0x1f,%ebp
  801e72:	0f 84 ac 00 00 00    	je     801f24 <__umoddi3+0x108>
  801e78:	bf 20 00 00 00       	mov    $0x20,%edi
  801e7d:	29 ef                	sub    %ebp,%edi
  801e7f:	89 fe                	mov    %edi,%esi
  801e81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e85:	89 e9                	mov    %ebp,%ecx
  801e87:	d3 e0                	shl    %cl,%eax
  801e89:	89 d7                	mov    %edx,%edi
  801e8b:	89 f1                	mov    %esi,%ecx
  801e8d:	d3 ef                	shr    %cl,%edi
  801e8f:	09 c7                	or     %eax,%edi
  801e91:	89 e9                	mov    %ebp,%ecx
  801e93:	d3 e2                	shl    %cl,%edx
  801e95:	89 14 24             	mov    %edx,(%esp)
  801e98:	89 d8                	mov    %ebx,%eax
  801e9a:	d3 e0                	shl    %cl,%eax
  801e9c:	89 c2                	mov    %eax,%edx
  801e9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ea2:	d3 e0                	shl    %cl,%eax
  801ea4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eac:	89 f1                	mov    %esi,%ecx
  801eae:	d3 e8                	shr    %cl,%eax
  801eb0:	09 d0                	or     %edx,%eax
  801eb2:	d3 eb                	shr    %cl,%ebx
  801eb4:	89 da                	mov    %ebx,%edx
  801eb6:	f7 f7                	div    %edi
  801eb8:	89 d3                	mov    %edx,%ebx
  801eba:	f7 24 24             	mull   (%esp)
  801ebd:	89 c6                	mov    %eax,%esi
  801ebf:	89 d1                	mov    %edx,%ecx
  801ec1:	39 d3                	cmp    %edx,%ebx
  801ec3:	0f 82 87 00 00 00    	jb     801f50 <__umoddi3+0x134>
  801ec9:	0f 84 91 00 00 00    	je     801f60 <__umoddi3+0x144>
  801ecf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ed3:	29 f2                	sub    %esi,%edx
  801ed5:	19 cb                	sbb    %ecx,%ebx
  801ed7:	89 d8                	mov    %ebx,%eax
  801ed9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801edd:	d3 e0                	shl    %cl,%eax
  801edf:	89 e9                	mov    %ebp,%ecx
  801ee1:	d3 ea                	shr    %cl,%edx
  801ee3:	09 d0                	or     %edx,%eax
  801ee5:	89 e9                	mov    %ebp,%ecx
  801ee7:	d3 eb                	shr    %cl,%ebx
  801ee9:	89 da                	mov    %ebx,%edx
  801eeb:	83 c4 1c             	add    $0x1c,%esp
  801eee:	5b                   	pop    %ebx
  801eef:	5e                   	pop    %esi
  801ef0:	5f                   	pop    %edi
  801ef1:	5d                   	pop    %ebp
  801ef2:	c3                   	ret    
  801ef3:	90                   	nop
  801ef4:	89 fd                	mov    %edi,%ebp
  801ef6:	85 ff                	test   %edi,%edi
  801ef8:	75 0b                	jne    801f05 <__umoddi3+0xe9>
  801efa:	b8 01 00 00 00       	mov    $0x1,%eax
  801eff:	31 d2                	xor    %edx,%edx
  801f01:	f7 f7                	div    %edi
  801f03:	89 c5                	mov    %eax,%ebp
  801f05:	89 f0                	mov    %esi,%eax
  801f07:	31 d2                	xor    %edx,%edx
  801f09:	f7 f5                	div    %ebp
  801f0b:	89 c8                	mov    %ecx,%eax
  801f0d:	f7 f5                	div    %ebp
  801f0f:	89 d0                	mov    %edx,%eax
  801f11:	e9 44 ff ff ff       	jmp    801e5a <__umoddi3+0x3e>
  801f16:	66 90                	xchg   %ax,%ax
  801f18:	89 c8                	mov    %ecx,%eax
  801f1a:	89 f2                	mov    %esi,%edx
  801f1c:	83 c4 1c             	add    $0x1c,%esp
  801f1f:	5b                   	pop    %ebx
  801f20:	5e                   	pop    %esi
  801f21:	5f                   	pop    %edi
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    
  801f24:	3b 04 24             	cmp    (%esp),%eax
  801f27:	72 06                	jb     801f2f <__umoddi3+0x113>
  801f29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f2d:	77 0f                	ja     801f3e <__umoddi3+0x122>
  801f2f:	89 f2                	mov    %esi,%edx
  801f31:	29 f9                	sub    %edi,%ecx
  801f33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f37:	89 14 24             	mov    %edx,(%esp)
  801f3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f42:	8b 14 24             	mov    (%esp),%edx
  801f45:	83 c4 1c             	add    $0x1c,%esp
  801f48:	5b                   	pop    %ebx
  801f49:	5e                   	pop    %esi
  801f4a:	5f                   	pop    %edi
  801f4b:	5d                   	pop    %ebp
  801f4c:	c3                   	ret    
  801f4d:	8d 76 00             	lea    0x0(%esi),%esi
  801f50:	2b 04 24             	sub    (%esp),%eax
  801f53:	19 fa                	sbb    %edi,%edx
  801f55:	89 d1                	mov    %edx,%ecx
  801f57:	89 c6                	mov    %eax,%esi
  801f59:	e9 71 ff ff ff       	jmp    801ecf <__umoddi3+0xb3>
  801f5e:	66 90                	xchg   %ax,%ax
  801f60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f64:	72 ea                	jb     801f50 <__umoddi3+0x134>
  801f66:	89 d9                	mov    %ebx,%ecx
  801f68:	e9 62 ff ff ff       	jmp    801ecf <__umoddi3+0xb3>
