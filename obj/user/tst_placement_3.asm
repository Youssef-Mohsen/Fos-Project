
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
  8000e8:	e8 0e 1a 00 00       	call   801afb <sys_check_LRU_lists>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(check == 0)
  8000f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8000f7:	75 14                	jne    80010d <_main+0xd5>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	68 00 1f 80 00       	push   $0x801f00
  800101:	6a 24                	push   $0x24
  800103:	68 82 1f 80 00       	push   $0x801f82
  800108:	e8 5e 04 00 00       	call   80056b <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010d:	e8 1b 16 00 00       	call   80172d <sys_pf_calculate_allocated_pages>
  800112:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int freePages = sys_calculate_free_frames();
  800115:	e8 c8 15 00 00       	call   8016e2 <sys_calculate_free_frames>
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
  800256:	68 9c 1f 80 00       	push   $0x801f9c
  80025b:	e8 c8 05 00 00       	call   800828 <cprintf>
  800260:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800263:	8a 85 c8 ff ff fe    	mov    -0x1000038(%ebp),%al
  800269:	3c ff                	cmp    $0xff,%al
  80026b:	74 17                	je     800284 <_main+0x24c>
  80026d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	68 cc 1f 80 00       	push   $0x801fcc
  80027c:	e8 a7 05 00 00       	call   800828 <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800284:	8a 85 c8 0f 00 ff    	mov    -0xfff038(%ebp),%al
  80028a:	3c ff                	cmp    $0xff,%al
  80028c:	74 17                	je     8002a5 <_main+0x26d>
  80028e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 cc 1f 80 00       	push   $0x801fcc
  80029d:	e8 86 05 00 00       	call   800828 <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8002a5:	8a 85 c8 ff 3f ff    	mov    -0xc00038(%ebp),%al
  8002ab:	3c ff                	cmp    $0xff,%al
  8002ad:	74 17                	je     8002c6 <_main+0x28e>
  8002af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	68 cc 1f 80 00       	push   $0x801fcc
  8002be:	e8 65 05 00 00       	call   800828 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8002c6:	8a 85 c8 0f 40 ff    	mov    -0xbff038(%ebp),%al
  8002cc:	3c ff                	cmp    $0xff,%al
  8002ce:	74 17                	je     8002e7 <_main+0x2af>
  8002d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 cc 1f 80 00       	push   $0x801fcc
  8002df:	e8 44 05 00 00       	call   800828 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8002e7:	8a 85 c8 ff 7f ff    	mov    -0x800038(%ebp),%al
  8002ed:	3c ff                	cmp    $0xff,%al
  8002ef:	74 17                	je     800308 <_main+0x2d0>
  8002f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002f8:	83 ec 0c             	sub    $0xc,%esp
  8002fb:	68 cc 1f 80 00       	push   $0x801fcc
  800300:	e8 23 05 00 00       	call   800828 <cprintf>
  800305:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800308:	8a 85 c8 0f 80 ff    	mov    -0x7ff038(%ebp),%al
  80030e:	3c ff                	cmp    $0xff,%al
  800310:	74 17                	je     800329 <_main+0x2f1>
  800312:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	68 cc 1f 80 00       	push   $0x801fcc
  800321:	e8 02 05 00 00       	call   800828 <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT written to Page File until it's replaced\n"); }
  800329:	e8 ff 13 00 00       	call   80172d <sys_pf_calculate_allocated_pages>
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	74 17                	je     80034a <_main+0x312>
  800333:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80033a:	83 ec 0c             	sub    $0xc,%esp
  80033d:	68 ec 1f 80 00       	push   $0x801fec
  800342:	e8 e1 04 00 00       	call   800828 <cprintf>
  800347:	83 c4 10             	add    $0x10,%esp

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  80034a:	c7 45 d0 07 00 00 00 	movl   $0x7,-0x30(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  800351:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800354:	e8 89 13 00 00       	call   8016e2 <sys_calculate_free_frames>
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
  800378:	68 34 20 80 00       	push   $0x802034
  80037d:	e8 a6 04 00 00       	call   800828 <cprintf>
  800382:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  800385:	83 ec 0c             	sub    $0xc,%esp
  800388:	68 74 20 80 00       	push   $0x802074
  80038d:	e8 96 04 00 00       	call   800828 <cprintf>
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
  8003a9:	68 a8 20 80 00       	push   $0x8020a8
  8003ae:	e8 75 04 00 00       	call   800828 <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  8003b6:	6a 04                	push   $0x4
  8003b8:	6a 0d                	push   $0xd
  8003ba:	8d 85 78 ff ff fe    	lea    -0x1000088(%ebp),%eax
  8003c0:	50                   	push   %eax
  8003c1:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 2e 17 00 00       	call   801afb <sys_check_LRU_lists>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if(check == 0)
  8003d3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8003d7:	75 17                	jne    8003f0 <_main+0x3b8>
			{ is_correct = 0; cprintf("LRU lists entries are not correct, check your logic again!!\n"); }
  8003d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003e0:	83 ec 0c             	sub    $0xc,%esp
  8003e3:	68 f4 20 80 00       	push   $0x8020f4
  8003e8:	e8 3b 04 00 00       	call   800828 <cprintf>
  8003ed:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B passed: checking LRU lists entries After Required PAGES IN SECOND LIST test are correct\n\n\n");
  8003f0:	83 ec 0c             	sub    $0xc,%esp
  8003f3:	68 34 21 80 00       	push   $0x802134
  8003f8:	e8 2b 04 00 00       	call   800828 <cprintf>
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
  800417:	68 98 21 80 00       	push   $0x802198
  80041c:	e8 07 04 00 00       	call   800828 <cprintf>
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
  800432:	e8 74 14 00 00       	call   8018ab <sys_getenvindex>
  800437:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80043a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	c1 e0 03             	shl    $0x3,%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80044b:	01 c8                	add    %ecx,%eax
  80044d:	01 c0                	add    %eax,%eax
  80044f:	01 d0                	add    %edx,%eax
  800451:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800458:	01 c8                	add    %ecx,%eax
  80045a:	01 d0                	add    %edx,%eax
  80045c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800461:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800466:	a1 04 30 80 00       	mov    0x803004,%eax
  80046b:	8a 40 20             	mov    0x20(%eax),%al
  80046e:	84 c0                	test   %al,%al
  800470:	74 0d                	je     80047f <libmain+0x53>
		binaryname = myEnv->prog_name;
  800472:	a1 04 30 80 00       	mov    0x803004,%eax
  800477:	83 c0 20             	add    $0x20,%eax
  80047a:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80047f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800483:	7e 0a                	jle    80048f <libmain+0x63>
		binaryname = argv[0];
  800485:	8b 45 0c             	mov    0xc(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	ff 75 0c             	pushl  0xc(%ebp)
  800495:	ff 75 08             	pushl  0x8(%ebp)
  800498:	e8 9b fb ff ff       	call   800038 <_main>
  80049d:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8004a0:	e8 8a 11 00 00       	call   80162f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8004a5:	83 ec 0c             	sub    $0xc,%esp
  8004a8:	68 00 22 80 00       	push   $0x802200
  8004ad:	e8 76 03 00 00       	call   800828 <cprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ba:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8004c0:	a1 04 30 80 00       	mov    0x803004,%eax
  8004c5:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	52                   	push   %edx
  8004cf:	50                   	push   %eax
  8004d0:	68 28 22 80 00       	push   $0x802228
  8004d5:	e8 4e 03 00 00       	call   800828 <cprintf>
  8004da:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004dd:	a1 04 30 80 00       	mov    0x803004,%eax
  8004e2:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8004e8:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ed:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8004f3:	a1 04 30 80 00       	mov    0x803004,%eax
  8004f8:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8004fe:	51                   	push   %ecx
  8004ff:	52                   	push   %edx
  800500:	50                   	push   %eax
  800501:	68 50 22 80 00       	push   $0x802250
  800506:	e8 1d 03 00 00       	call   800828 <cprintf>
  80050b:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80050e:	a1 04 30 80 00       	mov    0x803004,%eax
  800513:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800519:	83 ec 08             	sub    $0x8,%esp
  80051c:	50                   	push   %eax
  80051d:	68 a8 22 80 00       	push   $0x8022a8
  800522:	e8 01 03 00 00       	call   800828 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80052a:	83 ec 0c             	sub    $0xc,%esp
  80052d:	68 00 22 80 00       	push   $0x802200
  800532:	e8 f1 02 00 00       	call   800828 <cprintf>
  800537:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80053a:	e8 0a 11 00 00       	call   801649 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80053f:	e8 19 00 00 00       	call   80055d <exit>
}
  800544:	90                   	nop
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	6a 00                	push   $0x0
  800552:	e8 20 13 00 00       	call   801877 <sys_destroy_env>
  800557:	83 c4 10             	add    $0x10,%esp
}
  80055a:	90                   	nop
  80055b:	c9                   	leave  
  80055c:	c3                   	ret    

0080055d <exit>:

void
exit(void)
{
  80055d:	55                   	push   %ebp
  80055e:	89 e5                	mov    %esp,%ebp
  800560:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800563:	e8 75 13 00 00       	call   8018dd <sys_exit_env>
}
  800568:	90                   	nop
  800569:	c9                   	leave  
  80056a:	c3                   	ret    

0080056b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80056b:	55                   	push   %ebp
  80056c:	89 e5                	mov    %esp,%ebp
  80056e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800571:	8d 45 10             	lea    0x10(%ebp),%eax
  800574:	83 c0 04             	add    $0x4,%eax
  800577:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80057a:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80057f:	85 c0                	test   %eax,%eax
  800581:	74 16                	je     800599 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800583:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800588:	83 ec 08             	sub    $0x8,%esp
  80058b:	50                   	push   %eax
  80058c:	68 bc 22 80 00       	push   $0x8022bc
  800591:	e8 92 02 00 00       	call   800828 <cprintf>
  800596:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800599:	a1 00 30 80 00       	mov    0x803000,%eax
  80059e:	ff 75 0c             	pushl  0xc(%ebp)
  8005a1:	ff 75 08             	pushl  0x8(%ebp)
  8005a4:	50                   	push   %eax
  8005a5:	68 c1 22 80 00       	push   $0x8022c1
  8005aa:	e8 79 02 00 00       	call   800828 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bb:	50                   	push   %eax
  8005bc:	e8 fc 01 00 00       	call   8007bd <vcprintf>
  8005c1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	6a 00                	push   $0x0
  8005c9:	68 dd 22 80 00       	push   $0x8022dd
  8005ce:	e8 ea 01 00 00       	call   8007bd <vcprintf>
  8005d3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005d6:	e8 82 ff ff ff       	call   80055d <exit>

	// should not return here
	while (1) ;
  8005db:	eb fe                	jmp    8005db <_panic+0x70>

