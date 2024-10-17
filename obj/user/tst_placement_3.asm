
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
  8000e8:	e8 1c 1a 00 00       	call   801b09 <sys_check_LRU_lists>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(check == 0)
  8000f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8000f7:	75 14                	jne    80010d <_main+0xd5>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 80 1e 80 00       	push   $0x801e80
  800101:	6a 24                	push   $0x24
  800103:	68 02 1f 80 00       	push   $0x801f02
  800108:	e8 6c 04 00 00       	call   800579 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010d:	e8 29 16 00 00       	call   80173b <sys_pf_calculate_allocated_pages>
  800112:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int freePages = sys_calculate_free_frames();
  800115:	e8 d6 15 00 00       	call   8016f0 <sys_calculate_free_frames>
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
  800256:	68 1c 1f 80 00       	push   $0x801f1c
  80025b:	e8 d6 05 00 00       	call   800836 <cprintf>
  800260:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800263:	8a 85 c8 ff ff fe    	mov    -0x1000038(%ebp),%al
  800269:	3c ff                	cmp    $0xff,%al
  80026b:	74 17                	je     800284 <_main+0x24c>
  80026d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	68 4c 1f 80 00       	push   $0x801f4c
  80027c:	e8 b5 05 00 00       	call   800836 <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800284:	8a 85 c8 0f 00 ff    	mov    -0xfff038(%ebp),%al
  80028a:	3c ff                	cmp    $0xff,%al
  80028c:	74 17                	je     8002a5 <_main+0x26d>
  80028e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 4c 1f 80 00       	push   $0x801f4c
  80029d:	e8 94 05 00 00       	call   800836 <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8002a5:	8a 85 c8 ff 3f ff    	mov    -0xc00038(%ebp),%al
  8002ab:	3c ff                	cmp    $0xff,%al
  8002ad:	74 17                	je     8002c6 <_main+0x28e>
  8002af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	68 4c 1f 80 00       	push   $0x801f4c
  8002be:	e8 73 05 00 00       	call   800836 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8002c6:	8a 85 c8 0f 40 ff    	mov    -0xbff038(%ebp),%al
  8002cc:	3c ff                	cmp    $0xff,%al
  8002ce:	74 17                	je     8002e7 <_main+0x2af>
  8002d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 4c 1f 80 00       	push   $0x801f4c
  8002df:	e8 52 05 00 00       	call   800836 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8002e7:	8a 85 c8 ff 7f ff    	mov    -0x800038(%ebp),%al
  8002ed:	3c ff                	cmp    $0xff,%al
  8002ef:	74 17                	je     800308 <_main+0x2d0>
  8002f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002f8:	83 ec 0c             	sub    $0xc,%esp
  8002fb:	68 4c 1f 80 00       	push   $0x801f4c
  800300:	e8 31 05 00 00       	call   800836 <cprintf>
  800305:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800308:	8a 85 c8 0f 80 ff    	mov    -0x7ff038(%ebp),%al
  80030e:	3c ff                	cmp    $0xff,%al
  800310:	74 17                	je     800329 <_main+0x2f1>
  800312:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	68 4c 1f 80 00       	push   $0x801f4c
  800321:	e8 10 05 00 00       	call   800836 <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT written to Page File until it's replaced\n"); }
  800329:	e8 0d 14 00 00       	call   80173b <sys_pf_calculate_allocated_pages>
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	74 17                	je     80034a <_main+0x312>
  800333:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80033a:	83 ec 0c             	sub    $0xc,%esp
  80033d:	68 6c 1f 80 00       	push   $0x801f6c
  800342:	e8 ef 04 00 00       	call   800836 <cprintf>
  800347:	83 c4 10             	add    $0x10,%esp

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  80034a:	c7 45 d0 07 00 00 00 	movl   $0x7,-0x30(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  800351:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800354:	e8 97 13 00 00       	call   8016f0 <sys_calculate_free_frames>
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
  800378:	68 b4 1f 80 00       	push   $0x801fb4
  80037d:	e8 b4 04 00 00       	call   800836 <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  800385:	83 ec 0c             	sub    $0xc,%esp
  800388:	68 f4 1f 80 00       	push   $0x801ff4
  80038d:	e8 a4 04 00 00       	call   800836 <cprintf>
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
  8003a9:	68 28 20 80 00       	push   $0x802028
  8003ae:	e8 83 04 00 00       	call   800836 <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  8003b6:	6a 04                	push   $0x4
  8003b8:	6a 0d                	push   $0xd
  8003ba:	8d 85 78 ff ff fe    	lea    -0x1000088(%ebp),%eax
  8003c0:	50                   	push   %eax
  8003c1:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 3c 17 00 00       	call   801b09 <sys_check_LRU_lists>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if(check == 0)
  8003d3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8003d7:	75 17                	jne    8003f0 <_main+0x3b8>
			{ is_correct = 0; cprintf("LRU lists entries are not correct, check your logic again!!\n"); }
  8003d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003e0:	83 ec 0c             	sub    $0xc,%esp
  8003e3:	68 74 20 80 00       	push   $0x802074
  8003e8:	e8 49 04 00 00       	call   800836 <cprintf>
  8003ed:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B passed: checking LRU lists entries After Required PAGES IN SECOND LIST test are correct\n\n\n");
  8003f0:	83 ec 0c             	sub    $0xc,%esp
  8003f3:	68 b4 20 80 00       	push   $0x8020b4
  8003f8:	e8 39 04 00 00       	call   800836 <cprintf>
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
  800417:	68 18 21 80 00       	push   $0x802118
  80041c:	e8 15 04 00 00       	call   800836 <cprintf>
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
  800432:	e8 82 14 00 00       	call   8018b9 <sys_getenvindex>
  800437:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80043a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	c1 e0 06             	shl    $0x6,%eax
  800442:	29 d0                	sub    %edx,%eax
  800444:	c1 e0 02             	shl    $0x2,%eax
  800447:	01 d0                	add    %edx,%eax
  800449:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800450:	01 c8                	add    %ecx,%eax
  800452:	c1 e0 03             	shl    $0x3,%eax
  800455:	01 d0                	add    %edx,%eax
  800457:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045e:	29 c2                	sub    %eax,%edx
  800460:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800467:	89 c2                	mov    %eax,%edx
  800469:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80046f:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800474:	a1 04 30 80 00       	mov    0x803004,%eax
  800479:	8a 40 20             	mov    0x20(%eax),%al
  80047c:	84 c0                	test   %al,%al
  80047e:	74 0d                	je     80048d <libmain+0x61>
		binaryname = myEnv->prog_name;
  800480:	a1 04 30 80 00       	mov    0x803004,%eax
  800485:	83 c0 20             	add    $0x20,%eax
  800488:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80048d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800491:	7e 0a                	jle    80049d <libmain+0x71>
		binaryname = argv[0];
  800493:	8b 45 0c             	mov    0xc(%ebp),%eax
  800496:	8b 00                	mov    (%eax),%eax
  800498:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	ff 75 0c             	pushl  0xc(%ebp)
  8004a3:	ff 75 08             	pushl  0x8(%ebp)
  8004a6:	e8 8d fb ff ff       	call   800038 <_main>
  8004ab:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8004ae:	e8 8a 11 00 00       	call   80163d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004b3:	83 ec 0c             	sub    $0xc,%esp
  8004b6:	68 80 21 80 00       	push   $0x802180
  8004bb:	e8 76 03 00 00       	call   800836 <cprintf>
  8004c0:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004c3:	a1 04 30 80 00       	mov    0x803004,%eax
  8004c8:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8004ce:	a1 04 30 80 00       	mov    0x803004,%eax
  8004d3:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8004d9:	83 ec 04             	sub    $0x4,%esp
  8004dc:	52                   	push   %edx
  8004dd:	50                   	push   %eax
  8004de:	68 a8 21 80 00       	push   $0x8021a8
  8004e3:	e8 4e 03 00 00       	call   800836 <cprintf>
  8004e8:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004eb:	a1 04 30 80 00       	mov    0x803004,%eax
  8004f0:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8004f6:	a1 04 30 80 00       	mov    0x803004,%eax
  8004fb:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800501:	a1 04 30 80 00       	mov    0x803004,%eax
  800506:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80050c:	51                   	push   %ecx
  80050d:	52                   	push   %edx
  80050e:	50                   	push   %eax
  80050f:	68 d0 21 80 00       	push   $0x8021d0
  800514:	e8 1d 03 00 00       	call   800836 <cprintf>
  800519:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80051c:	a1 04 30 80 00       	mov    0x803004,%eax
  800521:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	50                   	push   %eax
  80052b:	68 28 22 80 00       	push   $0x802228
  800530:	e8 01 03 00 00       	call   800836 <cprintf>
  800535:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	68 80 21 80 00       	push   $0x802180
  800540:	e8 f1 02 00 00       	call   800836 <cprintf>
  800545:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800548:	e8 0a 11 00 00       	call   801657 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80054d:	e8 19 00 00 00       	call   80056b <exit>
}
  800552:	90                   	nop
  800553:	c9                   	leave  
  800554:	c3                   	ret    

00800555 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	6a 00                	push   $0x0
  800560:	e8 20 13 00 00       	call   801885 <sys_destroy_env>
  800565:	83 c4 10             	add    $0x10,%esp
}
  800568:	90                   	nop
  800569:	c9                   	leave  
  80056a:	c3                   	ret    

0080056b <exit>:

void
exit(void)
{
  80056b:	55                   	push   %ebp
  80056c:	89 e5                	mov    %esp,%ebp
  80056e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800571:	e8 75 13 00 00       	call   8018eb <sys_exit_env>
}
  800576:	90                   	nop
  800577:	c9                   	leave  
  800578:	c3                   	ret    

00800579 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800579:	55                   	push   %ebp
  80057a:	89 e5                	mov    %esp,%ebp
  80057c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80057f:	8d 45 10             	lea    0x10(%ebp),%eax
  800582:	83 c0 04             	add    $0x4,%eax
  800585:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800588:	a1 24 30 80 00       	mov    0x803024,%eax
  80058d:	85 c0                	test   %eax,%eax
  80058f:	74 16                	je     8005a7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800591:	a1 24 30 80 00       	mov    0x803024,%eax
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	50                   	push   %eax
  80059a:	68 3c 22 80 00       	push   $0x80223c
  80059f:	e8 92 02 00 00       	call   800836 <cprintf>
  8005a4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005a7:	a1 00 30 80 00       	mov    0x803000,%eax
  8005ac:	ff 75 0c             	pushl  0xc(%ebp)
  8005af:	ff 75 08             	pushl  0x8(%ebp)
  8005b2:	50                   	push   %eax
  8005b3:	68 41 22 80 00       	push   $0x802241
  8005b8:	e8 79 02 00 00       	call   800836 <cprintf>
  8005bd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c9:	50                   	push   %eax
  8005ca:	e8 fc 01 00 00       	call   8007cb <vcprintf>
  8005cf:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	6a 00                	push   $0x0
  8005d7:	68 5d 22 80 00       	push   $0x80225d
  8005dc:	e8 ea 01 00 00       	call   8007cb <vcprintf>
  8005e1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005e4:	e8 82 ff ff ff       	call   80056b <exit>

	// should not return here
	while (1) ;
  8005e9:	eb fe                	jmp    8005e9 <_panic+0x70>

