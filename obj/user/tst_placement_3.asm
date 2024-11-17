
obj/user/tst_placement_3:     file format elf32-i386


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
  800031:	e8 f6 03 00 00       	call   80042c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

#include <inc/lib.h>
extern uint32 initFreeFrames;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 80 00 00 01    	sub    $0x1000080,%esp

	int8 arr[PAGE_SIZE*1024*4];
	int x = 0;
  800043:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	//uint32 actual_active_list[13] = {0xedbfd000,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
	uint32 actual_active_list[13] ;
	{
		actual_active_list[0] = 0xedbfd000;
  80004a:	c7 85 94 ff ff fe 00 	movl   $0xedbfd000,-0x100006c(%ebp)
  800051:	d0 bf ed 
		actual_active_list[1] = 0xeebfd000;
  800054:	c7 85 98 ff ff fe 00 	movl   $0xeebfd000,-0x1000068(%ebp)
  80005b:	d0 bf ee 
		actual_active_list[2] = 0x803000;
  80005e:	c7 85 9c ff ff fe 00 	movl   $0x803000,-0x1000064(%ebp)
  800065:	30 80 00 
		actual_active_list[3] = 0x802000;
  800068:	c7 85 a0 ff ff fe 00 	movl   $0x802000,-0x1000060(%ebp)
  80006f:	20 80 00 
		actual_active_list[4] = 0x801000;
  800072:	c7 85 a4 ff ff fe 00 	movl   $0x801000,-0x100005c(%ebp)
  800079:	10 80 00 
		actual_active_list[5] = 0x800000;
  80007c:	c7 85 a8 ff ff fe 00 	movl   $0x800000,-0x1000058(%ebp)
  800083:	00 80 00 
		actual_active_list[6] = 0x205000;
  800086:	c7 85 ac ff ff fe 00 	movl   $0x205000,-0x1000054(%ebp)
  80008d:	50 20 00 
		actual_active_list[7] = 0x204000;
  800090:	c7 85 b0 ff ff fe 00 	movl   $0x204000,-0x1000050(%ebp)
  800097:	40 20 00 
		actual_active_list[8] = 0x203000;
  80009a:	c7 85 b4 ff ff fe 00 	movl   $0x203000,-0x100004c(%ebp)
  8000a1:	30 20 00 
		actual_active_list[9] = 0x202000;
  8000a4:	c7 85 b8 ff ff fe 00 	movl   $0x202000,-0x1000048(%ebp)
  8000ab:	20 20 00 
		actual_active_list[10] = 0x201000;
  8000ae:	c7 85 bc ff ff fe 00 	movl   $0x201000,-0x1000044(%ebp)
  8000b5:	10 20 00 
		actual_active_list[11] = 0x200000;
  8000b8:	c7 85 c0 ff ff fe 00 	movl   $0x200000,-0x1000040(%ebp)
  8000bf:	00 20 00 
	}
	uint32 actual_second_list[7] = {};
  8000c2:	8d 95 78 ff ff fe    	lea    -0x1000088(%ebp),%edx
  8000c8:	b9 07 00 00 00       	mov    $0x7,%ecx
  8000cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d2:	89 d7                	mov    %edx,%edi
  8000d4:	f3 ab                	rep stos %eax,%es:(%edi)
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000d6:	6a 00                	push   $0x0
  8000d8:	6a 0c                	push   $0xc
  8000da:	8d 85 78 ff ff fe    	lea    -0x1000088(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  8000e7:	50                   	push   %eax
  8000e8:	e8 06 1a 00 00       	call   801af3 <sys_check_LRU_lists>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(check == 0)
  8000f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8000f7:	75 14                	jne    80010d <_main+0xd5>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 60 1e 80 00       	push   $0x801e60
  800101:	6a 24                	push   $0x24
  800103:	68 e2 1e 80 00       	push   $0x801ee2
  800108:	e8 56 04 00 00       	call   800563 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010d:	e8 13 16 00 00       	call   801725 <sys_pf_calculate_allocated_pages>
  800112:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int freePages = sys_calculate_free_frames();
  800115:	e8 c0 15 00 00       	call   8016da <sys_calculate_free_frames>
  80011a:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int i=0;
  80011d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800124:	eb 11                	jmp    800137 <_main+0xff>
	{
		arr[i] = -1;
  800126:	8d 95 c8 ff ff fe    	lea    -0x1000038(%ebp),%edx
  80012c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80012f:	01 d0                	add    %edx,%eax
  800131:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  800134:	ff 45 f4             	incl   -0xc(%ebp)
  800137:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  80013e:	7e e6                	jle    800126 <_main+0xee>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  800140:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800147:	eb 11                	jmp    80015a <_main+0x122>
	{
		arr[i] = -1;
  800149:	8d 95 c8 ff ff fe    	lea    -0x1000038(%ebp),%edx
  80014f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800157:	ff 45 f4             	incl   -0xc(%ebp)
  80015a:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  800161:	7e e6                	jle    800149 <_main+0x111>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  800163:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80016a:	eb 11                	jmp    80017d <_main+0x145>
	{
		arr[i] = -1;
  80016c:	8d 95 c8 ff ff fe    	lea    -0x1000038(%ebp),%edx
  800172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800175:	01 d0                	add    %edx,%eax
  800177:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80017a:	ff 45 f4             	incl   -0xc(%ebp)
  80017d:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  800184:	7e e6                	jle    80016c <_main+0x134>
	{
		arr[i] = -1;
	}

	uint32* secondlistVA= (uint32*)0x200000;
  800186:	c7 45 d4 00 00 20 00 	movl   $0x200000,-0x2c(%ebp)
	x = x + *secondlistVA;
  80018d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800190:	8b 10                	mov    (%eax),%edx
  800192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800195:	01 d0                	add    %edx,%eax
  800197:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	secondlistVA = (uint32*) 0x202000;
  80019a:	c7 45 d4 00 20 20 00 	movl   $0x202000,-0x2c(%ebp)
	x = x + *secondlistVA;
  8001a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001a4:	8b 10                	mov    (%eax),%edx
  8001a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a9:	01 d0                	add    %edx,%eax
  8001ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	actual_second_list[0]=0X205000;
  8001ae:	c7 85 78 ff ff fe 00 	movl   $0x205000,-0x1000088(%ebp)
  8001b5:	50 20 00 
	actual_second_list[1]=0X204000;
  8001b8:	c7 85 7c ff ff fe 00 	movl   $0x204000,-0x1000084(%ebp)
  8001bf:	40 20 00 
	actual_second_list[2]=0x203000;
  8001c2:	c7 85 80 ff ff fe 00 	movl   $0x203000,-0x1000080(%ebp)
  8001c9:	30 20 00 
	actual_second_list[3]=0x201000;
  8001cc:	c7 85 84 ff ff fe 00 	movl   $0x201000,-0x100007c(%ebp)
  8001d3:	10 20 00 
	for (int i=12;i>6;i--)
  8001d6:	c7 45 f0 0c 00 00 00 	movl   $0xc,-0x10(%ebp)
  8001dd:	eb 1a                	jmp    8001f9 <_main+0x1c1>
		actual_active_list[i]=actual_active_list[i-7];
  8001df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e2:	83 e8 07             	sub    $0x7,%eax
  8001e5:	8b 94 85 94 ff ff fe 	mov    -0x100006c(%ebp,%eax,4),%edx
  8001ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ef:	89 94 85 94 ff ff fe 	mov    %edx,-0x100006c(%ebp,%eax,4)

	actual_second_list[0]=0X205000;
	actual_second_list[1]=0X204000;
	actual_second_list[2]=0x203000;
	actual_second_list[3]=0x201000;
	for (int i=12;i>6;i--)
  8001f6:	ff 4d f0             	decl   -0x10(%ebp)
  8001f9:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
  8001fd:	7f e0                	jg     8001df <_main+0x1a7>
		actual_active_list[i]=actual_active_list[i-7];

	actual_active_list[0]=0x202000;
  8001ff:	c7 85 94 ff ff fe 00 	movl   $0x202000,-0x100006c(%ebp)
  800206:	20 20 00 
	actual_active_list[1]=0x200000;
  800209:	c7 85 98 ff ff fe 00 	movl   $0x200000,-0x1000068(%ebp)
  800210:	00 20 00 
	actual_active_list[2]=0xee3fe000;
  800213:	c7 85 9c ff ff fe 00 	movl   $0xee3fe000,-0x1000064(%ebp)
  80021a:	e0 3f ee 
	actual_active_list[3]=0xee3fd000;
  80021d:	c7 85 a0 ff ff fe 00 	movl   $0xee3fd000,-0x1000060(%ebp)
  800224:	d0 3f ee 
	actual_active_list[4]=0xedffe000;
  800227:	c7 85 a4 ff ff fe 00 	movl   $0xedffe000,-0x100005c(%ebp)
  80022e:	e0 ff ed 
	actual_active_list[5]=0xedffd000;
  800231:	c7 85 a8 ff ff fe 00 	movl   $0xedffd000,-0x1000058(%ebp)
  800238:	d0 ff ed 
	actual_active_list[6]=0xedbfe000;
  80023b:	c7 85 ac ff ff fe 00 	movl   $0xedbfe000,-0x1000054(%ebp)
  800242:	e0 bf ed 

	int eval = 0;
  800245:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	bool is_correct = 1;
  80024c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)

	uint32 expected, actual ;
	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	68 fc 1e 80 00       	push   $0x801efc
  80025b:	e8 c0 05 00 00       	call   800820 <cprintf>
  800260:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800263:	8a 85 c8 ff ff fe    	mov    -0x1000038(%ebp),%al
  800269:	3c ff                	cmp    $0xff,%al
  80026b:	74 17                	je     800284 <_main+0x24c>
  80026d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	68 2c 1f 80 00       	push   $0x801f2c
  80027c:	e8 9f 05 00 00       	call   800820 <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800284:	8a 85 c8 0f 00 ff    	mov    -0xfff038(%ebp),%al
  80028a:	3c ff                	cmp    $0xff,%al
  80028c:	74 17                	je     8002a5 <_main+0x26d>
  80028e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 2c 1f 80 00       	push   $0x801f2c
  80029d:	e8 7e 05 00 00       	call   800820 <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8002a5:	8a 85 c8 ff 3f ff    	mov    -0xc00038(%ebp),%al
  8002ab:	3c ff                	cmp    $0xff,%al
  8002ad:	74 17                	je     8002c6 <_main+0x28e>
  8002af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	68 2c 1f 80 00       	push   $0x801f2c
  8002be:	e8 5d 05 00 00       	call   800820 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8002c6:	8a 85 c8 0f 40 ff    	mov    -0xbff038(%ebp),%al
  8002cc:	3c ff                	cmp    $0xff,%al
  8002ce:	74 17                	je     8002e7 <_main+0x2af>
  8002d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 2c 1f 80 00       	push   $0x801f2c
  8002df:	e8 3c 05 00 00       	call   800820 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8002e7:	8a 85 c8 ff 7f ff    	mov    -0x800038(%ebp),%al
  8002ed:	3c ff                	cmp    $0xff,%al
  8002ef:	74 17                	je     800308 <_main+0x2d0>
  8002f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002f8:	83 ec 0c             	sub    $0xc,%esp
  8002fb:	68 2c 1f 80 00       	push   $0x801f2c
  800300:	e8 1b 05 00 00       	call   800820 <cprintf>
  800305:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800308:	8a 85 c8 0f 80 ff    	mov    -0x7ff038(%ebp),%al
  80030e:	3c ff                	cmp    $0xff,%al
  800310:	74 17                	je     800329 <_main+0x2f1>
  800312:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	68 2c 1f 80 00       	push   $0x801f2c
  800321:	e8 fa 04 00 00       	call   800820 <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT written to Page File until it's replaced\n"); }
  800329:	e8 f7 13 00 00       	call   801725 <sys_pf_calculate_allocated_pages>
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	74 17                	je     80034a <_main+0x312>
  800333:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80033a:	83 ec 0c             	sub    $0xc,%esp
  80033d:	68 4c 1f 80 00       	push   $0x801f4c
  800342:	e8 d9 04 00 00       	call   800820 <cprintf>
  800347:	83 c4 10             	add    $0x10,%esp

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  80034a:	c7 45 d0 07 00 00 00 	movl   $0x7,-0x30(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  800351:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800354:	e8 81 13 00 00       	call   8016da <sys_calculate_free_frames>
  800359:	29 c3                	sub    %eax,%ebx
  80035b:	89 d8                	mov    %ebx,%eax
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//actual = (initFreeFrames - sys_calculate_free_frames()) ;
		if(actual != expected) { is_correct = 0; cprintf("allocated memory size incorrect. Expected = %d, Actual = %d\n", expected, actual); }
  800360:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800363:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800366:	74 1d                	je     800385 <_main+0x34d>
  800368:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	ff 75 cc             	pushl  -0x34(%ebp)
  800375:	ff 75 d0             	pushl  -0x30(%ebp)
  800378:	68 94 1f 80 00       	push   $0x801f94
  80037d:	e8 9e 04 00 00       	call   800820 <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  800385:	83 ec 0c             	sub    $0xc,%esp
  800388:	68 d4 1f 80 00       	push   $0x801fd4
  80038d:	e8 8e 04 00 00       	call   800820 <cprintf>
  800392:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  800395:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800399:	74 04                	je     80039f <_main+0x367>
		eval += 50 ;
  80039b:	83 45 ec 32          	addl   $0x32,-0x14(%ebp)
	is_correct = 1;
  80039f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)

	cprintf("STEP B: checking LRU lists entries After Required PAGES IN SECOND LIST...\n");
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 08 20 80 00       	push   $0x802008
  8003ae:	e8 6d 04 00 00       	call   800820 <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  8003b6:	6a 04                	push   $0x4
  8003b8:	6a 0d                	push   $0xd
  8003ba:	8d 85 78 ff ff fe    	lea    -0x1000088(%ebp),%eax
  8003c0:	50                   	push   %eax
  8003c1:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 26 17 00 00       	call   801af3 <sys_check_LRU_lists>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if(check == 0)
  8003d3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8003d7:	75 17                	jne    8003f0 <_main+0x3b8>
			{ is_correct = 0; cprintf("LRU lists entries are not correct, check your logic again!!\n"); }
  8003d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003e0:	83 ec 0c             	sub    $0xc,%esp
  8003e3:	68 54 20 80 00       	push   $0x802054
  8003e8:	e8 33 04 00 00       	call   800820 <cprintf>
  8003ed:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B passed: checking LRU lists entries After Required PAGES IN SECOND LIST test are correct\n\n\n");
  8003f0:	83 ec 0c             	sub    $0xc,%esp
  8003f3:	68 94 20 80 00       	push   $0x802094
  8003f8:	e8 23 04 00 00       	call   800820 <cprintf>
  8003fd:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  800400:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800404:	74 04                	je     80040a <_main+0x3d2>
		eval += 50 ;
  800406:	83 45 ec 32          	addl   $0x32,-0x14(%ebp)
	is_correct = 1;
  80040a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)

	cprintf("Congratulations!! Test of PAGE PLACEMENT THIRD SCENARIO completed. Eval = %d\n\n\n", eval);
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	ff 75 ec             	pushl  -0x14(%ebp)
  800417:	68 f8 20 80 00       	push   $0x8020f8
  80041c:	e8 ff 03 00 00       	call   800820 <cprintf>
  800421:	83 c4 10             	add    $0x10,%esp
	return;
  800424:	90                   	nop
}
  800425:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800428:	5b                   	pop    %ebx
  800429:	5f                   	pop    %edi
  80042a:	5d                   	pop    %ebp
  80042b:	c3                   	ret    

0080042c <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800432:	e8 6c 14 00 00       	call   8018a3 <sys_getenvindex>
  800437:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80043a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	c1 e0 02             	shl    $0x2,%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	01 c0                	add    %eax,%eax
  800446:	01 d0                	add    %edx,%eax
  800448:	c1 e0 02             	shl    $0x2,%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	01 c0                	add    %eax,%eax
  80044f:	01 d0                	add    %edx,%eax
  800451:	c1 e0 04             	shl    $0x4,%eax
  800454:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800459:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80045e:	a1 04 30 80 00       	mov    0x803004,%eax
  800463:	8a 40 20             	mov    0x20(%eax),%al
  800466:	84 c0                	test   %al,%al
  800468:	74 0d                	je     800477 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80046a:	a1 04 30 80 00       	mov    0x803004,%eax
  80046f:	83 c0 20             	add    $0x20,%eax
  800472:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800477:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80047b:	7e 0a                	jle    800487 <libmain+0x5b>
		binaryname = argv[0];
  80047d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800487:	83 ec 08             	sub    $0x8,%esp
  80048a:	ff 75 0c             	pushl  0xc(%ebp)
  80048d:	ff 75 08             	pushl  0x8(%ebp)
  800490:	e8 a3 fb ff ff       	call   800038 <_main>
  800495:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800498:	e8 8a 11 00 00       	call   801627 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80049d:	83 ec 0c             	sub    $0xc,%esp
  8004a0:	68 60 21 80 00       	push   $0x802160
  8004a5:	e8 76 03 00 00       	call   800820 <cprintf>
  8004aa:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8004b2:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8004b8:	a1 04 30 80 00       	mov    0x803004,%eax
  8004bd:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8004c3:	83 ec 04             	sub    $0x4,%esp
  8004c6:	52                   	push   %edx
  8004c7:	50                   	push   %eax
  8004c8:	68 88 21 80 00       	push   $0x802188
  8004cd:	e8 4e 03 00 00       	call   800820 <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004d5:	a1 04 30 80 00       	mov    0x803004,%eax
  8004da:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8004e0:	a1 04 30 80 00       	mov    0x803004,%eax
  8004e5:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8004eb:	a1 04 30 80 00       	mov    0x803004,%eax
  8004f0:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8004f6:	51                   	push   %ecx
  8004f7:	52                   	push   %edx
  8004f8:	50                   	push   %eax
  8004f9:	68 b0 21 80 00       	push   $0x8021b0
  8004fe:	e8 1d 03 00 00       	call   800820 <cprintf>
  800503:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800506:	a1 04 30 80 00       	mov    0x803004,%eax
  80050b:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800511:	83 ec 08             	sub    $0x8,%esp
  800514:	50                   	push   %eax
  800515:	68 08 22 80 00       	push   $0x802208
  80051a:	e8 01 03 00 00       	call   800820 <cprintf>
  80051f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800522:	83 ec 0c             	sub    $0xc,%esp
  800525:	68 60 21 80 00       	push   $0x802160
  80052a:	e8 f1 02 00 00       	call   800820 <cprintf>
  80052f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800532:	e8 0a 11 00 00       	call   801641 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800537:	e8 19 00 00 00       	call   800555 <exit>
}
  80053c:	90                   	nop
  80053d:	c9                   	leave  
  80053e:	c3                   	ret    