008005dd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005dd:	55                   	push   %ebp
  8005de:	89 e5                	mov    %esp,%ebp
  8005e0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005e3:	a1 04 30 80 00       	mov    0x803004,%eax
  8005e8:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f1:	39 c2                	cmp    %eax,%edx
  8005f3:	74 14                	je     800609 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005f5:	83 ec 04             	sub    $0x4,%esp
  8005f8:	68 e0 22 80 00       	push   $0x8022e0
  8005fd:	6a 26                	push   $0x26
  8005ff:	68 2c 23 80 00       	push   $0x80232c
  800604:	e8 62 ff ff ff       	call   80056b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800609:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800610:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800617:	e9 c5 00 00 00       	jmp    8006e1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80061c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800626:	8b 45 08             	mov    0x8(%ebp),%eax
  800629:	01 d0                	add    %edx,%eax
  80062b:	8b 00                	mov    (%eax),%eax
  80062d:	85 c0                	test   %eax,%eax
  80062f:	75 08                	jne    800639 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800631:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800634:	e9 a5 00 00 00       	jmp    8006de <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800639:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800640:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800647:	eb 69                	jmp    8006b2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800649:	a1 04 30 80 00       	mov    0x803004,%eax
  80064e:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800654:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800657:	89 d0                	mov    %edx,%eax
  800659:	01 c0                	add    %eax,%eax
  80065b:	01 d0                	add    %edx,%eax
  80065d:	c1 e0 03             	shl    $0x3,%eax
  800660:	01 c8                	add    %ecx,%eax
  800662:	8a 40 04             	mov    0x4(%eax),%al
  800665:	84 c0                	test   %al,%al
  800667:	75 46                	jne    8006af <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800669:	a1 04 30 80 00       	mov    0x803004,%eax
  80066e:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800674:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	01 c0                	add    %eax,%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	c1 e0 03             	shl    $0x3,%eax
  800680:	01 c8                	add    %ecx,%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800687:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80068a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80068f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800694:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	01 c8                	add    %ecx,%eax
  8006a0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006a2:	39 c2                	cmp    %eax,%edx
  8006a4:	75 09                	jne    8006af <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006a6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006ad:	eb 15                	jmp    8006c4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006af:	ff 45 e8             	incl   -0x18(%ebp)
  8006b2:	a1 04 30 80 00       	mov    0x803004,%eax
  8006b7:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006c0:	39 c2                	cmp    %eax,%edx
  8006c2:	77 85                	ja     800649 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006c8:	75 14                	jne    8006de <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 38 23 80 00       	push   $0x802338
  8006d2:	6a 3a                	push   $0x3a
  8006d4:	68 2c 23 80 00       	push   $0x80232c
  8006d9:	e8 8d fe ff ff       	call   80056b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006de:	ff 45 f0             	incl   -0x10(%ebp)
  8006e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006e7:	0f 8c 2f ff ff ff    	jl     80061c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006fb:	eb 26                	jmp    800723 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800702:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800708:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80070b:	89 d0                	mov    %edx,%eax
  80070d:	01 c0                	add    %eax,%eax
  80070f:	01 d0                	add    %edx,%eax
  800711:	c1 e0 03             	shl    $0x3,%eax
  800714:	01 c8                	add    %ecx,%eax
  800716:	8a 40 04             	mov    0x4(%eax),%al
  800719:	3c 01                	cmp    $0x1,%al
  80071b:	75 03                	jne    800720 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80071d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800720:	ff 45 e0             	incl   -0x20(%ebp)
  800723:	a1 04 30 80 00       	mov    0x803004,%eax
  800728:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80072e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800731:	39 c2                	cmp    %eax,%edx
  800733:	77 c8                	ja     8006fd <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800738:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80073b:	74 14                	je     800751 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80073d:	83 ec 04             	sub    $0x4,%esp
  800740:	68 8c 23 80 00       	push   $0x80238c
  800745:	6a 44                	push   $0x44
  800747:	68 2c 23 80 00       	push   $0x80232c
  80074c:	e8 1a fe ff ff       	call   80056b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800751:	90                   	nop
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	8d 48 01             	lea    0x1(%eax),%ecx
  800762:	8b 55 0c             	mov    0xc(%ebp),%edx
  800765:	89 0a                	mov    %ecx,(%edx)
  800767:	8b 55 08             	mov    0x8(%ebp),%edx
  80076a:	88 d1                	mov    %dl,%cl
  80076c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80076f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800773:	8b 45 0c             	mov    0xc(%ebp),%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	3d ff 00 00 00       	cmp    $0xff,%eax
  80077d:	75 2c                	jne    8007ab <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80077f:	a0 08 30 80 00       	mov    0x803008,%al
  800784:	0f b6 c0             	movzbl %al,%eax
  800787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80078a:	8b 12                	mov    (%edx),%edx
  80078c:	89 d1                	mov    %edx,%ecx
  80078e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800791:	83 c2 08             	add    $0x8,%edx
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	50                   	push   %eax
  800798:	51                   	push   %ecx
  800799:	52                   	push   %edx
  80079a:	e8 4e 0e 00 00       	call   8015ed <sys_cputs>
  80079f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ae:	8b 40 04             	mov    0x4(%eax),%eax
  8007b1:	8d 50 01             	lea    0x1(%eax),%edx
  8007b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007ba:	90                   	nop
  8007bb:	c9                   	leave  
  8007bc:	c3                   	ret    

008007bd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
  8007c0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007c6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007cd:	00 00 00 
	b.cnt = 0;
  8007d0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007d7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	ff 75 08             	pushl  0x8(%ebp)
  8007e0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e6:	50                   	push   %eax
  8007e7:	68 54 07 80 00       	push   $0x800754
  8007ec:	e8 11 02 00 00       	call   800a02 <vprintfmt>
  8007f1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007f4:	a0 08 30 80 00       	mov    0x803008,%al
  8007f9:	0f b6 c0             	movzbl %al,%eax
  8007fc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800802:	83 ec 04             	sub    $0x4,%esp
  800805:	50                   	push   %eax
  800806:	52                   	push   %edx
  800807:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80080d:	83 c0 08             	add    $0x8,%eax
  800810:	50                   	push   %eax
  800811:	e8 d7 0d 00 00       	call   8015ed <sys_cputs>
  800816:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800819:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800820:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800826:	c9                   	leave  
  800827:	c3                   	ret    

00800828 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80082e:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800835:	8d 45 0c             	lea    0xc(%ebp),%eax
  800838:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 f4             	pushl  -0xc(%ebp)
  800844:	50                   	push   %eax
  800845:	e8 73 ff ff ff       	call   8007bd <vcprintf>
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800850:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800853:	c9                   	leave  
  800854:	c3                   	ret    

00800855 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80085b:	e8 cf 0d 00 00       	call   80162f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800860:	8d 45 0c             	lea    0xc(%ebp),%eax
  800863:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	ff 75 f4             	pushl  -0xc(%ebp)
  80086f:	50                   	push   %eax
  800870:	e8 48 ff ff ff       	call   8007bd <vcprintf>
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80087b:	e8 c9 0d 00 00       	call   801649 <sys_unlock_cons>
	return cnt;
  800880:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800883:	c9                   	leave  
  800884:	c3                   	ret    

00800885 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	83 ec 14             	sub    $0x14,%esp
  80088c:	8b 45 10             	mov    0x10(%ebp),%eax
  80088f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800898:	8b 45 18             	mov    0x18(%ebp),%eax
  80089b:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008a3:	77 55                	ja     8008fa <printnum+0x75>
  8008a5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008a8:	72 05                	jb     8008af <printnum+0x2a>
  8008aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008ad:	77 4b                	ja     8008fa <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008af:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008b2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8008b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8008bd:	52                   	push   %edx
  8008be:	50                   	push   %eax
  8008bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8008c5:	e8 be 13 00 00       	call   801c88 <__udivdi3>
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	ff 75 20             	pushl  0x20(%ebp)
  8008d3:	53                   	push   %ebx
  8008d4:	ff 75 18             	pushl  0x18(%ebp)
  8008d7:	52                   	push   %edx
  8008d8:	50                   	push   %eax
  8008d9:	ff 75 0c             	pushl  0xc(%ebp)
  8008dc:	ff 75 08             	pushl  0x8(%ebp)
  8008df:	e8 a1 ff ff ff       	call   800885 <printnum>
  8008e4:	83 c4 20             	add    $0x20,%esp
  8008e7:	eb 1a                	jmp    800903 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	ff 75 20             	pushl  0x20(%ebp)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	ff d0                	call   *%eax
  8008f7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008fa:	ff 4d 1c             	decl   0x1c(%ebp)
  8008fd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800901:	7f e6                	jg     8008e9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800903:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800906:	bb 00 00 00 00       	mov    $0x0,%ebx
  80090b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800911:	53                   	push   %ebx
  800912:	51                   	push   %ecx
  800913:	52                   	push   %edx
  800914:	50                   	push   %eax
  800915:	e8 7e 14 00 00       	call   801d98 <__umoddi3>
  80091a:	83 c4 10             	add    $0x10,%esp
  80091d:	05 f4 25 80 00       	add    $0x8025f4,%eax
  800922:	8a 00                	mov    (%eax),%al
  800924:	0f be c0             	movsbl %al,%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	50                   	push   %eax
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
}
  800936:	90                   	nop
  800937:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    

0080093c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80093f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800943:	7e 1c                	jle    800961 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  80095f:	eb 40                	jmp    8009a1 <getuint+0x65>
	else if (lflag)
  800961:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800965:	74 1e                	je     800985 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	8d 50 04             	lea    0x4(%eax),%edx
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	89 10                	mov    %edx,(%eax)
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	83 e8 04             	sub    $0x4,%eax
  80097c:	8b 00                	mov    (%eax),%eax
  80097e:	ba 00 00 00 00       	mov    $0x0,%edx
  800983:	eb 1c                	jmp    8009a1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8b 00                	mov    (%eax),%eax
  80098a:	8d 50 04             	lea    0x4(%eax),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	89 10                	mov    %edx,(%eax)
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	83 e8 04             	sub    $0x4,%eax
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009a1:	5d                   	pop    %ebp
  8009a2:	c3                   	ret    

