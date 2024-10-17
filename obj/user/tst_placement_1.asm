
obj/user/tst_placement_1:     file format elf32-i386


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
  800031:	e8 81 03 00 00       	call   8003b7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 84 00 00 01    	sub    $0x1000084,%esp
	int freePages = sys_calculate_free_frames();
  800042:	e8 34 16 00 00       	call   80167b <sys_calculate_free_frames>
  800047:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	char arr[PAGE_SIZE*1024*4];

	//uint32 actual_active_list[17] = {0xedbfd000,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
	uint32 actual_active_list[17] ;
	{
		actual_active_list[0] = 0xedbfd000;
  80004a:	c7 85 8c ff ff fe 00 	movl   $0xedbfd000,-0x1000074(%ebp)
  800051:	d0 bf ed 
		actual_active_list[1] = 0xeebfd000;
  800054:	c7 85 90 ff ff fe 00 	movl   $0xeebfd000,-0x1000070(%ebp)
  80005b:	d0 bf ee 
		actual_active_list[2] = 0x803000;
  80005e:	c7 85 94 ff ff fe 00 	movl   $0x803000,-0x100006c(%ebp)
  800065:	30 80 00 
		actual_active_list[3] = 0x802000;
  800068:	c7 85 98 ff ff fe 00 	movl   $0x802000,-0x1000068(%ebp)
  80006f:	20 80 00 
		actual_active_list[4] = 0x801000;
  800072:	c7 85 9c ff ff fe 00 	movl   $0x801000,-0x1000064(%ebp)
  800079:	10 80 00 
		actual_active_list[5] = 0x800000;
  80007c:	c7 85 a0 ff ff fe 00 	movl   $0x800000,-0x1000060(%ebp)
  800083:	00 80 00 
		actual_active_list[6] = 0x205000;
  800086:	c7 85 a4 ff ff fe 00 	movl   $0x205000,-0x100005c(%ebp)
  80008d:	50 20 00 
		actual_active_list[7] = 0x204000;
  800090:	c7 85 a8 ff ff fe 00 	movl   $0x204000,-0x1000058(%ebp)
  800097:	40 20 00 
		actual_active_list[8] = 0x203000;
  80009a:	c7 85 ac ff ff fe 00 	movl   $0x203000,-0x1000054(%ebp)
  8000a1:	30 20 00 
		actual_active_list[9] = 0x202000;
  8000a4:	c7 85 b0 ff ff fe 00 	movl   $0x202000,-0x1000050(%ebp)
  8000ab:	20 20 00 
		actual_active_list[10] = 0x201000;
  8000ae:	c7 85 b4 ff ff fe 00 	movl   $0x201000,-0x100004c(%ebp)
  8000b5:	10 20 00 
		actual_active_list[11] = 0x200000;
  8000b8:	c7 85 b8 ff ff fe 00 	movl   $0x200000,-0x1000048(%ebp)
  8000bf:	00 20 00 
	}
	uint32 actual_second_list[2] = {};
  8000c2:	c7 85 84 ff ff fe 00 	movl   $0x0,-0x100007c(%ebp)
  8000c9:	00 00 00 
  8000cc:	c7 85 88 ff ff fe 00 	movl   $0x0,-0x1000078(%ebp)
  8000d3:	00 00 00 

	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000d6:	6a 00                	push   $0x0
  8000d8:	6a 0c                	push   $0xc
  8000da:	8d 85 84 ff ff fe    	lea    -0x100007c(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	8d 85 8c ff ff fe    	lea    -0x1000074(%ebp),%eax
  8000e7:	50                   	push   %eax
  8000e8:	e8 a7 19 00 00       	call   801a94 <sys_check_LRU_lists>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(check == 0)
  8000f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8000f7:	75 14                	jne    80010d <_main+0xd5>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 00 1e 80 00       	push   $0x801e00
  800101:	6a 26                	push   $0x26
  800103:	68 82 1e 80 00       	push   $0x801e82
  800108:	e8 f7 03 00 00       	call   800504 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010d:	e8 b4 15 00 00       	call   8016c6 <sys_pf_calculate_allocated_pages>
  800112:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i=0;
  800115:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  80011c:	eb 11                	jmp    80012f <_main+0xf7>
	{
		arr[i] = 'A';
  80011e:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  800124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800127:	01 d0                	add    %edx,%eax
  800129:	c6 00 41             	movb   $0x41,(%eax)
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int i=0;
	for(;i<=PAGE_SIZE;i++)
  80012c:	ff 45 f4             	incl   -0xc(%ebp)
  80012f:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  800136:	7e e6                	jle    80011e <_main+0xe6>
	{
		arr[i] = 'A';
	}
//	cprintf("1. free frames = %d\n", sys_calculate_free_frames());

	i=PAGE_SIZE*1024;
  800138:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80013f:	eb 11                	jmp    800152 <_main+0x11a>
	{
		arr[i] = 'A';
  800141:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  800147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 41             	movb   $0x41,(%eax)
		arr[i] = 'A';
	}
//	cprintf("1. free frames = %d\n", sys_calculate_free_frames());

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80014f:	ff 45 f4             	incl   -0xc(%ebp)
  800152:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  800159:	7e e6                	jle    800141 <_main+0x109>
	{
		arr[i] = 'A';
	}
	//cprintf("2. free frames = %d\n", sys_calculate_free_frames());

	i=PAGE_SIZE*1024*2;
  80015b:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800162:	eb 11                	jmp    800175 <_main+0x13d>
	{
		arr[i] = 'A';
  800164:	8d 95 d0 ff ff fe    	lea    -0x1000030(%ebp),%edx
  80016a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80016d:	01 d0                	add    %edx,%eax
  80016f:	c6 00 41             	movb   $0x41,(%eax)
		arr[i] = 'A';
	}
	//cprintf("2. free frames = %d\n", sys_calculate_free_frames());

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800172:	ff 45 f4             	incl   -0xc(%ebp)
  800175:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  80017c:	7e e6                	jle    800164 <_main+0x12c>
		arr[i] = 'A';
	}
	//cprintf("3. free frames = %d\n", sys_calculate_free_frames());


	int eval = 0;
  80017e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	bool is_correct = 1;
  800185:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
	uint32 expected, actual ;
	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	68 9c 1e 80 00       	push   $0x801e9c
  800194:	e8 28 06 00 00       	call   8007c1 <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  80019c:	8a 85 d0 ff ff fe    	mov    -0x1000030(%ebp),%al
  8001a2:	3c 41                	cmp    $0x41,%al
  8001a4:	74 17                	je     8001bd <_main+0x185>
  8001a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 cc 1e 80 00       	push   $0x801ecc
  8001b5:	e8 07 06 00 00       	call   8007c1 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001bd:	8a 85 d0 0f 00 ff    	mov    -0xfff030(%ebp),%al
  8001c3:	3c 41                	cmp    $0x41,%al
  8001c5:	74 17                	je     8001de <_main+0x1a6>
  8001c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	68 cc 1e 80 00       	push   $0x801ecc
  8001d6:	e8 e6 05 00 00       	call   8007c1 <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001de:	8a 85 d0 ff 3f ff    	mov    -0xc00030(%ebp),%al
  8001e4:	3c 41                	cmp    $0x41,%al
  8001e6:	74 17                	je     8001ff <_main+0x1c7>
  8001e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	68 cc 1e 80 00       	push   $0x801ecc
  8001f7:	e8 c5 05 00 00       	call   8007c1 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001ff:	8a 85 d0 0f 40 ff    	mov    -0xbff030(%ebp),%al
  800205:	3c 41                	cmp    $0x41,%al
  800207:	74 17                	je     800220 <_main+0x1e8>
  800209:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 cc 1e 80 00       	push   $0x801ecc
  800218:	e8 a4 05 00 00       	call   8007c1 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800220:	8a 85 d0 ff 7f ff    	mov    -0x800030(%ebp),%al
  800226:	3c 41                	cmp    $0x41,%al
  800228:	74 17                	je     800241 <_main+0x209>
  80022a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	68 cc 1e 80 00       	push   $0x801ecc
  800239:	e8 83 05 00 00       	call   8007c1 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800241:	8a 85 d0 0f 80 ff    	mov    -0x7ff030(%ebp),%al
  800247:	3c 41                	cmp    $0x41,%al
  800249:	74 17                	je     800262 <_main+0x22a>
  80024b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800252:	83 ec 0c             	sub    $0xc,%esp
  800255:	68 cc 1e 80 00       	push   $0x801ecc
  80025a:	e8 62 05 00 00       	call   8007c1 <cprintf>
  80025f:	83 c4 10             	add    $0x10,%esp

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT written to Page File until it's replaced\n"); }
  800262:	e8 5f 14 00 00       	call   8016c6 <sys_pf_calculate_allocated_pages>
  800267:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80026a:	74 17                	je     800283 <_main+0x24b>
  80026c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	68 ec 1e 80 00       	push   $0x801eec
  80027b:	e8 41 05 00 00       	call   8007c1 <cprintf>
  800280:	83 c4 10             	add    $0x10,%esp

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  800283:	c7 45 d8 07 00 00 00 	movl   $0x7,-0x28(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  80028a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80028d:	e8 e9 13 00 00       	call   80167b <sys_calculate_free_frames>
  800292:	29 c3                	sub    %eax,%ebx
  800294:	89 d8                	mov    %ebx,%eax
  800296:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		//actual = (initFreeFrames - sys_calculate_free_frames()) ;

		if(actual != expected) { is_correct = 0; cprintf("allocated memory size incorrect. Expected = %d, Actual = %d\n", expected, actual); }
  800299:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80029c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80029f:	74 1d                	je     8002be <_main+0x286>
  8002a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b1:	68 34 1f 80 00       	push   $0x801f34
  8002b6:	e8 06 05 00 00       	call   8007c1 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 74 1f 80 00       	push   $0x801f74
  8002c6:	e8 f6 04 00 00       	call   8007c1 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  8002ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002d2:	74 04                	je     8002d8 <_main+0x2a0>
		eval += 50 ;
  8002d4:	83 45 f0 32          	addl   $0x32,-0x10(%ebp)
	is_correct = 1;
  8002d8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)

	for (int i=16;i>4;i--)
  8002df:	c7 45 e8 10 00 00 00 	movl   $0x10,-0x18(%ebp)
  8002e6:	eb 1a                	jmp    800302 <_main+0x2ca>
		actual_active_list[i]=actual_active_list[i-5];
  8002e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002eb:	83 e8 05             	sub    $0x5,%eax
  8002ee:	8b 94 85 8c ff ff fe 	mov    -0x1000074(%ebp,%eax,4),%edx
  8002f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f8:	89 94 85 8c ff ff fe 	mov    %edx,-0x1000074(%ebp,%eax,4)
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
	if (is_correct)
		eval += 50 ;
	is_correct = 1;

	for (int i=16;i>4;i--)
  8002ff:	ff 4d e8             	decl   -0x18(%ebp)
  800302:	83 7d e8 04          	cmpl   $0x4,-0x18(%ebp)
  800306:	7f e0                	jg     8002e8 <_main+0x2b0>
		actual_active_list[i]=actual_active_list[i-5];

	actual_active_list[0]=0xee3fe000;
  800308:	c7 85 8c ff ff fe 00 	movl   $0xee3fe000,-0x1000074(%ebp)
  80030f:	e0 3f ee 
	actual_active_list[1]=0xee3fd000;
  800312:	c7 85 90 ff ff fe 00 	movl   $0xee3fd000,-0x1000070(%ebp)
  800319:	d0 3f ee 
	actual_active_list[2]=0xedffe000;
  80031c:	c7 85 94 ff ff fe 00 	movl   $0xedffe000,-0x100006c(%ebp)
  800323:	e0 ff ed 
	actual_active_list[3]=0xedffd000;
  800326:	c7 85 98 ff ff fe 00 	movl   $0xedffd000,-0x1000068(%ebp)
  80032d:	d0 ff ed 
	actual_active_list[4]=0xedbfe000;
  800330:	c7 85 9c ff ff fe 00 	movl   $0xedbfe000,-0x1000064(%ebp)
  800337:	e0 bf ed 

	cprintf("STEP B: checking LRU lists entries ...\n");
  80033a:	83 ec 0c             	sub    $0xc,%esp
  80033d:	68 a8 1f 80 00       	push   $0x801fa8
  800342:	e8 7a 04 00 00       	call   8007c1 <cprintf>
  800347:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 17, 0);
  80034a:	6a 00                	push   $0x0
  80034c:	6a 11                	push   $0x11
  80034e:	8d 85 84 ff ff fe    	lea    -0x100007c(%ebp),%eax
  800354:	50                   	push   %eax
  800355:	8d 85 8c ff ff fe    	lea    -0x1000074(%ebp),%eax
  80035b:	50                   	push   %eax
  80035c:	e8 33 17 00 00       	call   801a94 <sys_check_LRU_lists>
  800361:	83 c4 10             	add    $0x10,%esp
  800364:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if(check == 0)
  800367:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80036b:	75 17                	jne    800384 <_main+0x34c>
				{ is_correct = 0; cprintf("LRU lists entries are not correct, check your logic again!!\n"); }
  80036d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	68 d0 1f 80 00       	push   $0x801fd0
  80037c:	e8 40 04 00 00       	call   8007c1 <cprintf>
  800381:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	68 10 20 80 00       	push   $0x802010
  80038c:	e8 30 04 00 00       	call   8007c1 <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  800394:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800398:	74 04                	je     80039e <_main+0x366>
		eval += 50 ;
  80039a:	83 45 f0 32          	addl   $0x32,-0x10(%ebp)

	cprintf("Congratulations!! Test of PAGE PLACEMENT FIRST SCENARIO completed. Eval = %d\n\n\n", eval);
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a4:	68 48 20 80 00       	push   $0x802048
  8003a9:	e8 13 04 00 00       	call   8007c1 <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp
	return;
  8003b1:	90                   	nop
}
  8003b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003b5:	c9                   	leave  
  8003b6:	c3                   	ret    