008005eb <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005eb:	55                   	push   %ebp
  8005ec:	89 e5                	mov    %esp,%ebp
  8005ee:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005f1:	a1 04 30 80 00       	mov    0x803004,%eax
  8005f6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ff:	39 c2                	cmp    %eax,%edx
  800601:	74 14                	je     800617 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800603:	83 ec 04             	sub    $0x4,%esp
  800606:	68 60 22 80 00       	push   $0x802260
  80060b:	6a 26                	push   $0x26
  80060d:	68 ac 22 80 00       	push   $0x8022ac
  800612:	e8 62 ff ff ff       	call   800579 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800617:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80061e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800625:	e9 c5 00 00 00       	jmp    8006ef <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80062a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	85 c0                	test   %eax,%eax
  80063d:	75 08                	jne    800647 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80063f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800642:	e9 a5 00 00 00       	jmp    8006ec <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800647:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80064e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800655:	eb 69                	jmp    8006c0 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800657:	a1 04 30 80 00       	mov    0x803004,%eax
  80065c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800662:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800665:	89 d0                	mov    %edx,%eax
  800667:	01 c0                	add    %eax,%eax
  800669:	01 d0                	add    %edx,%eax
  80066b:	c1 e0 03             	shl    $0x3,%eax
  80066e:	01 c8                	add    %ecx,%eax
  800670:	8a 40 04             	mov    0x4(%eax),%al
  800673:	84 c0                	test   %al,%al
  800675:	75 46                	jne    8006bd <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800677:	a1 04 30 80 00       	mov    0x803004,%eax
  80067c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800682:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800685:	89 d0                	mov    %edx,%eax
  800687:	01 c0                	add    %eax,%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	c1 e0 03             	shl    $0x3,%eax
  80068e:	01 c8                	add    %ecx,%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800695:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800698:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80069d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80069f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	01 c8                	add    %ecx,%eax
  8006ae:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006b0:	39 c2                	cmp    %eax,%edx
  8006b2:	75 09                	jne    8006bd <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006b4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006bb:	eb 15                	jmp    8006d2 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006bd:	ff 45 e8             	incl   -0x18(%ebp)
  8006c0:	a1 04 30 80 00       	mov    0x803004,%eax
  8006c5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ce:	39 c2                	cmp    %eax,%edx
  8006d0:	77 85                	ja     800657 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006d6:	75 14                	jne    8006ec <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006d8:	83 ec 04             	sub    $0x4,%esp
  8006db:	68 b8 22 80 00       	push   $0x8022b8
  8006e0:	6a 3a                	push   $0x3a
  8006e2:	68 ac 22 80 00       	push   $0x8022ac
  8006e7:	e8 8d fe ff ff       	call   800579 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006ec:	ff 45 f0             	incl   -0x10(%ebp)
  8006ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006f5:	0f 8c 2f ff ff ff    	jl     80062a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800702:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800709:	eb 26                	jmp    800731 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80070b:	a1 04 30 80 00       	mov    0x803004,%eax
  800710:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800716:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800719:	89 d0                	mov    %edx,%eax
  80071b:	01 c0                	add    %eax,%eax
  80071d:	01 d0                	add    %edx,%eax
  80071f:	c1 e0 03             	shl    $0x3,%eax
  800722:	01 c8                	add    %ecx,%eax
  800724:	8a 40 04             	mov    0x4(%eax),%al
  800727:	3c 01                	cmp    $0x1,%al
  800729:	75 03                	jne    80072e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80072b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80072e:	ff 45 e0             	incl   -0x20(%ebp)
  800731:	a1 04 30 80 00       	mov    0x803004,%eax
  800736:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80073c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80073f:	39 c2                	cmp    %eax,%edx
  800741:	77 c8                	ja     80070b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800746:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800749:	74 14                	je     80075f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80074b:	83 ec 04             	sub    $0x4,%esp
  80074e:	68 0c 23 80 00       	push   $0x80230c
  800753:	6a 44                	push   $0x44
  800755:	68 ac 22 80 00       	push   $0x8022ac
  80075a:	e8 1a fe ff ff       	call   800579 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80075f:	90                   	nop
  800760:	c9                   	leave  
  800761:	c3                   	ret    

00800762 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
  800765:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076b:	8b 00                	mov    (%eax),%eax
  80076d:	8d 48 01             	lea    0x1(%eax),%ecx
  800770:	8b 55 0c             	mov    0xc(%ebp),%edx
  800773:	89 0a                	mov    %ecx,(%edx)
  800775:	8b 55 08             	mov    0x8(%ebp),%edx
  800778:	88 d1                	mov    %dl,%cl
  80077a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80077d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800781:	8b 45 0c             	mov    0xc(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	3d ff 00 00 00       	cmp    $0xff,%eax
  80078b:	75 2c                	jne    8007b9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80078d:	a0 08 30 80 00       	mov    0x803008,%al
  800792:	0f b6 c0             	movzbl %al,%eax
  800795:	8b 55 0c             	mov    0xc(%ebp),%edx
  800798:	8b 12                	mov    (%edx),%edx
  80079a:	89 d1                	mov    %edx,%ecx
  80079c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80079f:	83 c2 08             	add    $0x8,%edx
  8007a2:	83 ec 04             	sub    $0x4,%esp
  8007a5:	50                   	push   %eax
  8007a6:	51                   	push   %ecx
  8007a7:	52                   	push   %edx
  8007a8:	e8 4e 0e 00 00       	call   8015fb <sys_cputs>
  8007ad:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bc:	8b 40 04             	mov    0x4(%eax),%eax
  8007bf:	8d 50 01             	lea    0x1(%eax),%edx
  8007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007c8:	90                   	nop
  8007c9:	c9                   	leave  
  8007ca:	c3                   	ret    

008007cb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007db:	00 00 00 
	b.cnt = 0;
  8007de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007e5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007e8:	ff 75 0c             	pushl  0xc(%ebp)
  8007eb:	ff 75 08             	pushl  0x8(%ebp)
  8007ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007f4:	50                   	push   %eax
  8007f5:	68 62 07 80 00       	push   $0x800762
  8007fa:	e8 11 02 00 00       	call   800a10 <vprintfmt>
  8007ff:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800802:	a0 08 30 80 00       	mov    0x803008,%al
  800807:	0f b6 c0             	movzbl %al,%eax
  80080a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800810:	83 ec 04             	sub    $0x4,%esp
  800813:	50                   	push   %eax
  800814:	52                   	push   %edx
  800815:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80081b:	83 c0 08             	add    $0x8,%eax
  80081e:	50                   	push   %eax
  80081f:	e8 d7 0d 00 00       	call   8015fb <sys_cputs>
  800824:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800827:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80082e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80083c:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800843:	8d 45 0c             	lea    0xc(%ebp),%eax
  800846:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 f4             	pushl  -0xc(%ebp)
  800852:	50                   	push   %eax
  800853:	e8 73 ff ff ff       	call   8007cb <vcprintf>
  800858:	83 c4 10             	add    $0x10,%esp
  80085b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80085e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800861:	c9                   	leave  
  800862:	c3                   	ret    

00800863 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800869:	e8 cf 0d 00 00       	call   80163d <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80086e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800871:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 f4             	pushl  -0xc(%ebp)
  80087d:	50                   	push   %eax
  80087e:	e8 48 ff ff ff       	call   8007cb <vcprintf>
  800883:	83 c4 10             	add    $0x10,%esp
  800886:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800889:	e8 c9 0d 00 00       	call   801657 <sys_unlock_cons>
	return cnt;
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800891:	c9                   	leave  
  800892:	c3                   	ret    

00800893 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	53                   	push   %ebx
  800897:	83 ec 14             	sub    $0x14,%esp
  80089a:	8b 45 10             	mov    0x10(%ebp),%eax
  80089d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8008a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008b1:	77 55                	ja     800908 <printnum+0x75>
  8008b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008b6:	72 05                	jb     8008bd <printnum+0x2a>
  8008b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008bb:	77 4b                	ja     800908 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8008c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cb:	52                   	push   %edx
  8008cc:	50                   	push   %eax
  8008cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8008d3:	e8 28 13 00 00       	call   801c00 <__udivdi3>
  8008d8:	83 c4 10             	add    $0x10,%esp
  8008db:	83 ec 04             	sub    $0x4,%esp
  8008de:	ff 75 20             	pushl  0x20(%ebp)
  8008e1:	53                   	push   %ebx
  8008e2:	ff 75 18             	pushl  0x18(%ebp)
  8008e5:	52                   	push   %edx
  8008e6:	50                   	push   %eax
  8008e7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ea:	ff 75 08             	pushl  0x8(%ebp)
  8008ed:	e8 a1 ff ff ff       	call   800893 <printnum>
  8008f2:	83 c4 20             	add    $0x20,%esp
  8008f5:	eb 1a                	jmp    800911 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008f7:	83 ec 08             	sub    $0x8,%esp
  8008fa:	ff 75 0c             	pushl  0xc(%ebp)
  8008fd:	ff 75 20             	pushl  0x20(%ebp)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	ff d0                	call   *%eax
  800905:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800908:	ff 4d 1c             	decl   0x1c(%ebp)
  80090b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80090f:	7f e6                	jg     8008f7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800911:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800914:	bb 00 00 00 00       	mov    $0x0,%ebx
  800919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80091c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80091f:	53                   	push   %ebx
  800920:	51                   	push   %ecx
  800921:	52                   	push   %edx
  800922:	50                   	push   %eax
  800923:	e8 e8 13 00 00       	call   801d10 <__umoddi3>
  800928:	83 c4 10             	add    $0x10,%esp
  80092b:	05 74 25 80 00       	add    $0x802574,%eax
  800930:	8a 00                	mov    (%eax),%al
  800932:	0f be c0             	movsbl %al,%eax
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	50                   	push   %eax
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
}
  800944:	90                   	nop
  800945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800948:	c9                   	leave  
  800949:	c3                   	ret    

