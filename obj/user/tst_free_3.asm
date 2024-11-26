
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
  8000a3:	68 80 4e 80 00       	push   $0x804e80
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 c1 4e 80 00       	push   $0x804ec1
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
  8000d9:	68 80 4e 80 00       	push   $0x804e80
  8000de:	6a 21                	push   $0x21
  8000e0:	68 c1 4e 80 00       	push   $0x804ec1
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
  80010f:	68 80 4e 80 00       	push   $0x804e80
  800114:	6a 22                	push   $0x22
  800116:	68 c1 4e 80 00       	push   $0x804ec1
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
  800145:	68 80 4e 80 00       	push   $0x804e80
  80014a:	6a 23                	push   $0x23
  80014c:	68 c1 4e 80 00       	push   $0x804ec1
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
  80017b:	68 80 4e 80 00       	push   $0x804e80
  800180:	6a 24                	push   $0x24
  800182:	68 c1 4e 80 00       	push   $0x804ec1
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
  8001b1:	68 80 4e 80 00       	push   $0x804e80
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 c1 4e 80 00       	push   $0x804ec1
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
  8001e9:	68 80 4e 80 00       	push   $0x804e80
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 c1 4e 80 00       	push   $0x804ec1
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
  800221:	68 80 4e 80 00       	push   $0x804e80
  800226:	6a 27                	push   $0x27
  800228:	68 c1 4e 80 00       	push   $0x804ec1
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
  800259:	68 80 4e 80 00       	push   $0x804e80
  80025e:	6a 28                	push   $0x28
  800260:	68 c1 4e 80 00       	push   $0x804ec1
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
  800291:	68 80 4e 80 00       	push   $0x804e80
  800296:	6a 29                	push   $0x29
  800298:	68 c1 4e 80 00       	push   $0x804ec1
  80029d:	e8 11 13 00 00       	call   8015b3 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8002a7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 d4 4e 80 00       	push   $0x804ed4
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 c1 4e 80 00       	push   $0x804ec1
  8002c0:	e8 ee 12 00 00       	call   8015b3 <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 a5 29 00 00       	call   802c6f <sys_calculate_free_frames>
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
  8002e1:	e8 d4 29 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  80031d:	68 1c 4f 80 00       	push   $0x804f1c
  800322:	6a 39                	push   $0x39
  800324:	68 c1 4e 80 00       	push   $0x804ec1
  800329:	e8 85 12 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 87 29 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 84 4f 80 00       	push   $0x804f84
  800345:	6a 3a                	push   $0x3a
  800347:	68 c1 4e 80 00       	push   $0x804ec1
  80034c:	e8 62 12 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 64 29 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  8003a6:	68 1c 4f 80 00       	push   $0x804f1c
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 c1 4e 80 00       	push   $0x804ec1
  8003b2:	e8 fc 11 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 fe 28 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  8003dd:	68 84 4f 80 00       	push   $0x804f84
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 c1 4e 80 00       	push   $0x804ec1
  8003e9:	e8 c5 11 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 c7 28 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  80044a:	68 1c 4f 80 00       	push   $0x804f1c
  80044f:	6a 47                	push   $0x47
  800451:	68 c1 4e 80 00       	push   $0x804ec1
  800456:	e8 58 11 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 5a 28 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  80047e:	68 84 4f 80 00       	push   $0x804f84
  800483:	6a 48                	push   $0x48
  800485:	68 c1 4e 80 00       	push   $0x804ec1
  80048a:	e8 24 11 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 26 28 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  8004fa:	68 1c 4f 80 00       	push   $0x804f1c
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 c1 4e 80 00       	push   $0x804ec1
  800506:	e8 a8 10 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 aa 27 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  800535:	68 84 4f 80 00       	push   $0x804f84
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 c1 4e 80 00       	push   $0x804ec1
  800541:	e8 6d 10 00 00       	call   8015b3 <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 24 27 00 00       	call   802c6f <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 35 27 00 00       	call   802c88 <sys_calculate_modified_frames>
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
  80060f:	e8 5b 26 00 00       	call   802c6f <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 6d 26 00 00       	call   802c88 <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 b4 4f 80 00       	push   $0x804fb4
  80062e:	6a 67                	push   $0x67
  800630:	68 c1 4e 80 00       	push   $0x804ec1
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
  8006d8:	68 f8 4f 80 00       	push   $0x804ff8
  8006dd:	6a 73                	push   $0x73
  8006df:	68 c1 4e 80 00       	push   $0x804ec1
  8006e4:	e8 ca 0e 00 00       	call   8015b3 <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e9:	e8 81 25 00 00       	call   802c6f <sys_calculate_free_frames>
  8006ee:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006f1:	e8 92 25 00 00       	call   802c88 <sys_calculate_modified_frames>
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
  8007f2:	e8 78 24 00 00       	call   802c6f <sys_calculate_free_frames>
  8007f7:	29 c3                	sub    %eax,%ebx
  8007f9:	89 d8                	mov    %ebx,%eax
  8007fb:	83 f8 04             	cmp    $0x4,%eax
  8007fe:	74 17                	je     800817 <_main+0x7df>
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	68 b4 4f 80 00       	push   $0x804fb4
  800808:	68 8e 00 00 00       	push   $0x8e
  80080d:	68 c1 4e 80 00       	push   $0x804ec1
  800812:	e8 9c 0d 00 00       	call   8015b3 <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800817:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  80081a:	e8 69 24 00 00       	call   802c88 <sys_calculate_modified_frames>
  80081f:	29 c3                	sub    %eax,%ebx
  800821:	89 d8                	mov    %ebx,%eax
  800823:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800826:	74 17                	je     80083f <_main+0x807>
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 b4 4f 80 00       	push   $0x804fb4
  800830:	68 8f 00 00 00       	push   $0x8f
  800835:	68 c1 4e 80 00       	push   $0x804ec1
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
  8008df:	68 f8 4f 80 00       	push   $0x804ff8
  8008e4:	68 9b 00 00 00       	push   $0x9b
  8008e9:	68 c1 4e 80 00       	push   $0x804ec1
  8008ee:	e8 c0 0c 00 00       	call   8015b3 <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008f3:	e8 77 23 00 00       	call   802c6f <sys_calculate_free_frames>
  8008f8:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008fb:	e8 88 23 00 00       	call   802c88 <sys_calculate_modified_frames>
  800900:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800903:	e8 b2 23 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
  800908:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  80090b:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800911:	83 ec 0c             	sub    $0xc,%esp
  800914:	50                   	push   %eax
  800915:	e8 25 1f 00 00       	call   80283f <free>
  80091a:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80091d:	e8 98 23 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  800945:	68 18 50 80 00       	push   $0x805018
  80094a:	68 a5 00 00 00       	push   $0xa5
  80094f:	68 c1 4e 80 00       	push   $0x804ec1
  800954:	e8 5a 0c 00 00       	call   8015b3 <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  800959:	e8 11 23 00 00       	call   802c6f <sys_calculate_free_frames>
  80095e:	89 c2                	mov    %eax,%edx
  800960:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800963:	29 c2                	sub    %eax,%edx
  800965:	89 d0                	mov    %edx,%eax
  800967:	83 f8 07             	cmp    $0x7,%eax
  80096a:	74 17                	je     800983 <_main+0x94b>
  80096c:	83 ec 04             	sub    $0x4,%esp
  80096f:	68 54 50 80 00       	push   $0x805054
  800974:	68 a7 00 00 00       	push   $0xa7
  800979:	68 c1 4e 80 00       	push   $0x804ec1
  80097e:	e8 30 0c 00 00       	call   8015b3 <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800983:	e8 00 23 00 00       	call   802c88 <sys_calculate_modified_frames>
  800988:	89 c2                	mov    %eax,%edx
  80098a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80098d:	29 c2                	sub    %eax,%edx
  80098f:	89 d0                	mov    %edx,%eax
  800991:	83 f8 02             	cmp    $0x2,%eax
  800994:	74 17                	je     8009ad <_main+0x975>
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	68 a8 50 80 00       	push   $0x8050a8
  80099e:	68 a8 00 00 00       	push   $0xa8
  8009a3:	68 c1 4e 80 00       	push   $0x804ec1
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
  800a1c:	68 e0 50 80 00       	push   $0x8050e0
  800a21:	68 b0 00 00 00       	push   $0xb0
  800a26:	68 c1 4e 80 00       	push   $0x804ec1
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
  800a56:	e8 14 22 00 00       	call   802c6f <sys_calculate_free_frames>
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
  800aa3:	e8 c7 21 00 00       	call   802c6f <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 02             	cmp    $0x2,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 b4 4f 80 00       	push   $0x804fb4
  800ab9:	68 bc 00 00 00       	push   $0xbc
  800abe:	68 c1 4e 80 00       	push   $0x804ec1
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
  800ba1:	68 f8 4f 80 00       	push   $0x804ff8
  800ba6:	68 c5 00 00 00       	push   $0xc5
  800bab:	68 c1 4e 80 00       	push   $0x804ec1
  800bb0:	e8 fe 09 00 00       	call   8015b3 <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bb5:	e8 00 21 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  800c05:	68 1c 4f 80 00       	push   $0x804f1c
  800c0a:	68 ca 00 00 00       	push   $0xca
  800c0f:	68 c1 4e 80 00       	push   $0x804ec1
  800c14:	e8 9a 09 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c19:	e8 9c 20 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
  800c1e:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c21:	83 f8 01             	cmp    $0x1,%eax
  800c24:	74 17                	je     800c3d <_main+0xc05>
  800c26:	83 ec 04             	sub    $0x4,%esp
  800c29:	68 84 4f 80 00       	push   $0x804f84
  800c2e:	68 cb 00 00 00       	push   $0xcb
  800c33:	68 c1 4e 80 00       	push   $0x804ec1
  800c38:	e8 76 09 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c3d:	e8 2d 20 00 00       	call   802c6f <sys_calculate_free_frames>
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
  800c88:	e8 e2 1f 00 00       	call   802c6f <sys_calculate_free_frames>
  800c8d:	29 c3                	sub    %eax,%ebx
  800c8f:	89 d8                	mov    %ebx,%eax
  800c91:	83 f8 02             	cmp    $0x2,%eax
  800c94:	74 17                	je     800cad <_main+0xc75>
  800c96:	83 ec 04             	sub    $0x4,%esp
  800c99:	68 b4 4f 80 00       	push   $0x804fb4
  800c9e:	68 d2 00 00 00       	push   $0xd2
  800ca3:	68 c1 4e 80 00       	push   $0x804ec1
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
  800d89:	68 f8 4f 80 00       	push   $0x804ff8
  800d8e:	68 db 00 00 00       	push   $0xdb
  800d93:	68 c1 4e 80 00       	push   $0x804ec1
  800d98:	e8 16 08 00 00       	call   8015b3 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d9d:	e8 cd 1e 00 00       	call   802c6f <sys_calculate_free_frames>
  800da2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800da5:	e8 10 1f 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  800e09:	68 1c 4f 80 00       	push   $0x804f1c
  800e0e:	68 e1 00 00 00       	push   $0xe1
  800e13:	68 c1 4e 80 00       	push   $0x804ec1
  800e18:	e8 96 07 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e1d:	e8 98 1e 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
  800e22:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e25:	83 f8 01             	cmp    $0x1,%eax
  800e28:	74 17                	je     800e41 <_main+0xe09>
  800e2a:	83 ec 04             	sub    $0x4,%esp
  800e2d:	68 84 4f 80 00       	push   $0x804f84
  800e32:	68 e2 00 00 00       	push   $0xe2
  800e37:	68 c1 4e 80 00       	push   $0x804ec1
  800e3c:	e8 72 07 00 00       	call   8015b3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e41:	e8 74 1e 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  800ead:	68 1c 4f 80 00       	push   $0x804f1c
  800eb2:	68 e8 00 00 00       	push   $0xe8
  800eb7:	68 c1 4e 80 00       	push   $0x804ec1
  800ebc:	e8 f2 06 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ec1:	e8 f4 1d 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
  800ec6:	2b 45 90             	sub    -0x70(%ebp),%eax
  800ec9:	83 f8 02             	cmp    $0x2,%eax
  800ecc:	74 17                	je     800ee5 <_main+0xead>
  800ece:	83 ec 04             	sub    $0x4,%esp
  800ed1:	68 84 4f 80 00       	push   $0x804f84
  800ed6:	68 e9 00 00 00       	push   $0xe9
  800edb:	68 c1 4e 80 00       	push   $0x804ec1
  800ee0:	e8 ce 06 00 00       	call   8015b3 <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800ee5:	e8 85 1d 00 00       	call   802c6f <sys_calculate_free_frames>
  800eea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800eed:	e8 c8 1d 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  800f58:	68 1c 4f 80 00       	push   $0x804f1c
  800f5d:	68 f0 00 00 00       	push   $0xf0
  800f62:	68 c1 4e 80 00       	push   $0x804ec1
  800f67:	e8 47 06 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f6c:	e8 49 1d 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  800f92:	68 84 4f 80 00       	push   $0x804f84
  800f97:	68 f1 00 00 00       	push   $0xf1
  800f9c:	68 c1 4e 80 00       	push   $0x804ec1
  800fa1:	e8 0d 06 00 00       	call   8015b3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800fa6:	e8 0f 1d 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  801021:	68 1c 4f 80 00       	push   $0x804f1c
  801026:	68 f7 00 00 00       	push   $0xf7
  80102b:	68 c1 4e 80 00       	push   $0x804ec1
  801030:	e8 7e 05 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  801035:	e8 80 1c 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  80105d:	68 84 4f 80 00       	push   $0x804f84
  801062:	68 f8 00 00 00       	push   $0xf8
  801067:	68 c1 4e 80 00       	push   $0x804ec1
  80106c:	e8 42 05 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801071:	e8 f9 1b 00 00       	call   802c6f <sys_calculate_free_frames>
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
  8010e2:	e8 88 1b 00 00       	call   802c6f <sys_calculate_free_frames>
  8010e7:	29 c3                	sub    %eax,%ebx
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	83 f8 05             	cmp    $0x5,%eax
  8010ee:	74 17                	je     801107 <_main+0x10cf>
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 b4 4f 80 00       	push   $0x804fb4
  8010f8:	68 00 01 00 00       	push   $0x100
  8010fd:	68 c1 4e 80 00       	push   $0x804ec1
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
  80123b:	68 f8 4f 80 00       	push   $0x804ff8
  801240:	68 0b 01 00 00       	push   $0x10b
  801245:	68 c1 4e 80 00       	push   $0x804ec1
  80124a:	e8 64 03 00 00       	call   8015b3 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80124f:	e8 66 1a 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
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
  8012cd:	68 1c 4f 80 00       	push   $0x804f1c
  8012d2:	68 10 01 00 00       	push   $0x110
  8012d7:	68 c1 4e 80 00       	push   $0x804ec1
  8012dc:	e8 d2 02 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012e1:	e8 d4 19 00 00       	call   802cba <sys_pf_calculate_allocated_pages>
  8012e6:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012e9:	83 f8 04             	cmp    $0x4,%eax
  8012ec:	74 17                	je     801305 <_main+0x12cd>
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 84 4f 80 00       	push   $0x804f84
  8012f6:	68 11 01 00 00       	push   $0x111
  8012fb:	68 c1 4e 80 00       	push   $0x804ec1
  801300:	e8 ae 02 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801305:	e8 65 19 00 00       	call   802c6f <sys_calculate_free_frames>
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
  801359:	e8 11 19 00 00       	call   802c6f <sys_calculate_free_frames>
  80135e:	29 c3                	sub    %eax,%ebx
  801360:	89 d8                	mov    %ebx,%eax
  801362:	83 f8 02             	cmp    $0x2,%eax
  801365:	74 17                	je     80137e <_main+0x1346>
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	68 b4 4f 80 00       	push   $0x804fb4
  80136f:	68 18 01 00 00       	push   $0x118
  801374:	68 c1 4e 80 00       	push   $0x804ec1
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
  801457:	68 f8 4f 80 00       	push   $0x804ff8
  80145c:	68 21 01 00 00       	push   $0x121
  801461:	68 c1 4e 80 00       	push   $0x804ec1
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
  80147a:	e8 b9 19 00 00       	call   802e38 <sys_getenvindex>
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
  8014e8:	e8 cf 16 00 00       	call   802bbc <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8014ed:	83 ec 0c             	sub    $0xc,%esp
  8014f0:	68 1c 51 80 00       	push   $0x80511c
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
  801518:	68 44 51 80 00       	push   $0x805144
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
  801549:	68 6c 51 80 00       	push   $0x80516c
  80154e:	e8 1d 03 00 00       	call   801870 <cprintf>
  801553:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801556:	a1 20 60 80 00       	mov    0x806020,%eax
  80155b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	50                   	push   %eax
  801565:	68 c4 51 80 00       	push   $0x8051c4
  80156a:	e8 01 03 00 00       	call   801870 <cprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 1c 51 80 00       	push   $0x80511c
  80157a:	e8 f1 02 00 00       	call   801870 <cprintf>
  80157f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801582:	e8 4f 16 00 00       	call   802bd6 <sys_unlock_cons>
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
  80159a:	e8 65 18 00 00       	call   802e04 <sys_destroy_env>
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
  8015ab:	e8 ba 18 00 00       	call   802e6a <sys_exit_env>
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
  8015d4:	68 d8 51 80 00       	push   $0x8051d8
  8015d9:	e8 92 02 00 00       	call   801870 <cprintf>
  8015de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015e1:	a1 00 60 80 00       	mov    0x806000,%eax
  8015e6:	ff 75 0c             	pushl  0xc(%ebp)
  8015e9:	ff 75 08             	pushl  0x8(%ebp)
  8015ec:	50                   	push   %eax
  8015ed:	68 dd 51 80 00       	push   $0x8051dd
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
  801611:	68 f9 51 80 00       	push   $0x8051f9
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
  801640:	68 fc 51 80 00       	push   $0x8051fc
  801645:	6a 26                	push   $0x26
  801647:	68 48 52 80 00       	push   $0x805248
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
  801715:	68 54 52 80 00       	push   $0x805254
  80171a:	6a 3a                	push   $0x3a
  80171c:	68 48 52 80 00       	push   $0x805248
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
  801788:	68 a8 52 80 00       	push   $0x8052a8
  80178d:	6a 44                	push   $0x44
  80178f:	68 48 52 80 00       	push   $0x805248
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
  8017e2:	e8 93 13 00 00       	call   802b7a <sys_cputs>
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
  801859:	e8 1c 13 00 00       	call   802b7a <sys_cputs>
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
  8018a3:	e8 14 13 00 00       	call   802bbc <sys_lock_cons>
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
  8018c3:	e8 0e 13 00 00       	call   802bd6 <sys_unlock_cons>
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
  80190d:	e8 02 33 00 00       	call   804c14 <__udivdi3>
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
  80195d:	e8 c2 33 00 00       	call   804d24 <__umoddi3>
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	05 14 55 80 00       	add    $0x805514,%eax
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
  801ab8:	8b 04 85 38 55 80 00 	mov    0x805538(,%eax,4),%eax
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
  801b99:	8b 34 9d 80 53 80 00 	mov    0x805380(,%ebx,4),%esi
  801ba0:	85 f6                	test   %esi,%esi
  801ba2:	75 19                	jne    801bbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801ba4:	53                   	push   %ebx
  801ba5:	68 25 55 80 00       	push   $0x805525
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
  801bbe:	68 2e 55 80 00       	push   $0x80552e
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
  801beb:	be 31 55 80 00       	mov    $0x805531,%esi
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
  8025f6:	68 a8 56 80 00       	push   $0x8056a8
  8025fb:	68 3f 01 00 00       	push   $0x13f
  802600:	68 ca 56 80 00       	push   $0x8056ca
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
  802616:	e8 0a 0b 00 00       	call   803125 <sys_sbrk>
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
  802691:	e8 13 09 00 00       	call   802fa9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802696:	85 c0                	test   %eax,%eax
  802698:	74 16                	je     8026b0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80269a:	83 ec 0c             	sub    $0xc,%esp
  80269d:	ff 75 08             	pushl  0x8(%ebp)
  8026a0:	e8 53 0e 00 00       	call   8034f8 <alloc_block_FF>
  8026a5:	83 c4 10             	add    $0x10,%esp
  8026a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ab:	e9 8a 01 00 00       	jmp    80283a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8026b0:	e8 25 09 00 00       	call   802fda <sys_isUHeapPlacementStrategyBESTFIT>
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	0f 84 7d 01 00 00    	je     80283a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	ff 75 08             	pushl  0x8(%ebp)
  8026c3:	e8 ec 12 00 00       	call   8039b4 <alloc_block_BF>
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
  802713:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
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
  802760:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
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
  802819:	89 04 95 60 60 90 00 	mov    %eax,0x906060(,%edx,4)
		sys_allocate_user_mem(i, size);
  802820:	83 ec 08             	sub    $0x8,%esp
  802823:	ff 75 08             	pushl  0x8(%ebp)
  802826:	ff 75 f0             	pushl  -0x10(%ebp)
  802829:	e8 2e 09 00 00       	call   80315c <sys_allocate_user_mem>
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
  802871:	e8 02 09 00 00       	call   803178 <get_block_size>
  802876:	83 c4 10             	add    $0x10,%esp
  802879:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80287c:	83 ec 0c             	sub    $0xc,%esp
  80287f:	ff 75 08             	pushl  0x8(%ebp)
  802882:	e8 35 1b 00 00       	call   8043bc <free_block>
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
  8028bc:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
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
  8028f9:	c7 04 85 60 60 88 00 	movl   $0x0,0x886060(,%eax,4)
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
  802919:	e8 22 08 00 00       	call   803140 <sys_free_user_mem>
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
  802927:	68 d8 56 80 00       	push   $0x8056d8
  80292c:	68 85 00 00 00       	push   $0x85
  802931:	68 02 57 80 00       	push   $0x805702
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
  80294d:	75 0a                	jne    802959 <smalloc+0x1c>
  80294f:	b8 00 00 00 00       	mov    $0x0,%eax
  802954:	e9 9a 00 00 00       	jmp    8029f3 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  802959:	8b 45 0c             	mov    0xc(%ebp),%eax
  80295c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802966:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	39 d0                	cmp    %edx,%eax
  80296e:	73 02                	jae    802972 <smalloc+0x35>
  802970:	89 d0                	mov    %edx,%eax
  802972:	83 ec 0c             	sub    $0xc,%esp
  802975:	50                   	push   %eax
  802976:	e8 a5 fc ff ff       	call   802620 <malloc>
  80297b:	83 c4 10             	add    $0x10,%esp
  80297e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  802981:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802985:	75 07                	jne    80298e <smalloc+0x51>
  802987:	b8 00 00 00 00       	mov    $0x0,%eax
  80298c:	eb 65                	jmp    8029f3 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80298e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802992:	ff 75 ec             	pushl  -0x14(%ebp)
  802995:	50                   	push   %eax
  802996:	ff 75 0c             	pushl  0xc(%ebp)
  802999:	ff 75 08             	pushl  0x8(%ebp)
  80299c:	e8 a6 03 00 00       	call   802d47 <sys_createSharedObject>
  8029a1:	83 c4 10             	add    $0x10,%esp
  8029a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8029a7:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8029ab:	74 06                	je     8029b3 <smalloc+0x76>
  8029ad:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8029b1:	75 07                	jne    8029ba <smalloc+0x7d>
  8029b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b8:	eb 39                	jmp    8029f3 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  8029ba:	83 ec 08             	sub    $0x8,%esp
  8029bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8029c0:	68 0e 57 80 00       	push   $0x80570e
  8029c5:	e8 a6 ee ff ff       	call   801870 <cprintf>
  8029ca:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8029cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029d0:	a1 20 60 80 00       	mov    0x806020,%eax
  8029d5:	8b 40 78             	mov    0x78(%eax),%eax
  8029d8:	29 c2                	sub    %eax,%edx
  8029da:	89 d0                	mov    %edx,%eax
  8029dc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8029e1:	c1 e8 0c             	shr    $0xc,%eax
  8029e4:	89 c2                	mov    %eax,%edx
  8029e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e9:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	 return ptr;
  8029f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8029f3:	c9                   	leave  
  8029f4:	c3                   	ret    

