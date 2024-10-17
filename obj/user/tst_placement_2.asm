
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
  8000e1:	e8 ed 19 00 00       	call   801ad3 <sys_check_LRU_lists>
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if(check == 0)
  8000ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8000f0:	75 14                	jne    800106 <_main+0xce>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 40 1e 80 00       	push   $0x801e40
  8000fa:	6a 24                	push   $0x24
  8000fc:	68 c2 1e 80 00       	push   $0x801ec2
  800101:	e8 3d 04 00 00       	call   800543 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800106:	e8 fa 15 00 00       	call   801705 <sys_pf_calculate_allocated_pages>
  80010b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int freePages = sys_calculate_free_frames();
  80010e:	e8 a7 15 00 00       	call   8016ba <sys_calculate_free_frames>
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
  800190:	68 dc 1e 80 00       	push   $0x801edc
  800195:	e8 66 06 00 00       	call   800800 <cprintf>
  80019a:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  80019d:	8a 85 c8 ff ff fe    	mov    -0x1000038(%ebp),%al
  8001a3:	3c ff                	cmp    $0xff,%al
  8001a5:	74 17                	je     8001be <_main+0x186>
  8001a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 0c 1f 80 00       	push   $0x801f0c
  8001b6:	e8 45 06 00 00       	call   800800 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001be:	8a 85 c8 0f 00 ff    	mov    -0xfff038(%ebp),%al
  8001c4:	3c ff                	cmp    $0xff,%al
  8001c6:	74 17                	je     8001df <_main+0x1a7>
  8001c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cf:	83 ec 0c             	sub    $0xc,%esp
  8001d2:	68 0c 1f 80 00       	push   $0x801f0c
  8001d7:	e8 24 06 00 00       	call   800800 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  8001df:	8a 85 c8 ff 3f ff    	mov    -0xc00038(%ebp),%al
  8001e5:	3c ff                	cmp    $0xff,%al
  8001e7:	74 17                	je     800200 <_main+0x1c8>
  8001e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 0c 1f 80 00       	push   $0x801f0c
  8001f8:	e8 03 06 00 00       	call   800800 <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1025] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800200:	8a 85 c8 0f 40 ff    	mov    -0xbff038(%ebp),%al
  800206:	3c ff                	cmp    $0xff,%al
  800208:	74 17                	je     800221 <_main+0x1e9>
  80020a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	68 0c 1f 80 00       	push   $0x801f0c
  800219:	e8 e2 05 00 00       	call   800800 <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp

		if( arr[PAGE_SIZE*1024*2] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800221:	8a 85 c8 ff 7f ff    	mov    -0x800038(%ebp),%al
  800227:	3c ff                	cmp    $0xff,%al
  800229:	74 17                	je     800242 <_main+0x20a>
  80022b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 0c 1f 80 00       	push   $0x801f0c
  80023a:	e8 c1 05 00 00       	call   800800 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  { is_correct = 0; cprintf("PLACEMENT of stack page failed\n"); }
  800242:	8a 85 c8 0f 80 ff    	mov    -0x7ff038(%ebp),%al
  800248:	3c ff                	cmp    $0xff,%al
  80024a:	74 17                	je     800263 <_main+0x22b>
  80024c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	68 0c 1f 80 00       	push   $0x801f0c
  80025b:	e8 a0 05 00 00       	call   800800 <cprintf>
  800260:	83 c4 10             	add    $0x10,%esp


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) { is_correct = 0; cprintf("new stack pages should NOT written to Page File until it's replaced\n"); }
  800263:	e8 9d 14 00 00       	call   801705 <sys_pf_calculate_allocated_pages>
  800268:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80026b:	74 17                	je     800284 <_main+0x24c>
  80026d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	68 2c 1f 80 00       	push   $0x801f2c
  80027c:	e8 7f 05 00 00       	call   800800 <cprintf>
  800281:	83 c4 10             	add    $0x10,%esp

		expected = 6 /*pages*/ + 3 /*tables*/ - 2 /*table + page due to a fault in the 1st call of sys_calculate_free_frames*/;
  800284:	c7 45 d0 07 00 00 00 	movl   $0x7,-0x30(%ebp)
		actual = (freePages - sys_calculate_free_frames()) ;
  80028b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  80028e:	e8 27 14 00 00       	call   8016ba <sys_calculate_free_frames>
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
  8002b2:	68 74 1f 80 00       	push   $0x801f74
  8002b7:	e8 44 05 00 00       	call   800800 <cprintf>
  8002bc:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8002bf:	83 ec 0c             	sub    $0xc,%esp
  8002c2:	68 b4 1f 80 00       	push   $0x801fb4
  8002c7:	e8 34 05 00 00       	call   800800 <cprintf>
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
  800373:	68 e8 1f 80 00       	push   $0x801fe8
  800378:	e8 83 04 00 00       	call   800800 <cprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  800380:	6a 04                	push   $0x4
  800382:	6a 0d                	push   $0xd
  800384:	8d 85 78 ff ff fe    	lea    -0x1000088(%ebp),%eax
  80038a:	50                   	push   %eax
  80038b:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  800391:	50                   	push   %eax
  800392:	e8 3c 17 00 00       	call   801ad3 <sys_check_LRU_lists>
  800397:	83 c4 10             	add    $0x10,%esp
  80039a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if(check == 0)
  80039d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8003a1:	75 17                	jne    8003ba <_main+0x382>
			{ is_correct = 0; cprintf("LRU lists entries are not correct, check your logic again!!\n"); }
  8003a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8003aa:	83 ec 0c             	sub    $0xc,%esp
  8003ad:	68 10 20 80 00       	push   $0x802010
  8003b2:	e8 49 04 00 00       	call   800800 <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	68 50 20 80 00       	push   $0x802050
  8003c2:	e8 39 04 00 00       	call   800800 <cprintf>
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
  8003e1:	68 88 20 80 00       	push   $0x802088
  8003e6:	e8 15 04 00 00       	call   800800 <cprintf>
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
  8003fc:	e8 82 14 00 00       	call   801883 <sys_getenvindex>
  800401:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800407:	89 d0                	mov    %edx,%eax
  800409:	c1 e0 06             	shl    $0x6,%eax
  80040c:	29 d0                	sub    %edx,%eax
  80040e:	c1 e0 02             	shl    $0x2,%eax
  800411:	01 d0                	add    %edx,%eax
  800413:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80041a:	01 c8                	add    %ecx,%eax
  80041c:	c1 e0 03             	shl    $0x3,%eax
  80041f:	01 d0                	add    %edx,%eax
  800421:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800428:	29 c2                	sub    %eax,%edx
  80042a:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800431:	89 c2                	mov    %eax,%edx
  800433:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800439:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80043e:	a1 04 30 80 00       	mov    0x803004,%eax
  800443:	8a 40 20             	mov    0x20(%eax),%al
  800446:	84 c0                	test   %al,%al
  800448:	74 0d                	je     800457 <libmain+0x61>
		binaryname = myEnv->prog_name;
  80044a:	a1 04 30 80 00       	mov    0x803004,%eax
  80044f:	83 c0 20             	add    $0x20,%eax
  800452:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800457:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80045b:	7e 0a                	jle    800467 <libmain+0x71>
		binaryname = argv[0];
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	ff 75 0c             	pushl  0xc(%ebp)
  80046d:	ff 75 08             	pushl  0x8(%ebp)
  800470:	e8 c3 fb ff ff       	call   800038 <_main>
  800475:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800478:	e8 8a 11 00 00       	call   801607 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80047d:	83 ec 0c             	sub    $0xc,%esp
  800480:	68 f4 20 80 00       	push   $0x8020f4
  800485:	e8 76 03 00 00       	call   800800 <cprintf>
  80048a:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80048d:	a1 04 30 80 00       	mov    0x803004,%eax
  800492:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800498:	a1 04 30 80 00       	mov    0x803004,%eax
  80049d:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	52                   	push   %edx
  8004a7:	50                   	push   %eax
  8004a8:	68 1c 21 80 00       	push   $0x80211c
  8004ad:	e8 4e 03 00 00       	call   800800 <cprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004b5:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ba:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8004c0:	a1 04 30 80 00       	mov    0x803004,%eax
  8004c5:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8004cb:	a1 04 30 80 00       	mov    0x803004,%eax
  8004d0:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8004d6:	51                   	push   %ecx
  8004d7:	52                   	push   %edx
  8004d8:	50                   	push   %eax
  8004d9:	68 44 21 80 00       	push   $0x802144
  8004de:	e8 1d 03 00 00       	call   800800 <cprintf>
  8004e3:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004e6:	a1 04 30 80 00       	mov    0x803004,%eax
  8004eb:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	50                   	push   %eax
  8004f5:	68 9c 21 80 00       	push   $0x80219c
  8004fa:	e8 01 03 00 00       	call   800800 <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	68 f4 20 80 00       	push   $0x8020f4
  80050a:	e8 f1 02 00 00       	call   800800 <cprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800512:	e8 0a 11 00 00       	call   801621 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800517:	e8 19 00 00 00       	call   800535 <exit>
}
  80051c:	90                   	nop
  80051d:	c9                   	leave  
  80051e:	c3                   	ret    

0080051f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80051f:	55                   	push   %ebp
  800520:	89 e5                	mov    %esp,%ebp
  800522:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800525:	83 ec 0c             	sub    $0xc,%esp
  800528:	6a 00                	push   $0x0
  80052a:	e8 20 13 00 00       	call   80184f <sys_destroy_env>
  80052f:	83 c4 10             	add    $0x10,%esp
}
  800532:	90                   	nop
  800533:	c9                   	leave  
  800534:	c3                   	ret    

00800535 <exit>:

void
exit(void)
{
  800535:	55                   	push   %ebp
  800536:	89 e5                	mov    %esp,%ebp
  800538:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80053b:	e8 75 13 00 00       	call   8018b5 <sys_exit_env>
}
  800540:	90                   	nop
  800541:	c9                   	leave  
  800542:	c3                   	ret    