0080053f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80053f:	55                   	push   %ebp
  800540:	89 e5                	mov    %esp,%ebp
  800542:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800545:	83 ec 0c             	sub    $0xc,%esp
  800548:	6a 00                	push   $0x0
  80054a:	e8 20 13 00 00       	call   80186f <sys_destroy_env>
  80054f:	83 c4 10             	add    $0x10,%esp
}
  800552:	90                   	nop
  800553:	c9                   	leave  
  800554:	c3                   	ret    

00800555 <exit>:

void
exit(void)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80055b:	e8 75 13 00 00       	call   8018d5 <sys_exit_env>
}
  800560:	90                   	nop
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800569:	8d 45 10             	lea    0x10(%ebp),%eax
  80056c:	83 c0 04             	add    $0x4,%eax
  80056f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800572:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800577:	85 c0                	test   %eax,%eax
  800579:	74 16                	je     800591 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80057b:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	50                   	push   %eax
  800584:	68 1c 22 80 00       	push   $0x80221c
  800589:	e8 92 02 00 00       	call   800820 <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800591:	a1 00 30 80 00       	mov    0x803000,%eax
  800596:	ff 75 0c             	pushl  0xc(%ebp)
  800599:	ff 75 08             	pushl  0x8(%ebp)
  80059c:	50                   	push   %eax
  80059d:	68 21 22 80 00       	push   $0x802221
  8005a2:	e8 79 02 00 00       	call   800820 <cprintf>
  8005a7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ad:	83 ec 08             	sub    $0x8,%esp
  8005b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b3:	50                   	push   %eax
  8005b4:	e8 fc 01 00 00       	call   8007b5 <vcprintf>
  8005b9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	6a 00                	push   $0x0
  8005c1:	68 3d 22 80 00       	push   $0x80223d
  8005c6:	e8 ea 01 00 00       	call   8007b5 <vcprintf>
  8005cb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005ce:	e8 82 ff ff ff       	call   800555 <exit>

	// should not return here
	while (1) ;
  8005d3:	eb fe                	jmp    8005d3 <_panic+0x70>

008005d5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
  8005d8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005db:	a1 04 30 80 00       	mov    0x803004,%eax
  8005e0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e9:	39 c2                	cmp    %eax,%edx
  8005eb:	74 14                	je     800601 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005ed:	83 ec 04             	sub    $0x4,%esp
  8005f0:	68 40 22 80 00       	push   $0x802240
  8005f5:	6a 26                	push   $0x26
  8005f7:	68 8c 22 80 00       	push   $0x80228c
  8005fc:	e8 62 ff ff ff       	call   800563 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800601:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800608:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060f:	e9 c5 00 00 00       	jmp    8006d9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800617:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	01 d0                	add    %edx,%eax
  800623:	8b 00                	mov    (%eax),%eax
  800625:	85 c0                	test   %eax,%eax
  800627:	75 08                	jne    800631 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800629:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80062c:	e9 a5 00 00 00       	jmp    8006d6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800631:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800638:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80063f:	eb 69                	jmp    8006aa <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800641:	a1 04 30 80 00       	mov    0x803004,%eax
  800646:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80064c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80064f:	89 d0                	mov    %edx,%eax
  800651:	01 c0                	add    %eax,%eax
  800653:	01 d0                	add    %edx,%eax
  800655:	c1 e0 03             	shl    $0x3,%eax
  800658:	01 c8                	add    %ecx,%eax
  80065a:	8a 40 04             	mov    0x4(%eax),%al
  80065d:	84 c0                	test   %al,%al
  80065f:	75 46                	jne    8006a7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800661:	a1 04 30 80 00       	mov    0x803004,%eax
  800666:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80066c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80066f:	89 d0                	mov    %edx,%eax
  800671:	01 c0                	add    %eax,%eax
  800673:	01 d0                	add    %edx,%eax
  800675:	c1 e0 03             	shl    $0x3,%eax
  800678:	01 c8                	add    %ecx,%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80067f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800682:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800687:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800689:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80068c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	01 c8                	add    %ecx,%eax
  800698:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80069a:	39 c2                	cmp    %eax,%edx
  80069c:	75 09                	jne    8006a7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80069e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006a5:	eb 15                	jmp    8006bc <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a7:	ff 45 e8             	incl   -0x18(%ebp)
  8006aa:	a1 04 30 80 00       	mov    0x803004,%eax
  8006af:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006b8:	39 c2                	cmp    %eax,%edx
  8006ba:	77 85                	ja     800641 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006c0:	75 14                	jne    8006d6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006c2:	83 ec 04             	sub    $0x4,%esp
  8006c5:	68 98 22 80 00       	push   $0x802298
  8006ca:	6a 3a                	push   $0x3a
  8006cc:	68 8c 22 80 00       	push   $0x80228c
  8006d1:	e8 8d fe ff ff       	call   800563 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006d6:	ff 45 f0             	incl   -0x10(%ebp)
  8006d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006df:	0f 8c 2f ff ff ff    	jl     800614 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006ec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006f3:	eb 26                	jmp    80071b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006f5:	a1 04 30 80 00       	mov    0x803004,%eax
  8006fa:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800700:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800703:	89 d0                	mov    %edx,%eax
  800705:	01 c0                	add    %eax,%eax
  800707:	01 d0                	add    %edx,%eax
  800709:	c1 e0 03             	shl    $0x3,%eax
  80070c:	01 c8                	add    %ecx,%eax
  80070e:	8a 40 04             	mov    0x4(%eax),%al
  800711:	3c 01                	cmp    $0x1,%al
  800713:	75 03                	jne    800718 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800715:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800718:	ff 45 e0             	incl   -0x20(%ebp)
  80071b:	a1 04 30 80 00       	mov    0x803004,%eax
  800720:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800726:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800729:	39 c2                	cmp    %eax,%edx
  80072b:	77 c8                	ja     8006f5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80072d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800730:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800733:	74 14                	je     800749 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800735:	83 ec 04             	sub    $0x4,%esp
  800738:	68 ec 22 80 00       	push   $0x8022ec
  80073d:	6a 44                	push   $0x44
  80073f:	68 8c 22 80 00       	push   $0x80228c
  800744:	e8 1a fe ff ff       	call   800563 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800749:	90                   	nop
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    