0080094a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80094d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800951:	7e 1c                	jle    80096f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	8d 50 08             	lea    0x8(%eax),%edx
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	89 10                	mov    %edx,(%eax)
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	8b 00                	mov    (%eax),%eax
  800965:	83 e8 08             	sub    $0x8,%eax
  800968:	8b 50 04             	mov    0x4(%eax),%edx
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	eb 40                	jmp    8009af <getuint+0x65>
	else if (lflag)
  80096f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800973:	74 1e                	je     800993 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	8d 50 04             	lea    0x4(%eax),%edx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	89 10                	mov    %edx,(%eax)
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	83 e8 04             	sub    $0x4,%eax
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	ba 00 00 00 00       	mov    $0x0,%edx
  800991:	eb 1c                	jmp    8009af <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	8d 50 04             	lea    0x4(%eax),%edx
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	89 10                	mov    %edx,(%eax)
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 00                	mov    (%eax),%eax
  8009a5:	83 e8 04             	sub    $0x4,%eax
  8009a8:	8b 00                	mov    (%eax),%eax
  8009aa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    

008009b1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009b8:	7e 1c                	jle    8009d6 <getint+0x25>
		return va_arg(*ap, long long);
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	8b 00                	mov    (%eax),%eax
  8009bf:	8d 50 08             	lea    0x8(%eax),%edx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	89 10                	mov    %edx,(%eax)
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	8b 00                	mov    (%eax),%eax
  8009cc:	83 e8 08             	sub    $0x8,%eax
  8009cf:	8b 50 04             	mov    0x4(%eax),%edx
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	eb 38                	jmp    800a0e <getint+0x5d>
	else if (lflag)
  8009d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009da:	74 1a                	je     8009f6 <getint+0x45>
		return va_arg(*ap, long);
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	8b 00                	mov    (%eax),%eax
  8009e1:	8d 50 04             	lea    0x4(%eax),%edx
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	89 10                	mov    %edx,(%eax)
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	83 e8 04             	sub    $0x4,%eax
  8009f1:	8b 00                	mov    (%eax),%eax
  8009f3:	99                   	cltd   
  8009f4:	eb 18                	jmp    800a0e <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	8d 50 04             	lea    0x4(%eax),%edx
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	89 10                	mov    %edx,(%eax)
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	8b 00                	mov    (%eax),%eax
  800a08:	83 e8 04             	sub    $0x4,%eax
  800a0b:	8b 00                	mov    (%eax),%eax
  800a0d:	99                   	cltd   
}
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	56                   	push   %esi
  800a14:	53                   	push   %ebx
  800a15:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a18:	eb 17                	jmp    800a31 <vprintfmt+0x21>
			if (ch == '\0')
  800a1a:	85 db                	test   %ebx,%ebx
  800a1c:	0f 84 c1 03 00 00    	je     800de3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	53                   	push   %ebx
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	ff d0                	call   *%eax
  800a2e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a31:	8b 45 10             	mov    0x10(%ebp),%eax
  800a34:	8d 50 01             	lea    0x1(%eax),%edx
  800a37:	89 55 10             	mov    %edx,0x10(%ebp)
  800a3a:	8a 00                	mov    (%eax),%al
  800a3c:	0f b6 d8             	movzbl %al,%ebx
  800a3f:	83 fb 25             	cmp    $0x25,%ebx
  800a42:	75 d6                	jne    800a1a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a44:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a48:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a4f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a56:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a5d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a64:	8b 45 10             	mov    0x10(%ebp),%eax
  800a67:	8d 50 01             	lea    0x1(%eax),%edx
  800a6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800a6d:	8a 00                	mov    (%eax),%al
  800a6f:	0f b6 d8             	movzbl %al,%ebx
  800a72:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a75:	83 f8 5b             	cmp    $0x5b,%eax
  800a78:	0f 87 3d 03 00 00    	ja     800dbb <vprintfmt+0x3ab>
  800a7e:	8b 04 85 98 25 80 00 	mov    0x802598(,%eax,4),%eax
  800a85:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a87:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a8b:	eb d7                	jmp    800a64 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a8d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a91:	eb d1                	jmp    800a64 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a93:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a9d:	89 d0                	mov    %edx,%eax
  800a9f:	c1 e0 02             	shl    $0x2,%eax
  800aa2:	01 d0                	add    %edx,%eax
  800aa4:	01 c0                	add    %eax,%eax
  800aa6:	01 d8                	add    %ebx,%eax
  800aa8:	83 e8 30             	sub    $0x30,%eax
  800aab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800aae:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab1:	8a 00                	mov    (%eax),%al
  800ab3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ab6:	83 fb 2f             	cmp    $0x2f,%ebx
  800ab9:	7e 3e                	jle    800af9 <vprintfmt+0xe9>
  800abb:	83 fb 39             	cmp    $0x39,%ebx
  800abe:	7f 39                	jg     800af9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ac3:	eb d5                	jmp    800a9a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	83 c0 04             	add    $0x4,%eax
  800acb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	83 e8 04             	sub    $0x4,%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ad9:	eb 1f                	jmp    800afa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800adb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adf:	79 83                	jns    800a64 <vprintfmt+0x54>
				width = 0;
  800ae1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ae8:	e9 77 ff ff ff       	jmp    800a64 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800aed:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800af4:	e9 6b ff ff ff       	jmp    800a64 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800af9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800afa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800afe:	0f 89 60 ff ff ff    	jns    800a64 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b0a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b11:	e9 4e ff ff ff       	jmp    800a64 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b16:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b19:	e9 46 ff ff ff       	jmp    800a64 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b21:	83 c0 04             	add    $0x4,%eax
  800b24:	89 45 14             	mov    %eax,0x14(%ebp)
  800b27:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2a:	83 e8 04             	sub    $0x4,%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	50                   	push   %eax
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			break;
  800b3e:	e9 9b 02 00 00       	jmp    800dde <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b43:	8b 45 14             	mov    0x14(%ebp),%eax
  800b46:	83 c0 04             	add    $0x4,%eax
  800b49:	89 45 14             	mov    %eax,0x14(%ebp)
  800b4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4f:	83 e8 04             	sub    $0x4,%eax
  800b52:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b54:	85 db                	test   %ebx,%ebx
  800b56:	79 02                	jns    800b5a <vprintfmt+0x14a>
				err = -err;
  800b58:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b5a:	83 fb 64             	cmp    $0x64,%ebx
  800b5d:	7f 0b                	jg     800b6a <vprintfmt+0x15a>
  800b5f:	8b 34 9d e0 23 80 00 	mov    0x8023e0(,%ebx,4),%esi
  800b66:	85 f6                	test   %esi,%esi
  800b68:	75 19                	jne    800b83 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b6a:	53                   	push   %ebx
  800b6b:	68 85 25 80 00       	push   $0x802585
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	ff 75 08             	pushl  0x8(%ebp)
  800b76:	e8 70 02 00 00       	call   800deb <printfmt>
  800b7b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b7e:	e9 5b 02 00 00       	jmp    800dde <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b83:	56                   	push   %esi
  800b84:	68 8e 25 80 00       	push   $0x80258e
  800b89:	ff 75 0c             	pushl  0xc(%ebp)
  800b8c:	ff 75 08             	pushl  0x8(%ebp)
  800b8f:	e8 57 02 00 00       	call   800deb <printfmt>
  800b94:	83 c4 10             	add    $0x10,%esp
			break;
  800b97:	e9 42 02 00 00       	jmp    800dde <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9f:	83 c0 04             	add    $0x4,%eax
  800ba2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba8:	83 e8 04             	sub    $0x4,%eax
  800bab:	8b 30                	mov    (%eax),%esi
  800bad:	85 f6                	test   %esi,%esi
  800baf:	75 05                	jne    800bb6 <vprintfmt+0x1a6>
				p = "(null)";
  800bb1:	be 91 25 80 00       	mov    $0x802591,%esi
			if (width > 0 && padc != '-')
  800bb6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bba:	7e 6d                	jle    800c29 <vprintfmt+0x219>
  800bbc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bc0:	74 67                	je     800c29 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bc5:	83 ec 08             	sub    $0x8,%esp
  800bc8:	50                   	push   %eax
  800bc9:	56                   	push   %esi
  800bca:	e8 1e 03 00 00       	call   800eed <strnlen>
  800bcf:	83 c4 10             	add    $0x10,%esp
  800bd2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bd5:	eb 16                	jmp    800bed <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bd7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bdb:	83 ec 08             	sub    $0x8,%esp
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	50                   	push   %eax
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	ff d0                	call   *%eax
  800be7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bea:	ff 4d e4             	decl   -0x1c(%ebp)
  800bed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf1:	7f e4                	jg     800bd7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bf3:	eb 34                	jmp    800c29 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bf5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bf9:	74 1c                	je     800c17 <vprintfmt+0x207>
  800bfb:	83 fb 1f             	cmp    $0x1f,%ebx
  800bfe:	7e 05                	jle    800c05 <vprintfmt+0x1f5>
  800c00:	83 fb 7e             	cmp    $0x7e,%ebx
  800c03:	7e 12                	jle    800c17 <vprintfmt+0x207>
					putch('?', putdat);
  800c05:	83 ec 08             	sub    $0x8,%esp
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	6a 3f                	push   $0x3f
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	ff d0                	call   *%eax
  800c12:	83 c4 10             	add    $0x10,%esp
  800c15:	eb 0f                	jmp    800c26 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	53                   	push   %ebx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	ff d0                	call   *%eax
  800c23:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c26:	ff 4d e4             	decl   -0x1c(%ebp)
  800c29:	89 f0                	mov    %esi,%eax
  800c2b:	8d 70 01             	lea    0x1(%eax),%esi
  800c2e:	8a 00                	mov    (%eax),%al
  800c30:	0f be d8             	movsbl %al,%ebx
  800c33:	85 db                	test   %ebx,%ebx
  800c35:	74 24                	je     800c5b <vprintfmt+0x24b>
  800c37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c3b:	78 b8                	js     800bf5 <vprintfmt+0x1e5>
  800c3d:	ff 4d e0             	decl   -0x20(%ebp)
  800c40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c44:	79 af                	jns    800bf5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c46:	eb 13                	jmp    800c5b <vprintfmt+0x24b>
				putch(' ', putdat);
  800c48:	83 ec 08             	sub    $0x8,%esp
  800c4b:	ff 75 0c             	pushl  0xc(%ebp)
  800c4e:	6a 20                	push   $0x20
  800c50:	8b 45 08             	mov    0x8(%ebp),%eax
  800c53:	ff d0                	call   *%eax
  800c55:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c58:	ff 4d e4             	decl   -0x1c(%ebp)
  800c5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5f:	7f e7                	jg     800c48 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c61:	e9 78 01 00 00       	jmp    800dde <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c66:	83 ec 08             	sub    $0x8,%esp
  800c69:	ff 75 e8             	pushl  -0x18(%ebp)
  800c6c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c6f:	50                   	push   %eax
  800c70:	e8 3c fd ff ff       	call   8009b1 <getint>
  800c75:	83 c4 10             	add    $0x10,%esp
  800c78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c84:	85 d2                	test   %edx,%edx
  800c86:	79 23                	jns    800cab <vprintfmt+0x29b>
				putch('-', putdat);
  800c88:	83 ec 08             	sub    $0x8,%esp
  800c8b:	ff 75 0c             	pushl  0xc(%ebp)
  800c8e:	6a 2d                	push   $0x2d
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	ff d0                	call   *%eax
  800c95:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9e:	f7 d8                	neg    %eax
  800ca0:	83 d2 00             	adc    $0x0,%edx
  800ca3:	f7 da                	neg    %edx
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cb2:	e9 bc 00 00 00       	jmp    800d73 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800cb7:	83 ec 08             	sub    $0x8,%esp
  800cba:	ff 75 e8             	pushl  -0x18(%ebp)
  800cbd:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc0:	50                   	push   %eax
  800cc1:	e8 84 fc ff ff       	call   80094a <getuint>
  800cc6:	83 c4 10             	add    $0x10,%esp
  800cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ccf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cd6:	e9 98 00 00 00       	jmp    800d73 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800cdb:	83 ec 08             	sub    $0x8,%esp
  800cde:	ff 75 0c             	pushl  0xc(%ebp)
  800ce1:	6a 58                	push   $0x58
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	ff d0                	call   *%eax
  800ce8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ceb:	83 ec 08             	sub    $0x8,%esp
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	6a 58                	push   $0x58
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cfb:	83 ec 08             	sub    $0x8,%esp
  800cfe:	ff 75 0c             	pushl  0xc(%ebp)
  800d01:	6a 58                	push   $0x58
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	ff d0                	call   *%eax
  800d08:	83 c4 10             	add    $0x10,%esp
			break;
  800d0b:	e9 ce 00 00 00       	jmp    800dde <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d10:	83 ec 08             	sub    $0x8,%esp
  800d13:	ff 75 0c             	pushl  0xc(%ebp)
  800d16:	6a 30                	push   $0x30
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	ff d0                	call   *%eax
  800d1d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d20:	83 ec 08             	sub    $0x8,%esp
  800d23:	ff 75 0c             	pushl  0xc(%ebp)
  800d26:	6a 78                	push   $0x78
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	ff d0                	call   *%eax
  800d2d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d30:	8b 45 14             	mov    0x14(%ebp),%eax
  800d33:	83 c0 04             	add    $0x4,%eax
  800d36:	89 45 14             	mov    %eax,0x14(%ebp)
  800d39:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3c:	83 e8 04             	sub    $0x4,%eax
  800d3f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d52:	eb 1f                	jmp    800d73 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d54:	83 ec 08             	sub    $0x8,%esp
  800d57:	ff 75 e8             	pushl  -0x18(%ebp)
  800d5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800d5d:	50                   	push   %eax
  800d5e:	e8 e7 fb ff ff       	call   80094a <getuint>
  800d63:	83 c4 10             	add    $0x10,%esp
  800d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d6c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d73:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d7a:	83 ec 04             	sub    $0x4,%esp
  800d7d:	52                   	push   %edx
  800d7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d81:	50                   	push   %eax
  800d82:	ff 75 f4             	pushl  -0xc(%ebp)
  800d85:	ff 75 f0             	pushl  -0x10(%ebp)
  800d88:	ff 75 0c             	pushl  0xc(%ebp)
  800d8b:	ff 75 08             	pushl  0x8(%ebp)
  800d8e:	e8 00 fb ff ff       	call   800893 <printnum>
  800d93:	83 c4 20             	add    $0x20,%esp
			break;
  800d96:	eb 46                	jmp    800dde <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d98:	83 ec 08             	sub    $0x8,%esp
  800d9b:	ff 75 0c             	pushl  0xc(%ebp)
  800d9e:	53                   	push   %ebx
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	ff d0                	call   *%eax
  800da4:	83 c4 10             	add    $0x10,%esp
			break;
  800da7:	eb 35                	jmp    800dde <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800da9:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800db0:	eb 2c                	jmp    800dde <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800db2:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800db9:	eb 23                	jmp    800dde <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	6a 25                	push   $0x25
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	ff d0                	call   *%eax
  800dc8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dcb:	ff 4d 10             	decl   0x10(%ebp)
  800dce:	eb 03                	jmp    800dd3 <vprintfmt+0x3c3>
  800dd0:	ff 4d 10             	decl   0x10(%ebp)
  800dd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd6:	48                   	dec    %eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	3c 25                	cmp    $0x25,%al
  800ddb:	75 f3                	jne    800dd0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ddd:	90                   	nop
		}
	}
  800dde:	e9 35 fc ff ff       	jmp    800a18 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800de3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800de4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    

