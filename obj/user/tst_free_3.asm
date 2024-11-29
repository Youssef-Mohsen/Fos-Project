
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
  8000a3:	68 60 4f 80 00       	push   $0x804f60
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 a1 4f 80 00       	push   $0x804fa1
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
  8000d9:	68 60 4f 80 00       	push   $0x804f60
  8000de:	6a 21                	push   $0x21
  8000e0:	68 a1 4f 80 00       	push   $0x804fa1
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
  80010f:	68 60 4f 80 00       	push   $0x804f60
  800114:	6a 22                	push   $0x22
  800116:	68 a1 4f 80 00       	push   $0x804fa1
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
  800145:	68 60 4f 80 00       	push   $0x804f60
  80014a:	6a 23                	push   $0x23
  80014c:	68 a1 4f 80 00       	push   $0x804fa1
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
  80017b:	68 60 4f 80 00       	push   $0x804f60
  800180:	6a 24                	push   $0x24
  800182:	68 a1 4f 80 00       	push   $0x804fa1
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
  8001b1:	68 60 4f 80 00       	push   $0x804f60
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 a1 4f 80 00       	push   $0x804fa1
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
  8001e9:	68 60 4f 80 00       	push   $0x804f60
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 a1 4f 80 00       	push   $0x804fa1
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
  800221:	68 60 4f 80 00       	push   $0x804f60
  800226:	6a 27                	push   $0x27
  800228:	68 a1 4f 80 00       	push   $0x804fa1
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
  800259:	68 60 4f 80 00       	push   $0x804f60
  80025e:	6a 28                	push   $0x28
  800260:	68 a1 4f 80 00       	push   $0x804fa1
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
  800291:	68 60 4f 80 00       	push   $0x804f60
  800296:	6a 29                	push   $0x29
  800298:	68 a1 4f 80 00       	push   $0x804fa1
  80029d:	e8 11 13 00 00       	call   8015b3 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8002a7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 b4 4f 80 00       	push   $0x804fb4
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 a1 4f 80 00       	push   $0x804fa1
  8002c0:	e8 ee 12 00 00       	call   8015b3 <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 80 2a 00 00       	call   802d4a <sys_calculate_free_frames>
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
  8002e1:	e8 af 2a 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  80031d:	68 fc 4f 80 00       	push   $0x804ffc
  800322:	6a 39                	push   $0x39
  800324:	68 a1 4f 80 00       	push   $0x804fa1
  800329:	e8 85 12 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 62 2a 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 64 50 80 00       	push   $0x805064
  800345:	6a 3a                	push   $0x3a
  800347:	68 a1 4f 80 00       	push   $0x804fa1
  80034c:	e8 62 12 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 3f 2a 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  8003a6:	68 fc 4f 80 00       	push   $0x804ffc
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 a1 4f 80 00       	push   $0x804fa1
  8003b2:	e8 fc 11 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 d9 29 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  8003dd:	68 64 50 80 00       	push   $0x805064
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 a1 4f 80 00       	push   $0x804fa1
  8003e9:	e8 c5 11 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 a2 29 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  80044a:	68 fc 4f 80 00       	push   $0x804ffc
  80044f:	6a 47                	push   $0x47
  800451:	68 a1 4f 80 00       	push   $0x804fa1
  800456:	e8 58 11 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 35 29 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  80047e:	68 64 50 80 00       	push   $0x805064
  800483:	6a 48                	push   $0x48
  800485:	68 a1 4f 80 00       	push   $0x804fa1
  80048a:	e8 24 11 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 01 29 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  8004fa:	68 fc 4f 80 00       	push   $0x804ffc
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 a1 4f 80 00       	push   $0x804fa1
  800506:	e8 a8 10 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 85 28 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  800535:	68 64 50 80 00       	push   $0x805064
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 a1 4f 80 00       	push   $0x804fa1
  800541:	e8 6d 10 00 00       	call   8015b3 <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 ff 27 00 00       	call   802d4a <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 10 28 00 00       	call   802d63 <sys_calculate_modified_frames>
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
  80060f:	e8 36 27 00 00       	call   802d4a <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 48 27 00 00       	call   802d63 <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 94 50 80 00       	push   $0x805094
  80062e:	6a 67                	push   $0x67
  800630:	68 a1 4f 80 00       	push   $0x804fa1
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
  8006d8:	68 d8 50 80 00       	push   $0x8050d8
  8006dd:	6a 73                	push   $0x73
  8006df:	68 a1 4f 80 00       	push   $0x804fa1
  8006e4:	e8 ca 0e 00 00       	call   8015b3 <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e9:	e8 5c 26 00 00       	call   802d4a <sys_calculate_free_frames>
  8006ee:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006f1:	e8 6d 26 00 00       	call   802d63 <sys_calculate_modified_frames>
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
  8007f2:	e8 53 25 00 00       	call   802d4a <sys_calculate_free_frames>
  8007f7:	29 c3                	sub    %eax,%ebx
  8007f9:	89 d8                	mov    %ebx,%eax
  8007fb:	83 f8 04             	cmp    $0x4,%eax
  8007fe:	74 17                	je     800817 <_main+0x7df>
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	68 94 50 80 00       	push   $0x805094
  800808:	68 8e 00 00 00       	push   $0x8e
  80080d:	68 a1 4f 80 00       	push   $0x804fa1
  800812:	e8 9c 0d 00 00       	call   8015b3 <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800817:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  80081a:	e8 44 25 00 00       	call   802d63 <sys_calculate_modified_frames>
  80081f:	29 c3                	sub    %eax,%ebx
  800821:	89 d8                	mov    %ebx,%eax
  800823:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800826:	74 17                	je     80083f <_main+0x807>
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 94 50 80 00       	push   $0x805094
  800830:	68 8f 00 00 00       	push   $0x8f
  800835:	68 a1 4f 80 00       	push   $0x804fa1
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
  8008df:	68 d8 50 80 00       	push   $0x8050d8
  8008e4:	68 9b 00 00 00       	push   $0x9b
  8008e9:	68 a1 4f 80 00       	push   $0x804fa1
  8008ee:	e8 c0 0c 00 00       	call   8015b3 <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008f3:	e8 52 24 00 00       	call   802d4a <sys_calculate_free_frames>
  8008f8:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008fb:	e8 63 24 00 00       	call   802d63 <sys_calculate_modified_frames>
  800900:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800903:	e8 8d 24 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
  800908:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  80090b:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800911:	83 ec 0c             	sub    $0xc,%esp
  800914:	50                   	push   %eax
  800915:	e8 25 1f 00 00       	call   80283f <free>
  80091a:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80091d:	e8 73 24 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  800945:	68 f8 50 80 00       	push   $0x8050f8
  80094a:	68 a5 00 00 00       	push   $0xa5
  80094f:	68 a1 4f 80 00       	push   $0x804fa1
  800954:	e8 5a 0c 00 00       	call   8015b3 <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  800959:	e8 ec 23 00 00       	call   802d4a <sys_calculate_free_frames>
  80095e:	89 c2                	mov    %eax,%edx
  800960:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800963:	29 c2                	sub    %eax,%edx
  800965:	89 d0                	mov    %edx,%eax
  800967:	83 f8 07             	cmp    $0x7,%eax
  80096a:	74 17                	je     800983 <_main+0x94b>
  80096c:	83 ec 04             	sub    $0x4,%esp
  80096f:	68 34 51 80 00       	push   $0x805134
  800974:	68 a7 00 00 00       	push   $0xa7
  800979:	68 a1 4f 80 00       	push   $0x804fa1
  80097e:	e8 30 0c 00 00       	call   8015b3 <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800983:	e8 db 23 00 00       	call   802d63 <sys_calculate_modified_frames>
  800988:	89 c2                	mov    %eax,%edx
  80098a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80098d:	29 c2                	sub    %eax,%edx
  80098f:	89 d0                	mov    %edx,%eax
  800991:	83 f8 02             	cmp    $0x2,%eax
  800994:	74 17                	je     8009ad <_main+0x975>
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	68 88 51 80 00       	push   $0x805188
  80099e:	68 a8 00 00 00       	push   $0xa8
  8009a3:	68 a1 4f 80 00       	push   $0x804fa1
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
  800a1c:	68 c0 51 80 00       	push   $0x8051c0
  800a21:	68 b0 00 00 00       	push   $0xb0
  800a26:	68 a1 4f 80 00       	push   $0x804fa1
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
  800a56:	e8 ef 22 00 00       	call   802d4a <sys_calculate_free_frames>
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
  800aa3:	e8 a2 22 00 00       	call   802d4a <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 02             	cmp    $0x2,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 94 50 80 00       	push   $0x805094
  800ab9:	68 bc 00 00 00       	push   $0xbc
  800abe:	68 a1 4f 80 00       	push   $0x804fa1
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
  800ba1:	68 d8 50 80 00       	push   $0x8050d8
  800ba6:	68 c5 00 00 00       	push   $0xc5
  800bab:	68 a1 4f 80 00       	push   $0x804fa1
  800bb0:	e8 fe 09 00 00       	call   8015b3 <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bb5:	e8 db 21 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  800c05:	68 fc 4f 80 00       	push   $0x804ffc
  800c0a:	68 ca 00 00 00       	push   $0xca
  800c0f:	68 a1 4f 80 00       	push   $0x804fa1
  800c14:	e8 9a 09 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c19:	e8 77 21 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
  800c1e:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c21:	83 f8 01             	cmp    $0x1,%eax
  800c24:	74 17                	je     800c3d <_main+0xc05>
  800c26:	83 ec 04             	sub    $0x4,%esp
  800c29:	68 64 50 80 00       	push   $0x805064
  800c2e:	68 cb 00 00 00       	push   $0xcb
  800c33:	68 a1 4f 80 00       	push   $0x804fa1
  800c38:	e8 76 09 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c3d:	e8 08 21 00 00       	call   802d4a <sys_calculate_free_frames>
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
  800c88:	e8 bd 20 00 00       	call   802d4a <sys_calculate_free_frames>
  800c8d:	29 c3                	sub    %eax,%ebx
  800c8f:	89 d8                	mov    %ebx,%eax
  800c91:	83 f8 02             	cmp    $0x2,%eax
  800c94:	74 17                	je     800cad <_main+0xc75>
  800c96:	83 ec 04             	sub    $0x4,%esp
  800c99:	68 94 50 80 00       	push   $0x805094
  800c9e:	68 d2 00 00 00       	push   $0xd2
  800ca3:	68 a1 4f 80 00       	push   $0x804fa1
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
  800d89:	68 d8 50 80 00       	push   $0x8050d8
  800d8e:	68 db 00 00 00       	push   $0xdb
  800d93:	68 a1 4f 80 00       	push   $0x804fa1
  800d98:	e8 16 08 00 00       	call   8015b3 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d9d:	e8 a8 1f 00 00       	call   802d4a <sys_calculate_free_frames>
  800da2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800da5:	e8 eb 1f 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  800e09:	68 fc 4f 80 00       	push   $0x804ffc
  800e0e:	68 e1 00 00 00       	push   $0xe1
  800e13:	68 a1 4f 80 00       	push   $0x804fa1
  800e18:	e8 96 07 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e1d:	e8 73 1f 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
  800e22:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e25:	83 f8 01             	cmp    $0x1,%eax
  800e28:	74 17                	je     800e41 <_main+0xe09>
  800e2a:	83 ec 04             	sub    $0x4,%esp
  800e2d:	68 64 50 80 00       	push   $0x805064
  800e32:	68 e2 00 00 00       	push   $0xe2
  800e37:	68 a1 4f 80 00       	push   $0x804fa1
  800e3c:	e8 72 07 00 00       	call   8015b3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e41:	e8 4f 1f 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  800ead:	68 fc 4f 80 00       	push   $0x804ffc
  800eb2:	68 e8 00 00 00       	push   $0xe8
  800eb7:	68 a1 4f 80 00       	push   $0x804fa1
  800ebc:	e8 f2 06 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ec1:	e8 cf 1e 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
  800ec6:	2b 45 90             	sub    -0x70(%ebp),%eax
  800ec9:	83 f8 02             	cmp    $0x2,%eax
  800ecc:	74 17                	je     800ee5 <_main+0xead>
  800ece:	83 ec 04             	sub    $0x4,%esp
  800ed1:	68 64 50 80 00       	push   $0x805064
  800ed6:	68 e9 00 00 00       	push   $0xe9
  800edb:	68 a1 4f 80 00       	push   $0x804fa1
  800ee0:	e8 ce 06 00 00       	call   8015b3 <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800ee5:	e8 60 1e 00 00       	call   802d4a <sys_calculate_free_frames>
  800eea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800eed:	e8 a3 1e 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  800f58:	68 fc 4f 80 00       	push   $0x804ffc
  800f5d:	68 f0 00 00 00       	push   $0xf0
  800f62:	68 a1 4f 80 00       	push   $0x804fa1
  800f67:	e8 47 06 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f6c:	e8 24 1e 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  800f92:	68 64 50 80 00       	push   $0x805064
  800f97:	68 f1 00 00 00       	push   $0xf1
  800f9c:	68 a1 4f 80 00       	push   $0x804fa1
  800fa1:	e8 0d 06 00 00       	call   8015b3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800fa6:	e8 ea 1d 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  801021:	68 fc 4f 80 00       	push   $0x804ffc
  801026:	68 f7 00 00 00       	push   $0xf7
  80102b:	68 a1 4f 80 00       	push   $0x804fa1
  801030:	e8 7e 05 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  801035:	e8 5b 1d 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  80105d:	68 64 50 80 00       	push   $0x805064
  801062:	68 f8 00 00 00       	push   $0xf8
  801067:	68 a1 4f 80 00       	push   $0x804fa1
  80106c:	e8 42 05 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801071:	e8 d4 1c 00 00       	call   802d4a <sys_calculate_free_frames>
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
  8010e2:	e8 63 1c 00 00       	call   802d4a <sys_calculate_free_frames>
  8010e7:	29 c3                	sub    %eax,%ebx
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	83 f8 05             	cmp    $0x5,%eax
  8010ee:	74 17                	je     801107 <_main+0x10cf>
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 94 50 80 00       	push   $0x805094
  8010f8:	68 00 01 00 00       	push   $0x100
  8010fd:	68 a1 4f 80 00       	push   $0x804fa1
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
  80123b:	68 d8 50 80 00       	push   $0x8050d8
  801240:	68 0b 01 00 00       	push   $0x10b
  801245:	68 a1 4f 80 00       	push   $0x804fa1
  80124a:	e8 64 03 00 00       	call   8015b3 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80124f:	e8 41 1b 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
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
  8012cd:	68 fc 4f 80 00       	push   $0x804ffc
  8012d2:	68 10 01 00 00       	push   $0x110
  8012d7:	68 a1 4f 80 00       	push   $0x804fa1
  8012dc:	e8 d2 02 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012e1:	e8 af 1a 00 00       	call   802d95 <sys_pf_calculate_allocated_pages>
  8012e6:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012e9:	83 f8 04             	cmp    $0x4,%eax
  8012ec:	74 17                	je     801305 <_main+0x12cd>
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 64 50 80 00       	push   $0x805064
  8012f6:	68 11 01 00 00       	push   $0x111
  8012fb:	68 a1 4f 80 00       	push   $0x804fa1
  801300:	e8 ae 02 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801305:	e8 40 1a 00 00       	call   802d4a <sys_calculate_free_frames>
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
  801359:	e8 ec 19 00 00       	call   802d4a <sys_calculate_free_frames>
  80135e:	29 c3                	sub    %eax,%ebx
  801360:	89 d8                	mov    %ebx,%eax
  801362:	83 f8 02             	cmp    $0x2,%eax
  801365:	74 17                	je     80137e <_main+0x1346>
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	68 94 50 80 00       	push   $0x805094
  80136f:	68 18 01 00 00       	push   $0x118
  801374:	68 a1 4f 80 00       	push   $0x804fa1
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
  801457:	68 d8 50 80 00       	push   $0x8050d8
  80145c:	68 21 01 00 00       	push   $0x121
  801461:	68 a1 4f 80 00       	push   $0x804fa1
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
  80147a:	e8 94 1a 00 00       	call   802f13 <sys_getenvindex>
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
  8014e8:	e8 aa 17 00 00       	call   802c97 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8014ed:	83 ec 0c             	sub    $0xc,%esp
  8014f0:	68 fc 51 80 00       	push   $0x8051fc
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
  801518:	68 24 52 80 00       	push   $0x805224
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
  801549:	68 4c 52 80 00       	push   $0x80524c
  80154e:	e8 1d 03 00 00       	call   801870 <cprintf>
  801553:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801556:	a1 20 60 80 00       	mov    0x806020,%eax
  80155b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	50                   	push   %eax
  801565:	68 a4 52 80 00       	push   $0x8052a4
  80156a:	e8 01 03 00 00       	call   801870 <cprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 fc 51 80 00       	push   $0x8051fc
  80157a:	e8 f1 02 00 00       	call   801870 <cprintf>
  80157f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801582:	e8 2a 17 00 00       	call   802cb1 <sys_unlock_cons>
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
  80159a:	e8 40 19 00 00       	call   802edf <sys_destroy_env>
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
  8015ab:	e8 95 19 00 00       	call   802f45 <sys_exit_env>
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
  8015c2:	a1 50 60 80 00       	mov    0x806050,%eax
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	74 16                	je     8015e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015cb:	a1 50 60 80 00       	mov    0x806050,%eax
  8015d0:	83 ec 08             	sub    $0x8,%esp
  8015d3:	50                   	push   %eax
  8015d4:	68 b8 52 80 00       	push   $0x8052b8
  8015d9:	e8 92 02 00 00       	call   801870 <cprintf>
  8015de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015e1:	a1 00 60 80 00       	mov    0x806000,%eax
  8015e6:	ff 75 0c             	pushl  0xc(%ebp)
  8015e9:	ff 75 08             	pushl  0x8(%ebp)
  8015ec:	50                   	push   %eax
  8015ed:	68 bd 52 80 00       	push   $0x8052bd
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
  801611:	68 d9 52 80 00       	push   $0x8052d9
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
  801640:	68 dc 52 80 00       	push   $0x8052dc
  801645:	6a 26                	push   $0x26
  801647:	68 28 53 80 00       	push   $0x805328
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
  801715:	68 34 53 80 00       	push   $0x805334
  80171a:	6a 3a                	push   $0x3a
  80171c:	68 28 53 80 00       	push   $0x805328
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
  801788:	68 88 53 80 00       	push   $0x805388
  80178d:	6a 44                	push   $0x44
  80178f:	68 28 53 80 00       	push   $0x805328
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
  8017c7:	a0 2c 60 80 00       	mov    0x80602c,%al
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
  8017e2:	e8 6e 14 00 00       	call   802c55 <sys_cputs>
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
  80183c:	a0 2c 60 80 00       	mov    0x80602c,%al
  801841:	0f b6 c0             	movzbl %al,%eax
  801844:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	50                   	push   %eax
  80184e:	52                   	push   %edx
  80184f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801855:	83 c0 08             	add    $0x8,%eax
  801858:	50                   	push   %eax
  801859:	e8 f7 13 00 00       	call   802c55 <sys_cputs>
  80185e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801861:	c6 05 2c 60 80 00 00 	movb   $0x0,0x80602c
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
  801876:	c6 05 2c 60 80 00 01 	movb   $0x1,0x80602c
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
  8018a3:	e8 ef 13 00 00       	call   802c97 <sys_lock_cons>
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
  8018c3:	e8 e9 13 00 00       	call   802cb1 <sys_unlock_cons>
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
  80190d:	e8 da 33 00 00       	call   804cec <__udivdi3>
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
  80195d:	e8 9a 34 00 00       	call   804dfc <__umoddi3>
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	05 f4 55 80 00       	add    $0x8055f4,%eax
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
  801ab8:	8b 04 85 18 56 80 00 	mov    0x805618(,%eax,4),%eax
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
  801b99:	8b 34 9d 60 54 80 00 	mov    0x805460(,%ebx,4),%esi
  801ba0:	85 f6                	test   %esi,%esi
  801ba2:	75 19                	jne    801bbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801ba4:	53                   	push   %ebx
  801ba5:	68 05 56 80 00       	push   $0x805605
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
  801bbe:	68 0e 56 80 00       	push   $0x80560e
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
  801beb:	be 11 56 80 00       	mov    $0x805611,%esi
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
  801de3:	c6 05 2c 60 80 00 00 	movb   $0x0,0x80602c
			break;
  801dea:	eb 2c                	jmp    801e18 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801dec:	c6 05 2c 60 80 00 01 	movb   $0x1,0x80602c
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
  8025f6:	68 88 57 80 00       	push   $0x805788
  8025fb:	68 3f 01 00 00       	push   $0x13f
  802600:	68 aa 57 80 00       	push   $0x8057aa
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
  802616:	e8 e5 0b 00 00       	call   803200 <sys_sbrk>
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
  802691:	e8 ee 09 00 00       	call   803084 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802696:	85 c0                	test   %eax,%eax
  802698:	74 16                	je     8026b0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80269a:	83 ec 0c             	sub    $0xc,%esp
  80269d:	ff 75 08             	pushl  0x8(%ebp)
  8026a0:	e8 2e 0f 00 00       	call   8035d3 <alloc_block_FF>
  8026a5:	83 c4 10             	add    $0x10,%esp
  8026a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ab:	e9 8a 01 00 00       	jmp    80283a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8026b0:	e8 00 0a 00 00       	call   8030b5 <sys_isUHeapPlacementStrategyBESTFIT>
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	0f 84 7d 01 00 00    	je     80283a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	ff 75 08             	pushl  0x8(%ebp)
  8026c3:	e8 c7 13 00 00       	call   803a8f <alloc_block_BF>
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
		//cprintf("52\n");
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
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8026fc:	a1 20 60 80 00       	mov    0x806020,%eax
  802701:	8b 40 78             	mov    0x78(%eax),%eax
  802704:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802707:	29 c2                	sub    %eax,%edx
  802709:	89 d0                	mov    %edx,%eax
  80270b:	2d 00 10 00 00       	sub    $0x1000,%eax
  802710:	c1 e8 0c             	shr    $0xc,%eax
  802713:	8b 04 85 60 a0 08 01 	mov    0x108a060(,%eax,4),%eax
  80271a:	85 c0                	test   %eax,%eax
  80271c:	0f 85 ab 00 00 00    	jne    8027cd <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  802722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802725:	05 00 10 00 00       	add    $0x1000,%eax
  80272a:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80272d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
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
  802760:	8b 04 85 60 a0 08 01 	mov    0x108a060(,%eax,4),%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	74 08                	je     802773 <malloc+0x153>
					{
						//cprintf("71\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
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
  8027b7:	c7 04 85 60 a0 08 01 	movl   $0x1,0x108a060(,%eax,4)
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
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8027cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027d1:	75 16                	jne    8027e9 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8027d3:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8027da:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8027e1:	0f 86 15 ff ff ff    	jbe    8026fc <malloc+0xdc>
  8027e7:	eb 01                	jmp    8027ea <malloc+0x1ca>
				}
				//cprintf("79\n");

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
  802819:	89 04 95 60 a0 10 01 	mov    %eax,0x110a060(,%edx,4)
		sys_allocate_user_mem(i, size);
  802820:	83 ec 08             	sub    $0x8,%esp
  802823:	ff 75 08             	pushl  0x8(%ebp)
  802826:	ff 75 f0             	pushl  -0x10(%ebp)
  802829:	e8 09 0a 00 00       	call   803237 <sys_allocate_user_mem>
  80282e:	83 c4 10             	add    $0x10,%esp
  802831:	eb 07                	jmp    80283a <malloc+0x21a>
		//cprintf("91\n");
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
  802871:	e8 dd 09 00 00       	call   803253 <get_block_size>
  802876:	83 c4 10             	add    $0x10,%esp
  802879:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80287c:	83 ec 0c             	sub    $0xc,%esp
  80287f:	ff 75 08             	pushl  0x8(%ebp)
  802882:	e8 10 1c 00 00       	call   804497 <free_block>
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
  8028bc:	8b 04 85 60 a0 10 01 	mov    0x110a060(,%eax,4),%eax
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
  8028f9:	c7 04 85 60 a0 08 01 	movl   $0x0,0x108a060(,%eax,4)
  802900:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  802904:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	83 ec 08             	sub    $0x8,%esp
  80290d:	52                   	push   %edx
  80290e:	50                   	push   %eax
  80290f:	e8 07 09 00 00       	call   80321b <sys_free_user_mem>
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
  802927:	68 b8 57 80 00       	push   $0x8057b8
  80292c:	68 88 00 00 00       	push   $0x88
  802931:	68 e2 57 80 00       	push   $0x8057e2
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
  802955:	e9 ec 00 00 00       	jmp    802a46 <smalloc+0x108>
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
  802986:	75 0a                	jne    802992 <smalloc+0x54>
  802988:	b8 00 00 00 00       	mov    $0x0,%eax
  80298d:	e9 b4 00 00 00       	jmp    802a46 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  802992:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802996:	ff 75 ec             	pushl  -0x14(%ebp)
  802999:	50                   	push   %eax
  80299a:	ff 75 0c             	pushl  0xc(%ebp)
  80299d:	ff 75 08             	pushl  0x8(%ebp)
  8029a0:	e8 7d 04 00 00       	call   802e22 <sys_createSharedObject>
  8029a5:	83 c4 10             	add    $0x10,%esp
  8029a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8029ab:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8029af:	74 06                	je     8029b7 <smalloc+0x79>
  8029b1:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8029b5:	75 0a                	jne    8029c1 <smalloc+0x83>
  8029b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bc:	e9 85 00 00 00       	jmp    802a46 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  8029c1:	83 ec 08             	sub    $0x8,%esp
  8029c4:	ff 75 ec             	pushl  -0x14(%ebp)
  8029c7:	68 ee 57 80 00       	push   $0x8057ee
  8029cc:	e8 9f ee ff ff       	call   801870 <cprintf>
  8029d1:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8029d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029d7:	a1 20 60 80 00       	mov    0x806020,%eax
  8029dc:	8b 40 78             	mov    0x78(%eax),%eax
  8029df:	29 c2                	sub    %eax,%edx
  8029e1:	89 d0                	mov    %edx,%eax
  8029e3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8029e8:	c1 e8 0c             	shr    $0xc,%eax
  8029eb:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8029f1:	42                   	inc    %edx
  8029f2:	89 15 24 60 80 00    	mov    %edx,0x806024
  8029f8:	8b 15 24 60 80 00    	mov    0x806024,%edx
  8029fe:	89 14 85 60 a0 00 01 	mov    %edx,0x100a060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  802a05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a08:	a1 20 60 80 00       	mov    0x806020,%eax
  802a0d:	8b 40 78             	mov    0x78(%eax),%eax
  802a10:	29 c2                	sub    %eax,%edx
  802a12:	89 d0                	mov    %edx,%eax
  802a14:	2d 00 10 00 00       	sub    $0x1000,%eax
  802a19:	c1 e8 0c             	shr    $0xc,%eax
  802a1c:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  802a23:	a1 20 60 80 00       	mov    0x806020,%eax
  802a28:	8b 50 10             	mov    0x10(%eax),%edx
  802a2b:	89 c8                	mov    %ecx,%eax
  802a2d:	c1 e0 02             	shl    $0x2,%eax
  802a30:	89 c1                	mov    %eax,%ecx
  802a32:	c1 e1 09             	shl    $0x9,%ecx
  802a35:	01 c8                	add    %ecx,%eax
  802a37:	01 c2                	add    %eax,%edx
  802a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3c:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  802a43:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  802a46:	c9                   	leave  
  802a47:	c3                   	ret    

