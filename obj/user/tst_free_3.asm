
obj/user/tst_free_3:     file format elf32-i386


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
  800031:	e8 3e 14 00 00       	call   801474 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

#define numOfAccessesFor3MB 7
#define numOfAccessesFor8MB 4
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 7c 01 00 00    	sub    $0x17c,%esp



	int Mega = 1024*1024;
  800044:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)
	int kilo = 1024;
  80004b:	c7 45 d0 00 04 00 00 	movl   $0x400,-0x30(%ebp)
	char minByte = 1<<7;
  800052:	c6 45 cf 80          	movb   $0x80,-0x31(%ebp)
	char maxByte = 0x7F;
  800056:	c6 45 ce 7f          	movb   $0x7f,-0x32(%ebp)
	short minShort = 1<<15 ;
  80005a:	66 c7 45 cc 00 80    	movw   $0x8000,-0x34(%ebp)
	short maxShort = 0x7FFF;
  800060:	66 c7 45 ca ff 7f    	movw   $0x7fff,-0x36(%ebp)
	int minInt = 1<<31 ;
  800066:	c7 45 c4 00 00 00 80 	movl   $0x80000000,-0x3c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006d:	c7 45 c0 ff ff ff 7f 	movl   $0x7fffffff,-0x40(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	6a 00                	push   $0x0
  800079:	e8 a2 25 00 00       	call   802620 <malloc>
  80007e:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800081:	a1 20 60 80 00       	mov    0x806020,%eax
  800086:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  80008c:	8b 00                	mov    (%eax),%eax
  80008e:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800091:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800099:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80009e:	74 14                	je     8000b4 <_main+0x7c>
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 e0 4e 80 00       	push   $0x804ee0
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 21 4f 80 00       	push   $0x804f21
  8000af:	e8 ff 14 00 00       	call   8015b3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000b4:	a1 20 60 80 00       	mov    0x806020,%eax
  8000b9:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8000bf:	83 c0 18             	add    $0x18,%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8000c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8000ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000cf:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 e0 4e 80 00       	push   $0x804ee0
  8000de:	6a 21                	push   $0x21
  8000e0:	68 21 4f 80 00       	push   $0x804f21
  8000e5:	e8 c9 14 00 00       	call   8015b3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ea:	a1 20 60 80 00       	mov    0x806020,%eax
  8000ef:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8000f5:	83 c0 30             	add    $0x30,%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000fd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800105:	3d 00 20 20 00       	cmp    $0x202000,%eax
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 e0 4e 80 00       	push   $0x804ee0
  800114:	6a 22                	push   $0x22
  800116:	68 21 4f 80 00       	push   $0x804f21
  80011b:	e8 93 14 00 00       	call   8015b3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800120:	a1 20 60 80 00       	mov    0x806020,%eax
  800125:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  80012b:	83 c0 48             	add    $0x48,%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800133:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800136:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80013b:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 e0 4e 80 00       	push   $0x804ee0
  80014a:	6a 23                	push   $0x23
  80014c:	68 21 4f 80 00       	push   $0x804f21
  800151:	e8 5d 14 00 00       	call   8015b3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800156:	a1 20 60 80 00       	mov    0x806020,%eax
  80015b:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800161:	83 c0 60             	add    $0x60,%eax
  800164:	8b 00                	mov    (%eax),%eax
  800166:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800169:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80016c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800171:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800176:	74 14                	je     80018c <_main+0x154>
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	68 e0 4e 80 00       	push   $0x804ee0
  800180:	6a 24                	push   $0x24
  800182:	68 21 4f 80 00       	push   $0x804f21
  800187:	e8 27 14 00 00       	call   8015b3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80018c:	a1 20 60 80 00       	mov    0x806020,%eax
  800191:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800197:	83 c0 78             	add    $0x78,%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80019f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a7:	3d 00 50 20 00       	cmp    $0x205000,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 e0 4e 80 00       	push   $0x804ee0
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 21 4f 80 00       	push   $0x804f21
  8001bd:	e8 f1 13 00 00       	call   8015b3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001c2:	a1 20 60 80 00       	mov    0x806020,%eax
  8001c7:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8001cd:	05 90 00 00 00       	add    $0x90,%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8001d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001df:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001e4:	74 14                	je     8001fa <_main+0x1c2>
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	68 e0 4e 80 00       	push   $0x804ee0
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 21 4f 80 00       	push   $0x804f21
  8001f5:	e8 b9 13 00 00       	call   8015b3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001fa:	a1 20 60 80 00       	mov    0x806020,%eax
  8001ff:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800205:	05 a8 00 00 00       	add    $0xa8,%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80020f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800212:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800217:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80021c:	74 14                	je     800232 <_main+0x1fa>
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 e0 4e 80 00       	push   $0x804ee0
  800226:	6a 27                	push   $0x27
  800228:	68 21 4f 80 00       	push   $0x804f21
  80022d:	e8 81 13 00 00       	call   8015b3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800232:	a1 20 60 80 00       	mov    0x806020,%eax
  800237:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  80023d:	05 c0 00 00 00       	add    $0xc0,%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800247:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80024a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 e0 4e 80 00       	push   $0x804ee0
  80025e:	6a 28                	push   $0x28
  800260:	68 21 4f 80 00       	push   $0x804f21
  800265:	e8 49 13 00 00       	call   8015b3 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026a:	a1 20 60 80 00       	mov    0x806020,%eax
  80026f:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800275:	05 d8 00 00 00       	add    $0xd8,%eax
  80027a:	8b 00                	mov    (%eax),%eax
  80027c:	89 45 98             	mov    %eax,-0x68(%ebp)
  80027f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800282:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800287:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 e0 4e 80 00       	push   $0x804ee0
  800296:	6a 29                	push   $0x29
  800298:	68 21 4f 80 00       	push   $0x804f21
  80029d:	e8 11 13 00 00       	call   8015b3 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8002a7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 34 4f 80 00       	push   $0x804f34
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 21 4f 80 00       	push   $0x804f21
  8002c0:	e8 ee 12 00 00       	call   8015b3 <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 93 29 00 00       	call   802c5d <sys_calculate_free_frames>
  8002ca:	89 45 94             	mov    %eax,-0x6c(%ebp)

	int indicesOf3MB[numOfAccessesFor3MB];
	int indicesOf8MB[numOfAccessesFor8MB];
	int var, i, j;

	void* ptr_allocations[20] = {0};
  8002cd:	8d 95 80 fe ff ff    	lea    -0x180(%ebp),%edx
  8002d3:	b9 14 00 00 00       	mov    $0x14,%ecx
  8002d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dd:	89 d7                	mov    %edx,%edi
  8002df:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		/*ALLOCATE 2 MB*/
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002e1:	e8 c2 29 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  8002e6:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8002e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	50                   	push   %eax
  8002f5:	e8 26 23 00 00       	call   802620 <malloc>
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800303:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	79 0d                	jns    80031a <_main+0x2e2>
  80030d:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800313:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800318:	76 14                	jbe    80032e <_main+0x2f6>
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	68 7c 4f 80 00       	push   $0x804f7c
  800322:	6a 39                	push   $0x39
  800324:	68 21 4f 80 00       	push   $0x804f21
  800329:	e8 85 12 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 75 29 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 e4 4f 80 00       	push   $0x804fe4
  800345:	6a 3a                	push   $0x3a
  800347:	68 21 4f 80 00       	push   $0x804f21
  80034c:	e8 62 12 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 52 29 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800356:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035c:	89 c2                	mov    %eax,%edx
  80035e:	01 d2                	add    %edx,%edx
  800360:	01 d0                	add    %edx,%eax
  800362:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	50                   	push   %eax
  800369:	e8 b2 22 00 00       	call   802620 <malloc>
  80036e:	83 c4 10             	add    $0x10,%esp
  800371:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800377:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80037d:	89 c2                	mov    %eax,%edx
  80037f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	05 00 00 00 80       	add    $0x80000000,%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	72 16                	jb     8003a3 <_main+0x36b>
  80038d:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800393:	89 c2                	mov    %eax,%edx
  800395:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80039f:	39 c2                	cmp    %eax,%edx
  8003a1:	76 14                	jbe    8003b7 <_main+0x37f>
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	68 7c 4f 80 00       	push   $0x804f7c
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 21 4f 80 00       	push   $0x804f21
  8003b2:	e8 fc 11 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 ec 28 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  8003bc:	2b 45 90             	sub    -0x70(%ebp),%eax
  8003bf:	89 c2                	mov    %eax,%edx
  8003c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c4:	89 c1                	mov    %eax,%ecx
  8003c6:	01 c9                	add    %ecx,%ecx
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	79 05                	jns    8003d3 <_main+0x39b>
  8003ce:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003d3:	c1 f8 0c             	sar    $0xc,%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 e4 4f 80 00       	push   $0x804fe4
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 21 4f 80 00       	push   $0x804f21
  8003e9:	e8 c5 11 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 b5 28 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  8003f3:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(8*Mega-kilo);
  8003f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f9:	c1 e0 03             	shl    $0x3,%eax
  8003fc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8003ff:	83 ec 0c             	sub    $0xc,%esp
  800402:	50                   	push   %eax
  800403:	e8 18 22 00 00       	call   802620 <malloc>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 5*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 5*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800411:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800417:	89 c1                	mov    %eax,%ecx
  800419:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	c1 e0 02             	shl    $0x2,%eax
  800421:	01 d0                	add    %edx,%eax
  800423:	05 00 00 00 80       	add    $0x80000000,%eax
  800428:	39 c1                	cmp    %eax,%ecx
  80042a:	72 1b                	jb     800447 <_main+0x40f>
  80042c:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800432:	89 c1                	mov    %eax,%ecx
  800434:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800437:	89 d0                	mov    %edx,%eax
  800439:	c1 e0 02             	shl    $0x2,%eax
  80043c:	01 d0                	add    %edx,%eax
  80043e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800443:	39 c1                	cmp    %eax,%ecx
  800445:	76 14                	jbe    80045b <_main+0x423>
  800447:	83 ec 04             	sub    $0x4,%esp
  80044a:	68 7c 4f 80 00       	push   $0x804f7c
  80044f:	6a 47                	push   $0x47
  800451:	68 21 4f 80 00       	push   $0x804f21
  800456:	e8 58 11 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 48 28 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800460:	2b 45 90             	sub    -0x70(%ebp),%eax
  800463:	89 c2                	mov    %eax,%edx
  800465:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800468:	c1 e0 03             	shl    $0x3,%eax
  80046b:	85 c0                	test   %eax,%eax
  80046d:	79 05                	jns    800474 <_main+0x43c>
  80046f:	05 ff 0f 00 00       	add    $0xfff,%eax
  800474:	c1 f8 0c             	sar    $0xc,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 e4 4f 80 00       	push   $0x804fe4
  800483:	6a 48                	push   $0x48
  800485:	68 21 4f 80 00       	push   $0x804f21
  80048a:	e8 24 11 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 14 28 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800494:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(7*Mega-kilo);
  800497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80049a:	89 d0                	mov    %edx,%eax
  80049c:	01 c0                	add    %eax,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	01 c0                	add    %eax,%eax
  8004a2:	01 d0                	add    %edx,%eax
  8004a4:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8004a7:	83 ec 0c             	sub    $0xc,%esp
  8004aa:	50                   	push   %eax
  8004ab:	e8 70 21 00 00       	call   802620 <malloc>
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 13*Mega) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 13*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8004b9:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004bf:	89 c1                	mov    %eax,%ecx
  8004c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004c4:	89 d0                	mov    %edx,%eax
  8004c6:	01 c0                	add    %eax,%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	c1 e0 02             	shl    $0x2,%eax
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	05 00 00 00 80       	add    $0x80000000,%eax
  8004d4:	39 c1                	cmp    %eax,%ecx
  8004d6:	72 1f                	jb     8004f7 <_main+0x4bf>
  8004d8:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004de:	89 c1                	mov    %eax,%ecx
  8004e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004e3:	89 d0                	mov    %edx,%eax
  8004e5:	01 c0                	add    %eax,%eax
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	c1 e0 02             	shl    $0x2,%eax
  8004ec:	01 d0                	add    %edx,%eax
  8004ee:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8004f3:	39 c1                	cmp    %eax,%ecx
  8004f5:	76 14                	jbe    80050b <_main+0x4d3>
  8004f7:	83 ec 04             	sub    $0x4,%esp
  8004fa:	68 7c 4f 80 00       	push   $0x804f7c
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 21 4f 80 00       	push   $0x804f21
  800506:	e8 a8 10 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 98 27 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800510:	2b 45 90             	sub    -0x70(%ebp),%eax
  800513:	89 c1                	mov    %eax,%ecx
  800515:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	01 c0                	add    %eax,%eax
  800520:	01 d0                	add    %edx,%eax
  800522:	85 c0                	test   %eax,%eax
  800524:	79 05                	jns    80052b <_main+0x4f3>
  800526:	05 ff 0f 00 00       	add    $0xfff,%eax
  80052b:	c1 f8 0c             	sar    $0xc,%eax
  80052e:	39 c1                	cmp    %eax,%ecx
  800530:	74 14                	je     800546 <_main+0x50e>
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	68 e4 4f 80 00       	push   $0x804fe4
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 21 4f 80 00       	push   $0x804f21
  800541:	e8 6d 10 00 00       	call   8015b3 <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 12 27 00 00       	call   802c5d <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 23 27 00 00       	call   802c76 <sys_calculate_modified_frames>
  800553:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
  800556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800559:	89 c2                	mov    %eax,%edx
  80055b:	01 d2                	add    %edx,%edx
  80055d:	01 d0                	add    %edx,%eax
  80055f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800562:	48                   	dec    %eax
  800563:	89 45 84             	mov    %eax,-0x7c(%ebp)
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
  800566:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800569:	bf 07 00 00 00       	mov    $0x7,%edi
  80056e:	99                   	cltd   
  80056f:	f7 ff                	idiv   %edi
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800574:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80057b:	eb 16                	jmp    800593 <_main+0x55b>
		{
			indicesOf3MB[var] = var * inc ;
  80057d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800580:	0f af 45 80          	imul   -0x80(%ebp),%eax
  800584:	89 c2                	mov    %eax,%edx
  800586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800589:	89 94 85 e0 fe ff ff 	mov    %edx,-0x120(%ebp,%eax,4)
		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
		int modFrames = sys_calculate_modified_frames();
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800590:	ff 45 e4             	incl   -0x1c(%ebp)
  800593:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800597:	7e e4                	jle    80057d <_main+0x545>
		{
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
  800599:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80059f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		//3 reads
		int sum = 0;
  8005a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005b3:	eb 1f                	jmp    8005d4 <_main+0x59c>
		{
			sum += byteArr[indicesOf3MB[var]] ;
  8005b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b8:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005bf:	89 c2                	mov    %eax,%edx
  8005c1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005c7:	01 d0                	add    %edx,%eax
  8005c9:	8a 00                	mov    (%eax),%al
  8005cb:	0f be c0             	movsbl %al,%eax
  8005ce:	01 45 dc             	add    %eax,-0x24(%ebp)
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
		//3 reads
		int sum = 0;
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005d1:	ff 45 e4             	incl   -0x1c(%ebp)
  8005d4:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  8005d8:	7e db                	jle    8005b5 <_main+0x57d>
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005da:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  8005e1:	eb 1c                	jmp    8005ff <_main+0x5c7>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
  8005e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005e6:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005ed:	89 c2                	mov    %eax,%edx
  8005ef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f5:	01 c2                	add    %eax,%edx
  8005f7:	8a 45 ce             	mov    -0x32(%ebp),%al
  8005fa:	88 02                	mov    %al,(%edx)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005fc:	ff 45 e4             	incl   -0x1c(%ebp)
  8005ff:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800603:	7e de                	jle    8005e3 <_main+0x5ab>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800605:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800608:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	89 c6                	mov    %eax,%esi
  80060f:	e8 49 26 00 00       	call   802c5d <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 5b 26 00 00       	call   802c76 <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 14 50 80 00       	push   $0x805014
  80062e:	6a 67                	push   $0x67
  800630:	68 21 4f 80 00       	push   $0x804f21
  800635:	e8 79 0f 00 00       	call   8015b3 <_panic>
		int found = 0;
  80063a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800641:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800648:	eb 7b                	jmp    8006c5 <_main+0x68d>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80064a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800651:	eb 5d                	jmp    8006b0 <_main+0x678>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  800653:	a1 20 60 80 00       	mov    0x806020,%eax
  800658:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80065e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800661:	89 d0                	mov    %edx,%eax
  800663:	01 c0                	add    %eax,%eax
  800665:	01 d0                	add    %edx,%eax
  800667:	c1 e0 03             	shl    $0x3,%eax
  80066a:	01 c8                	add    %ecx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800674:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80067a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80067f:	89 c2                	mov    %eax,%edx
  800681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800684:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  80068b:	89 c1                	mov    %eax,%ecx
  80068d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800693:	01 c8                	add    %ecx,%eax
  800695:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  80069b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	75 03                	jne    8006ad <_main+0x675>
				{
					found++;
  8006aa:	ff 45 d8             	incl   -0x28(%ebp)
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8006ad:	ff 45 e0             	incl   -0x20(%ebp)
  8006b0:	a1 20 60 80 00       	mov    0x806020,%eax
  8006b5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8006bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006be:	39 c2                	cmp    %eax,%edx
  8006c0:	77 91                	ja     800653 <_main+0x61b>
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  8006c2:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c5:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8006c9:	0f 8e 7b ff ff ff    	jle    80064a <_main+0x612>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor3MB) panic("malloc: page is not added to WS");
  8006cf:	83 7d d8 07          	cmpl   $0x7,-0x28(%ebp)
  8006d3:	74 14                	je     8006e9 <_main+0x6b1>
  8006d5:	83 ec 04             	sub    $0x4,%esp
  8006d8:	68 58 50 80 00       	push   $0x805058
  8006dd:	6a 73                	push   $0x73
  8006df:	68 21 4f 80 00       	push   $0x804f21
  8006e4:	e8 ca 0e 00 00       	call   8015b3 <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e9:	e8 6f 25 00 00       	call   802c5d <sys_calculate_free_frames>
  8006ee:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006f1:	e8 80 25 00 00       	call   802c76 <sys_calculate_modified_frames>
  8006f6:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfShort = (8*Mega-kilo)/sizeof(short) - 1;
  8006f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006fc:	c1 e0 03             	shl    $0x3,%eax
  8006ff:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800702:	d1 e8                	shr    %eax
  800704:	48                   	dec    %eax
  800705:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		indicesOf8MB[0] = lastIndexOfShort * 1 / 2;
  80070b:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800711:	89 c2                	mov    %eax,%edx
  800713:	c1 ea 1f             	shr    $0x1f,%edx
  800716:	01 d0                	add    %edx,%eax
  800718:	d1 f8                	sar    %eax
  80071a:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
		indicesOf8MB[1] = lastIndexOfShort * 2 / 3;
  800720:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800726:	01 c0                	add    %eax,%eax
  800728:	89 c1                	mov    %eax,%ecx
  80072a:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80072f:	f7 e9                	imul   %ecx
  800731:	c1 f9 1f             	sar    $0x1f,%ecx
  800734:	89 d0                	mov    %edx,%eax
  800736:	29 c8                	sub    %ecx,%eax
  800738:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
		indicesOf8MB[2] = lastIndexOfShort * 3 / 4;
  80073e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800744:	89 c2                	mov    %eax,%edx
  800746:	01 d2                	add    %edx,%edx
  800748:	01 d0                	add    %edx,%eax
  80074a:	85 c0                	test   %eax,%eax
  80074c:	79 03                	jns    800751 <_main+0x719>
  80074e:	83 c0 03             	add    $0x3,%eax
  800751:	c1 f8 02             	sar    $0x2,%eax
  800754:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
		indicesOf8MB[3] = lastIndexOfShort ;
  80075a:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800760:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)

		//use one of the read pages from 3 MB to avoid victimizing it
		sum += byteArr[indicesOf3MB[0]] ;
  800766:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  80076c:	89 c2                	mov    %eax,%edx
  80076e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800774:	01 d0                	add    %edx,%eax
  800776:	8a 00                	mov    (%eax),%al
  800778:	0f be c0             	movsbl %al,%eax
  80077b:	01 45 dc             	add    %eax,-0x24(%ebp)

		shortArr = (short *) ptr_allocations[2];
  80077e:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800784:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		//2 reads
		sum = 0;
  80078a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  800791:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800798:	eb 20                	jmp    8007ba <_main+0x782>
		{
			sum += shortArr[indicesOf8MB[var]] ;
  80079a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80079d:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007ae:	01 d0                	add    %edx,%eax
  8007b0:	66 8b 00             	mov    (%eax),%ax
  8007b3:	98                   	cwtl   
  8007b4:	01 45 dc             	add    %eax,-0x24(%ebp)
		sum += byteArr[indicesOf3MB[0]] ;

		shortArr = (short *) ptr_allocations[2];
		//2 reads
		sum = 0;
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  8007b7:	ff 45 e4             	incl   -0x1c(%ebp)
  8007ba:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8007be:	7e da                	jle    80079a <_main+0x762>
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007c0:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  8007c7:	eb 20                	jmp    8007e9 <_main+0x7b1>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
  8007c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007cc:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  8007d3:	01 c0                	add    %eax,%eax
  8007d5:	89 c2                	mov    %eax,%edx
  8007d7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007dd:	01 c2                	add    %eax,%edx
  8007df:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  8007e3:	66 89 02             	mov    %ax,(%edx)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007e6:	ff 45 e4             	incl   -0x1c(%ebp)
  8007e9:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8007ed:	7e da                	jle    8007c9 <_main+0x791>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007ef:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8007f2:	e8 66 24 00 00       	call   802c5d <sys_calculate_free_frames>
  8007f7:	29 c3                	sub    %eax,%ebx
  8007f9:	89 d8                	mov    %ebx,%eax
  8007fb:	83 f8 04             	cmp    $0x4,%eax
  8007fe:	74 17                	je     800817 <_main+0x7df>
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	68 14 50 80 00       	push   $0x805014
  800808:	68 8e 00 00 00       	push   $0x8e
  80080d:	68 21 4f 80 00       	push   $0x804f21
  800812:	e8 9c 0d 00 00       	call   8015b3 <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800817:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  80081a:	e8 57 24 00 00       	call   802c76 <sys_calculate_modified_frames>
  80081f:	29 c3                	sub    %eax,%ebx
  800821:	89 d8                	mov    %ebx,%eax
  800823:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800826:	74 17                	je     80083f <_main+0x807>
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 14 50 80 00       	push   $0x805014
  800830:	68 8f 00 00 00       	push   $0x8f
  800835:	68 21 4f 80 00       	push   $0x804f21
  80083a:	e8 74 0d 00 00       	call   8015b3 <_panic>
		found = 0;
  80083f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  800846:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80084d:	eb 7d                	jmp    8008cc <_main+0x894>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80084f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800856:	eb 5f                	jmp    8008b7 <_main+0x87f>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[indicesOf8MB[var]])), PAGE_SIZE))
  800858:	a1 20 60 80 00       	mov    0x806020,%eax
  80085d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800863:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800866:	89 d0                	mov    %edx,%eax
  800868:	01 c0                	add    %eax,%eax
  80086a:	01 d0                	add    %edx,%eax
  80086c:	c1 e0 03             	shl    $0x3,%eax
  80086f:	01 c8                	add    %ecx,%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800879:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80087f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800884:	89 c2                	mov    %eax,%edx
  800886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800889:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  800890:	01 c0                	add    %eax,%eax
  800892:	89 c1                	mov    %eax,%ecx
  800894:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80089a:	01 c8                	add    %ecx,%eax
  80089c:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  8008a2:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8008a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008ad:	39 c2                	cmp    %eax,%edx
  8008af:	75 03                	jne    8008b4 <_main+0x87c>
				{
					found++;
  8008b1:	ff 45 d8             	incl   -0x28(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8008b4:	ff 45 e0             	incl   -0x20(%ebp)
  8008b7:	a1 20 60 80 00       	mov    0x806020,%eax
  8008bc:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8008c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	77 8f                	ja     800858 <_main+0x820>
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  8008c9:	ff 45 e4             	incl   -0x1c(%ebp)
  8008cc:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8008d0:	0f 8e 79 ff ff ff    	jle    80084f <_main+0x817>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor8MB) panic("malloc: page is not added to WS");
  8008d6:	83 7d d8 04          	cmpl   $0x4,-0x28(%ebp)
  8008da:	74 17                	je     8008f3 <_main+0x8bb>
  8008dc:	83 ec 04             	sub    $0x4,%esp
  8008df:	68 58 50 80 00       	push   $0x805058
  8008e4:	68 9b 00 00 00       	push   $0x9b
  8008e9:	68 21 4f 80 00       	push   $0x804f21
  8008ee:	e8 c0 0c 00 00       	call   8015b3 <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008f3:	e8 65 23 00 00       	call   802c5d <sys_calculate_free_frames>
  8008f8:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008fb:	e8 76 23 00 00       	call   802c76 <sys_calculate_modified_frames>
  800900:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800903:	e8 a0 23 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800908:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  80090b:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800911:	83 ec 0c             	sub    $0xc,%esp
  800914:	50                   	push   %eax
  800915:	e8 25 1f 00 00       	call   80283f <free>
  80091a:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80091d:	e8 86 23 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800922:	8b 55 90             	mov    -0x70(%ebp),%edx
  800925:	89 d1                	mov    %edx,%ecx
  800927:	29 c1                	sub    %eax,%ecx
  800929:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80092c:	89 c2                	mov    %eax,%edx
  80092e:	01 d2                	add    %edx,%edx
  800930:	01 d0                	add    %edx,%eax
  800932:	85 c0                	test   %eax,%eax
  800934:	79 05                	jns    80093b <_main+0x903>
  800936:	05 ff 0f 00 00       	add    $0xfff,%eax
  80093b:	c1 f8 0c             	sar    $0xc,%eax
  80093e:	39 c1                	cmp    %eax,%ecx
  800940:	74 17                	je     800959 <_main+0x921>
  800942:	83 ec 04             	sub    $0x4,%esp
  800945:	68 78 50 80 00       	push   $0x805078
  80094a:	68 a5 00 00 00       	push   $0xa5
  80094f:	68 21 4f 80 00       	push   $0x804f21
  800954:	e8 5a 0c 00 00       	call   8015b3 <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  800959:	e8 ff 22 00 00       	call   802c5d <sys_calculate_free_frames>
  80095e:	89 c2                	mov    %eax,%edx
  800960:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800963:	29 c2                	sub    %eax,%edx
  800965:	89 d0                	mov    %edx,%eax
  800967:	83 f8 07             	cmp    $0x7,%eax
  80096a:	74 17                	je     800983 <_main+0x94b>
  80096c:	83 ec 04             	sub    $0x4,%esp
  80096f:	68 b4 50 80 00       	push   $0x8050b4
  800974:	68 a7 00 00 00       	push   $0xa7
  800979:	68 21 4f 80 00       	push   $0x804f21
  80097e:	e8 30 0c 00 00       	call   8015b3 <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800983:	e8 ee 22 00 00       	call   802c76 <sys_calculate_modified_frames>
  800988:	89 c2                	mov    %eax,%edx
  80098a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80098d:	29 c2                	sub    %eax,%edx
  80098f:	89 d0                	mov    %edx,%eax
  800991:	83 f8 02             	cmp    $0x2,%eax
  800994:	74 17                	je     8009ad <_main+0x975>
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	68 08 51 80 00       	push   $0x805108
  80099e:	68 a8 00 00 00       	push   $0xa8
  8009a3:	68 21 4f 80 00       	push   $0x804f21
  8009a8:	e8 06 0c 00 00       	call   8015b3 <_panic>
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  8009ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8009b4:	e9 93 00 00 00       	jmp    800a4c <_main+0xa14>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8009b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009c0:	eb 71                	jmp    800a33 <_main+0x9fb>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  8009c2:	a1 20 60 80 00       	mov    0x806020,%eax
  8009c7:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8009cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d0:	89 d0                	mov    %edx,%eax
  8009d2:	01 c0                	add    %eax,%eax
  8009d4:	01 d0                	add    %edx,%eax
  8009d6:	c1 e0 03             	shl    $0x3,%eax
  8009d9:	01 c8                	add    %ecx,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8009e3:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8009e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009ee:	89 c2                	mov    %eax,%edx
  8009f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009f3:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8009fa:	89 c1                	mov    %eax,%ecx
  8009fc:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800a02:	01 c8                	add    %ecx,%eax
  800a04:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800a0a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a15:	39 c2                	cmp    %eax,%edx
  800a17:	75 17                	jne    800a30 <_main+0x9f8>
				{
					panic("free: page is not removed from WS");
  800a19:	83 ec 04             	sub    $0x4,%esp
  800a1c:	68 40 51 80 00       	push   $0x805140
  800a21:	68 b0 00 00 00       	push   $0xb0
  800a26:	68 21 4f 80 00       	push   $0x804f21
  800a2b:	e8 83 0b 00 00       	call   8015b3 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800a30:	ff 45 e0             	incl   -0x20(%ebp)
  800a33:	a1 20 60 80 00       	mov    0x806020,%eax
  800a38:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800a3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	0f 87 79 ff ff ff    	ja     8009c2 <_main+0x98a>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800a49:	ff 45 e4             	incl   -0x1c(%ebp)
  800a4c:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800a50:	0f 8e 63 ff ff ff    	jle    8009b9 <_main+0x981>
			}
		}



		freeFrames = sys_calculate_free_frames() ;
  800a56:	e8 02 22 00 00       	call   802c5d <sys_calculate_free_frames>
  800a5b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr = (short *) ptr_allocations[2];
  800a5e:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800a64:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800a6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a6d:	01 c0                	add    %eax,%eax
  800a6f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800a72:	d1 e8                	shr    %eax
  800a74:	48                   	dec    %eax
  800a75:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		shortArr[0] = minShort;
  800a7b:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  800a81:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a84:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800a87:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a8d:	01 c0                	add    %eax,%eax
  800a8f:	89 c2                	mov    %eax,%edx
  800a91:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a97:	01 c2                	add    %eax,%edx
  800a99:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  800a9d:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800aa0:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800aa3:	e8 b5 21 00 00       	call   802c5d <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 02             	cmp    $0x2,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 14 50 80 00       	push   $0x805014
  800ab9:	68 bc 00 00 00       	push   $0xbc
  800abe:	68 21 4f 80 00       	push   $0x804f21
  800ac3:	e8 eb 0a 00 00       	call   8015b3 <_panic>
		found = 0;
  800ac8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800acf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ad6:	e9 a7 00 00 00       	jmp    800b82 <_main+0xb4a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800adb:	a1 20 60 80 00       	mov    0x806020,%eax
  800ae0:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800ae6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ae9:	89 d0                	mov    %edx,%eax
  800aeb:	01 c0                	add    %eax,%eax
  800aed:	01 d0                	add    %edx,%eax
  800aef:	c1 e0 03             	shl    $0x3,%eax
  800af2:	01 c8                	add    %ecx,%eax
  800af4:	8b 00                	mov    (%eax),%eax
  800af6:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800afc:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b07:	89 c2                	mov    %eax,%edx
  800b09:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b0f:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b15:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b20:	39 c2                	cmp    %eax,%edx
  800b22:	75 03                	jne    800b27 <_main+0xaef>
				found++;
  800b24:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  800b27:	a1 20 60 80 00       	mov    0x806020,%eax
  800b2c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800b32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b35:	89 d0                	mov    %edx,%eax
  800b37:	01 c0                	add    %eax,%eax
  800b39:	01 d0                	add    %edx,%eax
  800b3b:	c1 e0 03             	shl    $0x3,%eax
  800b3e:	01 c8                	add    %ecx,%eax
  800b40:	8b 00                	mov    (%eax),%eax
  800b42:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b48:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b4e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b53:	89 c2                	mov    %eax,%edx
  800b55:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b5b:	01 c0                	add    %eax,%eax
  800b5d:	89 c1                	mov    %eax,%ecx
  800b5f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b65:	01 c8                	add    %ecx,%eax
  800b67:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b6d:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b78:	39 c2                	cmp    %eax,%edx
  800b7a:	75 03                	jne    800b7f <_main+0xb47>
				found++;
  800b7c:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b7f:	ff 45 e4             	incl   -0x1c(%ebp)
  800b82:	a1 20 60 80 00       	mov    0x806020,%eax
  800b87:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800b8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b90:	39 c2                	cmp    %eax,%edx
  800b92:	0f 87 43 ff ff ff    	ja     800adb <_main+0xaa3>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800b98:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800b9c:	74 17                	je     800bb5 <_main+0xb7d>
  800b9e:	83 ec 04             	sub    $0x4,%esp
  800ba1:	68 58 50 80 00       	push   $0x805058
  800ba6:	68 c5 00 00 00       	push   $0xc5
  800bab:	68 21 4f 80 00       	push   $0x804f21
  800bb0:	e8 fe 09 00 00       	call   8015b3 <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bb5:	e8 ee 20 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800bba:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800bbd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc0:	01 c0                	add    %eax,%eax
  800bc2:	83 ec 0c             	sub    $0xc,%esp
  800bc5:	50                   	push   %eax
  800bc6:	e8 55 1a 00 00       	call   802620 <malloc>
  800bcb:	83 c4 10             	add    $0x10,%esp
  800bce:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800bd4:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bda:	89 c2                	mov    %eax,%edx
  800bdc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bdf:	c1 e0 02             	shl    $0x2,%eax
  800be2:	05 00 00 00 80       	add    $0x80000000,%eax
  800be7:	39 c2                	cmp    %eax,%edx
  800be9:	72 17                	jb     800c02 <_main+0xbca>
  800beb:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bf1:	89 c2                	mov    %eax,%edx
  800bf3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bf6:	c1 e0 02             	shl    $0x2,%eax
  800bf9:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800bfe:	39 c2                	cmp    %eax,%edx
  800c00:	76 17                	jbe    800c19 <_main+0xbe1>
  800c02:	83 ec 04             	sub    $0x4,%esp
  800c05:	68 7c 4f 80 00       	push   $0x804f7c
  800c0a:	68 ca 00 00 00       	push   $0xca
  800c0f:	68 21 4f 80 00       	push   $0x804f21
  800c14:	e8 9a 09 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c19:	e8 8a 20 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800c1e:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c21:	83 f8 01             	cmp    $0x1,%eax
  800c24:	74 17                	je     800c3d <_main+0xc05>
  800c26:	83 ec 04             	sub    $0x4,%esp
  800c29:	68 e4 4f 80 00       	push   $0x804fe4
  800c2e:	68 cb 00 00 00       	push   $0xcb
  800c33:	68 21 4f 80 00       	push   $0x804f21
  800c38:	e8 76 09 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c3d:	e8 1b 20 00 00       	call   802c5d <sys_calculate_free_frames>
  800c42:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr = (int *) ptr_allocations[2];
  800c45:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800c4b:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800c51:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c54:	01 c0                	add    %eax,%eax
  800c56:	c1 e8 02             	shr    $0x2,%eax
  800c59:	48                   	dec    %eax
  800c5a:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
		intArr[0] = minInt;
  800c60:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c66:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800c69:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  800c6b:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c71:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c78:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c7e:	01 c2                	add    %eax,%edx
  800c80:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c83:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800c85:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800c88:	e8 d0 1f 00 00       	call   802c5d <sys_calculate_free_frames>
  800c8d:	29 c3                	sub    %eax,%ebx
  800c8f:	89 d8                	mov    %ebx,%eax
  800c91:	83 f8 02             	cmp    $0x2,%eax
  800c94:	74 17                	je     800cad <_main+0xc75>
  800c96:	83 ec 04             	sub    $0x4,%esp
  800c99:	68 14 50 80 00       	push   $0x805014
  800c9e:	68 d2 00 00 00       	push   $0xd2
  800ca3:	68 21 4f 80 00       	push   $0x804f21
  800ca8:	e8 06 09 00 00       	call   8015b3 <_panic>
		found = 0;
  800cad:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800cb4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800cbb:	e9 aa 00 00 00       	jmp    800d6a <_main+0xd32>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800cc0:	a1 20 60 80 00       	mov    0x806020,%eax
  800cc5:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800ccb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800cce:	89 d0                	mov    %edx,%eax
  800cd0:	01 c0                	add    %eax,%eax
  800cd2:	01 d0                	add    %edx,%eax
  800cd4:	c1 e0 03             	shl    $0x3,%eax
  800cd7:	01 c8                	add    %ecx,%eax
  800cd9:	8b 00                	mov    (%eax),%eax
  800cdb:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800ce1:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800ce7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cec:	89 c2                	mov    %eax,%edx
  800cee:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800cf4:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800cfa:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d05:	39 c2                	cmp    %eax,%edx
  800d07:	75 03                	jne    800d0c <_main+0xcd4>
				found++;
  800d09:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800d0c:	a1 20 60 80 00       	mov    0x806020,%eax
  800d11:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800d17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d1a:	89 d0                	mov    %edx,%eax
  800d1c:	01 c0                	add    %eax,%eax
  800d1e:	01 d0                	add    %edx,%eax
  800d20:	c1 e0 03             	shl    $0x3,%eax
  800d23:	01 c8                	add    %ecx,%eax
  800d25:	8b 00                	mov    (%eax),%eax
  800d27:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d2d:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d38:	89 c2                	mov    %eax,%edx
  800d3a:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d40:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d47:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800d4d:	01 c8                	add    %ecx,%eax
  800d4f:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d55:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d60:	39 c2                	cmp    %eax,%edx
  800d62:	75 03                	jne    800d67 <_main+0xd2f>
				found++;
  800d64:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d67:	ff 45 e4             	incl   -0x1c(%ebp)
  800d6a:	a1 20 60 80 00       	mov    0x806020,%eax
  800d6f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800d75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d78:	39 c2                	cmp    %eax,%edx
  800d7a:	0f 87 40 ff ff ff    	ja     800cc0 <_main+0xc88>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800d80:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800d84:	74 17                	je     800d9d <_main+0xd65>
  800d86:	83 ec 04             	sub    $0x4,%esp
  800d89:	68 58 50 80 00       	push   $0x805058
  800d8e:	68 db 00 00 00       	push   $0xdb
  800d93:	68 21 4f 80 00       	push   $0x804f21
  800d98:	e8 16 08 00 00       	call   8015b3 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d9d:	e8 bb 1e 00 00       	call   802c5d <sys_calculate_free_frames>
  800da2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800da5:	e8 fe 1e 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800daa:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800dad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800db0:	01 c0                	add    %eax,%eax
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	50                   	push   %eax
  800db6:	e8 65 18 00 00       	call   802620 <malloc>
  800dbb:	83 c4 10             	add    $0x10,%esp
  800dbe:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800dc4:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800dca:	89 c2                	mov    %eax,%edx
  800dcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dcf:	c1 e0 02             	shl    $0x2,%eax
  800dd2:	89 c1                	mov    %eax,%ecx
  800dd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800dd7:	c1 e0 02             	shl    $0x2,%eax
  800dda:	01 c8                	add    %ecx,%eax
  800ddc:	05 00 00 00 80       	add    $0x80000000,%eax
  800de1:	39 c2                	cmp    %eax,%edx
  800de3:	72 21                	jb     800e06 <_main+0xdce>
  800de5:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800deb:	89 c2                	mov    %eax,%edx
  800ded:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800df0:	c1 e0 02             	shl    $0x2,%eax
  800df3:	89 c1                	mov    %eax,%ecx
  800df5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800df8:	c1 e0 02             	shl    $0x2,%eax
  800dfb:	01 c8                	add    %ecx,%eax
  800dfd:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800e02:	39 c2                	cmp    %eax,%edx
  800e04:	76 17                	jbe    800e1d <_main+0xde5>
  800e06:	83 ec 04             	sub    $0x4,%esp
  800e09:	68 7c 4f 80 00       	push   $0x804f7c
  800e0e:	68 e1 00 00 00       	push   $0xe1
  800e13:	68 21 4f 80 00       	push   $0x804f21
  800e18:	e8 96 07 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e1d:	e8 86 1e 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800e22:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e25:	83 f8 01             	cmp    $0x1,%eax
  800e28:	74 17                	je     800e41 <_main+0xe09>
  800e2a:	83 ec 04             	sub    $0x4,%esp
  800e2d:	68 e4 4f 80 00       	push   $0x804fe4
  800e32:	68 e2 00 00 00       	push   $0xe2
  800e37:	68 21 4f 80 00       	push   $0x804f21
  800e3c:	e8 72 07 00 00       	call   8015b3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e41:	e8 62 1e 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800e46:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800e49:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e4c:	89 d0                	mov    %edx,%eax
  800e4e:	01 c0                	add    %eax,%eax
  800e50:	01 d0                	add    %edx,%eax
  800e52:	01 c0                	add    %eax,%eax
  800e54:	01 d0                	add    %edx,%eax
  800e56:	83 ec 0c             	sub    $0xc,%esp
  800e59:	50                   	push   %eax
  800e5a:	e8 c1 17 00 00       	call   802620 <malloc>
  800e5f:	83 c4 10             	add    $0x10,%esp
  800e62:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800e68:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e6e:	89 c2                	mov    %eax,%edx
  800e70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e73:	c1 e0 02             	shl    $0x2,%eax
  800e76:	89 c1                	mov    %eax,%ecx
  800e78:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e7b:	c1 e0 03             	shl    $0x3,%eax
  800e7e:	01 c8                	add    %ecx,%eax
  800e80:	05 00 00 00 80       	add    $0x80000000,%eax
  800e85:	39 c2                	cmp    %eax,%edx
  800e87:	72 21                	jb     800eaa <_main+0xe72>
  800e89:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e8f:	89 c2                	mov    %eax,%edx
  800e91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e94:	c1 e0 02             	shl    $0x2,%eax
  800e97:	89 c1                	mov    %eax,%ecx
  800e99:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e9c:	c1 e0 03             	shl    $0x3,%eax
  800e9f:	01 c8                	add    %ecx,%eax
  800ea1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800ea6:	39 c2                	cmp    %eax,%edx
  800ea8:	76 17                	jbe    800ec1 <_main+0xe89>
  800eaa:	83 ec 04             	sub    $0x4,%esp
  800ead:	68 7c 4f 80 00       	push   $0x804f7c
  800eb2:	68 e8 00 00 00       	push   $0xe8
  800eb7:	68 21 4f 80 00       	push   $0x804f21
  800ebc:	e8 f2 06 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ec1:	e8 e2 1d 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800ec6:	2b 45 90             	sub    -0x70(%ebp),%eax
  800ec9:	83 f8 02             	cmp    $0x2,%eax
  800ecc:	74 17                	je     800ee5 <_main+0xead>
  800ece:	83 ec 04             	sub    $0x4,%esp
  800ed1:	68 e4 4f 80 00       	push   $0x804fe4
  800ed6:	68 e9 00 00 00       	push   $0xe9
  800edb:	68 21 4f 80 00       	push   $0x804f21
  800ee0:	e8 ce 06 00 00       	call   8015b3 <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800ee5:	e8 73 1d 00 00       	call   802c5d <sys_calculate_free_frames>
  800eea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800eed:	e8 b6 1d 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800ef2:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800ef5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ef8:	89 c2                	mov    %eax,%edx
  800efa:	01 d2                	add    %edx,%edx
  800efc:	01 d0                	add    %edx,%eax
  800efe:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800f01:	83 ec 0c             	sub    $0xc,%esp
  800f04:	50                   	push   %eax
  800f05:	e8 16 17 00 00       	call   802620 <malloc>
  800f0a:	83 c4 10             	add    $0x10,%esp
  800f0d:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800f13:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800f19:	89 c2                	mov    %eax,%edx
  800f1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f1e:	c1 e0 02             	shl    $0x2,%eax
  800f21:	89 c1                	mov    %eax,%ecx
  800f23:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f26:	c1 e0 04             	shl    $0x4,%eax
  800f29:	01 c8                	add    %ecx,%eax
  800f2b:	05 00 00 00 80       	add    $0x80000000,%eax
  800f30:	39 c2                	cmp    %eax,%edx
  800f32:	72 21                	jb     800f55 <_main+0xf1d>
  800f34:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800f3a:	89 c2                	mov    %eax,%edx
  800f3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f3f:	c1 e0 02             	shl    $0x2,%eax
  800f42:	89 c1                	mov    %eax,%ecx
  800f44:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f47:	c1 e0 04             	shl    $0x4,%eax
  800f4a:	01 c8                	add    %ecx,%eax
  800f4c:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800f51:	39 c2                	cmp    %eax,%edx
  800f53:	76 17                	jbe    800f6c <_main+0xf34>
  800f55:	83 ec 04             	sub    $0x4,%esp
  800f58:	68 7c 4f 80 00       	push   $0x804f7c
  800f5d:	68 f0 00 00 00       	push   $0xf0
  800f62:	68 21 4f 80 00       	push   $0x804f21
  800f67:	e8 47 06 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f6c:	e8 37 1d 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800f71:	2b 45 90             	sub    -0x70(%ebp),%eax
  800f74:	89 c2                	mov    %eax,%edx
  800f76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f79:	89 c1                	mov    %eax,%ecx
  800f7b:	01 c9                	add    %ecx,%ecx
  800f7d:	01 c8                	add    %ecx,%eax
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	79 05                	jns    800f88 <_main+0xf50>
  800f83:	05 ff 0f 00 00       	add    $0xfff,%eax
  800f88:	c1 f8 0c             	sar    $0xc,%eax
  800f8b:	39 c2                	cmp    %eax,%edx
  800f8d:	74 17                	je     800fa6 <_main+0xf6e>
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	68 e4 4f 80 00       	push   $0x804fe4
  800f97:	68 f1 00 00 00       	push   $0xf1
  800f9c:	68 21 4f 80 00       	push   $0x804f21
  800fa1:	e8 0d 06 00 00       	call   8015b3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800fa6:	e8 fd 1c 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  800fab:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800fae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fb1:	89 d0                	mov    %edx,%eax
  800fb3:	01 c0                	add    %eax,%eax
  800fb5:	01 d0                	add    %edx,%eax
  800fb7:	01 c0                	add    %eax,%eax
  800fb9:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800fbc:	83 ec 0c             	sub    $0xc,%esp
  800fbf:	50                   	push   %eax
  800fc0:	e8 5b 16 00 00       	call   802620 <malloc>
  800fc5:	83 c4 10             	add    $0x10,%esp
  800fc8:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800fce:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800fd4:	89 c1                	mov    %eax,%ecx
  800fd6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fd9:	89 d0                	mov    %edx,%eax
  800fdb:	01 c0                	add    %eax,%eax
  800fdd:	01 d0                	add    %edx,%eax
  800fdf:	01 c0                	add    %eax,%eax
  800fe1:	01 d0                	add    %edx,%eax
  800fe3:	89 c2                	mov    %eax,%edx
  800fe5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fe8:	c1 e0 04             	shl    $0x4,%eax
  800feb:	01 d0                	add    %edx,%eax
  800fed:	05 00 00 00 80       	add    $0x80000000,%eax
  800ff2:	39 c1                	cmp    %eax,%ecx
  800ff4:	72 28                	jb     80101e <_main+0xfe6>
  800ff6:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800ffc:	89 c1                	mov    %eax,%ecx
  800ffe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801001:	89 d0                	mov    %edx,%eax
  801003:	01 c0                	add    %eax,%eax
  801005:	01 d0                	add    %edx,%eax
  801007:	01 c0                	add    %eax,%eax
  801009:	01 d0                	add    %edx,%eax
  80100b:	89 c2                	mov    %eax,%edx
  80100d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801010:	c1 e0 04             	shl    $0x4,%eax
  801013:	01 d0                	add    %edx,%eax
  801015:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80101a:	39 c1                	cmp    %eax,%ecx
  80101c:	76 17                	jbe    801035 <_main+0xffd>
  80101e:	83 ec 04             	sub    $0x4,%esp
  801021:	68 7c 4f 80 00       	push   $0x804f7c
  801026:	68 f7 00 00 00       	push   $0xf7
  80102b:	68 21 4f 80 00       	push   $0x804f21
  801030:	e8 7e 05 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  801035:	e8 6e 1c 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  80103a:	2b 45 90             	sub    -0x70(%ebp),%eax
  80103d:	89 c1                	mov    %eax,%ecx
  80103f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801042:	89 d0                	mov    %edx,%eax
  801044:	01 c0                	add    %eax,%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	01 c0                	add    %eax,%eax
  80104a:	85 c0                	test   %eax,%eax
  80104c:	79 05                	jns    801053 <_main+0x101b>
  80104e:	05 ff 0f 00 00       	add    $0xfff,%eax
  801053:	c1 f8 0c             	sar    $0xc,%eax
  801056:	39 c1                	cmp    %eax,%ecx
  801058:	74 17                	je     801071 <_main+0x1039>
  80105a:	83 ec 04             	sub    $0x4,%esp
  80105d:	68 e4 4f 80 00       	push   $0x804fe4
  801062:	68 f8 00 00 00       	push   $0xf8
  801067:	68 21 4f 80 00       	push   $0x804f21
  80106c:	e8 42 05 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801071:	e8 e7 1b 00 00       	call   802c5d <sys_calculate_free_frames>
  801076:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  801079:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80107c:	89 d0                	mov    %edx,%eax
  80107e:	01 c0                	add    %eax,%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	01 c0                	add    %eax,%eax
  801084:	2b 45 d0             	sub    -0x30(%ebp),%eax
  801087:	48                   	dec    %eax
  801088:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  80108e:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  801094:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
		byteArr2[0] = minByte ;
  80109a:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010a0:	8a 55 cf             	mov    -0x31(%ebp),%dl
  8010a3:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  8010a5:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8010ab:	89 c2                	mov    %eax,%edx
  8010ad:	c1 ea 1f             	shr    $0x1f,%edx
  8010b0:	01 d0                	add    %edx,%eax
  8010b2:	d1 f8                	sar    %eax
  8010b4:	89 c2                	mov    %eax,%edx
  8010b6:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010bc:	01 c2                	add    %eax,%edx
  8010be:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010c1:	88 c1                	mov    %al,%cl
  8010c3:	c0 e9 07             	shr    $0x7,%cl
  8010c6:	01 c8                	add    %ecx,%eax
  8010c8:	d0 f8                	sar    %al
  8010ca:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  8010cc:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8010d2:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010d8:	01 c2                	add    %eax,%edx
  8010da:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010dd:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8010df:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8010e2:	e8 76 1b 00 00       	call   802c5d <sys_calculate_free_frames>
  8010e7:	29 c3                	sub    %eax,%ebx
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	83 f8 05             	cmp    $0x5,%eax
  8010ee:	74 17                	je     801107 <_main+0x10cf>
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 14 50 80 00       	push   $0x805014
  8010f8:	68 00 01 00 00       	push   $0x100
  8010fd:	68 21 4f 80 00       	push   $0x804f21
  801102:	e8 ac 04 00 00       	call   8015b3 <_panic>
		found = 0;
  801107:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80110e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801115:	e9 02 01 00 00       	jmp    80121c <_main+0x11e4>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  80111a:	a1 20 60 80 00       	mov    0x806020,%eax
  80111f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801125:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801128:	89 d0                	mov    %edx,%eax
  80112a:	01 c0                	add    %eax,%eax
  80112c:	01 d0                	add    %edx,%eax
  80112e:	c1 e0 03             	shl    $0x3,%eax
  801131:	01 c8                	add    %ecx,%eax
  801133:	8b 00                	mov    (%eax),%eax
  801135:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  80113b:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801141:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801146:	89 c2                	mov    %eax,%edx
  801148:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  80114e:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801154:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80115a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80115f:	39 c2                	cmp    %eax,%edx
  801161:	75 03                	jne    801166 <_main+0x112e>
				found++;
  801163:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  801166:	a1 20 60 80 00       	mov    0x806020,%eax
  80116b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801171:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801174:	89 d0                	mov    %edx,%eax
  801176:	01 c0                	add    %eax,%eax
  801178:	01 d0                	add    %edx,%eax
  80117a:	c1 e0 03             	shl    $0x3,%eax
  80117d:	01 c8                	add    %ecx,%eax
  80117f:	8b 00                	mov    (%eax),%eax
  801181:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  801187:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  80118d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801192:	89 c2                	mov    %eax,%edx
  801194:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  80119a:	89 c1                	mov    %eax,%ecx
  80119c:	c1 e9 1f             	shr    $0x1f,%ecx
  80119f:	01 c8                	add    %ecx,%eax
  8011a1:	d1 f8                	sar    %eax
  8011a3:	89 c1                	mov    %eax,%ecx
  8011a5:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011ab:	01 c8                	add    %ecx,%eax
  8011ad:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  8011b3:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  8011b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011be:	39 c2                	cmp    %eax,%edx
  8011c0:	75 03                	jne    8011c5 <_main+0x118d>
				found++;
  8011c2:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  8011c5:	a1 20 60 80 00       	mov    0x806020,%eax
  8011ca:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8011d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	01 c0                	add    %eax,%eax
  8011d7:	01 d0                	add    %edx,%eax
  8011d9:	c1 e0 03             	shl    $0x3,%eax
  8011dc:	01 c8                	add    %ecx,%eax
  8011de:	8b 00                	mov    (%eax),%eax
  8011e0:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  8011e6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  8011ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f1:	89 c1                	mov    %eax,%ecx
  8011f3:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8011f9:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011ff:	01 d0                	add    %edx,%eax
  801201:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  801207:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  80120d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801212:	39 c1                	cmp    %eax,%ecx
  801214:	75 03                	jne    801219 <_main+0x11e1>
				found++;
  801216:	ff 45 d8             	incl   -0x28(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801219:	ff 45 e4             	incl   -0x1c(%ebp)
  80121c:	a1 20 60 80 00       	mov    0x806020,%eax
  801221:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801227:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80122a:	39 c2                	cmp    %eax,%edx
  80122c:	0f 87 e8 fe ff ff    	ja     80111a <_main+0x10e2>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  801232:	83 7d d8 03          	cmpl   $0x3,-0x28(%ebp)
  801236:	74 17                	je     80124f <_main+0x1217>
  801238:	83 ec 04             	sub    $0x4,%esp
  80123b:	68 58 50 80 00       	push   $0x805058
  801240:	68 0b 01 00 00       	push   $0x10b
  801245:	68 21 4f 80 00       	push   $0x804f21
  80124a:	e8 64 03 00 00       	call   8015b3 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80124f:	e8 54 1a 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  801254:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  801257:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80125a:	89 d0                	mov    %edx,%eax
  80125c:	01 c0                	add    %eax,%eax
  80125e:	01 d0                	add    %edx,%eax
  801260:	01 c0                	add    %eax,%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	01 c0                	add    %eax,%eax
  801266:	83 ec 0c             	sub    $0xc,%esp
  801269:	50                   	push   %eax
  80126a:	e8 b1 13 00 00       	call   802620 <malloc>
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  801278:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  80127e:	89 c1                	mov    %eax,%ecx
  801280:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801283:	89 d0                	mov    %edx,%eax
  801285:	01 c0                	add    %eax,%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	c1 e0 02             	shl    $0x2,%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	89 c2                	mov    %eax,%edx
  801290:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801293:	c1 e0 04             	shl    $0x4,%eax
  801296:	01 d0                	add    %edx,%eax
  801298:	05 00 00 00 80       	add    $0x80000000,%eax
  80129d:	39 c1                	cmp    %eax,%ecx
  80129f:	72 29                	jb     8012ca <_main+0x1292>
  8012a1:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  8012a7:	89 c1                	mov    %eax,%ecx
  8012a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8012ac:	89 d0                	mov    %edx,%eax
  8012ae:	01 c0                	add    %eax,%eax
  8012b0:	01 d0                	add    %edx,%eax
  8012b2:	c1 e0 02             	shl    $0x2,%eax
  8012b5:	01 d0                	add    %edx,%eax
  8012b7:	89 c2                	mov    %eax,%edx
  8012b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8012bc:	c1 e0 04             	shl    $0x4,%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8012c6:	39 c1                	cmp    %eax,%ecx
  8012c8:	76 17                	jbe    8012e1 <_main+0x12a9>
  8012ca:	83 ec 04             	sub    $0x4,%esp
  8012cd:	68 7c 4f 80 00       	push   $0x804f7c
  8012d2:	68 10 01 00 00       	push   $0x110
  8012d7:	68 21 4f 80 00       	push   $0x804f21
  8012dc:	e8 d2 02 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012e1:	e8 c2 19 00 00       	call   802ca8 <sys_pf_calculate_allocated_pages>
  8012e6:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012e9:	83 f8 04             	cmp    $0x4,%eax
  8012ec:	74 17                	je     801305 <_main+0x12cd>
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 e4 4f 80 00       	push   $0x804fe4
  8012f6:	68 11 01 00 00       	push   $0x111
  8012fb:	68 21 4f 80 00       	push   $0x804f21
  801300:	e8 ae 02 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801305:	e8 53 19 00 00       	call   802c5d <sys_calculate_free_frames>
  80130a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  80130d:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  801313:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  801319:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80131c:	89 d0                	mov    %edx,%eax
  80131e:	01 c0                	add    %eax,%eax
  801320:	01 d0                	add    %edx,%eax
  801322:	01 c0                	add    %eax,%eax
  801324:	01 d0                	add    %edx,%eax
  801326:	01 c0                	add    %eax,%eax
  801328:	d1 e8                	shr    %eax
  80132a:	48                   	dec    %eax
  80132b:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		shortArr2[0] = minShort;
  801331:	8b 95 10 ff ff ff    	mov    -0xf0(%ebp),%edx
  801337:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80133a:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  80133d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801343:	01 c0                	add    %eax,%eax
  801345:	89 c2                	mov    %eax,%edx
  801347:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  80134d:	01 c2                	add    %eax,%edx
  80134f:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  801353:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  801356:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  801359:	e8 ff 18 00 00       	call   802c5d <sys_calculate_free_frames>
  80135e:	29 c3                	sub    %eax,%ebx
  801360:	89 d8                	mov    %ebx,%eax
  801362:	83 f8 02             	cmp    $0x2,%eax
  801365:	74 17                	je     80137e <_main+0x1346>
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	68 14 50 80 00       	push   $0x805014
  80136f:	68 18 01 00 00       	push   $0x118
  801374:	68 21 4f 80 00       	push   $0x804f21
  801379:	e8 35 02 00 00       	call   8015b3 <_panic>
		found = 0;
  80137e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801385:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80138c:	e9 a7 00 00 00       	jmp    801438 <_main+0x1400>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  801391:	a1 20 60 80 00       	mov    0x806020,%eax
  801396:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80139c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80139f:	89 d0                	mov    %edx,%eax
  8013a1:	01 c0                	add    %eax,%eax
  8013a3:	01 d0                	add    %edx,%eax
  8013a5:	c1 e0 03             	shl    $0x3,%eax
  8013a8:	01 c8                	add    %ecx,%eax
  8013aa:	8b 00                	mov    (%eax),%eax
  8013ac:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  8013b2:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  8013b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013bd:	89 c2                	mov    %eax,%edx
  8013bf:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8013c5:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  8013cb:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8013d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d6:	39 c2                	cmp    %eax,%edx
  8013d8:	75 03                	jne    8013dd <_main+0x13a5>
				found++;
  8013da:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  8013dd:	a1 20 60 80 00       	mov    0x806020,%eax
  8013e2:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8013e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013eb:	89 d0                	mov    %edx,%eax
  8013ed:	01 c0                	add    %eax,%eax
  8013ef:	01 d0                	add    %edx,%eax
  8013f1:	c1 e0 03             	shl    $0x3,%eax
  8013f4:	01 c8                	add    %ecx,%eax
  8013f6:	8b 00                	mov    (%eax),%eax
  8013f8:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  8013fe:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  801404:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801409:	89 c2                	mov    %eax,%edx
  80140b:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801411:	01 c0                	add    %eax,%eax
  801413:	89 c1                	mov    %eax,%ecx
  801415:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  80141b:	01 c8                	add    %ecx,%eax
  80141d:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801423:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  801429:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80142e:	39 c2                	cmp    %eax,%edx
  801430:	75 03                	jne    801435 <_main+0x13fd>
				found++;
  801432:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801435:	ff 45 e4             	incl   -0x1c(%ebp)
  801438:	a1 20 60 80 00       	mov    0x806020,%eax
  80143d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801446:	39 c2                	cmp    %eax,%edx
  801448:	0f 87 43 ff ff ff    	ja     801391 <_main+0x1359>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80144e:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  801452:	74 17                	je     80146b <_main+0x1433>
  801454:	83 ec 04             	sub    $0x4,%esp
  801457:	68 58 50 80 00       	push   $0x805058
  80145c:	68 21 01 00 00       	push   $0x121
  801461:	68 21 4f 80 00       	push   $0x804f21
  801466:	e8 48 01 00 00       	call   8015b3 <_panic>
		if(start_freeFrames != (sys_calculate_free_frames() + 4)) {panic("Wrong free: not all pages removed correctly at end");}
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
	 */
	return;
  80146b:	90                   	nop
}
  80146c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80146f:	5b                   	pop    %ebx
  801470:	5e                   	pop    %esi
  801471:	5f                   	pop    %edi
  801472:	5d                   	pop    %ebp
  801473:	c3                   	ret    