008029f5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8029f5:	55                   	push   %ebp
  8029f6:	89 e5                	mov    %esp,%ebp
  8029f8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8029fb:	83 ec 08             	sub    $0x8,%esp
  8029fe:	ff 75 0c             	pushl  0xc(%ebp)
  802a01:	ff 75 08             	pushl  0x8(%ebp)
  802a04:	e8 68 03 00 00       	call   802d71 <sys_getSizeOfSharedObject>
  802a09:	83 c4 10             	add    $0x10,%esp
  802a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  802a0f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802a13:	75 07                	jne    802a1c <sget+0x27>
  802a15:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1a:	eb 7f                	jmp    802a9b <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a22:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2f:	39 d0                	cmp    %edx,%eax
  802a31:	7d 02                	jge    802a35 <sget+0x40>
  802a33:	89 d0                	mov    %edx,%eax
  802a35:	83 ec 0c             	sub    $0xc,%esp
  802a38:	50                   	push   %eax
  802a39:	e8 e2 fb ff ff       	call   802620 <malloc>
  802a3e:	83 c4 10             	add    $0x10,%esp
  802a41:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802a44:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a48:	75 07                	jne    802a51 <sget+0x5c>
  802a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4f:	eb 4a                	jmp    802a9b <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802a51:	83 ec 04             	sub    $0x4,%esp
  802a54:	ff 75 e8             	pushl  -0x18(%ebp)
  802a57:	ff 75 0c             	pushl  0xc(%ebp)
  802a5a:	ff 75 08             	pushl  0x8(%ebp)
  802a5d:	e8 2c 03 00 00       	call   802d8e <sys_getSharedObject>
  802a62:	83 c4 10             	add    $0x10,%esp
  802a65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  802a68:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a6b:	a1 20 60 80 00       	mov    0x806020,%eax
  802a70:	8b 40 78             	mov    0x78(%eax),%eax
  802a73:	29 c2                	sub    %eax,%edx
  802a75:	89 d0                	mov    %edx,%eax
  802a77:	2d 00 10 00 00       	sub    $0x1000,%eax
  802a7c:	c1 e8 0c             	shr    $0xc,%eax
  802a7f:	89 c2                	mov    %eax,%edx
  802a81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a84:	89 04 95 60 60 80 00 	mov    %eax,0x806060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802a8b:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802a8f:	75 07                	jne    802a98 <sget+0xa3>
  802a91:	b8 00 00 00 00       	mov    $0x0,%eax
  802a96:	eb 03                	jmp    802a9b <sget+0xa6>
	return ptr;
  802a98:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802a9b:	c9                   	leave  
  802a9c:	c3                   	ret    

00802a9d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802a9d:	55                   	push   %ebp
  802a9e:	89 e5                	mov    %esp,%ebp
  802aa0:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  802aa3:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa6:	a1 20 60 80 00       	mov    0x806020,%eax
  802aab:	8b 40 78             	mov    0x78(%eax),%eax
  802aae:	29 c2                	sub    %eax,%edx
  802ab0:	89 d0                	mov    %edx,%eax
  802ab2:	2d 00 10 00 00       	sub    $0x1000,%eax
  802ab7:	c1 e8 0c             	shr    $0xc,%eax
  802aba:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  802ac4:	83 ec 08             	sub    $0x8,%esp
  802ac7:	ff 75 08             	pushl  0x8(%ebp)
  802aca:	ff 75 f4             	pushl  -0xc(%ebp)
  802acd:	e8 db 02 00 00       	call   802dad <sys_freeSharedObject>
  802ad2:	83 c4 10             	add    $0x10,%esp
  802ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  802ad8:	90                   	nop
  802ad9:	c9                   	leave  
  802ada:	c3                   	ret    

00802adb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802adb:	55                   	push   %ebp
  802adc:	89 e5                	mov    %esp,%ebp
  802ade:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	68 20 57 80 00       	push   $0x805720
  802ae9:	68 de 00 00 00       	push   $0xde
  802aee:	68 02 57 80 00       	push   $0x805702
  802af3:	e8 bb ea ff ff       	call   8015b3 <_panic>

00802af8 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802af8:	55                   	push   %ebp
  802af9:	89 e5                	mov    %esp,%ebp
  802afb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802afe:	83 ec 04             	sub    $0x4,%esp
  802b01:	68 46 57 80 00       	push   $0x805746
  802b06:	68 ea 00 00 00       	push   $0xea
  802b0b:	68 02 57 80 00       	push   $0x805702
  802b10:	e8 9e ea ff ff       	call   8015b3 <_panic>

00802b15 <shrink>:

}
void shrink(uint32 newSize)
{
  802b15:	55                   	push   %ebp
  802b16:	89 e5                	mov    %esp,%ebp
  802b18:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b1b:	83 ec 04             	sub    $0x4,%esp
  802b1e:	68 46 57 80 00       	push   $0x805746
  802b23:	68 ef 00 00 00       	push   $0xef
  802b28:	68 02 57 80 00       	push   $0x805702
  802b2d:	e8 81 ea ff ff       	call   8015b3 <_panic>

00802b32 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802b32:	55                   	push   %ebp
  802b33:	89 e5                	mov    %esp,%ebp
  802b35:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b38:	83 ec 04             	sub    $0x4,%esp
  802b3b:	68 46 57 80 00       	push   $0x805746
  802b40:	68 f4 00 00 00       	push   $0xf4
  802b45:	68 02 57 80 00       	push   $0x805702
  802b4a:	e8 64 ea ff ff       	call   8015b3 <_panic>

00802b4f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802b4f:	55                   	push   %ebp
  802b50:	89 e5                	mov    %esp,%ebp
  802b52:	57                   	push   %edi
  802b53:	56                   	push   %esi
  802b54:	53                   	push   %ebx
  802b55:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b64:	8b 7d 18             	mov    0x18(%ebp),%edi
  802b67:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802b6a:	cd 30                	int    $0x30
  802b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802b72:	83 c4 10             	add    $0x10,%esp
  802b75:	5b                   	pop    %ebx
  802b76:	5e                   	pop    %esi
  802b77:	5f                   	pop    %edi
  802b78:	5d                   	pop    %ebp
  802b79:	c3                   	ret    

00802b7a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802b7a:	55                   	push   %ebp
  802b7b:	89 e5                	mov    %esp,%ebp
  802b7d:	83 ec 04             	sub    $0x4,%esp
  802b80:	8b 45 10             	mov    0x10(%ebp),%eax
  802b83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802b86:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	6a 00                	push   $0x0
  802b8f:	6a 00                	push   $0x0
  802b91:	52                   	push   %edx
  802b92:	ff 75 0c             	pushl  0xc(%ebp)
  802b95:	50                   	push   %eax
  802b96:	6a 00                	push   $0x0
  802b98:	e8 b2 ff ff ff       	call   802b4f <syscall>
  802b9d:	83 c4 18             	add    $0x18,%esp
}
  802ba0:	90                   	nop
  802ba1:	c9                   	leave  
  802ba2:	c3                   	ret    

00802ba3 <sys_cgetc>:

int
sys_cgetc(void)
{
  802ba3:	55                   	push   %ebp
  802ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802ba6:	6a 00                	push   $0x0
  802ba8:	6a 00                	push   $0x0
  802baa:	6a 00                	push   $0x0
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 02                	push   $0x2
  802bb2:	e8 98 ff ff ff       	call   802b4f <syscall>
  802bb7:	83 c4 18             	add    $0x18,%esp
}
  802bba:	c9                   	leave  
  802bbb:	c3                   	ret    

00802bbc <sys_lock_cons>:

void sys_lock_cons(void)
{
  802bbc:	55                   	push   %ebp
  802bbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 00                	push   $0x0
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	6a 03                	push   $0x3
  802bcb:	e8 7f ff ff ff       	call   802b4f <syscall>
  802bd0:	83 c4 18             	add    $0x18,%esp
}
  802bd3:	90                   	nop
  802bd4:	c9                   	leave  
  802bd5:	c3                   	ret    

00802bd6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802bd6:	55                   	push   %ebp
  802bd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802bd9:	6a 00                	push   $0x0
  802bdb:	6a 00                	push   $0x0
  802bdd:	6a 00                	push   $0x0
  802bdf:	6a 00                	push   $0x0
  802be1:	6a 00                	push   $0x0
  802be3:	6a 04                	push   $0x4
  802be5:	e8 65 ff ff ff       	call   802b4f <syscall>
  802bea:	83 c4 18             	add    $0x18,%esp
}
  802bed:	90                   	nop
  802bee:	c9                   	leave  
  802bef:	c3                   	ret    

00802bf0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802bf0:	55                   	push   %ebp
  802bf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	6a 00                	push   $0x0
  802bfb:	6a 00                	push   $0x0
  802bfd:	6a 00                	push   $0x0
  802bff:	52                   	push   %edx
  802c00:	50                   	push   %eax
  802c01:	6a 08                	push   $0x8
  802c03:	e8 47 ff ff ff       	call   802b4f <syscall>
  802c08:	83 c4 18             	add    $0x18,%esp
}
  802c0b:	c9                   	leave  
  802c0c:	c3                   	ret    

00802c0d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802c0d:	55                   	push   %ebp
  802c0e:	89 e5                	mov    %esp,%ebp
  802c10:	56                   	push   %esi
  802c11:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802c12:	8b 75 18             	mov    0x18(%ebp),%esi
  802c15:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	56                   	push   %esi
  802c22:	53                   	push   %ebx
  802c23:	51                   	push   %ecx
  802c24:	52                   	push   %edx
  802c25:	50                   	push   %eax
  802c26:	6a 09                	push   $0x9
  802c28:	e8 22 ff ff ff       	call   802b4f <syscall>
  802c2d:	83 c4 18             	add    $0x18,%esp
}
  802c30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c33:	5b                   	pop    %ebx
  802c34:	5e                   	pop    %esi
  802c35:	5d                   	pop    %ebp
  802c36:	c3                   	ret    

00802c37 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802c37:	55                   	push   %ebp
  802c38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	6a 00                	push   $0x0
  802c42:	6a 00                	push   $0x0
  802c44:	6a 00                	push   $0x0
  802c46:	52                   	push   %edx
  802c47:	50                   	push   %eax
  802c48:	6a 0a                	push   $0xa
  802c4a:	e8 00 ff ff ff       	call   802b4f <syscall>
  802c4f:	83 c4 18             	add    $0x18,%esp
}
  802c52:	c9                   	leave  
  802c53:	c3                   	ret    

00802c54 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802c54:	55                   	push   %ebp
  802c55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802c57:	6a 00                	push   $0x0
  802c59:	6a 00                	push   $0x0
  802c5b:	6a 00                	push   $0x0
  802c5d:	ff 75 0c             	pushl  0xc(%ebp)
  802c60:	ff 75 08             	pushl  0x8(%ebp)
  802c63:	6a 0b                	push   $0xb
  802c65:	e8 e5 fe ff ff       	call   802b4f <syscall>
  802c6a:	83 c4 18             	add    $0x18,%esp
}
  802c6d:	c9                   	leave  
  802c6e:	c3                   	ret    

00802c6f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802c6f:	55                   	push   %ebp
  802c70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802c72:	6a 00                	push   $0x0
  802c74:	6a 00                	push   $0x0
  802c76:	6a 00                	push   $0x0
  802c78:	6a 00                	push   $0x0
  802c7a:	6a 00                	push   $0x0
  802c7c:	6a 0c                	push   $0xc
  802c7e:	e8 cc fe ff ff       	call   802b4f <syscall>
  802c83:	83 c4 18             	add    $0x18,%esp
}
  802c86:	c9                   	leave  
  802c87:	c3                   	ret    

00802c88 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802c88:	55                   	push   %ebp
  802c89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802c8b:	6a 00                	push   $0x0
  802c8d:	6a 00                	push   $0x0
  802c8f:	6a 00                	push   $0x0
  802c91:	6a 00                	push   $0x0
  802c93:	6a 00                	push   $0x0
  802c95:	6a 0d                	push   $0xd
  802c97:	e8 b3 fe ff ff       	call   802b4f <syscall>
  802c9c:	83 c4 18             	add    $0x18,%esp
}
  802c9f:	c9                   	leave  
  802ca0:	c3                   	ret    

00802ca1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802ca1:	55                   	push   %ebp
  802ca2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802ca4:	6a 00                	push   $0x0
  802ca6:	6a 00                	push   $0x0
  802ca8:	6a 00                	push   $0x0
  802caa:	6a 00                	push   $0x0
  802cac:	6a 00                	push   $0x0
  802cae:	6a 0e                	push   $0xe
  802cb0:	e8 9a fe ff ff       	call   802b4f <syscall>
  802cb5:	83 c4 18             	add    $0x18,%esp
}
  802cb8:	c9                   	leave  
  802cb9:	c3                   	ret    

00802cba <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802cba:	55                   	push   %ebp
  802cbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802cbd:	6a 00                	push   $0x0
  802cbf:	6a 00                	push   $0x0
  802cc1:	6a 00                	push   $0x0
  802cc3:	6a 00                	push   $0x0
  802cc5:	6a 00                	push   $0x0
  802cc7:	6a 0f                	push   $0xf
  802cc9:	e8 81 fe ff ff       	call   802b4f <syscall>
  802cce:	83 c4 18             	add    $0x18,%esp
}
  802cd1:	c9                   	leave  
  802cd2:	c3                   	ret    

00802cd3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802cd3:	55                   	push   %ebp
  802cd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802cd6:	6a 00                	push   $0x0
  802cd8:	6a 00                	push   $0x0
  802cda:	6a 00                	push   $0x0
  802cdc:	6a 00                	push   $0x0
  802cde:	ff 75 08             	pushl  0x8(%ebp)
  802ce1:	6a 10                	push   $0x10
  802ce3:	e8 67 fe ff ff       	call   802b4f <syscall>
  802ce8:	83 c4 18             	add    $0x18,%esp
}
  802ceb:	c9                   	leave  
  802cec:	c3                   	ret    

00802ced <sys_scarce_memory>:

void sys_scarce_memory()
{
  802ced:	55                   	push   %ebp
  802cee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802cf0:	6a 00                	push   $0x0
  802cf2:	6a 00                	push   $0x0
  802cf4:	6a 00                	push   $0x0
  802cf6:	6a 00                	push   $0x0
  802cf8:	6a 00                	push   $0x0
  802cfa:	6a 11                	push   $0x11
  802cfc:	e8 4e fe ff ff       	call   802b4f <syscall>
  802d01:	83 c4 18             	add    $0x18,%esp
}
  802d04:	90                   	nop
  802d05:	c9                   	leave  
  802d06:	c3                   	ret    

00802d07 <sys_cputc>:

void
sys_cputc(const char c)
{
  802d07:	55                   	push   %ebp
  802d08:	89 e5                	mov    %esp,%ebp
  802d0a:	83 ec 04             	sub    $0x4,%esp
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802d13:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802d17:	6a 00                	push   $0x0
  802d19:	6a 00                	push   $0x0
  802d1b:	6a 00                	push   $0x0
  802d1d:	6a 00                	push   $0x0
  802d1f:	50                   	push   %eax
  802d20:	6a 01                	push   $0x1
  802d22:	e8 28 fe ff ff       	call   802b4f <syscall>
  802d27:	83 c4 18             	add    $0x18,%esp
}
  802d2a:	90                   	nop
  802d2b:	c9                   	leave  
  802d2c:	c3                   	ret    

00802d2d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802d2d:	55                   	push   %ebp
  802d2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802d30:	6a 00                	push   $0x0
  802d32:	6a 00                	push   $0x0
  802d34:	6a 00                	push   $0x0
  802d36:	6a 00                	push   $0x0
  802d38:	6a 00                	push   $0x0
  802d3a:	6a 14                	push   $0x14
  802d3c:	e8 0e fe ff ff       	call   802b4f <syscall>
  802d41:	83 c4 18             	add    $0x18,%esp
}
  802d44:	90                   	nop
  802d45:	c9                   	leave  
  802d46:	c3                   	ret    

00802d47 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802d47:	55                   	push   %ebp
  802d48:	89 e5                	mov    %esp,%ebp
  802d4a:	83 ec 04             	sub    $0x4,%esp
  802d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  802d50:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802d53:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d56:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	6a 00                	push   $0x0
  802d5f:	51                   	push   %ecx
  802d60:	52                   	push   %edx
  802d61:	ff 75 0c             	pushl  0xc(%ebp)
  802d64:	50                   	push   %eax
  802d65:	6a 15                	push   $0x15
  802d67:	e8 e3 fd ff ff       	call   802b4f <syscall>
  802d6c:	83 c4 18             	add    $0x18,%esp
}
  802d6f:	c9                   	leave  
  802d70:	c3                   	ret    

00802d71 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802d71:	55                   	push   %ebp
  802d72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802d74:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	6a 00                	push   $0x0
  802d7c:	6a 00                	push   $0x0
  802d7e:	6a 00                	push   $0x0
  802d80:	52                   	push   %edx
  802d81:	50                   	push   %eax
  802d82:	6a 16                	push   $0x16
  802d84:	e8 c6 fd ff ff       	call   802b4f <syscall>
  802d89:	83 c4 18             	add    $0x18,%esp
}
  802d8c:	c9                   	leave  
  802d8d:	c3                   	ret    

00802d8e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802d8e:	55                   	push   %ebp
  802d8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802d91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d94:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	6a 00                	push   $0x0
  802d9c:	6a 00                	push   $0x0
  802d9e:	51                   	push   %ecx
  802d9f:	52                   	push   %edx
  802da0:	50                   	push   %eax
  802da1:	6a 17                	push   $0x17
  802da3:	e8 a7 fd ff ff       	call   802b4f <syscall>
  802da8:	83 c4 18             	add    $0x18,%esp
}
  802dab:	c9                   	leave  
  802dac:	c3                   	ret    

00802dad <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802dad:	55                   	push   %ebp
  802dae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802db0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	6a 00                	push   $0x0
  802db8:	6a 00                	push   $0x0
  802dba:	6a 00                	push   $0x0
  802dbc:	52                   	push   %edx
  802dbd:	50                   	push   %eax
  802dbe:	6a 18                	push   $0x18
  802dc0:	e8 8a fd ff ff       	call   802b4f <syscall>
  802dc5:	83 c4 18             	add    $0x18,%esp
}
  802dc8:	c9                   	leave  
  802dc9:	c3                   	ret    