008003b7 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003bd:	e8 82 14 00 00       	call   801844 <sys_getenvindex>
  8003c2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8003c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c8:	89 d0                	mov    %edx,%eax
  8003ca:	c1 e0 06             	shl    $0x6,%eax
  8003cd:	29 d0                	sub    %edx,%eax
  8003cf:	c1 e0 02             	shl    $0x2,%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003db:	01 c8                	add    %ecx,%eax
  8003dd:	c1 e0 03             	shl    $0x3,%eax
  8003e0:	01 d0                	add    %edx,%eax
  8003e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e9:	29 c2                	sub    %eax,%edx
  8003eb:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8003fa:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003ff:	a1 04 30 80 00       	mov    0x803004,%eax
  800404:	8a 40 20             	mov    0x20(%eax),%al
  800407:	84 c0                	test   %al,%al
  800409:	74 0d                	je     800418 <libmain+0x61>
		binaryname = myEnv->prog_name;
  80040b:	a1 04 30 80 00       	mov    0x803004,%eax
  800410:	83 c0 20             	add    $0x20,%eax
  800413:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800418:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80041c:	7e 0a                	jle    800428 <libmain+0x71>
		binaryname = argv[0];
  80041e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800421:	8b 00                	mov    (%eax),%eax
  800423:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800428:	83 ec 08             	sub    $0x8,%esp
  80042b:	ff 75 0c             	pushl  0xc(%ebp)
  80042e:	ff 75 08             	pushl  0x8(%ebp)
  800431:	e8 02 fc ff ff       	call   800038 <_main>
  800436:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800439:	e8 8a 11 00 00       	call   8015c8 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80043e:	83 ec 0c             	sub    $0xc,%esp
  800441:	68 b0 20 80 00       	push   $0x8020b0
  800446:	e8 76 03 00 00       	call   8007c1 <cprintf>
  80044b:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80044e:	a1 04 30 80 00       	mov    0x803004,%eax
  800453:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800459:	a1 04 30 80 00       	mov    0x803004,%eax
  80045e:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800464:	83 ec 04             	sub    $0x4,%esp
  800467:	52                   	push   %edx
  800468:	50                   	push   %eax
  800469:	68 d8 20 80 00       	push   $0x8020d8
  80046e:	e8 4e 03 00 00       	call   8007c1 <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800476:	a1 04 30 80 00       	mov    0x803004,%eax
  80047b:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800481:	a1 04 30 80 00       	mov    0x803004,%eax
  800486:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80048c:	a1 04 30 80 00       	mov    0x803004,%eax
  800491:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800497:	51                   	push   %ecx
  800498:	52                   	push   %edx
  800499:	50                   	push   %eax
  80049a:	68 00 21 80 00       	push   $0x802100
  80049f:	e8 1d 03 00 00       	call   8007c1 <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004a7:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ac:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	50                   	push   %eax
  8004b6:	68 58 21 80 00       	push   $0x802158
  8004bb:	e8 01 03 00 00       	call   8007c1 <cprintf>
  8004c0:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8004c3:	83 ec 0c             	sub    $0xc,%esp
  8004c6:	68 b0 20 80 00       	push   $0x8020b0
  8004cb:	e8 f1 02 00 00       	call   8007c1 <cprintf>
  8004d0:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8004d3:	e8 0a 11 00 00       	call   8015e2 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8004d8:	e8 19 00 00 00       	call   8004f6 <exit>
}
  8004dd:	90                   	nop
  8004de:	c9                   	leave  
  8004df:	c3                   	ret    

008004e0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004e6:	83 ec 0c             	sub    $0xc,%esp
  8004e9:	6a 00                	push   $0x0
  8004eb:	e8 20 13 00 00       	call   801810 <sys_destroy_env>
  8004f0:	83 c4 10             	add    $0x10,%esp
}
  8004f3:	90                   	nop
  8004f4:	c9                   	leave  
  8004f5:	c3                   	ret    

008004f6 <exit>:

void
exit(void)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004fc:	e8 75 13 00 00       	call   801876 <sys_exit_env>
}
  800501:	90                   	nop
  800502:	c9                   	leave  
  800503:	c3                   	ret    

00800504 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  800507:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80050a:	8d 45 10             	lea    0x10(%ebp),%eax
  80050d:	83 c0 04             	add    $0x4,%eax
  800510:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800513:	a1 24 30 80 00       	mov    0x803024,%eax
  800518:	85 c0                	test   %eax,%eax
  80051a:	74 16                	je     800532 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80051c:	a1 24 30 80 00       	mov    0x803024,%eax
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	50                   	push   %eax
  800525:	68 6c 21 80 00       	push   $0x80216c
  80052a:	e8 92 02 00 00       	call   8007c1 <cprintf>
  80052f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800532:	a1 00 30 80 00       	mov    0x803000,%eax
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 08             	pushl  0x8(%ebp)
  80053d:	50                   	push   %eax
  80053e:	68 71 21 80 00       	push   $0x802171
  800543:	e8 79 02 00 00       	call   8007c1 <cprintf>
  800548:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80054b:	8b 45 10             	mov    0x10(%ebp),%eax
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	ff 75 f4             	pushl  -0xc(%ebp)
  800554:	50                   	push   %eax
  800555:	e8 fc 01 00 00       	call   800756 <vcprintf>
  80055a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	6a 00                	push   $0x0
  800562:	68 8d 21 80 00       	push   $0x80218d
  800567:	e8 ea 01 00 00       	call   800756 <vcprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80056f:	e8 82 ff ff ff       	call   8004f6 <exit>

	// should not return here
	while (1) ;
  800574:	eb fe                	jmp    800574 <_panic+0x70>

00800576 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80057c:	a1 04 30 80 00       	mov    0x803004,%eax
  800581:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	39 c2                	cmp    %eax,%edx
  80058c:	74 14                	je     8005a2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80058e:	83 ec 04             	sub    $0x4,%esp
  800591:	68 90 21 80 00       	push   $0x802190
  800596:	6a 26                	push   $0x26
  800598:	68 dc 21 80 00       	push   $0x8021dc
  80059d:	e8 62 ff ff ff       	call   800504 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005b0:	e9 c5 00 00 00       	jmp    80067a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	01 d0                	add    %edx,%eax
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	85 c0                	test   %eax,%eax
  8005c8:	75 08                	jne    8005d2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005ca:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005cd:	e9 a5 00 00 00       	jmp    800677 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005e0:	eb 69                	jmp    80064b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005e2:	a1 04 30 80 00       	mov    0x803004,%eax
  8005e7:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005f0:	89 d0                	mov    %edx,%eax
  8005f2:	01 c0                	add    %eax,%eax
  8005f4:	01 d0                	add    %edx,%eax
  8005f6:	c1 e0 03             	shl    $0x3,%eax
  8005f9:	01 c8                	add    %ecx,%eax
  8005fb:	8a 40 04             	mov    0x4(%eax),%al
  8005fe:	84 c0                	test   %al,%al
  800600:	75 46                	jne    800648 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800602:	a1 04 30 80 00       	mov    0x803004,%eax
  800607:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80060d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800610:	89 d0                	mov    %edx,%eax
  800612:	01 c0                	add    %eax,%eax
  800614:	01 d0                	add    %edx,%eax
  800616:	c1 e0 03             	shl    $0x3,%eax
  800619:	01 c8                	add    %ecx,%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800620:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800623:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800628:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80062a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	01 c8                	add    %ecx,%eax
  800639:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80063b:	39 c2                	cmp    %eax,%edx
  80063d:	75 09                	jne    800648 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80063f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800646:	eb 15                	jmp    80065d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800648:	ff 45 e8             	incl   -0x18(%ebp)
  80064b:	a1 04 30 80 00       	mov    0x803004,%eax
  800650:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800656:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	77 85                	ja     8005e2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80065d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800661:	75 14                	jne    800677 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800663:	83 ec 04             	sub    $0x4,%esp
  800666:	68 e8 21 80 00       	push   $0x8021e8
  80066b:	6a 3a                	push   $0x3a
  80066d:	68 dc 21 80 00       	push   $0x8021dc
  800672:	e8 8d fe ff ff       	call   800504 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800677:	ff 45 f0             	incl   -0x10(%ebp)
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80067d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800680:	0f 8c 2f ff ff ff    	jl     8005b5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800686:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80068d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800694:	eb 26                	jmp    8006bc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800696:	a1 04 30 80 00       	mov    0x803004,%eax
  80069b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8006a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006a4:	89 d0                	mov    %edx,%eax
  8006a6:	01 c0                	add    %eax,%eax
  8006a8:	01 d0                	add    %edx,%eax
  8006aa:	c1 e0 03             	shl    $0x3,%eax
  8006ad:	01 c8                	add    %ecx,%eax
  8006af:	8a 40 04             	mov    0x4(%eax),%al
  8006b2:	3c 01                	cmp    $0x1,%al
  8006b4:	75 03                	jne    8006b9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006b6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b9:	ff 45 e0             	incl   -0x20(%ebp)
  8006bc:	a1 04 30 80 00       	mov    0x803004,%eax
  8006c1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ca:	39 c2                	cmp    %eax,%edx
  8006cc:	77 c8                	ja     800696 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006d4:	74 14                	je     8006ea <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006d6:	83 ec 04             	sub    $0x4,%esp
  8006d9:	68 3c 22 80 00       	push   $0x80223c
  8006de:	6a 44                	push   $0x44
  8006e0:	68 dc 21 80 00       	push   $0x8021dc
  8006e5:	e8 1a fe ff ff       	call   800504 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006ea:	90                   	nop
  8006eb:	c9                   	leave  
  8006ec:	c3                   	ret    