0080074c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80074c:	55                   	push   %ebp
  80074d:	89 e5                	mov    %esp,%ebp
  80074f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800752:	8b 45 0c             	mov    0xc(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	8d 48 01             	lea    0x1(%eax),%ecx
  80075a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80075d:	89 0a                	mov    %ecx,(%edx)
  80075f:	8b 55 08             	mov    0x8(%ebp),%edx
  800762:	88 d1                	mov    %dl,%cl
  800764:	8b 55 0c             	mov    0xc(%ebp),%edx
  800767:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80076b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	3d ff 00 00 00       	cmp    $0xff,%eax
  800775:	75 2c                	jne    8007a3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800777:	a0 08 30 80 00       	mov    0x803008,%al
  80077c:	0f b6 c0             	movzbl %al,%eax
  80077f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800782:	8b 12                	mov    (%edx),%edx
  800784:	89 d1                	mov    %edx,%ecx
  800786:	8b 55 0c             	mov    0xc(%ebp),%edx
  800789:	83 c2 08             	add    $0x8,%edx
  80078c:	83 ec 04             	sub    $0x4,%esp
  80078f:	50                   	push   %eax
  800790:	51                   	push   %ecx
  800791:	52                   	push   %edx
  800792:	e8 4e 0e 00 00       	call   8015e5 <sys_cputs>
  800797:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80079a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a6:	8b 40 04             	mov    0x4(%eax),%eax
  8007a9:	8d 50 01             	lea    0x1(%eax),%edx
  8007ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007af:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007b2:	90                   	nop
  8007b3:	c9                   	leave  
  8007b4:	c3                   	ret    

008007b5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007c5:	00 00 00 
	b.cnt = 0;
  8007c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007cf:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007d2:	ff 75 0c             	pushl  0xc(%ebp)
  8007d5:	ff 75 08             	pushl  0x8(%ebp)
  8007d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007de:	50                   	push   %eax
  8007df:	68 4c 07 80 00       	push   $0x80074c
  8007e4:	e8 11 02 00 00       	call   8009fa <vprintfmt>
  8007e9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007ec:	a0 08 30 80 00       	mov    0x803008,%al
  8007f1:	0f b6 c0             	movzbl %al,%eax
  8007f4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007fa:	83 ec 04             	sub    $0x4,%esp
  8007fd:	50                   	push   %eax
  8007fe:	52                   	push   %edx
  8007ff:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800805:	83 c0 08             	add    $0x8,%eax
  800808:	50                   	push   %eax
  800809:	e8 d7 0d 00 00       	call   8015e5 <sys_cputs>
  80080e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800811:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800818:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80081e:	c9                   	leave  
  80081f:	c3                   	ret    

00800820 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800826:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80082d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800830:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	ff 75 f4             	pushl  -0xc(%ebp)
  80083c:	50                   	push   %eax
  80083d:	e8 73 ff ff ff       	call   8007b5 <vcprintf>
  800842:	83 c4 10             	add    $0x10,%esp
  800845:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800848:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80084b:	c9                   	leave  
  80084c:	c3                   	ret    

0080084d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80084d:	55                   	push   %ebp
  80084e:	89 e5                	mov    %esp,%ebp
  800850:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800853:	e8 cf 0d 00 00       	call   801627 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800858:	8d 45 0c             	lea    0xc(%ebp),%eax
  80085b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	ff 75 f4             	pushl  -0xc(%ebp)
  800867:	50                   	push   %eax
  800868:	e8 48 ff ff ff       	call   8007b5 <vcprintf>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800873:	e8 c9 0d 00 00       	call   801641 <sys_unlock_cons>
	return cnt;
  800878:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80087b:	c9                   	leave  
  80087c:	c3                   	ret    

0080087d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	53                   	push   %ebx
  800881:	83 ec 14             	sub    $0x14,%esp
  800884:	8b 45 10             	mov    0x10(%ebp),%eax
  800887:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088a:	8b 45 14             	mov    0x14(%ebp),%eax
  80088d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800890:	8b 45 18             	mov    0x18(%ebp),%eax
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80089b:	77 55                	ja     8008f2 <printnum+0x75>
  80089d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008a0:	72 05                	jb     8008a7 <printnum+0x2a>
  8008a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008a5:	77 4b                	ja     8008f2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008a7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008aa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008ad:	8b 45 18             	mov    0x18(%ebp),%eax
  8008b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b5:	52                   	push   %edx
  8008b6:	50                   	push   %eax
  8008b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8008bd:	e8 22 13 00 00       	call   801be4 <__udivdi3>
  8008c2:	83 c4 10             	add    $0x10,%esp
  8008c5:	83 ec 04             	sub    $0x4,%esp
  8008c8:	ff 75 20             	pushl  0x20(%ebp)
  8008cb:	53                   	push   %ebx
  8008cc:	ff 75 18             	pushl  0x18(%ebp)
  8008cf:	52                   	push   %edx
  8008d0:	50                   	push   %eax
  8008d1:	ff 75 0c             	pushl  0xc(%ebp)
  8008d4:	ff 75 08             	pushl  0x8(%ebp)
  8008d7:	e8 a1 ff ff ff       	call   80087d <printnum>
  8008dc:	83 c4 20             	add    $0x20,%esp
  8008df:	eb 1a                	jmp    8008fb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008e1:	83 ec 08             	sub    $0x8,%esp
  8008e4:	ff 75 0c             	pushl  0xc(%ebp)
  8008e7:	ff 75 20             	pushl  0x20(%ebp)
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	ff d0                	call   *%eax
  8008ef:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008f2:	ff 4d 1c             	decl   0x1c(%ebp)
  8008f5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008f9:	7f e6                	jg     8008e1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008fb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800906:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800909:	53                   	push   %ebx
  80090a:	51                   	push   %ecx
  80090b:	52                   	push   %edx
  80090c:	50                   	push   %eax
  80090d:	e8 e2 13 00 00       	call   801cf4 <__umoddi3>
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	05 54 25 80 00       	add    $0x802554,%eax
  80091a:	8a 00                	mov    (%eax),%al
  80091c:	0f be c0             	movsbl %al,%eax
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	50                   	push   %eax
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	ff d0                	call   *%eax
  80092b:	83 c4 10             	add    $0x10,%esp
}
  80092e:	90                   	nop
  80092f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800932:	c9                   	leave  
  800933:	c3                   	ret    

