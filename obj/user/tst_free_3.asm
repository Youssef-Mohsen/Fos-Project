
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
  8000a3:	68 20 4e 80 00       	push   $0x804e20
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 61 4e 80 00       	push   $0x804e61
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
  8000d9:	68 20 4e 80 00       	push   $0x804e20
  8000de:	6a 21                	push   $0x21
  8000e0:	68 61 4e 80 00       	push   $0x804e61
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
  80010f:	68 20 4e 80 00       	push   $0x804e20
  800114:	6a 22                	push   $0x22
  800116:	68 61 4e 80 00       	push   $0x804e61
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
  800145:	68 20 4e 80 00       	push   $0x804e20
  80014a:	6a 23                	push   $0x23
  80014c:	68 61 4e 80 00       	push   $0x804e61
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
  80017b:	68 20 4e 80 00       	push   $0x804e20
  800180:	6a 24                	push   $0x24
  800182:	68 61 4e 80 00       	push   $0x804e61
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
  8001b1:	68 20 4e 80 00       	push   $0x804e20
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 61 4e 80 00       	push   $0x804e61
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
  8001e9:	68 20 4e 80 00       	push   $0x804e20
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 61 4e 80 00       	push   $0x804e61
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
  800221:	68 20 4e 80 00       	push   $0x804e20
  800226:	6a 27                	push   $0x27
  800228:	68 61 4e 80 00       	push   $0x804e61
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
  800259:	68 20 4e 80 00       	push   $0x804e20
  80025e:	6a 28                	push   $0x28
  800260:	68 61 4e 80 00       	push   $0x804e61
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
  800291:	68 20 4e 80 00       	push   $0x804e20
  800296:	6a 29                	push   $0x29
  800298:	68 61 4e 80 00       	push   $0x804e61
  80029d:	e8 11 13 00 00       	call   8015b3 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8002a7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 74 4e 80 00       	push   $0x804e74
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 61 4e 80 00       	push   $0x804e61
  8002c0:	e8 ee 12 00 00       	call   8015b3 <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 38 29 00 00       	call   802c02 <sys_calculate_free_frames>
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
  8002e1:	e8 67 29 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  80031d:	68 bc 4e 80 00       	push   $0x804ebc
  800322:	6a 39                	push   $0x39
  800324:	68 61 4e 80 00       	push   $0x804e61
  800329:	e8 85 12 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 1a 29 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 24 4f 80 00       	push   $0x804f24
  800345:	6a 3a                	push   $0x3a
  800347:	68 61 4e 80 00       	push   $0x804e61
  80034c:	e8 62 12 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 f7 28 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  8003a6:	68 bc 4e 80 00       	push   $0x804ebc
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 61 4e 80 00       	push   $0x804e61
  8003b2:	e8 fc 11 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 91 28 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  8003dd:	68 24 4f 80 00       	push   $0x804f24
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 61 4e 80 00       	push   $0x804e61
  8003e9:	e8 c5 11 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 5a 28 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  80044a:	68 bc 4e 80 00       	push   $0x804ebc
  80044f:	6a 47                	push   $0x47
  800451:	68 61 4e 80 00       	push   $0x804e61
  800456:	e8 58 11 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 ed 27 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  80047e:	68 24 4f 80 00       	push   $0x804f24
  800483:	6a 48                	push   $0x48
  800485:	68 61 4e 80 00       	push   $0x804e61
  80048a:	e8 24 11 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 b9 27 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  8004fa:	68 bc 4e 80 00       	push   $0x804ebc
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 61 4e 80 00       	push   $0x804e61
  800506:	e8 a8 10 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 3d 27 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  800535:	68 24 4f 80 00       	push   $0x804f24
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 61 4e 80 00       	push   $0x804e61
  800541:	e8 6d 10 00 00       	call   8015b3 <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 b7 26 00 00       	call   802c02 <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 c8 26 00 00       	call   802c1b <sys_calculate_modified_frames>
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
  80060f:	e8 ee 25 00 00       	call   802c02 <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 00 26 00 00       	call   802c1b <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 54 4f 80 00       	push   $0x804f54
  80062e:	6a 67                	push   $0x67
  800630:	68 61 4e 80 00       	push   $0x804e61
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
  8006d8:	68 98 4f 80 00       	push   $0x804f98
  8006dd:	6a 73                	push   $0x73
  8006df:	68 61 4e 80 00       	push   $0x804e61
  8006e4:	e8 ca 0e 00 00       	call   8015b3 <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e9:	e8 14 25 00 00       	call   802c02 <sys_calculate_free_frames>
  8006ee:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006f1:	e8 25 25 00 00       	call   802c1b <sys_calculate_modified_frames>
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
  8007f2:	e8 0b 24 00 00       	call   802c02 <sys_calculate_free_frames>
  8007f7:	29 c3                	sub    %eax,%ebx
  8007f9:	89 d8                	mov    %ebx,%eax
  8007fb:	83 f8 04             	cmp    $0x4,%eax
  8007fe:	74 17                	je     800817 <_main+0x7df>
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	68 54 4f 80 00       	push   $0x804f54
  800808:	68 8e 00 00 00       	push   $0x8e
  80080d:	68 61 4e 80 00       	push   $0x804e61
  800812:	e8 9c 0d 00 00       	call   8015b3 <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800817:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  80081a:	e8 fc 23 00 00       	call   802c1b <sys_calculate_modified_frames>
  80081f:	29 c3                	sub    %eax,%ebx
  800821:	89 d8                	mov    %ebx,%eax
  800823:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800826:	74 17                	je     80083f <_main+0x807>
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 54 4f 80 00       	push   $0x804f54
  800830:	68 8f 00 00 00       	push   $0x8f
  800835:	68 61 4e 80 00       	push   $0x804e61
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
  8008df:	68 98 4f 80 00       	push   $0x804f98
  8008e4:	68 9b 00 00 00       	push   $0x9b
  8008e9:	68 61 4e 80 00       	push   $0x804e61
  8008ee:	e8 c0 0c 00 00       	call   8015b3 <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008f3:	e8 0a 23 00 00       	call   802c02 <sys_calculate_free_frames>
  8008f8:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008fb:	e8 1b 23 00 00       	call   802c1b <sys_calculate_modified_frames>
  800900:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800903:	e8 45 23 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
  800908:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  80090b:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800911:	83 ec 0c             	sub    $0xc,%esp
  800914:	50                   	push   %eax
  800915:	e8 25 1f 00 00       	call   80283f <free>
  80091a:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80091d:	e8 2b 23 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  800945:	68 b8 4f 80 00       	push   $0x804fb8
  80094a:	68 a5 00 00 00       	push   $0xa5
  80094f:	68 61 4e 80 00       	push   $0x804e61
  800954:	e8 5a 0c 00 00       	call   8015b3 <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  800959:	e8 a4 22 00 00       	call   802c02 <sys_calculate_free_frames>
  80095e:	89 c2                	mov    %eax,%edx
  800960:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800963:	29 c2                	sub    %eax,%edx
  800965:	89 d0                	mov    %edx,%eax
  800967:	83 f8 07             	cmp    $0x7,%eax
  80096a:	74 17                	je     800983 <_main+0x94b>
  80096c:	83 ec 04             	sub    $0x4,%esp
  80096f:	68 f4 4f 80 00       	push   $0x804ff4
  800974:	68 a7 00 00 00       	push   $0xa7
  800979:	68 61 4e 80 00       	push   $0x804e61
  80097e:	e8 30 0c 00 00       	call   8015b3 <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800983:	e8 93 22 00 00       	call   802c1b <sys_calculate_modified_frames>
  800988:	89 c2                	mov    %eax,%edx
  80098a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80098d:	29 c2                	sub    %eax,%edx
  80098f:	89 d0                	mov    %edx,%eax
  800991:	83 f8 02             	cmp    $0x2,%eax
  800994:	74 17                	je     8009ad <_main+0x975>
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	68 48 50 80 00       	push   $0x805048
  80099e:	68 a8 00 00 00       	push   $0xa8
  8009a3:	68 61 4e 80 00       	push   $0x804e61
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
  800a1c:	68 80 50 80 00       	push   $0x805080
  800a21:	68 b0 00 00 00       	push   $0xb0
  800a26:	68 61 4e 80 00       	push   $0x804e61
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
  800a56:	e8 a7 21 00 00       	call   802c02 <sys_calculate_free_frames>
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
  800aa3:	e8 5a 21 00 00       	call   802c02 <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 02             	cmp    $0x2,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 54 4f 80 00       	push   $0x804f54
  800ab9:	68 bc 00 00 00       	push   $0xbc
  800abe:	68 61 4e 80 00       	push   $0x804e61
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
  800ba1:	68 98 4f 80 00       	push   $0x804f98
  800ba6:	68 c5 00 00 00       	push   $0xc5
  800bab:	68 61 4e 80 00       	push   $0x804e61
  800bb0:	e8 fe 09 00 00       	call   8015b3 <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bb5:	e8 93 20 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  800c05:	68 bc 4e 80 00       	push   $0x804ebc
  800c0a:	68 ca 00 00 00       	push   $0xca
  800c0f:	68 61 4e 80 00       	push   $0x804e61
  800c14:	e8 9a 09 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c19:	e8 2f 20 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
  800c1e:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c21:	83 f8 01             	cmp    $0x1,%eax
  800c24:	74 17                	je     800c3d <_main+0xc05>
  800c26:	83 ec 04             	sub    $0x4,%esp
  800c29:	68 24 4f 80 00       	push   $0x804f24
  800c2e:	68 cb 00 00 00       	push   $0xcb
  800c33:	68 61 4e 80 00       	push   $0x804e61
  800c38:	e8 76 09 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c3d:	e8 c0 1f 00 00       	call   802c02 <sys_calculate_free_frames>
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
  800c88:	e8 75 1f 00 00       	call   802c02 <sys_calculate_free_frames>
  800c8d:	29 c3                	sub    %eax,%ebx
  800c8f:	89 d8                	mov    %ebx,%eax
  800c91:	83 f8 02             	cmp    $0x2,%eax
  800c94:	74 17                	je     800cad <_main+0xc75>
  800c96:	83 ec 04             	sub    $0x4,%esp
  800c99:	68 54 4f 80 00       	push   $0x804f54
  800c9e:	68 d2 00 00 00       	push   $0xd2
  800ca3:	68 61 4e 80 00       	push   $0x804e61
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
  800d89:	68 98 4f 80 00       	push   $0x804f98
  800d8e:	68 db 00 00 00       	push   $0xdb
  800d93:	68 61 4e 80 00       	push   $0x804e61
  800d98:	e8 16 08 00 00       	call   8015b3 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d9d:	e8 60 1e 00 00       	call   802c02 <sys_calculate_free_frames>
  800da2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800da5:	e8 a3 1e 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  800e09:	68 bc 4e 80 00       	push   $0x804ebc
  800e0e:	68 e1 00 00 00       	push   $0xe1
  800e13:	68 61 4e 80 00       	push   $0x804e61
  800e18:	e8 96 07 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e1d:	e8 2b 1e 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
  800e22:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e25:	83 f8 01             	cmp    $0x1,%eax
  800e28:	74 17                	je     800e41 <_main+0xe09>
  800e2a:	83 ec 04             	sub    $0x4,%esp
  800e2d:	68 24 4f 80 00       	push   $0x804f24
  800e32:	68 e2 00 00 00       	push   $0xe2
  800e37:	68 61 4e 80 00       	push   $0x804e61
  800e3c:	e8 72 07 00 00       	call   8015b3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e41:	e8 07 1e 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  800ead:	68 bc 4e 80 00       	push   $0x804ebc
  800eb2:	68 e8 00 00 00       	push   $0xe8
  800eb7:	68 61 4e 80 00       	push   $0x804e61
  800ebc:	e8 f2 06 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ec1:	e8 87 1d 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
  800ec6:	2b 45 90             	sub    -0x70(%ebp),%eax
  800ec9:	83 f8 02             	cmp    $0x2,%eax
  800ecc:	74 17                	je     800ee5 <_main+0xead>
  800ece:	83 ec 04             	sub    $0x4,%esp
  800ed1:	68 24 4f 80 00       	push   $0x804f24
  800ed6:	68 e9 00 00 00       	push   $0xe9
  800edb:	68 61 4e 80 00       	push   $0x804e61
  800ee0:	e8 ce 06 00 00       	call   8015b3 <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800ee5:	e8 18 1d 00 00       	call   802c02 <sys_calculate_free_frames>
  800eea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800eed:	e8 5b 1d 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  800f58:	68 bc 4e 80 00       	push   $0x804ebc
  800f5d:	68 f0 00 00 00       	push   $0xf0
  800f62:	68 61 4e 80 00       	push   $0x804e61
  800f67:	e8 47 06 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f6c:	e8 dc 1c 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  800f92:	68 24 4f 80 00       	push   $0x804f24
  800f97:	68 f1 00 00 00       	push   $0xf1
  800f9c:	68 61 4e 80 00       	push   $0x804e61
  800fa1:	e8 0d 06 00 00       	call   8015b3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800fa6:	e8 a2 1c 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  801021:	68 bc 4e 80 00       	push   $0x804ebc
  801026:	68 f7 00 00 00       	push   $0xf7
  80102b:	68 61 4e 80 00       	push   $0x804e61
  801030:	e8 7e 05 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  801035:	e8 13 1c 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  80105d:	68 24 4f 80 00       	push   $0x804f24
  801062:	68 f8 00 00 00       	push   $0xf8
  801067:	68 61 4e 80 00       	push   $0x804e61
  80106c:	e8 42 05 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801071:	e8 8c 1b 00 00       	call   802c02 <sys_calculate_free_frames>
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
  8010e2:	e8 1b 1b 00 00       	call   802c02 <sys_calculate_free_frames>
  8010e7:	29 c3                	sub    %eax,%ebx
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	83 f8 05             	cmp    $0x5,%eax
  8010ee:	74 17                	je     801107 <_main+0x10cf>
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 54 4f 80 00       	push   $0x804f54
  8010f8:	68 00 01 00 00       	push   $0x100
  8010fd:	68 61 4e 80 00       	push   $0x804e61
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
  80123b:	68 98 4f 80 00       	push   $0x804f98
  801240:	68 0b 01 00 00       	push   $0x10b
  801245:	68 61 4e 80 00       	push   $0x804e61
  80124a:	e8 64 03 00 00       	call   8015b3 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80124f:	e8 f9 19 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
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
  8012cd:	68 bc 4e 80 00       	push   $0x804ebc
  8012d2:	68 10 01 00 00       	push   $0x110
  8012d7:	68 61 4e 80 00       	push   $0x804e61
  8012dc:	e8 d2 02 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012e1:	e8 67 19 00 00       	call   802c4d <sys_pf_calculate_allocated_pages>
  8012e6:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012e9:	83 f8 04             	cmp    $0x4,%eax
  8012ec:	74 17                	je     801305 <_main+0x12cd>
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 24 4f 80 00       	push   $0x804f24
  8012f6:	68 11 01 00 00       	push   $0x111
  8012fb:	68 61 4e 80 00       	push   $0x804e61
  801300:	e8 ae 02 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801305:	e8 f8 18 00 00       	call   802c02 <sys_calculate_free_frames>
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
  801359:	e8 a4 18 00 00       	call   802c02 <sys_calculate_free_frames>
  80135e:	29 c3                	sub    %eax,%ebx
  801360:	89 d8                	mov    %ebx,%eax
  801362:	83 f8 02             	cmp    $0x2,%eax
  801365:	74 17                	je     80137e <_main+0x1346>
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	68 54 4f 80 00       	push   $0x804f54
  80136f:	68 18 01 00 00       	push   $0x118
  801374:	68 61 4e 80 00       	push   $0x804e61
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
  801457:	68 98 4f 80 00       	push   $0x804f98
  80145c:	68 21 01 00 00       	push   $0x121
  801461:	68 61 4e 80 00       	push   $0x804e61
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
  80147a:	e8 4c 19 00 00       	call   802dcb <sys_getenvindex>
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
  8014e8:	e8 62 16 00 00       	call   802b4f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8014ed:	83 ec 0c             	sub    $0xc,%esp
  8014f0:	68 bc 50 80 00       	push   $0x8050bc
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
  801518:	68 e4 50 80 00       	push   $0x8050e4
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
  801549:	68 0c 51 80 00       	push   $0x80510c
  80154e:	e8 1d 03 00 00       	call   801870 <cprintf>
  801553:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801556:	a1 20 60 80 00       	mov    0x806020,%eax
  80155b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	50                   	push   %eax
  801565:	68 64 51 80 00       	push   $0x805164
  80156a:	e8 01 03 00 00       	call   801870 <cprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 bc 50 80 00       	push   $0x8050bc
  80157a:	e8 f1 02 00 00       	call   801870 <cprintf>
  80157f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801582:	e8 e2 15 00 00       	call   802b69 <sys_unlock_cons>
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
  80159a:	e8 f8 17 00 00       	call   802d97 <sys_destroy_env>
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
  8015ab:	e8 4d 18 00 00       	call   802dfd <sys_exit_env>
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
  8015d4:	68 78 51 80 00       	push   $0x805178
  8015d9:	e8 92 02 00 00       	call   801870 <cprintf>
  8015de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015e1:	a1 00 60 80 00       	mov    0x806000,%eax
  8015e6:	ff 75 0c             	pushl  0xc(%ebp)
  8015e9:	ff 75 08             	pushl  0x8(%ebp)
  8015ec:	50                   	push   %eax
  8015ed:	68 7d 51 80 00       	push   $0x80517d
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
  801611:	68 99 51 80 00       	push   $0x805199
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
  801640:	68 9c 51 80 00       	push   $0x80519c
  801645:	6a 26                	push   $0x26
  801647:	68 e8 51 80 00       	push   $0x8051e8
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
  801715:	68 f4 51 80 00       	push   $0x8051f4
  80171a:	6a 3a                	push   $0x3a
  80171c:	68 e8 51 80 00       	push   $0x8051e8
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
  801788:	68 48 52 80 00       	push   $0x805248
  80178d:	6a 44                	push   $0x44
  80178f:	68 e8 51 80 00       	push   $0x8051e8
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
  8017e2:	e8 26 13 00 00       	call   802b0d <sys_cputs>
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
  801859:	e8 af 12 00 00       	call   802b0d <sys_cputs>
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
  8018a3:	e8 a7 12 00 00       	call   802b4f <sys_lock_cons>
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
  8018c3:	e8 a1 12 00 00       	call   802b69 <sys_unlock_cons>
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
  80190d:	e8 92 32 00 00       	call   804ba4 <__udivdi3>
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
  80195d:	e8 52 33 00 00       	call   804cb4 <__umoddi3>
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	05 b4 54 80 00       	add    $0x8054b4,%eax
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
  801ab8:	8b 04 85 d8 54 80 00 	mov    0x8054d8(,%eax,4),%eax
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
  801b99:	8b 34 9d 20 53 80 00 	mov    0x805320(,%ebx,4),%esi
  801ba0:	85 f6                	test   %esi,%esi
  801ba2:	75 19                	jne    801bbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801ba4:	53                   	push   %ebx
  801ba5:	68 c5 54 80 00       	push   $0x8054c5
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
  801bbe:	68 ce 54 80 00       	push   $0x8054ce
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
  801beb:	be d1 54 80 00       	mov    $0x8054d1,%esi
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
  8025f6:	68 48 56 80 00       	push   $0x805648
  8025fb:	68 3f 01 00 00       	push   $0x13f
  802600:	68 6a 56 80 00       	push   $0x80566a
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
  802616:	e8 9d 0a 00 00       	call   8030b8 <sys_sbrk>
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
  802691:	e8 a6 08 00 00       	call   802f3c <sys_isUHeapPlacementStrategyFIRSTFIT>
  802696:	85 c0                	test   %eax,%eax
  802698:	74 16                	je     8026b0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80269a:	83 ec 0c             	sub    $0xc,%esp
  80269d:	ff 75 08             	pushl  0x8(%ebp)
  8026a0:	e8 e6 0d 00 00       	call   80348b <alloc_block_FF>
  8026a5:	83 c4 10             	add    $0x10,%esp
  8026a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ab:	e9 8a 01 00 00       	jmp    80283a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8026b0:	e8 b8 08 00 00       	call   802f6d <sys_isUHeapPlacementStrategyBESTFIT>
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	0f 84 7d 01 00 00    	je     80283a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	ff 75 08             	pushl  0x8(%ebp)
  8026c3:	e8 7f 12 00 00       	call   803947 <alloc_block_BF>
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
  802713:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
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
  802760:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
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
  8027b7:	c7 04 85 60 60 80 00 	movl   $0x1,0x806060(,%eax,4)
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
  802819:	89 04 95 60 60 88 00 	mov    %eax,0x886060(,%edx,4)
		sys_allocate_user_mem(i, size);
  802820:	83 ec 08             	sub    $0x8,%esp
  802823:	ff 75 08             	pushl  0x8(%ebp)
  802826:	ff 75 f0             	pushl  -0x10(%ebp)
  802829:	e8 c1 08 00 00       	call   8030ef <sys_allocate_user_mem>
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
  802871:	e8 95 08 00 00       	call   80310b <get_block_size>
  802876:	83 c4 10             	add    $0x10,%esp
  802879:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80287c:	83 ec 0c             	sub    $0xc,%esp
  80287f:	ff 75 08             	pushl  0x8(%ebp)
  802882:	e8 c8 1a 00 00       	call   80434f <free_block>
  802887:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  8028bc:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  8028c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8028c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c9:	c1 e0 0c             	shl    $0xc,%eax
  8028cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8028cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028d6:	eb 2f                	jmp    802907 <free+0xc8>
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
  8028f9:	c7 04 85 60 60 80 00 	movl   $0x0,0x806060(,%eax,4)
  802900:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  802904:	ff 45 f4             	incl   -0xc(%ebp)
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80290d:	72 c9                	jb     8028d8 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	83 ec 08             	sub    $0x8,%esp
  802915:	ff 75 ec             	pushl  -0x14(%ebp)
  802918:	50                   	push   %eax
  802919:	e8 b5 07 00 00       	call   8030d3 <sys_free_user_mem>
  80291e:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  802921:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  802922:	eb 17                	jmp    80293b <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  802924:	83 ec 04             	sub    $0x4,%esp
  802927:	68 78 56 80 00       	push   $0x805678
  80292c:	68 84 00 00 00       	push   $0x84
  802931:	68 a2 56 80 00       	push   $0x8056a2
  802936:	e8 78 ec ff ff       	call   8015b3 <_panic>
	}
}
  80293b:	c9                   	leave  
  80293c:	c3                   	ret    