008006ed <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006ed:	55                   	push   %ebp
  8006ee:	89 e5                	mov    %esp,%ebp
  8006f0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	8d 48 01             	lea    0x1(%eax),%ecx
  8006fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006fe:	89 0a                	mov    %ecx,(%edx)
  800700:	8b 55 08             	mov    0x8(%ebp),%edx
  800703:	88 d1                	mov    %dl,%cl
  800705:	8b 55 0c             	mov    0xc(%ebp),%edx
  800708:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80070c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	3d ff 00 00 00       	cmp    $0xff,%eax
  800716:	75 2c                	jne    800744 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800718:	a0 08 30 80 00       	mov    0x803008,%al
  80071d:	0f b6 c0             	movzbl %al,%eax
  800720:	8b 55 0c             	mov    0xc(%ebp),%edx
  800723:	8b 12                	mov    (%edx),%edx
  800725:	89 d1                	mov    %edx,%ecx
  800727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072a:	83 c2 08             	add    $0x8,%edx
  80072d:	83 ec 04             	sub    $0x4,%esp
  800730:	50                   	push   %eax
  800731:	51                   	push   %ecx
  800732:	52                   	push   %edx
  800733:	e8 4e 0e 00 00       	call   801586 <sys_cputs>
  800738:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80073b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800744:	8b 45 0c             	mov    0xc(%ebp),%eax
  800747:	8b 40 04             	mov    0x4(%eax),%eax
  80074a:	8d 50 01             	lea    0x1(%eax),%edx
  80074d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800750:	89 50 04             	mov    %edx,0x4(%eax)
}
  800753:	90                   	nop
  800754:	c9                   	leave  
  800755:	c3                   	ret    

00800756 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
  800759:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80075f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800766:	00 00 00 
	b.cnt = 0;
  800769:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800770:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800773:	ff 75 0c             	pushl  0xc(%ebp)
  800776:	ff 75 08             	pushl  0x8(%ebp)
  800779:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80077f:	50                   	push   %eax
  800780:	68 ed 06 80 00       	push   $0x8006ed
  800785:	e8 11 02 00 00       	call   80099b <vprintfmt>
  80078a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80078d:	a0 08 30 80 00       	mov    0x803008,%al
  800792:	0f b6 c0             	movzbl %al,%eax
  800795:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80079b:	83 ec 04             	sub    $0x4,%esp
  80079e:	50                   	push   %eax
  80079f:	52                   	push   %edx
  8007a0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007a6:	83 c0 08             	add    $0x8,%eax
  8007a9:	50                   	push   %eax
  8007aa:	e8 d7 0d 00 00       	call   801586 <sys_cputs>
  8007af:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007b2:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8007b9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007bf:	c9                   	leave  
  8007c0:	c3                   	ret    

008007c1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007c7:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8007ce:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	ff 75 f4             	pushl  -0xc(%ebp)
  8007dd:	50                   	push   %eax
  8007de:	e8 73 ff ff ff       	call   800756 <vcprintf>
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ec:	c9                   	leave  
  8007ed:	c3                   	ret    

008007ee <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
  8007f1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007f4:	e8 cf 0d 00 00       	call   8015c8 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007f9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	ff 75 f4             	pushl  -0xc(%ebp)
  800808:	50                   	push   %eax
  800809:	e8 48 ff ff ff       	call   800756 <vcprintf>
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800814:	e8 c9 0d 00 00       	call   8015e2 <sys_unlock_cons>
	return cnt;
  800819:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80081c:	c9                   	leave  
  80081d:	c3                   	ret    

0080081e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	53                   	push   %ebx
  800822:	83 ec 14             	sub    $0x14,%esp
  800825:	8b 45 10             	mov    0x10(%ebp),%eax
  800828:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800831:	8b 45 18             	mov    0x18(%ebp),%eax
  800834:	ba 00 00 00 00       	mov    $0x0,%edx
  800839:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80083c:	77 55                	ja     800893 <printnum+0x75>
  80083e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800841:	72 05                	jb     800848 <printnum+0x2a>
  800843:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800846:	77 4b                	ja     800893 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800848:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80084b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80084e:	8b 45 18             	mov    0x18(%ebp),%eax
  800851:	ba 00 00 00 00       	mov    $0x0,%edx
  800856:	52                   	push   %edx
  800857:	50                   	push   %eax
  800858:	ff 75 f4             	pushl  -0xc(%ebp)
  80085b:	ff 75 f0             	pushl  -0x10(%ebp)
  80085e:	e8 25 13 00 00       	call   801b88 <__udivdi3>
  800863:	83 c4 10             	add    $0x10,%esp
  800866:	83 ec 04             	sub    $0x4,%esp
  800869:	ff 75 20             	pushl  0x20(%ebp)
  80086c:	53                   	push   %ebx
  80086d:	ff 75 18             	pushl  0x18(%ebp)
  800870:	52                   	push   %edx
  800871:	50                   	push   %eax
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	ff 75 08             	pushl  0x8(%ebp)
  800878:	e8 a1 ff ff ff       	call   80081e <printnum>
  80087d:	83 c4 20             	add    $0x20,%esp
  800880:	eb 1a                	jmp    80089c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	ff 75 20             	pushl  0x20(%ebp)
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	ff d0                	call   *%eax
  800890:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800893:	ff 4d 1c             	decl   0x1c(%ebp)
  800896:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80089a:	7f e6                	jg     800882 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80089c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80089f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008aa:	53                   	push   %ebx
  8008ab:	51                   	push   %ecx
  8008ac:	52                   	push   %edx
  8008ad:	50                   	push   %eax
  8008ae:	e8 e5 13 00 00       	call   801c98 <__umoddi3>
  8008b3:	83 c4 10             	add    $0x10,%esp
  8008b6:	05 b4 24 80 00       	add    $0x8024b4,%eax
  8008bb:	8a 00                	mov    (%eax),%al
  8008bd:	0f be c0             	movsbl %al,%eax
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	ff d0                	call   *%eax
  8008cc:	83 c4 10             	add    $0x10,%esp
}
  8008cf:	90                   	nop
  8008d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d3:	c9                   	leave  
  8008d4:	c3                   	ret    

008008d5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008dc:	7e 1c                	jle    8008fa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	8d 50 08             	lea    0x8(%eax),%edx
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	89 10                	mov    %edx,(%eax)
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	83 e8 08             	sub    $0x8,%eax
  8008f3:	8b 50 04             	mov    0x4(%eax),%edx
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	eb 40                	jmp    80093a <getuint+0x65>
	else if (lflag)
  8008fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008fe:	74 1e                	je     80091e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	8d 50 04             	lea    0x4(%eax),%edx
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	89 10                	mov    %edx,(%eax)
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	ba 00 00 00 00       	mov    $0x0,%edx
  80091c:	eb 1c                	jmp    80093a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	8d 50 04             	lea    0x4(%eax),%edx
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	89 10                	mov    %edx,(%eax)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	83 e8 04             	sub    $0x4,%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80093a:	5d                   	pop    %ebp
  80093b:	c3                   	ret    