00802dca <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802dca:	55                   	push   %ebp
  802dcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	6a 00                	push   $0x0
  802dd2:	ff 75 14             	pushl  0x14(%ebp)
  802dd5:	ff 75 10             	pushl  0x10(%ebp)
  802dd8:	ff 75 0c             	pushl  0xc(%ebp)
  802ddb:	50                   	push   %eax
  802ddc:	6a 19                	push   $0x19
  802dde:	e8 6c fd ff ff       	call   802b4f <syscall>
  802de3:	83 c4 18             	add    $0x18,%esp
}
  802de6:	c9                   	leave  
  802de7:	c3                   	ret    

00802de8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802de8:	55                   	push   %ebp
  802de9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	6a 00                	push   $0x0
  802df0:	6a 00                	push   $0x0
  802df2:	6a 00                	push   $0x0
  802df4:	6a 00                	push   $0x0
  802df6:	50                   	push   %eax
  802df7:	6a 1a                	push   $0x1a
  802df9:	e8 51 fd ff ff       	call   802b4f <syscall>
  802dfe:	83 c4 18             	add    $0x18,%esp
}
  802e01:	90                   	nop
  802e02:	c9                   	leave  
  802e03:	c3                   	ret    

00802e04 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802e04:	55                   	push   %ebp
  802e05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	6a 00                	push   $0x0
  802e0c:	6a 00                	push   $0x0
  802e0e:	6a 00                	push   $0x0
  802e10:	6a 00                	push   $0x0
  802e12:	50                   	push   %eax
  802e13:	6a 1b                	push   $0x1b
  802e15:	e8 35 fd ff ff       	call   802b4f <syscall>
  802e1a:	83 c4 18             	add    $0x18,%esp
}
  802e1d:	c9                   	leave  
  802e1e:	c3                   	ret    

00802e1f <sys_getenvid>:

int32 sys_getenvid(void)
{
  802e1f:	55                   	push   %ebp
  802e20:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802e22:	6a 00                	push   $0x0
  802e24:	6a 00                	push   $0x0
  802e26:	6a 00                	push   $0x0
  802e28:	6a 00                	push   $0x0
  802e2a:	6a 00                	push   $0x0
  802e2c:	6a 05                	push   $0x5
  802e2e:	e8 1c fd ff ff       	call   802b4f <syscall>
  802e33:	83 c4 18             	add    $0x18,%esp
}
  802e36:	c9                   	leave  
  802e37:	c3                   	ret    

00802e38 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802e38:	55                   	push   %ebp
  802e39:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802e3b:	6a 00                	push   $0x0
  802e3d:	6a 00                	push   $0x0
  802e3f:	6a 00                	push   $0x0
  802e41:	6a 00                	push   $0x0
  802e43:	6a 00                	push   $0x0
  802e45:	6a 06                	push   $0x6
  802e47:	e8 03 fd ff ff       	call   802b4f <syscall>
  802e4c:	83 c4 18             	add    $0x18,%esp
}
  802e4f:	c9                   	leave  
  802e50:	c3                   	ret    

00802e51 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802e51:	55                   	push   %ebp
  802e52:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802e54:	6a 00                	push   $0x0
  802e56:	6a 00                	push   $0x0
  802e58:	6a 00                	push   $0x0
  802e5a:	6a 00                	push   $0x0
  802e5c:	6a 00                	push   $0x0
  802e5e:	6a 07                	push   $0x7
  802e60:	e8 ea fc ff ff       	call   802b4f <syscall>
  802e65:	83 c4 18             	add    $0x18,%esp
}
  802e68:	c9                   	leave  
  802e69:	c3                   	ret    

00802e6a <sys_exit_env>:


void sys_exit_env(void)
{
  802e6a:	55                   	push   %ebp
  802e6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802e6d:	6a 00                	push   $0x0
  802e6f:	6a 00                	push   $0x0
  802e71:	6a 00                	push   $0x0
  802e73:	6a 00                	push   $0x0
  802e75:	6a 00                	push   $0x0
  802e77:	6a 1c                	push   $0x1c
  802e79:	e8 d1 fc ff ff       	call   802b4f <syscall>
  802e7e:	83 c4 18             	add    $0x18,%esp
}
  802e81:	90                   	nop
  802e82:	c9                   	leave  
  802e83:	c3                   	ret    

00802e84 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802e84:	55                   	push   %ebp
  802e85:	89 e5                	mov    %esp,%ebp
  802e87:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802e8a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e8d:	8d 50 04             	lea    0x4(%eax),%edx
  802e90:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e93:	6a 00                	push   $0x0
  802e95:	6a 00                	push   $0x0
  802e97:	6a 00                	push   $0x0
  802e99:	52                   	push   %edx
  802e9a:	50                   	push   %eax
  802e9b:	6a 1d                	push   $0x1d
  802e9d:	e8 ad fc ff ff       	call   802b4f <syscall>
  802ea2:	83 c4 18             	add    $0x18,%esp
	return result;
  802ea5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ea8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802eab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802eae:	89 01                	mov    %eax,(%ecx)
  802eb0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	c9                   	leave  
  802eb7:	c2 04 00             	ret    $0x4

00802eba <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802eba:	55                   	push   %ebp
  802ebb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802ebd:	6a 00                	push   $0x0
  802ebf:	6a 00                	push   $0x0
  802ec1:	ff 75 10             	pushl  0x10(%ebp)
  802ec4:	ff 75 0c             	pushl  0xc(%ebp)
  802ec7:	ff 75 08             	pushl  0x8(%ebp)
  802eca:	6a 13                	push   $0x13
  802ecc:	e8 7e fc ff ff       	call   802b4f <syscall>
  802ed1:	83 c4 18             	add    $0x18,%esp
	return ;
  802ed4:	90                   	nop
}
  802ed5:	c9                   	leave  
  802ed6:	c3                   	ret    

00802ed7 <sys_rcr2>:
uint32 sys_rcr2()
{
  802ed7:	55                   	push   %ebp
  802ed8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802eda:	6a 00                	push   $0x0
  802edc:	6a 00                	push   $0x0
  802ede:	6a 00                	push   $0x0
  802ee0:	6a 00                	push   $0x0
  802ee2:	6a 00                	push   $0x0
  802ee4:	6a 1e                	push   $0x1e
  802ee6:	e8 64 fc ff ff       	call   802b4f <syscall>
  802eeb:	83 c4 18             	add    $0x18,%esp
}
  802eee:	c9                   	leave  
  802eef:	c3                   	ret    

00802ef0 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802ef0:	55                   	push   %ebp
  802ef1:	89 e5                	mov    %esp,%ebp
  802ef3:	83 ec 04             	sub    $0x4,%esp
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802efc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802f00:	6a 00                	push   $0x0
  802f02:	6a 00                	push   $0x0
  802f04:	6a 00                	push   $0x0
  802f06:	6a 00                	push   $0x0
  802f08:	50                   	push   %eax
  802f09:	6a 1f                	push   $0x1f
  802f0b:	e8 3f fc ff ff       	call   802b4f <syscall>
  802f10:	83 c4 18             	add    $0x18,%esp
	return ;
  802f13:	90                   	nop
}
  802f14:	c9                   	leave  
  802f15:	c3                   	ret    

00802f16 <rsttst>:
void rsttst()
{
  802f16:	55                   	push   %ebp
  802f17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802f19:	6a 00                	push   $0x0
  802f1b:	6a 00                	push   $0x0
  802f1d:	6a 00                	push   $0x0
  802f1f:	6a 00                	push   $0x0
  802f21:	6a 00                	push   $0x0
  802f23:	6a 21                	push   $0x21
  802f25:	e8 25 fc ff ff       	call   802b4f <syscall>
  802f2a:	83 c4 18             	add    $0x18,%esp
	return ;
  802f2d:	90                   	nop
}
  802f2e:	c9                   	leave  
  802f2f:	c3                   	ret    

00802f30 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802f30:	55                   	push   %ebp
  802f31:	89 e5                	mov    %esp,%ebp
  802f33:	83 ec 04             	sub    $0x4,%esp
  802f36:	8b 45 14             	mov    0x14(%ebp),%eax
  802f39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802f3c:	8b 55 18             	mov    0x18(%ebp),%edx
  802f3f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f43:	52                   	push   %edx
  802f44:	50                   	push   %eax
  802f45:	ff 75 10             	pushl  0x10(%ebp)
  802f48:	ff 75 0c             	pushl  0xc(%ebp)
  802f4b:	ff 75 08             	pushl  0x8(%ebp)
  802f4e:	6a 20                	push   $0x20
  802f50:	e8 fa fb ff ff       	call   802b4f <syscall>
  802f55:	83 c4 18             	add    $0x18,%esp
	return ;
  802f58:	90                   	nop
}
  802f59:	c9                   	leave  
  802f5a:	c3                   	ret    

00802f5b <chktst>:
void chktst(uint32 n)
{
  802f5b:	55                   	push   %ebp
  802f5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802f5e:	6a 00                	push   $0x0
  802f60:	6a 00                	push   $0x0
  802f62:	6a 00                	push   $0x0
  802f64:	6a 00                	push   $0x0
  802f66:	ff 75 08             	pushl  0x8(%ebp)
  802f69:	6a 22                	push   $0x22
  802f6b:	e8 df fb ff ff       	call   802b4f <syscall>
  802f70:	83 c4 18             	add    $0x18,%esp
	return ;
  802f73:	90                   	nop
}
  802f74:	c9                   	leave  
  802f75:	c3                   	ret    

00802f76 <inctst>:

void inctst()
{
  802f76:	55                   	push   %ebp
  802f77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802f79:	6a 00                	push   $0x0
  802f7b:	6a 00                	push   $0x0
  802f7d:	6a 00                	push   $0x0
  802f7f:	6a 00                	push   $0x0
  802f81:	6a 00                	push   $0x0
  802f83:	6a 23                	push   $0x23
  802f85:	e8 c5 fb ff ff       	call   802b4f <syscall>
  802f8a:	83 c4 18             	add    $0x18,%esp
	return ;
  802f8d:	90                   	nop
}
  802f8e:	c9                   	leave  
  802f8f:	c3                   	ret    

00802f90 <gettst>:
uint32 gettst()
{
  802f90:	55                   	push   %ebp
  802f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	6a 00                	push   $0x0
  802f99:	6a 00                	push   $0x0
  802f9b:	6a 00                	push   $0x0
  802f9d:	6a 24                	push   $0x24
  802f9f:	e8 ab fb ff ff       	call   802b4f <syscall>
  802fa4:	83 c4 18             	add    $0x18,%esp
}
  802fa7:	c9                   	leave  
  802fa8:	c3                   	ret    

00802fa9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802fa9:	55                   	push   %ebp
  802faa:	89 e5                	mov    %esp,%ebp
  802fac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802faf:	6a 00                	push   $0x0
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 00                	push   $0x0
  802fb7:	6a 00                	push   $0x0
  802fb9:	6a 25                	push   $0x25
  802fbb:	e8 8f fb ff ff       	call   802b4f <syscall>
  802fc0:	83 c4 18             	add    $0x18,%esp
  802fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802fc6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802fca:	75 07                	jne    802fd3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802fcc:	b8 01 00 00 00       	mov    $0x1,%eax
  802fd1:	eb 05                	jmp    802fd8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fd8:	c9                   	leave  
  802fd9:	c3                   	ret    

00802fda <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802fda:	55                   	push   %ebp
  802fdb:	89 e5                	mov    %esp,%ebp
  802fdd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802fe0:	6a 00                	push   $0x0
  802fe2:	6a 00                	push   $0x0
  802fe4:	6a 00                	push   $0x0
  802fe6:	6a 00                	push   $0x0
  802fe8:	6a 00                	push   $0x0
  802fea:	6a 25                	push   $0x25
  802fec:	e8 5e fb ff ff       	call   802b4f <syscall>
  802ff1:	83 c4 18             	add    $0x18,%esp
  802ff4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802ff7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802ffb:	75 07                	jne    803004 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802ffd:	b8 01 00 00 00       	mov    $0x1,%eax
  803002:	eb 05                	jmp    803009 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  803004:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803009:	c9                   	leave  
  80300a:	c3                   	ret    

0080300b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80300b:	55                   	push   %ebp
  80300c:	89 e5                	mov    %esp,%ebp
  80300e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803011:	6a 00                	push   $0x0
  803013:	6a 00                	push   $0x0
  803015:	6a 00                	push   $0x0
  803017:	6a 00                	push   $0x0
  803019:	6a 00                	push   $0x0
  80301b:	6a 25                	push   $0x25
  80301d:	e8 2d fb ff ff       	call   802b4f <syscall>
  803022:	83 c4 18             	add    $0x18,%esp
  803025:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803028:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80302c:	75 07                	jne    803035 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80302e:	b8 01 00 00 00       	mov    $0x1,%eax
  803033:	eb 05                	jmp    80303a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803035:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80303a:	c9                   	leave  
  80303b:	c3                   	ret    

0080303c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80303c:	55                   	push   %ebp
  80303d:	89 e5                	mov    %esp,%ebp
  80303f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803042:	6a 00                	push   $0x0
  803044:	6a 00                	push   $0x0
  803046:	6a 00                	push   $0x0
  803048:	6a 00                	push   $0x0
  80304a:	6a 00                	push   $0x0
  80304c:	6a 25                	push   $0x25
  80304e:	e8 fc fa ff ff       	call   802b4f <syscall>
  803053:	83 c4 18             	add    $0x18,%esp
  803056:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803059:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80305d:	75 07                	jne    803066 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80305f:	b8 01 00 00 00       	mov    $0x1,%eax
  803064:	eb 05                	jmp    80306b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803066:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80306b:	c9                   	leave  
  80306c:	c3                   	ret    

0080306d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80306d:	55                   	push   %ebp
  80306e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803070:	6a 00                	push   $0x0
  803072:	6a 00                	push   $0x0
  803074:	6a 00                	push   $0x0
  803076:	6a 00                	push   $0x0
  803078:	ff 75 08             	pushl  0x8(%ebp)
  80307b:	6a 26                	push   $0x26
  80307d:	e8 cd fa ff ff       	call   802b4f <syscall>
  803082:	83 c4 18             	add    $0x18,%esp
	return ;
  803085:	90                   	nop
}
  803086:	c9                   	leave  
  803087:	c3                   	ret    

00803088 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803088:	55                   	push   %ebp
  803089:	89 e5                	mov    %esp,%ebp
  80308b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80308c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80308f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803092:	8b 55 0c             	mov    0xc(%ebp),%edx
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	6a 00                	push   $0x0
  80309a:	53                   	push   %ebx
  80309b:	51                   	push   %ecx
  80309c:	52                   	push   %edx
  80309d:	50                   	push   %eax
  80309e:	6a 27                	push   $0x27
  8030a0:	e8 aa fa ff ff       	call   802b4f <syscall>
  8030a5:	83 c4 18             	add    $0x18,%esp
}
  8030a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030ab:	c9                   	leave  
  8030ac:	c3                   	ret    

008030ad <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8030ad:	55                   	push   %ebp
  8030ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8030b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	6a 00                	push   $0x0
  8030b8:	6a 00                	push   $0x0
  8030ba:	6a 00                	push   $0x0
  8030bc:	52                   	push   %edx
  8030bd:	50                   	push   %eax
  8030be:	6a 28                	push   $0x28
  8030c0:	e8 8a fa ff ff       	call   802b4f <syscall>
  8030c5:	83 c4 18             	add    $0x18,%esp
}
  8030c8:	c9                   	leave  
  8030c9:	c3                   	ret    

008030ca <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8030ca:	55                   	push   %ebp
  8030cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8030cd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8030d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	6a 00                	push   $0x0
  8030d8:	51                   	push   %ecx
  8030d9:	ff 75 10             	pushl  0x10(%ebp)
  8030dc:	52                   	push   %edx
  8030dd:	50                   	push   %eax
  8030de:	6a 29                	push   $0x29
  8030e0:	e8 6a fa ff ff       	call   802b4f <syscall>
  8030e5:	83 c4 18             	add    $0x18,%esp
}
  8030e8:	c9                   	leave  
  8030e9:	c3                   	ret    

008030ea <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8030ea:	55                   	push   %ebp
  8030eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8030ed:	6a 00                	push   $0x0
  8030ef:	6a 00                	push   $0x0
  8030f1:	ff 75 10             	pushl  0x10(%ebp)
  8030f4:	ff 75 0c             	pushl  0xc(%ebp)
  8030f7:	ff 75 08             	pushl  0x8(%ebp)
  8030fa:	6a 12                	push   $0x12
  8030fc:	e8 4e fa ff ff       	call   802b4f <syscall>
  803101:	83 c4 18             	add    $0x18,%esp
	return ;
  803104:	90                   	nop
}
  803105:	c9                   	leave  
  803106:	c3                   	ret    

00803107 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803107:	55                   	push   %ebp
  803108:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80310a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	6a 00                	push   $0x0
  803112:	6a 00                	push   $0x0
  803114:	6a 00                	push   $0x0
  803116:	52                   	push   %edx
  803117:	50                   	push   %eax
  803118:	6a 2a                	push   $0x2a
  80311a:	e8 30 fa ff ff       	call   802b4f <syscall>
  80311f:	83 c4 18             	add    $0x18,%esp
	return;
  803122:	90                   	nop
}
  803123:	c9                   	leave  
  803124:	c3                   	ret    

00803125 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  803125:	55                   	push   %ebp
  803126:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	6a 00                	push   $0x0
  80312d:	6a 00                	push   $0x0
  80312f:	6a 00                	push   $0x0
  803131:	6a 00                	push   $0x0
  803133:	50                   	push   %eax
  803134:	6a 2b                	push   $0x2b
  803136:	e8 14 fa ff ff       	call   802b4f <syscall>
  80313b:	83 c4 18             	add    $0x18,%esp
}
  80313e:	c9                   	leave  
  80313f:	c3                   	ret    

00803140 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803140:	55                   	push   %ebp
  803141:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  803143:	6a 00                	push   $0x0
  803145:	6a 00                	push   $0x0
  803147:	6a 00                	push   $0x0
  803149:	ff 75 0c             	pushl  0xc(%ebp)
  80314c:	ff 75 08             	pushl  0x8(%ebp)
  80314f:	6a 2c                	push   $0x2c
  803151:	e8 f9 f9 ff ff       	call   802b4f <syscall>
  803156:	83 c4 18             	add    $0x18,%esp
	return;
  803159:	90                   	nop
}
  80315a:	c9                   	leave  
  80315b:	c3                   	ret    

0080315c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80315c:	55                   	push   %ebp
  80315d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  80315f:	6a 00                	push   $0x0
  803161:	6a 00                	push   $0x0
  803163:	6a 00                	push   $0x0
  803165:	ff 75 0c             	pushl  0xc(%ebp)
  803168:	ff 75 08             	pushl  0x8(%ebp)
  80316b:	6a 2d                	push   $0x2d
  80316d:	e8 dd f9 ff ff       	call   802b4f <syscall>
  803172:	83 c4 18             	add    $0x18,%esp
	return;
  803175:	90                   	nop
}
  803176:	c9                   	leave  
  803177:	c3                   	ret    

00803178 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  803178:	55                   	push   %ebp
  803179:	89 e5                	mov    %esp,%ebp
  80317b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	83 e8 04             	sub    $0x4,%eax
  803184:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  803187:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80318f:	c9                   	leave  
  803190:	c3                   	ret    

00803191 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  803191:	55                   	push   %ebp
  803192:	89 e5                	mov    %esp,%ebp
  803194:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	83 e8 04             	sub    $0x4,%eax
  80319d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8031a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031a3:	8b 00                	mov    (%eax),%eax
  8031a5:	83 e0 01             	and    $0x1,%eax
  8031a8:	85 c0                	test   %eax,%eax
  8031aa:	0f 94 c0             	sete   %al
}
  8031ad:	c9                   	leave  
  8031ae:	c3                   	ret    

008031af <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8031af:	55                   	push   %ebp
  8031b0:	89 e5                	mov    %esp,%ebp
  8031b2:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8031b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8031bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031bf:	83 f8 02             	cmp    $0x2,%eax
  8031c2:	74 2b                	je     8031ef <alloc_block+0x40>
  8031c4:	83 f8 02             	cmp    $0x2,%eax
  8031c7:	7f 07                	jg     8031d0 <alloc_block+0x21>
  8031c9:	83 f8 01             	cmp    $0x1,%eax
  8031cc:	74 0e                	je     8031dc <alloc_block+0x2d>
  8031ce:	eb 58                	jmp    803228 <alloc_block+0x79>
  8031d0:	83 f8 03             	cmp    $0x3,%eax
  8031d3:	74 2d                	je     803202 <alloc_block+0x53>
  8031d5:	83 f8 04             	cmp    $0x4,%eax
  8031d8:	74 3b                	je     803215 <alloc_block+0x66>
  8031da:	eb 4c                	jmp    803228 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8031dc:	83 ec 0c             	sub    $0xc,%esp
  8031df:	ff 75 08             	pushl  0x8(%ebp)
  8031e2:	e8 11 03 00 00       	call   8034f8 <alloc_block_FF>
  8031e7:	83 c4 10             	add    $0x10,%esp
  8031ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8031ed:	eb 4a                	jmp    803239 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8031ef:	83 ec 0c             	sub    $0xc,%esp
  8031f2:	ff 75 08             	pushl  0x8(%ebp)
  8031f5:	e8 fa 19 00 00       	call   804bf4 <alloc_block_NF>
  8031fa:	83 c4 10             	add    $0x10,%esp
  8031fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803200:	eb 37                	jmp    803239 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  803202:	83 ec 0c             	sub    $0xc,%esp
  803205:	ff 75 08             	pushl  0x8(%ebp)
  803208:	e8 a7 07 00 00       	call   8039b4 <alloc_block_BF>
  80320d:	83 c4 10             	add    $0x10,%esp
  803210:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803213:	eb 24                	jmp    803239 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  803215:	83 ec 0c             	sub    $0xc,%esp
  803218:	ff 75 08             	pushl  0x8(%ebp)
  80321b:	e8 b7 19 00 00       	call   804bd7 <alloc_block_WF>
  803220:	83 c4 10             	add    $0x10,%esp
  803223:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803226:	eb 11                	jmp    803239 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  803228:	83 ec 0c             	sub    $0xc,%esp
  80322b:	68 58 57 80 00       	push   $0x805758
  803230:	e8 3b e6 ff ff       	call   801870 <cprintf>
  803235:	83 c4 10             	add    $0x10,%esp
		break;
  803238:	90                   	nop
	}
	return va;
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80323c:	c9                   	leave  
  80323d:	c3                   	ret    