0080293d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80293d:	55                   	push   %ebp
  80293e:	89 e5                	mov    %esp,%ebp
  802940:	83 ec 28             	sub    $0x28,%esp
  802943:	8b 45 10             	mov    0x10(%ebp),%eax
  802946:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802949:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80294d:	75 07                	jne    802956 <smalloc+0x19>
  80294f:	b8 00 00 00 00       	mov    $0x0,%eax
  802954:	eb 74                	jmp    8029ca <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802956:	8b 45 0c             	mov    0xc(%ebp),%eax
  802959:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802963:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	39 d0                	cmp    %edx,%eax
  80296b:	73 02                	jae    80296f <smalloc+0x32>
  80296d:	89 d0                	mov    %edx,%eax
  80296f:	83 ec 0c             	sub    $0xc,%esp
  802972:	50                   	push   %eax
  802973:	e8 a8 fc ff ff       	call   802620 <malloc>
  802978:	83 c4 10             	add    $0x10,%esp
  80297b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80297e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802982:	75 07                	jne    80298b <smalloc+0x4e>
  802984:	b8 00 00 00 00       	mov    $0x0,%eax
  802989:	eb 3f                	jmp    8029ca <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80298b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80298f:	ff 75 ec             	pushl  -0x14(%ebp)
  802992:	50                   	push   %eax
  802993:	ff 75 0c             	pushl  0xc(%ebp)
  802996:	ff 75 08             	pushl  0x8(%ebp)
  802999:	e8 3c 03 00 00       	call   802cda <sys_createSharedObject>
  80299e:	83 c4 10             	add    $0x10,%esp
  8029a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8029a4:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8029a8:	74 06                	je     8029b0 <smalloc+0x73>
  8029aa:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8029ae:	75 07                	jne    8029b7 <smalloc+0x7a>
  8029b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b5:	eb 13                	jmp    8029ca <smalloc+0x8d>
	 cprintf("153\n");
  8029b7:	83 ec 0c             	sub    $0xc,%esp
  8029ba:	68 ae 56 80 00       	push   $0x8056ae
  8029bf:	e8 ac ee ff ff       	call   801870 <cprintf>
  8029c4:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8029c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8029ca:	c9                   	leave  
  8029cb:	c3                   	ret    

008029cc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8029cc:	55                   	push   %ebp
  8029cd:	89 e5                	mov    %esp,%ebp
  8029cf:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8029d2:	83 ec 08             	sub    $0x8,%esp
  8029d5:	ff 75 0c             	pushl  0xc(%ebp)
  8029d8:	ff 75 08             	pushl  0x8(%ebp)
  8029db:	e8 24 03 00 00       	call   802d04 <sys_getSizeOfSharedObject>
  8029e0:	83 c4 10             	add    $0x10,%esp
  8029e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8029e6:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8029ea:	75 07                	jne    8029f3 <sget+0x27>
  8029ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f1:	eb 5c                	jmp    802a4f <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8029f9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a06:	39 d0                	cmp    %edx,%eax
  802a08:	7d 02                	jge    802a0c <sget+0x40>
  802a0a:	89 d0                	mov    %edx,%eax
  802a0c:	83 ec 0c             	sub    $0xc,%esp
  802a0f:	50                   	push   %eax
  802a10:	e8 0b fc ff ff       	call   802620 <malloc>
  802a15:	83 c4 10             	add    $0x10,%esp
  802a18:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802a1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a1f:	75 07                	jne    802a28 <sget+0x5c>
  802a21:	b8 00 00 00 00       	mov    $0x0,%eax
  802a26:	eb 27                	jmp    802a4f <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802a28:	83 ec 04             	sub    $0x4,%esp
  802a2b:	ff 75 e8             	pushl  -0x18(%ebp)
  802a2e:	ff 75 0c             	pushl  0xc(%ebp)
  802a31:	ff 75 08             	pushl  0x8(%ebp)
  802a34:	e8 e8 02 00 00       	call   802d21 <sys_getSharedObject>
  802a39:	83 c4 10             	add    $0x10,%esp
  802a3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802a3f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802a43:	75 07                	jne    802a4c <sget+0x80>
  802a45:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4a:	eb 03                	jmp    802a4f <sget+0x83>
	return ptr;
  802a4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802a4f:	c9                   	leave  
  802a50:	c3                   	ret    

00802a51 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802a51:	55                   	push   %ebp
  802a52:	89 e5                	mov    %esp,%ebp
  802a54:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802a57:	83 ec 04             	sub    $0x4,%esp
  802a5a:	68 b4 56 80 00       	push   $0x8056b4
  802a5f:	68 c2 00 00 00       	push   $0xc2
  802a64:	68 a2 56 80 00       	push   $0x8056a2
  802a69:	e8 45 eb ff ff       	call   8015b3 <_panic>

00802a6e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802a6e:	55                   	push   %ebp
  802a6f:	89 e5                	mov    %esp,%ebp
  802a71:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802a74:	83 ec 04             	sub    $0x4,%esp
  802a77:	68 d8 56 80 00       	push   $0x8056d8
  802a7c:	68 d9 00 00 00       	push   $0xd9
  802a81:	68 a2 56 80 00       	push   $0x8056a2
  802a86:	e8 28 eb ff ff       	call   8015b3 <_panic>

00802a8b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
  802a8e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802a91:	83 ec 04             	sub    $0x4,%esp
  802a94:	68 fe 56 80 00       	push   $0x8056fe
  802a99:	68 e5 00 00 00       	push   $0xe5
  802a9e:	68 a2 56 80 00       	push   $0x8056a2
  802aa3:	e8 0b eb ff ff       	call   8015b3 <_panic>

00802aa8 <shrink>:

}
void shrink(uint32 newSize)
{
  802aa8:	55                   	push   %ebp
  802aa9:	89 e5                	mov    %esp,%ebp
  802aab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802aae:	83 ec 04             	sub    $0x4,%esp
  802ab1:	68 fe 56 80 00       	push   $0x8056fe
  802ab6:	68 ea 00 00 00       	push   $0xea
  802abb:	68 a2 56 80 00       	push   $0x8056a2
  802ac0:	e8 ee ea ff ff       	call   8015b3 <_panic>

00802ac5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802ac5:	55                   	push   %ebp
  802ac6:	89 e5                	mov    %esp,%ebp
  802ac8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802acb:	83 ec 04             	sub    $0x4,%esp
  802ace:	68 fe 56 80 00       	push   $0x8056fe
  802ad3:	68 ef 00 00 00       	push   $0xef
  802ad8:	68 a2 56 80 00       	push   $0x8056a2
  802add:	e8 d1 ea ff ff       	call   8015b3 <_panic>

00802ae2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802ae2:	55                   	push   %ebp
  802ae3:	89 e5                	mov    %esp,%ebp
  802ae5:	57                   	push   %edi
  802ae6:	56                   	push   %esi
  802ae7:	53                   	push   %ebx
  802ae8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802af4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802af7:	8b 7d 18             	mov    0x18(%ebp),%edi
  802afa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802afd:	cd 30                	int    $0x30
  802aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802b05:	83 c4 10             	add    $0x10,%esp
  802b08:	5b                   	pop    %ebx
  802b09:	5e                   	pop    %esi
  802b0a:	5f                   	pop    %edi
  802b0b:	5d                   	pop    %ebp
  802b0c:	c3                   	ret    

00802b0d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802b0d:	55                   	push   %ebp
  802b0e:	89 e5                	mov    %esp,%ebp
  802b10:	83 ec 04             	sub    $0x4,%esp
  802b13:	8b 45 10             	mov    0x10(%ebp),%eax
  802b16:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802b19:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	6a 00                	push   $0x0
  802b22:	6a 00                	push   $0x0
  802b24:	52                   	push   %edx
  802b25:	ff 75 0c             	pushl  0xc(%ebp)
  802b28:	50                   	push   %eax
  802b29:	6a 00                	push   $0x0
  802b2b:	e8 b2 ff ff ff       	call   802ae2 <syscall>
  802b30:	83 c4 18             	add    $0x18,%esp
}
  802b33:	90                   	nop
  802b34:	c9                   	leave  
  802b35:	c3                   	ret    

00802b36 <sys_cgetc>:

int
sys_cgetc(void)
{
  802b36:	55                   	push   %ebp
  802b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802b39:	6a 00                	push   $0x0
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	6a 02                	push   $0x2
  802b45:	e8 98 ff ff ff       	call   802ae2 <syscall>
  802b4a:	83 c4 18             	add    $0x18,%esp
}
  802b4d:	c9                   	leave  
  802b4e:	c3                   	ret    

00802b4f <sys_lock_cons>:

void sys_lock_cons(void)
{
  802b4f:	55                   	push   %ebp
  802b50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802b52:	6a 00                	push   $0x0
  802b54:	6a 00                	push   $0x0
  802b56:	6a 00                	push   $0x0
  802b58:	6a 00                	push   $0x0
  802b5a:	6a 00                	push   $0x0
  802b5c:	6a 03                	push   $0x3
  802b5e:	e8 7f ff ff ff       	call   802ae2 <syscall>
  802b63:	83 c4 18             	add    $0x18,%esp
}
  802b66:	90                   	nop
  802b67:	c9                   	leave  
  802b68:	c3                   	ret    

00802b69 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802b69:	55                   	push   %ebp
  802b6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 04                	push   $0x4
  802b78:	e8 65 ff ff ff       	call   802ae2 <syscall>
  802b7d:	83 c4 18             	add    $0x18,%esp
}
  802b80:	90                   	nop
  802b81:	c9                   	leave  
  802b82:	c3                   	ret    

00802b83 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802b83:	55                   	push   %ebp
  802b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	6a 00                	push   $0x0
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 00                	push   $0x0
  802b92:	52                   	push   %edx
  802b93:	50                   	push   %eax
  802b94:	6a 08                	push   $0x8
  802b96:	e8 47 ff ff ff       	call   802ae2 <syscall>
  802b9b:	83 c4 18             	add    $0x18,%esp
}
  802b9e:	c9                   	leave  
  802b9f:	c3                   	ret    

00802ba0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802ba0:	55                   	push   %ebp
  802ba1:	89 e5                	mov    %esp,%ebp
  802ba3:	56                   	push   %esi
  802ba4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802ba5:	8b 75 18             	mov    0x18(%ebp),%esi
  802ba8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802bab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	56                   	push   %esi
  802bb5:	53                   	push   %ebx
  802bb6:	51                   	push   %ecx
  802bb7:	52                   	push   %edx
  802bb8:	50                   	push   %eax
  802bb9:	6a 09                	push   $0x9
  802bbb:	e8 22 ff ff ff       	call   802ae2 <syscall>
  802bc0:	83 c4 18             	add    $0x18,%esp
}
  802bc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802bc6:	5b                   	pop    %ebx
  802bc7:	5e                   	pop    %esi
  802bc8:	5d                   	pop    %ebp
  802bc9:	c3                   	ret    

00802bca <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802bca:	55                   	push   %ebp
  802bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	6a 00                	push   $0x0
  802bd5:	6a 00                	push   $0x0
  802bd7:	6a 00                	push   $0x0
  802bd9:	52                   	push   %edx
  802bda:	50                   	push   %eax
  802bdb:	6a 0a                	push   $0xa
  802bdd:	e8 00 ff ff ff       	call   802ae2 <syscall>
  802be2:	83 c4 18             	add    $0x18,%esp
}
  802be5:	c9                   	leave  
  802be6:	c3                   	ret    

00802be7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802be7:	55                   	push   %ebp
  802be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802bea:	6a 00                	push   $0x0
  802bec:	6a 00                	push   $0x0
  802bee:	6a 00                	push   $0x0
  802bf0:	ff 75 0c             	pushl  0xc(%ebp)
  802bf3:	ff 75 08             	pushl  0x8(%ebp)
  802bf6:	6a 0b                	push   $0xb
  802bf8:	e8 e5 fe ff ff       	call   802ae2 <syscall>
  802bfd:	83 c4 18             	add    $0x18,%esp
}
  802c00:	c9                   	leave  
  802c01:	c3                   	ret    

00802c02 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802c02:	55                   	push   %ebp
  802c03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802c05:	6a 00                	push   $0x0
  802c07:	6a 00                	push   $0x0
  802c09:	6a 00                	push   $0x0
  802c0b:	6a 00                	push   $0x0
  802c0d:	6a 00                	push   $0x0
  802c0f:	6a 0c                	push   $0xc
  802c11:	e8 cc fe ff ff       	call   802ae2 <syscall>
  802c16:	83 c4 18             	add    $0x18,%esp
}
  802c19:	c9                   	leave  
  802c1a:	c3                   	ret    

00802c1b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802c1b:	55                   	push   %ebp
  802c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802c1e:	6a 00                	push   $0x0
  802c20:	6a 00                	push   $0x0
  802c22:	6a 00                	push   $0x0
  802c24:	6a 00                	push   $0x0
  802c26:	6a 00                	push   $0x0
  802c28:	6a 0d                	push   $0xd
  802c2a:	e8 b3 fe ff ff       	call   802ae2 <syscall>
  802c2f:	83 c4 18             	add    $0x18,%esp
}
  802c32:	c9                   	leave  
  802c33:	c3                   	ret    

00802c34 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802c34:	55                   	push   %ebp
  802c35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802c37:	6a 00                	push   $0x0
  802c39:	6a 00                	push   $0x0
  802c3b:	6a 00                	push   $0x0
  802c3d:	6a 00                	push   $0x0
  802c3f:	6a 00                	push   $0x0
  802c41:	6a 0e                	push   $0xe
  802c43:	e8 9a fe ff ff       	call   802ae2 <syscall>
  802c48:	83 c4 18             	add    $0x18,%esp
}
  802c4b:	c9                   	leave  
  802c4c:	c3                   	ret    

00802c4d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802c4d:	55                   	push   %ebp
  802c4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802c50:	6a 00                	push   $0x0
  802c52:	6a 00                	push   $0x0
  802c54:	6a 00                	push   $0x0
  802c56:	6a 00                	push   $0x0
  802c58:	6a 00                	push   $0x0
  802c5a:	6a 0f                	push   $0xf
  802c5c:	e8 81 fe ff ff       	call   802ae2 <syscall>
  802c61:	83 c4 18             	add    $0x18,%esp
}
  802c64:	c9                   	leave  
  802c65:	c3                   	ret    

00802c66 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802c66:	55                   	push   %ebp
  802c67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802c69:	6a 00                	push   $0x0
  802c6b:	6a 00                	push   $0x0
  802c6d:	6a 00                	push   $0x0
  802c6f:	6a 00                	push   $0x0
  802c71:	ff 75 08             	pushl  0x8(%ebp)
  802c74:	6a 10                	push   $0x10
  802c76:	e8 67 fe ff ff       	call   802ae2 <syscall>
  802c7b:	83 c4 18             	add    $0x18,%esp
}
  802c7e:	c9                   	leave  
  802c7f:	c3                   	ret    

00802c80 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802c80:	55                   	push   %ebp
  802c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802c83:	6a 00                	push   $0x0
  802c85:	6a 00                	push   $0x0
  802c87:	6a 00                	push   $0x0
  802c89:	6a 00                	push   $0x0
  802c8b:	6a 00                	push   $0x0
  802c8d:	6a 11                	push   $0x11
  802c8f:	e8 4e fe ff ff       	call   802ae2 <syscall>
  802c94:	83 c4 18             	add    $0x18,%esp
}
  802c97:	90                   	nop
  802c98:	c9                   	leave  
  802c99:	c3                   	ret    

00802c9a <sys_cputc>:

void
sys_cputc(const char c)
{
  802c9a:	55                   	push   %ebp
  802c9b:	89 e5                	mov    %esp,%ebp
  802c9d:	83 ec 04             	sub    $0x4,%esp
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802ca6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802caa:	6a 00                	push   $0x0
  802cac:	6a 00                	push   $0x0
  802cae:	6a 00                	push   $0x0
  802cb0:	6a 00                	push   $0x0
  802cb2:	50                   	push   %eax
  802cb3:	6a 01                	push   $0x1
  802cb5:	e8 28 fe ff ff       	call   802ae2 <syscall>
  802cba:	83 c4 18             	add    $0x18,%esp
}
  802cbd:	90                   	nop
  802cbe:	c9                   	leave  
  802cbf:	c3                   	ret    

00802cc0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802cc3:	6a 00                	push   $0x0
  802cc5:	6a 00                	push   $0x0
  802cc7:	6a 00                	push   $0x0
  802cc9:	6a 00                	push   $0x0
  802ccb:	6a 00                	push   $0x0
  802ccd:	6a 14                	push   $0x14
  802ccf:	e8 0e fe ff ff       	call   802ae2 <syscall>
  802cd4:	83 c4 18             	add    $0x18,%esp
}
  802cd7:	90                   	nop
  802cd8:	c9                   	leave  
  802cd9:	c3                   	ret    

00802cda <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802cda:	55                   	push   %ebp
  802cdb:	89 e5                	mov    %esp,%ebp
  802cdd:	83 ec 04             	sub    $0x4,%esp
  802ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ce3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802ce6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ce9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	6a 00                	push   $0x0
  802cf2:	51                   	push   %ecx
  802cf3:	52                   	push   %edx
  802cf4:	ff 75 0c             	pushl  0xc(%ebp)
  802cf7:	50                   	push   %eax
  802cf8:	6a 15                	push   $0x15
  802cfa:	e8 e3 fd ff ff       	call   802ae2 <syscall>
  802cff:	83 c4 18             	add    $0x18,%esp
}
  802d02:	c9                   	leave  
  802d03:	c3                   	ret    

00802d04 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802d04:	55                   	push   %ebp
  802d05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	6a 00                	push   $0x0
  802d0f:	6a 00                	push   $0x0
  802d11:	6a 00                	push   $0x0
  802d13:	52                   	push   %edx
  802d14:	50                   	push   %eax
  802d15:	6a 16                	push   $0x16
  802d17:	e8 c6 fd ff ff       	call   802ae2 <syscall>
  802d1c:	83 c4 18             	add    $0x18,%esp
}
  802d1f:	c9                   	leave  
  802d20:	c3                   	ret    

00802d21 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802d21:	55                   	push   %ebp
  802d22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802d24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	6a 00                	push   $0x0
  802d2f:	6a 00                	push   $0x0
  802d31:	51                   	push   %ecx
  802d32:	52                   	push   %edx
  802d33:	50                   	push   %eax
  802d34:	6a 17                	push   $0x17
  802d36:	e8 a7 fd ff ff       	call   802ae2 <syscall>
  802d3b:	83 c4 18             	add    $0x18,%esp
}
  802d3e:	c9                   	leave  
  802d3f:	c3                   	ret    

00802d40 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802d40:	55                   	push   %ebp
  802d41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	6a 00                	push   $0x0
  802d4b:	6a 00                	push   $0x0
  802d4d:	6a 00                	push   $0x0
  802d4f:	52                   	push   %edx
  802d50:	50                   	push   %eax
  802d51:	6a 18                	push   $0x18
  802d53:	e8 8a fd ff ff       	call   802ae2 <syscall>
  802d58:	83 c4 18             	add    $0x18,%esp
}
  802d5b:	c9                   	leave  
  802d5c:	c3                   	ret    

00802d5d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802d5d:	55                   	push   %ebp
  802d5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	6a 00                	push   $0x0
  802d65:	ff 75 14             	pushl  0x14(%ebp)
  802d68:	ff 75 10             	pushl  0x10(%ebp)
  802d6b:	ff 75 0c             	pushl  0xc(%ebp)
  802d6e:	50                   	push   %eax
  802d6f:	6a 19                	push   $0x19
  802d71:	e8 6c fd ff ff       	call   802ae2 <syscall>
  802d76:	83 c4 18             	add    $0x18,%esp
}
  802d79:	c9                   	leave  
  802d7a:	c3                   	ret    

00802d7b <sys_run_env>:

void sys_run_env(int32 envId)
{
  802d7b:	55                   	push   %ebp
  802d7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	6a 00                	push   $0x0
  802d83:	6a 00                	push   $0x0
  802d85:	6a 00                	push   $0x0
  802d87:	6a 00                	push   $0x0
  802d89:	50                   	push   %eax
  802d8a:	6a 1a                	push   $0x1a
  802d8c:	e8 51 fd ff ff       	call   802ae2 <syscall>
  802d91:	83 c4 18             	add    $0x18,%esp
}
  802d94:	90                   	nop
  802d95:	c9                   	leave  
  802d96:	c3                   	ret    

00802d97 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802d97:	55                   	push   %ebp
  802d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	6a 00                	push   $0x0
  802d9f:	6a 00                	push   $0x0
  802da1:	6a 00                	push   $0x0
  802da3:	6a 00                	push   $0x0
  802da5:	50                   	push   %eax
  802da6:	6a 1b                	push   $0x1b
  802da8:	e8 35 fd ff ff       	call   802ae2 <syscall>
  802dad:	83 c4 18             	add    $0x18,%esp
}
  802db0:	c9                   	leave  
  802db1:	c3                   	ret    

00802db2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802db2:	55                   	push   %ebp
  802db3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802db5:	6a 00                	push   $0x0
  802db7:	6a 00                	push   $0x0
  802db9:	6a 00                	push   $0x0
  802dbb:	6a 00                	push   $0x0
  802dbd:	6a 00                	push   $0x0
  802dbf:	6a 05                	push   $0x5
  802dc1:	e8 1c fd ff ff       	call   802ae2 <syscall>
  802dc6:	83 c4 18             	add    $0x18,%esp
}
  802dc9:	c9                   	leave  
  802dca:	c3                   	ret    

00802dcb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802dcb:	55                   	push   %ebp
  802dcc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802dce:	6a 00                	push   $0x0
  802dd0:	6a 00                	push   $0x0
  802dd2:	6a 00                	push   $0x0
  802dd4:	6a 00                	push   $0x0
  802dd6:	6a 00                	push   $0x0
  802dd8:	6a 06                	push   $0x6
  802dda:	e8 03 fd ff ff       	call   802ae2 <syscall>
  802ddf:	83 c4 18             	add    $0x18,%esp
}
  802de2:	c9                   	leave  
  802de3:	c3                   	ret    

00802de4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802de4:	55                   	push   %ebp
  802de5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802de7:	6a 00                	push   $0x0
  802de9:	6a 00                	push   $0x0
  802deb:	6a 00                	push   $0x0
  802ded:	6a 00                	push   $0x0
  802def:	6a 00                	push   $0x0
  802df1:	6a 07                	push   $0x7
  802df3:	e8 ea fc ff ff       	call   802ae2 <syscall>
  802df8:	83 c4 18             	add    $0x18,%esp
}
  802dfb:	c9                   	leave  
  802dfc:	c3                   	ret    

00802dfd <sys_exit_env>:


void sys_exit_env(void)
{
  802dfd:	55                   	push   %ebp
  802dfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802e00:	6a 00                	push   $0x0
  802e02:	6a 00                	push   $0x0
  802e04:	6a 00                	push   $0x0
  802e06:	6a 00                	push   $0x0
  802e08:	6a 00                	push   $0x0
  802e0a:	6a 1c                	push   $0x1c
  802e0c:	e8 d1 fc ff ff       	call   802ae2 <syscall>
  802e11:	83 c4 18             	add    $0x18,%esp
}
  802e14:	90                   	nop
  802e15:	c9                   	leave  
  802e16:	c3                   	ret    

00802e17 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802e17:	55                   	push   %ebp
  802e18:	89 e5                	mov    %esp,%ebp
  802e1a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802e1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e20:	8d 50 04             	lea    0x4(%eax),%edx
  802e23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e26:	6a 00                	push   $0x0
  802e28:	6a 00                	push   $0x0
  802e2a:	6a 00                	push   $0x0
  802e2c:	52                   	push   %edx
  802e2d:	50                   	push   %eax
  802e2e:	6a 1d                	push   $0x1d
  802e30:	e8 ad fc ff ff       	call   802ae2 <syscall>
  802e35:	83 c4 18             	add    $0x18,%esp
	return result;
  802e38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802e3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802e41:	89 01                	mov    %eax,(%ecx)
  802e43:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	c9                   	leave  
  802e4a:	c2 04 00             	ret    $0x4

00802e4d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802e4d:	55                   	push   %ebp
  802e4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802e50:	6a 00                	push   $0x0
  802e52:	6a 00                	push   $0x0
  802e54:	ff 75 10             	pushl  0x10(%ebp)
  802e57:	ff 75 0c             	pushl  0xc(%ebp)
  802e5a:	ff 75 08             	pushl  0x8(%ebp)
  802e5d:	6a 13                	push   $0x13
  802e5f:	e8 7e fc ff ff       	call   802ae2 <syscall>
  802e64:	83 c4 18             	add    $0x18,%esp
	return ;
  802e67:	90                   	nop
}
  802e68:	c9                   	leave  
  802e69:	c3                   	ret    

00802e6a <sys_rcr2>:
uint32 sys_rcr2()
{
  802e6a:	55                   	push   %ebp
  802e6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802e6d:	6a 00                	push   $0x0
  802e6f:	6a 00                	push   $0x0
  802e71:	6a 00                	push   $0x0
  802e73:	6a 00                	push   $0x0
  802e75:	6a 00                	push   $0x0
  802e77:	6a 1e                	push   $0x1e
  802e79:	e8 64 fc ff ff       	call   802ae2 <syscall>
  802e7e:	83 c4 18             	add    $0x18,%esp
}
  802e81:	c9                   	leave  
  802e82:	c3                   	ret    

00802e83 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802e83:	55                   	push   %ebp
  802e84:	89 e5                	mov    %esp,%ebp
  802e86:	83 ec 04             	sub    $0x4,%esp
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802e8f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802e93:	6a 00                	push   $0x0
  802e95:	6a 00                	push   $0x0
  802e97:	6a 00                	push   $0x0
  802e99:	6a 00                	push   $0x0
  802e9b:	50                   	push   %eax
  802e9c:	6a 1f                	push   $0x1f
  802e9e:	e8 3f fc ff ff       	call   802ae2 <syscall>
  802ea3:	83 c4 18             	add    $0x18,%esp
	return ;
  802ea6:	90                   	nop
}
  802ea7:	c9                   	leave  
  802ea8:	c3                   	ret    

00802ea9 <rsttst>:
void rsttst()
{
  802ea9:	55                   	push   %ebp
  802eaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802eac:	6a 00                	push   $0x0
  802eae:	6a 00                	push   $0x0
  802eb0:	6a 00                	push   $0x0
  802eb2:	6a 00                	push   $0x0
  802eb4:	6a 00                	push   $0x0
  802eb6:	6a 21                	push   $0x21
  802eb8:	e8 25 fc ff ff       	call   802ae2 <syscall>
  802ebd:	83 c4 18             	add    $0x18,%esp
	return ;
  802ec0:	90                   	nop
}
  802ec1:	c9                   	leave  
  802ec2:	c3                   	ret    

00802ec3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802ec3:	55                   	push   %ebp
  802ec4:	89 e5                	mov    %esp,%ebp
  802ec6:	83 ec 04             	sub    $0x4,%esp
  802ec9:	8b 45 14             	mov    0x14(%ebp),%eax
  802ecc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802ecf:	8b 55 18             	mov    0x18(%ebp),%edx
  802ed2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ed6:	52                   	push   %edx
  802ed7:	50                   	push   %eax
  802ed8:	ff 75 10             	pushl  0x10(%ebp)
  802edb:	ff 75 0c             	pushl  0xc(%ebp)
  802ede:	ff 75 08             	pushl  0x8(%ebp)
  802ee1:	6a 20                	push   $0x20
  802ee3:	e8 fa fb ff ff       	call   802ae2 <syscall>
  802ee8:	83 c4 18             	add    $0x18,%esp
	return ;
  802eeb:	90                   	nop
}
  802eec:	c9                   	leave  
  802eed:	c3                   	ret    

00802eee <chktst>:
void chktst(uint32 n)
{
  802eee:	55                   	push   %ebp
  802eef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802ef1:	6a 00                	push   $0x0
  802ef3:	6a 00                	push   $0x0
  802ef5:	6a 00                	push   $0x0
  802ef7:	6a 00                	push   $0x0
  802ef9:	ff 75 08             	pushl  0x8(%ebp)
  802efc:	6a 22                	push   $0x22
  802efe:	e8 df fb ff ff       	call   802ae2 <syscall>
  802f03:	83 c4 18             	add    $0x18,%esp
	return ;
  802f06:	90                   	nop
}
  802f07:	c9                   	leave  
  802f08:	c3                   	ret    

00802f09 <inctst>:

void inctst()
{
  802f09:	55                   	push   %ebp
  802f0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802f0c:	6a 00                	push   $0x0
  802f0e:	6a 00                	push   $0x0
  802f10:	6a 00                	push   $0x0
  802f12:	6a 00                	push   $0x0
  802f14:	6a 00                	push   $0x0
  802f16:	6a 23                	push   $0x23
  802f18:	e8 c5 fb ff ff       	call   802ae2 <syscall>
  802f1d:	83 c4 18             	add    $0x18,%esp
	return ;
  802f20:	90                   	nop
}
  802f21:	c9                   	leave  
  802f22:	c3                   	ret    

00802f23 <gettst>:
uint32 gettst()
{
  802f23:	55                   	push   %ebp
  802f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802f26:	6a 00                	push   $0x0
  802f28:	6a 00                	push   $0x0
  802f2a:	6a 00                	push   $0x0
  802f2c:	6a 00                	push   $0x0
  802f2e:	6a 00                	push   $0x0
  802f30:	6a 24                	push   $0x24
  802f32:	e8 ab fb ff ff       	call   802ae2 <syscall>
  802f37:	83 c4 18             	add    $0x18,%esp
}
  802f3a:	c9                   	leave  
  802f3b:	c3                   	ret    

00802f3c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802f3c:	55                   	push   %ebp
  802f3d:	89 e5                	mov    %esp,%ebp
  802f3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f42:	6a 00                	push   $0x0
  802f44:	6a 00                	push   $0x0
  802f46:	6a 00                	push   $0x0
  802f48:	6a 00                	push   $0x0
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 25                	push   $0x25
  802f4e:	e8 8f fb ff ff       	call   802ae2 <syscall>
  802f53:	83 c4 18             	add    $0x18,%esp
  802f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802f59:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802f5d:	75 07                	jne    802f66 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802f5f:	b8 01 00 00 00       	mov    $0x1,%eax
  802f64:	eb 05                	jmp    802f6b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f6b:	c9                   	leave  
  802f6c:	c3                   	ret    

00802f6d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802f6d:	55                   	push   %ebp
  802f6e:	89 e5                	mov    %esp,%ebp
  802f70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f73:	6a 00                	push   $0x0
  802f75:	6a 00                	push   $0x0
  802f77:	6a 00                	push   $0x0
  802f79:	6a 00                	push   $0x0
  802f7b:	6a 00                	push   $0x0
  802f7d:	6a 25                	push   $0x25
  802f7f:	e8 5e fb ff ff       	call   802ae2 <syscall>
  802f84:	83 c4 18             	add    $0x18,%esp
  802f87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802f8a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802f8e:	75 07                	jne    802f97 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802f90:	b8 01 00 00 00       	mov    $0x1,%eax
  802f95:	eb 05                	jmp    802f9c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f9c:	c9                   	leave  
  802f9d:	c3                   	ret    

00802f9e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802f9e:	55                   	push   %ebp
  802f9f:	89 e5                	mov    %esp,%ebp
  802fa1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802fa4:	6a 00                	push   $0x0
  802fa6:	6a 00                	push   $0x0
  802fa8:	6a 00                	push   $0x0
  802faa:	6a 00                	push   $0x0
  802fac:	6a 00                	push   $0x0
  802fae:	6a 25                	push   $0x25
  802fb0:	e8 2d fb ff ff       	call   802ae2 <syscall>
  802fb5:	83 c4 18             	add    $0x18,%esp
  802fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802fbb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802fbf:	75 07                	jne    802fc8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802fc1:	b8 01 00 00 00       	mov    $0x1,%eax
  802fc6:	eb 05                	jmp    802fcd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802fc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fcd:	c9                   	leave  
  802fce:	c3                   	ret    

00802fcf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802fcf:	55                   	push   %ebp
  802fd0:	89 e5                	mov    %esp,%ebp
  802fd2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802fd5:	6a 00                	push   $0x0
  802fd7:	6a 00                	push   $0x0
  802fd9:	6a 00                	push   $0x0
  802fdb:	6a 00                	push   $0x0
  802fdd:	6a 00                	push   $0x0
  802fdf:	6a 25                	push   $0x25
  802fe1:	e8 fc fa ff ff       	call   802ae2 <syscall>
  802fe6:	83 c4 18             	add    $0x18,%esp
  802fe9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802fec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802ff0:	75 07                	jne    802ff9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802ff2:	b8 01 00 00 00       	mov    $0x1,%eax
  802ff7:	eb 05                	jmp    802ffe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ff9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ffe:	c9                   	leave  
  802fff:	c3                   	ret    

00803000 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803000:	55                   	push   %ebp
  803001:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803003:	6a 00                	push   $0x0
  803005:	6a 00                	push   $0x0
  803007:	6a 00                	push   $0x0
  803009:	6a 00                	push   $0x0
  80300b:	ff 75 08             	pushl  0x8(%ebp)
  80300e:	6a 26                	push   $0x26
  803010:	e8 cd fa ff ff       	call   802ae2 <syscall>
  803015:	83 c4 18             	add    $0x18,%esp
	return ;
  803018:	90                   	nop
}
  803019:	c9                   	leave  
  80301a:	c3                   	ret    

0080301b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80301b:	55                   	push   %ebp
  80301c:	89 e5                	mov    %esp,%ebp
  80301e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80301f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803022:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803025:	8b 55 0c             	mov    0xc(%ebp),%edx
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	6a 00                	push   $0x0
  80302d:	53                   	push   %ebx
  80302e:	51                   	push   %ecx
  80302f:	52                   	push   %edx
  803030:	50                   	push   %eax
  803031:	6a 27                	push   $0x27
  803033:	e8 aa fa ff ff       	call   802ae2 <syscall>
  803038:	83 c4 18             	add    $0x18,%esp
}
  80303b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80303e:	c9                   	leave  
  80303f:	c3                   	ret    

00803040 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803040:	55                   	push   %ebp
  803041:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803043:	8b 55 0c             	mov    0xc(%ebp),%edx
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	6a 00                	push   $0x0
  80304b:	6a 00                	push   $0x0
  80304d:	6a 00                	push   $0x0
  80304f:	52                   	push   %edx
  803050:	50                   	push   %eax
  803051:	6a 28                	push   $0x28
  803053:	e8 8a fa ff ff       	call   802ae2 <syscall>
  803058:	83 c4 18             	add    $0x18,%esp
}
  80305b:	c9                   	leave  
  80305c:	c3                   	ret    

0080305d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80305d:	55                   	push   %ebp
  80305e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803060:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803063:	8b 55 0c             	mov    0xc(%ebp),%edx
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	6a 00                	push   $0x0
  80306b:	51                   	push   %ecx
  80306c:	ff 75 10             	pushl  0x10(%ebp)
  80306f:	52                   	push   %edx
  803070:	50                   	push   %eax
  803071:	6a 29                	push   $0x29
  803073:	e8 6a fa ff ff       	call   802ae2 <syscall>
  803078:	83 c4 18             	add    $0x18,%esp
}
  80307b:	c9                   	leave  
  80307c:	c3                   	ret    

0080307d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80307d:	55                   	push   %ebp
  80307e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803080:	6a 00                	push   $0x0
  803082:	6a 00                	push   $0x0
  803084:	ff 75 10             	pushl  0x10(%ebp)
  803087:	ff 75 0c             	pushl  0xc(%ebp)
  80308a:	ff 75 08             	pushl  0x8(%ebp)
  80308d:	6a 12                	push   $0x12
  80308f:	e8 4e fa ff ff       	call   802ae2 <syscall>
  803094:	83 c4 18             	add    $0x18,%esp
	return ;
  803097:	90                   	nop
}
  803098:	c9                   	leave  
  803099:	c3                   	ret    

0080309a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80309a:	55                   	push   %ebp
  80309b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80309d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	6a 00                	push   $0x0
  8030a5:	6a 00                	push   $0x0
  8030a7:	6a 00                	push   $0x0
  8030a9:	52                   	push   %edx
  8030aa:	50                   	push   %eax
  8030ab:	6a 2a                	push   $0x2a
  8030ad:	e8 30 fa ff ff       	call   802ae2 <syscall>
  8030b2:	83 c4 18             	add    $0x18,%esp
	return;
  8030b5:	90                   	nop
}
  8030b6:	c9                   	leave  
  8030b7:	c3                   	ret    

008030b8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8030b8:	55                   	push   %ebp
  8030b9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	6a 00                	push   $0x0
  8030c0:	6a 00                	push   $0x0
  8030c2:	6a 00                	push   $0x0
  8030c4:	6a 00                	push   $0x0
  8030c6:	50                   	push   %eax
  8030c7:	6a 2b                	push   $0x2b
  8030c9:	e8 14 fa ff ff       	call   802ae2 <syscall>
  8030ce:	83 c4 18             	add    $0x18,%esp
}
  8030d1:	c9                   	leave  
  8030d2:	c3                   	ret    

008030d3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8030d3:	55                   	push   %ebp
  8030d4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8030d6:	6a 00                	push   $0x0
  8030d8:	6a 00                	push   $0x0
  8030da:	6a 00                	push   $0x0
  8030dc:	ff 75 0c             	pushl  0xc(%ebp)
  8030df:	ff 75 08             	pushl  0x8(%ebp)
  8030e2:	6a 2c                	push   $0x2c
  8030e4:	e8 f9 f9 ff ff       	call   802ae2 <syscall>
  8030e9:	83 c4 18             	add    $0x18,%esp
	return;
  8030ec:	90                   	nop
}
  8030ed:	c9                   	leave  
  8030ee:	c3                   	ret    

008030ef <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8030ef:	55                   	push   %ebp
  8030f0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8030f2:	6a 00                	push   $0x0
  8030f4:	6a 00                	push   $0x0
  8030f6:	6a 00                	push   $0x0
  8030f8:	ff 75 0c             	pushl  0xc(%ebp)
  8030fb:	ff 75 08             	pushl  0x8(%ebp)
  8030fe:	6a 2d                	push   $0x2d
  803100:	e8 dd f9 ff ff       	call   802ae2 <syscall>
  803105:	83 c4 18             	add    $0x18,%esp
	return;
  803108:	90                   	nop
}
  803109:	c9                   	leave  
  80310a:	c3                   	ret    

0080310b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80310b:	55                   	push   %ebp
  80310c:	89 e5                	mov    %esp,%ebp
  80310e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	83 e8 04             	sub    $0x4,%eax
  803117:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80311a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80311d:	8b 00                	mov    (%eax),%eax
  80311f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  803122:	c9                   	leave  
  803123:	c3                   	ret    

00803124 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  803124:	55                   	push   %ebp
  803125:	89 e5                	mov    %esp,%ebp
  803127:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	83 e8 04             	sub    $0x4,%eax
  803130:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  803133:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	83 e0 01             	and    $0x1,%eax
  80313b:	85 c0                	test   %eax,%eax
  80313d:	0f 94 c0             	sete   %al
}
  803140:	c9                   	leave  
  803141:	c3                   	ret    

00803142 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  803142:	55                   	push   %ebp
  803143:	89 e5                	mov    %esp,%ebp
  803145:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  803148:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80314f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803152:	83 f8 02             	cmp    $0x2,%eax
  803155:	74 2b                	je     803182 <alloc_block+0x40>
  803157:	83 f8 02             	cmp    $0x2,%eax
  80315a:	7f 07                	jg     803163 <alloc_block+0x21>
  80315c:	83 f8 01             	cmp    $0x1,%eax
  80315f:	74 0e                	je     80316f <alloc_block+0x2d>
  803161:	eb 58                	jmp    8031bb <alloc_block+0x79>
  803163:	83 f8 03             	cmp    $0x3,%eax
  803166:	74 2d                	je     803195 <alloc_block+0x53>
  803168:	83 f8 04             	cmp    $0x4,%eax
  80316b:	74 3b                	je     8031a8 <alloc_block+0x66>
  80316d:	eb 4c                	jmp    8031bb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80316f:	83 ec 0c             	sub    $0xc,%esp
  803172:	ff 75 08             	pushl  0x8(%ebp)
  803175:	e8 11 03 00 00       	call   80348b <alloc_block_FF>
  80317a:	83 c4 10             	add    $0x10,%esp
  80317d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803180:	eb 4a                	jmp    8031cc <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  803182:	83 ec 0c             	sub    $0xc,%esp
  803185:	ff 75 08             	pushl  0x8(%ebp)
  803188:	e8 fa 19 00 00       	call   804b87 <alloc_block_NF>
  80318d:	83 c4 10             	add    $0x10,%esp
  803190:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803193:	eb 37                	jmp    8031cc <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  803195:	83 ec 0c             	sub    $0xc,%esp
  803198:	ff 75 08             	pushl  0x8(%ebp)
  80319b:	e8 a7 07 00 00       	call   803947 <alloc_block_BF>
  8031a0:	83 c4 10             	add    $0x10,%esp
  8031a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8031a6:	eb 24                	jmp    8031cc <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8031a8:	83 ec 0c             	sub    $0xc,%esp
  8031ab:	ff 75 08             	pushl  0x8(%ebp)
  8031ae:	e8 b7 19 00 00       	call   804b6a <alloc_block_WF>
  8031b3:	83 c4 10             	add    $0x10,%esp
  8031b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8031b9:	eb 11                	jmp    8031cc <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8031bb:	83 ec 0c             	sub    $0xc,%esp
  8031be:	68 10 57 80 00       	push   $0x805710
  8031c3:	e8 a8 e6 ff ff       	call   801870 <cprintf>
  8031c8:	83 c4 10             	add    $0x10,%esp
		break;
  8031cb:	90                   	nop
	}
	return va;
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8031cf:	c9                   	leave  
  8031d0:	c3                   	ret    