0080093c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80093f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800943:	7e 1c                	jle    800961 <getint+0x25>
		return va_arg(*ap, long long);
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	8d 50 08             	lea    0x8(%eax),%edx
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	89 10                	mov    %edx,(%eax)
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	83 e8 08             	sub    $0x8,%eax
  80095a:	8b 50 04             	mov    0x4(%eax),%edx
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	eb 38                	jmp    800999 <getint+0x5d>
	else if (lflag)
  800961:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800965:	74 1a                	je     800981 <getint+0x45>
		return va_arg(*ap, long);
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	8d 50 04             	lea    0x4(%eax),%edx
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	89 10                	mov    %edx,(%eax)
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	83 e8 04             	sub    $0x4,%eax
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	99                   	cltd   
  80097f:	eb 18                	jmp    800999 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	8d 50 04             	lea    0x4(%eax),%edx
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	89 10                	mov    %edx,(%eax)
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 00                	mov    (%eax),%eax
  800993:	83 e8 04             	sub    $0x4,%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	99                   	cltd   
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	56                   	push   %esi
  80099f:	53                   	push   %ebx
  8009a0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a3:	eb 17                	jmp    8009bc <vprintfmt+0x21>
			if (ch == '\0')
  8009a5:	85 db                	test   %ebx,%ebx
  8009a7:	0f 84 c1 03 00 00    	je     800d6e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	ff 75 0c             	pushl  0xc(%ebp)
  8009b3:	53                   	push   %ebx
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	ff d0                	call   *%eax
  8009b9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bf:	8d 50 01             	lea    0x1(%eax),%edx
  8009c2:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c5:	8a 00                	mov    (%eax),%al
  8009c7:	0f b6 d8             	movzbl %al,%ebx
  8009ca:	83 fb 25             	cmp    $0x25,%ebx
  8009cd:	75 d6                	jne    8009a5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009cf:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009d3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009da:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009e1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009e8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f2:	8d 50 01             	lea    0x1(%eax),%edx
  8009f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f8:	8a 00                	mov    (%eax),%al
  8009fa:	0f b6 d8             	movzbl %al,%ebx
  8009fd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a00:	83 f8 5b             	cmp    $0x5b,%eax
  800a03:	0f 87 3d 03 00 00    	ja     800d46 <vprintfmt+0x3ab>
  800a09:	8b 04 85 d8 24 80 00 	mov    0x8024d8(,%eax,4),%eax
  800a10:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a12:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a16:	eb d7                	jmp    8009ef <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a18:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a1c:	eb d1                	jmp    8009ef <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a1e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a28:	89 d0                	mov    %edx,%eax
  800a2a:	c1 e0 02             	shl    $0x2,%eax
  800a2d:	01 d0                	add    %edx,%eax
  800a2f:	01 c0                	add    %eax,%eax
  800a31:	01 d8                	add    %ebx,%eax
  800a33:	83 e8 30             	sub    $0x30,%eax
  800a36:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a39:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a41:	83 fb 2f             	cmp    $0x2f,%ebx
  800a44:	7e 3e                	jle    800a84 <vprintfmt+0xe9>
  800a46:	83 fb 39             	cmp    $0x39,%ebx
  800a49:	7f 39                	jg     800a84 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a4b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a4e:	eb d5                	jmp    800a25 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a50:	8b 45 14             	mov    0x14(%ebp),%eax
  800a53:	83 c0 04             	add    $0x4,%eax
  800a56:	89 45 14             	mov    %eax,0x14(%ebp)
  800a59:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5c:	83 e8 04             	sub    $0x4,%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a64:	eb 1f                	jmp    800a85 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6a:	79 83                	jns    8009ef <vprintfmt+0x54>
				width = 0;
  800a6c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a73:	e9 77 ff ff ff       	jmp    8009ef <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a78:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a7f:	e9 6b ff ff ff       	jmp    8009ef <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a84:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a89:	0f 89 60 ff ff ff    	jns    8009ef <vprintfmt+0x54>
				width = precision, precision = -1;
  800a8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a95:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a9c:	e9 4e ff ff ff       	jmp    8009ef <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aa1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800aa4:	e9 46 ff ff ff       	jmp    8009ef <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	83 c0 04             	add    $0x4,%eax
  800aaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	83 e8 04             	sub    $0x4,%eax
  800ab8:	8b 00                	mov    (%eax),%eax
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	50                   	push   %eax
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	ff d0                	call   *%eax
  800ac6:	83 c4 10             	add    $0x10,%esp
			break;
  800ac9:	e9 9b 02 00 00       	jmp    800d69 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ada:	83 e8 04             	sub    $0x4,%eax
  800add:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800adf:	85 db                	test   %ebx,%ebx
  800ae1:	79 02                	jns    800ae5 <vprintfmt+0x14a>
				err = -err;
  800ae3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ae5:	83 fb 64             	cmp    $0x64,%ebx
  800ae8:	7f 0b                	jg     800af5 <vprintfmt+0x15a>
  800aea:	8b 34 9d 20 23 80 00 	mov    0x802320(,%ebx,4),%esi
  800af1:	85 f6                	test   %esi,%esi
  800af3:	75 19                	jne    800b0e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800af5:	53                   	push   %ebx
  800af6:	68 c5 24 80 00       	push   $0x8024c5
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	ff 75 08             	pushl  0x8(%ebp)
  800b01:	e8 70 02 00 00       	call   800d76 <printfmt>
  800b06:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b09:	e9 5b 02 00 00       	jmp    800d69 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b0e:	56                   	push   %esi
  800b0f:	68 ce 24 80 00       	push   $0x8024ce
  800b14:	ff 75 0c             	pushl  0xc(%ebp)
  800b17:	ff 75 08             	pushl  0x8(%ebp)
  800b1a:	e8 57 02 00 00       	call   800d76 <printfmt>
  800b1f:	83 c4 10             	add    $0x10,%esp
			break;
  800b22:	e9 42 02 00 00       	jmp    800d69 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b27:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2a:	83 c0 04             	add    $0x4,%eax
  800b2d:	89 45 14             	mov    %eax,0x14(%ebp)
  800b30:	8b 45 14             	mov    0x14(%ebp),%eax
  800b33:	83 e8 04             	sub    $0x4,%eax
  800b36:	8b 30                	mov    (%eax),%esi
  800b38:	85 f6                	test   %esi,%esi
  800b3a:	75 05                	jne    800b41 <vprintfmt+0x1a6>
				p = "(null)";
  800b3c:	be d1 24 80 00       	mov    $0x8024d1,%esi
			if (width > 0 && padc != '-')
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7e 6d                	jle    800bb4 <vprintfmt+0x219>
  800b47:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b4b:	74 67                	je     800bb4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	50                   	push   %eax
  800b54:	56                   	push   %esi
  800b55:	e8 1e 03 00 00       	call   800e78 <strnlen>
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b60:	eb 16                	jmp    800b78 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b62:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	ff 75 0c             	pushl  0xc(%ebp)
  800b6c:	50                   	push   %eax
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b75:	ff 4d e4             	decl   -0x1c(%ebp)
  800b78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b7c:	7f e4                	jg     800b62 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7e:	eb 34                	jmp    800bb4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b80:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b84:	74 1c                	je     800ba2 <vprintfmt+0x207>
  800b86:	83 fb 1f             	cmp    $0x1f,%ebx
  800b89:	7e 05                	jle    800b90 <vprintfmt+0x1f5>
  800b8b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b8e:	7e 12                	jle    800ba2 <vprintfmt+0x207>
					putch('?', putdat);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	6a 3f                	push   $0x3f
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	ff d0                	call   *%eax
  800b9d:	83 c4 10             	add    $0x10,%esp
  800ba0:	eb 0f                	jmp    800bb1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ba2:	83 ec 08             	sub    $0x8,%esp
  800ba5:	ff 75 0c             	pushl  0xc(%ebp)
  800ba8:	53                   	push   %ebx
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	ff d0                	call   *%eax
  800bae:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bb1:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb4:	89 f0                	mov    %esi,%eax
  800bb6:	8d 70 01             	lea    0x1(%eax),%esi
  800bb9:	8a 00                	mov    (%eax),%al
  800bbb:	0f be d8             	movsbl %al,%ebx
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	74 24                	je     800be6 <vprintfmt+0x24b>
  800bc2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc6:	78 b8                	js     800b80 <vprintfmt+0x1e5>
  800bc8:	ff 4d e0             	decl   -0x20(%ebp)
  800bcb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bcf:	79 af                	jns    800b80 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd1:	eb 13                	jmp    800be6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	6a 20                	push   $0x20
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	ff d0                	call   *%eax
  800be0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be3:	ff 4d e4             	decl   -0x1c(%ebp)
  800be6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bea:	7f e7                	jg     800bd3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bec:	e9 78 01 00 00       	jmp    800d69 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bf1:	83 ec 08             	sub    $0x8,%esp
  800bf4:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bfa:	50                   	push   %eax
  800bfb:	e8 3c fd ff ff       	call   80093c <getint>
  800c00:	83 c4 10             	add    $0x10,%esp
  800c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0f:	85 d2                	test   %edx,%edx
  800c11:	79 23                	jns    800c36 <vprintfmt+0x29b>
				putch('-', putdat);
  800c13:	83 ec 08             	sub    $0x8,%esp
  800c16:	ff 75 0c             	pushl  0xc(%ebp)
  800c19:	6a 2d                	push   $0x2d
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c29:	f7 d8                	neg    %eax
  800c2b:	83 d2 00             	adc    $0x0,%edx
  800c2e:	f7 da                	neg    %edx
  800c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3d:	e9 bc 00 00 00       	jmp    800cfe <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	ff 75 e8             	pushl  -0x18(%ebp)
  800c48:	8d 45 14             	lea    0x14(%ebp),%eax
  800c4b:	50                   	push   %eax
  800c4c:	e8 84 fc ff ff       	call   8008d5 <getuint>
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c5a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c61:	e9 98 00 00 00       	jmp    800cfe <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	6a 58                	push   $0x58
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	ff d0                	call   *%eax
  800c73:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	6a 58                	push   $0x58
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	ff d0                	call   *%eax
  800c83:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c86:	83 ec 08             	sub    $0x8,%esp
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	6a 58                	push   $0x58
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	ff d0                	call   *%eax
  800c93:	83 c4 10             	add    $0x10,%esp
			break;
  800c96:	e9 ce 00 00 00       	jmp    800d69 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c9b:	83 ec 08             	sub    $0x8,%esp
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	6a 30                	push   $0x30
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	ff d0                	call   *%eax
  800ca8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cab:	83 ec 08             	sub    $0x8,%esp
  800cae:	ff 75 0c             	pushl  0xc(%ebp)
  800cb1:	6a 78                	push   $0x78
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	ff d0                	call   *%eax
  800cb8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbe:	83 c0 04             	add    $0x4,%eax
  800cc1:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc7:	83 e8 04             	sub    $0x4,%eax
  800cca:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cd6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cdd:	eb 1f                	jmp    800cfe <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cdf:	83 ec 08             	sub    $0x8,%esp
  800ce2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ce5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ce8:	50                   	push   %eax
  800ce9:	e8 e7 fb ff ff       	call   8008d5 <getuint>
  800cee:	83 c4 10             	add    $0x10,%esp
  800cf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cf7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cfe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d05:	83 ec 04             	sub    $0x4,%esp
  800d08:	52                   	push   %edx
  800d09:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d0c:	50                   	push   %eax
  800d0d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d10:	ff 75 f0             	pushl  -0x10(%ebp)
  800d13:	ff 75 0c             	pushl  0xc(%ebp)
  800d16:	ff 75 08             	pushl  0x8(%ebp)
  800d19:	e8 00 fb ff ff       	call   80081e <printnum>
  800d1e:	83 c4 20             	add    $0x20,%esp
			break;
  800d21:	eb 46                	jmp    800d69 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d23:	83 ec 08             	sub    $0x8,%esp
  800d26:	ff 75 0c             	pushl  0xc(%ebp)
  800d29:	53                   	push   %ebx
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	ff d0                	call   *%eax
  800d2f:	83 c4 10             	add    $0x10,%esp
			break;
  800d32:	eb 35                	jmp    800d69 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d34:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800d3b:	eb 2c                	jmp    800d69 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d3d:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800d44:	eb 23                	jmp    800d69 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	ff 75 0c             	pushl  0xc(%ebp)
  800d4c:	6a 25                	push   $0x25
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	ff d0                	call   *%eax
  800d53:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d56:	ff 4d 10             	decl   0x10(%ebp)
  800d59:	eb 03                	jmp    800d5e <vprintfmt+0x3c3>
  800d5b:	ff 4d 10             	decl   0x10(%ebp)
  800d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d61:	48                   	dec    %eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	3c 25                	cmp    $0x25,%al
  800d66:	75 f3                	jne    800d5b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d68:	90                   	nop
		}
	}
  800d69:	e9 35 fc ff ff       	jmp    8009a3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d6e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d76:	55                   	push   %ebp
  800d77:	89 e5                	mov    %esp,%ebp
  800d79:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d7c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d7f:	83 c0 04             	add    $0x4,%eax
  800d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d85:	8b 45 10             	mov    0x10(%ebp),%eax
  800d88:	ff 75 f4             	pushl  -0xc(%ebp)
  800d8b:	50                   	push   %eax
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 08             	pushl  0x8(%ebp)
  800d92:	e8 04 fc ff ff       	call   80099b <vprintfmt>
  800d97:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d9a:	90                   	nop
  800d9b:	c9                   	leave  
  800d9c:	c3                   	ret    

00800d9d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8b 40 08             	mov    0x8(%eax),%eax
  800da6:	8d 50 01             	lea    0x1(%eax),%edx
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db2:	8b 10                	mov    (%eax),%edx
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	8b 40 04             	mov    0x4(%eax),%eax
  800dba:	39 c2                	cmp    %eax,%edx
  800dbc:	73 12                	jae    800dd0 <sprintputch+0x33>
		*b->buf++ = ch;
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	8b 00                	mov    (%eax),%eax
  800dc3:	8d 48 01             	lea    0x1(%eax),%ecx
  800dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc9:	89 0a                	mov    %ecx,(%edx)
  800dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dce:	88 10                	mov    %dl,(%eax)
}
  800dd0:	90                   	nop
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	01 d0                	add    %edx,%eax
  800dea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ded:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800df4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df8:	74 06                	je     800e00 <vsnprintf+0x2d>
  800dfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfe:	7f 07                	jg     800e07 <vsnprintf+0x34>
		return -E_INVAL;
  800e00:	b8 03 00 00 00       	mov    $0x3,%eax
  800e05:	eb 20                	jmp    800e27 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e07:	ff 75 14             	pushl  0x14(%ebp)
  800e0a:	ff 75 10             	pushl  0x10(%ebp)
  800e0d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e10:	50                   	push   %eax
  800e11:	68 9d 0d 80 00       	push   $0x800d9d
  800e16:	e8 80 fb ff ff       	call   80099b <vprintfmt>
  800e1b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e21:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e27:	c9                   	leave  
  800e28:	c3                   	ret    

