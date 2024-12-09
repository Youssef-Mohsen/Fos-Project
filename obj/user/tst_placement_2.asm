
obj/user/tst_placement_2:     file format elf32-i386


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
  800031:	e8 c0 03 00 00       	call   8003f6 <libmain>
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

	//uint32 actual_active_list[13] = {0xedbfd000,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
	uint32 actual_active_list[13] ;
	{
		actual_active_list[0] = 0xedbfd000;
  800043:	c7 85 94 ff ff fe 00 	movl   $0xedbfd000,-0x100006c(%ebp)
  80004a:	d0 bf ed 
		actual_active_list[1] = 0xeebfd000;
  80004d:	c7 85 98 ff ff fe 00 	movl   $0xeebfd000,-0x1000068(%ebp)
  800054:	d0 bf ee 
		actual_active_list[2] = 0x803000;
  800057:	c7 85 9c ff ff fe 00 	movl   $0x803000,-0x1000064(%ebp)
  80005e:	30 80 00 
		actual_active_list[3] = 0x802000;
  800061:	c7 85 a0 ff ff fe 00 	movl   $0x802000,-0x1000060(%ebp)
  800068:	20 80 00 
		actual_active_list[4] = 0x801000;
  80006b:	c7 85 a4 ff ff fe 00 	movl   $0x801000,-0x100005c(%ebp)
  800072:	10 80 00 
		actual_active_list[5] = 0x800000;
  800075:	c7 85 a8 ff ff fe 00 	movl   $0x800000,-0x1000058(%ebp)
  80007c:	00 80 00 
		actual_active_list[6] = 0x205000;
  80007f:	c7 85 ac ff ff fe 00 	movl   $0x205000,-0x1000054(%ebp)
  800086:	50 20 00 
		actual_active_list[7] = 0x204000;
  800089:	c7 85 b0 ff ff fe 00 	movl   $0x204000,-0x1000050(%ebp)
  800090:	40 20 00 
		actual_active_list[8] = 0x203000;
  800093:	c7 85 b4 ff ff fe 00 	movl   $0x203000,-0x100004c(%ebp)
  80009a:	30 20 00 
		actual_active_list[9] = 0x202000;
  80009d:	c7 85 b8 ff ff fe 00 	movl   $0x202000,-0x1000048(%ebp)
  8000a4:	20 20 00 
		actual_active_list[10] = 0x201000;
  8000a7:	c7 85 bc ff ff fe 00 	movl   $0x201000,-0x1000044(%ebp)
  8000ae:	10 20 00 
		actual_active_list[11] = 0x200000;
  8000b1:	c7 85 c0 ff ff fe 00 	movl   $0x200000,-0x1000040(%ebp)
  8000b8:	00 20 00 
	}
	uint32 actual_second_list[7] = {};
  8000bb:	8d 95 78 ff ff fe    	lea    -0x1000088(%ebp),%edx
  8000c1:	b9 07 00 00 00       	mov    $0x7,%ecx
  8000c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cb:	89 d7                	mov    %edx,%edi
  8000cd:	f3 ab                	rep stos %eax,%es:(%edi)
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000cf:	6a 00                	push   $0x0
  8000d1:	6a 0c                	push   $0xc
  8000d3:	8d 85 78 ff ff fe    	lea    -0x1000088(%ebp),%eax
  8000d9:	50                   	push   %eax
  8000da:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 df 19 00 00       	call   801ac5 <sys_check_LRU_lists>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if(check == 0)
  8000ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8000f0:	75 14                	jne    800106 <_main+0xce>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 c0 1e 80 00       	push   $0x801ec0
  8000fa:	6a 24                	push   $0x24
  8000fc:	68 42 1f 80 00       	push   $0x801f42
  800101:	e8 2f 04 00 00       	call   800535 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800106:	e8 ec 15 00 00       	call   8016f7 <sys_pf_calculate_allocated_pages>
  80010b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int freePages = sys_calculate_free_frames();
  80010e:	e8 99 15 00 00       	call   8016ac <sys_calculate_free_frames>
  800113:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i=0;
  800116:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  80011d:	eb 11                	jmp    800130 <_main+0xf8>
	{
		arr[i] = -1;
  80011f:	8d 95 c8 ff ff fe    	lea    -0x1000038(%ebp),%edx
  800125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800128:	01 d0                	add    %edx,%eax
  80012a:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  80012d:	ff 45 f4             	incl   -0xc(%ebp)
  800130:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  800137:	7e e6                	jle    80011f <_main+0xe7>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  800139:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800140:	eb 11                	jmp    800153 <_main+0x11b>
	{
		arr[i] = -1;
  800142:	8d 95 c8 ff ff fe    	lea    -0x1000038(%ebp),%edx
  800148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800150:	ff 45 f4             	incl   -0xc(%ebp)
  800153:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  80015a:	7e e6                	jle    800142 <_main+0x10a>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  80015c:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800163:	eb 11                	jmp    800176 <_main+0x13e>
	{
		arr[i] = -1;
  800165:	8d 95 c8 ff ff fe    	lea    -0x1000038(%ebp),%edx
  80016b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800173:	ff 45 f4             	incl   -0xc(%ebp)
  800176:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  80017d:	7e e6                	jle    800165 <_main+0x12d>
	{
		arr[i] = -1;
	}

	int eval = 0;
  80017f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	bool is_correct = 1;
  800186:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)

	uint32 expected, actual ;
	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  80018d:	83 ec 0c             	sub    $0xc,%esp
  800190:	68 5c 1f 80 00       	push   $0x801f5c
  800195:	e8 58 06 00 00       	call   8007f2 <cprintf>
  80019a:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  80019d:	8a 85 c8 ff ff fe    	mov    -0x1000038(%ebp),%al
  8001a3:	3c ff                	cmp    $0xff,%al
  8001a5:	74 17                	je     8001be <_main+0x186>
  8001a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 8c 1f 80 00       	push   $0x801f8c
  8001b6:	e8 37 06 00 00       	call   8007f2 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001be:	8a 85 c8 0f 00 ff    	mov    -0xfff038(%ebp),%al
  8001c4:	3c ff                	cmp    $0xff,%al
  8001c6:	74 17                	je     8001df <_main+0x1a7>
  8001c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cf:	83 ec 0c             	sub    $0xc,%esp
  8001d2:	68 8c 1f 80 00       	push   $0x801f8c
  8001d7:	e8 16 06 00 00       	call   8007f2 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001df:	8a 85 c8 ff 3f ff    	mov    -0xc00038(%ebp),%al
  8001e5:	3c ff                	cmp    $0xff,%al
  8001e7:	74 17                	je     800200 <_main+0x1c8>
  8001e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 8c 1f 80 00       	push   $0x801f8c
  8001f8:	e8 f5 05 00 00       	call   8007f2 <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800200:	8a 85 c8 0f 40 ff    	mov    -0xbff038(%ebp),%al
  800206:	3c ff                	cmp    $0xff,%al
  800208:	74 17                	je     800221 <_main+0x1e9>
  80020a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	68 8c 1f 80 00       	push   $0x801f8c
  800219:	e8 d4 05 00 00       	call   8007f2 <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800221:	8a 85 c8 ff 7f ff    	mov    -0x800038(%ebp),%al
  800227:	3c ff                	cmp    $0xff,%al
  800229:	74 17                	je     800242 <_main+0x20a>
  80022b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 8c 1f 80 00       	push   $0x801f8c
  80023a:	e8 b3 05 00 00       	call   8007f2 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800242:	8a 85 c8 0f 80 ff    	mov    -0x7ff038(%ebp),%al
  800248:	3c ff                	cmp    $0xff,%al
  80024a:	74 17                	je     800263 <_main+0x22b>
  80024c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	68 8c 1f 80 00       	push   $0x801f8c
  80025b:	e8 92 05 00 00       	call   8007f2 <cprintf>
  800260:	83 c4 10             	add    $0x10,%esp


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT written to Page File until it's replaced\n"); }
  800263:	e8 8f 14 00 00       	call   8016f7 <sys_pf_calculate_allocated_pages>
  800268:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80026b:	74 17                	je     800284 <_main+0x24c>
  80026d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	68 ac 1f 80 00       	push   $0x801fac
  80027c:	e8 71 05 00 00       	call   8007f2 <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  800284:	c7 45 d0 07 00 00 00 	movl   $0x7,-0x30(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  80028b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80028e:	e8 19 14 00 00       	call   8016ac <sys_calculate_free_frames>
  800293:	29 c3                	sub    %eax,%ebx
  800295:	89 d8                	mov    %ebx,%eax
  800297:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//actual = (initFreeFrames - sys_calculate_free_frames()) ;
		if(actual != expected) { is_correct = 0; cprintf("allocated memory size incorrect. Expected = %d, Actual = %d\n", expected, actual); }
  80029a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80029d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8002a0:	74 1d                	je     8002bf <_main+0x287>
  8002a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002a9:	83 ec 04             	sub    $0x4,%esp
  8002ac:	ff 75 cc             	pushl  -0x34(%ebp)
  8002af:	ff 75 d0             	pushl  -0x30(%ebp)
  8002b2:	68 f4 1f 80 00       	push   $0x801ff4
  8002b7:	e8 36 05 00 00       	call   8007f2 <cprintf>
  8002bc:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8002bf:	83 ec 0c             	sub    $0xc,%esp
  8002c2:	68 34 20 80 00       	push   $0x802034
  8002c7:	e8 26 05 00 00       	call   8007f2 <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  8002cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002d3:	74 04                	je     8002d9 <_main+0x2a1>
		eval += 50 ;
  8002d5:	83 45 f0 32          	addl   $0x32,-0x10(%ebp)
	is_correct = 1;
  8002d9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)

	int j=0;
  8002e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for (int i=3;i>=0;i--,j++)
  8002e7:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  8002ee:	eb 1f                	jmp    80030f <_main+0x2d7>
		actual_second_list[i]=actual_active_list[11-j];
  8002f0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002f5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002f8:	8b 94 85 94 ff ff fe 	mov    -0x100006c(%ebp,%eax,4),%edx
  8002ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800302:	89 94 85 78 ff ff fe 	mov    %edx,-0x1000088(%ebp,%eax,4)
	if (is_correct)
		eval += 50 ;
	is_correct = 1;

	int j=0;
	for (int i=3;i>=0;i--,j++)
  800309:	ff 4d e4             	decl   -0x1c(%ebp)
  80030c:	ff 45 e8             	incl   -0x18(%ebp)
  80030f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800313:	79 db                	jns    8002f0 <_main+0x2b8>
		actual_second_list[i]=actual_active_list[11-j];
	for (int i=12;i>4;i--)
  800315:	c7 45 e0 0c 00 00 00 	movl   $0xc,-0x20(%ebp)
  80031c:	eb 1a                	jmp    800338 <_main+0x300>
		actual_active_list[i]=actual_active_list[i-5];
  80031e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800321:	83 e8 05             	sub    $0x5,%eax
  800324:	8b 94 85 94 ff ff fe 	mov    -0x100006c(%ebp,%eax,4),%edx
  80032b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032e:	89 94 85 94 ff ff fe 	mov    %edx,-0x100006c(%ebp,%eax,4)
	is_correct = 1;

	int j=0;
	for (int i=3;i>=0;i--,j++)
		actual_second_list[i]=actual_active_list[11-j];
	for (int i=12;i>4;i--)
  800335:	ff 4d e0             	decl   -0x20(%ebp)
  800338:	83 7d e0 04          	cmpl   $0x4,-0x20(%ebp)
  80033c:	7f e0                	jg     80031e <_main+0x2e6>
		actual_active_list[i]=actual_active_list[i-5];
	actual_active_list[0]=0xee3fe000;
  80033e:	c7 85 94 ff ff fe 00 	movl   $0xee3fe000,-0x100006c(%ebp)
  800345:	e0 3f ee 
	actual_active_list[1]=0xee3fd000;
  800348:	c7 85 98 ff ff fe 00 	movl   $0xee3fd000,-0x1000068(%ebp)
  80034f:	d0 3f ee 
	actual_active_list[2]=0xedffe000;
  800352:	c7 85 9c ff ff fe 00 	movl   $0xedffe000,-0x1000064(%ebp)
  800359:	e0 ff ed 
	actual_active_list[3]=0xedffd000;
  80035c:	c7 85 a0 ff ff fe 00 	movl   $0xedffd000,-0x1000060(%ebp)
  800363:	d0 ff ed 
	actual_active_list[4]=0xedbfe000;
  800366:	c7 85 a4 ff ff fe 00 	movl   $0xedbfe000,-0x100005c(%ebp)
  80036d:	e0 bf ed 

	cprintf("STEP B: checking LRU lists entries ...\n");
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	68 68 20 80 00       	push   $0x802068
  800378:	e8 75 04 00 00       	call   8007f2 <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  800380:	6a 04                	push   $0x4
  800382:	6a 0d                	push   $0xd
  800384:	8d 85 78 ff ff fe    	lea    -0x1000088(%ebp),%eax
  80038a:	50                   	push   %eax
  80038b:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  800391:	50                   	push   %eax
  800392:	e8 2e 17 00 00       	call   801ac5 <sys_check_LRU_lists>
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if(check == 0)
  80039d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8003a1:	75 17                	jne    8003ba <_main+0x382>
			{ is_correct = 0; cprintf("LRU lists entries are not correct, check your logic again!!\n"); }
  8003a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8003aa:	83 ec 0c             	sub    $0xc,%esp
  8003ad:	68 90 20 80 00       	push   $0x802090
  8003b2:	e8 3b 04 00 00       	call   8007f2 <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	68 d0 20 80 00       	push   $0x8020d0
  8003c2:	e8 2b 04 00 00       	call   8007f2 <cprintf>
  8003c7:	83 c4 10             	add    $0x10,%esp
	if (is_correct)
  8003ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ce:	74 04                	je     8003d4 <_main+0x39c>
		eval += 50 ;
  8003d0:	83 45 f0 32          	addl   $0x32,-0x10(%ebp)
	is_correct = 1;
  8003d4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)

	cprintf("Congratulations!! Test of PAGE PLACEMENT SECOND SCENARIO completed. Eval = %d\n\n\n", eval);
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e1:	68 08 21 80 00       	push   $0x802108
  8003e6:	e8 07 04 00 00       	call   8007f2 <cprintf>
  8003eb:	83 c4 10             	add    $0x10,%esp
	return;
  8003ee:	90                   	nop
}
  8003ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003f2:	5b                   	pop    %ebx
  8003f3:	5f                   	pop    %edi
  8003f4:	5d                   	pop    %ebp
  8003f5:	c3                   	ret    