008031d1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8031d1:	55                   	push   %ebp
  8031d2:	89 e5                	mov    %esp,%ebp
  8031d4:	53                   	push   %ebx
  8031d5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8031d8:	83 ec 0c             	sub    $0xc,%esp
  8031db:	68 30 57 80 00       	push   $0x805730
  8031e0:	e8 8b e6 ff ff       	call   801870 <cprintf>
  8031e5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8031e8:	83 ec 0c             	sub    $0xc,%esp
  8031eb:	68 5b 57 80 00       	push   $0x80575b
  8031f0:	e8 7b e6 ff ff       	call   801870 <cprintf>
  8031f5:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8031f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031fe:	eb 37                	jmp    803237 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  803200:	83 ec 0c             	sub    $0xc,%esp
  803203:	ff 75 f4             	pushl  -0xc(%ebp)
  803206:	e8 19 ff ff ff       	call   803124 <is_free_block>
  80320b:	83 c4 10             	add    $0x10,%esp
  80320e:	0f be d8             	movsbl %al,%ebx
  803211:	83 ec 0c             	sub    $0xc,%esp
  803214:	ff 75 f4             	pushl  -0xc(%ebp)
  803217:	e8 ef fe ff ff       	call   80310b <get_block_size>
  80321c:	83 c4 10             	add    $0x10,%esp
  80321f:	83 ec 04             	sub    $0x4,%esp
  803222:	53                   	push   %ebx
  803223:	50                   	push   %eax
  803224:	68 73 57 80 00       	push   $0x805773
  803229:	e8 42 e6 ff ff       	call   801870 <cprintf>
  80322e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  803231:	8b 45 10             	mov    0x10(%ebp),%eax
  803234:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803237:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323b:	74 07                	je     803244 <print_blocks_list+0x73>
  80323d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803240:	8b 00                	mov    (%eax),%eax
  803242:	eb 05                	jmp    803249 <print_blocks_list+0x78>
  803244:	b8 00 00 00 00       	mov    $0x0,%eax
  803249:	89 45 10             	mov    %eax,0x10(%ebp)
  80324c:	8b 45 10             	mov    0x10(%ebp),%eax
  80324f:	85 c0                	test   %eax,%eax
  803251:	75 ad                	jne    803200 <print_blocks_list+0x2f>
  803253:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803257:	75 a7                	jne    803200 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  803259:	83 ec 0c             	sub    $0xc,%esp
  80325c:	68 30 57 80 00       	push   $0x805730
  803261:	e8 0a e6 ff ff       	call   801870 <cprintf>
  803266:	83 c4 10             	add    $0x10,%esp

}
  803269:	90                   	nop
  80326a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80326d:	c9                   	leave  
  80326e:	c3                   	ret    

0080326f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80326f:	55                   	push   %ebp
  803270:	89 e5                	mov    %esp,%ebp
  803272:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  803275:	8b 45 0c             	mov    0xc(%ebp),%eax
  803278:	83 e0 01             	and    $0x1,%eax
  80327b:	85 c0                	test   %eax,%eax
  80327d:	74 03                	je     803282 <initialize_dynamic_allocator+0x13>
  80327f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  803282:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803286:	0f 84 c7 01 00 00    	je     803453 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80328c:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  803293:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  803296:	8b 55 08             	mov    0x8(%ebp),%edx
  803299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329c:	01 d0                	add    %edx,%eax
  80329e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8032a3:	0f 87 ad 01 00 00    	ja     803456 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	85 c0                	test   %eax,%eax
  8032ae:	0f 89 a5 01 00 00    	jns    803459 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8032b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ba:	01 d0                	add    %edx,%eax
  8032bc:	83 e8 04             	sub    $0x4,%eax
  8032bf:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  8032c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8032cb:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8032d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d3:	e9 87 00 00 00       	jmp    80335f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8032d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032dc:	75 14                	jne    8032f2 <initialize_dynamic_allocator+0x83>
  8032de:	83 ec 04             	sub    $0x4,%esp
  8032e1:	68 8b 57 80 00       	push   $0x80578b
  8032e6:	6a 79                	push   $0x79
  8032e8:	68 a9 57 80 00       	push   $0x8057a9
  8032ed:	e8 c1 e2 ff ff       	call   8015b3 <_panic>
  8032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f5:	8b 00                	mov    (%eax),%eax
  8032f7:	85 c0                	test   %eax,%eax
  8032f9:	74 10                	je     80330b <initialize_dynamic_allocator+0x9c>
  8032fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fe:	8b 00                	mov    (%eax),%eax
  803300:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803303:	8b 52 04             	mov    0x4(%edx),%edx
  803306:	89 50 04             	mov    %edx,0x4(%eax)
  803309:	eb 0b                	jmp    803316 <initialize_dynamic_allocator+0xa7>
  80330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330e:	8b 40 04             	mov    0x4(%eax),%eax
  803311:	a3 30 60 80 00       	mov    %eax,0x806030
  803316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803319:	8b 40 04             	mov    0x4(%eax),%eax
  80331c:	85 c0                	test   %eax,%eax
  80331e:	74 0f                	je     80332f <initialize_dynamic_allocator+0xc0>
  803320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803323:	8b 40 04             	mov    0x4(%eax),%eax
  803326:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803329:	8b 12                	mov    (%edx),%edx
  80332b:	89 10                	mov    %edx,(%eax)
  80332d:	eb 0a                	jmp    803339 <initialize_dynamic_allocator+0xca>
  80332f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803332:	8b 00                	mov    (%eax),%eax
  803334:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803345:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334c:	a1 38 60 80 00       	mov    0x806038,%eax
  803351:	48                   	dec    %eax
  803352:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  803357:	a1 34 60 80 00       	mov    0x806034,%eax
  80335c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80335f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803363:	74 07                	je     80336c <initialize_dynamic_allocator+0xfd>
  803365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803368:	8b 00                	mov    (%eax),%eax
  80336a:	eb 05                	jmp    803371 <initialize_dynamic_allocator+0x102>
  80336c:	b8 00 00 00 00       	mov    $0x0,%eax
  803371:	a3 34 60 80 00       	mov    %eax,0x806034
  803376:	a1 34 60 80 00       	mov    0x806034,%eax
  80337b:	85 c0                	test   %eax,%eax
  80337d:	0f 85 55 ff ff ff    	jne    8032d8 <initialize_dynamic_allocator+0x69>
  803383:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803387:	0f 85 4b ff ff ff    	jne    8032d8 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  803393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803396:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80339c:	a1 44 60 80 00       	mov    0x806044,%eax
  8033a1:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  8033a6:	a1 40 60 80 00       	mov    0x806040,%eax
  8033ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	83 c0 08             	add    $0x8,%eax
  8033b7:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	83 c0 04             	add    $0x4,%eax
  8033c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033c3:	83 ea 08             	sub    $0x8,%edx
  8033c6:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8033c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	01 d0                	add    %edx,%eax
  8033d0:	83 e8 08             	sub    $0x8,%eax
  8033d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033d6:	83 ea 08             	sub    $0x8,%edx
  8033d9:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8033db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8033e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8033ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033f2:	75 17                	jne    80340b <initialize_dynamic_allocator+0x19c>
  8033f4:	83 ec 04             	sub    $0x4,%esp
  8033f7:	68 c4 57 80 00       	push   $0x8057c4
  8033fc:	68 90 00 00 00       	push   $0x90
  803401:	68 a9 57 80 00       	push   $0x8057a9
  803406:	e8 a8 e1 ff ff       	call   8015b3 <_panic>
  80340b:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803411:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803414:	89 10                	mov    %edx,(%eax)
  803416:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	74 0d                	je     80342c <initialize_dynamic_allocator+0x1bd>
  80341f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803424:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803427:	89 50 04             	mov    %edx,0x4(%eax)
  80342a:	eb 08                	jmp    803434 <initialize_dynamic_allocator+0x1c5>
  80342c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342f:	a3 30 60 80 00       	mov    %eax,0x806030
  803434:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803437:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80343c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803446:	a1 38 60 80 00       	mov    0x806038,%eax
  80344b:	40                   	inc    %eax
  80344c:	a3 38 60 80 00       	mov    %eax,0x806038
  803451:	eb 07                	jmp    80345a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  803453:	90                   	nop
  803454:	eb 04                	jmp    80345a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  803456:	90                   	nop
  803457:	eb 01                	jmp    80345a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  803459:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80345a:	c9                   	leave  
  80345b:	c3                   	ret    

0080345c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80345c:	55                   	push   %ebp
  80345d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80345f:	8b 45 10             	mov    0x10(%ebp),%eax
  803462:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	8d 50 fc             	lea    -0x4(%eax),%edx
  80346b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	83 e8 04             	sub    $0x4,%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	83 e0 fe             	and    $0xfffffffe,%eax
  80347b:	8d 50 f8             	lea    -0x8(%eax),%edx
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	01 c2                	add    %eax,%edx
  803483:	8b 45 0c             	mov    0xc(%ebp),%eax
  803486:	89 02                	mov    %eax,(%edx)
}
  803488:	90                   	nop
  803489:	5d                   	pop    %ebp
  80348a:	c3                   	ret    

0080348b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80348b:	55                   	push   %ebp
  80348c:	89 e5                	mov    %esp,%ebp
  80348e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	83 e0 01             	and    $0x1,%eax
  803497:	85 c0                	test   %eax,%eax
  803499:	74 03                	je     80349e <alloc_block_FF+0x13>
  80349b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80349e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8034a2:	77 07                	ja     8034ab <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8034a4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8034ab:	a1 24 60 80 00       	mov    0x806024,%eax
  8034b0:	85 c0                	test   %eax,%eax
  8034b2:	75 73                	jne    803527 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b7:	83 c0 10             	add    $0x10,%eax
  8034ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8034bd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8034c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ca:	01 d0                	add    %edx,%eax
  8034cc:	48                   	dec    %eax
  8034cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8034d8:	f7 75 ec             	divl   -0x14(%ebp)
  8034db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034de:	29 d0                	sub    %edx,%eax
  8034e0:	c1 e8 0c             	shr    $0xc,%eax
  8034e3:	83 ec 0c             	sub    $0xc,%esp
  8034e6:	50                   	push   %eax
  8034e7:	e8 1e f1 ff ff       	call   80260a <sbrk>
  8034ec:	83 c4 10             	add    $0x10,%esp
  8034ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8034f2:	83 ec 0c             	sub    $0xc,%esp
  8034f5:	6a 00                	push   $0x0
  8034f7:	e8 0e f1 ff ff       	call   80260a <sbrk>
  8034fc:	83 c4 10             	add    $0x10,%esp
  8034ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803505:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803508:	83 ec 08             	sub    $0x8,%esp
  80350b:	50                   	push   %eax
  80350c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80350f:	e8 5b fd ff ff       	call   80326f <initialize_dynamic_allocator>
  803514:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803517:	83 ec 0c             	sub    $0xc,%esp
  80351a:	68 e7 57 80 00       	push   $0x8057e7
  80351f:	e8 4c e3 ff ff       	call   801870 <cprintf>
  803524:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803527:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80352b:	75 0a                	jne    803537 <alloc_block_FF+0xac>
	        return NULL;
  80352d:	b8 00 00 00 00       	mov    $0x0,%eax
  803532:	e9 0e 04 00 00       	jmp    803945 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803537:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80353e:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803543:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803546:	e9 f3 02 00 00       	jmp    80383e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80354b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803551:	83 ec 0c             	sub    $0xc,%esp
  803554:	ff 75 bc             	pushl  -0x44(%ebp)
  803557:	e8 af fb ff ff       	call   80310b <get_block_size>
  80355c:	83 c4 10             	add    $0x10,%esp
  80355f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803562:	8b 45 08             	mov    0x8(%ebp),%eax
  803565:	83 c0 08             	add    $0x8,%eax
  803568:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80356b:	0f 87 c5 02 00 00    	ja     803836 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803571:	8b 45 08             	mov    0x8(%ebp),%eax
  803574:	83 c0 18             	add    $0x18,%eax
  803577:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80357a:	0f 87 19 02 00 00    	ja     803799 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  803580:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803583:	2b 45 08             	sub    0x8(%ebp),%eax
  803586:	83 e8 08             	sub    $0x8,%eax
  803589:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80358c:	8b 45 08             	mov    0x8(%ebp),%eax
  80358f:	8d 50 08             	lea    0x8(%eax),%edx
  803592:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803595:	01 d0                	add    %edx,%eax
  803597:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80359a:	8b 45 08             	mov    0x8(%ebp),%eax
  80359d:	83 c0 08             	add    $0x8,%eax
  8035a0:	83 ec 04             	sub    $0x4,%esp
  8035a3:	6a 01                	push   $0x1
  8035a5:	50                   	push   %eax
  8035a6:	ff 75 bc             	pushl  -0x44(%ebp)
  8035a9:	e8 ae fe ff ff       	call   80345c <set_block_data>
  8035ae:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8035b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b4:	8b 40 04             	mov    0x4(%eax),%eax
  8035b7:	85 c0                	test   %eax,%eax
  8035b9:	75 68                	jne    803623 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8035bb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8035bf:	75 17                	jne    8035d8 <alloc_block_FF+0x14d>
  8035c1:	83 ec 04             	sub    $0x4,%esp
  8035c4:	68 c4 57 80 00       	push   $0x8057c4
  8035c9:	68 d7 00 00 00       	push   $0xd7
  8035ce:	68 a9 57 80 00       	push   $0x8057a9
  8035d3:	e8 db df ff ff       	call   8015b3 <_panic>
  8035d8:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8035de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035e1:	89 10                	mov    %edx,(%eax)
  8035e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035e6:	8b 00                	mov    (%eax),%eax
  8035e8:	85 c0                	test   %eax,%eax
  8035ea:	74 0d                	je     8035f9 <alloc_block_FF+0x16e>
  8035ec:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8035f1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8035f4:	89 50 04             	mov    %edx,0x4(%eax)
  8035f7:	eb 08                	jmp    803601 <alloc_block_FF+0x176>
  8035f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035fc:	a3 30 60 80 00       	mov    %eax,0x806030
  803601:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803604:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803609:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80360c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803613:	a1 38 60 80 00       	mov    0x806038,%eax
  803618:	40                   	inc    %eax
  803619:	a3 38 60 80 00       	mov    %eax,0x806038
  80361e:	e9 dc 00 00 00       	jmp    8036ff <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803626:	8b 00                	mov    (%eax),%eax
  803628:	85 c0                	test   %eax,%eax
  80362a:	75 65                	jne    803691 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80362c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803630:	75 17                	jne    803649 <alloc_block_FF+0x1be>
  803632:	83 ec 04             	sub    $0x4,%esp
  803635:	68 f8 57 80 00       	push   $0x8057f8
  80363a:	68 db 00 00 00       	push   $0xdb
  80363f:	68 a9 57 80 00       	push   $0x8057a9
  803644:	e8 6a df ff ff       	call   8015b3 <_panic>
  803649:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80364f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803652:	89 50 04             	mov    %edx,0x4(%eax)
  803655:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803658:	8b 40 04             	mov    0x4(%eax),%eax
  80365b:	85 c0                	test   %eax,%eax
  80365d:	74 0c                	je     80366b <alloc_block_FF+0x1e0>
  80365f:	a1 30 60 80 00       	mov    0x806030,%eax
  803664:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803667:	89 10                	mov    %edx,(%eax)
  803669:	eb 08                	jmp    803673 <alloc_block_FF+0x1e8>
  80366b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80366e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803673:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803676:	a3 30 60 80 00       	mov    %eax,0x806030
  80367b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80367e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803684:	a1 38 60 80 00       	mov    0x806038,%eax
  803689:	40                   	inc    %eax
  80368a:	a3 38 60 80 00       	mov    %eax,0x806038
  80368f:	eb 6e                	jmp    8036ff <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  803691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803695:	74 06                	je     80369d <alloc_block_FF+0x212>
  803697:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80369b:	75 17                	jne    8036b4 <alloc_block_FF+0x229>
  80369d:	83 ec 04             	sub    $0x4,%esp
  8036a0:	68 1c 58 80 00       	push   $0x80581c
  8036a5:	68 df 00 00 00       	push   $0xdf
  8036aa:	68 a9 57 80 00       	push   $0x8057a9
  8036af:	e8 ff de ff ff       	call   8015b3 <_panic>
  8036b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b7:	8b 10                	mov    (%eax),%edx
  8036b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036bc:	89 10                	mov    %edx,(%eax)
  8036be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036c1:	8b 00                	mov    (%eax),%eax
  8036c3:	85 c0                	test   %eax,%eax
  8036c5:	74 0b                	je     8036d2 <alloc_block_FF+0x247>
  8036c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ca:	8b 00                	mov    (%eax),%eax
  8036cc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8036cf:	89 50 04             	mov    %edx,0x4(%eax)
  8036d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8036d8:	89 10                	mov    %edx,(%eax)
  8036da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e0:	89 50 04             	mov    %edx,0x4(%eax)
  8036e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036e6:	8b 00                	mov    (%eax),%eax
  8036e8:	85 c0                	test   %eax,%eax
  8036ea:	75 08                	jne    8036f4 <alloc_block_FF+0x269>
  8036ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036ef:	a3 30 60 80 00       	mov    %eax,0x806030
  8036f4:	a1 38 60 80 00       	mov    0x806038,%eax
  8036f9:	40                   	inc    %eax
  8036fa:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8036ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803703:	75 17                	jne    80371c <alloc_block_FF+0x291>
  803705:	83 ec 04             	sub    $0x4,%esp
  803708:	68 8b 57 80 00       	push   $0x80578b
  80370d:	68 e1 00 00 00       	push   $0xe1
  803712:	68 a9 57 80 00       	push   $0x8057a9
  803717:	e8 97 de ff ff       	call   8015b3 <_panic>
  80371c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371f:	8b 00                	mov    (%eax),%eax
  803721:	85 c0                	test   %eax,%eax
  803723:	74 10                	je     803735 <alloc_block_FF+0x2aa>
  803725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803728:	8b 00                	mov    (%eax),%eax
  80372a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80372d:	8b 52 04             	mov    0x4(%edx),%edx
  803730:	89 50 04             	mov    %edx,0x4(%eax)
  803733:	eb 0b                	jmp    803740 <alloc_block_FF+0x2b5>
  803735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803738:	8b 40 04             	mov    0x4(%eax),%eax
  80373b:	a3 30 60 80 00       	mov    %eax,0x806030
  803740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803743:	8b 40 04             	mov    0x4(%eax),%eax
  803746:	85 c0                	test   %eax,%eax
  803748:	74 0f                	je     803759 <alloc_block_FF+0x2ce>
  80374a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374d:	8b 40 04             	mov    0x4(%eax),%eax
  803750:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803753:	8b 12                	mov    (%edx),%edx
  803755:	89 10                	mov    %edx,(%eax)
  803757:	eb 0a                	jmp    803763 <alloc_block_FF+0x2d8>
  803759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375c:	8b 00                	mov    (%eax),%eax
  80375e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803766:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80376c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803776:	a1 38 60 80 00       	mov    0x806038,%eax
  80377b:	48                   	dec    %eax
  80377c:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  803781:	83 ec 04             	sub    $0x4,%esp
  803784:	6a 00                	push   $0x0
  803786:	ff 75 b4             	pushl  -0x4c(%ebp)
  803789:	ff 75 b0             	pushl  -0x50(%ebp)
  80378c:	e8 cb fc ff ff       	call   80345c <set_block_data>
  803791:	83 c4 10             	add    $0x10,%esp
  803794:	e9 95 00 00 00       	jmp    80382e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803799:	83 ec 04             	sub    $0x4,%esp
  80379c:	6a 01                	push   $0x1
  80379e:	ff 75 b8             	pushl  -0x48(%ebp)
  8037a1:	ff 75 bc             	pushl  -0x44(%ebp)
  8037a4:	e8 b3 fc ff ff       	call   80345c <set_block_data>
  8037a9:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8037ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b0:	75 17                	jne    8037c9 <alloc_block_FF+0x33e>
  8037b2:	83 ec 04             	sub    $0x4,%esp
  8037b5:	68 8b 57 80 00       	push   $0x80578b
  8037ba:	68 e8 00 00 00       	push   $0xe8
  8037bf:	68 a9 57 80 00       	push   $0x8057a9
  8037c4:	e8 ea dd ff ff       	call   8015b3 <_panic>
  8037c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cc:	8b 00                	mov    (%eax),%eax
  8037ce:	85 c0                	test   %eax,%eax
  8037d0:	74 10                	je     8037e2 <alloc_block_FF+0x357>
  8037d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d5:	8b 00                	mov    (%eax),%eax
  8037d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037da:	8b 52 04             	mov    0x4(%edx),%edx
  8037dd:	89 50 04             	mov    %edx,0x4(%eax)
  8037e0:	eb 0b                	jmp    8037ed <alloc_block_FF+0x362>
  8037e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e5:	8b 40 04             	mov    0x4(%eax),%eax
  8037e8:	a3 30 60 80 00       	mov    %eax,0x806030
  8037ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f0:	8b 40 04             	mov    0x4(%eax),%eax
  8037f3:	85 c0                	test   %eax,%eax
  8037f5:	74 0f                	je     803806 <alloc_block_FF+0x37b>
  8037f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fa:	8b 40 04             	mov    0x4(%eax),%eax
  8037fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803800:	8b 12                	mov    (%edx),%edx
  803802:	89 10                	mov    %edx,(%eax)
  803804:	eb 0a                	jmp    803810 <alloc_block_FF+0x385>
  803806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803809:	8b 00                	mov    (%eax),%eax
  80380b:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803813:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80381c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803823:	a1 38 60 80 00       	mov    0x806038,%eax
  803828:	48                   	dec    %eax
  803829:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  80382e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803831:	e9 0f 01 00 00       	jmp    803945 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803836:	a1 34 60 80 00       	mov    0x806034,%eax
  80383b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80383e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803842:	74 07                	je     80384b <alloc_block_FF+0x3c0>
  803844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803847:	8b 00                	mov    (%eax),%eax
  803849:	eb 05                	jmp    803850 <alloc_block_FF+0x3c5>
  80384b:	b8 00 00 00 00       	mov    $0x0,%eax
  803850:	a3 34 60 80 00       	mov    %eax,0x806034
  803855:	a1 34 60 80 00       	mov    0x806034,%eax
  80385a:	85 c0                	test   %eax,%eax
  80385c:	0f 85 e9 fc ff ff    	jne    80354b <alloc_block_FF+0xc0>
  803862:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803866:	0f 85 df fc ff ff    	jne    80354b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80386c:	8b 45 08             	mov    0x8(%ebp),%eax
  80386f:	83 c0 08             	add    $0x8,%eax
  803872:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803875:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80387c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80387f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803882:	01 d0                	add    %edx,%eax
  803884:	48                   	dec    %eax
  803885:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803888:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80388b:	ba 00 00 00 00       	mov    $0x0,%edx
  803890:	f7 75 d8             	divl   -0x28(%ebp)
  803893:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803896:	29 d0                	sub    %edx,%eax
  803898:	c1 e8 0c             	shr    $0xc,%eax
  80389b:	83 ec 0c             	sub    $0xc,%esp
  80389e:	50                   	push   %eax
  80389f:	e8 66 ed ff ff       	call   80260a <sbrk>
  8038a4:	83 c4 10             	add    $0x10,%esp
  8038a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8038aa:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8038ae:	75 0a                	jne    8038ba <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8038b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b5:	e9 8b 00 00 00       	jmp    803945 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8038ba:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8038c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038c7:	01 d0                	add    %edx,%eax
  8038c9:	48                   	dec    %eax
  8038ca:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8038cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8038d5:	f7 75 cc             	divl   -0x34(%ebp)
  8038d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038db:	29 d0                	sub    %edx,%eax
  8038dd:	8d 50 fc             	lea    -0x4(%eax),%edx
  8038e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038e3:	01 d0                	add    %edx,%eax
  8038e5:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  8038ea:	a1 40 60 80 00       	mov    0x806040,%eax
  8038ef:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8038f5:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8038fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038ff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803902:	01 d0                	add    %edx,%eax
  803904:	48                   	dec    %eax
  803905:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803908:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80390b:	ba 00 00 00 00       	mov    $0x0,%edx
  803910:	f7 75 c4             	divl   -0x3c(%ebp)
  803913:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803916:	29 d0                	sub    %edx,%eax
  803918:	83 ec 04             	sub    $0x4,%esp
  80391b:	6a 01                	push   $0x1
  80391d:	50                   	push   %eax
  80391e:	ff 75 d0             	pushl  -0x30(%ebp)
  803921:	e8 36 fb ff ff       	call   80345c <set_block_data>
  803926:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803929:	83 ec 0c             	sub    $0xc,%esp
  80392c:	ff 75 d0             	pushl  -0x30(%ebp)
  80392f:	e8 1b 0a 00 00       	call   80434f <free_block>
  803934:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803937:	83 ec 0c             	sub    $0xc,%esp
  80393a:	ff 75 08             	pushl  0x8(%ebp)
  80393d:	e8 49 fb ff ff       	call   80348b <alloc_block_FF>
  803942:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803945:	c9                   	leave  
  803946:	c3                   	ret    

