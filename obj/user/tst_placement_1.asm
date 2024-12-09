
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
  800042:	e8 26 16 00 00       	call   80166d <sys_calculate_free_frames>
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
  8000e8:	e8 99 19 00 00       	call   801a86 <sys_check_LRU_lists>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(check == 0)
  8000f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8000f7:	75 14                	jne    80010d <_main+0xd5>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 80 1e 80 00       	push   $0x801e80
  800101:	6a 26                	push   $0x26
  800103:	68 02 1f 80 00       	push   $0x801f02
  800108:	e8 e9 03 00 00       	call   8004f6 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010d:	e8 a6 15 00 00       	call   8016b8 <sys_pf_calculate_allocated_pages>
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
  80018f:	68 1c 1f 80 00       	push   $0x801f1c
  800194:	e8 1a 06 00 00       	call   8007b3 <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  80019c:	8a 85 d0 ff ff fe    	mov    -0x1000030(%ebp),%al
  8001a2:	3c 41                	cmp    $0x41,%al
  8001a4:	74 17                	je     8001bd <_main+0x185>
  8001a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 4c 1f 80 00       	push   $0x801f4c
  8001b5:	e8 f9 05 00 00       	call   8007b3 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001bd:	8a 85 d0 0f 00 ff    	mov    -0xfff030(%ebp),%al
  8001c3:	3c 41                	cmp    $0x41,%al
  8001c5:	74 17                	je     8001de <_main+0x1a6>
  8001c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	68 4c 1f 80 00       	push   $0x801f4c
  8001d6:	e8 d8 05 00 00       	call   8007b3 <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001de:	8a 85 d0 ff 3f ff    	mov    -0xc00030(%ebp),%al
  8001e4:	3c 41                	cmp    $0x41,%al
  8001e6:	74 17                	je     8001ff <_main+0x1c7>
  8001e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	68 4c 1f 80 00       	push   $0x801f4c
  8001f7:	e8 b7 05 00 00       	call   8007b3 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001ff:	8a 85 d0 0f 40 ff    	mov    -0xbff030(%ebp),%al
  800205:	3c 41                	cmp    $0x41,%al
  800207:	74 17                	je     800220 <_main+0x1e8>
  800209:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 4c 1f 80 00       	push   $0x801f4c
  800218:	e8 96 05 00 00       	call   8007b3 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800220:	8a 85 d0 ff 7f ff    	mov    -0x800030(%ebp),%al
  800226:	3c 41                	cmp    $0x41,%al
  800228:	74 17                	je     800241 <_main+0x209>
  80022a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	68 4c 1f 80 00       	push   $0x801f4c
  800239:	e8 75 05 00 00       	call   8007b3 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800241:	8a 85 d0 0f 80 ff    	mov    -0x7ff030(%ebp),%al
  800247:	3c 41                	cmp    $0x41,%al
  800249:	74 17                	je     800262 <_main+0x22a>
  80024b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800252:	83 ec 0c             	sub    $0xc,%esp
  800255:	68 4c 1f 80 00       	push   $0x801f4c
  80025a:	e8 54 05 00 00       	call   8007b3 <cprintf>
  80025f:	83 c4 10             	add    $0x10,%esp

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT written to Page File until it's replaced\n"); }
  800262:	e8 51 14 00 00       	call   8016b8 <sys_pf_calculate_allocated_pages>
  800267:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80026a:	74 17                	je     800283 <_main+0x24b>
  80026c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	68 6c 1f 80 00       	push   $0x801f6c
  80027b:	e8 33 05 00 00       	call   8007b3 <cprintf>
  800280:	83 c4 10             	add    $0x10,%esp

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  800283:	c7 45 d8 07 00 00 00 	movl   $0x7,-0x28(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  80028a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80028d:	e8 db 13 00 00       	call   80166d <sys_calculate_free_frames>
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
  8002b1:	68 b4 1f 80 00       	push   $0x801fb4
  8002b6:	e8 f8 04 00 00       	call   8007b3 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 f4 1f 80 00       	push   $0x801ff4
  8002c6:	e8 e8 04 00 00       	call   8007b3 <cprintf>
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
  80033d:	68 28 20 80 00       	push   $0x802028
  800342:	e8 6c 04 00 00       	call   8007b3 <cprintf>
  800347:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 17, 0);
  80034a:	6a 00                	push   $0x0
  80034c:	6a 11                	push   $0x11
  80034e:	8d 85 84 ff ff fe    	lea    -0x100007c(%ebp),%eax
  800354:	50                   	push   %eax
  800355:	8d 85 8c ff ff fe    	lea    -0x1000074(%ebp),%eax
  80035b:	50                   	push   %eax
  80035c:	e8 25 17 00 00       	call   801a86 <sys_check_LRU_lists>
  800361:	83 c4 10             	add    $0x10,%esp
  800364:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if(check == 0)
  800367:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80036b:	75 17                	jne    800384 <_main+0x34c>
				{ is_correct = 0; cprintf("LRU lists entries are not correct, check your logic again!!\n"); }
  80036d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	68 50 20 80 00       	push   $0x802050
  80037c:	e8 32 04 00 00       	call   8007b3 <cprintf>
  800381:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	68 90 20 80 00       	push   $0x802090
  80038c:	e8 22 04 00 00       	call   8007b3 <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  800394:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800398:	74 04                	je     80039e <_main+0x366>
		eval += 50 ;
  80039a:	83 45 f0 32          	addl   $0x32,-0x10(%ebp)

	cprintf("Congratulations!! Test of PAGE PLACEMENT FIRST SCENARIO completed. Eval = %d\n\n\n", eval);
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a4:	68 c8 20 80 00       	push   $0x8020c8
  8003a9:	e8 05 04 00 00       	call   8007b3 <cprintf>
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
  8003bd:	e8 74 14 00 00       	call   801836 <sys_getenvindex>
  8003c2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8003c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c8:	89 d0                	mov    %edx,%eax
  8003ca:	c1 e0 03             	shl    $0x3,%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003d6:	01 c8                	add    %ecx,%eax
  8003d8:	01 c0                	add    %eax,%eax
  8003da:	01 d0                	add    %edx,%eax
  8003dc:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8003e3:	01 c8                	add    %ecx,%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003ec:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003f1:	a1 04 30 80 00       	mov    0x803004,%eax
  8003f6:	8a 40 20             	mov    0x20(%eax),%al
  8003f9:	84 c0                	test   %al,%al
  8003fb:	74 0d                	je     80040a <libmain+0x53>
		binaryname = myEnv->prog_name;
  8003fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800402:	83 c0 20             	add    $0x20,%eax
  800405:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80040a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80040e:	7e 0a                	jle    80041a <libmain+0x63>
		binaryname = argv[0];
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	8b 00                	mov    (%eax),%eax
  800415:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80041a:	83 ec 08             	sub    $0x8,%esp
  80041d:	ff 75 0c             	pushl  0xc(%ebp)
  800420:	ff 75 08             	pushl  0x8(%ebp)
  800423:	e8 10 fc ff ff       	call   800038 <_main>
  800428:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80042b:	e8 8a 11 00 00       	call   8015ba <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800430:	83 ec 0c             	sub    $0xc,%esp
  800433:	68 30 21 80 00       	push   $0x802130
  800438:	e8 76 03 00 00       	call   8007b3 <cprintf>
  80043d:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800440:	a1 04 30 80 00       	mov    0x803004,%eax
  800445:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80044b:	a1 04 30 80 00       	mov    0x803004,%eax
  800450:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800456:	83 ec 04             	sub    $0x4,%esp
  800459:	52                   	push   %edx
  80045a:	50                   	push   %eax
  80045b:	68 58 21 80 00       	push   $0x802158
  800460:	e8 4e 03 00 00       	call   8007b3 <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800468:	a1 04 30 80 00       	mov    0x803004,%eax
  80046d:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800473:	a1 04 30 80 00       	mov    0x803004,%eax
  800478:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80047e:	a1 04 30 80 00       	mov    0x803004,%eax
  800483:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800489:	51                   	push   %ecx
  80048a:	52                   	push   %edx
  80048b:	50                   	push   %eax
  80048c:	68 80 21 80 00       	push   $0x802180
  800491:	e8 1d 03 00 00       	call   8007b3 <cprintf>
  800496:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800499:	a1 04 30 80 00       	mov    0x803004,%eax
  80049e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	50                   	push   %eax
  8004a8:	68 d8 21 80 00       	push   $0x8021d8
  8004ad:	e8 01 03 00 00       	call   8007b3 <cprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8004b5:	83 ec 0c             	sub    $0xc,%esp
  8004b8:	68 30 21 80 00       	push   $0x802130
  8004bd:	e8 f1 02 00 00       	call   8007b3 <cprintf>
  8004c2:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8004c5:	e8 0a 11 00 00       	call   8015d4 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8004ca:	e8 19 00 00 00       	call   8004e8 <exit>
}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004d8:	83 ec 0c             	sub    $0xc,%esp
  8004db:	6a 00                	push   $0x0
  8004dd:	e8 20 13 00 00       	call   801802 <sys_destroy_env>
  8004e2:	83 c4 10             	add    $0x10,%esp
}
  8004e5:	90                   	nop
  8004e6:	c9                   	leave  
  8004e7:	c3                   	ret    

008004e8 <exit>:

void
exit(void)
{
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ee:	e8 75 13 00 00       	call   801868 <sys_exit_env>
}
  8004f3:	90                   	nop
  8004f4:	c9                   	leave  
  8004f5:	c3                   	ret    