00802a48 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802a48:	55                   	push   %ebp
  802a49:	89 e5                	mov    %esp,%ebp
  802a4b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802a4e:	83 ec 08             	sub    $0x8,%esp
  802a51:	ff 75 0c             	pushl  0xc(%ebp)
  802a54:	ff 75 08             	pushl  0x8(%ebp)
  802a57:	e8 f0 03 00 00       	call   802e4c <sys_getSizeOfSharedObject>
  802a5c:	83 c4 10             	add    $0x10,%esp
  802a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  802a62:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802a66:	75 0a                	jne    802a72 <sget+0x2a>
  802a68:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6d:	e9 e7 00 00 00       	jmp    802b59 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a78:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a85:	39 d0                	cmp    %edx,%eax
  802a87:	73 02                	jae    802a8b <sget+0x43>
  802a89:	89 d0                	mov    %edx,%eax
  802a8b:	83 ec 0c             	sub    $0xc,%esp
  802a8e:	50                   	push   %eax
  802a8f:	e8 8c fb ff ff       	call   802620 <malloc>
  802a94:	83 c4 10             	add    $0x10,%esp
  802a97:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802a9a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a9e:	75 0a                	jne    802aaa <sget+0x62>
  802aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa5:	e9 af 00 00 00       	jmp    802b59 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802aaa:	83 ec 04             	sub    $0x4,%esp
  802aad:	ff 75 e8             	pushl  -0x18(%ebp)
  802ab0:	ff 75 0c             	pushl  0xc(%ebp)
  802ab3:	ff 75 08             	pushl  0x8(%ebp)
  802ab6:	e8 ae 03 00 00       	call   802e69 <sys_getSharedObject>
  802abb:	83 c4 10             	add    $0x10,%esp
  802abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  802ac1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ac4:	a1 20 60 80 00       	mov    0x806020,%eax
  802ac9:	8b 40 78             	mov    0x78(%eax),%eax
  802acc:	29 c2                	sub    %eax,%edx
  802ace:	89 d0                	mov    %edx,%eax
  802ad0:	2d 00 10 00 00       	sub    $0x1000,%eax
  802ad5:	c1 e8 0c             	shr    $0xc,%eax
  802ad8:	8b 15 24 60 80 00    	mov    0x806024,%edx
  802ade:	42                   	inc    %edx
  802adf:	89 15 24 60 80 00    	mov    %edx,0x806024
  802ae5:	8b 15 24 60 80 00    	mov    0x806024,%edx
  802aeb:	89 14 85 60 a0 00 01 	mov    %edx,0x100a060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  802af2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802af5:	a1 20 60 80 00       	mov    0x806020,%eax
  802afa:	8b 40 78             	mov    0x78(%eax),%eax
  802afd:	29 c2                	sub    %eax,%edx
  802aff:	89 d0                	mov    %edx,%eax
  802b01:	2d 00 10 00 00       	sub    $0x1000,%eax
  802b06:	c1 e8 0c             	shr    $0xc,%eax
  802b09:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  802b10:	a1 20 60 80 00       	mov    0x806020,%eax
  802b15:	8b 50 10             	mov    0x10(%eax),%edx
  802b18:	89 c8                	mov    %ecx,%eax
  802b1a:	c1 e0 02             	shl    $0x2,%eax
  802b1d:	89 c1                	mov    %eax,%ecx
  802b1f:	c1 e1 09             	shl    $0x9,%ecx
  802b22:	01 c8                	add    %ecx,%eax
  802b24:	01 c2                	add    %eax,%edx
  802b26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b29:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  802b30:	a1 20 60 80 00       	mov    0x806020,%eax
  802b35:	8b 40 10             	mov    0x10(%eax),%eax
  802b38:	83 ec 08             	sub    $0x8,%esp
  802b3b:	50                   	push   %eax
  802b3c:	68 fd 57 80 00       	push   $0x8057fd
  802b41:	e8 2a ed ff ff       	call   801870 <cprintf>
  802b46:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802b49:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802b4d:	75 07                	jne    802b56 <sget+0x10e>
  802b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b54:	eb 03                	jmp    802b59 <sget+0x111>
	return ptr;
  802b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802b59:	c9                   	leave  
  802b5a:	c3                   	ret    

00802b5b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802b5b:	55                   	push   %ebp
  802b5c:	89 e5                	mov    %esp,%ebp
  802b5e:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  802b61:	8b 55 08             	mov    0x8(%ebp),%edx
  802b64:	a1 20 60 80 00       	mov    0x806020,%eax
  802b69:	8b 40 78             	mov    0x78(%eax),%eax
  802b6c:	29 c2                	sub    %eax,%edx
  802b6e:	89 d0                	mov    %edx,%eax
  802b70:	2d 00 10 00 00       	sub    $0x1000,%eax
  802b75:	c1 e8 0c             	shr    $0xc,%eax
  802b78:	8b 0c 85 60 a0 00 01 	mov    0x100a060(,%eax,4),%ecx
  802b7f:	a1 20 60 80 00       	mov    0x806020,%eax
  802b84:	8b 50 10             	mov    0x10(%eax),%edx
  802b87:	89 c8                	mov    %ecx,%eax
  802b89:	c1 e0 02             	shl    $0x2,%eax
  802b8c:	89 c1                	mov    %eax,%ecx
  802b8e:	c1 e1 09             	shl    $0x9,%ecx
  802b91:	01 c8                	add    %ecx,%eax
  802b93:	01 d0                	add    %edx,%eax
  802b95:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802b9f:	83 ec 08             	sub    $0x8,%esp
  802ba2:	ff 75 08             	pushl  0x8(%ebp)
  802ba5:	ff 75 f4             	pushl  -0xc(%ebp)
  802ba8:	e8 db 02 00 00       	call   802e88 <sys_freeSharedObject>
  802bad:	83 c4 10             	add    $0x10,%esp
  802bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802bb3:	90                   	nop
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
  802bb9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802bbc:	83 ec 04             	sub    $0x4,%esp
  802bbf:	68 0c 58 80 00       	push   $0x80580c
  802bc4:	68 e5 00 00 00       	push   $0xe5
  802bc9:	68 e2 57 80 00       	push   $0x8057e2
  802bce:	e8 e0 e9 ff ff       	call   8015b3 <_panic>

00802bd3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802bd3:	55                   	push   %ebp
  802bd4:	89 e5                	mov    %esp,%ebp
  802bd6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802bd9:	83 ec 04             	sub    $0x4,%esp
  802bdc:	68 32 58 80 00       	push   $0x805832
  802be1:	68 f1 00 00 00       	push   $0xf1
  802be6:	68 e2 57 80 00       	push   $0x8057e2
  802beb:	e8 c3 e9 ff ff       	call   8015b3 <_panic>

00802bf0 <shrink>:

}
void shrink(uint32 newSize)
{
  802bf0:	55                   	push   %ebp
  802bf1:	89 e5                	mov    %esp,%ebp
  802bf3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802bf6:	83 ec 04             	sub    $0x4,%esp
  802bf9:	68 32 58 80 00       	push   $0x805832
  802bfe:	68 f6 00 00 00       	push   $0xf6
  802c03:	68 e2 57 80 00       	push   $0x8057e2
  802c08:	e8 a6 e9 ff ff       	call   8015b3 <_panic>

00802c0d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802c0d:	55                   	push   %ebp
  802c0e:	89 e5                	mov    %esp,%ebp
  802c10:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802c13:	83 ec 04             	sub    $0x4,%esp
  802c16:	68 32 58 80 00       	push   $0x805832
  802c1b:	68 fb 00 00 00       	push   $0xfb
  802c20:	68 e2 57 80 00       	push   $0x8057e2
  802c25:	e8 89 e9 ff ff       	call   8015b3 <_panic>

00802c2a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802c2a:	55                   	push   %ebp
  802c2b:	89 e5                	mov    %esp,%ebp
  802c2d:	57                   	push   %edi
  802c2e:	56                   	push   %esi
  802c2f:	53                   	push   %ebx
  802c30:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c3c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c3f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802c42:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802c45:	cd 30                	int    $0x30
  802c47:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802c4d:	83 c4 10             	add    $0x10,%esp
  802c50:	5b                   	pop    %ebx
  802c51:	5e                   	pop    %esi
  802c52:	5f                   	pop    %edi
  802c53:	5d                   	pop    %ebp
  802c54:	c3                   	ret    

00802c55 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802c55:	55                   	push   %ebp
  802c56:	89 e5                	mov    %esp,%ebp
  802c58:	83 ec 04             	sub    $0x4,%esp
  802c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  802c5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802c61:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	6a 00                	push   $0x0
  802c6a:	6a 00                	push   $0x0
  802c6c:	52                   	push   %edx
  802c6d:	ff 75 0c             	pushl  0xc(%ebp)
  802c70:	50                   	push   %eax
  802c71:	6a 00                	push   $0x0
  802c73:	e8 b2 ff ff ff       	call   802c2a <syscall>
  802c78:	83 c4 18             	add    $0x18,%esp
}
  802c7b:	90                   	nop
  802c7c:	c9                   	leave  
  802c7d:	c3                   	ret    

00802c7e <sys_cgetc>:

int
sys_cgetc(void)
{
  802c7e:	55                   	push   %ebp
  802c7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802c81:	6a 00                	push   $0x0
  802c83:	6a 00                	push   $0x0
  802c85:	6a 00                	push   $0x0
  802c87:	6a 00                	push   $0x0
  802c89:	6a 00                	push   $0x0
  802c8b:	6a 02                	push   $0x2
  802c8d:	e8 98 ff ff ff       	call   802c2a <syscall>
  802c92:	83 c4 18             	add    $0x18,%esp
}
  802c95:	c9                   	leave  
  802c96:	c3                   	ret    

00802c97 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802c97:	55                   	push   %ebp
  802c98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802c9a:	6a 00                	push   $0x0
  802c9c:	6a 00                	push   $0x0
  802c9e:	6a 00                	push   $0x0
  802ca0:	6a 00                	push   $0x0
  802ca2:	6a 00                	push   $0x0
  802ca4:	6a 03                	push   $0x3
  802ca6:	e8 7f ff ff ff       	call   802c2a <syscall>
  802cab:	83 c4 18             	add    $0x18,%esp
}
  802cae:	90                   	nop
  802caf:	c9                   	leave  
  802cb0:	c3                   	ret    

00802cb1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802cb1:	55                   	push   %ebp
  802cb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802cb4:	6a 00                	push   $0x0
  802cb6:	6a 00                	push   $0x0
  802cb8:	6a 00                	push   $0x0
  802cba:	6a 00                	push   $0x0
  802cbc:	6a 00                	push   $0x0
  802cbe:	6a 04                	push   $0x4
  802cc0:	e8 65 ff ff ff       	call   802c2a <syscall>
  802cc5:	83 c4 18             	add    $0x18,%esp
}
  802cc8:	90                   	nop
  802cc9:	c9                   	leave  
  802cca:	c3                   	ret    

00802ccb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802ccb:	55                   	push   %ebp
  802ccc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	6a 00                	push   $0x0
  802cd6:	6a 00                	push   $0x0
  802cd8:	6a 00                	push   $0x0
  802cda:	52                   	push   %edx
  802cdb:	50                   	push   %eax
  802cdc:	6a 08                	push   $0x8
  802cde:	e8 47 ff ff ff       	call   802c2a <syscall>
  802ce3:	83 c4 18             	add    $0x18,%esp
}
  802ce6:	c9                   	leave  
  802ce7:	c3                   	ret    

00802ce8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
  802ceb:	56                   	push   %esi
  802cec:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802ced:	8b 75 18             	mov    0x18(%ebp),%esi
  802cf0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802cf3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfc:	56                   	push   %esi
  802cfd:	53                   	push   %ebx
  802cfe:	51                   	push   %ecx
  802cff:	52                   	push   %edx
  802d00:	50                   	push   %eax
  802d01:	6a 09                	push   $0x9
  802d03:	e8 22 ff ff ff       	call   802c2a <syscall>
  802d08:	83 c4 18             	add    $0x18,%esp
}
  802d0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d0e:	5b                   	pop    %ebx
  802d0f:	5e                   	pop    %esi
  802d10:	5d                   	pop    %ebp
  802d11:	c3                   	ret    

00802d12 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802d12:	55                   	push   %ebp
  802d13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802d15:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	6a 00                	push   $0x0
  802d1d:	6a 00                	push   $0x0
  802d1f:	6a 00                	push   $0x0
  802d21:	52                   	push   %edx
  802d22:	50                   	push   %eax
  802d23:	6a 0a                	push   $0xa
  802d25:	e8 00 ff ff ff       	call   802c2a <syscall>
  802d2a:	83 c4 18             	add    $0x18,%esp
}
  802d2d:	c9                   	leave  
  802d2e:	c3                   	ret    

00802d2f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802d2f:	55                   	push   %ebp
  802d30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802d32:	6a 00                	push   $0x0
  802d34:	6a 00                	push   $0x0
  802d36:	6a 00                	push   $0x0
  802d38:	ff 75 0c             	pushl  0xc(%ebp)
  802d3b:	ff 75 08             	pushl  0x8(%ebp)
  802d3e:	6a 0b                	push   $0xb
  802d40:	e8 e5 fe ff ff       	call   802c2a <syscall>
  802d45:	83 c4 18             	add    $0x18,%esp
}
  802d48:	c9                   	leave  
  802d49:	c3                   	ret    

00802d4a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802d4a:	55                   	push   %ebp
  802d4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802d4d:	6a 00                	push   $0x0
  802d4f:	6a 00                	push   $0x0
  802d51:	6a 00                	push   $0x0
  802d53:	6a 00                	push   $0x0
  802d55:	6a 00                	push   $0x0
  802d57:	6a 0c                	push   $0xc
  802d59:	e8 cc fe ff ff       	call   802c2a <syscall>
  802d5e:	83 c4 18             	add    $0x18,%esp
}
  802d61:	c9                   	leave  
  802d62:	c3                   	ret    

00802d63 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802d63:	55                   	push   %ebp
  802d64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802d66:	6a 00                	push   $0x0
  802d68:	6a 00                	push   $0x0
  802d6a:	6a 00                	push   $0x0
  802d6c:	6a 00                	push   $0x0
  802d6e:	6a 00                	push   $0x0
  802d70:	6a 0d                	push   $0xd
  802d72:	e8 b3 fe ff ff       	call   802c2a <syscall>
  802d77:	83 c4 18             	add    $0x18,%esp
}
  802d7a:	c9                   	leave  
  802d7b:	c3                   	ret    

00802d7c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802d7c:	55                   	push   %ebp
  802d7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802d7f:	6a 00                	push   $0x0
  802d81:	6a 00                	push   $0x0
  802d83:	6a 00                	push   $0x0
  802d85:	6a 00                	push   $0x0
  802d87:	6a 00                	push   $0x0
  802d89:	6a 0e                	push   $0xe
  802d8b:	e8 9a fe ff ff       	call   802c2a <syscall>
  802d90:	83 c4 18             	add    $0x18,%esp
}
  802d93:	c9                   	leave  
  802d94:	c3                   	ret    

00802d95 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802d95:	55                   	push   %ebp
  802d96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802d98:	6a 00                	push   $0x0
  802d9a:	6a 00                	push   $0x0
  802d9c:	6a 00                	push   $0x0
  802d9e:	6a 00                	push   $0x0
  802da0:	6a 00                	push   $0x0
  802da2:	6a 0f                	push   $0xf
  802da4:	e8 81 fe ff ff       	call   802c2a <syscall>
  802da9:	83 c4 18             	add    $0x18,%esp
}
  802dac:	c9                   	leave  
  802dad:	c3                   	ret    

00802dae <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802dae:	55                   	push   %ebp
  802daf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802db1:	6a 00                	push   $0x0
  802db3:	6a 00                	push   $0x0
  802db5:	6a 00                	push   $0x0
  802db7:	6a 00                	push   $0x0
  802db9:	ff 75 08             	pushl  0x8(%ebp)
  802dbc:	6a 10                	push   $0x10
  802dbe:	e8 67 fe ff ff       	call   802c2a <syscall>
  802dc3:	83 c4 18             	add    $0x18,%esp
}
  802dc6:	c9                   	leave  
  802dc7:	c3                   	ret    

00802dc8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802dc8:	55                   	push   %ebp
  802dc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802dcb:	6a 00                	push   $0x0
  802dcd:	6a 00                	push   $0x0
  802dcf:	6a 00                	push   $0x0
  802dd1:	6a 00                	push   $0x0
  802dd3:	6a 00                	push   $0x0
  802dd5:	6a 11                	push   $0x11
  802dd7:	e8 4e fe ff ff       	call   802c2a <syscall>
  802ddc:	83 c4 18             	add    $0x18,%esp
}
  802ddf:	90                   	nop
  802de0:	c9                   	leave  
  802de1:	c3                   	ret    

00802de2 <sys_cputc>:

void
sys_cputc(const char c)
{
  802de2:	55                   	push   %ebp
  802de3:	89 e5                	mov    %esp,%ebp
  802de5:	83 ec 04             	sub    $0x4,%esp
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802dee:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802df2:	6a 00                	push   $0x0
  802df4:	6a 00                	push   $0x0
  802df6:	6a 00                	push   $0x0
  802df8:	6a 00                	push   $0x0
  802dfa:	50                   	push   %eax
  802dfb:	6a 01                	push   $0x1
  802dfd:	e8 28 fe ff ff       	call   802c2a <syscall>
  802e02:	83 c4 18             	add    $0x18,%esp
}
  802e05:	90                   	nop
  802e06:	c9                   	leave  
  802e07:	c3                   	ret    