008003f6 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8003f6:	55                   	push   %ebp
  8003f7:	89 e5                	mov    %esp,%ebp
  8003f9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003fc:	e8 74 14 00 00       	call   801875 <sys_getenvindex>
  800401:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800407:	89 d0                	mov    %edx,%eax
  800409:	c1 e0 03             	shl    $0x3,%eax
  80040c:	01 d0                	add    %edx,%eax
  80040e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800415:	01 c8                	add    %ecx,%eax
  800417:	01 c0                	add    %eax,%eax
  800419:	01 d0                	add    %edx,%eax
  80041b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800422:	01 c8                	add    %ecx,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80042b:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800430:	a1 04 30 80 00       	mov    0x803004,%eax
  800435:	8a 40 20             	mov    0x20(%eax),%al
  800438:	84 c0                	test   %al,%al
  80043a:	74 0d                	je     800449 <libmain+0x53>
		binaryname = myEnv->prog_name;
  80043c:	a1 04 30 80 00       	mov    0x803004,%eax
  800441:	83 c0 20             	add    $0x20,%eax
  800444:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800449:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80044d:	7e 0a                	jle    800459 <libmain+0x63>
		binaryname = argv[0];
  80044f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800459:	83 ec 08             	sub    $0x8,%esp
  80045c:	ff 75 0c             	pushl  0xc(%ebp)
  80045f:	ff 75 08             	pushl  0x8(%ebp)
  800462:	e8 d1 fb ff ff       	call   800038 <_main>
  800467:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80046a:	e8 8a 11 00 00       	call   8015f9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80046f:	83 ec 0c             	sub    $0xc,%esp
  800472:	68 74 21 80 00       	push   $0x802174
  800477:	e8 76 03 00 00       	call   8007f2 <cprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80047f:	a1 04 30 80 00       	mov    0x803004,%eax
  800484:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80048a:	a1 04 30 80 00       	mov    0x803004,%eax
  80048f:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800495:	83 ec 04             	sub    $0x4,%esp
  800498:	52                   	push   %edx
  800499:	50                   	push   %eax
  80049a:	68 9c 21 80 00       	push   $0x80219c
  80049f:	e8 4e 03 00 00       	call   8007f2 <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004a7:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ac:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8004b2:	a1 04 30 80 00       	mov    0x803004,%eax
  8004b7:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8004bd:	a1 04 30 80 00       	mov    0x803004,%eax
  8004c2:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8004c8:	51                   	push   %ecx
  8004c9:	52                   	push   %edx
  8004ca:	50                   	push   %eax
  8004cb:	68 c4 21 80 00       	push   $0x8021c4
  8004d0:	e8 1d 03 00 00       	call   8007f2 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004d8:	a1 04 30 80 00       	mov    0x803004,%eax
  8004dd:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	50                   	push   %eax
  8004e7:	68 1c 22 80 00       	push   $0x80221c
  8004ec:	e8 01 03 00 00       	call   8007f2 <cprintf>
  8004f1:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8004f4:	83 ec 0c             	sub    $0xc,%esp
  8004f7:	68 74 21 80 00       	push   $0x802174
  8004fc:	e8 f1 02 00 00       	call   8007f2 <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800504:	e8 0a 11 00 00       	call   801613 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800509:	e8 19 00 00 00       	call   800527 <exit>
}
  80050e:	90                   	nop
  80050f:	c9                   	leave  
  800510:	c3                   	ret    

00800511 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800517:	83 ec 0c             	sub    $0xc,%esp
  80051a:	6a 00                	push   $0x0
  80051c:	e8 20 13 00 00       	call   801841 <sys_destroy_env>
  800521:	83 c4 10             	add    $0x10,%esp
}
  800524:	90                   	nop
  800525:	c9                   	leave  
  800526:	c3                   	ret    

00800527 <exit>:

void
exit(void)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80052d:	e8 75 13 00 00       	call   8018a7 <sys_exit_env>
}
  800532:	90                   	nop
  800533:	c9                   	leave  
  800534:	c3                   	ret    

00800535 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800535:	55                   	push   %ebp
  800536:	89 e5                	mov    %esp,%ebp
  800538:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80053b:	8d 45 10             	lea    0x10(%ebp),%eax
  80053e:	83 c0 04             	add    $0x4,%eax
  800541:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800544:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800549:	85 c0                	test   %eax,%eax
  80054b:	74 16                	je     800563 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80054d:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	50                   	push   %eax
  800556:	68 30 22 80 00       	push   $0x802230
  80055b:	e8 92 02 00 00       	call   8007f2 <cprintf>
  800560:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800563:	a1 00 30 80 00       	mov    0x803000,%eax
  800568:	ff 75 0c             	pushl  0xc(%ebp)
  80056b:	ff 75 08             	pushl  0x8(%ebp)
  80056e:	50                   	push   %eax
  80056f:	68 35 22 80 00       	push   $0x802235
  800574:	e8 79 02 00 00       	call   8007f2 <cprintf>
  800579:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80057c:	8b 45 10             	mov    0x10(%ebp),%eax
  80057f:	83 ec 08             	sub    $0x8,%esp
  800582:	ff 75 f4             	pushl  -0xc(%ebp)
  800585:	50                   	push   %eax
  800586:	e8 fc 01 00 00       	call   800787 <vcprintf>
  80058b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	6a 00                	push   $0x0
  800593:	68 51 22 80 00       	push   $0x802251
  800598:	e8 ea 01 00 00       	call   800787 <vcprintf>
  80059d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005a0:	e8 82 ff ff ff       	call   800527 <exit>

	// should not return here
	while (1) ;
  8005a5:	eb fe                	jmp    8005a5 <_panic+0x70>

008005a7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005a7:	55                   	push   %ebp
  8005a8:	89 e5                	mov    %esp,%ebp
  8005aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005ad:	a1 04 30 80 00       	mov    0x803004,%eax
  8005b2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bb:	39 c2                	cmp    %eax,%edx
  8005bd:	74 14                	je     8005d3 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005bf:	83 ec 04             	sub    $0x4,%esp
  8005c2:	68 54 22 80 00       	push   $0x802254
  8005c7:	6a 26                	push   $0x26
  8005c9:	68 a0 22 80 00       	push   $0x8022a0
  8005ce:	e8 62 ff ff ff       	call   800535 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005e1:	e9 c5 00 00 00       	jmp    8006ab <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f3:	01 d0                	add    %edx,%eax
  8005f5:	8b 00                	mov    (%eax),%eax
  8005f7:	85 c0                	test   %eax,%eax
  8005f9:	75 08                	jne    800603 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005fb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005fe:	e9 a5 00 00 00       	jmp    8006a8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800603:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80060a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800611:	eb 69                	jmp    80067c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800613:	a1 04 30 80 00       	mov    0x803004,%eax
  800618:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80061e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800621:	89 d0                	mov    %edx,%eax
  800623:	01 c0                	add    %eax,%eax
  800625:	01 d0                	add    %edx,%eax
  800627:	c1 e0 03             	shl    $0x3,%eax
  80062a:	01 c8                	add    %ecx,%eax
  80062c:	8a 40 04             	mov    0x4(%eax),%al
  80062f:	84 c0                	test   %al,%al
  800631:	75 46                	jne    800679 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800633:	a1 04 30 80 00       	mov    0x803004,%eax
  800638:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80063e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800641:	89 d0                	mov    %edx,%eax
  800643:	01 c0                	add    %eax,%eax
  800645:	01 d0                	add    %edx,%eax
  800647:	c1 e0 03             	shl    $0x3,%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8b 00                	mov    (%eax),%eax
  80064e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800651:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800654:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800659:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80065b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80065e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800665:	8b 45 08             	mov    0x8(%ebp),%eax
  800668:	01 c8                	add    %ecx,%eax
  80066a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80066c:	39 c2                	cmp    %eax,%edx
  80066e:	75 09                	jne    800679 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800670:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800677:	eb 15                	jmp    80068e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800679:	ff 45 e8             	incl   -0x18(%ebp)
  80067c:	a1 04 30 80 00       	mov    0x803004,%eax
  800681:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800687:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80068a:	39 c2                	cmp    %eax,%edx
  80068c:	77 85                	ja     800613 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80068e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800692:	75 14                	jne    8006a8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 ac 22 80 00       	push   $0x8022ac
  80069c:	6a 3a                	push   $0x3a
  80069e:	68 a0 22 80 00       	push   $0x8022a0
  8006a3:	e8 8d fe ff ff       	call   800535 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006a8:	ff 45 f0             	incl   -0x10(%ebp)
  8006ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006b1:	0f 8c 2f ff ff ff    	jl     8005e6 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006c5:	eb 26                	jmp    8006ed <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006c7:	a1 04 30 80 00       	mov    0x803004,%eax
  8006cc:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8006d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006d5:	89 d0                	mov    %edx,%eax
  8006d7:	01 c0                	add    %eax,%eax
  8006d9:	01 d0                	add    %edx,%eax
  8006db:	c1 e0 03             	shl    $0x3,%eax
  8006de:	01 c8                	add    %ecx,%eax
  8006e0:	8a 40 04             	mov    0x4(%eax),%al
  8006e3:	3c 01                	cmp    $0x1,%al
  8006e5:	75 03                	jne    8006ea <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006e7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006ea:	ff 45 e0             	incl   -0x20(%ebp)
  8006ed:	a1 04 30 80 00       	mov    0x803004,%eax
  8006f2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006fb:	39 c2                	cmp    %eax,%edx
  8006fd:	77 c8                	ja     8006c7 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800702:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800705:	74 14                	je     80071b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800707:	83 ec 04             	sub    $0x4,%esp
  80070a:	68 00 23 80 00       	push   $0x802300
  80070f:	6a 44                	push   $0x44
  800711:	68 a0 22 80 00       	push   $0x8022a0
  800716:	e8 1a fe ff ff       	call   800535 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800724:	8b 45 0c             	mov    0xc(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	8d 48 01             	lea    0x1(%eax),%ecx
  80072c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072f:	89 0a                	mov    %ecx,(%edx)
  800731:	8b 55 08             	mov    0x8(%ebp),%edx
  800734:	88 d1                	mov    %dl,%cl
  800736:	8b 55 0c             	mov    0xc(%ebp),%edx
  800739:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80073d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	3d ff 00 00 00       	cmp    $0xff,%eax
  800747:	75 2c                	jne    800775 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800749:	a0 08 30 80 00       	mov    0x803008,%al
  80074e:	0f b6 c0             	movzbl %al,%eax
  800751:	8b 55 0c             	mov    0xc(%ebp),%edx
  800754:	8b 12                	mov    (%edx),%edx
  800756:	89 d1                	mov    %edx,%ecx
  800758:	8b 55 0c             	mov    0xc(%ebp),%edx
  80075b:	83 c2 08             	add    $0x8,%edx
  80075e:	83 ec 04             	sub    $0x4,%esp
  800761:	50                   	push   %eax
  800762:	51                   	push   %ecx
  800763:	52                   	push   %edx
  800764:	e8 4e 0e 00 00       	call   8015b7 <sys_cputs>
  800769:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80076c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80076f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800775:	8b 45 0c             	mov    0xc(%ebp),%eax
  800778:	8b 40 04             	mov    0x4(%eax),%eax
  80077b:	8d 50 01             	lea    0x1(%eax),%edx
  80077e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800781:	89 50 04             	mov    %edx,0x4(%eax)
}
  800784:	90                   	nop
  800785:	c9                   	leave  
  800786:	c3                   	ret    