00801474 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80147a:	e8 a7 19 00 00       	call   802e26 <sys_getenvindex>
  80147f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  801482:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801485:	89 d0                	mov    %edx,%eax
  801487:	c1 e0 03             	shl    $0x3,%eax
  80148a:	01 d0                	add    %edx,%eax
  80148c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  801493:	01 c8                	add    %ecx,%eax
  801495:	01 c0                	add    %eax,%eax
  801497:	01 d0                	add    %edx,%eax
  801499:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8014a0:	01 c8                	add    %ecx,%eax
  8014a2:	01 d0                	add    %edx,%eax
  8014a4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014a9:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8014ae:	a1 20 60 80 00       	mov    0x806020,%eax
  8014b3:	8a 40 20             	mov    0x20(%eax),%al
  8014b6:	84 c0                	test   %al,%al
  8014b8:	74 0d                	je     8014c7 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8014ba:	a1 20 60 80 00       	mov    0x806020,%eax
  8014bf:	83 c0 20             	add    $0x20,%eax
  8014c2:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8014c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014cb:	7e 0a                	jle    8014d7 <libmain+0x63>
		binaryname = argv[0];
  8014cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d0:	8b 00                	mov    (%eax),%eax
  8014d2:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	ff 75 0c             	pushl  0xc(%ebp)
  8014dd:	ff 75 08             	pushl  0x8(%ebp)
  8014e0:	e8 53 eb ff ff       	call   800038 <_main>
  8014e5:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8014e8:	e8 bd 16 00 00       	call   802baa <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8014ed:	83 ec 0c             	sub    $0xc,%esp
  8014f0:	68 7c 51 80 00       	push   $0x80517c
  8014f5:	e8 76 03 00 00       	call   801870 <cprintf>
  8014fa:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014fd:	a1 20 60 80 00       	mov    0x806020,%eax
  801502:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  801508:	a1 20 60 80 00       	mov    0x806020,%eax
  80150d:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  801513:	83 ec 04             	sub    $0x4,%esp
  801516:	52                   	push   %edx
  801517:	50                   	push   %eax
  801518:	68 a4 51 80 00       	push   $0x8051a4
  80151d:	e8 4e 03 00 00       	call   801870 <cprintf>
  801522:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801525:	a1 20 60 80 00       	mov    0x806020,%eax
  80152a:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  801530:	a1 20 60 80 00       	mov    0x806020,%eax
  801535:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80153b:	a1 20 60 80 00       	mov    0x806020,%eax
  801540:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  801546:	51                   	push   %ecx
  801547:	52                   	push   %edx
  801548:	50                   	push   %eax
  801549:	68 cc 51 80 00       	push   $0x8051cc
  80154e:	e8 1d 03 00 00       	call   801870 <cprintf>
  801553:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801556:	a1 20 60 80 00       	mov    0x806020,%eax
  80155b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	50                   	push   %eax
  801565:	68 24 52 80 00       	push   $0x805224
  80156a:	e8 01 03 00 00       	call   801870 <cprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 7c 51 80 00       	push   $0x80517c
  80157a:	e8 f1 02 00 00       	call   801870 <cprintf>
  80157f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801582:	e8 3d 16 00 00       	call   802bc4 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  801587:	e8 19 00 00 00       	call   8015a5 <exit>
}
  80158c:	90                   	nop
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801595:	83 ec 0c             	sub    $0xc,%esp
  801598:	6a 00                	push   $0x0
  80159a:	e8 53 18 00 00       	call   802df2 <sys_destroy_env>
  80159f:	83 c4 10             	add    $0x10,%esp
}
  8015a2:	90                   	nop
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <exit>:

void
exit(void)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8015ab:	e8 a8 18 00 00       	call   802e58 <sys_exit_env>
}
  8015b0:	90                   	nop
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8015b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8015bc:	83 c0 04             	add    $0x4,%eax
  8015bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8015c2:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	74 16                	je     8015e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015cb:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8015d0:	83 ec 08             	sub    $0x8,%esp
  8015d3:	50                   	push   %eax
  8015d4:	68 38 52 80 00       	push   $0x805238
  8015d9:	e8 92 02 00 00       	call   801870 <cprintf>
  8015de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015e1:	a1 00 60 80 00       	mov    0x806000,%eax
  8015e6:	ff 75 0c             	pushl  0xc(%ebp)
  8015e9:	ff 75 08             	pushl  0x8(%ebp)
  8015ec:	50                   	push   %eax
  8015ed:	68 3d 52 80 00       	push   $0x80523d
  8015f2:	e8 79 02 00 00       	call   801870 <cprintf>
  8015f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8015fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	ff 75 f4             	pushl  -0xc(%ebp)
  801603:	50                   	push   %eax
  801604:	e8 fc 01 00 00       	call   801805 <vcprintf>
  801609:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80160c:	83 ec 08             	sub    $0x8,%esp
  80160f:	6a 00                	push   $0x0
  801611:	68 59 52 80 00       	push   $0x805259
  801616:	e8 ea 01 00 00       	call   801805 <vcprintf>
  80161b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80161e:	e8 82 ff ff ff       	call   8015a5 <exit>

	// should not return here
	while (1) ;
  801623:	eb fe                	jmp    801623 <_panic+0x70>

