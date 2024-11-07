
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
  800042:	e8 1e 16 00 00       	call   801665 <sys_calculate_free_frames>
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
  8000e8:	e8 91 19 00 00       	call   801a7e <sys_check_LRU_lists>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(check == 0)
  8000f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8000f7:	75 14                	jne    80010d <_main+0xd5>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 e0 1d 80 00       	push   $0x801de0
  800101:	6a 26                	push   $0x26
  800103:	68 62 1e 80 00       	push   $0x801e62
  800108:	e8 e1 03 00 00       	call   8004ee <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010d:	e8 9e 15 00 00       	call   8016b0 <sys_pf_calculate_allocated_pages>
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
  80018f:	68 7c 1e 80 00       	push   $0x801e7c
  800194:	e8 12 06 00 00       	call   8007ab <cprintf>
  800199:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  80019c:	8a 85 d0 ff ff fe    	mov    -0x1000030(%ebp),%al
  8001a2:	3c 41                	cmp    $0x41,%al
  8001a4:	74 17                	je     8001bd <_main+0x185>
  8001a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 ac 1e 80 00       	push   $0x801eac
  8001b5:	e8 f1 05 00 00       	call   8007ab <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n");}
  8001bd:	8a 85 d0 0f 00 ff    	mov    -0xfff030(%ebp),%al
  8001c3:	3c 41                	cmp    $0x41,%al
  8001c5:	74 17                	je     8001de <_main+0x1a6>
  8001c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ce:	83 ec 0c             	sub    $0xc,%esp
  8001d1:	68 ac 1e 80 00       	push   $0x801eac
  8001d6:	e8 d0 05 00 00       	call   8007ab <cprintf>
  8001db:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001de:	8a 85 d0 ff 3f ff    	mov    -0xc00030(%ebp),%al
  8001e4:	3c 41                	cmp    $0x41,%al
  8001e6:	74 17                	je     8001ff <_main+0x1c7>
  8001e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	68 ac 1e 80 00       	push   $0x801eac
  8001f7:	e8 af 05 00 00       	call   8007ab <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001ff:	8a 85 d0 0f 40 ff    	mov    -0xbff030(%ebp),%al
  800205:	3c 41                	cmp    $0x41,%al
  800207:	74 17                	je     800220 <_main+0x1e8>
  800209:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 ac 1e 80 00       	push   $0x801eac
  800218:	e8 8e 05 00 00       	call   8007ab <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800220:	8a 85 d0 ff 7f ff    	mov    -0x800030(%ebp),%al
  800226:	3c 41                	cmp    $0x41,%al
  800228:	74 17                	je     800241 <_main+0x209>
  80022a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800231:	83 ec 0c             	sub    $0xc,%esp
  800234:	68 ac 1e 80 00       	push   $0x801eac
  800239:	e8 6d 05 00 00       	call   8007ab <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] != 'A')  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800241:	8a 85 d0 0f 80 ff    	mov    -0x7ff030(%ebp),%al
  800247:	3c 41                	cmp    $0x41,%al
  800249:	74 17                	je     800262 <_main+0x22a>
  80024b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800252:	83 ec 0c             	sub    $0xc,%esp
  800255:	68 ac 1e 80 00       	push   $0x801eac
  80025a:	e8 4c 05 00 00       	call   8007ab <cprintf>
  80025f:	83 c4 10             	add    $0x10,%esp

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT written to Page File until it's replaced\n"); }
  800262:	e8 49 14 00 00       	call   8016b0 <sys_pf_calculate_allocated_pages>
  800267:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80026a:	74 17                	je     800283 <_main+0x24b>
  80026c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	68 cc 1e 80 00       	push   $0x801ecc
  80027b:	e8 2b 05 00 00       	call   8007ab <cprintf>
  800280:	83 c4 10             	add    $0x10,%esp

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  800283:	c7 45 d8 07 00 00 00 	movl   $0x7,-0x28(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  80028a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80028d:	e8 d3 13 00 00       	call   801665 <sys_calculate_free_frames>
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
  8002b1:	68 14 1f 80 00       	push   $0x801f14
  8002b6:	e8 f0 04 00 00       	call   8007ab <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 54 1f 80 00       	push   $0x801f54
  8002c6:	e8 e0 04 00 00       	call   8007ab <cprintf>
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
  80033d:	68 88 1f 80 00       	push   $0x801f88
  800342:	e8 64 04 00 00       	call   8007ab <cprintf>
  800347:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 17, 0);
  80034a:	6a 00                	push   $0x0
  80034c:	6a 11                	push   $0x11
  80034e:	8d 85 84 ff ff fe    	lea    -0x100007c(%ebp),%eax
  800354:	50                   	push   %eax
  800355:	8d 85 8c ff ff fe    	lea    -0x1000074(%ebp),%eax
  80035b:	50                   	push   %eax
  80035c:	e8 1d 17 00 00       	call   801a7e <sys_check_LRU_lists>
  800361:	83 c4 10             	add    $0x10,%esp
  800364:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if(check == 0)
  800367:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80036b:	75 17                	jne    800384 <_main+0x34c>
				{ is_correct = 0; cprintf("LRU lists entries are not correct, check your logic again!!\n"); }
  80036d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	68 b0 1f 80 00       	push   $0x801fb0
  80037c:	e8 2a 04 00 00       	call   8007ab <cprintf>
  800381:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	68 f0 1f 80 00       	push   $0x801ff0
  80038c:	e8 1a 04 00 00       	call   8007ab <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  800394:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800398:	74 04                	je     80039e <_main+0x366>
		eval += 50 ;
  80039a:	83 45 f0 32          	addl   $0x32,-0x10(%ebp)

	cprintf("Congratulations!! Test of PAGE PLACEMENT FIRST SCENARIO completed. Eval = %d\n\n\n", eval);
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a4:	68 28 20 80 00       	push   $0x802028
  8003a9:	e8 fd 03 00 00       	call   8007ab <cprintf>
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
  8003bd:	e8 6c 14 00 00       	call   80182e <sys_getenvindex>
  8003c2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8003c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c8:	89 d0                	mov    %edx,%eax
  8003ca:	c1 e0 02             	shl    $0x2,%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	01 c0                	add    %eax,%eax
  8003d1:	01 d0                	add    %edx,%eax
  8003d3:	c1 e0 02             	shl    $0x2,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	01 c0                	add    %eax,%eax
  8003da:	01 d0                	add    %edx,%eax
  8003dc:	c1 e0 04             	shl    $0x4,%eax
  8003df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e4:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8003ee:	8a 40 20             	mov    0x20(%eax),%al
  8003f1:	84 c0                	test   %al,%al
  8003f3:	74 0d                	je     800402 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8003f5:	a1 04 30 80 00       	mov    0x803004,%eax
  8003fa:	83 c0 20             	add    $0x20,%eax
  8003fd:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800402:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800406:	7e 0a                	jle    800412 <libmain+0x5b>
		binaryname = argv[0];
  800408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800412:	83 ec 08             	sub    $0x8,%esp
  800415:	ff 75 0c             	pushl  0xc(%ebp)
  800418:	ff 75 08             	pushl  0x8(%ebp)
  80041b:	e8 18 fc ff ff       	call   800038 <_main>
  800420:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800423:	e8 8a 11 00 00       	call   8015b2 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800428:	83 ec 0c             	sub    $0xc,%esp
  80042b:	68 90 20 80 00       	push   $0x802090
  800430:	e8 76 03 00 00       	call   8007ab <cprintf>
  800435:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800438:	a1 04 30 80 00       	mov    0x803004,%eax
  80043d:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800443:	a1 04 30 80 00       	mov    0x803004,%eax
  800448:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80044e:	83 ec 04             	sub    $0x4,%esp
  800451:	52                   	push   %edx
  800452:	50                   	push   %eax
  800453:	68 b8 20 80 00       	push   $0x8020b8
  800458:	e8 4e 03 00 00       	call   8007ab <cprintf>
  80045d:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800460:	a1 04 30 80 00       	mov    0x803004,%eax
  800465:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  80046b:	a1 04 30 80 00       	mov    0x803004,%eax
  800470:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800476:	a1 04 30 80 00       	mov    0x803004,%eax
  80047b:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800481:	51                   	push   %ecx
  800482:	52                   	push   %edx
  800483:	50                   	push   %eax
  800484:	68 e0 20 80 00       	push   $0x8020e0
  800489:	e8 1d 03 00 00       	call   8007ab <cprintf>
  80048e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800491:	a1 04 30 80 00       	mov    0x803004,%eax
  800496:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80049c:	83 ec 08             	sub    $0x8,%esp
  80049f:	50                   	push   %eax
  8004a0:	68 38 21 80 00       	push   $0x802138
  8004a5:	e8 01 03 00 00       	call   8007ab <cprintf>
  8004aa:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8004ad:	83 ec 0c             	sub    $0xc,%esp
  8004b0:	68 90 20 80 00       	push   $0x802090
  8004b5:	e8 f1 02 00 00       	call   8007ab <cprintf>
  8004ba:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8004bd:	e8 0a 11 00 00       	call   8015cc <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8004c2:	e8 19 00 00 00       	call   8004e0 <exit>
}
  8004c7:	90                   	nop
  8004c8:	c9                   	leave  
  8004c9:	c3                   	ret    

008004ca <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004ca:	55                   	push   %ebp
  8004cb:	89 e5                	mov    %esp,%ebp
  8004cd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004d0:	83 ec 0c             	sub    $0xc,%esp
  8004d3:	6a 00                	push   $0x0
  8004d5:	e8 20 13 00 00       	call   8017fa <sys_destroy_env>
  8004da:	83 c4 10             	add    $0x10,%esp
}
  8004dd:	90                   	nop
  8004de:	c9                   	leave  
  8004df:	c3                   	ret    

008004e0 <exit>:

void
exit(void)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004e6:	e8 75 13 00 00       	call   801860 <sys_exit_env>
}
  8004eb:	90                   	nop
  8004ec:	c9                   	leave  
  8004ed:	c3                   	ret    