00803947 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803947:	55                   	push   %ebp
  803948:	89 e5                	mov    %esp,%ebp
  80394a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80394d:	8b 45 08             	mov    0x8(%ebp),%eax
  803950:	83 e0 01             	and    $0x1,%eax
  803953:	85 c0                	test   %eax,%eax
  803955:	74 03                	je     80395a <alloc_block_BF+0x13>
  803957:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80395a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80395e:	77 07                	ja     803967 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803960:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803967:	a1 24 60 80 00       	mov    0x806024,%eax
  80396c:	85 c0                	test   %eax,%eax
  80396e:	75 73                	jne    8039e3 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803970:	8b 45 08             	mov    0x8(%ebp),%eax
  803973:	83 c0 10             	add    $0x10,%eax
  803976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803979:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803980:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803983:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803986:	01 d0                	add    %edx,%eax
  803988:	48                   	dec    %eax
  803989:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80398c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80398f:	ba 00 00 00 00       	mov    $0x0,%edx
  803994:	f7 75 e0             	divl   -0x20(%ebp)
  803997:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80399a:	29 d0                	sub    %edx,%eax
  80399c:	c1 e8 0c             	shr    $0xc,%eax
  80399f:	83 ec 0c             	sub    $0xc,%esp
  8039a2:	50                   	push   %eax
  8039a3:	e8 62 ec ff ff       	call   80260a <sbrk>
  8039a8:	83 c4 10             	add    $0x10,%esp
  8039ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8039ae:	83 ec 0c             	sub    $0xc,%esp
  8039b1:	6a 00                	push   $0x0
  8039b3:	e8 52 ec ff ff       	call   80260a <sbrk>
  8039b8:	83 c4 10             	add    $0x10,%esp
  8039bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8039be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039c1:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8039c4:	83 ec 08             	sub    $0x8,%esp
  8039c7:	50                   	push   %eax
  8039c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8039cb:	e8 9f f8 ff ff       	call   80326f <initialize_dynamic_allocator>
  8039d0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8039d3:	83 ec 0c             	sub    $0xc,%esp
  8039d6:	68 e7 57 80 00       	push   $0x8057e7
  8039db:	e8 90 de ff ff       	call   801870 <cprintf>
  8039e0:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8039e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8039ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8039f1:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8039f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8039ff:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a07:	e9 1d 01 00 00       	jmp    803b29 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803a12:	83 ec 0c             	sub    $0xc,%esp
  803a15:	ff 75 a8             	pushl  -0x58(%ebp)
  803a18:	e8 ee f6 ff ff       	call   80310b <get_block_size>
  803a1d:	83 c4 10             	add    $0x10,%esp
  803a20:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803a23:	8b 45 08             	mov    0x8(%ebp),%eax
  803a26:	83 c0 08             	add    $0x8,%eax
  803a29:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803a2c:	0f 87 ef 00 00 00    	ja     803b21 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803a32:	8b 45 08             	mov    0x8(%ebp),%eax
  803a35:	83 c0 18             	add    $0x18,%eax
  803a38:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803a3b:	77 1d                	ja     803a5a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a40:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803a43:	0f 86 d8 00 00 00    	jbe    803b21 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803a49:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803a4f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803a52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803a55:	e9 c7 00 00 00       	jmp    803b21 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5d:	83 c0 08             	add    $0x8,%eax
  803a60:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803a63:	0f 85 9d 00 00 00    	jne    803b06 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803a69:	83 ec 04             	sub    $0x4,%esp
  803a6c:	6a 01                	push   $0x1
  803a6e:	ff 75 a4             	pushl  -0x5c(%ebp)
  803a71:	ff 75 a8             	pushl  -0x58(%ebp)
  803a74:	e8 e3 f9 ff ff       	call   80345c <set_block_data>
  803a79:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a80:	75 17                	jne    803a99 <alloc_block_BF+0x152>
  803a82:	83 ec 04             	sub    $0x4,%esp
  803a85:	68 8b 57 80 00       	push   $0x80578b
  803a8a:	68 2c 01 00 00       	push   $0x12c
  803a8f:	68 a9 57 80 00       	push   $0x8057a9
  803a94:	e8 1a db ff ff       	call   8015b3 <_panic>
  803a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9c:	8b 00                	mov    (%eax),%eax
  803a9e:	85 c0                	test   %eax,%eax
  803aa0:	74 10                	je     803ab2 <alloc_block_BF+0x16b>
  803aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa5:	8b 00                	mov    (%eax),%eax
  803aa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aaa:	8b 52 04             	mov    0x4(%edx),%edx
  803aad:	89 50 04             	mov    %edx,0x4(%eax)
  803ab0:	eb 0b                	jmp    803abd <alloc_block_BF+0x176>
  803ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab5:	8b 40 04             	mov    0x4(%eax),%eax
  803ab8:	a3 30 60 80 00       	mov    %eax,0x806030
  803abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac0:	8b 40 04             	mov    0x4(%eax),%eax
  803ac3:	85 c0                	test   %eax,%eax
  803ac5:	74 0f                	je     803ad6 <alloc_block_BF+0x18f>
  803ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aca:	8b 40 04             	mov    0x4(%eax),%eax
  803acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ad0:	8b 12                	mov    (%edx),%edx
  803ad2:	89 10                	mov    %edx,(%eax)
  803ad4:	eb 0a                	jmp    803ae0 <alloc_block_BF+0x199>
  803ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad9:	8b 00                	mov    (%eax),%eax
  803adb:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af3:	a1 38 60 80 00       	mov    0x806038,%eax
  803af8:	48                   	dec    %eax
  803af9:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  803afe:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803b01:	e9 24 04 00 00       	jmp    803f2a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803b06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b09:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803b0c:	76 13                	jbe    803b21 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803b0e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803b15:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803b1b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803b1e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803b21:	a1 34 60 80 00       	mov    0x806034,%eax
  803b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b2d:	74 07                	je     803b36 <alloc_block_BF+0x1ef>
  803b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b32:	8b 00                	mov    (%eax),%eax
  803b34:	eb 05                	jmp    803b3b <alloc_block_BF+0x1f4>
  803b36:	b8 00 00 00 00       	mov    $0x0,%eax
  803b3b:	a3 34 60 80 00       	mov    %eax,0x806034
  803b40:	a1 34 60 80 00       	mov    0x806034,%eax
  803b45:	85 c0                	test   %eax,%eax
  803b47:	0f 85 bf fe ff ff    	jne    803a0c <alloc_block_BF+0xc5>
  803b4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b51:	0f 85 b5 fe ff ff    	jne    803a0c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803b57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b5b:	0f 84 26 02 00 00    	je     803d87 <alloc_block_BF+0x440>
  803b61:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b65:	0f 85 1c 02 00 00    	jne    803d87 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b6e:	2b 45 08             	sub    0x8(%ebp),%eax
  803b71:	83 e8 08             	sub    $0x8,%eax
  803b74:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803b77:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7a:	8d 50 08             	lea    0x8(%eax),%edx
  803b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b80:	01 d0                	add    %edx,%eax
  803b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803b85:	8b 45 08             	mov    0x8(%ebp),%eax
  803b88:	83 c0 08             	add    $0x8,%eax
  803b8b:	83 ec 04             	sub    $0x4,%esp
  803b8e:	6a 01                	push   $0x1
  803b90:	50                   	push   %eax
  803b91:	ff 75 f0             	pushl  -0x10(%ebp)
  803b94:	e8 c3 f8 ff ff       	call   80345c <set_block_data>
  803b99:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b9f:	8b 40 04             	mov    0x4(%eax),%eax
  803ba2:	85 c0                	test   %eax,%eax
  803ba4:	75 68                	jne    803c0e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803ba6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803baa:	75 17                	jne    803bc3 <alloc_block_BF+0x27c>
  803bac:	83 ec 04             	sub    $0x4,%esp
  803baf:	68 c4 57 80 00       	push   $0x8057c4
  803bb4:	68 45 01 00 00       	push   $0x145
  803bb9:	68 a9 57 80 00       	push   $0x8057a9
  803bbe:	e8 f0 d9 ff ff       	call   8015b3 <_panic>
  803bc3:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803bc9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803bcc:	89 10                	mov    %edx,(%eax)
  803bce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803bd1:	8b 00                	mov    (%eax),%eax
  803bd3:	85 c0                	test   %eax,%eax
  803bd5:	74 0d                	je     803be4 <alloc_block_BF+0x29d>
  803bd7:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803bdc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803bdf:	89 50 04             	mov    %edx,0x4(%eax)
  803be2:	eb 08                	jmp    803bec <alloc_block_BF+0x2a5>
  803be4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803be7:	a3 30 60 80 00       	mov    %eax,0x806030
  803bec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803bef:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803bf4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803bf7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bfe:	a1 38 60 80 00       	mov    0x806038,%eax
  803c03:	40                   	inc    %eax
  803c04:	a3 38 60 80 00       	mov    %eax,0x806038
  803c09:	e9 dc 00 00 00       	jmp    803cea <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c11:	8b 00                	mov    (%eax),%eax
  803c13:	85 c0                	test   %eax,%eax
  803c15:	75 65                	jne    803c7c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803c17:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803c1b:	75 17                	jne    803c34 <alloc_block_BF+0x2ed>
  803c1d:	83 ec 04             	sub    $0x4,%esp
  803c20:	68 f8 57 80 00       	push   $0x8057f8
  803c25:	68 4a 01 00 00       	push   $0x14a
  803c2a:	68 a9 57 80 00       	push   $0x8057a9
  803c2f:	e8 7f d9 ff ff       	call   8015b3 <_panic>
  803c34:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803c3a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c3d:	89 50 04             	mov    %edx,0x4(%eax)
  803c40:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c43:	8b 40 04             	mov    0x4(%eax),%eax
  803c46:	85 c0                	test   %eax,%eax
  803c48:	74 0c                	je     803c56 <alloc_block_BF+0x30f>
  803c4a:	a1 30 60 80 00       	mov    0x806030,%eax
  803c4f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803c52:	89 10                	mov    %edx,(%eax)
  803c54:	eb 08                	jmp    803c5e <alloc_block_BF+0x317>
  803c56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c59:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803c5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c61:	a3 30 60 80 00       	mov    %eax,0x806030
  803c66:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c6f:	a1 38 60 80 00       	mov    0x806038,%eax
  803c74:	40                   	inc    %eax
  803c75:	a3 38 60 80 00       	mov    %eax,0x806038
  803c7a:	eb 6e                	jmp    803cea <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803c7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c80:	74 06                	je     803c88 <alloc_block_BF+0x341>
  803c82:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803c86:	75 17                	jne    803c9f <alloc_block_BF+0x358>
  803c88:	83 ec 04             	sub    $0x4,%esp
  803c8b:	68 1c 58 80 00       	push   $0x80581c
  803c90:	68 4f 01 00 00       	push   $0x14f
  803c95:	68 a9 57 80 00       	push   $0x8057a9
  803c9a:	e8 14 d9 ff ff       	call   8015b3 <_panic>
  803c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ca2:	8b 10                	mov    (%eax),%edx
  803ca4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803ca7:	89 10                	mov    %edx,(%eax)
  803ca9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cac:	8b 00                	mov    (%eax),%eax
  803cae:	85 c0                	test   %eax,%eax
  803cb0:	74 0b                	je     803cbd <alloc_block_BF+0x376>
  803cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cb5:	8b 00                	mov    (%eax),%eax
  803cb7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803cba:	89 50 04             	mov    %edx,0x4(%eax)
  803cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cc0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803cc3:	89 10                	mov    %edx,(%eax)
  803cc5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ccb:	89 50 04             	mov    %edx,0x4(%eax)
  803cce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cd1:	8b 00                	mov    (%eax),%eax
  803cd3:	85 c0                	test   %eax,%eax
  803cd5:	75 08                	jne    803cdf <alloc_block_BF+0x398>
  803cd7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cda:	a3 30 60 80 00       	mov    %eax,0x806030
  803cdf:	a1 38 60 80 00       	mov    0x806038,%eax
  803ce4:	40                   	inc    %eax
  803ce5:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803cea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cee:	75 17                	jne    803d07 <alloc_block_BF+0x3c0>
  803cf0:	83 ec 04             	sub    $0x4,%esp
  803cf3:	68 8b 57 80 00       	push   $0x80578b
  803cf8:	68 51 01 00 00       	push   $0x151
  803cfd:	68 a9 57 80 00       	push   $0x8057a9
  803d02:	e8 ac d8 ff ff       	call   8015b3 <_panic>
  803d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d0a:	8b 00                	mov    (%eax),%eax
  803d0c:	85 c0                	test   %eax,%eax
  803d0e:	74 10                	je     803d20 <alloc_block_BF+0x3d9>
  803d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d13:	8b 00                	mov    (%eax),%eax
  803d15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d18:	8b 52 04             	mov    0x4(%edx),%edx
  803d1b:	89 50 04             	mov    %edx,0x4(%eax)
  803d1e:	eb 0b                	jmp    803d2b <alloc_block_BF+0x3e4>
  803d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d23:	8b 40 04             	mov    0x4(%eax),%eax
  803d26:	a3 30 60 80 00       	mov    %eax,0x806030
  803d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d2e:	8b 40 04             	mov    0x4(%eax),%eax
  803d31:	85 c0                	test   %eax,%eax
  803d33:	74 0f                	je     803d44 <alloc_block_BF+0x3fd>
  803d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d38:	8b 40 04             	mov    0x4(%eax),%eax
  803d3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d3e:	8b 12                	mov    (%edx),%edx
  803d40:	89 10                	mov    %edx,(%eax)
  803d42:	eb 0a                	jmp    803d4e <alloc_block_BF+0x407>
  803d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d47:	8b 00                	mov    (%eax),%eax
  803d49:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d61:	a1 38 60 80 00       	mov    0x806038,%eax
  803d66:	48                   	dec    %eax
  803d67:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  803d6c:	83 ec 04             	sub    $0x4,%esp
  803d6f:	6a 00                	push   $0x0
  803d71:	ff 75 d0             	pushl  -0x30(%ebp)
  803d74:	ff 75 cc             	pushl  -0x34(%ebp)
  803d77:	e8 e0 f6 ff ff       	call   80345c <set_block_data>
  803d7c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d82:	e9 a3 01 00 00       	jmp    803f2a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803d87:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803d8b:	0f 85 9d 00 00 00    	jne    803e2e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803d91:	83 ec 04             	sub    $0x4,%esp
  803d94:	6a 01                	push   $0x1
  803d96:	ff 75 ec             	pushl  -0x14(%ebp)
  803d99:	ff 75 f0             	pushl  -0x10(%ebp)
  803d9c:	e8 bb f6 ff ff       	call   80345c <set_block_data>
  803da1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803da4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803da8:	75 17                	jne    803dc1 <alloc_block_BF+0x47a>
  803daa:	83 ec 04             	sub    $0x4,%esp
  803dad:	68 8b 57 80 00       	push   $0x80578b
  803db2:	68 58 01 00 00       	push   $0x158
  803db7:	68 a9 57 80 00       	push   $0x8057a9
  803dbc:	e8 f2 d7 ff ff       	call   8015b3 <_panic>
  803dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc4:	8b 00                	mov    (%eax),%eax
  803dc6:	85 c0                	test   %eax,%eax
  803dc8:	74 10                	je     803dda <alloc_block_BF+0x493>
  803dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dcd:	8b 00                	mov    (%eax),%eax
  803dcf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dd2:	8b 52 04             	mov    0x4(%edx),%edx
  803dd5:	89 50 04             	mov    %edx,0x4(%eax)
  803dd8:	eb 0b                	jmp    803de5 <alloc_block_BF+0x49e>
  803dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ddd:	8b 40 04             	mov    0x4(%eax),%eax
  803de0:	a3 30 60 80 00       	mov    %eax,0x806030
  803de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de8:	8b 40 04             	mov    0x4(%eax),%eax
  803deb:	85 c0                	test   %eax,%eax
  803ded:	74 0f                	je     803dfe <alloc_block_BF+0x4b7>
  803def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df2:	8b 40 04             	mov    0x4(%eax),%eax
  803df5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803df8:	8b 12                	mov    (%edx),%edx
  803dfa:	89 10                	mov    %edx,(%eax)
  803dfc:	eb 0a                	jmp    803e08 <alloc_block_BF+0x4c1>
  803dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e01:	8b 00                	mov    (%eax),%eax
  803e03:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e1b:	a1 38 60 80 00       	mov    0x806038,%eax
  803e20:	48                   	dec    %eax
  803e21:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e29:	e9 fc 00 00 00       	jmp    803f2a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e31:	83 c0 08             	add    $0x8,%eax
  803e34:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803e37:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803e3e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803e41:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e44:	01 d0                	add    %edx,%eax
  803e46:	48                   	dec    %eax
  803e47:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803e4a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e4d:	ba 00 00 00 00       	mov    $0x0,%edx
  803e52:	f7 75 c4             	divl   -0x3c(%ebp)
  803e55:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e58:	29 d0                	sub    %edx,%eax
  803e5a:	c1 e8 0c             	shr    $0xc,%eax
  803e5d:	83 ec 0c             	sub    $0xc,%esp
  803e60:	50                   	push   %eax
  803e61:	e8 a4 e7 ff ff       	call   80260a <sbrk>
  803e66:	83 c4 10             	add    $0x10,%esp
  803e69:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803e6c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803e70:	75 0a                	jne    803e7c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803e72:	b8 00 00 00 00       	mov    $0x0,%eax
  803e77:	e9 ae 00 00 00       	jmp    803f2a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803e7c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803e83:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803e86:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e89:	01 d0                	add    %edx,%eax
  803e8b:	48                   	dec    %eax
  803e8c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803e8f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803e92:	ba 00 00 00 00       	mov    $0x0,%edx
  803e97:	f7 75 b8             	divl   -0x48(%ebp)
  803e9a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803e9d:	29 d0                	sub    %edx,%eax
  803e9f:	8d 50 fc             	lea    -0x4(%eax),%edx
  803ea2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803ea5:	01 d0                	add    %edx,%eax
  803ea7:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  803eac:	a1 40 60 80 00       	mov    0x806040,%eax
  803eb1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803eb7:	83 ec 0c             	sub    $0xc,%esp
  803eba:	68 50 58 80 00       	push   $0x805850
  803ebf:	e8 ac d9 ff ff       	call   801870 <cprintf>
  803ec4:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803ec7:	83 ec 08             	sub    $0x8,%esp
  803eca:	ff 75 bc             	pushl  -0x44(%ebp)
  803ecd:	68 55 58 80 00       	push   $0x805855
  803ed2:	e8 99 d9 ff ff       	call   801870 <cprintf>
  803ed7:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803eda:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803ee1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ee4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803ee7:	01 d0                	add    %edx,%eax
  803ee9:	48                   	dec    %eax
  803eea:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803eed:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803ef0:	ba 00 00 00 00       	mov    $0x0,%edx
  803ef5:	f7 75 b0             	divl   -0x50(%ebp)
  803ef8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803efb:	29 d0                	sub    %edx,%eax
  803efd:	83 ec 04             	sub    $0x4,%esp
  803f00:	6a 01                	push   $0x1
  803f02:	50                   	push   %eax
  803f03:	ff 75 bc             	pushl  -0x44(%ebp)
  803f06:	e8 51 f5 ff ff       	call   80345c <set_block_data>
  803f0b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803f0e:	83 ec 0c             	sub    $0xc,%esp
  803f11:	ff 75 bc             	pushl  -0x44(%ebp)
  803f14:	e8 36 04 00 00       	call   80434f <free_block>
  803f19:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803f1c:	83 ec 0c             	sub    $0xc,%esp
  803f1f:	ff 75 08             	pushl  0x8(%ebp)
  803f22:	e8 20 fa ff ff       	call   803947 <alloc_block_BF>
  803f27:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803f2a:	c9                   	leave  
  803f2b:	c3                   	ret    

