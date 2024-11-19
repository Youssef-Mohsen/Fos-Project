
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
  8000e1:	e8 d7 19 00 00       	call   801abd <sys_check_LRU_lists>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if(check == 0)
  8000ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8000f0:	75 14                	jne    800106 <_main+0xce>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 20 1e 80 00       	push   $0x801e20
  8000fa:	6a 24                	push   $0x24
  8000fc:	68 a2 1e 80 00       	push   $0x801ea2
  800101:	e8 27 04 00 00       	call   80052d <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800106:	e8 e4 15 00 00       	call   8016ef <sys_pf_calculate_allocated_pages>
  80010b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int freePages = sys_calculate_free_frames();
  80010e:	e8 91 15 00 00       	call   8016a4 <sys_calculate_free_frames>
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
  800190:	68 bc 1e 80 00       	push   $0x801ebc
  800195:	e8 50 06 00 00       	call   8007ea <cprintf>
  80019a:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  80019d:	8a 85 c8 ff ff fe    	mov    -0x1000038(%ebp),%al
  8001a3:	3c ff                	cmp    $0xff,%al
  8001a5:	74 17                	je     8001be <_main+0x186>
  8001a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 ec 1e 80 00       	push   $0x801eec
  8001b6:	e8 2f 06 00 00       	call   8007ea <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001be:	8a 85 c8 0f 00 ff    	mov    -0xfff038(%ebp),%al
  8001c4:	3c ff                	cmp    $0xff,%al
  8001c6:	74 17                	je     8001df <_main+0x1a7>
  8001c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cf:	83 ec 0c             	sub    $0xc,%esp
  8001d2:	68 ec 1e 80 00       	push   $0x801eec
  8001d7:	e8 0e 06 00 00       	call   8007ea <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001df:	8a 85 c8 ff 3f ff    	mov    -0xc00038(%ebp),%al
  8001e5:	3c ff                	cmp    $0xff,%al
  8001e7:	74 17                	je     800200 <_main+0x1c8>
  8001e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 ec 1e 80 00       	push   $0x801eec
  8001f8:	e8 ed 05 00 00       	call   8007ea <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800200:	8a 85 c8 0f 40 ff    	mov    -0xbff038(%ebp),%al
  800206:	3c ff                	cmp    $0xff,%al
  800208:	74 17                	je     800221 <_main+0x1e9>
  80020a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	68 ec 1e 80 00       	push   $0x801eec
  800219:	e8 cc 05 00 00       	call   8007ea <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800221:	8a 85 c8 ff 7f ff    	mov    -0x800038(%ebp),%al
  800227:	3c ff                	cmp    $0xff,%al
  800229:	74 17                	je     800242 <_main+0x20a>
  80022b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 ec 1e 80 00       	push   $0x801eec
  80023a:	e8 ab 05 00 00       	call   8007ea <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800242:	8a 85 c8 0f 80 ff    	mov    -0x7ff038(%ebp),%al
  800248:	3c ff                	cmp    $0xff,%al
  80024a:	74 17                	je     800263 <_main+0x22b>
  80024c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	68 ec 1e 80 00       	push   $0x801eec
  80025b:	e8 8a 05 00 00       	call   8007ea <cprintf>
  800260:	83 c4 10             	add    $0x10,%esp


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT written to Page File until it's replaced\n"); }
  800263:	e8 87 14 00 00       	call   8016ef <sys_pf_calculate_allocated_pages>
  800268:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80026b:	74 17                	je     800284 <_main+0x24c>
  80026d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	68 0c 1f 80 00       	push   $0x801f0c
  80027c:	e8 69 05 00 00       	call   8007ea <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  800284:	c7 45 d0 07 00 00 00 	movl   $0x7,-0x30(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  80028b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80028e:	e8 11 14 00 00       	call   8016a4 <sys_calculate_free_frames>
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
  8002b2:	68 54 1f 80 00       	push   $0x801f54
  8002b7:	e8 2e 05 00 00       	call   8007ea <cprintf>
  8002bc:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8002bf:	83 ec 0c             	sub    $0xc,%esp
  8002c2:	68 94 1f 80 00       	push   $0x801f94
  8002c7:	e8 1e 05 00 00       	call   8007ea <cprintf>
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
  800373:	68 c8 1f 80 00       	push   $0x801fc8
  800378:	e8 6d 04 00 00       	call   8007ea <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  800380:	6a 04                	push   $0x4
  800382:	6a 0d                	push   $0xd
  800384:	8d 85 78 ff ff fe    	lea    -0x1000088(%ebp),%eax
  80038a:	50                   	push   %eax
  80038b:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  800391:	50                   	push   %eax
  800392:	e8 26 17 00 00       	call   801abd <sys_check_LRU_lists>
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if(check == 0)
  80039d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8003a1:	75 17                	jne    8003ba <_main+0x382>
			{ is_correct = 0; cprintf("LRU lists entries are not correct, check your logic again!!\n"); }
  8003a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8003aa:	83 ec 0c             	sub    $0xc,%esp
  8003ad:	68 f0 1f 80 00       	push   $0x801ff0
  8003b2:	e8 33 04 00 00       	call   8007ea <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	68 30 20 80 00       	push   $0x802030
  8003c2:	e8 23 04 00 00       	call   8007ea <cprintf>
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
  8003e1:	68 68 20 80 00       	push   $0x802068
  8003e6:	e8 ff 03 00 00       	call   8007ea <cprintf>
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
  8003fc:	e8 6c 14 00 00       	call   80186d <sys_getenvindex>
  800401:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800407:	89 d0                	mov    %edx,%eax
  800409:	c1 e0 02             	shl    $0x2,%eax
  80040c:	01 d0                	add    %edx,%eax
  80040e:	01 c0                	add    %eax,%eax
  800410:	01 d0                	add    %edx,%eax
  800412:	c1 e0 02             	shl    $0x2,%eax
  800415:	01 d0                	add    %edx,%eax
  800417:	01 c0                	add    %eax,%eax
  800419:	01 d0                	add    %edx,%eax
  80041b:	c1 e0 04             	shl    $0x4,%eax
  80041e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800423:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800428:	a1 04 30 80 00       	mov    0x803004,%eax
  80042d:	8a 40 20             	mov    0x20(%eax),%al
  800430:	84 c0                	test   %al,%al
  800432:	74 0d                	je     800441 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800434:	a1 04 30 80 00       	mov    0x803004,%eax
  800439:	83 c0 20             	add    $0x20,%eax
  80043c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800441:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800445:	7e 0a                	jle    800451 <libmain+0x5b>
		binaryname = argv[0];
  800447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800451:	83 ec 08             	sub    $0x8,%esp
  800454:	ff 75 0c             	pushl  0xc(%ebp)
  800457:	ff 75 08             	pushl  0x8(%ebp)
  80045a:	e8 d9 fb ff ff       	call   800038 <_main>
  80045f:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800462:	e8 8a 11 00 00       	call   8015f1 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800467:	83 ec 0c             	sub    $0xc,%esp
  80046a:	68 d4 20 80 00       	push   $0x8020d4
  80046f:	e8 76 03 00 00       	call   8007ea <cprintf>
  800474:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800477:	a1 04 30 80 00       	mov    0x803004,%eax
  80047c:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800482:	a1 04 30 80 00       	mov    0x803004,%eax
  800487:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80048d:	83 ec 04             	sub    $0x4,%esp
  800490:	52                   	push   %edx
  800491:	50                   	push   %eax
  800492:	68 fc 20 80 00       	push   $0x8020fc
  800497:	e8 4e 03 00 00       	call   8007ea <cprintf>
  80049c:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80049f:	a1 04 30 80 00       	mov    0x803004,%eax
  8004a4:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8004aa:	a1 04 30 80 00       	mov    0x803004,%eax
  8004af:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8004b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ba:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8004c0:	51                   	push   %ecx
  8004c1:	52                   	push   %edx
  8004c2:	50                   	push   %eax
  8004c3:	68 24 21 80 00       	push   $0x802124
  8004c8:	e8 1d 03 00 00       	call   8007ea <cprintf>
  8004cd:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8004d5:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	50                   	push   %eax
  8004df:	68 7c 21 80 00       	push   $0x80217c
  8004e4:	e8 01 03 00 00       	call   8007ea <cprintf>
  8004e9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	68 d4 20 80 00       	push   $0x8020d4
  8004f4:	e8 f1 02 00 00       	call   8007ea <cprintf>
  8004f9:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8004fc:	e8 0a 11 00 00       	call   80160b <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800501:	e8 19 00 00 00       	call   80051f <exit>
}
  800506:	90                   	nop
  800507:	c9                   	leave  
  800508:	c3                   	ret    

00800509 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800509:	55                   	push   %ebp
  80050a:	89 e5                	mov    %esp,%ebp
  80050c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80050f:	83 ec 0c             	sub    $0xc,%esp
  800512:	6a 00                	push   $0x0
  800514:	e8 20 13 00 00       	call   801839 <sys_destroy_env>
  800519:	83 c4 10             	add    $0x10,%esp
}
  80051c:	90                   	nop
  80051d:	c9                   	leave  
  80051e:	c3                   	ret    

0080051f <exit>:

void
exit(void)
{
  80051f:	55                   	push   %ebp
  800520:	89 e5                	mov    %esp,%ebp
  800522:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800525:	e8 75 13 00 00       	call   80189f <sys_exit_env>
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800533:	8d 45 10             	lea    0x10(%ebp),%eax
  800536:	83 c0 04             	add    $0x4,%eax
  800539:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80053c:	a1 2c 30 80 00       	mov    0x80302c,%eax
  800541:	85 c0                	test   %eax,%eax
  800543:	74 16                	je     80055b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800545:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	50                   	push   %eax
  80054e:	68 90 21 80 00       	push   $0x802190
  800553:	e8 92 02 00 00       	call   8007ea <cprintf>
  800558:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80055b:	a1 00 30 80 00       	mov    0x803000,%eax
  800560:	ff 75 0c             	pushl  0xc(%ebp)
  800563:	ff 75 08             	pushl  0x8(%ebp)
  800566:	50                   	push   %eax
  800567:	68 95 21 80 00       	push   $0x802195
  80056c:	e8 79 02 00 00       	call   8007ea <cprintf>
  800571:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800574:	8b 45 10             	mov    0x10(%ebp),%eax
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 f4             	pushl  -0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	e8 fc 01 00 00       	call   80077f <vcprintf>
  800583:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800586:	83 ec 08             	sub    $0x8,%esp
  800589:	6a 00                	push   $0x0
  80058b:	68 b1 21 80 00       	push   $0x8021b1
  800590:	e8 ea 01 00 00       	call   80077f <vcprintf>
  800595:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800598:	e8 82 ff ff ff       	call   80051f <exit>

	// should not return here
	while (1) ;
  80059d:	eb fe                	jmp    80059d <_panic+0x70>

0080059f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80059f:	55                   	push   %ebp
  8005a0:	89 e5                	mov    %esp,%ebp
  8005a2:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8005aa:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b3:	39 c2                	cmp    %eax,%edx
  8005b5:	74 14                	je     8005cb <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 b4 21 80 00       	push   $0x8021b4
  8005bf:	6a 26                	push   $0x26
  8005c1:	68 00 22 80 00       	push   $0x802200
  8005c6:	e8 62 ff ff ff       	call   80052d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005d9:	e9 c5 00 00 00       	jmp    8006a3 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	01 d0                	add    %edx,%eax
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	85 c0                	test   %eax,%eax
  8005f1:	75 08                	jne    8005fb <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005f3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005f6:	e9 a5 00 00 00       	jmp    8006a0 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800602:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800609:	eb 69                	jmp    800674 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80060b:	a1 04 30 80 00       	mov    0x803004,%eax
  800610:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800616:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800619:	89 d0                	mov    %edx,%eax
  80061b:	01 c0                	add    %eax,%eax
  80061d:	01 d0                	add    %edx,%eax
  80061f:	c1 e0 03             	shl    $0x3,%eax
  800622:	01 c8                	add    %ecx,%eax
  800624:	8a 40 04             	mov    0x4(%eax),%al
  800627:	84 c0                	test   %al,%al
  800629:	75 46                	jne    800671 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80062b:	a1 04 30 80 00       	mov    0x803004,%eax
  800630:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800636:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800639:	89 d0                	mov    %edx,%eax
  80063b:	01 c0                	add    %eax,%eax
  80063d:	01 d0                	add    %edx,%eax
  80063f:	c1 e0 03             	shl    $0x3,%eax
  800642:	01 c8                	add    %ecx,%eax
  800644:	8b 00                	mov    (%eax),%eax
  800646:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800649:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80064c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800651:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800656:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	01 c8                	add    %ecx,%eax
  800662:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800664:	39 c2                	cmp    %eax,%edx
  800666:	75 09                	jne    800671 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800668:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80066f:	eb 15                	jmp    800686 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800671:	ff 45 e8             	incl   -0x18(%ebp)
  800674:	a1 04 30 80 00       	mov    0x803004,%eax
  800679:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80067f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800682:	39 c2                	cmp    %eax,%edx
  800684:	77 85                	ja     80060b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800686:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80068a:	75 14                	jne    8006a0 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80068c:	83 ec 04             	sub    $0x4,%esp
  80068f:	68 0c 22 80 00       	push   $0x80220c
  800694:	6a 3a                	push   $0x3a
  800696:	68 00 22 80 00       	push   $0x802200
  80069b:	e8 8d fe ff ff       	call   80052d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006a0:	ff 45 f0             	incl   -0x10(%ebp)
  8006a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a9:	0f 8c 2f ff ff ff    	jl     8005de <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006bd:	eb 26                	jmp    8006e5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006bf:	a1 04 30 80 00       	mov    0x803004,%eax
  8006c4:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8006ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006cd:	89 d0                	mov    %edx,%eax
  8006cf:	01 c0                	add    %eax,%eax
  8006d1:	01 d0                	add    %edx,%eax
  8006d3:	c1 e0 03             	shl    $0x3,%eax
  8006d6:	01 c8                	add    %ecx,%eax
  8006d8:	8a 40 04             	mov    0x4(%eax),%al
  8006db:	3c 01                	cmp    $0x1,%al
  8006dd:	75 03                	jne    8006e2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006df:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006e2:	ff 45 e0             	incl   -0x20(%ebp)
  8006e5:	a1 04 30 80 00       	mov    0x803004,%eax
  8006ea:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006f3:	39 c2                	cmp    %eax,%edx
  8006f5:	77 c8                	ja     8006bf <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006fa:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006fd:	74 14                	je     800713 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006ff:	83 ec 04             	sub    $0x4,%esp
  800702:	68 60 22 80 00       	push   $0x802260
  800707:	6a 44                	push   $0x44
  800709:	68 00 22 80 00       	push   $0x802200
  80070e:	e8 1a fe ff ff       	call   80052d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800713:	90                   	nop
  800714:	c9                   	leave  
  800715:	c3                   	ret    

00800716 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800716:	55                   	push   %ebp
  800717:	89 e5                	mov    %esp,%ebp
  800719:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80071c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	8d 48 01             	lea    0x1(%eax),%ecx
  800724:	8b 55 0c             	mov    0xc(%ebp),%edx
  800727:	89 0a                	mov    %ecx,(%edx)
  800729:	8b 55 08             	mov    0x8(%ebp),%edx
  80072c:	88 d1                	mov    %dl,%cl
  80072e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800731:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800735:	8b 45 0c             	mov    0xc(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80073f:	75 2c                	jne    80076d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800741:	a0 08 30 80 00       	mov    0x803008,%al
  800746:	0f b6 c0             	movzbl %al,%eax
  800749:	8b 55 0c             	mov    0xc(%ebp),%edx
  80074c:	8b 12                	mov    (%edx),%edx
  80074e:	89 d1                	mov    %edx,%ecx
  800750:	8b 55 0c             	mov    0xc(%ebp),%edx
  800753:	83 c2 08             	add    $0x8,%edx
  800756:	83 ec 04             	sub    $0x4,%esp
  800759:	50                   	push   %eax
  80075a:	51                   	push   %ecx
  80075b:	52                   	push   %edx
  80075c:	e8 4e 0e 00 00       	call   8015af <sys_cputs>
  800761:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800764:	8b 45 0c             	mov    0xc(%ebp),%eax
  800767:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80076d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800770:	8b 40 04             	mov    0x4(%eax),%eax
  800773:	8d 50 01             	lea    0x1(%eax),%edx
  800776:	8b 45 0c             	mov    0xc(%ebp),%eax
  800779:	89 50 04             	mov    %edx,0x4(%eax)
}
  80077c:	90                   	nop
  80077d:	c9                   	leave  
  80077e:	c3                   	ret    

0080077f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80077f:	55                   	push   %ebp
  800780:	89 e5                	mov    %esp,%ebp
  800782:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800788:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80078f:	00 00 00 
	b.cnt = 0;
  800792:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800799:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	ff 75 08             	pushl  0x8(%ebp)
  8007a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007a8:	50                   	push   %eax
  8007a9:	68 16 07 80 00       	push   $0x800716
  8007ae:	e8 11 02 00 00       	call   8009c4 <vprintfmt>
  8007b3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007b6:	a0 08 30 80 00       	mov    0x803008,%al
  8007bb:	0f b6 c0             	movzbl %al,%eax
  8007be:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007c4:	83 ec 04             	sub    $0x4,%esp
  8007c7:	50                   	push   %eax
  8007c8:	52                   	push   %edx
  8007c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007cf:	83 c0 08             	add    $0x8,%eax
  8007d2:	50                   	push   %eax
  8007d3:	e8 d7 0d 00 00       	call   8015af <sys_cputs>
  8007d8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007db:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8007e2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007e8:	c9                   	leave  
  8007e9:	c3                   	ret    

008007ea <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007f0:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8007f7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	ff 75 f4             	pushl  -0xc(%ebp)
  800806:	50                   	push   %eax
  800807:	e8 73 ff ff ff       	call   80077f <vcprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800812:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80081d:	e8 cf 0d 00 00       	call   8015f1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800822:	8d 45 0c             	lea    0xc(%ebp),%eax
  800825:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 f4             	pushl  -0xc(%ebp)
  800831:	50                   	push   %eax
  800832:	e8 48 ff ff ff       	call   80077f <vcprintf>
  800837:	83 c4 10             	add    $0x10,%esp
  80083a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80083d:	e8 c9 0d 00 00       	call   80160b <sys_unlock_cons>
	return cnt;
  800842:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800845:	c9                   	leave  
  800846:	c3                   	ret    

00800847 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	53                   	push   %ebx
  80084b:	83 ec 14             	sub    $0x14,%esp
  80084e:	8b 45 10             	mov    0x10(%ebp),%eax
  800851:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800854:	8b 45 14             	mov    0x14(%ebp),%eax
  800857:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80085a:	8b 45 18             	mov    0x18(%ebp),%eax
  80085d:	ba 00 00 00 00       	mov    $0x0,%edx
  800862:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800865:	77 55                	ja     8008bc <printnum+0x75>
  800867:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80086a:	72 05                	jb     800871 <printnum+0x2a>
  80086c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80086f:	77 4b                	ja     8008bc <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800871:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800874:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800877:	8b 45 18             	mov    0x18(%ebp),%eax
  80087a:	ba 00 00 00 00       	mov    $0x0,%edx
  80087f:	52                   	push   %edx
  800880:	50                   	push   %eax
  800881:	ff 75 f4             	pushl  -0xc(%ebp)
  800884:	ff 75 f0             	pushl  -0x10(%ebp)
  800887:	e8 24 13 00 00       	call   801bb0 <__udivdi3>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	83 ec 04             	sub    $0x4,%esp
  800892:	ff 75 20             	pushl  0x20(%ebp)
  800895:	53                   	push   %ebx
  800896:	ff 75 18             	pushl  0x18(%ebp)
  800899:	52                   	push   %edx
  80089a:	50                   	push   %eax
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	ff 75 08             	pushl  0x8(%ebp)
  8008a1:	e8 a1 ff ff ff       	call   800847 <printnum>
  8008a6:	83 c4 20             	add    $0x20,%esp
  8008a9:	eb 1a                	jmp    8008c5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	ff 75 0c             	pushl  0xc(%ebp)
  8008b1:	ff 75 20             	pushl  0x20(%ebp)
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008bc:	ff 4d 1c             	decl   0x1c(%ebp)
  8008bf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008c3:	7f e6                	jg     8008ab <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008c5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008c8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d3:	53                   	push   %ebx
  8008d4:	51                   	push   %ecx
  8008d5:	52                   	push   %edx
  8008d6:	50                   	push   %eax
  8008d7:	e8 e4 13 00 00       	call   801cc0 <__umoddi3>
  8008dc:	83 c4 10             	add    $0x10,%esp
  8008df:	05 d4 24 80 00       	add    $0x8024d4,%eax
  8008e4:	8a 00                	mov    (%eax),%al
  8008e6:	0f be c0             	movsbl %al,%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	50                   	push   %eax
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	ff d0                	call   *%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
}
  8008f8:	90                   	nop
  8008f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800901:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800905:	7e 1c                	jle    800923 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	8d 50 08             	lea    0x8(%eax),%edx
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	89 10                	mov    %edx,(%eax)
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	8b 00                	mov    (%eax),%eax
  800919:	83 e8 08             	sub    $0x8,%eax
  80091c:	8b 50 04             	mov    0x4(%eax),%edx
  80091f:	8b 00                	mov    (%eax),%eax
  800921:	eb 40                	jmp    800963 <getuint+0x65>
	else if (lflag)
  800923:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800927:	74 1e                	je     800947 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	8b 00                	mov    (%eax),%eax
  80092e:	8d 50 04             	lea    0x4(%eax),%edx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	89 10                	mov    %edx,(%eax)
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	ba 00 00 00 00       	mov    $0x0,%edx
  800945:	eb 1c                	jmp    800963 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	8d 50 04             	lea    0x4(%eax),%edx
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	89 10                	mov    %edx,(%eax)
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	83 e8 04             	sub    $0x4,%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800963:	5d                   	pop    %ebp
  800964:	c3                   	ret    