008004ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004ee:	55                   	push   %ebp
  8004ef:	89 e5                	mov    %esp,%ebp
  8004f1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004f4:	8d 45 10             	lea    0x10(%ebp),%eax
  8004f7:	83 c0 04             	add    $0x4,%eax
  8004fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004fd:	a1 24 30 80 00       	mov    0x803024,%eax
  800502:	85 c0                	test   %eax,%eax
  800504:	74 16                	je     80051c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800506:	a1 24 30 80 00       	mov    0x803024,%eax
  80050b:	83 ec 08             	sub    $0x8,%esp
  80050e:	50                   	push   %eax
  80050f:	68 4c 21 80 00       	push   $0x80214c
  800514:	e8 92 02 00 00       	call   8007ab <cprintf>
  800519:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80051c:	a1 00 30 80 00       	mov    0x803000,%eax
  800521:	ff 75 0c             	pushl  0xc(%ebp)
  800524:	ff 75 08             	pushl  0x8(%ebp)
  800527:	50                   	push   %eax
  800528:	68 51 21 80 00       	push   $0x802151
  80052d:	e8 79 02 00 00       	call   8007ab <cprintf>
  800532:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800535:	8b 45 10             	mov    0x10(%ebp),%eax
  800538:	83 ec 08             	sub    $0x8,%esp
  80053b:	ff 75 f4             	pushl  -0xc(%ebp)
  80053e:	50                   	push   %eax
  80053f:	e8 fc 01 00 00       	call   800740 <vcprintf>
  800544:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	6a 00                	push   $0x0
  80054c:	68 6d 21 80 00       	push   $0x80216d
  800551:	e8 ea 01 00 00       	call   800740 <vcprintf>
  800556:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800559:	e8 82 ff ff ff       	call   8004e0 <exit>

	// should not return here
	while (1) ;
  80055e:	eb fe                	jmp    80055e <_panic+0x70>

00800560 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800566:	a1 04 30 80 00       	mov    0x803004,%eax
  80056b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800571:	8b 45 0c             	mov    0xc(%ebp),%eax
  800574:	39 c2                	cmp    %eax,%edx
  800576:	74 14                	je     80058c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800578:	83 ec 04             	sub    $0x4,%esp
  80057b:	68 70 21 80 00       	push   $0x802170
  800580:	6a 26                	push   $0x26
  800582:	68 bc 21 80 00       	push   $0x8021bc
  800587:	e8 62 ff ff ff       	call   8004ee <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80058c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800593:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059a:	e9 c5 00 00 00       	jmp    800664 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80059f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	85 c0                	test   %eax,%eax
  8005b2:	75 08                	jne    8005bc <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005b4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005b7:	e9 a5 00 00 00       	jmp    800661 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005ca:	eb 69                	jmp    800635 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005cc:	a1 04 30 80 00       	mov    0x803004,%eax
  8005d1:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8005d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005da:	89 d0                	mov    %edx,%eax
  8005dc:	01 c0                	add    %eax,%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	c1 e0 03             	shl    $0x3,%eax
  8005e3:	01 c8                	add    %ecx,%eax
  8005e5:	8a 40 04             	mov    0x4(%eax),%al
  8005e8:	84 c0                	test   %al,%al
  8005ea:	75 46                	jne    800632 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ec:	a1 04 30 80 00       	mov    0x803004,%eax
  8005f1:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8005f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005fa:	89 d0                	mov    %edx,%eax
  8005fc:	01 c0                	add    %eax,%eax
  8005fe:	01 d0                	add    %edx,%eax
  800600:	c1 e0 03             	shl    $0x3,%eax
  800603:	01 c8                	add    %ecx,%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80060a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800612:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800617:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	01 c8                	add    %ecx,%eax
  800623:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800625:	39 c2                	cmp    %eax,%edx
  800627:	75 09                	jne    800632 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800629:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800630:	eb 15                	jmp    800647 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800632:	ff 45 e8             	incl   -0x18(%ebp)
  800635:	a1 04 30 80 00       	mov    0x803004,%eax
  80063a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800643:	39 c2                	cmp    %eax,%edx
  800645:	77 85                	ja     8005cc <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800647:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80064b:	75 14                	jne    800661 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80064d:	83 ec 04             	sub    $0x4,%esp
  800650:	68 c8 21 80 00       	push   $0x8021c8
  800655:	6a 3a                	push   $0x3a
  800657:	68 bc 21 80 00       	push   $0x8021bc
  80065c:	e8 8d fe ff ff       	call   8004ee <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800661:	ff 45 f0             	incl   -0x10(%ebp)
  800664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800667:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80066a:	0f 8c 2f ff ff ff    	jl     80059f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800670:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800677:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80067e:	eb 26                	jmp    8006a6 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800680:	a1 04 30 80 00       	mov    0x803004,%eax
  800685:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80068b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068e:	89 d0                	mov    %edx,%eax
  800690:	01 c0                	add    %eax,%eax
  800692:	01 d0                	add    %edx,%eax
  800694:	c1 e0 03             	shl    $0x3,%eax
  800697:	01 c8                	add    %ecx,%eax
  800699:	8a 40 04             	mov    0x4(%eax),%al
  80069c:	3c 01                	cmp    $0x1,%al
  80069e:	75 03                	jne    8006a3 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006a0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a3:	ff 45 e0             	incl   -0x20(%ebp)
  8006a6:	a1 04 30 80 00       	mov    0x803004,%eax
  8006ab:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b4:	39 c2                	cmp    %eax,%edx
  8006b6:	77 c8                	ja     800680 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006be:	74 14                	je     8006d4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006c0:	83 ec 04             	sub    $0x4,%esp
  8006c3:	68 1c 22 80 00       	push   $0x80221c
  8006c8:	6a 44                	push   $0x44
  8006ca:	68 bc 21 80 00       	push   $0x8021bc
  8006cf:	e8 1a fe ff ff       	call   8004ee <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006d4:	90                   	nop
  8006d5:	c9                   	leave  
  8006d6:	c3                   	ret    

008006d7 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006d7:	55                   	push   %ebp
  8006d8:	89 e5                	mov    %esp,%ebp
  8006da:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	8d 48 01             	lea    0x1(%eax),%ecx
  8006e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e8:	89 0a                	mov    %ecx,(%edx)
  8006ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8006ed:	88 d1                	mov    %dl,%cl
  8006ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800700:	75 2c                	jne    80072e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800702:	a0 08 30 80 00       	mov    0x803008,%al
  800707:	0f b6 c0             	movzbl %al,%eax
  80070a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070d:	8b 12                	mov    (%edx),%edx
  80070f:	89 d1                	mov    %edx,%ecx
  800711:	8b 55 0c             	mov    0xc(%ebp),%edx
  800714:	83 c2 08             	add    $0x8,%edx
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	50                   	push   %eax
  80071b:	51                   	push   %ecx
  80071c:	52                   	push   %edx
  80071d:	e8 4e 0e 00 00       	call   801570 <sys_cputs>
  800722:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800725:	8b 45 0c             	mov    0xc(%ebp),%eax
  800728:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80072e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800731:	8b 40 04             	mov    0x4(%eax),%eax
  800734:	8d 50 01             	lea    0x1(%eax),%edx
  800737:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80073d:	90                   	nop
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800749:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800750:	00 00 00 
	b.cnt = 0;
  800753:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80075a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	ff 75 08             	pushl  0x8(%ebp)
  800763:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800769:	50                   	push   %eax
  80076a:	68 d7 06 80 00       	push   $0x8006d7
  80076f:	e8 11 02 00 00       	call   800985 <vprintfmt>
  800774:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800777:	a0 08 30 80 00       	mov    0x803008,%al
  80077c:	0f b6 c0             	movzbl %al,%eax
  80077f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800785:	83 ec 04             	sub    $0x4,%esp
  800788:	50                   	push   %eax
  800789:	52                   	push   %edx
  80078a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800790:	83 c0 08             	add    $0x8,%eax
  800793:	50                   	push   %eax
  800794:	e8 d7 0d 00 00       	call   801570 <sys_cputs>
  800799:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80079c:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8007a3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    

008007ab <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007b1:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8007b8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c7:	50                   	push   %eax
  8007c8:	e8 73 ff ff ff       	call   800740 <vcprintf>
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    

008007d8 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007de:	e8 cf 0d 00 00       	call   8015b2 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007e3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f2:	50                   	push   %eax
  8007f3:	e8 48 ff ff ff       	call   800740 <vcprintf>
  8007f8:	83 c4 10             	add    $0x10,%esp
  8007fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007fe:	e8 c9 0d 00 00       	call   8015cc <sys_unlock_cons>
	return cnt;
  800803:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800806:	c9                   	leave  
  800807:	c3                   	ret    

00800808 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	53                   	push   %ebx
  80080c:	83 ec 14             	sub    $0x14,%esp
  80080f:	8b 45 10             	mov    0x10(%ebp),%eax
  800812:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80081b:	8b 45 18             	mov    0x18(%ebp),%eax
  80081e:	ba 00 00 00 00       	mov    $0x0,%edx
  800823:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800826:	77 55                	ja     80087d <printnum+0x75>
  800828:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082b:	72 05                	jb     800832 <printnum+0x2a>
  80082d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800830:	77 4b                	ja     80087d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800832:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800835:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800838:	8b 45 18             	mov    0x18(%ebp),%eax
  80083b:	ba 00 00 00 00       	mov    $0x0,%edx
  800840:	52                   	push   %edx
  800841:	50                   	push   %eax
  800842:	ff 75 f4             	pushl  -0xc(%ebp)
  800845:	ff 75 f0             	pushl  -0x10(%ebp)
  800848:	e8 23 13 00 00       	call   801b70 <__udivdi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	83 ec 04             	sub    $0x4,%esp
  800853:	ff 75 20             	pushl  0x20(%ebp)
  800856:	53                   	push   %ebx
  800857:	ff 75 18             	pushl  0x18(%ebp)
  80085a:	52                   	push   %edx
  80085b:	50                   	push   %eax
  80085c:	ff 75 0c             	pushl  0xc(%ebp)
  80085f:	ff 75 08             	pushl  0x8(%ebp)
  800862:	e8 a1 ff ff ff       	call   800808 <printnum>
  800867:	83 c4 20             	add    $0x20,%esp
  80086a:	eb 1a                	jmp    800886 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	ff 75 20             	pushl  0x20(%ebp)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80087d:	ff 4d 1c             	decl   0x1c(%ebp)
  800880:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800884:	7f e6                	jg     80086c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800886:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800889:	bb 00 00 00 00       	mov    $0x0,%ebx
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800894:	53                   	push   %ebx
  800895:	51                   	push   %ecx
  800896:	52                   	push   %edx
  800897:	50                   	push   %eax
  800898:	e8 e3 13 00 00       	call   801c80 <__umoddi3>
  80089d:	83 c4 10             	add    $0x10,%esp
  8008a0:	05 94 24 80 00       	add    $0x802494,%eax
  8008a5:	8a 00                	mov    (%eax),%al
  8008a7:	0f be c0             	movsbl %al,%eax
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	50                   	push   %eax
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	ff d0                	call   *%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
}
  8008b9:	90                   	nop
  8008ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008bd:	c9                   	leave  
  8008be:	c3                   	ret    