00803f2c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803f2c:	55                   	push   %ebp
  803f2d:	89 e5                	mov    %esp,%ebp
  803f2f:	53                   	push   %ebx
  803f30:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803f33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803f3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803f41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f45:	74 1e                	je     803f65 <merging+0x39>
  803f47:	ff 75 08             	pushl  0x8(%ebp)
  803f4a:	e8 bc f1 ff ff       	call   80310b <get_block_size>
  803f4f:	83 c4 04             	add    $0x4,%esp
  803f52:	89 c2                	mov    %eax,%edx
  803f54:	8b 45 08             	mov    0x8(%ebp),%eax
  803f57:	01 d0                	add    %edx,%eax
  803f59:	3b 45 10             	cmp    0x10(%ebp),%eax
  803f5c:	75 07                	jne    803f65 <merging+0x39>
		prev_is_free = 1;
  803f5e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803f65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803f69:	74 1e                	je     803f89 <merging+0x5d>
  803f6b:	ff 75 10             	pushl  0x10(%ebp)
  803f6e:	e8 98 f1 ff ff       	call   80310b <get_block_size>
  803f73:	83 c4 04             	add    $0x4,%esp
  803f76:	89 c2                	mov    %eax,%edx
  803f78:	8b 45 10             	mov    0x10(%ebp),%eax
  803f7b:	01 d0                	add    %edx,%eax
  803f7d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803f80:	75 07                	jne    803f89 <merging+0x5d>
		next_is_free = 1;
  803f82:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803f89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f8d:	0f 84 cc 00 00 00    	je     80405f <merging+0x133>
  803f93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f97:	0f 84 c2 00 00 00    	je     80405f <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803f9d:	ff 75 08             	pushl  0x8(%ebp)
  803fa0:	e8 66 f1 ff ff       	call   80310b <get_block_size>
  803fa5:	83 c4 04             	add    $0x4,%esp
  803fa8:	89 c3                	mov    %eax,%ebx
  803faa:	ff 75 10             	pushl  0x10(%ebp)
  803fad:	e8 59 f1 ff ff       	call   80310b <get_block_size>
  803fb2:	83 c4 04             	add    $0x4,%esp
  803fb5:	01 c3                	add    %eax,%ebx
  803fb7:	ff 75 0c             	pushl  0xc(%ebp)
  803fba:	e8 4c f1 ff ff       	call   80310b <get_block_size>
  803fbf:	83 c4 04             	add    $0x4,%esp
  803fc2:	01 d8                	add    %ebx,%eax
  803fc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803fc7:	6a 00                	push   $0x0
  803fc9:	ff 75 ec             	pushl  -0x14(%ebp)
  803fcc:	ff 75 08             	pushl  0x8(%ebp)
  803fcf:	e8 88 f4 ff ff       	call   80345c <set_block_data>
  803fd4:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803fd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803fdb:	75 17                	jne    803ff4 <merging+0xc8>
  803fdd:	83 ec 04             	sub    $0x4,%esp
  803fe0:	68 8b 57 80 00       	push   $0x80578b
  803fe5:	68 7d 01 00 00       	push   $0x17d
  803fea:	68 a9 57 80 00       	push   $0x8057a9
  803fef:	e8 bf d5 ff ff       	call   8015b3 <_panic>
  803ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ff7:	8b 00                	mov    (%eax),%eax
  803ff9:	85 c0                	test   %eax,%eax
  803ffb:	74 10                	je     80400d <merging+0xe1>
  803ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  804000:	8b 00                	mov    (%eax),%eax
  804002:	8b 55 0c             	mov    0xc(%ebp),%edx
  804005:	8b 52 04             	mov    0x4(%edx),%edx
  804008:	89 50 04             	mov    %edx,0x4(%eax)
  80400b:	eb 0b                	jmp    804018 <merging+0xec>
  80400d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804010:	8b 40 04             	mov    0x4(%eax),%eax
  804013:	a3 30 60 80 00       	mov    %eax,0x806030
  804018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80401b:	8b 40 04             	mov    0x4(%eax),%eax
  80401e:	85 c0                	test   %eax,%eax
  804020:	74 0f                	je     804031 <merging+0x105>
  804022:	8b 45 0c             	mov    0xc(%ebp),%eax
  804025:	8b 40 04             	mov    0x4(%eax),%eax
  804028:	8b 55 0c             	mov    0xc(%ebp),%edx
  80402b:	8b 12                	mov    (%edx),%edx
  80402d:	89 10                	mov    %edx,(%eax)
  80402f:	eb 0a                	jmp    80403b <merging+0x10f>
  804031:	8b 45 0c             	mov    0xc(%ebp),%eax
  804034:	8b 00                	mov    (%eax),%eax
  804036:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80403b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80403e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804044:	8b 45 0c             	mov    0xc(%ebp),%eax
  804047:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80404e:	a1 38 60 80 00       	mov    0x806038,%eax
  804053:	48                   	dec    %eax
  804054:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  804059:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80405a:	e9 ea 02 00 00       	jmp    804349 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80405f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804063:	74 3b                	je     8040a0 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  804065:	83 ec 0c             	sub    $0xc,%esp
  804068:	ff 75 08             	pushl  0x8(%ebp)
  80406b:	e8 9b f0 ff ff       	call   80310b <get_block_size>
  804070:	83 c4 10             	add    $0x10,%esp
  804073:	89 c3                	mov    %eax,%ebx
  804075:	83 ec 0c             	sub    $0xc,%esp
  804078:	ff 75 10             	pushl  0x10(%ebp)
  80407b:	e8 8b f0 ff ff       	call   80310b <get_block_size>
  804080:	83 c4 10             	add    $0x10,%esp
  804083:	01 d8                	add    %ebx,%eax
  804085:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  804088:	83 ec 04             	sub    $0x4,%esp
  80408b:	6a 00                	push   $0x0
  80408d:	ff 75 e8             	pushl  -0x18(%ebp)
  804090:	ff 75 08             	pushl  0x8(%ebp)
  804093:	e8 c4 f3 ff ff       	call   80345c <set_block_data>
  804098:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80409b:	e9 a9 02 00 00       	jmp    804349 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8040a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8040a4:	0f 84 2d 01 00 00    	je     8041d7 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8040aa:	83 ec 0c             	sub    $0xc,%esp
  8040ad:	ff 75 10             	pushl  0x10(%ebp)
  8040b0:	e8 56 f0 ff ff       	call   80310b <get_block_size>
  8040b5:	83 c4 10             	add    $0x10,%esp
  8040b8:	89 c3                	mov    %eax,%ebx
  8040ba:	83 ec 0c             	sub    $0xc,%esp
  8040bd:	ff 75 0c             	pushl  0xc(%ebp)
  8040c0:	e8 46 f0 ff ff       	call   80310b <get_block_size>
  8040c5:	83 c4 10             	add    $0x10,%esp
  8040c8:	01 d8                	add    %ebx,%eax
  8040ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8040cd:	83 ec 04             	sub    $0x4,%esp
  8040d0:	6a 00                	push   $0x0
  8040d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8040d5:	ff 75 10             	pushl  0x10(%ebp)
  8040d8:	e8 7f f3 ff ff       	call   80345c <set_block_data>
  8040dd:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8040e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8040e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8040e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8040ea:	74 06                	je     8040f2 <merging+0x1c6>
  8040ec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8040f0:	75 17                	jne    804109 <merging+0x1dd>
  8040f2:	83 ec 04             	sub    $0x4,%esp
  8040f5:	68 64 58 80 00       	push   $0x805864
  8040fa:	68 8d 01 00 00       	push   $0x18d
  8040ff:	68 a9 57 80 00       	push   $0x8057a9
  804104:	e8 aa d4 ff ff       	call   8015b3 <_panic>
  804109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80410c:	8b 50 04             	mov    0x4(%eax),%edx
  80410f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804112:	89 50 04             	mov    %edx,0x4(%eax)
  804115:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804118:	8b 55 0c             	mov    0xc(%ebp),%edx
  80411b:	89 10                	mov    %edx,(%eax)
  80411d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804120:	8b 40 04             	mov    0x4(%eax),%eax
  804123:	85 c0                	test   %eax,%eax
  804125:	74 0d                	je     804134 <merging+0x208>
  804127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80412a:	8b 40 04             	mov    0x4(%eax),%eax
  80412d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804130:	89 10                	mov    %edx,(%eax)
  804132:	eb 08                	jmp    80413c <merging+0x210>
  804134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804137:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80413c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80413f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804142:	89 50 04             	mov    %edx,0x4(%eax)
  804145:	a1 38 60 80 00       	mov    0x806038,%eax
  80414a:	40                   	inc    %eax
  80414b:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  804150:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804154:	75 17                	jne    80416d <merging+0x241>
  804156:	83 ec 04             	sub    $0x4,%esp
  804159:	68 8b 57 80 00       	push   $0x80578b
  80415e:	68 8e 01 00 00       	push   $0x18e
  804163:	68 a9 57 80 00       	push   $0x8057a9
  804168:	e8 46 d4 ff ff       	call   8015b3 <_panic>
  80416d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804170:	8b 00                	mov    (%eax),%eax
  804172:	85 c0                	test   %eax,%eax
  804174:	74 10                	je     804186 <merging+0x25a>
  804176:	8b 45 0c             	mov    0xc(%ebp),%eax
  804179:	8b 00                	mov    (%eax),%eax
  80417b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80417e:	8b 52 04             	mov    0x4(%edx),%edx
  804181:	89 50 04             	mov    %edx,0x4(%eax)
  804184:	eb 0b                	jmp    804191 <merging+0x265>
  804186:	8b 45 0c             	mov    0xc(%ebp),%eax
  804189:	8b 40 04             	mov    0x4(%eax),%eax
  80418c:	a3 30 60 80 00       	mov    %eax,0x806030
  804191:	8b 45 0c             	mov    0xc(%ebp),%eax
  804194:	8b 40 04             	mov    0x4(%eax),%eax
  804197:	85 c0                	test   %eax,%eax
  804199:	74 0f                	je     8041aa <merging+0x27e>
  80419b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80419e:	8b 40 04             	mov    0x4(%eax),%eax
  8041a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8041a4:	8b 12                	mov    (%edx),%edx
  8041a6:	89 10                	mov    %edx,(%eax)
  8041a8:	eb 0a                	jmp    8041b4 <merging+0x288>
  8041aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041ad:	8b 00                	mov    (%eax),%eax
  8041af:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8041b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041c7:	a1 38 60 80 00       	mov    0x806038,%eax
  8041cc:	48                   	dec    %eax
  8041cd:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8041d2:	e9 72 01 00 00       	jmp    804349 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8041d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8041da:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8041dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041e1:	74 79                	je     80425c <merging+0x330>
  8041e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8041e7:	74 73                	je     80425c <merging+0x330>
  8041e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041ed:	74 06                	je     8041f5 <merging+0x2c9>
  8041ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8041f3:	75 17                	jne    80420c <merging+0x2e0>
  8041f5:	83 ec 04             	sub    $0x4,%esp
  8041f8:	68 1c 58 80 00       	push   $0x80581c
  8041fd:	68 94 01 00 00       	push   $0x194
  804202:	68 a9 57 80 00       	push   $0x8057a9
  804207:	e8 a7 d3 ff ff       	call   8015b3 <_panic>
  80420c:	8b 45 08             	mov    0x8(%ebp),%eax
  80420f:	8b 10                	mov    (%eax),%edx
  804211:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804214:	89 10                	mov    %edx,(%eax)
  804216:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804219:	8b 00                	mov    (%eax),%eax
  80421b:	85 c0                	test   %eax,%eax
  80421d:	74 0b                	je     80422a <merging+0x2fe>
  80421f:	8b 45 08             	mov    0x8(%ebp),%eax
  804222:	8b 00                	mov    (%eax),%eax
  804224:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804227:	89 50 04             	mov    %edx,0x4(%eax)
  80422a:	8b 45 08             	mov    0x8(%ebp),%eax
  80422d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804230:	89 10                	mov    %edx,(%eax)
  804232:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804235:	8b 55 08             	mov    0x8(%ebp),%edx
  804238:	89 50 04             	mov    %edx,0x4(%eax)
  80423b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80423e:	8b 00                	mov    (%eax),%eax
  804240:	85 c0                	test   %eax,%eax
  804242:	75 08                	jne    80424c <merging+0x320>
  804244:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804247:	a3 30 60 80 00       	mov    %eax,0x806030
  80424c:	a1 38 60 80 00       	mov    0x806038,%eax
  804251:	40                   	inc    %eax
  804252:	a3 38 60 80 00       	mov    %eax,0x806038
  804257:	e9 ce 00 00 00       	jmp    80432a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80425c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804260:	74 65                	je     8042c7 <merging+0x39b>
  804262:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804266:	75 17                	jne    80427f <merging+0x353>
  804268:	83 ec 04             	sub    $0x4,%esp
  80426b:	68 f8 57 80 00       	push   $0x8057f8
  804270:	68 95 01 00 00       	push   $0x195
  804275:	68 a9 57 80 00       	push   $0x8057a9
  80427a:	e8 34 d3 ff ff       	call   8015b3 <_panic>
  80427f:	8b 15 30 60 80 00    	mov    0x806030,%edx
  804285:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804288:	89 50 04             	mov    %edx,0x4(%eax)
  80428b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80428e:	8b 40 04             	mov    0x4(%eax),%eax
  804291:	85 c0                	test   %eax,%eax
  804293:	74 0c                	je     8042a1 <merging+0x375>
  804295:	a1 30 60 80 00       	mov    0x806030,%eax
  80429a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80429d:	89 10                	mov    %edx,(%eax)
  80429f:	eb 08                	jmp    8042a9 <merging+0x37d>
  8042a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042a4:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8042a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042ac:	a3 30 60 80 00       	mov    %eax,0x806030
  8042b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042ba:	a1 38 60 80 00       	mov    0x806038,%eax
  8042bf:	40                   	inc    %eax
  8042c0:	a3 38 60 80 00       	mov    %eax,0x806038
  8042c5:	eb 63                	jmp    80432a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8042c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8042cb:	75 17                	jne    8042e4 <merging+0x3b8>
  8042cd:	83 ec 04             	sub    $0x4,%esp
  8042d0:	68 c4 57 80 00       	push   $0x8057c4
  8042d5:	68 98 01 00 00       	push   $0x198
  8042da:	68 a9 57 80 00       	push   $0x8057a9
  8042df:	e8 cf d2 ff ff       	call   8015b3 <_panic>
  8042e4:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8042ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042ed:	89 10                	mov    %edx,(%eax)
  8042ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042f2:	8b 00                	mov    (%eax),%eax
  8042f4:	85 c0                	test   %eax,%eax
  8042f6:	74 0d                	je     804305 <merging+0x3d9>
  8042f8:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8042fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804300:	89 50 04             	mov    %edx,0x4(%eax)
  804303:	eb 08                	jmp    80430d <merging+0x3e1>
  804305:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804308:	a3 30 60 80 00       	mov    %eax,0x806030
  80430d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804310:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804315:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804318:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80431f:	a1 38 60 80 00       	mov    0x806038,%eax
  804324:	40                   	inc    %eax
  804325:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  80432a:	83 ec 0c             	sub    $0xc,%esp
  80432d:	ff 75 10             	pushl  0x10(%ebp)
  804330:	e8 d6 ed ff ff       	call   80310b <get_block_size>
  804335:	83 c4 10             	add    $0x10,%esp
  804338:	83 ec 04             	sub    $0x4,%esp
  80433b:	6a 00                	push   $0x0
  80433d:	50                   	push   %eax
  80433e:	ff 75 10             	pushl  0x10(%ebp)
  804341:	e8 16 f1 ff ff       	call   80345c <set_block_data>
  804346:	83 c4 10             	add    $0x10,%esp
	}
}
  804349:	90                   	nop
  80434a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80434d:	c9                   	leave  
  80434e:	c3                   	ret    

0080434f <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80434f:	55                   	push   %ebp
  804350:	89 e5                	mov    %esp,%ebp
  804352:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  804355:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80435a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80435d:	a1 30 60 80 00       	mov    0x806030,%eax
  804362:	3b 45 08             	cmp    0x8(%ebp),%eax
  804365:	73 1b                	jae    804382 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  804367:	a1 30 60 80 00       	mov    0x806030,%eax
  80436c:	83 ec 04             	sub    $0x4,%esp
  80436f:	ff 75 08             	pushl  0x8(%ebp)
  804372:	6a 00                	push   $0x0
  804374:	50                   	push   %eax
  804375:	e8 b2 fb ff ff       	call   803f2c <merging>
  80437a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80437d:	e9 8b 00 00 00       	jmp    80440d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  804382:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804387:	3b 45 08             	cmp    0x8(%ebp),%eax
  80438a:	76 18                	jbe    8043a4 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80438c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804391:	83 ec 04             	sub    $0x4,%esp
  804394:	ff 75 08             	pushl  0x8(%ebp)
  804397:	50                   	push   %eax
  804398:	6a 00                	push   $0x0
  80439a:	e8 8d fb ff ff       	call   803f2c <merging>
  80439f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8043a2:	eb 69                	jmp    80440d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8043a4:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8043a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043ac:	eb 39                	jmp    8043e7 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8043ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8043b4:	73 29                	jae    8043df <free_block+0x90>
  8043b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043b9:	8b 00                	mov    (%eax),%eax
  8043bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8043be:	76 1f                	jbe    8043df <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8043c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043c3:	8b 00                	mov    (%eax),%eax
  8043c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8043c8:	83 ec 04             	sub    $0x4,%esp
  8043cb:	ff 75 08             	pushl  0x8(%ebp)
  8043ce:	ff 75 f0             	pushl  -0x10(%ebp)
  8043d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8043d4:	e8 53 fb ff ff       	call   803f2c <merging>
  8043d9:	83 c4 10             	add    $0x10,%esp
			break;
  8043dc:	90                   	nop
		}
	}
}
  8043dd:	eb 2e                	jmp    80440d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8043df:	a1 34 60 80 00       	mov    0x806034,%eax
  8043e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043eb:	74 07                	je     8043f4 <free_block+0xa5>
  8043ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043f0:	8b 00                	mov    (%eax),%eax
  8043f2:	eb 05                	jmp    8043f9 <free_block+0xaa>
  8043f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8043f9:	a3 34 60 80 00       	mov    %eax,0x806034
  8043fe:	a1 34 60 80 00       	mov    0x806034,%eax
  804403:	85 c0                	test   %eax,%eax
  804405:	75 a7                	jne    8043ae <free_block+0x5f>
  804407:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80440b:	75 a1                	jne    8043ae <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80440d:	90                   	nop
  80440e:	c9                   	leave  
  80440f:	c3                   	ret    