0080323e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80323e:	55                   	push   %ebp
  80323f:	89 e5                	mov    %esp,%ebp
  803241:	53                   	push   %ebx
  803242:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  803245:	83 ec 0c             	sub    $0xc,%esp
  803248:	68 78 57 80 00       	push   $0x805778
  80324d:	e8 1e e6 ff ff       	call   801870 <cprintf>
  803252:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  803255:	83 ec 0c             	sub    $0xc,%esp
  803258:	68 a3 57 80 00       	push   $0x8057a3
  80325d:	e8 0e e6 ff ff       	call   801870 <cprintf>
  803262:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80326b:	eb 37                	jmp    8032a4 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80326d:	83 ec 0c             	sub    $0xc,%esp
  803270:	ff 75 f4             	pushl  -0xc(%ebp)
  803273:	e8 19 ff ff ff       	call   803191 <is_free_block>
  803278:	83 c4 10             	add    $0x10,%esp
  80327b:	0f be d8             	movsbl %al,%ebx
  80327e:	83 ec 0c             	sub    $0xc,%esp
  803281:	ff 75 f4             	pushl  -0xc(%ebp)
  803284:	e8 ef fe ff ff       	call   803178 <get_block_size>
  803289:	83 c4 10             	add    $0x10,%esp
  80328c:	83 ec 04             	sub    $0x4,%esp
  80328f:	53                   	push   %ebx
  803290:	50                   	push   %eax
  803291:	68 bb 57 80 00       	push   $0x8057bb
  803296:	e8 d5 e5 ff ff       	call   801870 <cprintf>
  80329b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80329e:	8b 45 10             	mov    0x10(%ebp),%eax
  8032a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a8:	74 07                	je     8032b1 <print_blocks_list+0x73>
  8032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ad:	8b 00                	mov    (%eax),%eax
  8032af:	eb 05                	jmp    8032b6 <print_blocks_list+0x78>
  8032b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b6:	89 45 10             	mov    %eax,0x10(%ebp)
  8032b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	75 ad                	jne    80326d <print_blocks_list+0x2f>
  8032c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c4:	75 a7                	jne    80326d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8032c6:	83 ec 0c             	sub    $0xc,%esp
  8032c9:	68 78 57 80 00       	push   $0x805778
  8032ce:	e8 9d e5 ff ff       	call   801870 <cprintf>
  8032d3:	83 c4 10             	add    $0x10,%esp

}
  8032d6:	90                   	nop
  8032d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032da:	c9                   	leave  
  8032db:	c3                   	ret    

008032dc <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8032dc:	55                   	push   %ebp
  8032dd:	89 e5                	mov    %esp,%ebp
  8032df:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8032e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e5:	83 e0 01             	and    $0x1,%eax
  8032e8:	85 c0                	test   %eax,%eax
  8032ea:	74 03                	je     8032ef <initialize_dynamic_allocator+0x13>
  8032ec:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8032ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032f3:	0f 84 c7 01 00 00    	je     8034c0 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8032f9:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  803300:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  803303:	8b 55 08             	mov    0x8(%ebp),%edx
  803306:	8b 45 0c             	mov    0xc(%ebp),%eax
  803309:	01 d0                	add    %edx,%eax
  80330b:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  803310:	0f 87 ad 01 00 00    	ja     8034c3 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	85 c0                	test   %eax,%eax
  80331b:	0f 89 a5 01 00 00    	jns    8034c6 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  803321:	8b 55 08             	mov    0x8(%ebp),%edx
  803324:	8b 45 0c             	mov    0xc(%ebp),%eax
  803327:	01 d0                	add    %edx,%eax
  803329:	83 e8 04             	sub    $0x4,%eax
  80332c:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  803331:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  803338:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80333d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803340:	e9 87 00 00 00       	jmp    8033cc <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  803345:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803349:	75 14                	jne    80335f <initialize_dynamic_allocator+0x83>
  80334b:	83 ec 04             	sub    $0x4,%esp
  80334e:	68 d3 57 80 00       	push   $0x8057d3
  803353:	6a 79                	push   $0x79
  803355:	68 f1 57 80 00       	push   $0x8057f1
  80335a:	e8 54 e2 ff ff       	call   8015b3 <_panic>
  80335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803362:	8b 00                	mov    (%eax),%eax
  803364:	85 c0                	test   %eax,%eax
  803366:	74 10                	je     803378 <initialize_dynamic_allocator+0x9c>
  803368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336b:	8b 00                	mov    (%eax),%eax
  80336d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803370:	8b 52 04             	mov    0x4(%edx),%edx
  803373:	89 50 04             	mov    %edx,0x4(%eax)
  803376:	eb 0b                	jmp    803383 <initialize_dynamic_allocator+0xa7>
  803378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337b:	8b 40 04             	mov    0x4(%eax),%eax
  80337e:	a3 30 60 80 00       	mov    %eax,0x806030
  803383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803386:	8b 40 04             	mov    0x4(%eax),%eax
  803389:	85 c0                	test   %eax,%eax
  80338b:	74 0f                	je     80339c <initialize_dynamic_allocator+0xc0>
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	8b 40 04             	mov    0x4(%eax),%eax
  803393:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803396:	8b 12                	mov    (%edx),%edx
  803398:	89 10                	mov    %edx,(%eax)
  80339a:	eb 0a                	jmp    8033a6 <initialize_dynamic_allocator+0xca>
  80339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339f:	8b 00                	mov    (%eax),%eax
  8033a1:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8033a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b9:	a1 38 60 80 00       	mov    0x806038,%eax
  8033be:	48                   	dec    %eax
  8033bf:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8033c4:	a1 34 60 80 00       	mov    0x806034,%eax
  8033c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d0:	74 07                	je     8033d9 <initialize_dynamic_allocator+0xfd>
  8033d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d5:	8b 00                	mov    (%eax),%eax
  8033d7:	eb 05                	jmp    8033de <initialize_dynamic_allocator+0x102>
  8033d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033de:	a3 34 60 80 00       	mov    %eax,0x806034
  8033e3:	a1 34 60 80 00       	mov    0x806034,%eax
  8033e8:	85 c0                	test   %eax,%eax
  8033ea:	0f 85 55 ff ff ff    	jne    803345 <initialize_dynamic_allocator+0x69>
  8033f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f4:	0f 85 4b ff ff ff    	jne    803345 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  803400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803403:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  803409:	a1 44 60 80 00       	mov    0x806044,%eax
  80340e:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  803413:	a1 40 60 80 00       	mov    0x806040,%eax
  803418:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	83 c0 08             	add    $0x8,%eax
  803424:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  803427:	8b 45 08             	mov    0x8(%ebp),%eax
  80342a:	83 c0 04             	add    $0x4,%eax
  80342d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803430:	83 ea 08             	sub    $0x8,%edx
  803433:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  803435:	8b 55 0c             	mov    0xc(%ebp),%edx
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	01 d0                	add    %edx,%eax
  80343d:	83 e8 08             	sub    $0x8,%eax
  803440:	8b 55 0c             	mov    0xc(%ebp),%edx
  803443:	83 ea 08             	sub    $0x8,%edx
  803446:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  803448:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80344b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  803451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803454:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80345b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80345f:	75 17                	jne    803478 <initialize_dynamic_allocator+0x19c>
  803461:	83 ec 04             	sub    $0x4,%esp
  803464:	68 0c 58 80 00       	push   $0x80580c
  803469:	68 90 00 00 00       	push   $0x90
  80346e:	68 f1 57 80 00       	push   $0x8057f1
  803473:	e8 3b e1 ff ff       	call   8015b3 <_panic>
  803478:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  80347e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803481:	89 10                	mov    %edx,(%eax)
  803483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803486:	8b 00                	mov    (%eax),%eax
  803488:	85 c0                	test   %eax,%eax
  80348a:	74 0d                	je     803499 <initialize_dynamic_allocator+0x1bd>
  80348c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803491:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803494:	89 50 04             	mov    %edx,0x4(%eax)
  803497:	eb 08                	jmp    8034a1 <initialize_dynamic_allocator+0x1c5>
  803499:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80349c:	a3 30 60 80 00       	mov    %eax,0x806030
  8034a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a4:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8034a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b3:	a1 38 60 80 00       	mov    0x806038,%eax
  8034b8:	40                   	inc    %eax
  8034b9:	a3 38 60 80 00       	mov    %eax,0x806038
  8034be:	eb 07                	jmp    8034c7 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8034c0:	90                   	nop
  8034c1:	eb 04                	jmp    8034c7 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8034c3:	90                   	nop
  8034c4:	eb 01                	jmp    8034c7 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8034c6:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8034c7:	c9                   	leave  
  8034c8:	c3                   	ret    

008034c9 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8034c9:	55                   	push   %ebp
  8034ca:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8034cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8034cf:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8034d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8034d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034db:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	83 e8 04             	sub    $0x4,%eax
  8034e3:	8b 00                	mov    (%eax),%eax
  8034e5:	83 e0 fe             	and    $0xfffffffe,%eax
  8034e8:	8d 50 f8             	lea    -0x8(%eax),%edx
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	01 c2                	add    %eax,%edx
  8034f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f3:	89 02                	mov    %eax,(%edx)
}
  8034f5:	90                   	nop
  8034f6:	5d                   	pop    %ebp
  8034f7:	c3                   	ret    

008034f8 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8034f8:	55                   	push   %ebp
  8034f9:	89 e5                	mov    %esp,%ebp
  8034fb:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8034fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803501:	83 e0 01             	and    $0x1,%eax
  803504:	85 c0                	test   %eax,%eax
  803506:	74 03                	je     80350b <alloc_block_FF+0x13>
  803508:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80350b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80350f:	77 07                	ja     803518 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803511:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803518:	a1 24 60 80 00       	mov    0x806024,%eax
  80351d:	85 c0                	test   %eax,%eax
  80351f:	75 73                	jne    803594 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	83 c0 10             	add    $0x10,%eax
  803527:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80352a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  803531:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803537:	01 d0                	add    %edx,%eax
  803539:	48                   	dec    %eax
  80353a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80353d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803540:	ba 00 00 00 00       	mov    $0x0,%edx
  803545:	f7 75 ec             	divl   -0x14(%ebp)
  803548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354b:	29 d0                	sub    %edx,%eax
  80354d:	c1 e8 0c             	shr    $0xc,%eax
  803550:	83 ec 0c             	sub    $0xc,%esp
  803553:	50                   	push   %eax
  803554:	e8 b1 f0 ff ff       	call   80260a <sbrk>
  803559:	83 c4 10             	add    $0x10,%esp
  80355c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80355f:	83 ec 0c             	sub    $0xc,%esp
  803562:	6a 00                	push   $0x0
  803564:	e8 a1 f0 ff ff       	call   80260a <sbrk>
  803569:	83 c4 10             	add    $0x10,%esp
  80356c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80356f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803572:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803575:	83 ec 08             	sub    $0x8,%esp
  803578:	50                   	push   %eax
  803579:	ff 75 e4             	pushl  -0x1c(%ebp)
  80357c:	e8 5b fd ff ff       	call   8032dc <initialize_dynamic_allocator>
  803581:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803584:	83 ec 0c             	sub    $0xc,%esp
  803587:	68 2f 58 80 00       	push   $0x80582f
  80358c:	e8 df e2 ff ff       	call   801870 <cprintf>
  803591:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803594:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803598:	75 0a                	jne    8035a4 <alloc_block_FF+0xac>
	        return NULL;
  80359a:	b8 00 00 00 00       	mov    $0x0,%eax
  80359f:	e9 0e 04 00 00       	jmp    8039b2 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8035a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8035ab:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8035b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035b3:	e9 f3 02 00 00       	jmp    8038ab <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8035b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8035be:	83 ec 0c             	sub    $0xc,%esp
  8035c1:	ff 75 bc             	pushl  -0x44(%ebp)
  8035c4:	e8 af fb ff ff       	call   803178 <get_block_size>
  8035c9:	83 c4 10             	add    $0x10,%esp
  8035cc:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8035cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d2:	83 c0 08             	add    $0x8,%eax
  8035d5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8035d8:	0f 87 c5 02 00 00    	ja     8038a3 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8035de:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e1:	83 c0 18             	add    $0x18,%eax
  8035e4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8035e7:	0f 87 19 02 00 00    	ja     803806 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8035ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035f0:	2b 45 08             	sub    0x8(%ebp),%eax
  8035f3:	83 e8 08             	sub    $0x8,%eax
  8035f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	8d 50 08             	lea    0x8(%eax),%edx
  8035ff:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803602:	01 d0                	add    %edx,%eax
  803604:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	83 c0 08             	add    $0x8,%eax
  80360d:	83 ec 04             	sub    $0x4,%esp
  803610:	6a 01                	push   $0x1
  803612:	50                   	push   %eax
  803613:	ff 75 bc             	pushl  -0x44(%ebp)
  803616:	e8 ae fe ff ff       	call   8034c9 <set_block_data>
  80361b:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80361e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803621:	8b 40 04             	mov    0x4(%eax),%eax
  803624:	85 c0                	test   %eax,%eax
  803626:	75 68                	jne    803690 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803628:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80362c:	75 17                	jne    803645 <alloc_block_FF+0x14d>
  80362e:	83 ec 04             	sub    $0x4,%esp
  803631:	68 0c 58 80 00       	push   $0x80580c
  803636:	68 d7 00 00 00       	push   $0xd7
  80363b:	68 f1 57 80 00       	push   $0x8057f1
  803640:	e8 6e df ff ff       	call   8015b3 <_panic>
  803645:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  80364b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80364e:	89 10                	mov    %edx,(%eax)
  803650:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803653:	8b 00                	mov    (%eax),%eax
  803655:	85 c0                	test   %eax,%eax
  803657:	74 0d                	je     803666 <alloc_block_FF+0x16e>
  803659:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80365e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803661:	89 50 04             	mov    %edx,0x4(%eax)
  803664:	eb 08                	jmp    80366e <alloc_block_FF+0x176>
  803666:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803669:	a3 30 60 80 00       	mov    %eax,0x806030
  80366e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803671:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803676:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803679:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803680:	a1 38 60 80 00       	mov    0x806038,%eax
  803685:	40                   	inc    %eax
  803686:	a3 38 60 80 00       	mov    %eax,0x806038
  80368b:	e9 dc 00 00 00       	jmp    80376c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803693:	8b 00                	mov    (%eax),%eax
  803695:	85 c0                	test   %eax,%eax
  803697:	75 65                	jne    8036fe <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803699:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80369d:	75 17                	jne    8036b6 <alloc_block_FF+0x1be>
  80369f:	83 ec 04             	sub    $0x4,%esp
  8036a2:	68 40 58 80 00       	push   $0x805840
  8036a7:	68 db 00 00 00       	push   $0xdb
  8036ac:	68 f1 57 80 00       	push   $0x8057f1
  8036b1:	e8 fd de ff ff       	call   8015b3 <_panic>
  8036b6:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8036bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036bf:	89 50 04             	mov    %edx,0x4(%eax)
  8036c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036c5:	8b 40 04             	mov    0x4(%eax),%eax
  8036c8:	85 c0                	test   %eax,%eax
  8036ca:	74 0c                	je     8036d8 <alloc_block_FF+0x1e0>
  8036cc:	a1 30 60 80 00       	mov    0x806030,%eax
  8036d1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8036d4:	89 10                	mov    %edx,(%eax)
  8036d6:	eb 08                	jmp    8036e0 <alloc_block_FF+0x1e8>
  8036d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036db:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8036e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036e3:	a3 30 60 80 00       	mov    %eax,0x806030
  8036e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f1:	a1 38 60 80 00       	mov    0x806038,%eax
  8036f6:	40                   	inc    %eax
  8036f7:	a3 38 60 80 00       	mov    %eax,0x806038
  8036fc:	eb 6e                	jmp    80376c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8036fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803702:	74 06                	je     80370a <alloc_block_FF+0x212>
  803704:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803708:	75 17                	jne    803721 <alloc_block_FF+0x229>
  80370a:	83 ec 04             	sub    $0x4,%esp
  80370d:	68 64 58 80 00       	push   $0x805864
  803712:	68 df 00 00 00       	push   $0xdf
  803717:	68 f1 57 80 00       	push   $0x8057f1
  80371c:	e8 92 de ff ff       	call   8015b3 <_panic>
  803721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803724:	8b 10                	mov    (%eax),%edx
  803726:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803729:	89 10                	mov    %edx,(%eax)
  80372b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80372e:	8b 00                	mov    (%eax),%eax
  803730:	85 c0                	test   %eax,%eax
  803732:	74 0b                	je     80373f <alloc_block_FF+0x247>
  803734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803737:	8b 00                	mov    (%eax),%eax
  803739:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80373c:	89 50 04             	mov    %edx,0x4(%eax)
  80373f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803742:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803745:	89 10                	mov    %edx,(%eax)
  803747:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80374a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80374d:	89 50 04             	mov    %edx,0x4(%eax)
  803750:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803753:	8b 00                	mov    (%eax),%eax
  803755:	85 c0                	test   %eax,%eax
  803757:	75 08                	jne    803761 <alloc_block_FF+0x269>
  803759:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80375c:	a3 30 60 80 00       	mov    %eax,0x806030
  803761:	a1 38 60 80 00       	mov    0x806038,%eax
  803766:	40                   	inc    %eax
  803767:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80376c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803770:	75 17                	jne    803789 <alloc_block_FF+0x291>
  803772:	83 ec 04             	sub    $0x4,%esp
  803775:	68 d3 57 80 00       	push   $0x8057d3
  80377a:	68 e1 00 00 00       	push   $0xe1
  80377f:	68 f1 57 80 00       	push   $0x8057f1
  803784:	e8 2a de ff ff       	call   8015b3 <_panic>
  803789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378c:	8b 00                	mov    (%eax),%eax
  80378e:	85 c0                	test   %eax,%eax
  803790:	74 10                	je     8037a2 <alloc_block_FF+0x2aa>
  803792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803795:	8b 00                	mov    (%eax),%eax
  803797:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80379a:	8b 52 04             	mov    0x4(%edx),%edx
  80379d:	89 50 04             	mov    %edx,0x4(%eax)
  8037a0:	eb 0b                	jmp    8037ad <alloc_block_FF+0x2b5>
  8037a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a5:	8b 40 04             	mov    0x4(%eax),%eax
  8037a8:	a3 30 60 80 00       	mov    %eax,0x806030
  8037ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b0:	8b 40 04             	mov    0x4(%eax),%eax
  8037b3:	85 c0                	test   %eax,%eax
  8037b5:	74 0f                	je     8037c6 <alloc_block_FF+0x2ce>
  8037b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ba:	8b 40 04             	mov    0x4(%eax),%eax
  8037bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037c0:	8b 12                	mov    (%edx),%edx
  8037c2:	89 10                	mov    %edx,(%eax)
  8037c4:	eb 0a                	jmp    8037d0 <alloc_block_FF+0x2d8>
  8037c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c9:	8b 00                	mov    (%eax),%eax
  8037cb:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8037d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037e3:	a1 38 60 80 00       	mov    0x806038,%eax
  8037e8:	48                   	dec    %eax
  8037e9:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  8037ee:	83 ec 04             	sub    $0x4,%esp
  8037f1:	6a 00                	push   $0x0
  8037f3:	ff 75 b4             	pushl  -0x4c(%ebp)
  8037f6:	ff 75 b0             	pushl  -0x50(%ebp)
  8037f9:	e8 cb fc ff ff       	call   8034c9 <set_block_data>
  8037fe:	83 c4 10             	add    $0x10,%esp
  803801:	e9 95 00 00 00       	jmp    80389b <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803806:	83 ec 04             	sub    $0x4,%esp
  803809:	6a 01                	push   $0x1
  80380b:	ff 75 b8             	pushl  -0x48(%ebp)
  80380e:	ff 75 bc             	pushl  -0x44(%ebp)
  803811:	e8 b3 fc ff ff       	call   8034c9 <set_block_data>
  803816:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  803819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80381d:	75 17                	jne    803836 <alloc_block_FF+0x33e>
  80381f:	83 ec 04             	sub    $0x4,%esp
  803822:	68 d3 57 80 00       	push   $0x8057d3
  803827:	68 e8 00 00 00       	push   $0xe8
  80382c:	68 f1 57 80 00       	push   $0x8057f1
  803831:	e8 7d dd ff ff       	call   8015b3 <_panic>
  803836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803839:	8b 00                	mov    (%eax),%eax
  80383b:	85 c0                	test   %eax,%eax
  80383d:	74 10                	je     80384f <alloc_block_FF+0x357>
  80383f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803842:	8b 00                	mov    (%eax),%eax
  803844:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803847:	8b 52 04             	mov    0x4(%edx),%edx
  80384a:	89 50 04             	mov    %edx,0x4(%eax)
  80384d:	eb 0b                	jmp    80385a <alloc_block_FF+0x362>
  80384f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803852:	8b 40 04             	mov    0x4(%eax),%eax
  803855:	a3 30 60 80 00       	mov    %eax,0x806030
  80385a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385d:	8b 40 04             	mov    0x4(%eax),%eax
  803860:	85 c0                	test   %eax,%eax
  803862:	74 0f                	je     803873 <alloc_block_FF+0x37b>
  803864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803867:	8b 40 04             	mov    0x4(%eax),%eax
  80386a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80386d:	8b 12                	mov    (%edx),%edx
  80386f:	89 10                	mov    %edx,(%eax)
  803871:	eb 0a                	jmp    80387d <alloc_block_FF+0x385>
  803873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803876:	8b 00                	mov    (%eax),%eax
  803878:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80387d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803880:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803889:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803890:	a1 38 60 80 00       	mov    0x806038,%eax
  803895:	48                   	dec    %eax
  803896:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  80389b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80389e:	e9 0f 01 00 00       	jmp    8039b2 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8038a3:	a1 34 60 80 00       	mov    0x806034,%eax
  8038a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038af:	74 07                	je     8038b8 <alloc_block_FF+0x3c0>
  8038b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b4:	8b 00                	mov    (%eax),%eax
  8038b6:	eb 05                	jmp    8038bd <alloc_block_FF+0x3c5>
  8038b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8038bd:	a3 34 60 80 00       	mov    %eax,0x806034
  8038c2:	a1 34 60 80 00       	mov    0x806034,%eax
  8038c7:	85 c0                	test   %eax,%eax
  8038c9:	0f 85 e9 fc ff ff    	jne    8035b8 <alloc_block_FF+0xc0>
  8038cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038d3:	0f 85 df fc ff ff    	jne    8035b8 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8038d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dc:	83 c0 08             	add    $0x8,%eax
  8038df:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8038e2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8038e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8038ef:	01 d0                	add    %edx,%eax
  8038f1:	48                   	dec    %eax
  8038f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8038f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8038f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8038fd:	f7 75 d8             	divl   -0x28(%ebp)
  803900:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803903:	29 d0                	sub    %edx,%eax
  803905:	c1 e8 0c             	shr    $0xc,%eax
  803908:	83 ec 0c             	sub    $0xc,%esp
  80390b:	50                   	push   %eax
  80390c:	e8 f9 ec ff ff       	call   80260a <sbrk>
  803911:	83 c4 10             	add    $0x10,%esp
  803914:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  803917:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80391b:	75 0a                	jne    803927 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80391d:	b8 00 00 00 00       	mov    $0x0,%eax
  803922:	e9 8b 00 00 00       	jmp    8039b2 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803927:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80392e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803931:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803934:	01 d0                	add    %edx,%eax
  803936:	48                   	dec    %eax
  803937:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80393a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80393d:	ba 00 00 00 00       	mov    $0x0,%edx
  803942:	f7 75 cc             	divl   -0x34(%ebp)
  803945:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803948:	29 d0                	sub    %edx,%eax
  80394a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80394d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803950:	01 d0                	add    %edx,%eax
  803952:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  803957:	a1 40 60 80 00       	mov    0x806040,%eax
  80395c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803962:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803969:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80396c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80396f:	01 d0                	add    %edx,%eax
  803971:	48                   	dec    %eax
  803972:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803975:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803978:	ba 00 00 00 00       	mov    $0x0,%edx
  80397d:	f7 75 c4             	divl   -0x3c(%ebp)
  803980:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803983:	29 d0                	sub    %edx,%eax
  803985:	83 ec 04             	sub    $0x4,%esp
  803988:	6a 01                	push   $0x1
  80398a:	50                   	push   %eax
  80398b:	ff 75 d0             	pushl  -0x30(%ebp)
  80398e:	e8 36 fb ff ff       	call   8034c9 <set_block_data>
  803993:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803996:	83 ec 0c             	sub    $0xc,%esp
  803999:	ff 75 d0             	pushl  -0x30(%ebp)
  80399c:	e8 1b 0a 00 00       	call   8043bc <free_block>
  8039a1:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8039a4:	83 ec 0c             	sub    $0xc,%esp
  8039a7:	ff 75 08             	pushl  0x8(%ebp)
  8039aa:	e8 49 fb ff ff       	call   8034f8 <alloc_block_FF>
  8039af:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8039b2:	c9                   	leave  
  8039b3:	c3                   	ret    