00800965 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800968:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80096c:	7e 1c                	jle    80098a <getint+0x25>
		return va_arg(*ap, long long);
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	8d 50 08             	lea    0x8(%eax),%edx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	89 10                	mov    %edx,(%eax)
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	8b 00                	mov    (%eax),%eax
  800980:	83 e8 08             	sub    $0x8,%eax
  800983:	8b 50 04             	mov    0x4(%eax),%edx
  800986:	8b 00                	mov    (%eax),%eax
  800988:	eb 38                	jmp    8009c2 <getint+0x5d>
	else if (lflag)
  80098a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098e:	74 1a                	je     8009aa <getint+0x45>
		return va_arg(*ap, long);
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	8d 50 04             	lea    0x4(%eax),%edx
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	89 10                	mov    %edx,(%eax)
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	8b 00                	mov    (%eax),%eax
  8009a2:	83 e8 04             	sub    $0x4,%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	99                   	cltd   
  8009a8:	eb 18                	jmp    8009c2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	8b 00                	mov    (%eax),%eax
  8009af:	8d 50 04             	lea    0x4(%eax),%edx
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	89 10                	mov    %edx,(%eax)
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	8b 00                	mov    (%eax),%eax
  8009bc:	83 e8 04             	sub    $0x4,%eax
  8009bf:	8b 00                	mov    (%eax),%eax
  8009c1:	99                   	cltd   
}
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	56                   	push   %esi
  8009c8:	53                   	push   %ebx
  8009c9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009cc:	eb 17                	jmp    8009e5 <vprintfmt+0x21>
			if (ch == '\0')
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	0f 84 c1 03 00 00    	je     800d97 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	53                   	push   %ebx
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	ff d0                	call   *%eax
  8009e2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e8:	8d 50 01             	lea    0x1(%eax),%edx
  8009eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ee:	8a 00                	mov    (%eax),%al
  8009f0:	0f b6 d8             	movzbl %al,%ebx
  8009f3:	83 fb 25             	cmp    $0x25,%ebx
  8009f6:	75 d6                	jne    8009ce <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009f8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009fc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a03:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a0a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a11:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a18:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1b:	8d 50 01             	lea    0x1(%eax),%edx
  800a1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f b6 d8             	movzbl %al,%ebx
  800a26:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a29:	83 f8 5b             	cmp    $0x5b,%eax
  800a2c:	0f 87 3d 03 00 00    	ja     800d6f <vprintfmt+0x3ab>
  800a32:	8b 04 85 f8 24 80 00 	mov    0x8024f8(,%eax,4),%eax
  800a39:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a3b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a3f:	eb d7                	jmp    800a18 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a41:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a45:	eb d1                	jmp    800a18 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a47:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a51:	89 d0                	mov    %edx,%eax
  800a53:	c1 e0 02             	shl    $0x2,%eax
  800a56:	01 d0                	add    %edx,%eax
  800a58:	01 c0                	add    %eax,%eax
  800a5a:	01 d8                	add    %ebx,%eax
  800a5c:	83 e8 30             	sub    $0x30,%eax
  800a5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a62:	8b 45 10             	mov    0x10(%ebp),%eax
  800a65:	8a 00                	mov    (%eax),%al
  800a67:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a6a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a6d:	7e 3e                	jle    800aad <vprintfmt+0xe9>
  800a6f:	83 fb 39             	cmp    $0x39,%ebx
  800a72:	7f 39                	jg     800aad <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a74:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a77:	eb d5                	jmp    800a4e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a79:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7c:	83 c0 04             	add    $0x4,%eax
  800a7f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 e8 04             	sub    $0x4,%eax
  800a88:	8b 00                	mov    (%eax),%eax
  800a8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a8d:	eb 1f                	jmp    800aae <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a8f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a93:	79 83                	jns    800a18 <vprintfmt+0x54>
				width = 0;
  800a95:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a9c:	e9 77 ff ff ff       	jmp    800a18 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800aa1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800aa8:	e9 6b ff ff ff       	jmp    800a18 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800aad:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800aae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ab2:	0f 89 60 ff ff ff    	jns    800a18 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ab8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800abb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800abe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ac5:	e9 4e ff ff ff       	jmp    800a18 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aca:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800acd:	e9 46 ff ff ff       	jmp    800a18 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ad2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad5:	83 c0 04             	add    $0x4,%eax
  800ad8:	89 45 14             	mov    %eax,0x14(%ebp)
  800adb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ade:	83 e8 04             	sub    $0x4,%eax
  800ae1:	8b 00                	mov    (%eax),%eax
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	50                   	push   %eax
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	ff d0                	call   *%eax
  800aef:	83 c4 10             	add    $0x10,%esp
			break;
  800af2:	e9 9b 02 00 00       	jmp    800d92 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800af7:	8b 45 14             	mov    0x14(%ebp),%eax
  800afa:	83 c0 04             	add    $0x4,%eax
  800afd:	89 45 14             	mov    %eax,0x14(%ebp)
  800b00:	8b 45 14             	mov    0x14(%ebp),%eax
  800b03:	83 e8 04             	sub    $0x4,%eax
  800b06:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b08:	85 db                	test   %ebx,%ebx
  800b0a:	79 02                	jns    800b0e <vprintfmt+0x14a>
				err = -err;
  800b0c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b0e:	83 fb 64             	cmp    $0x64,%ebx
  800b11:	7f 0b                	jg     800b1e <vprintfmt+0x15a>
  800b13:	8b 34 9d 40 23 80 00 	mov    0x802340(,%ebx,4),%esi
  800b1a:	85 f6                	test   %esi,%esi
  800b1c:	75 19                	jne    800b37 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b1e:	53                   	push   %ebx
  800b1f:	68 e5 24 80 00       	push   $0x8024e5
  800b24:	ff 75 0c             	pushl  0xc(%ebp)
  800b27:	ff 75 08             	pushl  0x8(%ebp)
  800b2a:	e8 70 02 00 00       	call   800d9f <printfmt>
  800b2f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b32:	e9 5b 02 00 00       	jmp    800d92 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b37:	56                   	push   %esi
  800b38:	68 ee 24 80 00       	push   $0x8024ee
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	ff 75 08             	pushl  0x8(%ebp)
  800b43:	e8 57 02 00 00       	call   800d9f <printfmt>
  800b48:	83 c4 10             	add    $0x10,%esp
			break;
  800b4b:	e9 42 02 00 00       	jmp    800d92 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b50:	8b 45 14             	mov    0x14(%ebp),%eax
  800b53:	83 c0 04             	add    $0x4,%eax
  800b56:	89 45 14             	mov    %eax,0x14(%ebp)
  800b59:	8b 45 14             	mov    0x14(%ebp),%eax
  800b5c:	83 e8 04             	sub    $0x4,%eax
  800b5f:	8b 30                	mov    (%eax),%esi
  800b61:	85 f6                	test   %esi,%esi
  800b63:	75 05                	jne    800b6a <vprintfmt+0x1a6>
				p = "(null)";
  800b65:	be f1 24 80 00       	mov    $0x8024f1,%esi
			if (width > 0 && padc != '-')
  800b6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6e:	7e 6d                	jle    800bdd <vprintfmt+0x219>
  800b70:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b74:	74 67                	je     800bdd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b79:	83 ec 08             	sub    $0x8,%esp
  800b7c:	50                   	push   %eax
  800b7d:	56                   	push   %esi
  800b7e:	e8 1e 03 00 00       	call   800ea1 <strnlen>
  800b83:	83 c4 10             	add    $0x10,%esp
  800b86:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b89:	eb 16                	jmp    800ba1 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b8b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	50                   	push   %eax
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	ff d0                	call   *%eax
  800b9b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b9e:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ba5:	7f e4                	jg     800b8b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ba7:	eb 34                	jmp    800bdd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ba9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bad:	74 1c                	je     800bcb <vprintfmt+0x207>
  800baf:	83 fb 1f             	cmp    $0x1f,%ebx
  800bb2:	7e 05                	jle    800bb9 <vprintfmt+0x1f5>
  800bb4:	83 fb 7e             	cmp    $0x7e,%ebx
  800bb7:	7e 12                	jle    800bcb <vprintfmt+0x207>
					putch('?', putdat);
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	ff 75 0c             	pushl  0xc(%ebp)
  800bbf:	6a 3f                	push   $0x3f
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	ff d0                	call   *%eax
  800bc6:	83 c4 10             	add    $0x10,%esp
  800bc9:	eb 0f                	jmp    800bda <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 0c             	pushl  0xc(%ebp)
  800bd1:	53                   	push   %ebx
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	ff d0                	call   *%eax
  800bd7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bda:	ff 4d e4             	decl   -0x1c(%ebp)
  800bdd:	89 f0                	mov    %esi,%eax
  800bdf:	8d 70 01             	lea    0x1(%eax),%esi
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	0f be d8             	movsbl %al,%ebx
  800be7:	85 db                	test   %ebx,%ebx
  800be9:	74 24                	je     800c0f <vprintfmt+0x24b>
  800beb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bef:	78 b8                	js     800ba9 <vprintfmt+0x1e5>
  800bf1:	ff 4d e0             	decl   -0x20(%ebp)
  800bf4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bf8:	79 af                	jns    800ba9 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bfa:	eb 13                	jmp    800c0f <vprintfmt+0x24b>
				putch(' ', putdat);
  800bfc:	83 ec 08             	sub    $0x8,%esp
  800bff:	ff 75 0c             	pushl  0xc(%ebp)
  800c02:	6a 20                	push   $0x20
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	ff d0                	call   *%eax
  800c09:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0c:	ff 4d e4             	decl   -0x1c(%ebp)
  800c0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c13:	7f e7                	jg     800bfc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c15:	e9 78 01 00 00       	jmp    800d92 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c20:	8d 45 14             	lea    0x14(%ebp),%eax
  800c23:	50                   	push   %eax
  800c24:	e8 3c fd ff ff       	call   800965 <getint>
  800c29:	83 c4 10             	add    $0x10,%esp
  800c2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c38:	85 d2                	test   %edx,%edx
  800c3a:	79 23                	jns    800c5f <vprintfmt+0x29b>
				putch('-', putdat);
  800c3c:	83 ec 08             	sub    $0x8,%esp
  800c3f:	ff 75 0c             	pushl  0xc(%ebp)
  800c42:	6a 2d                	push   $0x2d
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	ff d0                	call   *%eax
  800c49:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c52:	f7 d8                	neg    %eax
  800c54:	83 d2 00             	adc    $0x0,%edx
  800c57:	f7 da                	neg    %edx
  800c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c5f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c66:	e9 bc 00 00 00       	jmp    800d27 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c71:	8d 45 14             	lea    0x14(%ebp),%eax
  800c74:	50                   	push   %eax
  800c75:	e8 84 fc ff ff       	call   8008fe <getuint>
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c83:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c8a:	e9 98 00 00 00       	jmp    800d27 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c8f:	83 ec 08             	sub    $0x8,%esp
  800c92:	ff 75 0c             	pushl  0xc(%ebp)
  800c95:	6a 58                	push   $0x58
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	ff d0                	call   *%eax
  800c9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	6a 58                	push   $0x58
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	ff d0                	call   *%eax
  800cac:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	6a 58                	push   $0x58
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	ff d0                	call   *%eax
  800cbc:	83 c4 10             	add    $0x10,%esp
			break;
  800cbf:	e9 ce 00 00 00       	jmp    800d92 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	6a 30                	push   $0x30
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	ff d0                	call   *%eax
  800cd1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cd4:	83 ec 08             	sub    $0x8,%esp
  800cd7:	ff 75 0c             	pushl  0xc(%ebp)
  800cda:	6a 78                	push   $0x78
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	ff d0                	call   *%eax
  800ce1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ce4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce7:	83 c0 04             	add    $0x4,%eax
  800cea:	89 45 14             	mov    %eax,0x14(%ebp)
  800ced:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf0:	83 e8 04             	sub    $0x4,%eax
  800cf3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d06:	eb 1f                	jmp    800d27 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 e8             	pushl  -0x18(%ebp)
  800d0e:	8d 45 14             	lea    0x14(%ebp),%eax
  800d11:	50                   	push   %eax
  800d12:	e8 e7 fb ff ff       	call   8008fe <getuint>
  800d17:	83 c4 10             	add    $0x10,%esp
  800d1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d1d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d20:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d27:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d2e:	83 ec 04             	sub    $0x4,%esp
  800d31:	52                   	push   %edx
  800d32:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d35:	50                   	push   %eax
  800d36:	ff 75 f4             	pushl  -0xc(%ebp)
  800d39:	ff 75 f0             	pushl  -0x10(%ebp)
  800d3c:	ff 75 0c             	pushl  0xc(%ebp)
  800d3f:	ff 75 08             	pushl  0x8(%ebp)
  800d42:	e8 00 fb ff ff       	call   800847 <printnum>
  800d47:	83 c4 20             	add    $0x20,%esp
			break;
  800d4a:	eb 46                	jmp    800d92 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d4c:	83 ec 08             	sub    $0x8,%esp
  800d4f:	ff 75 0c             	pushl  0xc(%ebp)
  800d52:	53                   	push   %ebx
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	ff d0                	call   *%eax
  800d58:	83 c4 10             	add    $0x10,%esp
			break;
  800d5b:	eb 35                	jmp    800d92 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d5d:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800d64:	eb 2c                	jmp    800d92 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d66:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800d6d:	eb 23                	jmp    800d92 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d6f:	83 ec 08             	sub    $0x8,%esp
  800d72:	ff 75 0c             	pushl  0xc(%ebp)
  800d75:	6a 25                	push   $0x25
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	ff d0                	call   *%eax
  800d7c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d7f:	ff 4d 10             	decl   0x10(%ebp)
  800d82:	eb 03                	jmp    800d87 <vprintfmt+0x3c3>
  800d84:	ff 4d 10             	decl   0x10(%ebp)
  800d87:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8a:	48                   	dec    %eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 25                	cmp    $0x25,%al
  800d8f:	75 f3                	jne    800d84 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d91:	90                   	nop
		}
	}
  800d92:	e9 35 fc ff ff       	jmp    8009cc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d97:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    