00801625 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80162b:	a1 20 60 80 00       	mov    0x806020,%eax
  801630:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801636:	8b 45 0c             	mov    0xc(%ebp),%eax
  801639:	39 c2                	cmp    %eax,%edx
  80163b:	74 14                	je     801651 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80163d:	83 ec 04             	sub    $0x4,%esp
  801640:	68 5c 52 80 00       	push   $0x80525c
  801645:	6a 26                	push   $0x26
  801647:	68 a8 52 80 00       	push   $0x8052a8
  80164c:	e8 62 ff ff ff       	call   8015b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801658:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80165f:	e9 c5 00 00 00       	jmp    801729 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801667:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	01 d0                	add    %edx,%eax
  801673:	8b 00                	mov    (%eax),%eax
  801675:	85 c0                	test   %eax,%eax
  801677:	75 08                	jne    801681 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801679:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80167c:	e9 a5 00 00 00       	jmp    801726 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801681:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801688:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80168f:	eb 69                	jmp    8016fa <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801691:	a1 20 60 80 00       	mov    0x806020,%eax
  801696:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80169c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80169f:	89 d0                	mov    %edx,%eax
  8016a1:	01 c0                	add    %eax,%eax
  8016a3:	01 d0                	add    %edx,%eax
  8016a5:	c1 e0 03             	shl    $0x3,%eax
  8016a8:	01 c8                	add    %ecx,%eax
  8016aa:	8a 40 04             	mov    0x4(%eax),%al
  8016ad:	84 c0                	test   %al,%al
  8016af:	75 46                	jne    8016f7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016b1:	a1 20 60 80 00       	mov    0x806020,%eax
  8016b6:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8016bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016bf:	89 d0                	mov    %edx,%eax
  8016c1:	01 c0                	add    %eax,%eax
  8016c3:	01 d0                	add    %edx,%eax
  8016c5:	c1 e0 03             	shl    $0x3,%eax
  8016c8:	01 c8                	add    %ecx,%eax
  8016ca:	8b 00                	mov    (%eax),%eax
  8016cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	01 c8                	add    %ecx,%eax
  8016e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016ea:	39 c2                	cmp    %eax,%edx
  8016ec:	75 09                	jne    8016f7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8016ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016f5:	eb 15                	jmp    80170c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016f7:	ff 45 e8             	incl   -0x18(%ebp)
  8016fa:	a1 20 60 80 00       	mov    0x806020,%eax
  8016ff:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801705:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801708:	39 c2                	cmp    %eax,%edx
  80170a:	77 85                	ja     801691 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80170c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801710:	75 14                	jne    801726 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801712:	83 ec 04             	sub    $0x4,%esp
  801715:	68 b4 52 80 00       	push   $0x8052b4
  80171a:	6a 3a                	push   $0x3a
  80171c:	68 a8 52 80 00       	push   $0x8052a8
  801721:	e8 8d fe ff ff       	call   8015b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801726:	ff 45 f0             	incl   -0x10(%ebp)
  801729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80172f:	0f 8c 2f ff ff ff    	jl     801664 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801735:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80173c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801743:	eb 26                	jmp    80176b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801745:	a1 20 60 80 00       	mov    0x806020,%eax
  80174a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801750:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801753:	89 d0                	mov    %edx,%eax
  801755:	01 c0                	add    %eax,%eax
  801757:	01 d0                	add    %edx,%eax
  801759:	c1 e0 03             	shl    $0x3,%eax
  80175c:	01 c8                	add    %ecx,%eax
  80175e:	8a 40 04             	mov    0x4(%eax),%al
  801761:	3c 01                	cmp    $0x1,%al
  801763:	75 03                	jne    801768 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801765:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801768:	ff 45 e0             	incl   -0x20(%ebp)
  80176b:	a1 20 60 80 00       	mov    0x806020,%eax
  801770:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801776:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801779:	39 c2                	cmp    %eax,%edx
  80177b:	77 c8                	ja     801745 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80177d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801780:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801783:	74 14                	je     801799 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	68 08 53 80 00       	push   $0x805308
  80178d:	6a 44                	push   $0x44
  80178f:	68 a8 52 80 00       	push   $0x8052a8
  801794:	e8 1a fe ff ff       	call   8015b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801799:	90                   	nop
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8017a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a5:	8b 00                	mov    (%eax),%eax
  8017a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ad:	89 0a                	mov    %ecx,(%edx)
  8017af:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b2:	88 d1                	mov    %dl,%cl
  8017b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8017bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017be:	8b 00                	mov    (%eax),%eax
  8017c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017c5:	75 2c                	jne    8017f3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8017c7:	a0 28 60 80 00       	mov    0x806028,%al
  8017cc:	0f b6 c0             	movzbl %al,%eax
  8017cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d2:	8b 12                	mov    (%edx),%edx
  8017d4:	89 d1                	mov    %edx,%ecx
  8017d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d9:	83 c2 08             	add    $0x8,%edx
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	50                   	push   %eax
  8017e0:	51                   	push   %ecx
  8017e1:	52                   	push   %edx
  8017e2:	e8 81 13 00 00       	call   802b68 <sys_cputs>
  8017e7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f6:	8b 40 04             	mov    0x4(%eax),%eax
  8017f9:	8d 50 01             	lea    0x1(%eax),%edx
  8017fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ff:	89 50 04             	mov    %edx,0x4(%eax)
}
  801802:	90                   	nop
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80180e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801815:	00 00 00 
	b.cnt = 0;
  801818:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80181f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80182e:	50                   	push   %eax
  80182f:	68 9c 17 80 00       	push   $0x80179c
  801834:	e8 11 02 00 00       	call   801a4a <vprintfmt>
  801839:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80183c:	a0 28 60 80 00       	mov    0x806028,%al
  801841:	0f b6 c0             	movzbl %al,%eax
  801844:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	50                   	push   %eax
  80184e:	52                   	push   %edx
  80184f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801855:	83 c0 08             	add    $0x8,%eax
  801858:	50                   	push   %eax
  801859:	e8 0a 13 00 00       	call   802b68 <sys_cputs>
  80185e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801861:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
	return b.cnt;
  801868:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801876:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
	va_start(ap, fmt);
  80187d:	8d 45 0c             	lea    0xc(%ebp),%eax
  801880:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	83 ec 08             	sub    $0x8,%esp
  801889:	ff 75 f4             	pushl  -0xc(%ebp)
  80188c:	50                   	push   %eax
  80188d:	e8 73 ff ff ff       	call   801805 <vcprintf>
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801898:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8018a3:	e8 02 13 00 00       	call   802baa <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8018a8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	83 ec 08             	sub    $0x8,%esp
  8018b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b7:	50                   	push   %eax
  8018b8:	e8 48 ff ff ff       	call   801805 <vcprintf>
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8018c3:	e8 fc 12 00 00       	call   802bc4 <sys_unlock_cons>
	return cnt;
  8018c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	53                   	push   %ebx
  8018d1:	83 ec 14             	sub    $0x14,%esp
  8018d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018da:	8b 45 14             	mov    0x14(%ebp),%eax
  8018dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018e0:	8b 45 18             	mov    0x18(%ebp),%eax
  8018e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018eb:	77 55                	ja     801942 <printnum+0x75>
  8018ed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018f0:	72 05                	jb     8018f7 <printnum+0x2a>
  8018f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018f5:	77 4b                	ja     801942 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8018f7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8018fa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8018fd:	8b 45 18             	mov    0x18(%ebp),%eax
  801900:	ba 00 00 00 00       	mov    $0x0,%edx
  801905:	52                   	push   %edx
  801906:	50                   	push   %eax
  801907:	ff 75 f4             	pushl  -0xc(%ebp)
  80190a:	ff 75 f0             	pushl  -0x10(%ebp)
  80190d:	e8 56 33 00 00       	call   804c68 <__udivdi3>
  801912:	83 c4 10             	add    $0x10,%esp
  801915:	83 ec 04             	sub    $0x4,%esp
  801918:	ff 75 20             	pushl  0x20(%ebp)
  80191b:	53                   	push   %ebx
  80191c:	ff 75 18             	pushl  0x18(%ebp)
  80191f:	52                   	push   %edx
  801920:	50                   	push   %eax
  801921:	ff 75 0c             	pushl  0xc(%ebp)
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	e8 a1 ff ff ff       	call   8018cd <printnum>
  80192c:	83 c4 20             	add    $0x20,%esp
  80192f:	eb 1a                	jmp    80194b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801931:	83 ec 08             	sub    $0x8,%esp
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	ff 75 20             	pushl  0x20(%ebp)
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	ff d0                	call   *%eax
  80193f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801942:	ff 4d 1c             	decl   0x1c(%ebp)
  801945:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801949:	7f e6                	jg     801931 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80194b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80194e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801956:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801959:	53                   	push   %ebx
  80195a:	51                   	push   %ecx
  80195b:	52                   	push   %edx
  80195c:	50                   	push   %eax
  80195d:	e8 16 34 00 00       	call   804d78 <__umoddi3>
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	05 74 55 80 00       	add    $0x805574,%eax
  80196a:	8a 00                	mov    (%eax),%al
  80196c:	0f be c0             	movsbl %al,%eax
  80196f:	83 ec 08             	sub    $0x8,%esp
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	50                   	push   %eax
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	ff d0                	call   *%eax
  80197b:	83 c4 10             	add    $0x10,%esp
}
  80197e:	90                   	nop
  80197f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801987:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80198b:	7e 1c                	jle    8019a9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	8b 00                	mov    (%eax),%eax
  801992:	8d 50 08             	lea    0x8(%eax),%edx
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	89 10                	mov    %edx,(%eax)
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	8b 00                	mov    (%eax),%eax
  80199f:	83 e8 08             	sub    $0x8,%eax
  8019a2:	8b 50 04             	mov    0x4(%eax),%edx
  8019a5:	8b 00                	mov    (%eax),%eax
  8019a7:	eb 40                	jmp    8019e9 <getuint+0x65>
	else if (lflag)
  8019a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019ad:	74 1e                	je     8019cd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	8b 00                	mov    (%eax),%eax
  8019b4:	8d 50 04             	lea    0x4(%eax),%edx
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	89 10                	mov    %edx,(%eax)
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	8b 00                	mov    (%eax),%eax
  8019c1:	83 e8 04             	sub    $0x4,%eax
  8019c4:	8b 00                	mov    (%eax),%eax
  8019c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cb:	eb 1c                	jmp    8019e9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	8b 00                	mov    (%eax),%eax
  8019d2:	8d 50 04             	lea    0x4(%eax),%edx
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	89 10                	mov    %edx,(%eax)
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	8b 00                	mov    (%eax),%eax
  8019df:	83 e8 04             	sub    $0x4,%eax
  8019e2:	8b 00                	mov    (%eax),%eax
  8019e4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019e9:	5d                   	pop    %ebp
  8019ea:	c3                   	ret    

008019eb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019ee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019f2:	7e 1c                	jle    801a10 <getint+0x25>
		return va_arg(*ap, long long);
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	8b 00                	mov    (%eax),%eax
  8019f9:	8d 50 08             	lea    0x8(%eax),%edx
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	89 10                	mov    %edx,(%eax)
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8b 00                	mov    (%eax),%eax
  801a06:	83 e8 08             	sub    $0x8,%eax
  801a09:	8b 50 04             	mov    0x4(%eax),%edx
  801a0c:	8b 00                	mov    (%eax),%eax
  801a0e:	eb 38                	jmp    801a48 <getint+0x5d>
	else if (lflag)
  801a10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a14:	74 1a                	je     801a30 <getint+0x45>
		return va_arg(*ap, long);
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8b 00                	mov    (%eax),%eax
  801a1b:	8d 50 04             	lea    0x4(%eax),%edx
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	89 10                	mov    %edx,(%eax)
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	8b 00                	mov    (%eax),%eax
  801a28:	83 e8 04             	sub    $0x4,%eax
  801a2b:	8b 00                	mov    (%eax),%eax
  801a2d:	99                   	cltd   
  801a2e:	eb 18                	jmp    801a48 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	8b 00                	mov    (%eax),%eax
  801a35:	8d 50 04             	lea    0x4(%eax),%edx
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	89 10                	mov    %edx,(%eax)
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	8b 00                	mov    (%eax),%eax
  801a42:	83 e8 04             	sub    $0x4,%eax
  801a45:	8b 00                	mov    (%eax),%eax
  801a47:	99                   	cltd   
}
  801a48:	5d                   	pop    %ebp
  801a49:	c3                   	ret    

00801a4a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	56                   	push   %esi
  801a4e:	53                   	push   %ebx
  801a4f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a52:	eb 17                	jmp    801a6b <vprintfmt+0x21>
			if (ch == '\0')
  801a54:	85 db                	test   %ebx,%ebx
  801a56:	0f 84 c1 03 00 00    	je     801e1d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801a5c:	83 ec 08             	sub    $0x8,%esp
  801a5f:	ff 75 0c             	pushl  0xc(%ebp)
  801a62:	53                   	push   %ebx
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	ff d0                	call   *%eax
  801a68:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6e:	8d 50 01             	lea    0x1(%eax),%edx
  801a71:	89 55 10             	mov    %edx,0x10(%ebp)
  801a74:	8a 00                	mov    (%eax),%al
  801a76:	0f b6 d8             	movzbl %al,%ebx
  801a79:	83 fb 25             	cmp    $0x25,%ebx
  801a7c:	75 d6                	jne    801a54 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a7e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a82:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a90:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801a97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa1:	8d 50 01             	lea    0x1(%eax),%edx
  801aa4:	89 55 10             	mov    %edx,0x10(%ebp)
  801aa7:	8a 00                	mov    (%eax),%al
  801aa9:	0f b6 d8             	movzbl %al,%ebx
  801aac:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801aaf:	83 f8 5b             	cmp    $0x5b,%eax
  801ab2:	0f 87 3d 03 00 00    	ja     801df5 <vprintfmt+0x3ab>
  801ab8:	8b 04 85 98 55 80 00 	mov    0x805598(,%eax,4),%eax
  801abf:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801ac1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801ac5:	eb d7                	jmp    801a9e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801ac7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801acb:	eb d1                	jmp    801a9e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801acd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801ad4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ad7:	89 d0                	mov    %edx,%eax
  801ad9:	c1 e0 02             	shl    $0x2,%eax
  801adc:	01 d0                	add    %edx,%eax
  801ade:	01 c0                	add    %eax,%eax
  801ae0:	01 d8                	add    %ebx,%eax
  801ae2:	83 e8 30             	sub    $0x30,%eax
  801ae5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aeb:	8a 00                	mov    (%eax),%al
  801aed:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801af0:	83 fb 2f             	cmp    $0x2f,%ebx
  801af3:	7e 3e                	jle    801b33 <vprintfmt+0xe9>
  801af5:	83 fb 39             	cmp    $0x39,%ebx
  801af8:	7f 39                	jg     801b33 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801afa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801afd:	eb d5                	jmp    801ad4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801aff:	8b 45 14             	mov    0x14(%ebp),%eax
  801b02:	83 c0 04             	add    $0x4,%eax
  801b05:	89 45 14             	mov    %eax,0x14(%ebp)
  801b08:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0b:	83 e8 04             	sub    $0x4,%eax
  801b0e:	8b 00                	mov    (%eax),%eax
  801b10:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b13:	eb 1f                	jmp    801b34 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b19:	79 83                	jns    801a9e <vprintfmt+0x54>
				width = 0;
  801b1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b22:	e9 77 ff ff ff       	jmp    801a9e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b27:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b2e:	e9 6b ff ff ff       	jmp    801a9e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b33:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b38:	0f 89 60 ff ff ff    	jns    801a9e <vprintfmt+0x54>
				width = precision, precision = -1;
  801b3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b44:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b4b:	e9 4e ff ff ff       	jmp    801a9e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b50:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b53:	e9 46 ff ff ff       	jmp    801a9e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b58:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5b:	83 c0 04             	add    $0x4,%eax
  801b5e:	89 45 14             	mov    %eax,0x14(%ebp)
  801b61:	8b 45 14             	mov    0x14(%ebp),%eax
  801b64:	83 e8 04             	sub    $0x4,%eax
  801b67:	8b 00                	mov    (%eax),%eax
  801b69:	83 ec 08             	sub    $0x8,%esp
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	50                   	push   %eax
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	ff d0                	call   *%eax
  801b75:	83 c4 10             	add    $0x10,%esp
			break;
  801b78:	e9 9b 02 00 00       	jmp    801e18 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b80:	83 c0 04             	add    $0x4,%eax
  801b83:	89 45 14             	mov    %eax,0x14(%ebp)
  801b86:	8b 45 14             	mov    0x14(%ebp),%eax
  801b89:	83 e8 04             	sub    $0x4,%eax
  801b8c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b8e:	85 db                	test   %ebx,%ebx
  801b90:	79 02                	jns    801b94 <vprintfmt+0x14a>
				err = -err;
  801b92:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801b94:	83 fb 64             	cmp    $0x64,%ebx
  801b97:	7f 0b                	jg     801ba4 <vprintfmt+0x15a>
  801b99:	8b 34 9d e0 53 80 00 	mov    0x8053e0(,%ebx,4),%esi
  801ba0:	85 f6                	test   %esi,%esi
  801ba2:	75 19                	jne    801bbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801ba4:	53                   	push   %ebx
  801ba5:	68 85 55 80 00       	push   $0x805585
  801baa:	ff 75 0c             	pushl  0xc(%ebp)
  801bad:	ff 75 08             	pushl  0x8(%ebp)
  801bb0:	e8 70 02 00 00       	call   801e25 <printfmt>
  801bb5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801bb8:	e9 5b 02 00 00       	jmp    801e18 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801bbd:	56                   	push   %esi
  801bbe:	68 8e 55 80 00       	push   $0x80558e
  801bc3:	ff 75 0c             	pushl  0xc(%ebp)
  801bc6:	ff 75 08             	pushl  0x8(%ebp)
  801bc9:	e8 57 02 00 00       	call   801e25 <printfmt>
  801bce:	83 c4 10             	add    $0x10,%esp
			break;
  801bd1:	e9 42 02 00 00       	jmp    801e18 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801bd6:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd9:	83 c0 04             	add    $0x4,%eax
  801bdc:	89 45 14             	mov    %eax,0x14(%ebp)
  801bdf:	8b 45 14             	mov    0x14(%ebp),%eax
  801be2:	83 e8 04             	sub    $0x4,%eax
  801be5:	8b 30                	mov    (%eax),%esi
  801be7:	85 f6                	test   %esi,%esi
  801be9:	75 05                	jne    801bf0 <vprintfmt+0x1a6>
				p = "(null)";
  801beb:	be 91 55 80 00       	mov    $0x805591,%esi
			if (width > 0 && padc != '-')
  801bf0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bf4:	7e 6d                	jle    801c63 <vprintfmt+0x219>
  801bf6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801bfa:	74 67                	je     801c63 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bff:	83 ec 08             	sub    $0x8,%esp
  801c02:	50                   	push   %eax
  801c03:	56                   	push   %esi
  801c04:	e8 1e 03 00 00       	call   801f27 <strnlen>
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c0f:	eb 16                	jmp    801c27 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c11:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c15:	83 ec 08             	sub    $0x8,%esp
  801c18:	ff 75 0c             	pushl  0xc(%ebp)
  801c1b:	50                   	push   %eax
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	ff d0                	call   *%eax
  801c21:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c24:	ff 4d e4             	decl   -0x1c(%ebp)
  801c27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c2b:	7f e4                	jg     801c11 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c2d:	eb 34                	jmp    801c63 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c33:	74 1c                	je     801c51 <vprintfmt+0x207>
  801c35:	83 fb 1f             	cmp    $0x1f,%ebx
  801c38:	7e 05                	jle    801c3f <vprintfmt+0x1f5>
  801c3a:	83 fb 7e             	cmp    $0x7e,%ebx
  801c3d:	7e 12                	jle    801c51 <vprintfmt+0x207>
					putch('?', putdat);
  801c3f:	83 ec 08             	sub    $0x8,%esp
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	6a 3f                	push   $0x3f
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	ff d0                	call   *%eax
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	eb 0f                	jmp    801c60 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c51:	83 ec 08             	sub    $0x8,%esp
  801c54:	ff 75 0c             	pushl  0xc(%ebp)
  801c57:	53                   	push   %ebx
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	ff d0                	call   *%eax
  801c5d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c60:	ff 4d e4             	decl   -0x1c(%ebp)
  801c63:	89 f0                	mov    %esi,%eax
  801c65:	8d 70 01             	lea    0x1(%eax),%esi
  801c68:	8a 00                	mov    (%eax),%al
  801c6a:	0f be d8             	movsbl %al,%ebx
  801c6d:	85 db                	test   %ebx,%ebx
  801c6f:	74 24                	je     801c95 <vprintfmt+0x24b>
  801c71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c75:	78 b8                	js     801c2f <vprintfmt+0x1e5>
  801c77:	ff 4d e0             	decl   -0x20(%ebp)
  801c7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c7e:	79 af                	jns    801c2f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c80:	eb 13                	jmp    801c95 <vprintfmt+0x24b>
				putch(' ', putdat);
  801c82:	83 ec 08             	sub    $0x8,%esp
  801c85:	ff 75 0c             	pushl  0xc(%ebp)
  801c88:	6a 20                	push   $0x20
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	ff d0                	call   *%eax
  801c8f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c92:	ff 4d e4             	decl   -0x1c(%ebp)
  801c95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c99:	7f e7                	jg     801c82 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801c9b:	e9 78 01 00 00       	jmp    801e18 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ca0:	83 ec 08             	sub    $0x8,%esp
  801ca3:	ff 75 e8             	pushl  -0x18(%ebp)
  801ca6:	8d 45 14             	lea    0x14(%ebp),%eax
  801ca9:	50                   	push   %eax
  801caa:	e8 3c fd ff ff       	call   8019eb <getint>
  801caf:	83 c4 10             	add    $0x10,%esp
  801cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cbe:	85 d2                	test   %edx,%edx
  801cc0:	79 23                	jns    801ce5 <vprintfmt+0x29b>
				putch('-', putdat);
  801cc2:	83 ec 08             	sub    $0x8,%esp
  801cc5:	ff 75 0c             	pushl  0xc(%ebp)
  801cc8:	6a 2d                	push   $0x2d
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	ff d0                	call   *%eax
  801ccf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd8:	f7 d8                	neg    %eax
  801cda:	83 d2 00             	adc    $0x0,%edx
  801cdd:	f7 da                	neg    %edx
  801cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ce2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801ce5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cec:	e9 bc 00 00 00       	jmp    801dad <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801cf1:	83 ec 08             	sub    $0x8,%esp
  801cf4:	ff 75 e8             	pushl  -0x18(%ebp)
  801cf7:	8d 45 14             	lea    0x14(%ebp),%eax
  801cfa:	50                   	push   %eax
  801cfb:	e8 84 fc ff ff       	call   801984 <getuint>
  801d00:	83 c4 10             	add    $0x10,%esp
  801d03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d09:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d10:	e9 98 00 00 00       	jmp    801dad <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d15:	83 ec 08             	sub    $0x8,%esp
  801d18:	ff 75 0c             	pushl  0xc(%ebp)
  801d1b:	6a 58                	push   $0x58
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	ff d0                	call   *%eax
  801d22:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d25:	83 ec 08             	sub    $0x8,%esp
  801d28:	ff 75 0c             	pushl  0xc(%ebp)
  801d2b:	6a 58                	push   $0x58
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	ff d0                	call   *%eax
  801d32:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d35:	83 ec 08             	sub    $0x8,%esp
  801d38:	ff 75 0c             	pushl  0xc(%ebp)
  801d3b:	6a 58                	push   $0x58
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	ff d0                	call   *%eax
  801d42:	83 c4 10             	add    $0x10,%esp
			break;
  801d45:	e9 ce 00 00 00       	jmp    801e18 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801d4a:	83 ec 08             	sub    $0x8,%esp
  801d4d:	ff 75 0c             	pushl  0xc(%ebp)
  801d50:	6a 30                	push   $0x30
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	ff d0                	call   *%eax
  801d57:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d5a:	83 ec 08             	sub    $0x8,%esp
  801d5d:	ff 75 0c             	pushl  0xc(%ebp)
  801d60:	6a 78                	push   $0x78
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	ff d0                	call   *%eax
  801d67:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6d:	83 c0 04             	add    $0x4,%eax
  801d70:	89 45 14             	mov    %eax,0x14(%ebp)
  801d73:	8b 45 14             	mov    0x14(%ebp),%eax
  801d76:	83 e8 04             	sub    $0x4,%eax
  801d79:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d8c:	eb 1f                	jmp    801dad <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d8e:	83 ec 08             	sub    $0x8,%esp
  801d91:	ff 75 e8             	pushl  -0x18(%ebp)
  801d94:	8d 45 14             	lea    0x14(%ebp),%eax
  801d97:	50                   	push   %eax
  801d98:	e8 e7 fb ff ff       	call   801984 <getuint>
  801d9d:	83 c4 10             	add    $0x10,%esp
  801da0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801da3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801da6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801dad:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801db1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db4:	83 ec 04             	sub    $0x4,%esp
  801db7:	52                   	push   %edx
  801db8:	ff 75 e4             	pushl  -0x1c(%ebp)
  801dbb:	50                   	push   %eax
  801dbc:	ff 75 f4             	pushl  -0xc(%ebp)
  801dbf:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc2:	ff 75 0c             	pushl  0xc(%ebp)
  801dc5:	ff 75 08             	pushl  0x8(%ebp)
  801dc8:	e8 00 fb ff ff       	call   8018cd <printnum>
  801dcd:	83 c4 20             	add    $0x20,%esp
			break;
  801dd0:	eb 46                	jmp    801e18 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801dd2:	83 ec 08             	sub    $0x8,%esp
  801dd5:	ff 75 0c             	pushl  0xc(%ebp)
  801dd8:	53                   	push   %ebx
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	ff d0                	call   *%eax
  801dde:	83 c4 10             	add    $0x10,%esp
			break;
  801de1:	eb 35                	jmp    801e18 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801de3:	c6 05 28 60 80 00 00 	movb   $0x0,0x806028
			break;
  801dea:	eb 2c                	jmp    801e18 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801dec:	c6 05 28 60 80 00 01 	movb   $0x1,0x806028
			break;
  801df3:	eb 23                	jmp    801e18 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801df5:	83 ec 08             	sub    $0x8,%esp
  801df8:	ff 75 0c             	pushl  0xc(%ebp)
  801dfb:	6a 25                	push   $0x25
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	ff d0                	call   *%eax
  801e02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e05:	ff 4d 10             	decl   0x10(%ebp)
  801e08:	eb 03                	jmp    801e0d <vprintfmt+0x3c3>
  801e0a:	ff 4d 10             	decl   0x10(%ebp)
  801e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e10:	48                   	dec    %eax
  801e11:	8a 00                	mov    (%eax),%al
  801e13:	3c 25                	cmp    $0x25,%al
  801e15:	75 f3                	jne    801e0a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801e17:	90                   	nop
		}
	}
  801e18:	e9 35 fc ff ff       	jmp    801a52 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e21:	5b                   	pop    %ebx
  801e22:	5e                   	pop    %esi
  801e23:	5d                   	pop    %ebp
  801e24:	c3                   	ret    

00801e25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e2b:	8d 45 10             	lea    0x10(%ebp),%eax
  801e2e:	83 c0 04             	add    $0x4,%eax
  801e31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801e34:	8b 45 10             	mov    0x10(%ebp),%eax
  801e37:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3a:	50                   	push   %eax
  801e3b:	ff 75 0c             	pushl  0xc(%ebp)
  801e3e:	ff 75 08             	pushl  0x8(%ebp)
  801e41:	e8 04 fc ff ff       	call   801a4a <vprintfmt>
  801e46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e49:	90                   	nop
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e52:	8b 40 08             	mov    0x8(%eax),%eax
  801e55:	8d 50 01             	lea    0x1(%eax),%edx
  801e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e61:	8b 10                	mov    (%eax),%edx
  801e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e66:	8b 40 04             	mov    0x4(%eax),%eax
  801e69:	39 c2                	cmp    %eax,%edx
  801e6b:	73 12                	jae    801e7f <sprintputch+0x33>
		*b->buf++ = ch;
  801e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e70:	8b 00                	mov    (%eax),%eax
  801e72:	8d 48 01             	lea    0x1(%eax),%ecx
  801e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e78:	89 0a                	mov    %ecx,(%edx)
  801e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  801e7d:	88 10                	mov    %dl,(%eax)
}
  801e7f:	90                   	nop
  801e80:	5d                   	pop    %ebp
  801e81:	c3                   	ret    

00801e82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e91:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e94:	8b 45 08             	mov    0x8(%ebp),%eax
  801e97:	01 d0                	add    %edx,%eax
  801e99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ea3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ea7:	74 06                	je     801eaf <vsnprintf+0x2d>
  801ea9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ead:	7f 07                	jg     801eb6 <vsnprintf+0x34>
		return -E_INVAL;
  801eaf:	b8 03 00 00 00       	mov    $0x3,%eax
  801eb4:	eb 20                	jmp    801ed6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801eb6:	ff 75 14             	pushl  0x14(%ebp)
  801eb9:	ff 75 10             	pushl  0x10(%ebp)
  801ebc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ebf:	50                   	push   %eax
  801ec0:	68 4c 1e 80 00       	push   $0x801e4c
  801ec5:	e8 80 fb ff ff       	call   801a4a <vprintfmt>
  801eca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ecd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801ede:	8d 45 10             	lea    0x10(%ebp),%eax
  801ee1:	83 c0 04             	add    $0x4,%eax
  801ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801ee7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eea:	ff 75 f4             	pushl  -0xc(%ebp)
  801eed:	50                   	push   %eax
  801eee:	ff 75 0c             	pushl  0xc(%ebp)
  801ef1:	ff 75 08             	pushl  0x8(%ebp)
  801ef4:	e8 89 ff ff ff       	call   801e82 <vsnprintf>
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f11:	eb 06                	jmp    801f19 <strlen+0x15>
		n++;
  801f13:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f16:	ff 45 08             	incl   0x8(%ebp)
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	8a 00                	mov    (%eax),%al
  801f1e:	84 c0                	test   %al,%al
  801f20:	75 f1                	jne    801f13 <strlen+0xf>
		n++;
	return n;
  801f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f34:	eb 09                	jmp    801f3f <strnlen+0x18>
		n++;
  801f36:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f39:	ff 45 08             	incl   0x8(%ebp)
  801f3c:	ff 4d 0c             	decl   0xc(%ebp)
  801f3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f43:	74 09                	je     801f4e <strnlen+0x27>
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	8a 00                	mov    (%eax),%al
  801f4a:	84 c0                	test   %al,%al
  801f4c:	75 e8                	jne    801f36 <strnlen+0xf>
		n++;
	return n;
  801f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f5f:	90                   	nop
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	8d 50 01             	lea    0x1(%eax),%edx
  801f66:	89 55 08             	mov    %edx,0x8(%ebp)
  801f69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f72:	8a 12                	mov    (%edx),%dl
  801f74:	88 10                	mov    %dl,(%eax)
  801f76:	8a 00                	mov    (%eax),%al
  801f78:	84 c0                	test   %al,%al
  801f7a:	75 e4                	jne    801f60 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f94:	eb 1f                	jmp    801fb5 <strncpy+0x34>
		*dst++ = *src;
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	8d 50 01             	lea    0x1(%eax),%edx
  801f9c:	89 55 08             	mov    %edx,0x8(%ebp)
  801f9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa2:	8a 12                	mov    (%edx),%dl
  801fa4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa9:	8a 00                	mov    (%eax),%al
  801fab:	84 c0                	test   %al,%al
  801fad:	74 03                	je     801fb2 <strncpy+0x31>
			src++;
  801faf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fb2:	ff 45 fc             	incl   -0x4(%ebp)
  801fb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb8:	3b 45 10             	cmp    0x10(%ebp),%eax
  801fbb:	72 d9                	jb     801f96 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801fbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801fce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fd2:	74 30                	je     802004 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801fd4:	eb 16                	jmp    801fec <strlcpy+0x2a>
			*dst++ = *src++;
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	8d 50 01             	lea    0x1(%eax),%edx
  801fdc:	89 55 08             	mov    %edx,0x8(%ebp)
  801fdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe2:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fe5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fe8:	8a 12                	mov    (%edx),%dl
  801fea:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801fec:	ff 4d 10             	decl   0x10(%ebp)
  801fef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ff3:	74 09                	je     801ffe <strlcpy+0x3c>
  801ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff8:	8a 00                	mov    (%eax),%al
  801ffa:	84 c0                	test   %al,%al
  801ffc:	75 d8                	jne    801fd6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802004:	8b 55 08             	mov    0x8(%ebp),%edx
  802007:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80200a:	29 c2                	sub    %eax,%edx
  80200c:	89 d0                	mov    %edx,%eax
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802013:	eb 06                	jmp    80201b <strcmp+0xb>
		p++, q++;
  802015:	ff 45 08             	incl   0x8(%ebp)
  802018:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	8a 00                	mov    (%eax),%al
  802020:	84 c0                	test   %al,%al
  802022:	74 0e                	je     802032 <strcmp+0x22>
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8a 10                	mov    (%eax),%dl
  802029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202c:	8a 00                	mov    (%eax),%al
  80202e:	38 c2                	cmp    %al,%dl
  802030:	74 e3                	je     802015 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	8a 00                	mov    (%eax),%al
  802037:	0f b6 d0             	movzbl %al,%edx
  80203a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203d:	8a 00                	mov    (%eax),%al
  80203f:	0f b6 c0             	movzbl %al,%eax
  802042:	29 c2                	sub    %eax,%edx
  802044:	89 d0                	mov    %edx,%eax
}
  802046:	5d                   	pop    %ebp
  802047:	c3                   	ret    

00802048 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80204b:	eb 09                	jmp    802056 <strncmp+0xe>
		n--, p++, q++;
  80204d:	ff 4d 10             	decl   0x10(%ebp)
  802050:	ff 45 08             	incl   0x8(%ebp)
  802053:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802056:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80205a:	74 17                	je     802073 <strncmp+0x2b>
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	8a 00                	mov    (%eax),%al
  802061:	84 c0                	test   %al,%al
  802063:	74 0e                	je     802073 <strncmp+0x2b>
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	8a 10                	mov    (%eax),%dl
  80206a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206d:	8a 00                	mov    (%eax),%al
  80206f:	38 c2                	cmp    %al,%dl
  802071:	74 da                	je     80204d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802073:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802077:	75 07                	jne    802080 <strncmp+0x38>
		return 0;
  802079:	b8 00 00 00 00       	mov    $0x0,%eax
  80207e:	eb 14                	jmp    802094 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	8a 00                	mov    (%eax),%al
  802085:	0f b6 d0             	movzbl %al,%edx
  802088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208b:	8a 00                	mov    (%eax),%al
  80208d:	0f b6 c0             	movzbl %al,%eax
  802090:	29 c2                	sub    %eax,%edx
  802092:	89 d0                	mov    %edx,%eax
}
  802094:	5d                   	pop    %ebp
  802095:	c3                   	ret    