008039b4 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8039b4:	55                   	push   %ebp
  8039b5:	89 e5                	mov    %esp,%ebp
  8039b7:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8039ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bd:	83 e0 01             	and    $0x1,%eax
  8039c0:	85 c0                	test   %eax,%eax
  8039c2:	74 03                	je     8039c7 <alloc_block_BF+0x13>
  8039c4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8039c7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8039cb:	77 07                	ja     8039d4 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8039cd:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8039d4:	a1 24 60 80 00       	mov    0x806024,%eax
  8039d9:	85 c0                	test   %eax,%eax
  8039db:	75 73                	jne    803a50 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8039dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e0:	83 c0 10             	add    $0x10,%eax
  8039e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8039e6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8039ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039f3:	01 d0                	add    %edx,%eax
  8039f5:	48                   	dec    %eax
  8039f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8039f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039fc:	ba 00 00 00 00       	mov    $0x0,%edx
  803a01:	f7 75 e0             	divl   -0x20(%ebp)
  803a04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a07:	29 d0                	sub    %edx,%eax
  803a09:	c1 e8 0c             	shr    $0xc,%eax
  803a0c:	83 ec 0c             	sub    $0xc,%esp
  803a0f:	50                   	push   %eax
  803a10:	e8 f5 eb ff ff       	call   80260a <sbrk>
  803a15:	83 c4 10             	add    $0x10,%esp
  803a18:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803a1b:	83 ec 0c             	sub    $0xc,%esp
  803a1e:	6a 00                	push   $0x0
  803a20:	e8 e5 eb ff ff       	call   80260a <sbrk>
  803a25:	83 c4 10             	add    $0x10,%esp
  803a28:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803a2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803a2e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  803a31:	83 ec 08             	sub    $0x8,%esp
  803a34:	50                   	push   %eax
  803a35:	ff 75 d8             	pushl  -0x28(%ebp)
  803a38:	e8 9f f8 ff ff       	call   8032dc <initialize_dynamic_allocator>
  803a3d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803a40:	83 ec 0c             	sub    $0xc,%esp
  803a43:	68 2f 58 80 00       	push   $0x80582f
  803a48:	e8 23 de ff ff       	call   801870 <cprintf>
  803a4d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  803a50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  803a57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  803a5e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  803a65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  803a6c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a74:	e9 1d 01 00 00       	jmp    803b96 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  803a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803a7f:	83 ec 0c             	sub    $0xc,%esp
  803a82:	ff 75 a8             	pushl  -0x58(%ebp)
  803a85:	e8 ee f6 ff ff       	call   803178 <get_block_size>
  803a8a:	83 c4 10             	add    $0x10,%esp
  803a8d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803a90:	8b 45 08             	mov    0x8(%ebp),%eax
  803a93:	83 c0 08             	add    $0x8,%eax
  803a96:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803a99:	0f 87 ef 00 00 00    	ja     803b8e <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa2:	83 c0 18             	add    $0x18,%eax
  803aa5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803aa8:	77 1d                	ja     803ac7 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803aaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aad:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803ab0:	0f 86 d8 00 00 00    	jbe    803b8e <alloc_block_BF+0x1da>
				{
					best_va = va;
  803ab6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803abc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803abf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803ac2:	e9 c7 00 00 00       	jmp    803b8e <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  803aca:	83 c0 08             	add    $0x8,%eax
  803acd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803ad0:	0f 85 9d 00 00 00    	jne    803b73 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803ad6:	83 ec 04             	sub    $0x4,%esp
  803ad9:	6a 01                	push   $0x1
  803adb:	ff 75 a4             	pushl  -0x5c(%ebp)
  803ade:	ff 75 a8             	pushl  -0x58(%ebp)
  803ae1:	e8 e3 f9 ff ff       	call   8034c9 <set_block_data>
  803ae6:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803aed:	75 17                	jne    803b06 <alloc_block_BF+0x152>
  803aef:	83 ec 04             	sub    $0x4,%esp
  803af2:	68 d3 57 80 00       	push   $0x8057d3
  803af7:	68 2c 01 00 00       	push   $0x12c
  803afc:	68 f1 57 80 00       	push   $0x8057f1
  803b01:	e8 ad da ff ff       	call   8015b3 <_panic>
  803b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b09:	8b 00                	mov    (%eax),%eax
  803b0b:	85 c0                	test   %eax,%eax
  803b0d:	74 10                	je     803b1f <alloc_block_BF+0x16b>
  803b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b12:	8b 00                	mov    (%eax),%eax
  803b14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b17:	8b 52 04             	mov    0x4(%edx),%edx
  803b1a:	89 50 04             	mov    %edx,0x4(%eax)
  803b1d:	eb 0b                	jmp    803b2a <alloc_block_BF+0x176>
  803b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b22:	8b 40 04             	mov    0x4(%eax),%eax
  803b25:	a3 30 60 80 00       	mov    %eax,0x806030
  803b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2d:	8b 40 04             	mov    0x4(%eax),%eax
  803b30:	85 c0                	test   %eax,%eax
  803b32:	74 0f                	je     803b43 <alloc_block_BF+0x18f>
  803b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b37:	8b 40 04             	mov    0x4(%eax),%eax
  803b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b3d:	8b 12                	mov    (%edx),%edx
  803b3f:	89 10                	mov    %edx,(%eax)
  803b41:	eb 0a                	jmp    803b4d <alloc_block_BF+0x199>
  803b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b46:	8b 00                	mov    (%eax),%eax
  803b48:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b60:	a1 38 60 80 00       	mov    0x806038,%eax
  803b65:	48                   	dec    %eax
  803b66:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  803b6b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803b6e:	e9 24 04 00 00       	jmp    803f97 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b76:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803b79:	76 13                	jbe    803b8e <alloc_block_BF+0x1da>
					{
						internal = 1;
  803b7b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803b82:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803b88:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803b8e:	a1 34 60 80 00       	mov    0x806034,%eax
  803b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b9a:	74 07                	je     803ba3 <alloc_block_BF+0x1ef>
  803b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9f:	8b 00                	mov    (%eax),%eax
  803ba1:	eb 05                	jmp    803ba8 <alloc_block_BF+0x1f4>
  803ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  803ba8:	a3 34 60 80 00       	mov    %eax,0x806034
  803bad:	a1 34 60 80 00       	mov    0x806034,%eax
  803bb2:	85 c0                	test   %eax,%eax
  803bb4:	0f 85 bf fe ff ff    	jne    803a79 <alloc_block_BF+0xc5>
  803bba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bbe:	0f 85 b5 fe ff ff    	jne    803a79 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803bc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bc8:	0f 84 26 02 00 00    	je     803df4 <alloc_block_BF+0x440>
  803bce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bd2:	0f 85 1c 02 00 00    	jne    803df4 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bdb:	2b 45 08             	sub    0x8(%ebp),%eax
  803bde:	83 e8 08             	sub    $0x8,%eax
  803be1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803be4:	8b 45 08             	mov    0x8(%ebp),%eax
  803be7:	8d 50 08             	lea    0x8(%eax),%edx
  803bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bed:	01 d0                	add    %edx,%eax
  803bef:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf5:	83 c0 08             	add    $0x8,%eax
  803bf8:	83 ec 04             	sub    $0x4,%esp
  803bfb:	6a 01                	push   $0x1
  803bfd:	50                   	push   %eax
  803bfe:	ff 75 f0             	pushl  -0x10(%ebp)
  803c01:	e8 c3 f8 ff ff       	call   8034c9 <set_block_data>
  803c06:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c0c:	8b 40 04             	mov    0x4(%eax),%eax
  803c0f:	85 c0                	test   %eax,%eax
  803c11:	75 68                	jne    803c7b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803c13:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803c17:	75 17                	jne    803c30 <alloc_block_BF+0x27c>
  803c19:	83 ec 04             	sub    $0x4,%esp
  803c1c:	68 0c 58 80 00       	push   $0x80580c
  803c21:	68 45 01 00 00       	push   $0x145
  803c26:	68 f1 57 80 00       	push   $0x8057f1
  803c2b:	e8 83 d9 ff ff       	call   8015b3 <_panic>
  803c30:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803c36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c39:	89 10                	mov    %edx,(%eax)
  803c3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c3e:	8b 00                	mov    (%eax),%eax
  803c40:	85 c0                	test   %eax,%eax
  803c42:	74 0d                	je     803c51 <alloc_block_BF+0x29d>
  803c44:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803c49:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803c4c:	89 50 04             	mov    %edx,0x4(%eax)
  803c4f:	eb 08                	jmp    803c59 <alloc_block_BF+0x2a5>
  803c51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c54:	a3 30 60 80 00       	mov    %eax,0x806030
  803c59:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c5c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803c61:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c6b:	a1 38 60 80 00       	mov    0x806038,%eax
  803c70:	40                   	inc    %eax
  803c71:	a3 38 60 80 00       	mov    %eax,0x806038
  803c76:	e9 dc 00 00 00       	jmp    803d57 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c7e:	8b 00                	mov    (%eax),%eax
  803c80:	85 c0                	test   %eax,%eax
  803c82:	75 65                	jne    803ce9 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803c84:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803c88:	75 17                	jne    803ca1 <alloc_block_BF+0x2ed>
  803c8a:	83 ec 04             	sub    $0x4,%esp
  803c8d:	68 40 58 80 00       	push   $0x805840
  803c92:	68 4a 01 00 00       	push   $0x14a
  803c97:	68 f1 57 80 00       	push   $0x8057f1
  803c9c:	e8 12 d9 ff ff       	call   8015b3 <_panic>
  803ca1:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803ca7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803caa:	89 50 04             	mov    %edx,0x4(%eax)
  803cad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cb0:	8b 40 04             	mov    0x4(%eax),%eax
  803cb3:	85 c0                	test   %eax,%eax
  803cb5:	74 0c                	je     803cc3 <alloc_block_BF+0x30f>
  803cb7:	a1 30 60 80 00       	mov    0x806030,%eax
  803cbc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803cbf:	89 10                	mov    %edx,(%eax)
  803cc1:	eb 08                	jmp    803ccb <alloc_block_BF+0x317>
  803cc3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cc6:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803ccb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cce:	a3 30 60 80 00       	mov    %eax,0x806030
  803cd3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cdc:	a1 38 60 80 00       	mov    0x806038,%eax
  803ce1:	40                   	inc    %eax
  803ce2:	a3 38 60 80 00       	mov    %eax,0x806038
  803ce7:	eb 6e                	jmp    803d57 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803ce9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ced:	74 06                	je     803cf5 <alloc_block_BF+0x341>
  803cef:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803cf3:	75 17                	jne    803d0c <alloc_block_BF+0x358>
  803cf5:	83 ec 04             	sub    $0x4,%esp
  803cf8:	68 64 58 80 00       	push   $0x805864
  803cfd:	68 4f 01 00 00       	push   $0x14f
  803d02:	68 f1 57 80 00       	push   $0x8057f1
  803d07:	e8 a7 d8 ff ff       	call   8015b3 <_panic>
  803d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d0f:	8b 10                	mov    (%eax),%edx
  803d11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d14:	89 10                	mov    %edx,(%eax)
  803d16:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d19:	8b 00                	mov    (%eax),%eax
  803d1b:	85 c0                	test   %eax,%eax
  803d1d:	74 0b                	je     803d2a <alloc_block_BF+0x376>
  803d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d22:	8b 00                	mov    (%eax),%eax
  803d24:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803d27:	89 50 04             	mov    %edx,0x4(%eax)
  803d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d2d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803d30:	89 10                	mov    %edx,(%eax)
  803d32:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d38:	89 50 04             	mov    %edx,0x4(%eax)
  803d3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d3e:	8b 00                	mov    (%eax),%eax
  803d40:	85 c0                	test   %eax,%eax
  803d42:	75 08                	jne    803d4c <alloc_block_BF+0x398>
  803d44:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d47:	a3 30 60 80 00       	mov    %eax,0x806030
  803d4c:	a1 38 60 80 00       	mov    0x806038,%eax
  803d51:	40                   	inc    %eax
  803d52:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803d57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d5b:	75 17                	jne    803d74 <alloc_block_BF+0x3c0>
  803d5d:	83 ec 04             	sub    $0x4,%esp
  803d60:	68 d3 57 80 00       	push   $0x8057d3
  803d65:	68 51 01 00 00       	push   $0x151
  803d6a:	68 f1 57 80 00       	push   $0x8057f1
  803d6f:	e8 3f d8 ff ff       	call   8015b3 <_panic>
  803d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d77:	8b 00                	mov    (%eax),%eax
  803d79:	85 c0                	test   %eax,%eax
  803d7b:	74 10                	je     803d8d <alloc_block_BF+0x3d9>
  803d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d80:	8b 00                	mov    (%eax),%eax
  803d82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d85:	8b 52 04             	mov    0x4(%edx),%edx
  803d88:	89 50 04             	mov    %edx,0x4(%eax)
  803d8b:	eb 0b                	jmp    803d98 <alloc_block_BF+0x3e4>
  803d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d90:	8b 40 04             	mov    0x4(%eax),%eax
  803d93:	a3 30 60 80 00       	mov    %eax,0x806030
  803d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d9b:	8b 40 04             	mov    0x4(%eax),%eax
  803d9e:	85 c0                	test   %eax,%eax
  803da0:	74 0f                	je     803db1 <alloc_block_BF+0x3fd>
  803da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803da5:	8b 40 04             	mov    0x4(%eax),%eax
  803da8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dab:	8b 12                	mov    (%edx),%edx
  803dad:	89 10                	mov    %edx,(%eax)
  803daf:	eb 0a                	jmp    803dbb <alloc_block_BF+0x407>
  803db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db4:	8b 00                	mov    (%eax),%eax
  803db6:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dce:	a1 38 60 80 00       	mov    0x806038,%eax
  803dd3:	48                   	dec    %eax
  803dd4:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  803dd9:	83 ec 04             	sub    $0x4,%esp
  803ddc:	6a 00                	push   $0x0
  803dde:	ff 75 d0             	pushl  -0x30(%ebp)
  803de1:	ff 75 cc             	pushl  -0x34(%ebp)
  803de4:	e8 e0 f6 ff ff       	call   8034c9 <set_block_data>
  803de9:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803def:	e9 a3 01 00 00       	jmp    803f97 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803df4:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803df8:	0f 85 9d 00 00 00    	jne    803e9b <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803dfe:	83 ec 04             	sub    $0x4,%esp
  803e01:	6a 01                	push   $0x1
  803e03:	ff 75 ec             	pushl  -0x14(%ebp)
  803e06:	ff 75 f0             	pushl  -0x10(%ebp)
  803e09:	e8 bb f6 ff ff       	call   8034c9 <set_block_data>
  803e0e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803e11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e15:	75 17                	jne    803e2e <alloc_block_BF+0x47a>
  803e17:	83 ec 04             	sub    $0x4,%esp
  803e1a:	68 d3 57 80 00       	push   $0x8057d3
  803e1f:	68 58 01 00 00       	push   $0x158
  803e24:	68 f1 57 80 00       	push   $0x8057f1
  803e29:	e8 85 d7 ff ff       	call   8015b3 <_panic>
  803e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e31:	8b 00                	mov    (%eax),%eax
  803e33:	85 c0                	test   %eax,%eax
  803e35:	74 10                	je     803e47 <alloc_block_BF+0x493>
  803e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e3a:	8b 00                	mov    (%eax),%eax
  803e3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e3f:	8b 52 04             	mov    0x4(%edx),%edx
  803e42:	89 50 04             	mov    %edx,0x4(%eax)
  803e45:	eb 0b                	jmp    803e52 <alloc_block_BF+0x49e>
  803e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e4a:	8b 40 04             	mov    0x4(%eax),%eax
  803e4d:	a3 30 60 80 00       	mov    %eax,0x806030
  803e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e55:	8b 40 04             	mov    0x4(%eax),%eax
  803e58:	85 c0                	test   %eax,%eax
  803e5a:	74 0f                	je     803e6b <alloc_block_BF+0x4b7>
  803e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e5f:	8b 40 04             	mov    0x4(%eax),%eax
  803e62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e65:	8b 12                	mov    (%edx),%edx
  803e67:	89 10                	mov    %edx,(%eax)
  803e69:	eb 0a                	jmp    803e75 <alloc_block_BF+0x4c1>
  803e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e6e:	8b 00                	mov    (%eax),%eax
  803e70:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e88:	a1 38 60 80 00       	mov    0x806038,%eax
  803e8d:	48                   	dec    %eax
  803e8e:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e96:	e9 fc 00 00 00       	jmp    803f97 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9e:	83 c0 08             	add    $0x8,%eax
  803ea1:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803ea4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803eab:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803eae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803eb1:	01 d0                	add    %edx,%eax
  803eb3:	48                   	dec    %eax
  803eb4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803eb7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803eba:	ba 00 00 00 00       	mov    $0x0,%edx
  803ebf:	f7 75 c4             	divl   -0x3c(%ebp)
  803ec2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803ec5:	29 d0                	sub    %edx,%eax
  803ec7:	c1 e8 0c             	shr    $0xc,%eax
  803eca:	83 ec 0c             	sub    $0xc,%esp
  803ecd:	50                   	push   %eax
  803ece:	e8 37 e7 ff ff       	call   80260a <sbrk>
  803ed3:	83 c4 10             	add    $0x10,%esp
  803ed6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803ed9:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803edd:	75 0a                	jne    803ee9 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803edf:	b8 00 00 00 00       	mov    $0x0,%eax
  803ee4:	e9 ae 00 00 00       	jmp    803f97 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803ee9:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803ef0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ef3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ef6:	01 d0                	add    %edx,%eax
  803ef8:	48                   	dec    %eax
  803ef9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803efc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803eff:	ba 00 00 00 00       	mov    $0x0,%edx
  803f04:	f7 75 b8             	divl   -0x48(%ebp)
  803f07:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803f0a:	29 d0                	sub    %edx,%eax
  803f0c:	8d 50 fc             	lea    -0x4(%eax),%edx
  803f0f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803f12:	01 d0                	add    %edx,%eax
  803f14:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  803f19:	a1 40 60 80 00       	mov    0x806040,%eax
  803f1e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803f24:	83 ec 0c             	sub    $0xc,%esp
  803f27:	68 98 58 80 00       	push   $0x805898
  803f2c:	e8 3f d9 ff ff       	call   801870 <cprintf>
  803f31:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803f34:	83 ec 08             	sub    $0x8,%esp
  803f37:	ff 75 bc             	pushl  -0x44(%ebp)
  803f3a:	68 9d 58 80 00       	push   $0x80589d
  803f3f:	e8 2c d9 ff ff       	call   801870 <cprintf>
  803f44:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803f47:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803f4e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803f51:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803f54:	01 d0                	add    %edx,%eax
  803f56:	48                   	dec    %eax
  803f57:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803f5a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803f5d:	ba 00 00 00 00       	mov    $0x0,%edx
  803f62:	f7 75 b0             	divl   -0x50(%ebp)
  803f65:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803f68:	29 d0                	sub    %edx,%eax
  803f6a:	83 ec 04             	sub    $0x4,%esp
  803f6d:	6a 01                	push   $0x1
  803f6f:	50                   	push   %eax
  803f70:	ff 75 bc             	pushl  -0x44(%ebp)
  803f73:	e8 51 f5 ff ff       	call   8034c9 <set_block_data>
  803f78:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803f7b:	83 ec 0c             	sub    $0xc,%esp
  803f7e:	ff 75 bc             	pushl  -0x44(%ebp)
  803f81:	e8 36 04 00 00       	call   8043bc <free_block>
  803f86:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803f89:	83 ec 0c             	sub    $0xc,%esp
  803f8c:	ff 75 08             	pushl  0x8(%ebp)
  803f8f:	e8 20 fa ff ff       	call   8039b4 <alloc_block_BF>
  803f94:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803f97:	c9                   	leave  
  803f98:	c3                   	ret    

00803f99 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803f99:	55                   	push   %ebp
  803f9a:	89 e5                	mov    %esp,%ebp
  803f9c:	53                   	push   %ebx
  803f9d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803fa0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803fa7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803fae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803fb2:	74 1e                	je     803fd2 <merging+0x39>
  803fb4:	ff 75 08             	pushl  0x8(%ebp)
  803fb7:	e8 bc f1 ff ff       	call   803178 <get_block_size>
  803fbc:	83 c4 04             	add    $0x4,%esp
  803fbf:	89 c2                	mov    %eax,%edx
  803fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc4:	01 d0                	add    %edx,%eax
  803fc6:	3b 45 10             	cmp    0x10(%ebp),%eax
  803fc9:	75 07                	jne    803fd2 <merging+0x39>
		prev_is_free = 1;
  803fcb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803fd2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803fd6:	74 1e                	je     803ff6 <merging+0x5d>
  803fd8:	ff 75 10             	pushl  0x10(%ebp)
  803fdb:	e8 98 f1 ff ff       	call   803178 <get_block_size>
  803fe0:	83 c4 04             	add    $0x4,%esp
  803fe3:	89 c2                	mov    %eax,%edx
  803fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  803fe8:	01 d0                	add    %edx,%eax
  803fea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803fed:	75 07                	jne    803ff6 <merging+0x5d>
		next_is_free = 1;
  803fef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803ff6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ffa:	0f 84 cc 00 00 00    	je     8040cc <merging+0x133>
  804000:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804004:	0f 84 c2 00 00 00    	je     8040cc <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  80400a:	ff 75 08             	pushl  0x8(%ebp)
  80400d:	e8 66 f1 ff ff       	call   803178 <get_block_size>
  804012:	83 c4 04             	add    $0x4,%esp
  804015:	89 c3                	mov    %eax,%ebx
  804017:	ff 75 10             	pushl  0x10(%ebp)
  80401a:	e8 59 f1 ff ff       	call   803178 <get_block_size>
  80401f:	83 c4 04             	add    $0x4,%esp
  804022:	01 c3                	add    %eax,%ebx
  804024:	ff 75 0c             	pushl  0xc(%ebp)
  804027:	e8 4c f1 ff ff       	call   803178 <get_block_size>
  80402c:	83 c4 04             	add    $0x4,%esp
  80402f:	01 d8                	add    %ebx,%eax
  804031:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  804034:	6a 00                	push   $0x0
  804036:	ff 75 ec             	pushl  -0x14(%ebp)
  804039:	ff 75 08             	pushl  0x8(%ebp)
  80403c:	e8 88 f4 ff ff       	call   8034c9 <set_block_data>
  804041:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  804044:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804048:	75 17                	jne    804061 <merging+0xc8>
  80404a:	83 ec 04             	sub    $0x4,%esp
  80404d:	68 d3 57 80 00       	push   $0x8057d3
  804052:	68 7d 01 00 00       	push   $0x17d
  804057:	68 f1 57 80 00       	push   $0x8057f1
  80405c:	e8 52 d5 ff ff       	call   8015b3 <_panic>
  804061:	8b 45 0c             	mov    0xc(%ebp),%eax
  804064:	8b 00                	mov    (%eax),%eax
  804066:	85 c0                	test   %eax,%eax
  804068:	74 10                	je     80407a <merging+0xe1>
  80406a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80406d:	8b 00                	mov    (%eax),%eax
  80406f:	8b 55 0c             	mov    0xc(%ebp),%edx
  804072:	8b 52 04             	mov    0x4(%edx),%edx
  804075:	89 50 04             	mov    %edx,0x4(%eax)
  804078:	eb 0b                	jmp    804085 <merging+0xec>
  80407a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80407d:	8b 40 04             	mov    0x4(%eax),%eax
  804080:	a3 30 60 80 00       	mov    %eax,0x806030
  804085:	8b 45 0c             	mov    0xc(%ebp),%eax
  804088:	8b 40 04             	mov    0x4(%eax),%eax
  80408b:	85 c0                	test   %eax,%eax
  80408d:	74 0f                	je     80409e <merging+0x105>
  80408f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804092:	8b 40 04             	mov    0x4(%eax),%eax
  804095:	8b 55 0c             	mov    0xc(%ebp),%edx
  804098:	8b 12                	mov    (%edx),%edx
  80409a:	89 10                	mov    %edx,(%eax)
  80409c:	eb 0a                	jmp    8040a8 <merging+0x10f>
  80409e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040a1:	8b 00                	mov    (%eax),%eax
  8040a3:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8040a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040bb:	a1 38 60 80 00       	mov    0x806038,%eax
  8040c0:	48                   	dec    %eax
  8040c1:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8040c6:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8040c7:	e9 ea 02 00 00       	jmp    8043b6 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8040cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040d0:	74 3b                	je     80410d <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8040d2:	83 ec 0c             	sub    $0xc,%esp
  8040d5:	ff 75 08             	pushl  0x8(%ebp)
  8040d8:	e8 9b f0 ff ff       	call   803178 <get_block_size>
  8040dd:	83 c4 10             	add    $0x10,%esp
  8040e0:	89 c3                	mov    %eax,%ebx
  8040e2:	83 ec 0c             	sub    $0xc,%esp
  8040e5:	ff 75 10             	pushl  0x10(%ebp)
  8040e8:	e8 8b f0 ff ff       	call   803178 <get_block_size>
  8040ed:	83 c4 10             	add    $0x10,%esp
  8040f0:	01 d8                	add    %ebx,%eax
  8040f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8040f5:	83 ec 04             	sub    $0x4,%esp
  8040f8:	6a 00                	push   $0x0
  8040fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8040fd:	ff 75 08             	pushl  0x8(%ebp)
  804100:	e8 c4 f3 ff ff       	call   8034c9 <set_block_data>
  804105:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  804108:	e9 a9 02 00 00       	jmp    8043b6 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  80410d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804111:	0f 84 2d 01 00 00    	je     804244 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  804117:	83 ec 0c             	sub    $0xc,%esp
  80411a:	ff 75 10             	pushl  0x10(%ebp)
  80411d:	e8 56 f0 ff ff       	call   803178 <get_block_size>
  804122:	83 c4 10             	add    $0x10,%esp
  804125:	89 c3                	mov    %eax,%ebx
  804127:	83 ec 0c             	sub    $0xc,%esp
  80412a:	ff 75 0c             	pushl  0xc(%ebp)
  80412d:	e8 46 f0 ff ff       	call   803178 <get_block_size>
  804132:	83 c4 10             	add    $0x10,%esp
  804135:	01 d8                	add    %ebx,%eax
  804137:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80413a:	83 ec 04             	sub    $0x4,%esp
  80413d:	6a 00                	push   $0x0
  80413f:	ff 75 e4             	pushl  -0x1c(%ebp)
  804142:	ff 75 10             	pushl  0x10(%ebp)
  804145:	e8 7f f3 ff ff       	call   8034c9 <set_block_data>
  80414a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80414d:	8b 45 10             	mov    0x10(%ebp),%eax
  804150:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  804153:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804157:	74 06                	je     80415f <merging+0x1c6>
  804159:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80415d:	75 17                	jne    804176 <merging+0x1dd>
  80415f:	83 ec 04             	sub    $0x4,%esp
  804162:	68 ac 58 80 00       	push   $0x8058ac
  804167:	68 8d 01 00 00       	push   $0x18d
  80416c:	68 f1 57 80 00       	push   $0x8057f1
  804171:	e8 3d d4 ff ff       	call   8015b3 <_panic>
  804176:	8b 45 0c             	mov    0xc(%ebp),%eax
  804179:	8b 50 04             	mov    0x4(%eax),%edx
  80417c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80417f:	89 50 04             	mov    %edx,0x4(%eax)
  804182:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804185:	8b 55 0c             	mov    0xc(%ebp),%edx
  804188:	89 10                	mov    %edx,(%eax)
  80418a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80418d:	8b 40 04             	mov    0x4(%eax),%eax
  804190:	85 c0                	test   %eax,%eax
  804192:	74 0d                	je     8041a1 <merging+0x208>
  804194:	8b 45 0c             	mov    0xc(%ebp),%eax
  804197:	8b 40 04             	mov    0x4(%eax),%eax
  80419a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80419d:	89 10                	mov    %edx,(%eax)
  80419f:	eb 08                	jmp    8041a9 <merging+0x210>
  8041a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041a4:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8041a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8041af:	89 50 04             	mov    %edx,0x4(%eax)
  8041b2:	a1 38 60 80 00       	mov    0x806038,%eax
  8041b7:	40                   	inc    %eax
  8041b8:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  8041bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8041c1:	75 17                	jne    8041da <merging+0x241>
  8041c3:	83 ec 04             	sub    $0x4,%esp
  8041c6:	68 d3 57 80 00       	push   $0x8057d3
  8041cb:	68 8e 01 00 00       	push   $0x18e
  8041d0:	68 f1 57 80 00       	push   $0x8057f1
  8041d5:	e8 d9 d3 ff ff       	call   8015b3 <_panic>
  8041da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041dd:	8b 00                	mov    (%eax),%eax
  8041df:	85 c0                	test   %eax,%eax
  8041e1:	74 10                	je     8041f3 <merging+0x25a>
  8041e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041e6:	8b 00                	mov    (%eax),%eax
  8041e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8041eb:	8b 52 04             	mov    0x4(%edx),%edx
  8041ee:	89 50 04             	mov    %edx,0x4(%eax)
  8041f1:	eb 0b                	jmp    8041fe <merging+0x265>
  8041f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041f6:	8b 40 04             	mov    0x4(%eax),%eax
  8041f9:	a3 30 60 80 00       	mov    %eax,0x806030
  8041fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  804201:	8b 40 04             	mov    0x4(%eax),%eax
  804204:	85 c0                	test   %eax,%eax
  804206:	74 0f                	je     804217 <merging+0x27e>
  804208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80420b:	8b 40 04             	mov    0x4(%eax),%eax
  80420e:	8b 55 0c             	mov    0xc(%ebp),%edx
  804211:	8b 12                	mov    (%edx),%edx
  804213:	89 10                	mov    %edx,(%eax)
  804215:	eb 0a                	jmp    804221 <merging+0x288>
  804217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80421a:	8b 00                	mov    (%eax),%eax
  80421c:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804221:	8b 45 0c             	mov    0xc(%ebp),%eax
  804224:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80422a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80422d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804234:	a1 38 60 80 00       	mov    0x806038,%eax
  804239:	48                   	dec    %eax
  80423a:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80423f:	e9 72 01 00 00       	jmp    8043b6 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  804244:	8b 45 10             	mov    0x10(%ebp),%eax
  804247:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80424a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80424e:	74 79                	je     8042c9 <merging+0x330>
  804250:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804254:	74 73                	je     8042c9 <merging+0x330>
  804256:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80425a:	74 06                	je     804262 <merging+0x2c9>
  80425c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804260:	75 17                	jne    804279 <merging+0x2e0>
  804262:	83 ec 04             	sub    $0x4,%esp
  804265:	68 64 58 80 00       	push   $0x805864
  80426a:	68 94 01 00 00       	push   $0x194
  80426f:	68 f1 57 80 00       	push   $0x8057f1
  804274:	e8 3a d3 ff ff       	call   8015b3 <_panic>
  804279:	8b 45 08             	mov    0x8(%ebp),%eax
  80427c:	8b 10                	mov    (%eax),%edx
  80427e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804281:	89 10                	mov    %edx,(%eax)
  804283:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804286:	8b 00                	mov    (%eax),%eax
  804288:	85 c0                	test   %eax,%eax
  80428a:	74 0b                	je     804297 <merging+0x2fe>
  80428c:	8b 45 08             	mov    0x8(%ebp),%eax
  80428f:	8b 00                	mov    (%eax),%eax
  804291:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804294:	89 50 04             	mov    %edx,0x4(%eax)
  804297:	8b 45 08             	mov    0x8(%ebp),%eax
  80429a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80429d:	89 10                	mov    %edx,(%eax)
  80429f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8042a5:	89 50 04             	mov    %edx,0x4(%eax)
  8042a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042ab:	8b 00                	mov    (%eax),%eax
  8042ad:	85 c0                	test   %eax,%eax
  8042af:	75 08                	jne    8042b9 <merging+0x320>
  8042b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042b4:	a3 30 60 80 00       	mov    %eax,0x806030
  8042b9:	a1 38 60 80 00       	mov    0x806038,%eax
  8042be:	40                   	inc    %eax
  8042bf:	a3 38 60 80 00       	mov    %eax,0x806038
  8042c4:	e9 ce 00 00 00       	jmp    804397 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8042c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8042cd:	74 65                	je     804334 <merging+0x39b>
  8042cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8042d3:	75 17                	jne    8042ec <merging+0x353>
  8042d5:	83 ec 04             	sub    $0x4,%esp
  8042d8:	68 40 58 80 00       	push   $0x805840
  8042dd:	68 95 01 00 00       	push   $0x195
  8042e2:	68 f1 57 80 00       	push   $0x8057f1
  8042e7:	e8 c7 d2 ff ff       	call   8015b3 <_panic>
  8042ec:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8042f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042f5:	89 50 04             	mov    %edx,0x4(%eax)
  8042f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042fb:	8b 40 04             	mov    0x4(%eax),%eax
  8042fe:	85 c0                	test   %eax,%eax
  804300:	74 0c                	je     80430e <merging+0x375>
  804302:	a1 30 60 80 00       	mov    0x806030,%eax
  804307:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80430a:	89 10                	mov    %edx,(%eax)
  80430c:	eb 08                	jmp    804316 <merging+0x37d>
  80430e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804311:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804316:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804319:	a3 30 60 80 00       	mov    %eax,0x806030
  80431e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804321:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804327:	a1 38 60 80 00       	mov    0x806038,%eax
  80432c:	40                   	inc    %eax
  80432d:	a3 38 60 80 00       	mov    %eax,0x806038
  804332:	eb 63                	jmp    804397 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  804334:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804338:	75 17                	jne    804351 <merging+0x3b8>
  80433a:	83 ec 04             	sub    $0x4,%esp
  80433d:	68 0c 58 80 00       	push   $0x80580c
  804342:	68 98 01 00 00       	push   $0x198
  804347:	68 f1 57 80 00       	push   $0x8057f1
  80434c:	e8 62 d2 ff ff       	call   8015b3 <_panic>
  804351:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  804357:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80435a:	89 10                	mov    %edx,(%eax)
  80435c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80435f:	8b 00                	mov    (%eax),%eax
  804361:	85 c0                	test   %eax,%eax
  804363:	74 0d                	je     804372 <merging+0x3d9>
  804365:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80436a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80436d:	89 50 04             	mov    %edx,0x4(%eax)
  804370:	eb 08                	jmp    80437a <merging+0x3e1>
  804372:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804375:	a3 30 60 80 00       	mov    %eax,0x806030
  80437a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80437d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804385:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80438c:	a1 38 60 80 00       	mov    0x806038,%eax
  804391:	40                   	inc    %eax
  804392:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  804397:	83 ec 0c             	sub    $0xc,%esp
  80439a:	ff 75 10             	pushl  0x10(%ebp)
  80439d:	e8 d6 ed ff ff       	call   803178 <get_block_size>
  8043a2:	83 c4 10             	add    $0x10,%esp
  8043a5:	83 ec 04             	sub    $0x4,%esp
  8043a8:	6a 00                	push   $0x0
  8043aa:	50                   	push   %eax
  8043ab:	ff 75 10             	pushl  0x10(%ebp)
  8043ae:	e8 16 f1 ff ff       	call   8034c9 <set_block_data>
  8043b3:	83 c4 10             	add    $0x10,%esp
	}
}
  8043b6:	90                   	nop
  8043b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8043ba:	c9                   	leave  
  8043bb:	c3                   	ret    