008004f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004fc:	8d 45 10             	lea    0x10(%ebp),%eax
  8004ff:	83 c0 04             	add    $0x4,%eax
  800502:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800505:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80050a:	85 c0                	test   %eax,%eax
  80050c:	74 16                	je     800524 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80050e:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800513:	83 ec 08             	sub    $0x8,%esp
  800516:	50                   	push   %eax
  800517:	68 ec 21 80 00       	push   $0x8021ec
  80051c:	e8 92 02 00 00       	call   8007b3 <cprintf>
  800521:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800524:	a1 00 30 80 00       	mov    0x803000,%eax
  800529:	ff 75 0c             	pushl  0xc(%ebp)
  80052c:	ff 75 08             	pushl  0x8(%ebp)
  80052f:	50                   	push   %eax
  800530:	68 f1 21 80 00       	push   $0x8021f1
  800535:	e8 79 02 00 00       	call   8007b3 <cprintf>
  80053a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80053d:	8b 45 10             	mov    0x10(%ebp),%eax
  800540:	83 ec 08             	sub    $0x8,%esp
  800543:	ff 75 f4             	pushl  -0xc(%ebp)
  800546:	50                   	push   %eax
  800547:	e8 fc 01 00 00       	call   800748 <vcprintf>
  80054c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80054f:	83 ec 08             	sub    $0x8,%esp
  800552:	6a 00                	push   $0x0
  800554:	68 0d 22 80 00       	push   $0x80220d
  800559:	e8 ea 01 00 00       	call   800748 <vcprintf>
  80055e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800561:	e8 82 ff ff ff       	call   8004e8 <exit>

	// should not return here
	while (1) ;
  800566:	eb fe                	jmp    800566 <_panic+0x70>

00800568 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800568:	55                   	push   %ebp
  800569:	89 e5                	mov    %esp,%ebp
  80056b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80056e:	a1 04 30 80 00       	mov    0x803004,%eax
  800573:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057c:	39 c2                	cmp    %eax,%edx
  80057e:	74 14                	je     800594 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 10 22 80 00       	push   $0x802210
  800588:	6a 26                	push   $0x26
  80058a:	68 5c 22 80 00       	push   $0x80225c
  80058f:	e8 62 ff ff ff       	call   8004f6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80059b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005a2:	e9 c5 00 00 00       	jmp    80066c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	85 c0                	test   %eax,%eax
  8005ba:	75 08                	jne    8005c4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005bc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005bf:	e9 a5 00 00 00       	jmp    800669 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d2:	eb 69                	jmp    80063d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005d4:	a1 04 30 80 00       	mov    0x803004,%eax
  8005d9:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8005df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005e2:	89 d0                	mov    %edx,%eax
  8005e4:	01 c0                	add    %eax,%eax
  8005e6:	01 d0                	add    %edx,%eax
  8005e8:	c1 e0 03             	shl    $0x3,%eax
  8005eb:	01 c8                	add    %ecx,%eax
  8005ed:	8a 40 04             	mov    0x4(%eax),%al
  8005f0:	84 c0                	test   %al,%al
  8005f2:	75 46                	jne    80063a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005f4:	a1 04 30 80 00       	mov    0x803004,%eax
  8005f9:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8005ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800602:	89 d0                	mov    %edx,%eax
  800604:	01 c0                	add    %eax,%eax
  800606:	01 d0                	add    %edx,%eax
  800608:	c1 e0 03             	shl    $0x3,%eax
  80060b:	01 c8                	add    %ecx,%eax
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800612:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800615:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80061a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80061c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800626:	8b 45 08             	mov    0x8(%ebp),%eax
  800629:	01 c8                	add    %ecx,%eax
  80062b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80062d:	39 c2                	cmp    %eax,%edx
  80062f:	75 09                	jne    80063a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800631:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800638:	eb 15                	jmp    80064f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063a:	ff 45 e8             	incl   -0x18(%ebp)
  80063d:	a1 04 30 80 00       	mov    0x803004,%eax
  800642:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800648:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80064b:	39 c2                	cmp    %eax,%edx
  80064d:	77 85                	ja     8005d4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80064f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800653:	75 14                	jne    800669 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800655:	83 ec 04             	sub    $0x4,%esp
  800658:	68 68 22 80 00       	push   $0x802268
  80065d:	6a 3a                	push   $0x3a
  80065f:	68 5c 22 80 00       	push   $0x80225c
  800664:	e8 8d fe ff ff       	call   8004f6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800669:	ff 45 f0             	incl   -0x10(%ebp)
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800672:	0f 8c 2f ff ff ff    	jl     8005a7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800678:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80067f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800686:	eb 26                	jmp    8006ae <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800688:	a1 04 30 80 00       	mov    0x803004,%eax
  80068d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800693:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800696:	89 d0                	mov    %edx,%eax
  800698:	01 c0                	add    %eax,%eax
  80069a:	01 d0                	add    %edx,%eax
  80069c:	c1 e0 03             	shl    $0x3,%eax
  80069f:	01 c8                	add    %ecx,%eax
  8006a1:	8a 40 04             	mov    0x4(%eax),%al
  8006a4:	3c 01                	cmp    $0x1,%al
  8006a6:	75 03                	jne    8006ab <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006a8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006ab:	ff 45 e0             	incl   -0x20(%ebp)
  8006ae:	a1 04 30 80 00       	mov    0x803004,%eax
  8006b3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006bc:	39 c2                	cmp    %eax,%edx
  8006be:	77 c8                	ja     800688 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006c6:	74 14                	je     8006dc <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006c8:	83 ec 04             	sub    $0x4,%esp
  8006cb:	68 bc 22 80 00       	push   $0x8022bc
  8006d0:	6a 44                	push   $0x44
  8006d2:	68 5c 22 80 00       	push   $0x80225c
  8006d7:	e8 1a fe ff ff       	call   8004f6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006dc:	90                   	nop
  8006dd:	c9                   	leave  
  8006de:	c3                   	ret    

008006df <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006df:	55                   	push   %ebp
  8006e0:	89 e5                	mov    %esp,%ebp
  8006e2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 48 01             	lea    0x1(%eax),%ecx
  8006ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f0:	89 0a                	mov    %ecx,(%edx)
  8006f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8006f5:	88 d1                	mov    %dl,%cl
  8006f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006fa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	3d ff 00 00 00       	cmp    $0xff,%eax
  800708:	75 2c                	jne    800736 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80070a:	a0 08 30 80 00       	mov    0x803008,%al
  80070f:	0f b6 c0             	movzbl %al,%eax
  800712:	8b 55 0c             	mov    0xc(%ebp),%edx
  800715:	8b 12                	mov    (%edx),%edx
  800717:	89 d1                	mov    %edx,%ecx
  800719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80071c:	83 c2 08             	add    $0x8,%edx
  80071f:	83 ec 04             	sub    $0x4,%esp
  800722:	50                   	push   %eax
  800723:	51                   	push   %ecx
  800724:	52                   	push   %edx
  800725:	e8 4e 0e 00 00       	call   801578 <sys_cputs>
  80072a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80072d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800736:	8b 45 0c             	mov    0xc(%ebp),%eax
  800739:	8b 40 04             	mov    0x4(%eax),%eax
  80073c:	8d 50 01             	lea    0x1(%eax),%edx
  80073f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800742:	89 50 04             	mov    %edx,0x4(%eax)
}
  800745:	90                   	nop
  800746:	c9                   	leave  
  800747:	c3                   	ret    

00800748 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800751:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800758:	00 00 00 
	b.cnt = 0;
  80075b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800762:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800765:	ff 75 0c             	pushl  0xc(%ebp)
  800768:	ff 75 08             	pushl  0x8(%ebp)
  80076b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800771:	50                   	push   %eax
  800772:	68 df 06 80 00       	push   $0x8006df
  800777:	e8 11 02 00 00       	call   80098d <vprintfmt>
  80077c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80077f:	a0 08 30 80 00       	mov    0x803008,%al
  800784:	0f b6 c0             	movzbl %al,%eax
  800787:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80078d:	83 ec 04             	sub    $0x4,%esp
  800790:	50                   	push   %eax
  800791:	52                   	push   %edx
  800792:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800798:	83 c0 08             	add    $0x8,%eax
  80079b:	50                   	push   %eax
  80079c:	e8 d7 0d 00 00       	call   801578 <sys_cputs>
  8007a1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007a4:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8007ab:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007b1:	c9                   	leave  
  8007b2:	c3                   	ret    

008007b3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007b3:	55                   	push   %ebp
  8007b4:	89 e5                	mov    %esp,%ebp
  8007b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007b9:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8007c0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cf:	50                   	push   %eax
  8007d0:	e8 73 ff ff ff       	call   800748 <vcprintf>
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007de:	c9                   	leave  
  8007df:	c3                   	ret    

008007e0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007e6:	e8 cf 0d 00 00       	call   8015ba <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007eb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8007fa:	50                   	push   %eax
  8007fb:	e8 48 ff ff ff       	call   800748 <vcprintf>
  800800:	83 c4 10             	add    $0x10,%esp
  800803:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800806:	e8 c9 0d 00 00       	call   8015d4 <sys_unlock_cons>
	return cnt;
  80080b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080e:	c9                   	leave  
  80080f:	c3                   	ret    

00800810 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800810:	55                   	push   %ebp
  800811:	89 e5                	mov    %esp,%ebp
  800813:	53                   	push   %ebx
  800814:	83 ec 14             	sub    $0x14,%esp
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800823:	8b 45 18             	mov    0x18(%ebp),%eax
  800826:	ba 00 00 00 00       	mov    $0x0,%edx
  80082b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082e:	77 55                	ja     800885 <printnum+0x75>
  800830:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800833:	72 05                	jb     80083a <printnum+0x2a>
  800835:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800838:	77 4b                	ja     800885 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80083a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80083d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800840:	8b 45 18             	mov    0x18(%ebp),%eax
  800843:	ba 00 00 00 00       	mov    $0x0,%edx
  800848:	52                   	push   %edx
  800849:	50                   	push   %eax
  80084a:	ff 75 f4             	pushl  -0xc(%ebp)
  80084d:	ff 75 f0             	pushl  -0x10(%ebp)
  800850:	e8 bf 13 00 00       	call   801c14 <__udivdi3>
  800855:	83 c4 10             	add    $0x10,%esp
  800858:	83 ec 04             	sub    $0x4,%esp
  80085b:	ff 75 20             	pushl  0x20(%ebp)
  80085e:	53                   	push   %ebx
  80085f:	ff 75 18             	pushl  0x18(%ebp)
  800862:	52                   	push   %edx
  800863:	50                   	push   %eax
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	ff 75 08             	pushl  0x8(%ebp)
  80086a:	e8 a1 ff ff ff       	call   800810 <printnum>
  80086f:	83 c4 20             	add    $0x20,%esp
  800872:	eb 1a                	jmp    80088e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	ff 75 20             	pushl  0x20(%ebp)
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	ff d0                	call   *%eax
  800882:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800885:	ff 4d 1c             	decl   0x1c(%ebp)
  800888:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80088c:	7f e6                	jg     800874 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80088e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800891:	bb 00 00 00 00       	mov    $0x0,%ebx
  800896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800899:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089c:	53                   	push   %ebx
  80089d:	51                   	push   %ecx
  80089e:	52                   	push   %edx
  80089f:	50                   	push   %eax
  8008a0:	e8 7f 14 00 00       	call   801d24 <__umoddi3>
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	05 34 25 80 00       	add    $0x802534,%eax
  8008ad:	8a 00                	mov    (%eax),%al
  8008af:	0f be c0             	movsbl %al,%eax
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	50                   	push   %eax
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	ff d0                	call   *%eax
  8008be:	83 c4 10             	add    $0x10,%esp
}
  8008c1:	90                   	nop
  8008c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c5:	c9                   	leave  
  8008c6:	c3                   	ret    