00800787 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800787:	55                   	push   %ebp
  800788:	89 e5                	mov    %esp,%ebp
  80078a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800790:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800797:	00 00 00 
	b.cnt = 0;
  80079a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007a1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	ff 75 08             	pushl  0x8(%ebp)
  8007aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007b0:	50                   	push   %eax
  8007b1:	68 1e 07 80 00       	push   $0x80071e
  8007b6:	e8 11 02 00 00       	call   8009cc <vprintfmt>
  8007bb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007be:	a0 08 30 80 00       	mov    0x803008,%al
  8007c3:	0f b6 c0             	movzbl %al,%eax
  8007c6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007cc:	83 ec 04             	sub    $0x4,%esp
  8007cf:	50                   	push   %eax
  8007d0:	52                   	push   %edx
  8007d1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007d7:	83 c0 08             	add    $0x8,%eax
  8007da:	50                   	push   %eax
  8007db:	e8 d7 0d 00 00       	call   8015b7 <sys_cputs>
  8007e0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007e3:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8007ea:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007f0:	c9                   	leave  
  8007f1:	c3                   	ret    

008007f2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007f8:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8007ff:	8d 45 0c             	lea    0xc(%ebp),%eax
  800802:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 f4             	pushl  -0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	e8 73 ff ff ff       	call   800787 <vcprintf>
  800814:	83 c4 10             	add    $0x10,%esp
  800817:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80081a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80081d:	c9                   	leave  
  80081e:	c3                   	ret    

0080081f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80081f:	55                   	push   %ebp
  800820:	89 e5                	mov    %esp,%ebp
  800822:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800825:	e8 cf 0d 00 00       	call   8015f9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80082a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80082d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	ff 75 f4             	pushl  -0xc(%ebp)
  800839:	50                   	push   %eax
  80083a:	e8 48 ff ff ff       	call   800787 <vcprintf>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800845:	e8 c9 0d 00 00       	call   801613 <sys_unlock_cons>
	return cnt;
  80084a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80084d:	c9                   	leave  
  80084e:	c3                   	ret    

0080084f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	53                   	push   %ebx
  800853:	83 ec 14             	sub    $0x14,%esp
  800856:	8b 45 10             	mov    0x10(%ebp),%eax
  800859:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800862:	8b 45 18             	mov    0x18(%ebp),%eax
  800865:	ba 00 00 00 00       	mov    $0x0,%edx
  80086a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80086d:	77 55                	ja     8008c4 <printnum+0x75>
  80086f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800872:	72 05                	jb     800879 <printnum+0x2a>
  800874:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800877:	77 4b                	ja     8008c4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800879:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80087c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80087f:	8b 45 18             	mov    0x18(%ebp),%eax
  800882:	ba 00 00 00 00       	mov    $0x0,%edx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	ff 75 f4             	pushl  -0xc(%ebp)
  80088c:	ff 75 f0             	pushl  -0x10(%ebp)
  80088f:	e8 c0 13 00 00       	call   801c54 <__udivdi3>
  800894:	83 c4 10             	add    $0x10,%esp
  800897:	83 ec 04             	sub    $0x4,%esp
  80089a:	ff 75 20             	pushl  0x20(%ebp)
  80089d:	53                   	push   %ebx
  80089e:	ff 75 18             	pushl  0x18(%ebp)
  8008a1:	52                   	push   %edx
  8008a2:	50                   	push   %eax
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	ff 75 08             	pushl  0x8(%ebp)
  8008a9:	e8 a1 ff ff ff       	call   80084f <printnum>
  8008ae:	83 c4 20             	add    $0x20,%esp
  8008b1:	eb 1a                	jmp    8008cd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008b3:	83 ec 08             	sub    $0x8,%esp
  8008b6:	ff 75 0c             	pushl  0xc(%ebp)
  8008b9:	ff 75 20             	pushl  0x20(%ebp)
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	ff d0                	call   *%eax
  8008c1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008c4:	ff 4d 1c             	decl   0x1c(%ebp)
  8008c7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008cb:	7f e6                	jg     8008b3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008cd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008db:	53                   	push   %ebx
  8008dc:	51                   	push   %ecx
  8008dd:	52                   	push   %edx
  8008de:	50                   	push   %eax
  8008df:	e8 80 14 00 00       	call   801d64 <__umoddi3>
  8008e4:	83 c4 10             	add    $0x10,%esp
  8008e7:	05 74 25 80 00       	add    $0x802574,%eax
  8008ec:	8a 00                	mov    (%eax),%al
  8008ee:	0f be c0             	movsbl %al,%eax
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	ff 75 0c             	pushl  0xc(%ebp)
  8008f7:	50                   	push   %eax
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	ff d0                	call   *%eax
  8008fd:	83 c4 10             	add    $0x10,%esp
}
  800900:	90                   	nop
  800901:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800909:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090d:	7e 1c                	jle    80092b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	8d 50 08             	lea    0x8(%eax),%edx
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	89 10                	mov    %edx,(%eax)
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	8b 00                	mov    (%eax),%eax
  800921:	83 e8 08             	sub    $0x8,%eax
  800924:	8b 50 04             	mov    0x4(%eax),%edx
  800927:	8b 00                	mov    (%eax),%eax
  800929:	eb 40                	jmp    80096b <getuint+0x65>
	else if (lflag)
  80092b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092f:	74 1e                	je     80094f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 00                	mov    (%eax),%eax
  800936:	8d 50 04             	lea    0x4(%eax),%edx
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	89 10                	mov    %edx,(%eax)
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	ba 00 00 00 00       	mov    $0x0,%edx
  80094d:	eb 1c                	jmp    80096b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	8d 50 04             	lea    0x4(%eax),%edx
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	89 10                	mov    %edx,(%eax)
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	83 e8 04             	sub    $0x4,%eax
  800964:	8b 00                	mov    (%eax),%eax
  800966:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80096b:	5d                   	pop    %ebp
  80096c:	c3                   	ret    

