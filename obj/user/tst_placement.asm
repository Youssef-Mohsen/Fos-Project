
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
  80004d:	e8 13 1c 00 00       	call   801c65 <sys_check_WS_list>
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800058:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 80 1f 80 00       	push   $0x801f80
  800066:	6a 15                	push   $0x15
  800068:	68 c1 1f 80 00       	push   $0x801fc1
  80006d:	e8 21 06 00 00       	call   800693 <_panic>

		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if( myEnv->page_last_WS_element !=  NULL)
  800072:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800077:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
  80007d:	85 c0                	test   %eax,%eax
  80007f:	74 14                	je     800095 <_main+0x5d>
			panic("INITIAL PAGE last WS checking failed! Review size of the WS..!!");
  800081:	83 ec 04             	sub    $0x4,%esp
  800084:	68 d8 1f 80 00       	push   $0x801fd8
  800089:	6a 19                	push   $0x19
  80008b:	68 c1 1f 80 00       	push   $0x801fc1
  800090:	e8 fe 05 00 00       	call   800693 <_panic>
		/*====================================*/
	}
	int eval = 0;
  800095:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  80009c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000a3:	e8 ad 17 00 00       	call   801855 <sys_pf_calculate_allocated_pages>
  8000a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freePages = sys_calculate_free_frames();
  8000ab:	e8 5a 17 00 00       	call   80180a <sys_calculate_free_frames>
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
  80012b:	e8 20 08 00 00       	call   800950 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800133:	8a 85 dc ff ff fe    	mov    -0x1000024(%ebp),%al
  800139:	3c 01                	cmp    $0x1,%al
  80013b:	74 17                	je     800154 <_main+0x11c>
  80013d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800144:	83 ec 0c             	sub    $0xc,%esp
  800147:	68 50 20 80 00       	push   $0x802050
  80014c:	e8 ff 07 00 00       	call   800950 <cprintf>
  800151:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800154:	8a 85 dc 0f 00 ff    	mov    -0xfff024(%ebp),%al
  80015a:	3c 01                	cmp    $0x1,%al
  80015c:	74 17                	je     800175 <_main+0x13d>
  80015e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	68 50 20 80 00       	push   $0x802050
  80016d:	e8 de 07 00 00       	call   800950 <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  2)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800175:	8a 85 dc ff 3f ff    	mov    -0xc00024(%ebp),%al
  80017b:	3c 02                	cmp    $0x2,%al
  80017d:	74 17                	je     800196 <_main+0x15e>
  80017f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 50 20 80 00       	push   $0x802050
  80018e:	e8 bd 07 00 00       	call   800950 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  2)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  800196:	8a 85 dc 0f 40 ff    	mov    -0xbff024(%ebp),%al
  80019c:	3c 02                	cmp    $0x2,%al
  80019e:	74 17                	je     8001b7 <_main+0x17f>
  8001a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 50 20 80 00       	push   $0x802050
  8001af:	e8 9c 07 00 00       	call   800950 <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  3)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001b7:	8a 85 dc ff 7f ff    	mov    -0x800024(%ebp),%al
  8001bd:	3c 03                	cmp    $0x3,%al
  8001bf:	74 17                	je     8001d8 <_main+0x1a0>
  8001c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001c8:	83 ec 0c             	sub    $0xc,%esp
  8001cb:	68 50 20 80 00       	push   $0x802050
  8001d0:	e8 7b 07 00 00       	call   800950 <cprintf>
  8001d5:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  3)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001d8:	8a 85 dc 0f 80 ff    	mov    -0x7ff024(%ebp),%al
  8001de:	3c 03                	cmp    $0x3,%al
  8001e0:	74 17                	je     8001f9 <_main+0x1c1>
  8001e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001e9:	83 ec 0c             	sub    $0xc,%esp
  8001ec:	68 50 20 80 00       	push   $0x802050
  8001f1:	e8 5a 07 00 00       	call   800950 <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT be written to Page File until evicted as victim\n");}
  8001f9:	e8 57 16 00 00       	call   801855 <sys_pf_calculate_allocated_pages>
  8001fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800201:	74 17                	je     80021a <_main+0x1e2>
  800203:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	68 70 20 80 00       	push   $0x802070
  800212:	e8 39 07 00 00       	call   800950 <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp

		int expected = 5 /*pages*/ + 2 /*tables*/;
  80021a:	c7 45 dc 07 00 00 00 	movl   $0x7,-0x24(%ebp)
		if( (freePages - sys_calculate_free_frames() ) != expected )
  800221:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800224:	e8 e1 15 00 00       	call   80180a <sys_calculate_free_frames>
  800229:	29 c3                	sub    %eax,%ebx
  80022b:	89 da                	mov    %ebx,%edx
  80022d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800230:	39 c2                	cmp    %eax,%edx
  800232:	74 27                	je     80025b <_main+0x223>
		{ is_correct = 0; cprintf("allocated memory size incorrect. Expected Difference = %d, Actual = %d\n", expected, (freePages - sys_calculate_free_frames() ));}
  800234:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80023b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80023e:	e8 c7 15 00 00       	call   80180a <sys_calculate_free_frames>
  800243:	29 c3                	sub    %eax,%ebx
  800245:	89 d8                	mov    %ebx,%eax
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	50                   	push   %eax
  80024b:	ff 75 dc             	pushl  -0x24(%ebp)
  80024e:	68 bc 20 80 00       	push   $0x8020bc
  800253:	e8 f8 06 00 00       	call   800950 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A finished: PLACEMENT fault handling !\n\n\n");
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 04 21 80 00       	push   $0x802104
  800263:	e8 e8 06 00 00       	call   800950 <cprintf>
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
  800284:	e8 c7 06 00 00       	call   800950 <cprintf>
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
  800357:	e8 09 19 00 00       	call   801c65 <sys_check_WS_list>
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1)
  800362:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800366:	74 17                	je     80037f <_main+0x347>
		{ is_correct = 0; cprintf("PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	68 5c 21 80 00       	push   $0x80215c
  800377:	e8 d4 05 00 00       	call   800950 <cprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B finished: WS entries test \n\n\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 b0 21 80 00       	push   $0x8021b0
  800387:	e8 c4 05 00 00       	call   800950 <cprintf>
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
  8003a8:	e8 a3 05 00 00       	call   800950 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
	{
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		if(myEnv->page_last_WS_element != NULL)
  8003b0:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8003b5:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	74 17                	je     8003d6 <_main+0x39e>
		{ is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}
  8003bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003c6:	83 ec 0c             	sub    $0xc,%esp
  8003c9:	68 14 22 80 00       	push   $0x802214
  8003ce:	e8 7d 05 00 00       	call   800950 <cprintf>
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
  800412:	e8 39 05 00 00       	call   800950 <cprintf>
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
  8004f2:	e8 6e 17 00 00       	call   801c65 <sys_check_WS_list>
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (found != 1)
  8004fd:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  800501:	74 17                	je     80051a <_main+0x4e2>
		{ is_correct = 0; cprintf("PAGE WS entry checking failed... trace it by printing page WS before & after fault\n");}
  800503:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80050a:	83 ec 0c             	sub    $0xc,%esp
  80050d:	68 5c 21 80 00       	push   $0x80215c
  800512:	e8 39 04 00 00       	call   800950 <cprintf>
  800517:	83 c4 10             	add    $0x10,%esp
		/*NO NEED FOR THIS IF REPL IS "LRU"*/
		//if(myEnv->page_last_WS_index != 0) { is_correct = 0; cprintf("wrong PAGE WS pointer location... trace it by printing page WS before & after fault\n");}

	}
	cprintf("STEP C finished: WS is FULL now\n\n\n");
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 6c 22 80 00       	push   $0x80226c
  800522:	e8 29 04 00 00       	call   800950 <cprintf>
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
  800546:	e8 05 04 00 00       	call   800950 <cprintf>
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
  80055a:	e8 74 14 00 00       	call   8019d3 <sys_getenvindex>
  80055f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800562:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800565:	89 d0                	mov    %edx,%eax
  800567:	c1 e0 03             	shl    $0x3,%eax
  80056a:	01 d0                	add    %edx,%eax
  80056c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800573:	01 c8                	add    %ecx,%eax
  800575:	01 c0                	add    %eax,%eax
  800577:	01 d0                	add    %edx,%eax
  800579:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800580:	01 c8                	add    %ecx,%eax
  800582:	01 d0                	add    %edx,%eax
  800584:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800589:	a3 3c 30 80 00       	mov    %eax,0x80303c

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80058e:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800593:	8a 40 20             	mov    0x20(%eax),%al
  800596:	84 c0                	test   %al,%al
  800598:	74 0d                	je     8005a7 <libmain+0x53>
		binaryname = myEnv->prog_name;
  80059a:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80059f:	83 c0 20             	add    $0x20,%eax
  8005a2:	a3 38 30 80 00       	mov    %eax,0x803038

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005ab:	7e 0a                	jle    8005b7 <libmain+0x63>
		binaryname = argv[0];
  8005ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	a3 38 30 80 00       	mov    %eax,0x803038

	// call user main routine
	_main(argc, argv);
  8005b7:	83 ec 08             	sub    $0x8,%esp
  8005ba:	ff 75 0c             	pushl  0xc(%ebp)
  8005bd:	ff 75 08             	pushl  0x8(%ebp)
  8005c0:	e8 73 fa ff ff       	call   800038 <_main>
  8005c5:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8005c8:	e8 8a 11 00 00       	call   801757 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8005cd:	83 ec 0c             	sub    $0xc,%esp
  8005d0:	68 dc 22 80 00       	push   $0x8022dc
  8005d5:	e8 76 03 00 00       	call   800950 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005dd:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8005e2:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005e8:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8005ed:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8005f3:	83 ec 04             	sub    $0x4,%esp
  8005f6:	52                   	push   %edx
  8005f7:	50                   	push   %eax
  8005f8:	68 04 23 80 00       	push   $0x802304
  8005fd:	e8 4e 03 00 00       	call   800950 <cprintf>
  800602:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800605:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80060a:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800610:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800615:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80061b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800620:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800626:	51                   	push   %ecx
  800627:	52                   	push   %edx
  800628:	50                   	push   %eax
  800629:	68 2c 23 80 00       	push   $0x80232c
  80062e:	e8 1d 03 00 00       	call   800950 <cprintf>
  800633:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800636:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80063b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	50                   	push   %eax
  800645:	68 84 23 80 00       	push   $0x802384
  80064a:	e8 01 03 00 00       	call   800950 <cprintf>
  80064f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800652:	83 ec 0c             	sub    $0xc,%esp
  800655:	68 dc 22 80 00       	push   $0x8022dc
  80065a:	e8 f1 02 00 00       	call   800950 <cprintf>
  80065f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800662:	e8 0a 11 00 00       	call   801771 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800667:	e8 19 00 00 00       	call   800685 <exit>
}
  80066c:	90                   	nop
  80066d:	c9                   	leave  
  80066e:	c3                   	ret    

0080066f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
  800672:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800675:	83 ec 0c             	sub    $0xc,%esp
  800678:	6a 00                	push   $0x0
  80067a:	e8 20 13 00 00       	call   80199f <sys_destroy_env>
  80067f:	83 c4 10             	add    $0x10,%esp
}
  800682:	90                   	nop
  800683:	c9                   	leave  
  800684:	c3                   	ret    