00800934 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800937:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80093b:	7e 1c                	jle    800959 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	8d 50 08             	lea    0x8(%eax),%edx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 10                	mov    %edx,(%eax)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 e8 08             	sub    $0x8,%eax
  800952:	8b 50 04             	mov    0x4(%eax),%edx
  800955:	8b 00                	mov    (%eax),%eax
  800957:	eb 40                	jmp    800999 <getuint+0x65>
	else if (lflag)
  800959:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80095d:	74 1e                	je     80097d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 00                	mov    (%eax),%eax
  800964:	8d 50 04             	lea    0x4(%eax),%edx
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	89 10                	mov    %edx,(%eax)
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	8b 00                	mov    (%eax),%eax
  800971:	83 e8 04             	sub    $0x4,%eax
  800974:	8b 00                	mov    (%eax),%eax
  800976:	ba 00 00 00 00       	mov    $0x0,%edx
  80097b:	eb 1c                	jmp    800999 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	8b 00                	mov    (%eax),%eax
  800982:	8d 50 04             	lea    0x4(%eax),%edx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	89 10                	mov    %edx,(%eax)
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	83 e8 04             	sub    $0x4,%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80099e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009a2:	7e 1c                	jle    8009c0 <getint+0x25>
		return va_arg(*ap, long long);
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	8d 50 08             	lea    0x8(%eax),%edx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	89 10                	mov    %edx,(%eax)
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	83 e8 08             	sub    $0x8,%eax
  8009b9:	8b 50 04             	mov    0x4(%eax),%edx
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	eb 38                	jmp    8009f8 <getint+0x5d>
	else if (lflag)
  8009c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009c4:	74 1a                	je     8009e0 <getint+0x45>
		return va_arg(*ap, long);
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	8d 50 04             	lea    0x4(%eax),%edx
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	89 10                	mov    %edx,(%eax)
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8b 00                	mov    (%eax),%eax
  8009d8:	83 e8 04             	sub    $0x4,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	99                   	cltd   
  8009de:	eb 18                	jmp    8009f8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	8b 00                	mov    (%eax),%eax
  8009e5:	8d 50 04             	lea    0x4(%eax),%edx
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	89 10                	mov    %edx,(%eax)
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	83 e8 04             	sub    $0x4,%eax
  8009f5:	8b 00                	mov    (%eax),%eax
  8009f7:	99                   	cltd   
}
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	56                   	push   %esi
  8009fe:	53                   	push   %ebx
  8009ff:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a02:	eb 17                	jmp    800a1b <vprintfmt+0x21>
			if (ch == '\0')
  800a04:	85 db                	test   %ebx,%ebx
  800a06:	0f 84 c1 03 00 00    	je     800dcd <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a0c:	83 ec 08             	sub    $0x8,%esp
  800a0f:	ff 75 0c             	pushl  0xc(%ebp)
  800a12:	53                   	push   %ebx
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1e:	8d 50 01             	lea    0x1(%eax),%edx
  800a21:	89 55 10             	mov    %edx,0x10(%ebp)
  800a24:	8a 00                	mov    (%eax),%al
  800a26:	0f b6 d8             	movzbl %al,%ebx
  800a29:	83 fb 25             	cmp    $0x25,%ebx
  800a2c:	75 d6                	jne    800a04 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a2e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a32:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a39:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a40:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a47:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a51:	8d 50 01             	lea    0x1(%eax),%edx
  800a54:	89 55 10             	mov    %edx,0x10(%ebp)
  800a57:	8a 00                	mov    (%eax),%al
  800a59:	0f b6 d8             	movzbl %al,%ebx
  800a5c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a5f:	83 f8 5b             	cmp    $0x5b,%eax
  800a62:	0f 87 3d 03 00 00    	ja     800da5 <vprintfmt+0x3ab>
  800a68:	8b 04 85 78 25 80 00 	mov    0x802578(,%eax,4),%eax
  800a6f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a71:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a75:	eb d7                	jmp    800a4e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a77:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a7b:	eb d1                	jmp    800a4e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a7d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a84:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a87:	89 d0                	mov    %edx,%eax
  800a89:	c1 e0 02             	shl    $0x2,%eax
  800a8c:	01 d0                	add    %edx,%eax
  800a8e:	01 c0                	add    %eax,%eax
  800a90:	01 d8                	add    %ebx,%eax
  800a92:	83 e8 30             	sub    $0x30,%eax
  800a95:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a98:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9b:	8a 00                	mov    (%eax),%al
  800a9d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aa0:	83 fb 2f             	cmp    $0x2f,%ebx
  800aa3:	7e 3e                	jle    800ae3 <vprintfmt+0xe9>
  800aa5:	83 fb 39             	cmp    $0x39,%ebx
  800aa8:	7f 39                	jg     800ae3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aaa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800aad:	eb d5                	jmp    800a84 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	83 c0 04             	add    $0x4,%eax
  800ab5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab8:	8b 45 14             	mov    0x14(%ebp),%eax
  800abb:	83 e8 04             	sub    $0x4,%eax
  800abe:	8b 00                	mov    (%eax),%eax
  800ac0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ac3:	eb 1f                	jmp    800ae4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ac5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac9:	79 83                	jns    800a4e <vprintfmt+0x54>
				width = 0;
  800acb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ad2:	e9 77 ff ff ff       	jmp    800a4e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ad7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ade:	e9 6b ff ff ff       	jmp    800a4e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ae3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ae4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ae8:	0f 89 60 ff ff ff    	jns    800a4e <vprintfmt+0x54>
				width = precision, precision = -1;
  800aee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800af4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800afb:	e9 4e ff ff ff       	jmp    800a4e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b00:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b03:	e9 46 ff ff ff       	jmp    800a4e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b08:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0b:	83 c0 04             	add    $0x4,%eax
  800b0e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b11:	8b 45 14             	mov    0x14(%ebp),%eax
  800b14:	83 e8 04             	sub    $0x4,%eax
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	50                   	push   %eax
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	ff d0                	call   *%eax
  800b25:	83 c4 10             	add    $0x10,%esp
			break;
  800b28:	e9 9b 02 00 00       	jmp    800dc8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b30:	83 c0 04             	add    $0x4,%eax
  800b33:	89 45 14             	mov    %eax,0x14(%ebp)
  800b36:	8b 45 14             	mov    0x14(%ebp),%eax
  800b39:	83 e8 04             	sub    $0x4,%eax
  800b3c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b3e:	85 db                	test   %ebx,%ebx
  800b40:	79 02                	jns    800b44 <vprintfmt+0x14a>
				err = -err;
  800b42:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b44:	83 fb 64             	cmp    $0x64,%ebx
  800b47:	7f 0b                	jg     800b54 <vprintfmt+0x15a>
  800b49:	8b 34 9d c0 23 80 00 	mov    0x8023c0(,%ebx,4),%esi
  800b50:	85 f6                	test   %esi,%esi
  800b52:	75 19                	jne    800b6d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b54:	53                   	push   %ebx
  800b55:	68 65 25 80 00       	push   $0x802565
  800b5a:	ff 75 0c             	pushl  0xc(%ebp)
  800b5d:	ff 75 08             	pushl  0x8(%ebp)
  800b60:	e8 70 02 00 00       	call   800dd5 <printfmt>
  800b65:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b68:	e9 5b 02 00 00       	jmp    800dc8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b6d:	56                   	push   %esi
  800b6e:	68 6e 25 80 00       	push   $0x80256e
  800b73:	ff 75 0c             	pushl  0xc(%ebp)
  800b76:	ff 75 08             	pushl  0x8(%ebp)
  800b79:	e8 57 02 00 00       	call   800dd5 <printfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp
			break;
  800b81:	e9 42 02 00 00       	jmp    800dc8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	83 c0 04             	add    $0x4,%eax
  800b8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b92:	83 e8 04             	sub    $0x4,%eax
  800b95:	8b 30                	mov    (%eax),%esi
  800b97:	85 f6                	test   %esi,%esi
  800b99:	75 05                	jne    800ba0 <vprintfmt+0x1a6>
				p = "(null)";
  800b9b:	be 71 25 80 00       	mov    $0x802571,%esi
			if (width > 0 && padc != '-')
  800ba0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ba4:	7e 6d                	jle    800c13 <vprintfmt+0x219>
  800ba6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800baa:	74 67                	je     800c13 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800baf:	83 ec 08             	sub    $0x8,%esp
  800bb2:	50                   	push   %eax
  800bb3:	56                   	push   %esi
  800bb4:	e8 1e 03 00 00       	call   800ed7 <strnlen>
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bbf:	eb 16                	jmp    800bd7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bc1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bc5:	83 ec 08             	sub    $0x8,%esp
  800bc8:	ff 75 0c             	pushl  0xc(%ebp)
  800bcb:	50                   	push   %eax
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	ff d0                	call   *%eax
  800bd1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bd4:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bdb:	7f e4                	jg     800bc1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bdd:	eb 34                	jmp    800c13 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bdf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800be3:	74 1c                	je     800c01 <vprintfmt+0x207>
  800be5:	83 fb 1f             	cmp    $0x1f,%ebx
  800be8:	7e 05                	jle    800bef <vprintfmt+0x1f5>
  800bea:	83 fb 7e             	cmp    $0x7e,%ebx
  800bed:	7e 12                	jle    800c01 <vprintfmt+0x207>
					putch('?', putdat);
  800bef:	83 ec 08             	sub    $0x8,%esp
  800bf2:	ff 75 0c             	pushl  0xc(%ebp)
  800bf5:	6a 3f                	push   $0x3f
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	ff d0                	call   *%eax
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	eb 0f                	jmp    800c10 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 0c             	pushl  0xc(%ebp)
  800c07:	53                   	push   %ebx
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	ff d0                	call   *%eax
  800c0d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c10:	ff 4d e4             	decl   -0x1c(%ebp)
  800c13:	89 f0                	mov    %esi,%eax
  800c15:	8d 70 01             	lea    0x1(%eax),%esi
  800c18:	8a 00                	mov    (%eax),%al
  800c1a:	0f be d8             	movsbl %al,%ebx
  800c1d:	85 db                	test   %ebx,%ebx
  800c1f:	74 24                	je     800c45 <vprintfmt+0x24b>
  800c21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c25:	78 b8                	js     800bdf <vprintfmt+0x1e5>
  800c27:	ff 4d e0             	decl   -0x20(%ebp)
  800c2a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c2e:	79 af                	jns    800bdf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c30:	eb 13                	jmp    800c45 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	6a 20                	push   $0x20
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c42:	ff 4d e4             	decl   -0x1c(%ebp)
  800c45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c49:	7f e7                	jg     800c32 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c4b:	e9 78 01 00 00       	jmp    800dc8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 e8             	pushl  -0x18(%ebp)
  800c56:	8d 45 14             	lea    0x14(%ebp),%eax
  800c59:	50                   	push   %eax
  800c5a:	e8 3c fd ff ff       	call   80099b <getint>
  800c5f:	83 c4 10             	add    $0x10,%esp
  800c62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c6e:	85 d2                	test   %edx,%edx
  800c70:	79 23                	jns    800c95 <vprintfmt+0x29b>
				putch('-', putdat);
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	6a 2d                	push   $0x2d
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	ff d0                	call   *%eax
  800c7f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c88:	f7 d8                	neg    %eax
  800c8a:	83 d2 00             	adc    $0x0,%edx
  800c8d:	f7 da                	neg    %edx
  800c8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c95:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c9c:	e9 bc 00 00 00       	jmp    800d5d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ca1:	83 ec 08             	sub    $0x8,%esp
  800ca4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ca7:	8d 45 14             	lea    0x14(%ebp),%eax
  800caa:	50                   	push   %eax
  800cab:	e8 84 fc ff ff       	call   800934 <getuint>
  800cb0:	83 c4 10             	add    $0x10,%esp
  800cb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cb9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cc0:	e9 98 00 00 00       	jmp    800d5d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cc5:	83 ec 08             	sub    $0x8,%esp
  800cc8:	ff 75 0c             	pushl  0xc(%ebp)
  800ccb:	6a 58                	push   $0x58
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	ff d0                	call   *%eax
  800cd2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cd5:	83 ec 08             	sub    $0x8,%esp
  800cd8:	ff 75 0c             	pushl  0xc(%ebp)
  800cdb:	6a 58                	push   $0x58
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	ff d0                	call   *%eax
  800ce2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ce5:	83 ec 08             	sub    $0x8,%esp
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	6a 58                	push   $0x58
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	ff d0                	call   *%eax
  800cf2:	83 c4 10             	add    $0x10,%esp
			break;
  800cf5:	e9 ce 00 00 00       	jmp    800dc8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cfa:	83 ec 08             	sub    $0x8,%esp
  800cfd:	ff 75 0c             	pushl  0xc(%ebp)
  800d00:	6a 30                	push   $0x30
  800d02:	8b 45 08             	mov    0x8(%ebp),%eax
  800d05:	ff d0                	call   *%eax
  800d07:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d0a:	83 ec 08             	sub    $0x8,%esp
  800d0d:	ff 75 0c             	pushl  0xc(%ebp)
  800d10:	6a 78                	push   $0x78
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	ff d0                	call   *%eax
  800d17:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	83 c0 04             	add    $0x4,%eax
  800d20:	89 45 14             	mov    %eax,0x14(%ebp)
  800d23:	8b 45 14             	mov    0x14(%ebp),%eax
  800d26:	83 e8 04             	sub    $0x4,%eax
  800d29:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d35:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d3c:	eb 1f                	jmp    800d5d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 e8             	pushl  -0x18(%ebp)
  800d44:	8d 45 14             	lea    0x14(%ebp),%eax
  800d47:	50                   	push   %eax
  800d48:	e8 e7 fb ff ff       	call   800934 <getuint>
  800d4d:	83 c4 10             	add    $0x10,%esp
  800d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d56:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d5d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d64:	83 ec 04             	sub    $0x4,%esp
  800d67:	52                   	push   %edx
  800d68:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d6b:	50                   	push   %eax
  800d6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6f:	ff 75 f0             	pushl  -0x10(%ebp)
  800d72:	ff 75 0c             	pushl  0xc(%ebp)
  800d75:	ff 75 08             	pushl  0x8(%ebp)
  800d78:	e8 00 fb ff ff       	call   80087d <printnum>
  800d7d:	83 c4 20             	add    $0x20,%esp
			break;
  800d80:	eb 46                	jmp    800dc8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d82:	83 ec 08             	sub    $0x8,%esp
  800d85:	ff 75 0c             	pushl  0xc(%ebp)
  800d88:	53                   	push   %ebx
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	ff d0                	call   *%eax
  800d8e:	83 c4 10             	add    $0x10,%esp
			break;
  800d91:	eb 35                	jmp    800dc8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d93:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800d9a:	eb 2c                	jmp    800dc8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d9c:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800da3:	eb 23                	jmp    800dc8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800da5:	83 ec 08             	sub    $0x8,%esp
  800da8:	ff 75 0c             	pushl  0xc(%ebp)
  800dab:	6a 25                	push   $0x25
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	ff d0                	call   *%eax
  800db2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800db5:	ff 4d 10             	decl   0x10(%ebp)
  800db8:	eb 03                	jmp    800dbd <vprintfmt+0x3c3>
  800dba:	ff 4d 10             	decl   0x10(%ebp)
  800dbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc0:	48                   	dec    %eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	3c 25                	cmp    $0x25,%al
  800dc5:	75 f3                	jne    800dba <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800dc7:	90                   	nop
		}
	}
  800dc8:	e9 35 fc ff ff       	jmp    800a02 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dcd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    