0080096d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800970:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800974:	7e 1c                	jle    800992 <getint+0x25>
		return va_arg(*ap, long long);
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 00                	mov    (%eax),%eax
  80097b:	8d 50 08             	lea    0x8(%eax),%edx
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	89 10                	mov    %edx,(%eax)
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	8b 00                	mov    (%eax),%eax
  800988:	83 e8 08             	sub    $0x8,%eax
  80098b:	8b 50 04             	mov    0x4(%eax),%edx
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	eb 38                	jmp    8009ca <getint+0x5d>
	else if (lflag)
  800992:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800996:	74 1a                	je     8009b2 <getint+0x45>
		return va_arg(*ap, long);
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	8d 50 04             	lea    0x4(%eax),%edx
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	89 10                	mov    %edx,(%eax)
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	8b 00                	mov    (%eax),%eax
  8009aa:	83 e8 04             	sub    $0x4,%eax
  8009ad:	8b 00                	mov    (%eax),%eax
  8009af:	99                   	cltd   
  8009b0:	eb 18                	jmp    8009ca <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	8d 50 04             	lea    0x4(%eax),%edx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	89 10                	mov    %edx,(%eax)
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8b 00                	mov    (%eax),%eax
  8009c4:	83 e8 04             	sub    $0x4,%eax
  8009c7:	8b 00                	mov    (%eax),%eax
  8009c9:	99                   	cltd   
}
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	56                   	push   %esi
  8009d0:	53                   	push   %ebx
  8009d1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d4:	eb 17                	jmp    8009ed <vprintfmt+0x21>
			if (ch == '\0')
  8009d6:	85 db                	test   %ebx,%ebx
  8009d8:	0f 84 c1 03 00 00    	je     800d9f <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009de:	83 ec 08             	sub    $0x8,%esp
  8009e1:	ff 75 0c             	pushl  0xc(%ebp)
  8009e4:	53                   	push   %ebx
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	ff d0                	call   *%eax
  8009ea:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f0:	8d 50 01             	lea    0x1(%eax),%edx
  8009f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009f6:	8a 00                	mov    (%eax),%al
  8009f8:	0f b6 d8             	movzbl %al,%ebx
  8009fb:	83 fb 25             	cmp    $0x25,%ebx
  8009fe:	75 d6                	jne    8009d6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a00:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a04:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a0b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a12:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a19:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a20:	8b 45 10             	mov    0x10(%ebp),%eax
  800a23:	8d 50 01             	lea    0x1(%eax),%edx
  800a26:	89 55 10             	mov    %edx,0x10(%ebp)
  800a29:	8a 00                	mov    (%eax),%al
  800a2b:	0f b6 d8             	movzbl %al,%ebx
  800a2e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a31:	83 f8 5b             	cmp    $0x5b,%eax
  800a34:	0f 87 3d 03 00 00    	ja     800d77 <vprintfmt+0x3ab>
  800a3a:	8b 04 85 98 25 80 00 	mov    0x802598(,%eax,4),%eax
  800a41:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a43:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a47:	eb d7                	jmp    800a20 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a49:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a4d:	eb d1                	jmp    800a20 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a4f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a59:	89 d0                	mov    %edx,%eax
  800a5b:	c1 e0 02             	shl    $0x2,%eax
  800a5e:	01 d0                	add    %edx,%eax
  800a60:	01 c0                	add    %eax,%eax
  800a62:	01 d8                	add    %ebx,%eax
  800a64:	83 e8 30             	sub    $0x30,%eax
  800a67:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6d:	8a 00                	mov    (%eax),%al
  800a6f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a72:	83 fb 2f             	cmp    $0x2f,%ebx
  800a75:	7e 3e                	jle    800ab5 <vprintfmt+0xe9>
  800a77:	83 fb 39             	cmp    $0x39,%ebx
  800a7a:	7f 39                	jg     800ab5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a7c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a7f:	eb d5                	jmp    800a56 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a81:	8b 45 14             	mov    0x14(%ebp),%eax
  800a84:	83 c0 04             	add    $0x4,%eax
  800a87:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8d:	83 e8 04             	sub    $0x4,%eax
  800a90:	8b 00                	mov    (%eax),%eax
  800a92:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a95:	eb 1f                	jmp    800ab6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a9b:	79 83                	jns    800a20 <vprintfmt+0x54>
				width = 0;
  800a9d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800aa4:	e9 77 ff ff ff       	jmp    800a20 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800aa9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ab0:	e9 6b ff ff ff       	jmp    800a20 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ab5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ab6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aba:	0f 89 60 ff ff ff    	jns    800a20 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ac0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ac6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800acd:	e9 4e ff ff ff       	jmp    800a20 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ad2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ad5:	e9 46 ff ff ff       	jmp    800a20 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	83 c0 04             	add    $0x4,%eax
  800ae0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 e8 04             	sub    $0x4,%eax
  800ae9:	8b 00                	mov    (%eax),%eax
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	ff 75 0c             	pushl  0xc(%ebp)
  800af1:	50                   	push   %eax
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	ff d0                	call   *%eax
  800af7:	83 c4 10             	add    $0x10,%esp
			break;
  800afa:	e9 9b 02 00 00       	jmp    800d9a <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aff:	8b 45 14             	mov    0x14(%ebp),%eax
  800b02:	83 c0 04             	add    $0x4,%eax
  800b05:	89 45 14             	mov    %eax,0x14(%ebp)
  800b08:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0b:	83 e8 04             	sub    $0x4,%eax
  800b0e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b10:	85 db                	test   %ebx,%ebx
  800b12:	79 02                	jns    800b16 <vprintfmt+0x14a>
				err = -err;
  800b14:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b16:	83 fb 64             	cmp    $0x64,%ebx
  800b19:	7f 0b                	jg     800b26 <vprintfmt+0x15a>
  800b1b:	8b 34 9d e0 23 80 00 	mov    0x8023e0(,%ebx,4),%esi
  800b22:	85 f6                	test   %esi,%esi
  800b24:	75 19                	jne    800b3f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b26:	53                   	push   %ebx
  800b27:	68 85 25 80 00       	push   $0x802585
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	ff 75 08             	pushl  0x8(%ebp)
  800b32:	e8 70 02 00 00       	call   800da7 <printfmt>
  800b37:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b3a:	e9 5b 02 00 00       	jmp    800d9a <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b3f:	56                   	push   %esi
  800b40:	68 8e 25 80 00       	push   $0x80258e
  800b45:	ff 75 0c             	pushl  0xc(%ebp)
  800b48:	ff 75 08             	pushl  0x8(%ebp)
  800b4b:	e8 57 02 00 00       	call   800da7 <printfmt>
  800b50:	83 c4 10             	add    $0x10,%esp
			break;
  800b53:	e9 42 02 00 00       	jmp    800d9a <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b58:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5b:	83 c0 04             	add    $0x4,%eax
  800b5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b61:	8b 45 14             	mov    0x14(%ebp),%eax
  800b64:	83 e8 04             	sub    $0x4,%eax
  800b67:	8b 30                	mov    (%eax),%esi
  800b69:	85 f6                	test   %esi,%esi
  800b6b:	75 05                	jne    800b72 <vprintfmt+0x1a6>
				p = "(null)";
  800b6d:	be 91 25 80 00       	mov    $0x802591,%esi
			if (width > 0 && padc != '-')
  800b72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b76:	7e 6d                	jle    800be5 <vprintfmt+0x219>
  800b78:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b7c:	74 67                	je     800be5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	50                   	push   %eax
  800b85:	56                   	push   %esi
  800b86:	e8 1e 03 00 00       	call   800ea9 <strnlen>
  800b8b:	83 c4 10             	add    $0x10,%esp
  800b8e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b91:	eb 16                	jmp    800ba9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b93:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b97:	83 ec 08             	sub    $0x8,%esp
  800b9a:	ff 75 0c             	pushl  0xc(%ebp)
  800b9d:	50                   	push   %eax
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	ff d0                	call   *%eax
  800ba3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ba6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bad:	7f e4                	jg     800b93 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800baf:	eb 34                	jmp    800be5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bb1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bb5:	74 1c                	je     800bd3 <vprintfmt+0x207>
  800bb7:	83 fb 1f             	cmp    $0x1f,%ebx
  800bba:	7e 05                	jle    800bc1 <vprintfmt+0x1f5>
  800bbc:	83 fb 7e             	cmp    $0x7e,%ebx
  800bbf:	7e 12                	jle    800bd3 <vprintfmt+0x207>
					putch('?', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 3f                	push   $0x3f
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
  800bd1:	eb 0f                	jmp    800be2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	53                   	push   %ebx
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	ff d0                	call   *%eax
  800bdf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800be2:	ff 4d e4             	decl   -0x1c(%ebp)
  800be5:	89 f0                	mov    %esi,%eax
  800be7:	8d 70 01             	lea    0x1(%eax),%esi
  800bea:	8a 00                	mov    (%eax),%al
  800bec:	0f be d8             	movsbl %al,%ebx
  800bef:	85 db                	test   %ebx,%ebx
  800bf1:	74 24                	je     800c17 <vprintfmt+0x24b>
  800bf3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bf7:	78 b8                	js     800bb1 <vprintfmt+0x1e5>
  800bf9:	ff 4d e0             	decl   -0x20(%ebp)
  800bfc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c00:	79 af                	jns    800bb1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c02:	eb 13                	jmp    800c17 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c04:	83 ec 08             	sub    $0x8,%esp
  800c07:	ff 75 0c             	pushl  0xc(%ebp)
  800c0a:	6a 20                	push   $0x20
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	ff d0                	call   *%eax
  800c11:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c14:	ff 4d e4             	decl   -0x1c(%ebp)
  800c17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1b:	7f e7                	jg     800c04 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c1d:	e9 78 01 00 00       	jmp    800d9a <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c22:	83 ec 08             	sub    $0x8,%esp
  800c25:	ff 75 e8             	pushl  -0x18(%ebp)
  800c28:	8d 45 14             	lea    0x14(%ebp),%eax
  800c2b:	50                   	push   %eax
  800c2c:	e8 3c fd ff ff       	call   80096d <getint>
  800c31:	83 c4 10             	add    $0x10,%esp
  800c34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c37:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c40:	85 d2                	test   %edx,%edx
  800c42:	79 23                	jns    800c67 <vprintfmt+0x29b>
				putch('-', putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	6a 2d                	push   $0x2d
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	ff d0                	call   *%eax
  800c51:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c5a:	f7 d8                	neg    %eax
  800c5c:	83 d2 00             	adc    $0x0,%edx
  800c5f:	f7 da                	neg    %edx
  800c61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c64:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c67:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c6e:	e9 bc 00 00 00       	jmp    800d2f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c73:	83 ec 08             	sub    $0x8,%esp
  800c76:	ff 75 e8             	pushl  -0x18(%ebp)
  800c79:	8d 45 14             	lea    0x14(%ebp),%eax
  800c7c:	50                   	push   %eax
  800c7d:	e8 84 fc ff ff       	call   800906 <getuint>
  800c82:	83 c4 10             	add    $0x10,%esp
  800c85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c8b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c92:	e9 98 00 00 00       	jmp    800d2f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 0c             	pushl  0xc(%ebp)
  800c9d:	6a 58                	push   $0x58
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	ff d0                	call   *%eax
  800ca4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ca7:	83 ec 08             	sub    $0x8,%esp
  800caa:	ff 75 0c             	pushl  0xc(%ebp)
  800cad:	6a 58                	push   $0x58
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	ff d0                	call   *%eax
  800cb4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cb7:	83 ec 08             	sub    $0x8,%esp
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	6a 58                	push   $0x58
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	ff d0                	call   *%eax
  800cc4:	83 c4 10             	add    $0x10,%esp
			break;
  800cc7:	e9 ce 00 00 00       	jmp    800d9a <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ccc:	83 ec 08             	sub    $0x8,%esp
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	6a 30                	push   $0x30
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	ff d0                	call   *%eax
  800cd9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cdc:	83 ec 08             	sub    $0x8,%esp
  800cdf:	ff 75 0c             	pushl  0xc(%ebp)
  800ce2:	6a 78                	push   $0x78
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	ff d0                	call   *%eax
  800ce9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cec:	8b 45 14             	mov    0x14(%ebp),%eax
  800cef:	83 c0 04             	add    $0x4,%eax
  800cf2:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf8:	83 e8 04             	sub    $0x4,%eax
  800cfb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d0e:	eb 1f                	jmp    800d2f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d10:	83 ec 08             	sub    $0x8,%esp
  800d13:	ff 75 e8             	pushl  -0x18(%ebp)
  800d16:	8d 45 14             	lea    0x14(%ebp),%eax
  800d19:	50                   	push   %eax
  800d1a:	e8 e7 fb ff ff       	call   800906 <getuint>
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d25:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d28:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d2f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	52                   	push   %edx
  800d3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d3d:	50                   	push   %eax
  800d3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d41:	ff 75 f0             	pushl  -0x10(%ebp)
  800d44:	ff 75 0c             	pushl  0xc(%ebp)
  800d47:	ff 75 08             	pushl  0x8(%ebp)
  800d4a:	e8 00 fb ff ff       	call   80084f <printnum>
  800d4f:	83 c4 20             	add    $0x20,%esp
			break;
  800d52:	eb 46                	jmp    800d9a <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d54:	83 ec 08             	sub    $0x8,%esp
  800d57:	ff 75 0c             	pushl  0xc(%ebp)
  800d5a:	53                   	push   %ebx
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	ff d0                	call   *%eax
  800d60:	83 c4 10             	add    $0x10,%esp
			break;
  800d63:	eb 35                	jmp    800d9a <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d65:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800d6c:	eb 2c                	jmp    800d9a <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d6e:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800d75:	eb 23                	jmp    800d9a <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	6a 25                	push   $0x25
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	ff d0                	call   *%eax
  800d84:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d87:	ff 4d 10             	decl   0x10(%ebp)
  800d8a:	eb 03                	jmp    800d8f <vprintfmt+0x3c3>
  800d8c:	ff 4d 10             	decl   0x10(%ebp)
  800d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d92:	48                   	dec    %eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	3c 25                	cmp    $0x25,%al
  800d97:	75 f3                	jne    800d8c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d99:	90                   	nop
		}
	}
  800d9a:	e9 35 fc ff ff       	jmp    8009d4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d9f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800da0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800da3:	5b                   	pop    %ebx
  800da4:	5e                   	pop    %esi
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    

00800da7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dad:	8d 45 10             	lea    0x10(%ebp),%eax
  800db0:	83 c0 04             	add    $0x4,%eax
  800db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800db6:	8b 45 10             	mov    0x10(%ebp),%eax
  800db9:	ff 75 f4             	pushl  -0xc(%ebp)
  800dbc:	50                   	push   %eax
  800dbd:	ff 75 0c             	pushl  0xc(%ebp)
  800dc0:	ff 75 08             	pushl  0x8(%ebp)
  800dc3:	e8 04 fc ff ff       	call   8009cc <vprintfmt>
  800dc8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dcb:	90                   	nop
  800dcc:	c9                   	leave  
  800dcd:	c3                   	ret    