008008bf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c6:	7e 1c                	jle    8008e4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	8d 50 08             	lea    0x8(%eax),%edx
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	89 10                	mov    %edx,(%eax)
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	83 e8 08             	sub    $0x8,%eax
  8008dd:	8b 50 04             	mov    0x4(%eax),%edx
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	eb 40                	jmp    800924 <getuint+0x65>
	else if (lflag)
  8008e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e8:	74 1e                	je     800908 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	8d 50 04             	lea    0x4(%eax),%edx
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	89 10                	mov    %edx,(%eax)
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	83 e8 04             	sub    $0x4,%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	ba 00 00 00 00       	mov    $0x0,%edx
  800906:	eb 1c                	jmp    800924 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	8d 50 04             	lea    0x4(%eax),%edx
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	89 10                	mov    %edx,(%eax)
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	83 e8 04             	sub    $0x4,%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800929:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80092d:	7e 1c                	jle    80094b <getint+0x25>
		return va_arg(*ap, long long);
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	8d 50 08             	lea    0x8(%eax),%edx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 10                	mov    %edx,(%eax)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	83 e8 08             	sub    $0x8,%eax
  800944:	8b 50 04             	mov    0x4(%eax),%edx
  800947:	8b 00                	mov    (%eax),%eax
  800949:	eb 38                	jmp    800983 <getint+0x5d>
	else if (lflag)
  80094b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094f:	74 1a                	je     80096b <getint+0x45>
		return va_arg(*ap, long);
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	8d 50 04             	lea    0x4(%eax),%edx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	89 10                	mov    %edx,(%eax)
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	83 e8 04             	sub    $0x4,%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	99                   	cltd   
  800969:	eb 18                	jmp    800983 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	8b 00                	mov    (%eax),%eax
  800970:	8d 50 04             	lea    0x4(%eax),%edx
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	89 10                	mov    %edx,(%eax)
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	83 e8 04             	sub    $0x4,%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	99                   	cltd   
}
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	56                   	push   %esi
  800989:	53                   	push   %ebx
  80098a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80098d:	eb 17                	jmp    8009a6 <vprintfmt+0x21>
			if (ch == '\0')
  80098f:	85 db                	test   %ebx,%ebx
  800991:	0f 84 c1 03 00 00    	je     800d58 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	53                   	push   %ebx
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a9:	8d 50 01             	lea    0x1(%eax),%edx
  8009ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8009af:	8a 00                	mov    (%eax),%al
  8009b1:	0f b6 d8             	movzbl %al,%ebx
  8009b4:	83 fb 25             	cmp    $0x25,%ebx
  8009b7:	75 d6                	jne    80098f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009bd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009c4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009cb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009dc:	8d 50 01             	lea    0x1(%eax),%edx
  8009df:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e2:	8a 00                	mov    (%eax),%al
  8009e4:	0f b6 d8             	movzbl %al,%ebx
  8009e7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ea:	83 f8 5b             	cmp    $0x5b,%eax
  8009ed:	0f 87 3d 03 00 00    	ja     800d30 <vprintfmt+0x3ab>
  8009f3:	8b 04 85 b8 24 80 00 	mov    0x8024b8(,%eax,4),%eax
  8009fa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009fc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a00:	eb d7                	jmp    8009d9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a02:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a06:	eb d1                	jmp    8009d9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a08:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a12:	89 d0                	mov    %edx,%eax
  800a14:	c1 e0 02             	shl    $0x2,%eax
  800a17:	01 d0                	add    %edx,%eax
  800a19:	01 c0                	add    %eax,%eax
  800a1b:	01 d8                	add    %ebx,%eax
  800a1d:	83 e8 30             	sub    $0x30,%eax
  800a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a23:	8b 45 10             	mov    0x10(%ebp),%eax
  800a26:	8a 00                	mov    (%eax),%al
  800a28:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a2b:	83 fb 2f             	cmp    $0x2f,%ebx
  800a2e:	7e 3e                	jle    800a6e <vprintfmt+0xe9>
  800a30:	83 fb 39             	cmp    $0x39,%ebx
  800a33:	7f 39                	jg     800a6e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a35:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a38:	eb d5                	jmp    800a0f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3d:	83 c0 04             	add    $0x4,%eax
  800a40:	89 45 14             	mov    %eax,0x14(%ebp)
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 e8 04             	sub    $0x4,%eax
  800a49:	8b 00                	mov    (%eax),%eax
  800a4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a4e:	eb 1f                	jmp    800a6f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a54:	79 83                	jns    8009d9 <vprintfmt+0x54>
				width = 0;
  800a56:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a5d:	e9 77 ff ff ff       	jmp    8009d9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a62:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a69:	e9 6b ff ff ff       	jmp    8009d9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a6e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a73:	0f 89 60 ff ff ff    	jns    8009d9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a86:	e9 4e ff ff ff       	jmp    8009d9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a8b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a8e:	e9 46 ff ff ff       	jmp    8009d9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a93:	8b 45 14             	mov    0x14(%ebp),%eax
  800a96:	83 c0 04             	add    $0x4,%eax
  800a99:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9f:	83 e8 04             	sub    $0x4,%eax
  800aa2:	8b 00                	mov    (%eax),%eax
  800aa4:	83 ec 08             	sub    $0x8,%esp
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	50                   	push   %eax
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
			break;
  800ab3:	e9 9b 02 00 00       	jmp    800d53 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab8:	8b 45 14             	mov    0x14(%ebp),%eax
  800abb:	83 c0 04             	add    $0x4,%eax
  800abe:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac4:	83 e8 04             	sub    $0x4,%eax
  800ac7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac9:	85 db                	test   %ebx,%ebx
  800acb:	79 02                	jns    800acf <vprintfmt+0x14a>
				err = -err;
  800acd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800acf:	83 fb 64             	cmp    $0x64,%ebx
  800ad2:	7f 0b                	jg     800adf <vprintfmt+0x15a>
  800ad4:	8b 34 9d 00 23 80 00 	mov    0x802300(,%ebx,4),%esi
  800adb:	85 f6                	test   %esi,%esi
  800add:	75 19                	jne    800af8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800adf:	53                   	push   %ebx
  800ae0:	68 a5 24 80 00       	push   $0x8024a5
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	ff 75 08             	pushl  0x8(%ebp)
  800aeb:	e8 70 02 00 00       	call   800d60 <printfmt>
  800af0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af3:	e9 5b 02 00 00       	jmp    800d53 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af8:	56                   	push   %esi
  800af9:	68 ae 24 80 00       	push   $0x8024ae
  800afe:	ff 75 0c             	pushl  0xc(%ebp)
  800b01:	ff 75 08             	pushl  0x8(%ebp)
  800b04:	e8 57 02 00 00       	call   800d60 <printfmt>
  800b09:	83 c4 10             	add    $0x10,%esp
			break;
  800b0c:	e9 42 02 00 00       	jmp    800d53 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b11:	8b 45 14             	mov    0x14(%ebp),%eax
  800b14:	83 c0 04             	add    $0x4,%eax
  800b17:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1d:	83 e8 04             	sub    $0x4,%eax
  800b20:	8b 30                	mov    (%eax),%esi
  800b22:	85 f6                	test   %esi,%esi
  800b24:	75 05                	jne    800b2b <vprintfmt+0x1a6>
				p = "(null)";
  800b26:	be b1 24 80 00       	mov    $0x8024b1,%esi
			if (width > 0 && padc != '-')
  800b2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2f:	7e 6d                	jle    800b9e <vprintfmt+0x219>
  800b31:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b35:	74 67                	je     800b9e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b3a:	83 ec 08             	sub    $0x8,%esp
  800b3d:	50                   	push   %eax
  800b3e:	56                   	push   %esi
  800b3f:	e8 1e 03 00 00       	call   800e62 <strnlen>
  800b44:	83 c4 10             	add    $0x10,%esp
  800b47:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b4a:	eb 16                	jmp    800b62 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b4c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	50                   	push   %eax
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b66:	7f e4                	jg     800b4c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b68:	eb 34                	jmp    800b9e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b6e:	74 1c                	je     800b8c <vprintfmt+0x207>
  800b70:	83 fb 1f             	cmp    $0x1f,%ebx
  800b73:	7e 05                	jle    800b7a <vprintfmt+0x1f5>
  800b75:	83 fb 7e             	cmp    $0x7e,%ebx
  800b78:	7e 12                	jle    800b8c <vprintfmt+0x207>
					putch('?', putdat);
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	ff 75 0c             	pushl  0xc(%ebp)
  800b80:	6a 3f                	push   $0x3f
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	ff d0                	call   *%eax
  800b87:	83 c4 10             	add    $0x10,%esp
  800b8a:	eb 0f                	jmp    800b9b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b8c:	83 ec 08             	sub    $0x8,%esp
  800b8f:	ff 75 0c             	pushl  0xc(%ebp)
  800b92:	53                   	push   %ebx
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	ff d0                	call   *%eax
  800b98:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b9e:	89 f0                	mov    %esi,%eax
  800ba0:	8d 70 01             	lea    0x1(%eax),%esi
  800ba3:	8a 00                	mov    (%eax),%al
  800ba5:	0f be d8             	movsbl %al,%ebx
  800ba8:	85 db                	test   %ebx,%ebx
  800baa:	74 24                	je     800bd0 <vprintfmt+0x24b>
  800bac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb0:	78 b8                	js     800b6a <vprintfmt+0x1e5>
  800bb2:	ff 4d e0             	decl   -0x20(%ebp)
  800bb5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb9:	79 af                	jns    800b6a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbb:	eb 13                	jmp    800bd0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 0c             	pushl  0xc(%ebp)
  800bc3:	6a 20                	push   $0x20
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
  800bca:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bcd:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd4:	7f e7                	jg     800bbd <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd6:	e9 78 01 00 00       	jmp    800d53 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bdb:	83 ec 08             	sub    $0x8,%esp
  800bde:	ff 75 e8             	pushl  -0x18(%ebp)
  800be1:	8d 45 14             	lea    0x14(%ebp),%eax
  800be4:	50                   	push   %eax
  800be5:	e8 3c fd ff ff       	call   800926 <getint>
  800bea:	83 c4 10             	add    $0x10,%esp
  800bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf9:	85 d2                	test   %edx,%edx
  800bfb:	79 23                	jns    800c20 <vprintfmt+0x29b>
				putch('-', putdat);
  800bfd:	83 ec 08             	sub    $0x8,%esp
  800c00:	ff 75 0c             	pushl  0xc(%ebp)
  800c03:	6a 2d                	push   $0x2d
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	ff d0                	call   *%eax
  800c0a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c13:	f7 d8                	neg    %eax
  800c15:	83 d2 00             	adc    $0x0,%edx
  800c18:	f7 da                	neg    %edx
  800c1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c20:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c27:	e9 bc 00 00 00       	jmp    800ce8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c2c:	83 ec 08             	sub    $0x8,%esp
  800c2f:	ff 75 e8             	pushl  -0x18(%ebp)
  800c32:	8d 45 14             	lea    0x14(%ebp),%eax
  800c35:	50                   	push   %eax
  800c36:	e8 84 fc ff ff       	call   8008bf <getuint>
  800c3b:	83 c4 10             	add    $0x10,%esp
  800c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c41:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c44:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c4b:	e9 98 00 00 00       	jmp    800ce8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	6a 58                	push   $0x58
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	6a 58                	push   $0x58
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	ff d0                	call   *%eax
  800c6d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c70:	83 ec 08             	sub    $0x8,%esp
  800c73:	ff 75 0c             	pushl  0xc(%ebp)
  800c76:	6a 58                	push   $0x58
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	ff d0                	call   *%eax
  800c7d:	83 c4 10             	add    $0x10,%esp
			break;
  800c80:	e9 ce 00 00 00       	jmp    800d53 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c85:	83 ec 08             	sub    $0x8,%esp
  800c88:	ff 75 0c             	pushl  0xc(%ebp)
  800c8b:	6a 30                	push   $0x30
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	ff d0                	call   *%eax
  800c92:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c95:	83 ec 08             	sub    $0x8,%esp
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	6a 78                	push   $0x78
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	ff d0                	call   *%eax
  800ca2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	83 c0 04             	add    $0x4,%eax
  800cab:	89 45 14             	mov    %eax,0x14(%ebp)
  800cae:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb1:	83 e8 04             	sub    $0x4,%eax
  800cb4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc7:	eb 1f                	jmp    800ce8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc9:	83 ec 08             	sub    $0x8,%esp
  800ccc:	ff 75 e8             	pushl  -0x18(%ebp)
  800ccf:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd2:	50                   	push   %eax
  800cd3:	e8 e7 fb ff ff       	call   8008bf <getuint>
  800cd8:	83 c4 10             	add    $0x10,%esp
  800cdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cde:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cef:	83 ec 04             	sub    $0x4,%esp
  800cf2:	52                   	push   %edx
  800cf3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf6:	50                   	push   %eax
  800cf7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfa:	ff 75 f0             	pushl  -0x10(%ebp)
  800cfd:	ff 75 0c             	pushl  0xc(%ebp)
  800d00:	ff 75 08             	pushl  0x8(%ebp)
  800d03:	e8 00 fb ff ff       	call   800808 <printnum>
  800d08:	83 c4 20             	add    $0x20,%esp
			break;
  800d0b:	eb 46                	jmp    800d53 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d0d:	83 ec 08             	sub    $0x8,%esp
  800d10:	ff 75 0c             	pushl  0xc(%ebp)
  800d13:	53                   	push   %ebx
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	ff d0                	call   *%eax
  800d19:	83 c4 10             	add    $0x10,%esp
			break;
  800d1c:	eb 35                	jmp    800d53 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d1e:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800d25:	eb 2c                	jmp    800d53 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d27:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800d2e:	eb 23                	jmp    800d53 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d30:	83 ec 08             	sub    $0x8,%esp
  800d33:	ff 75 0c             	pushl  0xc(%ebp)
  800d36:	6a 25                	push   $0x25
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	ff d0                	call   *%eax
  800d3d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d40:	ff 4d 10             	decl   0x10(%ebp)
  800d43:	eb 03                	jmp    800d48 <vprintfmt+0x3c3>
  800d45:	ff 4d 10             	decl   0x10(%ebp)
  800d48:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4b:	48                   	dec    %eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	3c 25                	cmp    $0x25,%al
  800d50:	75 f3                	jne    800d45 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d52:	90                   	nop
		}
	}
  800d53:	e9 35 fc ff ff       	jmp    80098d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d58:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d5c:	5b                   	pop    %ebx
  800d5d:	5e                   	pop    %esi
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d66:	8d 45 10             	lea    0x10(%ebp),%eax
  800d69:	83 c0 04             	add    $0x4,%eax
  800d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	ff 75 f4             	pushl  -0xc(%ebp)
  800d75:	50                   	push   %eax
  800d76:	ff 75 0c             	pushl  0xc(%ebp)
  800d79:	ff 75 08             	pushl  0x8(%ebp)
  800d7c:	e8 04 fc ff ff       	call   800985 <vprintfmt>
  800d81:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d84:	90                   	nop
  800d85:	c9                   	leave  
  800d86:	c3                   	ret    