00800d9f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800da5:	8d 45 10             	lea    0x10(%ebp),%eax
  800da8:	83 c0 04             	add    $0x4,%eax
  800dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dae:	8b 45 10             	mov    0x10(%ebp),%eax
  800db1:	ff 75 f4             	pushl  -0xc(%ebp)
  800db4:	50                   	push   %eax
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	ff 75 08             	pushl  0x8(%ebp)
  800dbb:	e8 04 fc ff ff       	call   8009c4 <vprintfmt>
  800dc0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dc3:	90                   	nop
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8b 40 08             	mov    0x8(%eax),%eax
  800dcf:	8d 50 01             	lea    0x1(%eax),%edx
  800dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	8b 10                	mov    (%eax),%edx
  800ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de0:	8b 40 04             	mov    0x4(%eax),%eax
  800de3:	39 c2                	cmp    %eax,%edx
  800de5:	73 12                	jae    800df9 <sprintputch+0x33>
		*b->buf++ = ch;
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	8d 48 01             	lea    0x1(%eax),%ecx
  800def:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df2:	89 0a                	mov    %ecx,(%edx)
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	88 10                	mov    %dl,(%eax)
}
  800df9:	90                   	nop
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    

00800dfc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	01 d0                	add    %edx,%eax
  800e13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e21:	74 06                	je     800e29 <vsnprintf+0x2d>
  800e23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e27:	7f 07                	jg     800e30 <vsnprintf+0x34>
		return -E_INVAL;
  800e29:	b8 03 00 00 00       	mov    $0x3,%eax
  800e2e:	eb 20                	jmp    800e50 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e30:	ff 75 14             	pushl  0x14(%ebp)
  800e33:	ff 75 10             	pushl  0x10(%ebp)
  800e36:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e39:	50                   	push   %eax
  800e3a:	68 c6 0d 80 00       	push   $0x800dc6
  800e3f:	e8 80 fb ff ff       	call   8009c4 <vprintfmt>
  800e44:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e4a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e50:	c9                   	leave  
  800e51:	c3                   	ret    

00800e52 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e58:	8d 45 10             	lea    0x10(%ebp),%eax
  800e5b:	83 c0 04             	add    $0x4,%eax
  800e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e61:	8b 45 10             	mov    0x10(%ebp),%eax
  800e64:	ff 75 f4             	pushl  -0xc(%ebp)
  800e67:	50                   	push   %eax
  800e68:	ff 75 0c             	pushl  0xc(%ebp)
  800e6b:	ff 75 08             	pushl  0x8(%ebp)
  800e6e:	e8 89 ff ff ff       	call   800dfc <vsnprintf>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8b:	eb 06                	jmp    800e93 <strlen+0x15>
		n++;
  800e8d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e90:	ff 45 08             	incl   0x8(%ebp)
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	84 c0                	test   %al,%al
  800e9a:	75 f1                	jne    800e8d <strlen+0xf>
		n++;
	return n;
  800e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9f:	c9                   	leave  
  800ea0:	c3                   	ret    

00800ea1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eae:	eb 09                	jmp    800eb9 <strnlen+0x18>
		n++;
  800eb0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb3:	ff 45 08             	incl   0x8(%ebp)
  800eb6:	ff 4d 0c             	decl   0xc(%ebp)
  800eb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebd:	74 09                	je     800ec8 <strnlen+0x27>
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	84 c0                	test   %al,%al
  800ec6:	75 e8                	jne    800eb0 <strnlen+0xf>
		n++;
	return n;
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    

00800ecd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ed9:	90                   	nop
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8d 50 01             	lea    0x1(%eax),%edx
  800ee0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eec:	8a 12                	mov    (%edx),%dl
  800eee:	88 10                	mov    %dl,(%eax)
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	84 c0                	test   %al,%al
  800ef4:	75 e4                	jne    800eda <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f0e:	eb 1f                	jmp    800f2f <strncpy+0x34>
		*dst++ = *src;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8d 50 01             	lea    0x1(%eax),%edx
  800f16:	89 55 08             	mov    %edx,0x8(%ebp)
  800f19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1c:	8a 12                	mov    (%edx),%dl
  800f1e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	84 c0                	test   %al,%al
  800f27:	74 03                	je     800f2c <strncpy+0x31>
			src++;
  800f29:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f2c:	ff 45 fc             	incl   -0x4(%ebp)
  800f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f32:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f35:	72 d9                	jb     800f10 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f3a:	c9                   	leave  
  800f3b:	c3                   	ret    

00800f3c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4c:	74 30                	je     800f7e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f4e:	eb 16                	jmp    800f66 <strlcpy+0x2a>
			*dst++ = *src++;
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8d 50 01             	lea    0x1(%eax),%edx
  800f56:	89 55 08             	mov    %edx,0x8(%ebp)
  800f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f62:	8a 12                	mov    (%edx),%dl
  800f64:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f66:	ff 4d 10             	decl   0x10(%ebp)
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	74 09                	je     800f78 <strlcpy+0x3c>
  800f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	84 c0                	test   %al,%al
  800f76:	75 d8                	jne    800f50 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f84:	29 c2                	sub    %eax,%edx
  800f86:	89 d0                	mov    %edx,%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f8d:	eb 06                	jmp    800f95 <strcmp+0xb>
		p++, q++;
  800f8f:	ff 45 08             	incl   0x8(%ebp)
  800f92:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	84 c0                	test   %al,%al
  800f9c:	74 0e                	je     800fac <strcmp+0x22>
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8a 10                	mov    (%eax),%dl
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	38 c2                	cmp    %al,%dl
  800faa:	74 e3                	je     800f8f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 d0             	movzbl %al,%edx
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	29 c2                	sub    %eax,%edx
  800fbe:	89 d0                	mov    %edx,%eax
}
  800fc0:	5d                   	pop    %ebp
  800fc1:	c3                   	ret    