00802e08 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802e08:	55                   	push   %ebp
  802e09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802e0b:	6a 00                	push   $0x0
  802e0d:	6a 00                	push   $0x0
  802e0f:	6a 00                	push   $0x0
  802e11:	6a 00                	push   $0x0
  802e13:	6a 00                	push   $0x0
  802e15:	6a 14                	push   $0x14
  802e17:	e8 0e fe ff ff       	call   802c2a <syscall>
  802e1c:	83 c4 18             	add    $0x18,%esp
}
  802e1f:	90                   	nop
  802e20:	c9                   	leave  
  802e21:	c3                   	ret    

00802e22 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802e22:	55                   	push   %ebp
  802e23:	89 e5                	mov    %esp,%ebp
  802e25:	83 ec 04             	sub    $0x4,%esp
  802e28:	8b 45 10             	mov    0x10(%ebp),%eax
  802e2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802e2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e31:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	6a 00                	push   $0x0
  802e3a:	51                   	push   %ecx
  802e3b:	52                   	push   %edx
  802e3c:	ff 75 0c             	pushl  0xc(%ebp)
  802e3f:	50                   	push   %eax
  802e40:	6a 15                	push   $0x15
  802e42:	e8 e3 fd ff ff       	call   802c2a <syscall>
  802e47:	83 c4 18             	add    $0x18,%esp
}
  802e4a:	c9                   	leave  
  802e4b:	c3                   	ret    

00802e4c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802e4c:	55                   	push   %ebp
  802e4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802e4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	6a 00                	push   $0x0
  802e57:	6a 00                	push   $0x0
  802e59:	6a 00                	push   $0x0
  802e5b:	52                   	push   %edx
  802e5c:	50                   	push   %eax
  802e5d:	6a 16                	push   $0x16
  802e5f:	e8 c6 fd ff ff       	call   802c2a <syscall>
  802e64:	83 c4 18             	add    $0x18,%esp
}
  802e67:	c9                   	leave  
  802e68:	c3                   	ret    

00802e69 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802e69:	55                   	push   %ebp
  802e6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802e6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	6a 00                	push   $0x0
  802e77:	6a 00                	push   $0x0
  802e79:	51                   	push   %ecx
  802e7a:	52                   	push   %edx
  802e7b:	50                   	push   %eax
  802e7c:	6a 17                	push   $0x17
  802e7e:	e8 a7 fd ff ff       	call   802c2a <syscall>
  802e83:	83 c4 18             	add    $0x18,%esp
}
  802e86:	c9                   	leave  
  802e87:	c3                   	ret    

00802e88 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802e88:	55                   	push   %ebp
  802e89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	6a 00                	push   $0x0
  802e93:	6a 00                	push   $0x0
  802e95:	6a 00                	push   $0x0
  802e97:	52                   	push   %edx
  802e98:	50                   	push   %eax
  802e99:	6a 18                	push   $0x18
  802e9b:	e8 8a fd ff ff       	call   802c2a <syscall>
  802ea0:	83 c4 18             	add    $0x18,%esp
}
  802ea3:	c9                   	leave  
  802ea4:	c3                   	ret    

00802ea5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802ea5:	55                   	push   %ebp
  802ea6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	6a 00                	push   $0x0
  802ead:	ff 75 14             	pushl  0x14(%ebp)
  802eb0:	ff 75 10             	pushl  0x10(%ebp)
  802eb3:	ff 75 0c             	pushl  0xc(%ebp)
  802eb6:	50                   	push   %eax
  802eb7:	6a 19                	push   $0x19
  802eb9:	e8 6c fd ff ff       	call   802c2a <syscall>
  802ebe:	83 c4 18             	add    $0x18,%esp
}
  802ec1:	c9                   	leave  
  802ec2:	c3                   	ret    

00802ec3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802ec3:	55                   	push   %ebp
  802ec4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	6a 00                	push   $0x0
  802ecb:	6a 00                	push   $0x0
  802ecd:	6a 00                	push   $0x0
  802ecf:	6a 00                	push   $0x0
  802ed1:	50                   	push   %eax
  802ed2:	6a 1a                	push   $0x1a
  802ed4:	e8 51 fd ff ff       	call   802c2a <syscall>
  802ed9:	83 c4 18             	add    $0x18,%esp
}
  802edc:	90                   	nop
  802edd:	c9                   	leave  
  802ede:	c3                   	ret    

00802edf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802edf:	55                   	push   %ebp
  802ee0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	6a 00                	push   $0x0
  802ee7:	6a 00                	push   $0x0
  802ee9:	6a 00                	push   $0x0
  802eeb:	6a 00                	push   $0x0
  802eed:	50                   	push   %eax
  802eee:	6a 1b                	push   $0x1b
  802ef0:	e8 35 fd ff ff       	call   802c2a <syscall>
  802ef5:	83 c4 18             	add    $0x18,%esp
}
  802ef8:	c9                   	leave  
  802ef9:	c3                   	ret    

00802efa <sys_getenvid>:

int32 sys_getenvid(void)
{
  802efa:	55                   	push   %ebp
  802efb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802efd:	6a 00                	push   $0x0
  802eff:	6a 00                	push   $0x0
  802f01:	6a 00                	push   $0x0
  802f03:	6a 00                	push   $0x0
  802f05:	6a 00                	push   $0x0
  802f07:	6a 05                	push   $0x5
  802f09:	e8 1c fd ff ff       	call   802c2a <syscall>
  802f0e:	83 c4 18             	add    $0x18,%esp
}
  802f11:	c9                   	leave  
  802f12:	c3                   	ret    

00802f13 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802f13:	55                   	push   %ebp
  802f14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802f16:	6a 00                	push   $0x0
  802f18:	6a 00                	push   $0x0
  802f1a:	6a 00                	push   $0x0
  802f1c:	6a 00                	push   $0x0
  802f1e:	6a 00                	push   $0x0
  802f20:	6a 06                	push   $0x6
  802f22:	e8 03 fd ff ff       	call   802c2a <syscall>
  802f27:	83 c4 18             	add    $0x18,%esp
}
  802f2a:	c9                   	leave  
  802f2b:	c3                   	ret    

00802f2c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802f2c:	55                   	push   %ebp
  802f2d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802f2f:	6a 00                	push   $0x0
  802f31:	6a 00                	push   $0x0
  802f33:	6a 00                	push   $0x0
  802f35:	6a 00                	push   $0x0
  802f37:	6a 00                	push   $0x0
  802f39:	6a 07                	push   $0x7
  802f3b:	e8 ea fc ff ff       	call   802c2a <syscall>
  802f40:	83 c4 18             	add    $0x18,%esp
}
  802f43:	c9                   	leave  
  802f44:	c3                   	ret    

00802f45 <sys_exit_env>:


void sys_exit_env(void)
{
  802f45:	55                   	push   %ebp
  802f46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 00                	push   $0x0
  802f50:	6a 00                	push   $0x0
  802f52:	6a 1c                	push   $0x1c
  802f54:	e8 d1 fc ff ff       	call   802c2a <syscall>
  802f59:	83 c4 18             	add    $0x18,%esp
}
  802f5c:	90                   	nop
  802f5d:	c9                   	leave  
  802f5e:	c3                   	ret    

00802f5f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802f5f:	55                   	push   %ebp
  802f60:	89 e5                	mov    %esp,%ebp
  802f62:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802f65:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802f68:	8d 50 04             	lea    0x4(%eax),%edx
  802f6b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802f6e:	6a 00                	push   $0x0
  802f70:	6a 00                	push   $0x0
  802f72:	6a 00                	push   $0x0
  802f74:	52                   	push   %edx
  802f75:	50                   	push   %eax
  802f76:	6a 1d                	push   $0x1d
  802f78:	e8 ad fc ff ff       	call   802c2a <syscall>
  802f7d:	83 c4 18             	add    $0x18,%esp
	return result;
  802f80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802f86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f89:	89 01                	mov    %eax,(%ecx)
  802f8b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	c9                   	leave  
  802f92:	c2 04 00             	ret    $0x4

00802f95 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802f95:	55                   	push   %ebp
  802f96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802f98:	6a 00                	push   $0x0
  802f9a:	6a 00                	push   $0x0
  802f9c:	ff 75 10             	pushl  0x10(%ebp)
  802f9f:	ff 75 0c             	pushl  0xc(%ebp)
  802fa2:	ff 75 08             	pushl  0x8(%ebp)
  802fa5:	6a 13                	push   $0x13
  802fa7:	e8 7e fc ff ff       	call   802c2a <syscall>
  802fac:	83 c4 18             	add    $0x18,%esp
	return ;
  802faf:	90                   	nop
}
  802fb0:	c9                   	leave  
  802fb1:	c3                   	ret    

00802fb2 <sys_rcr2>:
uint32 sys_rcr2()
{
  802fb2:	55                   	push   %ebp
  802fb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802fb5:	6a 00                	push   $0x0
  802fb7:	6a 00                	push   $0x0
  802fb9:	6a 00                	push   $0x0
  802fbb:	6a 00                	push   $0x0
  802fbd:	6a 00                	push   $0x0
  802fbf:	6a 1e                	push   $0x1e
  802fc1:	e8 64 fc ff ff       	call   802c2a <syscall>
  802fc6:	83 c4 18             	add    $0x18,%esp
}
  802fc9:	c9                   	leave  
  802fca:	c3                   	ret    

00802fcb <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802fcb:	55                   	push   %ebp
  802fcc:	89 e5                	mov    %esp,%ebp
  802fce:	83 ec 04             	sub    $0x4,%esp
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802fd7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802fdb:	6a 00                	push   $0x0
  802fdd:	6a 00                	push   $0x0
  802fdf:	6a 00                	push   $0x0
  802fe1:	6a 00                	push   $0x0
  802fe3:	50                   	push   %eax
  802fe4:	6a 1f                	push   $0x1f
  802fe6:	e8 3f fc ff ff       	call   802c2a <syscall>
  802feb:	83 c4 18             	add    $0x18,%esp
	return ;
  802fee:	90                   	nop
}
  802fef:	c9                   	leave  
  802ff0:	c3                   	ret    

00802ff1 <rsttst>:
void rsttst()
{
  802ff1:	55                   	push   %ebp
  802ff2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802ff4:	6a 00                	push   $0x0
  802ff6:	6a 00                	push   $0x0
  802ff8:	6a 00                	push   $0x0
  802ffa:	6a 00                	push   $0x0
  802ffc:	6a 00                	push   $0x0
  802ffe:	6a 21                	push   $0x21
  803000:	e8 25 fc ff ff       	call   802c2a <syscall>
  803005:	83 c4 18             	add    $0x18,%esp
	return ;
  803008:	90                   	nop
}
  803009:	c9                   	leave  
  80300a:	c3                   	ret    

0080300b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80300b:	55                   	push   %ebp
  80300c:	89 e5                	mov    %esp,%ebp
  80300e:	83 ec 04             	sub    $0x4,%esp
  803011:	8b 45 14             	mov    0x14(%ebp),%eax
  803014:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803017:	8b 55 18             	mov    0x18(%ebp),%edx
  80301a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80301e:	52                   	push   %edx
  80301f:	50                   	push   %eax
  803020:	ff 75 10             	pushl  0x10(%ebp)
  803023:	ff 75 0c             	pushl  0xc(%ebp)
  803026:	ff 75 08             	pushl  0x8(%ebp)
  803029:	6a 20                	push   $0x20
  80302b:	e8 fa fb ff ff       	call   802c2a <syscall>
  803030:	83 c4 18             	add    $0x18,%esp
	return ;
  803033:	90                   	nop
}
  803034:	c9                   	leave  
  803035:	c3                   	ret    

00803036 <chktst>:
void chktst(uint32 n)
{
  803036:	55                   	push   %ebp
  803037:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803039:	6a 00                	push   $0x0
  80303b:	6a 00                	push   $0x0
  80303d:	6a 00                	push   $0x0
  80303f:	6a 00                	push   $0x0
  803041:	ff 75 08             	pushl  0x8(%ebp)
  803044:	6a 22                	push   $0x22
  803046:	e8 df fb ff ff       	call   802c2a <syscall>
  80304b:	83 c4 18             	add    $0x18,%esp
	return ;
  80304e:	90                   	nop
}
  80304f:	c9                   	leave  
  803050:	c3                   	ret    

00803051 <inctst>:

void inctst()
{
  803051:	55                   	push   %ebp
  803052:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803054:	6a 00                	push   $0x0
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	6a 00                	push   $0x0
  80305e:	6a 23                	push   $0x23
  803060:	e8 c5 fb ff ff       	call   802c2a <syscall>
  803065:	83 c4 18             	add    $0x18,%esp
	return ;
  803068:	90                   	nop
}
  803069:	c9                   	leave  
  80306a:	c3                   	ret    

0080306b <gettst>:
uint32 gettst()
{
  80306b:	55                   	push   %ebp
  80306c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80306e:	6a 00                	push   $0x0
  803070:	6a 00                	push   $0x0
  803072:	6a 00                	push   $0x0
  803074:	6a 00                	push   $0x0
  803076:	6a 00                	push   $0x0
  803078:	6a 24                	push   $0x24
  80307a:	e8 ab fb ff ff       	call   802c2a <syscall>
  80307f:	83 c4 18             	add    $0x18,%esp
}
  803082:	c9                   	leave  
  803083:	c3                   	ret    

00803084 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  803084:	55                   	push   %ebp
  803085:	89 e5                	mov    %esp,%ebp
  803087:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80308a:	6a 00                	push   $0x0
  80308c:	6a 00                	push   $0x0
  80308e:	6a 00                	push   $0x0
  803090:	6a 00                	push   $0x0
  803092:	6a 00                	push   $0x0
  803094:	6a 25                	push   $0x25
  803096:	e8 8f fb ff ff       	call   802c2a <syscall>
  80309b:	83 c4 18             	add    $0x18,%esp
  80309e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8030a1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8030a5:	75 07                	jne    8030ae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8030a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ac:	eb 05                	jmp    8030b3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8030ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b3:	c9                   	leave  
  8030b4:	c3                   	ret    

008030b5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8030b5:	55                   	push   %ebp
  8030b6:	89 e5                	mov    %esp,%ebp
  8030b8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8030bb:	6a 00                	push   $0x0
  8030bd:	6a 00                	push   $0x0
  8030bf:	6a 00                	push   $0x0
  8030c1:	6a 00                	push   $0x0
  8030c3:	6a 00                	push   $0x0
  8030c5:	6a 25                	push   $0x25
  8030c7:	e8 5e fb ff ff       	call   802c2a <syscall>
  8030cc:	83 c4 18             	add    $0x18,%esp
  8030cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8030d2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8030d6:	75 07                	jne    8030df <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8030d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8030dd:	eb 05                	jmp    8030e4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8030df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030e4:	c9                   	leave  
  8030e5:	c3                   	ret    

008030e6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8030e6:	55                   	push   %ebp
  8030e7:	89 e5                	mov    %esp,%ebp
  8030e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8030ec:	6a 00                	push   $0x0
  8030ee:	6a 00                	push   $0x0
  8030f0:	6a 00                	push   $0x0
  8030f2:	6a 00                	push   $0x0
  8030f4:	6a 00                	push   $0x0
  8030f6:	6a 25                	push   $0x25
  8030f8:	e8 2d fb ff ff       	call   802c2a <syscall>
  8030fd:	83 c4 18             	add    $0x18,%esp
  803100:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803103:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803107:	75 07                	jne    803110 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803109:	b8 01 00 00 00       	mov    $0x1,%eax
  80310e:	eb 05                	jmp    803115 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803110:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803115:	c9                   	leave  
  803116:	c3                   	ret    

00803117 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803117:	55                   	push   %ebp
  803118:	89 e5                	mov    %esp,%ebp
  80311a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80311d:	6a 00                	push   $0x0
  80311f:	6a 00                	push   $0x0
  803121:	6a 00                	push   $0x0
  803123:	6a 00                	push   $0x0
  803125:	6a 00                	push   $0x0
  803127:	6a 25                	push   $0x25
  803129:	e8 fc fa ff ff       	call   802c2a <syscall>
  80312e:	83 c4 18             	add    $0x18,%esp
  803131:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803134:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803138:	75 07                	jne    803141 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80313a:	b8 01 00 00 00       	mov    $0x1,%eax
  80313f:	eb 05                	jmp    803146 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803141:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803146:	c9                   	leave  
  803147:	c3                   	ret    

00803148 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803148:	55                   	push   %ebp
  803149:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80314b:	6a 00                	push   $0x0
  80314d:	6a 00                	push   $0x0
  80314f:	6a 00                	push   $0x0
  803151:	6a 00                	push   $0x0
  803153:	ff 75 08             	pushl  0x8(%ebp)
  803156:	6a 26                	push   $0x26
  803158:	e8 cd fa ff ff       	call   802c2a <syscall>
  80315d:	83 c4 18             	add    $0x18,%esp
	return ;
  803160:	90                   	nop
}
  803161:	c9                   	leave  
  803162:	c3                   	ret    

00803163 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803163:	55                   	push   %ebp
  803164:	89 e5                	mov    %esp,%ebp
  803166:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803167:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80316a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80316d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	6a 00                	push   $0x0
  803175:	53                   	push   %ebx
  803176:	51                   	push   %ecx
  803177:	52                   	push   %edx
  803178:	50                   	push   %eax
  803179:	6a 27                	push   $0x27
  80317b:	e8 aa fa ff ff       	call   802c2a <syscall>
  803180:	83 c4 18             	add    $0x18,%esp
}
  803183:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803186:	c9                   	leave  
  803187:	c3                   	ret    

00803188 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803188:	55                   	push   %ebp
  803189:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80318b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	6a 00                	push   $0x0
  803193:	6a 00                	push   $0x0
  803195:	6a 00                	push   $0x0
  803197:	52                   	push   %edx
  803198:	50                   	push   %eax
  803199:	6a 28                	push   $0x28
  80319b:	e8 8a fa ff ff       	call   802c2a <syscall>
  8031a0:	83 c4 18             	add    $0x18,%esp
}
  8031a3:	c9                   	leave  
  8031a4:	c3                   	ret    

008031a5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8031a5:	55                   	push   %ebp
  8031a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8031a8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8031ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	6a 00                	push   $0x0
  8031b3:	51                   	push   %ecx
  8031b4:	ff 75 10             	pushl  0x10(%ebp)
  8031b7:	52                   	push   %edx
  8031b8:	50                   	push   %eax
  8031b9:	6a 29                	push   $0x29
  8031bb:	e8 6a fa ff ff       	call   802c2a <syscall>
  8031c0:	83 c4 18             	add    $0x18,%esp
}
  8031c3:	c9                   	leave  
  8031c4:	c3                   	ret    

008031c5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8031c5:	55                   	push   %ebp
  8031c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8031c8:	6a 00                	push   $0x0
  8031ca:	6a 00                	push   $0x0
  8031cc:	ff 75 10             	pushl  0x10(%ebp)
  8031cf:	ff 75 0c             	pushl  0xc(%ebp)
  8031d2:	ff 75 08             	pushl  0x8(%ebp)
  8031d5:	6a 12                	push   $0x12
  8031d7:	e8 4e fa ff ff       	call   802c2a <syscall>
  8031dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8031df:	90                   	nop
}
  8031e0:	c9                   	leave  
  8031e1:	c3                   	ret    

008031e2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8031e2:	55                   	push   %ebp
  8031e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8031e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	6a 00                	push   $0x0
  8031ed:	6a 00                	push   $0x0
  8031ef:	6a 00                	push   $0x0
  8031f1:	52                   	push   %edx
  8031f2:	50                   	push   %eax
  8031f3:	6a 2a                	push   $0x2a
  8031f5:	e8 30 fa ff ff       	call   802c2a <syscall>
  8031fa:	83 c4 18             	add    $0x18,%esp
	return;
  8031fd:	90                   	nop
}
  8031fe:	c9                   	leave  
  8031ff:	c3                   	ret    

00803200 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  803200:	55                   	push   %ebp
  803201:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  803203:	8b 45 08             	mov    0x8(%ebp),%eax
  803206:	6a 00                	push   $0x0
  803208:	6a 00                	push   $0x0
  80320a:	6a 00                	push   $0x0
  80320c:	6a 00                	push   $0x0
  80320e:	50                   	push   %eax
  80320f:	6a 2b                	push   $0x2b
  803211:	e8 14 fa ff ff       	call   802c2a <syscall>
  803216:	83 c4 18             	add    $0x18,%esp
}
  803219:	c9                   	leave  
  80321a:	c3                   	ret    

0080321b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80321b:	55                   	push   %ebp
  80321c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  80321e:	6a 00                	push   $0x0
  803220:	6a 00                	push   $0x0
  803222:	6a 00                	push   $0x0
  803224:	ff 75 0c             	pushl  0xc(%ebp)
  803227:	ff 75 08             	pushl  0x8(%ebp)
  80322a:	6a 2c                	push   $0x2c
  80322c:	e8 f9 f9 ff ff       	call   802c2a <syscall>
  803231:	83 c4 18             	add    $0x18,%esp
	return;
  803234:	90                   	nop
}
  803235:	c9                   	leave  
  803236:	c3                   	ret    

00803237 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803237:	55                   	push   %ebp
  803238:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80323a:	6a 00                	push   $0x0
  80323c:	6a 00                	push   $0x0
  80323e:	6a 00                	push   $0x0
  803240:	ff 75 0c             	pushl  0xc(%ebp)
  803243:	ff 75 08             	pushl  0x8(%ebp)
  803246:	6a 2d                	push   $0x2d
  803248:	e8 dd f9 ff ff       	call   802c2a <syscall>
  80324d:	83 c4 18             	add    $0x18,%esp
	return;
  803250:	90                   	nop
}
  803251:	c9                   	leave  
  803252:	c3                   	ret    

00803253 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  803253:	55                   	push   %ebp
  803254:	89 e5                	mov    %esp,%ebp
  803256:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	83 e8 04             	sub    $0x4,%eax
  80325f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  803262:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803265:	8b 00                	mov    (%eax),%eax
  803267:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80326a:	c9                   	leave  
  80326b:	c3                   	ret    