00800543 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800543:	55                   	push   %ebp
  800544:	89 e5                	mov    %esp,%ebp
  800546:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800549:	8d 45 10             	lea    0x10(%ebp),%eax
  80054c:	83 c0 04             	add    $0x4,%eax
  80054f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800552:	a1 24 30 80 00       	mov    0x803024,%eax
  800557:	85 c0                	test   %eax,%eax
  800559:	74 16                	je     800571 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80055b:	a1 24 30 80 00       	mov    0x803024,%eax
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	50                   	push   %eax
  800564:	68 b0 21 80 00       	push   $0x8021b0
  800569:	e8 92 02 00 00       	call   800800 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800571:	a1 00 30 80 00       	mov    0x803000,%eax
  800576:	ff 75 0c             	pushl  0xc(%ebp)
  800579:	ff 75 08             	pushl  0x8(%ebp)
  80057c:	50                   	push   %eax
  80057d:	68 b5 21 80 00       	push   $0x8021b5
  800582:	e8 79 02 00 00       	call   800800 <cprintf>
  800587:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80058a:	8b 45 10             	mov    0x10(%ebp),%eax
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 f4             	pushl  -0xc(%ebp)
  800593:	50                   	push   %eax
  800594:	e8 fc 01 00 00       	call   800795 <vcprintf>
  800599:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	6a 00                	push   $0x0
  8005a1:	68 d1 21 80 00       	push   $0x8021d1
  8005a6:	e8 ea 01 00 00       	call   800795 <vcprintf>
  8005ab:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005ae:	e8 82 ff ff ff       	call   800535 <exit>

	// should not return here
	while (1) ;
  8005b3:	eb fe                	jmp    8005b3 <_panic+0x70>

008005b5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005bb:	a1 04 30 80 00       	mov    0x803004,%eax
  8005c0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c9:	39 c2                	cmp    %eax,%edx
  8005cb:	74 14                	je     8005e1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005cd:	83 ec 04             	sub    $0x4,%esp
  8005d0:	68 d4 21 80 00       	push   $0x8021d4
  8005d5:	6a 26                	push   $0x26
  8005d7:	68 20 22 80 00       	push   $0x802220
  8005dc:	e8 62 ff ff ff       	call   800543 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005ef:	e9 c5 00 00 00       	jmp    8006b9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800601:	01 d0                	add    %edx,%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	85 c0                	test   %eax,%eax
  800607:	75 08                	jne    800611 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800609:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80060c:	e9 a5 00 00 00       	jmp    8006b6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800611:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800618:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80061f:	eb 69                	jmp    80068a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800621:	a1 04 30 80 00       	mov    0x803004,%eax
  800626:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80062c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	01 c0                	add    %eax,%eax
  800633:	01 d0                	add    %edx,%eax
  800635:	c1 e0 03             	shl    $0x3,%eax
  800638:	01 c8                	add    %ecx,%eax
  80063a:	8a 40 04             	mov    0x4(%eax),%al
  80063d:	84 c0                	test   %al,%al
  80063f:	75 46                	jne    800687 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800641:	a1 04 30 80 00       	mov    0x803004,%eax
  800646:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80064c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80064f:	89 d0                	mov    %edx,%eax
  800651:	01 c0                	add    %eax,%eax
  800653:	01 d0                	add    %edx,%eax
  800655:	c1 e0 03             	shl    $0x3,%eax
  800658:	01 c8                	add    %ecx,%eax
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80065f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800662:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800667:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800673:	8b 45 08             	mov    0x8(%ebp),%eax
  800676:	01 c8                	add    %ecx,%eax
  800678:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80067a:	39 c2                	cmp    %eax,%edx
  80067c:	75 09                	jne    800687 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80067e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800685:	eb 15                	jmp    80069c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800687:	ff 45 e8             	incl   -0x18(%ebp)
  80068a:	a1 04 30 80 00       	mov    0x803004,%eax
  80068f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800698:	39 c2                	cmp    %eax,%edx
  80069a:	77 85                	ja     800621 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80069c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006a0:	75 14                	jne    8006b6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 2c 22 80 00       	push   $0x80222c
  8006aa:	6a 3a                	push   $0x3a
  8006ac:	68 20 22 80 00       	push   $0x802220
  8006b1:	e8 8d fe ff ff       	call   800543 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006b6:	ff 45 f0             	incl   -0x10(%ebp)
  8006b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006bf:	0f 8c 2f ff ff ff    	jl     8005f4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006d3:	eb 26                	jmp    8006fb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006d5:	a1 04 30 80 00       	mov    0x803004,%eax
  8006da:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8006e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e3:	89 d0                	mov    %edx,%eax
  8006e5:	01 c0                	add    %eax,%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	c1 e0 03             	shl    $0x3,%eax
  8006ec:	01 c8                	add    %ecx,%eax
  8006ee:	8a 40 04             	mov    0x4(%eax),%al
  8006f1:	3c 01                	cmp    $0x1,%al
  8006f3:	75 03                	jne    8006f8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006f5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f8:	ff 45 e0             	incl   -0x20(%ebp)
  8006fb:	a1 04 30 80 00       	mov    0x803004,%eax
  800700:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800706:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800709:	39 c2                	cmp    %eax,%edx
  80070b:	77 c8                	ja     8006d5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80070d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800710:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800713:	74 14                	je     800729 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800715:	83 ec 04             	sub    $0x4,%esp
  800718:	68 80 22 80 00       	push   $0x802280
  80071d:	6a 44                	push   $0x44
  80071f:	68 20 22 80 00       	push   $0x802220
  800724:	e8 1a fe ff ff       	call   800543 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800729:	90                   	nop
  80072a:	c9                   	leave  
  80072b:	c3                   	ret    

0080072c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80072c:	55                   	push   %ebp
  80072d:	89 e5                	mov    %esp,%ebp
  80072f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	8d 48 01             	lea    0x1(%eax),%ecx
  80073a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073d:	89 0a                	mov    %ecx,(%edx)
  80073f:	8b 55 08             	mov    0x8(%ebp),%edx
  800742:	88 d1                	mov    %dl,%cl
  800744:	8b 55 0c             	mov    0xc(%ebp),%edx
  800747:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80074b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	3d ff 00 00 00       	cmp    $0xff,%eax
  800755:	75 2c                	jne    800783 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800757:	a0 08 30 80 00       	mov    0x803008,%al
  80075c:	0f b6 c0             	movzbl %al,%eax
  80075f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800762:	8b 12                	mov    (%edx),%edx
  800764:	89 d1                	mov    %edx,%ecx
  800766:	8b 55 0c             	mov    0xc(%ebp),%edx
  800769:	83 c2 08             	add    $0x8,%edx
  80076c:	83 ec 04             	sub    $0x4,%esp
  80076f:	50                   	push   %eax
  800770:	51                   	push   %ecx
  800771:	52                   	push   %edx
  800772:	e8 4e 0e 00 00       	call   8015c5 <sys_cputs>
  800777:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80077a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800783:	8b 45 0c             	mov    0xc(%ebp),%eax
  800786:	8b 40 04             	mov    0x4(%eax),%eax
  800789:	8d 50 01             	lea    0x1(%eax),%edx
  80078c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800792:	90                   	nop
  800793:	c9                   	leave  
  800794:	c3                   	ret    

00800795 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800795:	55                   	push   %ebp
  800796:	89 e5                	mov    %esp,%ebp
  800798:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80079e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a5:	00 00 00 
	b.cnt = 0;
  8007a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007af:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	ff 75 08             	pushl  0x8(%ebp)
  8007b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007be:	50                   	push   %eax
  8007bf:	68 2c 07 80 00       	push   $0x80072c
  8007c4:	e8 11 02 00 00       	call   8009da <vprintfmt>
  8007c9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007cc:	a0 08 30 80 00       	mov    0x803008,%al
  8007d1:	0f b6 c0             	movzbl %al,%eax
  8007d4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007da:	83 ec 04             	sub    $0x4,%esp
  8007dd:	50                   	push   %eax
  8007de:	52                   	push   %edx
  8007df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e5:	83 c0 08             	add    $0x8,%eax
  8007e8:	50                   	push   %eax
  8007e9:	e8 d7 0d 00 00       	call   8015c5 <sys_cputs>
  8007ee:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007f1:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8007f8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007fe:	c9                   	leave  
  8007ff:	c3                   	ret    

00800800 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800806:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80080d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800810:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	ff 75 f4             	pushl  -0xc(%ebp)
  80081c:	50                   	push   %eax
  80081d:	e8 73 ff ff ff       	call   800795 <vcprintf>
  800822:	83 c4 10             	add    $0x10,%esp
  800825:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800828:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80082b:	c9                   	leave  
  80082c:	c3                   	ret    

0080082d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800833:	e8 cf 0d 00 00       	call   801607 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800838:	8d 45 0c             	lea    0xc(%ebp),%eax
  80083b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 f4             	pushl  -0xc(%ebp)
  800847:	50                   	push   %eax
  800848:	e8 48 ff ff ff       	call   800795 <vcprintf>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800853:	e8 c9 0d 00 00       	call   801621 <sys_unlock_cons>
	return cnt;
  800858:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80085b:	c9                   	leave  
  80085c:	c3                   	ret    

0080085d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	53                   	push   %ebx
  800861:	83 ec 14             	sub    $0x14,%esp
  800864:	8b 45 10             	mov    0x10(%ebp),%eax
  800867:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800870:	8b 45 18             	mov    0x18(%ebp),%eax
  800873:	ba 00 00 00 00       	mov    $0x0,%edx
  800878:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80087b:	77 55                	ja     8008d2 <printnum+0x75>
  80087d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800880:	72 05                	jb     800887 <printnum+0x2a>
  800882:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800885:	77 4b                	ja     8008d2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800887:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80088a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80088d:	8b 45 18             	mov    0x18(%ebp),%eax
  800890:	ba 00 00 00 00       	mov    $0x0,%edx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	ff 75 f4             	pushl  -0xc(%ebp)
  80089a:	ff 75 f0             	pushl  -0x10(%ebp)
  80089d:	e8 26 13 00 00       	call   801bc8 <__udivdi3>
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	83 ec 04             	sub    $0x4,%esp
  8008a8:	ff 75 20             	pushl  0x20(%ebp)
  8008ab:	53                   	push   %ebx
  8008ac:	ff 75 18             	pushl  0x18(%ebp)
  8008af:	52                   	push   %edx
  8008b0:	50                   	push   %eax
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	ff 75 08             	pushl  0x8(%ebp)
  8008b7:	e8 a1 ff ff ff       	call   80085d <printnum>
  8008bc:	83 c4 20             	add    $0x20,%esp
  8008bf:	eb 1a                	jmp    8008db <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	ff 75 20             	pushl  0x20(%ebp)
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	ff d0                	call   *%eax
  8008cf:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008d2:	ff 4d 1c             	decl   0x1c(%ebp)
  8008d5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008d9:	7f e6                	jg     8008c1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008db:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e9:	53                   	push   %ebx
  8008ea:	51                   	push   %ecx
  8008eb:	52                   	push   %edx
  8008ec:	50                   	push   %eax
  8008ed:	e8 e6 13 00 00       	call   801cd8 <__umoddi3>
  8008f2:	83 c4 10             	add    $0x10,%esp
  8008f5:	05 f4 24 80 00       	add    $0x8024f4,%eax
  8008fa:	8a 00                	mov    (%eax),%al
  8008fc:	0f be c0             	movsbl %al,%eax
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	50                   	push   %eax
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	ff d0                	call   *%eax
  80090b:	83 c4 10             	add    $0x10,%esp
}
  80090e:	90                   	nop
  80090f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800912:	c9                   	leave  
  800913:	c3                   	ret    