00800e29 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e2f:	8d 45 10             	lea    0x10(%ebp),%eax
  800e32:	83 c0 04             	add    $0x4,%eax
  800e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800e3e:	50                   	push   %eax
  800e3f:	ff 75 0c             	pushl  0xc(%ebp)
  800e42:	ff 75 08             	pushl  0x8(%ebp)
  800e45:	e8 89 ff ff ff       	call   800dd3 <vsnprintf>
  800e4a:	83 c4 10             	add    $0x10,%esp
  800e4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e53:	c9                   	leave  
  800e54:	c3                   	ret    

00800e55 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e62:	eb 06                	jmp    800e6a <strlen+0x15>
		n++;
  800e64:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e67:	ff 45 08             	incl   0x8(%ebp)
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	84 c0                	test   %al,%al
  800e71:	75 f1                	jne    800e64 <strlen+0xf>
		n++;
	return n;
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e85:	eb 09                	jmp    800e90 <strnlen+0x18>
		n++;
  800e87:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e8a:	ff 45 08             	incl   0x8(%ebp)
  800e8d:	ff 4d 0c             	decl   0xc(%ebp)
  800e90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e94:	74 09                	je     800e9f <strnlen+0x27>
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	84 c0                	test   %al,%al
  800e9d:	75 e8                	jne    800e87 <strnlen+0xf>
		n++;
	return n;
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800eb0:	90                   	nop
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8d 50 01             	lea    0x1(%eax),%edx
  800eb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec3:	8a 12                	mov    (%edx),%dl
  800ec5:	88 10                	mov    %dl,(%eax)
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	84 c0                	test   %al,%al
  800ecb:	75 e4                	jne    800eb1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ecd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ede:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ee5:	eb 1f                	jmp    800f06 <strncpy+0x34>
		*dst++ = *src;
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8d 50 01             	lea    0x1(%eax),%edx
  800eed:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef3:	8a 12                	mov    (%edx),%dl
  800ef5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	84 c0                	test   %al,%al
  800efe:	74 03                	je     800f03 <strncpy+0x31>
			src++;
  800f00:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f03:	ff 45 fc             	incl   -0x4(%ebp)
  800f06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f09:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f0c:	72 d9                	jb     800ee7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f11:	c9                   	leave  
  800f12:	c3                   	ret    

00800f13 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f23:	74 30                	je     800f55 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f25:	eb 16                	jmp    800f3d <strlcpy+0x2a>
			*dst++ = *src++;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8d 50 01             	lea    0x1(%eax),%edx
  800f2d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f33:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f36:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f39:	8a 12                	mov    (%edx),%dl
  800f3b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f3d:	ff 4d 10             	decl   0x10(%ebp)
  800f40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f44:	74 09                	je     800f4f <strlcpy+0x3c>
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	84 c0                	test   %al,%al
  800f4d:	75 d8                	jne    800f27 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f55:	8b 55 08             	mov    0x8(%ebp),%edx
  800f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5b:	29 c2                	sub    %eax,%edx
  800f5d:	89 d0                	mov    %edx,%eax
}
  800f5f:	c9                   	leave  
  800f60:	c3                   	ret    

00800f61 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f64:	eb 06                	jmp    800f6c <strcmp+0xb>
		p++, q++;
  800f66:	ff 45 08             	incl   0x8(%ebp)
  800f69:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	84 c0                	test   %al,%al
  800f73:	74 0e                	je     800f83 <strcmp+0x22>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 10                	mov    (%eax),%dl
  800f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	38 c2                	cmp    %al,%dl
  800f81:	74 e3                	je     800f66 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	0f b6 d0             	movzbl %al,%edx
  800f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	0f b6 c0             	movzbl %al,%eax
  800f93:	29 c2                	sub    %eax,%edx
  800f95:	89 d0                	mov    %edx,%eax
}
  800f97:	5d                   	pop    %ebp
  800f98:	c3                   	ret    

00800f99 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f9c:	eb 09                	jmp    800fa7 <strncmp+0xe>
		n--, p++, q++;
  800f9e:	ff 4d 10             	decl   0x10(%ebp)
  800fa1:	ff 45 08             	incl   0x8(%ebp)
  800fa4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fa7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fab:	74 17                	je     800fc4 <strncmp+0x2b>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	84 c0                	test   %al,%al
  800fb4:	74 0e                	je     800fc4 <strncmp+0x2b>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 10                	mov    (%eax),%dl
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	38 c2                	cmp    %al,%dl
  800fc2:	74 da                	je     800f9e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc8:	75 07                	jne    800fd1 <strncmp+0x38>
		return 0;
  800fca:	b8 00 00 00 00       	mov    $0x0,%eax
  800fcf:	eb 14                	jmp    800fe5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	0f b6 d0             	movzbl %al,%edx
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	0f b6 c0             	movzbl %al,%eax
  800fe1:	29 c2                	sub    %eax,%edx
  800fe3:	89 d0                	mov    %edx,%eax
}
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    

00800fe7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	83 ec 04             	sub    $0x4,%esp
  800fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff3:	eb 12                	jmp    801007 <strchr+0x20>
		if (*s == c)
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ffd:	75 05                	jne    801004 <strchr+0x1d>
			return (char *) s;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	eb 11                	jmp    801015 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801004:	ff 45 08             	incl   0x8(%ebp)
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	84 c0                	test   %al,%al
  80100e:	75 e5                	jne    800ff5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801010:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 04             	sub    $0x4,%esp
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801023:	eb 0d                	jmp    801032 <strfind+0x1b>
		if (*s == c)
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80102d:	74 0e                	je     80103d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	84 c0                	test   %al,%al
  801039:	75 ea                	jne    801025 <strfind+0xe>
  80103b:	eb 01                	jmp    80103e <strfind+0x27>
		if (*s == c)
			break;
  80103d:	90                   	nop
	return (char *) s;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80104f:	8b 45 10             	mov    0x10(%ebp),%eax
  801052:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801055:	eb 0e                	jmp    801065 <memset+0x22>
		*p++ = c;
  801057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80105a:	8d 50 01             	lea    0x1(%eax),%edx
  80105d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801060:	8b 55 0c             	mov    0xc(%ebp),%edx
  801063:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801065:	ff 4d f8             	decl   -0x8(%ebp)
  801068:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80106c:	79 e9                	jns    801057 <memset+0x14>
		*p++ = c;

	return v;
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801071:	c9                   	leave  
  801072:	c3                   	ret    

00801073 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801079:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801085:	eb 16                	jmp    80109d <memcpy+0x2a>
		*d++ = *s++;
  801087:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108a:	8d 50 01             	lea    0x1(%eax),%edx
  80108d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801090:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801093:	8d 4a 01             	lea    0x1(%edx),%ecx
  801096:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801099:	8a 12                	mov    (%edx),%dl
  80109b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80109d:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a6:	85 c0                	test   %eax,%eax
  8010a8:	75 dd                	jne    801087 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ad:	c9                   	leave  
  8010ae:	c3                   	ret    

008010af <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010c7:	73 50                	jae    801119 <memmove+0x6a>
  8010c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cf:	01 d0                	add    %edx,%eax
  8010d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010d4:	76 43                	jbe    801119 <memmove+0x6a>
		s += n;
  8010d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010e2:	eb 10                	jmp    8010f4 <memmove+0x45>
			*--d = *--s;
  8010e4:	ff 4d f8             	decl   -0x8(%ebp)
  8010e7:	ff 4d fc             	decl   -0x4(%ebp)
  8010ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ed:	8a 10                	mov    (%eax),%dl
  8010ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	75 e3                	jne    8010e4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801101:	eb 23                	jmp    801126 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801103:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801106:	8d 50 01             	lea    0x1(%eax),%edx
  801109:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80110c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801112:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801115:	8a 12                	mov    (%edx),%dl
  801117:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801119:	8b 45 10             	mov    0x10(%ebp),%eax
  80111c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111f:	89 55 10             	mov    %edx,0x10(%ebp)
  801122:	85 c0                	test   %eax,%eax
  801124:	75 dd                	jne    801103 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801129:	c9                   	leave  
  80112a:	c3                   	ret    

0080112b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80113d:	eb 2a                	jmp    801169 <memcmp+0x3e>
		if (*s1 != *s2)
  80113f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801142:	8a 10                	mov    (%eax),%dl
  801144:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	38 c2                	cmp    %al,%dl
  80114b:	74 16                	je     801163 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80114d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f b6 d0             	movzbl %al,%edx
  801155:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	0f b6 c0             	movzbl %al,%eax
  80115d:	29 c2                	sub    %eax,%edx
  80115f:	89 d0                	mov    %edx,%eax
  801161:	eb 18                	jmp    80117b <memcmp+0x50>
		s1++, s2++;
  801163:	ff 45 fc             	incl   -0x4(%ebp)
  801166:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116f:	89 55 10             	mov    %edx,0x10(%ebp)
  801172:	85 c0                	test   %eax,%eax
  801174:	75 c9                	jne    80113f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801176:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117b:	c9                   	leave  
  80117c:	c3                   	ret    

0080117d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	8b 45 10             	mov    0x10(%ebp),%eax
  801189:	01 d0                	add    %edx,%eax
  80118b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80118e:	eb 15                	jmp    8011a5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	0f b6 d0             	movzbl %al,%edx
  801198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119b:	0f b6 c0             	movzbl %al,%eax
  80119e:	39 c2                	cmp    %eax,%edx
  8011a0:	74 0d                	je     8011af <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011a2:	ff 45 08             	incl   0x8(%ebp)
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011ab:	72 e3                	jb     801190 <memfind+0x13>
  8011ad:	eb 01                	jmp    8011b0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011af:	90                   	nop
	return (void *) s;
  8011b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b3:	c9                   	leave  
  8011b4:	c3                   	ret    