00800685 <exit>:

void
exit(void)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80068b:	e8 75 13 00 00       	call   801a05 <sys_exit_env>
}
  800690:	90                   	nop
  800691:	c9                   	leave  
  800692:	c3                   	ret    

00800693 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800693:	55                   	push   %ebp
  800694:	89 e5                	mov    %esp,%ebp
  800696:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800699:	8d 45 10             	lea    0x10(%ebp),%eax
  80069c:	83 c0 04             	add    $0x4,%eax
  80069f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006a2:	a1 64 30 80 00       	mov    0x803064,%eax
  8006a7:	85 c0                	test   %eax,%eax
  8006a9:	74 16                	je     8006c1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006ab:	a1 64 30 80 00       	mov    0x803064,%eax
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	50                   	push   %eax
  8006b4:	68 98 23 80 00       	push   $0x802398
  8006b9:	e8 92 02 00 00       	call   800950 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006c1:	a1 38 30 80 00       	mov    0x803038,%eax
  8006c6:	ff 75 0c             	pushl  0xc(%ebp)
  8006c9:	ff 75 08             	pushl  0x8(%ebp)
  8006cc:	50                   	push   %eax
  8006cd:	68 9d 23 80 00       	push   $0x80239d
  8006d2:	e8 79 02 00 00       	call   800950 <cprintf>
  8006d7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006da:	8b 45 10             	mov    0x10(%ebp),%eax
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e3:	50                   	push   %eax
  8006e4:	e8 fc 01 00 00       	call   8008e5 <vcprintf>
  8006e9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	6a 00                	push   $0x0
  8006f1:	68 b9 23 80 00       	push   $0x8023b9
  8006f6:	e8 ea 01 00 00       	call   8008e5 <vcprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8006fe:	e8 82 ff ff ff       	call   800685 <exit>

	// should not return here
	while (1) ;
  800703:	eb fe                	jmp    800703 <_panic+0x70>

00800705 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80070b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800710:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	39 c2                	cmp    %eax,%edx
  80071b:	74 14                	je     800731 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80071d:	83 ec 04             	sub    $0x4,%esp
  800720:	68 bc 23 80 00       	push   $0x8023bc
  800725:	6a 26                	push   $0x26
  800727:	68 08 24 80 00       	push   $0x802408
  80072c:	e8 62 ff ff ff       	call   800693 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800738:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80073f:	e9 c5 00 00 00       	jmp    800809 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800747:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	01 d0                	add    %edx,%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	85 c0                	test   %eax,%eax
  800757:	75 08                	jne    800761 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800759:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80075c:	e9 a5 00 00 00       	jmp    800806 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800761:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800768:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80076f:	eb 69                	jmp    8007da <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800771:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800776:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80077c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80077f:	89 d0                	mov    %edx,%eax
  800781:	01 c0                	add    %eax,%eax
  800783:	01 d0                	add    %edx,%eax
  800785:	c1 e0 03             	shl    $0x3,%eax
  800788:	01 c8                	add    %ecx,%eax
  80078a:	8a 40 04             	mov    0x4(%eax),%al
  80078d:	84 c0                	test   %al,%al
  80078f:	75 46                	jne    8007d7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800791:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800796:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80079c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80079f:	89 d0                	mov    %edx,%eax
  8007a1:	01 c0                	add    %eax,%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c1 e0 03             	shl    $0x3,%eax
  8007a8:	01 c8                	add    %ecx,%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007b7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	01 c8                	add    %ecx,%eax
  8007c8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ca:	39 c2                	cmp    %eax,%edx
  8007cc:	75 09                	jne    8007d7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8007ce:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007d5:	eb 15                	jmp    8007ec <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007d7:	ff 45 e8             	incl   -0x18(%ebp)
  8007da:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8007df:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8007e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e8:	39 c2                	cmp    %eax,%edx
  8007ea:	77 85                	ja     800771 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8007ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8007f0:	75 14                	jne    800806 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8007f2:	83 ec 04             	sub    $0x4,%esp
  8007f5:	68 14 24 80 00       	push   $0x802414
  8007fa:	6a 3a                	push   $0x3a
  8007fc:	68 08 24 80 00       	push   $0x802408
  800801:	e8 8d fe ff ff       	call   800693 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800806:	ff 45 f0             	incl   -0x10(%ebp)
  800809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80080f:	0f 8c 2f ff ff ff    	jl     800744 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800815:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80081c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800823:	eb 26                	jmp    80084b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800825:	a1 3c 30 80 00       	mov    0x80303c,%eax
  80082a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800830:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800833:	89 d0                	mov    %edx,%eax
  800835:	01 c0                	add    %eax,%eax
  800837:	01 d0                	add    %edx,%eax
  800839:	c1 e0 03             	shl    $0x3,%eax
  80083c:	01 c8                	add    %ecx,%eax
  80083e:	8a 40 04             	mov    0x4(%eax),%al
  800841:	3c 01                	cmp    $0x1,%al
  800843:	75 03                	jne    800848 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800845:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800848:	ff 45 e0             	incl   -0x20(%ebp)
  80084b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  800850:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800856:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800859:	39 c2                	cmp    %eax,%edx
  80085b:	77 c8                	ja     800825 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80085d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800860:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800863:	74 14                	je     800879 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800865:	83 ec 04             	sub    $0x4,%esp
  800868:	68 68 24 80 00       	push   $0x802468
  80086d:	6a 44                	push   $0x44
  80086f:	68 08 24 80 00       	push   $0x802408
  800874:	e8 1a fe ff ff       	call   800693 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800879:	90                   	nop
  80087a:	c9                   	leave  
  80087b:	c3                   	ret    

0080087c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800882:	8b 45 0c             	mov    0xc(%ebp),%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	8d 48 01             	lea    0x1(%eax),%ecx
  80088a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088d:	89 0a                	mov    %ecx,(%edx)
  80088f:	8b 55 08             	mov    0x8(%ebp),%edx
  800892:	88 d1                	mov    %dl,%cl
  800894:	8b 55 0c             	mov    0xc(%ebp),%edx
  800897:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80089b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008a5:	75 2c                	jne    8008d3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008a7:	a0 40 30 80 00       	mov    0x803040,%al
  8008ac:	0f b6 c0             	movzbl %al,%eax
  8008af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b2:	8b 12                	mov    (%edx),%edx
  8008b4:	89 d1                	mov    %edx,%ecx
  8008b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b9:	83 c2 08             	add    $0x8,%edx
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	50                   	push   %eax
  8008c0:	51                   	push   %ecx
  8008c1:	52                   	push   %edx
  8008c2:	e8 4e 0e 00 00       	call   801715 <sys_cputs>
  8008c7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d6:	8b 40 04             	mov    0x4(%eax),%eax
  8008d9:	8d 50 01             	lea    0x1(%eax),%edx
  8008dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008df:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008e2:	90                   	nop
  8008e3:	c9                   	leave  
  8008e4:	c3                   	ret    

008008e5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8008ee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008f5:	00 00 00 
	b.cnt = 0;
  8008f8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008ff:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	ff 75 08             	pushl  0x8(%ebp)
  800908:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80090e:	50                   	push   %eax
  80090f:	68 7c 08 80 00       	push   $0x80087c
  800914:	e8 11 02 00 00       	call   800b2a <vprintfmt>
  800919:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80091c:	a0 40 30 80 00       	mov    0x803040,%al
  800921:	0f b6 c0             	movzbl %al,%eax
  800924:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80092a:	83 ec 04             	sub    $0x4,%esp
  80092d:	50                   	push   %eax
  80092e:	52                   	push   %edx
  80092f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800935:	83 c0 08             	add    $0x8,%eax
  800938:	50                   	push   %eax
  800939:	e8 d7 0d 00 00       	call   801715 <sys_cputs>
  80093e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800941:	c6 05 40 30 80 00 00 	movb   $0x0,0x803040
	return b.cnt;
  800948:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80094e:	c9                   	leave  
  80094f:	c3                   	ret    

00800950 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800956:	c6 05 40 30 80 00 01 	movb   $0x1,0x803040
	va_start(ap, fmt);
  80095d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800960:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 f4             	pushl  -0xc(%ebp)
  80096c:	50                   	push   %eax
  80096d:	e8 73 ff ff ff       	call   8008e5 <vcprintf>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800978:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80097b:	c9                   	leave  
  80097c:	c3                   	ret    

0080097d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800983:	e8 cf 0d 00 00       	call   801757 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800988:	8d 45 0c             	lea    0xc(%ebp),%eax
  80098b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	83 ec 08             	sub    $0x8,%esp
  800994:	ff 75 f4             	pushl  -0xc(%ebp)
  800997:	50                   	push   %eax
  800998:	e8 48 ff ff ff       	call   8008e5 <vcprintf>
  80099d:	83 c4 10             	add    $0x10,%esp
  8009a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8009a3:	e8 c9 0d 00 00       	call   801771 <sys_unlock_cons>
	return cnt;
  8009a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ab:	c9                   	leave  
  8009ac:	c3                   	ret    

008009ad <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	53                   	push   %ebx
  8009b1:	83 ec 14             	sub    $0x14,%esp
  8009b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8009c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009cb:	77 55                	ja     800a22 <printnum+0x75>
  8009cd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009d0:	72 05                	jb     8009d7 <printnum+0x2a>
  8009d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009d5:	77 4b                	ja     800a22 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009d7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009da:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009dd:	8b 45 18             	mov    0x18(%ebp),%eax
  8009e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8009e5:	52                   	push   %edx
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ed:	e8 22 13 00 00       	call   801d14 <__udivdi3>
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	83 ec 04             	sub    $0x4,%esp
  8009f8:	ff 75 20             	pushl  0x20(%ebp)
  8009fb:	53                   	push   %ebx
  8009fc:	ff 75 18             	pushl  0x18(%ebp)
  8009ff:	52                   	push   %edx
  800a00:	50                   	push   %eax
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	e8 a1 ff ff ff       	call   8009ad <printnum>
  800a0c:	83 c4 20             	add    $0x20,%esp
  800a0f:	eb 1a                	jmp    800a2b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a11:	83 ec 08             	sub    $0x8,%esp
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	ff 75 20             	pushl  0x20(%ebp)
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	ff d0                	call   *%eax
  800a1f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a22:	ff 4d 1c             	decl   0x1c(%ebp)
  800a25:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a29:	7f e6                	jg     800a11 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a2b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a39:	53                   	push   %ebx
  800a3a:	51                   	push   %ecx
  800a3b:	52                   	push   %edx
  800a3c:	50                   	push   %eax
  800a3d:	e8 e2 13 00 00       	call   801e24 <__umoddi3>
  800a42:	83 c4 10             	add    $0x10,%esp
  800a45:	05 d4 26 80 00       	add    $0x8026d4,%eax
  800a4a:	8a 00                	mov    (%eax),%al
  800a4c:	0f be c0             	movsbl %al,%eax
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	50                   	push   %eax
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
}
  800a5e:	90                   	nop
  800a5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a62:	c9                   	leave  
  800a63:	c3                   	ret    