00800914 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800917:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091b:	7e 1c                	jle    800939 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	8d 50 08             	lea    0x8(%eax),%edx
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	89 10                	mov    %edx,(%eax)
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	83 e8 08             	sub    $0x8,%eax
  800932:	8b 50 04             	mov    0x4(%eax),%edx
  800935:	8b 00                	mov    (%eax),%eax
  800937:	eb 40                	jmp    800979 <getuint+0x65>
	else if (lflag)
  800939:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093d:	74 1e                	je     80095d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	8d 50 04             	lea    0x4(%eax),%edx
  800947:	8b 45 08             	mov    0x8(%ebp),%eax
  80094a:	89 10                	mov    %edx,(%eax)
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	83 e8 04             	sub    $0x4,%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	ba 00 00 00 00       	mov    $0x0,%edx
  80095b:	eb 1c                	jmp    800979 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	8b 00                	mov    (%eax),%eax
  800962:	8d 50 04             	lea    0x4(%eax),%edx
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	89 10                	mov    %edx,(%eax)
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	83 e8 04             	sub    $0x4,%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800982:	7e 1c                	jle    8009a0 <getint+0x25>
		return va_arg(*ap, long long);
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	8b 00                	mov    (%eax),%eax
  800989:	8d 50 08             	lea    0x8(%eax),%edx
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	89 10                	mov    %edx,(%eax)
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	83 e8 08             	sub    $0x8,%eax
  800999:	8b 50 04             	mov    0x4(%eax),%edx
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	eb 38                	jmp    8009d8 <getint+0x5d>
	else if (lflag)
  8009a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a4:	74 1a                	je     8009c0 <getint+0x45>
		return va_arg(*ap, long);
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8b 00                	mov    (%eax),%eax
  8009ab:	8d 50 04             	lea    0x4(%eax),%edx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	89 10                	mov    %edx,(%eax)
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	8b 00                	mov    (%eax),%eax
  8009b8:	83 e8 04             	sub    $0x4,%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	99                   	cltd   
  8009be:	eb 18                	jmp    8009d8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	8d 50 04             	lea    0x4(%eax),%edx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 10                	mov    %edx,(%eax)
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	83 e8 04             	sub    $0x4,%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	99                   	cltd   
}
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	56                   	push   %esi
  8009de:	53                   	push   %ebx
  8009df:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e2:	eb 17                	jmp    8009fb <vprintfmt+0x21>
			if (ch == '\0')
  8009e4:	85 db                	test   %ebx,%ebx
  8009e6:	0f 84 c1 03 00 00    	je     800dad <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	53                   	push   %ebx
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fe:	8d 50 01             	lea    0x1(%eax),%edx
  800a01:	89 55 10             	mov    %edx,0x10(%ebp)
  800a04:	8a 00                	mov    (%eax),%al
  800a06:	0f b6 d8             	movzbl %al,%ebx
  800a09:	83 fb 25             	cmp    $0x25,%ebx
  800a0c:	75 d6                	jne    8009e4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a0e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a12:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a20:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a27:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a31:	8d 50 01             	lea    0x1(%eax),%edx
  800a34:	89 55 10             	mov    %edx,0x10(%ebp)
  800a37:	8a 00                	mov    (%eax),%al
  800a39:	0f b6 d8             	movzbl %al,%ebx
  800a3c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a3f:	83 f8 5b             	cmp    $0x5b,%eax
  800a42:	0f 87 3d 03 00 00    	ja     800d85 <vprintfmt+0x3ab>
  800a48:	8b 04 85 18 25 80 00 	mov    0x802518(,%eax,4),%eax
  800a4f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a51:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a55:	eb d7                	jmp    800a2e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a57:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a5b:	eb d1                	jmp    800a2e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a5d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a67:	89 d0                	mov    %edx,%eax
  800a69:	c1 e0 02             	shl    $0x2,%eax
  800a6c:	01 d0                	add    %edx,%eax
  800a6e:	01 c0                	add    %eax,%eax
  800a70:	01 d8                	add    %ebx,%eax
  800a72:	83 e8 30             	sub    $0x30,%eax
  800a75:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a78:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a80:	83 fb 2f             	cmp    $0x2f,%ebx
  800a83:	7e 3e                	jle    800ac3 <vprintfmt+0xe9>
  800a85:	83 fb 39             	cmp    $0x39,%ebx
  800a88:	7f 39                	jg     800ac3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a8a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a8d:	eb d5                	jmp    800a64 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	83 c0 04             	add    $0x4,%eax
  800a95:	89 45 14             	mov    %eax,0x14(%ebp)
  800a98:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9b:	83 e8 04             	sub    $0x4,%eax
  800a9e:	8b 00                	mov    (%eax),%eax
  800aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aa3:	eb 1f                	jmp    800ac4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aa5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa9:	79 83                	jns    800a2e <vprintfmt+0x54>
				width = 0;
  800aab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ab2:	e9 77 ff ff ff       	jmp    800a2e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ab7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800abe:	e9 6b ff ff ff       	jmp    800a2e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ac3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac8:	0f 89 60 ff ff ff    	jns    800a2e <vprintfmt+0x54>
				width = precision, precision = -1;
  800ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800adb:	e9 4e ff ff ff       	jmp    800a2e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ae0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ae3:	e9 46 ff ff ff       	jmp    800a2e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ae8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aeb:	83 c0 04             	add    $0x4,%eax
  800aee:	89 45 14             	mov    %eax,0x14(%ebp)
  800af1:	8b 45 14             	mov    0x14(%ebp),%eax
  800af4:	83 e8 04             	sub    $0x4,%eax
  800af7:	8b 00                	mov    (%eax),%eax
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	50                   	push   %eax
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			break;
  800b08:	e9 9b 02 00 00       	jmp    800da8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b10:	83 c0 04             	add    $0x4,%eax
  800b13:	89 45 14             	mov    %eax,0x14(%ebp)
  800b16:	8b 45 14             	mov    0x14(%ebp),%eax
  800b19:	83 e8 04             	sub    $0x4,%eax
  800b1c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b1e:	85 db                	test   %ebx,%ebx
  800b20:	79 02                	jns    800b24 <vprintfmt+0x14a>
				err = -err;
  800b22:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b24:	83 fb 64             	cmp    $0x64,%ebx
  800b27:	7f 0b                	jg     800b34 <vprintfmt+0x15a>
  800b29:	8b 34 9d 60 23 80 00 	mov    0x802360(,%ebx,4),%esi
  800b30:	85 f6                	test   %esi,%esi
  800b32:	75 19                	jne    800b4d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b34:	53                   	push   %ebx
  800b35:	68 05 25 80 00       	push   $0x802505
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	ff 75 08             	pushl  0x8(%ebp)
  800b40:	e8 70 02 00 00       	call   800db5 <printfmt>
  800b45:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b48:	e9 5b 02 00 00       	jmp    800da8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b4d:	56                   	push   %esi
  800b4e:	68 0e 25 80 00       	push   $0x80250e
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	ff 75 08             	pushl  0x8(%ebp)
  800b59:	e8 57 02 00 00       	call   800db5 <printfmt>
  800b5e:	83 c4 10             	add    $0x10,%esp
			break;
  800b61:	e9 42 02 00 00       	jmp    800da8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b66:	8b 45 14             	mov    0x14(%ebp),%eax
  800b69:	83 c0 04             	add    $0x4,%eax
  800b6c:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b72:	83 e8 04             	sub    $0x4,%eax
  800b75:	8b 30                	mov    (%eax),%esi
  800b77:	85 f6                	test   %esi,%esi
  800b79:	75 05                	jne    800b80 <vprintfmt+0x1a6>
				p = "(null)";
  800b7b:	be 11 25 80 00       	mov    $0x802511,%esi
			if (width > 0 && padc != '-')
  800b80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b84:	7e 6d                	jle    800bf3 <vprintfmt+0x219>
  800b86:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b8a:	74 67                	je     800bf3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	50                   	push   %eax
  800b93:	56                   	push   %esi
  800b94:	e8 1e 03 00 00       	call   800eb7 <strnlen>
  800b99:	83 c4 10             	add    $0x10,%esp
  800b9c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b9f:	eb 16                	jmp    800bb7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ba1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	50                   	push   %eax
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	ff d0                	call   *%eax
  800bb1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb4:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bbb:	7f e4                	jg     800ba1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbd:	eb 34                	jmp    800bf3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bbf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bc3:	74 1c                	je     800be1 <vprintfmt+0x207>
  800bc5:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc8:	7e 05                	jle    800bcf <vprintfmt+0x1f5>
  800bca:	83 fb 7e             	cmp    $0x7e,%ebx
  800bcd:	7e 12                	jle    800be1 <vprintfmt+0x207>
					putch('?', putdat);
  800bcf:	83 ec 08             	sub    $0x8,%esp
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	6a 3f                	push   $0x3f
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	ff d0                	call   *%eax
  800bdc:	83 c4 10             	add    $0x10,%esp
  800bdf:	eb 0f                	jmp    800bf0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800be1:	83 ec 08             	sub    $0x8,%esp
  800be4:	ff 75 0c             	pushl  0xc(%ebp)
  800be7:	53                   	push   %ebx
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	ff d0                	call   *%eax
  800bed:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bf0:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf3:	89 f0                	mov    %esi,%eax
  800bf5:	8d 70 01             	lea    0x1(%eax),%esi
  800bf8:	8a 00                	mov    (%eax),%al
  800bfa:	0f be d8             	movsbl %al,%ebx
  800bfd:	85 db                	test   %ebx,%ebx
  800bff:	74 24                	je     800c25 <vprintfmt+0x24b>
  800c01:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c05:	78 b8                	js     800bbf <vprintfmt+0x1e5>
  800c07:	ff 4d e0             	decl   -0x20(%ebp)
  800c0a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c0e:	79 af                	jns    800bbf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c10:	eb 13                	jmp    800c25 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	6a 20                	push   $0x20
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	ff d0                	call   *%eax
  800c1f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c22:	ff 4d e4             	decl   -0x1c(%ebp)
  800c25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c29:	7f e7                	jg     800c12 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c2b:	e9 78 01 00 00       	jmp    800da8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c30:	83 ec 08             	sub    $0x8,%esp
  800c33:	ff 75 e8             	pushl  -0x18(%ebp)
  800c36:	8d 45 14             	lea    0x14(%ebp),%eax
  800c39:	50                   	push   %eax
  800c3a:	e8 3c fd ff ff       	call   80097b <getint>
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c45:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4e:	85 d2                	test   %edx,%edx
  800c50:	79 23                	jns    800c75 <vprintfmt+0x29b>
				putch('-', putdat);
  800c52:	83 ec 08             	sub    $0x8,%esp
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	6a 2d                	push   $0x2d
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	ff d0                	call   *%eax
  800c5f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c68:	f7 d8                	neg    %eax
  800c6a:	83 d2 00             	adc    $0x0,%edx
  800c6d:	f7 da                	neg    %edx
  800c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c75:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c7c:	e9 bc 00 00 00       	jmp    800d3d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	ff 75 e8             	pushl  -0x18(%ebp)
  800c87:	8d 45 14             	lea    0x14(%ebp),%eax
  800c8a:	50                   	push   %eax
  800c8b:	e8 84 fc ff ff       	call   800914 <getuint>
  800c90:	83 c4 10             	add    $0x10,%esp
  800c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c99:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ca0:	e9 98 00 00 00       	jmp    800d3d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ca5:	83 ec 08             	sub    $0x8,%esp
  800ca8:	ff 75 0c             	pushl  0xc(%ebp)
  800cab:	6a 58                	push   $0x58
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	6a 58                	push   $0x58
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc5:	83 ec 08             	sub    $0x8,%esp
  800cc8:	ff 75 0c             	pushl  0xc(%ebp)
  800ccb:	6a 58                	push   $0x58
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	ff d0                	call   *%eax
  800cd2:	83 c4 10             	add    $0x10,%esp
			break;
  800cd5:	e9 ce 00 00 00       	jmp    800da8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cda:	83 ec 08             	sub    $0x8,%esp
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	6a 30                	push   $0x30
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	ff d0                	call   *%eax
  800ce7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cea:	83 ec 08             	sub    $0x8,%esp
  800ced:	ff 75 0c             	pushl  0xc(%ebp)
  800cf0:	6a 78                	push   $0x78
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	ff d0                	call   *%eax
  800cf7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cfa:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfd:	83 c0 04             	add    $0x4,%eax
  800d00:	89 45 14             	mov    %eax,0x14(%ebp)
  800d03:	8b 45 14             	mov    0x14(%ebp),%eax
  800d06:	83 e8 04             	sub    $0x4,%eax
  800d09:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d1c:	eb 1f                	jmp    800d3d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d1e:	83 ec 08             	sub    $0x8,%esp
  800d21:	ff 75 e8             	pushl  -0x18(%ebp)
  800d24:	8d 45 14             	lea    0x14(%ebp),%eax
  800d27:	50                   	push   %eax
  800d28:	e8 e7 fb ff ff       	call   800914 <getuint>
  800d2d:	83 c4 10             	add    $0x10,%esp
  800d30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d36:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d3d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d44:	83 ec 04             	sub    $0x4,%esp
  800d47:	52                   	push   %edx
  800d48:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d4b:	50                   	push   %eax
  800d4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800d52:	ff 75 0c             	pushl  0xc(%ebp)
  800d55:	ff 75 08             	pushl  0x8(%ebp)
  800d58:	e8 00 fb ff ff       	call   80085d <printnum>
  800d5d:	83 c4 20             	add    $0x20,%esp
			break;
  800d60:	eb 46                	jmp    800da8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d62:	83 ec 08             	sub    $0x8,%esp
  800d65:	ff 75 0c             	pushl  0xc(%ebp)
  800d68:	53                   	push   %ebx
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	ff d0                	call   *%eax
  800d6e:	83 c4 10             	add    $0x10,%esp
			break;
  800d71:	eb 35                	jmp    800da8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d73:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800d7a:	eb 2c                	jmp    800da8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d7c:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800d83:	eb 23                	jmp    800da8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d85:	83 ec 08             	sub    $0x8,%esp
  800d88:	ff 75 0c             	pushl  0xc(%ebp)
  800d8b:	6a 25                	push   $0x25
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	ff d0                	call   *%eax
  800d92:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d95:	ff 4d 10             	decl   0x10(%ebp)
  800d98:	eb 03                	jmp    800d9d <vprintfmt+0x3c3>
  800d9a:	ff 4d 10             	decl   0x10(%ebp)
  800d9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800da0:	48                   	dec    %eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	3c 25                	cmp    $0x25,%al
  800da5:	75 f3                	jne    800d9a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800da7:	90                   	nop
		}
	}
  800da8:	e9 35 fc ff ff       	jmp    8009e2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dad:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dbb:	8d 45 10             	lea    0x10(%ebp),%eax
  800dbe:	83 c0 04             	add    $0x4,%eax
  800dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dca:	50                   	push   %eax
  800dcb:	ff 75 0c             	pushl  0xc(%ebp)
  800dce:	ff 75 08             	pushl  0x8(%ebp)
  800dd1:	e8 04 fc ff ff       	call   8009da <vprintfmt>
  800dd6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dd9:	90                   	nop
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	8b 40 08             	mov    0x8(%eax),%eax
  800de5:	8d 50 01             	lea    0x1(%eax),%edx
  800de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800deb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df1:	8b 10                	mov    (%eax),%edx
  800df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df6:	8b 40 04             	mov    0x4(%eax),%eax
  800df9:	39 c2                	cmp    %eax,%edx
  800dfb:	73 12                	jae    800e0f <sprintputch+0x33>
		*b->buf++ = ch;
  800dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e00:	8b 00                	mov    (%eax),%eax
  800e02:	8d 48 01             	lea    0x1(%eax),%ecx
  800e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e08:	89 0a                	mov    %ecx,(%edx)
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	88 10                	mov    %dl,(%eax)
}
  800e0f:	90                   	nop
  800e10:	5d                   	pop    %ebp
  800e11:	c3                   	ret    