00800dd5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ddb:	8d 45 10             	lea    0x10(%ebp),%eax
  800dde:	83 c0 04             	add    $0x4,%eax
  800de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800de4:	8b 45 10             	mov    0x10(%ebp),%eax
  800de7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dea:	50                   	push   %eax
  800deb:	ff 75 0c             	pushl  0xc(%ebp)
  800dee:	ff 75 08             	pushl  0x8(%ebp)
  800df1:	e8 04 fc ff ff       	call   8009fa <vprintfmt>
  800df6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800df9:	90                   	nop
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e02:	8b 40 08             	mov    0x8(%eax),%eax
  800e05:	8d 50 01             	lea    0x1(%eax),%edx
  800e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e11:	8b 10                	mov    (%eax),%edx
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	8b 40 04             	mov    0x4(%eax),%eax
  800e19:	39 c2                	cmp    %eax,%edx
  800e1b:	73 12                	jae    800e2f <sprintputch+0x33>
		*b->buf++ = ch;
  800e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e20:	8b 00                	mov    (%eax),%eax
  800e22:	8d 48 01             	lea    0x1(%eax),%ecx
  800e25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e28:	89 0a                	mov    %ecx,(%edx)
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	88 10                	mov    %dl,(%eax)
}
  800e2f:	90                   	nop
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    

00800e32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	01 d0                	add    %edx,%eax
  800e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e57:	74 06                	je     800e5f <vsnprintf+0x2d>
  800e59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5d:	7f 07                	jg     800e66 <vsnprintf+0x34>
		return -E_INVAL;
  800e5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800e64:	eb 20                	jmp    800e86 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e66:	ff 75 14             	pushl  0x14(%ebp)
  800e69:	ff 75 10             	pushl  0x10(%ebp)
  800e6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e6f:	50                   	push   %eax
  800e70:	68 fc 0d 80 00       	push   $0x800dfc
  800e75:	e8 80 fb ff ff       	call   8009fa <vprintfmt>
  800e7a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e80:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800e91:	83 c0 04             	add    $0x4,%eax
  800e94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e97:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e9d:	50                   	push   %eax
  800e9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ea1:	ff 75 08             	pushl  0x8(%ebp)
  800ea4:	e8 89 ff ff ff       	call   800e32 <vsnprintf>
  800ea9:	83 c4 10             	add    $0x10,%esp
  800eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec1:	eb 06                	jmp    800ec9 <strlen+0x15>
		n++;
  800ec3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ec6:	ff 45 08             	incl   0x8(%ebp)
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8a 00                	mov    (%eax),%al
  800ece:	84 c0                	test   %al,%al
  800ed0:	75 f1                	jne    800ec3 <strlen+0xf>
		n++;
	return n;
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ed5:	c9                   	leave  
  800ed6:	c3                   	ret    

00800ed7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800edd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ee4:	eb 09                	jmp    800eef <strnlen+0x18>
		n++;
  800ee6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ee9:	ff 45 08             	incl   0x8(%ebp)
  800eec:	ff 4d 0c             	decl   0xc(%ebp)
  800eef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ef3:	74 09                	je     800efe <strnlen+0x27>
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	84 c0                	test   %al,%al
  800efc:	75 e8                	jne    800ee6 <strnlen+0xf>
		n++;
	return n;
  800efe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    

00800f03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f0f:	90                   	nop
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8d 50 01             	lea    0x1(%eax),%edx
  800f16:	89 55 08             	mov    %edx,0x8(%ebp)
  800f19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f22:	8a 12                	mov    (%edx),%dl
  800f24:	88 10                	mov    %dl,(%eax)
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	75 e4                	jne    800f10 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f44:	eb 1f                	jmp    800f65 <strncpy+0x34>
		*dst++ = *src;
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8d 50 01             	lea    0x1(%eax),%edx
  800f4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f52:	8a 12                	mov    (%edx),%dl
  800f54:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	84 c0                	test   %al,%al
  800f5d:	74 03                	je     800f62 <strncpy+0x31>
			src++;
  800f5f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f62:	ff 45 fc             	incl   -0x4(%ebp)
  800f65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f6b:	72 d9                	jb     800f46 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f70:	c9                   	leave  
  800f71:	c3                   	ret    

00800f72 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f82:	74 30                	je     800fb4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f84:	eb 16                	jmp    800f9c <strlcpy+0x2a>
			*dst++ = *src++;
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8d 50 01             	lea    0x1(%eax),%edx
  800f8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f98:	8a 12                	mov    (%edx),%dl
  800f9a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f9c:	ff 4d 10             	decl   0x10(%ebp)
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	74 09                	je     800fae <strlcpy+0x3c>
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	84 c0                	test   %al,%al
  800fac:	75 d8                	jne    800f86 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fba:	29 c2                	sub    %eax,%edx
  800fbc:	89 d0                	mov    %edx,%eax
}
  800fbe:	c9                   	leave  
  800fbf:	c3                   	ret    

00800fc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fc3:	eb 06                	jmp    800fcb <strcmp+0xb>
		p++, q++;
  800fc5:	ff 45 08             	incl   0x8(%ebp)
  800fc8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	84 c0                	test   %al,%al
  800fd2:	74 0e                	je     800fe2 <strcmp+0x22>
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	8a 10                	mov    (%eax),%dl
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	38 c2                	cmp    %al,%dl
  800fe0:	74 e3                	je     800fc5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	0f b6 d0             	movzbl %al,%edx
  800fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	0f b6 c0             	movzbl %al,%eax
  800ff2:	29 c2                	sub    %eax,%edx
  800ff4:	89 d0                	mov    %edx,%eax
}
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    

00800ff8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ffb:	eb 09                	jmp    801006 <strncmp+0xe>
		n--, p++, q++;
  800ffd:	ff 4d 10             	decl   0x10(%ebp)
  801000:	ff 45 08             	incl   0x8(%ebp)
  801003:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801006:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100a:	74 17                	je     801023 <strncmp+0x2b>
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	84 c0                	test   %al,%al
  801013:	74 0e                	je     801023 <strncmp+0x2b>
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 10                	mov    (%eax),%dl
  80101a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	38 c2                	cmp    %al,%dl
  801021:	74 da                	je     800ffd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801023:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801027:	75 07                	jne    801030 <strncmp+0x38>
		return 0;
  801029:	b8 00 00 00 00       	mov    $0x0,%eax
  80102e:	eb 14                	jmp    801044 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	0f b6 d0             	movzbl %al,%edx
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f b6 c0             	movzbl %al,%eax
  801040:	29 c2                	sub    %eax,%edx
  801042:	89 d0                	mov    %edx,%eax
}
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    

00801046 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 04             	sub    $0x4,%esp
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801052:	eb 12                	jmp    801066 <strchr+0x20>
		if (*s == c)
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80105c:	75 05                	jne    801063 <strchr+0x1d>
			return (char *) s;
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	eb 11                	jmp    801074 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801063:	ff 45 08             	incl   0x8(%ebp)
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	84 c0                	test   %al,%al
  80106d:	75 e5                	jne    801054 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80106f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 04             	sub    $0x4,%esp
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801082:	eb 0d                	jmp    801091 <strfind+0x1b>
		if (*s == c)
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80108c:	74 0e                	je     80109c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80108e:	ff 45 08             	incl   0x8(%ebp)
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	84 c0                	test   %al,%al
  801098:	75 ea                	jne    801084 <strfind+0xe>
  80109a:	eb 01                	jmp    80109d <strfind+0x27>
		if (*s == c)
			break;
  80109c:	90                   	nop
	return (char *) s;
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010b4:	eb 0e                	jmp    8010c4 <memset+0x22>
		*p++ = c;
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	8d 50 01             	lea    0x1(%eax),%edx
  8010bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010c4:	ff 4d f8             	decl   -0x8(%ebp)
  8010c7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010cb:	79 e9                	jns    8010b6 <memset+0x14>
		*p++ = c;

	return v;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010e4:	eb 16                	jmp    8010fc <memcpy+0x2a>
		*d++ = *s++;
  8010e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010f8:	8a 12                	mov    (%edx),%dl
  8010fa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801102:	89 55 10             	mov    %edx,0x10(%ebp)
  801105:	85 c0                	test   %eax,%eax
  801107:	75 dd                	jne    8010e6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    

0080110e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801114:	8b 45 0c             	mov    0xc(%ebp),%eax
  801117:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801126:	73 50                	jae    801178 <memmove+0x6a>
  801128:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80112b:	8b 45 10             	mov    0x10(%ebp),%eax
  80112e:	01 d0                	add    %edx,%eax
  801130:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801133:	76 43                	jbe    801178 <memmove+0x6a>
		s += n;
  801135:	8b 45 10             	mov    0x10(%ebp),%eax
  801138:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801141:	eb 10                	jmp    801153 <memmove+0x45>
			*--d = *--s;
  801143:	ff 4d f8             	decl   -0x8(%ebp)
  801146:	ff 4d fc             	decl   -0x4(%ebp)
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114c:	8a 10                	mov    (%eax),%dl
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801153:	8b 45 10             	mov    0x10(%ebp),%eax
  801156:	8d 50 ff             	lea    -0x1(%eax),%edx
  801159:	89 55 10             	mov    %edx,0x10(%ebp)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	75 e3                	jne    801143 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801160:	eb 23                	jmp    801185 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801162:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801165:	8d 50 01             	lea    0x1(%eax),%edx
  801168:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80116b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80116e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801171:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801174:	8a 12                	mov    (%edx),%dl
  801176:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801178:	8b 45 10             	mov    0x10(%ebp),%eax
  80117b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80117e:	89 55 10             	mov    %edx,0x10(%ebp)
  801181:	85 c0                	test   %eax,%eax
  801183:	75 dd                	jne    801162 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80119c:	eb 2a                	jmp    8011c8 <memcmp+0x3e>
		if (*s1 != *s2)
  80119e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a1:	8a 10                	mov    (%eax),%dl
  8011a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	38 c2                	cmp    %al,%dl
  8011aa:	74 16                	je     8011c2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	0f b6 d0             	movzbl %al,%edx
  8011b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	0f b6 c0             	movzbl %al,%eax
  8011bc:	29 c2                	sub    %eax,%edx
  8011be:	89 d0                	mov    %edx,%eax
  8011c0:	eb 18                	jmp    8011da <memcmp+0x50>
		s1++, s2++;
  8011c2:	ff 45 fc             	incl   -0x4(%ebp)
  8011c5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	75 c9                	jne    80119e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e8:	01 d0                	add    %edx,%eax
  8011ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011ed:	eb 15                	jmp    801204 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	0f b6 d0             	movzbl %al,%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	0f b6 c0             	movzbl %al,%eax
  8011fd:	39 c2                	cmp    %eax,%edx
  8011ff:	74 0d                	je     80120e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801201:	ff 45 08             	incl   0x8(%ebp)
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80120a:	72 e3                	jb     8011ef <memfind+0x13>
  80120c:	eb 01                	jmp    80120f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80120e:	90                   	nop
	return (void *) s;
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801212:	c9                   	leave  
  801213:	c3                   	ret    