008043bc <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8043bc:	55                   	push   %ebp
  8043bd:	89 e5                	mov    %esp,%ebp
  8043bf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8043c2:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8043c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8043ca:	a1 30 60 80 00       	mov    0x806030,%eax
  8043cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8043d2:	73 1b                	jae    8043ef <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8043d4:	a1 30 60 80 00       	mov    0x806030,%eax
  8043d9:	83 ec 04             	sub    $0x4,%esp
  8043dc:	ff 75 08             	pushl  0x8(%ebp)
  8043df:	6a 00                	push   $0x0
  8043e1:	50                   	push   %eax
  8043e2:	e8 b2 fb ff ff       	call   803f99 <merging>
  8043e7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8043ea:	e9 8b 00 00 00       	jmp    80447a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8043ef:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8043f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8043f7:	76 18                	jbe    804411 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8043f9:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8043fe:	83 ec 04             	sub    $0x4,%esp
  804401:	ff 75 08             	pushl  0x8(%ebp)
  804404:	50                   	push   %eax
  804405:	6a 00                	push   $0x0
  804407:	e8 8d fb ff ff       	call   803f99 <merging>
  80440c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80440f:	eb 69                	jmp    80447a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  804411:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804416:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804419:	eb 39                	jmp    804454 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80441b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80441e:	3b 45 08             	cmp    0x8(%ebp),%eax
  804421:	73 29                	jae    80444c <free_block+0x90>
  804423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804426:	8b 00                	mov    (%eax),%eax
  804428:	3b 45 08             	cmp    0x8(%ebp),%eax
  80442b:	76 1f                	jbe    80444c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80442d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804430:	8b 00                	mov    (%eax),%eax
  804432:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  804435:	83 ec 04             	sub    $0x4,%esp
  804438:	ff 75 08             	pushl  0x8(%ebp)
  80443b:	ff 75 f0             	pushl  -0x10(%ebp)
  80443e:	ff 75 f4             	pushl  -0xc(%ebp)
  804441:	e8 53 fb ff ff       	call   803f99 <merging>
  804446:	83 c4 10             	add    $0x10,%esp
			break;
  804449:	90                   	nop
		}
	}
}
  80444a:	eb 2e                	jmp    80447a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80444c:	a1 34 60 80 00       	mov    0x806034,%eax
  804451:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804458:	74 07                	je     804461 <free_block+0xa5>
  80445a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80445d:	8b 00                	mov    (%eax),%eax
  80445f:	eb 05                	jmp    804466 <free_block+0xaa>
  804461:	b8 00 00 00 00       	mov    $0x0,%eax
  804466:	a3 34 60 80 00       	mov    %eax,0x806034
  80446b:	a1 34 60 80 00       	mov    0x806034,%eax
  804470:	85 c0                	test   %eax,%eax
  804472:	75 a7                	jne    80441b <free_block+0x5f>
  804474:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804478:	75 a1                	jne    80441b <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80447a:	90                   	nop
  80447b:	c9                   	leave  
  80447c:	c3                   	ret    