00802096 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 04             	sub    $0x4,%esp
  80209c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020a2:	eb 12                	jmp    8020b6 <strchr+0x20>
		if (*s == c)
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	8a 00                	mov    (%eax),%al
  8020a9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020ac:	75 05                	jne    8020b3 <strchr+0x1d>
			return (char *) s;
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	eb 11                	jmp    8020c4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020b3:	ff 45 08             	incl   0x8(%ebp)
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	8a 00                	mov    (%eax),%al
  8020bb:	84 c0                	test   %al,%al
  8020bd:	75 e5                	jne    8020a4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8020bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020d2:	eb 0d                	jmp    8020e1 <strfind+0x1b>
		if (*s == c)
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	8a 00                	mov    (%eax),%al
  8020d9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020dc:	74 0e                	je     8020ec <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020de:	ff 45 08             	incl   0x8(%ebp)
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8a 00                	mov    (%eax),%al
  8020e6:	84 c0                	test   %al,%al
  8020e8:	75 ea                	jne    8020d4 <strfind+0xe>
  8020ea:	eb 01                	jmp    8020ed <strfind+0x27>
		if (*s == c)
			break;
  8020ec:	90                   	nop
	return (char *) s;
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8020fe:	8b 45 10             	mov    0x10(%ebp),%eax
  802101:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  802104:	eb 0e                	jmp    802114 <memset+0x22>
		*p++ = c;
  802106:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802109:	8d 50 01             	lea    0x1(%eax),%edx
  80210c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80210f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802112:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  802114:	ff 4d f8             	decl   -0x8(%ebp)
  802117:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80211b:	79 e9                	jns    802106 <memset+0x14>
		*p++ = c;

	return v;
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  802134:	eb 16                	jmp    80214c <memcpy+0x2a>
		*d++ = *s++;
  802136:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802139:	8d 50 01             	lea    0x1(%eax),%edx
  80213c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80213f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802142:	8d 4a 01             	lea    0x1(%edx),%ecx
  802145:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802148:	8a 12                	mov    (%edx),%dl
  80214a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80214c:	8b 45 10             	mov    0x10(%ebp),%eax
  80214f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802152:	89 55 10             	mov    %edx,0x10(%ebp)
  802155:	85 c0                	test   %eax,%eax
  802157:	75 dd                	jne    802136 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802164:	8b 45 0c             	mov    0xc(%ebp),%eax
  802167:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802170:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802173:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802176:	73 50                	jae    8021c8 <memmove+0x6a>
  802178:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80217b:	8b 45 10             	mov    0x10(%ebp),%eax
  80217e:	01 d0                	add    %edx,%eax
  802180:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802183:	76 43                	jbe    8021c8 <memmove+0x6a>
		s += n;
  802185:	8b 45 10             	mov    0x10(%ebp),%eax
  802188:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80218b:	8b 45 10             	mov    0x10(%ebp),%eax
  80218e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802191:	eb 10                	jmp    8021a3 <memmove+0x45>
			*--d = *--s;
  802193:	ff 4d f8             	decl   -0x8(%ebp)
  802196:	ff 4d fc             	decl   -0x4(%ebp)
  802199:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219c:	8a 10                	mov    (%eax),%dl
  80219e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021a1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8021a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8021ac:	85 c0                	test   %eax,%eax
  8021ae:	75 e3                	jne    802193 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8021b0:	eb 23                	jmp    8021d5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8021b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021b5:	8d 50 01             	lea    0x1(%eax),%edx
  8021b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021c1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8021c4:	8a 12                	mov    (%edx),%dl
  8021c6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8021c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8021cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	75 dd                	jne    8021b2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8021ec:	eb 2a                	jmp    802218 <memcmp+0x3e>
		if (*s1 != *s2)
  8021ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f1:	8a 10                	mov    (%eax),%dl
  8021f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021f6:	8a 00                	mov    (%eax),%al
  8021f8:	38 c2                	cmp    %al,%dl
  8021fa:	74 16                	je     802212 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8021fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ff:	8a 00                	mov    (%eax),%al
  802201:	0f b6 d0             	movzbl %al,%edx
  802204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802207:	8a 00                	mov    (%eax),%al
  802209:	0f b6 c0             	movzbl %al,%eax
  80220c:	29 c2                	sub    %eax,%edx
  80220e:	89 d0                	mov    %edx,%eax
  802210:	eb 18                	jmp    80222a <memcmp+0x50>
		s1++, s2++;
  802212:	ff 45 fc             	incl   -0x4(%ebp)
  802215:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802218:	8b 45 10             	mov    0x10(%ebp),%eax
  80221b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80221e:	89 55 10             	mov    %edx,0x10(%ebp)
  802221:	85 c0                	test   %eax,%eax
  802223:	75 c9                	jne    8021ee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802232:	8b 55 08             	mov    0x8(%ebp),%edx
  802235:	8b 45 10             	mov    0x10(%ebp),%eax
  802238:	01 d0                	add    %edx,%eax
  80223a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80223d:	eb 15                	jmp    802254 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	8a 00                	mov    (%eax),%al
  802244:	0f b6 d0             	movzbl %al,%edx
  802247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224a:	0f b6 c0             	movzbl %al,%eax
  80224d:	39 c2                	cmp    %eax,%edx
  80224f:	74 0d                	je     80225e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802251:	ff 45 08             	incl   0x8(%ebp)
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80225a:	72 e3                	jb     80223f <memfind+0x13>
  80225c:	eb 01                	jmp    80225f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80225e:	90                   	nop
	return (void *) s;
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80226a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802271:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802278:	eb 03                	jmp    80227d <strtol+0x19>
		s++;
  80227a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	8a 00                	mov    (%eax),%al
  802282:	3c 20                	cmp    $0x20,%al
  802284:	74 f4                	je     80227a <strtol+0x16>
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	8a 00                	mov    (%eax),%al
  80228b:	3c 09                	cmp    $0x9,%al
  80228d:	74 eb                	je     80227a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	8a 00                	mov    (%eax),%al
  802294:	3c 2b                	cmp    $0x2b,%al
  802296:	75 05                	jne    80229d <strtol+0x39>
		s++;
  802298:	ff 45 08             	incl   0x8(%ebp)
  80229b:	eb 13                	jmp    8022b0 <strtol+0x4c>
	else if (*s == '-')
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	8a 00                	mov    (%eax),%al
  8022a2:	3c 2d                	cmp    $0x2d,%al
  8022a4:	75 0a                	jne    8022b0 <strtol+0x4c>
		s++, neg = 1;
  8022a6:	ff 45 08             	incl   0x8(%ebp)
  8022a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8022b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022b4:	74 06                	je     8022bc <strtol+0x58>
  8022b6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8022ba:	75 20                	jne    8022dc <strtol+0x78>
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	8a 00                	mov    (%eax),%al
  8022c1:	3c 30                	cmp    $0x30,%al
  8022c3:	75 17                	jne    8022dc <strtol+0x78>
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	40                   	inc    %eax
  8022c9:	8a 00                	mov    (%eax),%al
  8022cb:	3c 78                	cmp    $0x78,%al
  8022cd:	75 0d                	jne    8022dc <strtol+0x78>
		s += 2, base = 16;
  8022cf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8022d3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8022da:	eb 28                	jmp    802304 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8022dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022e0:	75 15                	jne    8022f7 <strtol+0x93>
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	8a 00                	mov    (%eax),%al
  8022e7:	3c 30                	cmp    $0x30,%al
  8022e9:	75 0c                	jne    8022f7 <strtol+0x93>
		s++, base = 8;
  8022eb:	ff 45 08             	incl   0x8(%ebp)
  8022ee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8022f5:	eb 0d                	jmp    802304 <strtol+0xa0>
	else if (base == 0)
  8022f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022fb:	75 07                	jne    802304 <strtol+0xa0>
		base = 10;
  8022fd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	8a 00                	mov    (%eax),%al
  802309:	3c 2f                	cmp    $0x2f,%al
  80230b:	7e 19                	jle    802326 <strtol+0xc2>
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	8a 00                	mov    (%eax),%al
  802312:	3c 39                	cmp    $0x39,%al
  802314:	7f 10                	jg     802326 <strtol+0xc2>
			dig = *s - '0';
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	8a 00                	mov    (%eax),%al
  80231b:	0f be c0             	movsbl %al,%eax
  80231e:	83 e8 30             	sub    $0x30,%eax
  802321:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802324:	eb 42                	jmp    802368 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	8a 00                	mov    (%eax),%al
  80232b:	3c 60                	cmp    $0x60,%al
  80232d:	7e 19                	jle    802348 <strtol+0xe4>
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	8a 00                	mov    (%eax),%al
  802334:	3c 7a                	cmp    $0x7a,%al
  802336:	7f 10                	jg     802348 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	8a 00                	mov    (%eax),%al
  80233d:	0f be c0             	movsbl %al,%eax
  802340:	83 e8 57             	sub    $0x57,%eax
  802343:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802346:	eb 20                	jmp    802368 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	8a 00                	mov    (%eax),%al
  80234d:	3c 40                	cmp    $0x40,%al
  80234f:	7e 39                	jle    80238a <strtol+0x126>
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	8a 00                	mov    (%eax),%al
  802356:	3c 5a                	cmp    $0x5a,%al
  802358:	7f 30                	jg     80238a <strtol+0x126>
			dig = *s - 'A' + 10;
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	8a 00                	mov    (%eax),%al
  80235f:	0f be c0             	movsbl %al,%eax
  802362:	83 e8 37             	sub    $0x37,%eax
  802365:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80236e:	7d 19                	jge    802389 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802370:	ff 45 08             	incl   0x8(%ebp)
  802373:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802376:	0f af 45 10          	imul   0x10(%ebp),%eax
  80237a:	89 c2                	mov    %eax,%edx
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	01 d0                	add    %edx,%eax
  802381:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802384:	e9 7b ff ff ff       	jmp    802304 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802389:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80238a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80238e:	74 08                	je     802398 <strtol+0x134>
		*endptr = (char *) s;
  802390:	8b 45 0c             	mov    0xc(%ebp),%eax
  802393:	8b 55 08             	mov    0x8(%ebp),%edx
  802396:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802398:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80239c:	74 07                	je     8023a5 <strtol+0x141>
  80239e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023a1:	f7 d8                	neg    %eax
  8023a3:	eb 03                	jmp    8023a8 <strtol+0x144>
  8023a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <ltostr>:

void
ltostr(long value, char *str)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8023b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8023b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8023be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c2:	79 13                	jns    8023d7 <ltostr+0x2d>
	{
		neg = 1;
  8023c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8023cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8023d1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8023d4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8023df:	99                   	cltd   
  8023e0:	f7 f9                	idiv   %ecx
  8023e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8023e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023e8:	8d 50 01             	lea    0x1(%eax),%edx
  8023eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023ee:	89 c2                	mov    %eax,%edx
  8023f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f3:	01 d0                	add    %edx,%eax
  8023f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023f8:	83 c2 30             	add    $0x30,%edx
  8023fb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8023fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802400:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802405:	f7 e9                	imul   %ecx
  802407:	c1 fa 02             	sar    $0x2,%edx
  80240a:	89 c8                	mov    %ecx,%eax
  80240c:	c1 f8 1f             	sar    $0x1f,%eax
  80240f:	29 c2                	sub    %eax,%edx
  802411:	89 d0                	mov    %edx,%eax
  802413:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802416:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80241a:	75 bb                	jne    8023d7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80241c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802423:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802426:	48                   	dec    %eax
  802427:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80242a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80242e:	74 3d                	je     80246d <ltostr+0xc3>
		start = 1 ;
  802430:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802437:	eb 34                	jmp    80246d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243f:	01 d0                	add    %edx,%eax
  802441:	8a 00                	mov    (%eax),%al
  802443:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244c:	01 c2                	add    %eax,%edx
  80244e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802451:	8b 45 0c             	mov    0xc(%ebp),%eax
  802454:	01 c8                	add    %ecx,%eax
  802456:	8a 00                	mov    (%eax),%al
  802458:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80245a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80245d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802460:	01 c2                	add    %eax,%edx
  802462:	8a 45 eb             	mov    -0x15(%ebp),%al
  802465:	88 02                	mov    %al,(%edx)
		start++ ;
  802467:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80246a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802473:	7c c4                	jl     802439 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802475:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247b:	01 d0                	add    %edx,%eax
  80247d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802480:	90                   	nop
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802489:	ff 75 08             	pushl  0x8(%ebp)
  80248c:	e8 73 fa ff ff       	call   801f04 <strlen>
  802491:	83 c4 04             	add    $0x4,%esp
  802494:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802497:	ff 75 0c             	pushl  0xc(%ebp)
  80249a:	e8 65 fa ff ff       	call   801f04 <strlen>
  80249f:	83 c4 04             	add    $0x4,%esp
  8024a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8024a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8024ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024b3:	eb 17                	jmp    8024cc <strcconcat+0x49>
		final[s] = str1[s] ;
  8024b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024bb:	01 c2                	add    %eax,%edx
  8024bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	01 c8                	add    %ecx,%eax
  8024c5:	8a 00                	mov    (%eax),%al
  8024c7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8024c9:	ff 45 fc             	incl   -0x4(%ebp)
  8024cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024d2:	7c e1                	jl     8024b5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8024d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8024db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8024e2:	eb 1f                	jmp    802503 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8024e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024e7:	8d 50 01             	lea    0x1(%eax),%edx
  8024ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8024ed:	89 c2                	mov    %eax,%edx
  8024ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f2:	01 c2                	add    %eax,%edx
  8024f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8024f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fa:	01 c8                	add    %ecx,%eax
  8024fc:	8a 00                	mov    (%eax),%al
  8024fe:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802500:	ff 45 f8             	incl   -0x8(%ebp)
  802503:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802506:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802509:	7c d9                	jl     8024e4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80250b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80250e:	8b 45 10             	mov    0x10(%ebp),%eax
  802511:	01 d0                	add    %edx,%eax
  802513:	c6 00 00             	movb   $0x0,(%eax)
}
  802516:	90                   	nop
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80251c:	8b 45 14             	mov    0x14(%ebp),%eax
  80251f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802525:	8b 45 14             	mov    0x14(%ebp),%eax
  802528:	8b 00                	mov    (%eax),%eax
  80252a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802531:	8b 45 10             	mov    0x10(%ebp),%eax
  802534:	01 d0                	add    %edx,%eax
  802536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80253c:	eb 0c                	jmp    80254a <strsplit+0x31>
			*string++ = 0;
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	8d 50 01             	lea    0x1(%eax),%edx
  802544:	89 55 08             	mov    %edx,0x8(%ebp)
  802547:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	8a 00                	mov    (%eax),%al
  80254f:	84 c0                	test   %al,%al
  802551:	74 18                	je     80256b <strsplit+0x52>
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	8a 00                	mov    (%eax),%al
  802558:	0f be c0             	movsbl %al,%eax
  80255b:	50                   	push   %eax
  80255c:	ff 75 0c             	pushl  0xc(%ebp)
  80255f:	e8 32 fb ff ff       	call   802096 <strchr>
  802564:	83 c4 08             	add    $0x8,%esp
  802567:	85 c0                	test   %eax,%eax
  802569:	75 d3                	jne    80253e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	8a 00                	mov    (%eax),%al
  802570:	84 c0                	test   %al,%al
  802572:	74 5a                	je     8025ce <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802574:	8b 45 14             	mov    0x14(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	83 f8 0f             	cmp    $0xf,%eax
  80257c:	75 07                	jne    802585 <strsplit+0x6c>
		{
			return 0;
  80257e:	b8 00 00 00 00       	mov    $0x0,%eax
  802583:	eb 66                	jmp    8025eb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802585:	8b 45 14             	mov    0x14(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	8d 48 01             	lea    0x1(%eax),%ecx
  80258d:	8b 55 14             	mov    0x14(%ebp),%edx
  802590:	89 0a                	mov    %ecx,(%edx)
  802592:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802599:	8b 45 10             	mov    0x10(%ebp),%eax
  80259c:	01 c2                	add    %eax,%edx
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025a3:	eb 03                	jmp    8025a8 <strsplit+0x8f>
			string++;
  8025a5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ab:	8a 00                	mov    (%eax),%al
  8025ad:	84 c0                	test   %al,%al
  8025af:	74 8b                	je     80253c <strsplit+0x23>
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	8a 00                	mov    (%eax),%al
  8025b6:	0f be c0             	movsbl %al,%eax
  8025b9:	50                   	push   %eax
  8025ba:	ff 75 0c             	pushl  0xc(%ebp)
  8025bd:	e8 d4 fa ff ff       	call   802096 <strchr>
  8025c2:	83 c4 08             	add    $0x8,%esp
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	74 dc                	je     8025a5 <strsplit+0x8c>
			string++;
	}
  8025c9:	e9 6e ff ff ff       	jmp    80253c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8025ce:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8025cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025db:	8b 45 10             	mov    0x10(%ebp),%eax
  8025de:	01 d0                	add    %edx,%eax
  8025e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8025e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025eb:	c9                   	leave  
  8025ec:	c3                   	ret    

008025ed <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
  8025f0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8025f3:	83 ec 04             	sub    $0x4,%esp
  8025f6:	68 08 57 80 00       	push   $0x805708
  8025fb:	68 3f 01 00 00       	push   $0x13f
  802600:	68 2a 57 80 00       	push   $0x80572a
  802605:	e8 a9 ef ff ff       	call   8015b3 <_panic>

0080260a <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  802610:	83 ec 0c             	sub    $0xc,%esp
  802613:	ff 75 08             	pushl  0x8(%ebp)
  802616:	e8 f8 0a 00 00       	call   803113 <sys_sbrk>
  80261b:	83 c4 10             	add    $0x10,%esp
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802626:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80262a:	75 0a                	jne    802636 <malloc+0x16>
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
  802631:	e9 07 02 00 00       	jmp    80283d <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  802636:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80263d:	8b 55 08             	mov    0x8(%ebp),%edx
  802640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802643:	01 d0                	add    %edx,%eax
  802645:	48                   	dec    %eax
  802646:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802649:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80264c:	ba 00 00 00 00       	mov    $0x0,%edx
  802651:	f7 75 dc             	divl   -0x24(%ebp)
  802654:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802657:	29 d0                	sub    %edx,%eax
  802659:	c1 e8 0c             	shr    $0xc,%eax
  80265c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80265f:	a1 20 60 80 00       	mov    0x806020,%eax
  802664:	8b 40 78             	mov    0x78(%eax),%eax
  802667:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  80266c:	29 c2                	sub    %eax,%edx
  80266e:	89 d0                	mov    %edx,%eax
  802670:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802673:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802676:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80267b:	c1 e8 0c             	shr    $0xc,%eax
  80267e:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  802681:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  802688:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80268f:	77 42                	ja     8026d3 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802691:	e8 01 09 00 00       	call   802f97 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802696:	85 c0                	test   %eax,%eax
  802698:	74 16                	je     8026b0 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  80269a:	83 ec 0c             	sub    $0xc,%esp
  80269d:	ff 75 08             	pushl  0x8(%ebp)
  8026a0:	e8 dd 0e 00 00       	call   803582 <alloc_block_FF>
  8026a5:	83 c4 10             	add    $0x10,%esp
  8026a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ab:	e9 8a 01 00 00       	jmp    80283a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8026b0:	e8 13 09 00 00       	call   802fc8 <sys_isUHeapPlacementStrategyBESTFIT>
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	0f 84 7d 01 00 00    	je     80283a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	ff 75 08             	pushl  0x8(%ebp)
  8026c3:	e8 76 13 00 00       	call   803a3e <alloc_block_BF>
  8026c8:	83 c4 10             	add    $0x10,%esp
  8026cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ce:	e9 67 01 00 00       	jmp    80283a <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8026d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026d6:	48                   	dec    %eax
  8026d7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8026da:	0f 86 53 01 00 00    	jbe    802833 <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8026e0:	a1 20 60 80 00       	mov    0x806020,%eax
  8026e5:	8b 40 78             	mov    0x78(%eax),%eax
  8026e8:	05 00 10 00 00       	add    $0x1000,%eax
  8026ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8026f0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8026f7:	e9 de 00 00 00       	jmp    8027da <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8026fc:	a1 20 60 80 00       	mov    0x806020,%eax
  802701:	8b 40 78             	mov    0x78(%eax),%eax
  802704:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802707:	29 c2                	sub    %eax,%edx
  802709:	89 d0                	mov    %edx,%eax
  80270b:	2d 00 10 00 00       	sub    $0x1000,%eax
  802710:	c1 e8 0c             	shr    $0xc,%eax
  802713:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  80271a:	85 c0                	test   %eax,%eax
  80271c:	0f 85 ab 00 00 00    	jne    8027cd <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  802722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802725:	05 00 10 00 00       	add    $0x1000,%eax
  80272a:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80272d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  802734:	eb 47                	jmp    80277d <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  802736:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80273d:	76 0a                	jbe    802749 <malloc+0x129>
  80273f:	b8 00 00 00 00       	mov    $0x0,%eax
  802744:	e9 f4 00 00 00       	jmp    80283d <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  802749:	a1 20 60 80 00       	mov    0x806020,%eax
  80274e:	8b 40 78             	mov    0x78(%eax),%eax
  802751:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802754:	29 c2                	sub    %eax,%edx
  802756:	89 d0                	mov    %edx,%eax
  802758:	2d 00 10 00 00       	sub    $0x1000,%eax
  80275d:	c1 e8 0c             	shr    $0xc,%eax
  802760:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	74 08                	je     802773 <malloc+0x153>
					{
						
						i = j;
  80276b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  802771:	eb 5a                	jmp    8027cd <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  802773:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80277a:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  80277d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802780:	48                   	dec    %eax
  802781:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802784:	77 b0                	ja     802736 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  802786:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  80278d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802794:	eb 2f                	jmp    8027c5 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  802796:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802799:	c1 e0 0c             	shl    $0xc,%eax
  80279c:	89 c2                	mov    %eax,%edx
  80279e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a1:	01 c2                	add    %eax,%edx
  8027a3:	a1 20 60 80 00       	mov    0x806020,%eax
  8027a8:	8b 40 78             	mov    0x78(%eax),%eax
  8027ab:	29 c2                	sub    %eax,%edx
  8027ad:	89 d0                	mov    %edx,%eax
  8027af:	2d 00 10 00 00       	sub    $0x1000,%eax
  8027b4:	c1 e8 0c             	shr    $0xc,%eax
  8027b7:	c7 04 85 60 60 88 00 	movl   $0x1,0x886060(,%eax,4)
  8027be:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  8027c2:	ff 45 e0             	incl   -0x20(%ebp)
  8027c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8027cb:	72 c9                	jb     802796 <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  8027cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027d1:	75 16                	jne    8027e9 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8027d3:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8027da:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8027e1:	0f 86 15 ff ff ff    	jbe    8026fc <malloc+0xdc>
  8027e7:	eb 01                	jmp    8027ea <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  8027e9:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8027ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ee:	75 07                	jne    8027f7 <malloc+0x1d7>
  8027f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f5:	eb 46                	jmp    80283d <malloc+0x21d>
		ptr = (void*)i;
  8027f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8027fd:	a1 20 60 80 00       	mov    0x806020,%eax
  802802:	8b 40 78             	mov    0x78(%eax),%eax
  802805:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802808:	29 c2                	sub    %eax,%edx
  80280a:	89 d0                	mov    %edx,%eax
  80280c:	2d 00 10 00 00       	sub    $0x1000,%eax
  802811:	c1 e8 0c             	shr    $0xc,%eax
  802814:	89 c2                	mov    %eax,%edx
  802816:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802819:	89 04 95 60 60 90 00 	mov    %eax,0x906060(,%edx,4)
		sys_allocate_user_mem(i, size);
  802820:	83 ec 08             	sub    $0x8,%esp
  802823:	ff 75 08             	pushl  0x8(%ebp)
  802826:	ff 75 f0             	pushl  -0x10(%ebp)
  802829:	e8 1c 09 00 00       	call   80314a <sys_allocate_user_mem>
  80282e:	83 c4 10             	add    $0x10,%esp
  802831:	eb 07                	jmp    80283a <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  802833:	b8 00 00 00 00       	mov    $0x0,%eax
  802838:	eb 03                	jmp    80283d <malloc+0x21d>
	}
	return ptr;
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80283d:	c9                   	leave  
  80283e:	c3                   	ret    

0080283f <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  802845:	a1 20 60 80 00       	mov    0x806020,%eax
  80284a:	8b 40 78             	mov    0x78(%eax),%eax
  80284d:	05 00 10 00 00       	add    $0x1000,%eax
  802852:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  802855:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  80285c:	a1 20 60 80 00       	mov    0x806020,%eax
  802861:	8b 50 78             	mov    0x78(%eax),%edx
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	39 c2                	cmp    %eax,%edx
  802869:	76 24                	jbe    80288f <free+0x50>
		size = get_block_size(va);
  80286b:	83 ec 0c             	sub    $0xc,%esp
  80286e:	ff 75 08             	pushl  0x8(%ebp)
  802871:	e8 8c 09 00 00       	call   803202 <get_block_size>
  802876:	83 c4 10             	add    $0x10,%esp
  802879:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80287c:	83 ec 0c             	sub    $0xc,%esp
  80287f:	ff 75 08             	pushl  0x8(%ebp)
  802882:	e8 9c 1b 00 00       	call   804423 <free_block>
  802887:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80288a:	e9 ac 00 00 00       	jmp    80293b <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802895:	0f 82 89 00 00 00    	jb     802924 <free+0xe5>
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  8028a3:	77 7f                	ja     802924 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  8028a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a8:	a1 20 60 80 00       	mov    0x806020,%eax
  8028ad:	8b 40 78             	mov    0x78(%eax),%eax
  8028b0:	29 c2                	sub    %eax,%edx
  8028b2:	89 d0                	mov    %edx,%eax
  8028b4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8028b9:	c1 e8 0c             	shr    $0xc,%eax
  8028bc:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
  8028c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8028c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c9:	c1 e0 0c             	shl    $0xc,%eax
  8028cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8028cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028d6:	eb 42                	jmp    80291a <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	c1 e0 0c             	shl    $0xc,%eax
  8028de:	89 c2                	mov    %eax,%edx
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	01 c2                	add    %eax,%edx
  8028e5:	a1 20 60 80 00       	mov    0x806020,%eax
  8028ea:	8b 40 78             	mov    0x78(%eax),%eax
  8028ed:	29 c2                	sub    %eax,%edx
  8028ef:	89 d0                	mov    %edx,%eax
  8028f1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8028f6:	c1 e8 0c             	shr    $0xc,%eax
  8028f9:	c7 04 85 60 60 88 00 	movl   $0x0,0x886060(,%eax,4)
  802900:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  802904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	83 ec 08             	sub    $0x8,%esp
  80290d:	52                   	push   %edx
  80290e:	50                   	push   %eax
  80290f:	e8 1a 08 00 00       	call   80312e <sys_free_user_mem>
  802914:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  802917:	ff 45 f4             	incl   -0xc(%ebp)
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802920:	72 b6                	jb     8028d8 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  802922:	eb 17                	jmp    80293b <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  802924:	83 ec 04             	sub    $0x4,%esp
  802927:	68 38 57 80 00       	push   $0x805738
  80292c:	68 87 00 00 00       	push   $0x87
  802931:	68 62 57 80 00       	push   $0x805762
  802936:	e8 78 ec ff ff       	call   8015b3 <_panic>
	}
}
  80293b:	90                   	nop
  80293c:	c9                   	leave  
  80293d:	c3                   	ret    

0080293e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80293e:	55                   	push   %ebp
  80293f:	89 e5                	mov    %esp,%ebp
  802941:	83 ec 28             	sub    $0x28,%esp
  802944:	8b 45 10             	mov    0x10(%ebp),%eax
  802947:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80294a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80294e:	75 0a                	jne    80295a <smalloc+0x1c>
  802950:	b8 00 00 00 00       	mov    $0x0,%eax
  802955:	e9 87 00 00 00       	jmp    8029e1 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80295a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80295d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802960:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802967:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	39 d0                	cmp    %edx,%eax
  80296f:	73 02                	jae    802973 <smalloc+0x35>
  802971:	89 d0                	mov    %edx,%eax
  802973:	83 ec 0c             	sub    $0xc,%esp
  802976:	50                   	push   %eax
  802977:	e8 a4 fc ff ff       	call   802620 <malloc>
  80297c:	83 c4 10             	add    $0x10,%esp
  80297f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802982:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802986:	75 07                	jne    80298f <smalloc+0x51>
  802988:	b8 00 00 00 00       	mov    $0x0,%eax
  80298d:	eb 52                	jmp    8029e1 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80298f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802993:	ff 75 ec             	pushl  -0x14(%ebp)
  802996:	50                   	push   %eax
  802997:	ff 75 0c             	pushl  0xc(%ebp)
  80299a:	ff 75 08             	pushl  0x8(%ebp)
  80299d:	e8 93 03 00 00       	call   802d35 <sys_createSharedObject>
  8029a2:	83 c4 10             	add    $0x10,%esp
  8029a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8029a8:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8029ac:	74 06                	je     8029b4 <smalloc+0x76>
  8029ae:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8029b2:	75 07                	jne    8029bb <smalloc+0x7d>
  8029b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b9:	eb 26                	jmp    8029e1 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8029bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029be:	a1 20 60 80 00       	mov    0x806020,%eax
  8029c3:	8b 40 78             	mov    0x78(%eax),%eax
  8029c6:	29 c2                	sub    %eax,%edx
  8029c8:	89 d0                	mov    %edx,%eax
  8029ca:	2d 00 10 00 00       	sub    $0x1000,%eax
  8029cf:	c1 e8 0c             	shr    $0xc,%eax
  8029d2:	89 c2                	mov    %eax,%edx
  8029d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d7:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  8029de:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8029e1:	c9                   	leave  
  8029e2:	c3                   	ret    

008029e3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8029e3:	55                   	push   %ebp
  8029e4:	89 e5                	mov    %esp,%ebp
  8029e6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8029e9:	83 ec 08             	sub    $0x8,%esp
  8029ec:	ff 75 0c             	pushl  0xc(%ebp)
  8029ef:	ff 75 08             	pushl  0x8(%ebp)
  8029f2:	e8 68 03 00 00       	call   802d5f <sys_getSizeOfSharedObject>
  8029f7:	83 c4 10             	add    $0x10,%esp
  8029fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8029fd:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802a01:	75 07                	jne    802a0a <sget+0x27>
  802a03:	b8 00 00 00 00       	mov    $0x0,%eax
  802a08:	eb 7f                	jmp    802a89 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a10:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a17:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1d:	39 d0                	cmp    %edx,%eax
  802a1f:	73 02                	jae    802a23 <sget+0x40>
  802a21:	89 d0                	mov    %edx,%eax
  802a23:	83 ec 0c             	sub    $0xc,%esp
  802a26:	50                   	push   %eax
  802a27:	e8 f4 fb ff ff       	call   802620 <malloc>
  802a2c:	83 c4 10             	add    $0x10,%esp
  802a2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802a32:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a36:	75 07                	jne    802a3f <sget+0x5c>
  802a38:	b8 00 00 00 00       	mov    $0x0,%eax
  802a3d:	eb 4a                	jmp    802a89 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802a3f:	83 ec 04             	sub    $0x4,%esp
  802a42:	ff 75 e8             	pushl  -0x18(%ebp)
  802a45:	ff 75 0c             	pushl  0xc(%ebp)
  802a48:	ff 75 08             	pushl  0x8(%ebp)
  802a4b:	e8 2c 03 00 00       	call   802d7c <sys_getSharedObject>
  802a50:	83 c4 10             	add    $0x10,%esp
  802a53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  802a56:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a59:	a1 20 60 80 00       	mov    0x806020,%eax
  802a5e:	8b 40 78             	mov    0x78(%eax),%eax
  802a61:	29 c2                	sub    %eax,%edx
  802a63:	89 d0                	mov    %edx,%eax
  802a65:	2d 00 10 00 00       	sub    $0x1000,%eax
  802a6a:	c1 e8 0c             	shr    $0xc,%eax
  802a6d:	89 c2                	mov    %eax,%edx
  802a6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a72:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802a79:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802a7d:	75 07                	jne    802a86 <sget+0xa3>
  802a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a84:	eb 03                	jmp    802a89 <sget+0xa6>
	return ptr;
  802a86:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    

00802a8b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
  802a8e:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802a91:	8b 55 08             	mov    0x8(%ebp),%edx
  802a94:	a1 20 60 80 00       	mov    0x806020,%eax
  802a99:	8b 40 78             	mov    0x78(%eax),%eax
  802a9c:	29 c2                	sub    %eax,%edx
  802a9e:	89 d0                	mov    %edx,%eax
  802aa0:	2d 00 10 00 00       	sub    $0x1000,%eax
  802aa5:	c1 e8 0c             	shr    $0xc,%eax
  802aa8:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802aaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802ab2:	83 ec 08             	sub    $0x8,%esp
  802ab5:	ff 75 08             	pushl  0x8(%ebp)
  802ab8:	ff 75 f4             	pushl  -0xc(%ebp)
  802abb:	e8 db 02 00 00       	call   802d9b <sys_freeSharedObject>
  802ac0:	83 c4 10             	add    $0x10,%esp
  802ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802ac6:	90                   	nop
  802ac7:	c9                   	leave  
  802ac8:	c3                   	ret    

00802ac9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802ac9:	55                   	push   %ebp
  802aca:	89 e5                	mov    %esp,%ebp
  802acc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802acf:	83 ec 04             	sub    $0x4,%esp
  802ad2:	68 70 57 80 00       	push   $0x805770
  802ad7:	68 e4 00 00 00       	push   $0xe4
  802adc:	68 62 57 80 00       	push   $0x805762
  802ae1:	e8 cd ea ff ff       	call   8015b3 <_panic>

00802ae6 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802ae6:	55                   	push   %ebp
  802ae7:	89 e5                	mov    %esp,%ebp
  802ae9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802aec:	83 ec 04             	sub    $0x4,%esp
  802aef:	68 96 57 80 00       	push   $0x805796
  802af4:	68 f0 00 00 00       	push   $0xf0
  802af9:	68 62 57 80 00       	push   $0x805762
  802afe:	e8 b0 ea ff ff       	call   8015b3 <_panic>

00802b03 <shrink>:

}
void shrink(uint32 newSize)
{
  802b03:	55                   	push   %ebp
  802b04:	89 e5                	mov    %esp,%ebp
  802b06:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b09:	83 ec 04             	sub    $0x4,%esp
  802b0c:	68 96 57 80 00       	push   $0x805796
  802b11:	68 f5 00 00 00       	push   $0xf5
  802b16:	68 62 57 80 00       	push   $0x805762
  802b1b:	e8 93 ea ff ff       	call   8015b3 <_panic>

00802b20 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802b20:	55                   	push   %ebp
  802b21:	89 e5                	mov    %esp,%ebp
  802b23:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b26:	83 ec 04             	sub    $0x4,%esp
  802b29:	68 96 57 80 00       	push   $0x805796
  802b2e:	68 fa 00 00 00       	push   $0xfa
  802b33:	68 62 57 80 00       	push   $0x805762
  802b38:	e8 76 ea ff ff       	call   8015b3 <_panic>

00802b3d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802b3d:	55                   	push   %ebp
  802b3e:	89 e5                	mov    %esp,%ebp
  802b40:	57                   	push   %edi
  802b41:	56                   	push   %esi
  802b42:	53                   	push   %ebx
  802b43:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b4f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b52:	8b 7d 18             	mov    0x18(%ebp),%edi
  802b55:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802b58:	cd 30                	int    $0x30
  802b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802b60:	83 c4 10             	add    $0x10,%esp
  802b63:	5b                   	pop    %ebx
  802b64:	5e                   	pop    %esi
  802b65:	5f                   	pop    %edi
  802b66:	5d                   	pop    %ebp
  802b67:	c3                   	ret    

00802b68 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802b68:	55                   	push   %ebp
  802b69:	89 e5                	mov    %esp,%ebp
  802b6b:	83 ec 04             	sub    $0x4,%esp
  802b6e:	8b 45 10             	mov    0x10(%ebp),%eax
  802b71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802b74:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	6a 00                	push   $0x0
  802b7d:	6a 00                	push   $0x0
  802b7f:	52                   	push   %edx
  802b80:	ff 75 0c             	pushl  0xc(%ebp)
  802b83:	50                   	push   %eax
  802b84:	6a 00                	push   $0x0
  802b86:	e8 b2 ff ff ff       	call   802b3d <syscall>
  802b8b:	83 c4 18             	add    $0x18,%esp
}
  802b8e:	90                   	nop
  802b8f:	c9                   	leave  
  802b90:	c3                   	ret    

00802b91 <sys_cgetc>:

int
sys_cgetc(void)
{
  802b91:	55                   	push   %ebp
  802b92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	6a 00                	push   $0x0
  802b9a:	6a 00                	push   $0x0
  802b9c:	6a 00                	push   $0x0
  802b9e:	6a 02                	push   $0x2
  802ba0:	e8 98 ff ff ff       	call   802b3d <syscall>
  802ba5:	83 c4 18             	add    $0x18,%esp
}
  802ba8:	c9                   	leave  
  802ba9:	c3                   	ret    

00802baa <sys_lock_cons>:

void sys_lock_cons(void)
{
  802baa:	55                   	push   %ebp
  802bab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802bad:	6a 00                	push   $0x0
  802baf:	6a 00                	push   $0x0
  802bb1:	6a 00                	push   $0x0
  802bb3:	6a 00                	push   $0x0
  802bb5:	6a 00                	push   $0x0
  802bb7:	6a 03                	push   $0x3
  802bb9:	e8 7f ff ff ff       	call   802b3d <syscall>
  802bbe:	83 c4 18             	add    $0x18,%esp
}
  802bc1:	90                   	nop
  802bc2:	c9                   	leave  
  802bc3:	c3                   	ret    

00802bc4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802bc4:	55                   	push   %ebp
  802bc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802bc7:	6a 00                	push   $0x0
  802bc9:	6a 00                	push   $0x0
  802bcb:	6a 00                	push   $0x0
  802bcd:	6a 00                	push   $0x0
  802bcf:	6a 00                	push   $0x0
  802bd1:	6a 04                	push   $0x4
  802bd3:	e8 65 ff ff ff       	call   802b3d <syscall>
  802bd8:	83 c4 18             	add    $0x18,%esp
}
  802bdb:	90                   	nop
  802bdc:	c9                   	leave  
  802bdd:	c3                   	ret    