008008c7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ca:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ce:	7e 1c                	jle    8008ec <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	8d 50 08             	lea    0x8(%eax),%edx
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	89 10                	mov    %edx,(%eax)
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	83 e8 08             	sub    $0x8,%eax
  8008e5:	8b 50 04             	mov    0x4(%eax),%edx
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	eb 40                	jmp    80092c <getuint+0x65>
	else if (lflag)
  8008ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f0:	74 1e                	je     800910 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	8d 50 04             	lea    0x4(%eax),%edx
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	89 10                	mov    %edx,(%eax)
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 00                	mov    (%eax),%eax
  800904:	83 e8 04             	sub    $0x4,%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	ba 00 00 00 00       	mov    $0x0,%edx
  80090e:	eb 1c                	jmp    80092c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	8d 50 04             	lea    0x4(%eax),%edx
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	89 10                	mov    %edx,(%eax)
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	83 e8 04             	sub    $0x4,%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80092c:	5d                   	pop    %ebp
  80092d:	c3                   	ret    

0080092e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800931:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800935:	7e 1c                	jle    800953 <getint+0x25>
		return va_arg(*ap, long long);
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	8d 50 08             	lea    0x8(%eax),%edx
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	89 10                	mov    %edx,(%eax)
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	83 e8 08             	sub    $0x8,%eax
  80094c:	8b 50 04             	mov    0x4(%eax),%edx
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	eb 38                	jmp    80098b <getint+0x5d>
	else if (lflag)
  800953:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800957:	74 1a                	je     800973 <getint+0x45>
		return va_arg(*ap, long);
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	8d 50 04             	lea    0x4(%eax),%edx
  800961:	8b 45 08             	mov    0x8(%ebp),%eax
  800964:	89 10                	mov    %edx,(%eax)
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	83 e8 04             	sub    $0x4,%eax
  80096e:	8b 00                	mov    (%eax),%eax
  800970:	99                   	cltd   
  800971:	eb 18                	jmp    80098b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	8d 50 04             	lea    0x4(%eax),%edx
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	89 10                	mov    %edx,(%eax)
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	83 e8 04             	sub    $0x4,%eax
  800988:	8b 00                	mov    (%eax),%eax
  80098a:	99                   	cltd   
}
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	56                   	push   %esi
  800991:	53                   	push   %ebx
  800992:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800995:	eb 17                	jmp    8009ae <vprintfmt+0x21>
			if (ch == '\0')
  800997:	85 db                	test   %ebx,%ebx
  800999:	0f 84 c1 03 00 00    	je     800d60 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80099f:	83 ec 08             	sub    $0x8,%esp
  8009a2:	ff 75 0c             	pushl  0xc(%ebp)
  8009a5:	53                   	push   %ebx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	ff d0                	call   *%eax
  8009ab:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b1:	8d 50 01             	lea    0x1(%eax),%edx
  8009b4:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b7:	8a 00                	mov    (%eax),%al
  8009b9:	0f b6 d8             	movzbl %al,%ebx
  8009bc:	83 fb 25             	cmp    $0x25,%ebx
  8009bf:	75 d6                	jne    800997 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009c1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009c5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e4:	8d 50 01             	lea    0x1(%eax),%edx
  8009e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	0f b6 d8             	movzbl %al,%ebx
  8009ef:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009f2:	83 f8 5b             	cmp    $0x5b,%eax
  8009f5:	0f 87 3d 03 00 00    	ja     800d38 <vprintfmt+0x3ab>
  8009fb:	8b 04 85 58 25 80 00 	mov    0x802558(,%eax,4),%eax
  800a02:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a04:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a08:	eb d7                	jmp    8009e1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a0a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a0e:	eb d1                	jmp    8009e1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a10:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a17:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a1a:	89 d0                	mov    %edx,%eax
  800a1c:	c1 e0 02             	shl    $0x2,%eax
  800a1f:	01 d0                	add    %edx,%eax
  800a21:	01 c0                	add    %eax,%eax
  800a23:	01 d8                	add    %ebx,%eax
  800a25:	83 e8 30             	sub    $0x30,%eax
  800a28:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2e:	8a 00                	mov    (%eax),%al
  800a30:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a33:	83 fb 2f             	cmp    $0x2f,%ebx
  800a36:	7e 3e                	jle    800a76 <vprintfmt+0xe9>
  800a38:	83 fb 39             	cmp    $0x39,%ebx
  800a3b:	7f 39                	jg     800a76 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a3d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a40:	eb d5                	jmp    800a17 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a42:	8b 45 14             	mov    0x14(%ebp),%eax
  800a45:	83 c0 04             	add    $0x4,%eax
  800a48:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4e:	83 e8 04             	sub    $0x4,%eax
  800a51:	8b 00                	mov    (%eax),%eax
  800a53:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a56:	eb 1f                	jmp    800a77 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5c:	79 83                	jns    8009e1 <vprintfmt+0x54>
				width = 0;
  800a5e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a65:	e9 77 ff ff ff       	jmp    8009e1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a6a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a71:	e9 6b ff ff ff       	jmp    8009e1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a76:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7b:	0f 89 60 ff ff ff    	jns    8009e1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a87:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a8e:	e9 4e ff ff ff       	jmp    8009e1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a93:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a96:	e9 46 ff ff ff       	jmp    8009e1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9e:	83 c0 04             	add    $0x4,%eax
  800aa1:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa4:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa7:	83 e8 04             	sub    $0x4,%eax
  800aaa:	8b 00                	mov    (%eax),%eax
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	50                   	push   %eax
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	ff d0                	call   *%eax
  800ab8:	83 c4 10             	add    $0x10,%esp
			break;
  800abb:	e9 9b 02 00 00       	jmp    800d5b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	83 c0 04             	add    $0x4,%eax
  800ac6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac9:	8b 45 14             	mov    0x14(%ebp),%eax
  800acc:	83 e8 04             	sub    $0x4,%eax
  800acf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ad1:	85 db                	test   %ebx,%ebx
  800ad3:	79 02                	jns    800ad7 <vprintfmt+0x14a>
				err = -err;
  800ad5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ad7:	83 fb 64             	cmp    $0x64,%ebx
  800ada:	7f 0b                	jg     800ae7 <vprintfmt+0x15a>
  800adc:	8b 34 9d a0 23 80 00 	mov    0x8023a0(,%ebx,4),%esi
  800ae3:	85 f6                	test   %esi,%esi
  800ae5:	75 19                	jne    800b00 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ae7:	53                   	push   %ebx
  800ae8:	68 45 25 80 00       	push   $0x802545
  800aed:	ff 75 0c             	pushl  0xc(%ebp)
  800af0:	ff 75 08             	pushl  0x8(%ebp)
  800af3:	e8 70 02 00 00       	call   800d68 <printfmt>
  800af8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800afb:	e9 5b 02 00 00       	jmp    800d5b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b00:	56                   	push   %esi
  800b01:	68 4e 25 80 00       	push   $0x80254e
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	ff 75 08             	pushl  0x8(%ebp)
  800b0c:	e8 57 02 00 00       	call   800d68 <printfmt>
  800b11:	83 c4 10             	add    $0x10,%esp
			break;
  800b14:	e9 42 02 00 00       	jmp    800d5b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b19:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1c:	83 c0 04             	add    $0x4,%eax
  800b1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b22:	8b 45 14             	mov    0x14(%ebp),%eax
  800b25:	83 e8 04             	sub    $0x4,%eax
  800b28:	8b 30                	mov    (%eax),%esi
  800b2a:	85 f6                	test   %esi,%esi
  800b2c:	75 05                	jne    800b33 <vprintfmt+0x1a6>
				p = "(null)";
  800b2e:	be 51 25 80 00       	mov    $0x802551,%esi
			if (width > 0 && padc != '-')
  800b33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b37:	7e 6d                	jle    800ba6 <vprintfmt+0x219>
  800b39:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b3d:	74 67                	je     800ba6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b42:	83 ec 08             	sub    $0x8,%esp
  800b45:	50                   	push   %eax
  800b46:	56                   	push   %esi
  800b47:	e8 1e 03 00 00       	call   800e6a <strnlen>
  800b4c:	83 c4 10             	add    $0x10,%esp
  800b4f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b52:	eb 16                	jmp    800b6a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b54:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	50                   	push   %eax
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	ff d0                	call   *%eax
  800b64:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b67:	ff 4d e4             	decl   -0x1c(%ebp)
  800b6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6e:	7f e4                	jg     800b54 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b70:	eb 34                	jmp    800ba6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b72:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b76:	74 1c                	je     800b94 <vprintfmt+0x207>
  800b78:	83 fb 1f             	cmp    $0x1f,%ebx
  800b7b:	7e 05                	jle    800b82 <vprintfmt+0x1f5>
  800b7d:	83 fb 7e             	cmp    $0x7e,%ebx
  800b80:	7e 12                	jle    800b94 <vprintfmt+0x207>
					putch('?', putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	6a 3f                	push   $0x3f
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	ff d0                	call   *%eax
  800b8f:	83 c4 10             	add    $0x10,%esp
  800b92:	eb 0f                	jmp    800ba3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	53                   	push   %ebx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	ff d0                	call   *%eax
  800ba0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba3:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba6:	89 f0                	mov    %esi,%eax
  800ba8:	8d 70 01             	lea    0x1(%eax),%esi
  800bab:	8a 00                	mov    (%eax),%al
  800bad:	0f be d8             	movsbl %al,%ebx
  800bb0:	85 db                	test   %ebx,%ebx
  800bb2:	74 24                	je     800bd8 <vprintfmt+0x24b>
  800bb4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb8:	78 b8                	js     800b72 <vprintfmt+0x1e5>
  800bba:	ff 4d e0             	decl   -0x20(%ebp)
  800bbd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bc1:	79 af                	jns    800b72 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc3:	eb 13                	jmp    800bd8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bc5:	83 ec 08             	sub    $0x8,%esp
  800bc8:	ff 75 0c             	pushl  0xc(%ebp)
  800bcb:	6a 20                	push   $0x20
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ff d0                	call   *%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd5:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bdc:	7f e7                	jg     800bc5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bde:	e9 78 01 00 00       	jmp    800d5b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800be3:	83 ec 08             	sub    $0x8,%esp
  800be6:	ff 75 e8             	pushl  -0x18(%ebp)
  800be9:	8d 45 14             	lea    0x14(%ebp),%eax
  800bec:	50                   	push   %eax
  800bed:	e8 3c fd ff ff       	call   80092e <getint>
  800bf2:	83 c4 10             	add    $0x10,%esp
  800bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c01:	85 d2                	test   %edx,%edx
  800c03:	79 23                	jns    800c28 <vprintfmt+0x29b>
				putch('-', putdat);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	6a 2d                	push   $0x2d
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	ff d0                	call   *%eax
  800c12:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1b:	f7 d8                	neg    %eax
  800c1d:	83 d2 00             	adc    $0x0,%edx
  800c20:	f7 da                	neg    %edx
  800c22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c25:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c28:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2f:	e9 bc 00 00 00       	jmp    800cf0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 e8             	pushl  -0x18(%ebp)
  800c3a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3d:	50                   	push   %eax
  800c3e:	e8 84 fc ff ff       	call   8008c7 <getuint>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c49:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c4c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c53:	e9 98 00 00 00       	jmp    800cf0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	ff 75 0c             	pushl  0xc(%ebp)
  800c5e:	6a 58                	push   $0x58
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	ff d0                	call   *%eax
  800c65:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c68:	83 ec 08             	sub    $0x8,%esp
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	6a 58                	push   $0x58
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	ff d0                	call   *%eax
  800c75:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c78:	83 ec 08             	sub    $0x8,%esp
  800c7b:	ff 75 0c             	pushl  0xc(%ebp)
  800c7e:	6a 58                	push   $0x58
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	ff d0                	call   *%eax
  800c85:	83 c4 10             	add    $0x10,%esp
			break;
  800c88:	e9 ce 00 00 00       	jmp    800d5b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c8d:	83 ec 08             	sub    $0x8,%esp
  800c90:	ff 75 0c             	pushl  0xc(%ebp)
  800c93:	6a 30                	push   $0x30
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	ff d0                	call   *%eax
  800c9a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	ff 75 0c             	pushl  0xc(%ebp)
  800ca3:	6a 78                	push   $0x78
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	ff d0                	call   *%eax
  800caa:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cad:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb0:	83 c0 04             	add    $0x4,%eax
  800cb3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb9:	83 e8 04             	sub    $0x4,%eax
  800cbc:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cc8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ccf:	eb 1f                	jmp    800cf0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd7:	8d 45 14             	lea    0x14(%ebp),%eax
  800cda:	50                   	push   %eax
  800cdb:	e8 e7 fb ff ff       	call   8008c7 <getuint>
  800ce0:	83 c4 10             	add    $0x10,%esp
  800ce3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cf0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf7:	83 ec 04             	sub    $0x4,%esp
  800cfa:	52                   	push   %edx
  800cfb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cfe:	50                   	push   %eax
  800cff:	ff 75 f4             	pushl  -0xc(%ebp)
  800d02:	ff 75 f0             	pushl  -0x10(%ebp)
  800d05:	ff 75 0c             	pushl  0xc(%ebp)
  800d08:	ff 75 08             	pushl  0x8(%ebp)
  800d0b:	e8 00 fb ff ff       	call   800810 <printnum>
  800d10:	83 c4 20             	add    $0x20,%esp
			break;
  800d13:	eb 46                	jmp    800d5b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d15:	83 ec 08             	sub    $0x8,%esp
  800d18:	ff 75 0c             	pushl  0xc(%ebp)
  800d1b:	53                   	push   %ebx
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	ff d0                	call   *%eax
  800d21:	83 c4 10             	add    $0x10,%esp
			break;
  800d24:	eb 35                	jmp    800d5b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d26:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800d2d:	eb 2c                	jmp    800d5b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d2f:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800d36:	eb 23                	jmp    800d5b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d38:	83 ec 08             	sub    $0x8,%esp
  800d3b:	ff 75 0c             	pushl  0xc(%ebp)
  800d3e:	6a 25                	push   $0x25
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	ff d0                	call   *%eax
  800d45:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d48:	ff 4d 10             	decl   0x10(%ebp)
  800d4b:	eb 03                	jmp    800d50 <vprintfmt+0x3c3>
  800d4d:	ff 4d 10             	decl   0x10(%ebp)
  800d50:	8b 45 10             	mov    0x10(%ebp),%eax
  800d53:	48                   	dec    %eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	3c 25                	cmp    $0x25,%al
  800d58:	75 f3                	jne    800d4d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d5a:	90                   	nop
		}
	}
  800d5b:	e9 35 fc ff ff       	jmp    800995 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d60:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5d                   	pop    %ebp
  800d67:	c3                   	ret    