0080326c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80326c:	55                   	push   %ebp
  80326d:	89 e5                	mov    %esp,%ebp
  80326f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	83 e8 04             	sub    $0x4,%eax
  803278:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80327b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80327e:	8b 00                	mov    (%eax),%eax
  803280:	83 e0 01             	and    $0x1,%eax
  803283:	85 c0                	test   %eax,%eax
  803285:	0f 94 c0             	sete   %al
}
  803288:	c9                   	leave  
  803289:	c3                   	ret    

0080328a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80328a:	55                   	push   %ebp
  80328b:	89 e5                	mov    %esp,%ebp
  80328d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  803290:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  803297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329a:	83 f8 02             	cmp    $0x2,%eax
  80329d:	74 2b                	je     8032ca <alloc_block+0x40>
  80329f:	83 f8 02             	cmp    $0x2,%eax
  8032a2:	7f 07                	jg     8032ab <alloc_block+0x21>
  8032a4:	83 f8 01             	cmp    $0x1,%eax
  8032a7:	74 0e                	je     8032b7 <alloc_block+0x2d>
  8032a9:	eb 58                	jmp    803303 <alloc_block+0x79>
  8032ab:	83 f8 03             	cmp    $0x3,%eax
  8032ae:	74 2d                	je     8032dd <alloc_block+0x53>
  8032b0:	83 f8 04             	cmp    $0x4,%eax
  8032b3:	74 3b                	je     8032f0 <alloc_block+0x66>
  8032b5:	eb 4c                	jmp    803303 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8032b7:	83 ec 0c             	sub    $0xc,%esp
  8032ba:	ff 75 08             	pushl  0x8(%ebp)
  8032bd:	e8 11 03 00 00       	call   8035d3 <alloc_block_FF>
  8032c2:	83 c4 10             	add    $0x10,%esp
  8032c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8032c8:	eb 4a                	jmp    803314 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8032ca:	83 ec 0c             	sub    $0xc,%esp
  8032cd:	ff 75 08             	pushl  0x8(%ebp)
  8032d0:	e8 fa 19 00 00       	call   804ccf <alloc_block_NF>
  8032d5:	83 c4 10             	add    $0x10,%esp
  8032d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8032db:	eb 37                	jmp    803314 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8032dd:	83 ec 0c             	sub    $0xc,%esp
  8032e0:	ff 75 08             	pushl  0x8(%ebp)
  8032e3:	e8 a7 07 00 00       	call   803a8f <alloc_block_BF>
  8032e8:	83 c4 10             	add    $0x10,%esp
  8032eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8032ee:	eb 24                	jmp    803314 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8032f0:	83 ec 0c             	sub    $0xc,%esp
  8032f3:	ff 75 08             	pushl  0x8(%ebp)
  8032f6:	e8 b7 19 00 00       	call   804cb2 <alloc_block_WF>
  8032fb:	83 c4 10             	add    $0x10,%esp
  8032fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803301:	eb 11                	jmp    803314 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  803303:	83 ec 0c             	sub    $0xc,%esp
  803306:	68 44 58 80 00       	push   $0x805844
  80330b:	e8 60 e5 ff ff       	call   801870 <cprintf>
  803310:	83 c4 10             	add    $0x10,%esp
		break;
  803313:	90                   	nop
	}
	return va;
  803314:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803317:	c9                   	leave  
  803318:	c3                   	ret    

00803319 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  803319:	55                   	push   %ebp
  80331a:	89 e5                	mov    %esp,%ebp
  80331c:	53                   	push   %ebx
  80331d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  803320:	83 ec 0c             	sub    $0xc,%esp
  803323:	68 64 58 80 00       	push   $0x805864
  803328:	e8 43 e5 ff ff       	call   801870 <cprintf>
  80332d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  803330:	83 ec 0c             	sub    $0xc,%esp
  803333:	68 8f 58 80 00       	push   $0x80588f
  803338:	e8 33 e5 ff ff       	call   801870 <cprintf>
  80333d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803346:	eb 37                	jmp    80337f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  803348:	83 ec 0c             	sub    $0xc,%esp
  80334b:	ff 75 f4             	pushl  -0xc(%ebp)
  80334e:	e8 19 ff ff ff       	call   80326c <is_free_block>
  803353:	83 c4 10             	add    $0x10,%esp
  803356:	0f be d8             	movsbl %al,%ebx
  803359:	83 ec 0c             	sub    $0xc,%esp
  80335c:	ff 75 f4             	pushl  -0xc(%ebp)
  80335f:	e8 ef fe ff ff       	call   803253 <get_block_size>
  803364:	83 c4 10             	add    $0x10,%esp
  803367:	83 ec 04             	sub    $0x4,%esp
  80336a:	53                   	push   %ebx
  80336b:	50                   	push   %eax
  80336c:	68 a7 58 80 00       	push   $0x8058a7
  803371:	e8 fa e4 ff ff       	call   801870 <cprintf>
  803376:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  803379:	8b 45 10             	mov    0x10(%ebp),%eax
  80337c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80337f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803383:	74 07                	je     80338c <print_blocks_list+0x73>
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	8b 00                	mov    (%eax),%eax
  80338a:	eb 05                	jmp    803391 <print_blocks_list+0x78>
  80338c:	b8 00 00 00 00       	mov    $0x0,%eax
  803391:	89 45 10             	mov    %eax,0x10(%ebp)
  803394:	8b 45 10             	mov    0x10(%ebp),%eax
  803397:	85 c0                	test   %eax,%eax
  803399:	75 ad                	jne    803348 <print_blocks_list+0x2f>
  80339b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80339f:	75 a7                	jne    803348 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8033a1:	83 ec 0c             	sub    $0xc,%esp
  8033a4:	68 64 58 80 00       	push   $0x805864
  8033a9:	e8 c2 e4 ff ff       	call   801870 <cprintf>
  8033ae:	83 c4 10             	add    $0x10,%esp

}
  8033b1:	90                   	nop
  8033b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8033b5:	c9                   	leave  
  8033b6:	c3                   	ret    

008033b7 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8033b7:	55                   	push   %ebp
  8033b8:	89 e5                	mov    %esp,%ebp
  8033ba:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8033bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c0:	83 e0 01             	and    $0x1,%eax
  8033c3:	85 c0                	test   %eax,%eax
  8033c5:	74 03                	je     8033ca <initialize_dynamic_allocator+0x13>
  8033c7:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8033ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033ce:	0f 84 c7 01 00 00    	je     80359b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8033d4:	c7 05 28 60 80 00 01 	movl   $0x1,0x806028
  8033db:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8033de:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e4:	01 d0                	add    %edx,%eax
  8033e6:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8033eb:	0f 87 ad 01 00 00    	ja     80359e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	85 c0                	test   %eax,%eax
  8033f6:	0f 89 a5 01 00 00    	jns    8035a1 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8033fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  803402:	01 d0                	add    %edx,%eax
  803404:	83 e8 04             	sub    $0x4,%eax
  803407:	a3 48 60 80 00       	mov    %eax,0x806048
     struct BlockElement * element = NULL;
  80340c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  803413:	a1 30 60 80 00       	mov    0x806030,%eax
  803418:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80341b:	e9 87 00 00 00       	jmp    8034a7 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  803420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803424:	75 14                	jne    80343a <initialize_dynamic_allocator+0x83>
  803426:	83 ec 04             	sub    $0x4,%esp
  803429:	68 bf 58 80 00       	push   $0x8058bf
  80342e:	6a 79                	push   $0x79
  803430:	68 dd 58 80 00       	push   $0x8058dd
  803435:	e8 79 e1 ff ff       	call   8015b3 <_panic>
  80343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343d:	8b 00                	mov    (%eax),%eax
  80343f:	85 c0                	test   %eax,%eax
  803441:	74 10                	je     803453 <initialize_dynamic_allocator+0x9c>
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	8b 00                	mov    (%eax),%eax
  803448:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80344b:	8b 52 04             	mov    0x4(%edx),%edx
  80344e:	89 50 04             	mov    %edx,0x4(%eax)
  803451:	eb 0b                	jmp    80345e <initialize_dynamic_allocator+0xa7>
  803453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803456:	8b 40 04             	mov    0x4(%eax),%eax
  803459:	a3 34 60 80 00       	mov    %eax,0x806034
  80345e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803461:	8b 40 04             	mov    0x4(%eax),%eax
  803464:	85 c0                	test   %eax,%eax
  803466:	74 0f                	je     803477 <initialize_dynamic_allocator+0xc0>
  803468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346b:	8b 40 04             	mov    0x4(%eax),%eax
  80346e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803471:	8b 12                	mov    (%edx),%edx
  803473:	89 10                	mov    %edx,(%eax)
  803475:	eb 0a                	jmp    803481 <initialize_dynamic_allocator+0xca>
  803477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347a:	8b 00                	mov    (%eax),%eax
  80347c:	a3 30 60 80 00       	mov    %eax,0x806030
  803481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803484:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803494:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803499:	48                   	dec    %eax
  80349a:	a3 3c 60 80 00       	mov    %eax,0x80603c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80349f:	a1 38 60 80 00       	mov    0x806038,%eax
  8034a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ab:	74 07                	je     8034b4 <initialize_dynamic_allocator+0xfd>
  8034ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b0:	8b 00                	mov    (%eax),%eax
  8034b2:	eb 05                	jmp    8034b9 <initialize_dynamic_allocator+0x102>
  8034b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b9:	a3 38 60 80 00       	mov    %eax,0x806038
  8034be:	a1 38 60 80 00       	mov    0x806038,%eax
  8034c3:	85 c0                	test   %eax,%eax
  8034c5:	0f 85 55 ff ff ff    	jne    803420 <initialize_dynamic_allocator+0x69>
  8034cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034cf:	0f 85 4b ff ff ff    	jne    803420 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8034db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034de:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8034e4:	a1 48 60 80 00       	mov    0x806048,%eax
  8034e9:	a3 44 60 80 00       	mov    %eax,0x806044
    end_block->info = 1;
  8034ee:	a1 44 60 80 00       	mov    0x806044,%eax
  8034f3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	83 c0 08             	add    $0x8,%eax
  8034ff:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  803502:	8b 45 08             	mov    0x8(%ebp),%eax
  803505:	83 c0 04             	add    $0x4,%eax
  803508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80350b:	83 ea 08             	sub    $0x8,%edx
  80350e:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  803510:	8b 55 0c             	mov    0xc(%ebp),%edx
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	01 d0                	add    %edx,%eax
  803518:	83 e8 08             	sub    $0x8,%eax
  80351b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80351e:	83 ea 08             	sub    $0x8,%edx
  803521:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  803523:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80352c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  803536:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80353a:	75 17                	jne    803553 <initialize_dynamic_allocator+0x19c>
  80353c:	83 ec 04             	sub    $0x4,%esp
  80353f:	68 f8 58 80 00       	push   $0x8058f8
  803544:	68 90 00 00 00       	push   $0x90
  803549:	68 dd 58 80 00       	push   $0x8058dd
  80354e:	e8 60 e0 ff ff       	call   8015b3 <_panic>
  803553:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803559:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355c:	89 10                	mov    %edx,(%eax)
  80355e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803561:	8b 00                	mov    (%eax),%eax
  803563:	85 c0                	test   %eax,%eax
  803565:	74 0d                	je     803574 <initialize_dynamic_allocator+0x1bd>
  803567:	a1 30 60 80 00       	mov    0x806030,%eax
  80356c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80356f:	89 50 04             	mov    %edx,0x4(%eax)
  803572:	eb 08                	jmp    80357c <initialize_dynamic_allocator+0x1c5>
  803574:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803577:	a3 34 60 80 00       	mov    %eax,0x806034
  80357c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357f:	a3 30 60 80 00       	mov    %eax,0x806030
  803584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803587:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358e:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803593:	40                   	inc    %eax
  803594:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803599:	eb 07                	jmp    8035a2 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80359b:	90                   	nop
  80359c:	eb 04                	jmp    8035a2 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80359e:	90                   	nop
  80359f:	eb 01                	jmp    8035a2 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8035a1:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8035a2:	c9                   	leave  
  8035a3:	c3                   	ret    

008035a4 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8035a4:	55                   	push   %ebp
  8035a5:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8035a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8035aa:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	8d 50 fc             	lea    -0x4(%eax),%edx
  8035b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b6:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8035b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bb:	83 e8 04             	sub    $0x4,%eax
  8035be:	8b 00                	mov    (%eax),%eax
  8035c0:	83 e0 fe             	and    $0xfffffffe,%eax
  8035c3:	8d 50 f8             	lea    -0x8(%eax),%edx
  8035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c9:	01 c2                	add    %eax,%edx
  8035cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ce:	89 02                	mov    %eax,(%edx)
}
  8035d0:	90                   	nop
  8035d1:	5d                   	pop    %ebp
  8035d2:	c3                   	ret    

008035d3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8035d3:	55                   	push   %ebp
  8035d4:	89 e5                	mov    %esp,%ebp
  8035d6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8035d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dc:	83 e0 01             	and    $0x1,%eax
  8035df:	85 c0                	test   %eax,%eax
  8035e1:	74 03                	je     8035e6 <alloc_block_FF+0x13>
  8035e3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8035e6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8035ea:	77 07                	ja     8035f3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8035ec:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8035f3:	a1 28 60 80 00       	mov    0x806028,%eax
  8035f8:	85 c0                	test   %eax,%eax
  8035fa:	75 73                	jne    80366f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8035fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ff:	83 c0 10             	add    $0x10,%eax
  803602:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803605:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80360c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80360f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803612:	01 d0                	add    %edx,%eax
  803614:	48                   	dec    %eax
  803615:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803618:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361b:	ba 00 00 00 00       	mov    $0x0,%edx
  803620:	f7 75 ec             	divl   -0x14(%ebp)
  803623:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803626:	29 d0                	sub    %edx,%eax
  803628:	c1 e8 0c             	shr    $0xc,%eax
  80362b:	83 ec 0c             	sub    $0xc,%esp
  80362e:	50                   	push   %eax
  80362f:	e8 d6 ef ff ff       	call   80260a <sbrk>
  803634:	83 c4 10             	add    $0x10,%esp
  803637:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80363a:	83 ec 0c             	sub    $0xc,%esp
  80363d:	6a 00                	push   $0x0
  80363f:	e8 c6 ef ff ff       	call   80260a <sbrk>
  803644:	83 c4 10             	add    $0x10,%esp
  803647:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80364a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80364d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803650:	83 ec 08             	sub    $0x8,%esp
  803653:	50                   	push   %eax
  803654:	ff 75 e4             	pushl  -0x1c(%ebp)
  803657:	e8 5b fd ff ff       	call   8033b7 <initialize_dynamic_allocator>
  80365c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80365f:	83 ec 0c             	sub    $0xc,%esp
  803662:	68 1b 59 80 00       	push   $0x80591b
  803667:	e8 04 e2 ff ff       	call   801870 <cprintf>
  80366c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80366f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803673:	75 0a                	jne    80367f <alloc_block_FF+0xac>
	        return NULL;
  803675:	b8 00 00 00 00       	mov    $0x0,%eax
  80367a:	e9 0e 04 00 00       	jmp    803a8d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80367f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  803686:	a1 30 60 80 00       	mov    0x806030,%eax
  80368b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80368e:	e9 f3 02 00 00       	jmp    803986 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  803693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803696:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803699:	83 ec 0c             	sub    $0xc,%esp
  80369c:	ff 75 bc             	pushl  -0x44(%ebp)
  80369f:	e8 af fb ff ff       	call   803253 <get_block_size>
  8036a4:	83 c4 10             	add    $0x10,%esp
  8036a7:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	83 c0 08             	add    $0x8,%eax
  8036b0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8036b3:	0f 87 c5 02 00 00    	ja     80397e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8036b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bc:	83 c0 18             	add    $0x18,%eax
  8036bf:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8036c2:	0f 87 19 02 00 00    	ja     8038e1 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8036c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036cb:	2b 45 08             	sub    0x8(%ebp),%eax
  8036ce:	83 e8 08             	sub    $0x8,%eax
  8036d1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8036d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d7:	8d 50 08             	lea    0x8(%eax),%edx
  8036da:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8036dd:	01 d0                	add    %edx,%eax
  8036df:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8036e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e5:	83 c0 08             	add    $0x8,%eax
  8036e8:	83 ec 04             	sub    $0x4,%esp
  8036eb:	6a 01                	push   $0x1
  8036ed:	50                   	push   %eax
  8036ee:	ff 75 bc             	pushl  -0x44(%ebp)
  8036f1:	e8 ae fe ff ff       	call   8035a4 <set_block_data>
  8036f6:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8036f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fc:	8b 40 04             	mov    0x4(%eax),%eax
  8036ff:	85 c0                	test   %eax,%eax
  803701:	75 68                	jne    80376b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803703:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803707:	75 17                	jne    803720 <alloc_block_FF+0x14d>
  803709:	83 ec 04             	sub    $0x4,%esp
  80370c:	68 f8 58 80 00       	push   $0x8058f8
  803711:	68 d7 00 00 00       	push   $0xd7
  803716:	68 dd 58 80 00       	push   $0x8058dd
  80371b:	e8 93 de ff ff       	call   8015b3 <_panic>
  803720:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803726:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803729:	89 10                	mov    %edx,(%eax)
  80372b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80372e:	8b 00                	mov    (%eax),%eax
  803730:	85 c0                	test   %eax,%eax
  803732:	74 0d                	je     803741 <alloc_block_FF+0x16e>
  803734:	a1 30 60 80 00       	mov    0x806030,%eax
  803739:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80373c:	89 50 04             	mov    %edx,0x4(%eax)
  80373f:	eb 08                	jmp    803749 <alloc_block_FF+0x176>
  803741:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803744:	a3 34 60 80 00       	mov    %eax,0x806034
  803749:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80374c:	a3 30 60 80 00       	mov    %eax,0x806030
  803751:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803754:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375b:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803760:	40                   	inc    %eax
  803761:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803766:	e9 dc 00 00 00       	jmp    803847 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80376b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376e:	8b 00                	mov    (%eax),%eax
  803770:	85 c0                	test   %eax,%eax
  803772:	75 65                	jne    8037d9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803774:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803778:	75 17                	jne    803791 <alloc_block_FF+0x1be>
  80377a:	83 ec 04             	sub    $0x4,%esp
  80377d:	68 2c 59 80 00       	push   $0x80592c
  803782:	68 db 00 00 00       	push   $0xdb
  803787:	68 dd 58 80 00       	push   $0x8058dd
  80378c:	e8 22 de ff ff       	call   8015b3 <_panic>
  803791:	8b 15 34 60 80 00    	mov    0x806034,%edx
  803797:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80379a:	89 50 04             	mov    %edx,0x4(%eax)
  80379d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037a0:	8b 40 04             	mov    0x4(%eax),%eax
  8037a3:	85 c0                	test   %eax,%eax
  8037a5:	74 0c                	je     8037b3 <alloc_block_FF+0x1e0>
  8037a7:	a1 34 60 80 00       	mov    0x806034,%eax
  8037ac:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8037af:	89 10                	mov    %edx,(%eax)
  8037b1:	eb 08                	jmp    8037bb <alloc_block_FF+0x1e8>
  8037b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037b6:	a3 30 60 80 00       	mov    %eax,0x806030
  8037bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037be:	a3 34 60 80 00       	mov    %eax,0x806034
  8037c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8037c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037cc:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8037d1:	40                   	inc    %eax
  8037d2:	a3 3c 60 80 00       	mov    %eax,0x80603c
  8037d7:	eb 6e                	jmp    803847 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8037d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037dd:	74 06                	je     8037e5 <alloc_block_FF+0x212>
  8037df:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8037e3:	75 17                	jne    8037fc <alloc_block_FF+0x229>
  8037e5:	83 ec 04             	sub    $0x4,%esp
  8037e8:	68 50 59 80 00       	push   $0x805950
  8037ed:	68 df 00 00 00       	push   $0xdf
  8037f2:	68 dd 58 80 00       	push   $0x8058dd
  8037f7:	e8 b7 dd ff ff       	call   8015b3 <_panic>
  8037fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ff:	8b 10                	mov    (%eax),%edx
  803801:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803804:	89 10                	mov    %edx,(%eax)
  803806:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803809:	8b 00                	mov    (%eax),%eax
  80380b:	85 c0                	test   %eax,%eax
  80380d:	74 0b                	je     80381a <alloc_block_FF+0x247>
  80380f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803812:	8b 00                	mov    (%eax),%eax
  803814:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803817:	89 50 04             	mov    %edx,0x4(%eax)
  80381a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803820:	89 10                	mov    %edx,(%eax)
  803822:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803825:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803828:	89 50 04             	mov    %edx,0x4(%eax)
  80382b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80382e:	8b 00                	mov    (%eax),%eax
  803830:	85 c0                	test   %eax,%eax
  803832:	75 08                	jne    80383c <alloc_block_FF+0x269>
  803834:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803837:	a3 34 60 80 00       	mov    %eax,0x806034
  80383c:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803841:	40                   	inc    %eax
  803842:	a3 3c 60 80 00       	mov    %eax,0x80603c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  803847:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80384b:	75 17                	jne    803864 <alloc_block_FF+0x291>
  80384d:	83 ec 04             	sub    $0x4,%esp
  803850:	68 bf 58 80 00       	push   $0x8058bf
  803855:	68 e1 00 00 00       	push   $0xe1
  80385a:	68 dd 58 80 00       	push   $0x8058dd
  80385f:	e8 4f dd ff ff       	call   8015b3 <_panic>
  803864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	85 c0                	test   %eax,%eax
  80386b:	74 10                	je     80387d <alloc_block_FF+0x2aa>
  80386d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803870:	8b 00                	mov    (%eax),%eax
  803872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803875:	8b 52 04             	mov    0x4(%edx),%edx
  803878:	89 50 04             	mov    %edx,0x4(%eax)
  80387b:	eb 0b                	jmp    803888 <alloc_block_FF+0x2b5>
  80387d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803880:	8b 40 04             	mov    0x4(%eax),%eax
  803883:	a3 34 60 80 00       	mov    %eax,0x806034
  803888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388b:	8b 40 04             	mov    0x4(%eax),%eax
  80388e:	85 c0                	test   %eax,%eax
  803890:	74 0f                	je     8038a1 <alloc_block_FF+0x2ce>
  803892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803895:	8b 40 04             	mov    0x4(%eax),%eax
  803898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80389b:	8b 12                	mov    (%edx),%edx
  80389d:	89 10                	mov    %edx,(%eax)
  80389f:	eb 0a                	jmp    8038ab <alloc_block_FF+0x2d8>
  8038a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a4:	8b 00                	mov    (%eax),%eax
  8038a6:	a3 30 60 80 00       	mov    %eax,0x806030
  8038ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038be:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8038c3:	48                   	dec    %eax
  8038c4:	a3 3c 60 80 00       	mov    %eax,0x80603c
				set_block_data(new_block_va, remaining_size, 0);
  8038c9:	83 ec 04             	sub    $0x4,%esp
  8038cc:	6a 00                	push   $0x0
  8038ce:	ff 75 b4             	pushl  -0x4c(%ebp)
  8038d1:	ff 75 b0             	pushl  -0x50(%ebp)
  8038d4:	e8 cb fc ff ff       	call   8035a4 <set_block_data>
  8038d9:	83 c4 10             	add    $0x10,%esp
  8038dc:	e9 95 00 00 00       	jmp    803976 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8038e1:	83 ec 04             	sub    $0x4,%esp
  8038e4:	6a 01                	push   $0x1
  8038e6:	ff 75 b8             	pushl  -0x48(%ebp)
  8038e9:	ff 75 bc             	pushl  -0x44(%ebp)
  8038ec:	e8 b3 fc ff ff       	call   8035a4 <set_block_data>
  8038f1:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8038f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f8:	75 17                	jne    803911 <alloc_block_FF+0x33e>
  8038fa:	83 ec 04             	sub    $0x4,%esp
  8038fd:	68 bf 58 80 00       	push   $0x8058bf
  803902:	68 e8 00 00 00       	push   $0xe8
  803907:	68 dd 58 80 00       	push   $0x8058dd
  80390c:	e8 a2 dc ff ff       	call   8015b3 <_panic>
  803911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803914:	8b 00                	mov    (%eax),%eax
  803916:	85 c0                	test   %eax,%eax
  803918:	74 10                	je     80392a <alloc_block_FF+0x357>
  80391a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391d:	8b 00                	mov    (%eax),%eax
  80391f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803922:	8b 52 04             	mov    0x4(%edx),%edx
  803925:	89 50 04             	mov    %edx,0x4(%eax)
  803928:	eb 0b                	jmp    803935 <alloc_block_FF+0x362>
  80392a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392d:	8b 40 04             	mov    0x4(%eax),%eax
  803930:	a3 34 60 80 00       	mov    %eax,0x806034
  803935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803938:	8b 40 04             	mov    0x4(%eax),%eax
  80393b:	85 c0                	test   %eax,%eax
  80393d:	74 0f                	je     80394e <alloc_block_FF+0x37b>
  80393f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803942:	8b 40 04             	mov    0x4(%eax),%eax
  803945:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803948:	8b 12                	mov    (%edx),%edx
  80394a:	89 10                	mov    %edx,(%eax)
  80394c:	eb 0a                	jmp    803958 <alloc_block_FF+0x385>
  80394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803951:	8b 00                	mov    (%eax),%eax
  803953:	a3 30 60 80 00       	mov    %eax,0x806030
  803958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803964:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80396b:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803970:	48                   	dec    %eax
  803971:	a3 3c 60 80 00       	mov    %eax,0x80603c
	            }
	            return va;
  803976:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803979:	e9 0f 01 00 00       	jmp    803a8d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80397e:	a1 38 60 80 00       	mov    0x806038,%eax
  803983:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80398a:	74 07                	je     803993 <alloc_block_FF+0x3c0>
  80398c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398f:	8b 00                	mov    (%eax),%eax
  803991:	eb 05                	jmp    803998 <alloc_block_FF+0x3c5>
  803993:	b8 00 00 00 00       	mov    $0x0,%eax
  803998:	a3 38 60 80 00       	mov    %eax,0x806038
  80399d:	a1 38 60 80 00       	mov    0x806038,%eax
  8039a2:	85 c0                	test   %eax,%eax
  8039a4:	0f 85 e9 fc ff ff    	jne    803693 <alloc_block_FF+0xc0>
  8039aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039ae:	0f 85 df fc ff ff    	jne    803693 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8039b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b7:	83 c0 08             	add    $0x8,%eax
  8039ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8039bd:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8039c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039ca:	01 d0                	add    %edx,%eax
  8039cc:	48                   	dec    %eax
  8039cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8039d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8039d8:	f7 75 d8             	divl   -0x28(%ebp)
  8039db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039de:	29 d0                	sub    %edx,%eax
  8039e0:	c1 e8 0c             	shr    $0xc,%eax
  8039e3:	83 ec 0c             	sub    $0xc,%esp
  8039e6:	50                   	push   %eax
  8039e7:	e8 1e ec ff ff       	call   80260a <sbrk>
  8039ec:	83 c4 10             	add    $0x10,%esp
  8039ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8039f2:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8039f6:	75 0a                	jne    803a02 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8039f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039fd:	e9 8b 00 00 00       	jmp    803a8d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803a02:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  803a09:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803a0f:	01 d0                	add    %edx,%eax
  803a11:	48                   	dec    %eax
  803a12:	89 45 c8             	mov    %eax,-0x38(%ebp)
  803a15:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a18:	ba 00 00 00 00       	mov    $0x0,%edx
  803a1d:	f7 75 cc             	divl   -0x34(%ebp)
  803a20:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a23:	29 d0                	sub    %edx,%eax
  803a25:	8d 50 fc             	lea    -0x4(%eax),%edx
  803a28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a2b:	01 d0                	add    %edx,%eax
  803a2d:	a3 44 60 80 00       	mov    %eax,0x806044
			end_block->info = 1;
  803a32:	a1 44 60 80 00       	mov    0x806044,%eax
  803a37:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803a3d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803a44:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a47:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803a4a:	01 d0                	add    %edx,%eax
  803a4c:	48                   	dec    %eax
  803a4d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803a50:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a53:	ba 00 00 00 00       	mov    $0x0,%edx
  803a58:	f7 75 c4             	divl   -0x3c(%ebp)
  803a5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803a5e:	29 d0                	sub    %edx,%eax
  803a60:	83 ec 04             	sub    $0x4,%esp
  803a63:	6a 01                	push   $0x1
  803a65:	50                   	push   %eax
  803a66:	ff 75 d0             	pushl  -0x30(%ebp)
  803a69:	e8 36 fb ff ff       	call   8035a4 <set_block_data>
  803a6e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803a71:	83 ec 0c             	sub    $0xc,%esp
  803a74:	ff 75 d0             	pushl  -0x30(%ebp)
  803a77:	e8 1b 0a 00 00       	call   804497 <free_block>
  803a7c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803a7f:	83 ec 0c             	sub    $0xc,%esp
  803a82:	ff 75 08             	pushl  0x8(%ebp)
  803a85:	e8 49 fb ff ff       	call   8035d3 <alloc_block_FF>
  803a8a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803a8d:	c9                   	leave  
  803a8e:	c3                   	ret    