00801214 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80121a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801221:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801228:	eb 03                	jmp    80122d <strtol+0x19>
		s++;
  80122a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	3c 20                	cmp    $0x20,%al
  801234:	74 f4                	je     80122a <strtol+0x16>
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	3c 09                	cmp    $0x9,%al
  80123d:	74 eb                	je     80122a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	3c 2b                	cmp    $0x2b,%al
  801246:	75 05                	jne    80124d <strtol+0x39>
		s++;
  801248:	ff 45 08             	incl   0x8(%ebp)
  80124b:	eb 13                	jmp    801260 <strtol+0x4c>
	else if (*s == '-')
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	3c 2d                	cmp    $0x2d,%al
  801254:	75 0a                	jne    801260 <strtol+0x4c>
		s++, neg = 1;
  801256:	ff 45 08             	incl   0x8(%ebp)
  801259:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801260:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801264:	74 06                	je     80126c <strtol+0x58>
  801266:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80126a:	75 20                	jne    80128c <strtol+0x78>
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 30                	cmp    $0x30,%al
  801273:	75 17                	jne    80128c <strtol+0x78>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	40                   	inc    %eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 78                	cmp    $0x78,%al
  80127d:	75 0d                	jne    80128c <strtol+0x78>
		s += 2, base = 16;
  80127f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801283:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80128a:	eb 28                	jmp    8012b4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80128c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801290:	75 15                	jne    8012a7 <strtol+0x93>
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3c 30                	cmp    $0x30,%al
  801299:	75 0c                	jne    8012a7 <strtol+0x93>
		s++, base = 8;
  80129b:	ff 45 08             	incl   0x8(%ebp)
  80129e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012a5:	eb 0d                	jmp    8012b4 <strtol+0xa0>
	else if (base == 0)
  8012a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ab:	75 07                	jne    8012b4 <strtol+0xa0>
		base = 10;
  8012ad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	3c 2f                	cmp    $0x2f,%al
  8012bb:	7e 19                	jle    8012d6 <strtol+0xc2>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	3c 39                	cmp    $0x39,%al
  8012c4:	7f 10                	jg     8012d6 <strtol+0xc2>
			dig = *s - '0';
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	0f be c0             	movsbl %al,%eax
  8012ce:	83 e8 30             	sub    $0x30,%eax
  8012d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012d4:	eb 42                	jmp    801318 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	3c 60                	cmp    $0x60,%al
  8012dd:	7e 19                	jle    8012f8 <strtol+0xe4>
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	8a 00                	mov    (%eax),%al
  8012e4:	3c 7a                	cmp    $0x7a,%al
  8012e6:	7f 10                	jg     8012f8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	8a 00                	mov    (%eax),%al
  8012ed:	0f be c0             	movsbl %al,%eax
  8012f0:	83 e8 57             	sub    $0x57,%eax
  8012f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f6:	eb 20                	jmp    801318 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	3c 40                	cmp    $0x40,%al
  8012ff:	7e 39                	jle    80133a <strtol+0x126>
  801301:	8b 45 08             	mov    0x8(%ebp),%eax
  801304:	8a 00                	mov    (%eax),%al
  801306:	3c 5a                	cmp    $0x5a,%al
  801308:	7f 30                	jg     80133a <strtol+0x126>
			dig = *s - 'A' + 10;
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	0f be c0             	movsbl %al,%eax
  801312:	83 e8 37             	sub    $0x37,%eax
  801315:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80131e:	7d 19                	jge    801339 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801320:	ff 45 08             	incl   0x8(%ebp)
  801323:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801326:	0f af 45 10          	imul   0x10(%ebp),%eax
  80132a:	89 c2                	mov    %eax,%edx
  80132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132f:	01 d0                	add    %edx,%eax
  801331:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801334:	e9 7b ff ff ff       	jmp    8012b4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801339:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80133a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80133e:	74 08                	je     801348 <strtol+0x134>
		*endptr = (char *) s;
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	8b 55 08             	mov    0x8(%ebp),%edx
  801346:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801348:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80134c:	74 07                	je     801355 <strtol+0x141>
  80134e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801351:	f7 d8                	neg    %eax
  801353:	eb 03                	jmp    801358 <strtol+0x144>
  801355:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801358:	c9                   	leave  
  801359:	c3                   	ret    

0080135a <ltostr>:

void
ltostr(long value, char *str)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801360:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801367:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80136e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801372:	79 13                	jns    801387 <ltostr+0x2d>
	{
		neg = 1;
  801374:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80137b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801381:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801384:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80138f:	99                   	cltd   
  801390:	f7 f9                	idiv   %ecx
  801392:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801395:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801398:	8d 50 01             	lea    0x1(%eax),%edx
  80139b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80139e:	89 c2                	mov    %eax,%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 d0                	add    %edx,%eax
  8013a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013a8:	83 c2 30             	add    $0x30,%edx
  8013ab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013b5:	f7 e9                	imul   %ecx
  8013b7:	c1 fa 02             	sar    $0x2,%edx
  8013ba:	89 c8                	mov    %ecx,%eax
  8013bc:	c1 f8 1f             	sar    $0x1f,%eax
  8013bf:	29 c2                	sub    %eax,%edx
  8013c1:	89 d0                	mov    %edx,%eax
  8013c3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ca:	75 bb                	jne    801387 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d6:	48                   	dec    %eax
  8013d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013da:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013de:	74 3d                	je     80141d <ltostr+0xc3>
		start = 1 ;
  8013e0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013e7:	eb 34                	jmp    80141d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	01 d0                	add    %edx,%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fc:	01 c2                	add    %eax,%edx
  8013fe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	01 c8                	add    %ecx,%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80140a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	01 c2                	add    %eax,%edx
  801412:	8a 45 eb             	mov    -0x15(%ebp),%al
  801415:	88 02                	mov    %al,(%edx)
		start++ ;
  801417:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80141a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80141d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801420:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801423:	7c c4                	jl     8013e9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801425:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801430:	90                   	nop
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801439:	ff 75 08             	pushl  0x8(%ebp)
  80143c:	e8 73 fa ff ff       	call   800eb4 <strlen>
  801441:	83 c4 04             	add    $0x4,%esp
  801444:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801447:	ff 75 0c             	pushl  0xc(%ebp)
  80144a:	e8 65 fa ff ff       	call   800eb4 <strlen>
  80144f:	83 c4 04             	add    $0x4,%esp
  801452:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801455:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80145c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801463:	eb 17                	jmp    80147c <strcconcat+0x49>
		final[s] = str1[s] ;
  801465:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801468:	8b 45 10             	mov    0x10(%ebp),%eax
  80146b:	01 c2                	add    %eax,%edx
  80146d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	01 c8                	add    %ecx,%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801479:	ff 45 fc             	incl   -0x4(%ebp)
  80147c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80147f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801482:	7c e1                	jl     801465 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801484:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80148b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801492:	eb 1f                	jmp    8014b3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801494:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801497:	8d 50 01             	lea    0x1(%eax),%edx
  80149a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80149d:	89 c2                	mov    %eax,%edx
  80149f:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a2:	01 c2                	add    %eax,%edx
  8014a4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014aa:	01 c8                	add    %ecx,%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014b0:	ff 45 f8             	incl   -0x8(%ebp)
  8014b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014b9:	7c d9                	jl     801494 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014be:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c1:	01 d0                	add    %edx,%eax
  8014c3:	c6 00 00             	movb   $0x0,(%eax)
}
  8014c6:	90                   	nop
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d8:	8b 00                	mov    (%eax),%eax
  8014da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014ec:	eb 0c                	jmp    8014fa <strsplit+0x31>
			*string++ = 0;
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8d 50 01             	lea    0x1(%eax),%edx
  8014f4:	89 55 08             	mov    %edx,0x8(%ebp)
  8014f7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8a 00                	mov    (%eax),%al
  8014ff:	84 c0                	test   %al,%al
  801501:	74 18                	je     80151b <strsplit+0x52>
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	8a 00                	mov    (%eax),%al
  801508:	0f be c0             	movsbl %al,%eax
  80150b:	50                   	push   %eax
  80150c:	ff 75 0c             	pushl  0xc(%ebp)
  80150f:	e8 32 fb ff ff       	call   801046 <strchr>
  801514:	83 c4 08             	add    $0x8,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	75 d3                	jne    8014ee <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	74 5a                	je     80157e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801524:	8b 45 14             	mov    0x14(%ebp),%eax
  801527:	8b 00                	mov    (%eax),%eax
  801529:	83 f8 0f             	cmp    $0xf,%eax
  80152c:	75 07                	jne    801535 <strsplit+0x6c>
		{
			return 0;
  80152e:	b8 00 00 00 00       	mov    $0x0,%eax
  801533:	eb 66                	jmp    80159b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801535:	8b 45 14             	mov    0x14(%ebp),%eax
  801538:	8b 00                	mov    (%eax),%eax
  80153a:	8d 48 01             	lea    0x1(%eax),%ecx
  80153d:	8b 55 14             	mov    0x14(%ebp),%edx
  801540:	89 0a                	mov    %ecx,(%edx)
  801542:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801549:	8b 45 10             	mov    0x10(%ebp),%eax
  80154c:	01 c2                	add    %eax,%edx
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801553:	eb 03                	jmp    801558 <strsplit+0x8f>
			string++;
  801555:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	84 c0                	test   %al,%al
  80155f:	74 8b                	je     8014ec <strsplit+0x23>
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	8a 00                	mov    (%eax),%al
  801566:	0f be c0             	movsbl %al,%eax
  801569:	50                   	push   %eax
  80156a:	ff 75 0c             	pushl  0xc(%ebp)
  80156d:	e8 d4 fa ff ff       	call   801046 <strchr>
  801572:	83 c4 08             	add    $0x8,%esp
  801575:	85 c0                	test   %eax,%eax
  801577:	74 dc                	je     801555 <strsplit+0x8c>
			string++;
	}
  801579:	e9 6e ff ff ff       	jmp    8014ec <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80157e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80157f:	8b 45 14             	mov    0x14(%ebp),%eax
  801582:	8b 00                	mov    (%eax),%eax
  801584:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80158b:	8b 45 10             	mov    0x10(%ebp),%eax
  80158e:	01 d0                	add    %edx,%eax
  801590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801596:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8015a3:	83 ec 04             	sub    $0x4,%esp
  8015a6:	68 e8 26 80 00       	push   $0x8026e8
  8015ab:	68 3f 01 00 00       	push   $0x13f
  8015b0:	68 0a 27 80 00       	push   $0x80270a
  8015b5:	e8 a9 ef ff ff       	call   800563 <_panic>

008015ba <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	57                   	push   %edi
  8015be:	56                   	push   %esi
  8015bf:	53                   	push   %ebx
  8015c0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015cf:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015d2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015d5:	cd 30                	int    $0x30
  8015d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015dd:	83 c4 10             	add    $0x10,%esp
  8015e0:	5b                   	pop    %ebx
  8015e1:	5e                   	pop    %esi
  8015e2:	5f                   	pop    %edi
  8015e3:	5d                   	pop    %ebp
  8015e4:	c3                   	ret    

008015e5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 04             	sub    $0x4,%esp
  8015eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015f1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	52                   	push   %edx
  8015fd:	ff 75 0c             	pushl  0xc(%ebp)
  801600:	50                   	push   %eax
  801601:	6a 00                	push   $0x0
  801603:	e8 b2 ff ff ff       	call   8015ba <syscall>
  801608:	83 c4 18             	add    $0x18,%esp
}
  80160b:	90                   	nop
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <sys_cgetc>:

int
sys_cgetc(void)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 02                	push   $0x2
  80161d:	e8 98 ff ff ff       	call   8015ba <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 03                	push   $0x3
  801636:	e8 7f ff ff ff       	call   8015ba <syscall>
  80163b:	83 c4 18             	add    $0x18,%esp
}
  80163e:	90                   	nop
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 04                	push   $0x4
  801650:	e8 65 ff ff ff       	call   8015ba <syscall>
  801655:	83 c4 18             	add    $0x18,%esp
}
  801658:	90                   	nop
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80165e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	52                   	push   %edx
  80166b:	50                   	push   %eax
  80166c:	6a 08                	push   $0x8
  80166e:	e8 47 ff ff ff       	call   8015ba <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	56                   	push   %esi
  80167c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80167d:	8b 75 18             	mov    0x18(%ebp),%esi
  801680:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801683:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801686:	8b 55 0c             	mov    0xc(%ebp),%edx
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	56                   	push   %esi
  80168d:	53                   	push   %ebx
  80168e:	51                   	push   %ecx
  80168f:	52                   	push   %edx
  801690:	50                   	push   %eax
  801691:	6a 09                	push   $0x9
  801693:	e8 22 ff ff ff       	call   8015ba <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169e:	5b                   	pop    %ebx
  80169f:	5e                   	pop    %esi
  8016a0:	5d                   	pop    %ebp
  8016a1:	c3                   	ret    