00802bde <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802bde:	55                   	push   %ebp
  802bdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	6a 00                	push   $0x0
  802be9:	6a 00                	push   $0x0
  802beb:	6a 00                	push   $0x0
  802bed:	52                   	push   %edx
  802bee:	50                   	push   %eax
  802bef:	6a 08                	push   $0x8
  802bf1:	e8 47 ff ff ff       	call   802b3d <syscall>
  802bf6:	83 c4 18             	add    $0x18,%esp
}
  802bf9:	c9                   	leave  
  802bfa:	c3                   	ret    

00802bfb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802bfb:	55                   	push   %ebp
  802bfc:	89 e5                	mov    %esp,%ebp
  802bfe:	56                   	push   %esi
  802bff:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802c00:	8b 75 18             	mov    0x18(%ebp),%esi
  802c03:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c06:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	56                   	push   %esi
  802c10:	53                   	push   %ebx
  802c11:	51                   	push   %ecx
  802c12:	52                   	push   %edx
  802c13:	50                   	push   %eax
  802c14:	6a 09                	push   $0x9
  802c16:	e8 22 ff ff ff       	call   802b3d <syscall>
  802c1b:	83 c4 18             	add    $0x18,%esp
}
  802c1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c21:	5b                   	pop    %ebx
  802c22:	5e                   	pop    %esi
  802c23:	5d                   	pop    %ebp
  802c24:	c3                   	ret    

00802c25 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802c25:	55                   	push   %ebp
  802c26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	6a 00                	push   $0x0
  802c30:	6a 00                	push   $0x0
  802c32:	6a 00                	push   $0x0
  802c34:	52                   	push   %edx
  802c35:	50                   	push   %eax
  802c36:	6a 0a                	push   $0xa
  802c38:	e8 00 ff ff ff       	call   802b3d <syscall>
  802c3d:	83 c4 18             	add    $0x18,%esp
}
  802c40:	c9                   	leave  
  802c41:	c3                   	ret    

00802c42 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802c42:	55                   	push   %ebp
  802c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802c45:	6a 00                	push   $0x0
  802c47:	6a 00                	push   $0x0
  802c49:	6a 00                	push   $0x0
  802c4b:	ff 75 0c             	pushl  0xc(%ebp)
  802c4e:	ff 75 08             	pushl  0x8(%ebp)
  802c51:	6a 0b                	push   $0xb
  802c53:	e8 e5 fe ff ff       	call   802b3d <syscall>
  802c58:	83 c4 18             	add    $0x18,%esp
}
  802c5b:	c9                   	leave  
  802c5c:	c3                   	ret    

00802c5d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802c5d:	55                   	push   %ebp
  802c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802c60:	6a 00                	push   $0x0
  802c62:	6a 00                	push   $0x0
  802c64:	6a 00                	push   $0x0
  802c66:	6a 00                	push   $0x0
  802c68:	6a 00                	push   $0x0
  802c6a:	6a 0c                	push   $0xc
  802c6c:	e8 cc fe ff ff       	call   802b3d <syscall>
  802c71:	83 c4 18             	add    $0x18,%esp
}
  802c74:	c9                   	leave  
  802c75:	c3                   	ret    

00802c76 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802c76:	55                   	push   %ebp
  802c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802c79:	6a 00                	push   $0x0
  802c7b:	6a 00                	push   $0x0
  802c7d:	6a 00                	push   $0x0
  802c7f:	6a 00                	push   $0x0
  802c81:	6a 00                	push   $0x0
  802c83:	6a 0d                	push   $0xd
  802c85:	e8 b3 fe ff ff       	call   802b3d <syscall>
  802c8a:	83 c4 18             	add    $0x18,%esp
}
  802c8d:	c9                   	leave  
  802c8e:	c3                   	ret    

00802c8f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802c8f:	55                   	push   %ebp
  802c90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802c92:	6a 00                	push   $0x0
  802c94:	6a 00                	push   $0x0
  802c96:	6a 00                	push   $0x0
  802c98:	6a 00                	push   $0x0
  802c9a:	6a 00                	push   $0x0
  802c9c:	6a 0e                	push   $0xe
  802c9e:	e8 9a fe ff ff       	call   802b3d <syscall>
  802ca3:	83 c4 18             	add    $0x18,%esp
}
  802ca6:	c9                   	leave  
  802ca7:	c3                   	ret    

00802ca8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802ca8:	55                   	push   %ebp
  802ca9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	6a 00                	push   $0x0
  802cb1:	6a 00                	push   $0x0
  802cb3:	6a 00                	push   $0x0
  802cb5:	6a 0f                	push   $0xf
  802cb7:	e8 81 fe ff ff       	call   802b3d <syscall>
  802cbc:	83 c4 18             	add    $0x18,%esp
}
  802cbf:	c9                   	leave  
  802cc0:	c3                   	ret    

00802cc1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802cc1:	55                   	push   %ebp
  802cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802cc4:	6a 00                	push   $0x0
  802cc6:	6a 00                	push   $0x0
  802cc8:	6a 00                	push   $0x0
  802cca:	6a 00                	push   $0x0
  802ccc:	ff 75 08             	pushl  0x8(%ebp)
  802ccf:	6a 10                	push   $0x10
  802cd1:	e8 67 fe ff ff       	call   802b3d <syscall>
  802cd6:	83 c4 18             	add    $0x18,%esp
}
  802cd9:	c9                   	leave  
  802cda:	c3                   	ret    

00802cdb <sys_scarce_memory>:

void sys_scarce_memory()
{
  802cdb:	55                   	push   %ebp
  802cdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802cde:	6a 00                	push   $0x0
  802ce0:	6a 00                	push   $0x0
  802ce2:	6a 00                	push   $0x0
  802ce4:	6a 00                	push   $0x0
  802ce6:	6a 00                	push   $0x0
  802ce8:	6a 11                	push   $0x11
  802cea:	e8 4e fe ff ff       	call   802b3d <syscall>
  802cef:	83 c4 18             	add    $0x18,%esp
}
  802cf2:	90                   	nop
  802cf3:	c9                   	leave  
  802cf4:	c3                   	ret    

00802cf5 <sys_cputc>:

void
sys_cputc(const char c)
{
  802cf5:	55                   	push   %ebp
  802cf6:	89 e5                	mov    %esp,%ebp
  802cf8:	83 ec 04             	sub    $0x4,%esp
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802d01:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802d05:	6a 00                	push   $0x0
  802d07:	6a 00                	push   $0x0
  802d09:	6a 00                	push   $0x0
  802d0b:	6a 00                	push   $0x0
  802d0d:	50                   	push   %eax
  802d0e:	6a 01                	push   $0x1
  802d10:	e8 28 fe ff ff       	call   802b3d <syscall>
  802d15:	83 c4 18             	add    $0x18,%esp
}
  802d18:	90                   	nop
  802d19:	c9                   	leave  
  802d1a:	c3                   	ret    

00802d1b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802d1b:	55                   	push   %ebp
  802d1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802d1e:	6a 00                	push   $0x0
  802d20:	6a 00                	push   $0x0
  802d22:	6a 00                	push   $0x0
  802d24:	6a 00                	push   $0x0
  802d26:	6a 00                	push   $0x0
  802d28:	6a 14                	push   $0x14
  802d2a:	e8 0e fe ff ff       	call   802b3d <syscall>
  802d2f:	83 c4 18             	add    $0x18,%esp
}
  802d32:	90                   	nop
  802d33:	c9                   	leave  
  802d34:	c3                   	ret    

00802d35 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802d35:	55                   	push   %ebp
  802d36:	89 e5                	mov    %esp,%ebp
  802d38:	83 ec 04             	sub    $0x4,%esp
  802d3b:	8b 45 10             	mov    0x10(%ebp),%eax
  802d3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802d41:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d44:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	6a 00                	push   $0x0
  802d4d:	51                   	push   %ecx
  802d4e:	52                   	push   %edx
  802d4f:	ff 75 0c             	pushl  0xc(%ebp)
  802d52:	50                   	push   %eax
  802d53:	6a 15                	push   $0x15
  802d55:	e8 e3 fd ff ff       	call   802b3d <syscall>
  802d5a:	83 c4 18             	add    $0x18,%esp
}
  802d5d:	c9                   	leave  
  802d5e:	c3                   	ret    

00802d5f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802d5f:	55                   	push   %ebp
  802d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	6a 00                	push   $0x0
  802d6a:	6a 00                	push   $0x0
  802d6c:	6a 00                	push   $0x0
  802d6e:	52                   	push   %edx
  802d6f:	50                   	push   %eax
  802d70:	6a 16                	push   $0x16
  802d72:	e8 c6 fd ff ff       	call   802b3d <syscall>
  802d77:	83 c4 18             	add    $0x18,%esp
}
  802d7a:	c9                   	leave  
  802d7b:	c3                   	ret    

00802d7c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802d7c:	55                   	push   %ebp
  802d7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802d7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d82:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	6a 00                	push   $0x0
  802d8a:	6a 00                	push   $0x0
  802d8c:	51                   	push   %ecx
  802d8d:	52                   	push   %edx
  802d8e:	50                   	push   %eax
  802d8f:	6a 17                	push   $0x17
  802d91:	e8 a7 fd ff ff       	call   802b3d <syscall>
  802d96:	83 c4 18             	add    $0x18,%esp
}
  802d99:	c9                   	leave  
  802d9a:	c3                   	ret    

00802d9b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802d9b:	55                   	push   %ebp
  802d9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	6a 00                	push   $0x0
  802da6:	6a 00                	push   $0x0
  802da8:	6a 00                	push   $0x0
  802daa:	52                   	push   %edx
  802dab:	50                   	push   %eax
  802dac:	6a 18                	push   $0x18
  802dae:	e8 8a fd ff ff       	call   802b3d <syscall>
  802db3:	83 c4 18             	add    $0x18,%esp
}
  802db6:	c9                   	leave  
  802db7:	c3                   	ret    

00802db8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802db8:	55                   	push   %ebp
  802db9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	6a 00                	push   $0x0
  802dc0:	ff 75 14             	pushl  0x14(%ebp)
  802dc3:	ff 75 10             	pushl  0x10(%ebp)
  802dc6:	ff 75 0c             	pushl  0xc(%ebp)
  802dc9:	50                   	push   %eax
  802dca:	6a 19                	push   $0x19
  802dcc:	e8 6c fd ff ff       	call   802b3d <syscall>
  802dd1:	83 c4 18             	add    $0x18,%esp
}
  802dd4:	c9                   	leave  
  802dd5:	c3                   	ret    

00802dd6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802dd6:	55                   	push   %ebp
  802dd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	6a 00                	push   $0x0
  802dde:	6a 00                	push   $0x0
  802de0:	6a 00                	push   $0x0
  802de2:	6a 00                	push   $0x0
  802de4:	50                   	push   %eax
  802de5:	6a 1a                	push   $0x1a
  802de7:	e8 51 fd ff ff       	call   802b3d <syscall>
  802dec:	83 c4 18             	add    $0x18,%esp
}
  802def:	90                   	nop
  802df0:	c9                   	leave  
  802df1:	c3                   	ret    

00802df2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802df2:	55                   	push   %ebp
  802df3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802df5:	8b 45 08             	mov    0x8(%ebp),%eax
  802df8:	6a 00                	push   $0x0
  802dfa:	6a 00                	push   $0x0
  802dfc:	6a 00                	push   $0x0
  802dfe:	6a 00                	push   $0x0
  802e00:	50                   	push   %eax
  802e01:	6a 1b                	push   $0x1b
  802e03:	e8 35 fd ff ff       	call   802b3d <syscall>
  802e08:	83 c4 18             	add    $0x18,%esp
}
  802e0b:	c9                   	leave  
  802e0c:	c3                   	ret    

00802e0d <sys_getenvid>:

int32 sys_getenvid(void)
{
  802e0d:	55                   	push   %ebp
  802e0e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802e10:	6a 00                	push   $0x0
  802e12:	6a 00                	push   $0x0
  802e14:	6a 00                	push   $0x0
  802e16:	6a 00                	push   $0x0
  802e18:	6a 00                	push   $0x0
  802e1a:	6a 05                	push   $0x5
  802e1c:	e8 1c fd ff ff       	call   802b3d <syscall>
  802e21:	83 c4 18             	add    $0x18,%esp
}
  802e24:	c9                   	leave  
  802e25:	c3                   	ret    

00802e26 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802e26:	55                   	push   %ebp
  802e27:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802e29:	6a 00                	push   $0x0
  802e2b:	6a 00                	push   $0x0
  802e2d:	6a 00                	push   $0x0
  802e2f:	6a 00                	push   $0x0
  802e31:	6a 00                	push   $0x0
  802e33:	6a 06                	push   $0x6
  802e35:	e8 03 fd ff ff       	call   802b3d <syscall>
  802e3a:	83 c4 18             	add    $0x18,%esp
}
  802e3d:	c9                   	leave  
  802e3e:	c3                   	ret    

00802e3f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802e3f:	55                   	push   %ebp
  802e40:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802e42:	6a 00                	push   $0x0
  802e44:	6a 00                	push   $0x0
  802e46:	6a 00                	push   $0x0
  802e48:	6a 00                	push   $0x0
  802e4a:	6a 00                	push   $0x0
  802e4c:	6a 07                	push   $0x7
  802e4e:	e8 ea fc ff ff       	call   802b3d <syscall>
  802e53:	83 c4 18             	add    $0x18,%esp
}
  802e56:	c9                   	leave  
  802e57:	c3                   	ret    

00802e58 <sys_exit_env>:


void sys_exit_env(void)
{
  802e58:	55                   	push   %ebp
  802e59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802e5b:	6a 00                	push   $0x0
  802e5d:	6a 00                	push   $0x0
  802e5f:	6a 00                	push   $0x0
  802e61:	6a 00                	push   $0x0
  802e63:	6a 00                	push   $0x0
  802e65:	6a 1c                	push   $0x1c
  802e67:	e8 d1 fc ff ff       	call   802b3d <syscall>
  802e6c:	83 c4 18             	add    $0x18,%esp
}
  802e6f:	90                   	nop
  802e70:	c9                   	leave  
  802e71:	c3                   	ret    

00802e72 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802e72:	55                   	push   %ebp
  802e73:	89 e5                	mov    %esp,%ebp
  802e75:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802e78:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e7b:	8d 50 04             	lea    0x4(%eax),%edx
  802e7e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e81:	6a 00                	push   $0x0
  802e83:	6a 00                	push   $0x0
  802e85:	6a 00                	push   $0x0
  802e87:	52                   	push   %edx
  802e88:	50                   	push   %eax
  802e89:	6a 1d                	push   $0x1d
  802e8b:	e8 ad fc ff ff       	call   802b3d <syscall>
  802e90:	83 c4 18             	add    $0x18,%esp
	return result;
  802e93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802e99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802e9c:	89 01                	mov    %eax,(%ecx)
  802e9e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	c9                   	leave  
  802ea5:	c2 04 00             	ret    $0x4

00802ea8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802ea8:	55                   	push   %ebp
  802ea9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802eab:	6a 00                	push   $0x0
  802ead:	6a 00                	push   $0x0
  802eaf:	ff 75 10             	pushl  0x10(%ebp)
  802eb2:	ff 75 0c             	pushl  0xc(%ebp)
  802eb5:	ff 75 08             	pushl  0x8(%ebp)
  802eb8:	6a 13                	push   $0x13
  802eba:	e8 7e fc ff ff       	call   802b3d <syscall>
  802ebf:	83 c4 18             	add    $0x18,%esp
	return ;
  802ec2:	90                   	nop
}
  802ec3:	c9                   	leave  
  802ec4:	c3                   	ret    

00802ec5 <sys_rcr2>:
uint32 sys_rcr2()
{
  802ec5:	55                   	push   %ebp
  802ec6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802ec8:	6a 00                	push   $0x0
  802eca:	6a 00                	push   $0x0
  802ecc:	6a 00                	push   $0x0
  802ece:	6a 00                	push   $0x0
  802ed0:	6a 00                	push   $0x0
  802ed2:	6a 1e                	push   $0x1e
  802ed4:	e8 64 fc ff ff       	call   802b3d <syscall>
  802ed9:	83 c4 18             	add    $0x18,%esp
}
  802edc:	c9                   	leave  
  802edd:	c3                   	ret    

00802ede <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802ede:	55                   	push   %ebp
  802edf:	89 e5                	mov    %esp,%ebp
  802ee1:	83 ec 04             	sub    $0x4,%esp
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802eea:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802eee:	6a 00                	push   $0x0
  802ef0:	6a 00                	push   $0x0
  802ef2:	6a 00                	push   $0x0
  802ef4:	6a 00                	push   $0x0
  802ef6:	50                   	push   %eax
  802ef7:	6a 1f                	push   $0x1f
  802ef9:	e8 3f fc ff ff       	call   802b3d <syscall>
  802efe:	83 c4 18             	add    $0x18,%esp
	return ;
  802f01:	90                   	nop
}
  802f02:	c9                   	leave  
  802f03:	c3                   	ret    

00802f04 <rsttst>:
void rsttst()
{
  802f04:	55                   	push   %ebp
  802f05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802f07:	6a 00                	push   $0x0
  802f09:	6a 00                	push   $0x0
  802f0b:	6a 00                	push   $0x0
  802f0d:	6a 00                	push   $0x0
  802f0f:	6a 00                	push   $0x0
  802f11:	6a 21                	push   $0x21
  802f13:	e8 25 fc ff ff       	call   802b3d <syscall>
  802f18:	83 c4 18             	add    $0x18,%esp
	return ;
  802f1b:	90                   	nop
}
  802f1c:	c9                   	leave  
  802f1d:	c3                   	ret    

00802f1e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802f1e:	55                   	push   %ebp
  802f1f:	89 e5                	mov    %esp,%ebp
  802f21:	83 ec 04             	sub    $0x4,%esp
  802f24:	8b 45 14             	mov    0x14(%ebp),%eax
  802f27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802f2a:	8b 55 18             	mov    0x18(%ebp),%edx
  802f2d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f31:	52                   	push   %edx
  802f32:	50                   	push   %eax
  802f33:	ff 75 10             	pushl  0x10(%ebp)
  802f36:	ff 75 0c             	pushl  0xc(%ebp)
  802f39:	ff 75 08             	pushl  0x8(%ebp)
  802f3c:	6a 20                	push   $0x20
  802f3e:	e8 fa fb ff ff       	call   802b3d <syscall>
  802f43:	83 c4 18             	add    $0x18,%esp
	return ;
  802f46:	90                   	nop
}
  802f47:	c9                   	leave  
  802f48:	c3                   	ret    

00802f49 <chktst>:
void chktst(uint32 n)
{
  802f49:	55                   	push   %ebp
  802f4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 00                	push   $0x0
  802f50:	6a 00                	push   $0x0
  802f52:	6a 00                	push   $0x0
  802f54:	ff 75 08             	pushl  0x8(%ebp)
  802f57:	6a 22                	push   $0x22
  802f59:	e8 df fb ff ff       	call   802b3d <syscall>
  802f5e:	83 c4 18             	add    $0x18,%esp
	return ;
  802f61:	90                   	nop
}
  802f62:	c9                   	leave  
  802f63:	c3                   	ret    

00802f64 <inctst>:

void inctst()
{
  802f64:	55                   	push   %ebp
  802f65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802f67:	6a 00                	push   $0x0
  802f69:	6a 00                	push   $0x0
  802f6b:	6a 00                	push   $0x0
  802f6d:	6a 00                	push   $0x0
  802f6f:	6a 00                	push   $0x0
  802f71:	6a 23                	push   $0x23
  802f73:	e8 c5 fb ff ff       	call   802b3d <syscall>
  802f78:	83 c4 18             	add    $0x18,%esp
	return ;
  802f7b:	90                   	nop
}
  802f7c:	c9                   	leave  
  802f7d:	c3                   	ret    

00802f7e <gettst>:
uint32 gettst()
{
  802f7e:	55                   	push   %ebp
  802f7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802f81:	6a 00                	push   $0x0
  802f83:	6a 00                	push   $0x0
  802f85:	6a 00                	push   $0x0
  802f87:	6a 00                	push   $0x0
  802f89:	6a 00                	push   $0x0
  802f8b:	6a 24                	push   $0x24
  802f8d:	e8 ab fb ff ff       	call   802b3d <syscall>
  802f92:	83 c4 18             	add    $0x18,%esp
}
  802f95:	c9                   	leave  
  802f96:	c3                   	ret    

00802f97 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802f97:	55                   	push   %ebp
  802f98:	89 e5                	mov    %esp,%ebp
  802f9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f9d:	6a 00                	push   $0x0
  802f9f:	6a 00                	push   $0x0
  802fa1:	6a 00                	push   $0x0
  802fa3:	6a 00                	push   $0x0
  802fa5:	6a 00                	push   $0x0
  802fa7:	6a 25                	push   $0x25
  802fa9:	e8 8f fb ff ff       	call   802b3d <syscall>
  802fae:	83 c4 18             	add    $0x18,%esp
  802fb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802fb4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802fb8:	75 07                	jne    802fc1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802fba:	b8 01 00 00 00       	mov    $0x1,%eax
  802fbf:	eb 05                	jmp    802fc6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fc6:	c9                   	leave  
  802fc7:	c3                   	ret    

00802fc8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802fc8:	55                   	push   %ebp
  802fc9:	89 e5                	mov    %esp,%ebp
  802fcb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802fce:	6a 00                	push   $0x0
  802fd0:	6a 00                	push   $0x0
  802fd2:	6a 00                	push   $0x0
  802fd4:	6a 00                	push   $0x0
  802fd6:	6a 00                	push   $0x0
  802fd8:	6a 25                	push   $0x25
  802fda:	e8 5e fb ff ff       	call   802b3d <syscall>
  802fdf:	83 c4 18             	add    $0x18,%esp
  802fe2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802fe5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802fe9:	75 07                	jne    802ff2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802feb:	b8 01 00 00 00       	mov    $0x1,%eax
  802ff0:	eb 05                	jmp    802ff7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802ff2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff7:	c9                   	leave  
  802ff8:	c3                   	ret    

00802ff9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802ff9:	55                   	push   %ebp
  802ffa:	89 e5                	mov    %esp,%ebp
  802ffc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802fff:	6a 00                	push   $0x0
  803001:	6a 00                	push   $0x0
  803003:	6a 00                	push   $0x0
  803005:	6a 00                	push   $0x0
  803007:	6a 00                	push   $0x0
  803009:	6a 25                	push   $0x25
  80300b:	e8 2d fb ff ff       	call   802b3d <syscall>
  803010:	83 c4 18             	add    $0x18,%esp
  803013:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803016:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80301a:	75 07                	jne    803023 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80301c:	b8 01 00 00 00       	mov    $0x1,%eax
  803021:	eb 05                	jmp    803028 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803023:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803028:	c9                   	leave  
  803029:	c3                   	ret    

0080302a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80302a:	55                   	push   %ebp
  80302b:	89 e5                	mov    %esp,%ebp
  80302d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803030:	6a 00                	push   $0x0
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	6a 00                	push   $0x0
  803038:	6a 00                	push   $0x0
  80303a:	6a 25                	push   $0x25
  80303c:	e8 fc fa ff ff       	call   802b3d <syscall>
  803041:	83 c4 18             	add    $0x18,%esp
  803044:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803047:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80304b:	75 07                	jne    803054 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80304d:	b8 01 00 00 00       	mov    $0x1,%eax
  803052:	eb 05                	jmp    803059 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803054:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803059:	c9                   	leave  
  80305a:	c3                   	ret    

0080305b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80305b:	55                   	push   %ebp
  80305c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80305e:	6a 00                	push   $0x0
  803060:	6a 00                	push   $0x0
  803062:	6a 00                	push   $0x0
  803064:	6a 00                	push   $0x0
  803066:	ff 75 08             	pushl  0x8(%ebp)
  803069:	6a 26                	push   $0x26
  80306b:	e8 cd fa ff ff       	call   802b3d <syscall>
  803070:	83 c4 18             	add    $0x18,%esp
	return ;
  803073:	90                   	nop
}
  803074:	c9                   	leave  
  803075:	c3                   	ret    

00803076 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803076:	55                   	push   %ebp
  803077:	89 e5                	mov    %esp,%ebp
  803079:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80307a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80307d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803080:	8b 55 0c             	mov    0xc(%ebp),%edx
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	6a 00                	push   $0x0
  803088:	53                   	push   %ebx
  803089:	51                   	push   %ecx
  80308a:	52                   	push   %edx
  80308b:	50                   	push   %eax
  80308c:	6a 27                	push   $0x27
  80308e:	e8 aa fa ff ff       	call   802b3d <syscall>
  803093:	83 c4 18             	add    $0x18,%esp
}
  803096:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803099:	c9                   	leave  
  80309a:	c3                   	ret    

0080309b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80309b:	55                   	push   %ebp
  80309c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80309e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	6a 00                	push   $0x0
  8030a6:	6a 00                	push   $0x0
  8030a8:	6a 00                	push   $0x0
  8030aa:	52                   	push   %edx
  8030ab:	50                   	push   %eax
  8030ac:	6a 28                	push   $0x28
  8030ae:	e8 8a fa ff ff       	call   802b3d <syscall>
  8030b3:	83 c4 18             	add    $0x18,%esp
}
  8030b6:	c9                   	leave  
  8030b7:	c3                   	ret    

008030b8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8030b8:	55                   	push   %ebp
  8030b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8030bb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8030be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	6a 00                	push   $0x0
  8030c6:	51                   	push   %ecx
  8030c7:	ff 75 10             	pushl  0x10(%ebp)
  8030ca:	52                   	push   %edx
  8030cb:	50                   	push   %eax
  8030cc:	6a 29                	push   $0x29
  8030ce:	e8 6a fa ff ff       	call   802b3d <syscall>
  8030d3:	83 c4 18             	add    $0x18,%esp
}
  8030d6:	c9                   	leave  
  8030d7:	c3                   	ret    

008030d8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8030d8:	55                   	push   %ebp
  8030d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8030db:	6a 00                	push   $0x0
  8030dd:	6a 00                	push   $0x0
  8030df:	ff 75 10             	pushl  0x10(%ebp)
  8030e2:	ff 75 0c             	pushl  0xc(%ebp)
  8030e5:	ff 75 08             	pushl  0x8(%ebp)
  8030e8:	6a 12                	push   $0x12
  8030ea:	e8 4e fa ff ff       	call   802b3d <syscall>
  8030ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8030f2:	90                   	nop
}
  8030f3:	c9                   	leave  
  8030f4:	c3                   	ret    

008030f5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8030f5:	55                   	push   %ebp
  8030f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8030f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	6a 00                	push   $0x0
  803100:	6a 00                	push   $0x0
  803102:	6a 00                	push   $0x0
  803104:	52                   	push   %edx
  803105:	50                   	push   %eax
  803106:	6a 2a                	push   $0x2a
  803108:	e8 30 fa ff ff       	call   802b3d <syscall>
  80310d:	83 c4 18             	add    $0x18,%esp
	return;
  803110:	90                   	nop
}
  803111:	c9                   	leave  
  803112:	c3                   	ret    

00803113 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  803113:	55                   	push   %ebp
  803114:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	6a 00                	push   $0x0
  80311b:	6a 00                	push   $0x0
  80311d:	6a 00                	push   $0x0
  80311f:	6a 00                	push   $0x0
  803121:	50                   	push   %eax
  803122:	6a 2b                	push   $0x2b
  803124:	e8 14 fa ff ff       	call   802b3d <syscall>
  803129:	83 c4 18             	add    $0x18,%esp
}
  80312c:	c9                   	leave  
  80312d:	c3                   	ret    

0080312e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80312e:	55                   	push   %ebp
  80312f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  803131:	6a 00                	push   $0x0
  803133:	6a 00                	push   $0x0
  803135:	6a 00                	push   $0x0
  803137:	ff 75 0c             	pushl  0xc(%ebp)
  80313a:	ff 75 08             	pushl  0x8(%ebp)
  80313d:	6a 2c                	push   $0x2c
  80313f:	e8 f9 f9 ff ff       	call   802b3d <syscall>
  803144:	83 c4 18             	add    $0x18,%esp
	return;
  803147:	90                   	nop
}
  803148:	c9                   	leave  
  803149:	c3                   	ret    

0080314a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80314a:	55                   	push   %ebp
  80314b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80314d:	6a 00                	push   $0x0
  80314f:	6a 00                	push   $0x0
  803151:	6a 00                	push   $0x0
  803153:	ff 75 0c             	pushl  0xc(%ebp)
  803156:	ff 75 08             	pushl  0x8(%ebp)
  803159:	6a 2d                	push   $0x2d
  80315b:	e8 dd f9 ff ff       	call   802b3d <syscall>
  803160:	83 c4 18             	add    $0x18,%esp
	return;
  803163:	90                   	nop
}
  803164:	c9                   	leave  
  803165:	c3                   	ret    

00803166 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  803166:	55                   	push   %ebp
  803167:	89 e5                	mov    %esp,%ebp
  803169:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  80316c:	6a 00                	push   $0x0
  80316e:	6a 00                	push   $0x0
  803170:	6a 00                	push   $0x0
  803172:	6a 00                	push   $0x0
  803174:	6a 00                	push   $0x0
  803176:	6a 2e                	push   $0x2e
  803178:	e8 c0 f9 ff ff       	call   802b3d <syscall>
  80317d:	83 c4 18             	add    $0x18,%esp
  803180:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  803183:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803186:	c9                   	leave  
  803187:	c3                   	ret    

00803188 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  803188:	55                   	push   %ebp
  803189:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	6a 00                	push   $0x0
  803190:	6a 00                	push   $0x0
  803192:	6a 00                	push   $0x0
  803194:	6a 00                	push   $0x0
  803196:	50                   	push   %eax
  803197:	6a 2f                	push   $0x2f
  803199:	e8 9f f9 ff ff       	call   802b3d <syscall>
  80319e:	83 c4 18             	add    $0x18,%esp
	return;
  8031a1:	90                   	nop
}
  8031a2:	c9                   	leave  
  8031a3:	c3                   	ret    

008031a4 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  8031a4:	55                   	push   %ebp
  8031a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  8031a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	6a 00                	push   $0x0
  8031af:	6a 00                	push   $0x0
  8031b1:	6a 00                	push   $0x0
  8031b3:	52                   	push   %edx
  8031b4:	50                   	push   %eax
  8031b5:	6a 30                	push   $0x30
  8031b7:	e8 81 f9 ff ff       	call   802b3d <syscall>
  8031bc:	83 c4 18             	add    $0x18,%esp
	return;
  8031bf:	90                   	nop
}
  8031c0:	c9                   	leave  
  8031c1:	c3                   	ret    

008031c2 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  8031c2:	55                   	push   %ebp
  8031c3:	89 e5                	mov    %esp,%ebp
  8031c5:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	6a 00                	push   $0x0
  8031cd:	6a 00                	push   $0x0
  8031cf:	6a 00                	push   $0x0
  8031d1:	6a 00                	push   $0x0
  8031d3:	50                   	push   %eax
  8031d4:	6a 31                	push   $0x31
  8031d6:	e8 62 f9 ff ff       	call   802b3d <syscall>
  8031db:	83 c4 18             	add    $0x18,%esp
  8031de:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  8031e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8031e4:	c9                   	leave  
  8031e5:	c3                   	ret    

008031e6 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  8031e6:	55                   	push   %ebp
  8031e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	6a 00                	push   $0x0
  8031ee:	6a 00                	push   $0x0
  8031f0:	6a 00                	push   $0x0
  8031f2:	6a 00                	push   $0x0
  8031f4:	50                   	push   %eax
  8031f5:	6a 32                	push   $0x32
  8031f7:	e8 41 f9 ff ff       	call   802b3d <syscall>
  8031fc:	83 c4 18             	add    $0x18,%esp
	return;
  8031ff:	90                   	nop
}
  803200:	c9                   	leave  
  803201:	c3                   	ret    

00803202 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  803202:	55                   	push   %ebp
  803203:	89 e5                	mov    %esp,%ebp
  803205:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	83 e8 04             	sub    $0x4,%eax
  80320e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  803211:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	83 e0 fe             	and    $0xfffffffe,%eax
}
  803219:	c9                   	leave  
  80321a:	c3                   	ret    

0080321b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80321b:	55                   	push   %ebp
  80321c:	89 e5                	mov    %esp,%ebp
  80321e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	83 e8 04             	sub    $0x4,%eax
  803227:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80322a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	83 e0 01             	and    $0x1,%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	0f 94 c0             	sete   %al
}
  803237:	c9                   	leave  
  803238:	c3                   	ret    

00803239 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  803239:	55                   	push   %ebp
  80323a:	89 e5                	mov    %esp,%ebp
  80323c:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80323f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  803246:	8b 45 0c             	mov    0xc(%ebp),%eax
  803249:	83 f8 02             	cmp    $0x2,%eax
  80324c:	74 2b                	je     803279 <alloc_block+0x40>
  80324e:	83 f8 02             	cmp    $0x2,%eax
  803251:	7f 07                	jg     80325a <alloc_block+0x21>
  803253:	83 f8 01             	cmp    $0x1,%eax
  803256:	74 0e                	je     803266 <alloc_block+0x2d>
  803258:	eb 58                	jmp    8032b2 <alloc_block+0x79>
  80325a:	83 f8 03             	cmp    $0x3,%eax
  80325d:	74 2d                	je     80328c <alloc_block+0x53>
  80325f:	83 f8 04             	cmp    $0x4,%eax
  803262:	74 3b                	je     80329f <alloc_block+0x66>
  803264:	eb 4c                	jmp    8032b2 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  803266:	83 ec 0c             	sub    $0xc,%esp
  803269:	ff 75 08             	pushl  0x8(%ebp)
  80326c:	e8 11 03 00 00       	call   803582 <alloc_block_FF>
  803271:	83 c4 10             	add    $0x10,%esp
  803274:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803277:	eb 4a                	jmp    8032c3 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  803279:	83 ec 0c             	sub    $0xc,%esp
  80327c:	ff 75 08             	pushl  0x8(%ebp)
  80327f:	e8 c7 19 00 00       	call   804c4b <alloc_block_NF>
  803284:	83 c4 10             	add    $0x10,%esp
  803287:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80328a:	eb 37                	jmp    8032c3 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80328c:	83 ec 0c             	sub    $0xc,%esp
  80328f:	ff 75 08             	pushl  0x8(%ebp)
  803292:	e8 a7 07 00 00       	call   803a3e <alloc_block_BF>
  803297:	83 c4 10             	add    $0x10,%esp
  80329a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80329d:	eb 24                	jmp    8032c3 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80329f:	83 ec 0c             	sub    $0xc,%esp
  8032a2:	ff 75 08             	pushl  0x8(%ebp)
  8032a5:	e8 84 19 00 00       	call   804c2e <alloc_block_WF>
  8032aa:	83 c4 10             	add    $0x10,%esp
  8032ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8032b0:	eb 11                	jmp    8032c3 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8032b2:	83 ec 0c             	sub    $0xc,%esp
  8032b5:	68 a8 57 80 00       	push   $0x8057a8
  8032ba:	e8 b1 e5 ff ff       	call   801870 <cprintf>
  8032bf:	83 c4 10             	add    $0x10,%esp
		break;
  8032c2:	90                   	nop
	}
	return va;
  8032c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8032c6:	c9                   	leave  
  8032c7:	c3                   	ret    