00803a8f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803a8f:	55                   	push   %ebp
  803a90:	89 e5                	mov    %esp,%ebp
  803a92:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803a95:	8b 45 08             	mov    0x8(%ebp),%eax
  803a98:	83 e0 01             	and    $0x1,%eax
  803a9b:	85 c0                	test   %eax,%eax
  803a9d:	74 03                	je     803aa2 <alloc_block_BF+0x13>
  803a9f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803aa2:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803aa6:	77 07                	ja     803aaf <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803aa8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803aaf:	a1 28 60 80 00       	mov    0x806028,%eax
  803ab4:	85 c0                	test   %eax,%eax
  803ab6:	75 73                	jne    803b2b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  803abb:	83 c0 10             	add    $0x10,%eax
  803abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803ac1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803ac8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803acb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ace:	01 d0                	add    %edx,%eax
  803ad0:	48                   	dec    %eax
  803ad1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803ad4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ad7:	ba 00 00 00 00       	mov    $0x0,%edx
  803adc:	f7 75 e0             	divl   -0x20(%ebp)
  803adf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ae2:	29 d0                	sub    %edx,%eax
  803ae4:	c1 e8 0c             	shr    $0xc,%eax
  803ae7:	83 ec 0c             	sub    $0xc,%esp
  803aea:	50                   	push   %eax
  803aeb:	e8 1a eb ff ff       	call   80260a <sbrk>
  803af0:	83 c4 10             	add    $0x10,%esp
  803af3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803af6:	83 ec 0c             	sub    $0xc,%esp
  803af9:	6a 00                	push   $0x0
  803afb:	e8 0a eb ff ff       	call   80260a <sbrk>
  803b00:	83 c4 10             	add    $0x10,%esp
  803b03:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803b06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b09:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803b0c:	83 ec 08             	sub    $0x8,%esp
  803b0f:	50                   	push   %eax
  803b10:	ff 75 d8             	pushl  -0x28(%ebp)
  803b13:	e8 9f f8 ff ff       	call   8033b7 <initialize_dynamic_allocator>
  803b18:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803b1b:	83 ec 0c             	sub    $0xc,%esp
  803b1e:	68 1b 59 80 00       	push   $0x80591b
  803b23:	e8 48 dd ff ff       	call   801870 <cprintf>
  803b28:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803b2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803b32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803b39:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803b40:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803b47:	a1 30 60 80 00       	mov    0x806030,%eax
  803b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b4f:	e9 1d 01 00 00       	jmp    803c71 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b57:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803b5a:	83 ec 0c             	sub    $0xc,%esp
  803b5d:	ff 75 a8             	pushl  -0x58(%ebp)
  803b60:	e8 ee f6 ff ff       	call   803253 <get_block_size>
  803b65:	83 c4 10             	add    $0x10,%esp
  803b68:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6e:	83 c0 08             	add    $0x8,%eax
  803b71:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803b74:	0f 87 ef 00 00 00    	ja     803c69 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7d:	83 c0 18             	add    $0x18,%eax
  803b80:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803b83:	77 1d                	ja     803ba2 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b88:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803b8b:	0f 86 d8 00 00 00    	jbe    803c69 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803b91:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803b94:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803b97:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803b9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803b9d:	e9 c7 00 00 00       	jmp    803c69 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba5:	83 c0 08             	add    $0x8,%eax
  803ba8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803bab:	0f 85 9d 00 00 00    	jne    803c4e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803bb1:	83 ec 04             	sub    $0x4,%esp
  803bb4:	6a 01                	push   $0x1
  803bb6:	ff 75 a4             	pushl  -0x5c(%ebp)
  803bb9:	ff 75 a8             	pushl  -0x58(%ebp)
  803bbc:	e8 e3 f9 ff ff       	call   8035a4 <set_block_data>
  803bc1:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bc8:	75 17                	jne    803be1 <alloc_block_BF+0x152>
  803bca:	83 ec 04             	sub    $0x4,%esp
  803bcd:	68 bf 58 80 00       	push   $0x8058bf
  803bd2:	68 2c 01 00 00       	push   $0x12c
  803bd7:	68 dd 58 80 00       	push   $0x8058dd
  803bdc:	e8 d2 d9 ff ff       	call   8015b3 <_panic>
  803be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be4:	8b 00                	mov    (%eax),%eax
  803be6:	85 c0                	test   %eax,%eax
  803be8:	74 10                	je     803bfa <alloc_block_BF+0x16b>
  803bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bed:	8b 00                	mov    (%eax),%eax
  803bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bf2:	8b 52 04             	mov    0x4(%edx),%edx
  803bf5:	89 50 04             	mov    %edx,0x4(%eax)
  803bf8:	eb 0b                	jmp    803c05 <alloc_block_BF+0x176>
  803bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfd:	8b 40 04             	mov    0x4(%eax),%eax
  803c00:	a3 34 60 80 00       	mov    %eax,0x806034
  803c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c08:	8b 40 04             	mov    0x4(%eax),%eax
  803c0b:	85 c0                	test   %eax,%eax
  803c0d:	74 0f                	je     803c1e <alloc_block_BF+0x18f>
  803c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c12:	8b 40 04             	mov    0x4(%eax),%eax
  803c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c18:	8b 12                	mov    (%edx),%edx
  803c1a:	89 10                	mov    %edx,(%eax)
  803c1c:	eb 0a                	jmp    803c28 <alloc_block_BF+0x199>
  803c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c21:	8b 00                	mov    (%eax),%eax
  803c23:	a3 30 60 80 00       	mov    %eax,0x806030
  803c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c3b:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803c40:	48                   	dec    %eax
  803c41:	a3 3c 60 80 00       	mov    %eax,0x80603c
					return va;
  803c46:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803c49:	e9 24 04 00 00       	jmp    804072 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c51:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803c54:	76 13                	jbe    803c69 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803c56:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803c5d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803c60:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803c63:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803c66:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803c69:	a1 38 60 80 00       	mov    0x806038,%eax
  803c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c75:	74 07                	je     803c7e <alloc_block_BF+0x1ef>
  803c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7a:	8b 00                	mov    (%eax),%eax
  803c7c:	eb 05                	jmp    803c83 <alloc_block_BF+0x1f4>
  803c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  803c83:	a3 38 60 80 00       	mov    %eax,0x806038
  803c88:	a1 38 60 80 00       	mov    0x806038,%eax
  803c8d:	85 c0                	test   %eax,%eax
  803c8f:	0f 85 bf fe ff ff    	jne    803b54 <alloc_block_BF+0xc5>
  803c95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c99:	0f 85 b5 fe ff ff    	jne    803b54 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803c9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ca3:	0f 84 26 02 00 00    	je     803ecf <alloc_block_BF+0x440>
  803ca9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803cad:	0f 85 1c 02 00 00    	jne    803ecf <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cb6:	2b 45 08             	sub    0x8(%ebp),%eax
  803cb9:	83 e8 08             	sub    $0x8,%eax
  803cbc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc2:	8d 50 08             	lea    0x8(%eax),%edx
  803cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cc8:	01 d0                	add    %edx,%eax
  803cca:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd0:	83 c0 08             	add    $0x8,%eax
  803cd3:	83 ec 04             	sub    $0x4,%esp
  803cd6:	6a 01                	push   $0x1
  803cd8:	50                   	push   %eax
  803cd9:	ff 75 f0             	pushl  -0x10(%ebp)
  803cdc:	e8 c3 f8 ff ff       	call   8035a4 <set_block_data>
  803ce1:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ce7:	8b 40 04             	mov    0x4(%eax),%eax
  803cea:	85 c0                	test   %eax,%eax
  803cec:	75 68                	jne    803d56 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803cee:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803cf2:	75 17                	jne    803d0b <alloc_block_BF+0x27c>
  803cf4:	83 ec 04             	sub    $0x4,%esp
  803cf7:	68 f8 58 80 00       	push   $0x8058f8
  803cfc:	68 45 01 00 00       	push   $0x145
  803d01:	68 dd 58 80 00       	push   $0x8058dd
  803d06:	e8 a8 d8 ff ff       	call   8015b3 <_panic>
  803d0b:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803d11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d14:	89 10                	mov    %edx,(%eax)
  803d16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d19:	8b 00                	mov    (%eax),%eax
  803d1b:	85 c0                	test   %eax,%eax
  803d1d:	74 0d                	je     803d2c <alloc_block_BF+0x29d>
  803d1f:	a1 30 60 80 00       	mov    0x806030,%eax
  803d24:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803d27:	89 50 04             	mov    %edx,0x4(%eax)
  803d2a:	eb 08                	jmp    803d34 <alloc_block_BF+0x2a5>
  803d2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d2f:	a3 34 60 80 00       	mov    %eax,0x806034
  803d34:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d37:	a3 30 60 80 00       	mov    %eax,0x806030
  803d3c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d46:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803d4b:	40                   	inc    %eax
  803d4c:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803d51:	e9 dc 00 00 00       	jmp    803e32 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d59:	8b 00                	mov    (%eax),%eax
  803d5b:	85 c0                	test   %eax,%eax
  803d5d:	75 65                	jne    803dc4 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803d5f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803d63:	75 17                	jne    803d7c <alloc_block_BF+0x2ed>
  803d65:	83 ec 04             	sub    $0x4,%esp
  803d68:	68 2c 59 80 00       	push   $0x80592c
  803d6d:	68 4a 01 00 00       	push   $0x14a
  803d72:	68 dd 58 80 00       	push   $0x8058dd
  803d77:	e8 37 d8 ff ff       	call   8015b3 <_panic>
  803d7c:	8b 15 34 60 80 00    	mov    0x806034,%edx
  803d82:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d85:	89 50 04             	mov    %edx,0x4(%eax)
  803d88:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d8b:	8b 40 04             	mov    0x4(%eax),%eax
  803d8e:	85 c0                	test   %eax,%eax
  803d90:	74 0c                	je     803d9e <alloc_block_BF+0x30f>
  803d92:	a1 34 60 80 00       	mov    0x806034,%eax
  803d97:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803d9a:	89 10                	mov    %edx,(%eax)
  803d9c:	eb 08                	jmp    803da6 <alloc_block_BF+0x317>
  803d9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803da1:	a3 30 60 80 00       	mov    %eax,0x806030
  803da6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803da9:	a3 34 60 80 00       	mov    %eax,0x806034
  803dae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803db1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803db7:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803dbc:	40                   	inc    %eax
  803dbd:	a3 3c 60 80 00       	mov    %eax,0x80603c
  803dc2:	eb 6e                	jmp    803e32 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803dc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803dc8:	74 06                	je     803dd0 <alloc_block_BF+0x341>
  803dca:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803dce:	75 17                	jne    803de7 <alloc_block_BF+0x358>
  803dd0:	83 ec 04             	sub    $0x4,%esp
  803dd3:	68 50 59 80 00       	push   $0x805950
  803dd8:	68 4f 01 00 00       	push   $0x14f
  803ddd:	68 dd 58 80 00       	push   $0x8058dd
  803de2:	e8 cc d7 ff ff       	call   8015b3 <_panic>
  803de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dea:	8b 10                	mov    (%eax),%edx
  803dec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803def:	89 10                	mov    %edx,(%eax)
  803df1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803df4:	8b 00                	mov    (%eax),%eax
  803df6:	85 c0                	test   %eax,%eax
  803df8:	74 0b                	je     803e05 <alloc_block_BF+0x376>
  803dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dfd:	8b 00                	mov    (%eax),%eax
  803dff:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803e02:	89 50 04             	mov    %edx,0x4(%eax)
  803e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e08:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803e0b:	89 10                	mov    %edx,(%eax)
  803e0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e13:	89 50 04             	mov    %edx,0x4(%eax)
  803e16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e19:	8b 00                	mov    (%eax),%eax
  803e1b:	85 c0                	test   %eax,%eax
  803e1d:	75 08                	jne    803e27 <alloc_block_BF+0x398>
  803e1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803e22:	a3 34 60 80 00       	mov    %eax,0x806034
  803e27:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803e2c:	40                   	inc    %eax
  803e2d:	a3 3c 60 80 00       	mov    %eax,0x80603c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803e32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e36:	75 17                	jne    803e4f <alloc_block_BF+0x3c0>
  803e38:	83 ec 04             	sub    $0x4,%esp
  803e3b:	68 bf 58 80 00       	push   $0x8058bf
  803e40:	68 51 01 00 00       	push   $0x151
  803e45:	68 dd 58 80 00       	push   $0x8058dd
  803e4a:	e8 64 d7 ff ff       	call   8015b3 <_panic>
  803e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e52:	8b 00                	mov    (%eax),%eax
  803e54:	85 c0                	test   %eax,%eax
  803e56:	74 10                	je     803e68 <alloc_block_BF+0x3d9>
  803e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e5b:	8b 00                	mov    (%eax),%eax
  803e5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e60:	8b 52 04             	mov    0x4(%edx),%edx
  803e63:	89 50 04             	mov    %edx,0x4(%eax)
  803e66:	eb 0b                	jmp    803e73 <alloc_block_BF+0x3e4>
  803e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e6b:	8b 40 04             	mov    0x4(%eax),%eax
  803e6e:	a3 34 60 80 00       	mov    %eax,0x806034
  803e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e76:	8b 40 04             	mov    0x4(%eax),%eax
  803e79:	85 c0                	test   %eax,%eax
  803e7b:	74 0f                	je     803e8c <alloc_block_BF+0x3fd>
  803e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e80:	8b 40 04             	mov    0x4(%eax),%eax
  803e83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e86:	8b 12                	mov    (%edx),%edx
  803e88:	89 10                	mov    %edx,(%eax)
  803e8a:	eb 0a                	jmp    803e96 <alloc_block_BF+0x407>
  803e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e8f:	8b 00                	mov    (%eax),%eax
  803e91:	a3 30 60 80 00       	mov    %eax,0x806030
  803e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ea2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ea9:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803eae:	48                   	dec    %eax
  803eaf:	a3 3c 60 80 00       	mov    %eax,0x80603c
			set_block_data(new_block_va, remaining_size, 0);
  803eb4:	83 ec 04             	sub    $0x4,%esp
  803eb7:	6a 00                	push   $0x0
  803eb9:	ff 75 d0             	pushl  -0x30(%ebp)
  803ebc:	ff 75 cc             	pushl  -0x34(%ebp)
  803ebf:	e8 e0 f6 ff ff       	call   8035a4 <set_block_data>
  803ec4:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eca:	e9 a3 01 00 00       	jmp    804072 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803ecf:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803ed3:	0f 85 9d 00 00 00    	jne    803f76 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803ed9:	83 ec 04             	sub    $0x4,%esp
  803edc:	6a 01                	push   $0x1
  803ede:	ff 75 ec             	pushl  -0x14(%ebp)
  803ee1:	ff 75 f0             	pushl  -0x10(%ebp)
  803ee4:	e8 bb f6 ff ff       	call   8035a4 <set_block_data>
  803ee9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803eec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ef0:	75 17                	jne    803f09 <alloc_block_BF+0x47a>
  803ef2:	83 ec 04             	sub    $0x4,%esp
  803ef5:	68 bf 58 80 00       	push   $0x8058bf
  803efa:	68 58 01 00 00       	push   $0x158
  803eff:	68 dd 58 80 00       	push   $0x8058dd
  803f04:	e8 aa d6 ff ff       	call   8015b3 <_panic>
  803f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f0c:	8b 00                	mov    (%eax),%eax
  803f0e:	85 c0                	test   %eax,%eax
  803f10:	74 10                	je     803f22 <alloc_block_BF+0x493>
  803f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f15:	8b 00                	mov    (%eax),%eax
  803f17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f1a:	8b 52 04             	mov    0x4(%edx),%edx
  803f1d:	89 50 04             	mov    %edx,0x4(%eax)
  803f20:	eb 0b                	jmp    803f2d <alloc_block_BF+0x49e>
  803f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f25:	8b 40 04             	mov    0x4(%eax),%eax
  803f28:	a3 34 60 80 00       	mov    %eax,0x806034
  803f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f30:	8b 40 04             	mov    0x4(%eax),%eax
  803f33:	85 c0                	test   %eax,%eax
  803f35:	74 0f                	je     803f46 <alloc_block_BF+0x4b7>
  803f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f3a:	8b 40 04             	mov    0x4(%eax),%eax
  803f3d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f40:	8b 12                	mov    (%edx),%edx
  803f42:	89 10                	mov    %edx,(%eax)
  803f44:	eb 0a                	jmp    803f50 <alloc_block_BF+0x4c1>
  803f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f49:	8b 00                	mov    (%eax),%eax
  803f4b:	a3 30 60 80 00       	mov    %eax,0x806030
  803f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f63:	a1 3c 60 80 00       	mov    0x80603c,%eax
  803f68:	48                   	dec    %eax
  803f69:	a3 3c 60 80 00       	mov    %eax,0x80603c
		return best_va;
  803f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f71:	e9 fc 00 00 00       	jmp    804072 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803f76:	8b 45 08             	mov    0x8(%ebp),%eax
  803f79:	83 c0 08             	add    $0x8,%eax
  803f7c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803f7f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803f86:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803f89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803f8c:	01 d0                	add    %edx,%eax
  803f8e:	48                   	dec    %eax
  803f8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803f92:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803f95:	ba 00 00 00 00       	mov    $0x0,%edx
  803f9a:	f7 75 c4             	divl   -0x3c(%ebp)
  803f9d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803fa0:	29 d0                	sub    %edx,%eax
  803fa2:	c1 e8 0c             	shr    $0xc,%eax
  803fa5:	83 ec 0c             	sub    $0xc,%esp
  803fa8:	50                   	push   %eax
  803fa9:	e8 5c e6 ff ff       	call   80260a <sbrk>
  803fae:	83 c4 10             	add    $0x10,%esp
  803fb1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803fb4:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803fb8:	75 0a                	jne    803fc4 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803fba:	b8 00 00 00 00       	mov    $0x0,%eax
  803fbf:	e9 ae 00 00 00       	jmp    804072 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803fc4:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803fcb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803fce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803fd1:	01 d0                	add    %edx,%eax
  803fd3:	48                   	dec    %eax
  803fd4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803fd7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803fda:	ba 00 00 00 00       	mov    $0x0,%edx
  803fdf:	f7 75 b8             	divl   -0x48(%ebp)
  803fe2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803fe5:	29 d0                	sub    %edx,%eax
  803fe7:	8d 50 fc             	lea    -0x4(%eax),%edx
  803fea:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803fed:	01 d0                	add    %edx,%eax
  803fef:	a3 44 60 80 00       	mov    %eax,0x806044
				end_block->info = 1;
  803ff4:	a1 44 60 80 00       	mov    0x806044,%eax
  803ff9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803fff:	83 ec 0c             	sub    $0xc,%esp
  804002:	68 84 59 80 00       	push   $0x805984
  804007:	e8 64 d8 ff ff       	call   801870 <cprintf>
  80400c:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80400f:	83 ec 08             	sub    $0x8,%esp
  804012:	ff 75 bc             	pushl  -0x44(%ebp)
  804015:	68 89 59 80 00       	push   $0x805989
  80401a:	e8 51 d8 ff ff       	call   801870 <cprintf>
  80401f:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  804022:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  804029:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80402c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80402f:	01 d0                	add    %edx,%eax
  804031:	48                   	dec    %eax
  804032:	89 45 ac             	mov    %eax,-0x54(%ebp)
  804035:	8b 45 ac             	mov    -0x54(%ebp),%eax
  804038:	ba 00 00 00 00       	mov    $0x0,%edx
  80403d:	f7 75 b0             	divl   -0x50(%ebp)
  804040:	8b 45 ac             	mov    -0x54(%ebp),%eax
  804043:	29 d0                	sub    %edx,%eax
  804045:	83 ec 04             	sub    $0x4,%esp
  804048:	6a 01                	push   $0x1
  80404a:	50                   	push   %eax
  80404b:	ff 75 bc             	pushl  -0x44(%ebp)
  80404e:	e8 51 f5 ff ff       	call   8035a4 <set_block_data>
  804053:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  804056:	83 ec 0c             	sub    $0xc,%esp
  804059:	ff 75 bc             	pushl  -0x44(%ebp)
  80405c:	e8 36 04 00 00       	call   804497 <free_block>
  804061:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  804064:	83 ec 0c             	sub    $0xc,%esp
  804067:	ff 75 08             	pushl  0x8(%ebp)
  80406a:	e8 20 fa ff ff       	call   803a8f <alloc_block_BF>
  80406f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  804072:	c9                   	leave  
  804073:	c3                   	ret    