00800d87 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8b 40 08             	mov    0x8(%eax),%eax
  800d90:	8d 50 01             	lea    0x1(%eax),%edx
  800d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d96:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	8b 10                	mov    (%eax),%edx
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	8b 40 04             	mov    0x4(%eax),%eax
  800da4:	39 c2                	cmp    %eax,%edx
  800da6:	73 12                	jae    800dba <sprintputch+0x33>
		*b->buf++ = ch;
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	8b 00                	mov    (%eax),%eax
  800dad:	8d 48 01             	lea    0x1(%eax),%ecx
  800db0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db3:	89 0a                	mov    %ecx,(%edx)
  800db5:	8b 55 08             	mov    0x8(%ebp),%edx
  800db8:	88 10                	mov    %dl,(%eax)
}
  800dba:	90                   	nop
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	01 d0                	add    %edx,%eax
  800dd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de2:	74 06                	je     800dea <vsnprintf+0x2d>
  800de4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de8:	7f 07                	jg     800df1 <vsnprintf+0x34>
		return -E_INVAL;
  800dea:	b8 03 00 00 00       	mov    $0x3,%eax
  800def:	eb 20                	jmp    800e11 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800df1:	ff 75 14             	pushl  0x14(%ebp)
  800df4:	ff 75 10             	pushl  0x10(%ebp)
  800df7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dfa:	50                   	push   %eax
  800dfb:	68 87 0d 80 00       	push   $0x800d87
  800e00:	e8 80 fb ff ff       	call   800985 <vprintfmt>
  800e05:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e0b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e11:	c9                   	leave  
  800e12:	c3                   	ret    

00800e13 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e19:	8d 45 10             	lea    0x10(%ebp),%eax
  800e1c:	83 c0 04             	add    $0x4,%eax
  800e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e22:	8b 45 10             	mov    0x10(%ebp),%eax
  800e25:	ff 75 f4             	pushl  -0xc(%ebp)
  800e28:	50                   	push   %eax
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	ff 75 08             	pushl  0x8(%ebp)
  800e2f:	e8 89 ff ff ff       	call   800dbd <vsnprintf>
  800e34:	83 c4 10             	add    $0x10,%esp
  800e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e3d:	c9                   	leave  
  800e3e:	c3                   	ret    

00800e3f <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4c:	eb 06                	jmp    800e54 <strlen+0x15>
		n++;
  800e4e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	84 c0                	test   %al,%al
  800e5b:	75 f1                	jne    800e4e <strlen+0xf>
		n++;
	return n;
  800e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6f:	eb 09                	jmp    800e7a <strnlen+0x18>
		n++;
  800e71:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e74:	ff 45 08             	incl   0x8(%ebp)
  800e77:	ff 4d 0c             	decl   0xc(%ebp)
  800e7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7e:	74 09                	je     800e89 <strnlen+0x27>
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	84 c0                	test   %al,%al
  800e87:	75 e8                	jne    800e71 <strnlen+0xf>
		n++;
	return n;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e9a:	90                   	nop
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ea1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eaa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ead:	8a 12                	mov    (%edx),%dl
  800eaf:	88 10                	mov    %dl,(%eax)
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	75 e4                	jne    800e9b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ec8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ecf:	eb 1f                	jmp    800ef0 <strncpy+0x34>
		*dst++ = *src;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8d 50 01             	lea    0x1(%eax),%edx
  800ed7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edd:	8a 12                	mov    (%edx),%dl
  800edf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	84 c0                	test   %al,%al
  800ee8:	74 03                	je     800eed <strncpy+0x31>
			src++;
  800eea:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eed:	ff 45 fc             	incl   -0x4(%ebp)
  800ef0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ef6:	72 d9                	jb     800ed1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0d:	74 30                	je     800f3f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f0f:	eb 16                	jmp    800f27 <strlcpy+0x2a>
			*dst++ = *src++;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8d 50 01             	lea    0x1(%eax),%edx
  800f17:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f20:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f23:	8a 12                	mov    (%edx),%dl
  800f25:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f27:	ff 4d 10             	decl   0x10(%ebp)
  800f2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2e:	74 09                	je     800f39 <strlcpy+0x3c>
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	84 c0                	test   %al,%al
  800f37:	75 d8                	jne    800f11 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f45:	29 c2                	sub    %eax,%edx
  800f47:	89 d0                	mov    %edx,%eax
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    