008016a2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	52                   	push   %edx
  8016b2:	50                   	push   %eax
  8016b3:	6a 0a                	push   $0xa
  8016b5:	e8 00 ff ff ff       	call   8015ba <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	ff 75 08             	pushl  0x8(%ebp)
  8016ce:	6a 0b                	push   $0xb
  8016d0:	e8 e5 fe ff ff       	call   8015ba <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 0c                	push   $0xc
  8016e9:	e8 cc fe ff ff       	call   8015ba <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 0d                	push   $0xd
  801702:	e8 b3 fe ff ff       	call   8015ba <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 0e                	push   $0xe
  80171b:	e8 9a fe ff ff       	call   8015ba <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 0f                	push   $0xf
  801734:	e8 81 fe ff ff       	call   8015ba <syscall>
  801739:	83 c4 18             	add    $0x18,%esp
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	ff 75 08             	pushl  0x8(%ebp)
  80174c:	6a 10                	push   $0x10
  80174e:	e8 67 fe ff ff       	call   8015ba <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 11                	push   $0x11
  801767:	e8 4e fe ff ff       	call   8015ba <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
}
  80176f:	90                   	nop
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_cputc>:

void
sys_cputc(const char c)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80177e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	50                   	push   %eax
  80178b:	6a 01                	push   $0x1
  80178d:	e8 28 fe ff ff       	call   8015ba <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	90                   	nop
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 14                	push   $0x14
  8017a7:	e8 0e fe ff ff       	call   8015ba <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
}
  8017af:	90                   	nop
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017be:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017c1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	6a 00                	push   $0x0
  8017ca:	51                   	push   %ecx
  8017cb:	52                   	push   %edx
  8017cc:	ff 75 0c             	pushl  0xc(%ebp)
  8017cf:	50                   	push   %eax
  8017d0:	6a 15                	push   $0x15
  8017d2:	e8 e3 fd ff ff       	call   8015ba <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	52                   	push   %edx
  8017ec:	50                   	push   %eax
  8017ed:	6a 16                	push   $0x16
  8017ef:	e8 c6 fd ff ff       	call   8015ba <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	51                   	push   %ecx
  80180a:	52                   	push   %edx
  80180b:	50                   	push   %eax
  80180c:	6a 17                	push   $0x17
  80180e:	e8 a7 fd ff ff       	call   8015ba <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80181b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	52                   	push   %edx
  801828:	50                   	push   %eax
  801829:	6a 18                	push   $0x18
  80182b:	e8 8a fd ff ff       	call   8015ba <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	6a 00                	push   $0x0
  80183d:	ff 75 14             	pushl  0x14(%ebp)
  801840:	ff 75 10             	pushl  0x10(%ebp)
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	50                   	push   %eax
  801847:	6a 19                	push   $0x19
  801849:	e8 6c fd ff ff       	call   8015ba <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	50                   	push   %eax
  801862:	6a 1a                	push   $0x1a
  801864:	e8 51 fd ff ff       	call   8015ba <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	90                   	nop
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	50                   	push   %eax
  80187e:	6a 1b                	push   $0x1b
  801880:	e8 35 fd ff ff       	call   8015ba <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 05                	push   $0x5
  801899:	e8 1c fd ff ff       	call   8015ba <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 06                	push   $0x6
  8018b2:	e8 03 fd ff ff       	call   8015ba <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 07                	push   $0x7
  8018cb:	e8 ea fc ff ff       	call   8015ba <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_exit_env>:


void sys_exit_env(void)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 1c                	push   $0x1c
  8018e4:	e8 d1 fc ff ff       	call   8015ba <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	90                   	nop
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018f5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018f8:	8d 50 04             	lea    0x4(%eax),%edx
  8018fb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	52                   	push   %edx
  801905:	50                   	push   %eax
  801906:	6a 1d                	push   $0x1d
  801908:	e8 ad fc ff ff       	call   8015ba <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
	return result;
  801910:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801913:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801916:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801919:	89 01                	mov    %eax,(%ecx)
  80191b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	c9                   	leave  
  801922:	c2 04 00             	ret    $0x4

00801925 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	ff 75 10             	pushl  0x10(%ebp)
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	ff 75 08             	pushl  0x8(%ebp)
  801935:	6a 13                	push   $0x13
  801937:	e8 7e fc ff ff       	call   8015ba <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
	return ;
  80193f:	90                   	nop
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_rcr2>:
uint32 sys_rcr2()
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 1e                	push   $0x1e
  801951:	e8 64 fc ff ff       	call   8015ba <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 04             	sub    $0x4,%esp
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801967:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	50                   	push   %eax
  801974:	6a 1f                	push   $0x1f
  801976:	e8 3f fc ff ff       	call   8015ba <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
	return ;
  80197e:	90                   	nop
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <rsttst>:
void rsttst()
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 21                	push   $0x21
  801990:	e8 25 fc ff ff       	call   8015ba <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
	return ;
  801998:	90                   	nop
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 04             	sub    $0x4,%esp
  8019a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019a7:	8b 55 18             	mov    0x18(%ebp),%edx
  8019aa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ae:	52                   	push   %edx
  8019af:	50                   	push   %eax
  8019b0:	ff 75 10             	pushl  0x10(%ebp)
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	ff 75 08             	pushl  0x8(%ebp)
  8019b9:	6a 20                	push   $0x20
  8019bb:	e8 fa fb ff ff       	call   8015ba <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c3:	90                   	nop
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <chktst>:
void chktst(uint32 n)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	ff 75 08             	pushl  0x8(%ebp)
  8019d4:	6a 22                	push   $0x22
  8019d6:	e8 df fb ff ff       	call   8015ba <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
	return ;
  8019de:	90                   	nop
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <inctst>:

void inctst()
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 23                	push   $0x23
  8019f0:	e8 c5 fb ff ff       	call   8015ba <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f8:	90                   	nop
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <gettst>:
uint32 gettst()
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 24                	push   $0x24
  801a0a:	e8 ab fb ff ff       	call   8015ba <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 25                	push   $0x25
  801a26:	e8 8f fb ff ff       	call   8015ba <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
  801a2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a31:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a35:	75 07                	jne    801a3e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a37:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3c:	eb 05                	jmp    801a43 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 25                	push   $0x25
  801a57:	e8 5e fb ff ff       	call   8015ba <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
  801a5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a62:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a66:	75 07                	jne    801a6f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a68:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6d:	eb 05                	jmp    801a74 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 25                	push   $0x25
  801a88:	e8 2d fb ff ff       	call   8015ba <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
  801a90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a93:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a97:	75 07                	jne    801aa0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a99:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9e:	eb 05                	jmp    801aa5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801aa0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 25                	push   $0x25
  801ab9:	e8 fc fa ff ff       	call   8015ba <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
  801ac1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ac4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ac8:	75 07                	jne    801ad1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801aca:	b8 01 00 00 00       	mov    $0x1,%eax
  801acf:	eb 05                	jmp    801ad6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ad1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	ff 75 08             	pushl  0x8(%ebp)
  801ae6:	6a 26                	push   $0x26
  801ae8:	e8 cd fa ff ff       	call   8015ba <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
	return ;
  801af0:	90                   	nop
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801af7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801afa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	53                   	push   %ebx
  801b06:	51                   	push   %ecx
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 27                	push   $0x27
  801b0b:	e8 aa fa ff ff       	call   8015ba <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	52                   	push   %edx
  801b28:	50                   	push   %eax
  801b29:	6a 28                	push   $0x28
  801b2b:	e8 8a fa ff ff       	call   8015ba <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b38:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	51                   	push   %ecx
  801b44:	ff 75 10             	pushl  0x10(%ebp)
  801b47:	52                   	push   %edx
  801b48:	50                   	push   %eax
  801b49:	6a 29                	push   $0x29
  801b4b:	e8 6a fa ff ff       	call   8015ba <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	ff 75 10             	pushl  0x10(%ebp)
  801b5f:	ff 75 0c             	pushl  0xc(%ebp)
  801b62:	ff 75 08             	pushl  0x8(%ebp)
  801b65:	6a 12                	push   $0x12
  801b67:	e8 4e fa ff ff       	call   8015ba <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6f:	90                   	nop
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	52                   	push   %edx
  801b82:	50                   	push   %eax
  801b83:	6a 2a                	push   $0x2a
  801b85:	e8 30 fa ff ff       	call   8015ba <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
	return;
  801b8d:	90                   	nop
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	50                   	push   %eax
  801b9f:	6a 2b                	push   $0x2b
  801ba1:	e8 14 fa ff ff       	call   8015ba <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	ff 75 0c             	pushl  0xc(%ebp)
  801bb7:	ff 75 08             	pushl  0x8(%ebp)
  801bba:	6a 2c                	push   $0x2c
  801bbc:	e8 f9 f9 ff ff       	call   8015ba <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
	return;
  801bc4:	90                   	nop
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	ff 75 0c             	pushl  0xc(%ebp)
  801bd3:	ff 75 08             	pushl  0x8(%ebp)
  801bd6:	6a 2d                	push   $0x2d
  801bd8:	e8 dd f9 ff ff       	call   8015ba <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
	return;
  801be0:	90                   	nop
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    
  801be3:	90                   	nop