008032c8 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8032c8:	55                   	push   %ebp
  8032c9:	89 e5                	mov    %esp,%ebp
  8032cb:	53                   	push   %ebx
  8032cc:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8032cf:	83 ec 0c             	sub    $0xc,%esp
  8032d2:	68 c8 57 80 00       	push   $0x8057c8
  8032d7:	e8 94 e5 ff ff       	call   801870 <cprintf>
  8032dc:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8032df:	83 ec 0c             	sub    $0xc,%esp
  8032e2:	68 f3 57 80 00       	push   $0x8057f3
  8032e7:	e8 84 e5 ff ff       	call   801870 <cprintf>
  8032ec:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f5:	eb 37                	jmp    80332e <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8032f7:	83 ec 0c             	sub    $0xc,%esp
  8032fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8032fd:	e8 19 ff ff ff       	call   80321b <is_free_block>
  803302:	83 c4 10             	add    $0x10,%esp
  803305:	0f be d8             	movsbl %al,%ebx
  803308:	83 ec 0c             	sub    $0xc,%esp
  80330b:	ff 75 f4             	pushl  -0xc(%ebp)
  80330e:	e8 ef fe ff ff       	call   803202 <get_block_size>
  803313:	83 c4 10             	add    $0x10,%esp
  803316:	83 ec 04             	sub    $0x4,%esp
  803319:	53                   	push   %ebx
  80331a:	50                   	push   %eax
  80331b:	68 0b 58 80 00       	push   $0x80580b
  803320:	e8 4b e5 ff ff       	call   801870 <cprintf>
  803325:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  803328:	8b 45 10             	mov    0x10(%ebp),%eax
  80332b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80332e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803332:	74 07                	je     80333b <print_blocks_list+0x73>
  803334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803337:	8b 00                	mov    (%eax),%eax
  803339:	eb 05                	jmp    803340 <print_blocks_list+0x78>
  80333b:	b8 00 00 00 00       	mov    $0x0,%eax
  803340:	89 45 10             	mov    %eax,0x10(%ebp)
  803343:	8b 45 10             	mov    0x10(%ebp),%eax
  803346:	85 c0                	test   %eax,%eax
  803348:	75 ad                	jne    8032f7 <print_blocks_list+0x2f>
  80334a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80334e:	75 a7                	jne    8032f7 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  803350:	83 ec 0c             	sub    $0xc,%esp
  803353:	68 c8 57 80 00       	push   $0x8057c8
  803358:	e8 13 e5 ff ff       	call   801870 <cprintf>
  80335d:	83 c4 10             	add    $0x10,%esp

}
  803360:	90                   	nop
  803361:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803364:	c9                   	leave  
  803365:	c3                   	ret    

00803366 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  803366:	55                   	push   %ebp
  803367:	89 e5                	mov    %esp,%ebp
  803369:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80336c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80336f:	83 e0 01             	and    $0x1,%eax
  803372:	85 c0                	test   %eax,%eax
  803374:	74 03                	je     803379 <initialize_dynamic_allocator+0x13>
  803376:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  803379:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80337d:	0f 84 c7 01 00 00    	je     80354a <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  803383:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  80338a:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80338d:	8b 55 08             	mov    0x8(%ebp),%edx
  803390:	8b 45 0c             	mov    0xc(%ebp),%eax
  803393:	01 d0                	add    %edx,%eax
  803395:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80339a:	0f 87 ad 01 00 00    	ja     80354d <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	85 c0                	test   %eax,%eax
  8033a5:	0f 89 a5 01 00 00    	jns    803550 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8033ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b1:	01 d0                	add    %edx,%eax
  8033b3:	83 e8 04             	sub    $0x4,%eax
  8033b6:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  8033bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8033c2:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8033c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ca:	e9 87 00 00 00       	jmp    803456 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8033cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d3:	75 14                	jne    8033e9 <initialize_dynamic_allocator+0x83>
  8033d5:	83 ec 04             	sub    $0x4,%esp
  8033d8:	68 23 58 80 00       	push   $0x805823
  8033dd:	6a 79                	push   $0x79
  8033df:	68 41 58 80 00       	push   $0x805841
  8033e4:	e8 ca e1 ff ff       	call   8015b3 <_panic>
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	85 c0                	test   %eax,%eax
  8033f0:	74 10                	je     803402 <initialize_dynamic_allocator+0x9c>
  8033f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f5:	8b 00                	mov    (%eax),%eax
  8033f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033fa:	8b 52 04             	mov    0x4(%edx),%edx
  8033fd:	89 50 04             	mov    %edx,0x4(%eax)
  803400:	eb 0b                	jmp    80340d <initialize_dynamic_allocator+0xa7>
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	8b 40 04             	mov    0x4(%eax),%eax
  803408:	a3 30 60 80 00       	mov    %eax,0x806030
  80340d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803410:	8b 40 04             	mov    0x4(%eax),%eax
  803413:	85 c0                	test   %eax,%eax
  803415:	74 0f                	je     803426 <initialize_dynamic_allocator+0xc0>
  803417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341a:	8b 40 04             	mov    0x4(%eax),%eax
  80341d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803420:	8b 12                	mov    (%edx),%edx
  803422:	89 10                	mov    %edx,(%eax)
  803424:	eb 0a                	jmp    803430 <initialize_dynamic_allocator+0xca>
  803426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803429:	8b 00                	mov    (%eax),%eax
  80342b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803443:	a1 38 60 80 00       	mov    0x806038,%eax
  803448:	48                   	dec    %eax
  803449:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80344e:	a1 34 60 80 00       	mov    0x806034,%eax
  803453:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803456:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80345a:	74 07                	je     803463 <initialize_dynamic_allocator+0xfd>
  80345c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345f:	8b 00                	mov    (%eax),%eax
  803461:	eb 05                	jmp    803468 <initialize_dynamic_allocator+0x102>
  803463:	b8 00 00 00 00       	mov    $0x0,%eax
  803468:	a3 34 60 80 00       	mov    %eax,0x806034
  80346d:	a1 34 60 80 00       	mov    0x806034,%eax
  803472:	85 c0                	test   %eax,%eax
  803474:	0f 85 55 ff ff ff    	jne    8033cf <initialize_dynamic_allocator+0x69>
  80347a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80347e:	0f 85 4b ff ff ff    	jne    8033cf <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  803484:	8b 45 08             	mov    0x8(%ebp),%eax
  803487:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80348a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  803493:	a1 44 60 80 00       	mov    0x806044,%eax
  803498:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  80349d:	a1 40 60 80 00       	mov    0x806040,%eax
  8034a2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8034a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ab:	83 c0 08             	add    $0x8,%eax
  8034ae:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8034b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b4:	83 c0 04             	add    $0x4,%eax
  8034b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034ba:	83 ea 08             	sub    $0x8,%edx
  8034bd:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8034bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	01 d0                	add    %edx,%eax
  8034c7:	83 e8 08             	sub    $0x8,%eax
  8034ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034cd:	83 ea 08             	sub    $0x8,%edx
  8034d0:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8034d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8034db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8034e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034e9:	75 17                	jne    803502 <initialize_dynamic_allocator+0x19c>
  8034eb:	83 ec 04             	sub    $0x4,%esp
  8034ee:	68 5c 58 80 00       	push   $0x80585c
  8034f3:	68 90 00 00 00       	push   $0x90
  8034f8:	68 41 58 80 00       	push   $0x805841
  8034fd:	e8 b1 e0 ff ff       	call   8015b3 <_panic>
  803502:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350b:	89 10                	mov    %edx,(%eax)
  80350d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803510:	8b 00                	mov    (%eax),%eax
  803512:	85 c0                	test   %eax,%eax
  803514:	74 0d                	je     803523 <initialize_dynamic_allocator+0x1bd>
  803516:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80351b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80351e:	89 50 04             	mov    %edx,0x4(%eax)
  803521:	eb 08                	jmp    80352b <initialize_dynamic_allocator+0x1c5>
  803523:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803526:	a3 30 60 80 00       	mov    %eax,0x806030
  80352b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803533:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803536:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353d:	a1 38 60 80 00       	mov    0x806038,%eax
  803542:	40                   	inc    %eax
  803543:	a3 38 60 80 00       	mov    %eax,0x806038
  803548:	eb 07                	jmp    803551 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80354a:	90                   	nop
  80354b:	eb 04                	jmp    803551 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80354d:	90                   	nop
  80354e:	eb 01                	jmp    803551 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  803550:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  803551:	c9                   	leave  
  803552:	c3                   	ret    

00803553 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  803553:	55                   	push   %ebp
  803554:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  803556:	8b 45 10             	mov    0x10(%ebp),%eax
  803559:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80355c:	8b 45 08             	mov    0x8(%ebp),%eax
  80355f:	8d 50 fc             	lea    -0x4(%eax),%edx
  803562:	8b 45 0c             	mov    0xc(%ebp),%eax
  803565:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	83 e8 04             	sub    $0x4,%eax
  80356d:	8b 00                	mov    (%eax),%eax
  80356f:	83 e0 fe             	and    $0xfffffffe,%eax
  803572:	8d 50 f8             	lea    -0x8(%eax),%edx
  803575:	8b 45 08             	mov    0x8(%ebp),%eax
  803578:	01 c2                	add    %eax,%edx
  80357a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357d:	89 02                	mov    %eax,(%edx)
}
  80357f:	90                   	nop
  803580:	5d                   	pop    %ebp
  803581:	c3                   	ret    

00803582 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  803582:	55                   	push   %ebp
  803583:	89 e5                	mov    %esp,%ebp
  803585:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803588:	8b 45 08             	mov    0x8(%ebp),%eax
  80358b:	83 e0 01             	and    $0x1,%eax
  80358e:	85 c0                	test   %eax,%eax
  803590:	74 03                	je     803595 <alloc_block_FF+0x13>
  803592:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803595:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803599:	77 07                	ja     8035a2 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80359b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8035a2:	a1 24 60 80 00       	mov    0x806024,%eax
  8035a7:	85 c0                	test   %eax,%eax
  8035a9:	75 73                	jne    80361e <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	83 c0 10             	add    $0x10,%eax
  8035b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8035b4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8035bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c1:	01 d0                	add    %edx,%eax
  8035c3:	48                   	dec    %eax
  8035c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8035c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8035cf:	f7 75 ec             	divl   -0x14(%ebp)
  8035d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d5:	29 d0                	sub    %edx,%eax
  8035d7:	c1 e8 0c             	shr    $0xc,%eax
  8035da:	83 ec 0c             	sub    $0xc,%esp
  8035dd:	50                   	push   %eax
  8035de:	e8 27 f0 ff ff       	call   80260a <sbrk>
  8035e3:	83 c4 10             	add    $0x10,%esp
  8035e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8035e9:	83 ec 0c             	sub    $0xc,%esp
  8035ec:	6a 00                	push   $0x0
  8035ee:	e8 17 f0 ff ff       	call   80260a <sbrk>
  8035f3:	83 c4 10             	add    $0x10,%esp
  8035f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8035f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8035ff:	83 ec 08             	sub    $0x8,%esp
  803602:	50                   	push   %eax
  803603:	ff 75 e4             	pushl  -0x1c(%ebp)
  803606:	e8 5b fd ff ff       	call   803366 <initialize_dynamic_allocator>
  80360b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80360e:	83 ec 0c             	sub    $0xc,%esp
  803611:	68 7f 58 80 00       	push   $0x80587f
  803616:	e8 55 e2 ff ff       	call   801870 <cprintf>
  80361b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80361e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803622:	75 0a                	jne    80362e <alloc_block_FF+0xac>
	        return NULL;
  803624:	b8 00 00 00 00       	mov    $0x0,%eax
  803629:	e9 0e 04 00 00       	jmp    803a3c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80362e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  803635:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80363a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80363d:	e9 f3 02 00 00       	jmp    803935 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  803642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803645:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803648:	83 ec 0c             	sub    $0xc,%esp
  80364b:	ff 75 bc             	pushl  -0x44(%ebp)
  80364e:	e8 af fb ff ff       	call   803202 <get_block_size>
  803653:	83 c4 10             	add    $0x10,%esp
  803656:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803659:	8b 45 08             	mov    0x8(%ebp),%eax
  80365c:	83 c0 08             	add    $0x8,%eax
  80365f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803662:	0f 87 c5 02 00 00    	ja     80392d <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	83 c0 18             	add    $0x18,%eax
  80366e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  803671:	0f 87 19 02 00 00    	ja     803890 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  803677:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80367a:	2b 45 08             	sub    0x8(%ebp),%eax
  80367d:	83 e8 08             	sub    $0x8,%eax
  803680:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  803683:	8b 45 08             	mov    0x8(%ebp),%eax
  803686:	8d 50 08             	lea    0x8(%eax),%edx
  803689:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80368c:	01 d0                	add    %edx,%eax
  80368e:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  803691:	8b 45 08             	mov    0x8(%ebp),%eax
  803694:	83 c0 08             	add    $0x8,%eax
  803697:	83 ec 04             	sub    $0x4,%esp
  80369a:	6a 01                	push   $0x1
  80369c:	50                   	push   %eax
  80369d:	ff 75 bc             	pushl  -0x44(%ebp)
  8036a0:	e8 ae fe ff ff       	call   803553 <set_block_data>
  8036a5:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8036a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ab:	8b 40 04             	mov    0x4(%eax),%eax
  8036ae:	85 c0                	test   %eax,%eax
  8036b0:	75 68                	jne    80371a <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8036b2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8036b6:	75 17                	jne    8036cf <alloc_block_FF+0x14d>
  8036b8:	83 ec 04             	sub    $0x4,%esp
  8036bb:	68 5c 58 80 00       	push   $0x80585c
  8036c0:	68 d7 00 00 00       	push   $0xd7
  8036c5:	68 41 58 80 00       	push   $0x805841
  8036ca:	e8 e4 de ff ff       	call   8015b3 <_panic>
  8036cf:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8036d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036d8:	89 10                	mov    %edx,(%eax)
  8036da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036dd:	8b 00                	mov    (%eax),%eax
  8036df:	85 c0                	test   %eax,%eax
  8036e1:	74 0d                	je     8036f0 <alloc_block_FF+0x16e>
  8036e3:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8036e8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8036eb:	89 50 04             	mov    %edx,0x4(%eax)
  8036ee:	eb 08                	jmp    8036f8 <alloc_block_FF+0x176>
  8036f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036f3:	a3 30 60 80 00       	mov    %eax,0x806030
  8036f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036fb:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803700:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803703:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80370a:	a1 38 60 80 00       	mov    0x806038,%eax
  80370f:	40                   	inc    %eax
  803710:	a3 38 60 80 00       	mov    %eax,0x806038
  803715:	e9 dc 00 00 00       	jmp    8037f6 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80371a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371d:	8b 00                	mov    (%eax),%eax
  80371f:	85 c0                	test   %eax,%eax
  803721:	75 65                	jne    803788 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803723:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803727:	75 17                	jne    803740 <alloc_block_FF+0x1be>
  803729:	83 ec 04             	sub    $0x4,%esp
  80372c:	68 90 58 80 00       	push   $0x805890
  803731:	68 db 00 00 00       	push   $0xdb
  803736:	68 41 58 80 00       	push   $0x805841
  80373b:	e8 73 de ff ff       	call   8015b3 <_panic>
  803740:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803746:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803749:	89 50 04             	mov    %edx,0x4(%eax)
  80374c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80374f:	8b 40 04             	mov    0x4(%eax),%eax
  803752:	85 c0                	test   %eax,%eax
  803754:	74 0c                	je     803762 <alloc_block_FF+0x1e0>
  803756:	a1 30 60 80 00       	mov    0x806030,%eax
  80375b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80375e:	89 10                	mov    %edx,(%eax)
  803760:	eb 08                	jmp    80376a <alloc_block_FF+0x1e8>
  803762:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803765:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80376a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80376d:	a3 30 60 80 00       	mov    %eax,0x806030
  803772:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803775:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80377b:	a1 38 60 80 00       	mov    0x806038,%eax
  803780:	40                   	inc    %eax
  803781:	a3 38 60 80 00       	mov    %eax,0x806038
  803786:	eb 6e                	jmp    8037f6 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  803788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80378c:	74 06                	je     803794 <alloc_block_FF+0x212>
  80378e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803792:	75 17                	jne    8037ab <alloc_block_FF+0x229>
  803794:	83 ec 04             	sub    $0x4,%esp
  803797:	68 b4 58 80 00       	push   $0x8058b4
  80379c:	68 df 00 00 00       	push   $0xdf
  8037a1:	68 41 58 80 00       	push   $0x805841
  8037a6:	e8 08 de ff ff       	call   8015b3 <_panic>
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	8b 10                	mov    (%eax),%edx
  8037b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037b3:	89 10                	mov    %edx,(%eax)
  8037b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037b8:	8b 00                	mov    (%eax),%eax
  8037ba:	85 c0                	test   %eax,%eax
  8037bc:	74 0b                	je     8037c9 <alloc_block_FF+0x247>
  8037be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c1:	8b 00                	mov    (%eax),%eax
  8037c3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8037c6:	89 50 04             	mov    %edx,0x4(%eax)
  8037c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8037cf:	89 10                	mov    %edx,(%eax)
  8037d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037d7:	89 50 04             	mov    %edx,0x4(%eax)
  8037da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037dd:	8b 00                	mov    (%eax),%eax
  8037df:	85 c0                	test   %eax,%eax
  8037e1:	75 08                	jne    8037eb <alloc_block_FF+0x269>
  8037e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037e6:	a3 30 60 80 00       	mov    %eax,0x806030
  8037eb:	a1 38 60 80 00       	mov    0x806038,%eax
  8037f0:	40                   	inc    %eax
  8037f1:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8037f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037fa:	75 17                	jne    803813 <alloc_block_FF+0x291>
  8037fc:	83 ec 04             	sub    $0x4,%esp
  8037ff:	68 23 58 80 00       	push   $0x805823
  803804:	68 e1 00 00 00       	push   $0xe1
  803809:	68 41 58 80 00       	push   $0x805841
  80380e:	e8 a0 dd ff ff       	call   8015b3 <_panic>
  803813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803816:	8b 00                	mov    (%eax),%eax
  803818:	85 c0                	test   %eax,%eax
  80381a:	74 10                	je     80382c <alloc_block_FF+0x2aa>
  80381c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381f:	8b 00                	mov    (%eax),%eax
  803821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803824:	8b 52 04             	mov    0x4(%edx),%edx
  803827:	89 50 04             	mov    %edx,0x4(%eax)
  80382a:	eb 0b                	jmp    803837 <alloc_block_FF+0x2b5>
  80382c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382f:	8b 40 04             	mov    0x4(%eax),%eax
  803832:	a3 30 60 80 00       	mov    %eax,0x806030
  803837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383a:	8b 40 04             	mov    0x4(%eax),%eax
  80383d:	85 c0                	test   %eax,%eax
  80383f:	74 0f                	je     803850 <alloc_block_FF+0x2ce>
  803841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803844:	8b 40 04             	mov    0x4(%eax),%eax
  803847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80384a:	8b 12                	mov    (%edx),%edx
  80384c:	89 10                	mov    %edx,(%eax)
  80384e:	eb 0a                	jmp    80385a <alloc_block_FF+0x2d8>
  803850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803853:	8b 00                	mov    (%eax),%eax
  803855:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80385a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803866:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80386d:	a1 38 60 80 00       	mov    0x806038,%eax
  803872:	48                   	dec    %eax
  803873:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  803878:	83 ec 04             	sub    $0x4,%esp
  80387b:	6a 00                	push   $0x0
  80387d:	ff 75 b4             	pushl  -0x4c(%ebp)
  803880:	ff 75 b0             	pushl  -0x50(%ebp)
  803883:	e8 cb fc ff ff       	call   803553 <set_block_data>
  803888:	83 c4 10             	add    $0x10,%esp
  80388b:	e9 95 00 00 00       	jmp    803925 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803890:	83 ec 04             	sub    $0x4,%esp
  803893:	6a 01                	push   $0x1
  803895:	ff 75 b8             	pushl  -0x48(%ebp)
  803898:	ff 75 bc             	pushl  -0x44(%ebp)
  80389b:	e8 b3 fc ff ff       	call   803553 <set_block_data>
  8038a0:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8038a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038a7:	75 17                	jne    8038c0 <alloc_block_FF+0x33e>
  8038a9:	83 ec 04             	sub    $0x4,%esp
  8038ac:	68 23 58 80 00       	push   $0x805823
  8038b1:	68 e8 00 00 00       	push   $0xe8
  8038b6:	68 41 58 80 00       	push   $0x805841
  8038bb:	e8 f3 dc ff ff       	call   8015b3 <_panic>
  8038c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c3:	8b 00                	mov    (%eax),%eax
  8038c5:	85 c0                	test   %eax,%eax
  8038c7:	74 10                	je     8038d9 <alloc_block_FF+0x357>
  8038c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cc:	8b 00                	mov    (%eax),%eax
  8038ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038d1:	8b 52 04             	mov    0x4(%edx),%edx
  8038d4:	89 50 04             	mov    %edx,0x4(%eax)
  8038d7:	eb 0b                	jmp    8038e4 <alloc_block_FF+0x362>
  8038d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038dc:	8b 40 04             	mov    0x4(%eax),%eax
  8038df:	a3 30 60 80 00       	mov    %eax,0x806030
  8038e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e7:	8b 40 04             	mov    0x4(%eax),%eax
  8038ea:	85 c0                	test   %eax,%eax
  8038ec:	74 0f                	je     8038fd <alloc_block_FF+0x37b>
  8038ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f1:	8b 40 04             	mov    0x4(%eax),%eax
  8038f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038f7:	8b 12                	mov    (%edx),%edx
  8038f9:	89 10                	mov    %edx,(%eax)
  8038fb:	eb 0a                	jmp    803907 <alloc_block_FF+0x385>
  8038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803900:	8b 00                	mov    (%eax),%eax
  803902:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803913:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80391a:	a1 38 60 80 00       	mov    0x806038,%eax
  80391f:	48                   	dec    %eax
  803920:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  803925:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803928:	e9 0f 01 00 00       	jmp    803a3c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80392d:	a1 34 60 80 00       	mov    0x806034,%eax
  803932:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803939:	74 07                	je     803942 <alloc_block_FF+0x3c0>
  80393b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393e:	8b 00                	mov    (%eax),%eax
  803940:	eb 05                	jmp    803947 <alloc_block_FF+0x3c5>
  803942:	b8 00 00 00 00       	mov    $0x0,%eax
  803947:	a3 34 60 80 00       	mov    %eax,0x806034
  80394c:	a1 34 60 80 00       	mov    0x806034,%eax
  803951:	85 c0                	test   %eax,%eax
  803953:	0f 85 e9 fc ff ff    	jne    803642 <alloc_block_FF+0xc0>
  803959:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80395d:	0f 85 df fc ff ff    	jne    803642 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  803963:	8b 45 08             	mov    0x8(%ebp),%eax
  803966:	83 c0 08             	add    $0x8,%eax
  803969:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80396c:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803973:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803976:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803979:	01 d0                	add    %edx,%eax
  80397b:	48                   	dec    %eax
  80397c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80397f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803982:	ba 00 00 00 00       	mov    $0x0,%edx
  803987:	f7 75 d8             	divl   -0x28(%ebp)
  80398a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80398d:	29 d0                	sub    %edx,%eax
  80398f:	c1 e8 0c             	shr    $0xc,%eax
  803992:	83 ec 0c             	sub    $0xc,%esp
  803995:	50                   	push   %eax
  803996:	e8 6f ec ff ff       	call   80260a <sbrk>
  80399b:	83 c4 10             	add    $0x10,%esp
  80399e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8039a1:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8039a5:	75 0a                	jne    8039b1 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8039a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ac:	e9 8b 00 00 00       	jmp    803a3c <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8039b1:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8039b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8039be:	01 d0                	add    %edx,%eax
  8039c0:	48                   	dec    %eax
  8039c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8039c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8039cc:	f7 75 cc             	divl   -0x34(%ebp)
  8039cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039d2:	29 d0                	sub    %edx,%eax
  8039d4:	8d 50 fc             	lea    -0x4(%eax),%edx
  8039d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8039da:	01 d0                	add    %edx,%eax
  8039dc:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  8039e1:	a1 40 60 80 00       	mov    0x806040,%eax
  8039e6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8039ec:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8039f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039f6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8039f9:	01 d0                	add    %edx,%eax
  8039fb:	48                   	dec    %eax
  8039fc:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8039ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a02:	ba 00 00 00 00       	mov    $0x0,%edx
  803a07:	f7 75 c4             	divl   -0x3c(%ebp)
  803a0a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a0d:	29 d0                	sub    %edx,%eax
  803a0f:	83 ec 04             	sub    $0x4,%esp
  803a12:	6a 01                	push   $0x1
  803a14:	50                   	push   %eax
  803a15:	ff 75 d0             	pushl  -0x30(%ebp)
  803a18:	e8 36 fb ff ff       	call   803553 <set_block_data>
  803a1d:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803a20:	83 ec 0c             	sub    $0xc,%esp
  803a23:	ff 75 d0             	pushl  -0x30(%ebp)
  803a26:	e8 f8 09 00 00       	call   804423 <free_block>
  803a2b:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803a2e:	83 ec 0c             	sub    $0xc,%esp
  803a31:	ff 75 08             	pushl  0x8(%ebp)
  803a34:	e8 49 fb ff ff       	call   803582 <alloc_block_FF>
  803a39:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803a3c:	c9                   	leave  
  803a3d:	c3                   	ret    