00800e12 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e21:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	01 d0                	add    %edx,%eax
  800e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e37:	74 06                	je     800e3f <vsnprintf+0x2d>
  800e39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e3d:	7f 07                	jg     800e46 <vsnprintf+0x34>
		return -E_INVAL;
  800e3f:	b8 03 00 00 00       	mov    $0x3,%eax
  800e44:	eb 20                	jmp    800e66 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e46:	ff 75 14             	pushl  0x14(%ebp)
  800e49:	ff 75 10             	pushl  0x10(%ebp)
  800e4c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e4f:	50                   	push   %eax
  800e50:	68 dc 0d 80 00       	push   $0x800ddc
  800e55:	e8 80 fb ff ff       	call   8009da <vprintfmt>
  800e5a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e60:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e66:	c9                   	leave  
  800e67:	c3                   	ret    

00800e68 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e6e:	8d 45 10             	lea    0x10(%ebp),%eax
  800e71:	83 c0 04             	add    $0x4,%eax
  800e74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e77:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e7d:	50                   	push   %eax
  800e7e:	ff 75 0c             	pushl  0xc(%ebp)
  800e81:	ff 75 08             	pushl  0x8(%ebp)
  800e84:	e8 89 ff ff ff       	call   800e12 <vsnprintf>
  800e89:	83 c4 10             	add    $0x10,%esp
  800e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e92:	c9                   	leave  
  800e93:	c3                   	ret    

00800e94 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea1:	eb 06                	jmp    800ea9 <strlen+0x15>
		n++;
  800ea3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ea6:	ff 45 08             	incl   0x8(%ebp)
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	84 c0                	test   %al,%al
  800eb0:	75 f1                	jne    800ea3 <strlen+0xf>
		n++;
	return n;
  800eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb5:	c9                   	leave  
  800eb6:	c3                   	ret    

00800eb7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ebd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec4:	eb 09                	jmp    800ecf <strnlen+0x18>
		n++;
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec9:	ff 45 08             	incl   0x8(%ebp)
  800ecc:	ff 4d 0c             	decl   0xc(%ebp)
  800ecf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed3:	74 09                	je     800ede <strnlen+0x27>
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	84 c0                	test   %al,%al
  800edc:	75 e8                	jne    800ec6 <strnlen+0xf>
		n++;
	return n;
  800ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    

00800ee3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800eef:	90                   	nop
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8d 50 01             	lea    0x1(%eax),%edx
  800ef6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f02:	8a 12                	mov    (%edx),%dl
  800f04:	88 10                	mov    %dl,(%eax)
  800f06:	8a 00                	mov    (%eax),%al
  800f08:	84 c0                	test   %al,%al
  800f0a:	75 e4                	jne    800ef0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f0f:	c9                   	leave  
  800f10:	c3                   	ret    

00800f11 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f1d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f24:	eb 1f                	jmp    800f45 <strncpy+0x34>
		*dst++ = *src;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8d 50 01             	lea    0x1(%eax),%edx
  800f2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f32:	8a 12                	mov    (%edx),%dl
  800f34:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	84 c0                	test   %al,%al
  800f3d:	74 03                	je     800f42 <strncpy+0x31>
			src++;
  800f3f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f42:	ff 45 fc             	incl   -0x4(%ebp)
  800f45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f48:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f4b:	72 d9                	jb     800f26 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f50:	c9                   	leave  
  800f51:	c3                   	ret    

00800f52 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	74 30                	je     800f94 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f64:	eb 16                	jmp    800f7c <strlcpy+0x2a>
			*dst++ = *src++;
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	8d 50 01             	lea    0x1(%eax),%edx
  800f6c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f75:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f78:	8a 12                	mov    (%edx),%dl
  800f7a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f7c:	ff 4d 10             	decl   0x10(%ebp)
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	74 09                	je     800f8e <strlcpy+0x3c>
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	84 c0                	test   %al,%al
  800f8c:	75 d8                	jne    800f66 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f94:	8b 55 08             	mov    0x8(%ebp),%edx
  800f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9a:	29 c2                	sub    %eax,%edx
  800f9c:	89 d0                	mov    %edx,%eax
}
  800f9e:	c9                   	leave  
  800f9f:	c3                   	ret    