00801be4 <__udivdi3>:
  801be4:	55                   	push   %ebp
  801be5:	57                   	push   %edi
  801be6:	56                   	push   %esi
  801be7:	53                   	push   %ebx
  801be8:	83 ec 1c             	sub    $0x1c,%esp
  801beb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bf7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bfb:	89 ca                	mov    %ecx,%edx
  801bfd:	89 f8                	mov    %edi,%eax
  801bff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c03:	85 f6                	test   %esi,%esi
  801c05:	75 2d                	jne    801c34 <__udivdi3+0x50>
  801c07:	39 cf                	cmp    %ecx,%edi
  801c09:	77 65                	ja     801c70 <__udivdi3+0x8c>
  801c0b:	89 fd                	mov    %edi,%ebp
  801c0d:	85 ff                	test   %edi,%edi
  801c0f:	75 0b                	jne    801c1c <__udivdi3+0x38>
  801c11:	b8 01 00 00 00       	mov    $0x1,%eax
  801c16:	31 d2                	xor    %edx,%edx
  801c18:	f7 f7                	div    %edi
  801c1a:	89 c5                	mov    %eax,%ebp
  801c1c:	31 d2                	xor    %edx,%edx
  801c1e:	89 c8                	mov    %ecx,%eax
  801c20:	f7 f5                	div    %ebp
  801c22:	89 c1                	mov    %eax,%ecx
  801c24:	89 d8                	mov    %ebx,%eax
  801c26:	f7 f5                	div    %ebp
  801c28:	89 cf                	mov    %ecx,%edi
  801c2a:	89 fa                	mov    %edi,%edx
  801c2c:	83 c4 1c             	add    $0x1c,%esp
  801c2f:	5b                   	pop    %ebx
  801c30:	5e                   	pop    %esi
  801c31:	5f                   	pop    %edi
  801c32:	5d                   	pop    %ebp
  801c33:	c3                   	ret    
  801c34:	39 ce                	cmp    %ecx,%esi
  801c36:	77 28                	ja     801c60 <__udivdi3+0x7c>
  801c38:	0f bd fe             	bsr    %esi,%edi
  801c3b:	83 f7 1f             	xor    $0x1f,%edi
  801c3e:	75 40                	jne    801c80 <__udivdi3+0x9c>
  801c40:	39 ce                	cmp    %ecx,%esi
  801c42:	72 0a                	jb     801c4e <__udivdi3+0x6a>
  801c44:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c48:	0f 87 9e 00 00 00    	ja     801cec <__udivdi3+0x108>
  801c4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c53:	89 fa                	mov    %edi,%edx
  801c55:	83 c4 1c             	add    $0x1c,%esp
  801c58:	5b                   	pop    %ebx
  801c59:	5e                   	pop    %esi
  801c5a:	5f                   	pop    %edi
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    
  801c5d:	8d 76 00             	lea    0x0(%esi),%esi
  801c60:	31 ff                	xor    %edi,%edi
  801c62:	31 c0                	xor    %eax,%eax
  801c64:	89 fa                	mov    %edi,%edx
  801c66:	83 c4 1c             	add    $0x1c,%esp
  801c69:	5b                   	pop    %ebx
  801c6a:	5e                   	pop    %esi
  801c6b:	5f                   	pop    %edi
  801c6c:	5d                   	pop    %ebp
  801c6d:	c3                   	ret    
  801c6e:	66 90                	xchg   %ax,%ax
  801c70:	89 d8                	mov    %ebx,%eax
  801c72:	f7 f7                	div    %edi
  801c74:	31 ff                	xor    %edi,%edi
  801c76:	89 fa                	mov    %edi,%edx
  801c78:	83 c4 1c             	add    $0x1c,%esp
  801c7b:	5b                   	pop    %ebx
  801c7c:	5e                   	pop    %esi
  801c7d:	5f                   	pop    %edi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    
  801c80:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c85:	89 eb                	mov    %ebp,%ebx
  801c87:	29 fb                	sub    %edi,%ebx
  801c89:	89 f9                	mov    %edi,%ecx
  801c8b:	d3 e6                	shl    %cl,%esi
  801c8d:	89 c5                	mov    %eax,%ebp
  801c8f:	88 d9                	mov    %bl,%cl
  801c91:	d3 ed                	shr    %cl,%ebp
  801c93:	89 e9                	mov    %ebp,%ecx
  801c95:	09 f1                	or     %esi,%ecx
  801c97:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c9b:	89 f9                	mov    %edi,%ecx
  801c9d:	d3 e0                	shl    %cl,%eax
  801c9f:	89 c5                	mov    %eax,%ebp
  801ca1:	89 d6                	mov    %edx,%esi
  801ca3:	88 d9                	mov    %bl,%cl
  801ca5:	d3 ee                	shr    %cl,%esi
  801ca7:	89 f9                	mov    %edi,%ecx
  801ca9:	d3 e2                	shl    %cl,%edx
  801cab:	8b 44 24 08          	mov    0x8(%esp),%eax
  801caf:	88 d9                	mov    %bl,%cl
  801cb1:	d3 e8                	shr    %cl,%eax
  801cb3:	09 c2                	or     %eax,%edx
  801cb5:	89 d0                	mov    %edx,%eax
  801cb7:	89 f2                	mov    %esi,%edx
  801cb9:	f7 74 24 0c          	divl   0xc(%esp)
  801cbd:	89 d6                	mov    %edx,%esi
  801cbf:	89 c3                	mov    %eax,%ebx
  801cc1:	f7 e5                	mul    %ebp
  801cc3:	39 d6                	cmp    %edx,%esi
  801cc5:	72 19                	jb     801ce0 <__udivdi3+0xfc>
  801cc7:	74 0b                	je     801cd4 <__udivdi3+0xf0>
  801cc9:	89 d8                	mov    %ebx,%eax
  801ccb:	31 ff                	xor    %edi,%edi
  801ccd:	e9 58 ff ff ff       	jmp    801c2a <__udivdi3+0x46>
  801cd2:	66 90                	xchg   %ax,%ax
  801cd4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cd8:	89 f9                	mov    %edi,%ecx
  801cda:	d3 e2                	shl    %cl,%edx
  801cdc:	39 c2                	cmp    %eax,%edx
  801cde:	73 e9                	jae    801cc9 <__udivdi3+0xe5>
  801ce0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ce3:	31 ff                	xor    %edi,%edi
  801ce5:	e9 40 ff ff ff       	jmp    801c2a <__udivdi3+0x46>
  801cea:	66 90                	xchg   %ax,%ax
  801cec:	31 c0                	xor    %eax,%eax
  801cee:	e9 37 ff ff ff       	jmp    801c2a <__udivdi3+0x46>
  801cf3:	90                   	nop

00801cf4 <__umoddi3>:
  801cf4:	55                   	push   %ebp
  801cf5:	57                   	push   %edi
  801cf6:	56                   	push   %esi
  801cf7:	53                   	push   %ebx
  801cf8:	83 ec 1c             	sub    $0x1c,%esp
  801cfb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cff:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d07:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d13:	89 f3                	mov    %esi,%ebx
  801d15:	89 fa                	mov    %edi,%edx
  801d17:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d1b:	89 34 24             	mov    %esi,(%esp)
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	75 1a                	jne    801d3c <__umoddi3+0x48>
  801d22:	39 f7                	cmp    %esi,%edi
  801d24:	0f 86 a2 00 00 00    	jbe    801dcc <__umoddi3+0xd8>
  801d2a:	89 c8                	mov    %ecx,%eax
  801d2c:	89 f2                	mov    %esi,%edx
  801d2e:	f7 f7                	div    %edi
  801d30:	89 d0                	mov    %edx,%eax
  801d32:	31 d2                	xor    %edx,%edx
  801d34:	83 c4 1c             	add    $0x1c,%esp
  801d37:	5b                   	pop    %ebx
  801d38:	5e                   	pop    %esi
  801d39:	5f                   	pop    %edi
  801d3a:	5d                   	pop    %ebp
  801d3b:	c3                   	ret    
  801d3c:	39 f0                	cmp    %esi,%eax
  801d3e:	0f 87 ac 00 00 00    	ja     801df0 <__umoddi3+0xfc>
  801d44:	0f bd e8             	bsr    %eax,%ebp
  801d47:	83 f5 1f             	xor    $0x1f,%ebp
  801d4a:	0f 84 ac 00 00 00    	je     801dfc <__umoddi3+0x108>
  801d50:	bf 20 00 00 00       	mov    $0x20,%edi
  801d55:	29 ef                	sub    %ebp,%edi
  801d57:	89 fe                	mov    %edi,%esi
  801d59:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d5d:	89 e9                	mov    %ebp,%ecx
  801d5f:	d3 e0                	shl    %cl,%eax
  801d61:	89 d7                	mov    %edx,%edi
  801d63:	89 f1                	mov    %esi,%ecx
  801d65:	d3 ef                	shr    %cl,%edi
  801d67:	09 c7                	or     %eax,%edi
  801d69:	89 e9                	mov    %ebp,%ecx
  801d6b:	d3 e2                	shl    %cl,%edx
  801d6d:	89 14 24             	mov    %edx,(%esp)
  801d70:	89 d8                	mov    %ebx,%eax
  801d72:	d3 e0                	shl    %cl,%eax
  801d74:	89 c2                	mov    %eax,%edx
  801d76:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d7a:	d3 e0                	shl    %cl,%eax
  801d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d80:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d84:	89 f1                	mov    %esi,%ecx
  801d86:	d3 e8                	shr    %cl,%eax
  801d88:	09 d0                	or     %edx,%eax
  801d8a:	d3 eb                	shr    %cl,%ebx
  801d8c:	89 da                	mov    %ebx,%edx
  801d8e:	f7 f7                	div    %edi
  801d90:	89 d3                	mov    %edx,%ebx
  801d92:	f7 24 24             	mull   (%esp)
  801d95:	89 c6                	mov    %eax,%esi
  801d97:	89 d1                	mov    %edx,%ecx
  801d99:	39 d3                	cmp    %edx,%ebx
  801d9b:	0f 82 87 00 00 00    	jb     801e28 <__umoddi3+0x134>
  801da1:	0f 84 91 00 00 00    	je     801e38 <__umoddi3+0x144>
  801da7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dab:	29 f2                	sub    %esi,%edx
  801dad:	19 cb                	sbb    %ecx,%ebx
  801daf:	89 d8                	mov    %ebx,%eax
  801db1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801db5:	d3 e0                	shl    %cl,%eax
  801db7:	89 e9                	mov    %ebp,%ecx
  801db9:	d3 ea                	shr    %cl,%edx
  801dbb:	09 d0                	or     %edx,%eax
  801dbd:	89 e9                	mov    %ebp,%ecx
  801dbf:	d3 eb                	shr    %cl,%ebx
  801dc1:	89 da                	mov    %ebx,%edx
  801dc3:	83 c4 1c             	add    $0x1c,%esp
  801dc6:	5b                   	pop    %ebx
  801dc7:	5e                   	pop    %esi
  801dc8:	5f                   	pop    %edi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    
  801dcb:	90                   	nop
  801dcc:	89 fd                	mov    %edi,%ebp
  801dce:	85 ff                	test   %edi,%edi
  801dd0:	75 0b                	jne    801ddd <__umoddi3+0xe9>
  801dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd7:	31 d2                	xor    %edx,%edx
  801dd9:	f7 f7                	div    %edi
  801ddb:	89 c5                	mov    %eax,%ebp
  801ddd:	89 f0                	mov    %esi,%eax
  801ddf:	31 d2                	xor    %edx,%edx
  801de1:	f7 f5                	div    %ebp
  801de3:	89 c8                	mov    %ecx,%eax
  801de5:	f7 f5                	div    %ebp
  801de7:	89 d0                	mov    %edx,%eax
  801de9:	e9 44 ff ff ff       	jmp    801d32 <__umoddi3+0x3e>
  801dee:	66 90                	xchg   %ax,%ax
  801df0:	89 c8                	mov    %ecx,%eax
  801df2:	89 f2                	mov    %esi,%edx
  801df4:	83 c4 1c             	add    $0x1c,%esp
  801df7:	5b                   	pop    %ebx
  801df8:	5e                   	pop    %esi
  801df9:	5f                   	pop    %edi
  801dfa:	5d                   	pop    %ebp
  801dfb:	c3                   	ret    
  801dfc:	3b 04 24             	cmp    (%esp),%eax
  801dff:	72 06                	jb     801e07 <__umoddi3+0x113>
  801e01:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e05:	77 0f                	ja     801e16 <__umoddi3+0x122>
  801e07:	89 f2                	mov    %esi,%edx
  801e09:	29 f9                	sub    %edi,%ecx
  801e0b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e0f:	89 14 24             	mov    %edx,(%esp)
  801e12:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e16:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e1a:	8b 14 24             	mov    (%esp),%edx
  801e1d:	83 c4 1c             	add    $0x1c,%esp
  801e20:	5b                   	pop    %ebx
  801e21:	5e                   	pop    %esi
  801e22:	5f                   	pop    %edi
  801e23:	5d                   	pop    %ebp
  801e24:	c3                   	ret    
  801e25:	8d 76 00             	lea    0x0(%esi),%esi
  801e28:	2b 04 24             	sub    (%esp),%eax
  801e2b:	19 fa                	sbb    %edi,%edx
  801e2d:	89 d1                	mov    %edx,%ecx
  801e2f:	89 c6                	mov    %eax,%esi
  801e31:	e9 71 ff ff ff       	jmp    801da7 <__umoddi3+0xb3>
  801e36:	66 90                	xchg   %ax,%ax
  801e38:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e3c:	72 ea                	jb     801e28 <__umoddi3+0x134>
  801e3e:	89 d9                	mov    %ebx,%ecx
  801e40:	e9 62 ff ff ff       	jmp    801da7 <__umoddi3+0xb3>