00800deb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800df1:	8d 45 10             	lea    0x10(%ebp),%eax
  800df4:	83 c0 04             	add    $0x4,%eax
  800df7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfd:	ff 75 f4             	pushl  -0xc(%ebp)
  800e00:	50                   	push   %eax
  800e01:	ff 75 0c             	pushl  0xc(%ebp)
  800e04:	ff 75 08             	pushl  0x8(%ebp)
  800e07:	e8 04 fc ff ff       	call   800a10 <vprintfmt>
  800e0c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e0f:	90                   	nop
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	8b 40 08             	mov    0x8(%eax),%eax
  800e1b:	8d 50 01             	lea    0x1(%eax),%edx
  800e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e21:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	8b 10                	mov    (%eax),%edx
  800e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2c:	8b 40 04             	mov    0x4(%eax),%eax
  800e2f:	39 c2                	cmp    %eax,%edx
  800e31:	73 12                	jae    800e45 <sprintputch+0x33>
		*b->buf++ = ch;
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	8b 00                	mov    (%eax),%eax
  800e38:	8d 48 01             	lea    0x1(%eax),%ecx
  800e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3e:	89 0a                	mov    %ecx,(%edx)
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	88 10                	mov    %dl,(%eax)
}
  800e45:	90                   	nop
  800e46:	5d                   	pop    %ebp
  800e47:	c3                   	ret    

00800e48 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	01 d0                	add    %edx,%eax
  800e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e6d:	74 06                	je     800e75 <vsnprintf+0x2d>
  800e6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e73:	7f 07                	jg     800e7c <vsnprintf+0x34>
		return -E_INVAL;
  800e75:	b8 03 00 00 00       	mov    $0x3,%eax
  800e7a:	eb 20                	jmp    800e9c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e7c:	ff 75 14             	pushl  0x14(%ebp)
  800e7f:	ff 75 10             	pushl  0x10(%ebp)
  800e82:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e85:	50                   	push   %eax
  800e86:	68 12 0e 80 00       	push   $0x800e12
  800e8b:	e8 80 fb ff ff       	call   800a10 <vprintfmt>
  800e90:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e96:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ea4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ea7:	83 c0 04             	add    $0x4,%eax
  800eaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ead:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb0:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb3:	50                   	push   %eax
  800eb4:	ff 75 0c             	pushl  0xc(%ebp)
  800eb7:	ff 75 08             	pushl  0x8(%ebp)
  800eba:	e8 89 ff ff ff       	call   800e48 <vsnprintf>
  800ebf:	83 c4 10             	add    $0x10,%esp
  800ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ed0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed7:	eb 06                	jmp    800edf <strlen+0x15>
		n++;
  800ed9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800edc:	ff 45 08             	incl   0x8(%ebp)
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	84 c0                	test   %al,%al
  800ee6:	75 f1                	jne    800ed9 <strlen+0xf>
		n++;
	return n;
  800ee8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ef3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800efa:	eb 09                	jmp    800f05 <strnlen+0x18>
		n++;
  800efc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eff:	ff 45 08             	incl   0x8(%ebp)
  800f02:	ff 4d 0c             	decl   0xc(%ebp)
  800f05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f09:	74 09                	je     800f14 <strnlen+0x27>
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	84 c0                	test   %al,%al
  800f12:	75 e8                	jne    800efc <strnlen+0xf>
		n++;
	return n;
  800f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f25:	90                   	nop
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8d 50 01             	lea    0x1(%eax),%edx
  800f2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f38:	8a 12                	mov    (%edx),%dl
  800f3a:	88 10                	mov    %dl,(%eax)
  800f3c:	8a 00                	mov    (%eax),%al
  800f3e:	84 c0                	test   %al,%al
  800f40:	75 e4                	jne    800f26 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f5a:	eb 1f                	jmp    800f7b <strncpy+0x34>
		*dst++ = *src;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 08             	mov    %edx,0x8(%ebp)
  800f65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f68:	8a 12                	mov    (%edx),%dl
  800f6a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	84 c0                	test   %al,%al
  800f73:	74 03                	je     800f78 <strncpy+0x31>
			src++;
  800f75:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f78:	ff 45 fc             	incl   -0x4(%ebp)
  800f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f81:	72 d9                	jb     800f5c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f86:	c9                   	leave  
  800f87:	c3                   	ret    

00800f88 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	74 30                	je     800fca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f9a:	eb 16                	jmp    800fb2 <strlcpy+0x2a>
			*dst++ = *src++;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8d 50 01             	lea    0x1(%eax),%edx
  800fa2:	89 55 08             	mov    %edx,0x8(%ebp)
  800fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fae:	8a 12                	mov    (%edx),%dl
  800fb0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fb2:	ff 4d 10             	decl   0x10(%ebp)
  800fb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb9:	74 09                	je     800fc4 <strlcpy+0x3c>
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	84 c0                	test   %al,%al
  800fc2:	75 d8                	jne    800f9c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd0:	29 c2                	sub    %eax,%edx
  800fd2:	89 d0                	mov    %edx,%eax
}
  800fd4:	c9                   	leave  
  800fd5:	c3                   	ret    

00800fd6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fd9:	eb 06                	jmp    800fe1 <strcmp+0xb>
		p++, q++;
  800fdb:	ff 45 08             	incl   0x8(%ebp)
  800fde:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	84 c0                	test   %al,%al
  800fe8:	74 0e                	je     800ff8 <strcmp+0x22>
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 10                	mov    (%eax),%dl
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	38 c2                	cmp    %al,%dl
  800ff6:	74 e3                	je     800fdb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	0f b6 d0             	movzbl %al,%edx
  801000:	8b 45 0c             	mov    0xc(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	0f b6 c0             	movzbl %al,%eax
  801008:	29 c2                	sub    %eax,%edx
  80100a:	89 d0                	mov    %edx,%eax
}
  80100c:	5d                   	pop    %ebp
  80100d:	c3                   	ret    