00803a3e <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803a3e:	55                   	push   %ebp
  803a3f:	89 e5                	mov    %esp,%ebp
  803a41:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803a44:	8b 45 08             	mov    0x8(%ebp),%eax
  803a47:	83 e0 01             	and    $0x1,%eax
  803a4a:	85 c0                	test   %eax,%eax
  803a4c:	74 03                	je     803a51 <alloc_block_BF+0x13>
  803a4e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803a51:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803a55:	77 07                	ja     803a5e <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803a57:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803a5e:	a1 24 60 80 00       	mov    0x806024,%eax
  803a63:	85 c0                	test   %eax,%eax
  803a65:	75 73                	jne    803ada <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803a67:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6a:	83 c0 10             	add    $0x10,%eax
  803a6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803a70:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803a77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a7d:	01 d0                	add    %edx,%eax
  803a7f:	48                   	dec    %eax
  803a80:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a86:	ba 00 00 00 00       	mov    $0x0,%edx
  803a8b:	f7 75 e0             	divl   -0x20(%ebp)
  803a8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a91:	29 d0                	sub    %edx,%eax
  803a93:	c1 e8 0c             	shr    $0xc,%eax
  803a96:	83 ec 0c             	sub    $0xc,%esp
  803a99:	50                   	push   %eax
  803a9a:	e8 6b eb ff ff       	call   80260a <sbrk>
  803a9f:	83 c4 10             	add    $0x10,%esp
  803aa2:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803aa5:	83 ec 0c             	sub    $0xc,%esp
  803aa8:	6a 00                	push   $0x0
  803aaa:	e8 5b eb ff ff       	call   80260a <sbrk>
  803aaf:	83 c4 10             	add    $0x10,%esp
  803ab2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803ab5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ab8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803abb:	83 ec 08             	sub    $0x8,%esp
  803abe:	50                   	push   %eax
  803abf:	ff 75 d8             	pushl  -0x28(%ebp)
  803ac2:	e8 9f f8 ff ff       	call   803366 <initialize_dynamic_allocator>
  803ac7:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803aca:	83 ec 0c             	sub    $0xc,%esp
  803acd:	68 7f 58 80 00       	push   $0x80587f
  803ad2:	e8 99 dd ff ff       	call   801870 <cprintf>
  803ad7:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803ada:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803ae1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803ae8:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803aef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803af6:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803afb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803afe:	e9 1d 01 00 00       	jmp    803c20 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b06:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803b09:	83 ec 0c             	sub    $0xc,%esp
  803b0c:	ff 75 a8             	pushl  -0x58(%ebp)
  803b0f:	e8 ee f6 ff ff       	call   803202 <get_block_size>
  803b14:	83 c4 10             	add    $0x10,%esp
  803b17:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1d:	83 c0 08             	add    $0x8,%eax
  803b20:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803b23:	0f 87 ef 00 00 00    	ja     803c18 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803b29:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2c:	83 c0 18             	add    $0x18,%eax
  803b2f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803b32:	77 1d                	ja     803b51 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b37:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803b3a:	0f 86 d8 00 00 00    	jbe    803c18 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803b40:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803b46:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803b49:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803b4c:	e9 c7 00 00 00       	jmp    803c18 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803b51:	8b 45 08             	mov    0x8(%ebp),%eax
  803b54:	83 c0 08             	add    $0x8,%eax
  803b57:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803b5a:	0f 85 9d 00 00 00    	jne    803bfd <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803b60:	83 ec 04             	sub    $0x4,%esp
  803b63:	6a 01                	push   $0x1
  803b65:	ff 75 a4             	pushl  -0x5c(%ebp)
  803b68:	ff 75 a8             	pushl  -0x58(%ebp)
  803b6b:	e8 e3 f9 ff ff       	call   803553 <set_block_data>
  803b70:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803b73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b77:	75 17                	jne    803b90 <alloc_block_BF+0x152>
  803b79:	83 ec 04             	sub    $0x4,%esp
  803b7c:	68 23 58 80 00       	push   $0x805823
  803b81:	68 2c 01 00 00       	push   $0x12c
  803b86:	68 41 58 80 00       	push   $0x805841
  803b8b:	e8 23 da ff ff       	call   8015b3 <_panic>
  803b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b93:	8b 00                	mov    (%eax),%eax
  803b95:	85 c0                	test   %eax,%eax
  803b97:	74 10                	je     803ba9 <alloc_block_BF+0x16b>
  803b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9c:	8b 00                	mov    (%eax),%eax
  803b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ba1:	8b 52 04             	mov    0x4(%edx),%edx
  803ba4:	89 50 04             	mov    %edx,0x4(%eax)
  803ba7:	eb 0b                	jmp    803bb4 <alloc_block_BF+0x176>
  803ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bac:	8b 40 04             	mov    0x4(%eax),%eax
  803baf:	a3 30 60 80 00       	mov    %eax,0x806030
  803bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb7:	8b 40 04             	mov    0x4(%eax),%eax
  803bba:	85 c0                	test   %eax,%eax
  803bbc:	74 0f                	je     803bcd <alloc_block_BF+0x18f>
  803bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc1:	8b 40 04             	mov    0x4(%eax),%eax
  803bc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bc7:	8b 12                	mov    (%edx),%edx
  803bc9:	89 10                	mov    %edx,(%eax)
  803bcb:	eb 0a                	jmp    803bd7 <alloc_block_BF+0x199>
  803bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd0:	8b 00                	mov    (%eax),%eax
  803bd2:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bea:	a1 38 60 80 00       	mov    0x806038,%eax
  803bef:	48                   	dec    %eax
  803bf0:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  803bf5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803bf8:	e9 01 04 00 00       	jmp    803ffe <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  803bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c00:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c03:	76 13                	jbe    803c18 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803c05:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803c0c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803c0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803c12:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803c15:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803c18:	a1 34 60 80 00       	mov    0x806034,%eax
  803c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c24:	74 07                	je     803c2d <alloc_block_BF+0x1ef>
  803c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c29:	8b 00                	mov    (%eax),%eax
  803c2b:	eb 05                	jmp    803c32 <alloc_block_BF+0x1f4>
  803c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  803c32:	a3 34 60 80 00       	mov    %eax,0x806034
  803c37:	a1 34 60 80 00       	mov    0x806034,%eax
  803c3c:	85 c0                	test   %eax,%eax
  803c3e:	0f 85 bf fe ff ff    	jne    803b03 <alloc_block_BF+0xc5>
  803c44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c48:	0f 85 b5 fe ff ff    	jne    803b03 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803c4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c52:	0f 84 26 02 00 00    	je     803e7e <alloc_block_BF+0x440>
  803c58:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c5c:	0f 85 1c 02 00 00    	jne    803e7e <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c65:	2b 45 08             	sub    0x8(%ebp),%eax
  803c68:	83 e8 08             	sub    $0x8,%eax
  803c6b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c71:	8d 50 08             	lea    0x8(%eax),%edx
  803c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c77:	01 d0                	add    %edx,%eax
  803c79:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7f:	83 c0 08             	add    $0x8,%eax
  803c82:	83 ec 04             	sub    $0x4,%esp
  803c85:	6a 01                	push   $0x1
  803c87:	50                   	push   %eax
  803c88:	ff 75 f0             	pushl  -0x10(%ebp)
  803c8b:	e8 c3 f8 ff ff       	call   803553 <set_block_data>
  803c90:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c96:	8b 40 04             	mov    0x4(%eax),%eax
  803c99:	85 c0                	test   %eax,%eax
  803c9b:	75 68                	jne    803d05 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803c9d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803ca1:	75 17                	jne    803cba <alloc_block_BF+0x27c>
  803ca3:	83 ec 04             	sub    $0x4,%esp
  803ca6:	68 5c 58 80 00       	push   $0x80585c
  803cab:	68 45 01 00 00       	push   $0x145
  803cb0:	68 41 58 80 00       	push   $0x805841
  803cb5:	e8 f9 d8 ff ff       	call   8015b3 <_panic>
  803cba:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803cc0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cc3:	89 10                	mov    %edx,(%eax)
  803cc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cc8:	8b 00                	mov    (%eax),%eax
  803cca:	85 c0                	test   %eax,%eax
  803ccc:	74 0d                	je     803cdb <alloc_block_BF+0x29d>
  803cce:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803cd3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803cd6:	89 50 04             	mov    %edx,0x4(%eax)
  803cd9:	eb 08                	jmp    803ce3 <alloc_block_BF+0x2a5>
  803cdb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cde:	a3 30 60 80 00       	mov    %eax,0x806030
  803ce3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ce6:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803ceb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cf5:	a1 38 60 80 00       	mov    0x806038,%eax
  803cfa:	40                   	inc    %eax
  803cfb:	a3 38 60 80 00       	mov    %eax,0x806038
  803d00:	e9 dc 00 00 00       	jmp    803de1 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d08:	8b 00                	mov    (%eax),%eax
  803d0a:	85 c0                	test   %eax,%eax
  803d0c:	75 65                	jne    803d73 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803d0e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803d12:	75 17                	jne    803d2b <alloc_block_BF+0x2ed>
  803d14:	83 ec 04             	sub    $0x4,%esp
  803d17:	68 90 58 80 00       	push   $0x805890
  803d1c:	68 4a 01 00 00       	push   $0x14a
  803d21:	68 41 58 80 00       	push   $0x805841
  803d26:	e8 88 d8 ff ff       	call   8015b3 <_panic>
  803d2b:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803d31:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d34:	89 50 04             	mov    %edx,0x4(%eax)
  803d37:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d3a:	8b 40 04             	mov    0x4(%eax),%eax
  803d3d:	85 c0                	test   %eax,%eax
  803d3f:	74 0c                	je     803d4d <alloc_block_BF+0x30f>
  803d41:	a1 30 60 80 00       	mov    0x806030,%eax
  803d46:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803d49:	89 10                	mov    %edx,(%eax)
  803d4b:	eb 08                	jmp    803d55 <alloc_block_BF+0x317>
  803d4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d50:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d55:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d58:	a3 30 60 80 00       	mov    %eax,0x806030
  803d5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d66:	a1 38 60 80 00       	mov    0x806038,%eax
  803d6b:	40                   	inc    %eax
  803d6c:	a3 38 60 80 00       	mov    %eax,0x806038
  803d71:	eb 6e                	jmp    803de1 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803d73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d77:	74 06                	je     803d7f <alloc_block_BF+0x341>
  803d79:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803d7d:	75 17                	jne    803d96 <alloc_block_BF+0x358>
  803d7f:	83 ec 04             	sub    $0x4,%esp
  803d82:	68 b4 58 80 00       	push   $0x8058b4
  803d87:	68 4f 01 00 00       	push   $0x14f
  803d8c:	68 41 58 80 00       	push   $0x805841
  803d91:	e8 1d d8 ff ff       	call   8015b3 <_panic>
  803d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d99:	8b 10                	mov    (%eax),%edx
  803d9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d9e:	89 10                	mov    %edx,(%eax)
  803da0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803da3:	8b 00                	mov    (%eax),%eax
  803da5:	85 c0                	test   %eax,%eax
  803da7:	74 0b                	je     803db4 <alloc_block_BF+0x376>
  803da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dac:	8b 00                	mov    (%eax),%eax
  803dae:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803db1:	89 50 04             	mov    %edx,0x4(%eax)
  803db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803dba:	89 10                	mov    %edx,(%eax)
  803dbc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803dbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dc2:	89 50 04             	mov    %edx,0x4(%eax)
  803dc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803dc8:	8b 00                	mov    (%eax),%eax
  803dca:	85 c0                	test   %eax,%eax
  803dcc:	75 08                	jne    803dd6 <alloc_block_BF+0x398>
  803dce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803dd1:	a3 30 60 80 00       	mov    %eax,0x806030
  803dd6:	a1 38 60 80 00       	mov    0x806038,%eax
  803ddb:	40                   	inc    %eax
  803ddc:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803de1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803de5:	75 17                	jne    803dfe <alloc_block_BF+0x3c0>
  803de7:	83 ec 04             	sub    $0x4,%esp
  803dea:	68 23 58 80 00       	push   $0x805823
  803def:	68 51 01 00 00       	push   $0x151
  803df4:	68 41 58 80 00       	push   $0x805841
  803df9:	e8 b5 d7 ff ff       	call   8015b3 <_panic>
  803dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e01:	8b 00                	mov    (%eax),%eax
  803e03:	85 c0                	test   %eax,%eax
  803e05:	74 10                	je     803e17 <alloc_block_BF+0x3d9>
  803e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e0a:	8b 00                	mov    (%eax),%eax
  803e0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e0f:	8b 52 04             	mov    0x4(%edx),%edx
  803e12:	89 50 04             	mov    %edx,0x4(%eax)
  803e15:	eb 0b                	jmp    803e22 <alloc_block_BF+0x3e4>
  803e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e1a:	8b 40 04             	mov    0x4(%eax),%eax
  803e1d:	a3 30 60 80 00       	mov    %eax,0x806030
  803e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e25:	8b 40 04             	mov    0x4(%eax),%eax
  803e28:	85 c0                	test   %eax,%eax
  803e2a:	74 0f                	je     803e3b <alloc_block_BF+0x3fd>
  803e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e2f:	8b 40 04             	mov    0x4(%eax),%eax
  803e32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e35:	8b 12                	mov    (%edx),%edx
  803e37:	89 10                	mov    %edx,(%eax)
  803e39:	eb 0a                	jmp    803e45 <alloc_block_BF+0x407>
  803e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e3e:	8b 00                	mov    (%eax),%eax
  803e40:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e58:	a1 38 60 80 00       	mov    0x806038,%eax
  803e5d:	48                   	dec    %eax
  803e5e:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  803e63:	83 ec 04             	sub    $0x4,%esp
  803e66:	6a 00                	push   $0x0
  803e68:	ff 75 d0             	pushl  -0x30(%ebp)
  803e6b:	ff 75 cc             	pushl  -0x34(%ebp)
  803e6e:	e8 e0 f6 ff ff       	call   803553 <set_block_data>
  803e73:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e79:	e9 80 01 00 00       	jmp    803ffe <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  803e7e:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803e82:	0f 85 9d 00 00 00    	jne    803f25 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803e88:	83 ec 04             	sub    $0x4,%esp
  803e8b:	6a 01                	push   $0x1
  803e8d:	ff 75 ec             	pushl  -0x14(%ebp)
  803e90:	ff 75 f0             	pushl  -0x10(%ebp)
  803e93:	e8 bb f6 ff ff       	call   803553 <set_block_data>
  803e98:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803e9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e9f:	75 17                	jne    803eb8 <alloc_block_BF+0x47a>
  803ea1:	83 ec 04             	sub    $0x4,%esp
  803ea4:	68 23 58 80 00       	push   $0x805823
  803ea9:	68 58 01 00 00       	push   $0x158
  803eae:	68 41 58 80 00       	push   $0x805841
  803eb3:	e8 fb d6 ff ff       	call   8015b3 <_panic>
  803eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ebb:	8b 00                	mov    (%eax),%eax
  803ebd:	85 c0                	test   %eax,%eax
  803ebf:	74 10                	je     803ed1 <alloc_block_BF+0x493>
  803ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ec4:	8b 00                	mov    (%eax),%eax
  803ec6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ec9:	8b 52 04             	mov    0x4(%edx),%edx
  803ecc:	89 50 04             	mov    %edx,0x4(%eax)
  803ecf:	eb 0b                	jmp    803edc <alloc_block_BF+0x49e>
  803ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ed4:	8b 40 04             	mov    0x4(%eax),%eax
  803ed7:	a3 30 60 80 00       	mov    %eax,0x806030
  803edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803edf:	8b 40 04             	mov    0x4(%eax),%eax
  803ee2:	85 c0                	test   %eax,%eax
  803ee4:	74 0f                	je     803ef5 <alloc_block_BF+0x4b7>
  803ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ee9:	8b 40 04             	mov    0x4(%eax),%eax
  803eec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803eef:	8b 12                	mov    (%edx),%edx
  803ef1:	89 10                	mov    %edx,(%eax)
  803ef3:	eb 0a                	jmp    803eff <alloc_block_BF+0x4c1>
  803ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ef8:	8b 00                	mov    (%eax),%eax
  803efa:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f12:	a1 38 60 80 00       	mov    0x806038,%eax
  803f17:	48                   	dec    %eax
  803f18:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f20:	e9 d9 00 00 00       	jmp    803ffe <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803f25:	8b 45 08             	mov    0x8(%ebp),%eax
  803f28:	83 c0 08             	add    $0x8,%eax
  803f2b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803f2e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803f35:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803f38:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f3b:	01 d0                	add    %edx,%eax
  803f3d:	48                   	dec    %eax
  803f3e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803f41:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f44:	ba 00 00 00 00       	mov    $0x0,%edx
  803f49:	f7 75 c4             	divl   -0x3c(%ebp)
  803f4c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f4f:	29 d0                	sub    %edx,%eax
  803f51:	c1 e8 0c             	shr    $0xc,%eax
  803f54:	83 ec 0c             	sub    $0xc,%esp
  803f57:	50                   	push   %eax
  803f58:	e8 ad e6 ff ff       	call   80260a <sbrk>
  803f5d:	83 c4 10             	add    $0x10,%esp
  803f60:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803f63:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803f67:	75 0a                	jne    803f73 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803f69:	b8 00 00 00 00       	mov    $0x0,%eax
  803f6e:	e9 8b 00 00 00       	jmp    803ffe <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803f73:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803f7a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803f7d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f80:	01 d0                	add    %edx,%eax
  803f82:	48                   	dec    %eax
  803f83:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803f86:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803f89:	ba 00 00 00 00       	mov    $0x0,%edx
  803f8e:	f7 75 b8             	divl   -0x48(%ebp)
  803f91:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803f94:	29 d0                	sub    %edx,%eax
  803f96:	8d 50 fc             	lea    -0x4(%eax),%edx
  803f99:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803f9c:	01 d0                	add    %edx,%eax
  803f9e:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  803fa3:	a1 40 60 80 00       	mov    0x806040,%eax
  803fa8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803fae:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803fb5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803fb8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803fbb:	01 d0                	add    %edx,%eax
  803fbd:	48                   	dec    %eax
  803fbe:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803fc1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803fc4:	ba 00 00 00 00       	mov    $0x0,%edx
  803fc9:	f7 75 b0             	divl   -0x50(%ebp)
  803fcc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803fcf:	29 d0                	sub    %edx,%eax
  803fd1:	83 ec 04             	sub    $0x4,%esp
  803fd4:	6a 01                	push   $0x1
  803fd6:	50                   	push   %eax
  803fd7:	ff 75 bc             	pushl  -0x44(%ebp)
  803fda:	e8 74 f5 ff ff       	call   803553 <set_block_data>
  803fdf:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803fe2:	83 ec 0c             	sub    $0xc,%esp
  803fe5:	ff 75 bc             	pushl  -0x44(%ebp)
  803fe8:	e8 36 04 00 00       	call   804423 <free_block>
  803fed:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803ff0:	83 ec 0c             	sub    $0xc,%esp
  803ff3:	ff 75 08             	pushl  0x8(%ebp)
  803ff6:	e8 43 fa ff ff       	call   803a3e <alloc_block_BF>
  803ffb:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803ffe:	c9                   	leave  
  803fff:	c3                   	ret    

00804000 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  804000:	55                   	push   %ebp
  804001:	89 e5                	mov    %esp,%ebp
  804003:	53                   	push   %ebx
  804004:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  804007:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80400e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  804015:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804019:	74 1e                	je     804039 <merging+0x39>
  80401b:	ff 75 08             	pushl  0x8(%ebp)
  80401e:	e8 df f1 ff ff       	call   803202 <get_block_size>
  804023:	83 c4 04             	add    $0x4,%esp
  804026:	89 c2                	mov    %eax,%edx
  804028:	8b 45 08             	mov    0x8(%ebp),%eax
  80402b:	01 d0                	add    %edx,%eax
  80402d:	3b 45 10             	cmp    0x10(%ebp),%eax
  804030:	75 07                	jne    804039 <merging+0x39>
		prev_is_free = 1;
  804032:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  804039:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80403d:	74 1e                	je     80405d <merging+0x5d>
  80403f:	ff 75 10             	pushl  0x10(%ebp)
  804042:	e8 bb f1 ff ff       	call   803202 <get_block_size>
  804047:	83 c4 04             	add    $0x4,%esp
  80404a:	89 c2                	mov    %eax,%edx
  80404c:	8b 45 10             	mov    0x10(%ebp),%eax
  80404f:	01 d0                	add    %edx,%eax
  804051:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804054:	75 07                	jne    80405d <merging+0x5d>
		next_is_free = 1;
  804056:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  80405d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804061:	0f 84 cc 00 00 00    	je     804133 <merging+0x133>
  804067:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80406b:	0f 84 c2 00 00 00    	je     804133 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  804071:	ff 75 08             	pushl  0x8(%ebp)
  804074:	e8 89 f1 ff ff       	call   803202 <get_block_size>
  804079:	83 c4 04             	add    $0x4,%esp
  80407c:	89 c3                	mov    %eax,%ebx
  80407e:	ff 75 10             	pushl  0x10(%ebp)
  804081:	e8 7c f1 ff ff       	call   803202 <get_block_size>
  804086:	83 c4 04             	add    $0x4,%esp
  804089:	01 c3                	add    %eax,%ebx
  80408b:	ff 75 0c             	pushl  0xc(%ebp)
  80408e:	e8 6f f1 ff ff       	call   803202 <get_block_size>
  804093:	83 c4 04             	add    $0x4,%esp
  804096:	01 d8                	add    %ebx,%eax
  804098:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80409b:	6a 00                	push   $0x0
  80409d:	ff 75 ec             	pushl  -0x14(%ebp)
  8040a0:	ff 75 08             	pushl  0x8(%ebp)
  8040a3:	e8 ab f4 ff ff       	call   803553 <set_block_data>
  8040a8:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  8040ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8040af:	75 17                	jne    8040c8 <merging+0xc8>
  8040b1:	83 ec 04             	sub    $0x4,%esp
  8040b4:	68 23 58 80 00       	push   $0x805823
  8040b9:	68 7d 01 00 00       	push   $0x17d
  8040be:	68 41 58 80 00       	push   $0x805841
  8040c3:	e8 eb d4 ff ff       	call   8015b3 <_panic>
  8040c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040cb:	8b 00                	mov    (%eax),%eax
  8040cd:	85 c0                	test   %eax,%eax
  8040cf:	74 10                	je     8040e1 <merging+0xe1>
  8040d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040d4:	8b 00                	mov    (%eax),%eax
  8040d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8040d9:	8b 52 04             	mov    0x4(%edx),%edx
  8040dc:	89 50 04             	mov    %edx,0x4(%eax)
  8040df:	eb 0b                	jmp    8040ec <merging+0xec>
  8040e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040e4:	8b 40 04             	mov    0x4(%eax),%eax
  8040e7:	a3 30 60 80 00       	mov    %eax,0x806030
  8040ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040ef:	8b 40 04             	mov    0x4(%eax),%eax
  8040f2:	85 c0                	test   %eax,%eax
  8040f4:	74 0f                	je     804105 <merging+0x105>
  8040f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040f9:	8b 40 04             	mov    0x4(%eax),%eax
  8040fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8040ff:	8b 12                	mov    (%edx),%edx
  804101:	89 10                	mov    %edx,(%eax)
  804103:	eb 0a                	jmp    80410f <merging+0x10f>
  804105:	8b 45 0c             	mov    0xc(%ebp),%eax
  804108:	8b 00                	mov    (%eax),%eax
  80410a:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80410f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804112:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80411b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804122:	a1 38 60 80 00       	mov    0x806038,%eax
  804127:	48                   	dec    %eax
  804128:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  80412d:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80412e:	e9 ea 02 00 00       	jmp    80441d <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  804133:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804137:	74 3b                	je     804174 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  804139:	83 ec 0c             	sub    $0xc,%esp
  80413c:	ff 75 08             	pushl  0x8(%ebp)
  80413f:	e8 be f0 ff ff       	call   803202 <get_block_size>
  804144:	83 c4 10             	add    $0x10,%esp
  804147:	89 c3                	mov    %eax,%ebx
  804149:	83 ec 0c             	sub    $0xc,%esp
  80414c:	ff 75 10             	pushl  0x10(%ebp)
  80414f:	e8 ae f0 ff ff       	call   803202 <get_block_size>
  804154:	83 c4 10             	add    $0x10,%esp
  804157:	01 d8                	add    %ebx,%eax
  804159:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80415c:	83 ec 04             	sub    $0x4,%esp
  80415f:	6a 00                	push   $0x0
  804161:	ff 75 e8             	pushl  -0x18(%ebp)
  804164:	ff 75 08             	pushl  0x8(%ebp)
  804167:	e8 e7 f3 ff ff       	call   803553 <set_block_data>
  80416c:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80416f:	e9 a9 02 00 00       	jmp    80441d <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  804174:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804178:	0f 84 2d 01 00 00    	je     8042ab <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80417e:	83 ec 0c             	sub    $0xc,%esp
  804181:	ff 75 10             	pushl  0x10(%ebp)
  804184:	e8 79 f0 ff ff       	call   803202 <get_block_size>
  804189:	83 c4 10             	add    $0x10,%esp
  80418c:	89 c3                	mov    %eax,%ebx
  80418e:	83 ec 0c             	sub    $0xc,%esp
  804191:	ff 75 0c             	pushl  0xc(%ebp)
  804194:	e8 69 f0 ff ff       	call   803202 <get_block_size>
  804199:	83 c4 10             	add    $0x10,%esp
  80419c:	01 d8                	add    %ebx,%eax
  80419e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8041a1:	83 ec 04             	sub    $0x4,%esp
  8041a4:	6a 00                	push   $0x0
  8041a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8041a9:	ff 75 10             	pushl  0x10(%ebp)
  8041ac:	e8 a2 f3 ff ff       	call   803553 <set_block_data>
  8041b1:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8041b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8041b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8041ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8041be:	74 06                	je     8041c6 <merging+0x1c6>
  8041c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8041c4:	75 17                	jne    8041dd <merging+0x1dd>
  8041c6:	83 ec 04             	sub    $0x4,%esp
  8041c9:	68 e8 58 80 00       	push   $0x8058e8
  8041ce:	68 8d 01 00 00       	push   $0x18d
  8041d3:	68 41 58 80 00       	push   $0x805841
  8041d8:	e8 d6 d3 ff ff       	call   8015b3 <_panic>
  8041dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041e0:	8b 50 04             	mov    0x4(%eax),%edx
  8041e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041e6:	89 50 04             	mov    %edx,0x4(%eax)
  8041e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8041ef:	89 10                	mov    %edx,(%eax)
  8041f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041f4:	8b 40 04             	mov    0x4(%eax),%eax
  8041f7:	85 c0                	test   %eax,%eax
  8041f9:	74 0d                	je     804208 <merging+0x208>
  8041fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041fe:	8b 40 04             	mov    0x4(%eax),%eax
  804201:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804204:	89 10                	mov    %edx,(%eax)
  804206:	eb 08                	jmp    804210 <merging+0x210>
  804208:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80420b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804210:	8b 45 0c             	mov    0xc(%ebp),%eax
  804213:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804216:	89 50 04             	mov    %edx,0x4(%eax)
  804219:	a1 38 60 80 00       	mov    0x806038,%eax
  80421e:	40                   	inc    %eax
  80421f:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  804224:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804228:	75 17                	jne    804241 <merging+0x241>
  80422a:	83 ec 04             	sub    $0x4,%esp
  80422d:	68 23 58 80 00       	push   $0x805823
  804232:	68 8e 01 00 00       	push   $0x18e
  804237:	68 41 58 80 00       	push   $0x805841
  80423c:	e8 72 d3 ff ff       	call   8015b3 <_panic>
  804241:	8b 45 0c             	mov    0xc(%ebp),%eax
  804244:	8b 00                	mov    (%eax),%eax
  804246:	85 c0                	test   %eax,%eax
  804248:	74 10                	je     80425a <merging+0x25a>
  80424a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80424d:	8b 00                	mov    (%eax),%eax
  80424f:	8b 55 0c             	mov    0xc(%ebp),%edx
  804252:	8b 52 04             	mov    0x4(%edx),%edx
  804255:	89 50 04             	mov    %edx,0x4(%eax)
  804258:	eb 0b                	jmp    804265 <merging+0x265>
  80425a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80425d:	8b 40 04             	mov    0x4(%eax),%eax
  804260:	a3 30 60 80 00       	mov    %eax,0x806030
  804265:	8b 45 0c             	mov    0xc(%ebp),%eax
  804268:	8b 40 04             	mov    0x4(%eax),%eax
  80426b:	85 c0                	test   %eax,%eax
  80426d:	74 0f                	je     80427e <merging+0x27e>
  80426f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804272:	8b 40 04             	mov    0x4(%eax),%eax
  804275:	8b 55 0c             	mov    0xc(%ebp),%edx
  804278:	8b 12                	mov    (%edx),%edx
  80427a:	89 10                	mov    %edx,(%eax)
  80427c:	eb 0a                	jmp    804288 <merging+0x288>
  80427e:	8b 45 0c             	mov    0xc(%ebp),%eax
  804281:	8b 00                	mov    (%eax),%eax
  804283:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80428b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804291:	8b 45 0c             	mov    0xc(%ebp),%eax
  804294:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80429b:	a1 38 60 80 00       	mov    0x806038,%eax
  8042a0:	48                   	dec    %eax
  8042a1:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8042a6:	e9 72 01 00 00       	jmp    80441d <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8042ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8042ae:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8042b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042b5:	74 79                	je     804330 <merging+0x330>
  8042b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8042bb:	74 73                	je     804330 <merging+0x330>
  8042bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042c1:	74 06                	je     8042c9 <merging+0x2c9>
  8042c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8042c7:	75 17                	jne    8042e0 <merging+0x2e0>
  8042c9:	83 ec 04             	sub    $0x4,%esp
  8042cc:	68 b4 58 80 00       	push   $0x8058b4
  8042d1:	68 94 01 00 00       	push   $0x194
  8042d6:	68 41 58 80 00       	push   $0x805841
  8042db:	e8 d3 d2 ff ff       	call   8015b3 <_panic>
  8042e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8042e3:	8b 10                	mov    (%eax),%edx
  8042e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042e8:	89 10                	mov    %edx,(%eax)
  8042ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042ed:	8b 00                	mov    (%eax),%eax
  8042ef:	85 c0                	test   %eax,%eax
  8042f1:	74 0b                	je     8042fe <merging+0x2fe>
  8042f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8042f6:	8b 00                	mov    (%eax),%eax
  8042f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8042fb:	89 50 04             	mov    %edx,0x4(%eax)
  8042fe:	8b 45 08             	mov    0x8(%ebp),%eax
  804301:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804304:	89 10                	mov    %edx,(%eax)
  804306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804309:	8b 55 08             	mov    0x8(%ebp),%edx
  80430c:	89 50 04             	mov    %edx,0x4(%eax)
  80430f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804312:	8b 00                	mov    (%eax),%eax
  804314:	85 c0                	test   %eax,%eax
  804316:	75 08                	jne    804320 <merging+0x320>
  804318:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80431b:	a3 30 60 80 00       	mov    %eax,0x806030
  804320:	a1 38 60 80 00       	mov    0x806038,%eax
  804325:	40                   	inc    %eax
  804326:	a3 38 60 80 00       	mov    %eax,0x806038
  80432b:	e9 ce 00 00 00       	jmp    8043fe <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  804330:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804334:	74 65                	je     80439b <merging+0x39b>
  804336:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80433a:	75 17                	jne    804353 <merging+0x353>
  80433c:	83 ec 04             	sub    $0x4,%esp
  80433f:	68 90 58 80 00       	push   $0x805890
  804344:	68 95 01 00 00       	push   $0x195
  804349:	68 41 58 80 00       	push   $0x805841
  80434e:	e8 60 d2 ff ff       	call   8015b3 <_panic>
  804353:	8b 15 30 60 80 00    	mov    0x806030,%edx
  804359:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80435c:	89 50 04             	mov    %edx,0x4(%eax)
  80435f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804362:	8b 40 04             	mov    0x4(%eax),%eax
  804365:	85 c0                	test   %eax,%eax
  804367:	74 0c                	je     804375 <merging+0x375>
  804369:	a1 30 60 80 00       	mov    0x806030,%eax
  80436e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804371:	89 10                	mov    %edx,(%eax)
  804373:	eb 08                	jmp    80437d <merging+0x37d>
  804375:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804378:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80437d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804380:	a3 30 60 80 00       	mov    %eax,0x806030
  804385:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80438e:	a1 38 60 80 00       	mov    0x806038,%eax
  804393:	40                   	inc    %eax
  804394:	a3 38 60 80 00       	mov    %eax,0x806038
  804399:	eb 63                	jmp    8043fe <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80439b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80439f:	75 17                	jne    8043b8 <merging+0x3b8>
  8043a1:	83 ec 04             	sub    $0x4,%esp
  8043a4:	68 5c 58 80 00       	push   $0x80585c
  8043a9:	68 98 01 00 00       	push   $0x198
  8043ae:	68 41 58 80 00       	push   $0x805841
  8043b3:	e8 fb d1 ff ff       	call   8015b3 <_panic>
  8043b8:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8043be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043c1:	89 10                	mov    %edx,(%eax)
  8043c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043c6:	8b 00                	mov    (%eax),%eax
  8043c8:	85 c0                	test   %eax,%eax
  8043ca:	74 0d                	je     8043d9 <merging+0x3d9>
  8043cc:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8043d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8043d4:	89 50 04             	mov    %edx,0x4(%eax)
  8043d7:	eb 08                	jmp    8043e1 <merging+0x3e1>
  8043d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043dc:	a3 30 60 80 00       	mov    %eax,0x806030
  8043e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043e4:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8043e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043f3:	a1 38 60 80 00       	mov    0x806038,%eax
  8043f8:	40                   	inc    %eax
  8043f9:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  8043fe:	83 ec 0c             	sub    $0xc,%esp
  804401:	ff 75 10             	pushl  0x10(%ebp)
  804404:	e8 f9 ed ff ff       	call   803202 <get_block_size>
  804409:	83 c4 10             	add    $0x10,%esp
  80440c:	83 ec 04             	sub    $0x4,%esp
  80440f:	6a 00                	push   $0x0
  804411:	50                   	push   %eax
  804412:	ff 75 10             	pushl  0x10(%ebp)
  804415:	e8 39 f1 ff ff       	call   803553 <set_block_data>
  80441a:	83 c4 10             	add    $0x10,%esp
	}
}
  80441d:	90                   	nop
  80441e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  804421:	c9                   	leave  
  804422:	c3                   	ret    

00804423 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  804423:	55                   	push   %ebp
  804424:	89 e5                	mov    %esp,%ebp
  804426:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  804429:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80442e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  804431:	a1 30 60 80 00       	mov    0x806030,%eax
  804436:	3b 45 08             	cmp    0x8(%ebp),%eax
  804439:	73 1b                	jae    804456 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80443b:	a1 30 60 80 00       	mov    0x806030,%eax
  804440:	83 ec 04             	sub    $0x4,%esp
  804443:	ff 75 08             	pushl  0x8(%ebp)
  804446:	6a 00                	push   $0x0
  804448:	50                   	push   %eax
  804449:	e8 b2 fb ff ff       	call   804000 <merging>
  80444e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  804451:	e9 8b 00 00 00       	jmp    8044e1 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  804456:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80445b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80445e:	76 18                	jbe    804478 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  804460:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804465:	83 ec 04             	sub    $0x4,%esp
  804468:	ff 75 08             	pushl  0x8(%ebp)
  80446b:	50                   	push   %eax
  80446c:	6a 00                	push   $0x0
  80446e:	e8 8d fb ff ff       	call   804000 <merging>
  804473:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  804476:	eb 69                	jmp    8044e1 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  804478:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80447d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804480:	eb 39                	jmp    8044bb <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  804482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804485:	3b 45 08             	cmp    0x8(%ebp),%eax
  804488:	73 29                	jae    8044b3 <free_block+0x90>
  80448a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80448d:	8b 00                	mov    (%eax),%eax
  80448f:	3b 45 08             	cmp    0x8(%ebp),%eax
  804492:	76 1f                	jbe    8044b3 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  804494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804497:	8b 00                	mov    (%eax),%eax
  804499:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80449c:	83 ec 04             	sub    $0x4,%esp
  80449f:	ff 75 08             	pushl  0x8(%ebp)
  8044a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8044a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8044a8:	e8 53 fb ff ff       	call   804000 <merging>
  8044ad:	83 c4 10             	add    $0x10,%esp
			break;
  8044b0:	90                   	nop
		}
	}
}
  8044b1:	eb 2e                	jmp    8044e1 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8044b3:	a1 34 60 80 00       	mov    0x806034,%eax
  8044b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8044bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044bf:	74 07                	je     8044c8 <free_block+0xa5>
  8044c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044c4:	8b 00                	mov    (%eax),%eax
  8044c6:	eb 05                	jmp    8044cd <free_block+0xaa>
  8044c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8044cd:	a3 34 60 80 00       	mov    %eax,0x806034
  8044d2:	a1 34 60 80 00       	mov    0x806034,%eax
  8044d7:	85 c0                	test   %eax,%eax
  8044d9:	75 a7                	jne    804482 <free_block+0x5f>
  8044db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044df:	75 a1                	jne    804482 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8044e1:	90                   	nop
  8044e2:	c9                   	leave  
  8044e3:	c3                   	ret    

008044e4 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8044e4:	55                   	push   %ebp
  8044e5:	89 e5                	mov    %esp,%ebp
  8044e7:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8044ea:	ff 75 08             	pushl  0x8(%ebp)
  8044ed:	e8 10 ed ff ff       	call   803202 <get_block_size>
  8044f2:	83 c4 04             	add    $0x4,%esp
  8044f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8044f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8044ff:	eb 17                	jmp    804518 <copy_data+0x34>
  804501:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804504:	8b 45 0c             	mov    0xc(%ebp),%eax
  804507:	01 c2                	add    %eax,%edx
  804509:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80450c:	8b 45 08             	mov    0x8(%ebp),%eax
  80450f:	01 c8                	add    %ecx,%eax
  804511:	8a 00                	mov    (%eax),%al
  804513:	88 02                	mov    %al,(%edx)
  804515:	ff 45 fc             	incl   -0x4(%ebp)
  804518:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80451b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80451e:	72 e1                	jb     804501 <copy_data+0x1d>
}
  804520:	90                   	nop
  804521:	c9                   	leave  
  804522:	c3                   	ret    