00800a64 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a67:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a6b:	7e 1c                	jle    800a89 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	8b 00                	mov    (%eax),%eax
  800a72:	8d 50 08             	lea    0x8(%eax),%edx
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	89 10                	mov    %edx,(%eax)
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	8b 00                	mov    (%eax),%eax
  800a7f:	83 e8 08             	sub    $0x8,%eax
  800a82:	8b 50 04             	mov    0x4(%eax),%edx
  800a85:	8b 00                	mov    (%eax),%eax
  800a87:	eb 40                	jmp    800ac9 <getuint+0x65>
	else if (lflag)
  800a89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8d:	74 1e                	je     800aad <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8b 00                	mov    (%eax),%eax
  800a94:	8d 50 04             	lea    0x4(%eax),%edx
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	89 10                	mov    %edx,(%eax)
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	83 e8 04             	sub    $0x4,%eax
  800aa4:	8b 00                	mov    (%eax),%eax
  800aa6:	ba 00 00 00 00       	mov    $0x0,%edx
  800aab:	eb 1c                	jmp    800ac9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	8d 50 04             	lea    0x4(%eax),%edx
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	89 10                	mov    %edx,(%eax)
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8b 00                	mov    (%eax),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ace:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ad2:	7e 1c                	jle    800af0 <getint+0x25>
		return va_arg(*ap, long long);
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	8d 50 08             	lea    0x8(%eax),%edx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	89 10                	mov    %edx,(%eax)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	83 e8 08             	sub    $0x8,%eax
  800ae9:	8b 50 04             	mov    0x4(%eax),%edx
  800aec:	8b 00                	mov    (%eax),%eax
  800aee:	eb 38                	jmp    800b28 <getint+0x5d>
	else if (lflag)
  800af0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af4:	74 1a                	je     800b10 <getint+0x45>
		return va_arg(*ap, long);
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 00                	mov    (%eax),%eax
  800afb:	8d 50 04             	lea    0x4(%eax),%edx
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	89 10                	mov    %edx,(%eax)
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	8b 00                	mov    (%eax),%eax
  800b08:	83 e8 04             	sub    $0x4,%eax
  800b0b:	8b 00                	mov    (%eax),%eax
  800b0d:	99                   	cltd   
  800b0e:	eb 18                	jmp    800b28 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	8b 00                	mov    (%eax),%eax
  800b15:	8d 50 04             	lea    0x4(%eax),%edx
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	89 10                	mov    %edx,(%eax)
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8b 00                	mov    (%eax),%eax
  800b22:	83 e8 04             	sub    $0x4,%eax
  800b25:	8b 00                	mov    (%eax),%eax
  800b27:	99                   	cltd   
}
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	56                   	push   %esi
  800b2e:	53                   	push   %ebx
  800b2f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b32:	eb 17                	jmp    800b4b <vprintfmt+0x21>
			if (ch == '\0')
  800b34:	85 db                	test   %ebx,%ebx
  800b36:	0f 84 c1 03 00 00    	je     800efd <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4e:	8d 50 01             	lea    0x1(%eax),%edx
  800b51:	89 55 10             	mov    %edx,0x10(%ebp)
  800b54:	8a 00                	mov    (%eax),%al
  800b56:	0f b6 d8             	movzbl %al,%ebx
  800b59:	83 fb 25             	cmp    $0x25,%ebx
  800b5c:	75 d6                	jne    800b34 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b5e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b62:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b69:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b70:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b77:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b81:	8d 50 01             	lea    0x1(%eax),%edx
  800b84:	89 55 10             	mov    %edx,0x10(%ebp)
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	0f b6 d8             	movzbl %al,%ebx
  800b8c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b8f:	83 f8 5b             	cmp    $0x5b,%eax
  800b92:	0f 87 3d 03 00 00    	ja     800ed5 <vprintfmt+0x3ab>
  800b98:	8b 04 85 f8 26 80 00 	mov    0x8026f8(,%eax,4),%eax
  800b9f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ba1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ba5:	eb d7                	jmp    800b7e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ba7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bab:	eb d1                	jmp    800b7e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bb4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bb7:	89 d0                	mov    %edx,%eax
  800bb9:	c1 e0 02             	shl    $0x2,%eax
  800bbc:	01 d0                	add    %edx,%eax
  800bbe:	01 c0                	add    %eax,%eax
  800bc0:	01 d8                	add    %ebx,%eax
  800bc2:	83 e8 30             	sub    $0x30,%eax
  800bc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcb:	8a 00                	mov    (%eax),%al
  800bcd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bd0:	83 fb 2f             	cmp    $0x2f,%ebx
  800bd3:	7e 3e                	jle    800c13 <vprintfmt+0xe9>
  800bd5:	83 fb 39             	cmp    $0x39,%ebx
  800bd8:	7f 39                	jg     800c13 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bda:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bdd:	eb d5                	jmp    800bb4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800be2:	83 c0 04             	add    $0x4,%eax
  800be5:	89 45 14             	mov    %eax,0x14(%ebp)
  800be8:	8b 45 14             	mov    0x14(%ebp),%eax
  800beb:	83 e8 04             	sub    $0x4,%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800bf3:	eb 1f                	jmp    800c14 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800bf5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf9:	79 83                	jns    800b7e <vprintfmt+0x54>
				width = 0;
  800bfb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c02:	e9 77 ff ff ff       	jmp    800b7e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c07:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c0e:	e9 6b ff ff ff       	jmp    800b7e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c13:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c18:	0f 89 60 ff ff ff    	jns    800b7e <vprintfmt+0x54>
				width = precision, precision = -1;
  800c1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c24:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c2b:	e9 4e ff ff ff       	jmp    800b7e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c30:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c33:	e9 46 ff ff ff       	jmp    800b7e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c38:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3b:	83 c0 04             	add    $0x4,%eax
  800c3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800c41:	8b 45 14             	mov    0x14(%ebp),%eax
  800c44:	83 e8 04             	sub    $0x4,%eax
  800c47:	8b 00                	mov    (%eax),%eax
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	50                   	push   %eax
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	ff d0                	call   *%eax
  800c55:	83 c4 10             	add    $0x10,%esp
			break;
  800c58:	e9 9b 02 00 00       	jmp    800ef8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c60:	83 c0 04             	add    $0x4,%eax
  800c63:	89 45 14             	mov    %eax,0x14(%ebp)
  800c66:	8b 45 14             	mov    0x14(%ebp),%eax
  800c69:	83 e8 04             	sub    $0x4,%eax
  800c6c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c6e:	85 db                	test   %ebx,%ebx
  800c70:	79 02                	jns    800c74 <vprintfmt+0x14a>
				err = -err;
  800c72:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c74:	83 fb 64             	cmp    $0x64,%ebx
  800c77:	7f 0b                	jg     800c84 <vprintfmt+0x15a>
  800c79:	8b 34 9d 40 25 80 00 	mov    0x802540(,%ebx,4),%esi
  800c80:	85 f6                	test   %esi,%esi
  800c82:	75 19                	jne    800c9d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c84:	53                   	push   %ebx
  800c85:	68 e5 26 80 00       	push   $0x8026e5
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	e8 70 02 00 00       	call   800f05 <printfmt>
  800c95:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c98:	e9 5b 02 00 00       	jmp    800ef8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c9d:	56                   	push   %esi
  800c9e:	68 ee 26 80 00       	push   $0x8026ee
  800ca3:	ff 75 0c             	pushl  0xc(%ebp)
  800ca6:	ff 75 08             	pushl  0x8(%ebp)
  800ca9:	e8 57 02 00 00       	call   800f05 <printfmt>
  800cae:	83 c4 10             	add    $0x10,%esp
			break;
  800cb1:	e9 42 02 00 00       	jmp    800ef8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb9:	83 c0 04             	add    $0x4,%eax
  800cbc:	89 45 14             	mov    %eax,0x14(%ebp)
  800cbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc2:	83 e8 04             	sub    $0x4,%eax
  800cc5:	8b 30                	mov    (%eax),%esi
  800cc7:	85 f6                	test   %esi,%esi
  800cc9:	75 05                	jne    800cd0 <vprintfmt+0x1a6>
				p = "(null)";
  800ccb:	be f1 26 80 00       	mov    $0x8026f1,%esi
			if (width > 0 && padc != '-')
  800cd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd4:	7e 6d                	jle    800d43 <vprintfmt+0x219>
  800cd6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cda:	74 67                	je     800d43 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cdf:	83 ec 08             	sub    $0x8,%esp
  800ce2:	50                   	push   %eax
  800ce3:	56                   	push   %esi
  800ce4:	e8 1e 03 00 00       	call   801007 <strnlen>
  800ce9:	83 c4 10             	add    $0x10,%esp
  800cec:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800cef:	eb 16                	jmp    800d07 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800cf1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	50                   	push   %eax
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	ff d0                	call   *%eax
  800d01:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d04:	ff 4d e4             	decl   -0x1c(%ebp)
  800d07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0b:	7f e4                	jg     800cf1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d0d:	eb 34                	jmp    800d43 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d0f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d13:	74 1c                	je     800d31 <vprintfmt+0x207>
  800d15:	83 fb 1f             	cmp    $0x1f,%ebx
  800d18:	7e 05                	jle    800d1f <vprintfmt+0x1f5>
  800d1a:	83 fb 7e             	cmp    $0x7e,%ebx
  800d1d:	7e 12                	jle    800d31 <vprintfmt+0x207>
					putch('?', putdat);
  800d1f:	83 ec 08             	sub    $0x8,%esp
  800d22:	ff 75 0c             	pushl  0xc(%ebp)
  800d25:	6a 3f                	push   $0x3f
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	ff d0                	call   *%eax
  800d2c:	83 c4 10             	add    $0x10,%esp
  800d2f:	eb 0f                	jmp    800d40 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d31:	83 ec 08             	sub    $0x8,%esp
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	53                   	push   %ebx
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	ff d0                	call   *%eax
  800d3d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d40:	ff 4d e4             	decl   -0x1c(%ebp)
  800d43:	89 f0                	mov    %esi,%eax
  800d45:	8d 70 01             	lea    0x1(%eax),%esi
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	0f be d8             	movsbl %al,%ebx
  800d4d:	85 db                	test   %ebx,%ebx
  800d4f:	74 24                	je     800d75 <vprintfmt+0x24b>
  800d51:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d55:	78 b8                	js     800d0f <vprintfmt+0x1e5>
  800d57:	ff 4d e0             	decl   -0x20(%ebp)
  800d5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d5e:	79 af                	jns    800d0f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d60:	eb 13                	jmp    800d75 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d62:	83 ec 08             	sub    $0x8,%esp
  800d65:	ff 75 0c             	pushl  0xc(%ebp)
  800d68:	6a 20                	push   $0x20
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	ff d0                	call   *%eax
  800d6f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d72:	ff 4d e4             	decl   -0x1c(%ebp)
  800d75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d79:	7f e7                	jg     800d62 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d7b:	e9 78 01 00 00       	jmp    800ef8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d80:	83 ec 08             	sub    $0x8,%esp
  800d83:	ff 75 e8             	pushl  -0x18(%ebp)
  800d86:	8d 45 14             	lea    0x14(%ebp),%eax
  800d89:	50                   	push   %eax
  800d8a:	e8 3c fd ff ff       	call   800acb <getint>
  800d8f:	83 c4 10             	add    $0x10,%esp
  800d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d95:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d9e:	85 d2                	test   %edx,%edx
  800da0:	79 23                	jns    800dc5 <vprintfmt+0x29b>
				putch('-', putdat);
  800da2:	83 ec 08             	sub    $0x8,%esp
  800da5:	ff 75 0c             	pushl  0xc(%ebp)
  800da8:	6a 2d                	push   $0x2d
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dad:	ff d0                	call   *%eax
  800daf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db8:	f7 d8                	neg    %eax
  800dba:	83 d2 00             	adc    $0x0,%edx
  800dbd:	f7 da                	neg    %edx
  800dbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800dc5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dcc:	e9 bc 00 00 00       	jmp    800e8d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dd1:	83 ec 08             	sub    $0x8,%esp
  800dd4:	ff 75 e8             	pushl  -0x18(%ebp)
  800dd7:	8d 45 14             	lea    0x14(%ebp),%eax
  800dda:	50                   	push   %eax
  800ddb:	e8 84 fc ff ff       	call   800a64 <getuint>
  800de0:	83 c4 10             	add    $0x10,%esp
  800de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800de6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800de9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800df0:	e9 98 00 00 00       	jmp    800e8d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800df5:	83 ec 08             	sub    $0x8,%esp
  800df8:	ff 75 0c             	pushl  0xc(%ebp)
  800dfb:	6a 58                	push   $0x58
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	ff d0                	call   *%eax
  800e02:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e05:	83 ec 08             	sub    $0x8,%esp
  800e08:	ff 75 0c             	pushl  0xc(%ebp)
  800e0b:	6a 58                	push   $0x58
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	ff d0                	call   *%eax
  800e12:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	6a 58                	push   $0x58
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	ff d0                	call   *%eax
  800e22:	83 c4 10             	add    $0x10,%esp
			break;
  800e25:	e9 ce 00 00 00       	jmp    800ef8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e2a:	83 ec 08             	sub    $0x8,%esp
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	6a 30                	push   $0x30
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	ff d0                	call   *%eax
  800e37:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 0c             	pushl  0xc(%ebp)
  800e40:	6a 78                	push   $0x78
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	ff d0                	call   *%eax
  800e47:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4d:	83 c0 04             	add    $0x4,%eax
  800e50:	89 45 14             	mov    %eax,0x14(%ebp)
  800e53:	8b 45 14             	mov    0x14(%ebp),%eax
  800e56:	83 e8 04             	sub    $0x4,%eax
  800e59:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e65:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e6c:	eb 1f                	jmp    800e8d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e6e:	83 ec 08             	sub    $0x8,%esp
  800e71:	ff 75 e8             	pushl  -0x18(%ebp)
  800e74:	8d 45 14             	lea    0x14(%ebp),%eax
  800e77:	50                   	push   %eax
  800e78:	e8 e7 fb ff ff       	call   800a64 <getuint>
  800e7d:	83 c4 10             	add    $0x10,%esp
  800e80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e83:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e8d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e94:	83 ec 04             	sub    $0x4,%esp
  800e97:	52                   	push   %edx
  800e98:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e9b:	50                   	push   %eax
  800e9c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e9f:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	ff 75 08             	pushl  0x8(%ebp)
  800ea8:	e8 00 fb ff ff       	call   8009ad <printnum>
  800ead:	83 c4 20             	add    $0x20,%esp
			break;
  800eb0:	eb 46                	jmp    800ef8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	53                   	push   %ebx
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	ff d0                	call   *%eax
  800ebe:	83 c4 10             	add    $0x10,%esp
			break;
  800ec1:	eb 35                	jmp    800ef8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ec3:	c6 05 40 30 80 00 00 	movb   $0x0,0x803040
			break;
  800eca:	eb 2c                	jmp    800ef8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ecc:	c6 05 40 30 80 00 01 	movb   $0x1,0x803040
			break;
  800ed3:	eb 23                	jmp    800ef8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ed5:	83 ec 08             	sub    $0x8,%esp
  800ed8:	ff 75 0c             	pushl  0xc(%ebp)
  800edb:	6a 25                	push   $0x25
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	ff d0                	call   *%eax
  800ee2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ee5:	ff 4d 10             	decl   0x10(%ebp)
  800ee8:	eb 03                	jmp    800eed <vprintfmt+0x3c3>
  800eea:	ff 4d 10             	decl   0x10(%ebp)
  800eed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef0:	48                   	dec    %eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	3c 25                	cmp    $0x25,%al
  800ef5:	75 f3                	jne    800eea <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ef7:	90                   	nop
		}
	}
  800ef8:	e9 35 fc ff ff       	jmp    800b32 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800efd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800efe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f0b:	8d 45 10             	lea    0x10(%ebp),%eax
  800f0e:	83 c0 04             	add    $0x4,%eax
  800f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f14:	8b 45 10             	mov    0x10(%ebp),%eax
  800f17:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1a:	50                   	push   %eax
  800f1b:	ff 75 0c             	pushl  0xc(%ebp)
  800f1e:	ff 75 08             	pushl  0x8(%ebp)
  800f21:	e8 04 fc ff ff       	call   800b2a <vprintfmt>
  800f26:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f29:	90                   	nop
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	8b 40 08             	mov    0x8(%eax),%eax
  800f35:	8d 50 01             	lea    0x1(%eax),%edx
  800f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	8b 10                	mov    (%eax),%edx
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8b 40 04             	mov    0x4(%eax),%eax
  800f49:	39 c2                	cmp    %eax,%edx
  800f4b:	73 12                	jae    800f5f <sprintputch+0x33>
		*b->buf++ = ch;
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	8b 00                	mov    (%eax),%eax
  800f52:	8d 48 01             	lea    0x1(%eax),%ecx
  800f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f58:	89 0a                	mov    %ecx,(%edx)
  800f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5d:	88 10                	mov    %dl,(%eax)
}
  800f5f:	90                   	nop
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    