00800fa0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fa3:	eb 06                	jmp    800fab <strcmp+0xb>
		p++, q++;
  800fa5:	ff 45 08             	incl   0x8(%ebp)
  800fa8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	84 c0                	test   %al,%al
  800fb2:	74 0e                	je     800fc2 <strcmp+0x22>
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	8a 10                	mov    (%eax),%dl
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	38 c2                	cmp    %al,%dl
  800fc0:	74 e3                	je     800fa5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	0f b6 d0             	movzbl %al,%edx
  800fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f b6 c0             	movzbl %al,%eax
  800fd2:	29 c2                	sub    %eax,%edx
  800fd4:	89 d0                	mov    %edx,%eax
}
  800fd6:	5d                   	pop    %ebp
  800fd7:	c3                   	ret    

00800fd8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fd8:	55                   	push   %ebp
  800fd9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fdb:	eb 09                	jmp    800fe6 <strncmp+0xe>
		n--, p++, q++;
  800fdd:	ff 4d 10             	decl   0x10(%ebp)
  800fe0:	ff 45 08             	incl   0x8(%ebp)
  800fe3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fe6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fea:	74 17                	je     801003 <strncmp+0x2b>
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	84 c0                	test   %al,%al
  800ff3:	74 0e                	je     801003 <strncmp+0x2b>
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 10                	mov    (%eax),%dl
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	38 c2                	cmp    %al,%dl
  801001:	74 da                	je     800fdd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801003:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801007:	75 07                	jne    801010 <strncmp+0x38>
		return 0;
  801009:	b8 00 00 00 00       	mov    $0x0,%eax
  80100e:	eb 14                	jmp    801024 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	0f b6 d0             	movzbl %al,%edx
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	8a 00                	mov    (%eax),%al
  80101d:	0f b6 c0             	movzbl %al,%eax
  801020:	29 c2                	sub    %eax,%edx
  801022:	89 d0                	mov    %edx,%eax
}
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 04             	sub    $0x4,%esp
  80102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801032:	eb 12                	jmp    801046 <strchr+0x20>
		if (*s == c)
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	8a 00                	mov    (%eax),%al
  801039:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80103c:	75 05                	jne    801043 <strchr+0x1d>
			return (char *) s;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	eb 11                	jmp    801054 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	84 c0                	test   %al,%al
  80104d:	75 e5                	jne    801034 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80104f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801054:	c9                   	leave  
  801055:	c3                   	ret    

00801056 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	83 ec 04             	sub    $0x4,%esp
  80105c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801062:	eb 0d                	jmp    801071 <strfind+0x1b>
		if (*s == c)
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80106c:	74 0e                	je     80107c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80106e:	ff 45 08             	incl   0x8(%ebp)
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	84 c0                	test   %al,%al
  801078:	75 ea                	jne    801064 <strfind+0xe>
  80107a:	eb 01                	jmp    80107d <strfind+0x27>
		if (*s == c)
			break;
  80107c:	90                   	nop
	return (char *) s;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80108e:	8b 45 10             	mov    0x10(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801094:	eb 0e                	jmp    8010a4 <memset+0x22>
		*p++ = c;
  801096:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801099:	8d 50 01             	lea    0x1(%eax),%edx
  80109c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80109f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010a4:	ff 4d f8             	decl   -0x8(%ebp)
  8010a7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010ab:	79 e9                	jns    801096 <memset+0x14>
		*p++ = c;

	return v;
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010c4:	eb 16                	jmp    8010dc <memcpy+0x2a>
		*d++ = *s++;
  8010c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c9:	8d 50 01             	lea    0x1(%eax),%edx
  8010cc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010d5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010d8:	8a 12                	mov    (%edx),%dl
  8010da:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	75 dd                	jne    8010c6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ec:	c9                   	leave  
  8010ed:	c3                   	ret    

008010ee <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
  8010f1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801100:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801103:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801106:	73 50                	jae    801158 <memmove+0x6a>
  801108:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801113:	76 43                	jbe    801158 <memmove+0x6a>
		s += n;
  801115:	8b 45 10             	mov    0x10(%ebp),%eax
  801118:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80111b:	8b 45 10             	mov    0x10(%ebp),%eax
  80111e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801121:	eb 10                	jmp    801133 <memmove+0x45>
			*--d = *--s;
  801123:	ff 4d f8             	decl   -0x8(%ebp)
  801126:	ff 4d fc             	decl   -0x4(%ebp)
  801129:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112c:	8a 10                	mov    (%eax),%dl
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801131:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801133:	8b 45 10             	mov    0x10(%ebp),%eax
  801136:	8d 50 ff             	lea    -0x1(%eax),%edx
  801139:	89 55 10             	mov    %edx,0x10(%ebp)
  80113c:	85 c0                	test   %eax,%eax
  80113e:	75 e3                	jne    801123 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801140:	eb 23                	jmp    801165 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	8d 50 01             	lea    0x1(%eax),%edx
  801148:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80114b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801151:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801154:	8a 12                	mov    (%edx),%dl
  801156:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801158:	8b 45 10             	mov    0x10(%ebp),%eax
  80115b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115e:	89 55 10             	mov    %edx,0x10(%ebp)
  801161:	85 c0                	test   %eax,%eax
  801163:	75 dd                	jne    801142 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801168:	c9                   	leave  
  801169:	c3                   	ret    

0080116a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80117c:	eb 2a                	jmp    8011a8 <memcmp+0x3e>
		if (*s1 != *s2)
  80117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801181:	8a 10                	mov    (%eax),%dl
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	38 c2                	cmp    %al,%dl
  80118a:	74 16                	je     8011a2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80118c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	0f b6 d0             	movzbl %al,%edx
  801194:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	0f b6 c0             	movzbl %al,%eax
  80119c:	29 c2                	sub    %eax,%edx
  80119e:	89 d0                	mov    %edx,%eax
  8011a0:	eb 18                	jmp    8011ba <memcmp+0x50>
		s1++, s2++;
  8011a2:	ff 45 fc             	incl   -0x4(%ebp)
  8011a5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	75 c9                	jne    80117e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011cd:	eb 15                	jmp    8011e4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	0f b6 d0             	movzbl %al,%edx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	0f b6 c0             	movzbl %al,%eax
  8011dd:	39 c2                	cmp    %eax,%edx
  8011df:	74 0d                	je     8011ee <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011e1:	ff 45 08             	incl   0x8(%ebp)
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011ea:	72 e3                	jb     8011cf <memfind+0x13>
  8011ec:	eb 01                	jmp    8011ef <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011ee:	90                   	nop
	return (void *) s;
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801201:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801208:	eb 03                	jmp    80120d <strtol+0x19>
		s++;
  80120a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	3c 20                	cmp    $0x20,%al
  801214:	74 f4                	je     80120a <strtol+0x16>
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	3c 09                	cmp    $0x9,%al
  80121d:	74 eb                	je     80120a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	3c 2b                	cmp    $0x2b,%al
  801226:	75 05                	jne    80122d <strtol+0x39>
		s++;
  801228:	ff 45 08             	incl   0x8(%ebp)
  80122b:	eb 13                	jmp    801240 <strtol+0x4c>
	else if (*s == '-')
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	3c 2d                	cmp    $0x2d,%al
  801234:	75 0a                	jne    801240 <strtol+0x4c>
		s++, neg = 1;
  801236:	ff 45 08             	incl   0x8(%ebp)
  801239:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	74 06                	je     80124c <strtol+0x58>
  801246:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80124a:	75 20                	jne    80126c <strtol+0x78>
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	3c 30                	cmp    $0x30,%al
  801253:	75 17                	jne    80126c <strtol+0x78>
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	40                   	inc    %eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	3c 78                	cmp    $0x78,%al
  80125d:	75 0d                	jne    80126c <strtol+0x78>
		s += 2, base = 16;
  80125f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801263:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80126a:	eb 28                	jmp    801294 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80126c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801270:	75 15                	jne    801287 <strtol+0x93>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	3c 30                	cmp    $0x30,%al
  801279:	75 0c                	jne    801287 <strtol+0x93>
		s++, base = 8;
  80127b:	ff 45 08             	incl   0x8(%ebp)
  80127e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801285:	eb 0d                	jmp    801294 <strtol+0xa0>
	else if (base == 0)
  801287:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80128b:	75 07                	jne    801294 <strtol+0xa0>
		base = 10;
  80128d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	3c 2f                	cmp    $0x2f,%al
  80129b:	7e 19                	jle    8012b6 <strtol+0xc2>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 39                	cmp    $0x39,%al
  8012a4:	7f 10                	jg     8012b6 <strtol+0xc2>
			dig = *s - '0';
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	8a 00                	mov    (%eax),%al
  8012ab:	0f be c0             	movsbl %al,%eax
  8012ae:	83 e8 30             	sub    $0x30,%eax
  8012b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012b4:	eb 42                	jmp    8012f8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	3c 60                	cmp    $0x60,%al
  8012bd:	7e 19                	jle    8012d8 <strtol+0xe4>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	3c 7a                	cmp    $0x7a,%al
  8012c6:	7f 10                	jg     8012d8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	0f be c0             	movsbl %al,%eax
  8012d0:	83 e8 57             	sub    $0x57,%eax
  8012d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012d6:	eb 20                	jmp    8012f8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	3c 40                	cmp    $0x40,%al
  8012df:	7e 39                	jle    80131a <strtol+0x126>
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	3c 5a                	cmp    $0x5a,%al
  8012e8:	7f 30                	jg     80131a <strtol+0x126>
			dig = *s - 'A' + 10;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	8a 00                	mov    (%eax),%al
  8012ef:	0f be c0             	movsbl %al,%eax
  8012f2:	83 e8 37             	sub    $0x37,%eax
  8012f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012fe:	7d 19                	jge    801319 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801300:	ff 45 08             	incl   0x8(%ebp)
  801303:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801306:	0f af 45 10          	imul   0x10(%ebp),%eax
  80130a:	89 c2                	mov    %eax,%edx
  80130c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130f:	01 d0                	add    %edx,%eax
  801311:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801314:	e9 7b ff ff ff       	jmp    801294 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801319:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80131a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131e:	74 08                	je     801328 <strtol+0x134>
		*endptr = (char *) s;
  801320:	8b 45 0c             	mov    0xc(%ebp),%eax
  801323:	8b 55 08             	mov    0x8(%ebp),%edx
  801326:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801328:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80132c:	74 07                	je     801335 <strtol+0x141>
  80132e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801331:	f7 d8                	neg    %eax
  801333:	eb 03                	jmp    801338 <strtol+0x144>
  801335:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <ltostr>:

void
ltostr(long value, char *str)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801340:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801347:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80134e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801352:	79 13                	jns    801367 <ltostr+0x2d>
	{
		neg = 1;
  801354:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801361:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801364:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80136f:	99                   	cltd   
  801370:	f7 f9                	idiv   %ecx
  801372:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801378:	8d 50 01             	lea    0x1(%eax),%edx
  80137b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80137e:	89 c2                	mov    %eax,%edx
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	01 d0                	add    %edx,%eax
  801385:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801388:	83 c2 30             	add    $0x30,%edx
  80138b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80138d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801390:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801395:	f7 e9                	imul   %ecx
  801397:	c1 fa 02             	sar    $0x2,%edx
  80139a:	89 c8                	mov    %ecx,%eax
  80139c:	c1 f8 1f             	sar    $0x1f,%eax
  80139f:	29 c2                	sub    %eax,%edx
  8013a1:	89 d0                	mov    %edx,%eax
  8013a3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013aa:	75 bb                	jne    801367 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b6:	48                   	dec    %eax
  8013b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013be:	74 3d                	je     8013fd <ltostr+0xc3>
		start = 1 ;
  8013c0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013c7:	eb 34                	jmp    8013fd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cf:	01 d0                	add    %edx,%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	01 c2                	add    %eax,%edx
  8013de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	01 c8                	add    %ecx,%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f0:	01 c2                	add    %eax,%edx
  8013f2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013f5:	88 02                	mov    %al,(%edx)
		start++ ;
  8013f7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013fa:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801400:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801403:	7c c4                	jl     8013c9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801405:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140b:	01 d0                	add    %edx,%eax
  80140d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801410:	90                   	nop
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801419:	ff 75 08             	pushl  0x8(%ebp)
  80141c:	e8 73 fa ff ff       	call   800e94 <strlen>
  801421:	83 c4 04             	add    $0x4,%esp
  801424:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801427:	ff 75 0c             	pushl  0xc(%ebp)
  80142a:	e8 65 fa ff ff       	call   800e94 <strlen>
  80142f:	83 c4 04             	add    $0x4,%esp
  801432:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801435:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80143c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801443:	eb 17                	jmp    80145c <strcconcat+0x49>
		final[s] = str1[s] ;
  801445:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801448:	8b 45 10             	mov    0x10(%ebp),%eax
  80144b:	01 c2                	add    %eax,%edx
  80144d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	01 c8                	add    %ecx,%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801459:	ff 45 fc             	incl   -0x4(%ebp)
  80145c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80145f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801462:	7c e1                	jl     801445 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801464:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80146b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801472:	eb 1f                	jmp    801493 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801474:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801477:	8d 50 01             	lea    0x1(%eax),%edx
  80147a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80147d:	89 c2                	mov    %eax,%edx
  80147f:	8b 45 10             	mov    0x10(%ebp),%eax
  801482:	01 c2                	add    %eax,%edx
  801484:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148a:	01 c8                	add    %ecx,%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801490:	ff 45 f8             	incl   -0x8(%ebp)
  801493:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801496:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801499:	7c d9                	jl     801474 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80149b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149e:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a1:	01 d0                	add    %edx,%eax
  8014a3:	c6 00 00             	movb   $0x0,(%eax)
}
  8014a6:	90                   	nop
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b8:	8b 00                	mov    (%eax),%eax
  8014ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c4:	01 d0                	add    %edx,%eax
  8014c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014cc:	eb 0c                	jmp    8014da <strsplit+0x31>
			*string++ = 0;
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	8d 50 01             	lea    0x1(%eax),%edx
  8014d4:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	84 c0                	test   %al,%al
  8014e1:	74 18                	je     8014fb <strsplit+0x52>
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	0f be c0             	movsbl %al,%eax
  8014eb:	50                   	push   %eax
  8014ec:	ff 75 0c             	pushl  0xc(%ebp)
  8014ef:	e8 32 fb ff ff       	call   801026 <strchr>
  8014f4:	83 c4 08             	add    $0x8,%esp
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	75 d3                	jne    8014ce <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	84 c0                	test   %al,%al
  801502:	74 5a                	je     80155e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801504:	8b 45 14             	mov    0x14(%ebp),%eax
  801507:	8b 00                	mov    (%eax),%eax
  801509:	83 f8 0f             	cmp    $0xf,%eax
  80150c:	75 07                	jne    801515 <strsplit+0x6c>
		{
			return 0;
  80150e:	b8 00 00 00 00       	mov    $0x0,%eax
  801513:	eb 66                	jmp    80157b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801515:	8b 45 14             	mov    0x14(%ebp),%eax
  801518:	8b 00                	mov    (%eax),%eax
  80151a:	8d 48 01             	lea    0x1(%eax),%ecx
  80151d:	8b 55 14             	mov    0x14(%ebp),%edx
  801520:	89 0a                	mov    %ecx,(%edx)
  801522:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801529:	8b 45 10             	mov    0x10(%ebp),%eax
  80152c:	01 c2                	add    %eax,%edx
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801533:	eb 03                	jmp    801538 <strsplit+0x8f>
			string++;
  801535:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	84 c0                	test   %al,%al
  80153f:	74 8b                	je     8014cc <strsplit+0x23>
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f be c0             	movsbl %al,%eax
  801549:	50                   	push   %eax
  80154a:	ff 75 0c             	pushl  0xc(%ebp)
  80154d:	e8 d4 fa ff ff       	call   801026 <strchr>
  801552:	83 c4 08             	add    $0x8,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	74 dc                	je     801535 <strsplit+0x8c>
			string++;
	}
  801559:	e9 6e ff ff ff       	jmp    8014cc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80155e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80155f:	8b 45 14             	mov    0x14(%ebp),%eax
  801562:	8b 00                	mov    (%eax),%eax
  801564:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80156b:	8b 45 10             	mov    0x10(%ebp),%eax
  80156e:	01 d0                	add    %edx,%eax
  801570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801576:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801583:	83 ec 04             	sub    $0x4,%esp
  801586:	68 88 26 80 00       	push   $0x802688
  80158b:	68 3f 01 00 00       	push   $0x13f
  801590:	68 aa 26 80 00       	push   $0x8026aa
  801595:	e8 a9 ef ff ff       	call   800543 <_panic>

0080159a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	57                   	push   %edi
  80159e:	56                   	push   %esi
  80159f:	53                   	push   %ebx
  8015a0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015af:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015b2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015b5:	cd 30                	int    $0x30
  8015b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015bd:	83 c4 10             	add    $0x10,%esp
  8015c0:	5b                   	pop    %ebx
  8015c1:	5e                   	pop    %esi
  8015c2:	5f                   	pop    %edi
  8015c3:	5d                   	pop    %ebp
  8015c4:	c3                   	ret    

008015c5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 04             	sub    $0x4,%esp
  8015cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015d1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	52                   	push   %edx
  8015dd:	ff 75 0c             	pushl  0xc(%ebp)
  8015e0:	50                   	push   %eax
  8015e1:	6a 00                	push   $0x0
  8015e3:	e8 b2 ff ff ff       	call   80159a <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
}
  8015eb:	90                   	nop
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sys_cgetc>:

int
sys_cgetc(void)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 02                	push   $0x2
  8015fd:	e8 98 ff ff ff       	call   80159a <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 03                	push   $0x3
  801616:	e8 7f ff ff ff       	call   80159a <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
}
  80161e:	90                   	nop
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 04                	push   $0x4
  801630:	e8 65 ff ff ff       	call   80159a <syscall>
  801635:	83 c4 18             	add    $0x18,%esp
}
  801638:	90                   	nop
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80163e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	52                   	push   %edx
  80164b:	50                   	push   %eax
  80164c:	6a 08                	push   $0x8
  80164e:	e8 47 ff ff ff       	call   80159a <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	56                   	push   %esi
  80165c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80165d:	8b 75 18             	mov    0x18(%ebp),%esi
  801660:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801663:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801666:	8b 55 0c             	mov    0xc(%ebp),%edx
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	56                   	push   %esi
  80166d:	53                   	push   %ebx
  80166e:	51                   	push   %ecx
  80166f:	52                   	push   %edx
  801670:	50                   	push   %eax
  801671:	6a 09                	push   $0x9
  801673:	e8 22 ff ff ff       	call   80159a <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
}
  80167b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80167e:	5b                   	pop    %ebx
  80167f:	5e                   	pop    %esi
  801680:	5d                   	pop    %ebp
  801681:	c3                   	ret    

00801682 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801685:	8b 55 0c             	mov    0xc(%ebp),%edx
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	6a 0a                	push   $0xa
  801695:	e8 00 ff ff ff       	call   80159a <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	ff 75 08             	pushl  0x8(%ebp)
  8016ae:	6a 0b                	push   $0xb
  8016b0:	e8 e5 fe ff ff       	call   80159a <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 0c                	push   $0xc
  8016c9:	e8 cc fe ff ff       	call   80159a <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 0d                	push   $0xd
  8016e2:	e8 b3 fe ff ff       	call   80159a <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 0e                	push   $0xe
  8016fb:	e8 9a fe ff ff       	call   80159a <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 0f                	push   $0xf
  801714:	e8 81 fe ff ff       	call   80159a <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	6a 10                	push   $0x10
  80172e:	e8 67 fe ff ff       	call   80159a <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 11                	push   $0x11
  801747:	e8 4e fe ff ff       	call   80159a <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
}
  80174f:	90                   	nop
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <sys_cputc>:

void
sys_cputc(const char c)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80175e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	50                   	push   %eax
  80176b:	6a 01                	push   $0x1
  80176d:	e8 28 fe ff ff       	call   80159a <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	90                   	nop
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 14                	push   $0x14
  801787:	e8 0e fe ff ff       	call   80159a <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	90                   	nop
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	83 ec 04             	sub    $0x4,%esp
  801798:	8b 45 10             	mov    0x10(%ebp),%eax
  80179b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80179e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017a1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	6a 00                	push   $0x0
  8017aa:	51                   	push   %ecx
  8017ab:	52                   	push   %edx
  8017ac:	ff 75 0c             	pushl  0xc(%ebp)
  8017af:	50                   	push   %eax
  8017b0:	6a 15                	push   $0x15
  8017b2:	e8 e3 fd ff ff       	call   80159a <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	52                   	push   %edx
  8017cc:	50                   	push   %eax
  8017cd:	6a 16                	push   $0x16
  8017cf:	e8 c6 fd ff ff       	call   80159a <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	51                   	push   %ecx
  8017ea:	52                   	push   %edx
  8017eb:	50                   	push   %eax
  8017ec:	6a 17                	push   $0x17
  8017ee:	e8 a7 fd ff ff       	call   80159a <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	52                   	push   %edx
  801808:	50                   	push   %eax
  801809:	6a 18                	push   $0x18
  80180b:	e8 8a fd ff ff       	call   80159a <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	6a 00                	push   $0x0
  80181d:	ff 75 14             	pushl  0x14(%ebp)
  801820:	ff 75 10             	pushl  0x10(%ebp)
  801823:	ff 75 0c             	pushl  0xc(%ebp)
  801826:	50                   	push   %eax
  801827:	6a 19                	push   $0x19
  801829:	e8 6c fd ff ff       	call   80159a <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	50                   	push   %eax
  801842:	6a 1a                	push   $0x1a
  801844:	e8 51 fd ff ff       	call   80159a <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	90                   	nop
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	50                   	push   %eax
  80185e:	6a 1b                	push   $0x1b
  801860:	e8 35 fd ff ff       	call   80159a <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 05                	push   $0x5
  801879:	e8 1c fd ff ff       	call   80159a <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 06                	push   $0x6
  801892:	e8 03 fd ff ff       	call   80159a <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 07                	push   $0x7
  8018ab:	e8 ea fc ff ff       	call   80159a <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_exit_env>:


void sys_exit_env(void)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 1c                	push   $0x1c
  8018c4:	e8 d1 fc ff ff       	call   80159a <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	90                   	nop
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018d5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018d8:	8d 50 04             	lea    0x4(%eax),%edx
  8018db:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	52                   	push   %edx
  8018e5:	50                   	push   %eax
  8018e6:	6a 1d                	push   $0x1d
  8018e8:	e8 ad fc ff ff       	call   80159a <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
	return result;
  8018f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f9:	89 01                	mov    %eax,(%ecx)
  8018fb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	c9                   	leave  
  801902:	c2 04 00             	ret    $0x4

00801905 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	ff 75 10             	pushl  0x10(%ebp)
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	6a 13                	push   $0x13
  801917:	e8 7e fc ff ff       	call   80159a <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
	return ;
  80191f:	90                   	nop
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_rcr2>:
uint32 sys_rcr2()
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 1e                	push   $0x1e
  801931:	e8 64 fc ff ff       	call   80159a <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801947:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	50                   	push   %eax
  801954:	6a 1f                	push   $0x1f
  801956:	e8 3f fc ff ff       	call   80159a <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
	return ;
  80195e:	90                   	nop
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <rsttst>:
void rsttst()
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 21                	push   $0x21
  801970:	e8 25 fc ff ff       	call   80159a <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
	return ;
  801978:	90                   	nop
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 04             	sub    $0x4,%esp
  801981:	8b 45 14             	mov    0x14(%ebp),%eax
  801984:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801987:	8b 55 18             	mov    0x18(%ebp),%edx
  80198a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80198e:	52                   	push   %edx
  80198f:	50                   	push   %eax
  801990:	ff 75 10             	pushl  0x10(%ebp)
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	ff 75 08             	pushl  0x8(%ebp)
  801999:	6a 20                	push   $0x20
  80199b:	e8 fa fb ff ff       	call   80159a <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a3:	90                   	nop
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <chktst>:
void chktst(uint32 n)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	ff 75 08             	pushl  0x8(%ebp)
  8019b4:	6a 22                	push   $0x22
  8019b6:	e8 df fb ff ff       	call   80159a <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019be:	90                   	nop
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <inctst>:

void inctst()
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 23                	push   $0x23
  8019d0:	e8 c5 fb ff ff       	call   80159a <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d8:	90                   	nop
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <gettst>:
uint32 gettst()
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 24                	push   $0x24
  8019ea:	e8 ab fb ff ff       	call   80159a <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 25                	push   $0x25
  801a06:	e8 8f fb ff ff       	call   80159a <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
  801a0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a11:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a15:	75 07                	jne    801a1e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a17:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1c:	eb 05                	jmp    801a23 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 25                	push   $0x25
  801a37:	e8 5e fb ff ff       	call   80159a <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
  801a3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a42:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a46:	75 07                	jne    801a4f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a48:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4d:	eb 05                	jmp    801a54 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 25                	push   $0x25
  801a68:	e8 2d fb ff ff       	call   80159a <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
  801a70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a73:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a77:	75 07                	jne    801a80 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a79:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7e:	eb 05                	jmp    801a85 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 25                	push   $0x25
  801a99:	e8 fc fa ff ff       	call   80159a <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
  801aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801aa4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801aa8:	75 07                	jne    801ab1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801aaa:	b8 01 00 00 00       	mov    $0x1,%eax
  801aaf:	eb 05                	jmp    801ab6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	ff 75 08             	pushl  0x8(%ebp)
  801ac6:	6a 26                	push   $0x26
  801ac8:	e8 cd fa ff ff       	call   80159a <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad0:	90                   	nop
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ad7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ada:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801add:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	6a 00                	push   $0x0
  801ae5:	53                   	push   %ebx
  801ae6:	51                   	push   %ecx
  801ae7:	52                   	push   %edx
  801ae8:	50                   	push   %eax
  801ae9:	6a 27                	push   $0x27
  801aeb:	e8 aa fa ff ff       	call   80159a <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 28                	push   $0x28
  801b0b:	e8 8a fa ff ff       	call   80159a <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b18:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	6a 00                	push   $0x0
  801b23:	51                   	push   %ecx
  801b24:	ff 75 10             	pushl  0x10(%ebp)
  801b27:	52                   	push   %edx
  801b28:	50                   	push   %eax
  801b29:	6a 29                	push   $0x29
  801b2b:	e8 6a fa ff ff       	call   80159a <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	ff 75 10             	pushl  0x10(%ebp)
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	ff 75 08             	pushl  0x8(%ebp)
  801b45:	6a 12                	push   $0x12
  801b47:	e8 4e fa ff ff       	call   80159a <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4f:	90                   	nop
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	6a 2a                	push   $0x2a
  801b65:	e8 30 fa ff ff       	call   80159a <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
	return;
  801b6d:	90                   	nop
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b76:	83 ec 04             	sub    $0x4,%esp
  801b79:	68 b7 26 80 00       	push   $0x8026b7
  801b7e:	68 2e 01 00 00       	push   $0x12e
  801b83:	68 cb 26 80 00       	push   $0x8026cb
  801b88:	e8 b6 e9 ff ff       	call   800543 <_panic>

00801b8d <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b93:	83 ec 04             	sub    $0x4,%esp
  801b96:	68 b7 26 80 00       	push   $0x8026b7
  801b9b:	68 35 01 00 00       	push   $0x135
  801ba0:	68 cb 26 80 00       	push   $0x8026cb
  801ba5:	e8 99 e9 ff ff       	call   800543 <_panic>

00801baa <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801bb0:	83 ec 04             	sub    $0x4,%esp
  801bb3:	68 b7 26 80 00       	push   $0x8026b7
  801bb8:	68 3b 01 00 00       	push   $0x13b
  801bbd:	68 cb 26 80 00       	push   $0x8026cb
  801bc2:	e8 7c e9 ff ff       	call   800543 <_panic>
  801bc7:	90                   	nop