00800f4b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f4e:	eb 06                	jmp    800f56 <strcmp+0xb>
		p++, q++;
  800f50:	ff 45 08             	incl   0x8(%ebp)
  800f53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	84 c0                	test   %al,%al
  800f5d:	74 0e                	je     800f6d <strcmp+0x22>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 10                	mov    (%eax),%dl
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	38 c2                	cmp    %al,%dl
  800f6b:	74 e3                	je     800f50 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 d0             	movzbl %al,%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	0f b6 c0             	movzbl %al,%eax
  800f7d:	29 c2                	sub    %eax,%edx
  800f7f:	89 d0                	mov    %edx,%eax
}
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f86:	eb 09                	jmp    800f91 <strncmp+0xe>
		n--, p++, q++;
  800f88:	ff 4d 10             	decl   0x10(%ebp)
  800f8b:	ff 45 08             	incl   0x8(%ebp)
  800f8e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f95:	74 17                	je     800fae <strncmp+0x2b>
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	84 c0                	test   %al,%al
  800f9e:	74 0e                	je     800fae <strncmp+0x2b>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 10                	mov    (%eax),%dl
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	38 c2                	cmp    %al,%dl
  800fac:	74 da                	je     800f88 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb2:	75 07                	jne    800fbb <strncmp+0x38>
		return 0;
  800fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb9:	eb 14                	jmp    800fcf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	0f b6 d0             	movzbl %al,%edx
  800fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	0f b6 c0             	movzbl %al,%eax
  800fcb:	29 c2                	sub    %eax,%edx
  800fcd:	89 d0                	mov    %edx,%eax
}
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 04             	sub    $0x4,%esp
  800fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fda:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fdd:	eb 12                	jmp    800ff1 <strchr+0x20>
		if (*s == c)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe7:	75 05                	jne    800fee <strchr+0x1d>
			return (char *) s;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	eb 11                	jmp    800fff <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	84 c0                	test   %al,%al
  800ff8:	75 e5                	jne    800fdf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ffa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fff:	c9                   	leave  
  801000:	c3                   	ret    

00801001 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 04             	sub    $0x4,%esp
  801007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80100d:	eb 0d                	jmp    80101c <strfind+0x1b>
		if (*s == c)
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	8a 00                	mov    (%eax),%al
  801014:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801017:	74 0e                	je     801027 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	84 c0                	test   %al,%al
  801023:	75 ea                	jne    80100f <strfind+0xe>
  801025:	eb 01                	jmp    801028 <strfind+0x27>
		if (*s == c)
			break;
  801027:	90                   	nop
	return (char *) s;
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80103f:	eb 0e                	jmp    80104f <memset+0x22>
		*p++ = c;
  801041:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801044:	8d 50 01             	lea    0x1(%eax),%edx
  801047:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80104a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80104f:	ff 4d f8             	decl   -0x8(%ebp)
  801052:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801056:	79 e9                	jns    801041 <memset+0x14>
		*p++ = c;

	return v;
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    

0080105d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80106f:	eb 16                	jmp    801087 <memcpy+0x2a>
		*d++ = *s++;
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	8d 50 01             	lea    0x1(%eax),%edx
  801077:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80107d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801080:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801083:	8a 12                	mov    (%edx),%dl
  801085:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108d:	89 55 10             	mov    %edx,0x10(%ebp)
  801090:	85 c0                	test   %eax,%eax
  801092:	75 dd                	jne    801071 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80109f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010b1:	73 50                	jae    801103 <memmove+0x6a>
  8010b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b9:	01 d0                	add    %edx,%eax
  8010bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010be:	76 43                	jbe    801103 <memmove+0x6a>
		s += n;
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010cc:	eb 10                	jmp    8010de <memmove+0x45>
			*--d = *--s;
  8010ce:	ff 4d f8             	decl   -0x8(%ebp)
  8010d1:	ff 4d fc             	decl   -0x4(%ebp)
  8010d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d7:	8a 10                	mov    (%eax),%dl
  8010d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010de:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	75 e3                	jne    8010ce <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010eb:	eb 23                	jmp    801110 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f0:	8d 50 01             	lea    0x1(%eax),%edx
  8010f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010ff:	8a 12                	mov    (%edx),%dl
  801101:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	8d 50 ff             	lea    -0x1(%eax),%edx
  801109:	89 55 10             	mov    %edx,0x10(%ebp)
  80110c:	85 c0                	test   %eax,%eax
  80110e:	75 dd                	jne    8010ed <memmove+0x54>
			*d++ = *s++;

	return dst;
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801127:	eb 2a                	jmp    801153 <memcmp+0x3e>
		if (*s1 != *s2)
  801129:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112c:	8a 10                	mov    (%eax),%dl
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	38 c2                	cmp    %al,%dl
  801135:	74 16                	je     80114d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801137:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113a:	8a 00                	mov    (%eax),%al
  80113c:	0f b6 d0             	movzbl %al,%edx
  80113f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	0f b6 c0             	movzbl %al,%eax
  801147:	29 c2                	sub    %eax,%edx
  801149:	89 d0                	mov    %edx,%eax
  80114b:	eb 18                	jmp    801165 <memcmp+0x50>
		s1++, s2++;
  80114d:	ff 45 fc             	incl   -0x4(%ebp)
  801150:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801153:	8b 45 10             	mov    0x10(%ebp),%eax
  801156:	8d 50 ff             	lea    -0x1(%eax),%edx
  801159:	89 55 10             	mov    %edx,0x10(%ebp)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	75 c9                	jne    801129 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801160:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801165:	c9                   	leave  
  801166:	c3                   	ret    

00801167 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80116d:	8b 55 08             	mov    0x8(%ebp),%edx
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	01 d0                	add    %edx,%eax
  801175:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801178:	eb 15                	jmp    80118f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
  80117d:	8a 00                	mov    (%eax),%al
  80117f:	0f b6 d0             	movzbl %al,%edx
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	0f b6 c0             	movzbl %al,%eax
  801188:	39 c2                	cmp    %eax,%edx
  80118a:	74 0d                	je     801199 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80118c:	ff 45 08             	incl   0x8(%ebp)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801195:	72 e3                	jb     80117a <memfind+0x13>
  801197:	eb 01                	jmp    80119a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801199:	90                   	nop
	return (void *) s;
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80119d:	c9                   	leave  
  80119e:	c3                   	ret    

0080119f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011b3:	eb 03                	jmp    8011b8 <strtol+0x19>
		s++;
  8011b5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	3c 20                	cmp    $0x20,%al
  8011bf:	74 f4                	je     8011b5 <strtol+0x16>
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 09                	cmp    $0x9,%al
  8011c8:	74 eb                	je     8011b5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	3c 2b                	cmp    $0x2b,%al
  8011d1:	75 05                	jne    8011d8 <strtol+0x39>
		s++;
  8011d3:	ff 45 08             	incl   0x8(%ebp)
  8011d6:	eb 13                	jmp    8011eb <strtol+0x4c>
	else if (*s == '-')
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 2d                	cmp    $0x2d,%al
  8011df:	75 0a                	jne    8011eb <strtol+0x4c>
		s++, neg = 1;
  8011e1:	ff 45 08             	incl   0x8(%ebp)
  8011e4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ef:	74 06                	je     8011f7 <strtol+0x58>
  8011f1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011f5:	75 20                	jne    801217 <strtol+0x78>
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	3c 30                	cmp    $0x30,%al
  8011fe:	75 17                	jne    801217 <strtol+0x78>
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	40                   	inc    %eax
  801204:	8a 00                	mov    (%eax),%al
  801206:	3c 78                	cmp    $0x78,%al
  801208:	75 0d                	jne    801217 <strtol+0x78>
		s += 2, base = 16;
  80120a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80120e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801215:	eb 28                	jmp    80123f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801217:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121b:	75 15                	jne    801232 <strtol+0x93>
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	3c 30                	cmp    $0x30,%al
  801224:	75 0c                	jne    801232 <strtol+0x93>
		s++, base = 8;
  801226:	ff 45 08             	incl   0x8(%ebp)
  801229:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801230:	eb 0d                	jmp    80123f <strtol+0xa0>
	else if (base == 0)
  801232:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801236:	75 07                	jne    80123f <strtol+0xa0>
		base = 10;
  801238:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	3c 2f                	cmp    $0x2f,%al
  801246:	7e 19                	jle    801261 <strtol+0xc2>
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	3c 39                	cmp    $0x39,%al
  80124f:	7f 10                	jg     801261 <strtol+0xc2>
			dig = *s - '0';
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	0f be c0             	movsbl %al,%eax
  801259:	83 e8 30             	sub    $0x30,%eax
  80125c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80125f:	eb 42                	jmp    8012a3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3c 60                	cmp    $0x60,%al
  801268:	7e 19                	jle    801283 <strtol+0xe4>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	3c 7a                	cmp    $0x7a,%al
  801271:	7f 10                	jg     801283 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	0f be c0             	movsbl %al,%eax
  80127b:	83 e8 57             	sub    $0x57,%eax
  80127e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801281:	eb 20                	jmp    8012a3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	3c 40                	cmp    $0x40,%al
  80128a:	7e 39                	jle    8012c5 <strtol+0x126>
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	3c 5a                	cmp    $0x5a,%al
  801293:	7f 30                	jg     8012c5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	0f be c0             	movsbl %al,%eax
  80129d:	83 e8 37             	sub    $0x37,%eax
  8012a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012a9:	7d 19                	jge    8012c4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ab:	ff 45 08             	incl   0x8(%ebp)
  8012ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012b5:	89 c2                	mov    %eax,%edx
  8012b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012bf:	e9 7b ff ff ff       	jmp    80123f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012c4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012c9:	74 08                	je     8012d3 <strtol+0x134>
		*endptr = (char *) s;
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012d7:	74 07                	je     8012e0 <strtol+0x141>
  8012d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012dc:	f7 d8                	neg    %eax
  8012de:	eb 03                	jmp    8012e3 <strtol+0x144>
  8012e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012e3:	c9                   	leave  
  8012e4:	c3                   	ret    

008012e5 <ltostr>:

void
ltostr(long value, char *str)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012fd:	79 13                	jns    801312 <ltostr+0x2d>
	{
		neg = 1;
  8012ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801306:	8b 45 0c             	mov    0xc(%ebp),%eax
  801309:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80130c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80130f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80131a:	99                   	cltd   
  80131b:	f7 f9                	idiv   %ecx
  80131d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801323:	8d 50 01             	lea    0x1(%eax),%edx
  801326:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801329:	89 c2                	mov    %eax,%edx
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	01 d0                	add    %edx,%eax
  801330:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801333:	83 c2 30             	add    $0x30,%edx
  801336:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801338:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801340:	f7 e9                	imul   %ecx
  801342:	c1 fa 02             	sar    $0x2,%edx
  801345:	89 c8                	mov    %ecx,%eax
  801347:	c1 f8 1f             	sar    $0x1f,%eax
  80134a:	29 c2                	sub    %eax,%edx
  80134c:	89 d0                	mov    %edx,%eax
  80134e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801355:	75 bb                	jne    801312 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801357:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80135e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801361:	48                   	dec    %eax
  801362:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801365:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801369:	74 3d                	je     8013a8 <ltostr+0xc3>
		start = 1 ;
  80136b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801372:	eb 34                	jmp    8013a8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801374:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801377:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137a:	01 d0                	add    %edx,%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801381:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 c2                	add    %eax,%edx
  801389:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c8                	add    %ecx,%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801395:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	01 c2                	add    %eax,%edx
  80139d:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a0:	88 02                	mov    %al,(%edx)
		start++ ;
  8013a2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013a5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ae:	7c c4                	jl     801374 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	01 d0                	add    %edx,%eax
  8013b8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013bb:	90                   	nop
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013c4:	ff 75 08             	pushl  0x8(%ebp)
  8013c7:	e8 73 fa ff ff       	call   800e3f <strlen>
  8013cc:	83 c4 04             	add    $0x4,%esp
  8013cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013d2:	ff 75 0c             	pushl  0xc(%ebp)
  8013d5:	e8 65 fa ff ff       	call   800e3f <strlen>
  8013da:	83 c4 04             	add    $0x4,%esp
  8013dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ee:	eb 17                	jmp    801407 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f6:	01 c2                	add    %eax,%edx
  8013f8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	01 c8                	add    %ecx,%eax
  801400:	8a 00                	mov    (%eax),%al
  801402:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801404:	ff 45 fc             	incl   -0x4(%ebp)
  801407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80140d:	7c e1                	jl     8013f0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80140f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801416:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80141d:	eb 1f                	jmp    80143e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80141f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801422:	8d 50 01             	lea    0x1(%eax),%edx
  801425:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801428:	89 c2                	mov    %eax,%edx
  80142a:	8b 45 10             	mov    0x10(%ebp),%eax
  80142d:	01 c2                	add    %eax,%edx
  80142f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801432:	8b 45 0c             	mov    0xc(%ebp),%eax
  801435:	01 c8                	add    %ecx,%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80143b:	ff 45 f8             	incl   -0x8(%ebp)
  80143e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801441:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801444:	7c d9                	jl     80141f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801446:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801449:	8b 45 10             	mov    0x10(%ebp),%eax
  80144c:	01 d0                	add    %edx,%eax
  80144e:	c6 00 00             	movb   $0x0,(%eax)
}
  801451:	90                   	nop
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801457:	8b 45 14             	mov    0x14(%ebp),%eax
  80145a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801460:	8b 45 14             	mov    0x14(%ebp),%eax
  801463:	8b 00                	mov    (%eax),%eax
  801465:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80146c:	8b 45 10             	mov    0x10(%ebp),%eax
  80146f:	01 d0                	add    %edx,%eax
  801471:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801477:	eb 0c                	jmp    801485 <strsplit+0x31>
			*string++ = 0;
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8d 50 01             	lea    0x1(%eax),%edx
  80147f:	89 55 08             	mov    %edx,0x8(%ebp)
  801482:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	84 c0                	test   %al,%al
  80148c:	74 18                	je     8014a6 <strsplit+0x52>
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	0f be c0             	movsbl %al,%eax
  801496:	50                   	push   %eax
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	e8 32 fb ff ff       	call   800fd1 <strchr>
  80149f:	83 c4 08             	add    $0x8,%esp
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	75 d3                	jne    801479 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	8a 00                	mov    (%eax),%al
  8014ab:	84 c0                	test   %al,%al
  8014ad:	74 5a                	je     801509 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014af:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b2:	8b 00                	mov    (%eax),%eax
  8014b4:	83 f8 0f             	cmp    $0xf,%eax
  8014b7:	75 07                	jne    8014c0 <strsplit+0x6c>
		{
			return 0;
  8014b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014be:	eb 66                	jmp    801526 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	8d 48 01             	lea    0x1(%eax),%ecx
  8014c8:	8b 55 14             	mov    0x14(%ebp),%edx
  8014cb:	89 0a                	mov    %ecx,(%edx)
  8014cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d7:	01 c2                	add    %eax,%edx
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014de:	eb 03                	jmp    8014e3 <strsplit+0x8f>
			string++;
  8014e0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	84 c0                	test   %al,%al
  8014ea:	74 8b                	je     801477 <strsplit+0x23>
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	8a 00                	mov    (%eax),%al
  8014f1:	0f be c0             	movsbl %al,%eax
  8014f4:	50                   	push   %eax
  8014f5:	ff 75 0c             	pushl  0xc(%ebp)
  8014f8:	e8 d4 fa ff ff       	call   800fd1 <strchr>
  8014fd:	83 c4 08             	add    $0x8,%esp
  801500:	85 c0                	test   %eax,%eax
  801502:	74 dc                	je     8014e0 <strsplit+0x8c>
			string++;
	}
  801504:	e9 6e ff ff ff       	jmp    801477 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801509:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80150a:	8b 45 14             	mov    0x14(%ebp),%eax
  80150d:	8b 00                	mov    (%eax),%eax
  80150f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801516:	8b 45 10             	mov    0x10(%ebp),%eax
  801519:	01 d0                	add    %edx,%eax
  80151b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801521:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80152e:	83 ec 04             	sub    $0x4,%esp
  801531:	68 28 26 80 00       	push   $0x802628
  801536:	68 3f 01 00 00       	push   $0x13f
  80153b:	68 4a 26 80 00       	push   $0x80264a
  801540:	e8 a9 ef ff ff       	call   8004ee <_panic>

00801545 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	57                   	push   %edi
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
  80154b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801557:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80155a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80155d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801560:	cd 30                	int    $0x30
  801562:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801565:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	5b                   	pop    %ebx
  80156c:	5e                   	pop    %esi
  80156d:	5f                   	pop    %edi
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80157c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	52                   	push   %edx
  801588:	ff 75 0c             	pushl  0xc(%ebp)
  80158b:	50                   	push   %eax
  80158c:	6a 00                	push   $0x0
  80158e:	e8 b2 ff ff ff       	call   801545 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	90                   	nop
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sys_cgetc>:

int
sys_cgetc(void)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 02                	push   $0x2
  8015a8:	e8 98 ff ff ff       	call   801545 <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 03                	push   $0x3
  8015c1:	e8 7f ff ff ff       	call   801545 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	90                   	nop
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 04                	push   $0x4
  8015db:	e8 65 ff ff ff       	call   801545 <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
}
  8015e3:	90                   	nop
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	52                   	push   %edx
  8015f6:	50                   	push   %eax
  8015f7:	6a 08                	push   $0x8
  8015f9:	e8 47 ff ff ff       	call   801545 <syscall>
  8015fe:	83 c4 18             	add    $0x18,%esp
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	56                   	push   %esi
  801607:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801608:	8b 75 18             	mov    0x18(%ebp),%esi
  80160b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80160e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801611:	8b 55 0c             	mov    0xc(%ebp),%edx
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	56                   	push   %esi
  801618:	53                   	push   %ebx
  801619:	51                   	push   %ecx
  80161a:	52                   	push   %edx
  80161b:	50                   	push   %eax
  80161c:	6a 09                	push   $0x9
  80161e:	e8 22 ff ff ff       	call   801545 <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
}
  801626:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801629:	5b                   	pop    %ebx
  80162a:	5e                   	pop    %esi
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    

0080162d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801630:	8b 55 0c             	mov    0xc(%ebp),%edx
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	52                   	push   %edx
  80163d:	50                   	push   %eax
  80163e:	6a 0a                	push   $0xa
  801640:	e8 00 ff ff ff       	call   801545 <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	ff 75 08             	pushl  0x8(%ebp)
  801659:	6a 0b                	push   $0xb
  80165b:	e8 e5 fe ff ff       	call   801545 <syscall>
  801660:	83 c4 18             	add    $0x18,%esp
}
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 0c                	push   $0xc
  801674:	e8 cc fe ff ff       	call   801545 <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 0d                	push   $0xd
  80168d:	e8 b3 fe ff ff       	call   801545 <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 0e                	push   $0xe
  8016a6:	e8 9a fe ff ff       	call   801545 <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 0f                	push   $0xf
  8016bf:	e8 81 fe ff ff       	call   801545 <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	ff 75 08             	pushl  0x8(%ebp)
  8016d7:	6a 10                	push   $0x10
  8016d9:	e8 67 fe ff ff       	call   801545 <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 11                	push   $0x11
  8016f2:	e8 4e fe ff ff       	call   801545 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	90                   	nop
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_cputc>:

void
sys_cputc(const char c)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 04             	sub    $0x4,%esp
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801709:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	50                   	push   %eax
  801716:	6a 01                	push   $0x1
  801718:	e8 28 fe ff ff       	call   801545 <syscall>
  80171d:	83 c4 18             	add    $0x18,%esp
}
  801720:	90                   	nop
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 14                	push   $0x14
  801732:	e8 0e fe ff ff       	call   801545 <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
}
  80173a:	90                   	nop
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801749:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80174c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	6a 00                	push   $0x0
  801755:	51                   	push   %ecx
  801756:	52                   	push   %edx
  801757:	ff 75 0c             	pushl  0xc(%ebp)
  80175a:	50                   	push   %eax
  80175b:	6a 15                	push   $0x15
  80175d:	e8 e3 fd ff ff       	call   801545 <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80176a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	52                   	push   %edx
  801777:	50                   	push   %eax
  801778:	6a 16                	push   $0x16
  80177a:	e8 c6 fd ff ff       	call   801545 <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801787:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80178a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	51                   	push   %ecx
  801795:	52                   	push   %edx
  801796:	50                   	push   %eax
  801797:	6a 17                	push   $0x17
  801799:	e8 a7 fd ff ff       	call   801545 <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	52                   	push   %edx
  8017b3:	50                   	push   %eax
  8017b4:	6a 18                	push   $0x18
  8017b6:	e8 8a fd ff ff       	call   801545 <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	6a 00                	push   $0x0
  8017c8:	ff 75 14             	pushl  0x14(%ebp)
  8017cb:	ff 75 10             	pushl  0x10(%ebp)
  8017ce:	ff 75 0c             	pushl  0xc(%ebp)
  8017d1:	50                   	push   %eax
  8017d2:	6a 19                	push   $0x19
  8017d4:	e8 6c fd ff ff       	call   801545 <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	50                   	push   %eax
  8017ed:	6a 1a                	push   $0x1a
  8017ef:	e8 51 fd ff ff       	call   801545 <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	90                   	nop
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	50                   	push   %eax
  801809:	6a 1b                	push   $0x1b
  80180b:	e8 35 fd ff ff       	call   801545 <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 05                	push   $0x5
  801824:	e8 1c fd ff ff       	call   801545 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 06                	push   $0x6
  80183d:	e8 03 fd ff ff       	call   801545 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 07                	push   $0x7
  801856:	e8 ea fc ff ff       	call   801545 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_exit_env>:


void sys_exit_env(void)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 1c                	push   $0x1c
  80186f:	e8 d1 fc ff ff       	call   801545 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	90                   	nop
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801880:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801883:	8d 50 04             	lea    0x4(%eax),%edx
  801886:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	52                   	push   %edx
  801890:	50                   	push   %eax
  801891:	6a 1d                	push   $0x1d
  801893:	e8 ad fc ff ff       	call   801545 <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
	return result;
  80189b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a4:	89 01                	mov    %eax,(%ecx)
  8018a6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	c9                   	leave  
  8018ad:	c2 04 00             	ret    $0x4

008018b0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	ff 75 10             	pushl  0x10(%ebp)
  8018ba:	ff 75 0c             	pushl  0xc(%ebp)
  8018bd:	ff 75 08             	pushl  0x8(%ebp)
  8018c0:	6a 13                	push   $0x13
  8018c2:	e8 7e fc ff ff       	call   801545 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ca:	90                   	nop
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_rcr2>:
uint32 sys_rcr2()
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 1e                	push   $0x1e
  8018dc:	e8 64 fc ff ff       	call   801545 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 04             	sub    $0x4,%esp
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018f2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	50                   	push   %eax
  8018ff:	6a 1f                	push   $0x1f
  801901:	e8 3f fc ff ff       	call   801545 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
	return ;
  801909:	90                   	nop
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <rsttst>:
void rsttst()
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 21                	push   $0x21
  80191b:	e8 25 fc ff ff       	call   801545 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
	return ;
  801923:	90                   	nop
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	8b 45 14             	mov    0x14(%ebp),%eax
  80192f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801932:	8b 55 18             	mov    0x18(%ebp),%edx
  801935:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801939:	52                   	push   %edx
  80193a:	50                   	push   %eax
  80193b:	ff 75 10             	pushl  0x10(%ebp)
  80193e:	ff 75 0c             	pushl  0xc(%ebp)
  801941:	ff 75 08             	pushl  0x8(%ebp)
  801944:	6a 20                	push   $0x20
  801946:	e8 fa fb ff ff       	call   801545 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
	return ;
  80194e:	90                   	nop
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <chktst>:
void chktst(uint32 n)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	ff 75 08             	pushl  0x8(%ebp)
  80195f:	6a 22                	push   $0x22
  801961:	e8 df fb ff ff       	call   801545 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
	return ;
  801969:	90                   	nop
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <inctst>:

void inctst()
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 23                	push   $0x23
  80197b:	e8 c5 fb ff ff       	call   801545 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
	return ;
  801983:	90                   	nop
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <gettst>:
uint32 gettst()
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 24                	push   $0x24
  801995:	e8 ab fb ff ff       	call   801545 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 25                	push   $0x25
  8019b1:	e8 8f fb ff ff       	call   801545 <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
  8019b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019bc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019c0:	75 07                	jne    8019c9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c7:	eb 05                	jmp    8019ce <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 25                	push   $0x25
  8019e2:	e8 5e fb ff ff       	call   801545 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
  8019ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019ed:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019f1:	75 07                	jne    8019fa <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f8:	eb 05                	jmp    8019ff <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 25                	push   $0x25
  801a13:	e8 2d fb ff ff       	call   801545 <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
  801a1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a1e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a22:	75 07                	jne    801a2b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a24:	b8 01 00 00 00       	mov    $0x1,%eax
  801a29:	eb 05                	jmp    801a30 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 25                	push   $0x25
  801a44:	e8 fc fa ff ff       	call   801545 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
  801a4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a4f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a53:	75 07                	jne    801a5c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a55:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5a:	eb 05                	jmp    801a61 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	ff 75 08             	pushl  0x8(%ebp)
  801a71:	6a 26                	push   $0x26
  801a73:	e8 cd fa ff ff       	call   801545 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7b:	90                   	nop
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a82:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a85:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	6a 00                	push   $0x0
  801a90:	53                   	push   %ebx
  801a91:	51                   	push   %ecx
  801a92:	52                   	push   %edx
  801a93:	50                   	push   %eax
  801a94:	6a 27                	push   $0x27
  801a96:	e8 aa fa ff ff       	call   801545 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	52                   	push   %edx
  801ab3:	50                   	push   %eax
  801ab4:	6a 28                	push   $0x28
  801ab6:	e8 8a fa ff ff       	call   801545 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ac3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	51                   	push   %ecx
  801acf:	ff 75 10             	pushl  0x10(%ebp)
  801ad2:	52                   	push   %edx
  801ad3:	50                   	push   %eax
  801ad4:	6a 29                	push   $0x29
  801ad6:	e8 6a fa ff ff       	call   801545 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	ff 75 10             	pushl  0x10(%ebp)
  801aea:	ff 75 0c             	pushl  0xc(%ebp)
  801aed:	ff 75 08             	pushl  0x8(%ebp)
  801af0:	6a 12                	push   $0x12
  801af2:	e8 4e fa ff ff       	call   801545 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
	return ;
  801afa:	90                   	nop
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	52                   	push   %edx
  801b0d:	50                   	push   %eax
  801b0e:	6a 2a                	push   $0x2a
  801b10:	e8 30 fa ff ff       	call   801545 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
	return;
  801b18:	90                   	nop
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	50                   	push   %eax
  801b2a:	6a 2b                	push   $0x2b
  801b2c:	e8 14 fa ff ff       	call   801545 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	ff 75 08             	pushl  0x8(%ebp)
  801b45:	6a 2c                	push   $0x2c
  801b47:	e8 f9 f9 ff ff       	call   801545 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
	return;
  801b4f:	90                   	nop
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	ff 75 0c             	pushl  0xc(%ebp)
  801b5e:	ff 75 08             	pushl  0x8(%ebp)
  801b61:	6a 2d                	push   $0x2d
  801b63:	e8 dd f9 ff ff       	call   801545 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
	return;
  801b6b:	90                   	nop
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    
  801b6e:	66 90                	xchg   %ax,%ax