00804410 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  804410:	55                   	push   %ebp
  804411:	89 e5                	mov    %esp,%ebp
  804413:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  804416:	ff 75 08             	pushl  0x8(%ebp)
  804419:	e8 ed ec ff ff       	call   80310b <get_block_size>
  80441e:	83 c4 04             	add    $0x4,%esp
  804421:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  804424:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80442b:	eb 17                	jmp    804444 <copy_data+0x34>
  80442d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804430:	8b 45 0c             	mov    0xc(%ebp),%eax
  804433:	01 c2                	add    %eax,%edx
  804435:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  804438:	8b 45 08             	mov    0x8(%ebp),%eax
  80443b:	01 c8                	add    %ecx,%eax
  80443d:	8a 00                	mov    (%eax),%al
  80443f:	88 02                	mov    %al,(%edx)
  804441:	ff 45 fc             	incl   -0x4(%ebp)
  804444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804447:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80444a:	72 e1                	jb     80442d <copy_data+0x1d>
}
  80444c:	90                   	nop
  80444d:	c9                   	leave  
  80444e:	c3                   	ret    

0080444f <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80444f:	55                   	push   %ebp
  804450:	89 e5                	mov    %esp,%ebp
  804452:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  804455:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804459:	75 23                	jne    80447e <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80445b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80445f:	74 13                	je     804474 <realloc_block_FF+0x25>
  804461:	83 ec 0c             	sub    $0xc,%esp
  804464:	ff 75 0c             	pushl  0xc(%ebp)
  804467:	e8 1f f0 ff ff       	call   80348b <alloc_block_FF>
  80446c:	83 c4 10             	add    $0x10,%esp
  80446f:	e9 f4 06 00 00       	jmp    804b68 <realloc_block_FF+0x719>
		return NULL;
  804474:	b8 00 00 00 00       	mov    $0x0,%eax
  804479:	e9 ea 06 00 00       	jmp    804b68 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80447e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804482:	75 18                	jne    80449c <realloc_block_FF+0x4d>
	{
		free_block(va);
  804484:	83 ec 0c             	sub    $0xc,%esp
  804487:	ff 75 08             	pushl  0x8(%ebp)
  80448a:	e8 c0 fe ff ff       	call   80434f <free_block>
  80448f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  804492:	b8 00 00 00 00       	mov    $0x0,%eax
  804497:	e9 cc 06 00 00       	jmp    804b68 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80449c:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8044a0:	77 07                	ja     8044a9 <realloc_block_FF+0x5a>
  8044a2:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8044a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044ac:	83 e0 01             	and    $0x1,%eax
  8044af:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8044b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044b5:	83 c0 08             	add    $0x8,%eax
  8044b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8044bb:	83 ec 0c             	sub    $0xc,%esp
  8044be:	ff 75 08             	pushl  0x8(%ebp)
  8044c1:	e8 45 ec ff ff       	call   80310b <get_block_size>
  8044c6:	83 c4 10             	add    $0x10,%esp
  8044c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8044cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044cf:	83 e8 08             	sub    $0x8,%eax
  8044d2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8044d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8044d8:	83 e8 04             	sub    $0x4,%eax
  8044db:	8b 00                	mov    (%eax),%eax
  8044dd:	83 e0 fe             	and    $0xfffffffe,%eax
  8044e0:	89 c2                	mov    %eax,%edx
  8044e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8044e5:	01 d0                	add    %edx,%eax
  8044e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8044ea:	83 ec 0c             	sub    $0xc,%esp
  8044ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8044f0:	e8 16 ec ff ff       	call   80310b <get_block_size>
  8044f5:	83 c4 10             	add    $0x10,%esp
  8044f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8044fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044fe:	83 e8 08             	sub    $0x8,%eax
  804501:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  804504:	8b 45 0c             	mov    0xc(%ebp),%eax
  804507:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80450a:	75 08                	jne    804514 <realloc_block_FF+0xc5>
	{
		 return va;
  80450c:	8b 45 08             	mov    0x8(%ebp),%eax
  80450f:	e9 54 06 00 00       	jmp    804b68 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  804514:	8b 45 0c             	mov    0xc(%ebp),%eax
  804517:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80451a:	0f 83 e5 03 00 00    	jae    804905 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  804520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804523:	2b 45 0c             	sub    0xc(%ebp),%eax
  804526:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804529:	83 ec 0c             	sub    $0xc,%esp
  80452c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80452f:	e8 f0 eb ff ff       	call   803124 <is_free_block>
  804534:	83 c4 10             	add    $0x10,%esp
  804537:	84 c0                	test   %al,%al
  804539:	0f 84 3b 01 00 00    	je     80467a <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80453f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804542:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804545:	01 d0                	add    %edx,%eax
  804547:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80454a:	83 ec 04             	sub    $0x4,%esp
  80454d:	6a 01                	push   $0x1
  80454f:	ff 75 f0             	pushl  -0x10(%ebp)
  804552:	ff 75 08             	pushl  0x8(%ebp)
  804555:	e8 02 ef ff ff       	call   80345c <set_block_data>
  80455a:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80455d:	8b 45 08             	mov    0x8(%ebp),%eax
  804560:	83 e8 04             	sub    $0x4,%eax
  804563:	8b 00                	mov    (%eax),%eax
  804565:	83 e0 fe             	and    $0xfffffffe,%eax
  804568:	89 c2                	mov    %eax,%edx
  80456a:	8b 45 08             	mov    0x8(%ebp),%eax
  80456d:	01 d0                	add    %edx,%eax
  80456f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  804572:	83 ec 04             	sub    $0x4,%esp
  804575:	6a 00                	push   $0x0
  804577:	ff 75 cc             	pushl  -0x34(%ebp)
  80457a:	ff 75 c8             	pushl  -0x38(%ebp)
  80457d:	e8 da ee ff ff       	call   80345c <set_block_data>
  804582:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804585:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804589:	74 06                	je     804591 <realloc_block_FF+0x142>
  80458b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80458f:	75 17                	jne    8045a8 <realloc_block_FF+0x159>
  804591:	83 ec 04             	sub    $0x4,%esp
  804594:	68 1c 58 80 00       	push   $0x80581c
  804599:	68 f6 01 00 00       	push   $0x1f6
  80459e:	68 a9 57 80 00       	push   $0x8057a9
  8045a3:	e8 0b d0 ff ff       	call   8015b3 <_panic>
  8045a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045ab:	8b 10                	mov    (%eax),%edx
  8045ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8045b0:	89 10                	mov    %edx,(%eax)
  8045b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8045b5:	8b 00                	mov    (%eax),%eax
  8045b7:	85 c0                	test   %eax,%eax
  8045b9:	74 0b                	je     8045c6 <realloc_block_FF+0x177>
  8045bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045be:	8b 00                	mov    (%eax),%eax
  8045c0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8045c3:	89 50 04             	mov    %edx,0x4(%eax)
  8045c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045c9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8045cc:	89 10                	mov    %edx,(%eax)
  8045ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8045d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045d4:	89 50 04             	mov    %edx,0x4(%eax)
  8045d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8045da:	8b 00                	mov    (%eax),%eax
  8045dc:	85 c0                	test   %eax,%eax
  8045de:	75 08                	jne    8045e8 <realloc_block_FF+0x199>
  8045e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8045e3:	a3 30 60 80 00       	mov    %eax,0x806030
  8045e8:	a1 38 60 80 00       	mov    0x806038,%eax
  8045ed:	40                   	inc    %eax
  8045ee:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8045f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045f7:	75 17                	jne    804610 <realloc_block_FF+0x1c1>
  8045f9:	83 ec 04             	sub    $0x4,%esp
  8045fc:	68 8b 57 80 00       	push   $0x80578b
  804601:	68 f7 01 00 00       	push   $0x1f7
  804606:	68 a9 57 80 00       	push   $0x8057a9
  80460b:	e8 a3 cf ff ff       	call   8015b3 <_panic>
  804610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804613:	8b 00                	mov    (%eax),%eax
  804615:	85 c0                	test   %eax,%eax
  804617:	74 10                	je     804629 <realloc_block_FF+0x1da>
  804619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80461c:	8b 00                	mov    (%eax),%eax
  80461e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804621:	8b 52 04             	mov    0x4(%edx),%edx
  804624:	89 50 04             	mov    %edx,0x4(%eax)
  804627:	eb 0b                	jmp    804634 <realloc_block_FF+0x1e5>
  804629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80462c:	8b 40 04             	mov    0x4(%eax),%eax
  80462f:	a3 30 60 80 00       	mov    %eax,0x806030
  804634:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804637:	8b 40 04             	mov    0x4(%eax),%eax
  80463a:	85 c0                	test   %eax,%eax
  80463c:	74 0f                	je     80464d <realloc_block_FF+0x1fe>
  80463e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804641:	8b 40 04             	mov    0x4(%eax),%eax
  804644:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804647:	8b 12                	mov    (%edx),%edx
  804649:	89 10                	mov    %edx,(%eax)
  80464b:	eb 0a                	jmp    804657 <realloc_block_FF+0x208>
  80464d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804650:	8b 00                	mov    (%eax),%eax
  804652:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80465a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804660:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804663:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80466a:	a1 38 60 80 00       	mov    0x806038,%eax
  80466f:	48                   	dec    %eax
  804670:	a3 38 60 80 00       	mov    %eax,0x806038
  804675:	e9 83 02 00 00       	jmp    8048fd <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80467a:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80467e:	0f 86 69 02 00 00    	jbe    8048ed <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804684:	83 ec 04             	sub    $0x4,%esp
  804687:	6a 01                	push   $0x1
  804689:	ff 75 f0             	pushl  -0x10(%ebp)
  80468c:	ff 75 08             	pushl  0x8(%ebp)
  80468f:	e8 c8 ed ff ff       	call   80345c <set_block_data>
  804694:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804697:	8b 45 08             	mov    0x8(%ebp),%eax
  80469a:	83 e8 04             	sub    $0x4,%eax
  80469d:	8b 00                	mov    (%eax),%eax
  80469f:	83 e0 fe             	and    $0xfffffffe,%eax
  8046a2:	89 c2                	mov    %eax,%edx
  8046a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8046a7:	01 d0                	add    %edx,%eax
  8046a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8046ac:	a1 38 60 80 00       	mov    0x806038,%eax
  8046b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8046b4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8046b8:	75 68                	jne    804722 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8046ba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8046be:	75 17                	jne    8046d7 <realloc_block_FF+0x288>
  8046c0:	83 ec 04             	sub    $0x4,%esp
  8046c3:	68 c4 57 80 00       	push   $0x8057c4
  8046c8:	68 06 02 00 00       	push   $0x206
  8046cd:	68 a9 57 80 00       	push   $0x8057a9
  8046d2:	e8 dc ce ff ff       	call   8015b3 <_panic>
  8046d7:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8046dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8046e0:	89 10                	mov    %edx,(%eax)
  8046e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8046e5:	8b 00                	mov    (%eax),%eax
  8046e7:	85 c0                	test   %eax,%eax
  8046e9:	74 0d                	je     8046f8 <realloc_block_FF+0x2a9>
  8046eb:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8046f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8046f3:	89 50 04             	mov    %edx,0x4(%eax)
  8046f6:	eb 08                	jmp    804700 <realloc_block_FF+0x2b1>
  8046f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8046fb:	a3 30 60 80 00       	mov    %eax,0x806030
  804700:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804703:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804708:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80470b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804712:	a1 38 60 80 00       	mov    0x806038,%eax
  804717:	40                   	inc    %eax
  804718:	a3 38 60 80 00       	mov    %eax,0x806038
  80471d:	e9 b0 01 00 00       	jmp    8048d2 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804722:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804727:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80472a:	76 68                	jbe    804794 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80472c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804730:	75 17                	jne    804749 <realloc_block_FF+0x2fa>
  804732:	83 ec 04             	sub    $0x4,%esp
  804735:	68 c4 57 80 00       	push   $0x8057c4
  80473a:	68 0b 02 00 00       	push   $0x20b
  80473f:	68 a9 57 80 00       	push   $0x8057a9
  804744:	e8 6a ce ff ff       	call   8015b3 <_panic>
  804749:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  80474f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804752:	89 10                	mov    %edx,(%eax)
  804754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804757:	8b 00                	mov    (%eax),%eax
  804759:	85 c0                	test   %eax,%eax
  80475b:	74 0d                	je     80476a <realloc_block_FF+0x31b>
  80475d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804762:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804765:	89 50 04             	mov    %edx,0x4(%eax)
  804768:	eb 08                	jmp    804772 <realloc_block_FF+0x323>
  80476a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80476d:	a3 30 60 80 00       	mov    %eax,0x806030
  804772:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804775:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80477a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80477d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804784:	a1 38 60 80 00       	mov    0x806038,%eax
  804789:	40                   	inc    %eax
  80478a:	a3 38 60 80 00       	mov    %eax,0x806038
  80478f:	e9 3e 01 00 00       	jmp    8048d2 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804794:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804799:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80479c:	73 68                	jae    804806 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80479e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8047a2:	75 17                	jne    8047bb <realloc_block_FF+0x36c>
  8047a4:	83 ec 04             	sub    $0x4,%esp
  8047a7:	68 f8 57 80 00       	push   $0x8057f8
  8047ac:	68 10 02 00 00       	push   $0x210
  8047b1:	68 a9 57 80 00       	push   $0x8057a9
  8047b6:	e8 f8 cd ff ff       	call   8015b3 <_panic>
  8047bb:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8047c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047c4:	89 50 04             	mov    %edx,0x4(%eax)
  8047c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047ca:	8b 40 04             	mov    0x4(%eax),%eax
  8047cd:	85 c0                	test   %eax,%eax
  8047cf:	74 0c                	je     8047dd <realloc_block_FF+0x38e>
  8047d1:	a1 30 60 80 00       	mov    0x806030,%eax
  8047d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8047d9:	89 10                	mov    %edx,(%eax)
  8047db:	eb 08                	jmp    8047e5 <realloc_block_FF+0x396>
  8047dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047e0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8047e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047e8:	a3 30 60 80 00       	mov    %eax,0x806030
  8047ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047f6:	a1 38 60 80 00       	mov    0x806038,%eax
  8047fb:	40                   	inc    %eax
  8047fc:	a3 38 60 80 00       	mov    %eax,0x806038
  804801:	e9 cc 00 00 00       	jmp    8048d2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804806:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80480d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804815:	e9 8a 00 00 00       	jmp    8048a4 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80481a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80481d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804820:	73 7a                	jae    80489c <realloc_block_FF+0x44d>
  804822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804825:	8b 00                	mov    (%eax),%eax
  804827:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80482a:	73 70                	jae    80489c <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80482c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804830:	74 06                	je     804838 <realloc_block_FF+0x3e9>
  804832:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804836:	75 17                	jne    80484f <realloc_block_FF+0x400>
  804838:	83 ec 04             	sub    $0x4,%esp
  80483b:	68 1c 58 80 00       	push   $0x80581c
  804840:	68 1a 02 00 00       	push   $0x21a
  804845:	68 a9 57 80 00       	push   $0x8057a9
  80484a:	e8 64 cd ff ff       	call   8015b3 <_panic>
  80484f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804852:	8b 10                	mov    (%eax),%edx
  804854:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804857:	89 10                	mov    %edx,(%eax)
  804859:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80485c:	8b 00                	mov    (%eax),%eax
  80485e:	85 c0                	test   %eax,%eax
  804860:	74 0b                	je     80486d <realloc_block_FF+0x41e>
  804862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804865:	8b 00                	mov    (%eax),%eax
  804867:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80486a:	89 50 04             	mov    %edx,0x4(%eax)
  80486d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804870:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804873:	89 10                	mov    %edx,(%eax)
  804875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804878:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80487b:	89 50 04             	mov    %edx,0x4(%eax)
  80487e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804881:	8b 00                	mov    (%eax),%eax
  804883:	85 c0                	test   %eax,%eax
  804885:	75 08                	jne    80488f <realloc_block_FF+0x440>
  804887:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80488a:	a3 30 60 80 00       	mov    %eax,0x806030
  80488f:	a1 38 60 80 00       	mov    0x806038,%eax
  804894:	40                   	inc    %eax
  804895:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  80489a:	eb 36                	jmp    8048d2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80489c:	a1 34 60 80 00       	mov    0x806034,%eax
  8048a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8048a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8048a8:	74 07                	je     8048b1 <realloc_block_FF+0x462>
  8048aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048ad:	8b 00                	mov    (%eax),%eax
  8048af:	eb 05                	jmp    8048b6 <realloc_block_FF+0x467>
  8048b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8048b6:	a3 34 60 80 00       	mov    %eax,0x806034
  8048bb:	a1 34 60 80 00       	mov    0x806034,%eax
  8048c0:	85 c0                	test   %eax,%eax
  8048c2:	0f 85 52 ff ff ff    	jne    80481a <realloc_block_FF+0x3cb>
  8048c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8048cc:	0f 85 48 ff ff ff    	jne    80481a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8048d2:	83 ec 04             	sub    $0x4,%esp
  8048d5:	6a 00                	push   $0x0
  8048d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8048da:	ff 75 d4             	pushl  -0x2c(%ebp)
  8048dd:	e8 7a eb ff ff       	call   80345c <set_block_data>
  8048e2:	83 c4 10             	add    $0x10,%esp
				return va;
  8048e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8048e8:	e9 7b 02 00 00       	jmp    804b68 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8048ed:	83 ec 0c             	sub    $0xc,%esp
  8048f0:	68 99 58 80 00       	push   $0x805899
  8048f5:	e8 76 cf ff ff       	call   801870 <cprintf>
  8048fa:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8048fd:	8b 45 08             	mov    0x8(%ebp),%eax
  804900:	e9 63 02 00 00       	jmp    804b68 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804905:	8b 45 0c             	mov    0xc(%ebp),%eax
  804908:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80490b:	0f 86 4d 02 00 00    	jbe    804b5e <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804911:	83 ec 0c             	sub    $0xc,%esp
  804914:	ff 75 e4             	pushl  -0x1c(%ebp)
  804917:	e8 08 e8 ff ff       	call   803124 <is_free_block>
  80491c:	83 c4 10             	add    $0x10,%esp
  80491f:	84 c0                	test   %al,%al
  804921:	0f 84 37 02 00 00    	je     804b5e <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80492a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80492d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804930:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804933:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804936:	76 38                	jbe    804970 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804938:	83 ec 0c             	sub    $0xc,%esp
  80493b:	ff 75 08             	pushl  0x8(%ebp)
  80493e:	e8 0c fa ff ff       	call   80434f <free_block>
  804943:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804946:	83 ec 0c             	sub    $0xc,%esp
  804949:	ff 75 0c             	pushl  0xc(%ebp)
  80494c:	e8 3a eb ff ff       	call   80348b <alloc_block_FF>
  804951:	83 c4 10             	add    $0x10,%esp
  804954:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804957:	83 ec 08             	sub    $0x8,%esp
  80495a:	ff 75 c0             	pushl  -0x40(%ebp)
  80495d:	ff 75 08             	pushl  0x8(%ebp)
  804960:	e8 ab fa ff ff       	call   804410 <copy_data>
  804965:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804968:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80496b:	e9 f8 01 00 00       	jmp    804b68 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804970:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804973:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804976:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804979:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80497d:	0f 87 a0 00 00 00    	ja     804a23 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804987:	75 17                	jne    8049a0 <realloc_block_FF+0x551>
  804989:	83 ec 04             	sub    $0x4,%esp
  80498c:	68 8b 57 80 00       	push   $0x80578b
  804991:	68 38 02 00 00       	push   $0x238
  804996:	68 a9 57 80 00       	push   $0x8057a9
  80499b:	e8 13 cc ff ff       	call   8015b3 <_panic>
  8049a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049a3:	8b 00                	mov    (%eax),%eax
  8049a5:	85 c0                	test   %eax,%eax
  8049a7:	74 10                	je     8049b9 <realloc_block_FF+0x56a>
  8049a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049ac:	8b 00                	mov    (%eax),%eax
  8049ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049b1:	8b 52 04             	mov    0x4(%edx),%edx
  8049b4:	89 50 04             	mov    %edx,0x4(%eax)
  8049b7:	eb 0b                	jmp    8049c4 <realloc_block_FF+0x575>
  8049b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049bc:	8b 40 04             	mov    0x4(%eax),%eax
  8049bf:	a3 30 60 80 00       	mov    %eax,0x806030
  8049c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049c7:	8b 40 04             	mov    0x4(%eax),%eax
  8049ca:	85 c0                	test   %eax,%eax
  8049cc:	74 0f                	je     8049dd <realloc_block_FF+0x58e>
  8049ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049d1:	8b 40 04             	mov    0x4(%eax),%eax
  8049d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049d7:	8b 12                	mov    (%edx),%edx
  8049d9:	89 10                	mov    %edx,(%eax)
  8049db:	eb 0a                	jmp    8049e7 <realloc_block_FF+0x598>
  8049dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049e0:	8b 00                	mov    (%eax),%eax
  8049e2:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8049e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8049f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8049fa:	a1 38 60 80 00       	mov    0x806038,%eax
  8049ff:	48                   	dec    %eax
  804a00:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804a05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804a08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a0b:	01 d0                	add    %edx,%eax
  804a0d:	83 ec 04             	sub    $0x4,%esp
  804a10:	6a 01                	push   $0x1
  804a12:	50                   	push   %eax
  804a13:	ff 75 08             	pushl  0x8(%ebp)
  804a16:	e8 41 ea ff ff       	call   80345c <set_block_data>
  804a1b:	83 c4 10             	add    $0x10,%esp
  804a1e:	e9 36 01 00 00       	jmp    804b59 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804a23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804a26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804a29:	01 d0                	add    %edx,%eax
  804a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804a2e:	83 ec 04             	sub    $0x4,%esp
  804a31:	6a 01                	push   $0x1
  804a33:	ff 75 f0             	pushl  -0x10(%ebp)
  804a36:	ff 75 08             	pushl  0x8(%ebp)
  804a39:	e8 1e ea ff ff       	call   80345c <set_block_data>
  804a3e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804a41:	8b 45 08             	mov    0x8(%ebp),%eax
  804a44:	83 e8 04             	sub    $0x4,%eax
  804a47:	8b 00                	mov    (%eax),%eax
  804a49:	83 e0 fe             	and    $0xfffffffe,%eax
  804a4c:	89 c2                	mov    %eax,%edx
  804a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  804a51:	01 d0                	add    %edx,%eax
  804a53:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804a56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804a5a:	74 06                	je     804a62 <realloc_block_FF+0x613>
  804a5c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804a60:	75 17                	jne    804a79 <realloc_block_FF+0x62a>
  804a62:	83 ec 04             	sub    $0x4,%esp
  804a65:	68 1c 58 80 00       	push   $0x80581c
  804a6a:	68 44 02 00 00       	push   $0x244
  804a6f:	68 a9 57 80 00       	push   $0x8057a9
  804a74:	e8 3a cb ff ff       	call   8015b3 <_panic>
  804a79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a7c:	8b 10                	mov    (%eax),%edx
  804a7e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804a81:	89 10                	mov    %edx,(%eax)
  804a83:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804a86:	8b 00                	mov    (%eax),%eax
  804a88:	85 c0                	test   %eax,%eax
  804a8a:	74 0b                	je     804a97 <realloc_block_FF+0x648>
  804a8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a8f:	8b 00                	mov    (%eax),%eax
  804a91:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804a94:	89 50 04             	mov    %edx,0x4(%eax)
  804a97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a9a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804a9d:	89 10                	mov    %edx,(%eax)
  804a9f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804aa2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804aa5:	89 50 04             	mov    %edx,0x4(%eax)
  804aa8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804aab:	8b 00                	mov    (%eax),%eax
  804aad:	85 c0                	test   %eax,%eax
  804aaf:	75 08                	jne    804ab9 <realloc_block_FF+0x66a>
  804ab1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804ab4:	a3 30 60 80 00       	mov    %eax,0x806030
  804ab9:	a1 38 60 80 00       	mov    0x806038,%eax
  804abe:	40                   	inc    %eax
  804abf:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804ac4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804ac8:	75 17                	jne    804ae1 <realloc_block_FF+0x692>
  804aca:	83 ec 04             	sub    $0x4,%esp
  804acd:	68 8b 57 80 00       	push   $0x80578b
  804ad2:	68 45 02 00 00       	push   $0x245
  804ad7:	68 a9 57 80 00       	push   $0x8057a9
  804adc:	e8 d2 ca ff ff       	call   8015b3 <_panic>
  804ae1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ae4:	8b 00                	mov    (%eax),%eax
  804ae6:	85 c0                	test   %eax,%eax
  804ae8:	74 10                	je     804afa <realloc_block_FF+0x6ab>
  804aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804aed:	8b 00                	mov    (%eax),%eax
  804aef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804af2:	8b 52 04             	mov    0x4(%edx),%edx
  804af5:	89 50 04             	mov    %edx,0x4(%eax)
  804af8:	eb 0b                	jmp    804b05 <realloc_block_FF+0x6b6>
  804afa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804afd:	8b 40 04             	mov    0x4(%eax),%eax
  804b00:	a3 30 60 80 00       	mov    %eax,0x806030
  804b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b08:	8b 40 04             	mov    0x4(%eax),%eax
  804b0b:	85 c0                	test   %eax,%eax
  804b0d:	74 0f                	je     804b1e <realloc_block_FF+0x6cf>
  804b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b12:	8b 40 04             	mov    0x4(%eax),%eax
  804b15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b18:	8b 12                	mov    (%edx),%edx
  804b1a:	89 10                	mov    %edx,(%eax)
  804b1c:	eb 0a                	jmp    804b28 <realloc_block_FF+0x6d9>
  804b1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b21:	8b 00                	mov    (%eax),%eax
  804b23:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804b28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804b3b:	a1 38 60 80 00       	mov    0x806038,%eax
  804b40:	48                   	dec    %eax
  804b41:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804b46:	83 ec 04             	sub    $0x4,%esp
  804b49:	6a 00                	push   $0x0
  804b4b:	ff 75 bc             	pushl  -0x44(%ebp)
  804b4e:	ff 75 b8             	pushl  -0x48(%ebp)
  804b51:	e8 06 e9 ff ff       	call   80345c <set_block_data>
  804b56:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804b59:	8b 45 08             	mov    0x8(%ebp),%eax
  804b5c:	eb 0a                	jmp    804b68 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804b5e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804b65:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804b68:	c9                   	leave  
  804b69:	c3                   	ret    

00804b6a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804b6a:	55                   	push   %ebp
  804b6b:	89 e5                	mov    %esp,%ebp
  804b6d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804b70:	83 ec 04             	sub    $0x4,%esp
  804b73:	68 a0 58 80 00       	push   $0x8058a0
  804b78:	68 58 02 00 00       	push   $0x258
  804b7d:	68 a9 57 80 00       	push   $0x8057a9
  804b82:	e8 2c ca ff ff       	call   8015b3 <_panic>

00804b87 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804b87:	55                   	push   %ebp
  804b88:	89 e5                	mov    %esp,%ebp
  804b8a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804b8d:	83 ec 04             	sub    $0x4,%esp
  804b90:	68 c8 58 80 00       	push   $0x8058c8
  804b95:	68 61 02 00 00       	push   $0x261
  804b9a:	68 a9 57 80 00       	push   $0x8057a9
  804b9f:	e8 0f ca ff ff       	call   8015b3 <_panic>

00804ba4 <__udivdi3>:
  804ba4:	55                   	push   %ebp
  804ba5:	57                   	push   %edi
  804ba6:	56                   	push   %esi
  804ba7:	53                   	push   %ebx
  804ba8:	83 ec 1c             	sub    $0x1c,%esp
  804bab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804baf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804bb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804bb7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804bbb:	89 ca                	mov    %ecx,%edx
  804bbd:	89 f8                	mov    %edi,%eax
  804bbf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804bc3:	85 f6                	test   %esi,%esi
  804bc5:	75 2d                	jne    804bf4 <__udivdi3+0x50>
  804bc7:	39 cf                	cmp    %ecx,%edi
  804bc9:	77 65                	ja     804c30 <__udivdi3+0x8c>
  804bcb:	89 fd                	mov    %edi,%ebp
  804bcd:	85 ff                	test   %edi,%edi
  804bcf:	75 0b                	jne    804bdc <__udivdi3+0x38>
  804bd1:	b8 01 00 00 00       	mov    $0x1,%eax
  804bd6:	31 d2                	xor    %edx,%edx
  804bd8:	f7 f7                	div    %edi
  804bda:	89 c5                	mov    %eax,%ebp
  804bdc:	31 d2                	xor    %edx,%edx
  804bde:	89 c8                	mov    %ecx,%eax
  804be0:	f7 f5                	div    %ebp
  804be2:	89 c1                	mov    %eax,%ecx
  804be4:	89 d8                	mov    %ebx,%eax
  804be6:	f7 f5                	div    %ebp
  804be8:	89 cf                	mov    %ecx,%edi
  804bea:	89 fa                	mov    %edi,%edx
  804bec:	83 c4 1c             	add    $0x1c,%esp
  804bef:	5b                   	pop    %ebx
  804bf0:	5e                   	pop    %esi
  804bf1:	5f                   	pop    %edi
  804bf2:	5d                   	pop    %ebp
  804bf3:	c3                   	ret    
  804bf4:	39 ce                	cmp    %ecx,%esi
  804bf6:	77 28                	ja     804c20 <__udivdi3+0x7c>
  804bf8:	0f bd fe             	bsr    %esi,%edi
  804bfb:	83 f7 1f             	xor    $0x1f,%edi
  804bfe:	75 40                	jne    804c40 <__udivdi3+0x9c>
  804c00:	39 ce                	cmp    %ecx,%esi
  804c02:	72 0a                	jb     804c0e <__udivdi3+0x6a>
  804c04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804c08:	0f 87 9e 00 00 00    	ja     804cac <__udivdi3+0x108>
  804c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  804c13:	89 fa                	mov    %edi,%edx
  804c15:	83 c4 1c             	add    $0x1c,%esp
  804c18:	5b                   	pop    %ebx
  804c19:	5e                   	pop    %esi
  804c1a:	5f                   	pop    %edi
  804c1b:	5d                   	pop    %ebp
  804c1c:	c3                   	ret    
  804c1d:	8d 76 00             	lea    0x0(%esi),%esi
  804c20:	31 ff                	xor    %edi,%edi
  804c22:	31 c0                	xor    %eax,%eax
  804c24:	89 fa                	mov    %edi,%edx
  804c26:	83 c4 1c             	add    $0x1c,%esp
  804c29:	5b                   	pop    %ebx
  804c2a:	5e                   	pop    %esi
  804c2b:	5f                   	pop    %edi
  804c2c:	5d                   	pop    %ebp
  804c2d:	c3                   	ret    
  804c2e:	66 90                	xchg   %ax,%ax
  804c30:	89 d8                	mov    %ebx,%eax
  804c32:	f7 f7                	div    %edi
  804c34:	31 ff                	xor    %edi,%edi
  804c36:	89 fa                	mov    %edi,%edx
  804c38:	83 c4 1c             	add    $0x1c,%esp
  804c3b:	5b                   	pop    %ebx
  804c3c:	5e                   	pop    %esi
  804c3d:	5f                   	pop    %edi
  804c3e:	5d                   	pop    %ebp
  804c3f:	c3                   	ret    
  804c40:	bd 20 00 00 00       	mov    $0x20,%ebp
  804c45:	89 eb                	mov    %ebp,%ebx
  804c47:	29 fb                	sub    %edi,%ebx
  804c49:	89 f9                	mov    %edi,%ecx
  804c4b:	d3 e6                	shl    %cl,%esi
  804c4d:	89 c5                	mov    %eax,%ebp
  804c4f:	88 d9                	mov    %bl,%cl
  804c51:	d3 ed                	shr    %cl,%ebp
  804c53:	89 e9                	mov    %ebp,%ecx
  804c55:	09 f1                	or     %esi,%ecx
  804c57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804c5b:	89 f9                	mov    %edi,%ecx
  804c5d:	d3 e0                	shl    %cl,%eax
  804c5f:	89 c5                	mov    %eax,%ebp
  804c61:	89 d6                	mov    %edx,%esi
  804c63:	88 d9                	mov    %bl,%cl
  804c65:	d3 ee                	shr    %cl,%esi
  804c67:	89 f9                	mov    %edi,%ecx
  804c69:	d3 e2                	shl    %cl,%edx
  804c6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  804c6f:	88 d9                	mov    %bl,%cl
  804c71:	d3 e8                	shr    %cl,%eax
  804c73:	09 c2                	or     %eax,%edx
  804c75:	89 d0                	mov    %edx,%eax
  804c77:	89 f2                	mov    %esi,%edx
  804c79:	f7 74 24 0c          	divl   0xc(%esp)
  804c7d:	89 d6                	mov    %edx,%esi
  804c7f:	89 c3                	mov    %eax,%ebx
  804c81:	f7 e5                	mul    %ebp
  804c83:	39 d6                	cmp    %edx,%esi
  804c85:	72 19                	jb     804ca0 <__udivdi3+0xfc>
  804c87:	74 0b                	je     804c94 <__udivdi3+0xf0>
  804c89:	89 d8                	mov    %ebx,%eax
  804c8b:	31 ff                	xor    %edi,%edi
  804c8d:	e9 58 ff ff ff       	jmp    804bea <__udivdi3+0x46>
  804c92:	66 90                	xchg   %ax,%ax
  804c94:	8b 54 24 08          	mov    0x8(%esp),%edx
  804c98:	89 f9                	mov    %edi,%ecx
  804c9a:	d3 e2                	shl    %cl,%edx
  804c9c:	39 c2                	cmp    %eax,%edx
  804c9e:	73 e9                	jae    804c89 <__udivdi3+0xe5>
  804ca0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804ca3:	31 ff                	xor    %edi,%edi
  804ca5:	e9 40 ff ff ff       	jmp    804bea <__udivdi3+0x46>
  804caa:	66 90                	xchg   %ax,%ax
  804cac:	31 c0                	xor    %eax,%eax
  804cae:	e9 37 ff ff ff       	jmp    804bea <__udivdi3+0x46>
  804cb3:	90                   	nop

00804cb4 <__umoddi3>:
  804cb4:	55                   	push   %ebp
  804cb5:	57                   	push   %edi
  804cb6:	56                   	push   %esi
  804cb7:	53                   	push   %ebx
  804cb8:	83 ec 1c             	sub    $0x1c,%esp
  804cbb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804cbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  804cc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804cc7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804ccb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804ccf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804cd3:	89 f3                	mov    %esi,%ebx
  804cd5:	89 fa                	mov    %edi,%edx
  804cd7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804cdb:	89 34 24             	mov    %esi,(%esp)
  804cde:	85 c0                	test   %eax,%eax
  804ce0:	75 1a                	jne    804cfc <__umoddi3+0x48>
  804ce2:	39 f7                	cmp    %esi,%edi
  804ce4:	0f 86 a2 00 00 00    	jbe    804d8c <__umoddi3+0xd8>
  804cea:	89 c8                	mov    %ecx,%eax
  804cec:	89 f2                	mov    %esi,%edx
  804cee:	f7 f7                	div    %edi
  804cf0:	89 d0                	mov    %edx,%eax
  804cf2:	31 d2                	xor    %edx,%edx
  804cf4:	83 c4 1c             	add    $0x1c,%esp
  804cf7:	5b                   	pop    %ebx
  804cf8:	5e                   	pop    %esi
  804cf9:	5f                   	pop    %edi
  804cfa:	5d                   	pop    %ebp
  804cfb:	c3                   	ret    
  804cfc:	39 f0                	cmp    %esi,%eax
  804cfe:	0f 87 ac 00 00 00    	ja     804db0 <__umoddi3+0xfc>
  804d04:	0f bd e8             	bsr    %eax,%ebp
  804d07:	83 f5 1f             	xor    $0x1f,%ebp
  804d0a:	0f 84 ac 00 00 00    	je     804dbc <__umoddi3+0x108>
  804d10:	bf 20 00 00 00       	mov    $0x20,%edi
  804d15:	29 ef                	sub    %ebp,%edi
  804d17:	89 fe                	mov    %edi,%esi
  804d19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804d1d:	89 e9                	mov    %ebp,%ecx
  804d1f:	d3 e0                	shl    %cl,%eax
  804d21:	89 d7                	mov    %edx,%edi
  804d23:	89 f1                	mov    %esi,%ecx
  804d25:	d3 ef                	shr    %cl,%edi
  804d27:	09 c7                	or     %eax,%edi
  804d29:	89 e9                	mov    %ebp,%ecx
  804d2b:	d3 e2                	shl    %cl,%edx
  804d2d:	89 14 24             	mov    %edx,(%esp)
  804d30:	89 d8                	mov    %ebx,%eax
  804d32:	d3 e0                	shl    %cl,%eax
  804d34:	89 c2                	mov    %eax,%edx
  804d36:	8b 44 24 08          	mov    0x8(%esp),%eax
  804d3a:	d3 e0                	shl    %cl,%eax
  804d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804d40:	8b 44 24 08          	mov    0x8(%esp),%eax
  804d44:	89 f1                	mov    %esi,%ecx
  804d46:	d3 e8                	shr    %cl,%eax
  804d48:	09 d0                	or     %edx,%eax
  804d4a:	d3 eb                	shr    %cl,%ebx
  804d4c:	89 da                	mov    %ebx,%edx
  804d4e:	f7 f7                	div    %edi
  804d50:	89 d3                	mov    %edx,%ebx
  804d52:	f7 24 24             	mull   (%esp)
  804d55:	89 c6                	mov    %eax,%esi
  804d57:	89 d1                	mov    %edx,%ecx
  804d59:	39 d3                	cmp    %edx,%ebx
  804d5b:	0f 82 87 00 00 00    	jb     804de8 <__umoddi3+0x134>
  804d61:	0f 84 91 00 00 00    	je     804df8 <__umoddi3+0x144>
  804d67:	8b 54 24 04          	mov    0x4(%esp),%edx
  804d6b:	29 f2                	sub    %esi,%edx
  804d6d:	19 cb                	sbb    %ecx,%ebx
  804d6f:	89 d8                	mov    %ebx,%eax
  804d71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804d75:	d3 e0                	shl    %cl,%eax
  804d77:	89 e9                	mov    %ebp,%ecx
  804d79:	d3 ea                	shr    %cl,%edx
  804d7b:	09 d0                	or     %edx,%eax
  804d7d:	89 e9                	mov    %ebp,%ecx
  804d7f:	d3 eb                	shr    %cl,%ebx
  804d81:	89 da                	mov    %ebx,%edx
  804d83:	83 c4 1c             	add    $0x1c,%esp
  804d86:	5b                   	pop    %ebx
  804d87:	5e                   	pop    %esi
  804d88:	5f                   	pop    %edi
  804d89:	5d                   	pop    %ebp
  804d8a:	c3                   	ret    
  804d8b:	90                   	nop
  804d8c:	89 fd                	mov    %edi,%ebp
  804d8e:	85 ff                	test   %edi,%edi
  804d90:	75 0b                	jne    804d9d <__umoddi3+0xe9>
  804d92:	b8 01 00 00 00       	mov    $0x1,%eax
  804d97:	31 d2                	xor    %edx,%edx
  804d99:	f7 f7                	div    %edi
  804d9b:	89 c5                	mov    %eax,%ebp
  804d9d:	89 f0                	mov    %esi,%eax
  804d9f:	31 d2                	xor    %edx,%edx
  804da1:	f7 f5                	div    %ebp
  804da3:	89 c8                	mov    %ecx,%eax
  804da5:	f7 f5                	div    %ebp
  804da7:	89 d0                	mov    %edx,%eax
  804da9:	e9 44 ff ff ff       	jmp    804cf2 <__umoddi3+0x3e>
  804dae:	66 90                	xchg   %ax,%ax
  804db0:	89 c8                	mov    %ecx,%eax
  804db2:	89 f2                	mov    %esi,%edx
  804db4:	83 c4 1c             	add    $0x1c,%esp
  804db7:	5b                   	pop    %ebx
  804db8:	5e                   	pop    %esi
  804db9:	5f                   	pop    %edi
  804dba:	5d                   	pop    %ebp
  804dbb:	c3                   	ret    
  804dbc:	3b 04 24             	cmp    (%esp),%eax
  804dbf:	72 06                	jb     804dc7 <__umoddi3+0x113>
  804dc1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804dc5:	77 0f                	ja     804dd6 <__umoddi3+0x122>
  804dc7:	89 f2                	mov    %esi,%edx
  804dc9:	29 f9                	sub    %edi,%ecx
  804dcb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804dcf:	89 14 24             	mov    %edx,(%esp)
  804dd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804dd6:	8b 44 24 04          	mov    0x4(%esp),%eax
  804dda:	8b 14 24             	mov    (%esp),%edx
  804ddd:	83 c4 1c             	add    $0x1c,%esp
  804de0:	5b                   	pop    %ebx
  804de1:	5e                   	pop    %esi
  804de2:	5f                   	pop    %edi
  804de3:	5d                   	pop    %ebp
  804de4:	c3                   	ret    
  804de5:	8d 76 00             	lea    0x0(%esi),%esi
  804de8:	2b 04 24             	sub    (%esp),%eax
  804deb:	19 fa                	sbb    %edi,%edx
  804ded:	89 d1                	mov    %edx,%ecx
  804def:	89 c6                	mov    %eax,%esi
  804df1:	e9 71 ff ff ff       	jmp    804d67 <__umoddi3+0xb3>
  804df6:	66 90                	xchg   %ax,%ax
  804df8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804dfc:	72 ea                	jb     804de8 <__umoddi3+0x134>
  804dfe:	89 d9                	mov    %ebx,%ecx
  804e00:	e9 62 ff ff ff       	jmp    804d67 <__umoddi3+0xb3>