00800f62 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	01 d0                	add    %edx,%eax
  800f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f87:	74 06                	je     800f8f <vsnprintf+0x2d>
  800f89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f8d:	7f 07                	jg     800f96 <vsnprintf+0x34>
		return -E_INVAL;
  800f8f:	b8 03 00 00 00       	mov    $0x3,%eax
  800f94:	eb 20                	jmp    800fb6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f96:	ff 75 14             	pushl  0x14(%ebp)
  800f99:	ff 75 10             	pushl  0x10(%ebp)
  800f9c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f9f:	50                   	push   %eax
  800fa0:	68 2c 0f 80 00       	push   $0x800f2c
  800fa5:	e8 80 fb ff ff       	call   800b2a <vprintfmt>
  800faa:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fb6:	c9                   	leave  
  800fb7:	c3                   	ret    

00800fb8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fbe:	8d 45 10             	lea    0x10(%ebp),%eax
  800fc1:	83 c0 04             	add    $0x4,%eax
  800fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	ff 75 f4             	pushl  -0xc(%ebp)
  800fcd:	50                   	push   %eax
  800fce:	ff 75 0c             	pushl  0xc(%ebp)
  800fd1:	ff 75 08             	pushl  0x8(%ebp)
  800fd4:	e8 89 ff ff ff       	call   800f62 <vsnprintf>
  800fd9:	83 c4 10             	add    $0x10,%esp
  800fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff1:	eb 06                	jmp    800ff9 <strlen+0x15>
		n++;
  800ff3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	84 c0                	test   %al,%al
  801000:	75 f1                	jne    800ff3 <strlen+0xf>
		n++;
	return n;
  801002:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801005:	c9                   	leave  
  801006:	c3                   	ret    

00801007 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80100d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801014:	eb 09                	jmp    80101f <strnlen+0x18>
		n++;
  801016:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	ff 4d 0c             	decl   0xc(%ebp)
  80101f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801023:	74 09                	je     80102e <strnlen+0x27>
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	84 c0                	test   %al,%al
  80102c:	75 e8                	jne    801016 <strnlen+0xf>
		n++;
	return n;
  80102e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801031:	c9                   	leave  
  801032:	c3                   	ret    