00800fc2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fc5:	eb 09                	jmp    800fd0 <strncmp+0xe>
		n--, p++, q++;
  800fc7:	ff 4d 10             	decl   0x10(%ebp)
  800fca:	ff 45 08             	incl   0x8(%ebp)
  800fcd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd4:	74 17                	je     800fed <strncmp+0x2b>
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	84 c0                	test   %al,%al
  800fdd:	74 0e                	je     800fed <strncmp+0x2b>
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 10                	mov    (%eax),%dl
  800fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	38 c2                	cmp    %al,%dl
  800feb:	74 da                	je     800fc7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff1:	75 07                	jne    800ffa <strncmp+0x38>
		return 0;
  800ff3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff8:	eb 14                	jmp    80100e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f b6 d0             	movzbl %al,%edx
  801002:	8b 45 0c             	mov    0xc(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	0f b6 c0             	movzbl %al,%eax
  80100a:	29 c2                	sub    %eax,%edx
  80100c:	89 d0                	mov    %edx,%eax
}
  80100e:	5d                   	pop    %ebp
  80100f:	c3                   	ret    

00801010 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101c:	eb 12                	jmp    801030 <strchr+0x20>
		if (*s == c)
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801026:	75 05                	jne    80102d <strchr+0x1d>
			return (char *) s;
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	eb 11                	jmp    80103e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80102d:	ff 45 08             	incl   0x8(%ebp)
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	84 c0                	test   %al,%al
  801037:	75 e5                	jne    80101e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801039:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103e:	c9                   	leave  
  80103f:	c3                   	ret    

00801040 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 04             	sub    $0x4,%esp
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80104c:	eb 0d                	jmp    80105b <strfind+0x1b>
		if (*s == c)
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801056:	74 0e                	je     801066 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	8a 00                	mov    (%eax),%al
  801060:	84 c0                	test   %al,%al
  801062:	75 ea                	jne    80104e <strfind+0xe>
  801064:	eb 01                	jmp    801067 <strfind+0x27>
		if (*s == c)
			break;
  801066:	90                   	nop
	return (char *) s;
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80107e:	eb 0e                	jmp    80108e <memset+0x22>
		*p++ = c;
  801080:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801083:	8d 50 01             	lea    0x1(%eax),%edx
  801086:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801089:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80108e:	ff 4d f8             	decl   -0x8(%ebp)
  801091:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801095:	79 e9                	jns    801080 <memset+0x14>
		*p++ = c;

	return v;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109a:	c9                   	leave  
  80109b:	c3                   	ret    

0080109c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010ae:	eb 16                	jmp    8010c6 <memcpy+0x2a>
		*d++ = *s++;
  8010b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010c2:	8a 12                	mov    (%edx),%dl
  8010c4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	75 dd                	jne    8010b0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d6:	c9                   	leave  
  8010d7:	c3                   	ret    

008010d8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f0:	73 50                	jae    801142 <memmove+0x6a>
  8010f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f8:	01 d0                	add    %edx,%eax
  8010fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010fd:	76 43                	jbe    801142 <memmove+0x6a>
		s += n;
  8010ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801102:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80110b:	eb 10                	jmp    80111d <memmove+0x45>
			*--d = *--s;
  80110d:	ff 4d f8             	decl   -0x8(%ebp)
  801110:	ff 4d fc             	decl   -0x4(%ebp)
  801113:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801116:	8a 10                	mov    (%eax),%dl
  801118:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80111d:	8b 45 10             	mov    0x10(%ebp),%eax
  801120:	8d 50 ff             	lea    -0x1(%eax),%edx
  801123:	89 55 10             	mov    %edx,0x10(%ebp)
  801126:	85 c0                	test   %eax,%eax
  801128:	75 e3                	jne    80110d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80112a:	eb 23                	jmp    80114f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80112c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112f:	8d 50 01             	lea    0x1(%eax),%edx
  801132:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801135:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801138:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80113e:	8a 12                	mov    (%edx),%dl
  801140:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801142:	8b 45 10             	mov    0x10(%ebp),%eax
  801145:	8d 50 ff             	lea    -0x1(%eax),%edx
  801148:	89 55 10             	mov    %edx,0x10(%ebp)
  80114b:	85 c0                	test   %eax,%eax
  80114d:	75 dd                	jne    80112c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801152:	c9                   	leave  
  801153:	c3                   	ret    

00801154 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
  801157:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801166:	eb 2a                	jmp    801192 <memcmp+0x3e>
		if (*s1 != *s2)
  801168:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116b:	8a 10                	mov    (%eax),%dl
  80116d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	38 c2                	cmp    %al,%dl
  801174:	74 16                	je     80118c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801176:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	0f b6 d0             	movzbl %al,%edx
  80117e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801181:	8a 00                	mov    (%eax),%al
  801183:	0f b6 c0             	movzbl %al,%eax
  801186:	29 c2                	sub    %eax,%edx
  801188:	89 d0                	mov    %edx,%eax
  80118a:	eb 18                	jmp    8011a4 <memcmp+0x50>
		s1++, s2++;
  80118c:	ff 45 fc             	incl   -0x4(%ebp)
  80118f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801192:	8b 45 10             	mov    0x10(%ebp),%eax
  801195:	8d 50 ff             	lea    -0x1(%eax),%edx
  801198:	89 55 10             	mov    %edx,0x10(%ebp)
  80119b:	85 c0                	test   %eax,%eax
  80119d:	75 c9                	jne    801168 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80119f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8011af:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b2:	01 d0                	add    %edx,%eax
  8011b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011b7:	eb 15                	jmp    8011ce <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	0f b6 d0             	movzbl %al,%edx
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	0f b6 c0             	movzbl %al,%eax
  8011c7:	39 c2                	cmp    %eax,%edx
  8011c9:	74 0d                	je     8011d8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011cb:	ff 45 08             	incl   0x8(%ebp)
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d4:	72 e3                	jb     8011b9 <memfind+0x13>
  8011d6:	eb 01                	jmp    8011d9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011d8:	90                   	nop
	return (void *) s;
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011dc:	c9                   	leave  
  8011dd:	c3                   	ret    

008011de <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
  8011e1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011eb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f2:	eb 03                	jmp    8011f7 <strtol+0x19>
		s++;
  8011f4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	3c 20                	cmp    $0x20,%al
  8011fe:	74 f4                	je     8011f4 <strtol+0x16>
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	3c 09                	cmp    $0x9,%al
  801207:	74 eb                	je     8011f4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	3c 2b                	cmp    $0x2b,%al
  801210:	75 05                	jne    801217 <strtol+0x39>
		s++;
  801212:	ff 45 08             	incl   0x8(%ebp)
  801215:	eb 13                	jmp    80122a <strtol+0x4c>
	else if (*s == '-')
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	3c 2d                	cmp    $0x2d,%al
  80121e:	75 0a                	jne    80122a <strtol+0x4c>
		s++, neg = 1;
  801220:	ff 45 08             	incl   0x8(%ebp)
  801223:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80122a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80122e:	74 06                	je     801236 <strtol+0x58>
  801230:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801234:	75 20                	jne    801256 <strtol+0x78>
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	3c 30                	cmp    $0x30,%al
  80123d:	75 17                	jne    801256 <strtol+0x78>
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	40                   	inc    %eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	3c 78                	cmp    $0x78,%al
  801247:	75 0d                	jne    801256 <strtol+0x78>
		s += 2, base = 16;
  801249:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80124d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801254:	eb 28                	jmp    80127e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801256:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125a:	75 15                	jne    801271 <strtol+0x93>
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	3c 30                	cmp    $0x30,%al
  801263:	75 0c                	jne    801271 <strtol+0x93>
		s++, base = 8;
  801265:	ff 45 08             	incl   0x8(%ebp)
  801268:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80126f:	eb 0d                	jmp    80127e <strtol+0xa0>
	else if (base == 0)
  801271:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801275:	75 07                	jne    80127e <strtol+0xa0>
		base = 10;
  801277:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 2f                	cmp    $0x2f,%al
  801285:	7e 19                	jle    8012a0 <strtol+0xc2>
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3c 39                	cmp    $0x39,%al
  80128e:	7f 10                	jg     8012a0 <strtol+0xc2>
			dig = *s - '0';
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	8a 00                	mov    (%eax),%al
  801295:	0f be c0             	movsbl %al,%eax
  801298:	83 e8 30             	sub    $0x30,%eax
  80129b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80129e:	eb 42                	jmp    8012e2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	3c 60                	cmp    $0x60,%al
  8012a7:	7e 19                	jle    8012c2 <strtol+0xe4>
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	3c 7a                	cmp    $0x7a,%al
  8012b0:	7f 10                	jg     8012c2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	8a 00                	mov    (%eax),%al
  8012b7:	0f be c0             	movsbl %al,%eax
  8012ba:	83 e8 57             	sub    $0x57,%eax
  8012bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c0:	eb 20                	jmp    8012e2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	3c 40                	cmp    $0x40,%al
  8012c9:	7e 39                	jle    801304 <strtol+0x126>
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	3c 5a                	cmp    $0x5a,%al
  8012d2:	7f 30                	jg     801304 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8a 00                	mov    (%eax),%al
  8012d9:	0f be c0             	movsbl %al,%eax
  8012dc:	83 e8 37             	sub    $0x37,%eax
  8012df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e8:	7d 19                	jge    801303 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ea:	ff 45 08             	incl   0x8(%ebp)
  8012ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012f4:	89 c2                	mov    %eax,%edx
  8012f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f9:	01 d0                	add    %edx,%eax
  8012fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012fe:	e9 7b ff ff ff       	jmp    80127e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801303:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801304:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801308:	74 08                	je     801312 <strtol+0x134>
		*endptr = (char *) s;
  80130a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130d:	8b 55 08             	mov    0x8(%ebp),%edx
  801310:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801312:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801316:	74 07                	je     80131f <strtol+0x141>
  801318:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131b:	f7 d8                	neg    %eax
  80131d:	eb 03                	jmp    801322 <strtol+0x144>
  80131f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <ltostr>:

void
ltostr(long value, char *str)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80132a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801331:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801338:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133c:	79 13                	jns    801351 <ltostr+0x2d>
	{
		neg = 1;
  80133e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80134b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80134e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801359:	99                   	cltd   
  80135a:	f7 f9                	idiv   %ecx
  80135c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80135f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801362:	8d 50 01             	lea    0x1(%eax),%edx
  801365:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801368:	89 c2                	mov    %eax,%edx
  80136a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136d:	01 d0                	add    %edx,%eax
  80136f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801372:	83 c2 30             	add    $0x30,%edx
  801375:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801377:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80137f:	f7 e9                	imul   %ecx
  801381:	c1 fa 02             	sar    $0x2,%edx
  801384:	89 c8                	mov    %ecx,%eax
  801386:	c1 f8 1f             	sar    $0x1f,%eax
  801389:	29 c2                	sub    %eax,%edx
  80138b:	89 d0                	mov    %edx,%eax
  80138d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801390:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801394:	75 bb                	jne    801351 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801396:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80139d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a0:	48                   	dec    %eax
  8013a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013a8:	74 3d                	je     8013e7 <ltostr+0xc3>
		start = 1 ;
  8013aa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013b1:	eb 34                	jmp    8013e7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	01 d0                	add    %edx,%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	01 c2                	add    %eax,%edx
  8013c8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ce:	01 c8                	add    %ecx,%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	01 c2                	add    %eax,%edx
  8013dc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013df:	88 02                	mov    %al,(%edx)
		start++ ;
  8013e1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013e4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ed:	7c c4                	jl     8013b3 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	01 d0                	add    %edx,%eax
  8013f7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013fa:	90                   	nop
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801403:	ff 75 08             	pushl  0x8(%ebp)
  801406:	e8 73 fa ff ff       	call   800e7e <strlen>
  80140b:	83 c4 04             	add    $0x4,%esp
  80140e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801411:	ff 75 0c             	pushl  0xc(%ebp)
  801414:	e8 65 fa ff ff       	call   800e7e <strlen>
  801419:	83 c4 04             	add    $0x4,%esp
  80141c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80141f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801426:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80142d:	eb 17                	jmp    801446 <strcconcat+0x49>
		final[s] = str1[s] ;
  80142f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801443:	ff 45 fc             	incl   -0x4(%ebp)
  801446:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801449:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80144c:	7c e1                	jl     80142f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80144e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801455:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80145c:	eb 1f                	jmp    80147d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80145e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801461:	8d 50 01             	lea    0x1(%eax),%edx
  801464:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801467:	89 c2                	mov    %eax,%edx
  801469:	8b 45 10             	mov    0x10(%ebp),%eax
  80146c:	01 c2                	add    %eax,%edx
  80146e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801471:	8b 45 0c             	mov    0xc(%ebp),%eax
  801474:	01 c8                	add    %ecx,%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80147a:	ff 45 f8             	incl   -0x8(%ebp)
  80147d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801480:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801483:	7c d9                	jl     80145e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801485:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801488:	8b 45 10             	mov    0x10(%ebp),%eax
  80148b:	01 d0                	add    %edx,%eax
  80148d:	c6 00 00             	movb   $0x0,(%eax)
}
  801490:	90                   	nop
  801491:	c9                   	leave  
  801492:	c3                   	ret    

00801493 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801496:	8b 45 14             	mov    0x14(%ebp),%eax
  801499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80149f:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a2:	8b 00                	mov    (%eax),%eax
  8014a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ae:	01 d0                	add    %edx,%eax
  8014b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b6:	eb 0c                	jmp    8014c4 <strsplit+0x31>
			*string++ = 0;
  8014b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bb:	8d 50 01             	lea    0x1(%eax),%edx
  8014be:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c7:	8a 00                	mov    (%eax),%al
  8014c9:	84 c0                	test   %al,%al
  8014cb:	74 18                	je     8014e5 <strsplit+0x52>
  8014cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d0:	8a 00                	mov    (%eax),%al
  8014d2:	0f be c0             	movsbl %al,%eax
  8014d5:	50                   	push   %eax
  8014d6:	ff 75 0c             	pushl  0xc(%ebp)
  8014d9:	e8 32 fb ff ff       	call   801010 <strchr>
  8014de:	83 c4 08             	add    $0x8,%esp
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	75 d3                	jne    8014b8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	84 c0                	test   %al,%al
  8014ec:	74 5a                	je     801548 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f1:	8b 00                	mov    (%eax),%eax
  8014f3:	83 f8 0f             	cmp    $0xf,%eax
  8014f6:	75 07                	jne    8014ff <strsplit+0x6c>
		{
			return 0;
  8014f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fd:	eb 66                	jmp    801565 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801502:	8b 00                	mov    (%eax),%eax
  801504:	8d 48 01             	lea    0x1(%eax),%ecx
  801507:	8b 55 14             	mov    0x14(%ebp),%edx
  80150a:	89 0a                	mov    %ecx,(%edx)
  80150c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801513:	8b 45 10             	mov    0x10(%ebp),%eax
  801516:	01 c2                	add    %eax,%edx
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80151d:	eb 03                	jmp    801522 <strsplit+0x8f>
			string++;
  80151f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	8a 00                	mov    (%eax),%al
  801527:	84 c0                	test   %al,%al
  801529:	74 8b                	je     8014b6 <strsplit+0x23>
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	0f be c0             	movsbl %al,%eax
  801533:	50                   	push   %eax
  801534:	ff 75 0c             	pushl  0xc(%ebp)
  801537:	e8 d4 fa ff ff       	call   801010 <strchr>
  80153c:	83 c4 08             	add    $0x8,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	74 dc                	je     80151f <strsplit+0x8c>
			string++;
	}
  801543:	e9 6e ff ff ff       	jmp    8014b6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801548:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801549:	8b 45 14             	mov    0x14(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801555:	8b 45 10             	mov    0x10(%ebp),%eax
  801558:	01 d0                	add    %edx,%eax
  80155a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801560:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	68 68 26 80 00       	push   $0x802668
  801575:	68 3f 01 00 00       	push   $0x13f
  80157a:	68 8a 26 80 00       	push   $0x80268a
  80157f:	e8 a9 ef ff ff       	call   80052d <_panic>

00801584 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	57                   	push   %edi
  801588:	56                   	push   %esi
  801589:	53                   	push   %ebx
  80158a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	8b 55 0c             	mov    0xc(%ebp),%edx
  801593:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801596:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801599:	8b 7d 18             	mov    0x18(%ebp),%edi
  80159c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80159f:	cd 30                	int    $0x30
  8015a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	5b                   	pop    %ebx
  8015ab:	5e                   	pop    %esi
  8015ac:	5f                   	pop    %edi
  8015ad:	5d                   	pop    %ebp
  8015ae:	c3                   	ret    

008015af <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015bb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	52                   	push   %edx
  8015c7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ca:	50                   	push   %eax
  8015cb:	6a 00                	push   $0x0
  8015cd:	e8 b2 ff ff ff       	call   801584 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	90                   	nop
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 02                	push   $0x2
  8015e7:	e8 98 ff ff ff       	call   801584 <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 03                	push   $0x3
  801600:	e8 7f ff ff ff       	call   801584 <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
}
  801608:	90                   	nop
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 04                	push   $0x4
  80161a:	e8 65 ff ff ff       	call   801584 <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
}
  801622:	90                   	nop
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	52                   	push   %edx
  801635:	50                   	push   %eax
  801636:	6a 08                	push   $0x8
  801638:	e8 47 ff ff ff       	call   801584 <syscall>
  80163d:	83 c4 18             	add    $0x18,%esp
}
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	56                   	push   %esi
  801646:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801647:	8b 75 18             	mov    0x18(%ebp),%esi
  80164a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80164d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801650:	8b 55 0c             	mov    0xc(%ebp),%edx
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
  801658:	51                   	push   %ecx
  801659:	52                   	push   %edx
  80165a:	50                   	push   %eax
  80165b:	6a 09                	push   $0x9
  80165d:	e8 22 ff ff ff       	call   801584 <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801668:	5b                   	pop    %ebx
  801669:	5e                   	pop    %esi
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    

0080166c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80166f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	52                   	push   %edx
  80167c:	50                   	push   %eax
  80167d:	6a 0a                	push   $0xa
  80167f:	e8 00 ff ff ff       	call   801584 <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
}
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	ff 75 0c             	pushl  0xc(%ebp)
  801695:	ff 75 08             	pushl  0x8(%ebp)
  801698:	6a 0b                	push   $0xb
  80169a:	e8 e5 fe ff ff       	call   801584 <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 0c                	push   $0xc
  8016b3:	e8 cc fe ff ff       	call   801584 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 0d                	push   $0xd
  8016cc:	e8 b3 fe ff ff       	call   801584 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 0e                	push   $0xe
  8016e5:	e8 9a fe ff ff       	call   801584 <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 0f                	push   $0xf
  8016fe:	e8 81 fe ff ff       	call   801584 <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	ff 75 08             	pushl  0x8(%ebp)
  801716:	6a 10                	push   $0x10
  801718:	e8 67 fe ff ff       	call   801584 <syscall>
  80171d:	83 c4 18             	add    $0x18,%esp
}
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 11                	push   $0x11
  801731:	e8 4e fe ff ff       	call   801584 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
}
  801739:	90                   	nop
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_cputc>:

void
sys_cputc(const char c)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801748:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	50                   	push   %eax
  801755:	6a 01                	push   $0x1
  801757:	e8 28 fe ff ff       	call   801584 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	90                   	nop
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 14                	push   $0x14
  801771:	e8 0e fe ff ff       	call   801584 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	90                   	nop
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	8b 45 10             	mov    0x10(%ebp),%eax
  801785:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801788:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80178b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	6a 00                	push   $0x0
  801794:	51                   	push   %ecx
  801795:	52                   	push   %edx
  801796:	ff 75 0c             	pushl  0xc(%ebp)
  801799:	50                   	push   %eax
  80179a:	6a 15                	push   $0x15
  80179c:	e8 e3 fd ff ff       	call   801584 <syscall>
  8017a1:	83 c4 18             	add    $0x18,%esp
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	52                   	push   %edx
  8017b6:	50                   	push   %eax
  8017b7:	6a 16                	push   $0x16
  8017b9:	e8 c6 fd ff ff       	call   801584 <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	51                   	push   %ecx
  8017d4:	52                   	push   %edx
  8017d5:	50                   	push   %eax
  8017d6:	6a 17                	push   $0x17
  8017d8:	e8 a7 fd ff ff       	call   801584 <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	52                   	push   %edx
  8017f2:	50                   	push   %eax
  8017f3:	6a 18                	push   $0x18
  8017f5:	e8 8a fd ff ff       	call   801584 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	6a 00                	push   $0x0
  801807:	ff 75 14             	pushl  0x14(%ebp)
  80180a:	ff 75 10             	pushl  0x10(%ebp)
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	50                   	push   %eax
  801811:	6a 19                	push   $0x19
  801813:	e8 6c fd ff ff       	call   801584 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	50                   	push   %eax
  80182c:	6a 1a                	push   $0x1a
  80182e:	e8 51 fd ff ff       	call   801584 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	90                   	nop
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	50                   	push   %eax
  801848:	6a 1b                	push   $0x1b
  80184a:	e8 35 fd ff ff       	call   801584 <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 05                	push   $0x5
  801863:	e8 1c fd ff ff       	call   801584 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 06                	push   $0x6
  80187c:	e8 03 fd ff ff       	call   801584 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 07                	push   $0x7
  801895:	e8 ea fc ff ff       	call   801584 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_exit_env>:


void sys_exit_env(void)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 1c                	push   $0x1c
  8018ae:	e8 d1 fc ff ff       	call   801584 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	90                   	nop
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018bf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c2:	8d 50 04             	lea    0x4(%eax),%edx
  8018c5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	52                   	push   %edx
  8018cf:	50                   	push   %eax
  8018d0:	6a 1d                	push   $0x1d
  8018d2:	e8 ad fc ff ff       	call   801584 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
	return result;
  8018da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e3:	89 01                	mov    %eax,(%ecx)
  8018e5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	c9                   	leave  
  8018ec:	c2 04 00             	ret    $0x4

008018ef <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	ff 75 10             	pushl  0x10(%ebp)
  8018f9:	ff 75 0c             	pushl  0xc(%ebp)
  8018fc:	ff 75 08             	pushl  0x8(%ebp)
  8018ff:	6a 13                	push   $0x13
  801901:	e8 7e fc ff ff       	call   801584 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
	return ;
  801909:	90                   	nop
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_rcr2>:
uint32 sys_rcr2()
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 1e                	push   $0x1e
  80191b:	e8 64 fc ff ff       	call   801584 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 04             	sub    $0x4,%esp
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801931:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	50                   	push   %eax
  80193e:	6a 1f                	push   $0x1f
  801940:	e8 3f fc ff ff       	call   801584 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
	return ;
  801948:	90                   	nop
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <rsttst>:
void rsttst()
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 21                	push   $0x21
  80195a:	e8 25 fc ff ff       	call   801584 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
	return ;
  801962:	90                   	nop
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	8b 45 14             	mov    0x14(%ebp),%eax
  80196e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801971:	8b 55 18             	mov    0x18(%ebp),%edx
  801974:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801978:	52                   	push   %edx
  801979:	50                   	push   %eax
  80197a:	ff 75 10             	pushl  0x10(%ebp)
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	6a 20                	push   $0x20
  801985:	e8 fa fb ff ff       	call   801584 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
	return ;
  80198d:	90                   	nop
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <chktst>:
void chktst(uint32 n)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	ff 75 08             	pushl  0x8(%ebp)
  80199e:	6a 22                	push   $0x22
  8019a0:	e8 df fb ff ff       	call   801584 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a8:	90                   	nop
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <inctst>:

void inctst()
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 23                	push   $0x23
  8019ba:	e8 c5 fb ff ff       	call   801584 <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c2:	90                   	nop
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <gettst>:
uint32 gettst()
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 24                	push   $0x24
  8019d4:	e8 ab fb ff ff       	call   801584 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 25                	push   $0x25
  8019f0:	e8 8f fb ff ff       	call   801584 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
  8019f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019fb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019ff:	75 07                	jne    801a08 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a01:	b8 01 00 00 00       	mov    $0x1,%eax
  801a06:	eb 05                	jmp    801a0d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 25                	push   $0x25
  801a21:	e8 5e fb ff ff       	call   801584 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
  801a29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a2c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a30:	75 07                	jne    801a39 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a32:	b8 01 00 00 00       	mov    $0x1,%eax
  801a37:	eb 05                	jmp    801a3e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 25                	push   $0x25
  801a52:	e8 2d fb ff ff       	call   801584 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
  801a5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a5d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a61:	75 07                	jne    801a6a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a63:	b8 01 00 00 00       	mov    $0x1,%eax
  801a68:	eb 05                	jmp    801a6f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 25                	push   $0x25
  801a83:	e8 fc fa ff ff       	call   801584 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
  801a8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a8e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a92:	75 07                	jne    801a9b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a94:	b8 01 00 00 00       	mov    $0x1,%eax
  801a99:	eb 05                	jmp    801aa0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	ff 75 08             	pushl  0x8(%ebp)
  801ab0:	6a 26                	push   $0x26
  801ab2:	e8 cd fa ff ff       	call   801584 <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
	return ;
  801aba:	90                   	nop
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ac1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ac4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	6a 00                	push   $0x0
  801acf:	53                   	push   %ebx
  801ad0:	51                   	push   %ecx
  801ad1:	52                   	push   %edx
  801ad2:	50                   	push   %eax
  801ad3:	6a 27                	push   $0x27
  801ad5:	e8 aa fa ff ff       	call   801584 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	52                   	push   %edx
  801af2:	50                   	push   %eax
  801af3:	6a 28                	push   $0x28
  801af5:	e8 8a fa ff ff       	call   801584 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b02:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	51                   	push   %ecx
  801b0e:	ff 75 10             	pushl  0x10(%ebp)
  801b11:	52                   	push   %edx
  801b12:	50                   	push   %eax
  801b13:	6a 29                	push   $0x29
  801b15:	e8 6a fa ff ff       	call   801584 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	ff 75 10             	pushl  0x10(%ebp)
  801b29:	ff 75 0c             	pushl  0xc(%ebp)
  801b2c:	ff 75 08             	pushl  0x8(%ebp)
  801b2f:	6a 12                	push   $0x12
  801b31:	e8 4e fa ff ff       	call   801584 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
	return ;
  801b39:	90                   	nop
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	52                   	push   %edx
  801b4c:	50                   	push   %eax
  801b4d:	6a 2a                	push   $0x2a
  801b4f:	e8 30 fa ff ff       	call   801584 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
	return;
  801b57:	90                   	nop
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	50                   	push   %eax
  801b69:	6a 2b                	push   $0x2b
  801b6b:	e8 14 fa ff ff       	call   801584 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	ff 75 0c             	pushl  0xc(%ebp)
  801b81:	ff 75 08             	pushl  0x8(%ebp)
  801b84:	6a 2c                	push   $0x2c
  801b86:	e8 f9 f9 ff ff       	call   801584 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
	return;
  801b8e:	90                   	nop
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	ff 75 0c             	pushl  0xc(%ebp)
  801b9d:	ff 75 08             	pushl  0x8(%ebp)
  801ba0:	6a 2d                	push   $0x2d
  801ba2:	e8 dd f9 ff ff       	call   801584 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
	return;
  801baa:	90                   	nop
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    
  801bad:	66 90                	xchg   %ax,%ax
  801baf:	90                   	nop

00801bb0 <__udivdi3>:
  801bb0:	55                   	push   %ebp
  801bb1:	57                   	push   %edi
  801bb2:	56                   	push   %esi
  801bb3:	53                   	push   %ebx
  801bb4:	83 ec 1c             	sub    $0x1c,%esp
  801bb7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bbb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bc3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bc7:	89 ca                	mov    %ecx,%edx
  801bc9:	89 f8                	mov    %edi,%eax
  801bcb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bcf:	85 f6                	test   %esi,%esi
  801bd1:	75 2d                	jne    801c00 <__udivdi3+0x50>
  801bd3:	39 cf                	cmp    %ecx,%edi
  801bd5:	77 65                	ja     801c3c <__udivdi3+0x8c>
  801bd7:	89 fd                	mov    %edi,%ebp
  801bd9:	85 ff                	test   %edi,%edi
  801bdb:	75 0b                	jne    801be8 <__udivdi3+0x38>
  801bdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801be2:	31 d2                	xor    %edx,%edx
  801be4:	f7 f7                	div    %edi
  801be6:	89 c5                	mov    %eax,%ebp
  801be8:	31 d2                	xor    %edx,%edx
  801bea:	89 c8                	mov    %ecx,%eax
  801bec:	f7 f5                	div    %ebp
  801bee:	89 c1                	mov    %eax,%ecx
  801bf0:	89 d8                	mov    %ebx,%eax
  801bf2:	f7 f5                	div    %ebp
  801bf4:	89 cf                	mov    %ecx,%edi
  801bf6:	89 fa                	mov    %edi,%edx
  801bf8:	83 c4 1c             	add    $0x1c,%esp
  801bfb:	5b                   	pop    %ebx
  801bfc:	5e                   	pop    %esi
  801bfd:	5f                   	pop    %edi
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    
  801c00:	39 ce                	cmp    %ecx,%esi
  801c02:	77 28                	ja     801c2c <__udivdi3+0x7c>
  801c04:	0f bd fe             	bsr    %esi,%edi
  801c07:	83 f7 1f             	xor    $0x1f,%edi
  801c0a:	75 40                	jne    801c4c <__udivdi3+0x9c>
  801c0c:	39 ce                	cmp    %ecx,%esi
  801c0e:	72 0a                	jb     801c1a <__udivdi3+0x6a>
  801c10:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c14:	0f 87 9e 00 00 00    	ja     801cb8 <__udivdi3+0x108>
  801c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1f:	89 fa                	mov    %edi,%edx
  801c21:	83 c4 1c             	add    $0x1c,%esp
  801c24:	5b                   	pop    %ebx
  801c25:	5e                   	pop    %esi
  801c26:	5f                   	pop    %edi
  801c27:	5d                   	pop    %ebp
  801c28:	c3                   	ret    
  801c29:	8d 76 00             	lea    0x0(%esi),%esi
  801c2c:	31 ff                	xor    %edi,%edi
  801c2e:	31 c0                	xor    %eax,%eax
  801c30:	89 fa                	mov    %edi,%edx
  801c32:	83 c4 1c             	add    $0x1c,%esp
  801c35:	5b                   	pop    %ebx
  801c36:	5e                   	pop    %esi
  801c37:	5f                   	pop    %edi
  801c38:	5d                   	pop    %ebp
  801c39:	c3                   	ret    
  801c3a:	66 90                	xchg   %ax,%ax
  801c3c:	89 d8                	mov    %ebx,%eax
  801c3e:	f7 f7                	div    %edi
  801c40:	31 ff                	xor    %edi,%edi
  801c42:	89 fa                	mov    %edi,%edx
  801c44:	83 c4 1c             	add    $0x1c,%esp
  801c47:	5b                   	pop    %ebx
  801c48:	5e                   	pop    %esi
  801c49:	5f                   	pop    %edi
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    
  801c4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c51:	89 eb                	mov    %ebp,%ebx
  801c53:	29 fb                	sub    %edi,%ebx
  801c55:	89 f9                	mov    %edi,%ecx
  801c57:	d3 e6                	shl    %cl,%esi
  801c59:	89 c5                	mov    %eax,%ebp
  801c5b:	88 d9                	mov    %bl,%cl
  801c5d:	d3 ed                	shr    %cl,%ebp
  801c5f:	89 e9                	mov    %ebp,%ecx
  801c61:	09 f1                	or     %esi,%ecx
  801c63:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c67:	89 f9                	mov    %edi,%ecx
  801c69:	d3 e0                	shl    %cl,%eax
  801c6b:	89 c5                	mov    %eax,%ebp
  801c6d:	89 d6                	mov    %edx,%esi
  801c6f:	88 d9                	mov    %bl,%cl
  801c71:	d3 ee                	shr    %cl,%esi
  801c73:	89 f9                	mov    %edi,%ecx
  801c75:	d3 e2                	shl    %cl,%edx
  801c77:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c7b:	88 d9                	mov    %bl,%cl
  801c7d:	d3 e8                	shr    %cl,%eax
  801c7f:	09 c2                	or     %eax,%edx
  801c81:	89 d0                	mov    %edx,%eax
  801c83:	89 f2                	mov    %esi,%edx
  801c85:	f7 74 24 0c          	divl   0xc(%esp)
  801c89:	89 d6                	mov    %edx,%esi
  801c8b:	89 c3                	mov    %eax,%ebx
  801c8d:	f7 e5                	mul    %ebp
  801c8f:	39 d6                	cmp    %edx,%esi
  801c91:	72 19                	jb     801cac <__udivdi3+0xfc>
  801c93:	74 0b                	je     801ca0 <__udivdi3+0xf0>
  801c95:	89 d8                	mov    %ebx,%eax
  801c97:	31 ff                	xor    %edi,%edi
  801c99:	e9 58 ff ff ff       	jmp    801bf6 <__udivdi3+0x46>
  801c9e:	66 90                	xchg   %ax,%ax
  801ca0:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ca4:	89 f9                	mov    %edi,%ecx
  801ca6:	d3 e2                	shl    %cl,%edx
  801ca8:	39 c2                	cmp    %eax,%edx
  801caa:	73 e9                	jae    801c95 <__udivdi3+0xe5>
  801cac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801caf:	31 ff                	xor    %edi,%edi
  801cb1:	e9 40 ff ff ff       	jmp    801bf6 <__udivdi3+0x46>
  801cb6:	66 90                	xchg   %ax,%ax
  801cb8:	31 c0                	xor    %eax,%eax
  801cba:	e9 37 ff ff ff       	jmp    801bf6 <__udivdi3+0x46>
  801cbf:	90                   	nop