00804074 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  804074:	55                   	push   %ebp
  804075:	89 e5                	mov    %esp,%ebp
  804077:	53                   	push   %ebx
  804078:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  80407b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804082:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  804089:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80408d:	74 1e                	je     8040ad <merging+0x39>
  80408f:	ff 75 08             	pushl  0x8(%ebp)
  804092:	e8 bc f1 ff ff       	call   803253 <get_block_size>
  804097:	83 c4 04             	add    $0x4,%esp
  80409a:	89 c2                	mov    %eax,%edx
  80409c:	8b 45 08             	mov    0x8(%ebp),%eax
  80409f:	01 d0                	add    %edx,%eax
  8040a1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8040a4:	75 07                	jne    8040ad <merging+0x39>
		prev_is_free = 1;
  8040a6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8040ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8040b1:	74 1e                	je     8040d1 <merging+0x5d>
  8040b3:	ff 75 10             	pushl  0x10(%ebp)
  8040b6:	e8 98 f1 ff ff       	call   803253 <get_block_size>
  8040bb:	83 c4 04             	add    $0x4,%esp
  8040be:	89 c2                	mov    %eax,%edx
  8040c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8040c3:	01 d0                	add    %edx,%eax
  8040c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8040c8:	75 07                	jne    8040d1 <merging+0x5d>
		next_is_free = 1;
  8040ca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8040d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040d5:	0f 84 cc 00 00 00    	je     8041a7 <merging+0x133>
  8040db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8040df:	0f 84 c2 00 00 00    	je     8041a7 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8040e5:	ff 75 08             	pushl  0x8(%ebp)
  8040e8:	e8 66 f1 ff ff       	call   803253 <get_block_size>
  8040ed:	83 c4 04             	add    $0x4,%esp
  8040f0:	89 c3                	mov    %eax,%ebx
  8040f2:	ff 75 10             	pushl  0x10(%ebp)
  8040f5:	e8 59 f1 ff ff       	call   803253 <get_block_size>
  8040fa:	83 c4 04             	add    $0x4,%esp
  8040fd:	01 c3                	add    %eax,%ebx
  8040ff:	ff 75 0c             	pushl  0xc(%ebp)
  804102:	e8 4c f1 ff ff       	call   803253 <get_block_size>
  804107:	83 c4 04             	add    $0x4,%esp
  80410a:	01 d8                	add    %ebx,%eax
  80410c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  80410f:	6a 00                	push   $0x0
  804111:	ff 75 ec             	pushl  -0x14(%ebp)
  804114:	ff 75 08             	pushl  0x8(%ebp)
  804117:	e8 88 f4 ff ff       	call   8035a4 <set_block_data>
  80411c:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  80411f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804123:	75 17                	jne    80413c <merging+0xc8>
  804125:	83 ec 04             	sub    $0x4,%esp
  804128:	68 bf 58 80 00       	push   $0x8058bf
  80412d:	68 7d 01 00 00       	push   $0x17d
  804132:	68 dd 58 80 00       	push   $0x8058dd
  804137:	e8 77 d4 ff ff       	call   8015b3 <_panic>
  80413c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80413f:	8b 00                	mov    (%eax),%eax
  804141:	85 c0                	test   %eax,%eax
  804143:	74 10                	je     804155 <merging+0xe1>
  804145:	8b 45 0c             	mov    0xc(%ebp),%eax
  804148:	8b 00                	mov    (%eax),%eax
  80414a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80414d:	8b 52 04             	mov    0x4(%edx),%edx
  804150:	89 50 04             	mov    %edx,0x4(%eax)
  804153:	eb 0b                	jmp    804160 <merging+0xec>
  804155:	8b 45 0c             	mov    0xc(%ebp),%eax
  804158:	8b 40 04             	mov    0x4(%eax),%eax
  80415b:	a3 34 60 80 00       	mov    %eax,0x806034
  804160:	8b 45 0c             	mov    0xc(%ebp),%eax
  804163:	8b 40 04             	mov    0x4(%eax),%eax
  804166:	85 c0                	test   %eax,%eax
  804168:	74 0f                	je     804179 <merging+0x105>
  80416a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80416d:	8b 40 04             	mov    0x4(%eax),%eax
  804170:	8b 55 0c             	mov    0xc(%ebp),%edx
  804173:	8b 12                	mov    (%edx),%edx
  804175:	89 10                	mov    %edx,(%eax)
  804177:	eb 0a                	jmp    804183 <merging+0x10f>
  804179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80417c:	8b 00                	mov    (%eax),%eax
  80417e:	a3 30 60 80 00       	mov    %eax,0x806030
  804183:	8b 45 0c             	mov    0xc(%ebp),%eax
  804186:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80418c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80418f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804196:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80419b:	48                   	dec    %eax
  80419c:	a3 3c 60 80 00       	mov    %eax,0x80603c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8041a1:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8041a2:	e9 ea 02 00 00       	jmp    804491 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8041a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041ab:	74 3b                	je     8041e8 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8041ad:	83 ec 0c             	sub    $0xc,%esp
  8041b0:	ff 75 08             	pushl  0x8(%ebp)
  8041b3:	e8 9b f0 ff ff       	call   803253 <get_block_size>
  8041b8:	83 c4 10             	add    $0x10,%esp
  8041bb:	89 c3                	mov    %eax,%ebx
  8041bd:	83 ec 0c             	sub    $0xc,%esp
  8041c0:	ff 75 10             	pushl  0x10(%ebp)
  8041c3:	e8 8b f0 ff ff       	call   803253 <get_block_size>
  8041c8:	83 c4 10             	add    $0x10,%esp
  8041cb:	01 d8                	add    %ebx,%eax
  8041cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8041d0:	83 ec 04             	sub    $0x4,%esp
  8041d3:	6a 00                	push   $0x0
  8041d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8041d8:	ff 75 08             	pushl  0x8(%ebp)
  8041db:	e8 c4 f3 ff ff       	call   8035a4 <set_block_data>
  8041e0:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8041e3:	e9 a9 02 00 00       	jmp    804491 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8041e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8041ec:	0f 84 2d 01 00 00    	je     80431f <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8041f2:	83 ec 0c             	sub    $0xc,%esp
  8041f5:	ff 75 10             	pushl  0x10(%ebp)
  8041f8:	e8 56 f0 ff ff       	call   803253 <get_block_size>
  8041fd:	83 c4 10             	add    $0x10,%esp
  804200:	89 c3                	mov    %eax,%ebx
  804202:	83 ec 0c             	sub    $0xc,%esp
  804205:	ff 75 0c             	pushl  0xc(%ebp)
  804208:	e8 46 f0 ff ff       	call   803253 <get_block_size>
  80420d:	83 c4 10             	add    $0x10,%esp
  804210:	01 d8                	add    %ebx,%eax
  804212:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  804215:	83 ec 04             	sub    $0x4,%esp
  804218:	6a 00                	push   $0x0
  80421a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80421d:	ff 75 10             	pushl  0x10(%ebp)
  804220:	e8 7f f3 ff ff       	call   8035a4 <set_block_data>
  804225:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  804228:	8b 45 10             	mov    0x10(%ebp),%eax
  80422b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  80422e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804232:	74 06                	je     80423a <merging+0x1c6>
  804234:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  804238:	75 17                	jne    804251 <merging+0x1dd>
  80423a:	83 ec 04             	sub    $0x4,%esp
  80423d:	68 98 59 80 00       	push   $0x805998
  804242:	68 8d 01 00 00       	push   $0x18d
  804247:	68 dd 58 80 00       	push   $0x8058dd
  80424c:	e8 62 d3 ff ff       	call   8015b3 <_panic>
  804251:	8b 45 0c             	mov    0xc(%ebp),%eax
  804254:	8b 50 04             	mov    0x4(%eax),%edx
  804257:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80425a:	89 50 04             	mov    %edx,0x4(%eax)
  80425d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804260:	8b 55 0c             	mov    0xc(%ebp),%edx
  804263:	89 10                	mov    %edx,(%eax)
  804265:	8b 45 0c             	mov    0xc(%ebp),%eax
  804268:	8b 40 04             	mov    0x4(%eax),%eax
  80426b:	85 c0                	test   %eax,%eax
  80426d:	74 0d                	je     80427c <merging+0x208>
  80426f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804272:	8b 40 04             	mov    0x4(%eax),%eax
  804275:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804278:	89 10                	mov    %edx,(%eax)
  80427a:	eb 08                	jmp    804284 <merging+0x210>
  80427c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80427f:	a3 30 60 80 00       	mov    %eax,0x806030
  804284:	8b 45 0c             	mov    0xc(%ebp),%eax
  804287:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80428a:	89 50 04             	mov    %edx,0x4(%eax)
  80428d:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804292:	40                   	inc    %eax
  804293:	a3 3c 60 80 00       	mov    %eax,0x80603c
		LIST_REMOVE(&freeBlocksList, next_block);
  804298:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80429c:	75 17                	jne    8042b5 <merging+0x241>
  80429e:	83 ec 04             	sub    $0x4,%esp
  8042a1:	68 bf 58 80 00       	push   $0x8058bf
  8042a6:	68 8e 01 00 00       	push   $0x18e
  8042ab:	68 dd 58 80 00       	push   $0x8058dd
  8042b0:	e8 fe d2 ff ff       	call   8015b3 <_panic>
  8042b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042b8:	8b 00                	mov    (%eax),%eax
  8042ba:	85 c0                	test   %eax,%eax
  8042bc:	74 10                	je     8042ce <merging+0x25a>
  8042be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042c1:	8b 00                	mov    (%eax),%eax
  8042c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042c6:	8b 52 04             	mov    0x4(%edx),%edx
  8042c9:	89 50 04             	mov    %edx,0x4(%eax)
  8042cc:	eb 0b                	jmp    8042d9 <merging+0x265>
  8042ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042d1:	8b 40 04             	mov    0x4(%eax),%eax
  8042d4:	a3 34 60 80 00       	mov    %eax,0x806034
  8042d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042dc:	8b 40 04             	mov    0x4(%eax),%eax
  8042df:	85 c0                	test   %eax,%eax
  8042e1:	74 0f                	je     8042f2 <merging+0x27e>
  8042e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042e6:	8b 40 04             	mov    0x4(%eax),%eax
  8042e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042ec:	8b 12                	mov    (%edx),%edx
  8042ee:	89 10                	mov    %edx,(%eax)
  8042f0:	eb 0a                	jmp    8042fc <merging+0x288>
  8042f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042f5:	8b 00                	mov    (%eax),%eax
  8042f7:	a3 30 60 80 00       	mov    %eax,0x806030
  8042fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8042ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804305:	8b 45 0c             	mov    0xc(%ebp),%eax
  804308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80430f:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804314:	48                   	dec    %eax
  804315:	a3 3c 60 80 00       	mov    %eax,0x80603c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80431a:	e9 72 01 00 00       	jmp    804491 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80431f:	8b 45 10             	mov    0x10(%ebp),%eax
  804322:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  804325:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804329:	74 79                	je     8043a4 <merging+0x330>
  80432b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80432f:	74 73                	je     8043a4 <merging+0x330>
  804331:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804335:	74 06                	je     80433d <merging+0x2c9>
  804337:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80433b:	75 17                	jne    804354 <merging+0x2e0>
  80433d:	83 ec 04             	sub    $0x4,%esp
  804340:	68 50 59 80 00       	push   $0x805950
  804345:	68 94 01 00 00       	push   $0x194
  80434a:	68 dd 58 80 00       	push   $0x8058dd
  80434f:	e8 5f d2 ff ff       	call   8015b3 <_panic>
  804354:	8b 45 08             	mov    0x8(%ebp),%eax
  804357:	8b 10                	mov    (%eax),%edx
  804359:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80435c:	89 10                	mov    %edx,(%eax)
  80435e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804361:	8b 00                	mov    (%eax),%eax
  804363:	85 c0                	test   %eax,%eax
  804365:	74 0b                	je     804372 <merging+0x2fe>
  804367:	8b 45 08             	mov    0x8(%ebp),%eax
  80436a:	8b 00                	mov    (%eax),%eax
  80436c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80436f:	89 50 04             	mov    %edx,0x4(%eax)
  804372:	8b 45 08             	mov    0x8(%ebp),%eax
  804375:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804378:	89 10                	mov    %edx,(%eax)
  80437a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80437d:	8b 55 08             	mov    0x8(%ebp),%edx
  804380:	89 50 04             	mov    %edx,0x4(%eax)
  804383:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804386:	8b 00                	mov    (%eax),%eax
  804388:	85 c0                	test   %eax,%eax
  80438a:	75 08                	jne    804394 <merging+0x320>
  80438c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80438f:	a3 34 60 80 00       	mov    %eax,0x806034
  804394:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804399:	40                   	inc    %eax
  80439a:	a3 3c 60 80 00       	mov    %eax,0x80603c
  80439f:	e9 ce 00 00 00       	jmp    804472 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8043a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8043a8:	74 65                	je     80440f <merging+0x39b>
  8043aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8043ae:	75 17                	jne    8043c7 <merging+0x353>
  8043b0:	83 ec 04             	sub    $0x4,%esp
  8043b3:	68 2c 59 80 00       	push   $0x80592c
  8043b8:	68 95 01 00 00       	push   $0x195
  8043bd:	68 dd 58 80 00       	push   $0x8058dd
  8043c2:	e8 ec d1 ff ff       	call   8015b3 <_panic>
  8043c7:	8b 15 34 60 80 00    	mov    0x806034,%edx
  8043cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043d0:	89 50 04             	mov    %edx,0x4(%eax)
  8043d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043d6:	8b 40 04             	mov    0x4(%eax),%eax
  8043d9:	85 c0                	test   %eax,%eax
  8043db:	74 0c                	je     8043e9 <merging+0x375>
  8043dd:	a1 34 60 80 00       	mov    0x806034,%eax
  8043e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8043e5:	89 10                	mov    %edx,(%eax)
  8043e7:	eb 08                	jmp    8043f1 <merging+0x37d>
  8043e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043ec:	a3 30 60 80 00       	mov    %eax,0x806030
  8043f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043f4:	a3 34 60 80 00       	mov    %eax,0x806034
  8043f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8043fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804402:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804407:	40                   	inc    %eax
  804408:	a3 3c 60 80 00       	mov    %eax,0x80603c
  80440d:	eb 63                	jmp    804472 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80440f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804413:	75 17                	jne    80442c <merging+0x3b8>
  804415:	83 ec 04             	sub    $0x4,%esp
  804418:	68 f8 58 80 00       	push   $0x8058f8
  80441d:	68 98 01 00 00       	push   $0x198
  804422:	68 dd 58 80 00       	push   $0x8058dd
  804427:	e8 87 d1 ff ff       	call   8015b3 <_panic>
  80442c:	8b 15 30 60 80 00    	mov    0x806030,%edx
  804432:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804435:	89 10                	mov    %edx,(%eax)
  804437:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80443a:	8b 00                	mov    (%eax),%eax
  80443c:	85 c0                	test   %eax,%eax
  80443e:	74 0d                	je     80444d <merging+0x3d9>
  804440:	a1 30 60 80 00       	mov    0x806030,%eax
  804445:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804448:	89 50 04             	mov    %edx,0x4(%eax)
  80444b:	eb 08                	jmp    804455 <merging+0x3e1>
  80444d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804450:	a3 34 60 80 00       	mov    %eax,0x806034
  804455:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804458:	a3 30 60 80 00       	mov    %eax,0x806030
  80445d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804460:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804467:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80446c:	40                   	inc    %eax
  80446d:	a3 3c 60 80 00       	mov    %eax,0x80603c
		}
		set_block_data(va, get_block_size(va), 0);
  804472:	83 ec 0c             	sub    $0xc,%esp
  804475:	ff 75 10             	pushl  0x10(%ebp)
  804478:	e8 d6 ed ff ff       	call   803253 <get_block_size>
  80447d:	83 c4 10             	add    $0x10,%esp
  804480:	83 ec 04             	sub    $0x4,%esp
  804483:	6a 00                	push   $0x0
  804485:	50                   	push   %eax
  804486:	ff 75 10             	pushl  0x10(%ebp)
  804489:	e8 16 f1 ff ff       	call   8035a4 <set_block_data>
  80448e:	83 c4 10             	add    $0x10,%esp
	}
}
  804491:	90                   	nop
  804492:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  804495:	c9                   	leave  
  804496:	c3                   	ret    