00801033 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80103f:	90                   	nop
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8d 50 01             	lea    0x1(%eax),%edx
  801046:	89 55 08             	mov    %edx,0x8(%ebp)
  801049:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801052:	8a 12                	mov    (%edx),%dl
  801054:	88 10                	mov    %dl,(%eax)
  801056:	8a 00                	mov    (%eax),%al
  801058:	84 c0                	test   %al,%al
  80105a:	75 e4                	jne    801040 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80105c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80106d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801074:	eb 1f                	jmp    801095 <strncpy+0x34>
		*dst++ = *src;
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8d 50 01             	lea    0x1(%eax),%edx
  80107c:	89 55 08             	mov    %edx,0x8(%ebp)
  80107f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801082:	8a 12                	mov    (%edx),%dl
  801084:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801086:	8b 45 0c             	mov    0xc(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	84 c0                	test   %al,%al
  80108d:	74 03                	je     801092 <strncpy+0x31>
			src++;
  80108f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801092:	ff 45 fc             	incl   -0x4(%ebp)
  801095:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801098:	3b 45 10             	cmp    0x10(%ebp),%eax
  80109b:	72 d9                	jb     801076 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80109d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b2:	74 30                	je     8010e4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010b4:	eb 16                	jmp    8010cc <strlcpy+0x2a>
			*dst++ = *src++;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8d 50 01             	lea    0x1(%eax),%edx
  8010bc:	89 55 08             	mov    %edx,0x8(%ebp)
  8010bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c8:	8a 12                	mov    (%edx),%dl
  8010ca:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010cc:	ff 4d 10             	decl   0x10(%ebp)
  8010cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d3:	74 09                	je     8010de <strlcpy+0x3c>
  8010d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	84 c0                	test   %al,%al
  8010dc:	75 d8                	jne    8010b6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ea:	29 c2                	sub    %eax,%edx
  8010ec:	89 d0                	mov    %edx,%eax
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010f3:	eb 06                	jmp    8010fb <strcmp+0xb>
		p++, q++;
  8010f5:	ff 45 08             	incl   0x8(%ebp)
  8010f8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	84 c0                	test   %al,%al
  801102:	74 0e                	je     801112 <strcmp+0x22>
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 10                	mov    (%eax),%dl
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	8a 00                	mov    (%eax),%al
  80110e:	38 c2                	cmp    %al,%dl
  801110:	74 e3                	je     8010f5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	0f b6 d0             	movzbl %al,%edx
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	8a 00                	mov    (%eax),%al
  80111f:	0f b6 c0             	movzbl %al,%eax
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
}
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80112b:	eb 09                	jmp    801136 <strncmp+0xe>
		n--, p++, q++;
  80112d:	ff 4d 10             	decl   0x10(%ebp)
  801130:	ff 45 08             	incl   0x8(%ebp)
  801133:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801136:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113a:	74 17                	je     801153 <strncmp+0x2b>
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	84 c0                	test   %al,%al
  801143:	74 0e                	je     801153 <strncmp+0x2b>
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 10                	mov    (%eax),%dl
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	38 c2                	cmp    %al,%dl
  801151:	74 da                	je     80112d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801153:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801157:	75 07                	jne    801160 <strncmp+0x38>
		return 0;
  801159:	b8 00 00 00 00       	mov    $0x0,%eax
  80115e:	eb 14                	jmp    801174 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	0f b6 d0             	movzbl %al,%edx
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	0f b6 c0             	movzbl %al,%eax
  801170:	29 c2                	sub    %eax,%edx
  801172:	89 d0                	mov    %edx,%eax
}
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    

00801176 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 04             	sub    $0x4,%esp
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801182:	eb 12                	jmp    801196 <strchr+0x20>
		if (*s == c)
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80118c:	75 05                	jne    801193 <strchr+0x1d>
			return (char *) s;
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	eb 11                	jmp    8011a4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	84 c0                	test   %al,%al
  80119d:	75 e5                	jne    801184 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80119f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	83 ec 04             	sub    $0x4,%esp
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b2:	eb 0d                	jmp    8011c1 <strfind+0x1b>
		if (*s == c)
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011bc:	74 0e                	je     8011cc <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011be:	ff 45 08             	incl   0x8(%ebp)
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	84 c0                	test   %al,%al
  8011c8:	75 ea                	jne    8011b4 <strfind+0xe>
  8011ca:	eb 01                	jmp    8011cd <strfind+0x27>
		if (*s == c)
			break;
  8011cc:	90                   	nop
	return (char *) s;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    

008011d2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011e4:	eb 0e                	jmp    8011f4 <memset+0x22>
		*p++ = c;
  8011e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ec:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011f4:	ff 4d f8             	decl   -0x8(%ebp)
  8011f7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8011fb:	79 e9                	jns    8011e6 <memset+0x14>
		*p++ = c;

	return v;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801200:	c9                   	leave  
  801201:	c3                   	ret    

00801202 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801214:	eb 16                	jmp    80122c <memcpy+0x2a>
		*d++ = *s++;
  801216:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801219:	8d 50 01             	lea    0x1(%eax),%edx
  80121c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801222:	8d 4a 01             	lea    0x1(%edx),%ecx
  801225:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801228:	8a 12                	mov    (%edx),%dl
  80122a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80122c:	8b 45 10             	mov    0x10(%ebp),%eax
  80122f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801232:	89 55 10             	mov    %edx,0x10(%ebp)
  801235:	85 c0                	test   %eax,%eax
  801237:	75 dd                	jne    801216 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801244:	8b 45 0c             	mov    0xc(%ebp),%eax
  801247:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801250:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801253:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801256:	73 50                	jae    8012a8 <memmove+0x6a>
  801258:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	01 d0                	add    %edx,%eax
  801260:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801263:	76 43                	jbe    8012a8 <memmove+0x6a>
		s += n;
  801265:	8b 45 10             	mov    0x10(%ebp),%eax
  801268:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801271:	eb 10                	jmp    801283 <memmove+0x45>
			*--d = *--s;
  801273:	ff 4d f8             	decl   -0x8(%ebp)
  801276:	ff 4d fc             	decl   -0x4(%ebp)
  801279:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80127c:	8a 10                	mov    (%eax),%dl
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801281:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801283:	8b 45 10             	mov    0x10(%ebp),%eax
  801286:	8d 50 ff             	lea    -0x1(%eax),%edx
  801289:	89 55 10             	mov    %edx,0x10(%ebp)
  80128c:	85 c0                	test   %eax,%eax
  80128e:	75 e3                	jne    801273 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801290:	eb 23                	jmp    8012b5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801292:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801295:	8d 50 01             	lea    0x1(%eax),%edx
  801298:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80129b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129e:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012a4:	8a 12                	mov    (%edx),%dl
  8012a6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	75 dd                	jne    801292 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b8:	c9                   	leave  
  8012b9:	c3                   	ret    

008012ba <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012cc:	eb 2a                	jmp    8012f8 <memcmp+0x3e>
		if (*s1 != *s2)
  8012ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d1:	8a 10                	mov    (%eax),%dl
  8012d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	38 c2                	cmp    %al,%dl
  8012da:	74 16                	je     8012f2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	0f b6 d0             	movzbl %al,%edx
  8012e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	0f b6 c0             	movzbl %al,%eax
  8012ec:	29 c2                	sub    %eax,%edx
  8012ee:	89 d0                	mov    %edx,%eax
  8012f0:	eb 18                	jmp    80130a <memcmp+0x50>
		s1++, s2++;
  8012f2:	ff 45 fc             	incl   -0x4(%ebp)
  8012f5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012fe:	89 55 10             	mov    %edx,0x10(%ebp)
  801301:	85 c0                	test   %eax,%eax
  801303:	75 c9                	jne    8012ce <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801305:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801312:	8b 55 08             	mov    0x8(%ebp),%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80131d:	eb 15                	jmp    801334 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f b6 d0             	movzbl %al,%edx
  801327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132a:	0f b6 c0             	movzbl %al,%eax
  80132d:	39 c2                	cmp    %eax,%edx
  80132f:	74 0d                	je     80133e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801331:	ff 45 08             	incl   0x8(%ebp)
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80133a:	72 e3                	jb     80131f <memfind+0x13>
  80133c:	eb 01                	jmp    80133f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80133e:	90                   	nop
	return (void *) s;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801342:	c9                   	leave  
  801343:	c3                   	ret    

00801344 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80134a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801351:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801358:	eb 03                	jmp    80135d <strtol+0x19>
		s++;
  80135a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	8a 00                	mov    (%eax),%al
  801362:	3c 20                	cmp    $0x20,%al
  801364:	74 f4                	je     80135a <strtol+0x16>
  801366:	8b 45 08             	mov    0x8(%ebp),%eax
  801369:	8a 00                	mov    (%eax),%al
  80136b:	3c 09                	cmp    $0x9,%al
  80136d:	74 eb                	je     80135a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	8a 00                	mov    (%eax),%al
  801374:	3c 2b                	cmp    $0x2b,%al
  801376:	75 05                	jne    80137d <strtol+0x39>
		s++;
  801378:	ff 45 08             	incl   0x8(%ebp)
  80137b:	eb 13                	jmp    801390 <strtol+0x4c>
	else if (*s == '-')
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	8a 00                	mov    (%eax),%al
  801382:	3c 2d                	cmp    $0x2d,%al
  801384:	75 0a                	jne    801390 <strtol+0x4c>
		s++, neg = 1;
  801386:	ff 45 08             	incl   0x8(%ebp)
  801389:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801390:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801394:	74 06                	je     80139c <strtol+0x58>
  801396:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80139a:	75 20                	jne    8013bc <strtol+0x78>
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	3c 30                	cmp    $0x30,%al
  8013a3:	75 17                	jne    8013bc <strtol+0x78>
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	40                   	inc    %eax
  8013a9:	8a 00                	mov    (%eax),%al
  8013ab:	3c 78                	cmp    $0x78,%al
  8013ad:	75 0d                	jne    8013bc <strtol+0x78>
		s += 2, base = 16;
  8013af:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013b3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013ba:	eb 28                	jmp    8013e4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c0:	75 15                	jne    8013d7 <strtol+0x93>
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	3c 30                	cmp    $0x30,%al
  8013c9:	75 0c                	jne    8013d7 <strtol+0x93>
		s++, base = 8;
  8013cb:	ff 45 08             	incl   0x8(%ebp)
  8013ce:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013d5:	eb 0d                	jmp    8013e4 <strtol+0xa0>
	else if (base == 0)
  8013d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013db:	75 07                	jne    8013e4 <strtol+0xa0>
		base = 10;
  8013dd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	3c 2f                	cmp    $0x2f,%al
  8013eb:	7e 19                	jle    801406 <strtol+0xc2>
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	3c 39                	cmp    $0x39,%al
  8013f4:	7f 10                	jg     801406 <strtol+0xc2>
			dig = *s - '0';
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	0f be c0             	movsbl %al,%eax
  8013fe:	83 e8 30             	sub    $0x30,%eax
  801401:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801404:	eb 42                	jmp    801448 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	3c 60                	cmp    $0x60,%al
  80140d:	7e 19                	jle    801428 <strtol+0xe4>
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	3c 7a                	cmp    $0x7a,%al
  801416:	7f 10                	jg     801428 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	0f be c0             	movsbl %al,%eax
  801420:	83 e8 57             	sub    $0x57,%eax
  801423:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801426:	eb 20                	jmp    801448 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	3c 40                	cmp    $0x40,%al
  80142f:	7e 39                	jle    80146a <strtol+0x126>
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	3c 5a                	cmp    $0x5a,%al
  801438:	7f 30                	jg     80146a <strtol+0x126>
			dig = *s - 'A' + 10;
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	8a 00                	mov    (%eax),%al
  80143f:	0f be c0             	movsbl %al,%eax
  801442:	83 e8 37             	sub    $0x37,%eax
  801445:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80144e:	7d 19                	jge    801469 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801450:	ff 45 08             	incl   0x8(%ebp)
  801453:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801456:	0f af 45 10          	imul   0x10(%ebp),%eax
  80145a:	89 c2                	mov    %eax,%edx
  80145c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145f:	01 d0                	add    %edx,%eax
  801461:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801464:	e9 7b ff ff ff       	jmp    8013e4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801469:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80146a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80146e:	74 08                	je     801478 <strtol+0x134>
		*endptr = (char *) s;
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	8b 55 08             	mov    0x8(%ebp),%edx
  801476:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801478:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80147c:	74 07                	je     801485 <strtol+0x141>
  80147e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801481:	f7 d8                	neg    %eax
  801483:	eb 03                	jmp    801488 <strtol+0x144>
  801485:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <ltostr>:

void
ltostr(long value, char *str)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801490:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801497:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80149e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a2:	79 13                	jns    8014b7 <ltostr+0x2d>
	{
		neg = 1;
  8014a4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ae:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014b1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014b4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014bf:	99                   	cltd   
  8014c0:	f7 f9                	idiv   %ecx
  8014c2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c8:	8d 50 01             	lea    0x1(%eax),%edx
  8014cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ce:	89 c2                	mov    %eax,%edx
  8014d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d3:	01 d0                	add    %edx,%eax
  8014d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014d8:	83 c2 30             	add    $0x30,%edx
  8014db:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014e5:	f7 e9                	imul   %ecx
  8014e7:	c1 fa 02             	sar    $0x2,%edx
  8014ea:	89 c8                	mov    %ecx,%eax
  8014ec:	c1 f8 1f             	sar    $0x1f,%eax
  8014ef:	29 c2                	sub    %eax,%edx
  8014f1:	89 d0                	mov    %edx,%eax
  8014f3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8014f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014fa:	75 bb                	jne    8014b7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8014fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801503:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801506:	48                   	dec    %eax
  801507:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80150a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80150e:	74 3d                	je     80154d <ltostr+0xc3>
		start = 1 ;
  801510:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801517:	eb 34                	jmp    80154d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801519:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	01 d0                	add    %edx,%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152c:	01 c2                	add    %eax,%edx
  80152e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801531:	8b 45 0c             	mov    0xc(%ebp),%eax
  801534:	01 c8                	add    %ecx,%eax
  801536:	8a 00                	mov    (%eax),%al
  801538:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80153a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80153d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801540:	01 c2                	add    %eax,%edx
  801542:	8a 45 eb             	mov    -0x15(%ebp),%al
  801545:	88 02                	mov    %al,(%edx)
		start++ ;
  801547:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80154a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80154d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801550:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801553:	7c c4                	jl     801519 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801555:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155b:	01 d0                	add    %edx,%eax
  80155d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801560:	90                   	nop
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801569:	ff 75 08             	pushl  0x8(%ebp)
  80156c:	e8 73 fa ff ff       	call   800fe4 <strlen>
  801571:	83 c4 04             	add    $0x4,%esp
  801574:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	e8 65 fa ff ff       	call   800fe4 <strlen>
  80157f:	83 c4 04             	add    $0x4,%esp
  801582:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801585:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80158c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801593:	eb 17                	jmp    8015ac <strcconcat+0x49>
		final[s] = str1[s] ;
  801595:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801598:	8b 45 10             	mov    0x10(%ebp),%eax
  80159b:	01 c2                	add    %eax,%edx
  80159d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	01 c8                	add    %ecx,%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015a9:	ff 45 fc             	incl   -0x4(%ebp)
  8015ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015b2:	7c e1                	jl     801595 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015c2:	eb 1f                	jmp    8015e3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c7:	8d 50 01             	lea    0x1(%eax),%edx
  8015ca:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015cd:	89 c2                	mov    %eax,%edx
  8015cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d2:	01 c2                	add    %eax,%edx
  8015d4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015da:	01 c8                	add    %ecx,%eax
  8015dc:	8a 00                	mov    (%eax),%al
  8015de:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015e0:	ff 45 f8             	incl   -0x8(%ebp)
  8015e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e9:	7c d9                	jl     8015c4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	c6 00 00             	movb   $0x0,(%eax)
}
  8015f6:	90                   	nop
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8015fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801605:	8b 45 14             	mov    0x14(%ebp),%eax
  801608:	8b 00                	mov    (%eax),%eax
  80160a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801611:	8b 45 10             	mov    0x10(%ebp),%eax
  801614:	01 d0                	add    %edx,%eax
  801616:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80161c:	eb 0c                	jmp    80162a <strsplit+0x31>
			*string++ = 0;
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	8d 50 01             	lea    0x1(%eax),%edx
  801624:	89 55 08             	mov    %edx,0x8(%ebp)
  801627:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	84 c0                	test   %al,%al
  801631:	74 18                	je     80164b <strsplit+0x52>
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	8a 00                	mov    (%eax),%al
  801638:	0f be c0             	movsbl %al,%eax
  80163b:	50                   	push   %eax
  80163c:	ff 75 0c             	pushl  0xc(%ebp)
  80163f:	e8 32 fb ff ff       	call   801176 <strchr>
  801644:	83 c4 08             	add    $0x8,%esp
  801647:	85 c0                	test   %eax,%eax
  801649:	75 d3                	jne    80161e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	84 c0                	test   %al,%al
  801652:	74 5a                	je     8016ae <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801654:	8b 45 14             	mov    0x14(%ebp),%eax
  801657:	8b 00                	mov    (%eax),%eax
  801659:	83 f8 0f             	cmp    $0xf,%eax
  80165c:	75 07                	jne    801665 <strsplit+0x6c>
		{
			return 0;
  80165e:	b8 00 00 00 00       	mov    $0x0,%eax
  801663:	eb 66                	jmp    8016cb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801665:	8b 45 14             	mov    0x14(%ebp),%eax
  801668:	8b 00                	mov    (%eax),%eax
  80166a:	8d 48 01             	lea    0x1(%eax),%ecx
  80166d:	8b 55 14             	mov    0x14(%ebp),%edx
  801670:	89 0a                	mov    %ecx,(%edx)
  801672:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801679:	8b 45 10             	mov    0x10(%ebp),%eax
  80167c:	01 c2                	add    %eax,%edx
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801683:	eb 03                	jmp    801688 <strsplit+0x8f>
			string++;
  801685:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8a 00                	mov    (%eax),%al
  80168d:	84 c0                	test   %al,%al
  80168f:	74 8b                	je     80161c <strsplit+0x23>
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	0f be c0             	movsbl %al,%eax
  801699:	50                   	push   %eax
  80169a:	ff 75 0c             	pushl  0xc(%ebp)
  80169d:	e8 d4 fa ff ff       	call   801176 <strchr>
  8016a2:	83 c4 08             	add    $0x8,%esp
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	74 dc                	je     801685 <strsplit+0x8c>
			string++;
	}
  8016a9:	e9 6e ff ff ff       	jmp    80161c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016ae:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016af:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b2:	8b 00                	mov    (%eax),%eax
  8016b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016be:	01 d0                	add    %edx,%eax
  8016c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8016d3:	83 ec 04             	sub    $0x4,%esp
  8016d6:	68 68 28 80 00       	push   $0x802868
  8016db:	68 3f 01 00 00       	push   $0x13f
  8016e0:	68 8a 28 80 00       	push   $0x80288a
  8016e5:	e8 a9 ef ff ff       	call   800693 <_panic>

008016ea <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	57                   	push   %edi
  8016ee:	56                   	push   %esi
  8016ef:	53                   	push   %ebx
  8016f0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ff:	8b 7d 18             	mov    0x18(%ebp),%edi
  801702:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801705:	cd 30                	int    $0x30
  801707:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80170a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	5b                   	pop    %ebx
  801711:	5e                   	pop    %esi
  801712:	5f                   	pop    %edi
  801713:	5d                   	pop    %ebp
  801714:	c3                   	ret    

00801715 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	8b 45 10             	mov    0x10(%ebp),%eax
  80171e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801721:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	52                   	push   %edx
  80172d:	ff 75 0c             	pushl  0xc(%ebp)
  801730:	50                   	push   %eax
  801731:	6a 00                	push   $0x0
  801733:	e8 b2 ff ff ff       	call   8016ea <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_cgetc>:

int
sys_cgetc(void)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 02                	push   $0x2
  80174d:	e8 98 ff ff ff       	call   8016ea <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 03                	push   $0x3
  801766:	e8 7f ff ff ff       	call   8016ea <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	90                   	nop
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 04                	push   $0x4
  801780:	e8 65 ff ff ff       	call   8016ea <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	90                   	nop
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	52                   	push   %edx
  80179b:	50                   	push   %eax
  80179c:	6a 08                	push   $0x8
  80179e:	e8 47 ff ff ff       	call   8016ea <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	56                   	push   %esi
  8017ac:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017ad:	8b 75 18             	mov    0x18(%ebp),%esi
  8017b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	56                   	push   %esi
  8017bd:	53                   	push   %ebx
  8017be:	51                   	push   %ecx
  8017bf:	52                   	push   %edx
  8017c0:	50                   	push   %eax
  8017c1:	6a 09                	push   $0x9
  8017c3:	e8 22 ff ff ff       	call   8016ea <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ce:	5b                   	pop    %ebx
  8017cf:	5e                   	pop    %esi
  8017d0:	5d                   	pop    %ebp
  8017d1:	c3                   	ret    

008017d2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	52                   	push   %edx
  8017e2:	50                   	push   %eax
  8017e3:	6a 0a                	push   $0xa
  8017e5:	e8 00 ff ff ff       	call   8016ea <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	ff 75 0c             	pushl  0xc(%ebp)
  8017fb:	ff 75 08             	pushl  0x8(%ebp)
  8017fe:	6a 0b                	push   $0xb
  801800:	e8 e5 fe ff ff       	call   8016ea <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 0c                	push   $0xc
  801819:	e8 cc fe ff ff       	call   8016ea <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 0d                	push   $0xd
  801832:	e8 b3 fe ff ff       	call   8016ea <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 0e                	push   $0xe
  80184b:	e8 9a fe ff ff       	call   8016ea <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 0f                	push   $0xf
  801864:	e8 81 fe ff ff       	call   8016ea <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	ff 75 08             	pushl  0x8(%ebp)
  80187c:	6a 10                	push   $0x10
  80187e:	e8 67 fe ff ff       	call   8016ea <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 11                	push   $0x11
  801897:	e8 4e fe ff ff       	call   8016ea <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	90                   	nop
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_cputc>:

void
sys_cputc(const char c)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 04             	sub    $0x4,%esp
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018ae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	50                   	push   %eax
  8018bb:	6a 01                	push   $0x1
  8018bd:	e8 28 fe ff ff       	call   8016ea <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	90                   	nop
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 14                	push   $0x14
  8018d7:	e8 0e fe ff ff       	call   8016ea <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	90                   	nop
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 04             	sub    $0x4,%esp
  8018e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018ee:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018f1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	51                   	push   %ecx
  8018fb:	52                   	push   %edx
  8018fc:	ff 75 0c             	pushl  0xc(%ebp)
  8018ff:	50                   	push   %eax
  801900:	6a 15                	push   $0x15
  801902:	e8 e3 fd ff ff       	call   8016ea <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80190f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	52                   	push   %edx
  80191c:	50                   	push   %eax
  80191d:	6a 16                	push   $0x16
  80191f:	e8 c6 fd ff ff       	call   8016ea <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80192c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	51                   	push   %ecx
  80193a:	52                   	push   %edx
  80193b:	50                   	push   %eax
  80193c:	6a 17                	push   $0x17
  80193e:	e8 a7 fd ff ff       	call   8016ea <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80194b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	52                   	push   %edx
  801958:	50                   	push   %eax
  801959:	6a 18                	push   $0x18
  80195b:	e8 8a fd ff ff       	call   8016ea <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	6a 00                	push   $0x0
  80196d:	ff 75 14             	pushl  0x14(%ebp)
  801970:	ff 75 10             	pushl  0x10(%ebp)
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	50                   	push   %eax
  801977:	6a 19                	push   $0x19
  801979:	e8 6c fd ff ff       	call   8016ea <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	50                   	push   %eax
  801992:	6a 1a                	push   $0x1a
  801994:	e8 51 fd ff ff       	call   8016ea <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	90                   	nop
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	50                   	push   %eax
  8019ae:	6a 1b                	push   $0x1b
  8019b0:	e8 35 fd ff ff       	call   8016ea <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 05                	push   $0x5
  8019c9:	e8 1c fd ff ff       	call   8016ea <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 06                	push   $0x6
  8019e2:	e8 03 fd ff ff       	call   8016ea <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 07                	push   $0x7
  8019fb:	e8 ea fc ff ff       	call   8016ea <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_exit_env>:


void sys_exit_env(void)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 1c                	push   $0x1c
  801a14:	e8 d1 fc ff ff       	call   8016ea <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	90                   	nop
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a25:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a28:	8d 50 04             	lea    0x4(%eax),%edx
  801a2b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	52                   	push   %edx
  801a35:	50                   	push   %eax
  801a36:	6a 1d                	push   $0x1d
  801a38:	e8 ad fc ff ff       	call   8016ea <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
	return result;
  801a40:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a46:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a49:	89 01                	mov    %eax,(%ecx)
  801a4b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	c9                   	leave  
  801a52:	c2 04 00             	ret    $0x4

00801a55 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	ff 75 10             	pushl  0x10(%ebp)
  801a5f:	ff 75 0c             	pushl  0xc(%ebp)
  801a62:	ff 75 08             	pushl  0x8(%ebp)
  801a65:	6a 13                	push   $0x13
  801a67:	e8 7e fc ff ff       	call   8016ea <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6f:	90                   	nop
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 1e                	push   $0x1e
  801a81:	e8 64 fc ff ff       	call   8016ea <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 04             	sub    $0x4,%esp
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a97:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	50                   	push   %eax
  801aa4:	6a 1f                	push   $0x1f
  801aa6:	e8 3f fc ff ff       	call   8016ea <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
	return ;
  801aae:	90                   	nop
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <rsttst>:
void rsttst()
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 21                	push   $0x21
  801ac0:	e8 25 fc ff ff       	call   8016ea <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac8:	90                   	nop
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 04             	sub    $0x4,%esp
  801ad1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ad7:	8b 55 18             	mov    0x18(%ebp),%edx
  801ada:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ade:	52                   	push   %edx
  801adf:	50                   	push   %eax
  801ae0:	ff 75 10             	pushl  0x10(%ebp)
  801ae3:	ff 75 0c             	pushl  0xc(%ebp)
  801ae6:	ff 75 08             	pushl  0x8(%ebp)
  801ae9:	6a 20                	push   $0x20
  801aeb:	e8 fa fb ff ff       	call   8016ea <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
	return ;
  801af3:	90                   	nop
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <chktst>:
void chktst(uint32 n)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	ff 75 08             	pushl  0x8(%ebp)
  801b04:	6a 22                	push   $0x22
  801b06:	e8 df fb ff ff       	call   8016ea <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0e:	90                   	nop
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <inctst>:

void inctst()
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 23                	push   $0x23
  801b20:	e8 c5 fb ff ff       	call   8016ea <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
	return ;
  801b28:	90                   	nop
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <gettst>:
uint32 gettst()
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 24                	push   $0x24
  801b3a:	e8 ab fb ff ff       	call   8016ea <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 25                	push   $0x25
  801b56:	e8 8f fb ff ff       	call   8016ea <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
  801b5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b61:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b65:	75 07                	jne    801b6e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b67:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6c:	eb 05                	jmp    801b73 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 25                	push   $0x25
  801b87:	e8 5e fb ff ff       	call   8016ea <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
  801b8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b92:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b96:	75 07                	jne    801b9f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b98:	b8 01 00 00 00       	mov    $0x1,%eax
  801b9d:	eb 05                	jmp    801ba4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 25                	push   $0x25
  801bb8:	e8 2d fb ff ff       	call   8016ea <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
  801bc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bc3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bc7:	75 07                	jne    801bd0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bce:	eb 05                	jmp    801bd5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 25                	push   $0x25
  801be9:	e8 fc fa ff ff       	call   8016ea <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
  801bf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bf4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bf8:	75 07                	jne    801c01 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801bff:	eb 05                	jmp    801c06 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	ff 75 08             	pushl  0x8(%ebp)
  801c16:	6a 26                	push   $0x26
  801c18:	e8 cd fa ff ff       	call   8016ea <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c20:	90                   	nop
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c27:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	6a 00                	push   $0x0
  801c35:	53                   	push   %ebx
  801c36:	51                   	push   %ecx
  801c37:	52                   	push   %edx
  801c38:	50                   	push   %eax
  801c39:	6a 27                	push   $0x27
  801c3b:	e8 aa fa ff ff       	call   8016ea <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	52                   	push   %edx
  801c58:	50                   	push   %eax
  801c59:	6a 28                	push   $0x28
  801c5b:	e8 8a fa ff ff       	call   8016ea <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c68:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	51                   	push   %ecx
  801c74:	ff 75 10             	pushl  0x10(%ebp)
  801c77:	52                   	push   %edx
  801c78:	50                   	push   %eax
  801c79:	6a 29                	push   $0x29
  801c7b:	e8 6a fa ff ff       	call   8016ea <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	ff 75 10             	pushl  0x10(%ebp)
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	6a 12                	push   $0x12
  801c97:	e8 4e fa ff ff       	call   8016ea <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9f:	90                   	nop
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ca5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	52                   	push   %edx
  801cb2:	50                   	push   %eax
  801cb3:	6a 2a                	push   $0x2a
  801cb5:	e8 30 fa ff ff       	call   8016ea <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
	return;
  801cbd:	90                   	nop
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	50                   	push   %eax
  801ccf:	6a 2b                	push   $0x2b
  801cd1:	e8 14 fa ff ff       	call   8016ea <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	ff 75 0c             	pushl  0xc(%ebp)
  801ce7:	ff 75 08             	pushl  0x8(%ebp)
  801cea:	6a 2c                	push   $0x2c
  801cec:	e8 f9 f9 ff ff       	call   8016ea <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
	return;
  801cf4:	90                   	nop
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	ff 75 08             	pushl  0x8(%ebp)
  801d06:	6a 2d                	push   $0x2d
  801d08:	e8 dd f9 ff ff       	call   8016ea <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
	return;
  801d10:	90                   	nop
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    
  801d13:	90                   	nop