00801b70 <__udivdi3>:
  801b70:	55                   	push   %ebp
  801b71:	57                   	push   %edi
  801b72:	56                   	push   %esi
  801b73:	53                   	push   %ebx
  801b74:	83 ec 1c             	sub    $0x1c,%esp
  801b77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b87:	89 ca                	mov    %ecx,%edx
  801b89:	89 f8                	mov    %edi,%eax
  801b8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b8f:	85 f6                	test   %esi,%esi
  801b91:	75 2d                	jne    801bc0 <__udivdi3+0x50>
  801b93:	39 cf                	cmp    %ecx,%edi
  801b95:	77 65                	ja     801bfc <__udivdi3+0x8c>
  801b97:	89 fd                	mov    %edi,%ebp
  801b99:	85 ff                	test   %edi,%edi
  801b9b:	75 0b                	jne    801ba8 <__udivdi3+0x38>
  801b9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba2:	31 d2                	xor    %edx,%edx
  801ba4:	f7 f7                	div    %edi
  801ba6:	89 c5                	mov    %eax,%ebp
  801ba8:	31 d2                	xor    %edx,%edx
  801baa:	89 c8                	mov    %ecx,%eax
  801bac:	f7 f5                	div    %ebp
  801bae:	89 c1                	mov    %eax,%ecx
  801bb0:	89 d8                	mov    %ebx,%eax
  801bb2:	f7 f5                	div    %ebp
  801bb4:	89 cf                	mov    %ecx,%edi
  801bb6:	89 fa                	mov    %edi,%edx
  801bb8:	83 c4 1c             	add    $0x1c,%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5e                   	pop    %esi
  801bbd:	5f                   	pop    %edi
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    
  801bc0:	39 ce                	cmp    %ecx,%esi
  801bc2:	77 28                	ja     801bec <__udivdi3+0x7c>
  801bc4:	0f bd fe             	bsr    %esi,%edi
  801bc7:	83 f7 1f             	xor    $0x1f,%edi
  801bca:	75 40                	jne    801c0c <__udivdi3+0x9c>
  801bcc:	39 ce                	cmp    %ecx,%esi
  801bce:	72 0a                	jb     801bda <__udivdi3+0x6a>
  801bd0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bd4:	0f 87 9e 00 00 00    	ja     801c78 <__udivdi3+0x108>
  801bda:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdf:	89 fa                	mov    %edi,%edx
  801be1:	83 c4 1c             	add    $0x1c,%esp
  801be4:	5b                   	pop    %ebx
  801be5:	5e                   	pop    %esi
  801be6:	5f                   	pop    %edi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    
  801be9:	8d 76 00             	lea    0x0(%esi),%esi
  801bec:	31 ff                	xor    %edi,%edi
  801bee:	31 c0                	xor    %eax,%eax
  801bf0:	89 fa                	mov    %edi,%edx
  801bf2:	83 c4 1c             	add    $0x1c,%esp
  801bf5:	5b                   	pop    %ebx
  801bf6:	5e                   	pop    %esi
  801bf7:	5f                   	pop    %edi
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    
  801bfa:	66 90                	xchg   %ax,%ax
  801bfc:	89 d8                	mov    %ebx,%eax
  801bfe:	f7 f7                	div    %edi
  801c00:	31 ff                	xor    %edi,%edi
  801c02:	89 fa                	mov    %edi,%edx
  801c04:	83 c4 1c             	add    $0x1c,%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5f                   	pop    %edi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    
  801c0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c11:	89 eb                	mov    %ebp,%ebx
  801c13:	29 fb                	sub    %edi,%ebx
  801c15:	89 f9                	mov    %edi,%ecx
  801c17:	d3 e6                	shl    %cl,%esi
  801c19:	89 c5                	mov    %eax,%ebp
  801c1b:	88 d9                	mov    %bl,%cl
  801c1d:	d3 ed                	shr    %cl,%ebp
  801c1f:	89 e9                	mov    %ebp,%ecx
  801c21:	09 f1                	or     %esi,%ecx
  801c23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c27:	89 f9                	mov    %edi,%ecx
  801c29:	d3 e0                	shl    %cl,%eax
  801c2b:	89 c5                	mov    %eax,%ebp
  801c2d:	89 d6                	mov    %edx,%esi
  801c2f:	88 d9                	mov    %bl,%cl
  801c31:	d3 ee                	shr    %cl,%esi
  801c33:	89 f9                	mov    %edi,%ecx
  801c35:	d3 e2                	shl    %cl,%edx
  801c37:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c3b:	88 d9                	mov    %bl,%cl
  801c3d:	d3 e8                	shr    %cl,%eax
  801c3f:	09 c2                	or     %eax,%edx
  801c41:	89 d0                	mov    %edx,%eax
  801c43:	89 f2                	mov    %esi,%edx
  801c45:	f7 74 24 0c          	divl   0xc(%esp)
  801c49:	89 d6                	mov    %edx,%esi
  801c4b:	89 c3                	mov    %eax,%ebx
  801c4d:	f7 e5                	mul    %ebp
  801c4f:	39 d6                	cmp    %edx,%esi
  801c51:	72 19                	jb     801c6c <__udivdi3+0xfc>
  801c53:	74 0b                	je     801c60 <__udivdi3+0xf0>
  801c55:	89 d8                	mov    %ebx,%eax
  801c57:	31 ff                	xor    %edi,%edi
  801c59:	e9 58 ff ff ff       	jmp    801bb6 <__udivdi3+0x46>
  801c5e:	66 90                	xchg   %ax,%ax
  801c60:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c64:	89 f9                	mov    %edi,%ecx
  801c66:	d3 e2                	shl    %cl,%edx
  801c68:	39 c2                	cmp    %eax,%edx
  801c6a:	73 e9                	jae    801c55 <__udivdi3+0xe5>
  801c6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c6f:	31 ff                	xor    %edi,%edi
  801c71:	e9 40 ff ff ff       	jmp    801bb6 <__udivdi3+0x46>
  801c76:	66 90                	xchg   %ax,%ax
  801c78:	31 c0                	xor    %eax,%eax
  801c7a:	e9 37 ff ff ff       	jmp    801bb6 <__udivdi3+0x46>
  801c7f:	90                   	nop

00801c80 <__umoddi3>:
  801c80:	55                   	push   %ebp
  801c81:	57                   	push   %edi
  801c82:	56                   	push   %esi
  801c83:	53                   	push   %ebx
  801c84:	83 ec 1c             	sub    $0x1c,%esp
  801c87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c9f:	89 f3                	mov    %esi,%ebx
  801ca1:	89 fa                	mov    %edi,%edx
  801ca3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca7:	89 34 24             	mov    %esi,(%esp)
  801caa:	85 c0                	test   %eax,%eax
  801cac:	75 1a                	jne    801cc8 <__umoddi3+0x48>
  801cae:	39 f7                	cmp    %esi,%edi
  801cb0:	0f 86 a2 00 00 00    	jbe    801d58 <__umoddi3+0xd8>
  801cb6:	89 c8                	mov    %ecx,%eax
  801cb8:	89 f2                	mov    %esi,%edx
  801cba:	f7 f7                	div    %edi
  801cbc:	89 d0                	mov    %edx,%eax
  801cbe:	31 d2                	xor    %edx,%edx
  801cc0:	83 c4 1c             	add    $0x1c,%esp
  801cc3:	5b                   	pop    %ebx
  801cc4:	5e                   	pop    %esi
  801cc5:	5f                   	pop    %edi
  801cc6:	5d                   	pop    %ebp
  801cc7:	c3                   	ret    
  801cc8:	39 f0                	cmp    %esi,%eax
  801cca:	0f 87 ac 00 00 00    	ja     801d7c <__umoddi3+0xfc>
  801cd0:	0f bd e8             	bsr    %eax,%ebp
  801cd3:	83 f5 1f             	xor    $0x1f,%ebp
  801cd6:	0f 84 ac 00 00 00    	je     801d88 <__umoddi3+0x108>
  801cdc:	bf 20 00 00 00       	mov    $0x20,%edi
  801ce1:	29 ef                	sub    %ebp,%edi
  801ce3:	89 fe                	mov    %edi,%esi
  801ce5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ce9:	89 e9                	mov    %ebp,%ecx
  801ceb:	d3 e0                	shl    %cl,%eax
  801ced:	89 d7                	mov    %edx,%edi
  801cef:	89 f1                	mov    %esi,%ecx
  801cf1:	d3 ef                	shr    %cl,%edi
  801cf3:	09 c7                	or     %eax,%edi
  801cf5:	89 e9                	mov    %ebp,%ecx
  801cf7:	d3 e2                	shl    %cl,%edx
  801cf9:	89 14 24             	mov    %edx,(%esp)
  801cfc:	89 d8                	mov    %ebx,%eax
  801cfe:	d3 e0                	shl    %cl,%eax
  801d00:	89 c2                	mov    %eax,%edx
  801d02:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d06:	d3 e0                	shl    %cl,%eax
  801d08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d10:	89 f1                	mov    %esi,%ecx
  801d12:	d3 e8                	shr    %cl,%eax
  801d14:	09 d0                	or     %edx,%eax
  801d16:	d3 eb                	shr    %cl,%ebx
  801d18:	89 da                	mov    %ebx,%edx
  801d1a:	f7 f7                	div    %edi
  801d1c:	89 d3                	mov    %edx,%ebx
  801d1e:	f7 24 24             	mull   (%esp)
  801d21:	89 c6                	mov    %eax,%esi
  801d23:	89 d1                	mov    %edx,%ecx
  801d25:	39 d3                	cmp    %edx,%ebx
  801d27:	0f 82 87 00 00 00    	jb     801db4 <__umoddi3+0x134>
  801d2d:	0f 84 91 00 00 00    	je     801dc4 <__umoddi3+0x144>
  801d33:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d37:	29 f2                	sub    %esi,%edx
  801d39:	19 cb                	sbb    %ecx,%ebx
  801d3b:	89 d8                	mov    %ebx,%eax
  801d3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d41:	d3 e0                	shl    %cl,%eax
  801d43:	89 e9                	mov    %ebp,%ecx
  801d45:	d3 ea                	shr    %cl,%edx
  801d47:	09 d0                	or     %edx,%eax
  801d49:	89 e9                	mov    %ebp,%ecx
  801d4b:	d3 eb                	shr    %cl,%ebx
  801d4d:	89 da                	mov    %ebx,%edx
  801d4f:	83 c4 1c             	add    $0x1c,%esp
  801d52:	5b                   	pop    %ebx
  801d53:	5e                   	pop    %esi
  801d54:	5f                   	pop    %edi
  801d55:	5d                   	pop    %ebp
  801d56:	c3                   	ret    
  801d57:	90                   	nop
  801d58:	89 fd                	mov    %edi,%ebp
  801d5a:	85 ff                	test   %edi,%edi
  801d5c:	75 0b                	jne    801d69 <__umoddi3+0xe9>
  801d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d63:	31 d2                	xor    %edx,%edx
  801d65:	f7 f7                	div    %edi
  801d67:	89 c5                	mov    %eax,%ebp
  801d69:	89 f0                	mov    %esi,%eax
  801d6b:	31 d2                	xor    %edx,%edx
  801d6d:	f7 f5                	div    %ebp
  801d6f:	89 c8                	mov    %ecx,%eax
  801d71:	f7 f5                	div    %ebp
  801d73:	89 d0                	mov    %edx,%eax
  801d75:	e9 44 ff ff ff       	jmp    801cbe <__umoddi3+0x3e>
  801d7a:	66 90                	xchg   %ax,%ax
  801d7c:	89 c8                	mov    %ecx,%eax
  801d7e:	89 f2                	mov    %esi,%edx
  801d80:	83 c4 1c             	add    $0x1c,%esp
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5f                   	pop    %edi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
  801d88:	3b 04 24             	cmp    (%esp),%eax
  801d8b:	72 06                	jb     801d93 <__umoddi3+0x113>
  801d8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d91:	77 0f                	ja     801da2 <__umoddi3+0x122>
  801d93:	89 f2                	mov    %esi,%edx
  801d95:	29 f9                	sub    %edi,%ecx
  801d97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d9b:	89 14 24             	mov    %edx,(%esp)
  801d9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801da2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801da6:	8b 14 24             	mov    (%esp),%edx
  801da9:	83 c4 1c             	add    $0x1c,%esp
  801dac:	5b                   	pop    %ebx
  801dad:	5e                   	pop    %esi
  801dae:	5f                   	pop    %edi
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    
  801db1:	8d 76 00             	lea    0x0(%esi),%esi
  801db4:	2b 04 24             	sub    (%esp),%eax
  801db7:	19 fa                	sbb    %edi,%edx
  801db9:	89 d1                	mov    %edx,%ecx
  801dbb:	89 c6                	mov    %eax,%esi
  801dbd:	e9 71 ff ff ff       	jmp    801d33 <__umoddi3+0xb3>
  801dc2:	66 90                	xchg   %ax,%ax
  801dc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dc8:	72 ea                	jb     801db4 <__umoddi3+0x134>
  801dca:	89 d9                	mov    %ebx,%ecx
  801dcc:	e9 62 ff ff ff       	jmp    801d33 <__umoddi3+0xb3>