00804497 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  804497:	55                   	push   %ebp
  804498:	89 e5                	mov    %esp,%ebp
  80449a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80449d:	a1 30 60 80 00       	mov    0x806030,%eax
  8044a2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8044a5:	a1 34 60 80 00       	mov    0x806034,%eax
  8044aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8044ad:	73 1b                	jae    8044ca <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8044af:	a1 34 60 80 00       	mov    0x806034,%eax
  8044b4:	83 ec 04             	sub    $0x4,%esp
  8044b7:	ff 75 08             	pushl  0x8(%ebp)
  8044ba:	6a 00                	push   $0x0
  8044bc:	50                   	push   %eax
  8044bd:	e8 b2 fb ff ff       	call   804074 <merging>
  8044c2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8044c5:	e9 8b 00 00 00       	jmp    804555 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8044ca:	a1 30 60 80 00       	mov    0x806030,%eax
  8044cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8044d2:	76 18                	jbe    8044ec <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8044d4:	a1 30 60 80 00       	mov    0x806030,%eax
  8044d9:	83 ec 04             	sub    $0x4,%esp
  8044dc:	ff 75 08             	pushl  0x8(%ebp)
  8044df:	50                   	push   %eax
  8044e0:	6a 00                	push   $0x0
  8044e2:	e8 8d fb ff ff       	call   804074 <merging>
  8044e7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8044ea:	eb 69                	jmp    804555 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8044ec:	a1 30 60 80 00       	mov    0x806030,%eax
  8044f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8044f4:	eb 39                	jmp    80452f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8044f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8044fc:	73 29                	jae    804527 <free_block+0x90>
  8044fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804501:	8b 00                	mov    (%eax),%eax
  804503:	3b 45 08             	cmp    0x8(%ebp),%eax
  804506:	76 1f                	jbe    804527 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  804508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80450b:	8b 00                	mov    (%eax),%eax
  80450d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  804510:	83 ec 04             	sub    $0x4,%esp
  804513:	ff 75 08             	pushl  0x8(%ebp)
  804516:	ff 75 f0             	pushl  -0x10(%ebp)
  804519:	ff 75 f4             	pushl  -0xc(%ebp)
  80451c:	e8 53 fb ff ff       	call   804074 <merging>
  804521:	83 c4 10             	add    $0x10,%esp
			break;
  804524:	90                   	nop
		}
	}
}
  804525:	eb 2e                	jmp    804555 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  804527:	a1 38 60 80 00       	mov    0x806038,%eax
  80452c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80452f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804533:	74 07                	je     80453c <free_block+0xa5>
  804535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804538:	8b 00                	mov    (%eax),%eax
  80453a:	eb 05                	jmp    804541 <free_block+0xaa>
  80453c:	b8 00 00 00 00       	mov    $0x0,%eax
  804541:	a3 38 60 80 00       	mov    %eax,0x806038
  804546:	a1 38 60 80 00       	mov    0x806038,%eax
  80454b:	85 c0                	test   %eax,%eax
  80454d:	75 a7                	jne    8044f6 <free_block+0x5f>
  80454f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804553:	75 a1                	jne    8044f6 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  804555:	90                   	nop
  804556:	c9                   	leave  
  804557:	c3                   	ret    

00804558 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  804558:	55                   	push   %ebp
  804559:	89 e5                	mov    %esp,%ebp
  80455b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80455e:	ff 75 08             	pushl  0x8(%ebp)
  804561:	e8 ed ec ff ff       	call   803253 <get_block_size>
  804566:	83 c4 04             	add    $0x4,%esp
  804569:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80456c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  804573:	eb 17                	jmp    80458c <copy_data+0x34>
  804575:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804578:	8b 45 0c             	mov    0xc(%ebp),%eax
  80457b:	01 c2                	add    %eax,%edx
  80457d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  804580:	8b 45 08             	mov    0x8(%ebp),%eax
  804583:	01 c8                	add    %ecx,%eax
  804585:	8a 00                	mov    (%eax),%al
  804587:	88 02                	mov    %al,(%edx)
  804589:	ff 45 fc             	incl   -0x4(%ebp)
  80458c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80458f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  804592:	72 e1                	jb     804575 <copy_data+0x1d>
}
  804594:	90                   	nop
  804595:	c9                   	leave  
  804596:	c3                   	ret    