008011b5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c9:	eb 03                	jmp    8011ce <strtol+0x19>
		s++;
  8011cb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	3c 20                	cmp    $0x20,%al
  8011d5:	74 f4                	je     8011cb <strtol+0x16>
  8011d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011da:	8a 00                	mov    (%eax),%al
  8011dc:	3c 09                	cmp    $0x9,%al
  8011de:	74 eb                	je     8011cb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 2b                	cmp    $0x2b,%al
  8011e7:	75 05                	jne    8011ee <strtol+0x39>
		s++;
  8011e9:	ff 45 08             	incl   0x8(%ebp)
  8011ec:	eb 13                	jmp    801201 <strtol+0x4c>
	else if (*s == '-')
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	8a 00                	mov    (%eax),%al
  8011f3:	3c 2d                	cmp    $0x2d,%al
  8011f5:	75 0a                	jne    801201 <strtol+0x4c>
		s++, neg = 1;
  8011f7:	ff 45 08             	incl   0x8(%ebp)
  8011fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801201:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801205:	74 06                	je     80120d <strtol+0x58>
  801207:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80120b:	75 20                	jne    80122d <strtol+0x78>
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	3c 30                	cmp    $0x30,%al
  801214:	75 17                	jne    80122d <strtol+0x78>
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	40                   	inc    %eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	3c 78                	cmp    $0x78,%al
  80121e:	75 0d                	jne    80122d <strtol+0x78>
		s += 2, base = 16;
  801220:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801224:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80122b:	eb 28                	jmp    801255 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80122d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801231:	75 15                	jne    801248 <strtol+0x93>
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	3c 30                	cmp    $0x30,%al
  80123a:	75 0c                	jne    801248 <strtol+0x93>
		s++, base = 8;
  80123c:	ff 45 08             	incl   0x8(%ebp)
  80123f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801246:	eb 0d                	jmp    801255 <strtol+0xa0>
	else if (base == 0)
  801248:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124c:	75 07                	jne    801255 <strtol+0xa0>
		base = 10;
  80124e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	3c 2f                	cmp    $0x2f,%al
  80125c:	7e 19                	jle    801277 <strtol+0xc2>
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 39                	cmp    $0x39,%al
  801265:	7f 10                	jg     801277 <strtol+0xc2>
			dig = *s - '0';
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	0f be c0             	movsbl %al,%eax
  80126f:	83 e8 30             	sub    $0x30,%eax
  801272:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801275:	eb 42                	jmp    8012b9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	3c 60                	cmp    $0x60,%al
  80127e:	7e 19                	jle    801299 <strtol+0xe4>
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 7a                	cmp    $0x7a,%al
  801287:	7f 10                	jg     801299 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	0f be c0             	movsbl %al,%eax
  801291:	83 e8 57             	sub    $0x57,%eax
  801294:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801297:	eb 20                	jmp    8012b9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801299:	8b 45 08             	mov    0x8(%ebp),%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	3c 40                	cmp    $0x40,%al
  8012a0:	7e 39                	jle    8012db <strtol+0x126>
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 5a                	cmp    $0x5a,%al
  8012a9:	7f 30                	jg     8012db <strtol+0x126>
			dig = *s - 'A' + 10;
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	0f be c0             	movsbl %al,%eax
  8012b3:	83 e8 37             	sub    $0x37,%eax
  8012b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012bf:	7d 19                	jge    8012da <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012c1:	ff 45 08             	incl   0x8(%ebp)
  8012c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012cb:	89 c2                	mov    %eax,%edx
  8012cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012d5:	e9 7b ff ff ff       	jmp    801255 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012da:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012df:	74 08                	je     8012e9 <strtol+0x134>
		*endptr = (char *) s;
  8012e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ed:	74 07                	je     8012f6 <strtol+0x141>
  8012ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f2:	f7 d8                	neg    %eax
  8012f4:	eb 03                	jmp    8012f9 <strtol+0x144>
  8012f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <ltostr>:

void
ltostr(long value, char *str)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801308:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80130f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801313:	79 13                	jns    801328 <ltostr+0x2d>
	{
		neg = 1;
  801315:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80131c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801322:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801325:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801330:	99                   	cltd   
  801331:	f7 f9                	idiv   %ecx
  801333:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801336:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801339:	8d 50 01             	lea    0x1(%eax),%edx
  80133c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80133f:	89 c2                	mov    %eax,%edx
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	01 d0                	add    %edx,%eax
  801346:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801349:	83 c2 30             	add    $0x30,%edx
  80134c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80134e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801351:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801356:	f7 e9                	imul   %ecx
  801358:	c1 fa 02             	sar    $0x2,%edx
  80135b:	89 c8                	mov    %ecx,%eax
  80135d:	c1 f8 1f             	sar    $0x1f,%eax
  801360:	29 c2                	sub    %eax,%edx
  801362:	89 d0                	mov    %edx,%eax
  801364:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801367:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80136b:	75 bb                	jne    801328 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80136d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801374:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801377:	48                   	dec    %eax
  801378:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80137b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137f:	74 3d                	je     8013be <ltostr+0xc3>
		start = 1 ;
  801381:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801388:	eb 34                	jmp    8013be <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80138a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801390:	01 d0                	add    %edx,%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801397:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	01 c2                	add    %eax,%edx
  80139f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a5:	01 c8                	add    %ecx,%eax
  8013a7:	8a 00                	mov    (%eax),%al
  8013a9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b1:	01 c2                	add    %eax,%edx
  8013b3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013b6:	88 02                	mov    %al,(%edx)
		start++ ;
  8013b8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013bb:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013c4:	7c c4                	jl     80138a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013d1:	90                   	nop
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013da:	ff 75 08             	pushl  0x8(%ebp)
  8013dd:	e8 73 fa ff ff       	call   800e55 <strlen>
  8013e2:	83 c4 04             	add    $0x4,%esp
  8013e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013e8:	ff 75 0c             	pushl  0xc(%ebp)
  8013eb:	e8 65 fa ff ff       	call   800e55 <strlen>
  8013f0:	83 c4 04             	add    $0x4,%esp
  8013f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801404:	eb 17                	jmp    80141d <strcconcat+0x49>
		final[s] = str1[s] ;
  801406:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801409:	8b 45 10             	mov    0x10(%ebp),%eax
  80140c:	01 c2                	add    %eax,%edx
  80140e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	01 c8                	add    %ecx,%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80141a:	ff 45 fc             	incl   -0x4(%ebp)
  80141d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801420:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801423:	7c e1                	jl     801406 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801425:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80142c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801433:	eb 1f                	jmp    801454 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801435:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801438:	8d 50 01             	lea    0x1(%eax),%edx
  80143b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80143e:	89 c2                	mov    %eax,%edx
  801440:	8b 45 10             	mov    0x10(%ebp),%eax
  801443:	01 c2                	add    %eax,%edx
  801445:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801448:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144b:	01 c8                	add    %ecx,%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801451:	ff 45 f8             	incl   -0x8(%ebp)
  801454:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801457:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80145a:	7c d9                	jl     801435 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80145c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145f:	8b 45 10             	mov    0x10(%ebp),%eax
  801462:	01 d0                	add    %edx,%eax
  801464:	c6 00 00             	movb   $0x0,(%eax)
}
  801467:	90                   	nop
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80146d:	8b 45 14             	mov    0x14(%ebp),%eax
  801470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801476:	8b 45 14             	mov    0x14(%ebp),%eax
  801479:	8b 00                	mov    (%eax),%eax
  80147b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801482:	8b 45 10             	mov    0x10(%ebp),%eax
  801485:	01 d0                	add    %edx,%eax
  801487:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148d:	eb 0c                	jmp    80149b <strsplit+0x31>
			*string++ = 0;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8d 50 01             	lea    0x1(%eax),%edx
  801495:	89 55 08             	mov    %edx,0x8(%ebp)
  801498:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	84 c0                	test   %al,%al
  8014a2:	74 18                	je     8014bc <strsplit+0x52>
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	0f be c0             	movsbl %al,%eax
  8014ac:	50                   	push   %eax
  8014ad:	ff 75 0c             	pushl  0xc(%ebp)
  8014b0:	e8 32 fb ff ff       	call   800fe7 <strchr>
  8014b5:	83 c4 08             	add    $0x8,%esp
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	75 d3                	jne    80148f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	8a 00                	mov    (%eax),%al
  8014c1:	84 c0                	test   %al,%al
  8014c3:	74 5a                	je     80151f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c8:	8b 00                	mov    (%eax),%eax
  8014ca:	83 f8 0f             	cmp    $0xf,%eax
  8014cd:	75 07                	jne    8014d6 <strsplit+0x6c>
		{
			return 0;
  8014cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d4:	eb 66                	jmp    80153c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d9:	8b 00                	mov    (%eax),%eax
  8014db:	8d 48 01             	lea    0x1(%eax),%ecx
  8014de:	8b 55 14             	mov    0x14(%ebp),%edx
  8014e1:	89 0a                	mov    %ecx,(%edx)
  8014e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ed:	01 c2                	add    %eax,%edx
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014f4:	eb 03                	jmp    8014f9 <strsplit+0x8f>
			string++;
  8014f6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	84 c0                	test   %al,%al
  801500:	74 8b                	je     80148d <strsplit+0x23>
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	0f be c0             	movsbl %al,%eax
  80150a:	50                   	push   %eax
  80150b:	ff 75 0c             	pushl  0xc(%ebp)
  80150e:	e8 d4 fa ff ff       	call   800fe7 <strchr>
  801513:	83 c4 08             	add    $0x8,%esp
  801516:	85 c0                	test   %eax,%eax
  801518:	74 dc                	je     8014f6 <strsplit+0x8c>
			string++;
	}
  80151a:	e9 6e ff ff ff       	jmp    80148d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80151f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801520:	8b 45 14             	mov    0x14(%ebp),%eax
  801523:	8b 00                	mov    (%eax),%eax
  801525:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80152c:	8b 45 10             	mov    0x10(%ebp),%eax
  80152f:	01 d0                	add    %edx,%eax
  801531:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801537:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    

0080153e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	68 48 26 80 00       	push   $0x802648
  80154c:	68 3f 01 00 00       	push   $0x13f
  801551:	68 6a 26 80 00       	push   $0x80266a
  801556:	e8 a9 ef ff ff       	call   800504 <_panic>

0080155b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	57                   	push   %edi
  80155f:	56                   	push   %esi
  801560:	53                   	push   %ebx
  801561:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80156d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801570:	8b 7d 18             	mov    0x18(%ebp),%edi
  801573:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801576:	cd 30                	int    $0x30
  801578:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80157b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	5b                   	pop    %ebx
  801582:	5e                   	pop    %esi
  801583:	5f                   	pop    %edi
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    

00801586 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 04             	sub    $0x4,%esp
  80158c:	8b 45 10             	mov    0x10(%ebp),%eax
  80158f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801592:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	52                   	push   %edx
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	50                   	push   %eax
  8015a2:	6a 00                	push   $0x0
  8015a4:	e8 b2 ff ff ff       	call   80155b <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
}
  8015ac:	90                   	nop
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_cgetc>:

int
sys_cgetc(void)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 02                	push   $0x2
  8015be:	e8 98 ff ff ff       	call   80155b <syscall>
  8015c3:	83 c4 18             	add    $0x18,%esp
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 03                	push   $0x3
  8015d7:	e8 7f ff ff ff       	call   80155b <syscall>
  8015dc:	83 c4 18             	add    $0x18,%esp
}
  8015df:	90                   	nop
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 04                	push   $0x4
  8015f1:	e8 65 ff ff ff       	call   80155b <syscall>
  8015f6:	83 c4 18             	add    $0x18,%esp
}
  8015f9:	90                   	nop
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	52                   	push   %edx
  80160c:	50                   	push   %eax
  80160d:	6a 08                	push   $0x8
  80160f:	e8 47 ff ff ff       	call   80155b <syscall>
  801614:	83 c4 18             	add    $0x18,%esp
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	56                   	push   %esi
  80161d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80161e:	8b 75 18             	mov    0x18(%ebp),%esi
  801621:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801624:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	56                   	push   %esi
  80162e:	53                   	push   %ebx
  80162f:	51                   	push   %ecx
  801630:	52                   	push   %edx
  801631:	50                   	push   %eax
  801632:	6a 09                	push   $0x9
  801634:	e8 22 ff ff ff       	call   80155b <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
}
  80163c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163f:	5b                   	pop    %ebx
  801640:	5e                   	pop    %esi
  801641:	5d                   	pop    %ebp
  801642:	c3                   	ret    