00801d14 <__udivdi3>:
  801d14:	55                   	push   %ebp
  801d15:	57                   	push   %edi
  801d16:	56                   	push   %esi
  801d17:	53                   	push   %ebx
  801d18:	83 ec 1c             	sub    $0x1c,%esp
  801d1b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d1f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d2b:	89 ca                	mov    %ecx,%edx
  801d2d:	89 f8                	mov    %edi,%eax
  801d2f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d33:	85 f6                	test   %esi,%esi
  801d35:	75 2d                	jne    801d64 <__udivdi3+0x50>
  801d37:	39 cf                	cmp    %ecx,%edi
  801d39:	77 65                	ja     801da0 <__udivdi3+0x8c>
  801d3b:	89 fd                	mov    %edi,%ebp
  801d3d:	85 ff                	test   %edi,%edi
  801d3f:	75 0b                	jne    801d4c <__udivdi3+0x38>
  801d41:	b8 01 00 00 00       	mov    $0x1,%eax
  801d46:	31 d2                	xor    %edx,%edx
  801d48:	f7 f7                	div    %edi
  801d4a:	89 c5                	mov    %eax,%ebp
  801d4c:	31 d2                	xor    %edx,%edx
  801d4e:	89 c8                	mov    %ecx,%eax
  801d50:	f7 f5                	div    %ebp
  801d52:	89 c1                	mov    %eax,%ecx
  801d54:	89 d8                	mov    %ebx,%eax
  801d56:	f7 f5                	div    %ebp
  801d58:	89 cf                	mov    %ecx,%edi
  801d5a:	89 fa                	mov    %edi,%edx
  801d5c:	83 c4 1c             	add    $0x1c,%esp
  801d5f:	5b                   	pop    %ebx
  801d60:	5e                   	pop    %esi
  801d61:	5f                   	pop    %edi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    
  801d64:	39 ce                	cmp    %ecx,%esi
  801d66:	77 28                	ja     801d90 <__udivdi3+0x7c>
  801d68:	0f bd fe             	bsr    %esi,%edi
  801d6b:	83 f7 1f             	xor    $0x1f,%edi
  801d6e:	75 40                	jne    801db0 <__udivdi3+0x9c>
  801d70:	39 ce                	cmp    %ecx,%esi
  801d72:	72 0a                	jb     801d7e <__udivdi3+0x6a>
  801d74:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d78:	0f 87 9e 00 00 00    	ja     801e1c <__udivdi3+0x108>
  801d7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d83:	89 fa                	mov    %edi,%edx
  801d85:	83 c4 1c             	add    $0x1c,%esp
  801d88:	5b                   	pop    %ebx
  801d89:	5e                   	pop    %esi
  801d8a:	5f                   	pop    %edi
  801d8b:	5d                   	pop    %ebp
  801d8c:	c3                   	ret    
  801d8d:	8d 76 00             	lea    0x0(%esi),%esi
  801d90:	31 ff                	xor    %edi,%edi
  801d92:	31 c0                	xor    %eax,%eax
  801d94:	89 fa                	mov    %edi,%edx
  801d96:	83 c4 1c             	add    $0x1c,%esp
  801d99:	5b                   	pop    %ebx
  801d9a:	5e                   	pop    %esi
  801d9b:	5f                   	pop    %edi
  801d9c:	5d                   	pop    %ebp
  801d9d:	c3                   	ret    
  801d9e:	66 90                	xchg   %ax,%ax
  801da0:	89 d8                	mov    %ebx,%eax
  801da2:	f7 f7                	div    %edi
  801da4:	31 ff                	xor    %edi,%edi
  801da6:	89 fa                	mov    %edi,%edx
  801da8:	83 c4 1c             	add    $0x1c,%esp
  801dab:	5b                   	pop    %ebx
  801dac:	5e                   	pop    %esi
  801dad:	5f                   	pop    %edi
  801dae:	5d                   	pop    %ebp
  801daf:	c3                   	ret    
  801db0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801db5:	89 eb                	mov    %ebp,%ebx
  801db7:	29 fb                	sub    %edi,%ebx
  801db9:	89 f9                	mov    %edi,%ecx
  801dbb:	d3 e6                	shl    %cl,%esi
  801dbd:	89 c5                	mov    %eax,%ebp
  801dbf:	88 d9                	mov    %bl,%cl
  801dc1:	d3 ed                	shr    %cl,%ebp
  801dc3:	89 e9                	mov    %ebp,%ecx
  801dc5:	09 f1                	or     %esi,%ecx
  801dc7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801dcb:	89 f9                	mov    %edi,%ecx
  801dcd:	d3 e0                	shl    %cl,%eax
  801dcf:	89 c5                	mov    %eax,%ebp
  801dd1:	89 d6                	mov    %edx,%esi
  801dd3:	88 d9                	mov    %bl,%cl
  801dd5:	d3 ee                	shr    %cl,%esi
  801dd7:	89 f9                	mov    %edi,%ecx
  801dd9:	d3 e2                	shl    %cl,%edx
  801ddb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ddf:	88 d9                	mov    %bl,%cl
  801de1:	d3 e8                	shr    %cl,%eax
  801de3:	09 c2                	or     %eax,%edx
  801de5:	89 d0                	mov    %edx,%eax
  801de7:	89 f2                	mov    %esi,%edx
  801de9:	f7 74 24 0c          	divl   0xc(%esp)
  801ded:	89 d6                	mov    %edx,%esi
  801def:	89 c3                	mov    %eax,%ebx
  801df1:	f7 e5                	mul    %ebp
  801df3:	39 d6                	cmp    %edx,%esi
  801df5:	72 19                	jb     801e10 <__udivdi3+0xfc>
  801df7:	74 0b                	je     801e04 <__udivdi3+0xf0>
  801df9:	89 d8                	mov    %ebx,%eax
  801dfb:	31 ff                	xor    %edi,%edi
  801dfd:	e9 58 ff ff ff       	jmp    801d5a <__udivdi3+0x46>
  801e02:	66 90                	xchg   %ax,%ax
  801e04:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e08:	89 f9                	mov    %edi,%ecx
  801e0a:	d3 e2                	shl    %cl,%edx
  801e0c:	39 c2                	cmp    %eax,%edx
  801e0e:	73 e9                	jae    801df9 <__udivdi3+0xe5>
  801e10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e13:	31 ff                	xor    %edi,%edi
  801e15:	e9 40 ff ff ff       	jmp    801d5a <__udivdi3+0x46>
  801e1a:	66 90                	xchg   %ax,%ax
  801e1c:	31 c0                	xor    %eax,%eax
  801e1e:	e9 37 ff ff ff       	jmp    801d5a <__udivdi3+0x46>
  801e23:	90                   	nop

00801e24 <__umoddi3>:
  801e24:	55                   	push   %ebp
  801e25:	57                   	push   %edi
  801e26:	56                   	push   %esi
  801e27:	53                   	push   %ebx
  801e28:	83 ec 1c             	sub    $0x1c,%esp
  801e2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e43:	89 f3                	mov    %esi,%ebx
  801e45:	89 fa                	mov    %edi,%edx
  801e47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e4b:	89 34 24             	mov    %esi,(%esp)
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	75 1a                	jne    801e6c <__umoddi3+0x48>
  801e52:	39 f7                	cmp    %esi,%edi
  801e54:	0f 86 a2 00 00 00    	jbe    801efc <__umoddi3+0xd8>
  801e5a:	89 c8                	mov    %ecx,%eax
  801e5c:	89 f2                	mov    %esi,%edx
  801e5e:	f7 f7                	div    %edi
  801e60:	89 d0                	mov    %edx,%eax
  801e62:	31 d2                	xor    %edx,%edx
  801e64:	83 c4 1c             	add    $0x1c,%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5f                   	pop    %edi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    
  801e6c:	39 f0                	cmp    %esi,%eax
  801e6e:	0f 87 ac 00 00 00    	ja     801f20 <__umoddi3+0xfc>
  801e74:	0f bd e8             	bsr    %eax,%ebp
  801e77:	83 f5 1f             	xor    $0x1f,%ebp
  801e7a:	0f 84 ac 00 00 00    	je     801f2c <__umoddi3+0x108>
  801e80:	bf 20 00 00 00       	mov    $0x20,%edi
  801e85:	29 ef                	sub    %ebp,%edi
  801e87:	89 fe                	mov    %edi,%esi
  801e89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e8d:	89 e9                	mov    %ebp,%ecx
  801e8f:	d3 e0                	shl    %cl,%eax
  801e91:	89 d7                	mov    %edx,%edi
  801e93:	89 f1                	mov    %esi,%ecx
  801e95:	d3 ef                	shr    %cl,%edi
  801e97:	09 c7                	or     %eax,%edi
  801e99:	89 e9                	mov    %ebp,%ecx
  801e9b:	d3 e2                	shl    %cl,%edx
  801e9d:	89 14 24             	mov    %edx,(%esp)
  801ea0:	89 d8                	mov    %ebx,%eax
  801ea2:	d3 e0                	shl    %cl,%eax
  801ea4:	89 c2                	mov    %eax,%edx
  801ea6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eaa:	d3 e0                	shl    %cl,%eax
  801eac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801eb4:	89 f1                	mov    %esi,%ecx
  801eb6:	d3 e8                	shr    %cl,%eax
  801eb8:	09 d0                	or     %edx,%eax
  801eba:	d3 eb                	shr    %cl,%ebx
  801ebc:	89 da                	mov    %ebx,%edx
  801ebe:	f7 f7                	div    %edi
  801ec0:	89 d3                	mov    %edx,%ebx
  801ec2:	f7 24 24             	mull   (%esp)
  801ec5:	89 c6                	mov    %eax,%esi
  801ec7:	89 d1                	mov    %edx,%ecx
  801ec9:	39 d3                	cmp    %edx,%ebx
  801ecb:	0f 82 87 00 00 00    	jb     801f58 <__umoddi3+0x134>
  801ed1:	0f 84 91 00 00 00    	je     801f68 <__umoddi3+0x144>
  801ed7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801edb:	29 f2                	sub    %esi,%edx
  801edd:	19 cb                	sbb    %ecx,%ebx
  801edf:	89 d8                	mov    %ebx,%eax
  801ee1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ee5:	d3 e0                	shl    %cl,%eax
  801ee7:	89 e9                	mov    %ebp,%ecx
  801ee9:	d3 ea                	shr    %cl,%edx
  801eeb:	09 d0                	or     %edx,%eax
  801eed:	89 e9                	mov    %ebp,%ecx
  801eef:	d3 eb                	shr    %cl,%ebx
  801ef1:	89 da                	mov    %ebx,%edx
  801ef3:	83 c4 1c             	add    $0x1c,%esp
  801ef6:	5b                   	pop    %ebx
  801ef7:	5e                   	pop    %esi
  801ef8:	5f                   	pop    %edi
  801ef9:	5d                   	pop    %ebp
  801efa:	c3                   	ret    
  801efb:	90                   	nop
  801efc:	89 fd                	mov    %edi,%ebp
  801efe:	85 ff                	test   %edi,%edi
  801f00:	75 0b                	jne    801f0d <__umoddi3+0xe9>
  801f02:	b8 01 00 00 00       	mov    $0x1,%eax
  801f07:	31 d2                	xor    %edx,%edx
  801f09:	f7 f7                	div    %edi
  801f0b:	89 c5                	mov    %eax,%ebp
  801f0d:	89 f0                	mov    %esi,%eax
  801f0f:	31 d2                	xor    %edx,%edx
  801f11:	f7 f5                	div    %ebp
  801f13:	89 c8                	mov    %ecx,%eax
  801f15:	f7 f5                	div    %ebp
  801f17:	89 d0                	mov    %edx,%eax
  801f19:	e9 44 ff ff ff       	jmp    801e62 <__umoddi3+0x3e>
  801f1e:	66 90                	xchg   %ax,%ax
  801f20:	89 c8                	mov    %ecx,%eax
  801f22:	89 f2                	mov    %esi,%edx
  801f24:	83 c4 1c             	add    $0x1c,%esp
  801f27:	5b                   	pop    %ebx
  801f28:	5e                   	pop    %esi
  801f29:	5f                   	pop    %edi
  801f2a:	5d                   	pop    %ebp
  801f2b:	c3                   	ret    
  801f2c:	3b 04 24             	cmp    (%esp),%eax
  801f2f:	72 06                	jb     801f37 <__umoddi3+0x113>
  801f31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f35:	77 0f                	ja     801f46 <__umoddi3+0x122>
  801f37:	89 f2                	mov    %esi,%edx
  801f39:	29 f9                	sub    %edi,%ecx
  801f3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f3f:	89 14 24             	mov    %edx,(%esp)
  801f42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f46:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f4a:	8b 14 24             	mov    (%esp),%edx
  801f4d:	83 c4 1c             	add    $0x1c,%esp
  801f50:	5b                   	pop    %ebx
  801f51:	5e                   	pop    %esi
  801f52:	5f                   	pop    %edi
  801f53:	5d                   	pop    %ebp
  801f54:	c3                   	ret    
  801f55:	8d 76 00             	lea    0x0(%esi),%esi
  801f58:	2b 04 24             	sub    (%esp),%eax
  801f5b:	19 fa                	sbb    %edi,%edx
  801f5d:	89 d1                	mov    %edx,%ecx
  801f5f:	89 c6                	mov    %eax,%esi
  801f61:	e9 71 ff ff ff       	jmp    801ed7 <__umoddi3+0xb3>
  801f66:	66 90                	xchg   %ax,%ax
  801f68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f6c:	72 ea                	jb     801f58 <__umoddi3+0x134>
  801f6e:	89 d9                	mov    %ebx,%ecx
  801f70:	e9 62 ff ff ff       	jmp    801ed7 <__umoddi3+0xb3>