0080100e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801011:	eb 09                	jmp    80101c <strncmp+0xe>
		n--, p++, q++;
  801013:	ff 4d 10             	decl   0x10(%ebp)
  801016:	ff 45 08             	incl   0x8(%ebp)
  801019:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80101c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801020:	74 17                	je     801039 <strncmp+0x2b>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	84 c0                	test   %al,%al
  801029:	74 0e                	je     801039 <strncmp+0x2b>
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 10                	mov    (%eax),%dl
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	38 c2                	cmp    %al,%dl
  801037:	74 da                	je     801013 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801039:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103d:	75 07                	jne    801046 <strncmp+0x38>
		return 0;
  80103f:	b8 00 00 00 00       	mov    $0x0,%eax
  801044:	eb 14                	jmp    80105a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	0f b6 d0             	movzbl %al,%edx
  80104e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	0f b6 c0             	movzbl %al,%eax
  801056:	29 c2                	sub    %eax,%edx
  801058:	89 d0                	mov    %edx,%eax
}
  80105a:	5d                   	pop    %ebp
  80105b:	c3                   	ret    

0080105c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 04             	sub    $0x4,%esp
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801068:	eb 12                	jmp    80107c <strchr+0x20>
		if (*s == c)
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801072:	75 05                	jne    801079 <strchr+0x1d>
			return (char *) s;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	eb 11                	jmp    80108a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801079:	ff 45 08             	incl   0x8(%ebp)
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	84 c0                	test   %al,%al
  801083:	75 e5                	jne    80106a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801085:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108a:	c9                   	leave  
  80108b:	c3                   	ret    

0080108c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	83 ec 04             	sub    $0x4,%esp
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801098:	eb 0d                	jmp    8010a7 <strfind+0x1b>
		if (*s == c)
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010a2:	74 0e                	je     8010b2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010a4:	ff 45 08             	incl   0x8(%ebp)
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	84 c0                	test   %al,%al
  8010ae:	75 ea                	jne    80109a <strfind+0xe>
  8010b0:	eb 01                	jmp    8010b3 <strfind+0x27>
		if (*s == c)
			break;
  8010b2:	90                   	nop
	return (char *) s;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b6:	c9                   	leave  
  8010b7:	c3                   	ret    

008010b8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010ca:	eb 0e                	jmp    8010da <memset+0x22>
		*p++ = c;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cf:	8d 50 01             	lea    0x1(%eax),%edx
  8010d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010da:	ff 4d f8             	decl   -0x8(%ebp)
  8010dd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010e1:	79 e9                	jns    8010cc <memset+0x14>
		*p++ = c;

	return v;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010fa:	eb 16                	jmp    801112 <memcpy+0x2a>
		*d++ = *s++;
  8010fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ff:	8d 50 01             	lea    0x1(%eax),%edx
  801102:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801105:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801108:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80110e:	8a 12                	mov    (%edx),%dl
  801110:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801112:	8b 45 10             	mov    0x10(%ebp),%eax
  801115:	8d 50 ff             	lea    -0x1(%eax),%edx
  801118:	89 55 10             	mov    %edx,0x10(%ebp)
  80111b:	85 c0                	test   %eax,%eax
  80111d:	75 dd                	jne    8010fc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801136:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801139:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80113c:	73 50                	jae    80118e <memmove+0x6a>
  80113e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801141:	8b 45 10             	mov    0x10(%ebp),%eax
  801144:	01 d0                	add    %edx,%eax
  801146:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801149:	76 43                	jbe    80118e <memmove+0x6a>
		s += n;
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801151:	8b 45 10             	mov    0x10(%ebp),%eax
  801154:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801157:	eb 10                	jmp    801169 <memmove+0x45>
			*--d = *--s;
  801159:	ff 4d f8             	decl   -0x8(%ebp)
  80115c:	ff 4d fc             	decl   -0x4(%ebp)
  80115f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801162:	8a 10                	mov    (%eax),%dl
  801164:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801167:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116f:	89 55 10             	mov    %edx,0x10(%ebp)
  801172:	85 c0                	test   %eax,%eax
  801174:	75 e3                	jne    801159 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801176:	eb 23                	jmp    80119b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801178:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117b:	8d 50 01             	lea    0x1(%eax),%edx
  80117e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801181:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801184:	8d 4a 01             	lea    0x1(%edx),%ecx
  801187:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80118a:	8a 12                	mov    (%edx),%dl
  80118c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80118e:	8b 45 10             	mov    0x10(%ebp),%eax
  801191:	8d 50 ff             	lea    -0x1(%eax),%edx
  801194:	89 55 10             	mov    %edx,0x10(%ebp)
  801197:	85 c0                	test   %eax,%eax
  801199:	75 dd                	jne    801178 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80119e:	c9                   	leave  
  80119f:	c3                   	ret    

008011a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011b2:	eb 2a                	jmp    8011de <memcmp+0x3e>
		if (*s1 != *s2)
  8011b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b7:	8a 10                	mov    (%eax),%dl
  8011b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	38 c2                	cmp    %al,%dl
  8011c0:	74 16                	je     8011d8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	0f b6 d0             	movzbl %al,%edx
  8011ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	0f b6 c0             	movzbl %al,%eax
  8011d2:	29 c2                	sub    %eax,%edx
  8011d4:	89 d0                	mov    %edx,%eax
  8011d6:	eb 18                	jmp    8011f0 <memcmp+0x50>
		s1++, s2++;
  8011d8:	ff 45 fc             	incl   -0x4(%ebp)
  8011db:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	75 c9                	jne    8011b4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f0:	c9                   	leave  
  8011f1:	c3                   	ret    

008011f2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801203:	eb 15                	jmp    80121a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	0f b6 d0             	movzbl %al,%edx
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	0f b6 c0             	movzbl %al,%eax
  801213:	39 c2                	cmp    %eax,%edx
  801215:	74 0d                	je     801224 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801217:	ff 45 08             	incl   0x8(%ebp)
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801220:	72 e3                	jb     801205 <memfind+0x13>
  801222:	eb 01                	jmp    801225 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801224:	90                   	nop
	return (void *) s;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801237:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80123e:	eb 03                	jmp    801243 <strtol+0x19>
		s++;
  801240:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	8a 00                	mov    (%eax),%al
  801248:	3c 20                	cmp    $0x20,%al
  80124a:	74 f4                	je     801240 <strtol+0x16>
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	3c 09                	cmp    $0x9,%al
  801253:	74 eb                	je     801240 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	3c 2b                	cmp    $0x2b,%al
  80125c:	75 05                	jne    801263 <strtol+0x39>
		s++;
  80125e:	ff 45 08             	incl   0x8(%ebp)
  801261:	eb 13                	jmp    801276 <strtol+0x4c>
	else if (*s == '-')
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	3c 2d                	cmp    $0x2d,%al
  80126a:	75 0a                	jne    801276 <strtol+0x4c>
		s++, neg = 1;
  80126c:	ff 45 08             	incl   0x8(%ebp)
  80126f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801276:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127a:	74 06                	je     801282 <strtol+0x58>
  80127c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801280:	75 20                	jne    8012a2 <strtol+0x78>
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	3c 30                	cmp    $0x30,%al
  801289:	75 17                	jne    8012a2 <strtol+0x78>
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	40                   	inc    %eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	3c 78                	cmp    $0x78,%al
  801293:	75 0d                	jne    8012a2 <strtol+0x78>
		s += 2, base = 16;
  801295:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801299:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012a0:	eb 28                	jmp    8012ca <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a6:	75 15                	jne    8012bd <strtol+0x93>
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	3c 30                	cmp    $0x30,%al
  8012af:	75 0c                	jne    8012bd <strtol+0x93>
		s++, base = 8;
  8012b1:	ff 45 08             	incl   0x8(%ebp)
  8012b4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012bb:	eb 0d                	jmp    8012ca <strtol+0xa0>
	else if (base == 0)
  8012bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c1:	75 07                	jne    8012ca <strtol+0xa0>
		base = 10;
  8012c3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	3c 2f                	cmp    $0x2f,%al
  8012d1:	7e 19                	jle    8012ec <strtol+0xc2>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	3c 39                	cmp    $0x39,%al
  8012da:	7f 10                	jg     8012ec <strtol+0xc2>
			dig = *s - '0';
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	0f be c0             	movsbl %al,%eax
  8012e4:	83 e8 30             	sub    $0x30,%eax
  8012e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ea:	eb 42                	jmp    80132e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	8a 00                	mov    (%eax),%al
  8012f1:	3c 60                	cmp    $0x60,%al
  8012f3:	7e 19                	jle    80130e <strtol+0xe4>
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	3c 7a                	cmp    $0x7a,%al
  8012fc:	7f 10                	jg     80130e <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	8a 00                	mov    (%eax),%al
  801303:	0f be c0             	movsbl %al,%eax
  801306:	83 e8 57             	sub    $0x57,%eax
  801309:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80130c:	eb 20                	jmp    80132e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	3c 40                	cmp    $0x40,%al
  801315:	7e 39                	jle    801350 <strtol+0x126>
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	3c 5a                	cmp    $0x5a,%al
  80131e:	7f 30                	jg     801350 <strtol+0x126>
			dig = *s - 'A' + 10;
  801320:	8b 45 08             	mov    0x8(%ebp),%eax
  801323:	8a 00                	mov    (%eax),%al
  801325:	0f be c0             	movsbl %al,%eax
  801328:	83 e8 37             	sub    $0x37,%eax
  80132b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80132e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801331:	3b 45 10             	cmp    0x10(%ebp),%eax
  801334:	7d 19                	jge    80134f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133c:	0f af 45 10          	imul   0x10(%ebp),%eax
  801340:	89 c2                	mov    %eax,%edx
  801342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801345:	01 d0                	add    %edx,%eax
  801347:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80134a:	e9 7b ff ff ff       	jmp    8012ca <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80134f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801350:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801354:	74 08                	je     80135e <strtol+0x134>
		*endptr = (char *) s;
  801356:	8b 45 0c             	mov    0xc(%ebp),%eax
  801359:	8b 55 08             	mov    0x8(%ebp),%edx
  80135c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80135e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801362:	74 07                	je     80136b <strtol+0x141>
  801364:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801367:	f7 d8                	neg    %eax
  801369:	eb 03                	jmp    80136e <strtol+0x144>
  80136b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <ltostr>:

void
ltostr(long value, char *str)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801376:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80137d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801384:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801388:	79 13                	jns    80139d <ltostr+0x2d>
	{
		neg = 1;
  80138a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801391:	8b 45 0c             	mov    0xc(%ebp),%eax
  801394:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801397:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80139a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013a5:	99                   	cltd   
  8013a6:	f7 f9                	idiv   %ecx
  8013a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ae:	8d 50 01             	lea    0x1(%eax),%edx
  8013b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013b4:	89 c2                	mov    %eax,%edx
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	01 d0                	add    %edx,%eax
  8013bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013be:	83 c2 30             	add    $0x30,%edx
  8013c1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013cb:	f7 e9                	imul   %ecx
  8013cd:	c1 fa 02             	sar    $0x2,%edx
  8013d0:	89 c8                	mov    %ecx,%eax
  8013d2:	c1 f8 1f             	sar    $0x1f,%eax
  8013d5:	29 c2                	sub    %eax,%edx
  8013d7:	89 d0                	mov    %edx,%eax
  8013d9:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e0:	75 bb                	jne    80139d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ec:	48                   	dec    %eax
  8013ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013f4:	74 3d                	je     801433 <ltostr+0xc3>
		start = 1 ;
  8013f6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013fd:	eb 34                	jmp    801433 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801402:	8b 45 0c             	mov    0xc(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	8a 00                	mov    (%eax),%al
  801409:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80140c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801412:	01 c2                	add    %eax,%edx
  801414:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141a:	01 c8                	add    %ecx,%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801420:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801423:	8b 45 0c             	mov    0xc(%ebp),%eax
  801426:	01 c2                	add    %eax,%edx
  801428:	8a 45 eb             	mov    -0x15(%ebp),%al
  80142b:	88 02                	mov    %al,(%edx)
		start++ ;
  80142d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801430:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801436:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801439:	7c c4                	jl     8013ff <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80143b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80143e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801441:	01 d0                	add    %edx,%eax
  801443:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801446:	90                   	nop
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80144f:	ff 75 08             	pushl  0x8(%ebp)
  801452:	e8 73 fa ff ff       	call   800eca <strlen>
  801457:	83 c4 04             	add    $0x4,%esp
  80145a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	e8 65 fa ff ff       	call   800eca <strlen>
  801465:	83 c4 04             	add    $0x4,%esp
  801468:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80146b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801479:	eb 17                	jmp    801492 <strcconcat+0x49>
		final[s] = str1[s] ;
  80147b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147e:	8b 45 10             	mov    0x10(%ebp),%eax
  801481:	01 c2                	add    %eax,%edx
  801483:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	01 c8                	add    %ecx,%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80148f:	ff 45 fc             	incl   -0x4(%ebp)
  801492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801495:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801498:	7c e1                	jl     80147b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80149a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014a8:	eb 1f                	jmp    8014c9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014ad:	8d 50 01             	lea    0x1(%eax),%edx
  8014b0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014b3:	89 c2                	mov    %eax,%edx
  8014b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b8:	01 c2                	add    %eax,%edx
  8014ba:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c0:	01 c8                	add    %ecx,%eax
  8014c2:	8a 00                	mov    (%eax),%al
  8014c4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014c6:	ff 45 f8             	incl   -0x8(%ebp)
  8014c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014cf:	7c d9                	jl     8014aa <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d7:	01 d0                	add    %edx,%eax
  8014d9:	c6 00 00             	movb   $0x0,(%eax)
}
  8014dc:	90                   	nop
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ee:	8b 00                	mov    (%eax),%eax
  8014f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fa:	01 d0                	add    %edx,%eax
  8014fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801502:	eb 0c                	jmp    801510 <strsplit+0x31>
			*string++ = 0;
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8d 50 01             	lea    0x1(%eax),%edx
  80150a:	89 55 08             	mov    %edx,0x8(%ebp)
  80150d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	84 c0                	test   %al,%al
  801517:	74 18                	je     801531 <strsplit+0x52>
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8a 00                	mov    (%eax),%al
  80151e:	0f be c0             	movsbl %al,%eax
  801521:	50                   	push   %eax
  801522:	ff 75 0c             	pushl  0xc(%ebp)
  801525:	e8 32 fb ff ff       	call   80105c <strchr>
  80152a:	83 c4 08             	add    $0x8,%esp
  80152d:	85 c0                	test   %eax,%eax
  80152f:	75 d3                	jne    801504 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	84 c0                	test   %al,%al
  801538:	74 5a                	je     801594 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80153a:	8b 45 14             	mov    0x14(%ebp),%eax
  80153d:	8b 00                	mov    (%eax),%eax
  80153f:	83 f8 0f             	cmp    $0xf,%eax
  801542:	75 07                	jne    80154b <strsplit+0x6c>
		{
			return 0;
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
  801549:	eb 66                	jmp    8015b1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80154b:	8b 45 14             	mov    0x14(%ebp),%eax
  80154e:	8b 00                	mov    (%eax),%eax
  801550:	8d 48 01             	lea    0x1(%eax),%ecx
  801553:	8b 55 14             	mov    0x14(%ebp),%edx
  801556:	89 0a                	mov    %ecx,(%edx)
  801558:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80155f:	8b 45 10             	mov    0x10(%ebp),%eax
  801562:	01 c2                	add    %eax,%edx
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801569:	eb 03                	jmp    80156e <strsplit+0x8f>
			string++;
  80156b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	84 c0                	test   %al,%al
  801575:	74 8b                	je     801502 <strsplit+0x23>
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	8a 00                	mov    (%eax),%al
  80157c:	0f be c0             	movsbl %al,%eax
  80157f:	50                   	push   %eax
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	e8 d4 fa ff ff       	call   80105c <strchr>
  801588:	83 c4 08             	add    $0x8,%esp
  80158b:	85 c0                	test   %eax,%eax
  80158d:	74 dc                	je     80156b <strsplit+0x8c>
			string++;
	}
  80158f:	e9 6e ff ff ff       	jmp    801502 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801594:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801595:	8b 45 14             	mov    0x14(%ebp),%eax
  801598:	8b 00                	mov    (%eax),%eax
  80159a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a4:	01 d0                	add    %edx,%eax
  8015a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015ac:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8015b9:	83 ec 04             	sub    $0x4,%esp
  8015bc:	68 08 27 80 00       	push   $0x802708
  8015c1:	68 3f 01 00 00       	push   $0x13f
  8015c6:	68 2a 27 80 00       	push   $0x80272a
  8015cb:	e8 a9 ef ff ff       	call   800579 <_panic>

008015d0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	57                   	push   %edi
  8015d4:	56                   	push   %esi
  8015d5:	53                   	push   %ebx
  8015d6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015e5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015e8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015eb:	cd 30                	int    $0x30
  8015ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	5b                   	pop    %ebx
  8015f7:	5e                   	pop    %esi
  8015f8:	5f                   	pop    %edi
  8015f9:	5d                   	pop    %ebp
  8015fa:	c3                   	ret    

008015fb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	8b 45 10             	mov    0x10(%ebp),%eax
  801604:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801607:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	52                   	push   %edx
  801613:	ff 75 0c             	pushl  0xc(%ebp)
  801616:	50                   	push   %eax
  801617:	6a 00                	push   $0x0
  801619:	e8 b2 ff ff ff       	call   8015d0 <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
}
  801621:	90                   	nop
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <sys_cgetc>:

int
sys_cgetc(void)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 02                	push   $0x2
  801633:	e8 98 ff ff ff       	call   8015d0 <syscall>
  801638:	83 c4 18             	add    $0x18,%esp
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 03                	push   $0x3
  80164c:	e8 7f ff ff ff       	call   8015d0 <syscall>
  801651:	83 c4 18             	add    $0x18,%esp
}
  801654:	90                   	nop
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 04                	push   $0x4
  801666:	e8 65 ff ff ff       	call   8015d0 <syscall>
  80166b:	83 c4 18             	add    $0x18,%esp
}
  80166e:	90                   	nop
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801674:	8b 55 0c             	mov    0xc(%ebp),%edx
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	52                   	push   %edx
  801681:	50                   	push   %eax
  801682:	6a 08                	push   $0x8
  801684:	e8 47 ff ff ff       	call   8015d0 <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	56                   	push   %esi
  801692:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801693:	8b 75 18             	mov    0x18(%ebp),%esi
  801696:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801699:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80169c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	56                   	push   %esi
  8016a3:	53                   	push   %ebx
  8016a4:	51                   	push   %ecx
  8016a5:	52                   	push   %edx
  8016a6:	50                   	push   %eax
  8016a7:	6a 09                	push   $0x9
  8016a9:	e8 22 ff ff ff       	call   8015d0 <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
}
  8016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b4:	5b                   	pop    %ebx
  8016b5:	5e                   	pop    %esi
  8016b6:	5d                   	pop    %ebp
  8016b7:	c3                   	ret    

008016b8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	52                   	push   %edx
  8016c8:	50                   	push   %eax
  8016c9:	6a 0a                	push   $0xa
  8016cb:	e8 00 ff ff ff       	call   8015d0 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	ff 75 0c             	pushl  0xc(%ebp)
  8016e1:	ff 75 08             	pushl  0x8(%ebp)
  8016e4:	6a 0b                	push   $0xb
  8016e6:	e8 e5 fe ff ff       	call   8015d0 <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 0c                	push   $0xc
  8016ff:	e8 cc fe ff ff       	call   8015d0 <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 0d                	push   $0xd
  801718:	e8 b3 fe ff ff       	call   8015d0 <syscall>
  80171d:	83 c4 18             	add    $0x18,%esp
}
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 0e                	push   $0xe
  801731:	e8 9a fe ff ff       	call   8015d0 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 0f                	push   $0xf
  80174a:	e8 81 fe ff ff       	call   8015d0 <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	ff 75 08             	pushl  0x8(%ebp)
  801762:	6a 10                	push   $0x10
  801764:	e8 67 fe ff ff       	call   8015d0 <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 11                	push   $0x11
  80177d:	e8 4e fe ff ff       	call   8015d0 <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
}
  801785:	90                   	nop
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_cputc>:

void
sys_cputc(const char c)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 04             	sub    $0x4,%esp
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801794:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	50                   	push   %eax
  8017a1:	6a 01                	push   $0x1
  8017a3:	e8 28 fe ff ff       	call   8015d0 <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	90                   	nop
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 14                	push   $0x14
  8017bd:	e8 0e fe ff ff       	call   8015d0 <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	90                   	nop
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 04             	sub    $0x4,%esp
  8017ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017d4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017d7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	6a 00                	push   $0x0
  8017e0:	51                   	push   %ecx
  8017e1:	52                   	push   %edx
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	50                   	push   %eax
  8017e6:	6a 15                	push   $0x15
  8017e8:	e8 e3 fd ff ff       	call   8015d0 <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	52                   	push   %edx
  801802:	50                   	push   %eax
  801803:	6a 16                	push   $0x16
  801805:	e8 c6 fd ff ff       	call   8015d0 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801812:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801815:	8b 55 0c             	mov    0xc(%ebp),%edx
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	51                   	push   %ecx
  801820:	52                   	push   %edx
  801821:	50                   	push   %eax
  801822:	6a 17                	push   $0x17
  801824:	e8 a7 fd ff ff       	call   8015d0 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801831:	8b 55 0c             	mov    0xc(%ebp),%edx
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	52                   	push   %edx
  80183e:	50                   	push   %eax
  80183f:	6a 18                	push   $0x18
  801841:	e8 8a fd ff ff       	call   8015d0 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	6a 00                	push   $0x0
  801853:	ff 75 14             	pushl  0x14(%ebp)
  801856:	ff 75 10             	pushl  0x10(%ebp)
  801859:	ff 75 0c             	pushl  0xc(%ebp)
  80185c:	50                   	push   %eax
  80185d:	6a 19                	push   $0x19
  80185f:	e8 6c fd ff ff       	call   8015d0 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	50                   	push   %eax
  801878:	6a 1a                	push   $0x1a
  80187a:	e8 51 fd ff ff       	call   8015d0 <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	90                   	nop
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	50                   	push   %eax
  801894:	6a 1b                	push   $0x1b
  801896:	e8 35 fd ff ff       	call   8015d0 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 05                	push   $0x5
  8018af:	e8 1c fd ff ff       	call   8015d0 <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 06                	push   $0x6
  8018c8:	e8 03 fd ff ff       	call   8015d0 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 07                	push   $0x7
  8018e1:	e8 ea fc ff ff       	call   8015d0 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_exit_env>:


void sys_exit_env(void)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 1c                	push   $0x1c
  8018fa:	e8 d1 fc ff ff       	call   8015d0 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	90                   	nop
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80190b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80190e:	8d 50 04             	lea    0x4(%eax),%edx
  801911:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	52                   	push   %edx
  80191b:	50                   	push   %eax
  80191c:	6a 1d                	push   $0x1d
  80191e:	e8 ad fc ff ff       	call   8015d0 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
	return result;
  801926:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801929:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80192f:	89 01                	mov    %eax,(%ecx)
  801931:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	c9                   	leave  
  801938:	c2 04 00             	ret    $0x4

0080193b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	ff 75 10             	pushl  0x10(%ebp)
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	ff 75 08             	pushl  0x8(%ebp)
  80194b:	6a 13                	push   $0x13
  80194d:	e8 7e fc ff ff       	call   8015d0 <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
	return ;
  801955:	90                   	nop
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_rcr2>:
uint32 sys_rcr2()
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 1e                	push   $0x1e
  801967:	e8 64 fc ff ff       	call   8015d0 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80197d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	50                   	push   %eax
  80198a:	6a 1f                	push   $0x1f
  80198c:	e8 3f fc ff ff       	call   8015d0 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
	return ;
  801994:	90                   	nop
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <rsttst>:
void rsttst()
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 21                	push   $0x21
  8019a6:	e8 25 fc ff ff       	call   8015d0 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ae:	90                   	nop
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019bd:	8b 55 18             	mov    0x18(%ebp),%edx
  8019c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c4:	52                   	push   %edx
  8019c5:	50                   	push   %eax
  8019c6:	ff 75 10             	pushl  0x10(%ebp)
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	ff 75 08             	pushl  0x8(%ebp)
  8019cf:	6a 20                	push   $0x20
  8019d1:	e8 fa fb ff ff       	call   8015d0 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d9:	90                   	nop
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <chktst>:
void chktst(uint32 n)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	ff 75 08             	pushl  0x8(%ebp)
  8019ea:	6a 22                	push   $0x22
  8019ec:	e8 df fb ff ff       	call   8015d0 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f4:	90                   	nop
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <inctst>:

void inctst()
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 23                	push   $0x23
  801a06:	e8 c5 fb ff ff       	call   8015d0 <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0e:	90                   	nop
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <gettst>:
uint32 gettst()
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 24                	push   $0x24
  801a20:	e8 ab fb ff ff       	call   8015d0 <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 25                	push   $0x25
  801a3c:	e8 8f fb ff ff       	call   8015d0 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
  801a44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a47:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a4b:	75 07                	jne    801a54 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a52:	eb 05                	jmp    801a59 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 25                	push   $0x25
  801a6d:	e8 5e fb ff ff       	call   8015d0 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
  801a75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a78:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a7c:	75 07                	jne    801a85 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a83:	eb 05                	jmp    801a8a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 25                	push   $0x25
  801a9e:	e8 2d fb ff ff       	call   8015d0 <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
  801aa6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801aa9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801aad:	75 07                	jne    801ab6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801aaf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab4:	eb 05                	jmp    801abb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ab6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 25                	push   $0x25
  801acf:	e8 fc fa ff ff       	call   8015d0 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
  801ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ada:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ade:	75 07                	jne    801ae7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ae0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae5:	eb 05                	jmp    801aec <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ae7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 08             	pushl  0x8(%ebp)
  801afc:	6a 26                	push   $0x26
  801afe:	e8 cd fa ff ff       	call   8015d0 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
	return ;
  801b06:	90                   	nop
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	53                   	push   %ebx
  801b1c:	51                   	push   %ecx
  801b1d:	52                   	push   %edx
  801b1e:	50                   	push   %eax
  801b1f:	6a 27                	push   $0x27
  801b21:	e8 aa fa ff ff       	call   8015d0 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	52                   	push   %edx
  801b3e:	50                   	push   %eax
  801b3f:	6a 28                	push   $0x28
  801b41:	e8 8a fa ff ff       	call   8015d0 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b4e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	51                   	push   %ecx
  801b5a:	ff 75 10             	pushl  0x10(%ebp)
  801b5d:	52                   	push   %edx
  801b5e:	50                   	push   %eax
  801b5f:	6a 29                	push   $0x29
  801b61:	e8 6a fa ff ff       	call   8015d0 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	ff 75 10             	pushl  0x10(%ebp)
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	6a 12                	push   $0x12
  801b7d:	e8 4e fa ff ff       	call   8015d0 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return ;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	52                   	push   %edx
  801b98:	50                   	push   %eax
  801b99:	6a 2a                	push   $0x2a
  801b9b:	e8 30 fa ff ff       	call   8015d0 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
	return;
  801ba3:	90                   	nop
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801bac:	83 ec 04             	sub    $0x4,%esp
  801baf:	68 37 27 80 00       	push   $0x802737
  801bb4:	68 2e 01 00 00       	push   $0x12e
  801bb9:	68 4b 27 80 00       	push   $0x80274b
  801bbe:	e8 b6 e9 ff ff       	call   800579 <_panic>

00801bc3 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	68 37 27 80 00       	push   $0x802737
  801bd1:	68 35 01 00 00       	push   $0x135
  801bd6:	68 4b 27 80 00       	push   $0x80274b
  801bdb:	e8 99 e9 ff ff       	call   800579 <_panic>

00801be0 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801be6:	83 ec 04             	sub    $0x4,%esp
  801be9:	68 37 27 80 00       	push   $0x802737
  801bee:	68 3b 01 00 00       	push   $0x13b
  801bf3:	68 4b 27 80 00       	push   $0x80274b
  801bf8:	e8 7c e9 ff ff       	call   800579 <_panic>
  801bfd:	66 90                	xchg   %ax,%ax
  801bff:	90                   	nop