00800d68 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d6e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d71:	83 c0 04             	add    $0x4,%eax
  800d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d77:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7d:	50                   	push   %eax
  800d7e:	ff 75 0c             	pushl  0xc(%ebp)
  800d81:	ff 75 08             	pushl  0x8(%ebp)
  800d84:	e8 04 fc ff ff       	call   80098d <vprintfmt>
  800d89:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d8c:	90                   	nop
  800d8d:	c9                   	leave  
  800d8e:	c3                   	ret    

00800d8f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8b 40 08             	mov    0x8(%eax),%eax
  800d98:	8d 50 01             	lea    0x1(%eax),%edx
  800d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	8b 10                	mov    (%eax),%edx
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	8b 40 04             	mov    0x4(%eax),%eax
  800dac:	39 c2                	cmp    %eax,%edx
  800dae:	73 12                	jae    800dc2 <sprintputch+0x33>
		*b->buf++ = ch;
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	8b 00                	mov    (%eax),%eax
  800db5:	8d 48 01             	lea    0x1(%eax),%ecx
  800db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbb:	89 0a                	mov    %ecx,(%edx)
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	88 10                	mov    %dl,(%eax)
}
  800dc2:	90                   	nop
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    

00800dc5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	01 d0                	add    %edx,%eax
  800ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800de6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dea:	74 06                	je     800df2 <vsnprintf+0x2d>
  800dec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df0:	7f 07                	jg     800df9 <vsnprintf+0x34>
		return -E_INVAL;
  800df2:	b8 03 00 00 00       	mov    $0x3,%eax
  800df7:	eb 20                	jmp    800e19 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800df9:	ff 75 14             	pushl  0x14(%ebp)
  800dfc:	ff 75 10             	pushl  0x10(%ebp)
  800dff:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e02:	50                   	push   %eax
  800e03:	68 8f 0d 80 00       	push   $0x800d8f
  800e08:	e8 80 fb ff ff       	call   80098d <vprintfmt>
  800e0d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e13:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e19:	c9                   	leave  
  800e1a:	c3                   	ret    

00800e1b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e21:	8d 45 10             	lea    0x10(%ebp),%eax
  800e24:	83 c0 04             	add    $0x4,%eax
  800e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800e30:	50                   	push   %eax
  800e31:	ff 75 0c             	pushl  0xc(%ebp)
  800e34:	ff 75 08             	pushl  0x8(%ebp)
  800e37:	e8 89 ff ff ff       	call   800dc5 <vsnprintf>
  800e3c:	83 c4 10             	add    $0x10,%esp
  800e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e45:	c9                   	leave  
  800e46:	c3                   	ret    

00800e47 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e54:	eb 06                	jmp    800e5c <strlen+0x15>
		n++;
  800e56:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e59:	ff 45 08             	incl   0x8(%ebp)
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	84 c0                	test   %al,%al
  800e63:	75 f1                	jne    800e56 <strlen+0xf>
		n++;
	return n;
  800e65:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e68:	c9                   	leave  
  800e69:	c3                   	ret    

00800e6a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e77:	eb 09                	jmp    800e82 <strnlen+0x18>
		n++;
  800e79:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e7c:	ff 45 08             	incl   0x8(%ebp)
  800e7f:	ff 4d 0c             	decl   0xc(%ebp)
  800e82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e86:	74 09                	je     800e91 <strnlen+0x27>
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	84 c0                	test   %al,%al
  800e8f:	75 e8                	jne    800e79 <strnlen+0xf>
		n++;
	return n;
  800e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e94:	c9                   	leave  
  800e95:	c3                   	ret    

00800e96 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ea2:	90                   	nop
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8d 50 01             	lea    0x1(%eax),%edx
  800ea9:	89 55 08             	mov    %edx,0x8(%ebp)
  800eac:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb5:	8a 12                	mov    (%edx),%dl
  800eb7:	88 10                	mov    %dl,(%eax)
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	84 c0                	test   %al,%al
  800ebd:	75 e4                	jne    800ea3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ebf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ec2:	c9                   	leave  
  800ec3:	c3                   	ret    

00800ec4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ed0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed7:	eb 1f                	jmp    800ef8 <strncpy+0x34>
		*dst++ = *src;
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8d 50 01             	lea    0x1(%eax),%edx
  800edf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee5:	8a 12                	mov    (%edx),%dl
  800ee7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	84 c0                	test   %al,%al
  800ef0:	74 03                	je     800ef5 <strncpy+0x31>
			src++;
  800ef2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ef5:	ff 45 fc             	incl   -0x4(%ebp)
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800efe:	72 d9                	jb     800ed9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f00:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f03:	c9                   	leave  
  800f04:	c3                   	ret    