00804523 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  804523:	55                   	push   %ebp
  804524:	89 e5                	mov    %esp,%ebp
  804526:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  804529:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80452d:	75 23                	jne    804552 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80452f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804533:	74 13                	je     804548 <realloc_block_FF+0x25>
  804535:	83 ec 0c             	sub    $0xc,%esp
  804538:	ff 75 0c             	pushl  0xc(%ebp)
  80453b:	e8 42 f0 ff ff       	call   803582 <alloc_block_FF>
  804540:	83 c4 10             	add    $0x10,%esp
  804543:	e9 e4 06 00 00       	jmp    804c2c <realloc_block_FF+0x709>
		return NULL;
  804548:	b8 00 00 00 00       	mov    $0x0,%eax
  80454d:	e9 da 06 00 00       	jmp    804c2c <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  804552:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804556:	75 18                	jne    804570 <realloc_block_FF+0x4d>
	{
		free_block(va);
  804558:	83 ec 0c             	sub    $0xc,%esp
  80455b:	ff 75 08             	pushl  0x8(%ebp)
  80455e:	e8 c0 fe ff ff       	call   804423 <free_block>
  804563:	83 c4 10             	add    $0x10,%esp
		return NULL;
  804566:	b8 00 00 00 00       	mov    $0x0,%eax
  80456b:	e9 bc 06 00 00       	jmp    804c2c <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  804570:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  804574:	77 07                	ja     80457d <realloc_block_FF+0x5a>
  804576:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80457d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804580:	83 e0 01             	and    $0x1,%eax
  804583:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  804586:	8b 45 0c             	mov    0xc(%ebp),%eax
  804589:	83 c0 08             	add    $0x8,%eax
  80458c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80458f:	83 ec 0c             	sub    $0xc,%esp
  804592:	ff 75 08             	pushl  0x8(%ebp)
  804595:	e8 68 ec ff ff       	call   803202 <get_block_size>
  80459a:	83 c4 10             	add    $0x10,%esp
  80459d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8045a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8045a3:	83 e8 08             	sub    $0x8,%eax
  8045a6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8045a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8045ac:	83 e8 04             	sub    $0x4,%eax
  8045af:	8b 00                	mov    (%eax),%eax
  8045b1:	83 e0 fe             	and    $0xfffffffe,%eax
  8045b4:	89 c2                	mov    %eax,%edx
  8045b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8045b9:	01 d0                	add    %edx,%eax
  8045bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8045be:	83 ec 0c             	sub    $0xc,%esp
  8045c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8045c4:	e8 39 ec ff ff       	call   803202 <get_block_size>
  8045c9:	83 c4 10             	add    $0x10,%esp
  8045cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8045cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8045d2:	83 e8 08             	sub    $0x8,%eax
  8045d5:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8045d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8045db:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8045de:	75 08                	jne    8045e8 <realloc_block_FF+0xc5>
	{
		 return va;
  8045e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e3:	e9 44 06 00 00       	jmp    804c2c <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8045e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8045eb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8045ee:	0f 83 d5 03 00 00    	jae    8049c9 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8045f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8045f7:	2b 45 0c             	sub    0xc(%ebp),%eax
  8045fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8045fd:	83 ec 0c             	sub    $0xc,%esp
  804600:	ff 75 e4             	pushl  -0x1c(%ebp)
  804603:	e8 13 ec ff ff       	call   80321b <is_free_block>
  804608:	83 c4 10             	add    $0x10,%esp
  80460b:	84 c0                	test   %al,%al
  80460d:	0f 84 3b 01 00 00    	je     80474e <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  804613:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804616:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804619:	01 d0                	add    %edx,%eax
  80461b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80461e:	83 ec 04             	sub    $0x4,%esp
  804621:	6a 01                	push   $0x1
  804623:	ff 75 f0             	pushl  -0x10(%ebp)
  804626:	ff 75 08             	pushl  0x8(%ebp)
  804629:	e8 25 ef ff ff       	call   803553 <set_block_data>
  80462e:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  804631:	8b 45 08             	mov    0x8(%ebp),%eax
  804634:	83 e8 04             	sub    $0x4,%eax
  804637:	8b 00                	mov    (%eax),%eax
  804639:	83 e0 fe             	and    $0xfffffffe,%eax
  80463c:	89 c2                	mov    %eax,%edx
  80463e:	8b 45 08             	mov    0x8(%ebp),%eax
  804641:	01 d0                	add    %edx,%eax
  804643:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  804646:	83 ec 04             	sub    $0x4,%esp
  804649:	6a 00                	push   $0x0
  80464b:	ff 75 cc             	pushl  -0x34(%ebp)
  80464e:	ff 75 c8             	pushl  -0x38(%ebp)
  804651:	e8 fd ee ff ff       	call   803553 <set_block_data>
  804656:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804659:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80465d:	74 06                	je     804665 <realloc_block_FF+0x142>
  80465f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804663:	75 17                	jne    80467c <realloc_block_FF+0x159>
  804665:	83 ec 04             	sub    $0x4,%esp
  804668:	68 b4 58 80 00       	push   $0x8058b4
  80466d:	68 f6 01 00 00       	push   $0x1f6
  804672:	68 41 58 80 00       	push   $0x805841
  804677:	e8 37 cf ff ff       	call   8015b3 <_panic>
  80467c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80467f:	8b 10                	mov    (%eax),%edx
  804681:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804684:	89 10                	mov    %edx,(%eax)
  804686:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804689:	8b 00                	mov    (%eax),%eax
  80468b:	85 c0                	test   %eax,%eax
  80468d:	74 0b                	je     80469a <realloc_block_FF+0x177>
  80468f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804692:	8b 00                	mov    (%eax),%eax
  804694:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804697:	89 50 04             	mov    %edx,0x4(%eax)
  80469a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80469d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8046a0:	89 10                	mov    %edx,(%eax)
  8046a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8046a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046a8:	89 50 04             	mov    %edx,0x4(%eax)
  8046ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8046ae:	8b 00                	mov    (%eax),%eax
  8046b0:	85 c0                	test   %eax,%eax
  8046b2:	75 08                	jne    8046bc <realloc_block_FF+0x199>
  8046b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8046b7:	a3 30 60 80 00       	mov    %eax,0x806030
  8046bc:	a1 38 60 80 00       	mov    0x806038,%eax
  8046c1:	40                   	inc    %eax
  8046c2:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8046c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8046cb:	75 17                	jne    8046e4 <realloc_block_FF+0x1c1>
  8046cd:	83 ec 04             	sub    $0x4,%esp
  8046d0:	68 23 58 80 00       	push   $0x805823
  8046d5:	68 f7 01 00 00       	push   $0x1f7
  8046da:	68 41 58 80 00       	push   $0x805841
  8046df:	e8 cf ce ff ff       	call   8015b3 <_panic>
  8046e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046e7:	8b 00                	mov    (%eax),%eax
  8046e9:	85 c0                	test   %eax,%eax
  8046eb:	74 10                	je     8046fd <realloc_block_FF+0x1da>
  8046ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046f0:	8b 00                	mov    (%eax),%eax
  8046f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046f5:	8b 52 04             	mov    0x4(%edx),%edx
  8046f8:	89 50 04             	mov    %edx,0x4(%eax)
  8046fb:	eb 0b                	jmp    804708 <realloc_block_FF+0x1e5>
  8046fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804700:	8b 40 04             	mov    0x4(%eax),%eax
  804703:	a3 30 60 80 00       	mov    %eax,0x806030
  804708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80470b:	8b 40 04             	mov    0x4(%eax),%eax
  80470e:	85 c0                	test   %eax,%eax
  804710:	74 0f                	je     804721 <realloc_block_FF+0x1fe>
  804712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804715:	8b 40 04             	mov    0x4(%eax),%eax
  804718:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80471b:	8b 12                	mov    (%edx),%edx
  80471d:	89 10                	mov    %edx,(%eax)
  80471f:	eb 0a                	jmp    80472b <realloc_block_FF+0x208>
  804721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804724:	8b 00                	mov    (%eax),%eax
  804726:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80472b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80472e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804734:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804737:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80473e:	a1 38 60 80 00       	mov    0x806038,%eax
  804743:	48                   	dec    %eax
  804744:	a3 38 60 80 00       	mov    %eax,0x806038
  804749:	e9 73 02 00 00       	jmp    8049c1 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80474e:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  804752:	0f 86 69 02 00 00    	jbe    8049c1 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804758:	83 ec 04             	sub    $0x4,%esp
  80475b:	6a 01                	push   $0x1
  80475d:	ff 75 f0             	pushl  -0x10(%ebp)
  804760:	ff 75 08             	pushl  0x8(%ebp)
  804763:	e8 eb ed ff ff       	call   803553 <set_block_data>
  804768:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80476b:	8b 45 08             	mov    0x8(%ebp),%eax
  80476e:	83 e8 04             	sub    $0x4,%eax
  804771:	8b 00                	mov    (%eax),%eax
  804773:	83 e0 fe             	and    $0xfffffffe,%eax
  804776:	89 c2                	mov    %eax,%edx
  804778:	8b 45 08             	mov    0x8(%ebp),%eax
  80477b:	01 d0                	add    %edx,%eax
  80477d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  804780:	a1 38 60 80 00       	mov    0x806038,%eax
  804785:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  804788:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80478c:	75 68                	jne    8047f6 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80478e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804792:	75 17                	jne    8047ab <realloc_block_FF+0x288>
  804794:	83 ec 04             	sub    $0x4,%esp
  804797:	68 5c 58 80 00       	push   $0x80585c
  80479c:	68 06 02 00 00       	push   $0x206
  8047a1:	68 41 58 80 00       	push   $0x805841
  8047a6:	e8 08 ce ff ff       	call   8015b3 <_panic>
  8047ab:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8047b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047b4:	89 10                	mov    %edx,(%eax)
  8047b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047b9:	8b 00                	mov    (%eax),%eax
  8047bb:	85 c0                	test   %eax,%eax
  8047bd:	74 0d                	je     8047cc <realloc_block_FF+0x2a9>
  8047bf:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8047c4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8047c7:	89 50 04             	mov    %edx,0x4(%eax)
  8047ca:	eb 08                	jmp    8047d4 <realloc_block_FF+0x2b1>
  8047cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047cf:	a3 30 60 80 00       	mov    %eax,0x806030
  8047d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047d7:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8047dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8047e6:	a1 38 60 80 00       	mov    0x806038,%eax
  8047eb:	40                   	inc    %eax
  8047ec:	a3 38 60 80 00       	mov    %eax,0x806038
  8047f1:	e9 b0 01 00 00       	jmp    8049a6 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8047f6:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8047fb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8047fe:	76 68                	jbe    804868 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804800:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804804:	75 17                	jne    80481d <realloc_block_FF+0x2fa>
  804806:	83 ec 04             	sub    $0x4,%esp
  804809:	68 5c 58 80 00       	push   $0x80585c
  80480e:	68 0b 02 00 00       	push   $0x20b
  804813:	68 41 58 80 00       	push   $0x805841
  804818:	e8 96 cd ff ff       	call   8015b3 <_panic>
  80481d:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  804823:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804826:	89 10                	mov    %edx,(%eax)
  804828:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80482b:	8b 00                	mov    (%eax),%eax
  80482d:	85 c0                	test   %eax,%eax
  80482f:	74 0d                	je     80483e <realloc_block_FF+0x31b>
  804831:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804836:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804839:	89 50 04             	mov    %edx,0x4(%eax)
  80483c:	eb 08                	jmp    804846 <realloc_block_FF+0x323>
  80483e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804841:	a3 30 60 80 00       	mov    %eax,0x806030
  804846:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804849:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80484e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804851:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804858:	a1 38 60 80 00       	mov    0x806038,%eax
  80485d:	40                   	inc    %eax
  80485e:	a3 38 60 80 00       	mov    %eax,0x806038
  804863:	e9 3e 01 00 00       	jmp    8049a6 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804868:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80486d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804870:	73 68                	jae    8048da <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  804872:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804876:	75 17                	jne    80488f <realloc_block_FF+0x36c>
  804878:	83 ec 04             	sub    $0x4,%esp
  80487b:	68 90 58 80 00       	push   $0x805890
  804880:	68 10 02 00 00       	push   $0x210
  804885:	68 41 58 80 00       	push   $0x805841
  80488a:	e8 24 cd ff ff       	call   8015b3 <_panic>
  80488f:	8b 15 30 60 80 00    	mov    0x806030,%edx
  804895:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804898:	89 50 04             	mov    %edx,0x4(%eax)
  80489b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80489e:	8b 40 04             	mov    0x4(%eax),%eax
  8048a1:	85 c0                	test   %eax,%eax
  8048a3:	74 0c                	je     8048b1 <realloc_block_FF+0x38e>
  8048a5:	a1 30 60 80 00       	mov    0x806030,%eax
  8048aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8048ad:	89 10                	mov    %edx,(%eax)
  8048af:	eb 08                	jmp    8048b9 <realloc_block_FF+0x396>
  8048b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048b4:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8048b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048bc:	a3 30 60 80 00       	mov    %eax,0x806030
  8048c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8048ca:	a1 38 60 80 00       	mov    0x806038,%eax
  8048cf:	40                   	inc    %eax
  8048d0:	a3 38 60 80 00       	mov    %eax,0x806038
  8048d5:	e9 cc 00 00 00       	jmp    8049a6 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8048da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8048e1:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8048e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8048e9:	e9 8a 00 00 00       	jmp    804978 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8048ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048f1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8048f4:	73 7a                	jae    804970 <realloc_block_FF+0x44d>
  8048f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048f9:	8b 00                	mov    (%eax),%eax
  8048fb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8048fe:	73 70                	jae    804970 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804900:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804904:	74 06                	je     80490c <realloc_block_FF+0x3e9>
  804906:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80490a:	75 17                	jne    804923 <realloc_block_FF+0x400>
  80490c:	83 ec 04             	sub    $0x4,%esp
  80490f:	68 b4 58 80 00       	push   $0x8058b4
  804914:	68 1a 02 00 00       	push   $0x21a
  804919:	68 41 58 80 00       	push   $0x805841
  80491e:	e8 90 cc ff ff       	call   8015b3 <_panic>
  804923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804926:	8b 10                	mov    (%eax),%edx
  804928:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80492b:	89 10                	mov    %edx,(%eax)
  80492d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804930:	8b 00                	mov    (%eax),%eax
  804932:	85 c0                	test   %eax,%eax
  804934:	74 0b                	je     804941 <realloc_block_FF+0x41e>
  804936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804939:	8b 00                	mov    (%eax),%eax
  80493b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80493e:	89 50 04             	mov    %edx,0x4(%eax)
  804941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804944:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804947:	89 10                	mov    %edx,(%eax)
  804949:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80494c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80494f:	89 50 04             	mov    %edx,0x4(%eax)
  804952:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804955:	8b 00                	mov    (%eax),%eax
  804957:	85 c0                	test   %eax,%eax
  804959:	75 08                	jne    804963 <realloc_block_FF+0x440>
  80495b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80495e:	a3 30 60 80 00       	mov    %eax,0x806030
  804963:	a1 38 60 80 00       	mov    0x806038,%eax
  804968:	40                   	inc    %eax
  804969:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  80496e:	eb 36                	jmp    8049a6 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804970:	a1 34 60 80 00       	mov    0x806034,%eax
  804975:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80497c:	74 07                	je     804985 <realloc_block_FF+0x462>
  80497e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804981:	8b 00                	mov    (%eax),%eax
  804983:	eb 05                	jmp    80498a <realloc_block_FF+0x467>
  804985:	b8 00 00 00 00       	mov    $0x0,%eax
  80498a:	a3 34 60 80 00       	mov    %eax,0x806034
  80498f:	a1 34 60 80 00       	mov    0x806034,%eax
  804994:	85 c0                	test   %eax,%eax
  804996:	0f 85 52 ff ff ff    	jne    8048ee <realloc_block_FF+0x3cb>
  80499c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8049a0:	0f 85 48 ff ff ff    	jne    8048ee <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8049a6:	83 ec 04             	sub    $0x4,%esp
  8049a9:	6a 00                	push   $0x0
  8049ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8049ae:	ff 75 d4             	pushl  -0x2c(%ebp)
  8049b1:	e8 9d eb ff ff       	call   803553 <set_block_data>
  8049b6:	83 c4 10             	add    $0x10,%esp
				return va;
  8049b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8049bc:	e9 6b 02 00 00       	jmp    804c2c <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8049c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8049c4:	e9 63 02 00 00       	jmp    804c2c <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8049c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8049cc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8049cf:	0f 86 4d 02 00 00    	jbe    804c22 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8049d5:	83 ec 0c             	sub    $0xc,%esp
  8049d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8049db:	e8 3b e8 ff ff       	call   80321b <is_free_block>
  8049e0:	83 c4 10             	add    $0x10,%esp
  8049e3:	84 c0                	test   %al,%al
  8049e5:	0f 84 37 02 00 00    	je     804c22 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8049eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8049ee:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8049f1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8049f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8049f7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8049fa:	76 38                	jbe    804a34 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  8049fc:	83 ec 0c             	sub    $0xc,%esp
  8049ff:	ff 75 0c             	pushl  0xc(%ebp)
  804a02:	e8 7b eb ff ff       	call   803582 <alloc_block_FF>
  804a07:	83 c4 10             	add    $0x10,%esp
  804a0a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804a0d:	83 ec 08             	sub    $0x8,%esp
  804a10:	ff 75 c0             	pushl  -0x40(%ebp)
  804a13:	ff 75 08             	pushl  0x8(%ebp)
  804a16:	e8 c9 fa ff ff       	call   8044e4 <copy_data>
  804a1b:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  804a1e:	83 ec 0c             	sub    $0xc,%esp
  804a21:	ff 75 08             	pushl  0x8(%ebp)
  804a24:	e8 fa f9 ff ff       	call   804423 <free_block>
  804a29:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804a2c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804a2f:	e9 f8 01 00 00       	jmp    804c2c <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a37:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804a3a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804a3d:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804a41:	0f 87 a0 00 00 00    	ja     804ae7 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804a4b:	75 17                	jne    804a64 <realloc_block_FF+0x541>
  804a4d:	83 ec 04             	sub    $0x4,%esp
  804a50:	68 23 58 80 00       	push   $0x805823
  804a55:	68 38 02 00 00       	push   $0x238
  804a5a:	68 41 58 80 00       	push   $0x805841
  804a5f:	e8 4f cb ff ff       	call   8015b3 <_panic>
  804a64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a67:	8b 00                	mov    (%eax),%eax
  804a69:	85 c0                	test   %eax,%eax
  804a6b:	74 10                	je     804a7d <realloc_block_FF+0x55a>
  804a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a70:	8b 00                	mov    (%eax),%eax
  804a72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804a75:	8b 52 04             	mov    0x4(%edx),%edx
  804a78:	89 50 04             	mov    %edx,0x4(%eax)
  804a7b:	eb 0b                	jmp    804a88 <realloc_block_FF+0x565>
  804a7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a80:	8b 40 04             	mov    0x4(%eax),%eax
  804a83:	a3 30 60 80 00       	mov    %eax,0x806030
  804a88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a8b:	8b 40 04             	mov    0x4(%eax),%eax
  804a8e:	85 c0                	test   %eax,%eax
  804a90:	74 0f                	je     804aa1 <realloc_block_FF+0x57e>
  804a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a95:	8b 40 04             	mov    0x4(%eax),%eax
  804a98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804a9b:	8b 12                	mov    (%edx),%edx
  804a9d:	89 10                	mov    %edx,(%eax)
  804a9f:	eb 0a                	jmp    804aab <realloc_block_FF+0x588>
  804aa1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804aa4:	8b 00                	mov    (%eax),%eax
  804aa6:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804aab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804aae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804ab4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ab7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804abe:	a1 38 60 80 00       	mov    0x806038,%eax
  804ac3:	48                   	dec    %eax
  804ac4:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804ac9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804acf:	01 d0                	add    %edx,%eax
  804ad1:	83 ec 04             	sub    $0x4,%esp
  804ad4:	6a 01                	push   $0x1
  804ad6:	50                   	push   %eax
  804ad7:	ff 75 08             	pushl  0x8(%ebp)
  804ada:	e8 74 ea ff ff       	call   803553 <set_block_data>
  804adf:	83 c4 10             	add    $0x10,%esp
  804ae2:	e9 36 01 00 00       	jmp    804c1d <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804ae7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804aea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804aed:	01 d0                	add    %edx,%eax
  804aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804af2:	83 ec 04             	sub    $0x4,%esp
  804af5:	6a 01                	push   $0x1
  804af7:	ff 75 f0             	pushl  -0x10(%ebp)
  804afa:	ff 75 08             	pushl  0x8(%ebp)
  804afd:	e8 51 ea ff ff       	call   803553 <set_block_data>
  804b02:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804b05:	8b 45 08             	mov    0x8(%ebp),%eax
  804b08:	83 e8 04             	sub    $0x4,%eax
  804b0b:	8b 00                	mov    (%eax),%eax
  804b0d:	83 e0 fe             	and    $0xfffffffe,%eax
  804b10:	89 c2                	mov    %eax,%edx
  804b12:	8b 45 08             	mov    0x8(%ebp),%eax
  804b15:	01 d0                	add    %edx,%eax
  804b17:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804b1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804b1e:	74 06                	je     804b26 <realloc_block_FF+0x603>
  804b20:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804b24:	75 17                	jne    804b3d <realloc_block_FF+0x61a>
  804b26:	83 ec 04             	sub    $0x4,%esp
  804b29:	68 b4 58 80 00       	push   $0x8058b4
  804b2e:	68 44 02 00 00       	push   $0x244
  804b33:	68 41 58 80 00       	push   $0x805841
  804b38:	e8 76 ca ff ff       	call   8015b3 <_panic>
  804b3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b40:	8b 10                	mov    (%eax),%edx
  804b42:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804b45:	89 10                	mov    %edx,(%eax)
  804b47:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804b4a:	8b 00                	mov    (%eax),%eax
  804b4c:	85 c0                	test   %eax,%eax
  804b4e:	74 0b                	je     804b5b <realloc_block_FF+0x638>
  804b50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b53:	8b 00                	mov    (%eax),%eax
  804b55:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804b58:	89 50 04             	mov    %edx,0x4(%eax)
  804b5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b5e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804b61:	89 10                	mov    %edx,(%eax)
  804b63:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804b66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b69:	89 50 04             	mov    %edx,0x4(%eax)
  804b6c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804b6f:	8b 00                	mov    (%eax),%eax
  804b71:	85 c0                	test   %eax,%eax
  804b73:	75 08                	jne    804b7d <realloc_block_FF+0x65a>
  804b75:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804b78:	a3 30 60 80 00       	mov    %eax,0x806030
  804b7d:	a1 38 60 80 00       	mov    0x806038,%eax
  804b82:	40                   	inc    %eax
  804b83:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804b88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804b8c:	75 17                	jne    804ba5 <realloc_block_FF+0x682>
  804b8e:	83 ec 04             	sub    $0x4,%esp
  804b91:	68 23 58 80 00       	push   $0x805823
  804b96:	68 45 02 00 00       	push   $0x245
  804b9b:	68 41 58 80 00       	push   $0x805841
  804ba0:	e8 0e ca ff ff       	call   8015b3 <_panic>
  804ba5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ba8:	8b 00                	mov    (%eax),%eax
  804baa:	85 c0                	test   %eax,%eax
  804bac:	74 10                	je     804bbe <realloc_block_FF+0x69b>
  804bae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bb1:	8b 00                	mov    (%eax),%eax
  804bb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804bb6:	8b 52 04             	mov    0x4(%edx),%edx
  804bb9:	89 50 04             	mov    %edx,0x4(%eax)
  804bbc:	eb 0b                	jmp    804bc9 <realloc_block_FF+0x6a6>
  804bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bc1:	8b 40 04             	mov    0x4(%eax),%eax
  804bc4:	a3 30 60 80 00       	mov    %eax,0x806030
  804bc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bcc:	8b 40 04             	mov    0x4(%eax),%eax
  804bcf:	85 c0                	test   %eax,%eax
  804bd1:	74 0f                	je     804be2 <realloc_block_FF+0x6bf>
  804bd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bd6:	8b 40 04             	mov    0x4(%eax),%eax
  804bd9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804bdc:	8b 12                	mov    (%edx),%edx
  804bde:	89 10                	mov    %edx,(%eax)
  804be0:	eb 0a                	jmp    804bec <realloc_block_FF+0x6c9>
  804be2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804be5:	8b 00                	mov    (%eax),%eax
  804be7:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804bf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804bff:	a1 38 60 80 00       	mov    0x806038,%eax
  804c04:	48                   	dec    %eax
  804c05:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804c0a:	83 ec 04             	sub    $0x4,%esp
  804c0d:	6a 00                	push   $0x0
  804c0f:	ff 75 bc             	pushl  -0x44(%ebp)
  804c12:	ff 75 b8             	pushl  -0x48(%ebp)
  804c15:	e8 39 e9 ff ff       	call   803553 <set_block_data>
  804c1a:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  804c20:	eb 0a                	jmp    804c2c <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804c22:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804c29:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804c2c:	c9                   	leave  
  804c2d:	c3                   	ret    

00804c2e <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804c2e:	55                   	push   %ebp
  804c2f:	89 e5                	mov    %esp,%ebp
  804c31:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804c34:	83 ec 04             	sub    $0x4,%esp
  804c37:	68 20 59 80 00       	push   $0x805920
  804c3c:	68 58 02 00 00       	push   $0x258
  804c41:	68 41 58 80 00       	push   $0x805841
  804c46:	e8 68 c9 ff ff       	call   8015b3 <_panic>

00804c4b <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804c4b:	55                   	push   %ebp
  804c4c:	89 e5                	mov    %esp,%ebp
  804c4e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804c51:	83 ec 04             	sub    $0x4,%esp
  804c54:	68 48 59 80 00       	push   $0x805948
  804c59:	68 61 02 00 00       	push   $0x261
  804c5e:	68 41 58 80 00       	push   $0x805841
  804c63:	e8 4b c9 ff ff       	call   8015b3 <_panic>

00804c68 <__udivdi3>:
  804c68:	55                   	push   %ebp
  804c69:	57                   	push   %edi
  804c6a:	56                   	push   %esi
  804c6b:	53                   	push   %ebx
  804c6c:	83 ec 1c             	sub    $0x1c,%esp
  804c6f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804c73:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804c77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804c7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804c7f:	89 ca                	mov    %ecx,%edx
  804c81:	89 f8                	mov    %edi,%eax
  804c83:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804c87:	85 f6                	test   %esi,%esi
  804c89:	75 2d                	jne    804cb8 <__udivdi3+0x50>
  804c8b:	39 cf                	cmp    %ecx,%edi
  804c8d:	77 65                	ja     804cf4 <__udivdi3+0x8c>
  804c8f:	89 fd                	mov    %edi,%ebp
  804c91:	85 ff                	test   %edi,%edi
  804c93:	75 0b                	jne    804ca0 <__udivdi3+0x38>
  804c95:	b8 01 00 00 00       	mov    $0x1,%eax
  804c9a:	31 d2                	xor    %edx,%edx
  804c9c:	f7 f7                	div    %edi
  804c9e:	89 c5                	mov    %eax,%ebp
  804ca0:	31 d2                	xor    %edx,%edx
  804ca2:	89 c8                	mov    %ecx,%eax
  804ca4:	f7 f5                	div    %ebp
  804ca6:	89 c1                	mov    %eax,%ecx
  804ca8:	89 d8                	mov    %ebx,%eax
  804caa:	f7 f5                	div    %ebp
  804cac:	89 cf                	mov    %ecx,%edi
  804cae:	89 fa                	mov    %edi,%edx
  804cb0:	83 c4 1c             	add    $0x1c,%esp
  804cb3:	5b                   	pop    %ebx
  804cb4:	5e                   	pop    %esi
  804cb5:	5f                   	pop    %edi
  804cb6:	5d                   	pop    %ebp
  804cb7:	c3                   	ret    
  804cb8:	39 ce                	cmp    %ecx,%esi
  804cba:	77 28                	ja     804ce4 <__udivdi3+0x7c>
  804cbc:	0f bd fe             	bsr    %esi,%edi
  804cbf:	83 f7 1f             	xor    $0x1f,%edi
  804cc2:	75 40                	jne    804d04 <__udivdi3+0x9c>
  804cc4:	39 ce                	cmp    %ecx,%esi
  804cc6:	72 0a                	jb     804cd2 <__udivdi3+0x6a>
  804cc8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804ccc:	0f 87 9e 00 00 00    	ja     804d70 <__udivdi3+0x108>
  804cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  804cd7:	89 fa                	mov    %edi,%edx
  804cd9:	83 c4 1c             	add    $0x1c,%esp
  804cdc:	5b                   	pop    %ebx
  804cdd:	5e                   	pop    %esi
  804cde:	5f                   	pop    %edi
  804cdf:	5d                   	pop    %ebp
  804ce0:	c3                   	ret    
  804ce1:	8d 76 00             	lea    0x0(%esi),%esi
  804ce4:	31 ff                	xor    %edi,%edi
  804ce6:	31 c0                	xor    %eax,%eax
  804ce8:	89 fa                	mov    %edi,%edx
  804cea:	83 c4 1c             	add    $0x1c,%esp
  804ced:	5b                   	pop    %ebx
  804cee:	5e                   	pop    %esi
  804cef:	5f                   	pop    %edi
  804cf0:	5d                   	pop    %ebp
  804cf1:	c3                   	ret    
  804cf2:	66 90                	xchg   %ax,%ax
  804cf4:	89 d8                	mov    %ebx,%eax
  804cf6:	f7 f7                	div    %edi
  804cf8:	31 ff                	xor    %edi,%edi
  804cfa:	89 fa                	mov    %edi,%edx
  804cfc:	83 c4 1c             	add    $0x1c,%esp
  804cff:	5b                   	pop    %ebx
  804d00:	5e                   	pop    %esi
  804d01:	5f                   	pop    %edi
  804d02:	5d                   	pop    %ebp
  804d03:	c3                   	ret    
  804d04:	bd 20 00 00 00       	mov    $0x20,%ebp
  804d09:	89 eb                	mov    %ebp,%ebx
  804d0b:	29 fb                	sub    %edi,%ebx
  804d0d:	89 f9                	mov    %edi,%ecx
  804d0f:	d3 e6                	shl    %cl,%esi
  804d11:	89 c5                	mov    %eax,%ebp
  804d13:	88 d9                	mov    %bl,%cl
  804d15:	d3 ed                	shr    %cl,%ebp
  804d17:	89 e9                	mov    %ebp,%ecx
  804d19:	09 f1                	or     %esi,%ecx
  804d1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804d1f:	89 f9                	mov    %edi,%ecx
  804d21:	d3 e0                	shl    %cl,%eax
  804d23:	89 c5                	mov    %eax,%ebp
  804d25:	89 d6                	mov    %edx,%esi
  804d27:	88 d9                	mov    %bl,%cl
  804d29:	d3 ee                	shr    %cl,%esi
  804d2b:	89 f9                	mov    %edi,%ecx
  804d2d:	d3 e2                	shl    %cl,%edx
  804d2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804d33:	88 d9                	mov    %bl,%cl
  804d35:	d3 e8                	shr    %cl,%eax
  804d37:	09 c2                	or     %eax,%edx
  804d39:	89 d0                	mov    %edx,%eax
  804d3b:	89 f2                	mov    %esi,%edx
  804d3d:	f7 74 24 0c          	divl   0xc(%esp)
  804d41:	89 d6                	mov    %edx,%esi
  804d43:	89 c3                	mov    %eax,%ebx
  804d45:	f7 e5                	mul    %ebp
  804d47:	39 d6                	cmp    %edx,%esi
  804d49:	72 19                	jb     804d64 <__udivdi3+0xfc>
  804d4b:	74 0b                	je     804d58 <__udivdi3+0xf0>
  804d4d:	89 d8                	mov    %ebx,%eax
  804d4f:	31 ff                	xor    %edi,%edi
  804d51:	e9 58 ff ff ff       	jmp    804cae <__udivdi3+0x46>
  804d56:	66 90                	xchg   %ax,%ax
  804d58:	8b 54 24 08          	mov    0x8(%esp),%edx
  804d5c:	89 f9                	mov    %edi,%ecx
  804d5e:	d3 e2                	shl    %cl,%edx
  804d60:	39 c2                	cmp    %eax,%edx
  804d62:	73 e9                	jae    804d4d <__udivdi3+0xe5>
  804d64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804d67:	31 ff                	xor    %edi,%edi
  804d69:	e9 40 ff ff ff       	jmp    804cae <__udivdi3+0x46>
  804d6e:	66 90                	xchg   %ax,%ax
  804d70:	31 c0                	xor    %eax,%eax
  804d72:	e9 37 ff ff ff       	jmp    804cae <__udivdi3+0x46>
  804d77:	90                   	nop

00804d78 <__umoddi3>:
  804d78:	55                   	push   %ebp
  804d79:	57                   	push   %edi
  804d7a:	56                   	push   %esi
  804d7b:	53                   	push   %ebx
  804d7c:	83 ec 1c             	sub    $0x1c,%esp
  804d7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804d83:	8b 74 24 34          	mov    0x34(%esp),%esi
  804d87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804d8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804d8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804d93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804d97:	89 f3                	mov    %esi,%ebx
  804d99:	89 fa                	mov    %edi,%edx
  804d9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804d9f:	89 34 24             	mov    %esi,(%esp)
  804da2:	85 c0                	test   %eax,%eax
  804da4:	75 1a                	jne    804dc0 <__umoddi3+0x48>
  804da6:	39 f7                	cmp    %esi,%edi
  804da8:	0f 86 a2 00 00 00    	jbe    804e50 <__umoddi3+0xd8>
  804dae:	89 c8                	mov    %ecx,%eax
  804db0:	89 f2                	mov    %esi,%edx
  804db2:	f7 f7                	div    %edi
  804db4:	89 d0                	mov    %edx,%eax
  804db6:	31 d2                	xor    %edx,%edx
  804db8:	83 c4 1c             	add    $0x1c,%esp
  804dbb:	5b                   	pop    %ebx
  804dbc:	5e                   	pop    %esi
  804dbd:	5f                   	pop    %edi
  804dbe:	5d                   	pop    %ebp
  804dbf:	c3                   	ret    
  804dc0:	39 f0                	cmp    %esi,%eax
  804dc2:	0f 87 ac 00 00 00    	ja     804e74 <__umoddi3+0xfc>
  804dc8:	0f bd e8             	bsr    %eax,%ebp
  804dcb:	83 f5 1f             	xor    $0x1f,%ebp
  804dce:	0f 84 ac 00 00 00    	je     804e80 <__umoddi3+0x108>
  804dd4:	bf 20 00 00 00       	mov    $0x20,%edi
  804dd9:	29 ef                	sub    %ebp,%edi
  804ddb:	89 fe                	mov    %edi,%esi
  804ddd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804de1:	89 e9                	mov    %ebp,%ecx
  804de3:	d3 e0                	shl    %cl,%eax
  804de5:	89 d7                	mov    %edx,%edi
  804de7:	89 f1                	mov    %esi,%ecx
  804de9:	d3 ef                	shr    %cl,%edi
  804deb:	09 c7                	or     %eax,%edi
  804ded:	89 e9                	mov    %ebp,%ecx
  804def:	d3 e2                	shl    %cl,%edx
  804df1:	89 14 24             	mov    %edx,(%esp)
  804df4:	89 d8                	mov    %ebx,%eax
  804df6:	d3 e0                	shl    %cl,%eax
  804df8:	89 c2                	mov    %eax,%edx
  804dfa:	8b 44 24 08          	mov    0x8(%esp),%eax
  804dfe:	d3 e0                	shl    %cl,%eax
  804e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  804e04:	8b 44 24 08          	mov    0x8(%esp),%eax
  804e08:	89 f1                	mov    %esi,%ecx
  804e0a:	d3 e8                	shr    %cl,%eax
  804e0c:	09 d0                	or     %edx,%eax
  804e0e:	d3 eb                	shr    %cl,%ebx
  804e10:	89 da                	mov    %ebx,%edx
  804e12:	f7 f7                	div    %edi
  804e14:	89 d3                	mov    %edx,%ebx
  804e16:	f7 24 24             	mull   (%esp)
  804e19:	89 c6                	mov    %eax,%esi
  804e1b:	89 d1                	mov    %edx,%ecx
  804e1d:	39 d3                	cmp    %edx,%ebx
  804e1f:	0f 82 87 00 00 00    	jb     804eac <__umoddi3+0x134>
  804e25:	0f 84 91 00 00 00    	je     804ebc <__umoddi3+0x144>
  804e2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  804e2f:	29 f2                	sub    %esi,%edx
  804e31:	19 cb                	sbb    %ecx,%ebx
  804e33:	89 d8                	mov    %ebx,%eax
  804e35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804e39:	d3 e0                	shl    %cl,%eax
  804e3b:	89 e9                	mov    %ebp,%ecx
  804e3d:	d3 ea                	shr    %cl,%edx
  804e3f:	09 d0                	or     %edx,%eax
  804e41:	89 e9                	mov    %ebp,%ecx
  804e43:	d3 eb                	shr    %cl,%ebx
  804e45:	89 da                	mov    %ebx,%edx
  804e47:	83 c4 1c             	add    $0x1c,%esp
  804e4a:	5b                   	pop    %ebx
  804e4b:	5e                   	pop    %esi
  804e4c:	5f                   	pop    %edi
  804e4d:	5d                   	pop    %ebp
  804e4e:	c3                   	ret    
  804e4f:	90                   	nop
  804e50:	89 fd                	mov    %edi,%ebp
  804e52:	85 ff                	test   %edi,%edi
  804e54:	75 0b                	jne    804e61 <__umoddi3+0xe9>
  804e56:	b8 01 00 00 00       	mov    $0x1,%eax
  804e5b:	31 d2                	xor    %edx,%edx
  804e5d:	f7 f7                	div    %edi
  804e5f:	89 c5                	mov    %eax,%ebp
  804e61:	89 f0                	mov    %esi,%eax
  804e63:	31 d2                	xor    %edx,%edx
  804e65:	f7 f5                	div    %ebp
  804e67:	89 c8                	mov    %ecx,%eax
  804e69:	f7 f5                	div    %ebp
  804e6b:	89 d0                	mov    %edx,%eax
  804e6d:	e9 44 ff ff ff       	jmp    804db6 <__umoddi3+0x3e>
  804e72:	66 90                	xchg   %ax,%ax
  804e74:	89 c8                	mov    %ecx,%eax
  804e76:	89 f2                	mov    %esi,%edx
  804e78:	83 c4 1c             	add    $0x1c,%esp
  804e7b:	5b                   	pop    %ebx
  804e7c:	5e                   	pop    %esi
  804e7d:	5f                   	pop    %edi
  804e7e:	5d                   	pop    %ebp
  804e7f:	c3                   	ret    
  804e80:	3b 04 24             	cmp    (%esp),%eax
  804e83:	72 06                	jb     804e8b <__umoddi3+0x113>
  804e85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804e89:	77 0f                	ja     804e9a <__umoddi3+0x122>
  804e8b:	89 f2                	mov    %esi,%edx
  804e8d:	29 f9                	sub    %edi,%ecx
  804e8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804e93:	89 14 24             	mov    %edx,(%esp)
  804e96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804e9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  804e9e:	8b 14 24             	mov    (%esp),%edx
  804ea1:	83 c4 1c             	add    $0x1c,%esp
  804ea4:	5b                   	pop    %ebx
  804ea5:	5e                   	pop    %esi
  804ea6:	5f                   	pop    %edi
  804ea7:	5d                   	pop    %ebp
  804ea8:	c3                   	ret    
  804ea9:	8d 76 00             	lea    0x0(%esi),%esi
  804eac:	2b 04 24             	sub    (%esp),%eax
  804eaf:	19 fa                	sbb    %edi,%edx
  804eb1:	89 d1                	mov    %edx,%ecx
  804eb3:	89 c6                	mov    %eax,%esi
  804eb5:	e9 71 ff ff ff       	jmp    804e2b <__umoddi3+0xb3>
  804eba:	66 90                	xchg   %ax,%ax
  804ebc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804ec0:	72 ea                	jb     804eac <__umoddi3+0x134>
  804ec2:	89 d9                	mov    %ebx,%ecx
  804ec4:	e9 62 ff ff ff       	jmp    804e2b <__umoddi3+0xb3>