00800dce <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8b 40 08             	mov    0x8(%eax),%eax
  800dd7:	8d 50 01             	lea    0x1(%eax),%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8b 10                	mov    (%eax),%edx
  800de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de8:	8b 40 04             	mov    0x4(%eax),%eax
  800deb:	39 c2                	cmp    %eax,%edx
  800ded:	73 12                	jae    800e01 <sprintputch+0x33>
		*b->buf++ = ch;
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8b 00                	mov    (%eax),%eax
  800df4:	8d 48 01             	lea    0x1(%eax),%ecx
  800df7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfa:	89 0a                	mov    %ecx,(%edx)
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	88 10                	mov    %dl,(%eax)
}
  800e01:	90                   	nop
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	01 d0                	add    %edx,%eax
  800e1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e29:	74 06                	je     800e31 <vsnprintf+0x2d>
  800e2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e2f:	7f 07                	jg     800e38 <vsnprintf+0x34>
		return -E_INVAL;
  800e31:	b8 03 00 00 00       	mov    $0x3,%eax
  800e36:	eb 20                	jmp    800e58 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e38:	ff 75 14             	pushl  0x14(%ebp)
  800e3b:	ff 75 10             	pushl  0x10(%ebp)
  800e3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e41:	50                   	push   %eax
  800e42:	68 ce 0d 80 00       	push   $0x800dce
  800e47:	e8 80 fb ff ff       	call   8009cc <vprintfmt>
  800e4c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e52:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e60:	8d 45 10             	lea    0x10(%ebp),%eax
  800e63:	83 c0 04             	add    $0x4,%eax
  800e66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e69:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e6f:	50                   	push   %eax
  800e70:	ff 75 0c             	pushl  0xc(%ebp)
  800e73:	ff 75 08             	pushl  0x8(%ebp)
  800e76:	e8 89 ff ff ff       	call   800e04 <vsnprintf>
  800e7b:	83 c4 10             	add    $0x10,%esp
  800e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e93:	eb 06                	jmp    800e9b <strlen+0x15>
		n++;
  800e95:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e98:	ff 45 08             	incl   0x8(%ebp)
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8a 00                	mov    (%eax),%al
  800ea0:	84 c0                	test   %al,%al
  800ea2:	75 f1                	jne    800e95 <strlen+0xf>
		n++;
	return n;
  800ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea7:	c9                   	leave  
  800ea8:	c3                   	ret    

00800ea9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eaf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb6:	eb 09                	jmp    800ec1 <strnlen+0x18>
		n++;
  800eb8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ebb:	ff 45 08             	incl   0x8(%ebp)
  800ebe:	ff 4d 0c             	decl   0xc(%ebp)
  800ec1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec5:	74 09                	je     800ed0 <strnlen+0x27>
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	84 c0                	test   %al,%al
  800ece:	75 e8                	jne    800eb8 <strnlen+0xf>
		n++;
	return n;
  800ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ee1:	90                   	nop
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8d 50 01             	lea    0x1(%eax),%edx
  800ee8:	89 55 08             	mov    %edx,0x8(%ebp)
  800eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eee:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef4:	8a 12                	mov    (%edx),%dl
  800ef6:	88 10                	mov    %dl,(%eax)
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	84 c0                	test   %al,%al
  800efc:	75 e4                	jne    800ee2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800efe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    

00800f03 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f16:	eb 1f                	jmp    800f37 <strncpy+0x34>
		*dst++ = *src;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8d 50 01             	lea    0x1(%eax),%edx
  800f1e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f24:	8a 12                	mov    (%edx),%dl
  800f26:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	84 c0                	test   %al,%al
  800f2f:	74 03                	je     800f34 <strncpy+0x31>
			src++;
  800f31:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f34:	ff 45 fc             	incl   -0x4(%ebp)
  800f37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f3d:	72 d9                	jb     800f18 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    

00800f44 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f54:	74 30                	je     800f86 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f56:	eb 16                	jmp    800f6e <strlcpy+0x2a>
			*dst++ = *src++;
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8d 50 01             	lea    0x1(%eax),%edx
  800f5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f64:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f6a:	8a 12                	mov    (%edx),%dl
  800f6c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f6e:	ff 4d 10             	decl   0x10(%ebp)
  800f71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f75:	74 09                	je     800f80 <strlcpy+0x3c>
  800f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	84 c0                	test   %al,%al
  800f7e:	75 d8                	jne    800f58 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f86:	8b 55 08             	mov    0x8(%ebp),%edx
  800f89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8c:	29 c2                	sub    %eax,%edx
  800f8e:	89 d0                	mov    %edx,%eax
}
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f95:	eb 06                	jmp    800f9d <strcmp+0xb>
		p++, q++;
  800f97:	ff 45 08             	incl   0x8(%ebp)
  800f9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	84 c0                	test   %al,%al
  800fa4:	74 0e                	je     800fb4 <strcmp+0x22>
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 10                	mov    (%eax),%dl
  800fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	38 c2                	cmp    %al,%dl
  800fb2:	74 e3                	je     800f97 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 d0             	movzbl %al,%edx
  800fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	0f b6 c0             	movzbl %al,%eax
  800fc4:	29 c2                	sub    %eax,%edx
  800fc6:	89 d0                	mov    %edx,%eax
}
  800fc8:	5d                   	pop    %ebp
  800fc9:	c3                   	ret    

00800fca <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fcd:	eb 09                	jmp    800fd8 <strncmp+0xe>
		n--, p++, q++;
  800fcf:	ff 4d 10             	decl   0x10(%ebp)
  800fd2:	ff 45 08             	incl   0x8(%ebp)
  800fd5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdc:	74 17                	je     800ff5 <strncmp+0x2b>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	84 c0                	test   %al,%al
  800fe5:	74 0e                	je     800ff5 <strncmp+0x2b>
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 10                	mov    (%eax),%dl
  800fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	38 c2                	cmp    %al,%dl
  800ff3:	74 da                	je     800fcf <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ff5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff9:	75 07                	jne    801002 <strncmp+0x38>
		return 0;
  800ffb:	b8 00 00 00 00       	mov    $0x0,%eax
  801000:	eb 14                	jmp    801016 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	0f b6 d0             	movzbl %al,%edx
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	0f b6 c0             	movzbl %al,%eax
  801012:	29 c2                	sub    %eax,%edx
  801014:	89 d0                	mov    %edx,%eax
}
  801016:	5d                   	pop    %ebp
  801017:	c3                   	ret    

00801018 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801018:	55                   	push   %ebp
  801019:	89 e5                	mov    %esp,%ebp
  80101b:	83 ec 04             	sub    $0x4,%esp
  80101e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801021:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801024:	eb 12                	jmp    801038 <strchr+0x20>
		if (*s == c)
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80102e:	75 05                	jne    801035 <strchr+0x1d>
			return (char *) s;
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	eb 11                	jmp    801046 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801035:	ff 45 08             	incl   0x8(%ebp)
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	84 c0                	test   %al,%al
  80103f:	75 e5                	jne    801026 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801041:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801046:	c9                   	leave  
  801047:	c3                   	ret    

00801048 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	83 ec 04             	sub    $0x4,%esp
  80104e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801051:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801054:	eb 0d                	jmp    801063 <strfind+0x1b>
		if (*s == c)
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80105e:	74 0e                	je     80106e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801060:	ff 45 08             	incl   0x8(%ebp)
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	84 c0                	test   %al,%al
  80106a:	75 ea                	jne    801056 <strfind+0xe>
  80106c:	eb 01                	jmp    80106f <strfind+0x27>
		if (*s == c)
			break;
  80106e:	90                   	nop
	return (char *) s;
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801072:	c9                   	leave  
  801073:	c3                   	ret    

00801074 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801080:	8b 45 10             	mov    0x10(%ebp),%eax
  801083:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801086:	eb 0e                	jmp    801096 <memset+0x22>
		*p++ = c;
  801088:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108b:	8d 50 01             	lea    0x1(%eax),%edx
  80108e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801091:	8b 55 0c             	mov    0xc(%ebp),%edx
  801094:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801096:	ff 4d f8             	decl   -0x8(%ebp)
  801099:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80109d:	79 e9                	jns    801088 <memset+0x14>
		*p++ = c;

	return v;
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a2:	c9                   	leave  
  8010a3:	c3                   	ret    

008010a4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010b6:	eb 16                	jmp    8010ce <memcpy+0x2a>
		*d++ = *s++;
  8010b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bb:	8d 50 01             	lea    0x1(%eax),%edx
  8010be:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010ca:	8a 12                	mov    (%edx),%dl
  8010cc:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	75 dd                	jne    8010b8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f8:	73 50                	jae    80114a <memmove+0x6a>
  8010fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801100:	01 d0                	add    %edx,%eax
  801102:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801105:	76 43                	jbe    80114a <memmove+0x6a>
		s += n;
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80110d:	8b 45 10             	mov    0x10(%ebp),%eax
  801110:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801113:	eb 10                	jmp    801125 <memmove+0x45>
			*--d = *--s;
  801115:	ff 4d f8             	decl   -0x8(%ebp)
  801118:	ff 4d fc             	decl   -0x4(%ebp)
  80111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111e:	8a 10                	mov    (%eax),%dl
  801120:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801123:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801125:	8b 45 10             	mov    0x10(%ebp),%eax
  801128:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112b:	89 55 10             	mov    %edx,0x10(%ebp)
  80112e:	85 c0                	test   %eax,%eax
  801130:	75 e3                	jne    801115 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801132:	eb 23                	jmp    801157 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801134:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801137:	8d 50 01             	lea    0x1(%eax),%edx
  80113a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80113d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801140:	8d 4a 01             	lea    0x1(%edx),%ecx
  801143:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801146:	8a 12                	mov    (%edx),%dl
  801148:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80114a:	8b 45 10             	mov    0x10(%ebp),%eax
  80114d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801150:	89 55 10             	mov    %edx,0x10(%ebp)
  801153:	85 c0                	test   %eax,%eax
  801155:	75 dd                	jne    801134 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80115a:	c9                   	leave  
  80115b:	c3                   	ret    