008009a3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009a6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009aa:	7e 1c                	jle    8009c8 <getint+0x25>
		return va_arg(*ap, long long);
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	8d 50 08             	lea    0x8(%eax),%edx
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	89 10                	mov    %edx,(%eax)
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 00                	mov    (%eax),%eax
  8009be:	83 e8 08             	sub    $0x8,%eax
  8009c1:	8b 50 04             	mov    0x4(%eax),%edx
  8009c4:	8b 00                	mov    (%eax),%eax
  8009c6:	eb 38                	jmp    800a00 <getint+0x5d>
	else if (lflag)
  8009c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009cc:	74 1a                	je     8009e8 <getint+0x45>
		return va_arg(*ap, long);
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	8b 00                	mov    (%eax),%eax
  8009d3:	8d 50 04             	lea    0x4(%eax),%edx
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	89 10                	mov    %edx,(%eax)
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	83 e8 04             	sub    $0x4,%eax
  8009e3:	8b 00                	mov    (%eax),%eax
  8009e5:	99                   	cltd   
  8009e6:	eb 18                	jmp    800a00 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	8d 50 04             	lea    0x4(%eax),%edx
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	89 10                	mov    %edx,(%eax)
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	8b 00                	mov    (%eax),%eax
  8009fa:	83 e8 04             	sub    $0x4,%eax
  8009fd:	8b 00                	mov    (%eax),%eax
  8009ff:	99                   	cltd   
}
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    

00800a02 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	56                   	push   %esi
  800a06:	53                   	push   %ebx
  800a07:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a0a:	eb 17                	jmp    800a23 <vprintfmt+0x21>
			if (ch == '\0')
  800a0c:	85 db                	test   %ebx,%ebx
  800a0e:	0f 84 c1 03 00 00    	je     800dd5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	53                   	push   %ebx
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a23:	8b 45 10             	mov    0x10(%ebp),%eax
  800a26:	8d 50 01             	lea    0x1(%eax),%edx
  800a29:	89 55 10             	mov    %edx,0x10(%ebp)
  800a2c:	8a 00                	mov    (%eax),%al
  800a2e:	0f b6 d8             	movzbl %al,%ebx
  800a31:	83 fb 25             	cmp    $0x25,%ebx
  800a34:	75 d6                	jne    800a0c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a36:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a3a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a41:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a48:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a4f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a56:	8b 45 10             	mov    0x10(%ebp),%eax
  800a59:	8d 50 01             	lea    0x1(%eax),%edx
  800a5c:	89 55 10             	mov    %edx,0x10(%ebp)
  800a5f:	8a 00                	mov    (%eax),%al
  800a61:	0f b6 d8             	movzbl %al,%ebx
  800a64:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a67:	83 f8 5b             	cmp    $0x5b,%eax
  800a6a:	0f 87 3d 03 00 00    	ja     800dad <vprintfmt+0x3ab>
  800a70:	8b 04 85 18 26 80 00 	mov    0x802618(,%eax,4),%eax
  800a77:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a79:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a7d:	eb d7                	jmp    800a56 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a7f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a83:	eb d1                	jmp    800a56 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a85:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8f:	89 d0                	mov    %edx,%eax
  800a91:	c1 e0 02             	shl    $0x2,%eax
  800a94:	01 d0                	add    %edx,%eax
  800a96:	01 c0                	add    %eax,%eax
  800a98:	01 d8                	add    %ebx,%eax
  800a9a:	83 e8 30             	sub    $0x30,%eax
  800a9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800aa0:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa3:	8a 00                	mov    (%eax),%al
  800aa5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800aa8:	83 fb 2f             	cmp    $0x2f,%ebx
  800aab:	7e 3e                	jle    800aeb <vprintfmt+0xe9>
  800aad:	83 fb 39             	cmp    $0x39,%ebx
  800ab0:	7f 39                	jg     800aeb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ab2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ab5:	eb d5                	jmp    800a8c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aba:	83 c0 04             	add    $0x4,%eax
  800abd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	83 e8 04             	sub    $0x4,%eax
  800ac6:	8b 00                	mov    (%eax),%eax
  800ac8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800acb:	eb 1f                	jmp    800aec <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	79 83                	jns    800a56 <vprintfmt+0x54>
				width = 0;
  800ad3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ada:	e9 77 ff ff ff       	jmp    800a56 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800adf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ae6:	e9 6b ff ff ff       	jmp    800a56 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aeb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af0:	0f 89 60 ff ff ff    	jns    800a56 <vprintfmt+0x54>
				width = precision, precision = -1;
  800af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800afc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b03:	e9 4e ff ff ff       	jmp    800a56 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b08:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b0b:	e9 46 ff ff ff       	jmp    800a56 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b10:	8b 45 14             	mov    0x14(%ebp),%eax
  800b13:	83 c0 04             	add    $0x4,%eax
  800b16:	89 45 14             	mov    %eax,0x14(%ebp)
  800b19:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1c:	83 e8 04             	sub    $0x4,%eax
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	83 ec 08             	sub    $0x8,%esp
  800b24:	ff 75 0c             	pushl  0xc(%ebp)
  800b27:	50                   	push   %eax
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	ff d0                	call   *%eax
  800b2d:	83 c4 10             	add    $0x10,%esp
			break;
  800b30:	e9 9b 02 00 00       	jmp    800dd0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	83 c0 04             	add    $0x4,%eax
  800b3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	83 e8 04             	sub    $0x4,%eax
  800b44:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b46:	85 db                	test   %ebx,%ebx
  800b48:	79 02                	jns    800b4c <vprintfmt+0x14a>
				err = -err;
  800b4a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b4c:	83 fb 64             	cmp    $0x64,%ebx
  800b4f:	7f 0b                	jg     800b5c <vprintfmt+0x15a>
  800b51:	8b 34 9d 60 24 80 00 	mov    0x802460(,%ebx,4),%esi
  800b58:	85 f6                	test   %esi,%esi
  800b5a:	75 19                	jne    800b75 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b5c:	53                   	push   %ebx
  800b5d:	68 05 26 80 00       	push   $0x802605
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	ff 75 08             	pushl  0x8(%ebp)
  800b68:	e8 70 02 00 00       	call   800ddd <printfmt>
  800b6d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b70:	e9 5b 02 00 00       	jmp    800dd0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b75:	56                   	push   %esi
  800b76:	68 0e 26 80 00       	push   $0x80260e
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	e8 57 02 00 00       	call   800ddd <printfmt>
  800b86:	83 c4 10             	add    $0x10,%esp
			break;
  800b89:	e9 42 02 00 00       	jmp    800dd0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b91:	83 c0 04             	add    $0x4,%eax
  800b94:	89 45 14             	mov    %eax,0x14(%ebp)
  800b97:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9a:	83 e8 04             	sub    $0x4,%eax
  800b9d:	8b 30                	mov    (%eax),%esi
  800b9f:	85 f6                	test   %esi,%esi
  800ba1:	75 05                	jne    800ba8 <vprintfmt+0x1a6>
				p = "(null)";
  800ba3:	be 11 26 80 00       	mov    $0x802611,%esi
			if (width > 0 && padc != '-')
  800ba8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bac:	7e 6d                	jle    800c1b <vprintfmt+0x219>
  800bae:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bb2:	74 67                	je     800c1b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	50                   	push   %eax
  800bbb:	56                   	push   %esi
  800bbc:	e8 1e 03 00 00       	call   800edf <strnlen>
  800bc1:	83 c4 10             	add    $0x10,%esp
  800bc4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800bc7:	eb 16                	jmp    800bdf <vprintfmt+0x1dd>
					putch(padc, putdat);
  800bc9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	50                   	push   %eax
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	ff d0                	call   *%eax
  800bd9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bdc:	ff 4d e4             	decl   -0x1c(%ebp)
  800bdf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be3:	7f e4                	jg     800bc9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be5:	eb 34                	jmp    800c1b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800be7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800beb:	74 1c                	je     800c09 <vprintfmt+0x207>
  800bed:	83 fb 1f             	cmp    $0x1f,%ebx
  800bf0:	7e 05                	jle    800bf7 <vprintfmt+0x1f5>
  800bf2:	83 fb 7e             	cmp    $0x7e,%ebx
  800bf5:	7e 12                	jle    800c09 <vprintfmt+0x207>
					putch('?', putdat);
  800bf7:	83 ec 08             	sub    $0x8,%esp
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	6a 3f                	push   $0x3f
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	ff d0                	call   *%eax
  800c04:	83 c4 10             	add    $0x10,%esp
  800c07:	eb 0f                	jmp    800c18 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c09:	83 ec 08             	sub    $0x8,%esp
  800c0c:	ff 75 0c             	pushl  0xc(%ebp)
  800c0f:	53                   	push   %ebx
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	ff d0                	call   *%eax
  800c15:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c18:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1b:	89 f0                	mov    %esi,%eax
  800c1d:	8d 70 01             	lea    0x1(%eax),%esi
  800c20:	8a 00                	mov    (%eax),%al
  800c22:	0f be d8             	movsbl %al,%ebx
  800c25:	85 db                	test   %ebx,%ebx
  800c27:	74 24                	je     800c4d <vprintfmt+0x24b>
  800c29:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c2d:	78 b8                	js     800be7 <vprintfmt+0x1e5>
  800c2f:	ff 4d e0             	decl   -0x20(%ebp)
  800c32:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c36:	79 af                	jns    800be7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c38:	eb 13                	jmp    800c4d <vprintfmt+0x24b>
				putch(' ', putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	6a 20                	push   $0x20
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c4a:	ff 4d e4             	decl   -0x1c(%ebp)
  800c4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c51:	7f e7                	jg     800c3a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c53:	e9 78 01 00 00       	jmp    800dd0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	ff 75 e8             	pushl  -0x18(%ebp)
  800c5e:	8d 45 14             	lea    0x14(%ebp),%eax
  800c61:	50                   	push   %eax
  800c62:	e8 3c fd ff ff       	call   8009a3 <getint>
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c76:	85 d2                	test   %edx,%edx
  800c78:	79 23                	jns    800c9d <vprintfmt+0x29b>
				putch('-', putdat);
  800c7a:	83 ec 08             	sub    $0x8,%esp
  800c7d:	ff 75 0c             	pushl  0xc(%ebp)
  800c80:	6a 2d                	push   $0x2d
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	ff d0                	call   *%eax
  800c87:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c90:	f7 d8                	neg    %eax
  800c92:	83 d2 00             	adc    $0x0,%edx
  800c95:	f7 da                	neg    %edx
  800c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c9d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ca4:	e9 bc 00 00 00       	jmp    800d65 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ca9:	83 ec 08             	sub    $0x8,%esp
  800cac:	ff 75 e8             	pushl  -0x18(%ebp)
  800caf:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb2:	50                   	push   %eax
  800cb3:	e8 84 fc ff ff       	call   80093c <getuint>
  800cb8:	83 c4 10             	add    $0x10,%esp
  800cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cc1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cc8:	e9 98 00 00 00       	jmp    800d65 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ccd:	83 ec 08             	sub    $0x8,%esp
  800cd0:	ff 75 0c             	pushl  0xc(%ebp)
  800cd3:	6a 58                	push   $0x58
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	ff d0                	call   *%eax
  800cda:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cdd:	83 ec 08             	sub    $0x8,%esp
  800ce0:	ff 75 0c             	pushl  0xc(%ebp)
  800ce3:	6a 58                	push   $0x58
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	ff d0                	call   *%eax
  800cea:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ced:	83 ec 08             	sub    $0x8,%esp
  800cf0:	ff 75 0c             	pushl  0xc(%ebp)
  800cf3:	6a 58                	push   $0x58
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	ff d0                	call   *%eax
  800cfa:	83 c4 10             	add    $0x10,%esp
			break;
  800cfd:	e9 ce 00 00 00       	jmp    800dd0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d02:	83 ec 08             	sub    $0x8,%esp
  800d05:	ff 75 0c             	pushl  0xc(%ebp)
  800d08:	6a 30                	push   $0x30
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	ff d0                	call   *%eax
  800d0f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	6a 78                	push   $0x78
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	ff d0                	call   *%eax
  800d1f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d22:	8b 45 14             	mov    0x14(%ebp),%eax
  800d25:	83 c0 04             	add    $0x4,%eax
  800d28:	89 45 14             	mov    %eax,0x14(%ebp)
  800d2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2e:	83 e8 04             	sub    $0x4,%eax
  800d31:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d3d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d44:	eb 1f                	jmp    800d65 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	ff 75 e8             	pushl  -0x18(%ebp)
  800d4c:	8d 45 14             	lea    0x14(%ebp),%eax
  800d4f:	50                   	push   %eax
  800d50:	e8 e7 fb ff ff       	call   80093c <getuint>
  800d55:	83 c4 10             	add    $0x10,%esp
  800d58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d5e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d65:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	52                   	push   %edx
  800d70:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d73:	50                   	push   %eax
  800d74:	ff 75 f4             	pushl  -0xc(%ebp)
  800d77:	ff 75 f0             	pushl  -0x10(%ebp)
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	ff 75 08             	pushl  0x8(%ebp)
  800d80:	e8 00 fb ff ff       	call   800885 <printnum>
  800d85:	83 c4 20             	add    $0x20,%esp
			break;
  800d88:	eb 46                	jmp    800dd0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d8a:	83 ec 08             	sub    $0x8,%esp
  800d8d:	ff 75 0c             	pushl  0xc(%ebp)
  800d90:	53                   	push   %ebx
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	ff d0                	call   *%eax
  800d96:	83 c4 10             	add    $0x10,%esp
			break;
  800d99:	eb 35                	jmp    800dd0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d9b:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800da2:	eb 2c                	jmp    800dd0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800da4:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800dab:	eb 23                	jmp    800dd0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dad:	83 ec 08             	sub    $0x8,%esp
  800db0:	ff 75 0c             	pushl  0xc(%ebp)
  800db3:	6a 25                	push   $0x25
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	ff d0                	call   *%eax
  800dba:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dbd:	ff 4d 10             	decl   0x10(%ebp)
  800dc0:	eb 03                	jmp    800dc5 <vprintfmt+0x3c3>
  800dc2:	ff 4d 10             	decl   0x10(%ebp)
  800dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc8:	48                   	dec    %eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	3c 25                	cmp    $0x25,%al
  800dcd:	75 f3                	jne    800dc2 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800dcf:	90                   	nop
		}
	}
  800dd0:	e9 35 fc ff ff       	jmp    800a0a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dd5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dd9:	5b                   	pop    %ebx
  800dda:	5e                   	pop    %esi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800de3:	8d 45 10             	lea    0x10(%ebp),%eax
  800de6:	83 c0 04             	add    $0x4,%eax
  800de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dec:	8b 45 10             	mov    0x10(%ebp),%eax
  800def:	ff 75 f4             	pushl  -0xc(%ebp)
  800df2:	50                   	push   %eax
  800df3:	ff 75 0c             	pushl  0xc(%ebp)
  800df6:	ff 75 08             	pushl  0x8(%ebp)
  800df9:	e8 04 fc ff ff       	call   800a02 <vprintfmt>
  800dfe:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e01:	90                   	nop
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0a:	8b 40 08             	mov    0x8(%eax),%eax
  800e0d:	8d 50 01             	lea    0x1(%eax),%edx
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e19:	8b 10                	mov    (%eax),%edx
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	8b 40 04             	mov    0x4(%eax),%eax
  800e21:	39 c2                	cmp    %eax,%edx
  800e23:	73 12                	jae    800e37 <sprintputch+0x33>
		*b->buf++ = ch;
  800e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e28:	8b 00                	mov    (%eax),%eax
  800e2a:	8d 48 01             	lea    0x1(%eax),%ecx
  800e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e30:	89 0a                	mov    %ecx,(%edx)
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	88 10                	mov    %dl,(%eax)
}
  800e37:	90                   	nop
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    