00801cc0 <__umoddi3>:
  801cc0:	55                   	push   %ebp
  801cc1:	57                   	push   %edi
  801cc2:	56                   	push   %esi
  801cc3:	53                   	push   %ebx
  801cc4:	83 ec 1c             	sub    $0x1c,%esp
  801cc7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ccb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ccf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cd3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cdb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cdf:	89 f3                	mov    %esi,%ebx
  801ce1:	89 fa                	mov    %edi,%edx
  801ce3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ce7:	89 34 24             	mov    %esi,(%esp)
  801cea:	85 c0                	test   %eax,%eax
  801cec:	75 1a                	jne    801d08 <__umoddi3+0x48>
  801cee:	39 f7                	cmp    %esi,%edi
  801cf0:	0f 86 a2 00 00 00    	jbe    801d98 <__umoddi3+0xd8>
  801cf6:	89 c8                	mov    %ecx,%eax
  801cf8:	89 f2                	mov    %esi,%edx
  801cfa:	f7 f7                	div    %edi
  801cfc:	89 d0                	mov    %edx,%eax
  801cfe:	31 d2                	xor    %edx,%edx
  801d00:	83 c4 1c             	add    $0x1c,%esp
  801d03:	5b                   	pop    %ebx
  801d04:	5e                   	pop    %esi
  801d05:	5f                   	pop    %edi
  801d06:	5d                   	pop    %ebp
  801d07:	c3                   	ret    
  801d08:	39 f0                	cmp    %esi,%eax
  801d0a:	0f 87 ac 00 00 00    	ja     801dbc <__umoddi3+0xfc>
  801d10:	0f bd e8             	bsr    %eax,%ebp
  801d13:	83 f5 1f             	xor    $0x1f,%ebp
  801d16:	0f 84 ac 00 00 00    	je     801dc8 <__umoddi3+0x108>
  801d1c:	bf 20 00 00 00       	mov    $0x20,%edi
  801d21:	29 ef                	sub    %ebp,%edi
  801d23:	89 fe                	mov    %edi,%esi
  801d25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d29:	89 e9                	mov    %ebp,%ecx
  801d2b:	d3 e0                	shl    %cl,%eax
  801d2d:	89 d7                	mov    %edx,%edi
  801d2f:	89 f1                	mov    %esi,%ecx
  801d31:	d3 ef                	shr    %cl,%edi
  801d33:	09 c7                	or     %eax,%edi
  801d35:	89 e9                	mov    %ebp,%ecx
  801d37:	d3 e2                	shl    %cl,%edx
  801d39:	89 14 24             	mov    %edx,(%esp)
  801d3c:	89 d8                	mov    %ebx,%eax
  801d3e:	d3 e0                	shl    %cl,%eax
  801d40:	89 c2                	mov    %eax,%edx
  801d42:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d46:	d3 e0                	shl    %cl,%eax
  801d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d50:	89 f1                	mov    %esi,%ecx
  801d52:	d3 e8                	shr    %cl,%eax
  801d54:	09 d0                	or     %edx,%eax
  801d56:	d3 eb                	shr    %cl,%ebx
  801d58:	89 da                	mov    %ebx,%edx
  801d5a:	f7 f7                	div    %edi
  801d5c:	89 d3                	mov    %edx,%ebx
  801d5e:	f7 24 24             	mull   (%esp)
  801d61:	89 c6                	mov    %eax,%esi
  801d63:	89 d1                	mov    %edx,%ecx
  801d65:	39 d3                	cmp    %edx,%ebx
  801d67:	0f 82 87 00 00 00    	jb     801df4 <__umoddi3+0x134>
  801d6d:	0f 84 91 00 00 00    	je     801e04 <__umoddi3+0x144>
  801d73:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d77:	29 f2                	sub    %esi,%edx
  801d79:	19 cb                	sbb    %ecx,%ebx
  801d7b:	89 d8                	mov    %ebx,%eax
  801d7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d81:	d3 e0                	shl    %cl,%eax
  801d83:	89 e9                	mov    %ebp,%ecx
  801d85:	d3 ea                	shr    %cl,%edx
  801d87:	09 d0                	or     %edx,%eax
  801d89:	89 e9                	mov    %ebp,%ecx
  801d8b:	d3 eb                	shr    %cl,%ebx
  801d8d:	89 da                	mov    %ebx,%edx
  801d8f:	83 c4 1c             	add    $0x1c,%esp
  801d92:	5b                   	pop    %ebx
  801d93:	5e                   	pop    %esi
  801d94:	5f                   	pop    %edi
  801d95:	5d                   	pop    %ebp
  801d96:	c3                   	ret    
  801d97:	90                   	nop
  801d98:	89 fd                	mov    %edi,%ebp
  801d9a:	85 ff                	test   %edi,%edi
  801d9c:	75 0b                	jne    801da9 <__umoddi3+0xe9>
  801d9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801da3:	31 d2                	xor    %edx,%edx
  801da5:	f7 f7                	div    %edi
  801da7:	89 c5                	mov    %eax,%ebp
  801da9:	89 f0                	mov    %esi,%eax
  801dab:	31 d2                	xor    %edx,%edx
  801dad:	f7 f5                	div    %ebp
  801daf:	89 c8                	mov    %ecx,%eax
  801db1:	f7 f5                	div    %ebp
  801db3:	89 d0                	mov    %edx,%eax
  801db5:	e9 44 ff ff ff       	jmp    801cfe <__umoddi3+0x3e>
  801dba:	66 90                	xchg   %ax,%ax
  801dbc:	89 c8                	mov    %ecx,%eax
  801dbe:	89 f2                	mov    %esi,%edx
  801dc0:	83 c4 1c             	add    $0x1c,%esp
  801dc3:	5b                   	pop    %ebx
  801dc4:	5e                   	pop    %esi
  801dc5:	5f                   	pop    %edi
  801dc6:	5d                   	pop    %ebp
  801dc7:	c3                   	ret    
  801dc8:	3b 04 24             	cmp    (%esp),%eax
  801dcb:	72 06                	jb     801dd3 <__umoddi3+0x113>
  801dcd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dd1:	77 0f                	ja     801de2 <__umoddi3+0x122>
  801dd3:	89 f2                	mov    %esi,%edx
  801dd5:	29 f9                	sub    %edi,%ecx
  801dd7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ddb:	89 14 24             	mov    %edx,(%esp)
  801dde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801de2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801de6:	8b 14 24             	mov    (%esp),%edx
  801de9:	83 c4 1c             	add    $0x1c,%esp
  801dec:	5b                   	pop    %ebx
  801ded:	5e                   	pop    %esi
  801dee:	5f                   	pop    %edi
  801def:	5d                   	pop    %ebp
  801df0:	c3                   	ret    
  801df1:	8d 76 00             	lea    0x0(%esi),%esi
  801df4:	2b 04 24             	sub    (%esp),%eax
  801df7:	19 fa                	sbb    %edi,%edx
  801df9:	89 d1                	mov    %edx,%ecx
  801dfb:	89 c6                	mov    %eax,%esi
  801dfd:	e9 71 ff ff ff       	jmp    801d73 <__umoddi3+0xb3>
  801e02:	66 90                	xchg   %ax,%ax
  801e04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e08:	72 ea                	jb     801df4 <__umoddi3+0x134>
  801e0a:	89 d9                	mov    %ebx,%ecx
  801e0c:	e9 62 ff ff ff       	jmp    801d73 <__umoddi3+0xb3>