0080115c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80116e:	eb 2a                	jmp    80119a <memcmp+0x3e>
		if (*s1 != *s2)
  801170:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801173:	8a 10                	mov    (%eax),%dl
  801175:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	38 c2                	cmp    %al,%dl
  80117c:	74 16                	je     801194 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	0f b6 d0             	movzbl %al,%edx
  801186:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801189:	8a 00                	mov    (%eax),%al
  80118b:	0f b6 c0             	movzbl %al,%eax
  80118e:	29 c2                	sub    %eax,%edx
  801190:	89 d0                	mov    %edx,%eax
  801192:	eb 18                	jmp    8011ac <memcmp+0x50>
		s1++, s2++;
  801194:	ff 45 fc             	incl   -0x4(%ebp)
  801197:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80119a:	8b 45 10             	mov    0x10(%ebp),%eax
  80119d:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a0:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	75 c9                	jne    801170 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	01 d0                	add    %edx,%eax
  8011bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011bf:	eb 15                	jmp    8011d6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	0f b6 d0             	movzbl %al,%edx
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cc:	0f b6 c0             	movzbl %al,%eax
  8011cf:	39 c2                	cmp    %eax,%edx
  8011d1:	74 0d                	je     8011e0 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011d3:	ff 45 08             	incl   0x8(%ebp)
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011dc:	72 e3                	jb     8011c1 <memfind+0x13>
  8011de:	eb 01                	jmp    8011e1 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011e0:	90                   	nop
	return (void *) s;
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011fa:	eb 03                	jmp    8011ff <strtol+0x19>
		s++;
  8011fc:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 20                	cmp    $0x20,%al
  801206:	74 f4                	je     8011fc <strtol+0x16>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 09                	cmp    $0x9,%al
  80120f:	74 eb                	je     8011fc <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	3c 2b                	cmp    $0x2b,%al
  801218:	75 05                	jne    80121f <strtol+0x39>
		s++;
  80121a:	ff 45 08             	incl   0x8(%ebp)
  80121d:	eb 13                	jmp    801232 <strtol+0x4c>
	else if (*s == '-')
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	3c 2d                	cmp    $0x2d,%al
  801226:	75 0a                	jne    801232 <strtol+0x4c>
		s++, neg = 1;
  801228:	ff 45 08             	incl   0x8(%ebp)
  80122b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801232:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801236:	74 06                	je     80123e <strtol+0x58>
  801238:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80123c:	75 20                	jne    80125e <strtol+0x78>
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	3c 30                	cmp    $0x30,%al
  801245:	75 17                	jne    80125e <strtol+0x78>
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	40                   	inc    %eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	3c 78                	cmp    $0x78,%al
  80124f:	75 0d                	jne    80125e <strtol+0x78>
		s += 2, base = 16;
  801251:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801255:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80125c:	eb 28                	jmp    801286 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80125e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801262:	75 15                	jne    801279 <strtol+0x93>
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	3c 30                	cmp    $0x30,%al
  80126b:	75 0c                	jne    801279 <strtol+0x93>
		s++, base = 8;
  80126d:	ff 45 08             	incl   0x8(%ebp)
  801270:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801277:	eb 0d                	jmp    801286 <strtol+0xa0>
	else if (base == 0)
  801279:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127d:	75 07                	jne    801286 <strtol+0xa0>
		base = 10;
  80127f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
  801289:	8a 00                	mov    (%eax),%al
  80128b:	3c 2f                	cmp    $0x2f,%al
  80128d:	7e 19                	jle    8012a8 <strtol+0xc2>
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	8a 00                	mov    (%eax),%al
  801294:	3c 39                	cmp    $0x39,%al
  801296:	7f 10                	jg     8012a8 <strtol+0xc2>
			dig = *s - '0';
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	0f be c0             	movsbl %al,%eax
  8012a0:	83 e8 30             	sub    $0x30,%eax
  8012a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a6:	eb 42                	jmp    8012ea <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	3c 60                	cmp    $0x60,%al
  8012af:	7e 19                	jle    8012ca <strtol+0xe4>
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	3c 7a                	cmp    $0x7a,%al
  8012b8:	7f 10                	jg     8012ca <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	8a 00                	mov    (%eax),%al
  8012bf:	0f be c0             	movsbl %al,%eax
  8012c2:	83 e8 57             	sub    $0x57,%eax
  8012c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c8:	eb 20                	jmp    8012ea <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	3c 40                	cmp    $0x40,%al
  8012d1:	7e 39                	jle    80130c <strtol+0x126>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	3c 5a                	cmp    $0x5a,%al
  8012da:	7f 30                	jg     80130c <strtol+0x126>
			dig = *s - 'A' + 10;
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	0f be c0             	movsbl %al,%eax
  8012e4:	83 e8 37             	sub    $0x37,%eax
  8012e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ed:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012f0:	7d 19                	jge    80130b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012f2:	ff 45 08             	incl   0x8(%ebp)
  8012f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f8:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012fc:	89 c2                	mov    %eax,%edx
  8012fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801301:	01 d0                	add    %edx,%eax
  801303:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801306:	e9 7b ff ff ff       	jmp    801286 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80130b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80130c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801310:	74 08                	je     80131a <strtol+0x134>
		*endptr = (char *) s;
  801312:	8b 45 0c             	mov    0xc(%ebp),%eax
  801315:	8b 55 08             	mov    0x8(%ebp),%edx
  801318:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80131a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80131e:	74 07                	je     801327 <strtol+0x141>
  801320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801323:	f7 d8                	neg    %eax
  801325:	eb 03                	jmp    80132a <strtol+0x144>
  801327:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <ltostr>:

void
ltostr(long value, char *str)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801332:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801339:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	79 13                	jns    801359 <ltostr+0x2d>
	{
		neg = 1;
  801346:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80134d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801350:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801353:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801356:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801361:	99                   	cltd   
  801362:	f7 f9                	idiv   %ecx
  801364:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801367:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136a:	8d 50 01             	lea    0x1(%eax),%edx
  80136d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801370:	89 c2                	mov    %eax,%edx
  801372:	8b 45 0c             	mov    0xc(%ebp),%eax
  801375:	01 d0                	add    %edx,%eax
  801377:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80137a:	83 c2 30             	add    $0x30,%edx
  80137d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80137f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801382:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801387:	f7 e9                	imul   %ecx
  801389:	c1 fa 02             	sar    $0x2,%edx
  80138c:	89 c8                	mov    %ecx,%eax
  80138e:	c1 f8 1f             	sar    $0x1f,%eax
  801391:	29 c2                	sub    %eax,%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139c:	75 bb                	jne    801359 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80139e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a8:	48                   	dec    %eax
  8013a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013b0:	74 3d                	je     8013ef <ltostr+0xc3>
		start = 1 ;
  8013b2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013b9:	eb 34                	jmp    8013ef <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c1:	01 d0                	add    %edx,%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ce:	01 c2                	add    %eax,%edx
  8013d0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d6:	01 c8                	add    %ecx,%eax
  8013d8:	8a 00                	mov    (%eax),%al
  8013da:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013e7:	88 02                	mov    %al,(%edx)
		start++ ;
  8013e9:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ec:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f5:	7c c4                	jl     8013bb <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013f7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	01 d0                	add    %edx,%eax
  8013ff:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80140b:	ff 75 08             	pushl  0x8(%ebp)
  80140e:	e8 73 fa ff ff       	call   800e86 <strlen>
  801413:	83 c4 04             	add    $0x4,%esp
  801416:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801419:	ff 75 0c             	pushl  0xc(%ebp)
  80141c:	e8 65 fa ff ff       	call   800e86 <strlen>
  801421:	83 c4 04             	add    $0x4,%esp
  801424:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801427:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80142e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801435:	eb 17                	jmp    80144e <strcconcat+0x49>
		final[s] = str1[s] ;
  801437:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143a:	8b 45 10             	mov    0x10(%ebp),%eax
  80143d:	01 c2                	add    %eax,%edx
  80143f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	01 c8                	add    %ecx,%eax
  801447:	8a 00                	mov    (%eax),%al
  801449:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80144b:	ff 45 fc             	incl   -0x4(%ebp)
  80144e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801451:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801454:	7c e1                	jl     801437 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801456:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80145d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801464:	eb 1f                	jmp    801485 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801466:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801469:	8d 50 01             	lea    0x1(%eax),%edx
  80146c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146f:	89 c2                	mov    %eax,%edx
  801471:	8b 45 10             	mov    0x10(%ebp),%eax
  801474:	01 c2                	add    %eax,%edx
  801476:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147c:	01 c8                	add    %ecx,%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801482:	ff 45 f8             	incl   -0x8(%ebp)
  801485:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801488:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80148b:	7c d9                	jl     801466 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80148d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801490:	8b 45 10             	mov    0x10(%ebp),%eax
  801493:	01 d0                	add    %edx,%eax
  801495:	c6 00 00             	movb   $0x0,(%eax)
}
  801498:	90                   	nop
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80149e:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014aa:	8b 00                	mov    (%eax),%eax
  8014ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b6:	01 d0                	add    %edx,%eax
  8014b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014be:	eb 0c                	jmp    8014cc <strsplit+0x31>
			*string++ = 0;
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	8d 50 01             	lea    0x1(%eax),%edx
  8014c6:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	84 c0                	test   %al,%al
  8014d3:	74 18                	je     8014ed <strsplit+0x52>
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	0f be c0             	movsbl %al,%eax
  8014dd:	50                   	push   %eax
  8014de:	ff 75 0c             	pushl  0xc(%ebp)
  8014e1:	e8 32 fb ff ff       	call   801018 <strchr>
  8014e6:	83 c4 08             	add    $0x8,%esp
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	75 d3                	jne    8014c0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	8a 00                	mov    (%eax),%al
  8014f2:	84 c0                	test   %al,%al
  8014f4:	74 5a                	je     801550 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	83 f8 0f             	cmp    $0xf,%eax
  8014fe:	75 07                	jne    801507 <strsplit+0x6c>
		{
			return 0;
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
  801505:	eb 66                	jmp    80156d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801507:	8b 45 14             	mov    0x14(%ebp),%eax
  80150a:	8b 00                	mov    (%eax),%eax
  80150c:	8d 48 01             	lea    0x1(%eax),%ecx
  80150f:	8b 55 14             	mov    0x14(%ebp),%edx
  801512:	89 0a                	mov    %ecx,(%edx)
  801514:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151b:	8b 45 10             	mov    0x10(%ebp),%eax
  80151e:	01 c2                	add    %eax,%edx
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801525:	eb 03                	jmp    80152a <strsplit+0x8f>
			string++;
  801527:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8a 00                	mov    (%eax),%al
  80152f:	84 c0                	test   %al,%al
  801531:	74 8b                	je     8014be <strsplit+0x23>
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 00                	mov    (%eax),%al
  801538:	0f be c0             	movsbl %al,%eax
  80153b:	50                   	push   %eax
  80153c:	ff 75 0c             	pushl  0xc(%ebp)
  80153f:	e8 d4 fa ff ff       	call   801018 <strchr>
  801544:	83 c4 08             	add    $0x8,%esp
  801547:	85 c0                	test   %eax,%eax
  801549:	74 dc                	je     801527 <strsplit+0x8c>
			string++;
	}
  80154b:	e9 6e ff ff ff       	jmp    8014be <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801550:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801551:	8b 45 14             	mov    0x14(%ebp),%eax
  801554:	8b 00                	mov    (%eax),%eax
  801556:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	01 d0                	add    %edx,%eax
  801562:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801568:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801575:	83 ec 04             	sub    $0x4,%esp
  801578:	68 08 27 80 00       	push   $0x802708
  80157d:	68 3f 01 00 00       	push   $0x13f
  801582:	68 2a 27 80 00       	push   $0x80272a
  801587:	e8 a9 ef ff ff       	call   800535 <_panic>

0080158c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	57                   	push   %edi
  801590:	56                   	push   %esi
  801591:	53                   	push   %ebx
  801592:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015a1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015a4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015a7:	cd 30                	int    $0x30
  8015a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	5b                   	pop    %ebx
  8015b3:	5e                   	pop    %esi
  8015b4:	5f                   	pop    %edi
  8015b5:	5d                   	pop    %ebp
  8015b6:	c3                   	ret    

008015b7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 04             	sub    $0x4,%esp
  8015bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	52                   	push   %edx
  8015cf:	ff 75 0c             	pushl  0xc(%ebp)
  8015d2:	50                   	push   %eax
  8015d3:	6a 00                	push   $0x0
  8015d5:	e8 b2 ff ff ff       	call   80158c <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
}
  8015dd:	90                   	nop
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 02                	push   $0x2
  8015ef:	e8 98 ff ff ff       	call   80158c <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 03                	push   $0x3
  801608:	e8 7f ff ff ff       	call   80158c <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	90                   	nop
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	6a 04                	push   $0x4
  801622:	e8 65 ff ff ff       	call   80158c <syscall>
  801627:	83 c4 18             	add    $0x18,%esp
}
  80162a:	90                   	nop
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801630:	8b 55 0c             	mov    0xc(%ebp),%edx
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	52                   	push   %edx
  80163d:	50                   	push   %eax
  80163e:	6a 08                	push   $0x8
  801640:	e8 47 ff ff ff       	call   80158c <syscall>
  801645:	83 c4 18             	add    $0x18,%esp
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	56                   	push   %esi
  80164e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80164f:	8b 75 18             	mov    0x18(%ebp),%esi
  801652:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801655:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	56                   	push   %esi
  80165f:	53                   	push   %ebx
  801660:	51                   	push   %ecx
  801661:	52                   	push   %edx
  801662:	50                   	push   %eax
  801663:	6a 09                	push   $0x9
  801665:	e8 22 ff ff ff       	call   80158c <syscall>
  80166a:	83 c4 18             	add    $0x18,%esp
}
  80166d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801670:	5b                   	pop    %ebx
  801671:	5e                   	pop    %esi
  801672:	5d                   	pop    %ebp
  801673:	c3                   	ret    