00801643 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801646:	8b 55 0c             	mov    0xc(%ebp),%edx
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	52                   	push   %edx
  801653:	50                   	push   %eax
  801654:	6a 0a                	push   $0xa
  801656:	e8 00 ff ff ff       	call   80155b <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
}
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	ff 75 08             	pushl  0x8(%ebp)
  80166f:	6a 0b                	push   $0xb
  801671:	e8 e5 fe ff ff       	call   80155b <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 0c                	push   $0xc
  80168a:	e8 cc fe ff ff       	call   80155b <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 0d                	push   $0xd
  8016a3:	e8 b3 fe ff ff       	call   80155b <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 0e                	push   $0xe
  8016bc:	e8 9a fe ff ff       	call   80155b <syscall>
  8016c1:	83 c4 18             	add    $0x18,%esp
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 0f                	push   $0xf
  8016d5:	e8 81 fe ff ff       	call   80155b <syscall>
  8016da:	83 c4 18             	add    $0x18,%esp
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	6a 10                	push   $0x10
  8016ef:	e8 67 fe ff ff       	call   80155b <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 11                	push   $0x11
  801708:	e8 4e fe ff ff       	call   80155b <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	90                   	nop
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_cputc>:

void
sys_cputc(const char c)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 04             	sub    $0x4,%esp
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80171f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	50                   	push   %eax
  80172c:	6a 01                	push   $0x1
  80172e:	e8 28 fe ff ff       	call   80155b <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	90                   	nop
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 14                	push   $0x14
  801748:	e8 0e fe ff ff       	call   80155b <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	90                   	nop
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80175f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801762:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	51                   	push   %ecx
  80176c:	52                   	push   %edx
  80176d:	ff 75 0c             	pushl  0xc(%ebp)
  801770:	50                   	push   %eax
  801771:	6a 15                	push   $0x15
  801773:	e8 e3 fd ff ff       	call   80155b <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801780:	8b 55 0c             	mov    0xc(%ebp),%edx
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	6a 16                	push   $0x16
  801790:	e8 c6 fd ff ff       	call   80155b <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80179d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	51                   	push   %ecx
  8017ab:	52                   	push   %edx
  8017ac:	50                   	push   %eax
  8017ad:	6a 17                	push   $0x17
  8017af:	e8 a7 fd ff ff       	call   80155b <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	6a 18                	push   $0x18
  8017cc:	e8 8a fd ff ff       	call   80155b <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	6a 00                	push   $0x0
  8017de:	ff 75 14             	pushl  0x14(%ebp)
  8017e1:	ff 75 10             	pushl  0x10(%ebp)
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	50                   	push   %eax
  8017e8:	6a 19                	push   $0x19
  8017ea:	e8 6c fd ff ff       	call   80155b <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	50                   	push   %eax
  801803:	6a 1a                	push   $0x1a
  801805:	e8 51 fd ff ff       	call   80155b <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	90                   	nop
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	50                   	push   %eax
  80181f:	6a 1b                	push   $0x1b
  801821:	e8 35 fd ff ff       	call   80155b <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 05                	push   $0x5
  80183a:	e8 1c fd ff ff       	call   80155b <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 06                	push   $0x6
  801853:	e8 03 fd ff ff       	call   80155b <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 07                	push   $0x7
  80186c:	e8 ea fc ff ff       	call   80155b <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_exit_env>:


void sys_exit_env(void)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 1c                	push   $0x1c
  801885:	e8 d1 fc ff ff       	call   80155b <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	90                   	nop
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801896:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801899:	8d 50 04             	lea    0x4(%eax),%edx
  80189c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	52                   	push   %edx
  8018a6:	50                   	push   %eax
  8018a7:	6a 1d                	push   $0x1d
  8018a9:	e8 ad fc ff ff       	call   80155b <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
	return result;
  8018b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ba:	89 01                	mov    %eax,(%ecx)
  8018bc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	c9                   	leave  
  8018c3:	c2 04 00             	ret    $0x4

008018c6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	ff 75 10             	pushl  0x10(%ebp)
  8018d0:	ff 75 0c             	pushl  0xc(%ebp)
  8018d3:	ff 75 08             	pushl  0x8(%ebp)
  8018d6:	6a 13                	push   $0x13
  8018d8:	e8 7e fc ff ff       	call   80155b <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e0:	90                   	nop
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 1e                	push   $0x1e
  8018f2:	e8 64 fc ff ff       	call   80155b <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801908:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	50                   	push   %eax
  801915:	6a 1f                	push   $0x1f
  801917:	e8 3f fc ff ff       	call   80155b <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
	return ;
  80191f:	90                   	nop
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <rsttst>:
void rsttst()
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 21                	push   $0x21
  801931:	e8 25 fc ff ff       	call   80155b <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
	return ;
  801939:	90                   	nop
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	8b 45 14             	mov    0x14(%ebp),%eax
  801945:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801948:	8b 55 18             	mov    0x18(%ebp),%edx
  80194b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	ff 75 10             	pushl  0x10(%ebp)
  801954:	ff 75 0c             	pushl  0xc(%ebp)
  801957:	ff 75 08             	pushl  0x8(%ebp)
  80195a:	6a 20                	push   $0x20
  80195c:	e8 fa fb ff ff       	call   80155b <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
	return ;
  801964:	90                   	nop
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <chktst>:
void chktst(uint32 n)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	ff 75 08             	pushl  0x8(%ebp)
  801975:	6a 22                	push   $0x22
  801977:	e8 df fb ff ff       	call   80155b <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
	return ;
  80197f:	90                   	nop
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <inctst>:

void inctst()
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 23                	push   $0x23
  801991:	e8 c5 fb ff ff       	call   80155b <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
	return ;
  801999:	90                   	nop
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <gettst>:
uint32 gettst()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 24                	push   $0x24
  8019ab:	e8 ab fb ff ff       	call   80155b <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 25                	push   $0x25
  8019c7:	e8 8f fb ff ff       	call   80155b <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
  8019cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019d2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019d6:	75 07                	jne    8019df <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8019dd:	eb 05                	jmp    8019e4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 25                	push   $0x25
  8019f8:	e8 5e fb ff ff       	call   80155b <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
  801a00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a03:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a07:	75 07                	jne    801a10 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a09:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0e:	eb 05                	jmp    801a15 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 25                	push   $0x25
  801a29:	e8 2d fb ff ff       	call   80155b <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
  801a31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a34:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a38:	75 07                	jne    801a41 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3f:	eb 05                	jmp    801a46 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 25                	push   $0x25
  801a5a:	e8 fc fa ff ff       	call   80155b <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
  801a62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a65:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a69:	75 07                	jne    801a72 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a70:	eb 05                	jmp    801a77 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	ff 75 08             	pushl  0x8(%ebp)
  801a87:	6a 26                	push   $0x26
  801a89:	e8 cd fa ff ff       	call   80155b <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a91:	90                   	nop
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a98:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	53                   	push   %ebx
  801aa7:	51                   	push   %ecx
  801aa8:	52                   	push   %edx
  801aa9:	50                   	push   %eax
  801aaa:	6a 27                	push   $0x27
  801aac:	e8 aa fa ff ff       	call   80155b <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
}
  801ab4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801abc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	52                   	push   %edx
  801ac9:	50                   	push   %eax
  801aca:	6a 28                	push   $0x28
  801acc:	e8 8a fa ff ff       	call   80155b <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ad9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801adc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	6a 00                	push   $0x0
  801ae4:	51                   	push   %ecx
  801ae5:	ff 75 10             	pushl  0x10(%ebp)
  801ae8:	52                   	push   %edx
  801ae9:	50                   	push   %eax
  801aea:	6a 29                	push   $0x29
  801aec:	e8 6a fa ff ff       	call   80155b <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	ff 75 10             	pushl  0x10(%ebp)
  801b00:	ff 75 0c             	pushl  0xc(%ebp)
  801b03:	ff 75 08             	pushl  0x8(%ebp)
  801b06:	6a 12                	push   $0x12
  801b08:	e8 4e fa ff ff       	call   80155b <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b10:	90                   	nop
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	52                   	push   %edx
  801b23:	50                   	push   %eax
  801b24:	6a 2a                	push   $0x2a
  801b26:	e8 30 fa ff ff       	call   80155b <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
	return;
  801b2e:	90                   	nop
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b37:	83 ec 04             	sub    $0x4,%esp
  801b3a:	68 77 26 80 00       	push   $0x802677
  801b3f:	68 2e 01 00 00       	push   $0x12e
  801b44:	68 8b 26 80 00       	push   $0x80268b
  801b49:	e8 b6 e9 ff ff       	call   800504 <_panic>

00801b4e <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b54:	83 ec 04             	sub    $0x4,%esp
  801b57:	68 77 26 80 00       	push   $0x802677
  801b5c:	68 35 01 00 00       	push   $0x135
  801b61:	68 8b 26 80 00       	push   $0x80268b
  801b66:	e8 99 e9 ff ff       	call   800504 <_panic>

00801b6b <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b71:	83 ec 04             	sub    $0x4,%esp
  801b74:	68 77 26 80 00       	push   $0x802677
  801b79:	68 3b 01 00 00       	push   $0x13b
  801b7e:	68 8b 26 80 00       	push   $0x80268b
  801b83:	e8 7c e9 ff ff       	call   800504 <_panic>