00801c00 <__udivdi3>:
  801c00:	55                   	push   %ebp
  801c01:	57                   	push   %edi
  801c02:	56                   	push   %esi
  801c03:	53                   	push   %ebx
  801c04:	83 ec 1c             	sub    $0x1c,%esp
  801c07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c17:	89 ca                	mov    %ecx,%edx
  801c19:	89 f8                	mov    %edi,%eax
  801c1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c1f:	85 f6                	test   %esi,%esi
  801c21:	75 2d                	jne    801c50 <__udivdi3+0x50>
  801c23:	39 cf                	cmp    %ecx,%edi
  801c25:	77 65                	ja     801c8c <__udivdi3+0x8c>
  801c27:	89 fd                	mov    %edi,%ebp
  801c29:	85 ff                	test   %edi,%edi
  801c2b:	75 0b                	jne    801c38 <__udivdi3+0x38>
  801c2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c32:	31 d2                	xor    %edx,%edx
  801c34:	f7 f7                	div    %edi
  801c36:	89 c5                	mov    %eax,%ebp
  801c38:	31 d2                	xor    %edx,%edx
  801c3a:	89 c8                	mov    %ecx,%eax
  801c3c:	f7 f5                	div    %ebp
  801c3e:	89 c1                	mov    %eax,%ecx
  801c40:	89 d8                	mov    %ebx,%eax
  801c42:	f7 f5                	div    %ebp
  801c44:	89 cf                	mov    %ecx,%edi
  801c46:	89 fa                	mov    %edi,%edx
  801c48:	83 c4 1c             	add    $0x1c,%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5f                   	pop    %edi
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    
  801c50:	39 ce                	cmp    %ecx,%esi
  801c52:	77 28                	ja     801c7c <__udivdi3+0x7c>
  801c54:	0f bd fe             	bsr    %esi,%edi
  801c57:	83 f7 1f             	xor    $0x1f,%edi
  801c5a:	75 40                	jne    801c9c <__udivdi3+0x9c>
  801c5c:	39 ce                	cmp    %ecx,%esi
  801c5e:	72 0a                	jb     801c6a <__udivdi3+0x6a>
  801c60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c64:	0f 87 9e 00 00 00    	ja     801d08 <__udivdi3+0x108>
  801c6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6f:	89 fa                	mov    %edi,%edx
  801c71:	83 c4 1c             	add    $0x1c,%esp
  801c74:	5b                   	pop    %ebx
  801c75:	5e                   	pop    %esi
  801c76:	5f                   	pop    %edi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    
  801c79:	8d 76 00             	lea    0x0(%esi),%esi
  801c7c:	31 ff                	xor    %edi,%edi
  801c7e:	31 c0                	xor    %eax,%eax
  801c80:	89 fa                	mov    %edi,%edx
  801c82:	83 c4 1c             	add    $0x1c,%esp
  801c85:	5b                   	pop    %ebx
  801c86:	5e                   	pop    %esi
  801c87:	5f                   	pop    %edi
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    
  801c8a:	66 90                	xchg   %ax,%ax
  801c8c:	89 d8                	mov    %ebx,%eax
  801c8e:	f7 f7                	div    %edi
  801c90:	31 ff                	xor    %edi,%edi
  801c92:	89 fa                	mov    %edi,%edx
  801c94:	83 c4 1c             	add    $0x1c,%esp
  801c97:	5b                   	pop    %ebx
  801c98:	5e                   	pop    %esi
  801c99:	5f                   	pop    %edi
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    
  801c9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ca1:	89 eb                	mov    %ebp,%ebx
  801ca3:	29 fb                	sub    %edi,%ebx
  801ca5:	89 f9                	mov    %edi,%ecx
  801ca7:	d3 e6                	shl    %cl,%esi
  801ca9:	89 c5                	mov    %eax,%ebp
  801cab:	88 d9                	mov    %bl,%cl
  801cad:	d3 ed                	shr    %cl,%ebp
  801caf:	89 e9                	mov    %ebp,%ecx
  801cb1:	09 f1                	or     %esi,%ecx
  801cb3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cb7:	89 f9                	mov    %edi,%ecx
  801cb9:	d3 e0                	shl    %cl,%eax
  801cbb:	89 c5                	mov    %eax,%ebp
  801cbd:	89 d6                	mov    %edx,%esi
  801cbf:	88 d9                	mov    %bl,%cl
  801cc1:	d3 ee                	shr    %cl,%esi
  801cc3:	89 f9                	mov    %edi,%ecx
  801cc5:	d3 e2                	shl    %cl,%edx
  801cc7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ccb:	88 d9                	mov    %bl,%cl
  801ccd:	d3 e8                	shr    %cl,%eax
  801ccf:	09 c2                	or     %eax,%edx
  801cd1:	89 d0                	mov    %edx,%eax
  801cd3:	89 f2                	mov    %esi,%edx
  801cd5:	f7 74 24 0c          	divl   0xc(%esp)
  801cd9:	89 d6                	mov    %edx,%esi
  801cdb:	89 c3                	mov    %eax,%ebx
  801cdd:	f7 e5                	mul    %ebp
  801cdf:	39 d6                	cmp    %edx,%esi
  801ce1:	72 19                	jb     801cfc <__udivdi3+0xfc>
  801ce3:	74 0b                	je     801cf0 <__udivdi3+0xf0>
  801ce5:	89 d8                	mov    %ebx,%eax
  801ce7:	31 ff                	xor    %edi,%edi
  801ce9:	e9 58 ff ff ff       	jmp    801c46 <__udivdi3+0x46>
  801cee:	66 90                	xchg   %ax,%ax
  801cf0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cf4:	89 f9                	mov    %edi,%ecx
  801cf6:	d3 e2                	shl    %cl,%edx
  801cf8:	39 c2                	cmp    %eax,%edx
  801cfa:	73 e9                	jae    801ce5 <__udivdi3+0xe5>
  801cfc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cff:	31 ff                	xor    %edi,%edi
  801d01:	e9 40 ff ff ff       	jmp    801c46 <__udivdi3+0x46>
  801d06:	66 90                	xchg   %ax,%ax
  801d08:	31 c0                	xor    %eax,%eax
  801d0a:	e9 37 ff ff ff       	jmp    801c46 <__udivdi3+0x46>
  801d0f:	90                   	nop

00801d10 <__umoddi3>:
  801d10:	55                   	push   %ebp
  801d11:	57                   	push   %edi
  801d12:	56                   	push   %esi
  801d13:	53                   	push   %ebx
  801d14:	83 ec 1c             	sub    $0x1c,%esp
  801d17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d2f:	89 f3                	mov    %esi,%ebx
  801d31:	89 fa                	mov    %edi,%edx
  801d33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d37:	89 34 24             	mov    %esi,(%esp)
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	75 1a                	jne    801d58 <__umoddi3+0x48>
  801d3e:	39 f7                	cmp    %esi,%edi
  801d40:	0f 86 a2 00 00 00    	jbe    801de8 <__umoddi3+0xd8>
  801d46:	89 c8                	mov    %ecx,%eax
  801d48:	89 f2                	mov    %esi,%edx
  801d4a:	f7 f7                	div    %edi
  801d4c:	89 d0                	mov    %edx,%eax
  801d4e:	31 d2                	xor    %edx,%edx
  801d50:	83 c4 1c             	add    $0x1c,%esp
  801d53:	5b                   	pop    %ebx
  801d54:	5e                   	pop    %esi
  801d55:	5f                   	pop    %edi
  801d56:	5d                   	pop    %ebp
  801d57:	c3                   	ret    
  801d58:	39 f0                	cmp    %esi,%eax
  801d5a:	0f 87 ac 00 00 00    	ja     801e0c <__umoddi3+0xfc>
  801d60:	0f bd e8             	bsr    %eax,%ebp
  801d63:	83 f5 1f             	xor    $0x1f,%ebp
  801d66:	0f 84 ac 00 00 00    	je     801e18 <__umoddi3+0x108>
  801d6c:	bf 20 00 00 00       	mov    $0x20,%edi
  801d71:	29 ef                	sub    %ebp,%edi
  801d73:	89 fe                	mov    %edi,%esi
  801d75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d79:	89 e9                	mov    %ebp,%ecx
  801d7b:	d3 e0                	shl    %cl,%eax
  801d7d:	89 d7                	mov    %edx,%edi
  801d7f:	89 f1                	mov    %esi,%ecx
  801d81:	d3 ef                	shr    %cl,%edi
  801d83:	09 c7                	or     %eax,%edi
  801d85:	89 e9                	mov    %ebp,%ecx
  801d87:	d3 e2                	shl    %cl,%edx
  801d89:	89 14 24             	mov    %edx,(%esp)
  801d8c:	89 d8                	mov    %ebx,%eax
  801d8e:	d3 e0                	shl    %cl,%eax
  801d90:	89 c2                	mov    %eax,%edx
  801d92:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d96:	d3 e0                	shl    %cl,%eax
  801d98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801da0:	89 f1                	mov    %esi,%ecx
  801da2:	d3 e8                	shr    %cl,%eax
  801da4:	09 d0                	or     %edx,%eax
  801da6:	d3 eb                	shr    %cl,%ebx
  801da8:	89 da                	mov    %ebx,%edx
  801daa:	f7 f7                	div    %edi
  801dac:	89 d3                	mov    %edx,%ebx
  801dae:	f7 24 24             	mull   (%esp)
  801db1:	89 c6                	mov    %eax,%esi
  801db3:	89 d1                	mov    %edx,%ecx
  801db5:	39 d3                	cmp    %edx,%ebx
  801db7:	0f 82 87 00 00 00    	jb     801e44 <__umoddi3+0x134>
  801dbd:	0f 84 91 00 00 00    	je     801e54 <__umoddi3+0x144>
  801dc3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dc7:	29 f2                	sub    %esi,%edx
  801dc9:	19 cb                	sbb    %ecx,%ebx
  801dcb:	89 d8                	mov    %ebx,%eax
  801dcd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801dd1:	d3 e0                	shl    %cl,%eax
  801dd3:	89 e9                	mov    %ebp,%ecx
  801dd5:	d3 ea                	shr    %cl,%edx
  801dd7:	09 d0                	or     %edx,%eax
  801dd9:	89 e9                	mov    %ebp,%ecx
  801ddb:	d3 eb                	shr    %cl,%ebx
  801ddd:	89 da                	mov    %ebx,%edx
  801ddf:	83 c4 1c             	add    $0x1c,%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5f                   	pop    %edi
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    
  801de7:	90                   	nop
  801de8:	89 fd                	mov    %edi,%ebp
  801dea:	85 ff                	test   %edi,%edi
  801dec:	75 0b                	jne    801df9 <__umoddi3+0xe9>
  801dee:	b8 01 00 00 00       	mov    $0x1,%eax
  801df3:	31 d2                	xor    %edx,%edx
  801df5:	f7 f7                	div    %edi
  801df7:	89 c5                	mov    %eax,%ebp
  801df9:	89 f0                	mov    %esi,%eax
  801dfb:	31 d2                	xor    %edx,%edx
  801dfd:	f7 f5                	div    %ebp
  801dff:	89 c8                	mov    %ecx,%eax
  801e01:	f7 f5                	div    %ebp
  801e03:	89 d0                	mov    %edx,%eax
  801e05:	e9 44 ff ff ff       	jmp    801d4e <__umoddi3+0x3e>
  801e0a:	66 90                	xchg   %ax,%ax
  801e0c:	89 c8                	mov    %ecx,%eax
  801e0e:	89 f2                	mov    %esi,%edx
  801e10:	83 c4 1c             	add    $0x1c,%esp
  801e13:	5b                   	pop    %ebx
  801e14:	5e                   	pop    %esi
  801e15:	5f                   	pop    %edi
  801e16:	5d                   	pop    %ebp
  801e17:	c3                   	ret    
  801e18:	3b 04 24             	cmp    (%esp),%eax
  801e1b:	72 06                	jb     801e23 <__umoddi3+0x113>
  801e1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e21:	77 0f                	ja     801e32 <__umoddi3+0x122>
  801e23:	89 f2                	mov    %esi,%edx
  801e25:	29 f9                	sub    %edi,%ecx
  801e27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e2b:	89 14 24             	mov    %edx,(%esp)
  801e2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e32:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e36:	8b 14 24             	mov    (%esp),%edx
  801e39:	83 c4 1c             	add    $0x1c,%esp
  801e3c:	5b                   	pop    %ebx
  801e3d:	5e                   	pop    %esi
  801e3e:	5f                   	pop    %edi
  801e3f:	5d                   	pop    %ebp
  801e40:	c3                   	ret    
  801e41:	8d 76 00             	lea    0x0(%esi),%esi
  801e44:	2b 04 24             	sub    (%esp),%eax
  801e47:	19 fa                	sbb    %edi,%edx
  801e49:	89 d1                	mov    %edx,%ecx
  801e4b:	89 c6                	mov    %eax,%esi
  801e4d:	e9 71 ff ff ff       	jmp    801dc3 <__umoddi3+0xb3>
  801e52:	66 90                	xchg   %ax,%ax
  801e54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e58:	72 ea                	jb     801e44 <__umoddi3+0x134>
  801e5a:	89 d9                	mov    %ebx,%ecx
  801e5c:	e9 62 ff ff ff       	jmp    801dc3 <__umoddi3+0xb3>