00801674 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	52                   	push   %edx
  801684:	50                   	push   %eax
  801685:	6a 0a                	push   $0xa
  801687:	e8 00 ff ff ff       	call   80158c <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	ff 75 0c             	pushl  0xc(%ebp)
  80169d:	ff 75 08             	pushl  0x8(%ebp)
  8016a0:	6a 0b                	push   $0xb
  8016a2:	e8 e5 fe ff ff       	call   80158c <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 0c                	push   $0xc
  8016bb:	e8 cc fe ff ff       	call   80158c <syscall>
  8016c0:	83 c4 18             	add    $0x18,%esp
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 0d                	push   $0xd
  8016d4:	e8 b3 fe ff ff       	call   80158c <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 0e                	push   $0xe
  8016ed:	e8 9a fe ff ff       	call   80158c <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 0f                	push   $0xf
  801706:	e8 81 fe ff ff       	call   80158c <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	ff 75 08             	pushl  0x8(%ebp)
  80171e:	6a 10                	push   $0x10
  801720:	e8 67 fe ff ff       	call   80158c <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 11                	push   $0x11
  801739:	e8 4e fe ff ff       	call   80158c <syscall>
  80173e:	83 c4 18             	add    $0x18,%esp
}
  801741:	90                   	nop
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_cputc>:

void
sys_cputc(const char c)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	83 ec 04             	sub    $0x4,%esp
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801750:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	50                   	push   %eax
  80175d:	6a 01                	push   $0x1
  80175f:	e8 28 fe ff ff       	call   80158c <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
}
  801767:	90                   	nop
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 14                	push   $0x14
  801779:	e8 0e fe ff ff       	call   80158c <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
}
  801781:	90                   	nop
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	83 ec 04             	sub    $0x4,%esp
  80178a:	8b 45 10             	mov    0x10(%ebp),%eax
  80178d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801790:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801793:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	6a 00                	push   $0x0
  80179c:	51                   	push   %ecx
  80179d:	52                   	push   %edx
  80179e:	ff 75 0c             	pushl  0xc(%ebp)
  8017a1:	50                   	push   %eax
  8017a2:	6a 15                	push   $0x15
  8017a4:	e8 e3 fd ff ff       	call   80158c <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	52                   	push   %edx
  8017be:	50                   	push   %eax
  8017bf:	6a 16                	push   $0x16
  8017c1:	e8 c6 fd ff ff       	call   80158c <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	51                   	push   %ecx
  8017dc:	52                   	push   %edx
  8017dd:	50                   	push   %eax
  8017de:	6a 17                	push   $0x17
  8017e0:	e8 a7 fd ff ff       	call   80158c <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	52                   	push   %edx
  8017fa:	50                   	push   %eax
  8017fb:	6a 18                	push   $0x18
  8017fd:	e8 8a fd ff ff       	call   80158c <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	6a 00                	push   $0x0
  80180f:	ff 75 14             	pushl  0x14(%ebp)
  801812:	ff 75 10             	pushl  0x10(%ebp)
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	50                   	push   %eax
  801819:	6a 19                	push   $0x19
  80181b:	e8 6c fd ff ff       	call   80158c <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	50                   	push   %eax
  801834:	6a 1a                	push   $0x1a
  801836:	e8 51 fd ff ff       	call   80158c <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
}
  80183e:	90                   	nop
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	50                   	push   %eax
  801850:	6a 1b                	push   $0x1b
  801852:	e8 35 fd ff ff       	call   80158c <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 05                	push   $0x5
  80186b:	e8 1c fd ff ff       	call   80158c <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 06                	push   $0x6
  801884:	e8 03 fd ff ff       	call   80158c <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 07                	push   $0x7
  80189d:	e8 ea fc ff ff       	call   80158c <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_exit_env>:


void sys_exit_env(void)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 1c                	push   $0x1c
  8018b6:	e8 d1 fc ff ff       	call   80158c <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	90                   	nop
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018ca:	8d 50 04             	lea    0x4(%eax),%edx
  8018cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	52                   	push   %edx
  8018d7:	50                   	push   %eax
  8018d8:	6a 1d                	push   $0x1d
  8018da:	e8 ad fc ff ff       	call   80158c <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
	return result;
  8018e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018eb:	89 01                	mov    %eax,(%ecx)
  8018ed:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	c9                   	leave  
  8018f4:	c2 04 00             	ret    $0x4

008018f7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	ff 75 10             	pushl  0x10(%ebp)
  801901:	ff 75 0c             	pushl  0xc(%ebp)
  801904:	ff 75 08             	pushl  0x8(%ebp)
  801907:	6a 13                	push   $0x13
  801909:	e8 7e fc ff ff       	call   80158c <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
	return ;
  801911:	90                   	nop
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_rcr2>:
uint32 sys_rcr2()
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 1e                	push   $0x1e
  801923:	e8 64 fc ff ff       	call   80158c <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 04             	sub    $0x4,%esp
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801939:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	50                   	push   %eax
  801946:	6a 1f                	push   $0x1f
  801948:	e8 3f fc ff ff       	call   80158c <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
	return ;
  801950:	90                   	nop
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <rsttst>:
void rsttst()
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 21                	push   $0x21
  801962:	e8 25 fc ff ff       	call   80158c <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
	return ;
  80196a:	90                   	nop
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	83 ec 04             	sub    $0x4,%esp
  801973:	8b 45 14             	mov    0x14(%ebp),%eax
  801976:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801979:	8b 55 18             	mov    0x18(%ebp),%edx
  80197c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801980:	52                   	push   %edx
  801981:	50                   	push   %eax
  801982:	ff 75 10             	pushl  0x10(%ebp)
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	6a 20                	push   $0x20
  80198d:	e8 fa fb ff ff       	call   80158c <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
	return ;
  801995:	90                   	nop
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <chktst>:
void chktst(uint32 n)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	ff 75 08             	pushl  0x8(%ebp)
  8019a6:	6a 22                	push   $0x22
  8019a8:	e8 df fb ff ff       	call   80158c <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b0:	90                   	nop
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <inctst>:

void inctst()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 23                	push   $0x23
  8019c2:	e8 c5 fb ff ff       	call   80158c <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ca:	90                   	nop
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <gettst>:
uint32 gettst()
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 24                	push   $0x24
  8019dc:	e8 ab fb ff ff       	call   80158c <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  8019f8:	e8 8f fb ff ff       	call   80158c <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
  801a00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a03:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a07:	75 07                	jne    801a10 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a09:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0e:	eb 05                	jmp    801a15 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
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
  801a29:	e8 5e fb ff ff       	call   80158c <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
  801a31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a34:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a38:	75 07                	jne    801a41 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3f:	eb 05                	jmp    801a46 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  801a5a:	e8 2d fb ff ff       	call   80158c <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
  801a62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a65:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a69:	75 07                	jne    801a72 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a70:	eb 05                	jmp    801a77 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 25                	push   $0x25
  801a8b:	e8 fc fa ff ff       	call   80158c <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
  801a93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a96:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a9a:	75 07                	jne    801aa3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa1:	eb 05                	jmp    801aa8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	ff 75 08             	pushl  0x8(%ebp)
  801ab8:	6a 26                	push   $0x26
  801aba:	e8 cd fa ff ff       	call   80158c <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac2:	90                   	nop
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ac9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801acc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	6a 00                	push   $0x0
  801ad7:	53                   	push   %ebx
  801ad8:	51                   	push   %ecx
  801ad9:	52                   	push   %edx
  801ada:	50                   	push   %eax
  801adb:	6a 27                	push   $0x27
  801add:	e8 aa fa ff ff       	call   80158c <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	52                   	push   %edx
  801afa:	50                   	push   %eax
  801afb:	6a 28                	push   $0x28
  801afd:	e8 8a fa ff ff       	call   80158c <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b0a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	6a 00                	push   $0x0
  801b15:	51                   	push   %ecx
  801b16:	ff 75 10             	pushl  0x10(%ebp)
  801b19:	52                   	push   %edx
  801b1a:	50                   	push   %eax
  801b1b:	6a 29                	push   $0x29
  801b1d:	e8 6a fa ff ff       	call   80158c <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	ff 75 10             	pushl  0x10(%ebp)
  801b31:	ff 75 0c             	pushl  0xc(%ebp)
  801b34:	ff 75 08             	pushl  0x8(%ebp)
  801b37:	6a 12                	push   $0x12
  801b39:	e8 4e fa ff ff       	call   80158c <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b41:	90                   	nop
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	52                   	push   %edx
  801b54:	50                   	push   %eax
  801b55:	6a 2a                	push   $0x2a
  801b57:	e8 30 fa ff ff       	call   80158c <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
	return;
  801b5f:	90                   	nop
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	50                   	push   %eax
  801b71:	6a 2b                	push   $0x2b
  801b73:	e8 14 fa ff ff       	call   80158c <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	ff 75 08             	pushl  0x8(%ebp)
  801b8c:	6a 2c                	push   $0x2c
  801b8e:	e8 f9 f9 ff ff       	call   80158c <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
	return;
  801b96:	90                   	nop
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	ff 75 0c             	pushl  0xc(%ebp)
  801ba5:	ff 75 08             	pushl  0x8(%ebp)
  801ba8:	6a 2d                	push   $0x2d
  801baa:	e8 dd f9 ff ff       	call   80158c <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
	return;
  801bb2:	90                   	nop
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 2e                	push   $0x2e
  801bc7:	e8 c0 f9 ff ff       	call   80158c <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
  801bcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	50                   	push   %eax
  801be6:	6a 2f                	push   $0x2f
  801be8:	e8 9f f9 ff ff       	call   80158c <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
	return;
  801bf0:	90                   	nop
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	52                   	push   %edx
  801c03:	50                   	push   %eax
  801c04:	6a 30                	push   $0x30
  801c06:	e8 81 f9 ff ff       	call   80158c <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
	return;
  801c0e:	90                   	nop
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	50                   	push   %eax
  801c23:	6a 31                	push   $0x31
  801c25:	e8 62 f9 ff ff       	call   80158c <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
  801c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	50                   	push   %eax
  801c44:	6a 32                	push   $0x32
  801c46:	e8 41 f9 ff ff       	call   80158c <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
	return;
  801c4e:	90                   	nop
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    
  801c51:	66 90                	xchg   %ax,%ax
  801c53:	90                   	nop