00804597 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  804597:	55                   	push   %ebp
  804598:	89 e5                	mov    %esp,%ebp
  80459a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80459d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8045a1:	75 23                	jne    8045c6 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8045a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8045a7:	74 13                	je     8045bc <realloc_block_FF+0x25>
  8045a9:	83 ec 0c             	sub    $0xc,%esp
  8045ac:	ff 75 0c             	pushl  0xc(%ebp)
  8045af:	e8 1f f0 ff ff       	call   8035d3 <alloc_block_FF>
  8045b4:	83 c4 10             	add    $0x10,%esp
  8045b7:	e9 f4 06 00 00       	jmp    804cb0 <realloc_block_FF+0x719>
		return NULL;
  8045bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8045c1:	e9 ea 06 00 00       	jmp    804cb0 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8045c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8045ca:	75 18                	jne    8045e4 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8045cc:	83 ec 0c             	sub    $0xc,%esp
  8045cf:	ff 75 08             	pushl  0x8(%ebp)
  8045d2:	e8 c0 fe ff ff       	call   804497 <free_block>
  8045d7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8045da:	b8 00 00 00 00       	mov    $0x0,%eax
  8045df:	e9 cc 06 00 00       	jmp    804cb0 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8045e4:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8045e8:	77 07                	ja     8045f1 <realloc_block_FF+0x5a>
  8045ea:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8045f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8045f4:	83 e0 01             	and    $0x1,%eax
  8045f7:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8045fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8045fd:	83 c0 08             	add    $0x8,%eax
  804600:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  804603:	83 ec 0c             	sub    $0xc,%esp
  804606:	ff 75 08             	pushl  0x8(%ebp)
  804609:	e8 45 ec ff ff       	call   803253 <get_block_size>
  80460e:	83 c4 10             	add    $0x10,%esp
  804611:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804614:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804617:	83 e8 08             	sub    $0x8,%eax
  80461a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80461d:	8b 45 08             	mov    0x8(%ebp),%eax
  804620:	83 e8 04             	sub    $0x4,%eax
  804623:	8b 00                	mov    (%eax),%eax
  804625:	83 e0 fe             	and    $0xfffffffe,%eax
  804628:	89 c2                	mov    %eax,%edx
  80462a:	8b 45 08             	mov    0x8(%ebp),%eax
  80462d:	01 d0                	add    %edx,%eax
  80462f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  804632:	83 ec 0c             	sub    $0xc,%esp
  804635:	ff 75 e4             	pushl  -0x1c(%ebp)
  804638:	e8 16 ec ff ff       	call   803253 <get_block_size>
  80463d:	83 c4 10             	add    $0x10,%esp
  804640:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804643:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804646:	83 e8 08             	sub    $0x8,%eax
  804649:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80464c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80464f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804652:	75 08                	jne    80465c <realloc_block_FF+0xc5>
	{
		 return va;
  804654:	8b 45 08             	mov    0x8(%ebp),%eax
  804657:	e9 54 06 00 00       	jmp    804cb0 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80465c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80465f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804662:	0f 83 e5 03 00 00    	jae    804a4d <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  804668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80466b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80466e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804671:	83 ec 0c             	sub    $0xc,%esp
  804674:	ff 75 e4             	pushl  -0x1c(%ebp)
  804677:	e8 f0 eb ff ff       	call   80326c <is_free_block>
  80467c:	83 c4 10             	add    $0x10,%esp
  80467f:	84 c0                	test   %al,%al
  804681:	0f 84 3b 01 00 00    	je     8047c2 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  804687:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80468a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80468d:	01 d0                	add    %edx,%eax
  80468f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  804692:	83 ec 04             	sub    $0x4,%esp
  804695:	6a 01                	push   $0x1
  804697:	ff 75 f0             	pushl  -0x10(%ebp)
  80469a:	ff 75 08             	pushl  0x8(%ebp)
  80469d:	e8 02 ef ff ff       	call   8035a4 <set_block_data>
  8046a2:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8046a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8046a8:	83 e8 04             	sub    $0x4,%eax
  8046ab:	8b 00                	mov    (%eax),%eax
  8046ad:	83 e0 fe             	and    $0xfffffffe,%eax
  8046b0:	89 c2                	mov    %eax,%edx
  8046b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8046b5:	01 d0                	add    %edx,%eax
  8046b7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8046ba:	83 ec 04             	sub    $0x4,%esp
  8046bd:	6a 00                	push   $0x0
  8046bf:	ff 75 cc             	pushl  -0x34(%ebp)
  8046c2:	ff 75 c8             	pushl  -0x38(%ebp)
  8046c5:	e8 da ee ff ff       	call   8035a4 <set_block_data>
  8046ca:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8046cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8046d1:	74 06                	je     8046d9 <realloc_block_FF+0x142>
  8046d3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8046d7:	75 17                	jne    8046f0 <realloc_block_FF+0x159>
  8046d9:	83 ec 04             	sub    $0x4,%esp
  8046dc:	68 50 59 80 00       	push   $0x805950
  8046e1:	68 f6 01 00 00       	push   $0x1f6
  8046e6:	68 dd 58 80 00       	push   $0x8058dd
  8046eb:	e8 c3 ce ff ff       	call   8015b3 <_panic>
  8046f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046f3:	8b 10                	mov    (%eax),%edx
  8046f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8046f8:	89 10                	mov    %edx,(%eax)
  8046fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8046fd:	8b 00                	mov    (%eax),%eax
  8046ff:	85 c0                	test   %eax,%eax
  804701:	74 0b                	je     80470e <realloc_block_FF+0x177>
  804703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804706:	8b 00                	mov    (%eax),%eax
  804708:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80470b:	89 50 04             	mov    %edx,0x4(%eax)
  80470e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804711:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804714:	89 10                	mov    %edx,(%eax)
  804716:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804719:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80471c:	89 50 04             	mov    %edx,0x4(%eax)
  80471f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804722:	8b 00                	mov    (%eax),%eax
  804724:	85 c0                	test   %eax,%eax
  804726:	75 08                	jne    804730 <realloc_block_FF+0x199>
  804728:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80472b:	a3 34 60 80 00       	mov    %eax,0x806034
  804730:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804735:	40                   	inc    %eax
  804736:	a3 3c 60 80 00       	mov    %eax,0x80603c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80473b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80473f:	75 17                	jne    804758 <realloc_block_FF+0x1c1>
  804741:	83 ec 04             	sub    $0x4,%esp
  804744:	68 bf 58 80 00       	push   $0x8058bf
  804749:	68 f7 01 00 00       	push   $0x1f7
  80474e:	68 dd 58 80 00       	push   $0x8058dd
  804753:	e8 5b ce ff ff       	call   8015b3 <_panic>
  804758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80475b:	8b 00                	mov    (%eax),%eax
  80475d:	85 c0                	test   %eax,%eax
  80475f:	74 10                	je     804771 <realloc_block_FF+0x1da>
  804761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804764:	8b 00                	mov    (%eax),%eax
  804766:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804769:	8b 52 04             	mov    0x4(%edx),%edx
  80476c:	89 50 04             	mov    %edx,0x4(%eax)
  80476f:	eb 0b                	jmp    80477c <realloc_block_FF+0x1e5>
  804771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804774:	8b 40 04             	mov    0x4(%eax),%eax
  804777:	a3 34 60 80 00       	mov    %eax,0x806034
  80477c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80477f:	8b 40 04             	mov    0x4(%eax),%eax
  804782:	85 c0                	test   %eax,%eax
  804784:	74 0f                	je     804795 <realloc_block_FF+0x1fe>
  804786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804789:	8b 40 04             	mov    0x4(%eax),%eax
  80478c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80478f:	8b 12                	mov    (%edx),%edx
  804791:	89 10                	mov    %edx,(%eax)
  804793:	eb 0a                	jmp    80479f <realloc_block_FF+0x208>
  804795:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804798:	8b 00                	mov    (%eax),%eax
  80479a:	a3 30 60 80 00       	mov    %eax,0x806030
  80479f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8047b2:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8047b7:	48                   	dec    %eax
  8047b8:	a3 3c 60 80 00       	mov    %eax,0x80603c
  8047bd:	e9 83 02 00 00       	jmp    804a45 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8047c2:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8047c6:	0f 86 69 02 00 00    	jbe    804a35 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8047cc:	83 ec 04             	sub    $0x4,%esp
  8047cf:	6a 01                	push   $0x1
  8047d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8047d4:	ff 75 08             	pushl  0x8(%ebp)
  8047d7:	e8 c8 ed ff ff       	call   8035a4 <set_block_data>
  8047dc:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8047df:	8b 45 08             	mov    0x8(%ebp),%eax
  8047e2:	83 e8 04             	sub    $0x4,%eax
  8047e5:	8b 00                	mov    (%eax),%eax
  8047e7:	83 e0 fe             	and    $0xfffffffe,%eax
  8047ea:	89 c2                	mov    %eax,%edx
  8047ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8047ef:	01 d0                	add    %edx,%eax
  8047f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8047f4:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8047f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8047fc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804800:	75 68                	jne    80486a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804802:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804806:	75 17                	jne    80481f <realloc_block_FF+0x288>
  804808:	83 ec 04             	sub    $0x4,%esp
  80480b:	68 f8 58 80 00       	push   $0x8058f8
  804810:	68 06 02 00 00       	push   $0x206
  804815:	68 dd 58 80 00       	push   $0x8058dd
  80481a:	e8 94 cd ff ff       	call   8015b3 <_panic>
  80481f:	8b 15 30 60 80 00    	mov    0x806030,%edx
  804825:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804828:	89 10                	mov    %edx,(%eax)
  80482a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80482d:	8b 00                	mov    (%eax),%eax
  80482f:	85 c0                	test   %eax,%eax
  804831:	74 0d                	je     804840 <realloc_block_FF+0x2a9>
  804833:	a1 30 60 80 00       	mov    0x806030,%eax
  804838:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80483b:	89 50 04             	mov    %edx,0x4(%eax)
  80483e:	eb 08                	jmp    804848 <realloc_block_FF+0x2b1>
  804840:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804843:	a3 34 60 80 00       	mov    %eax,0x806034
  804848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80484b:	a3 30 60 80 00       	mov    %eax,0x806030
  804850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804853:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80485a:	a1 3c 60 80 00       	mov    0x80603c,%eax
  80485f:	40                   	inc    %eax
  804860:	a3 3c 60 80 00       	mov    %eax,0x80603c
  804865:	e9 b0 01 00 00       	jmp    804a1a <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80486a:	a1 30 60 80 00       	mov    0x806030,%eax
  80486f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804872:	76 68                	jbe    8048dc <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804874:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804878:	75 17                	jne    804891 <realloc_block_FF+0x2fa>
  80487a:	83 ec 04             	sub    $0x4,%esp
  80487d:	68 f8 58 80 00       	push   $0x8058f8
  804882:	68 0b 02 00 00       	push   $0x20b
  804887:	68 dd 58 80 00       	push   $0x8058dd
  80488c:	e8 22 cd ff ff       	call   8015b3 <_panic>
  804891:	8b 15 30 60 80 00    	mov    0x806030,%edx
  804897:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80489a:	89 10                	mov    %edx,(%eax)
  80489c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80489f:	8b 00                	mov    (%eax),%eax
  8048a1:	85 c0                	test   %eax,%eax
  8048a3:	74 0d                	je     8048b2 <realloc_block_FF+0x31b>
  8048a5:	a1 30 60 80 00       	mov    0x806030,%eax
  8048aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8048ad:	89 50 04             	mov    %edx,0x4(%eax)
  8048b0:	eb 08                	jmp    8048ba <realloc_block_FF+0x323>
  8048b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048b5:	a3 34 60 80 00       	mov    %eax,0x806034
  8048ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048bd:	a3 30 60 80 00       	mov    %eax,0x806030
  8048c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8048cc:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8048d1:	40                   	inc    %eax
  8048d2:	a3 3c 60 80 00       	mov    %eax,0x80603c
  8048d7:	e9 3e 01 00 00       	jmp    804a1a <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8048dc:	a1 30 60 80 00       	mov    0x806030,%eax
  8048e1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8048e4:	73 68                	jae    80494e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8048e6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8048ea:	75 17                	jne    804903 <realloc_block_FF+0x36c>
  8048ec:	83 ec 04             	sub    $0x4,%esp
  8048ef:	68 2c 59 80 00       	push   $0x80592c
  8048f4:	68 10 02 00 00       	push   $0x210
  8048f9:	68 dd 58 80 00       	push   $0x8058dd
  8048fe:	e8 b0 cc ff ff       	call   8015b3 <_panic>
  804903:	8b 15 34 60 80 00    	mov    0x806034,%edx
  804909:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80490c:	89 50 04             	mov    %edx,0x4(%eax)
  80490f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804912:	8b 40 04             	mov    0x4(%eax),%eax
  804915:	85 c0                	test   %eax,%eax
  804917:	74 0c                	je     804925 <realloc_block_FF+0x38e>
  804919:	a1 34 60 80 00       	mov    0x806034,%eax
  80491e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804921:	89 10                	mov    %edx,(%eax)
  804923:	eb 08                	jmp    80492d <realloc_block_FF+0x396>
  804925:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804928:	a3 30 60 80 00       	mov    %eax,0x806030
  80492d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804930:	a3 34 60 80 00       	mov    %eax,0x806034
  804935:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804938:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80493e:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804943:	40                   	inc    %eax
  804944:	a3 3c 60 80 00       	mov    %eax,0x80603c
  804949:	e9 cc 00 00 00       	jmp    804a1a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80494e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  804955:	a1 30 60 80 00       	mov    0x806030,%eax
  80495a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80495d:	e9 8a 00 00 00       	jmp    8049ec <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804965:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804968:	73 7a                	jae    8049e4 <realloc_block_FF+0x44d>
  80496a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80496d:	8b 00                	mov    (%eax),%eax
  80496f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804972:	73 70                	jae    8049e4 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804974:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804978:	74 06                	je     804980 <realloc_block_FF+0x3e9>
  80497a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80497e:	75 17                	jne    804997 <realloc_block_FF+0x400>
  804980:	83 ec 04             	sub    $0x4,%esp
  804983:	68 50 59 80 00       	push   $0x805950
  804988:	68 1a 02 00 00       	push   $0x21a
  80498d:	68 dd 58 80 00       	push   $0x8058dd
  804992:	e8 1c cc ff ff       	call   8015b3 <_panic>
  804997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80499a:	8b 10                	mov    (%eax),%edx
  80499c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80499f:	89 10                	mov    %edx,(%eax)
  8049a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049a4:	8b 00                	mov    (%eax),%eax
  8049a6:	85 c0                	test   %eax,%eax
  8049a8:	74 0b                	je     8049b5 <realloc_block_FF+0x41e>
  8049aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8049ad:	8b 00                	mov    (%eax),%eax
  8049af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8049b2:	89 50 04             	mov    %edx,0x4(%eax)
  8049b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8049b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8049bb:	89 10                	mov    %edx,(%eax)
  8049bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8049c3:	89 50 04             	mov    %edx,0x4(%eax)
  8049c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049c9:	8b 00                	mov    (%eax),%eax
  8049cb:	85 c0                	test   %eax,%eax
  8049cd:	75 08                	jne    8049d7 <realloc_block_FF+0x440>
  8049cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8049d2:	a3 34 60 80 00       	mov    %eax,0x806034
  8049d7:	a1 3c 60 80 00       	mov    0x80603c,%eax
  8049dc:	40                   	inc    %eax
  8049dd:	a3 3c 60 80 00       	mov    %eax,0x80603c
							break;
  8049e2:	eb 36                	jmp    804a1a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8049e4:	a1 38 60 80 00       	mov    0x806038,%eax
  8049e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8049ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8049f0:	74 07                	je     8049f9 <realloc_block_FF+0x462>
  8049f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8049f5:	8b 00                	mov    (%eax),%eax
  8049f7:	eb 05                	jmp    8049fe <realloc_block_FF+0x467>
  8049f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8049fe:	a3 38 60 80 00       	mov    %eax,0x806038
  804a03:	a1 38 60 80 00       	mov    0x806038,%eax
  804a08:	85 c0                	test   %eax,%eax
  804a0a:	0f 85 52 ff ff ff    	jne    804962 <realloc_block_FF+0x3cb>
  804a10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804a14:	0f 85 48 ff ff ff    	jne    804962 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  804a1a:	83 ec 04             	sub    $0x4,%esp
  804a1d:	6a 00                	push   $0x0
  804a1f:	ff 75 d8             	pushl  -0x28(%ebp)
  804a22:	ff 75 d4             	pushl  -0x2c(%ebp)
  804a25:	e8 7a eb ff ff       	call   8035a4 <set_block_data>
  804a2a:	83 c4 10             	add    $0x10,%esp
				return va;
  804a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  804a30:	e9 7b 02 00 00       	jmp    804cb0 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  804a35:	83 ec 0c             	sub    $0xc,%esp
  804a38:	68 cd 59 80 00       	push   $0x8059cd
  804a3d:	e8 2e ce ff ff       	call   801870 <cprintf>
  804a42:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  804a45:	8b 45 08             	mov    0x8(%ebp),%eax
  804a48:	e9 63 02 00 00       	jmp    804cb0 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804a50:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804a53:	0f 86 4d 02 00 00    	jbe    804ca6 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804a59:	83 ec 0c             	sub    $0xc,%esp
  804a5c:	ff 75 e4             	pushl  -0x1c(%ebp)
  804a5f:	e8 08 e8 ff ff       	call   80326c <is_free_block>
  804a64:	83 c4 10             	add    $0x10,%esp
  804a67:	84 c0                	test   %al,%al
  804a69:	0f 84 37 02 00 00    	je     804ca6 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804a72:	2b 45 e8             	sub    -0x18(%ebp),%eax
  804a75:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804a78:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804a7b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804a7e:	76 38                	jbe    804ab8 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804a80:	83 ec 0c             	sub    $0xc,%esp
  804a83:	ff 75 08             	pushl  0x8(%ebp)
  804a86:	e8 0c fa ff ff       	call   804497 <free_block>
  804a8b:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804a8e:	83 ec 0c             	sub    $0xc,%esp
  804a91:	ff 75 0c             	pushl  0xc(%ebp)
  804a94:	e8 3a eb ff ff       	call   8035d3 <alloc_block_FF>
  804a99:	83 c4 10             	add    $0x10,%esp
  804a9c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804a9f:	83 ec 08             	sub    $0x8,%esp
  804aa2:	ff 75 c0             	pushl  -0x40(%ebp)
  804aa5:	ff 75 08             	pushl  0x8(%ebp)
  804aa8:	e8 ab fa ff ff       	call   804558 <copy_data>
  804aad:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804ab0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  804ab3:	e9 f8 01 00 00       	jmp    804cb0 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804ab8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804abb:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804abe:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804ac1:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  804ac5:	0f 87 a0 00 00 00    	ja     804b6b <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804acb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804acf:	75 17                	jne    804ae8 <realloc_block_FF+0x551>
  804ad1:	83 ec 04             	sub    $0x4,%esp
  804ad4:	68 bf 58 80 00       	push   $0x8058bf
  804ad9:	68 38 02 00 00       	push   $0x238
  804ade:	68 dd 58 80 00       	push   $0x8058dd
  804ae3:	e8 cb ca ff ff       	call   8015b3 <_panic>
  804ae8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804aeb:	8b 00                	mov    (%eax),%eax
  804aed:	85 c0                	test   %eax,%eax
  804aef:	74 10                	je     804b01 <realloc_block_FF+0x56a>
  804af1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804af4:	8b 00                	mov    (%eax),%eax
  804af6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804af9:	8b 52 04             	mov    0x4(%edx),%edx
  804afc:	89 50 04             	mov    %edx,0x4(%eax)
  804aff:	eb 0b                	jmp    804b0c <realloc_block_FF+0x575>
  804b01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b04:	8b 40 04             	mov    0x4(%eax),%eax
  804b07:	a3 34 60 80 00       	mov    %eax,0x806034
  804b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b0f:	8b 40 04             	mov    0x4(%eax),%eax
  804b12:	85 c0                	test   %eax,%eax
  804b14:	74 0f                	je     804b25 <realloc_block_FF+0x58e>
  804b16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b19:	8b 40 04             	mov    0x4(%eax),%eax
  804b1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b1f:	8b 12                	mov    (%edx),%edx
  804b21:	89 10                	mov    %edx,(%eax)
  804b23:	eb 0a                	jmp    804b2f <realloc_block_FF+0x598>
  804b25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b28:	8b 00                	mov    (%eax),%eax
  804b2a:	a3 30 60 80 00       	mov    %eax,0x806030
  804b2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804b42:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804b47:	48                   	dec    %eax
  804b48:	a3 3c 60 80 00       	mov    %eax,0x80603c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804b4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804b50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804b53:	01 d0                	add    %edx,%eax
  804b55:	83 ec 04             	sub    $0x4,%esp
  804b58:	6a 01                	push   $0x1
  804b5a:	50                   	push   %eax
  804b5b:	ff 75 08             	pushl  0x8(%ebp)
  804b5e:	e8 41 ea ff ff       	call   8035a4 <set_block_data>
  804b63:	83 c4 10             	add    $0x10,%esp
  804b66:	e9 36 01 00 00       	jmp    804ca1 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804b6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804b6e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804b71:	01 d0                	add    %edx,%eax
  804b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804b76:	83 ec 04             	sub    $0x4,%esp
  804b79:	6a 01                	push   $0x1
  804b7b:	ff 75 f0             	pushl  -0x10(%ebp)
  804b7e:	ff 75 08             	pushl  0x8(%ebp)
  804b81:	e8 1e ea ff ff       	call   8035a4 <set_block_data>
  804b86:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804b89:	8b 45 08             	mov    0x8(%ebp),%eax
  804b8c:	83 e8 04             	sub    $0x4,%eax
  804b8f:	8b 00                	mov    (%eax),%eax
  804b91:	83 e0 fe             	and    $0xfffffffe,%eax
  804b94:	89 c2                	mov    %eax,%edx
  804b96:	8b 45 08             	mov    0x8(%ebp),%eax
  804b99:	01 d0                	add    %edx,%eax
  804b9b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804b9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804ba2:	74 06                	je     804baa <realloc_block_FF+0x613>
  804ba4:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804ba8:	75 17                	jne    804bc1 <realloc_block_FF+0x62a>
  804baa:	83 ec 04             	sub    $0x4,%esp
  804bad:	68 50 59 80 00       	push   $0x805950
  804bb2:	68 44 02 00 00       	push   $0x244
  804bb7:	68 dd 58 80 00       	push   $0x8058dd
  804bbc:	e8 f2 c9 ff ff       	call   8015b3 <_panic>
  804bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bc4:	8b 10                	mov    (%eax),%edx
  804bc6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804bc9:	89 10                	mov    %edx,(%eax)
  804bcb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804bce:	8b 00                	mov    (%eax),%eax
  804bd0:	85 c0                	test   %eax,%eax
  804bd2:	74 0b                	je     804bdf <realloc_block_FF+0x648>
  804bd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bd7:	8b 00                	mov    (%eax),%eax
  804bd9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804bdc:	89 50 04             	mov    %edx,0x4(%eax)
  804bdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804be2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804be5:	89 10                	mov    %edx,(%eax)
  804be7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804bea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804bed:	89 50 04             	mov    %edx,0x4(%eax)
  804bf0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804bf3:	8b 00                	mov    (%eax),%eax
  804bf5:	85 c0                	test   %eax,%eax
  804bf7:	75 08                	jne    804c01 <realloc_block_FF+0x66a>
  804bf9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804bfc:	a3 34 60 80 00       	mov    %eax,0x806034
  804c01:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804c06:	40                   	inc    %eax
  804c07:	a3 3c 60 80 00       	mov    %eax,0x80603c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804c0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804c10:	75 17                	jne    804c29 <realloc_block_FF+0x692>
  804c12:	83 ec 04             	sub    $0x4,%esp
  804c15:	68 bf 58 80 00       	push   $0x8058bf
  804c1a:	68 45 02 00 00       	push   $0x245
  804c1f:	68 dd 58 80 00       	push   $0x8058dd
  804c24:	e8 8a c9 ff ff       	call   8015b3 <_panic>
  804c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c2c:	8b 00                	mov    (%eax),%eax
  804c2e:	85 c0                	test   %eax,%eax
  804c30:	74 10                	je     804c42 <realloc_block_FF+0x6ab>
  804c32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c35:	8b 00                	mov    (%eax),%eax
  804c37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804c3a:	8b 52 04             	mov    0x4(%edx),%edx
  804c3d:	89 50 04             	mov    %edx,0x4(%eax)
  804c40:	eb 0b                	jmp    804c4d <realloc_block_FF+0x6b6>
  804c42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c45:	8b 40 04             	mov    0x4(%eax),%eax
  804c48:	a3 34 60 80 00       	mov    %eax,0x806034
  804c4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c50:	8b 40 04             	mov    0x4(%eax),%eax
  804c53:	85 c0                	test   %eax,%eax
  804c55:	74 0f                	je     804c66 <realloc_block_FF+0x6cf>
  804c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c5a:	8b 40 04             	mov    0x4(%eax),%eax
  804c5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804c60:	8b 12                	mov    (%edx),%edx
  804c62:	89 10                	mov    %edx,(%eax)
  804c64:	eb 0a                	jmp    804c70 <realloc_block_FF+0x6d9>
  804c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c69:	8b 00                	mov    (%eax),%eax
  804c6b:	a3 30 60 80 00       	mov    %eax,0x806030
  804c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804c83:	a1 3c 60 80 00       	mov    0x80603c,%eax
  804c88:	48                   	dec    %eax
  804c89:	a3 3c 60 80 00       	mov    %eax,0x80603c
				set_block_data(next_new_va, remaining_size, 0);
  804c8e:	83 ec 04             	sub    $0x4,%esp
  804c91:	6a 00                	push   $0x0
  804c93:	ff 75 bc             	pushl  -0x44(%ebp)
  804c96:	ff 75 b8             	pushl  -0x48(%ebp)
  804c99:	e8 06 e9 ff ff       	call   8035a4 <set_block_data>
  804c9e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  804ca4:	eb 0a                	jmp    804cb0 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804ca6:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804cad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804cb0:	c9                   	leave  
  804cb1:	c3                   	ret    

00804cb2 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804cb2:	55                   	push   %ebp
  804cb3:	89 e5                	mov    %esp,%ebp
  804cb5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804cb8:	83 ec 04             	sub    $0x4,%esp
  804cbb:	68 d4 59 80 00       	push   $0x8059d4
  804cc0:	68 58 02 00 00       	push   $0x258
  804cc5:	68 dd 58 80 00       	push   $0x8058dd
  804cca:	e8 e4 c8 ff ff       	call   8015b3 <_panic>

00804ccf <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804ccf:	55                   	push   %ebp
  804cd0:	89 e5                	mov    %esp,%ebp
  804cd2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804cd5:	83 ec 04             	sub    $0x4,%esp
  804cd8:	68 fc 59 80 00       	push   $0x8059fc
  804cdd:	68 61 02 00 00       	push   $0x261
  804ce2:	68 dd 58 80 00       	push   $0x8058dd
  804ce7:	e8 c7 c8 ff ff       	call   8015b3 <_panic>

00804cec <__udivdi3>:
  804cec:	55                   	push   %ebp
  804ced:	57                   	push   %edi
  804cee:	56                   	push   %esi
  804cef:	53                   	push   %ebx
  804cf0:	83 ec 1c             	sub    $0x1c,%esp
  804cf3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804cf7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804cfb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804cff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804d03:	89 ca                	mov    %ecx,%edx
  804d05:	89 f8                	mov    %edi,%eax
  804d07:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804d0b:	85 f6                	test   %esi,%esi
  804d0d:	75 2d                	jne    804d3c <__udivdi3+0x50>
  804d0f:	39 cf                	cmp    %ecx,%edi
  804d11:	77 65                	ja     804d78 <__udivdi3+0x8c>
  804d13:	89 fd                	mov    %edi,%ebp
  804d15:	85 ff                	test   %edi,%edi
  804d17:	75 0b                	jne    804d24 <__udivdi3+0x38>
  804d19:	b8 01 00 00 00       	mov    $0x1,%eax
  804d1e:	31 d2                	xor    %edx,%edx
  804d20:	f7 f7                	div    %edi
  804d22:	89 c5                	mov    %eax,%ebp
  804d24:	31 d2                	xor    %edx,%edx
  804d26:	89 c8                	mov    %ecx,%eax
  804d28:	f7 f5                	div    %ebp
  804d2a:	89 c1                	mov    %eax,%ecx
  804d2c:	89 d8                	mov    %ebx,%eax
  804d2e:	f7 f5                	div    %ebp
  804d30:	89 cf                	mov    %ecx,%edi
  804d32:	89 fa                	mov    %edi,%edx
  804d34:	83 c4 1c             	add    $0x1c,%esp
  804d37:	5b                   	pop    %ebx
  804d38:	5e                   	pop    %esi
  804d39:	5f                   	pop    %edi
  804d3a:	5d                   	pop    %ebp
  804d3b:	c3                   	ret    
  804d3c:	39 ce                	cmp    %ecx,%esi
  804d3e:	77 28                	ja     804d68 <__udivdi3+0x7c>
  804d40:	0f bd fe             	bsr    %esi,%edi
  804d43:	83 f7 1f             	xor    $0x1f,%edi
  804d46:	75 40                	jne    804d88 <__udivdi3+0x9c>
  804d48:	39 ce                	cmp    %ecx,%esi
  804d4a:	72 0a                	jb     804d56 <__udivdi3+0x6a>
  804d4c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804d50:	0f 87 9e 00 00 00    	ja     804df4 <__udivdi3+0x108>
  804d56:	b8 01 00 00 00       	mov    $0x1,%eax
  804d5b:	89 fa                	mov    %edi,%edx
  804d5d:	83 c4 1c             	add    $0x1c,%esp
  804d60:	5b                   	pop    %ebx
  804d61:	5e                   	pop    %esi
  804d62:	5f                   	pop    %edi
  804d63:	5d                   	pop    %ebp
  804d64:	c3                   	ret    
  804d65:	8d 76 00             	lea    0x0(%esi),%esi
  804d68:	31 ff                	xor    %edi,%edi
  804d6a:	31 c0                	xor    %eax,%eax
  804d6c:	89 fa                	mov    %edi,%edx
  804d6e:	83 c4 1c             	add    $0x1c,%esp
  804d71:	5b                   	pop    %ebx
  804d72:	5e                   	pop    %esi
  804d73:	5f                   	pop    %edi
  804d74:	5d                   	pop    %ebp
  804d75:	c3                   	ret    
  804d76:	66 90                	xchg   %ax,%ax
  804d78:	89 d8                	mov    %ebx,%eax
  804d7a:	f7 f7                	div    %edi
  804d7c:	31 ff                	xor    %edi,%edi
  804d7e:	89 fa                	mov    %edi,%edx
  804d80:	83 c4 1c             	add    $0x1c,%esp
  804d83:	5b                   	pop    %ebx
  804d84:	5e                   	pop    %esi
  804d85:	5f                   	pop    %edi
  804d86:	5d                   	pop    %ebp
  804d87:	c3                   	ret    
  804d88:	bd 20 00 00 00       	mov    $0x20,%ebp
  804d8d:	89 eb                	mov    %ebp,%ebx
  804d8f:	29 fb                	sub    %edi,%ebx
  804d91:	89 f9                	mov    %edi,%ecx
  804d93:	d3 e6                	shl    %cl,%esi
  804d95:	89 c5                	mov    %eax,%ebp
  804d97:	88 d9                	mov    %bl,%cl
  804d99:	d3 ed                	shr    %cl,%ebp
  804d9b:	89 e9                	mov    %ebp,%ecx
  804d9d:	09 f1                	or     %esi,%ecx
  804d9f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804da3:	89 f9                	mov    %edi,%ecx
  804da5:	d3 e0                	shl    %cl,%eax
  804da7:	89 c5                	mov    %eax,%ebp
  804da9:	89 d6                	mov    %edx,%esi
  804dab:	88 d9                	mov    %bl,%cl
  804dad:	d3 ee                	shr    %cl,%esi
  804daf:	89 f9                	mov    %edi,%ecx
  804db1:	d3 e2                	shl    %cl,%edx
  804db3:	8b 44 24 08          	mov    0x8(%esp),%eax
  804db7:	88 d9                	mov    %bl,%cl
  804db9:	d3 e8                	shr    %cl,%eax
  804dbb:	09 c2                	or     %eax,%edx
  804dbd:	89 d0                	mov    %edx,%eax
  804dbf:	89 f2                	mov    %esi,%edx
  804dc1:	f7 74 24 0c          	divl   0xc(%esp)
  804dc5:	89 d6                	mov    %edx,%esi
  804dc7:	89 c3                	mov    %eax,%ebx
  804dc9:	f7 e5                	mul    %ebp
  804dcb:	39 d6                	cmp    %edx,%esi
  804dcd:	72 19                	jb     804de8 <__udivdi3+0xfc>
  804dcf:	74 0b                	je     804ddc <__udivdi3+0xf0>
  804dd1:	89 d8                	mov    %ebx,%eax
  804dd3:	31 ff                	xor    %edi,%edi
  804dd5:	e9 58 ff ff ff       	jmp    804d32 <__udivdi3+0x46>
  804dda:	66 90                	xchg   %ax,%ax
  804ddc:	8b 54 24 08          	mov    0x8(%esp),%edx
  804de0:	89 f9                	mov    %edi,%ecx
  804de2:	d3 e2                	shl    %cl,%edx
  804de4:	39 c2                	cmp    %eax,%edx
  804de6:	73 e9                	jae    804dd1 <__udivdi3+0xe5>
  804de8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804deb:	31 ff                	xor    %edi,%edi
  804ded:	e9 40 ff ff ff       	jmp    804d32 <__udivdi3+0x46>
  804df2:	66 90                	xchg   %ax,%ax
  804df4:	31 c0                	xor    %eax,%eax
  804df6:	e9 37 ff ff ff       	jmp    804d32 <__udivdi3+0x46>
  804dfb:	90                   	nop

00804dfc <__umoddi3>:
  804dfc:	55                   	push   %ebp
  804dfd:	57                   	push   %edi
  804dfe:	56                   	push   %esi
  804dff:	53                   	push   %ebx
  804e00:	83 ec 1c             	sub    $0x1c,%esp
  804e03:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804e07:	8b 74 24 34          	mov    0x34(%esp),%esi
  804e0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804e0f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804e13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804e17:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804e1b:	89 f3                	mov    %esi,%ebx
  804e1d:	89 fa                	mov    %edi,%edx
  804e1f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804e23:	89 34 24             	mov    %esi,(%esp)
  804e26:	85 c0                	test   %eax,%eax
  804e28:	75 1a                	jne    804e44 <__umoddi3+0x48>
  804e2a:	39 f7                	cmp    %esi,%edi
  804e2c:	0f 86 a2 00 00 00    	jbe    804ed4 <__umoddi3+0xd8>
  804e32:	89 c8                	mov    %ecx,%eax
  804e34:	89 f2                	mov    %esi,%edx
  804e36:	f7 f7                	div    %edi
  804e38:	89 d0                	mov    %edx,%eax
  804e3a:	31 d2                	xor    %edx,%edx
  804e3c:	83 c4 1c             	add    $0x1c,%esp
  804e3f:	5b                   	pop    %ebx
  804e40:	5e                   	pop    %esi
  804e41:	5f                   	pop    %edi
  804e42:	5d                   	pop    %ebp
  804e43:	c3                   	ret    
  804e44:	39 f0                	cmp    %esi,%eax
  804e46:	0f 87 ac 00 00 00    	ja     804ef8 <__umoddi3+0xfc>
  804e4c:	0f bd e8             	bsr    %eax,%ebp
  804e4f:	83 f5 1f             	xor    $0x1f,%ebp
  804e52:	0f 84 ac 00 00 00    	je     804f04 <__umoddi3+0x108>
  804e58:	bf 20 00 00 00       	mov    $0x20,%edi
  804e5d:	29 ef                	sub    %ebp,%edi
  804e5f:	89 fe                	mov    %edi,%esi
  804e61:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804e65:	89 e9                	mov    %ebp,%ecx
  804e67:	d3 e0                	shl    %cl,%eax
  804e69:	89 d7                	mov    %edx,%edi
  804e6b:	89 f1                	mov    %esi,%ecx
  804e6d:	d3 ef                	shr    %cl,%edi
  804e6f:	09 c7                	or     %eax,%edi
  804e71:	89 e9                	mov    %ebp,%ecx
  804e73:	d3 e2                	shl    %cl,%edx
  804e75:	89 14 24             	mov    %edx,(%esp)
  804e78:	89 d8                	mov    %ebx,%eax
  804e7a:	d3 e0                	shl    %cl,%eax
  804e7c:	89 c2                	mov    %eax,%edx
  804e7e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804e82:	d3 e0                	shl    %cl,%eax
  804e84:	89 44 24 04          	mov    %eax,0x4(%esp)
  804e88:	8b 44 24 08          	mov    0x8(%esp),%eax
  804e8c:	89 f1                	mov    %esi,%ecx
  804e8e:	d3 e8                	shr    %cl,%eax
  804e90:	09 d0                	or     %edx,%eax
  804e92:	d3 eb                	shr    %cl,%ebx
  804e94:	89 da                	mov    %ebx,%edx
  804e96:	f7 f7                	div    %edi
  804e98:	89 d3                	mov    %edx,%ebx
  804e9a:	f7 24 24             	mull   (%esp)
  804e9d:	89 c6                	mov    %eax,%esi
  804e9f:	89 d1                	mov    %edx,%ecx
  804ea1:	39 d3                	cmp    %edx,%ebx
  804ea3:	0f 82 87 00 00 00    	jb     804f30 <__umoddi3+0x134>
  804ea9:	0f 84 91 00 00 00    	je     804f40 <__umoddi3+0x144>
  804eaf:	8b 54 24 04          	mov    0x4(%esp),%edx
  804eb3:	29 f2                	sub    %esi,%edx
  804eb5:	19 cb                	sbb    %ecx,%ebx
  804eb7:	89 d8                	mov    %ebx,%eax
  804eb9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804ebd:	d3 e0                	shl    %cl,%eax
  804ebf:	89 e9                	mov    %ebp,%ecx
  804ec1:	d3 ea                	shr    %cl,%edx
  804ec3:	09 d0                	or     %edx,%eax
  804ec5:	89 e9                	mov    %ebp,%ecx
  804ec7:	d3 eb                	shr    %cl,%ebx
  804ec9:	89 da                	mov    %ebx,%edx
  804ecb:	83 c4 1c             	add    $0x1c,%esp
  804ece:	5b                   	pop    %ebx
  804ecf:	5e                   	pop    %esi
  804ed0:	5f                   	pop    %edi
  804ed1:	5d                   	pop    %ebp
  804ed2:	c3                   	ret    
  804ed3:	90                   	nop
  804ed4:	89 fd                	mov    %edi,%ebp
  804ed6:	85 ff                	test   %edi,%edi
  804ed8:	75 0b                	jne    804ee5 <__umoddi3+0xe9>
  804eda:	b8 01 00 00 00       	mov    $0x1,%eax
  804edf:	31 d2                	xor    %edx,%edx
  804ee1:	f7 f7                	div    %edi
  804ee3:	89 c5                	mov    %eax,%ebp
  804ee5:	89 f0                	mov    %esi,%eax
  804ee7:	31 d2                	xor    %edx,%edx
  804ee9:	f7 f5                	div    %ebp
  804eeb:	89 c8                	mov    %ecx,%eax
  804eed:	f7 f5                	div    %ebp
  804eef:	89 d0                	mov    %edx,%eax
  804ef1:	e9 44 ff ff ff       	jmp    804e3a <__umoddi3+0x3e>
  804ef6:	66 90                	xchg   %ax,%ax
  804ef8:	89 c8                	mov    %ecx,%eax
  804efa:	89 f2                	mov    %esi,%edx
  804efc:	83 c4 1c             	add    $0x1c,%esp
  804eff:	5b                   	pop    %ebx
  804f00:	5e                   	pop    %esi
  804f01:	5f                   	pop    %edi
  804f02:	5d                   	pop    %ebp
  804f03:	c3                   	ret    
  804f04:	3b 04 24             	cmp    (%esp),%eax
  804f07:	72 06                	jb     804f0f <__umoddi3+0x113>
  804f09:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804f0d:	77 0f                	ja     804f1e <__umoddi3+0x122>
  804f0f:	89 f2                	mov    %esi,%edx
  804f11:	29 f9                	sub    %edi,%ecx
  804f13:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804f17:	89 14 24             	mov    %edx,(%esp)
  804f1a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804f1e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804f22:	8b 14 24             	mov    (%esp),%edx
  804f25:	83 c4 1c             	add    $0x1c,%esp
  804f28:	5b                   	pop    %ebx
  804f29:	5e                   	pop    %esi
  804f2a:	5f                   	pop    %edi
  804f2b:	5d                   	pop    %ebp
  804f2c:	c3                   	ret    
  804f2d:	8d 76 00             	lea    0x0(%esi),%esi
  804f30:	2b 04 24             	sub    (%esp),%eax
  804f33:	19 fa                	sbb    %edi,%edx
  804f35:	89 d1                	mov    %edx,%ecx
  804f37:	89 c6                	mov    %eax,%esi
  804f39:	e9 71 ff ff ff       	jmp    804eaf <__umoddi3+0xb3>
  804f3e:	66 90                	xchg   %ax,%ax
  804f40:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804f44:	72 ea                	jb     804f30 <__umoddi3+0x134>
  804f46:	89 d9                	mov    %ebx,%ecx
  804f48:	e9 62 ff ff ff       	jmp    804eaf <__umoddi3+0xb3>