00800e3a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	01 d0                	add    %edx,%eax
  800e51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e5f:	74 06                	je     800e67 <vsnprintf+0x2d>
  800e61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e65:	7f 07                	jg     800e6e <vsnprintf+0x34>
		return -E_INVAL;
  800e67:	b8 03 00 00 00       	mov    $0x3,%eax
  800e6c:	eb 20                	jmp    800e8e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e6e:	ff 75 14             	pushl  0x14(%ebp)
  800e71:	ff 75 10             	pushl  0x10(%ebp)
  800e74:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e77:	50                   	push   %eax
  800e78:	68 04 0e 80 00       	push   $0x800e04
  800e7d:	e8 80 fb ff ff       	call   800a02 <vprintfmt>
  800e82:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e88:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e8e:	c9                   	leave  
  800e8f:	c3                   	ret    

00800e90 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e96:	8d 45 10             	lea    0x10(%ebp),%eax
  800e99:	83 c0 04             	add    $0x4,%eax
  800e9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea5:	50                   	push   %eax
  800ea6:	ff 75 0c             	pushl  0xc(%ebp)
  800ea9:	ff 75 08             	pushl  0x8(%ebp)
  800eac:	e8 89 ff ff ff       	call   800e3a <vsnprintf>
  800eb1:	83 c4 10             	add    $0x10,%esp
  800eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ec2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec9:	eb 06                	jmp    800ed1 <strlen+0x15>
		n++;
  800ecb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ece:	ff 45 08             	incl   0x8(%ebp)
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	84 c0                	test   %al,%al
  800ed8:	75 f1                	jne    800ecb <strlen+0xf>
		n++;
	return n;
  800eda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800edd:	c9                   	leave  
  800ede:	c3                   	ret    

00800edf <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ee5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eec:	eb 09                	jmp    800ef7 <strnlen+0x18>
		n++;
  800eee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ef1:	ff 45 08             	incl   0x8(%ebp)
  800ef4:	ff 4d 0c             	decl   0xc(%ebp)
  800ef7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800efb:	74 09                	je     800f06 <strnlen+0x27>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	84 c0                	test   %al,%al
  800f04:	75 e8                	jne    800eee <strnlen+0xf>
		n++;
	return n;
  800f06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f17:	90                   	nop
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8d 50 01             	lea    0x1(%eax),%edx
  800f1e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f27:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f2a:	8a 12                	mov    (%edx),%dl
  800f2c:	88 10                	mov    %dl,(%eax)
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	84 c0                	test   %al,%al
  800f32:	75 e4                	jne    800f18 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f37:	c9                   	leave  
  800f38:	c3                   	ret    

00800f39 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f4c:	eb 1f                	jmp    800f6d <strncpy+0x34>
		*dst++ = *src;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8d 50 01             	lea    0x1(%eax),%edx
  800f54:	89 55 08             	mov    %edx,0x8(%ebp)
  800f57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5a:	8a 12                	mov    (%edx),%dl
  800f5c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	84 c0                	test   %al,%al
  800f65:	74 03                	je     800f6a <strncpy+0x31>
			src++;
  800f67:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f6a:	ff 45 fc             	incl   -0x4(%ebp)
  800f6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f70:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f73:	72 d9                	jb     800f4e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f75:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f8a:	74 30                	je     800fbc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f8c:	eb 16                	jmp    800fa4 <strlcpy+0x2a>
			*dst++ = *src++;
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8d 50 01             	lea    0x1(%eax),%edx
  800f94:	89 55 08             	mov    %edx,0x8(%ebp)
  800f97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fa0:	8a 12                	mov    (%edx),%dl
  800fa2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fa4:	ff 4d 10             	decl   0x10(%ebp)
  800fa7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fab:	74 09                	je     800fb6 <strlcpy+0x3c>
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	84 c0                	test   %al,%al
  800fb4:	75 d8                	jne    800f8e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	29 c2                	sub    %eax,%edx
  800fc4:	89 d0                	mov    %edx,%eax
}
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    

00800fc8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fcb:	eb 06                	jmp    800fd3 <strcmp+0xb>
		p++, q++;
  800fcd:	ff 45 08             	incl   0x8(%ebp)
  800fd0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	84 c0                	test   %al,%al
  800fda:	74 0e                	je     800fea <strcmp+0x22>
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 10                	mov    (%eax),%dl
  800fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	38 c2                	cmp    %al,%dl
  800fe8:	74 e3                	je     800fcd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	0f b6 d0             	movzbl %al,%edx
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	0f b6 c0             	movzbl %al,%eax
  800ffa:	29 c2                	sub    %eax,%edx
  800ffc:	89 d0                	mov    %edx,%eax
}
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801003:	eb 09                	jmp    80100e <strncmp+0xe>
		n--, p++, q++;
  801005:	ff 4d 10             	decl   0x10(%ebp)
  801008:	ff 45 08             	incl   0x8(%ebp)
  80100b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80100e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801012:	74 17                	je     80102b <strncmp+0x2b>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	84 c0                	test   %al,%al
  80101b:	74 0e                	je     80102b <strncmp+0x2b>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 10                	mov    (%eax),%dl
  801022:	8b 45 0c             	mov    0xc(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	38 c2                	cmp    %al,%dl
  801029:	74 da                	je     801005 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80102b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102f:	75 07                	jne    801038 <strncmp+0x38>
		return 0;
  801031:	b8 00 00 00 00       	mov    $0x0,%eax
  801036:	eb 14                	jmp    80104c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f b6 d0             	movzbl %al,%edx
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 c0             	movzbl %al,%eax
  801048:	29 c2                	sub    %eax,%edx
  80104a:	89 d0                	mov    %edx,%eax
}
  80104c:	5d                   	pop    %ebp
  80104d:	c3                   	ret    