00801b88 <__udivdi3>:
  801b88:	55                   	push   %ebp
  801b89:	57                   	push   %edi
  801b8a:	56                   	push   %esi
  801b8b:	53                   	push   %ebx
  801b8c:	83 ec 1c             	sub    $0x1c,%esp
  801b8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b9f:	89 ca                	mov    %ecx,%edx
  801ba1:	89 f8                	mov    %edi,%eax
  801ba3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ba7:	85 f6                	test   %esi,%esi
  801ba9:	75 2d                	jne    801bd8 <__udivdi3+0x50>
  801bab:	39 cf                	cmp    %ecx,%edi
  801bad:	77 65                	ja     801c14 <__udivdi3+0x8c>
  801baf:	89 fd                	mov    %edi,%ebp
  801bb1:	85 ff                	test   %edi,%edi
  801bb3:	75 0b                	jne    801bc0 <__udivdi3+0x38>
  801bb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bba:	31 d2                	xor    %edx,%edx
  801bbc:	f7 f7                	div    %edi
  801bbe:	89 c5                	mov    %eax,%ebp
  801bc0:	31 d2                	xor    %edx,%edx
  801bc2:	89 c8                	mov    %ecx,%eax
  801bc4:	f7 f5                	div    %ebp
  801bc6:	89 c1                	mov    %eax,%ecx
  801bc8:	89 d8                	mov    %ebx,%eax
  801bca:	f7 f5                	div    %ebp
  801bcc:	89 cf                	mov    %ecx,%edi
  801bce:	89 fa                	mov    %edi,%edx
  801bd0:	83 c4 1c             	add    $0x1c,%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5f                   	pop    %edi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    
  801bd8:	39 ce                	cmp    %ecx,%esi
  801bda:	77 28                	ja     801c04 <__udivdi3+0x7c>
  801bdc:	0f bd fe             	bsr    %esi,%edi
  801bdf:	83 f7 1f             	xor    $0x1f,%edi
  801be2:	75 40                	jne    801c24 <__udivdi3+0x9c>
  801be4:	39 ce                	cmp    %ecx,%esi
  801be6:	72 0a                	jb     801bf2 <__udivdi3+0x6a>
  801be8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bec:	0f 87 9e 00 00 00    	ja     801c90 <__udivdi3+0x108>
  801bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf7:	89 fa                	mov    %edi,%edx
  801bf9:	83 c4 1c             	add    $0x1c,%esp
  801bfc:	5b                   	pop    %ebx
  801bfd:	5e                   	pop    %esi
  801bfe:	5f                   	pop    %edi
  801bff:	5d                   	pop    %ebp
  801c00:	c3                   	ret    
  801c01:	8d 76 00             	lea    0x0(%esi),%esi
  801c04:	31 ff                	xor    %edi,%edi
  801c06:	31 c0                	xor    %eax,%eax
  801c08:	89 fa                	mov    %edi,%edx
  801c0a:	83 c4 1c             	add    $0x1c,%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5e                   	pop    %esi
  801c0f:	5f                   	pop    %edi
  801c10:	5d                   	pop    %ebp
  801c11:	c3                   	ret    
  801c12:	66 90                	xchg   %ax,%ax
  801c14:	89 d8                	mov    %ebx,%eax
  801c16:	f7 f7                	div    %edi
  801c18:	31 ff                	xor    %edi,%edi
  801c1a:	89 fa                	mov    %edi,%edx
  801c1c:	83 c4 1c             	add    $0x1c,%esp
  801c1f:	5b                   	pop    %ebx
  801c20:	5e                   	pop    %esi
  801c21:	5f                   	pop    %edi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    
  801c24:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c29:	89 eb                	mov    %ebp,%ebx
  801c2b:	29 fb                	sub    %edi,%ebx
  801c2d:	89 f9                	mov    %edi,%ecx
  801c2f:	d3 e6                	shl    %cl,%esi
  801c31:	89 c5                	mov    %eax,%ebp
  801c33:	88 d9                	mov    %bl,%cl
  801c35:	d3 ed                	shr    %cl,%ebp
  801c37:	89 e9                	mov    %ebp,%ecx
  801c39:	09 f1                	or     %esi,%ecx
  801c3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c3f:	89 f9                	mov    %edi,%ecx
  801c41:	d3 e0                	shl    %cl,%eax
  801c43:	89 c5                	mov    %eax,%ebp
  801c45:	89 d6                	mov    %edx,%esi
  801c47:	88 d9                	mov    %bl,%cl
  801c49:	d3 ee                	shr    %cl,%esi
  801c4b:	89 f9                	mov    %edi,%ecx
  801c4d:	d3 e2                	shl    %cl,%edx
  801c4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c53:	88 d9                	mov    %bl,%cl
  801c55:	d3 e8                	shr    %cl,%eax
  801c57:	09 c2                	or     %eax,%edx
  801c59:	89 d0                	mov    %edx,%eax
  801c5b:	89 f2                	mov    %esi,%edx
  801c5d:	f7 74 24 0c          	divl   0xc(%esp)
  801c61:	89 d6                	mov    %edx,%esi
  801c63:	89 c3                	mov    %eax,%ebx
  801c65:	f7 e5                	mul    %ebp
  801c67:	39 d6                	cmp    %edx,%esi
  801c69:	72 19                	jb     801c84 <__udivdi3+0xfc>
  801c6b:	74 0b                	je     801c78 <__udivdi3+0xf0>
  801c6d:	89 d8                	mov    %ebx,%eax
  801c6f:	31 ff                	xor    %edi,%edi
  801c71:	e9 58 ff ff ff       	jmp    801bce <__udivdi3+0x46>
  801c76:	66 90                	xchg   %ax,%ax
  801c78:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c7c:	89 f9                	mov    %edi,%ecx
  801c7e:	d3 e2                	shl    %cl,%edx
  801c80:	39 c2                	cmp    %eax,%edx
  801c82:	73 e9                	jae    801c6d <__udivdi3+0xe5>
  801c84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c87:	31 ff                	xor    %edi,%edi
  801c89:	e9 40 ff ff ff       	jmp    801bce <__udivdi3+0x46>
  801c8e:	66 90                	xchg   %ax,%ax
  801c90:	31 c0                	xor    %eax,%eax
  801c92:	e9 37 ff ff ff       	jmp    801bce <__udivdi3+0x46>
  801c97:	90                   	nop

00801c98 <__umoddi3>:
  801c98:	55                   	push   %ebp
  801c99:	57                   	push   %edi
  801c9a:	56                   	push   %esi
  801c9b:	53                   	push   %ebx
  801c9c:	83 ec 1c             	sub    $0x1c,%esp
  801c9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ca3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ca7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801caf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cb7:	89 f3                	mov    %esi,%ebx
  801cb9:	89 fa                	mov    %edi,%edx
  801cbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cbf:	89 34 24             	mov    %esi,(%esp)
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	75 1a                	jne    801ce0 <__umoddi3+0x48>
  801cc6:	39 f7                	cmp    %esi,%edi
  801cc8:	0f 86 a2 00 00 00    	jbe    801d70 <__umoddi3+0xd8>
  801cce:	89 c8                	mov    %ecx,%eax
  801cd0:	89 f2                	mov    %esi,%edx
  801cd2:	f7 f7                	div    %edi
  801cd4:	89 d0                	mov    %edx,%eax
  801cd6:	31 d2                	xor    %edx,%edx
  801cd8:	83 c4 1c             	add    $0x1c,%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5f                   	pop    %edi
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    
  801ce0:	39 f0                	cmp    %esi,%eax
  801ce2:	0f 87 ac 00 00 00    	ja     801d94 <__umoddi3+0xfc>
  801ce8:	0f bd e8             	bsr    %eax,%ebp
  801ceb:	83 f5 1f             	xor    $0x1f,%ebp
  801cee:	0f 84 ac 00 00 00    	je     801da0 <__umoddi3+0x108>
  801cf4:	bf 20 00 00 00       	mov    $0x20,%edi
  801cf9:	29 ef                	sub    %ebp,%edi
  801cfb:	89 fe                	mov    %edi,%esi
  801cfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d01:	89 e9                	mov    %ebp,%ecx
  801d03:	d3 e0                	shl    %cl,%eax
  801d05:	89 d7                	mov    %edx,%edi
  801d07:	89 f1                	mov    %esi,%ecx
  801d09:	d3 ef                	shr    %cl,%edi
  801d0b:	09 c7                	or     %eax,%edi
  801d0d:	89 e9                	mov    %ebp,%ecx
  801d0f:	d3 e2                	shl    %cl,%edx
  801d11:	89 14 24             	mov    %edx,(%esp)
  801d14:	89 d8                	mov    %ebx,%eax
  801d16:	d3 e0                	shl    %cl,%eax
  801d18:	89 c2                	mov    %eax,%edx
  801d1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d1e:	d3 e0                	shl    %cl,%eax
  801d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d24:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d28:	89 f1                	mov    %esi,%ecx
  801d2a:	d3 e8                	shr    %cl,%eax
  801d2c:	09 d0                	or     %edx,%eax
  801d2e:	d3 eb                	shr    %cl,%ebx
  801d30:	89 da                	mov    %ebx,%edx
  801d32:	f7 f7                	div    %edi
  801d34:	89 d3                	mov    %edx,%ebx
  801d36:	f7 24 24             	mull   (%esp)
  801d39:	89 c6                	mov    %eax,%esi
  801d3b:	89 d1                	mov    %edx,%ecx
  801d3d:	39 d3                	cmp    %edx,%ebx
  801d3f:	0f 82 87 00 00 00    	jb     801dcc <__umoddi3+0x134>
  801d45:	0f 84 91 00 00 00    	je     801ddc <__umoddi3+0x144>
  801d4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d4f:	29 f2                	sub    %esi,%edx
  801d51:	19 cb                	sbb    %ecx,%ebx
  801d53:	89 d8                	mov    %ebx,%eax
  801d55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d59:	d3 e0                	shl    %cl,%eax
  801d5b:	89 e9                	mov    %ebp,%ecx
  801d5d:	d3 ea                	shr    %cl,%edx
  801d5f:	09 d0                	or     %edx,%eax
  801d61:	89 e9                	mov    %ebp,%ecx
  801d63:	d3 eb                	shr    %cl,%ebx
  801d65:	89 da                	mov    %ebx,%edx
  801d67:	83 c4 1c             	add    $0x1c,%esp
  801d6a:	5b                   	pop    %ebx
  801d6b:	5e                   	pop    %esi
  801d6c:	5f                   	pop    %edi
  801d6d:	5d                   	pop    %ebp
  801d6e:	c3                   	ret    
  801d6f:	90                   	nop
  801d70:	89 fd                	mov    %edi,%ebp
  801d72:	85 ff                	test   %edi,%edi
  801d74:	75 0b                	jne    801d81 <__umoddi3+0xe9>
  801d76:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7b:	31 d2                	xor    %edx,%edx
  801d7d:	f7 f7                	div    %edi
  801d7f:	89 c5                	mov    %eax,%ebp
  801d81:	89 f0                	mov    %esi,%eax
  801d83:	31 d2                	xor    %edx,%edx
  801d85:	f7 f5                	div    %ebp
  801d87:	89 c8                	mov    %ecx,%eax
  801d89:	f7 f5                	div    %ebp
  801d8b:	89 d0                	mov    %edx,%eax
  801d8d:	e9 44 ff ff ff       	jmp    801cd6 <__umoddi3+0x3e>
  801d92:	66 90                	xchg   %ax,%ax
  801d94:	89 c8                	mov    %ecx,%eax
  801d96:	89 f2                	mov    %esi,%edx
  801d98:	83 c4 1c             	add    $0x1c,%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5f                   	pop    %edi
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    
  801da0:	3b 04 24             	cmp    (%esp),%eax
  801da3:	72 06                	jb     801dab <__umoddi3+0x113>
  801da5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801da9:	77 0f                	ja     801dba <__umoddi3+0x122>
  801dab:	89 f2                	mov    %esi,%edx
  801dad:	29 f9                	sub    %edi,%ecx
  801daf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801db3:	89 14 24             	mov    %edx,(%esp)
  801db6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dba:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dbe:	8b 14 24             	mov    (%esp),%edx
  801dc1:	83 c4 1c             	add    $0x1c,%esp
  801dc4:	5b                   	pop    %ebx
  801dc5:	5e                   	pop    %esi
  801dc6:	5f                   	pop    %edi
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    
  801dc9:	8d 76 00             	lea    0x0(%esi),%esi
  801dcc:	2b 04 24             	sub    (%esp),%eax
  801dcf:	19 fa                	sbb    %edi,%edx
  801dd1:	89 d1                	mov    %edx,%ecx
  801dd3:	89 c6                	mov    %eax,%esi
  801dd5:	e9 71 ff ff ff       	jmp    801d4b <__umoddi3+0xb3>
  801dda:	66 90                	xchg   %ax,%ax
  801ddc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801de0:	72 ea                	jb     801dcc <__umoddi3+0x134>
  801de2:	89 d9                	mov    %ebx,%ecx
  801de4:	e9 62 ff ff ff       	jmp    801d4b <__umoddi3+0xb3>