00801bc8 <__udivdi3>:
  801bc8:	55                   	push   %ebp
  801bc9:	57                   	push   %edi
  801bca:	56                   	push   %esi
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 1c             	sub    $0x1c,%esp
  801bcf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bd3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bdb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bdf:	89 ca                	mov    %ecx,%edx
  801be1:	89 f8                	mov    %edi,%eax
  801be3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801be7:	85 f6                	test   %esi,%esi
  801be9:	75 2d                	jne    801c18 <__udivdi3+0x50>
  801beb:	39 cf                	cmp    %ecx,%edi
  801bed:	77 65                	ja     801c54 <__udivdi3+0x8c>
  801bef:	89 fd                	mov    %edi,%ebp
  801bf1:	85 ff                	test   %edi,%edi
  801bf3:	75 0b                	jne    801c00 <__udivdi3+0x38>
  801bf5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfa:	31 d2                	xor    %edx,%edx
  801bfc:	f7 f7                	div    %edi
  801bfe:	89 c5                	mov    %eax,%ebp
  801c00:	31 d2                	xor    %edx,%edx
  801c02:	89 c8                	mov    %ecx,%eax
  801c04:	f7 f5                	div    %ebp
  801c06:	89 c1                	mov    %eax,%ecx
  801c08:	89 d8                	mov    %ebx,%eax
  801c0a:	f7 f5                	div    %ebp
  801c0c:	89 cf                	mov    %ecx,%edi
  801c0e:	89 fa                	mov    %edi,%edx
  801c10:	83 c4 1c             	add    $0x1c,%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5e                   	pop    %esi
  801c15:	5f                   	pop    %edi
  801c16:	5d                   	pop    %ebp
  801c17:	c3                   	ret    
  801c18:	39 ce                	cmp    %ecx,%esi
  801c1a:	77 28                	ja     801c44 <__udivdi3+0x7c>
  801c1c:	0f bd fe             	bsr    %esi,%edi
  801c1f:	83 f7 1f             	xor    $0x1f,%edi
  801c22:	75 40                	jne    801c64 <__udivdi3+0x9c>
  801c24:	39 ce                	cmp    %ecx,%esi
  801c26:	72 0a                	jb     801c32 <__udivdi3+0x6a>
  801c28:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c2c:	0f 87 9e 00 00 00    	ja     801cd0 <__udivdi3+0x108>
  801c32:	b8 01 00 00 00       	mov    $0x1,%eax
  801c37:	89 fa                	mov    %edi,%edx
  801c39:	83 c4 1c             	add    $0x1c,%esp
  801c3c:	5b                   	pop    %ebx
  801c3d:	5e                   	pop    %esi
  801c3e:	5f                   	pop    %edi
  801c3f:	5d                   	pop    %ebp
  801c40:	c3                   	ret    
  801c41:	8d 76 00             	lea    0x0(%esi),%esi
  801c44:	31 ff                	xor    %edi,%edi
  801c46:	31 c0                	xor    %eax,%eax
  801c48:	89 fa                	mov    %edi,%edx
  801c4a:	83 c4 1c             	add    $0x1c,%esp
  801c4d:	5b                   	pop    %ebx
  801c4e:	5e                   	pop    %esi
  801c4f:	5f                   	pop    %edi
  801c50:	5d                   	pop    %ebp
  801c51:	c3                   	ret    
  801c52:	66 90                	xchg   %ax,%ax
  801c54:	89 d8                	mov    %ebx,%eax
  801c56:	f7 f7                	div    %edi
  801c58:	31 ff                	xor    %edi,%edi
  801c5a:	89 fa                	mov    %edi,%edx
  801c5c:	83 c4 1c             	add    $0x1c,%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5e                   	pop    %esi
  801c61:	5f                   	pop    %edi
  801c62:	5d                   	pop    %ebp
  801c63:	c3                   	ret    
  801c64:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c69:	89 eb                	mov    %ebp,%ebx
  801c6b:	29 fb                	sub    %edi,%ebx
  801c6d:	89 f9                	mov    %edi,%ecx
  801c6f:	d3 e6                	shl    %cl,%esi
  801c71:	89 c5                	mov    %eax,%ebp
  801c73:	88 d9                	mov    %bl,%cl
  801c75:	d3 ed                	shr    %cl,%ebp
  801c77:	89 e9                	mov    %ebp,%ecx
  801c79:	09 f1                	or     %esi,%ecx
  801c7b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c7f:	89 f9                	mov    %edi,%ecx
  801c81:	d3 e0                	shl    %cl,%eax
  801c83:	89 c5                	mov    %eax,%ebp
  801c85:	89 d6                	mov    %edx,%esi
  801c87:	88 d9                	mov    %bl,%cl
  801c89:	d3 ee                	shr    %cl,%esi
  801c8b:	89 f9                	mov    %edi,%ecx
  801c8d:	d3 e2                	shl    %cl,%edx
  801c8f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c93:	88 d9                	mov    %bl,%cl
  801c95:	d3 e8                	shr    %cl,%eax
  801c97:	09 c2                	or     %eax,%edx
  801c99:	89 d0                	mov    %edx,%eax
  801c9b:	89 f2                	mov    %esi,%edx
  801c9d:	f7 74 24 0c          	divl   0xc(%esp)
  801ca1:	89 d6                	mov    %edx,%esi
  801ca3:	89 c3                	mov    %eax,%ebx
  801ca5:	f7 e5                	mul    %ebp
  801ca7:	39 d6                	cmp    %edx,%esi
  801ca9:	72 19                	jb     801cc4 <__udivdi3+0xfc>
  801cab:	74 0b                	je     801cb8 <__udivdi3+0xf0>
  801cad:	89 d8                	mov    %ebx,%eax
  801caf:	31 ff                	xor    %edi,%edi
  801cb1:	e9 58 ff ff ff       	jmp    801c0e <__udivdi3+0x46>
  801cb6:	66 90                	xchg   %ax,%ax
  801cb8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cbc:	89 f9                	mov    %edi,%ecx
  801cbe:	d3 e2                	shl    %cl,%edx
  801cc0:	39 c2                	cmp    %eax,%edx
  801cc2:	73 e9                	jae    801cad <__udivdi3+0xe5>
  801cc4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cc7:	31 ff                	xor    %edi,%edi
  801cc9:	e9 40 ff ff ff       	jmp    801c0e <__udivdi3+0x46>
  801cce:	66 90                	xchg   %ax,%ax
  801cd0:	31 c0                	xor    %eax,%eax
  801cd2:	e9 37 ff ff ff       	jmp    801c0e <__udivdi3+0x46>
  801cd7:	90                   	nop

00801cd8 <__umoddi3>:
  801cd8:	55                   	push   %ebp
  801cd9:	57                   	push   %edi
  801cda:	56                   	push   %esi
  801cdb:	53                   	push   %ebx
  801cdc:	83 ec 1c             	sub    $0x1c,%esp
  801cdf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ce3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ce7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ceb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cf3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cf7:	89 f3                	mov    %esi,%ebx
  801cf9:	89 fa                	mov    %edi,%edx
  801cfb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cff:	89 34 24             	mov    %esi,(%esp)
  801d02:	85 c0                	test   %eax,%eax
  801d04:	75 1a                	jne    801d20 <__umoddi3+0x48>
  801d06:	39 f7                	cmp    %esi,%edi
  801d08:	0f 86 a2 00 00 00    	jbe    801db0 <__umoddi3+0xd8>
  801d0e:	89 c8                	mov    %ecx,%eax
  801d10:	89 f2                	mov    %esi,%edx
  801d12:	f7 f7                	div    %edi
  801d14:	89 d0                	mov    %edx,%eax
  801d16:	31 d2                	xor    %edx,%edx
  801d18:	83 c4 1c             	add    $0x1c,%esp
  801d1b:	5b                   	pop    %ebx
  801d1c:	5e                   	pop    %esi
  801d1d:	5f                   	pop    %edi
  801d1e:	5d                   	pop    %ebp
  801d1f:	c3                   	ret    
  801d20:	39 f0                	cmp    %esi,%eax
  801d22:	0f 87 ac 00 00 00    	ja     801dd4 <__umoddi3+0xfc>
  801d28:	0f bd e8             	bsr    %eax,%ebp
  801d2b:	83 f5 1f             	xor    $0x1f,%ebp
  801d2e:	0f 84 ac 00 00 00    	je     801de0 <__umoddi3+0x108>
  801d34:	bf 20 00 00 00       	mov    $0x20,%edi
  801d39:	29 ef                	sub    %ebp,%edi
  801d3b:	89 fe                	mov    %edi,%esi
  801d3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d41:	89 e9                	mov    %ebp,%ecx
  801d43:	d3 e0                	shl    %cl,%eax
  801d45:	89 d7                	mov    %edx,%edi
  801d47:	89 f1                	mov    %esi,%ecx
  801d49:	d3 ef                	shr    %cl,%edi
  801d4b:	09 c7                	or     %eax,%edi
  801d4d:	89 e9                	mov    %ebp,%ecx
  801d4f:	d3 e2                	shl    %cl,%edx
  801d51:	89 14 24             	mov    %edx,(%esp)
  801d54:	89 d8                	mov    %ebx,%eax
  801d56:	d3 e0                	shl    %cl,%eax
  801d58:	89 c2                	mov    %eax,%edx
  801d5a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d5e:	d3 e0                	shl    %cl,%eax
  801d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d64:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d68:	89 f1                	mov    %esi,%ecx
  801d6a:	d3 e8                	shr    %cl,%eax
  801d6c:	09 d0                	or     %edx,%eax
  801d6e:	d3 eb                	shr    %cl,%ebx
  801d70:	89 da                	mov    %ebx,%edx
  801d72:	f7 f7                	div    %edi
  801d74:	89 d3                	mov    %edx,%ebx
  801d76:	f7 24 24             	mull   (%esp)
  801d79:	89 c6                	mov    %eax,%esi
  801d7b:	89 d1                	mov    %edx,%ecx
  801d7d:	39 d3                	cmp    %edx,%ebx
  801d7f:	0f 82 87 00 00 00    	jb     801e0c <__umoddi3+0x134>
  801d85:	0f 84 91 00 00 00    	je     801e1c <__umoddi3+0x144>
  801d8b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d8f:	29 f2                	sub    %esi,%edx
  801d91:	19 cb                	sbb    %ecx,%ebx
  801d93:	89 d8                	mov    %ebx,%eax
  801d95:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d99:	d3 e0                	shl    %cl,%eax
  801d9b:	89 e9                	mov    %ebp,%ecx
  801d9d:	d3 ea                	shr    %cl,%edx
  801d9f:	09 d0                	or     %edx,%eax
  801da1:	89 e9                	mov    %ebp,%ecx
  801da3:	d3 eb                	shr    %cl,%ebx
  801da5:	89 da                	mov    %ebx,%edx
  801da7:	83 c4 1c             	add    $0x1c,%esp
  801daa:	5b                   	pop    %ebx
  801dab:	5e                   	pop    %esi
  801dac:	5f                   	pop    %edi
  801dad:	5d                   	pop    %ebp
  801dae:	c3                   	ret    
  801daf:	90                   	nop
  801db0:	89 fd                	mov    %edi,%ebp
  801db2:	85 ff                	test   %edi,%edi
  801db4:	75 0b                	jne    801dc1 <__umoddi3+0xe9>
  801db6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbb:	31 d2                	xor    %edx,%edx
  801dbd:	f7 f7                	div    %edi
  801dbf:	89 c5                	mov    %eax,%ebp
  801dc1:	89 f0                	mov    %esi,%eax
  801dc3:	31 d2                	xor    %edx,%edx
  801dc5:	f7 f5                	div    %ebp
  801dc7:	89 c8                	mov    %ecx,%eax
  801dc9:	f7 f5                	div    %ebp
  801dcb:	89 d0                	mov    %edx,%eax
  801dcd:	e9 44 ff ff ff       	jmp    801d16 <__umoddi3+0x3e>
  801dd2:	66 90                	xchg   %ax,%ax
  801dd4:	89 c8                	mov    %ecx,%eax
  801dd6:	89 f2                	mov    %esi,%edx
  801dd8:	83 c4 1c             	add    $0x1c,%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5f                   	pop    %edi
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    
  801de0:	3b 04 24             	cmp    (%esp),%eax
  801de3:	72 06                	jb     801deb <__umoddi3+0x113>
  801de5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801de9:	77 0f                	ja     801dfa <__umoddi3+0x122>
  801deb:	89 f2                	mov    %esi,%edx
  801ded:	29 f9                	sub    %edi,%ecx
  801def:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801df3:	89 14 24             	mov    %edx,(%esp)
  801df6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dfa:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dfe:	8b 14 24             	mov    (%esp),%edx
  801e01:	83 c4 1c             	add    $0x1c,%esp
  801e04:	5b                   	pop    %ebx
  801e05:	5e                   	pop    %esi
  801e06:	5f                   	pop    %edi
  801e07:	5d                   	pop    %ebp
  801e08:	c3                   	ret    
  801e09:	8d 76 00             	lea    0x0(%esi),%esi
  801e0c:	2b 04 24             	sub    (%esp),%eax
  801e0f:	19 fa                	sbb    %edi,%edx
  801e11:	89 d1                	mov    %edx,%ecx
  801e13:	89 c6                	mov    %eax,%esi
  801e15:	e9 71 ff ff ff       	jmp    801d8b <__umoddi3+0xb3>
  801e1a:	66 90                	xchg   %ax,%ax
  801e1c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e20:	72 ea                	jb     801e0c <__umoddi3+0x134>
  801e22:	89 d9                	mov    %ebx,%ecx
  801e24:	e9 62 ff ff ff       	jmp    801d8b <__umoddi3+0xb3>