0080104e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	83 ec 04             	sub    $0x4,%esp
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80105a:	eb 12                	jmp    80106e <strchr+0x20>
		if (*s == c)
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801064:	75 05                	jne    80106b <strchr+0x1d>
			return (char *) s;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	eb 11                	jmp    80107c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80106b:	ff 45 08             	incl   0x8(%ebp)
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	84 c0                	test   %al,%al
  801075:	75 e5                	jne    80105c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801077:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80108a:	eb 0d                	jmp    801099 <strfind+0x1b>
		if (*s == c)
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801094:	74 0e                	je     8010a4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801096:	ff 45 08             	incl   0x8(%ebp)
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	84 c0                	test   %al,%al
  8010a0:	75 ea                	jne    80108c <strfind+0xe>
  8010a2:	eb 01                	jmp    8010a5 <strfind+0x27>
		if (*s == c)
			break;
  8010a4:	90                   	nop
	return (char *) s;
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010bc:	eb 0e                	jmp    8010cc <memset+0x22>
		*p++ = c;
  8010be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c1:	8d 50 01             	lea    0x1(%eax),%edx
  8010c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ca:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010cc:	ff 4d f8             	decl   -0x8(%ebp)
  8010cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010d3:	79 e9                	jns    8010be <memset+0x14>
		*p++ = c;

	return v;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010ec:	eb 16                	jmp    801104 <memcpy+0x2a>
		*d++ = *s++;
  8010ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f1:	8d 50 01             	lea    0x1(%eax),%edx
  8010f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801100:	8a 12                	mov    (%edx),%dl
  801102:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801104:	8b 45 10             	mov    0x10(%ebp),%eax
  801107:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110a:	89 55 10             	mov    %edx,0x10(%ebp)
  80110d:	85 c0                	test   %eax,%eax
  80110f:	75 dd                	jne    8010ee <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801114:	c9                   	leave  
  801115:	c3                   	ret    

00801116 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801128:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80112e:	73 50                	jae    801180 <memmove+0x6a>
  801130:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801133:	8b 45 10             	mov    0x10(%ebp),%eax
  801136:	01 d0                	add    %edx,%eax
  801138:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80113b:	76 43                	jbe    801180 <memmove+0x6a>
		s += n;
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801143:	8b 45 10             	mov    0x10(%ebp),%eax
  801146:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801149:	eb 10                	jmp    80115b <memmove+0x45>
			*--d = *--s;
  80114b:	ff 4d f8             	decl   -0x8(%ebp)
  80114e:	ff 4d fc             	decl   -0x4(%ebp)
  801151:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801154:	8a 10                	mov    (%eax),%dl
  801156:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801159:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80115b:	8b 45 10             	mov    0x10(%ebp),%eax
  80115e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801161:	89 55 10             	mov    %edx,0x10(%ebp)
  801164:	85 c0                	test   %eax,%eax
  801166:	75 e3                	jne    80114b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801168:	eb 23                	jmp    80118d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80116a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116d:	8d 50 01             	lea    0x1(%eax),%edx
  801170:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801173:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801176:	8d 4a 01             	lea    0x1(%edx),%ecx
  801179:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80117c:	8a 12                	mov    (%edx),%dl
  80117e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	8d 50 ff             	lea    -0x1(%eax),%edx
  801186:	89 55 10             	mov    %edx,0x10(%ebp)
  801189:	85 c0                	test   %eax,%eax
  80118b:	75 dd                	jne    80116a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80118d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801190:	c9                   	leave  
  801191:	c3                   	ret    

00801192 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80119e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011a4:	eb 2a                	jmp    8011d0 <memcmp+0x3e>
		if (*s1 != *s2)
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a9:	8a 10                	mov    (%eax),%dl
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	38 c2                	cmp    %al,%dl
  8011b2:	74 16                	je     8011ca <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	0f b6 d0             	movzbl %al,%edx
  8011bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	0f b6 c0             	movzbl %al,%eax
  8011c4:	29 c2                	sub    %eax,%edx
  8011c6:	89 d0                	mov    %edx,%eax
  8011c8:	eb 18                	jmp    8011e2 <memcmp+0x50>
		s1++, s2++;
  8011ca:	ff 45 fc             	incl   -0x4(%ebp)
  8011cd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	75 c9                	jne    8011a6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f0:	01 d0                	add    %edx,%eax
  8011f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011f5:	eb 15                	jmp    80120c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	0f b6 d0             	movzbl %al,%edx
  8011ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801202:	0f b6 c0             	movzbl %al,%eax
  801205:	39 c2                	cmp    %eax,%edx
  801207:	74 0d                	je     801216 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801209:	ff 45 08             	incl   0x8(%ebp)
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801212:	72 e3                	jb     8011f7 <memfind+0x13>
  801214:	eb 01                	jmp    801217 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801216:	90                   	nop
	return (void *) s;
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801222:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801229:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801230:	eb 03                	jmp    801235 <strtol+0x19>
		s++;
  801232:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 20                	cmp    $0x20,%al
  80123c:	74 f4                	je     801232 <strtol+0x16>
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	3c 09                	cmp    $0x9,%al
  801245:	74 eb                	je     801232 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	3c 2b                	cmp    $0x2b,%al
  80124e:	75 05                	jne    801255 <strtol+0x39>
		s++;
  801250:	ff 45 08             	incl   0x8(%ebp)
  801253:	eb 13                	jmp    801268 <strtol+0x4c>
	else if (*s == '-')
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	3c 2d                	cmp    $0x2d,%al
  80125c:	75 0a                	jne    801268 <strtol+0x4c>
		s++, neg = 1;
  80125e:	ff 45 08             	incl   0x8(%ebp)
  801261:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801268:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80126c:	74 06                	je     801274 <strtol+0x58>
  80126e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801272:	75 20                	jne    801294 <strtol+0x78>
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	3c 30                	cmp    $0x30,%al
  80127b:	75 17                	jne    801294 <strtol+0x78>
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	40                   	inc    %eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 78                	cmp    $0x78,%al
  801285:	75 0d                	jne    801294 <strtol+0x78>
		s += 2, base = 16;
  801287:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80128b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801292:	eb 28                	jmp    8012bc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801294:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801298:	75 15                	jne    8012af <strtol+0x93>
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	8a 00                	mov    (%eax),%al
  80129f:	3c 30                	cmp    $0x30,%al
  8012a1:	75 0c                	jne    8012af <strtol+0x93>
		s++, base = 8;
  8012a3:	ff 45 08             	incl   0x8(%ebp)
  8012a6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012ad:	eb 0d                	jmp    8012bc <strtol+0xa0>
	else if (base == 0)
  8012af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b3:	75 07                	jne    8012bc <strtol+0xa0>
		base = 10;
  8012b5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	8a 00                	mov    (%eax),%al
  8012c1:	3c 2f                	cmp    $0x2f,%al
  8012c3:	7e 19                	jle    8012de <strtol+0xc2>
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	8a 00                	mov    (%eax),%al
  8012ca:	3c 39                	cmp    $0x39,%al
  8012cc:	7f 10                	jg     8012de <strtol+0xc2>
			dig = *s - '0';
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	8a 00                	mov    (%eax),%al
  8012d3:	0f be c0             	movsbl %al,%eax
  8012d6:	83 e8 30             	sub    $0x30,%eax
  8012d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012dc:	eb 42                	jmp    801320 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	3c 60                	cmp    $0x60,%al
  8012e5:	7e 19                	jle    801300 <strtol+0xe4>
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	3c 7a                	cmp    $0x7a,%al
  8012ee:	7f 10                	jg     801300 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	8a 00                	mov    (%eax),%al
  8012f5:	0f be c0             	movsbl %al,%eax
  8012f8:	83 e8 57             	sub    $0x57,%eax
  8012fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012fe:	eb 20                	jmp    801320 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	3c 40                	cmp    $0x40,%al
  801307:	7e 39                	jle    801342 <strtol+0x126>
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	3c 5a                	cmp    $0x5a,%al
  801310:	7f 30                	jg     801342 <strtol+0x126>
			dig = *s - 'A' + 10;
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	0f be c0             	movsbl %al,%eax
  80131a:	83 e8 37             	sub    $0x37,%eax
  80131d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801323:	3b 45 10             	cmp    0x10(%ebp),%eax
  801326:	7d 19                	jge    801341 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801328:	ff 45 08             	incl   0x8(%ebp)
  80132b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801332:	89 c2                	mov    %eax,%edx
  801334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80133c:	e9 7b ff ff ff       	jmp    8012bc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801341:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801342:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801346:	74 08                	je     801350 <strtol+0x134>
		*endptr = (char *) s;
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	8b 55 08             	mov    0x8(%ebp),%edx
  80134e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801350:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801354:	74 07                	je     80135d <strtol+0x141>
  801356:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801359:	f7 d8                	neg    %eax
  80135b:	eb 03                	jmp    801360 <strtol+0x144>
  80135d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801360:	c9                   	leave  
  801361:	c3                   	ret    

00801362 <ltostr>:

void
ltostr(long value, char *str)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801368:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80136f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801376:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80137a:	79 13                	jns    80138f <ltostr+0x2d>
	{
		neg = 1;
  80137c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801383:	8b 45 0c             	mov    0xc(%ebp),%eax
  801386:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801389:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80138c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801397:	99                   	cltd   
  801398:	f7 f9                	idiv   %ecx
  80139a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80139d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a0:	8d 50 01             	lea    0x1(%eax),%edx
  8013a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a6:	89 c2                	mov    %eax,%edx
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	01 d0                	add    %edx,%eax
  8013ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013b0:	83 c2 30             	add    $0x30,%edx
  8013b3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013b8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013bd:	f7 e9                	imul   %ecx
  8013bf:	c1 fa 02             	sar    $0x2,%edx
  8013c2:	89 c8                	mov    %ecx,%eax
  8013c4:	c1 f8 1f             	sar    $0x1f,%eax
  8013c7:	29 c2                	sub    %eax,%edx
  8013c9:	89 d0                	mov    %edx,%eax
  8013cb:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013d2:	75 bb                	jne    80138f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013de:	48                   	dec    %eax
  8013df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013e6:	74 3d                	je     801425 <ltostr+0xc3>
		start = 1 ;
  8013e8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013ef:	eb 34                	jmp    801425 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	01 d0                	add    %edx,%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801401:	8b 45 0c             	mov    0xc(%ebp),%eax
  801404:	01 c2                	add    %eax,%edx
  801406:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140c:	01 c8                	add    %ecx,%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801412:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801415:	8b 45 0c             	mov    0xc(%ebp),%eax
  801418:	01 c2                	add    %eax,%edx
  80141a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80141d:	88 02                	mov    %al,(%edx)
		start++ ;
  80141f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801422:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801428:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80142b:	7c c4                	jl     8013f1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80142d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801430:	8b 45 0c             	mov    0xc(%ebp),%eax
  801433:	01 d0                	add    %edx,%eax
  801435:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801438:	90                   	nop
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801441:	ff 75 08             	pushl  0x8(%ebp)
  801444:	e8 73 fa ff ff       	call   800ebc <strlen>
  801449:	83 c4 04             	add    $0x4,%esp
  80144c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	e8 65 fa ff ff       	call   800ebc <strlen>
  801457:	83 c4 04             	add    $0x4,%esp
  80145a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80145d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801464:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80146b:	eb 17                	jmp    801484 <strcconcat+0x49>
		final[s] = str1[s] ;
  80146d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	01 c2                	add    %eax,%edx
  801475:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	01 c8                	add    %ecx,%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801481:	ff 45 fc             	incl   -0x4(%ebp)
  801484:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801487:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80148a:	7c e1                	jl     80146d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80148c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801493:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80149a:	eb 1f                	jmp    8014bb <strcconcat+0x80>
		final[s++] = str2[i] ;
  80149c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149f:	8d 50 01             	lea    0x1(%eax),%edx
  8014a2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014a5:	89 c2                	mov    %eax,%edx
  8014a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014aa:	01 c2                	add    %eax,%edx
  8014ac:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b2:	01 c8                	add    %ecx,%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014b8:	ff 45 f8             	incl   -0x8(%ebp)
  8014bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014c1:	7c d9                	jl     80149c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c9:	01 d0                	add    %edx,%eax
  8014cb:	c6 00 00             	movb   $0x0,(%eax)
}
  8014ce:	90                   	nop
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e0:	8b 00                	mov    (%eax),%eax
  8014e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	01 d0                	add    %edx,%eax
  8014ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014f4:	eb 0c                	jmp    801502 <strsplit+0x31>
			*string++ = 0;
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	8d 50 01             	lea    0x1(%eax),%edx
  8014fc:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ff:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	84 c0                	test   %al,%al
  801509:	74 18                	je     801523 <strsplit+0x52>
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 00                	mov    (%eax),%al
  801510:	0f be c0             	movsbl %al,%eax
  801513:	50                   	push   %eax
  801514:	ff 75 0c             	pushl  0xc(%ebp)
  801517:	e8 32 fb ff ff       	call   80104e <strchr>
  80151c:	83 c4 08             	add    $0x8,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	75 d3                	jne    8014f6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8a 00                	mov    (%eax),%al
  801528:	84 c0                	test   %al,%al
  80152a:	74 5a                	je     801586 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80152c:	8b 45 14             	mov    0x14(%ebp),%eax
  80152f:	8b 00                	mov    (%eax),%eax
  801531:	83 f8 0f             	cmp    $0xf,%eax
  801534:	75 07                	jne    80153d <strsplit+0x6c>
		{
			return 0;
  801536:	b8 00 00 00 00       	mov    $0x0,%eax
  80153b:	eb 66                	jmp    8015a3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80153d:	8b 45 14             	mov    0x14(%ebp),%eax
  801540:	8b 00                	mov    (%eax),%eax
  801542:	8d 48 01             	lea    0x1(%eax),%ecx
  801545:	8b 55 14             	mov    0x14(%ebp),%edx
  801548:	89 0a                	mov    %ecx,(%edx)
  80154a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801551:	8b 45 10             	mov    0x10(%ebp),%eax
  801554:	01 c2                	add    %eax,%edx
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80155b:	eb 03                	jmp    801560 <strsplit+0x8f>
			string++;
  80155d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	8a 00                	mov    (%eax),%al
  801565:	84 c0                	test   %al,%al
  801567:	74 8b                	je     8014f4 <strsplit+0x23>
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	8a 00                	mov    (%eax),%al
  80156e:	0f be c0             	movsbl %al,%eax
  801571:	50                   	push   %eax
  801572:	ff 75 0c             	pushl  0xc(%ebp)
  801575:	e8 d4 fa ff ff       	call   80104e <strchr>
  80157a:	83 c4 08             	add    $0x8,%esp
  80157d:	85 c0                	test   %eax,%eax
  80157f:	74 dc                	je     80155d <strsplit+0x8c>
			string++;
	}
  801581:	e9 6e ff ff ff       	jmp    8014f4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801586:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801587:	8b 45 14             	mov    0x14(%ebp),%eax
  80158a:	8b 00                	mov    (%eax),%eax
  80158c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801593:	8b 45 10             	mov    0x10(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80159e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8015ab:	83 ec 04             	sub    $0x4,%esp
  8015ae:	68 88 27 80 00       	push   $0x802788
  8015b3:	68 3f 01 00 00       	push   $0x13f
  8015b8:	68 aa 27 80 00       	push   $0x8027aa
  8015bd:	e8 a9 ef ff ff       	call   80056b <_panic>

008015c2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	57                   	push   %edi
  8015c6:	56                   	push   %esi
  8015c7:	53                   	push   %ebx
  8015c8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015d7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015da:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015dd:	cd 30                	int    $0x30
  8015df:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015e5:	83 c4 10             	add    $0x10,%esp
  8015e8:	5b                   	pop    %ebx
  8015e9:	5e                   	pop    %esi
  8015ea:	5f                   	pop    %edi
  8015eb:	5d                   	pop    %ebp
  8015ec:	c3                   	ret    

008015ed <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	52                   	push   %edx
  801605:	ff 75 0c             	pushl  0xc(%ebp)
  801608:	50                   	push   %eax
  801609:	6a 00                	push   $0x0
  80160b:	e8 b2 ff ff ff       	call   8015c2 <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
}
  801613:	90                   	nop
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_cgetc>:

int
sys_cgetc(void)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 02                	push   $0x2
  801625:	e8 98 ff ff ff       	call   8015c2 <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 03                	push   $0x3
  80163e:	e8 7f ff ff ff       	call   8015c2 <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
}
  801646:	90                   	nop
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 04                	push   $0x4
  801658:	e8 65 ff ff ff       	call   8015c2 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	90                   	nop
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801666:	8b 55 0c             	mov    0xc(%ebp),%edx
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	52                   	push   %edx
  801673:	50                   	push   %eax
  801674:	6a 08                	push   $0x8
  801676:	e8 47 ff ff ff       	call   8015c2 <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	56                   	push   %esi
  801684:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801685:	8b 75 18             	mov    0x18(%ebp),%esi
  801688:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	56                   	push   %esi
  801695:	53                   	push   %ebx
  801696:	51                   	push   %ecx
  801697:	52                   	push   %edx
  801698:	50                   	push   %eax
  801699:	6a 09                	push   $0x9
  80169b:	e8 22 ff ff ff       	call   8015c2 <syscall>
  8016a0:	83 c4 18             	add    $0x18,%esp
}
  8016a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a6:	5b                   	pop    %ebx
  8016a7:	5e                   	pop    %esi
  8016a8:	5d                   	pop    %ebp
  8016a9:	c3                   	ret    

008016aa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	52                   	push   %edx
  8016ba:	50                   	push   %eax
  8016bb:	6a 0a                	push   $0xa
  8016bd:	e8 00 ff ff ff       	call   8015c2 <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	ff 75 0c             	pushl  0xc(%ebp)
  8016d3:	ff 75 08             	pushl  0x8(%ebp)
  8016d6:	6a 0b                	push   $0xb
  8016d8:	e8 e5 fe ff ff       	call   8015c2 <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 0c                	push   $0xc
  8016f1:	e8 cc fe ff ff       	call   8015c2 <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 0d                	push   $0xd
  80170a:	e8 b3 fe ff ff       	call   8015c2 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 0e                	push   $0xe
  801723:	e8 9a fe ff ff       	call   8015c2 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 0f                	push   $0xf
  80173c:	e8 81 fe ff ff       	call   8015c2 <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	ff 75 08             	pushl  0x8(%ebp)
  801754:	6a 10                	push   $0x10
  801756:	e8 67 fe ff ff       	call   8015c2 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 11                	push   $0x11
  80176f:	e8 4e fe ff ff       	call   8015c2 <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	90                   	nop
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_cputc>:

void
sys_cputc(const char c)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 04             	sub    $0x4,%esp
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801786:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	50                   	push   %eax
  801793:	6a 01                	push   $0x1
  801795:	e8 28 fe ff ff       	call   8015c2 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	90                   	nop
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 14                	push   $0x14
  8017af:	e8 0e fe ff ff       	call   8015c2 <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	90                   	nop
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017c6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017c9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	6a 00                	push   $0x0
  8017d2:	51                   	push   %ecx
  8017d3:	52                   	push   %edx
  8017d4:	ff 75 0c             	pushl  0xc(%ebp)
  8017d7:	50                   	push   %eax
  8017d8:	6a 15                	push   $0x15
  8017da:	e8 e3 fd ff ff       	call   8015c2 <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	52                   	push   %edx
  8017f4:	50                   	push   %eax
  8017f5:	6a 16                	push   $0x16
  8017f7:	e8 c6 fd ff ff       	call   8015c2 <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801804:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	51                   	push   %ecx
  801812:	52                   	push   %edx
  801813:	50                   	push   %eax
  801814:	6a 17                	push   $0x17
  801816:	e8 a7 fd ff ff       	call   8015c2 <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	52                   	push   %edx
  801830:	50                   	push   %eax
  801831:	6a 18                	push   $0x18
  801833:	e8 8a fd ff ff       	call   8015c2 <syscall>
  801838:	83 c4 18             	add    $0x18,%esp
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	6a 00                	push   $0x0
  801845:	ff 75 14             	pushl  0x14(%ebp)
  801848:	ff 75 10             	pushl  0x10(%ebp)
  80184b:	ff 75 0c             	pushl  0xc(%ebp)
  80184e:	50                   	push   %eax
  80184f:	6a 19                	push   $0x19
  801851:	e8 6c fd ff ff       	call   8015c2 <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	50                   	push   %eax
  80186a:	6a 1a                	push   $0x1a
  80186c:	e8 51 fd ff ff       	call   8015c2 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	90                   	nop
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	50                   	push   %eax
  801886:	6a 1b                	push   $0x1b
  801888:	e8 35 fd ff ff       	call   8015c2 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 05                	push   $0x5
  8018a1:	e8 1c fd ff ff       	call   8015c2 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 06                	push   $0x6
  8018ba:	e8 03 fd ff ff       	call   8015c2 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 07                	push   $0x7
  8018d3:	e8 ea fc ff ff       	call   8015c2 <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_exit_env>:


void sys_exit_env(void)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 1c                	push   $0x1c
  8018ec:	e8 d1 fc ff ff       	call   8015c2 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	90                   	nop
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018fd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801900:	8d 50 04             	lea    0x4(%eax),%edx
  801903:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	52                   	push   %edx
  80190d:	50                   	push   %eax
  80190e:	6a 1d                	push   $0x1d
  801910:	e8 ad fc ff ff       	call   8015c2 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
	return result;
  801918:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80191b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801921:	89 01                	mov    %eax,(%ecx)
  801923:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	c9                   	leave  
  80192a:	c2 04 00             	ret    $0x4

0080192d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	ff 75 10             	pushl  0x10(%ebp)
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	ff 75 08             	pushl  0x8(%ebp)
  80193d:	6a 13                	push   $0x13
  80193f:	e8 7e fc ff ff       	call   8015c2 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return ;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_rcr2>:
uint32 sys_rcr2()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 1e                	push   $0x1e
  801959:	e8 64 fc ff ff       	call   8015c2 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 04             	sub    $0x4,%esp
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80196f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	50                   	push   %eax
  80197c:	6a 1f                	push   $0x1f
  80197e:	e8 3f fc ff ff       	call   8015c2 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
	return ;
  801986:	90                   	nop
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <rsttst>:
void rsttst()
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 21                	push   $0x21
  801998:	e8 25 fc ff ff       	call   8015c2 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a0:	90                   	nop
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 04             	sub    $0x4,%esp
  8019a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019af:	8b 55 18             	mov    0x18(%ebp),%edx
  8019b2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b6:	52                   	push   %edx
  8019b7:	50                   	push   %eax
  8019b8:	ff 75 10             	pushl  0x10(%ebp)
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	ff 75 08             	pushl  0x8(%ebp)
  8019c1:	6a 20                	push   $0x20
  8019c3:	e8 fa fb ff ff       	call   8015c2 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019cb:	90                   	nop
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <chktst>:
void chktst(uint32 n)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	ff 75 08             	pushl  0x8(%ebp)
  8019dc:	6a 22                	push   $0x22
  8019de:	e8 df fb ff ff       	call   8015c2 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e6:	90                   	nop
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <inctst>:

void inctst()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 23                	push   $0x23
  8019f8:	e8 c5 fb ff ff       	call   8015c2 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
	return ;
  801a00:	90                   	nop
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <gettst>:
uint32 gettst()
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 24                	push   $0x24
  801a12:	e8 ab fb ff ff       	call   8015c2 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 25                	push   $0x25
  801a2e:	e8 8f fb ff ff       	call   8015c2 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
  801a36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a39:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a3d:	75 07                	jne    801a46 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a3f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a44:	eb 05                	jmp    801a4b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 25                	push   $0x25
  801a5f:	e8 5e fb ff ff       	call   8015c2 <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
  801a67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a6a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a6e:	75 07                	jne    801a77 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a70:	b8 01 00 00 00       	mov    $0x1,%eax
  801a75:	eb 05                	jmp    801a7c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 25                	push   $0x25
  801a90:	e8 2d fb ff ff       	call   8015c2 <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
  801a98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a9b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a9f:	75 07                	jne    801aa8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801aa1:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa6:	eb 05                	jmp    801aad <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801aa8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 25                	push   $0x25
  801ac1:	e8 fc fa ff ff       	call   8015c2 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
  801ac9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801acc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ad0:	75 07                	jne    801ad9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ad2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad7:	eb 05                	jmp    801ade <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	ff 75 08             	pushl  0x8(%ebp)
  801aee:	6a 26                	push   $0x26
  801af0:	e8 cd fa ff ff       	call   8015c2 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
	return ;
  801af8:	90                   	nop
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801aff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	53                   	push   %ebx
  801b0e:	51                   	push   %ecx
  801b0f:	52                   	push   %edx
  801b10:	50                   	push   %eax
  801b11:	6a 27                	push   $0x27
  801b13:	e8 aa fa ff ff       	call   8015c2 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	6a 28                	push   $0x28
  801b33:	e8 8a fa ff ff       	call   8015c2 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b40:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	51                   	push   %ecx
  801b4c:	ff 75 10             	pushl  0x10(%ebp)
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 29                	push   $0x29
  801b53:	e8 6a fa ff ff       	call   8015c2 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	ff 75 10             	pushl  0x10(%ebp)
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	ff 75 08             	pushl  0x8(%ebp)
  801b6d:	6a 12                	push   $0x12
  801b6f:	e8 4e fa ff ff       	call   8015c2 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
	return ;
  801b77:	90                   	nop
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	52                   	push   %edx
  801b8a:	50                   	push   %eax
  801b8b:	6a 2a                	push   $0x2a
  801b8d:	e8 30 fa ff ff       	call   8015c2 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
	return;
  801b95:	90                   	nop
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	50                   	push   %eax
  801ba7:	6a 2b                	push   $0x2b
  801ba9:	e8 14 fa ff ff       	call   8015c2 <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	ff 75 08             	pushl  0x8(%ebp)
  801bc2:	6a 2c                	push   $0x2c
  801bc4:	e8 f9 f9 ff ff       	call   8015c2 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
	return;
  801bcc:	90                   	nop
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	ff 75 0c             	pushl  0xc(%ebp)
  801bdb:	ff 75 08             	pushl  0x8(%ebp)
  801bde:	6a 2d                	push   $0x2d
  801be0:	e8 dd f9 ff ff       	call   8015c2 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
	return;
  801be8:	90                   	nop
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 2e                	push   $0x2e
  801bfd:	e8 c0 f9 ff ff       	call   8015c2 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
  801c05:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801c08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	50                   	push   %eax
  801c1c:	6a 2f                	push   $0x2f
  801c1e:	e8 9f f9 ff ff       	call   8015c2 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
	return;
  801c26:	90                   	nop
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	52                   	push   %edx
  801c39:	50                   	push   %eax
  801c3a:	6a 30                	push   $0x30
  801c3c:	e8 81 f9 ff ff       	call   8015c2 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
	return;
  801c44:	90                   	nop
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	50                   	push   %eax
  801c59:	6a 31                	push   $0x31
  801c5b:	e8 62 f9 ff ff       	call   8015c2 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
  801c63:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	50                   	push   %eax
  801c7a:	6a 32                	push   $0x32
  801c7c:	e8 41 f9 ff ff       	call   8015c2 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
	return;
  801c84:	90                   	nop
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    
  801c87:	90                   	nop