00801c54 <__udivdi3>:
  801c54:	55                   	push   %ebp
  801c55:	57                   	push   %edi
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	83 ec 1c             	sub    $0x1c,%esp
  801c5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c6b:	89 ca                	mov    %ecx,%edx
  801c6d:	89 f8                	mov    %edi,%eax
  801c6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c73:	85 f6                	test   %esi,%esi
  801c75:	75 2d                	jne    801ca4 <__udivdi3+0x50>
  801c77:	39 cf                	cmp    %ecx,%edi
  801c79:	77 65                	ja     801ce0 <__udivdi3+0x8c>
  801c7b:	89 fd                	mov    %edi,%ebp
  801c7d:	85 ff                	test   %edi,%edi
  801c7f:	75 0b                	jne    801c8c <__udivdi3+0x38>
  801c81:	b8 01 00 00 00       	mov    $0x1,%eax
  801c86:	31 d2                	xor    %edx,%edx
  801c88:	f7 f7                	div    %edi
  801c8a:	89 c5                	mov    %eax,%ebp
  801c8c:	31 d2                	xor    %edx,%edx
  801c8e:	89 c8                	mov    %ecx,%eax
  801c90:	f7 f5                	div    %ebp
  801c92:	89 c1                	mov    %eax,%ecx
  801c94:	89 d8                	mov    %ebx,%eax
  801c96:	f7 f5                	div    %ebp
  801c98:	89 cf                	mov    %ecx,%edi
  801c9a:	89 fa                	mov    %edi,%edx
  801c9c:	83 c4 1c             	add    $0x1c,%esp
  801c9f:	5b                   	pop    %ebx
  801ca0:	5e                   	pop    %esi
  801ca1:	5f                   	pop    %edi
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    
  801ca4:	39 ce                	cmp    %ecx,%esi
  801ca6:	77 28                	ja     801cd0 <__udivdi3+0x7c>
  801ca8:	0f bd fe             	bsr    %esi,%edi
  801cab:	83 f7 1f             	xor    $0x1f,%edi
  801cae:	75 40                	jne    801cf0 <__udivdi3+0x9c>
  801cb0:	39 ce                	cmp    %ecx,%esi
  801cb2:	72 0a                	jb     801cbe <__udivdi3+0x6a>
  801cb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cb8:	0f 87 9e 00 00 00    	ja     801d5c <__udivdi3+0x108>
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc3:	89 fa                	mov    %edi,%edx
  801cc5:	83 c4 1c             	add    $0x1c,%esp
  801cc8:	5b                   	pop    %ebx
  801cc9:	5e                   	pop    %esi
  801cca:	5f                   	pop    %edi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    
  801ccd:	8d 76 00             	lea    0x0(%esi),%esi
  801cd0:	31 ff                	xor    %edi,%edi
  801cd2:	31 c0                	xor    %eax,%eax
  801cd4:	89 fa                	mov    %edi,%edx
  801cd6:	83 c4 1c             	add    $0x1c,%esp
  801cd9:	5b                   	pop    %ebx
  801cda:	5e                   	pop    %esi
  801cdb:	5f                   	pop    %edi
  801cdc:	5d                   	pop    %ebp
  801cdd:	c3                   	ret    
  801cde:	66 90                	xchg   %ax,%ax
  801ce0:	89 d8                	mov    %ebx,%eax
  801ce2:	f7 f7                	div    %edi
  801ce4:	31 ff                	xor    %edi,%edi
  801ce6:	89 fa                	mov    %edi,%edx
  801ce8:	83 c4 1c             	add    $0x1c,%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5e                   	pop    %esi
  801ced:	5f                   	pop    %edi
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    
  801cf0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cf5:	89 eb                	mov    %ebp,%ebx
  801cf7:	29 fb                	sub    %edi,%ebx
  801cf9:	89 f9                	mov    %edi,%ecx
  801cfb:	d3 e6                	shl    %cl,%esi
  801cfd:	89 c5                	mov    %eax,%ebp
  801cff:	88 d9                	mov    %bl,%cl
  801d01:	d3 ed                	shr    %cl,%ebp
  801d03:	89 e9                	mov    %ebp,%ecx
  801d05:	09 f1                	or     %esi,%ecx
  801d07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d0b:	89 f9                	mov    %edi,%ecx
  801d0d:	d3 e0                	shl    %cl,%eax
  801d0f:	89 c5                	mov    %eax,%ebp
  801d11:	89 d6                	mov    %edx,%esi
  801d13:	88 d9                	mov    %bl,%cl
  801d15:	d3 ee                	shr    %cl,%esi
  801d17:	89 f9                	mov    %edi,%ecx
  801d19:	d3 e2                	shl    %cl,%edx
  801d1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d1f:	88 d9                	mov    %bl,%cl
  801d21:	d3 e8                	shr    %cl,%eax
  801d23:	09 c2                	or     %eax,%edx
  801d25:	89 d0                	mov    %edx,%eax
  801d27:	89 f2                	mov    %esi,%edx
  801d29:	f7 74 24 0c          	divl   0xc(%esp)
  801d2d:	89 d6                	mov    %edx,%esi
  801d2f:	89 c3                	mov    %eax,%ebx
  801d31:	f7 e5                	mul    %ebp
  801d33:	39 d6                	cmp    %edx,%esi
  801d35:	72 19                	jb     801d50 <__udivdi3+0xfc>
  801d37:	74 0b                	je     801d44 <__udivdi3+0xf0>
  801d39:	89 d8                	mov    %ebx,%eax
  801d3b:	31 ff                	xor    %edi,%edi
  801d3d:	e9 58 ff ff ff       	jmp    801c9a <__udivdi3+0x46>
  801d42:	66 90                	xchg   %ax,%ax
  801d44:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d48:	89 f9                	mov    %edi,%ecx
  801d4a:	d3 e2                	shl    %cl,%edx
  801d4c:	39 c2                	cmp    %eax,%edx
  801d4e:	73 e9                	jae    801d39 <__udivdi3+0xe5>
  801d50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d53:	31 ff                	xor    %edi,%edi
  801d55:	e9 40 ff ff ff       	jmp    801c9a <__udivdi3+0x46>
  801d5a:	66 90                	xchg   %ax,%ax
  801d5c:	31 c0                	xor    %eax,%eax
  801d5e:	e9 37 ff ff ff       	jmp    801c9a <__udivdi3+0x46>
  801d63:	90                   	nop

00801d64 <__umoddi3>:
  801d64:	55                   	push   %ebp
  801d65:	57                   	push   %edi
  801d66:	56                   	push   %esi
  801d67:	53                   	push   %ebx
  801d68:	83 ec 1c             	sub    $0x1c,%esp
  801d6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d83:	89 f3                	mov    %esi,%ebx
  801d85:	89 fa                	mov    %edi,%edx
  801d87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d8b:	89 34 24             	mov    %esi,(%esp)
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	75 1a                	jne    801dac <__umoddi3+0x48>
  801d92:	39 f7                	cmp    %esi,%edi
  801d94:	0f 86 a2 00 00 00    	jbe    801e3c <__umoddi3+0xd8>
  801d9a:	89 c8                	mov    %ecx,%eax
  801d9c:	89 f2                	mov    %esi,%edx
  801d9e:	f7 f7                	div    %edi
  801da0:	89 d0                	mov    %edx,%eax
  801da2:	31 d2                	xor    %edx,%edx
  801da4:	83 c4 1c             	add    $0x1c,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    
  801dac:	39 f0                	cmp    %esi,%eax
  801dae:	0f 87 ac 00 00 00    	ja     801e60 <__umoddi3+0xfc>
  801db4:	0f bd e8             	bsr    %eax,%ebp
  801db7:	83 f5 1f             	xor    $0x1f,%ebp
  801dba:	0f 84 ac 00 00 00    	je     801e6c <__umoddi3+0x108>
  801dc0:	bf 20 00 00 00       	mov    $0x20,%edi
  801dc5:	29 ef                	sub    %ebp,%edi
  801dc7:	89 fe                	mov    %edi,%esi
  801dc9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dcd:	89 e9                	mov    %ebp,%ecx
  801dcf:	d3 e0                	shl    %cl,%eax
  801dd1:	89 d7                	mov    %edx,%edi
  801dd3:	89 f1                	mov    %esi,%ecx
  801dd5:	d3 ef                	shr    %cl,%edi
  801dd7:	09 c7                	or     %eax,%edi
  801dd9:	89 e9                	mov    %ebp,%ecx
  801ddb:	d3 e2                	shl    %cl,%edx
  801ddd:	89 14 24             	mov    %edx,(%esp)
  801de0:	89 d8                	mov    %ebx,%eax
  801de2:	d3 e0                	shl    %cl,%eax
  801de4:	89 c2                	mov    %eax,%edx
  801de6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dea:	d3 e0                	shl    %cl,%eax
  801dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801df4:	89 f1                	mov    %esi,%ecx
  801df6:	d3 e8                	shr    %cl,%eax
  801df8:	09 d0                	or     %edx,%eax
  801dfa:	d3 eb                	shr    %cl,%ebx
  801dfc:	89 da                	mov    %ebx,%edx
  801dfe:	f7 f7                	div    %edi
  801e00:	89 d3                	mov    %edx,%ebx
  801e02:	f7 24 24             	mull   (%esp)
  801e05:	89 c6                	mov    %eax,%esi
  801e07:	89 d1                	mov    %edx,%ecx
  801e09:	39 d3                	cmp    %edx,%ebx
  801e0b:	0f 82 87 00 00 00    	jb     801e98 <__umoddi3+0x134>
  801e11:	0f 84 91 00 00 00    	je     801ea8 <__umoddi3+0x144>
  801e17:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e1b:	29 f2                	sub    %esi,%edx
  801e1d:	19 cb                	sbb    %ecx,%ebx
  801e1f:	89 d8                	mov    %ebx,%eax
  801e21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e25:	d3 e0                	shl    %cl,%eax
  801e27:	89 e9                	mov    %ebp,%ecx
  801e29:	d3 ea                	shr    %cl,%edx
  801e2b:	09 d0                	or     %edx,%eax
  801e2d:	89 e9                	mov    %ebp,%ecx
  801e2f:	d3 eb                	shr    %cl,%ebx
  801e31:	89 da                	mov    %ebx,%edx
  801e33:	83 c4 1c             	add    $0x1c,%esp
  801e36:	5b                   	pop    %ebx
  801e37:	5e                   	pop    %esi
  801e38:	5f                   	pop    %edi
  801e39:	5d                   	pop    %ebp
  801e3a:	c3                   	ret    
  801e3b:	90                   	nop
  801e3c:	89 fd                	mov    %edi,%ebp
  801e3e:	85 ff                	test   %edi,%edi
  801e40:	75 0b                	jne    801e4d <__umoddi3+0xe9>
  801e42:	b8 01 00 00 00       	mov    $0x1,%eax
  801e47:	31 d2                	xor    %edx,%edx
  801e49:	f7 f7                	div    %edi
  801e4b:	89 c5                	mov    %eax,%ebp
  801e4d:	89 f0                	mov    %esi,%eax
  801e4f:	31 d2                	xor    %edx,%edx
  801e51:	f7 f5                	div    %ebp
  801e53:	89 c8                	mov    %ecx,%eax
  801e55:	f7 f5                	div    %ebp
  801e57:	89 d0                	mov    %edx,%eax
  801e59:	e9 44 ff ff ff       	jmp    801da2 <__umoddi3+0x3e>
  801e5e:	66 90                	xchg   %ax,%ax
  801e60:	89 c8                	mov    %ecx,%eax
  801e62:	89 f2                	mov    %esi,%edx
  801e64:	83 c4 1c             	add    $0x1c,%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5f                   	pop    %edi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    
  801e6c:	3b 04 24             	cmp    (%esp),%eax
  801e6f:	72 06                	jb     801e77 <__umoddi3+0x113>
  801e71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e75:	77 0f                	ja     801e86 <__umoddi3+0x122>
  801e77:	89 f2                	mov    %esi,%edx
  801e79:	29 f9                	sub    %edi,%ecx
  801e7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e7f:	89 14 24             	mov    %edx,(%esp)
  801e82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e86:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e8a:	8b 14 24             	mov    (%esp),%edx
  801e8d:	83 c4 1c             	add    $0x1c,%esp
  801e90:	5b                   	pop    %ebx
  801e91:	5e                   	pop    %esi
  801e92:	5f                   	pop    %edi
  801e93:	5d                   	pop    %ebp
  801e94:	c3                   	ret    
  801e95:	8d 76 00             	lea    0x0(%esi),%esi
  801e98:	2b 04 24             	sub    (%esp),%eax
  801e9b:	19 fa                	sbb    %edi,%edx
  801e9d:	89 d1                	mov    %edx,%ecx
  801e9f:	89 c6                	mov    %eax,%esi
  801ea1:	e9 71 ff ff ff       	jmp    801e17 <__umoddi3+0xb3>
  801ea6:	66 90                	xchg   %ax,%ax
  801ea8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801eac:	72 ea                	jb     801e98 <__umoddi3+0x134>
  801eae:	89 d9                	mov    %ebx,%ecx
  801eb0:	e9 62 ff ff ff       	jmp    801e17 <__umoddi3+0xb3>