00800f05 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f15:	74 30                	je     800f47 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f17:	eb 16                	jmp    800f2f <strlcpy+0x2a>
			*dst++ = *src++;
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8d 50 01             	lea    0x1(%eax),%edx
  800f1f:	89 55 08             	mov    %edx,0x8(%ebp)
  800f22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f28:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f2b:	8a 12                	mov    (%edx),%dl
  800f2d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f2f:	ff 4d 10             	decl   0x10(%ebp)
  800f32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f36:	74 09                	je     800f41 <strlcpy+0x3c>
  800f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	84 c0                	test   %al,%al
  800f3f:	75 d8                	jne    800f19 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f47:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4d:	29 c2                	sub    %eax,%edx
  800f4f:	89 d0                	mov    %edx,%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f56:	eb 06                	jmp    800f5e <strcmp+0xb>
		p++, q++;
  800f58:	ff 45 08             	incl   0x8(%ebp)
  800f5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	84 c0                	test   %al,%al
  800f65:	74 0e                	je     800f75 <strcmp+0x22>
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 10                	mov    (%eax),%dl
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	38 c2                	cmp    %al,%dl
  800f73:	74 e3                	je     800f58 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	0f b6 d0             	movzbl %al,%edx
  800f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	0f b6 c0             	movzbl %al,%eax
  800f85:	29 c2                	sub    %eax,%edx
  800f87:	89 d0                	mov    %edx,%eax
}
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    

00800f8b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f8e:	eb 09                	jmp    800f99 <strncmp+0xe>
		n--, p++, q++;
  800f90:	ff 4d 10             	decl   0x10(%ebp)
  800f93:	ff 45 08             	incl   0x8(%ebp)
  800f96:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9d:	74 17                	je     800fb6 <strncmp+0x2b>
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	84 c0                	test   %al,%al
  800fa6:	74 0e                	je     800fb6 <strncmp+0x2b>
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 10                	mov    (%eax),%dl
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	38 c2                	cmp    %al,%dl
  800fb4:	74 da                	je     800f90 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fba:	75 07                	jne    800fc3 <strncmp+0x38>
		return 0;
  800fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc1:	eb 14                	jmp    800fd7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	0f b6 d0             	movzbl %al,%edx
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	0f b6 c0             	movzbl %al,%eax
  800fd3:	29 c2                	sub    %eax,%edx
  800fd5:	89 d0                	mov    %edx,%eax
}
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe5:	eb 12                	jmp    800ff9 <strchr+0x20>
		if (*s == c)
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fef:	75 05                	jne    800ff6 <strchr+0x1d>
			return (char *) s;
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	eb 11                	jmp    801007 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	84 c0                	test   %al,%al
  801000:	75 e5                	jne    800fe7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801002:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801007:	c9                   	leave  
  801008:	c3                   	ret    

00801009 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 04             	sub    $0x4,%esp
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801015:	eb 0d                	jmp    801024 <strfind+0x1b>
		if (*s == c)
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80101f:	74 0e                	je     80102f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801021:	ff 45 08             	incl   0x8(%ebp)
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	84 c0                	test   %al,%al
  80102b:	75 ea                	jne    801017 <strfind+0xe>
  80102d:	eb 01                	jmp    801030 <strfind+0x27>
		if (*s == c)
			break;
  80102f:	90                   	nop
	return (char *) s;
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801033:	c9                   	leave  
  801034:	c3                   	ret    

00801035 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801041:	8b 45 10             	mov    0x10(%ebp),%eax
  801044:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801047:	eb 0e                	jmp    801057 <memset+0x22>
		*p++ = c;
  801049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104c:	8d 50 01             	lea    0x1(%eax),%edx
  80104f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801052:	8b 55 0c             	mov    0xc(%ebp),%edx
  801055:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801057:	ff 4d f8             	decl   -0x8(%ebp)
  80105a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80105e:	79 e9                	jns    801049 <memset+0x14>
		*p++ = c;

	return v;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801077:	eb 16                	jmp    80108f <memcpy+0x2a>
		*d++ = *s++;
  801079:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107c:	8d 50 01             	lea    0x1(%eax),%edx
  80107f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801082:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801085:	8d 4a 01             	lea    0x1(%edx),%ecx
  801088:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80108b:	8a 12                	mov    (%edx),%dl
  80108d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80108f:	8b 45 10             	mov    0x10(%ebp),%eax
  801092:	8d 50 ff             	lea    -0x1(%eax),%edx
  801095:	89 55 10             	mov    %edx,0x10(%ebp)
  801098:	85 c0                	test   %eax,%eax
  80109a:	75 dd                	jne    801079 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80109c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010b9:	73 50                	jae    80110b <memmove+0x6a>
  8010bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010be:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c1:	01 d0                	add    %edx,%eax
  8010c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010c6:	76 43                	jbe    80110b <memmove+0x6a>
		s += n;
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010d4:	eb 10                	jmp    8010e6 <memmove+0x45>
			*--d = *--s;
  8010d6:	ff 4d f8             	decl   -0x8(%ebp)
  8010d9:	ff 4d fc             	decl   -0x4(%ebp)
  8010dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010df:	8a 10                	mov    (%eax),%dl
  8010e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ec:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	75 e3                	jne    8010d6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010f3:	eb 23                	jmp    801118 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f8:	8d 50 01             	lea    0x1(%eax),%edx
  8010fb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801101:	8d 4a 01             	lea    0x1(%edx),%ecx
  801104:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801107:	8a 12                	mov    (%edx),%dl
  801109:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801111:	89 55 10             	mov    %edx,0x10(%ebp)
  801114:	85 c0                	test   %eax,%eax
  801116:	75 dd                	jne    8010f5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111b:	c9                   	leave  
  80111c:	c3                   	ret    

0080111d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80112f:	eb 2a                	jmp    80115b <memcmp+0x3e>
		if (*s1 != *s2)
  801131:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801134:	8a 10                	mov    (%eax),%dl
  801136:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801139:	8a 00                	mov    (%eax),%al
  80113b:	38 c2                	cmp    %al,%dl
  80113d:	74 16                	je     801155 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80113f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	0f b6 d0             	movzbl %al,%edx
  801147:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 c0             	movzbl %al,%eax
  80114f:	29 c2                	sub    %eax,%edx
  801151:	89 d0                	mov    %edx,%eax
  801153:	eb 18                	jmp    80116d <memcmp+0x50>
		s1++, s2++;
  801155:	ff 45 fc             	incl   -0x4(%ebp)
  801158:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80115b:	8b 45 10             	mov    0x10(%ebp),%eax
  80115e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801161:	89 55 10             	mov    %edx,0x10(%ebp)
  801164:	85 c0                	test   %eax,%eax
  801166:	75 c9                	jne    801131 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801168:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801175:	8b 55 08             	mov    0x8(%ebp),%edx
  801178:	8b 45 10             	mov    0x10(%ebp),%eax
  80117b:	01 d0                	add    %edx,%eax
  80117d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801180:	eb 15                	jmp    801197 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 d0             	movzbl %al,%edx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	0f b6 c0             	movzbl %al,%eax
  801190:	39 c2                	cmp    %eax,%edx
  801192:	74 0d                	je     8011a1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801194:	ff 45 08             	incl   0x8(%ebp)
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80119d:	72 e3                	jb     801182 <memfind+0x13>
  80119f:	eb 01                	jmp    8011a2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011a1:	90                   	nop
	return (void *) s;
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011bb:	eb 03                	jmp    8011c0 <strtol+0x19>
		s++;
  8011bd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c3:	8a 00                	mov    (%eax),%al
  8011c5:	3c 20                	cmp    $0x20,%al
  8011c7:	74 f4                	je     8011bd <strtol+0x16>
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	3c 09                	cmp    $0x9,%al
  8011d0:	74 eb                	je     8011bd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	8a 00                	mov    (%eax),%al
  8011d7:	3c 2b                	cmp    $0x2b,%al
  8011d9:	75 05                	jne    8011e0 <strtol+0x39>
		s++;
  8011db:	ff 45 08             	incl   0x8(%ebp)
  8011de:	eb 13                	jmp    8011f3 <strtol+0x4c>
	else if (*s == '-')
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 2d                	cmp    $0x2d,%al
  8011e7:	75 0a                	jne    8011f3 <strtol+0x4c>
		s++, neg = 1;
  8011e9:	ff 45 08             	incl   0x8(%ebp)
  8011ec:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f7:	74 06                	je     8011ff <strtol+0x58>
  8011f9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011fd:	75 20                	jne    80121f <strtol+0x78>
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 30                	cmp    $0x30,%al
  801206:	75 17                	jne    80121f <strtol+0x78>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	40                   	inc    %eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	3c 78                	cmp    $0x78,%al
  801210:	75 0d                	jne    80121f <strtol+0x78>
		s += 2, base = 16;
  801212:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801216:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80121d:	eb 28                	jmp    801247 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80121f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801223:	75 15                	jne    80123a <strtol+0x93>
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	3c 30                	cmp    $0x30,%al
  80122c:	75 0c                	jne    80123a <strtol+0x93>
		s++, base = 8;
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801238:	eb 0d                	jmp    801247 <strtol+0xa0>
	else if (base == 0)
  80123a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123e:	75 07                	jne    801247 <strtol+0xa0>
		base = 10;
  801240:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	3c 2f                	cmp    $0x2f,%al
  80124e:	7e 19                	jle    801269 <strtol+0xc2>
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 39                	cmp    $0x39,%al
  801257:	7f 10                	jg     801269 <strtol+0xc2>
			dig = *s - '0';
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	0f be c0             	movsbl %al,%eax
  801261:	83 e8 30             	sub    $0x30,%eax
  801264:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801267:	eb 42                	jmp    8012ab <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	3c 60                	cmp    $0x60,%al
  801270:	7e 19                	jle    80128b <strtol+0xe4>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	3c 7a                	cmp    $0x7a,%al
  801279:	7f 10                	jg     80128b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	0f be c0             	movsbl %al,%eax
  801283:	83 e8 57             	sub    $0x57,%eax
  801286:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801289:	eb 20                	jmp    8012ab <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	3c 40                	cmp    $0x40,%al
  801292:	7e 39                	jle    8012cd <strtol+0x126>
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	3c 5a                	cmp    $0x5a,%al
  80129b:	7f 30                	jg     8012cd <strtol+0x126>
			dig = *s - 'A' + 10;
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	0f be c0             	movsbl %al,%eax
  8012a5:	83 e8 37             	sub    $0x37,%eax
  8012a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ae:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012b1:	7d 19                	jge    8012cc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012b3:	ff 45 08             	incl   0x8(%ebp)
  8012b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012bd:	89 c2                	mov    %eax,%edx
  8012bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c2:	01 d0                	add    %edx,%eax
  8012c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012c7:	e9 7b ff ff ff       	jmp    801247 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012cc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012d1:	74 08                	je     8012db <strtol+0x134>
		*endptr = (char *) s;
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012db:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012df:	74 07                	je     8012e8 <strtol+0x141>
  8012e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e4:	f7 d8                	neg    %eax
  8012e6:	eb 03                	jmp    8012eb <strtol+0x144>
  8012e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <ltostr>:

void
ltostr(long value, char *str)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801301:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801305:	79 13                	jns    80131a <ltostr+0x2d>
	{
		neg = 1;
  801307:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80130e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801311:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801314:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801317:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801322:	99                   	cltd   
  801323:	f7 f9                	idiv   %ecx
  801325:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801328:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132b:	8d 50 01             	lea    0x1(%eax),%edx
  80132e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801331:	89 c2                	mov    %eax,%edx
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	01 d0                	add    %edx,%eax
  801338:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80133b:	83 c2 30             	add    $0x30,%edx
  80133e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801340:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801343:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801348:	f7 e9                	imul   %ecx
  80134a:	c1 fa 02             	sar    $0x2,%edx
  80134d:	89 c8                	mov    %ecx,%eax
  80134f:	c1 f8 1f             	sar    $0x1f,%eax
  801352:	29 c2                	sub    %eax,%edx
  801354:	89 d0                	mov    %edx,%eax
  801356:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801359:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80135d:	75 bb                	jne    80131a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80136d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801371:	74 3d                	je     8013b0 <ltostr+0xc3>
		start = 1 ;
  801373:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80137a:	eb 34                	jmp    8013b0 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c2                	add    %eax,%edx
  801391:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	01 c8                	add    %ecx,%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80139d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b6:	7c c4                	jl     80137c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c3:	90                   	nop
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 73 fa ff ff       	call   800e47 <strlen>
  8013d4:	83 c4 04             	add    $0x4,%esp
  8013d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 65 fa ff ff       	call   800e47 <strlen>
  8013e2:	83 c4 04             	add    $0x4,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f6:	eb 17                	jmp    80140f <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80140c:	ff 45 fc             	incl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801415:	7c e1                	jl     8013f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801417:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801425:	eb 1f                	jmp    801446 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	8d 50 01             	lea    0x1(%eax),%edx
  80142d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801430:	89 c2                	mov    %eax,%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801443:	ff 45 f8             	incl   -0x8(%ebp)
  801446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c d9                	jl     801427 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147f:	eb 0c                	jmp    80148d <strsplit+0x31>
			*string++ = 0;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	89 55 08             	mov    %edx,0x8(%ebp)
  80148a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 18                	je     8014ae <strsplit+0x52>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	0f be c0             	movsbl %al,%eax
  80149e:	50                   	push   %eax
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	e8 32 fb ff ff       	call   800fd9 <strchr>
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	75 d3                	jne    801481 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 5a                	je     801511 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	83 f8 0f             	cmp    $0xf,%eax
  8014bf:	75 07                	jne    8014c8 <strsplit+0x6c>
		{
			return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	eb 66                	jmp    80152e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d3:	89 0a                	mov    %ecx,(%edx)
  8014d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 c2                	add    %eax,%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e6:	eb 03                	jmp    8014eb <strsplit+0x8f>
			string++;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	74 8b                	je     80147f <strsplit+0x23>
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	e8 d4 fa ff ff       	call   800fd9 <strchr>
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 dc                	je     8014e8 <strsplit+0x8c>
			string++;
	}
  80150c:	e9 6e ff ff ff       	jmp    80147f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801511:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801529:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801536:	83 ec 04             	sub    $0x4,%esp
  801539:	68 c8 26 80 00       	push   $0x8026c8
  80153e:	68 3f 01 00 00       	push   $0x13f
  801543:	68 ea 26 80 00       	push   $0x8026ea
  801548:	e8 a9 ef ff ff       	call   8004f6 <_panic>

0080154d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
  801550:	57                   	push   %edi
  801551:	56                   	push   %esi
  801552:	53                   	push   %ebx
  801553:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80155f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801562:	8b 7d 18             	mov    0x18(%ebp),%edi
  801565:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801568:	cd 30                	int    $0x30
  80156a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80156d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	5b                   	pop    %ebx
  801574:	5e                   	pop    %esi
  801575:	5f                   	pop    %edi
  801576:	5d                   	pop    %ebp
  801577:	c3                   	ret    

00801578 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	8b 45 10             	mov    0x10(%ebp),%eax
  801581:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801584:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	52                   	push   %edx
  801590:	ff 75 0c             	pushl  0xc(%ebp)
  801593:	50                   	push   %eax
  801594:	6a 00                	push   $0x0
  801596:	e8 b2 ff ff ff       	call   80154d <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	90                   	nop
  80159f:	c9                   	leave  
  8015a0:	c3                   	ret    

008015a1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 02                	push   $0x2
  8015b0:	e8 98 ff ff ff       	call   80154d <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 03                	push   $0x3
  8015c9:	e8 7f ff ff ff       	call   80154d <syscall>
  8015ce:	83 c4 18             	add    $0x18,%esp
}
  8015d1:	90                   	nop
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 04                	push   $0x4
  8015e3:	e8 65 ff ff ff       	call   80154d <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
}
  8015eb:	90                   	nop
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	52                   	push   %edx
  8015fe:	50                   	push   %eax
  8015ff:	6a 08                	push   $0x8
  801601:	e8 47 ff ff ff       	call   80154d <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	56                   	push   %esi
  80160f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801610:	8b 75 18             	mov    0x18(%ebp),%esi
  801613:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801616:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	56                   	push   %esi
  801620:	53                   	push   %ebx
  801621:	51                   	push   %ecx
  801622:	52                   	push   %edx
  801623:	50                   	push   %eax
  801624:	6a 09                	push   $0x9
  801626:	e8 22 ff ff ff       	call   80154d <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
}
  80162e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801631:	5b                   	pop    %ebx
  801632:	5e                   	pop    %esi
  801633:	5d                   	pop    %ebp
  801634:	c3                   	ret    

00801635 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801638:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	52                   	push   %edx
  801645:	50                   	push   %eax
  801646:	6a 0a                	push   $0xa
  801648:	e8 00 ff ff ff       	call   80154d <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	ff 75 0c             	pushl  0xc(%ebp)
  80165e:	ff 75 08             	pushl  0x8(%ebp)
  801661:	6a 0b                	push   $0xb
  801663:	e8 e5 fe ff ff       	call   80154d <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 0c                	push   $0xc
  80167c:	e8 cc fe ff ff       	call   80154d <syscall>
  801681:	83 c4 18             	add    $0x18,%esp
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 0d                	push   $0xd
  801695:	e8 b3 fe ff ff       	call   80154d <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 0e                	push   $0xe
  8016ae:	e8 9a fe ff ff       	call   80154d <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 0f                	push   $0xf
  8016c7:	e8 81 fe ff ff       	call   80154d <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	ff 75 08             	pushl  0x8(%ebp)
  8016df:	6a 10                	push   $0x10
  8016e1:	e8 67 fe ff ff       	call   80154d <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 11                	push   $0x11
  8016fa:	e8 4e fe ff ff       	call   80154d <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_cputc>:

void
sys_cputc(const char c)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801711:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	50                   	push   %eax
  80171e:	6a 01                	push   $0x1
  801720:	e8 28 fe ff ff       	call   80154d <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	90                   	nop
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 14                	push   $0x14
  80173a:	e8 0e fe ff ff       	call   80154d <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	90                   	nop
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 04             	sub    $0x4,%esp
  80174b:	8b 45 10             	mov    0x10(%ebp),%eax
  80174e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801751:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801754:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	6a 00                	push   $0x0
  80175d:	51                   	push   %ecx
  80175e:	52                   	push   %edx
  80175f:	ff 75 0c             	pushl  0xc(%ebp)
  801762:	50                   	push   %eax
  801763:	6a 15                	push   $0x15
  801765:	e8 e3 fd ff ff       	call   80154d <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801772:	8b 55 0c             	mov    0xc(%ebp),%edx
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	52                   	push   %edx
  80177f:	50                   	push   %eax
  801780:	6a 16                	push   $0x16
  801782:	e8 c6 fd ff ff       	call   80154d <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80178f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801792:	8b 55 0c             	mov    0xc(%ebp),%edx
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	51                   	push   %ecx
  80179d:	52                   	push   %edx
  80179e:	50                   	push   %eax
  80179f:	6a 17                	push   $0x17
  8017a1:	e8 a7 fd ff ff       	call   80154d <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	52                   	push   %edx
  8017bb:	50                   	push   %eax
  8017bc:	6a 18                	push   $0x18
  8017be:	e8 8a fd ff ff       	call   80154d <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	6a 00                	push   $0x0
  8017d0:	ff 75 14             	pushl  0x14(%ebp)
  8017d3:	ff 75 10             	pushl  0x10(%ebp)
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	50                   	push   %eax
  8017da:	6a 19                	push   $0x19
  8017dc:	e8 6c fd ff ff       	call   80154d <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	50                   	push   %eax
  8017f5:	6a 1a                	push   $0x1a
  8017f7:	e8 51 fd ff ff       	call   80154d <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
}
  8017ff:	90                   	nop
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	50                   	push   %eax
  801811:	6a 1b                	push   $0x1b
  801813:	e8 35 fd ff ff       	call   80154d <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 05                	push   $0x5
  80182c:	e8 1c fd ff ff       	call   80154d <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 06                	push   $0x6
  801845:	e8 03 fd ff ff       	call   80154d <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 07                	push   $0x7
  80185e:	e8 ea fc ff ff       	call   80154d <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_exit_env>:


void sys_exit_env(void)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 1c                	push   $0x1c
  801877:	e8 d1 fc ff ff       	call   80154d <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	90                   	nop
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801888:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80188b:	8d 50 04             	lea    0x4(%eax),%edx
  80188e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	52                   	push   %edx
  801898:	50                   	push   %eax
  801899:	6a 1d                	push   $0x1d
  80189b:	e8 ad fc ff ff       	call   80154d <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
	return result;
  8018a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ac:	89 01                	mov    %eax,(%ecx)
  8018ae:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	c9                   	leave  
  8018b5:	c2 04 00             	ret    $0x4

008018b8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	ff 75 10             	pushl  0x10(%ebp)
  8018c2:	ff 75 0c             	pushl  0xc(%ebp)
  8018c5:	ff 75 08             	pushl  0x8(%ebp)
  8018c8:	6a 13                	push   $0x13
  8018ca:	e8 7e fc ff ff       	call   80154d <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d2:	90                   	nop
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 1e                	push   $0x1e
  8018e4:	e8 64 fc ff ff       	call   80154d <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018fa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	50                   	push   %eax
  801907:	6a 1f                	push   $0x1f
  801909:	e8 3f fc ff ff       	call   80154d <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
	return ;
  801911:	90                   	nop
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <rsttst>:
void rsttst()
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 21                	push   $0x21
  801923:	e8 25 fc ff ff       	call   80154d <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
	return ;
  80192b:	90                   	nop
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 04             	sub    $0x4,%esp
  801934:	8b 45 14             	mov    0x14(%ebp),%eax
  801937:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80193a:	8b 55 18             	mov    0x18(%ebp),%edx
  80193d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801941:	52                   	push   %edx
  801942:	50                   	push   %eax
  801943:	ff 75 10             	pushl  0x10(%ebp)
  801946:	ff 75 0c             	pushl  0xc(%ebp)
  801949:	ff 75 08             	pushl  0x8(%ebp)
  80194c:	6a 20                	push   $0x20
  80194e:	e8 fa fb ff ff       	call   80154d <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
	return ;
  801956:	90                   	nop
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <chktst>:
void chktst(uint32 n)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	ff 75 08             	pushl  0x8(%ebp)
  801967:	6a 22                	push   $0x22
  801969:	e8 df fb ff ff       	call   80154d <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
	return ;
  801971:	90                   	nop
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <inctst>:

void inctst()
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 23                	push   $0x23
  801983:	e8 c5 fb ff ff       	call   80154d <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
	return ;
  80198b:	90                   	nop
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <gettst>:
uint32 gettst()
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 24                	push   $0x24
  80199d:	e8 ab fb ff ff       	call   80154d <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 25                	push   $0x25
  8019b9:	e8 8f fb ff ff       	call   80154d <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
  8019c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019c4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019c8:	75 07                	jne    8019d1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8019cf:	eb 05                	jmp    8019d6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 25                	push   $0x25
  8019ea:	e8 5e fb ff ff       	call   80154d <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
  8019f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019f5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019f9:	75 07                	jne    801a02 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019fb:	b8 01 00 00 00       	mov    $0x1,%eax
  801a00:	eb 05                	jmp    801a07 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 25                	push   $0x25
  801a1b:	e8 2d fb ff ff       	call   80154d <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
  801a23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a26:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a2a:	75 07                	jne    801a33 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801a31:	eb 05                	jmp    801a38 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 25                	push   $0x25
  801a4c:	e8 fc fa ff ff       	call   80154d <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
  801a54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a57:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a5b:	75 07                	jne    801a64 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a62:	eb 05                	jmp    801a69 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	ff 75 08             	pushl  0x8(%ebp)
  801a79:	6a 26                	push   $0x26
  801a7b:	e8 cd fa ff ff       	call   80154d <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
	return ;
  801a83:	90                   	nop
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a8a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	6a 00                	push   $0x0
  801a98:	53                   	push   %ebx
  801a99:	51                   	push   %ecx
  801a9a:	52                   	push   %edx
  801a9b:	50                   	push   %eax
  801a9c:	6a 27                	push   $0x27
  801a9e:	e8 aa fa ff ff       	call   80154d <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
}
  801aa6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801aae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	52                   	push   %edx
  801abb:	50                   	push   %eax
  801abc:	6a 28                	push   $0x28
  801abe:	e8 8a fa ff ff       	call   80154d <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801acb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ace:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	6a 00                	push   $0x0
  801ad6:	51                   	push   %ecx
  801ad7:	ff 75 10             	pushl  0x10(%ebp)
  801ada:	52                   	push   %edx
  801adb:	50                   	push   %eax
  801adc:	6a 29                	push   $0x29
  801ade:	e8 6a fa ff ff       	call   80154d <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	ff 75 10             	pushl  0x10(%ebp)
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	ff 75 08             	pushl  0x8(%ebp)
  801af8:	6a 12                	push   $0x12
  801afa:	e8 4e fa ff ff       	call   80154d <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
	return ;
  801b02:	90                   	nop
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	52                   	push   %edx
  801b15:	50                   	push   %eax
  801b16:	6a 2a                	push   $0x2a
  801b18:	e8 30 fa ff ff       	call   80154d <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
	return;
  801b20:	90                   	nop
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	50                   	push   %eax
  801b32:	6a 2b                	push   $0x2b
  801b34:	e8 14 fa ff ff       	call   80154d <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	ff 75 0c             	pushl  0xc(%ebp)
  801b4a:	ff 75 08             	pushl  0x8(%ebp)
  801b4d:	6a 2c                	push   $0x2c
  801b4f:	e8 f9 f9 ff ff       	call   80154d <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
	return;
  801b57:	90                   	nop
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	ff 75 08             	pushl  0x8(%ebp)
  801b69:	6a 2d                	push   $0x2d
  801b6b:	e8 dd f9 ff ff       	call   80154d <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
	return;
  801b73:	90                   	nop
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 2e                	push   $0x2e
  801b88:	e8 c0 f9 ff ff       	call   80154d <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
  801b90:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801b93:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	50                   	push   %eax
  801ba7:	6a 2f                	push   $0x2f
  801ba9:	e8 9f f9 ff ff       	call   80154d <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
	return;
  801bb1:	90                   	nop
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	52                   	push   %edx
  801bc4:	50                   	push   %eax
  801bc5:	6a 30                	push   $0x30
  801bc7:	e8 81 f9 ff ff       	call   80154d <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
	return;
  801bcf:	90                   	nop
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	50                   	push   %eax
  801be4:	6a 31                	push   $0x31
  801be6:	e8 62 f9 ff ff       	call   80154d <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
  801bee:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	50                   	push   %eax
  801c05:	6a 32                	push   $0x32
  801c07:	e8 41 f9 ff ff       	call   80154d <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
	return;
  801c0f:	90                   	nop
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    
  801c12:	66 90                	xchg   %ax,%ax

00801c14 <__udivdi3>:
  801c14:	55                   	push   %ebp
  801c15:	57                   	push   %edi
  801c16:	56                   	push   %esi
  801c17:	53                   	push   %ebx
  801c18:	83 ec 1c             	sub    $0x1c,%esp
  801c1b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c1f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c2b:	89 ca                	mov    %ecx,%edx
  801c2d:	89 f8                	mov    %edi,%eax
  801c2f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c33:	85 f6                	test   %esi,%esi
  801c35:	75 2d                	jne    801c64 <__udivdi3+0x50>
  801c37:	39 cf                	cmp    %ecx,%edi
  801c39:	77 65                	ja     801ca0 <__udivdi3+0x8c>
  801c3b:	89 fd                	mov    %edi,%ebp
  801c3d:	85 ff                	test   %edi,%edi
  801c3f:	75 0b                	jne    801c4c <__udivdi3+0x38>
  801c41:	b8 01 00 00 00       	mov    $0x1,%eax
  801c46:	31 d2                	xor    %edx,%edx
  801c48:	f7 f7                	div    %edi
  801c4a:	89 c5                	mov    %eax,%ebp
  801c4c:	31 d2                	xor    %edx,%edx
  801c4e:	89 c8                	mov    %ecx,%eax
  801c50:	f7 f5                	div    %ebp
  801c52:	89 c1                	mov    %eax,%ecx
  801c54:	89 d8                	mov    %ebx,%eax
  801c56:	f7 f5                	div    %ebp
  801c58:	89 cf                	mov    %ecx,%edi
  801c5a:	89 fa                	mov    %edi,%edx
  801c5c:	83 c4 1c             	add    $0x1c,%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5e                   	pop    %esi
  801c61:	5f                   	pop    %edi
  801c62:	5d                   	pop    %ebp
  801c63:	c3                   	ret    
  801c64:	39 ce                	cmp    %ecx,%esi
  801c66:	77 28                	ja     801c90 <__udivdi3+0x7c>
  801c68:	0f bd fe             	bsr    %esi,%edi
  801c6b:	83 f7 1f             	xor    $0x1f,%edi
  801c6e:	75 40                	jne    801cb0 <__udivdi3+0x9c>
  801c70:	39 ce                	cmp    %ecx,%esi
  801c72:	72 0a                	jb     801c7e <__udivdi3+0x6a>
  801c74:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c78:	0f 87 9e 00 00 00    	ja     801d1c <__udivdi3+0x108>
  801c7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c83:	89 fa                	mov    %edi,%edx
  801c85:	83 c4 1c             	add    $0x1c,%esp
  801c88:	5b                   	pop    %ebx
  801c89:	5e                   	pop    %esi
  801c8a:	5f                   	pop    %edi
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    
  801c8d:	8d 76 00             	lea    0x0(%esi),%esi
  801c90:	31 ff                	xor    %edi,%edi
  801c92:	31 c0                	xor    %eax,%eax
  801c94:	89 fa                	mov    %edi,%edx
  801c96:	83 c4 1c             	add    $0x1c,%esp
  801c99:	5b                   	pop    %ebx
  801c9a:	5e                   	pop    %esi
  801c9b:	5f                   	pop    %edi
  801c9c:	5d                   	pop    %ebp
  801c9d:	c3                   	ret    
  801c9e:	66 90                	xchg   %ax,%ax
  801ca0:	89 d8                	mov    %ebx,%eax
  801ca2:	f7 f7                	div    %edi
  801ca4:	31 ff                	xor    %edi,%edi
  801ca6:	89 fa                	mov    %edi,%edx
  801ca8:	83 c4 1c             	add    $0x1c,%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	5f                   	pop    %edi
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    
  801cb0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cb5:	89 eb                	mov    %ebp,%ebx
  801cb7:	29 fb                	sub    %edi,%ebx
  801cb9:	89 f9                	mov    %edi,%ecx
  801cbb:	d3 e6                	shl    %cl,%esi
  801cbd:	89 c5                	mov    %eax,%ebp
  801cbf:	88 d9                	mov    %bl,%cl
  801cc1:	d3 ed                	shr    %cl,%ebp
  801cc3:	89 e9                	mov    %ebp,%ecx
  801cc5:	09 f1                	or     %esi,%ecx
  801cc7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ccb:	89 f9                	mov    %edi,%ecx
  801ccd:	d3 e0                	shl    %cl,%eax
  801ccf:	89 c5                	mov    %eax,%ebp
  801cd1:	89 d6                	mov    %edx,%esi
  801cd3:	88 d9                	mov    %bl,%cl
  801cd5:	d3 ee                	shr    %cl,%esi
  801cd7:	89 f9                	mov    %edi,%ecx
  801cd9:	d3 e2                	shl    %cl,%edx
  801cdb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cdf:	88 d9                	mov    %bl,%cl
  801ce1:	d3 e8                	shr    %cl,%eax
  801ce3:	09 c2                	or     %eax,%edx
  801ce5:	89 d0                	mov    %edx,%eax
  801ce7:	89 f2                	mov    %esi,%edx
  801ce9:	f7 74 24 0c          	divl   0xc(%esp)
  801ced:	89 d6                	mov    %edx,%esi
  801cef:	89 c3                	mov    %eax,%ebx
  801cf1:	f7 e5                	mul    %ebp
  801cf3:	39 d6                	cmp    %edx,%esi
  801cf5:	72 19                	jb     801d10 <__udivdi3+0xfc>
  801cf7:	74 0b                	je     801d04 <__udivdi3+0xf0>
  801cf9:	89 d8                	mov    %ebx,%eax
  801cfb:	31 ff                	xor    %edi,%edi
  801cfd:	e9 58 ff ff ff       	jmp    801c5a <__udivdi3+0x46>
  801d02:	66 90                	xchg   %ax,%ax
  801d04:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d08:	89 f9                	mov    %edi,%ecx
  801d0a:	d3 e2                	shl    %cl,%edx
  801d0c:	39 c2                	cmp    %eax,%edx
  801d0e:	73 e9                	jae    801cf9 <__udivdi3+0xe5>
  801d10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d13:	31 ff                	xor    %edi,%edi
  801d15:	e9 40 ff ff ff       	jmp    801c5a <__udivdi3+0x46>
  801d1a:	66 90                	xchg   %ax,%ax
  801d1c:	31 c0                	xor    %eax,%eax
  801d1e:	e9 37 ff ff ff       	jmp    801c5a <__udivdi3+0x46>
  801d23:	90                   	nop