0080447d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80447d:	55                   	push   %ebp
  80447e:	89 e5                	mov    %esp,%ebp
  804480:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  804483:	ff 75 08             	pushl  0x8(%ebp)
  804486:	e8 ed ec ff ff       	call   803178 <get_block_size>
  80448b:	83 c4 04             	add    $0x4,%esp
  80448e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  804491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  804498:	eb 17                	jmp    8044b1 <copy_data+0x34>
  80449a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80449d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044a0:	01 c2                	add    %eax,%edx
  8044a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8044a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8044a8:	01 c8                	add    %ecx,%eax
  8044aa:	8a 00                	mov    (%eax),%al
  8044ac:	88 02                	mov    %al,(%edx)
  8044ae:	ff 45 fc             	incl   -0x4(%ebp)
  8044b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8044b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8044b7:	72 e1                	jb     80449a <copy_data+0x1d>
}
  8044b9:	90                   	nop
  8044ba:	c9                   	leave  
  8044bb:	c3                   	ret    

008044bc <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8044bc:	55                   	push   %ebp
  8044bd:	89 e5                	mov    %esp,%ebp
  8044bf:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8044c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8044c6:	75 23                	jne    8044eb <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8044c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8044cc:	74 13                	je     8044e1 <realloc_block_FF+0x25>
  8044ce:	83 ec 0c             	sub    $0xc,%esp
  8044d1:	ff 75 0c             	pushl  0xc(%ebp)
  8044d4:	e8 1f f0 ff ff       	call   8034f8 <alloc_block_FF>
  8044d9:	83 c4 10             	add    $0x10,%esp
  8044dc:	e9 f4 06 00 00       	jmp    804bd5 <realloc_block_FF+0x719>
		return NULL;
  8044e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8044e6:	e9 ea 06 00 00       	jmp    804bd5 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8044eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8044ef:	75 18                	jne    804509 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8044f1:	83 ec 0c             	sub    $0xc,%esp
  8044f4:	ff 75 08             	pushl  0x8(%ebp)
  8044f7:	e8 c0 fe ff ff       	call   8043bc <free_block>
  8044fc:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8044ff:	b8 00 00 00 00       	mov    $0x0,%eax
  804504:	e9 cc 06 00 00       	jmp    804bd5 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  804509:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80450d:	77 07                	ja     804516 <realloc_block_FF+0x5a>
  80450f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  804516:	8b 45 0c             	mov    0xc(%ebp),%eax
  804519:	83 e0 01             	and    $0x1,%eax
  80451c:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80451f:	8b 45 0c             	mov    0xc(%ebp),%eax
  804522:	83 c0 08             	add    $0x8,%eax
  804525:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  804528:	83 ec 0c             	sub    $0xc,%esp
  80452b:	ff 75 08             	pushl  0x8(%ebp)
  80452e:	e8 45 ec ff ff       	call   803178 <get_block_size>
  804533:	83 c4 10             	add    $0x10,%esp
  804536:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804539:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80453c:	83 e8 08             	sub    $0x8,%eax
  80453f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  804542:	8b 45 08             	mov    0x8(%ebp),%eax
  804545:	83 e8 04             	sub    $0x4,%eax
  804548:	8b 00                	mov    (%eax),%eax
  80454a:	83 e0 fe             	and    $0xfffffffe,%eax
  80454d:	89 c2                	mov    %eax,%edx
  80454f:	8b 45 08             	mov    0x8(%ebp),%eax
  804552:	01 d0                	add    %edx,%eax
  804554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  804557:	83 ec 0c             	sub    $0xc,%esp
  80455a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80455d:	e8 16 ec ff ff       	call   803178 <get_block_size>
  804562:	83 c4 10             	add    $0x10,%esp
  804565:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  804568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80456b:	83 e8 08             	sub    $0x8,%eax
  80456e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  804571:	8b 45 0c             	mov    0xc(%ebp),%eax
  804574:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804577:	75 08                	jne    804581 <realloc_block_FF+0xc5>
	{
		 return va;
  804579:	8b 45 08             	mov    0x8(%ebp),%eax
  80457c:	e9 54 06 00 00       	jmp    804bd5 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  804581:	8b 45 0c             	mov    0xc(%ebp),%eax
  804584:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804587:	0f 83 e5 03 00 00    	jae    804972 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80458d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804590:	2b 45 0c             	sub    0xc(%ebp),%eax
  804593:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804596:	83 ec 0c             	sub    $0xc,%esp
  804599:	ff 75 e4             	pushl  -0x1c(%ebp)
  80459c:	e8 f0 eb ff ff       	call   803191 <is_free_block>
  8045a1:	83 c4 10             	add    $0x10,%esp
  8045a4:	84 c0                	test   %al,%al
  8045a6:	0f 84 3b 01 00 00    	je     8046e7 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8045ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8045af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8045b2:	01 d0                	add    %edx,%eax
  8045b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8045b7:	83 ec 04             	sub    $0x4,%esp
  8045ba:	6a 01                	push   $0x1
  8045bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8045bf:	ff 75 08             	pushl  0x8(%ebp)
  8045c2:	e8 02 ef ff ff       	call   8034c9 <set_block_data>
  8045c7:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8045ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8045cd:	83 e8 04             	sub    $0x4,%eax
  8045d0:	8b 00                	mov    (%eax),%eax
  8045d2:	83 e0 fe             	and    $0xfffffffe,%eax
  8045d5:	89 c2                	mov    %eax,%edx
  8045d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8045da:	01 d0                	add    %edx,%eax
  8045dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8045df:	83 ec 04             	sub    $0x4,%esp
  8045e2:	6a 00                	push   $0x0
  8045e4:	ff 75 cc             	pushl  -0x34(%ebp)
  8045e7:	ff 75 c8             	pushl  -0x38(%ebp)
  8045ea:	e8 da ee ff ff       	call   8034c9 <set_block_data>
  8045ef:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8045f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045f6:	74 06                	je     8045fe <realloc_block_FF+0x142>
  8045f8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8045fc:	75 17                	jne    804615 <realloc_block_FF+0x159>
  8045fe:	83 ec 04             	sub    $0x4,%esp
  804601:	68 64 58 80 00       	push   $0x805864
  804606:	68 f6 01 00 00       	push   $0x1f6
  80460b:	68 f1 57 80 00       	push   $0x8057f1
  804610:	e8 9e cf ff ff       	call   8015b3 <_panic>
  804615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804618:	8b 10                	mov    (%eax),%edx
  80461a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80461d:	89 10                	mov    %edx,(%eax)
  80461f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804622:	8b 00                	mov    (%eax),%eax
  804624:	85 c0                	test   %eax,%eax
  804626:	74 0b                	je     804633 <realloc_block_FF+0x177>
  804628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80462b:	8b 00                	mov    (%eax),%eax
  80462d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804630:	89 50 04             	mov    %edx,0x4(%eax)
  804633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804636:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804639:	89 10                	mov    %edx,(%eax)
  80463b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80463e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804641:	89 50 04             	mov    %edx,0x4(%eax)
  804644:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804647:	8b 00                	mov    (%eax),%eax
  804649:	85 c0                	test   %eax,%eax
  80464b:	75 08                	jne    804655 <realloc_block_FF+0x199>
  80464d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804650:	a3 30 60 80 00       	mov    %eax,0x806030
  804655:	a1 38 60 80 00       	mov    0x806038,%eax
  80465a:	40                   	inc    %eax
  80465b:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804660:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804664:	75 17                	jne    80467d <realloc_block_FF+0x1c1>
  804666:	83 ec 04             	sub    $0x4,%esp
  804669:	68 d3 57 80 00       	push   $0x8057d3
  80466e:	68 f7 01 00 00       	push   $0x1f7
  804673:	68 f1 57 80 00       	push   $0x8057f1
  804678:	e8 36 cf ff ff       	call   8015b3 <_panic>
  80467d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804680:	8b 00                	mov    (%eax),%eax
  804682:	85 c0                	test   %eax,%eax
  804684:	74 10                	je     804696 <realloc_block_FF+0x1da>
  804686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804689:	8b 00                	mov    (%eax),%eax
  80468b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80468e:	8b 52 04             	mov    0x4(%edx),%edx
  804691:	89 50 04             	mov    %edx,0x4(%eax)
  804694:	eb 0b                	jmp    8046a1 <realloc_block_FF+0x1e5>
  804696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804699:	8b 40 04             	mov    0x4(%eax),%eax
  80469c:	a3 30 60 80 00       	mov    %eax,0x806030
  8046a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046a4:	8b 40 04             	mov    0x4(%eax),%eax
  8046a7:	85 c0                	test   %eax,%eax
  8046a9:	74 0f                	je     8046ba <realloc_block_FF+0x1fe>
  8046ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046ae:	8b 40 04             	mov    0x4(%eax),%eax
  8046b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8046b4:	8b 12                	mov    (%edx),%edx
  8046b6:	89 10                	mov    %edx,(%eax)
  8046b8:	eb 0a                	jmp    8046c4 <realloc_block_FF+0x208>
  8046ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046bd:	8b 00                	mov    (%eax),%eax
  8046bf:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8046c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8046cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8046d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8046d7:	a1 38 60 80 00       	mov    0x806038,%eax
  8046dc:	48                   	dec    %eax
  8046dd:	a3 38 60 80 00       	mov    %eax,0x806038
  8046e2:	e9 83 02 00 00       	jmp    80496a <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8046e7:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8046eb:	0f 86 69 02 00 00    	jbe    80495a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8046f1:	83 ec 04             	sub    $0x4,%esp
  8046f4:	6a 01                	push   $0x1
  8046f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8046f9:	ff 75 08             	pushl  0x8(%ebp)
  8046fc:	e8 c8 ed ff ff       	call   8034c9 <set_block_data>
  804701:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804704:	8b 45 08             	mov    0x8(%ebp),%eax
  804707:	83 e8 04             	sub    $0x4,%eax
  80470a:	8b 00                	mov    (%eax),%eax
  80470c:	83 e0 fe             	and    $0xfffffffe,%eax
  80470f:	89 c2                	mov    %eax,%edx
  804711:	8b 45 08             	mov    0x8(%ebp),%eax
  804714:	01 d0                	add    %edx,%eax
  804716:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  804719:	a1 38 60 80 00       	mov    0x806038,%eax
  80471e:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  804721:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804725:	75 68                	jne    80478f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804727:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80472b:	75 17                	jne    804744 <realloc_block_FF+0x288>
  80472d:	83 ec 04             	sub    $0x4,%esp
  804730:	68 0c 58 80 00       	push   $0x80580c
  804735:	68 06 02 00 00       	push   $0x206
  80473a:	68 f1 57 80 00       	push   $0x8057f1
  80473f:	e8 6f ce ff ff       	call   8015b3 <_panic>
  804744:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  80474a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80474d:	89 10                	mov    %edx,(%eax)
  80474f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804752:	8b 00                	mov    (%eax),%eax
  804754:	85 c0                	test   %eax,%eax
  804756:	74 0d                	je     804765 <realloc_block_FF+0x2a9>
  804758:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80475d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804760:	89 50 04             	mov    %edx,0x4(%eax)
  804763:	eb 08                	jmp    80476d <realloc_block_FF+0x2b1>
  804765:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804768:	a3 30 60 80 00       	mov    %eax,0x806030
  80476d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804770:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804775:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804778:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80477f:	a1 38 60 80 00       	mov    0x806038,%eax
  804784:	40                   	inc    %eax
  804785:	a3 38 60 80 00       	mov    %eax,0x806038
  80478a:	e9 b0 01 00 00       	jmp    80493f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80478f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804794:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804797:	76 68                	jbe    804801 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  804799:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80479d:	75 17                	jne    8047b6 <realloc_block_FF+0x2fa>
  80479f:	83 ec 04             	sub    $0x4,%esp
  8047a2:	68 0c 58 80 00       	push   $0x80580c
  8047a7:	68 0b 02 00 00       	push   $0x20b
  8047ac:	68 f1 57 80 00       	push   $0x8057f1
  8047b1:	e8 fd cd ff ff       	call   8015b3 <_panic>
  8047b6:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8047bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047bf:	89 10                	mov    %edx,(%eax)
  8047c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047c4:	8b 00                	mov    (%eax),%eax
  8047c6:	85 c0                	test   %eax,%eax
  8047c8:	74 0d                	je     8047d7 <realloc_block_FF+0x31b>
  8047ca:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8047cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8047d2:	89 50 04             	mov    %edx,0x4(%eax)
  8047d5:	eb 08                	jmp    8047df <realloc_block_FF+0x323>
  8047d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047da:	a3 30 60 80 00       	mov    %eax,0x806030
  8047df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047e2:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8047e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8047f1:	a1 38 60 80 00       	mov    0x806038,%eax
  8047f6:	40                   	inc    %eax
  8047f7:	a3 38 60 80 00       	mov    %eax,0x806038
  8047fc:	e9 3e 01 00 00       	jmp    80493f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804801:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804806:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804809:	73 68                	jae    804873 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80480b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80480f:	75 17                	jne    804828 <realloc_block_FF+0x36c>
  804811:	83 ec 04             	sub    $0x4,%esp
  804814:	68 40 58 80 00       	push   $0x805840
  804819:	68 10 02 00 00       	push   $0x210
  80481e:	68 f1 57 80 00       	push   $0x8057f1
  804823:	e8 8b cd ff ff       	call   8015b3 <_panic>
  804828:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80482e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804831:	89 50 04             	mov    %edx,0x4(%eax)
  804834:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804837:	8b 40 04             	mov    0x4(%eax),%eax
  80483a:	85 c0                	test   %eax,%eax
  80483c:	74 0c                	je     80484a <realloc_block_FF+0x38e>
  80483e:	a1 30 60 80 00       	mov    0x806030,%eax
  804843:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804846:	89 10                	mov    %edx,(%eax)
  804848:	eb 08                	jmp    804852 <realloc_block_FF+0x396>
  80484a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80484d:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804852:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804855:	a3 30 60 80 00       	mov    %eax,0x806030
  80485a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80485d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804863:	a1 38 60 80 00       	mov    0x806038,%eax
  804868:	40                   	inc    %eax
  804869:	a3 38 60 80 00       	mov    %eax,0x806038
  80486e:	e9 cc 00 00 00       	jmp    80493f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  804873:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80487a:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80487f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804882:	e9 8a 00 00 00       	jmp    804911 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  804887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80488a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80488d:	73 7a                	jae    804909 <realloc_block_FF+0x44d>
  80488f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804892:	8b 00                	mov    (%eax),%eax
  804894:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804897:	73 70                	jae    804909 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  804899:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80489d:	74 06                	je     8048a5 <realloc_block_FF+0x3e9>
  80489f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8048a3:	75 17                	jne    8048bc <realloc_block_FF+0x400>
  8048a5:	83 ec 04             	sub    $0x4,%esp
  8048a8:	68 64 58 80 00       	push   $0x805864
  8048ad:	68 1a 02 00 00       	push   $0x21a
  8048b2:	68 f1 57 80 00       	push   $0x8057f1
  8048b7:	e8 f7 cc ff ff       	call   8015b3 <_panic>
  8048bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048bf:	8b 10                	mov    (%eax),%edx
  8048c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048c4:	89 10                	mov    %edx,(%eax)
  8048c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048c9:	8b 00                	mov    (%eax),%eax
  8048cb:	85 c0                	test   %eax,%eax
  8048cd:	74 0b                	je     8048da <realloc_block_FF+0x41e>
  8048cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048d2:	8b 00                	mov    (%eax),%eax
  8048d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8048d7:	89 50 04             	mov    %edx,0x4(%eax)
  8048da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048dd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8048e0:	89 10                	mov    %edx,(%eax)
  8048e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8048e8:	89 50 04             	mov    %edx,0x4(%eax)
  8048eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048ee:	8b 00                	mov    (%eax),%eax
  8048f0:	85 c0                	test   %eax,%eax
  8048f2:	75 08                	jne    8048fc <realloc_block_FF+0x440>
  8048f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8048f7:	a3 30 60 80 00       	mov    %eax,0x806030
  8048fc:	a1 38 60 80 00       	mov    0x806038,%eax
  804901:	40                   	inc    %eax
  804902:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  804907:	eb 36                	jmp    80493f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  804909:	a1 34 60 80 00       	mov    0x806034,%eax
  80490e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804911:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804915:	74 07                	je     80491e <realloc_block_FF+0x462>
  804917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80491a:	8b 00                	mov    (%eax),%eax
  80491c:	eb 05                	jmp    804923 <realloc_block_FF+0x467>
  80491e:	b8 00 00 00 00       	mov    $0x0,%eax
  804923:	a3 34 60 80 00       	mov    %eax,0x806034
  804928:	a1 34 60 80 00       	mov    0x806034,%eax
  80492d:	85 c0                	test   %eax,%eax
  80492f:	0f 85 52 ff ff ff    	jne    804887 <realloc_block_FF+0x3cb>
  804935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804939:	0f 85 48 ff ff ff    	jne    804887 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80493f:	83 ec 04             	sub    $0x4,%esp
  804942:	6a 00                	push   $0x0
  804944:	ff 75 d8             	pushl  -0x28(%ebp)
  804947:	ff 75 d4             	pushl  -0x2c(%ebp)
  80494a:	e8 7a eb ff ff       	call   8034c9 <set_block_data>
  80494f:	83 c4 10             	add    $0x10,%esp
				return va;
  804952:	8b 45 08             	mov    0x8(%ebp),%eax
  804955:	e9 7b 02 00 00       	jmp    804bd5 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80495a:	83 ec 0c             	sub    $0xc,%esp
  80495d:	68 e1 58 80 00       	push   $0x8058e1
  804962:	e8 09 cf ff ff       	call   801870 <cprintf>
  804967:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80496a:	8b 45 08             	mov    0x8(%ebp),%eax
  80496d:	e9 63 02 00 00       	jmp    804bd5 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  804972:	8b 45 0c             	mov    0xc(%ebp),%eax
  804975:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804978:	0f 86 4d 02 00 00    	jbe    804bcb <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80497e:	83 ec 0c             	sub    $0xc,%esp
  804981:	ff 75 e4             	pushl  -0x1c(%ebp)
  804984:	e8 08 e8 ff ff       	call   803191 <is_free_block>
  804989:	83 c4 10             	add    $0x10,%esp
  80498c:	84 c0                	test   %al,%al
  80498e:	0f 84 37 02 00 00    	je     804bcb <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804994:	8b 45 0c             	mov    0xc(%ebp),%eax
  804997:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80499a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80499d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8049a0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8049a3:	76 38                	jbe    8049dd <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8049a5:	83 ec 0c             	sub    $0xc,%esp
  8049a8:	ff 75 08             	pushl  0x8(%ebp)
  8049ab:	e8 0c fa ff ff       	call   8043bc <free_block>
  8049b0:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8049b3:	83 ec 0c             	sub    $0xc,%esp
  8049b6:	ff 75 0c             	pushl  0xc(%ebp)
  8049b9:	e8 3a eb ff ff       	call   8034f8 <alloc_block_FF>
  8049be:	83 c4 10             	add    $0x10,%esp
  8049c1:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8049c4:	83 ec 08             	sub    $0x8,%esp
  8049c7:	ff 75 c0             	pushl  -0x40(%ebp)
  8049ca:	ff 75 08             	pushl  0x8(%ebp)
  8049cd:	e8 ab fa ff ff       	call   80447d <copy_data>
  8049d2:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8049d5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8049d8:	e9 f8 01 00 00       	jmp    804bd5 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8049dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8049e0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8049e3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8049e6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8049ea:	0f 87 a0 00 00 00    	ja     804a90 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8049f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8049f4:	75 17                	jne    804a0d <realloc_block_FF+0x551>
  8049f6:	83 ec 04             	sub    $0x4,%esp
  8049f9:	68 d3 57 80 00       	push   $0x8057d3
  8049fe:	68 38 02 00 00       	push   $0x238
  804a03:	68 f1 57 80 00       	push   $0x8057f1
  804a08:	e8 a6 cb ff ff       	call   8015b3 <_panic>
  804a0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a10:	8b 00                	mov    (%eax),%eax
  804a12:	85 c0                	test   %eax,%eax
  804a14:	74 10                	je     804a26 <realloc_block_FF+0x56a>
  804a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a19:	8b 00                	mov    (%eax),%eax
  804a1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804a1e:	8b 52 04             	mov    0x4(%edx),%edx
  804a21:	89 50 04             	mov    %edx,0x4(%eax)
  804a24:	eb 0b                	jmp    804a31 <realloc_block_FF+0x575>
  804a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a29:	8b 40 04             	mov    0x4(%eax),%eax
  804a2c:	a3 30 60 80 00       	mov    %eax,0x806030
  804a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a34:	8b 40 04             	mov    0x4(%eax),%eax
  804a37:	85 c0                	test   %eax,%eax
  804a39:	74 0f                	je     804a4a <realloc_block_FF+0x58e>
  804a3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a3e:	8b 40 04             	mov    0x4(%eax),%eax
  804a41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804a44:	8b 12                	mov    (%edx),%edx
  804a46:	89 10                	mov    %edx,(%eax)
  804a48:	eb 0a                	jmp    804a54 <realloc_block_FF+0x598>
  804a4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a4d:	8b 00                	mov    (%eax),%eax
  804a4f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804a54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804a67:	a1 38 60 80 00       	mov    0x806038,%eax
  804a6c:	48                   	dec    %eax
  804a6d:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  804a72:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804a75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804a78:	01 d0                	add    %edx,%eax
  804a7a:	83 ec 04             	sub    $0x4,%esp
  804a7d:	6a 01                	push   $0x1
  804a7f:	50                   	push   %eax
  804a80:	ff 75 08             	pushl  0x8(%ebp)
  804a83:	e8 41 ea ff ff       	call   8034c9 <set_block_data>
  804a88:	83 c4 10             	add    $0x10,%esp
  804a8b:	e9 36 01 00 00       	jmp    804bc6 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804a90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804a93:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804a96:	01 d0                	add    %edx,%eax
  804a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804a9b:	83 ec 04             	sub    $0x4,%esp
  804a9e:	6a 01                	push   $0x1
  804aa0:	ff 75 f0             	pushl  -0x10(%ebp)
  804aa3:	ff 75 08             	pushl  0x8(%ebp)
  804aa6:	e8 1e ea ff ff       	call   8034c9 <set_block_data>
  804aab:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804aae:	8b 45 08             	mov    0x8(%ebp),%eax
  804ab1:	83 e8 04             	sub    $0x4,%eax
  804ab4:	8b 00                	mov    (%eax),%eax
  804ab6:	83 e0 fe             	and    $0xfffffffe,%eax
  804ab9:	89 c2                	mov    %eax,%edx
  804abb:	8b 45 08             	mov    0x8(%ebp),%eax
  804abe:	01 d0                	add    %edx,%eax
  804ac0:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804ac3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804ac7:	74 06                	je     804acf <realloc_block_FF+0x613>
  804ac9:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804acd:	75 17                	jne    804ae6 <realloc_block_FF+0x62a>
  804acf:	83 ec 04             	sub    $0x4,%esp
  804ad2:	68 64 58 80 00       	push   $0x805864
  804ad7:	68 44 02 00 00       	push   $0x244
  804adc:	68 f1 57 80 00       	push   $0x8057f1
  804ae1:	e8 cd ca ff ff       	call   8015b3 <_panic>
  804ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ae9:	8b 10                	mov    (%eax),%edx
  804aeb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804aee:	89 10                	mov    %edx,(%eax)
  804af0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804af3:	8b 00                	mov    (%eax),%eax
  804af5:	85 c0                	test   %eax,%eax
  804af7:	74 0b                	je     804b04 <realloc_block_FF+0x648>
  804af9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804afc:	8b 00                	mov    (%eax),%eax
  804afe:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804b01:	89 50 04             	mov    %edx,0x4(%eax)
  804b04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b07:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804b0a:	89 10                	mov    %edx,(%eax)
  804b0c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804b0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b12:	89 50 04             	mov    %edx,0x4(%eax)
  804b15:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804b18:	8b 00                	mov    (%eax),%eax
  804b1a:	85 c0                	test   %eax,%eax
  804b1c:	75 08                	jne    804b26 <realloc_block_FF+0x66a>
  804b1e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804b21:	a3 30 60 80 00       	mov    %eax,0x806030
  804b26:	a1 38 60 80 00       	mov    0x806038,%eax
  804b2b:	40                   	inc    %eax
  804b2c:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804b31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804b35:	75 17                	jne    804b4e <realloc_block_FF+0x692>
  804b37:	83 ec 04             	sub    $0x4,%esp
  804b3a:	68 d3 57 80 00       	push   $0x8057d3
  804b3f:	68 45 02 00 00       	push   $0x245
  804b44:	68 f1 57 80 00       	push   $0x8057f1
  804b49:	e8 65 ca ff ff       	call   8015b3 <_panic>
  804b4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b51:	8b 00                	mov    (%eax),%eax
  804b53:	85 c0                	test   %eax,%eax
  804b55:	74 10                	je     804b67 <realloc_block_FF+0x6ab>
  804b57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b5a:	8b 00                	mov    (%eax),%eax
  804b5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b5f:	8b 52 04             	mov    0x4(%edx),%edx
  804b62:	89 50 04             	mov    %edx,0x4(%eax)
  804b65:	eb 0b                	jmp    804b72 <realloc_block_FF+0x6b6>
  804b67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b6a:	8b 40 04             	mov    0x4(%eax),%eax
  804b6d:	a3 30 60 80 00       	mov    %eax,0x806030
  804b72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b75:	8b 40 04             	mov    0x4(%eax),%eax
  804b78:	85 c0                	test   %eax,%eax
  804b7a:	74 0f                	je     804b8b <realloc_block_FF+0x6cf>
  804b7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b7f:	8b 40 04             	mov    0x4(%eax),%eax
  804b82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b85:	8b 12                	mov    (%edx),%edx
  804b87:	89 10                	mov    %edx,(%eax)
  804b89:	eb 0a                	jmp    804b95 <realloc_block_FF+0x6d9>
  804b8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b8e:	8b 00                	mov    (%eax),%eax
  804b90:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804b95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804b9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ba1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804ba8:	a1 38 60 80 00       	mov    0x806038,%eax
  804bad:	48                   	dec    %eax
  804bae:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804bb3:	83 ec 04             	sub    $0x4,%esp
  804bb6:	6a 00                	push   $0x0
  804bb8:	ff 75 bc             	pushl  -0x44(%ebp)
  804bbb:	ff 75 b8             	pushl  -0x48(%ebp)
  804bbe:	e8 06 e9 ff ff       	call   8034c9 <set_block_data>
  804bc3:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  804bc9:	eb 0a                	jmp    804bd5 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804bcb:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804bd2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804bd5:	c9                   	leave  
  804bd6:	c3                   	ret    

00804bd7 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804bd7:	55                   	push   %ebp
  804bd8:	89 e5                	mov    %esp,%ebp
  804bda:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804bdd:	83 ec 04             	sub    $0x4,%esp
  804be0:	68 e8 58 80 00       	push   $0x8058e8
  804be5:	68 58 02 00 00       	push   $0x258
  804bea:	68 f1 57 80 00       	push   $0x8057f1
  804bef:	e8 bf c9 ff ff       	call   8015b3 <_panic>

00804bf4 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804bf4:	55                   	push   %ebp
  804bf5:	89 e5                	mov    %esp,%ebp
  804bf7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804bfa:	83 ec 04             	sub    $0x4,%esp
  804bfd:	68 10 59 80 00       	push   $0x805910
  804c02:	68 61 02 00 00       	push   $0x261
  804c07:	68 f1 57 80 00       	push   $0x8057f1
  804c0c:	e8 a2 c9 ff ff       	call   8015b3 <_panic>
  804c11:	66 90                	xchg   %ax,%ax
  804c13:	90                   	nop

00804c14 <__udivdi3>:
  804c14:	55                   	push   %ebp
  804c15:	57                   	push   %edi
  804c16:	56                   	push   %esi
  804c17:	53                   	push   %ebx
  804c18:	83 ec 1c             	sub    $0x1c,%esp
  804c1b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804c1f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804c23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804c27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804c2b:	89 ca                	mov    %ecx,%edx
  804c2d:	89 f8                	mov    %edi,%eax
  804c2f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804c33:	85 f6                	test   %esi,%esi
  804c35:	75 2d                	jne    804c64 <__udivdi3+0x50>
  804c37:	39 cf                	cmp    %ecx,%edi
  804c39:	77 65                	ja     804ca0 <__udivdi3+0x8c>
  804c3b:	89 fd                	mov    %edi,%ebp
  804c3d:	85 ff                	test   %edi,%edi
  804c3f:	75 0b                	jne    804c4c <__udivdi3+0x38>
  804c41:	b8 01 00 00 00       	mov    $0x1,%eax
  804c46:	31 d2                	xor    %edx,%edx
  804c48:	f7 f7                	div    %edi
  804c4a:	89 c5                	mov    %eax,%ebp
  804c4c:	31 d2                	xor    %edx,%edx
  804c4e:	89 c8                	mov    %ecx,%eax
  804c50:	f7 f5                	div    %ebp
  804c52:	89 c1                	mov    %eax,%ecx
  804c54:	89 d8                	mov    %ebx,%eax
  804c56:	f7 f5                	div    %ebp
  804c58:	89 cf                	mov    %ecx,%edi
  804c5a:	89 fa                	mov    %edi,%edx
  804c5c:	83 c4 1c             	add    $0x1c,%esp
  804c5f:	5b                   	pop    %ebx
  804c60:	5e                   	pop    %esi
  804c61:	5f                   	pop    %edi
  804c62:	5d                   	pop    %ebp
  804c63:	c3                   	ret    
  804c64:	39 ce                	cmp    %ecx,%esi
  804c66:	77 28                	ja     804c90 <__udivdi3+0x7c>
  804c68:	0f bd fe             	bsr    %esi,%edi
  804c6b:	83 f7 1f             	xor    $0x1f,%edi
  804c6e:	75 40                	jne    804cb0 <__udivdi3+0x9c>
  804c70:	39 ce                	cmp    %ecx,%esi
  804c72:	72 0a                	jb     804c7e <__udivdi3+0x6a>
  804c74:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804c78:	0f 87 9e 00 00 00    	ja     804d1c <__udivdi3+0x108>
  804c7e:	b8 01 00 00 00       	mov    $0x1,%eax
  804c83:	89 fa                	mov    %edi,%edx
  804c85:	83 c4 1c             	add    $0x1c,%esp
  804c88:	5b                   	pop    %ebx
  804c89:	5e                   	pop    %esi
  804c8a:	5f                   	pop    %edi
  804c8b:	5d                   	pop    %ebp
  804c8c:	c3                   	ret    
  804c8d:	8d 76 00             	lea    0x0(%esi),%esi
  804c90:	31 ff                	xor    %edi,%edi
  804c92:	31 c0                	xor    %eax,%eax
  804c94:	89 fa                	mov    %edi,%edx
  804c96:	83 c4 1c             	add    $0x1c,%esp
  804c99:	5b                   	pop    %ebx
  804c9a:	5e                   	pop    %esi
  804c9b:	5f                   	pop    %edi
  804c9c:	5d                   	pop    %ebp
  804c9d:	c3                   	ret    
  804c9e:	66 90                	xchg   %ax,%ax
  804ca0:	89 d8                	mov    %ebx,%eax
  804ca2:	f7 f7                	div    %edi
  804ca4:	31 ff                	xor    %edi,%edi
  804ca6:	89 fa                	mov    %edi,%edx
  804ca8:	83 c4 1c             	add    $0x1c,%esp
  804cab:	5b                   	pop    %ebx
  804cac:	5e                   	pop    %esi
  804cad:	5f                   	pop    %edi
  804cae:	5d                   	pop    %ebp
  804caf:	c3                   	ret    
  804cb0:	bd 20 00 00 00       	mov    $0x20,%ebp
  804cb5:	89 eb                	mov    %ebp,%ebx
  804cb7:	29 fb                	sub    %edi,%ebx
  804cb9:	89 f9                	mov    %edi,%ecx
  804cbb:	d3 e6                	shl    %cl,%esi
  804cbd:	89 c5                	mov    %eax,%ebp
  804cbf:	88 d9                	mov    %bl,%cl
  804cc1:	d3 ed                	shr    %cl,%ebp
  804cc3:	89 e9                	mov    %ebp,%ecx
  804cc5:	09 f1                	or     %esi,%ecx
  804cc7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804ccb:	89 f9                	mov    %edi,%ecx
  804ccd:	d3 e0                	shl    %cl,%eax
  804ccf:	89 c5                	mov    %eax,%ebp
  804cd1:	89 d6                	mov    %edx,%esi
  804cd3:	88 d9                	mov    %bl,%cl
  804cd5:	d3 ee                	shr    %cl,%esi
  804cd7:	89 f9                	mov    %edi,%ecx
  804cd9:	d3 e2                	shl    %cl,%edx
  804cdb:	8b 44 24 08          	mov    0x8(%esp),%eax
  804cdf:	88 d9                	mov    %bl,%cl
  804ce1:	d3 e8                	shr    %cl,%eax
  804ce3:	09 c2                	or     %eax,%edx
  804ce5:	89 d0                	mov    %edx,%eax
  804ce7:	89 f2                	mov    %esi,%edx
  804ce9:	f7 74 24 0c          	divl   0xc(%esp)
  804ced:	89 d6                	mov    %edx,%esi
  804cef:	89 c3                	mov    %eax,%ebx
  804cf1:	f7 e5                	mul    %ebp
  804cf3:	39 d6                	cmp    %edx,%esi
  804cf5:	72 19                	jb     804d10 <__udivdi3+0xfc>
  804cf7:	74 0b                	je     804d04 <__udivdi3+0xf0>
  804cf9:	89 d8                	mov    %ebx,%eax
  804cfb:	31 ff                	xor    %edi,%edi
  804cfd:	e9 58 ff ff ff       	jmp    804c5a <__udivdi3+0x46>
  804d02:	66 90                	xchg   %ax,%ax
  804d04:	8b 54 24 08          	mov    0x8(%esp),%edx
  804d08:	89 f9                	mov    %edi,%ecx
  804d0a:	d3 e2                	shl    %cl,%edx
  804d0c:	39 c2                	cmp    %eax,%edx
  804d0e:	73 e9                	jae    804cf9 <__udivdi3+0xe5>
  804d10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804d13:	31 ff                	xor    %edi,%edi
  804d15:	e9 40 ff ff ff       	jmp    804c5a <__udivdi3+0x46>
  804d1a:	66 90                	xchg   %ax,%ax
  804d1c:	31 c0                	xor    %eax,%eax
  804d1e:	e9 37 ff ff ff       	jmp    804c5a <__udivdi3+0x46>
  804d23:	90                   	nop

00804d24 <__umoddi3>:
  804d24:	55                   	push   %ebp
  804d25:	57                   	push   %edi
  804d26:	56                   	push   %esi
  804d27:	53                   	push   %ebx
  804d28:	83 ec 1c             	sub    $0x1c,%esp
  804d2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804d2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804d33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804d37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804d3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804d3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804d43:	89 f3                	mov    %esi,%ebx
  804d45:	89 fa                	mov    %edi,%edx
  804d47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804d4b:	89 34 24             	mov    %esi,(%esp)
  804d4e:	85 c0                	test   %eax,%eax
  804d50:	75 1a                	jne    804d6c <__umoddi3+0x48>
  804d52:	39 f7                	cmp    %esi,%edi
  804d54:	0f 86 a2 00 00 00    	jbe    804dfc <__umoddi3+0xd8>
  804d5a:	89 c8                	mov    %ecx,%eax
  804d5c:	89 f2                	mov    %esi,%edx
  804d5e:	f7 f7                	div    %edi
  804d60:	89 d0                	mov    %edx,%eax
  804d62:	31 d2                	xor    %edx,%edx
  804d64:	83 c4 1c             	add    $0x1c,%esp
  804d67:	5b                   	pop    %ebx
  804d68:	5e                   	pop    %esi
  804d69:	5f                   	pop    %edi
  804d6a:	5d                   	pop    %ebp
  804d6b:	c3                   	ret    
  804d6c:	39 f0                	cmp    %esi,%eax
  804d6e:	0f 87 ac 00 00 00    	ja     804e20 <__umoddi3+0xfc>
  804d74:	0f bd e8             	bsr    %eax,%ebp
  804d77:	83 f5 1f             	xor    $0x1f,%ebp
  804d7a:	0f 84 ac 00 00 00    	je     804e2c <__umoddi3+0x108>
  804d80:	bf 20 00 00 00       	mov    $0x20,%edi
  804d85:	29 ef                	sub    %ebp,%edi
  804d87:	89 fe                	mov    %edi,%esi
  804d89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804d8d:	89 e9                	mov    %ebp,%ecx
  804d8f:	d3 e0                	shl    %cl,%eax
  804d91:	89 d7                	mov    %edx,%edi
  804d93:	89 f1                	mov    %esi,%ecx
  804d95:	d3 ef                	shr    %cl,%edi
  804d97:	09 c7                	or     %eax,%edi
  804d99:	89 e9                	mov    %ebp,%ecx
  804d9b:	d3 e2                	shl    %cl,%edx
  804d9d:	89 14 24             	mov    %edx,(%esp)
  804da0:	89 d8                	mov    %ebx,%eax
  804da2:	d3 e0                	shl    %cl,%eax
  804da4:	89 c2                	mov    %eax,%edx
  804da6:	8b 44 24 08          	mov    0x8(%esp),%eax
  804daa:	d3 e0                	shl    %cl,%eax
  804dac:	89 44 24 04          	mov    %eax,0x4(%esp)
  804db0:	8b 44 24 08          	mov    0x8(%esp),%eax
  804db4:	89 f1                	mov    %esi,%ecx
  804db6:	d3 e8                	shr    %cl,%eax
  804db8:	09 d0                	or     %edx,%eax
  804dba:	d3 eb                	shr    %cl,%ebx
  804dbc:	89 da                	mov    %ebx,%edx
  804dbe:	f7 f7                	div    %edi
  804dc0:	89 d3                	mov    %edx,%ebx
  804dc2:	f7 24 24             	mull   (%esp)
  804dc5:	89 c6                	mov    %eax,%esi
  804dc7:	89 d1                	mov    %edx,%ecx
  804dc9:	39 d3                	cmp    %edx,%ebx
  804dcb:	0f 82 87 00 00 00    	jb     804e58 <__umoddi3+0x134>
  804dd1:	0f 84 91 00 00 00    	je     804e68 <__umoddi3+0x144>
  804dd7:	8b 54 24 04          	mov    0x4(%esp),%edx
  804ddb:	29 f2                	sub    %esi,%edx
  804ddd:	19 cb                	sbb    %ecx,%ebx
  804ddf:	89 d8                	mov    %ebx,%eax
  804de1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804de5:	d3 e0                	shl    %cl,%eax
  804de7:	89 e9                	mov    %ebp,%ecx
  804de9:	d3 ea                	shr    %cl,%edx
  804deb:	09 d0                	or     %edx,%eax
  804ded:	89 e9                	mov    %ebp,%ecx
  804def:	d3 eb                	shr    %cl,%ebx
  804df1:	89 da                	mov    %ebx,%edx
  804df3:	83 c4 1c             	add    $0x1c,%esp
  804df6:	5b                   	pop    %ebx
  804df7:	5e                   	pop    %esi
  804df8:	5f                   	pop    %edi
  804df9:	5d                   	pop    %ebp
  804dfa:	c3                   	ret    
  804dfb:	90                   	nop
  804dfc:	89 fd                	mov    %edi,%ebp
  804dfe:	85 ff                	test   %edi,%edi
  804e00:	75 0b                	jne    804e0d <__umoddi3+0xe9>
  804e02:	b8 01 00 00 00       	mov    $0x1,%eax
  804e07:	31 d2                	xor    %edx,%edx
  804e09:	f7 f7                	div    %edi
  804e0b:	89 c5                	mov    %eax,%ebp
  804e0d:	89 f0                	mov    %esi,%eax
  804e0f:	31 d2                	xor    %edx,%edx
  804e11:	f7 f5                	div    %ebp
  804e13:	89 c8                	mov    %ecx,%eax
  804e15:	f7 f5                	div    %ebp
  804e17:	89 d0                	mov    %edx,%eax
  804e19:	e9 44 ff ff ff       	jmp    804d62 <__umoddi3+0x3e>
  804e1e:	66 90                	xchg   %ax,%ax
  804e20:	89 c8                	mov    %ecx,%eax
  804e22:	89 f2                	mov    %esi,%edx
  804e24:	83 c4 1c             	add    $0x1c,%esp
  804e27:	5b                   	pop    %ebx
  804e28:	5e                   	pop    %esi
  804e29:	5f                   	pop    %edi
  804e2a:	5d                   	pop    %ebp
  804e2b:	c3                   	ret    
  804e2c:	3b 04 24             	cmp    (%esp),%eax
  804e2f:	72 06                	jb     804e37 <__umoddi3+0x113>
  804e31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804e35:	77 0f                	ja     804e46 <__umoddi3+0x122>
  804e37:	89 f2                	mov    %esi,%edx
  804e39:	29 f9                	sub    %edi,%ecx
  804e3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804e3f:	89 14 24             	mov    %edx,(%esp)
  804e42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804e46:	8b 44 24 04          	mov    0x4(%esp),%eax
  804e4a:	8b 14 24             	mov    (%esp),%edx
  804e4d:	83 c4 1c             	add    $0x1c,%esp
  804e50:	5b                   	pop    %ebx
  804e51:	5e                   	pop    %esi
  804e52:	5f                   	pop    %edi
  804e53:	5d                   	pop    %ebp
  804e54:	c3                   	ret    
  804e55:	8d 76 00             	lea    0x0(%esi),%esi
  804e58:	2b 04 24             	sub    (%esp),%eax
  804e5b:	19 fa                	sbb    %edi,%edx
  804e5d:	89 d1                	mov    %edx,%ecx
  804e5f:	89 c6                	mov    %eax,%esi
  804e61:	e9 71 ff ff ff       	jmp    804dd7 <__umoddi3+0xb3>
  804e66:	66 90                	xchg   %ax,%ax
  804e68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804e6c:	72 ea                	jb     804e58 <__umoddi3+0x134>
  804e6e:	89 d9                	mov    %ebx,%ecx
  804e70:	e9 62 ff ff ff       	jmp    804dd7 <__umoddi3+0xb3>