00801c88 <__udivdi3>:
  801c88:	55                   	push   %ebp
  801c89:	57                   	push   %edi
  801c8a:	56                   	push   %esi
  801c8b:	53                   	push   %ebx
  801c8c:	83 ec 1c             	sub    $0x1c,%esp
  801c8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c9f:	89 ca                	mov    %ecx,%edx
  801ca1:	89 f8                	mov    %edi,%eax
  801ca3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ca7:	85 f6                	test   %esi,%esi
  801ca9:	75 2d                	jne    801cd8 <__udivdi3+0x50>
  801cab:	39 cf                	cmp    %ecx,%edi
  801cad:	77 65                	ja     801d14 <__udivdi3+0x8c>
  801caf:	89 fd                	mov    %edi,%ebp
  801cb1:	85 ff                	test   %edi,%edi
  801cb3:	75 0b                	jne    801cc0 <__udivdi3+0x38>
  801cb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cba:	31 d2                	xor    %edx,%edx
  801cbc:	f7 f7                	div    %edi
  801cbe:	89 c5                	mov    %eax,%ebp
  801cc0:	31 d2                	xor    %edx,%edx
  801cc2:	89 c8                	mov    %ecx,%eax
  801cc4:	f7 f5                	div    %ebp
  801cc6:	89 c1                	mov    %eax,%ecx
  801cc8:	89 d8                	mov    %ebx,%eax
  801cca:	f7 f5                	div    %ebp
  801ccc:	89 cf                	mov    %ecx,%edi
  801cce:	89 fa                	mov    %edi,%edx
  801cd0:	83 c4 1c             	add    $0x1c,%esp
  801cd3:	5b                   	pop    %ebx
  801cd4:	5e                   	pop    %esi
  801cd5:	5f                   	pop    %edi
  801cd6:	5d                   	pop    %ebp
  801cd7:	c3                   	ret    
  801cd8:	39 ce                	cmp    %ecx,%esi
  801cda:	77 28                	ja     801d04 <__udivdi3+0x7c>
  801cdc:	0f bd fe             	bsr    %esi,%edi
  801cdf:	83 f7 1f             	xor    $0x1f,%edi
  801ce2:	75 40                	jne    801d24 <__udivdi3+0x9c>
  801ce4:	39 ce                	cmp    %ecx,%esi
  801ce6:	72 0a                	jb     801cf2 <__udivdi3+0x6a>
  801ce8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cec:	0f 87 9e 00 00 00    	ja     801d90 <__udivdi3+0x108>
  801cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf7:	89 fa                	mov    %edi,%edx
  801cf9:	83 c4 1c             	add    $0x1c,%esp
  801cfc:	5b                   	pop    %ebx
  801cfd:	5e                   	pop    %esi
  801cfe:	5f                   	pop    %edi
  801cff:	5d                   	pop    %ebp
  801d00:	c3                   	ret    
  801d01:	8d 76 00             	lea    0x0(%esi),%esi
  801d04:	31 ff                	xor    %edi,%edi
  801d06:	31 c0                	xor    %eax,%eax
  801d08:	89 fa                	mov    %edi,%edx
  801d0a:	83 c4 1c             	add    $0x1c,%esp
  801d0d:	5b                   	pop    %ebx
  801d0e:	5e                   	pop    %esi
  801d0f:	5f                   	pop    %edi
  801d10:	5d                   	pop    %ebp
  801d11:	c3                   	ret    
  801d12:	66 90                	xchg   %ax,%ax
  801d14:	89 d8                	mov    %ebx,%eax
  801d16:	f7 f7                	div    %edi
  801d18:	31 ff                	xor    %edi,%edi
  801d1a:	89 fa                	mov    %edi,%edx
  801d1c:	83 c4 1c             	add    $0x1c,%esp
  801d1f:	5b                   	pop    %ebx
  801d20:	5e                   	pop    %esi
  801d21:	5f                   	pop    %edi
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    
  801d24:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d29:	89 eb                	mov    %ebp,%ebx
  801d2b:	29 fb                	sub    %edi,%ebx
  801d2d:	89 f9                	mov    %edi,%ecx
  801d2f:	d3 e6                	shl    %cl,%esi
  801d31:	89 c5                	mov    %eax,%ebp
  801d33:	88 d9                	mov    %bl,%cl
  801d35:	d3 ed                	shr    %cl,%ebp
  801d37:	89 e9                	mov    %ebp,%ecx
  801d39:	09 f1                	or     %esi,%ecx
  801d3b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d3f:	89 f9                	mov    %edi,%ecx
  801d41:	d3 e0                	shl    %cl,%eax
  801d43:	89 c5                	mov    %eax,%ebp
  801d45:	89 d6                	mov    %edx,%esi
  801d47:	88 d9                	mov    %bl,%cl
  801d49:	d3 ee                	shr    %cl,%esi
  801d4b:	89 f9                	mov    %edi,%ecx
  801d4d:	d3 e2                	shl    %cl,%edx
  801d4f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d53:	88 d9                	mov    %bl,%cl
  801d55:	d3 e8                	shr    %cl,%eax
  801d57:	09 c2                	or     %eax,%edx
  801d59:	89 d0                	mov    %edx,%eax
  801d5b:	89 f2                	mov    %esi,%edx
  801d5d:	f7 74 24 0c          	divl   0xc(%esp)
  801d61:	89 d6                	mov    %edx,%esi
  801d63:	89 c3                	mov    %eax,%ebx
  801d65:	f7 e5                	mul    %ebp
  801d67:	39 d6                	cmp    %edx,%esi
  801d69:	72 19                	jb     801d84 <__udivdi3+0xfc>
  801d6b:	74 0b                	je     801d78 <__udivdi3+0xf0>
  801d6d:	89 d8                	mov    %ebx,%eax
  801d6f:	31 ff                	xor    %edi,%edi
  801d71:	e9 58 ff ff ff       	jmp    801cce <__udivdi3+0x46>
  801d76:	66 90                	xchg   %ax,%ax
  801d78:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d7c:	89 f9                	mov    %edi,%ecx
  801d7e:	d3 e2                	shl    %cl,%edx
  801d80:	39 c2                	cmp    %eax,%edx
  801d82:	73 e9                	jae    801d6d <__udivdi3+0xe5>
  801d84:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d87:	31 ff                	xor    %edi,%edi
  801d89:	e9 40 ff ff ff       	jmp    801cce <__udivdi3+0x46>
  801d8e:	66 90                	xchg   %ax,%ax
  801d90:	31 c0                	xor    %eax,%eax
  801d92:	e9 37 ff ff ff       	jmp    801cce <__udivdi3+0x46>
  801d97:	90                   	nop

00801d98 <__umoddi3>:
  801d98:	55                   	push   %ebp
  801d99:	57                   	push   %edi
  801d9a:	56                   	push   %esi
  801d9b:	53                   	push   %ebx
  801d9c:	83 ec 1c             	sub    $0x1c,%esp
  801d9f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801da3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801da7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801daf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801db3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801db7:	89 f3                	mov    %esi,%ebx
  801db9:	89 fa                	mov    %edi,%edx
  801dbb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dbf:	89 34 24             	mov    %esi,(%esp)
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	75 1a                	jne    801de0 <__umoddi3+0x48>
  801dc6:	39 f7                	cmp    %esi,%edi
  801dc8:	0f 86 a2 00 00 00    	jbe    801e70 <__umoddi3+0xd8>
  801dce:	89 c8                	mov    %ecx,%eax
  801dd0:	89 f2                	mov    %esi,%edx
  801dd2:	f7 f7                	div    %edi
  801dd4:	89 d0                	mov    %edx,%eax
  801dd6:	31 d2                	xor    %edx,%edx
  801dd8:	83 c4 1c             	add    $0x1c,%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5f                   	pop    %edi
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    
  801de0:	39 f0                	cmp    %esi,%eax
  801de2:	0f 87 ac 00 00 00    	ja     801e94 <__umoddi3+0xfc>
  801de8:	0f bd e8             	bsr    %eax,%ebp
  801deb:	83 f5 1f             	xor    $0x1f,%ebp
  801dee:	0f 84 ac 00 00 00    	je     801ea0 <__umoddi3+0x108>
  801df4:	bf 20 00 00 00       	mov    $0x20,%edi
  801df9:	29 ef                	sub    %ebp,%edi
  801dfb:	89 fe                	mov    %edi,%esi
  801dfd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e01:	89 e9                	mov    %ebp,%ecx
  801e03:	d3 e0                	shl    %cl,%eax
  801e05:	89 d7                	mov    %edx,%edi
  801e07:	89 f1                	mov    %esi,%ecx
  801e09:	d3 ef                	shr    %cl,%edi
  801e0b:	09 c7                	or     %eax,%edi
  801e0d:	89 e9                	mov    %ebp,%ecx
  801e0f:	d3 e2                	shl    %cl,%edx
  801e11:	89 14 24             	mov    %edx,(%esp)
  801e14:	89 d8                	mov    %ebx,%eax
  801e16:	d3 e0                	shl    %cl,%eax
  801e18:	89 c2                	mov    %eax,%edx
  801e1a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e1e:	d3 e0                	shl    %cl,%eax
  801e20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e24:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e28:	89 f1                	mov    %esi,%ecx
  801e2a:	d3 e8                	shr    %cl,%eax
  801e2c:	09 d0                	or     %edx,%eax
  801e2e:	d3 eb                	shr    %cl,%ebx
  801e30:	89 da                	mov    %ebx,%edx
  801e32:	f7 f7                	div    %edi
  801e34:	89 d3                	mov    %edx,%ebx
  801e36:	f7 24 24             	mull   (%esp)
  801e39:	89 c6                	mov    %eax,%esi
  801e3b:	89 d1                	mov    %edx,%ecx
  801e3d:	39 d3                	cmp    %edx,%ebx
  801e3f:	0f 82 87 00 00 00    	jb     801ecc <__umoddi3+0x134>
  801e45:	0f 84 91 00 00 00    	je     801edc <__umoddi3+0x144>
  801e4b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e4f:	29 f2                	sub    %esi,%edx
  801e51:	19 cb                	sbb    %ecx,%ebx
  801e53:	89 d8                	mov    %ebx,%eax
  801e55:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e59:	d3 e0                	shl    %cl,%eax
  801e5b:	89 e9                	mov    %ebp,%ecx
  801e5d:	d3 ea                	shr    %cl,%edx
  801e5f:	09 d0                	or     %edx,%eax
  801e61:	89 e9                	mov    %ebp,%ecx
  801e63:	d3 eb                	shr    %cl,%ebx
  801e65:	89 da                	mov    %ebx,%edx
  801e67:	83 c4 1c             	add    $0x1c,%esp
  801e6a:	5b                   	pop    %ebx
  801e6b:	5e                   	pop    %esi
  801e6c:	5f                   	pop    %edi
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    
  801e6f:	90                   	nop
  801e70:	89 fd                	mov    %edi,%ebp
  801e72:	85 ff                	test   %edi,%edi
  801e74:	75 0b                	jne    801e81 <__umoddi3+0xe9>
  801e76:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7b:	31 d2                	xor    %edx,%edx
  801e7d:	f7 f7                	div    %edi
  801e7f:	89 c5                	mov    %eax,%ebp
  801e81:	89 f0                	mov    %esi,%eax
  801e83:	31 d2                	xor    %edx,%edx
  801e85:	f7 f5                	div    %ebp
  801e87:	89 c8                	mov    %ecx,%eax
  801e89:	f7 f5                	div    %ebp
  801e8b:	89 d0                	mov    %edx,%eax
  801e8d:	e9 44 ff ff ff       	jmp    801dd6 <__umoddi3+0x3e>
  801e92:	66 90                	xchg   %ax,%ax
  801e94:	89 c8                	mov    %ecx,%eax
  801e96:	89 f2                	mov    %esi,%edx
  801e98:	83 c4 1c             	add    $0x1c,%esp
  801e9b:	5b                   	pop    %ebx
  801e9c:	5e                   	pop    %esi
  801e9d:	5f                   	pop    %edi
  801e9e:	5d                   	pop    %ebp
  801e9f:	c3                   	ret    
  801ea0:	3b 04 24             	cmp    (%esp),%eax
  801ea3:	72 06                	jb     801eab <__umoddi3+0x113>
  801ea5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ea9:	77 0f                	ja     801eba <__umoddi3+0x122>
  801eab:	89 f2                	mov    %esi,%edx
  801ead:	29 f9                	sub    %edi,%ecx
  801eaf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801eb3:	89 14 24             	mov    %edx,(%esp)
  801eb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801eba:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ebe:	8b 14 24             	mov    (%esp),%edx
  801ec1:	83 c4 1c             	add    $0x1c,%esp
  801ec4:	5b                   	pop    %ebx
  801ec5:	5e                   	pop    %esi
  801ec6:	5f                   	pop    %edi
  801ec7:	5d                   	pop    %ebp
  801ec8:	c3                   	ret    
  801ec9:	8d 76 00             	lea    0x0(%esi),%esi
  801ecc:	2b 04 24             	sub    (%esp),%eax
  801ecf:	19 fa                	sbb    %edi,%edx
  801ed1:	89 d1                	mov    %edx,%ecx
  801ed3:	89 c6                	mov    %eax,%esi
  801ed5:	e9 71 ff ff ff       	jmp    801e4b <__umoddi3+0xb3>
  801eda:	66 90                	xchg   %ax,%ax
  801edc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ee0:	72 ea                	jb     801ecc <__umoddi3+0x134>
  801ee2:	89 d9                	mov    %ebx,%ecx
  801ee4:	e9 62 ff ff ff       	jmp    801e4b <__umoddi3+0xb3>