00801d24 <__umoddi3>:
  801d24:	55                   	push   %ebp
  801d25:	57                   	push   %edi
  801d26:	56                   	push   %esi
  801d27:	53                   	push   %ebx
  801d28:	83 ec 1c             	sub    $0x1c,%esp
  801d2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d43:	89 f3                	mov    %esi,%ebx
  801d45:	89 fa                	mov    %edi,%edx
  801d47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d4b:	89 34 24             	mov    %esi,(%esp)
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	75 1a                	jne    801d6c <__umoddi3+0x48>
  801d52:	39 f7                	cmp    %esi,%edi
  801d54:	0f 86 a2 00 00 00    	jbe    801dfc <__umoddi3+0xd8>
  801d5a:	89 c8                	mov    %ecx,%eax
  801d5c:	89 f2                	mov    %esi,%edx
  801d5e:	f7 f7                	div    %edi
  801d60:	89 d0                	mov    %edx,%eax
  801d62:	31 d2                	xor    %edx,%edx
  801d64:	83 c4 1c             	add    $0x1c,%esp
  801d67:	5b                   	pop    %ebx
  801d68:	5e                   	pop    %esi
  801d69:	5f                   	pop    %edi
  801d6a:	5d                   	pop    %ebp
  801d6b:	c3                   	ret    
  801d6c:	39 f0                	cmp    %esi,%eax
  801d6e:	0f 87 ac 00 00 00    	ja     801e20 <__umoddi3+0xfc>
  801d74:	0f bd e8             	bsr    %eax,%ebp
  801d77:	83 f5 1f             	xor    $0x1f,%ebp
  801d7a:	0f 84 ac 00 00 00    	je     801e2c <__umoddi3+0x108>
  801d80:	bf 20 00 00 00       	mov    $0x20,%edi
  801d85:	29 ef                	sub    %ebp,%edi
  801d87:	89 fe                	mov    %edi,%esi
  801d89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d8d:	89 e9                	mov    %ebp,%ecx
  801d8f:	d3 e0                	shl    %cl,%eax
  801d91:	89 d7                	mov    %edx,%edi
  801d93:	89 f1                	mov    %esi,%ecx
  801d95:	d3 ef                	shr    %cl,%edi
  801d97:	09 c7                	or     %eax,%edi
  801d99:	89 e9                	mov    %ebp,%ecx
  801d9b:	d3 e2                	shl    %cl,%edx
  801d9d:	89 14 24             	mov    %edx,(%esp)
  801da0:	89 d8                	mov    %ebx,%eax
  801da2:	d3 e0                	shl    %cl,%eax
  801da4:	89 c2                	mov    %eax,%edx
  801da6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801daa:	d3 e0                	shl    %cl,%eax
  801dac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801db4:	89 f1                	mov    %esi,%ecx
  801db6:	d3 e8                	shr    %cl,%eax
  801db8:	09 d0                	or     %edx,%eax
  801dba:	d3 eb                	shr    %cl,%ebx
  801dbc:	89 da                	mov    %ebx,%edx
  801dbe:	f7 f7                	div    %edi
  801dc0:	89 d3                	mov    %edx,%ebx
  801dc2:	f7 24 24             	mull   (%esp)
  801dc5:	89 c6                	mov    %eax,%esi
  801dc7:	89 d1                	mov    %edx,%ecx
  801dc9:	39 d3                	cmp    %edx,%ebx
  801dcb:	0f 82 87 00 00 00    	jb     801e58 <__umoddi3+0x134>
  801dd1:	0f 84 91 00 00 00    	je     801e68 <__umoddi3+0x144>
  801dd7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ddb:	29 f2                	sub    %esi,%edx
  801ddd:	19 cb                	sbb    %ecx,%ebx
  801ddf:	89 d8                	mov    %ebx,%eax
  801de1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801de5:	d3 e0                	shl    %cl,%eax
  801de7:	89 e9                	mov    %ebp,%ecx
  801de9:	d3 ea                	shr    %cl,%edx
  801deb:	09 d0                	or     %edx,%eax
  801ded:	89 e9                	mov    %ebp,%ecx
  801def:	d3 eb                	shr    %cl,%ebx
  801df1:	89 da                	mov    %ebx,%edx
  801df3:	83 c4 1c             	add    $0x1c,%esp
  801df6:	5b                   	pop    %ebx
  801df7:	5e                   	pop    %esi
  801df8:	5f                   	pop    %edi
  801df9:	5d                   	pop    %ebp
  801dfa:	c3                   	ret    
  801dfb:	90                   	nop
  801dfc:	89 fd                	mov    %edi,%ebp
  801dfe:	85 ff                	test   %edi,%edi
  801e00:	75 0b                	jne    801e0d <__umoddi3+0xe9>
  801e02:	b8 01 00 00 00       	mov    $0x1,%eax
  801e07:	31 d2                	xor    %edx,%edx
  801e09:	f7 f7                	div    %edi
  801e0b:	89 c5                	mov    %eax,%ebp
  801e0d:	89 f0                	mov    %esi,%eax
  801e0f:	31 d2                	xor    %edx,%edx
  801e11:	f7 f5                	div    %ebp
  801e13:	89 c8                	mov    %ecx,%eax
  801e15:	f7 f5                	div    %ebp
  801e17:	89 d0                	mov    %edx,%eax
  801e19:	e9 44 ff ff ff       	jmp    801d62 <__umoddi3+0x3e>
  801e1e:	66 90                	xchg   %ax,%ax
  801e20:	89 c8                	mov    %ecx,%eax
  801e22:	89 f2                	mov    %esi,%edx
  801e24:	83 c4 1c             	add    $0x1c,%esp
  801e27:	5b                   	pop    %ebx
  801e28:	5e                   	pop    %esi
  801e29:	5f                   	pop    %edi
  801e2a:	5d                   	pop    %ebp
  801e2b:	c3                   	ret    
  801e2c:	3b 04 24             	cmp    (%esp),%eax
  801e2f:	72 06                	jb     801e37 <__umoddi3+0x113>
  801e31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e35:	77 0f                	ja     801e46 <__umoddi3+0x122>
  801e37:	89 f2                	mov    %esi,%edx
  801e39:	29 f9                	sub    %edi,%ecx
  801e3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e3f:	89 14 24             	mov    %edx,(%esp)
  801e42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e46:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e4a:	8b 14 24             	mov    (%esp),%edx
  801e4d:	83 c4 1c             	add    $0x1c,%esp
  801e50:	5b                   	pop    %ebx
  801e51:	5e                   	pop    %esi
  801e52:	5f                   	pop    %edi
  801e53:	5d                   	pop    %ebp
  801e54:	c3                   	ret    
  801e55:	8d 76 00             	lea    0x0(%esi),%esi
  801e58:	2b 04 24             	sub    (%esp),%eax
  801e5b:	19 fa                	sbb    %edi,%edx
  801e5d:	89 d1                	mov    %edx,%ecx
  801e5f:	89 c6                	mov    %eax,%esi
  801e61:	e9 71 ff ff ff       	jmp    801dd7 <__umoddi3+0xb3>
  801e66:	66 90                	xchg   %ax,%ax
  801e68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e6c:	72 ea                	jb     801e58 <__umoddi3+0x134>
  801e6e:	89 d9                	mov    %ebx,%ecx
  801e70:	e9 62 ff ff ff       	jmp    801dd7 <__umoddi3+0xb3>
