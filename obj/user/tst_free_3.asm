
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
  800079:	e8 b0 25 00 00       	call   80262e <malloc>
  80007e:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800081:	a1 04 40 80 00       	mov    0x804004,%eax
  800086:	8b 80 38 da 01 00    	mov    0x1da38(%eax),%eax
  80008c:	8b 00                	mov    (%eax),%eax
  80008e:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800091:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800099:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80009e:	74 14                	je     8000b4 <_main+0x7c>
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 e0 2f 80 00       	push   $0x802fe0
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 21 30 80 00       	push   $0x803021
  8000af:	e8 0d 15 00 00       	call   8015c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000b4:	a1 04 40 80 00       	mov    0x804004,%eax
  8000b9:	8b 80 38 da 01 00    	mov    0x1da38(%eax),%eax
  8000bf:	83 c0 18             	add    $0x18,%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8000c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8000ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000cf:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 e0 2f 80 00       	push   $0x802fe0
  8000de:	6a 21                	push   $0x21
  8000e0:	68 21 30 80 00       	push   $0x803021
  8000e5:	e8 d7 14 00 00       	call   8015c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8000ef:	8b 80 38 da 01 00    	mov    0x1da38(%eax),%eax
  8000f5:	83 c0 30             	add    $0x30,%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000fd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800105:	3d 00 20 20 00       	cmp    $0x202000,%eax
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 e0 2f 80 00       	push   $0x802fe0
  800114:	6a 22                	push   $0x22
  800116:	68 21 30 80 00       	push   $0x803021
  80011b:	e8 a1 14 00 00       	call   8015c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800120:	a1 04 40 80 00       	mov    0x804004,%eax
  800125:	8b 80 38 da 01 00    	mov    0x1da38(%eax),%eax
  80012b:	83 c0 48             	add    $0x48,%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800133:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800136:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80013b:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 e0 2f 80 00       	push   $0x802fe0
  80014a:	6a 23                	push   $0x23
  80014c:	68 21 30 80 00       	push   $0x803021
  800151:	e8 6b 14 00 00       	call   8015c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800156:	a1 04 40 80 00       	mov    0x804004,%eax
  80015b:	8b 80 38 da 01 00    	mov    0x1da38(%eax),%eax
  800161:	83 c0 60             	add    $0x60,%eax
  800164:	8b 00                	mov    (%eax),%eax
  800166:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800169:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80016c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800171:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800176:	74 14                	je     80018c <_main+0x154>
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	68 e0 2f 80 00       	push   $0x802fe0
  800180:	6a 24                	push   $0x24
  800182:	68 21 30 80 00       	push   $0x803021
  800187:	e8 35 14 00 00       	call   8015c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80018c:	a1 04 40 80 00       	mov    0x804004,%eax
  800191:	8b 80 38 da 01 00    	mov    0x1da38(%eax),%eax
  800197:	83 c0 78             	add    $0x78,%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80019f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a7:	3d 00 50 20 00       	cmp    $0x205000,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 e0 2f 80 00       	push   $0x802fe0
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 21 30 80 00       	push   $0x803021
  8001bd:	e8 ff 13 00 00       	call   8015c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001c2:	a1 04 40 80 00       	mov    0x804004,%eax
  8001c7:	8b 80 38 da 01 00    	mov    0x1da38(%eax),%eax
  8001cd:	05 90 00 00 00       	add    $0x90,%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8001d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001df:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001e4:	74 14                	je     8001fa <_main+0x1c2>
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	68 e0 2f 80 00       	push   $0x802fe0
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 21 30 80 00       	push   $0x803021
  8001f5:	e8 c7 13 00 00       	call   8015c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8001ff:	8b 80 38 da 01 00    	mov    0x1da38(%eax),%eax
  800205:	05 a8 00 00 00       	add    $0xa8,%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80020f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800212:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800217:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80021c:	74 14                	je     800232 <_main+0x1fa>
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 e0 2f 80 00       	push   $0x802fe0
  800226:	6a 27                	push   $0x27
  800228:	68 21 30 80 00       	push   $0x803021
  80022d:	e8 8f 13 00 00       	call   8015c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800232:	a1 04 40 80 00       	mov    0x804004,%eax
  800237:	8b 80 38 da 01 00    	mov    0x1da38(%eax),%eax
  80023d:	05 c0 00 00 00       	add    $0xc0,%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800247:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80024a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 e0 2f 80 00       	push   $0x802fe0
  80025e:	6a 28                	push   $0x28
  800260:	68 21 30 80 00       	push   $0x803021
  800265:	e8 57 13 00 00       	call   8015c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026a:	a1 04 40 80 00       	mov    0x804004,%eax
  80026f:	8b 80 38 da 01 00    	mov    0x1da38(%eax),%eax
  800275:	05 d8 00 00 00       	add    $0xd8,%eax
  80027a:	8b 00                	mov    (%eax),%eax
  80027c:	89 45 98             	mov    %eax,-0x68(%ebp)
  80027f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800282:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800287:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 e0 2f 80 00       	push   $0x802fe0
  800296:	6a 29                	push   $0x29
  800298:	68 21 30 80 00       	push   $0x803021
  80029d:	e8 1f 13 00 00       	call   8015c1 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 04 40 80 00       	mov    0x804004,%eax
  8002a7:	8b 80 58 d5 01 00    	mov    0x1d558(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 34 30 80 00       	push   $0x803034
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 21 30 80 00       	push   $0x803021
  8002c0:	e8 fc 12 00 00       	call   8015c1 <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 98 25 00 00       	call   802862 <sys_calculate_free_frames>
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
  8002e1:	e8 c7 25 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
  8002e6:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8002e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	50                   	push   %eax
  8002f5:	e8 34 23 00 00       	call   80262e <malloc>
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
  80031d:	68 7c 30 80 00       	push   $0x80307c
  800322:	6a 39                	push   $0x39
  800324:	68 21 30 80 00       	push   $0x803021
  800329:	e8 93 12 00 00       	call   8015c1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 7a 25 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 e4 30 80 00       	push   $0x8030e4
  800345:	6a 3a                	push   $0x3a
  800347:	68 21 30 80 00       	push   $0x803021
  80034c:	e8 70 12 00 00       	call   8015c1 <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 57 25 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
  800356:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035c:	89 c2                	mov    %eax,%edx
  80035e:	01 d2                	add    %edx,%edx
  800360:	01 d0                	add    %edx,%eax
  800362:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	50                   	push   %eax
  800369:	e8 c0 22 00 00       	call   80262e <malloc>
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
  8003a6:	68 7c 30 80 00       	push   $0x80307c
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 21 30 80 00       	push   $0x803021
  8003b2:	e8 0a 12 00 00       	call   8015c1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 f1 24 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
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
  8003dd:	68 e4 30 80 00       	push   $0x8030e4
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 21 30 80 00       	push   $0x803021
  8003e9:	e8 d3 11 00 00       	call   8015c1 <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 ba 24 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
  8003f3:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(8*Mega-kilo);
  8003f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f9:	c1 e0 03             	shl    $0x3,%eax
  8003fc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8003ff:	83 ec 0c             	sub    $0xc,%esp
  800402:	50                   	push   %eax
  800403:	e8 26 22 00 00       	call   80262e <malloc>
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
  80044a:	68 7c 30 80 00       	push   $0x80307c
  80044f:	6a 47                	push   $0x47
  800451:	68 21 30 80 00       	push   $0x803021
  800456:	e8 66 11 00 00       	call   8015c1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 4d 24 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
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
  80047e:	68 e4 30 80 00       	push   $0x8030e4
  800483:	6a 48                	push   $0x48
  800485:	68 21 30 80 00       	push   $0x803021
  80048a:	e8 32 11 00 00       	call   8015c1 <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 19 24 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
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
  8004ab:	e8 7e 21 00 00       	call   80262e <malloc>
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
  8004fa:	68 7c 30 80 00       	push   $0x80307c
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 21 30 80 00       	push   $0x803021
  800506:	e8 b6 10 00 00       	call   8015c1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 9d 23 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
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
  800535:	68 e4 30 80 00       	push   $0x8030e4
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 21 30 80 00       	push   $0x803021
  800541:	e8 7b 10 00 00       	call   8015c1 <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 17 23 00 00       	call   802862 <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 28 23 00 00       	call   80287b <sys_calculate_modified_frames>
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
  80060f:	e8 4e 22 00 00       	call   802862 <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 60 22 00 00       	call   80287b <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 14 31 80 00       	push   $0x803114
  80062e:	6a 67                	push   $0x67
  800630:	68 21 30 80 00       	push   $0x803021
  800635:	e8 87 0f 00 00       	call   8015c1 <_panic>
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
  800653:	a1 04 40 80 00       	mov    0x804004,%eax
  800658:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  8006b0:	a1 04 40 80 00       	mov    0x804004,%eax
  8006b5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  8006d8:	68 58 31 80 00       	push   $0x803158
  8006dd:	6a 73                	push   $0x73
  8006df:	68 21 30 80 00       	push   $0x803021
  8006e4:	e8 d8 0e 00 00       	call   8015c1 <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e9:	e8 74 21 00 00       	call   802862 <sys_calculate_free_frames>
  8006ee:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006f1:	e8 85 21 00 00       	call   80287b <sys_calculate_modified_frames>
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
  8007f2:	e8 6b 20 00 00       	call   802862 <sys_calculate_free_frames>
  8007f7:	29 c3                	sub    %eax,%ebx
  8007f9:	89 d8                	mov    %ebx,%eax
  8007fb:	83 f8 04             	cmp    $0x4,%eax
  8007fe:	74 17                	je     800817 <_main+0x7df>
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	68 14 31 80 00       	push   $0x803114
  800808:	68 8e 00 00 00       	push   $0x8e
  80080d:	68 21 30 80 00       	push   $0x803021
  800812:	e8 aa 0d 00 00       	call   8015c1 <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800817:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  80081a:	e8 5c 20 00 00       	call   80287b <sys_calculate_modified_frames>
  80081f:	29 c3                	sub    %eax,%ebx
  800821:	89 d8                	mov    %ebx,%eax
  800823:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800826:	74 17                	je     80083f <_main+0x807>
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 14 31 80 00       	push   $0x803114
  800830:	68 8f 00 00 00       	push   $0x8f
  800835:	68 21 30 80 00       	push   $0x803021
  80083a:	e8 82 0d 00 00       	call   8015c1 <_panic>
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
  800858:	a1 04 40 80 00       	mov    0x804004,%eax
  80085d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  8008b7:	a1 04 40 80 00       	mov    0x804004,%eax
  8008bc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  8008df:	68 58 31 80 00       	push   $0x803158
  8008e4:	68 9b 00 00 00       	push   $0x9b
  8008e9:	68 21 30 80 00       	push   $0x803021
  8008ee:	e8 ce 0c 00 00       	call   8015c1 <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008f3:	e8 6a 1f 00 00       	call   802862 <sys_calculate_free_frames>
  8008f8:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008fb:	e8 7b 1f 00 00       	call   80287b <sys_calculate_modified_frames>
  800900:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800903:	e8 a5 1f 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
  800908:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  80090b:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800911:	83 ec 0c             	sub    $0xc,%esp
  800914:	50                   	push   %eax
  800915:	e8 3d 1d 00 00       	call   802657 <free>
  80091a:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80091d:	e8 8b 1f 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
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
  800945:	68 78 31 80 00       	push   $0x803178
  80094a:	68 a5 00 00 00       	push   $0xa5
  80094f:	68 21 30 80 00       	push   $0x803021
  800954:	e8 68 0c 00 00       	call   8015c1 <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  800959:	e8 04 1f 00 00       	call   802862 <sys_calculate_free_frames>
  80095e:	89 c2                	mov    %eax,%edx
  800960:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800963:	29 c2                	sub    %eax,%edx
  800965:	89 d0                	mov    %edx,%eax
  800967:	83 f8 07             	cmp    $0x7,%eax
  80096a:	74 17                	je     800983 <_main+0x94b>
  80096c:	83 ec 04             	sub    $0x4,%esp
  80096f:	68 b4 31 80 00       	push   $0x8031b4
  800974:	68 a7 00 00 00       	push   $0xa7
  800979:	68 21 30 80 00       	push   $0x803021
  80097e:	e8 3e 0c 00 00       	call   8015c1 <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800983:	e8 f3 1e 00 00       	call   80287b <sys_calculate_modified_frames>
  800988:	89 c2                	mov    %eax,%edx
  80098a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80098d:	29 c2                	sub    %eax,%edx
  80098f:	89 d0                	mov    %edx,%eax
  800991:	83 f8 02             	cmp    $0x2,%eax
  800994:	74 17                	je     8009ad <_main+0x975>
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	68 08 32 80 00       	push   $0x803208
  80099e:	68 a8 00 00 00       	push   $0xa8
  8009a3:	68 21 30 80 00       	push   $0x803021
  8009a8:	e8 14 0c 00 00       	call   8015c1 <_panic>
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
  8009c2:	a1 04 40 80 00       	mov    0x804004,%eax
  8009c7:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800a1c:	68 40 32 80 00       	push   $0x803240
  800a21:	68 b0 00 00 00       	push   $0xb0
  800a26:	68 21 30 80 00       	push   $0x803021
  800a2b:	e8 91 0b 00 00       	call   8015c1 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800a30:	ff 45 e0             	incl   -0x20(%ebp)
  800a33:	a1 04 40 80 00       	mov    0x804004,%eax
  800a38:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  800a56:	e8 07 1e 00 00       	call   802862 <sys_calculate_free_frames>
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
  800aa3:	e8 ba 1d 00 00       	call   802862 <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 02             	cmp    $0x2,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 14 31 80 00       	push   $0x803114
  800ab9:	68 bc 00 00 00       	push   $0xbc
  800abe:	68 21 30 80 00       	push   $0x803021
  800ac3:	e8 f9 0a 00 00       	call   8015c1 <_panic>
		found = 0;
  800ac8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800acf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ad6:	e9 a7 00 00 00       	jmp    800b82 <_main+0xb4a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800adb:	a1 04 40 80 00       	mov    0x804004,%eax
  800ae0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800b27:	a1 04 40 80 00       	mov    0x804004,%eax
  800b2c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800b82:	a1 04 40 80 00       	mov    0x804004,%eax
  800b87:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  800ba1:	68 58 31 80 00       	push   $0x803158
  800ba6:	68 c5 00 00 00       	push   $0xc5
  800bab:	68 21 30 80 00       	push   $0x803021
  800bb0:	e8 0c 0a 00 00       	call   8015c1 <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bb5:	e8 f3 1c 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
  800bba:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800bbd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc0:	01 c0                	add    %eax,%eax
  800bc2:	83 ec 0c             	sub    $0xc,%esp
  800bc5:	50                   	push   %eax
  800bc6:	e8 63 1a 00 00       	call   80262e <malloc>
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
  800c05:	68 7c 30 80 00       	push   $0x80307c
  800c0a:	68 ca 00 00 00       	push   $0xca
  800c0f:	68 21 30 80 00       	push   $0x803021
  800c14:	e8 a8 09 00 00       	call   8015c1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c19:	e8 8f 1c 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
  800c1e:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c21:	83 f8 01             	cmp    $0x1,%eax
  800c24:	74 17                	je     800c3d <_main+0xc05>
  800c26:	83 ec 04             	sub    $0x4,%esp
  800c29:	68 e4 30 80 00       	push   $0x8030e4
  800c2e:	68 cb 00 00 00       	push   $0xcb
  800c33:	68 21 30 80 00       	push   $0x803021
  800c38:	e8 84 09 00 00       	call   8015c1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c3d:	e8 20 1c 00 00       	call   802862 <sys_calculate_free_frames>
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
  800c88:	e8 d5 1b 00 00       	call   802862 <sys_calculate_free_frames>
  800c8d:	29 c3                	sub    %eax,%ebx
  800c8f:	89 d8                	mov    %ebx,%eax
  800c91:	83 f8 02             	cmp    $0x2,%eax
  800c94:	74 17                	je     800cad <_main+0xc75>
  800c96:	83 ec 04             	sub    $0x4,%esp
  800c99:	68 14 31 80 00       	push   $0x803114
  800c9e:	68 d2 00 00 00       	push   $0xd2
  800ca3:	68 21 30 80 00       	push   $0x803021
  800ca8:	e8 14 09 00 00       	call   8015c1 <_panic>
		found = 0;
  800cad:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800cb4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800cbb:	e9 aa 00 00 00       	jmp    800d6a <_main+0xd32>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800cc0:	a1 04 40 80 00       	mov    0x804004,%eax
  800cc5:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800d0c:	a1 04 40 80 00       	mov    0x804004,%eax
  800d11:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  800d6a:	a1 04 40 80 00       	mov    0x804004,%eax
  800d6f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  800d89:	68 58 31 80 00       	push   $0x803158
  800d8e:	68 db 00 00 00       	push   $0xdb
  800d93:	68 21 30 80 00       	push   $0x803021
  800d98:	e8 24 08 00 00       	call   8015c1 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d9d:	e8 c0 1a 00 00       	call   802862 <sys_calculate_free_frames>
  800da2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800da5:	e8 03 1b 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
  800daa:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800dad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800db0:	01 c0                	add    %eax,%eax
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	50                   	push   %eax
  800db6:	e8 73 18 00 00       	call   80262e <malloc>
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
  800e09:	68 7c 30 80 00       	push   $0x80307c
  800e0e:	68 e1 00 00 00       	push   $0xe1
  800e13:	68 21 30 80 00       	push   $0x803021
  800e18:	e8 a4 07 00 00       	call   8015c1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e1d:	e8 8b 1a 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
  800e22:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e25:	83 f8 01             	cmp    $0x1,%eax
  800e28:	74 17                	je     800e41 <_main+0xe09>
  800e2a:	83 ec 04             	sub    $0x4,%esp
  800e2d:	68 e4 30 80 00       	push   $0x8030e4
  800e32:	68 e2 00 00 00       	push   $0xe2
  800e37:	68 21 30 80 00       	push   $0x803021
  800e3c:	e8 80 07 00 00       	call   8015c1 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e41:	e8 67 1a 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
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
  800e5a:	e8 cf 17 00 00       	call   80262e <malloc>
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
  800ead:	68 7c 30 80 00       	push   $0x80307c
  800eb2:	68 e8 00 00 00       	push   $0xe8
  800eb7:	68 21 30 80 00       	push   $0x803021
  800ebc:	e8 00 07 00 00       	call   8015c1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ec1:	e8 e7 19 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
  800ec6:	2b 45 90             	sub    -0x70(%ebp),%eax
  800ec9:	83 f8 02             	cmp    $0x2,%eax
  800ecc:	74 17                	je     800ee5 <_main+0xead>
  800ece:	83 ec 04             	sub    $0x4,%esp
  800ed1:	68 e4 30 80 00       	push   $0x8030e4
  800ed6:	68 e9 00 00 00       	push   $0xe9
  800edb:	68 21 30 80 00       	push   $0x803021
  800ee0:	e8 dc 06 00 00       	call   8015c1 <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800ee5:	e8 78 19 00 00       	call   802862 <sys_calculate_free_frames>
  800eea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800eed:	e8 bb 19 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
  800ef2:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800ef5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ef8:	89 c2                	mov    %eax,%edx
  800efa:	01 d2                	add    %edx,%edx
  800efc:	01 d0                	add    %edx,%eax
  800efe:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800f01:	83 ec 0c             	sub    $0xc,%esp
  800f04:	50                   	push   %eax
  800f05:	e8 24 17 00 00       	call   80262e <malloc>
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
  800f58:	68 7c 30 80 00       	push   $0x80307c
  800f5d:	68 f0 00 00 00       	push   $0xf0
  800f62:	68 21 30 80 00       	push   $0x803021
  800f67:	e8 55 06 00 00       	call   8015c1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f6c:	e8 3c 19 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
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
  800f92:	68 e4 30 80 00       	push   $0x8030e4
  800f97:	68 f1 00 00 00       	push   $0xf1
  800f9c:	68 21 30 80 00       	push   $0x803021
  800fa1:	e8 1b 06 00 00       	call   8015c1 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800fa6:	e8 02 19 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
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
  800fc0:	e8 69 16 00 00       	call   80262e <malloc>
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
  801021:	68 7c 30 80 00       	push   $0x80307c
  801026:	68 f7 00 00 00       	push   $0xf7
  80102b:	68 21 30 80 00       	push   $0x803021
  801030:	e8 8c 05 00 00       	call   8015c1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  801035:	e8 73 18 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
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
  80105d:	68 e4 30 80 00       	push   $0x8030e4
  801062:	68 f8 00 00 00       	push   $0xf8
  801067:	68 21 30 80 00       	push   $0x803021
  80106c:	e8 50 05 00 00       	call   8015c1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801071:	e8 ec 17 00 00       	call   802862 <sys_calculate_free_frames>
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
  8010e2:	e8 7b 17 00 00       	call   802862 <sys_calculate_free_frames>
  8010e7:	29 c3                	sub    %eax,%ebx
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	83 f8 05             	cmp    $0x5,%eax
  8010ee:	74 17                	je     801107 <_main+0x10cf>
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 14 31 80 00       	push   $0x803114
  8010f8:	68 00 01 00 00       	push   $0x100
  8010fd:	68 21 30 80 00       	push   $0x803021
  801102:	e8 ba 04 00 00       	call   8015c1 <_panic>
		found = 0;
  801107:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80110e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801115:	e9 02 01 00 00       	jmp    80121c <_main+0x11e4>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  80111a:	a1 04 40 80 00       	mov    0x804004,%eax
  80111f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  801166:	a1 04 40 80 00       	mov    0x804004,%eax
  80116b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  8011c5:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ca:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  80121c:	a1 04 40 80 00       	mov    0x804004,%eax
  801221:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  80123b:	68 58 31 80 00       	push   $0x803158
  801240:	68 0b 01 00 00       	push   $0x10b
  801245:	68 21 30 80 00       	push   $0x803021
  80124a:	e8 72 03 00 00       	call   8015c1 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80124f:	e8 59 16 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
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
  80126a:	e8 bf 13 00 00       	call   80262e <malloc>
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
  8012cd:	68 7c 30 80 00       	push   $0x80307c
  8012d2:	68 10 01 00 00       	push   $0x110
  8012d7:	68 21 30 80 00       	push   $0x803021
  8012dc:	e8 e0 02 00 00       	call   8015c1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012e1:	e8 c7 15 00 00       	call   8028ad <sys_pf_calculate_allocated_pages>
  8012e6:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012e9:	83 f8 04             	cmp    $0x4,%eax
  8012ec:	74 17                	je     801305 <_main+0x12cd>
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 e4 30 80 00       	push   $0x8030e4
  8012f6:	68 11 01 00 00       	push   $0x111
  8012fb:	68 21 30 80 00       	push   $0x803021
  801300:	e8 bc 02 00 00       	call   8015c1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801305:	e8 58 15 00 00       	call   802862 <sys_calculate_free_frames>
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
  801359:	e8 04 15 00 00       	call   802862 <sys_calculate_free_frames>
  80135e:	29 c3                	sub    %eax,%ebx
  801360:	89 d8                	mov    %ebx,%eax
  801362:	83 f8 02             	cmp    $0x2,%eax
  801365:	74 17                	je     80137e <_main+0x1346>
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	68 14 31 80 00       	push   $0x803114
  80136f:	68 18 01 00 00       	push   $0x118
  801374:	68 21 30 80 00       	push   $0x803021
  801379:	e8 43 02 00 00       	call   8015c1 <_panic>
		found = 0;
  80137e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801385:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80138c:	e9 a7 00 00 00       	jmp    801438 <_main+0x1400>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  801391:	a1 04 40 80 00       	mov    0x804004,%eax
  801396:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  8013dd:	a1 04 40 80 00       	mov    0x804004,%eax
  8013e2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
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
  801438:	a1 04 40 80 00       	mov    0x804004,%eax
  80143d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
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
  801457:	68 58 31 80 00       	push   $0x803158
  80145c:	68 21 01 00 00       	push   $0x121
  801461:	68 21 30 80 00       	push   $0x803021
  801466:	e8 56 01 00 00       	call   8015c1 <_panic>
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
  80147a:	e8 ac 15 00 00       	call   802a2b <sys_getenvindex>
  80147f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  801482:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801485:	89 d0                	mov    %edx,%eax
  801487:	c1 e0 06             	shl    $0x6,%eax
  80148a:	29 d0                	sub    %edx,%eax
  80148c:	c1 e0 02             	shl    $0x2,%eax
  80148f:	01 d0                	add    %edx,%eax
  801491:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801498:	01 c8                	add    %ecx,%eax
  80149a:	c1 e0 03             	shl    $0x3,%eax
  80149d:	01 d0                	add    %edx,%eax
  80149f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a6:	29 c2                	sub    %eax,%edx
  8014a8:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8014af:	89 c2                	mov    %eax,%edx
  8014b1:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8014b7:	a3 04 40 80 00       	mov    %eax,0x804004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8014bc:	a1 04 40 80 00       	mov    0x804004,%eax
  8014c1:	8a 40 20             	mov    0x20(%eax),%al
  8014c4:	84 c0                	test   %al,%al
  8014c6:	74 0d                	je     8014d5 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8014c8:	a1 04 40 80 00       	mov    0x804004,%eax
  8014cd:	83 c0 20             	add    $0x20,%eax
  8014d0:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8014d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d9:	7e 0a                	jle    8014e5 <libmain+0x71>
		binaryname = argv[0];
  8014db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014de:	8b 00                	mov    (%eax),%eax
  8014e0:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	ff 75 0c             	pushl  0xc(%ebp)
  8014eb:	ff 75 08             	pushl  0x8(%ebp)
  8014ee:	e8 45 eb ff ff       	call   800038 <_main>
  8014f3:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8014f6:	e8 b4 12 00 00       	call   8027af <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	68 7c 32 80 00       	push   $0x80327c
  801503:	e8 76 03 00 00       	call   80187e <cprintf>
  801508:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80150b:	a1 04 40 80 00       	mov    0x804004,%eax
  801510:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  801516:	a1 04 40 80 00       	mov    0x804004,%eax
  80151b:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	52                   	push   %edx
  801525:	50                   	push   %eax
  801526:	68 a4 32 80 00       	push   $0x8032a4
  80152b:	e8 4e 03 00 00       	call   80187e <cprintf>
  801530:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801533:	a1 04 40 80 00       	mov    0x804004,%eax
  801538:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80153e:	a1 04 40 80 00       	mov    0x804004,%eax
  801543:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  801549:	a1 04 40 80 00       	mov    0x804004,%eax
  80154e:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  801554:	51                   	push   %ecx
  801555:	52                   	push   %edx
  801556:	50                   	push   %eax
  801557:	68 cc 32 80 00       	push   $0x8032cc
  80155c:	e8 1d 03 00 00       	call   80187e <cprintf>
  801561:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801564:	a1 04 40 80 00       	mov    0x804004,%eax
  801569:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	50                   	push   %eax
  801573:	68 24 33 80 00       	push   $0x803324
  801578:	e8 01 03 00 00       	call   80187e <cprintf>
  80157d:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801580:	83 ec 0c             	sub    $0xc,%esp
  801583:	68 7c 32 80 00       	push   $0x80327c
  801588:	e8 f1 02 00 00       	call   80187e <cprintf>
  80158d:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801590:	e8 34 12 00 00       	call   8027c9 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  801595:	e8 19 00 00 00       	call   8015b3 <exit>
}
  80159a:	90                   	nop
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8015a3:	83 ec 0c             	sub    $0xc,%esp
  8015a6:	6a 00                	push   $0x0
  8015a8:	e8 4a 14 00 00       	call   8029f7 <sys_destroy_env>
  8015ad:	83 c4 10             	add    $0x10,%esp
}
  8015b0:	90                   	nop
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <exit>:

void
exit(void)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8015b9:	e8 9f 14 00 00       	call   802a5d <sys_exit_env>
}
  8015be:	90                   	nop
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8015c7:	8d 45 10             	lea    0x10(%ebp),%eax
  8015ca:	83 c0 04             	add    $0x4,%eax
  8015cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8015d0:	a1 24 40 80 00       	mov    0x804024,%eax
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	74 16                	je     8015ef <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015d9:	a1 24 40 80 00       	mov    0x804024,%eax
  8015de:	83 ec 08             	sub    $0x8,%esp
  8015e1:	50                   	push   %eax
  8015e2:	68 38 33 80 00       	push   $0x803338
  8015e7:	e8 92 02 00 00       	call   80187e <cprintf>
  8015ec:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015ef:	a1 00 40 80 00       	mov    0x804000,%eax
  8015f4:	ff 75 0c             	pushl  0xc(%ebp)
  8015f7:	ff 75 08             	pushl  0x8(%ebp)
  8015fa:	50                   	push   %eax
  8015fb:	68 3d 33 80 00       	push   $0x80333d
  801600:	e8 79 02 00 00       	call   80187e <cprintf>
  801605:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801608:	8b 45 10             	mov    0x10(%ebp),%eax
  80160b:	83 ec 08             	sub    $0x8,%esp
  80160e:	ff 75 f4             	pushl  -0xc(%ebp)
  801611:	50                   	push   %eax
  801612:	e8 fc 01 00 00       	call   801813 <vcprintf>
  801617:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	6a 00                	push   $0x0
  80161f:	68 59 33 80 00       	push   $0x803359
  801624:	e8 ea 01 00 00       	call   801813 <vcprintf>
  801629:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80162c:	e8 82 ff ff ff       	call   8015b3 <exit>

	// should not return here
	while (1) ;
  801631:	eb fe                	jmp    801631 <_panic+0x70>

00801633 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801639:	a1 04 40 80 00       	mov    0x804004,%eax
  80163e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801644:	8b 45 0c             	mov    0xc(%ebp),%eax
  801647:	39 c2                	cmp    %eax,%edx
  801649:	74 14                	je     80165f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	68 5c 33 80 00       	push   $0x80335c
  801653:	6a 26                	push   $0x26
  801655:	68 a8 33 80 00       	push   $0x8033a8
  80165a:	e8 62 ff ff ff       	call   8015c1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80165f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801666:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80166d:	e9 c5 00 00 00       	jmp    801737 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801675:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	01 d0                	add    %edx,%eax
  801681:	8b 00                	mov    (%eax),%eax
  801683:	85 c0                	test   %eax,%eax
  801685:	75 08                	jne    80168f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801687:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80168a:	e9 a5 00 00 00       	jmp    801734 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80168f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801696:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80169d:	eb 69                	jmp    801708 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80169f:	a1 04 40 80 00       	mov    0x804004,%eax
  8016a4:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8016aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016ad:	89 d0                	mov    %edx,%eax
  8016af:	01 c0                	add    %eax,%eax
  8016b1:	01 d0                	add    %edx,%eax
  8016b3:	c1 e0 03             	shl    $0x3,%eax
  8016b6:	01 c8                	add    %ecx,%eax
  8016b8:	8a 40 04             	mov    0x4(%eax),%al
  8016bb:	84 c0                	test   %al,%al
  8016bd:	75 46                	jne    801705 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016bf:	a1 04 40 80 00       	mov    0x804004,%eax
  8016c4:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8016ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016cd:	89 d0                	mov    %edx,%eax
  8016cf:	01 c0                	add    %eax,%eax
  8016d1:	01 d0                	add    %edx,%eax
  8016d3:	c1 e0 03             	shl    $0x3,%eax
  8016d6:	01 c8                	add    %ecx,%eax
  8016d8:	8b 00                	mov    (%eax),%eax
  8016da:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016e5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	01 c8                	add    %ecx,%eax
  8016f6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016f8:	39 c2                	cmp    %eax,%edx
  8016fa:	75 09                	jne    801705 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8016fc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801703:	eb 15                	jmp    80171a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801705:	ff 45 e8             	incl   -0x18(%ebp)
  801708:	a1 04 40 80 00       	mov    0x804004,%eax
  80170d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801713:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801716:	39 c2                	cmp    %eax,%edx
  801718:	77 85                	ja     80169f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80171a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80171e:	75 14                	jne    801734 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801720:	83 ec 04             	sub    $0x4,%esp
  801723:	68 b4 33 80 00       	push   $0x8033b4
  801728:	6a 3a                	push   $0x3a
  80172a:	68 a8 33 80 00       	push   $0x8033a8
  80172f:	e8 8d fe ff ff       	call   8015c1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801734:	ff 45 f0             	incl   -0x10(%ebp)
  801737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80173d:	0f 8c 2f ff ff ff    	jl     801672 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801743:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80174a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801751:	eb 26                	jmp    801779 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801753:	a1 04 40 80 00       	mov    0x804004,%eax
  801758:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80175e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801761:	89 d0                	mov    %edx,%eax
  801763:	01 c0                	add    %eax,%eax
  801765:	01 d0                	add    %edx,%eax
  801767:	c1 e0 03             	shl    $0x3,%eax
  80176a:	01 c8                	add    %ecx,%eax
  80176c:	8a 40 04             	mov    0x4(%eax),%al
  80176f:	3c 01                	cmp    $0x1,%al
  801771:	75 03                	jne    801776 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801773:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801776:	ff 45 e0             	incl   -0x20(%ebp)
  801779:	a1 04 40 80 00       	mov    0x804004,%eax
  80177e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801784:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801787:	39 c2                	cmp    %eax,%edx
  801789:	77 c8                	ja     801753 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801791:	74 14                	je     8017a7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	68 08 34 80 00       	push   $0x803408
  80179b:	6a 44                	push   $0x44
  80179d:	68 a8 33 80 00       	push   $0x8033a8
  8017a2:	e8 1a fe ff ff       	call   8015c1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8017a7:	90                   	nop
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8017b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b3:	8b 00                	mov    (%eax),%eax
  8017b5:	8d 48 01             	lea    0x1(%eax),%ecx
  8017b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bb:	89 0a                	mov    %ecx,(%edx)
  8017bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c0:	88 d1                	mov    %dl,%cl
  8017c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8017c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cc:	8b 00                	mov    (%eax),%eax
  8017ce:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017d3:	75 2c                	jne    801801 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8017d5:	a0 08 40 80 00       	mov    0x804008,%al
  8017da:	0f b6 c0             	movzbl %al,%eax
  8017dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e0:	8b 12                	mov    (%edx),%edx
  8017e2:	89 d1                	mov    %edx,%ecx
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	83 c2 08             	add    $0x8,%edx
  8017ea:	83 ec 04             	sub    $0x4,%esp
  8017ed:	50                   	push   %eax
  8017ee:	51                   	push   %ecx
  8017ef:	52                   	push   %edx
  8017f0:	e8 78 0f 00 00       	call   80276d <sys_cputs>
  8017f5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801801:	8b 45 0c             	mov    0xc(%ebp),%eax
  801804:	8b 40 04             	mov    0x4(%eax),%eax
  801807:	8d 50 01             	lea    0x1(%eax),%edx
  80180a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180d:	89 50 04             	mov    %edx,0x4(%eax)
}
  801810:	90                   	nop
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80181c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801823:	00 00 00 
	b.cnt = 0;
  801826:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80182d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801830:	ff 75 0c             	pushl  0xc(%ebp)
  801833:	ff 75 08             	pushl  0x8(%ebp)
  801836:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80183c:	50                   	push   %eax
  80183d:	68 aa 17 80 00       	push   $0x8017aa
  801842:	e8 11 02 00 00       	call   801a58 <vprintfmt>
  801847:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80184a:	a0 08 40 80 00       	mov    0x804008,%al
  80184f:	0f b6 c0             	movzbl %al,%eax
  801852:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801858:	83 ec 04             	sub    $0x4,%esp
  80185b:	50                   	push   %eax
  80185c:	52                   	push   %edx
  80185d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801863:	83 c0 08             	add    $0x8,%eax
  801866:	50                   	push   %eax
  801867:	e8 01 0f 00 00       	call   80276d <sys_cputs>
  80186c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80186f:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
	return b.cnt;
  801876:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801884:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
	va_start(ap, fmt);
  80188b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80188e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	83 ec 08             	sub    $0x8,%esp
  801897:	ff 75 f4             	pushl  -0xc(%ebp)
  80189a:	50                   	push   %eax
  80189b:	e8 73 ff ff ff       	call   801813 <vcprintf>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8018a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8018b1:	e8 f9 0e 00 00       	call   8027af <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8018b6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	83 ec 08             	sub    $0x8,%esp
  8018c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c5:	50                   	push   %eax
  8018c6:	e8 48 ff ff ff       	call   801813 <vcprintf>
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8018d1:	e8 f3 0e 00 00       	call   8027c9 <sys_unlock_cons>
	return cnt;
  8018d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	53                   	push   %ebx
  8018df:	83 ec 14             	sub    $0x14,%esp
  8018e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018ee:	8b 45 18             	mov    0x18(%ebp),%eax
  8018f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018f9:	77 55                	ja     801950 <printnum+0x75>
  8018fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018fe:	72 05                	jb     801905 <printnum+0x2a>
  801900:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801903:	77 4b                	ja     801950 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801905:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801908:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80190b:	8b 45 18             	mov    0x18(%ebp),%eax
  80190e:	ba 00 00 00 00       	mov    $0x0,%edx
  801913:	52                   	push   %edx
  801914:	50                   	push   %eax
  801915:	ff 75 f4             	pushl  -0xc(%ebp)
  801918:	ff 75 f0             	pushl  -0x10(%ebp)
  80191b:	e8 50 14 00 00       	call   802d70 <__udivdi3>
  801920:	83 c4 10             	add    $0x10,%esp
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	ff 75 20             	pushl  0x20(%ebp)
  801929:	53                   	push   %ebx
  80192a:	ff 75 18             	pushl  0x18(%ebp)
  80192d:	52                   	push   %edx
  80192e:	50                   	push   %eax
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	ff 75 08             	pushl  0x8(%ebp)
  801935:	e8 a1 ff ff ff       	call   8018db <printnum>
  80193a:	83 c4 20             	add    $0x20,%esp
  80193d:	eb 1a                	jmp    801959 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	ff 75 20             	pushl  0x20(%ebp)
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	ff d0                	call   *%eax
  80194d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801950:	ff 4d 1c             	decl   0x1c(%ebp)
  801953:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801957:	7f e6                	jg     80193f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801959:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80195c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801967:	53                   	push   %ebx
  801968:	51                   	push   %ecx
  801969:	52                   	push   %edx
  80196a:	50                   	push   %eax
  80196b:	e8 10 15 00 00       	call   802e80 <__umoddi3>
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	05 74 36 80 00       	add    $0x803674,%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	0f be c0             	movsbl %al,%eax
  80197d:	83 ec 08             	sub    $0x8,%esp
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	50                   	push   %eax
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	ff d0                	call   *%eax
  801989:	83 c4 10             	add    $0x10,%esp
}
  80198c:	90                   	nop
  80198d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801995:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801999:	7e 1c                	jle    8019b7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8b 00                	mov    (%eax),%eax
  8019a0:	8d 50 08             	lea    0x8(%eax),%edx
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	89 10                	mov    %edx,(%eax)
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	8b 00                	mov    (%eax),%eax
  8019ad:	83 e8 08             	sub    $0x8,%eax
  8019b0:	8b 50 04             	mov    0x4(%eax),%edx
  8019b3:	8b 00                	mov    (%eax),%eax
  8019b5:	eb 40                	jmp    8019f7 <getuint+0x65>
	else if (lflag)
  8019b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019bb:	74 1e                	je     8019db <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8b 00                	mov    (%eax),%eax
  8019c2:	8d 50 04             	lea    0x4(%eax),%edx
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	89 10                	mov    %edx,(%eax)
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	8b 00                	mov    (%eax),%eax
  8019cf:	83 e8 04             	sub    $0x4,%eax
  8019d2:	8b 00                	mov    (%eax),%eax
  8019d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d9:	eb 1c                	jmp    8019f7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	8b 00                	mov    (%eax),%eax
  8019e0:	8d 50 04             	lea    0x4(%eax),%edx
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	89 10                	mov    %edx,(%eax)
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8b 00                	mov    (%eax),%eax
  8019ed:	83 e8 04             	sub    $0x4,%eax
  8019f0:	8b 00                	mov    (%eax),%eax
  8019f2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    

008019f9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019fc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a00:	7e 1c                	jle    801a1e <getint+0x25>
		return va_arg(*ap, long long);
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8b 00                	mov    (%eax),%eax
  801a07:	8d 50 08             	lea    0x8(%eax),%edx
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	89 10                	mov    %edx,(%eax)
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	8b 00                	mov    (%eax),%eax
  801a14:	83 e8 08             	sub    $0x8,%eax
  801a17:	8b 50 04             	mov    0x4(%eax),%edx
  801a1a:	8b 00                	mov    (%eax),%eax
  801a1c:	eb 38                	jmp    801a56 <getint+0x5d>
	else if (lflag)
  801a1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a22:	74 1a                	je     801a3e <getint+0x45>
		return va_arg(*ap, long);
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8b 00                	mov    (%eax),%eax
  801a29:	8d 50 04             	lea    0x4(%eax),%edx
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	89 10                	mov    %edx,(%eax)
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	8b 00                	mov    (%eax),%eax
  801a36:	83 e8 04             	sub    $0x4,%eax
  801a39:	8b 00                	mov    (%eax),%eax
  801a3b:	99                   	cltd   
  801a3c:	eb 18                	jmp    801a56 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8b 00                	mov    (%eax),%eax
  801a43:	8d 50 04             	lea    0x4(%eax),%edx
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	89 10                	mov    %edx,(%eax)
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	8b 00                	mov    (%eax),%eax
  801a50:	83 e8 04             	sub    $0x4,%eax
  801a53:	8b 00                	mov    (%eax),%eax
  801a55:	99                   	cltd   
}
  801a56:	5d                   	pop    %ebp
  801a57:	c3                   	ret    

00801a58 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	56                   	push   %esi
  801a5c:	53                   	push   %ebx
  801a5d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a60:	eb 17                	jmp    801a79 <vprintfmt+0x21>
			if (ch == '\0')
  801a62:	85 db                	test   %ebx,%ebx
  801a64:	0f 84 c1 03 00 00    	je     801e2b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801a6a:	83 ec 08             	sub    $0x8,%esp
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	53                   	push   %ebx
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	ff d0                	call   *%eax
  801a76:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a79:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7c:	8d 50 01             	lea    0x1(%eax),%edx
  801a7f:	89 55 10             	mov    %edx,0x10(%ebp)
  801a82:	8a 00                	mov    (%eax),%al
  801a84:	0f b6 d8             	movzbl %al,%ebx
  801a87:	83 fb 25             	cmp    $0x25,%ebx
  801a8a:	75 d6                	jne    801a62 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a8c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a90:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a97:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a9e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801aa5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aac:	8b 45 10             	mov    0x10(%ebp),%eax
  801aaf:	8d 50 01             	lea    0x1(%eax),%edx
  801ab2:	89 55 10             	mov    %edx,0x10(%ebp)
  801ab5:	8a 00                	mov    (%eax),%al
  801ab7:	0f b6 d8             	movzbl %al,%ebx
  801aba:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801abd:	83 f8 5b             	cmp    $0x5b,%eax
  801ac0:	0f 87 3d 03 00 00    	ja     801e03 <vprintfmt+0x3ab>
  801ac6:	8b 04 85 98 36 80 00 	mov    0x803698(,%eax,4),%eax
  801acd:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801acf:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801ad3:	eb d7                	jmp    801aac <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801ad5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801ad9:	eb d1                	jmp    801aac <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801adb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801ae2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae5:	89 d0                	mov    %edx,%eax
  801ae7:	c1 e0 02             	shl    $0x2,%eax
  801aea:	01 d0                	add    %edx,%eax
  801aec:	01 c0                	add    %eax,%eax
  801aee:	01 d8                	add    %ebx,%eax
  801af0:	83 e8 30             	sub    $0x30,%eax
  801af3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801af6:	8b 45 10             	mov    0x10(%ebp),%eax
  801af9:	8a 00                	mov    (%eax),%al
  801afb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801afe:	83 fb 2f             	cmp    $0x2f,%ebx
  801b01:	7e 3e                	jle    801b41 <vprintfmt+0xe9>
  801b03:	83 fb 39             	cmp    $0x39,%ebx
  801b06:	7f 39                	jg     801b41 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b08:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b0b:	eb d5                	jmp    801ae2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b10:	83 c0 04             	add    $0x4,%eax
  801b13:	89 45 14             	mov    %eax,0x14(%ebp)
  801b16:	8b 45 14             	mov    0x14(%ebp),%eax
  801b19:	83 e8 04             	sub    $0x4,%eax
  801b1c:	8b 00                	mov    (%eax),%eax
  801b1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b21:	eb 1f                	jmp    801b42 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b27:	79 83                	jns    801aac <vprintfmt+0x54>
				width = 0;
  801b29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b30:	e9 77 ff ff ff       	jmp    801aac <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b35:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b3c:	e9 6b ff ff ff       	jmp    801aac <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b41:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b46:	0f 89 60 ff ff ff    	jns    801aac <vprintfmt+0x54>
				width = precision, precision = -1;
  801b4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b52:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b59:	e9 4e ff ff ff       	jmp    801aac <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b5e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b61:	e9 46 ff ff ff       	jmp    801aac <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b66:	8b 45 14             	mov    0x14(%ebp),%eax
  801b69:	83 c0 04             	add    $0x4,%eax
  801b6c:	89 45 14             	mov    %eax,0x14(%ebp)
  801b6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b72:	83 e8 04             	sub    $0x4,%eax
  801b75:	8b 00                	mov    (%eax),%eax
  801b77:	83 ec 08             	sub    $0x8,%esp
  801b7a:	ff 75 0c             	pushl  0xc(%ebp)
  801b7d:	50                   	push   %eax
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	ff d0                	call   *%eax
  801b83:	83 c4 10             	add    $0x10,%esp
			break;
  801b86:	e9 9b 02 00 00       	jmp    801e26 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b8e:	83 c0 04             	add    $0x4,%eax
  801b91:	89 45 14             	mov    %eax,0x14(%ebp)
  801b94:	8b 45 14             	mov    0x14(%ebp),%eax
  801b97:	83 e8 04             	sub    $0x4,%eax
  801b9a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b9c:	85 db                	test   %ebx,%ebx
  801b9e:	79 02                	jns    801ba2 <vprintfmt+0x14a>
				err = -err;
  801ba0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801ba2:	83 fb 64             	cmp    $0x64,%ebx
  801ba5:	7f 0b                	jg     801bb2 <vprintfmt+0x15a>
  801ba7:	8b 34 9d e0 34 80 00 	mov    0x8034e0(,%ebx,4),%esi
  801bae:	85 f6                	test   %esi,%esi
  801bb0:	75 19                	jne    801bcb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801bb2:	53                   	push   %ebx
  801bb3:	68 85 36 80 00       	push   $0x803685
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	e8 70 02 00 00       	call   801e33 <printfmt>
  801bc3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801bc6:	e9 5b 02 00 00       	jmp    801e26 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801bcb:	56                   	push   %esi
  801bcc:	68 8e 36 80 00       	push   $0x80368e
  801bd1:	ff 75 0c             	pushl  0xc(%ebp)
  801bd4:	ff 75 08             	pushl  0x8(%ebp)
  801bd7:	e8 57 02 00 00       	call   801e33 <printfmt>
  801bdc:	83 c4 10             	add    $0x10,%esp
			break;
  801bdf:	e9 42 02 00 00       	jmp    801e26 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801be4:	8b 45 14             	mov    0x14(%ebp),%eax
  801be7:	83 c0 04             	add    $0x4,%eax
  801bea:	89 45 14             	mov    %eax,0x14(%ebp)
  801bed:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf0:	83 e8 04             	sub    $0x4,%eax
  801bf3:	8b 30                	mov    (%eax),%esi
  801bf5:	85 f6                	test   %esi,%esi
  801bf7:	75 05                	jne    801bfe <vprintfmt+0x1a6>
				p = "(null)";
  801bf9:	be 91 36 80 00       	mov    $0x803691,%esi
			if (width > 0 && padc != '-')
  801bfe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c02:	7e 6d                	jle    801c71 <vprintfmt+0x219>
  801c04:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c08:	74 67                	je     801c71 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c0d:	83 ec 08             	sub    $0x8,%esp
  801c10:	50                   	push   %eax
  801c11:	56                   	push   %esi
  801c12:	e8 1e 03 00 00       	call   801f35 <strnlen>
  801c17:	83 c4 10             	add    $0x10,%esp
  801c1a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c1d:	eb 16                	jmp    801c35 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c1f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c23:	83 ec 08             	sub    $0x8,%esp
  801c26:	ff 75 0c             	pushl  0xc(%ebp)
  801c29:	50                   	push   %eax
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	ff d0                	call   *%eax
  801c2f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c32:	ff 4d e4             	decl   -0x1c(%ebp)
  801c35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c39:	7f e4                	jg     801c1f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c3b:	eb 34                	jmp    801c71 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c41:	74 1c                	je     801c5f <vprintfmt+0x207>
  801c43:	83 fb 1f             	cmp    $0x1f,%ebx
  801c46:	7e 05                	jle    801c4d <vprintfmt+0x1f5>
  801c48:	83 fb 7e             	cmp    $0x7e,%ebx
  801c4b:	7e 12                	jle    801c5f <vprintfmt+0x207>
					putch('?', putdat);
  801c4d:	83 ec 08             	sub    $0x8,%esp
  801c50:	ff 75 0c             	pushl  0xc(%ebp)
  801c53:	6a 3f                	push   $0x3f
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	ff d0                	call   *%eax
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	eb 0f                	jmp    801c6e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c5f:	83 ec 08             	sub    $0x8,%esp
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	53                   	push   %ebx
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	ff d0                	call   *%eax
  801c6b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c6e:	ff 4d e4             	decl   -0x1c(%ebp)
  801c71:	89 f0                	mov    %esi,%eax
  801c73:	8d 70 01             	lea    0x1(%eax),%esi
  801c76:	8a 00                	mov    (%eax),%al
  801c78:	0f be d8             	movsbl %al,%ebx
  801c7b:	85 db                	test   %ebx,%ebx
  801c7d:	74 24                	je     801ca3 <vprintfmt+0x24b>
  801c7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c83:	78 b8                	js     801c3d <vprintfmt+0x1e5>
  801c85:	ff 4d e0             	decl   -0x20(%ebp)
  801c88:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c8c:	79 af                	jns    801c3d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c8e:	eb 13                	jmp    801ca3 <vprintfmt+0x24b>
				putch(' ', putdat);
  801c90:	83 ec 08             	sub    $0x8,%esp
  801c93:	ff 75 0c             	pushl  0xc(%ebp)
  801c96:	6a 20                	push   $0x20
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	ff d0                	call   *%eax
  801c9d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ca0:	ff 4d e4             	decl   -0x1c(%ebp)
  801ca3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ca7:	7f e7                	jg     801c90 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801ca9:	e9 78 01 00 00       	jmp    801e26 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801cae:	83 ec 08             	sub    $0x8,%esp
  801cb1:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb4:	8d 45 14             	lea    0x14(%ebp),%eax
  801cb7:	50                   	push   %eax
  801cb8:	e8 3c fd ff ff       	call   8019f9 <getint>
  801cbd:	83 c4 10             	add    $0x10,%esp
  801cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ccc:	85 d2                	test   %edx,%edx
  801cce:	79 23                	jns    801cf3 <vprintfmt+0x29b>
				putch('-', putdat);
  801cd0:	83 ec 08             	sub    $0x8,%esp
  801cd3:	ff 75 0c             	pushl  0xc(%ebp)
  801cd6:	6a 2d                	push   $0x2d
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	ff d0                	call   *%eax
  801cdd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ce6:	f7 d8                	neg    %eax
  801ce8:	83 d2 00             	adc    $0x0,%edx
  801ceb:	f7 da                	neg    %edx
  801ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801cf3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cfa:	e9 bc 00 00 00       	jmp    801dbb <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801cff:	83 ec 08             	sub    $0x8,%esp
  801d02:	ff 75 e8             	pushl  -0x18(%ebp)
  801d05:	8d 45 14             	lea    0x14(%ebp),%eax
  801d08:	50                   	push   %eax
  801d09:	e8 84 fc ff ff       	call   801992 <getuint>
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d14:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d17:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d1e:	e9 98 00 00 00       	jmp    801dbb <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d23:	83 ec 08             	sub    $0x8,%esp
  801d26:	ff 75 0c             	pushl  0xc(%ebp)
  801d29:	6a 58                	push   $0x58
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	ff d0                	call   *%eax
  801d30:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d33:	83 ec 08             	sub    $0x8,%esp
  801d36:	ff 75 0c             	pushl  0xc(%ebp)
  801d39:	6a 58                	push   $0x58
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	ff d0                	call   *%eax
  801d40:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d43:	83 ec 08             	sub    $0x8,%esp
  801d46:	ff 75 0c             	pushl  0xc(%ebp)
  801d49:	6a 58                	push   $0x58
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	ff d0                	call   *%eax
  801d50:	83 c4 10             	add    $0x10,%esp
			break;
  801d53:	e9 ce 00 00 00       	jmp    801e26 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801d58:	83 ec 08             	sub    $0x8,%esp
  801d5b:	ff 75 0c             	pushl  0xc(%ebp)
  801d5e:	6a 30                	push   $0x30
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	ff d0                	call   *%eax
  801d65:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d68:	83 ec 08             	sub    $0x8,%esp
  801d6b:	ff 75 0c             	pushl  0xc(%ebp)
  801d6e:	6a 78                	push   $0x78
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	ff d0                	call   *%eax
  801d75:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d78:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7b:	83 c0 04             	add    $0x4,%eax
  801d7e:	89 45 14             	mov    %eax,0x14(%ebp)
  801d81:	8b 45 14             	mov    0x14(%ebp),%eax
  801d84:	83 e8 04             	sub    $0x4,%eax
  801d87:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d93:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d9a:	eb 1f                	jmp    801dbb <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d9c:	83 ec 08             	sub    $0x8,%esp
  801d9f:	ff 75 e8             	pushl  -0x18(%ebp)
  801da2:	8d 45 14             	lea    0x14(%ebp),%eax
  801da5:	50                   	push   %eax
  801da6:	e8 e7 fb ff ff       	call   801992 <getuint>
  801dab:	83 c4 10             	add    $0x10,%esp
  801dae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801db1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801db4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801dbb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801dbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc2:	83 ec 04             	sub    $0x4,%esp
  801dc5:	52                   	push   %edx
  801dc6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801dc9:	50                   	push   %eax
  801dca:	ff 75 f4             	pushl  -0xc(%ebp)
  801dcd:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd0:	ff 75 0c             	pushl  0xc(%ebp)
  801dd3:	ff 75 08             	pushl  0x8(%ebp)
  801dd6:	e8 00 fb ff ff       	call   8018db <printnum>
  801ddb:	83 c4 20             	add    $0x20,%esp
			break;
  801dde:	eb 46                	jmp    801e26 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801de0:	83 ec 08             	sub    $0x8,%esp
  801de3:	ff 75 0c             	pushl  0xc(%ebp)
  801de6:	53                   	push   %ebx
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	ff d0                	call   *%eax
  801dec:	83 c4 10             	add    $0x10,%esp
			break;
  801def:	eb 35                	jmp    801e26 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801df1:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
			break;
  801df8:	eb 2c                	jmp    801e26 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801dfa:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
			break;
  801e01:	eb 23                	jmp    801e26 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e03:	83 ec 08             	sub    $0x8,%esp
  801e06:	ff 75 0c             	pushl  0xc(%ebp)
  801e09:	6a 25                	push   $0x25
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	ff d0                	call   *%eax
  801e10:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e13:	ff 4d 10             	decl   0x10(%ebp)
  801e16:	eb 03                	jmp    801e1b <vprintfmt+0x3c3>
  801e18:	ff 4d 10             	decl   0x10(%ebp)
  801e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1e:	48                   	dec    %eax
  801e1f:	8a 00                	mov    (%eax),%al
  801e21:	3c 25                	cmp    $0x25,%al
  801e23:	75 f3                	jne    801e18 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801e25:	90                   	nop
		}
	}
  801e26:	e9 35 fc ff ff       	jmp    801a60 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e2b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e2f:	5b                   	pop    %ebx
  801e30:	5e                   	pop    %esi
  801e31:	5d                   	pop    %ebp
  801e32:	c3                   	ret    

00801e33 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e39:	8d 45 10             	lea    0x10(%ebp),%eax
  801e3c:	83 c0 04             	add    $0x4,%eax
  801e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801e42:	8b 45 10             	mov    0x10(%ebp),%eax
  801e45:	ff 75 f4             	pushl  -0xc(%ebp)
  801e48:	50                   	push   %eax
  801e49:	ff 75 0c             	pushl  0xc(%ebp)
  801e4c:	ff 75 08             	pushl  0x8(%ebp)
  801e4f:	e8 04 fc ff ff       	call   801a58 <vprintfmt>
  801e54:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e57:	90                   	nop
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e60:	8b 40 08             	mov    0x8(%eax),%eax
  801e63:	8d 50 01             	lea    0x1(%eax),%edx
  801e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e69:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6f:	8b 10                	mov    (%eax),%edx
  801e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e74:	8b 40 04             	mov    0x4(%eax),%eax
  801e77:	39 c2                	cmp    %eax,%edx
  801e79:	73 12                	jae    801e8d <sprintputch+0x33>
		*b->buf++ = ch;
  801e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7e:	8b 00                	mov    (%eax),%eax
  801e80:	8d 48 01             	lea    0x1(%eax),%ecx
  801e83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e86:	89 0a                	mov    %ecx,(%edx)
  801e88:	8b 55 08             	mov    0x8(%ebp),%edx
  801e8b:	88 10                	mov    %dl,(%eax)
}
  801e8d:	90                   	nop
  801e8e:	5d                   	pop    %ebp
  801e8f:	c3                   	ret    

00801e90 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	01 d0                	add    %edx,%eax
  801ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801eaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801eb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801eb5:	74 06                	je     801ebd <vsnprintf+0x2d>
  801eb7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ebb:	7f 07                	jg     801ec4 <vsnprintf+0x34>
		return -E_INVAL;
  801ebd:	b8 03 00 00 00       	mov    $0x3,%eax
  801ec2:	eb 20                	jmp    801ee4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ec4:	ff 75 14             	pushl  0x14(%ebp)
  801ec7:	ff 75 10             	pushl  0x10(%ebp)
  801eca:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ecd:	50                   	push   %eax
  801ece:	68 5a 1e 80 00       	push   $0x801e5a
  801ed3:	e8 80 fb ff ff       	call   801a58 <vprintfmt>
  801ed8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801edb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ede:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801eec:	8d 45 10             	lea    0x10(%ebp),%eax
  801eef:	83 c0 04             	add    $0x4,%eax
  801ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801ef5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef8:	ff 75 f4             	pushl  -0xc(%ebp)
  801efb:	50                   	push   %eax
  801efc:	ff 75 0c             	pushl  0xc(%ebp)
  801eff:	ff 75 08             	pushl  0x8(%ebp)
  801f02:	e8 89 ff ff ff       	call   801e90 <vsnprintf>
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f1f:	eb 06                	jmp    801f27 <strlen+0x15>
		n++;
  801f21:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f24:	ff 45 08             	incl   0x8(%ebp)
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	8a 00                	mov    (%eax),%al
  801f2c:	84 c0                	test   %al,%al
  801f2e:	75 f1                	jne    801f21 <strlen+0xf>
		n++;
	return n;
  801f30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f42:	eb 09                	jmp    801f4d <strnlen+0x18>
		n++;
  801f44:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f47:	ff 45 08             	incl   0x8(%ebp)
  801f4a:	ff 4d 0c             	decl   0xc(%ebp)
  801f4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f51:	74 09                	je     801f5c <strnlen+0x27>
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	8a 00                	mov    (%eax),%al
  801f58:	84 c0                	test   %al,%al
  801f5a:	75 e8                	jne    801f44 <strnlen+0xf>
		n++;
	return n;
  801f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f67:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f6d:	90                   	nop
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	8d 50 01             	lea    0x1(%eax),%edx
  801f74:	89 55 08             	mov    %edx,0x8(%ebp)
  801f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f7d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f80:	8a 12                	mov    (%edx),%dl
  801f82:	88 10                	mov    %dl,(%eax)
  801f84:	8a 00                	mov    (%eax),%al
  801f86:	84 c0                	test   %al,%al
  801f88:	75 e4                	jne    801f6e <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fa2:	eb 1f                	jmp    801fc3 <strncpy+0x34>
		*dst++ = *src;
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	8d 50 01             	lea    0x1(%eax),%edx
  801faa:	89 55 08             	mov    %edx,0x8(%ebp)
  801fad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb0:	8a 12                	mov    (%edx),%dl
  801fb2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb7:	8a 00                	mov    (%eax),%al
  801fb9:	84 c0                	test   %al,%al
  801fbb:	74 03                	je     801fc0 <strncpy+0x31>
			src++;
  801fbd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fc0:	ff 45 fc             	incl   -0x4(%ebp)
  801fc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc6:	3b 45 10             	cmp    0x10(%ebp),%eax
  801fc9:	72 d9                	jb     801fa4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801fcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801fdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fe0:	74 30                	je     802012 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801fe2:	eb 16                	jmp    801ffa <strlcpy+0x2a>
			*dst++ = *src++;
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	8d 50 01             	lea    0x1(%eax),%edx
  801fea:	89 55 08             	mov    %edx,0x8(%ebp)
  801fed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff0:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ff3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801ff6:	8a 12                	mov    (%edx),%dl
  801ff8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801ffa:	ff 4d 10             	decl   0x10(%ebp)
  801ffd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802001:	74 09                	je     80200c <strlcpy+0x3c>
  802003:	8b 45 0c             	mov    0xc(%ebp),%eax
  802006:	8a 00                	mov    (%eax),%al
  802008:	84 c0                	test   %al,%al
  80200a:	75 d8                	jne    801fe4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802012:	8b 55 08             	mov    0x8(%ebp),%edx
  802015:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802018:	29 c2                	sub    %eax,%edx
  80201a:	89 d0                	mov    %edx,%eax
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802021:	eb 06                	jmp    802029 <strcmp+0xb>
		p++, q++;
  802023:	ff 45 08             	incl   0x8(%ebp)
  802026:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	8a 00                	mov    (%eax),%al
  80202e:	84 c0                	test   %al,%al
  802030:	74 0e                	je     802040 <strcmp+0x22>
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	8a 10                	mov    (%eax),%dl
  802037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203a:	8a 00                	mov    (%eax),%al
  80203c:	38 c2                	cmp    %al,%dl
  80203e:	74 e3                	je     802023 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	8a 00                	mov    (%eax),%al
  802045:	0f b6 d0             	movzbl %al,%edx
  802048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204b:	8a 00                	mov    (%eax),%al
  80204d:	0f b6 c0             	movzbl %al,%eax
  802050:	29 c2                	sub    %eax,%edx
  802052:	89 d0                	mov    %edx,%eax
}
  802054:	5d                   	pop    %ebp
  802055:	c3                   	ret    

00802056 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802059:	eb 09                	jmp    802064 <strncmp+0xe>
		n--, p++, q++;
  80205b:	ff 4d 10             	decl   0x10(%ebp)
  80205e:	ff 45 08             	incl   0x8(%ebp)
  802061:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802064:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802068:	74 17                	je     802081 <strncmp+0x2b>
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	8a 00                	mov    (%eax),%al
  80206f:	84 c0                	test   %al,%al
  802071:	74 0e                	je     802081 <strncmp+0x2b>
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	8a 10                	mov    (%eax),%dl
  802078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207b:	8a 00                	mov    (%eax),%al
  80207d:	38 c2                	cmp    %al,%dl
  80207f:	74 da                	je     80205b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802081:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802085:	75 07                	jne    80208e <strncmp+0x38>
		return 0;
  802087:	b8 00 00 00 00       	mov    $0x0,%eax
  80208c:	eb 14                	jmp    8020a2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	8a 00                	mov    (%eax),%al
  802093:	0f b6 d0             	movzbl %al,%edx
  802096:	8b 45 0c             	mov    0xc(%ebp),%eax
  802099:	8a 00                	mov    (%eax),%al
  80209b:	0f b6 c0             	movzbl %al,%eax
  80209e:	29 c2                	sub    %eax,%edx
  8020a0:	89 d0                	mov    %edx,%eax
}
  8020a2:	5d                   	pop    %ebp
  8020a3:	c3                   	ret    

008020a4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	83 ec 04             	sub    $0x4,%esp
  8020aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020b0:	eb 12                	jmp    8020c4 <strchr+0x20>
		if (*s == c)
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	8a 00                	mov    (%eax),%al
  8020b7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020ba:	75 05                	jne    8020c1 <strchr+0x1d>
			return (char *) s;
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	eb 11                	jmp    8020d2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020c1:	ff 45 08             	incl   0x8(%ebp)
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	8a 00                	mov    (%eax),%al
  8020c9:	84 c0                	test   %al,%al
  8020cb:	75 e5                	jne    8020b2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8020cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020e0:	eb 0d                	jmp    8020ef <strfind+0x1b>
		if (*s == c)
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	8a 00                	mov    (%eax),%al
  8020e7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020ea:	74 0e                	je     8020fa <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020ec:	ff 45 08             	incl   0x8(%ebp)
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	8a 00                	mov    (%eax),%al
  8020f4:	84 c0                	test   %al,%al
  8020f6:	75 ea                	jne    8020e2 <strfind+0xe>
  8020f8:	eb 01                	jmp    8020fb <strfind+0x27>
		if (*s == c)
			break;
  8020fa:	90                   	nop
	return (char *) s;
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80210c:	8b 45 10             	mov    0x10(%ebp),%eax
  80210f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  802112:	eb 0e                	jmp    802122 <memset+0x22>
		*p++ = c;
  802114:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802117:	8d 50 01             	lea    0x1(%eax),%edx
  80211a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80211d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802120:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  802122:	ff 4d f8             	decl   -0x8(%ebp)
  802125:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802129:	79 e9                	jns    802114 <memset+0x14>
		*p++ = c;

	return v;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802136:	8b 45 0c             	mov    0xc(%ebp),%eax
  802139:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  802142:	eb 16                	jmp    80215a <memcpy+0x2a>
		*d++ = *s++;
  802144:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802147:	8d 50 01             	lea    0x1(%eax),%edx
  80214a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80214d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802150:	8d 4a 01             	lea    0x1(%edx),%ecx
  802153:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802156:	8a 12                	mov    (%edx),%dl
  802158:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80215a:	8b 45 10             	mov    0x10(%ebp),%eax
  80215d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802160:	89 55 10             	mov    %edx,0x10(%ebp)
  802163:	85 c0                	test   %eax,%eax
  802165:	75 dd                	jne    802144 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802172:	8b 45 0c             	mov    0xc(%ebp),%eax
  802175:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80217e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802181:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802184:	73 50                	jae    8021d6 <memmove+0x6a>
  802186:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802189:	8b 45 10             	mov    0x10(%ebp),%eax
  80218c:	01 d0                	add    %edx,%eax
  80218e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802191:	76 43                	jbe    8021d6 <memmove+0x6a>
		s += n;
  802193:	8b 45 10             	mov    0x10(%ebp),%eax
  802196:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802199:	8b 45 10             	mov    0x10(%ebp),%eax
  80219c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80219f:	eb 10                	jmp    8021b1 <memmove+0x45>
			*--d = *--s;
  8021a1:	ff 4d f8             	decl   -0x8(%ebp)
  8021a4:	ff 4d fc             	decl   -0x4(%ebp)
  8021a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021aa:	8a 10                	mov    (%eax),%dl
  8021ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021af:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8021b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	75 e3                	jne    8021a1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8021be:	eb 23                	jmp    8021e3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8021c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021c3:	8d 50 01             	lea    0x1(%eax),%edx
  8021c6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021cf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8021d2:	8a 12                	mov    (%edx),%dl
  8021d4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8021d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	75 dd                	jne    8021c0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8021f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8021fa:	eb 2a                	jmp    802226 <memcmp+0x3e>
		if (*s1 != *s2)
  8021fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ff:	8a 10                	mov    (%eax),%dl
  802201:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802204:	8a 00                	mov    (%eax),%al
  802206:	38 c2                	cmp    %al,%dl
  802208:	74 16                	je     802220 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80220a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80220d:	8a 00                	mov    (%eax),%al
  80220f:	0f b6 d0             	movzbl %al,%edx
  802212:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802215:	8a 00                	mov    (%eax),%al
  802217:	0f b6 c0             	movzbl %al,%eax
  80221a:	29 c2                	sub    %eax,%edx
  80221c:	89 d0                	mov    %edx,%eax
  80221e:	eb 18                	jmp    802238 <memcmp+0x50>
		s1++, s2++;
  802220:	ff 45 fc             	incl   -0x4(%ebp)
  802223:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802226:	8b 45 10             	mov    0x10(%ebp),%eax
  802229:	8d 50 ff             	lea    -0x1(%eax),%edx
  80222c:	89 55 10             	mov    %edx,0x10(%ebp)
  80222f:	85 c0                	test   %eax,%eax
  802231:	75 c9                	jne    8021fc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802240:	8b 55 08             	mov    0x8(%ebp),%edx
  802243:	8b 45 10             	mov    0x10(%ebp),%eax
  802246:	01 d0                	add    %edx,%eax
  802248:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80224b:	eb 15                	jmp    802262 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	8a 00                	mov    (%eax),%al
  802252:	0f b6 d0             	movzbl %al,%edx
  802255:	8b 45 0c             	mov    0xc(%ebp),%eax
  802258:	0f b6 c0             	movzbl %al,%eax
  80225b:	39 c2                	cmp    %eax,%edx
  80225d:	74 0d                	je     80226c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80225f:	ff 45 08             	incl   0x8(%ebp)
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802268:	72 e3                	jb     80224d <memfind+0x13>
  80226a:	eb 01                	jmp    80226d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80226c:	90                   	nop
	return (void *) s;
  80226d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802278:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80227f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802286:	eb 03                	jmp    80228b <strtol+0x19>
		s++;
  802288:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	8a 00                	mov    (%eax),%al
  802290:	3c 20                	cmp    $0x20,%al
  802292:	74 f4                	je     802288 <strtol+0x16>
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	8a 00                	mov    (%eax),%al
  802299:	3c 09                	cmp    $0x9,%al
  80229b:	74 eb                	je     802288 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	8a 00                	mov    (%eax),%al
  8022a2:	3c 2b                	cmp    $0x2b,%al
  8022a4:	75 05                	jne    8022ab <strtol+0x39>
		s++;
  8022a6:	ff 45 08             	incl   0x8(%ebp)
  8022a9:	eb 13                	jmp    8022be <strtol+0x4c>
	else if (*s == '-')
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	8a 00                	mov    (%eax),%al
  8022b0:	3c 2d                	cmp    $0x2d,%al
  8022b2:	75 0a                	jne    8022be <strtol+0x4c>
		s++, neg = 1;
  8022b4:	ff 45 08             	incl   0x8(%ebp)
  8022b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8022be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022c2:	74 06                	je     8022ca <strtol+0x58>
  8022c4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8022c8:	75 20                	jne    8022ea <strtol+0x78>
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	8a 00                	mov    (%eax),%al
  8022cf:	3c 30                	cmp    $0x30,%al
  8022d1:	75 17                	jne    8022ea <strtol+0x78>
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	40                   	inc    %eax
  8022d7:	8a 00                	mov    (%eax),%al
  8022d9:	3c 78                	cmp    $0x78,%al
  8022db:	75 0d                	jne    8022ea <strtol+0x78>
		s += 2, base = 16;
  8022dd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8022e1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8022e8:	eb 28                	jmp    802312 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8022ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022ee:	75 15                	jne    802305 <strtol+0x93>
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	8a 00                	mov    (%eax),%al
  8022f5:	3c 30                	cmp    $0x30,%al
  8022f7:	75 0c                	jne    802305 <strtol+0x93>
		s++, base = 8;
  8022f9:	ff 45 08             	incl   0x8(%ebp)
  8022fc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802303:	eb 0d                	jmp    802312 <strtol+0xa0>
	else if (base == 0)
  802305:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802309:	75 07                	jne    802312 <strtol+0xa0>
		base = 10;
  80230b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	8a 00                	mov    (%eax),%al
  802317:	3c 2f                	cmp    $0x2f,%al
  802319:	7e 19                	jle    802334 <strtol+0xc2>
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8a 00                	mov    (%eax),%al
  802320:	3c 39                	cmp    $0x39,%al
  802322:	7f 10                	jg     802334 <strtol+0xc2>
			dig = *s - '0';
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	8a 00                	mov    (%eax),%al
  802329:	0f be c0             	movsbl %al,%eax
  80232c:	83 e8 30             	sub    $0x30,%eax
  80232f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802332:	eb 42                	jmp    802376 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	8a 00                	mov    (%eax),%al
  802339:	3c 60                	cmp    $0x60,%al
  80233b:	7e 19                	jle    802356 <strtol+0xe4>
  80233d:	8b 45 08             	mov    0x8(%ebp),%eax
  802340:	8a 00                	mov    (%eax),%al
  802342:	3c 7a                	cmp    $0x7a,%al
  802344:	7f 10                	jg     802356 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	8a 00                	mov    (%eax),%al
  80234b:	0f be c0             	movsbl %al,%eax
  80234e:	83 e8 57             	sub    $0x57,%eax
  802351:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802354:	eb 20                	jmp    802376 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	8a 00                	mov    (%eax),%al
  80235b:	3c 40                	cmp    $0x40,%al
  80235d:	7e 39                	jle    802398 <strtol+0x126>
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	8a 00                	mov    (%eax),%al
  802364:	3c 5a                	cmp    $0x5a,%al
  802366:	7f 30                	jg     802398 <strtol+0x126>
			dig = *s - 'A' + 10;
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	8a 00                	mov    (%eax),%al
  80236d:	0f be c0             	movsbl %al,%eax
  802370:	83 e8 37             	sub    $0x37,%eax
  802373:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	3b 45 10             	cmp    0x10(%ebp),%eax
  80237c:	7d 19                	jge    802397 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80237e:	ff 45 08             	incl   0x8(%ebp)
  802381:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802384:	0f af 45 10          	imul   0x10(%ebp),%eax
  802388:	89 c2                	mov    %eax,%edx
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	01 d0                	add    %edx,%eax
  80238f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802392:	e9 7b ff ff ff       	jmp    802312 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802397:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80239c:	74 08                	je     8023a6 <strtol+0x134>
		*endptr = (char *) s;
  80239e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8023a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023aa:	74 07                	je     8023b3 <strtol+0x141>
  8023ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023af:	f7 d8                	neg    %eax
  8023b1:	eb 03                	jmp    8023b6 <strtol+0x144>
  8023b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <ltostr>:

void
ltostr(long value, char *str)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8023be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8023c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8023cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d0:	79 13                	jns    8023e5 <ltostr+0x2d>
	{
		neg = 1;
  8023d2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8023d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023dc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8023df:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8023e2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8023ed:	99                   	cltd   
  8023ee:	f7 f9                	idiv   %ecx
  8023f0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8023f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023f6:	8d 50 01             	lea    0x1(%eax),%edx
  8023f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023fc:	89 c2                	mov    %eax,%edx
  8023fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802401:	01 d0                	add    %edx,%eax
  802403:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802406:	83 c2 30             	add    $0x30,%edx
  802409:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80240b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80240e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802413:	f7 e9                	imul   %ecx
  802415:	c1 fa 02             	sar    $0x2,%edx
  802418:	89 c8                	mov    %ecx,%eax
  80241a:	c1 f8 1f             	sar    $0x1f,%eax
  80241d:	29 c2                	sub    %eax,%edx
  80241f:	89 d0                	mov    %edx,%eax
  802421:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  802424:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802428:	75 bb                	jne    8023e5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80242a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802431:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802434:	48                   	dec    %eax
  802435:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802438:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80243c:	74 3d                	je     80247b <ltostr+0xc3>
		start = 1 ;
  80243e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802445:	eb 34                	jmp    80247b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802447:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244d:	01 d0                	add    %edx,%eax
  80244f:	8a 00                	mov    (%eax),%al
  802451:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802454:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245a:	01 c2                	add    %eax,%edx
  80245c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80245f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802462:	01 c8                	add    %ecx,%eax
  802464:	8a 00                	mov    (%eax),%al
  802466:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802468:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80246b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246e:	01 c2                	add    %eax,%edx
  802470:	8a 45 eb             	mov    -0x15(%ebp),%al
  802473:	88 02                	mov    %al,(%edx)
		start++ ;
  802475:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802478:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802481:	7c c4                	jl     802447 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802483:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802486:	8b 45 0c             	mov    0xc(%ebp),%eax
  802489:	01 d0                	add    %edx,%eax
  80248b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80248e:	90                   	nop
  80248f:	c9                   	leave  
  802490:	c3                   	ret    

00802491 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802497:	ff 75 08             	pushl  0x8(%ebp)
  80249a:	e8 73 fa ff ff       	call   801f12 <strlen>
  80249f:	83 c4 04             	add    $0x4,%esp
  8024a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8024a5:	ff 75 0c             	pushl  0xc(%ebp)
  8024a8:	e8 65 fa ff ff       	call   801f12 <strlen>
  8024ad:	83 c4 04             	add    $0x4,%esp
  8024b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8024b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8024ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024c1:	eb 17                	jmp    8024da <strcconcat+0x49>
		final[s] = str1[s] ;
  8024c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c9:	01 c2                	add    %eax,%edx
  8024cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d1:	01 c8                	add    %ecx,%eax
  8024d3:	8a 00                	mov    (%eax),%al
  8024d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8024d7:	ff 45 fc             	incl   -0x4(%ebp)
  8024da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024e0:	7c e1                	jl     8024c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8024e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8024e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8024f0:	eb 1f                	jmp    802511 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8024f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024f5:	8d 50 01             	lea    0x1(%eax),%edx
  8024f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8024fb:	89 c2                	mov    %eax,%edx
  8024fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802500:	01 c2                	add    %eax,%edx
  802502:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802505:	8b 45 0c             	mov    0xc(%ebp),%eax
  802508:	01 c8                	add    %ecx,%eax
  80250a:	8a 00                	mov    (%eax),%al
  80250c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80250e:	ff 45 f8             	incl   -0x8(%ebp)
  802511:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802514:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802517:	7c d9                	jl     8024f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802519:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80251c:	8b 45 10             	mov    0x10(%ebp),%eax
  80251f:	01 d0                	add    %edx,%eax
  802521:	c6 00 00             	movb   $0x0,(%eax)
}
  802524:	90                   	nop
  802525:	c9                   	leave  
  802526:	c3                   	ret    

00802527 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802527:	55                   	push   %ebp
  802528:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80252a:	8b 45 14             	mov    0x14(%ebp),%eax
  80252d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802533:	8b 45 14             	mov    0x14(%ebp),%eax
  802536:	8b 00                	mov    (%eax),%eax
  802538:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80253f:	8b 45 10             	mov    0x10(%ebp),%eax
  802542:	01 d0                	add    %edx,%eax
  802544:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80254a:	eb 0c                	jmp    802558 <strsplit+0x31>
			*string++ = 0;
  80254c:	8b 45 08             	mov    0x8(%ebp),%eax
  80254f:	8d 50 01             	lea    0x1(%eax),%edx
  802552:	89 55 08             	mov    %edx,0x8(%ebp)
  802555:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802558:	8b 45 08             	mov    0x8(%ebp),%eax
  80255b:	8a 00                	mov    (%eax),%al
  80255d:	84 c0                	test   %al,%al
  80255f:	74 18                	je     802579 <strsplit+0x52>
  802561:	8b 45 08             	mov    0x8(%ebp),%eax
  802564:	8a 00                	mov    (%eax),%al
  802566:	0f be c0             	movsbl %al,%eax
  802569:	50                   	push   %eax
  80256a:	ff 75 0c             	pushl  0xc(%ebp)
  80256d:	e8 32 fb ff ff       	call   8020a4 <strchr>
  802572:	83 c4 08             	add    $0x8,%esp
  802575:	85 c0                	test   %eax,%eax
  802577:	75 d3                	jne    80254c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	8a 00                	mov    (%eax),%al
  80257e:	84 c0                	test   %al,%al
  802580:	74 5a                	je     8025dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802582:	8b 45 14             	mov    0x14(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	83 f8 0f             	cmp    $0xf,%eax
  80258a:	75 07                	jne    802593 <strsplit+0x6c>
		{
			return 0;
  80258c:	b8 00 00 00 00       	mov    $0x0,%eax
  802591:	eb 66                	jmp    8025f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802593:	8b 45 14             	mov    0x14(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	8d 48 01             	lea    0x1(%eax),%ecx
  80259b:	8b 55 14             	mov    0x14(%ebp),%edx
  80259e:	89 0a                	mov    %ecx,(%edx)
  8025a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8025aa:	01 c2                	add    %eax,%edx
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025b1:	eb 03                	jmp    8025b6 <strsplit+0x8f>
			string++;
  8025b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b9:	8a 00                	mov    (%eax),%al
  8025bb:	84 c0                	test   %al,%al
  8025bd:	74 8b                	je     80254a <strsplit+0x23>
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	8a 00                	mov    (%eax),%al
  8025c4:	0f be c0             	movsbl %al,%eax
  8025c7:	50                   	push   %eax
  8025c8:	ff 75 0c             	pushl  0xc(%ebp)
  8025cb:	e8 d4 fa ff ff       	call   8020a4 <strchr>
  8025d0:	83 c4 08             	add    $0x8,%esp
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	74 dc                	je     8025b3 <strsplit+0x8c>
			string++;
	}
  8025d7:	e9 6e ff ff ff       	jmp    80254a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8025dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8025dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8025e0:	8b 00                	mov    (%eax),%eax
  8025e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ec:	01 d0                	add    %edx,%eax
  8025ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8025f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025f9:	c9                   	leave  
  8025fa:	c3                   	ret    

008025fb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
  8025fe:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  802601:	83 ec 04             	sub    $0x4,%esp
  802604:	68 08 38 80 00       	push   $0x803808
  802609:	68 3f 01 00 00       	push   $0x13f
  80260e:	68 2a 38 80 00       	push   $0x80382a
  802613:	e8 a9 ef ff ff       	call   8015c1 <_panic>

00802618 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  802618:	55                   	push   %ebp
  802619:	89 e5                	mov    %esp,%ebp
  80261b:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80261e:	83 ec 0c             	sub    $0xc,%esp
  802621:	ff 75 08             	pushl  0x8(%ebp)
  802624:	e8 ef 06 00 00       	call   802d18 <sys_sbrk>
  802629:	83 c4 10             	add    $0x10,%esp
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
  802631:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802634:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802638:	75 07                	jne    802641 <malloc+0x13>
  80263a:	b8 00 00 00 00       	mov    $0x0,%eax
  80263f:	eb 14                	jmp    802655 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  802641:	83 ec 04             	sub    $0x4,%esp
  802644:	68 38 38 80 00       	push   $0x803838
  802649:	6a 1b                	push   $0x1b
  80264b:	68 5d 38 80 00       	push   $0x80385d
  802650:	e8 6c ef ff ff       	call   8015c1 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
  80265a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80265d:	83 ec 04             	sub    $0x4,%esp
  802660:	68 6c 38 80 00       	push   $0x80386c
  802665:	6a 29                	push   $0x29
  802667:	68 5d 38 80 00       	push   $0x80385d
  80266c:	e8 50 ef ff ff       	call   8015c1 <_panic>

00802671 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
  802674:	83 ec 18             	sub    $0x18,%esp
  802677:	8b 45 10             	mov    0x10(%ebp),%eax
  80267a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80267d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802681:	75 07                	jne    80268a <smalloc+0x19>
  802683:	b8 00 00 00 00       	mov    $0x0,%eax
  802688:	eb 14                	jmp    80269e <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80268a:	83 ec 04             	sub    $0x4,%esp
  80268d:	68 90 38 80 00       	push   $0x803890
  802692:	6a 38                	push   $0x38
  802694:	68 5d 38 80 00       	push   $0x80385d
  802699:	e8 23 ef ff ff       	call   8015c1 <_panic>
	return NULL;
}
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
  8026a3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8026a6:	83 ec 04             	sub    $0x4,%esp
  8026a9:	68 b8 38 80 00       	push   $0x8038b8
  8026ae:	6a 43                	push   $0x43
  8026b0:	68 5d 38 80 00       	push   $0x80385d
  8026b5:	e8 07 ef ff ff       	call   8015c1 <_panic>

008026ba <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
  8026bd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8026c0:	83 ec 04             	sub    $0x4,%esp
  8026c3:	68 dc 38 80 00       	push   $0x8038dc
  8026c8:	6a 5b                	push   $0x5b
  8026ca:	68 5d 38 80 00       	push   $0x80385d
  8026cf:	e8 ed ee ff ff       	call   8015c1 <_panic>

008026d4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8026da:	83 ec 04             	sub    $0x4,%esp
  8026dd:	68 00 39 80 00       	push   $0x803900
  8026e2:	6a 72                	push   $0x72
  8026e4:	68 5d 38 80 00       	push   $0x80385d
  8026e9:	e8 d3 ee ff ff       	call   8015c1 <_panic>

008026ee <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
  8026f1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026f4:	83 ec 04             	sub    $0x4,%esp
  8026f7:	68 26 39 80 00       	push   $0x803926
  8026fc:	6a 7e                	push   $0x7e
  8026fe:	68 5d 38 80 00       	push   $0x80385d
  802703:	e8 b9 ee ff ff       	call   8015c1 <_panic>

00802708 <shrink>:

}
void shrink(uint32 newSize)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80270e:	83 ec 04             	sub    $0x4,%esp
  802711:	68 26 39 80 00       	push   $0x803926
  802716:	68 83 00 00 00       	push   $0x83
  80271b:	68 5d 38 80 00       	push   $0x80385d
  802720:	e8 9c ee ff ff       	call   8015c1 <_panic>

00802725 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802725:	55                   	push   %ebp
  802726:	89 e5                	mov    %esp,%ebp
  802728:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80272b:	83 ec 04             	sub    $0x4,%esp
  80272e:	68 26 39 80 00       	push   $0x803926
  802733:	68 88 00 00 00       	push   $0x88
  802738:	68 5d 38 80 00       	push   $0x80385d
  80273d:	e8 7f ee ff ff       	call   8015c1 <_panic>

00802742 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802742:	55                   	push   %ebp
  802743:	89 e5                	mov    %esp,%ebp
  802745:	57                   	push   %edi
  802746:	56                   	push   %esi
  802747:	53                   	push   %ebx
  802748:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802751:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802754:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802757:	8b 7d 18             	mov    0x18(%ebp),%edi
  80275a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80275d:	cd 30                	int    $0x30
  80275f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802762:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802765:	83 c4 10             	add    $0x10,%esp
  802768:	5b                   	pop    %ebx
  802769:	5e                   	pop    %esi
  80276a:	5f                   	pop    %edi
  80276b:	5d                   	pop    %ebp
  80276c:	c3                   	ret    

0080276d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80276d:	55                   	push   %ebp
  80276e:	89 e5                	mov    %esp,%ebp
  802770:	83 ec 04             	sub    $0x4,%esp
  802773:	8b 45 10             	mov    0x10(%ebp),%eax
  802776:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802779:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80277d:	8b 45 08             	mov    0x8(%ebp),%eax
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	52                   	push   %edx
  802785:	ff 75 0c             	pushl  0xc(%ebp)
  802788:	50                   	push   %eax
  802789:	6a 00                	push   $0x0
  80278b:	e8 b2 ff ff ff       	call   802742 <syscall>
  802790:	83 c4 18             	add    $0x18,%esp
}
  802793:	90                   	nop
  802794:	c9                   	leave  
  802795:	c3                   	ret    

00802796 <sys_cgetc>:

int
sys_cgetc(void)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802799:	6a 00                	push   $0x0
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 02                	push   $0x2
  8027a5:	e8 98 ff ff ff       	call   802742 <syscall>
  8027aa:	83 c4 18             	add    $0x18,%esp
}
  8027ad:	c9                   	leave  
  8027ae:	c3                   	ret    

008027af <sys_lock_cons>:

void sys_lock_cons(void)
{
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8027b2:	6a 00                	push   $0x0
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 00                	push   $0x0
  8027ba:	6a 00                	push   $0x0
  8027bc:	6a 03                	push   $0x3
  8027be:	e8 7f ff ff ff       	call   802742 <syscall>
  8027c3:	83 c4 18             	add    $0x18,%esp
}
  8027c6:	90                   	nop
  8027c7:	c9                   	leave  
  8027c8:	c3                   	ret    

008027c9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 04                	push   $0x4
  8027d8:	e8 65 ff ff ff       	call   802742 <syscall>
  8027dd:	83 c4 18             	add    $0x18,%esp
}
  8027e0:	90                   	nop
  8027e1:	c9                   	leave  
  8027e2:	c3                   	ret    

008027e3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8027e3:	55                   	push   %ebp
  8027e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8027e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ec:	6a 00                	push   $0x0
  8027ee:	6a 00                	push   $0x0
  8027f0:	6a 00                	push   $0x0
  8027f2:	52                   	push   %edx
  8027f3:	50                   	push   %eax
  8027f4:	6a 08                	push   $0x8
  8027f6:	e8 47 ff ff ff       	call   802742 <syscall>
  8027fb:	83 c4 18             	add    $0x18,%esp
}
  8027fe:	c9                   	leave  
  8027ff:	c3                   	ret    

00802800 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	56                   	push   %esi
  802804:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802805:	8b 75 18             	mov    0x18(%ebp),%esi
  802808:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80280b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80280e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802811:	8b 45 08             	mov    0x8(%ebp),%eax
  802814:	56                   	push   %esi
  802815:	53                   	push   %ebx
  802816:	51                   	push   %ecx
  802817:	52                   	push   %edx
  802818:	50                   	push   %eax
  802819:	6a 09                	push   $0x9
  80281b:	e8 22 ff ff ff       	call   802742 <syscall>
  802820:	83 c4 18             	add    $0x18,%esp
}
  802823:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802826:	5b                   	pop    %ebx
  802827:	5e                   	pop    %esi
  802828:	5d                   	pop    %ebp
  802829:	c3                   	ret    

0080282a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80282d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802830:	8b 45 08             	mov    0x8(%ebp),%eax
  802833:	6a 00                	push   $0x0
  802835:	6a 00                	push   $0x0
  802837:	6a 00                	push   $0x0
  802839:	52                   	push   %edx
  80283a:	50                   	push   %eax
  80283b:	6a 0a                	push   $0xa
  80283d:	e8 00 ff ff ff       	call   802742 <syscall>
  802842:	83 c4 18             	add    $0x18,%esp
}
  802845:	c9                   	leave  
  802846:	c3                   	ret    

00802847 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802847:	55                   	push   %ebp
  802848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80284a:	6a 00                	push   $0x0
  80284c:	6a 00                	push   $0x0
  80284e:	6a 00                	push   $0x0
  802850:	ff 75 0c             	pushl  0xc(%ebp)
  802853:	ff 75 08             	pushl  0x8(%ebp)
  802856:	6a 0b                	push   $0xb
  802858:	e8 e5 fe ff ff       	call   802742 <syscall>
  80285d:	83 c4 18             	add    $0x18,%esp
}
  802860:	c9                   	leave  
  802861:	c3                   	ret    

00802862 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 0c                	push   $0xc
  802871:	e8 cc fe ff ff       	call   802742 <syscall>
  802876:	83 c4 18             	add    $0x18,%esp
}
  802879:	c9                   	leave  
  80287a:	c3                   	ret    

0080287b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80287e:	6a 00                	push   $0x0
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 0d                	push   $0xd
  80288a:	e8 b3 fe ff ff       	call   802742 <syscall>
  80288f:	83 c4 18             	add    $0x18,%esp
}
  802892:	c9                   	leave  
  802893:	c3                   	ret    

00802894 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802894:	55                   	push   %ebp
  802895:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802897:	6a 00                	push   $0x0
  802899:	6a 00                	push   $0x0
  80289b:	6a 00                	push   $0x0
  80289d:	6a 00                	push   $0x0
  80289f:	6a 00                	push   $0x0
  8028a1:	6a 0e                	push   $0xe
  8028a3:	e8 9a fe ff ff       	call   802742 <syscall>
  8028a8:	83 c4 18             	add    $0x18,%esp
}
  8028ab:	c9                   	leave  
  8028ac:	c3                   	ret    

008028ad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8028ad:	55                   	push   %ebp
  8028ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 0f                	push   $0xf
  8028bc:	e8 81 fe ff ff       	call   802742 <syscall>
  8028c1:	83 c4 18             	add    $0x18,%esp
}
  8028c4:	c9                   	leave  
  8028c5:	c3                   	ret    

008028c6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8028c9:	6a 00                	push   $0x0
  8028cb:	6a 00                	push   $0x0
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	ff 75 08             	pushl  0x8(%ebp)
  8028d4:	6a 10                	push   $0x10
  8028d6:	e8 67 fe ff ff       	call   802742 <syscall>
  8028db:	83 c4 18             	add    $0x18,%esp
}
  8028de:	c9                   	leave  
  8028df:	c3                   	ret    

008028e0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8028e3:	6a 00                	push   $0x0
  8028e5:	6a 00                	push   $0x0
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 11                	push   $0x11
  8028ef:	e8 4e fe ff ff       	call   802742 <syscall>
  8028f4:	83 c4 18             	add    $0x18,%esp
}
  8028f7:	90                   	nop
  8028f8:	c9                   	leave  
  8028f9:	c3                   	ret    

008028fa <sys_cputc>:

void
sys_cputc(const char c)
{
  8028fa:	55                   	push   %ebp
  8028fb:	89 e5                	mov    %esp,%ebp
  8028fd:	83 ec 04             	sub    $0x4,%esp
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802906:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80290a:	6a 00                	push   $0x0
  80290c:	6a 00                	push   $0x0
  80290e:	6a 00                	push   $0x0
  802910:	6a 00                	push   $0x0
  802912:	50                   	push   %eax
  802913:	6a 01                	push   $0x1
  802915:	e8 28 fe ff ff       	call   802742 <syscall>
  80291a:	83 c4 18             	add    $0x18,%esp
}
  80291d:	90                   	nop
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802923:	6a 00                	push   $0x0
  802925:	6a 00                	push   $0x0
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	6a 14                	push   $0x14
  80292f:	e8 0e fe ff ff       	call   802742 <syscall>
  802934:	83 c4 18             	add    $0x18,%esp
}
  802937:	90                   	nop
  802938:	c9                   	leave  
  802939:	c3                   	ret    

0080293a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	83 ec 04             	sub    $0x4,%esp
  802940:	8b 45 10             	mov    0x10(%ebp),%eax
  802943:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802946:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802949:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80294d:	8b 45 08             	mov    0x8(%ebp),%eax
  802950:	6a 00                	push   $0x0
  802952:	51                   	push   %ecx
  802953:	52                   	push   %edx
  802954:	ff 75 0c             	pushl  0xc(%ebp)
  802957:	50                   	push   %eax
  802958:	6a 15                	push   $0x15
  80295a:	e8 e3 fd ff ff       	call   802742 <syscall>
  80295f:	83 c4 18             	add    $0x18,%esp
}
  802962:	c9                   	leave  
  802963:	c3                   	ret    

00802964 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802964:	55                   	push   %ebp
  802965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	6a 00                	push   $0x0
  80296f:	6a 00                	push   $0x0
  802971:	6a 00                	push   $0x0
  802973:	52                   	push   %edx
  802974:	50                   	push   %eax
  802975:	6a 16                	push   $0x16
  802977:	e8 c6 fd ff ff       	call   802742 <syscall>
  80297c:	83 c4 18             	add    $0x18,%esp
}
  80297f:	c9                   	leave  
  802980:	c3                   	ret    

00802981 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802981:	55                   	push   %ebp
  802982:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802984:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802987:	8b 55 0c             	mov    0xc(%ebp),%edx
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	6a 00                	push   $0x0
  80298f:	6a 00                	push   $0x0
  802991:	51                   	push   %ecx
  802992:	52                   	push   %edx
  802993:	50                   	push   %eax
  802994:	6a 17                	push   $0x17
  802996:	e8 a7 fd ff ff       	call   802742 <syscall>
  80299b:	83 c4 18             	add    $0x18,%esp
}
  80299e:	c9                   	leave  
  80299f:	c3                   	ret    

008029a0 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8029a0:	55                   	push   %ebp
  8029a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8029a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	6a 00                	push   $0x0
  8029ab:	6a 00                	push   $0x0
  8029ad:	6a 00                	push   $0x0
  8029af:	52                   	push   %edx
  8029b0:	50                   	push   %eax
  8029b1:	6a 18                	push   $0x18
  8029b3:	e8 8a fd ff ff       	call   802742 <syscall>
  8029b8:	83 c4 18             	add    $0x18,%esp
}
  8029bb:	c9                   	leave  
  8029bc:	c3                   	ret    

008029bd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8029bd:	55                   	push   %ebp
  8029be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	6a 00                	push   $0x0
  8029c5:	ff 75 14             	pushl  0x14(%ebp)
  8029c8:	ff 75 10             	pushl  0x10(%ebp)
  8029cb:	ff 75 0c             	pushl  0xc(%ebp)
  8029ce:	50                   	push   %eax
  8029cf:	6a 19                	push   $0x19
  8029d1:	e8 6c fd ff ff       	call   802742 <syscall>
  8029d6:	83 c4 18             	add    $0x18,%esp
}
  8029d9:	c9                   	leave  
  8029da:	c3                   	ret    

008029db <sys_run_env>:

void sys_run_env(int32 envId)
{
  8029db:	55                   	push   %ebp
  8029dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8029de:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e1:	6a 00                	push   $0x0
  8029e3:	6a 00                	push   $0x0
  8029e5:	6a 00                	push   $0x0
  8029e7:	6a 00                	push   $0x0
  8029e9:	50                   	push   %eax
  8029ea:	6a 1a                	push   $0x1a
  8029ec:	e8 51 fd ff ff       	call   802742 <syscall>
  8029f1:	83 c4 18             	add    $0x18,%esp
}
  8029f4:	90                   	nop
  8029f5:	c9                   	leave  
  8029f6:	c3                   	ret    

008029f7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	6a 00                	push   $0x0
  8029ff:	6a 00                	push   $0x0
  802a01:	6a 00                	push   $0x0
  802a03:	6a 00                	push   $0x0
  802a05:	50                   	push   %eax
  802a06:	6a 1b                	push   $0x1b
  802a08:	e8 35 fd ff ff       	call   802742 <syscall>
  802a0d:	83 c4 18             	add    $0x18,%esp
}
  802a10:	c9                   	leave  
  802a11:	c3                   	ret    

00802a12 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802a12:	55                   	push   %ebp
  802a13:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802a15:	6a 00                	push   $0x0
  802a17:	6a 00                	push   $0x0
  802a19:	6a 00                	push   $0x0
  802a1b:	6a 00                	push   $0x0
  802a1d:	6a 00                	push   $0x0
  802a1f:	6a 05                	push   $0x5
  802a21:	e8 1c fd ff ff       	call   802742 <syscall>
  802a26:	83 c4 18             	add    $0x18,%esp
}
  802a29:	c9                   	leave  
  802a2a:	c3                   	ret    

00802a2b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802a2b:	55                   	push   %ebp
  802a2c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 00                	push   $0x0
  802a32:	6a 00                	push   $0x0
  802a34:	6a 00                	push   $0x0
  802a36:	6a 00                	push   $0x0
  802a38:	6a 06                	push   $0x6
  802a3a:	e8 03 fd ff ff       	call   802742 <syscall>
  802a3f:	83 c4 18             	add    $0x18,%esp
}
  802a42:	c9                   	leave  
  802a43:	c3                   	ret    

00802a44 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802a44:	55                   	push   %ebp
  802a45:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802a47:	6a 00                	push   $0x0
  802a49:	6a 00                	push   $0x0
  802a4b:	6a 00                	push   $0x0
  802a4d:	6a 00                	push   $0x0
  802a4f:	6a 00                	push   $0x0
  802a51:	6a 07                	push   $0x7
  802a53:	e8 ea fc ff ff       	call   802742 <syscall>
  802a58:	83 c4 18             	add    $0x18,%esp
}
  802a5b:	c9                   	leave  
  802a5c:	c3                   	ret    

00802a5d <sys_exit_env>:


void sys_exit_env(void)
{
  802a5d:	55                   	push   %ebp
  802a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a60:	6a 00                	push   $0x0
  802a62:	6a 00                	push   $0x0
  802a64:	6a 00                	push   $0x0
  802a66:	6a 00                	push   $0x0
  802a68:	6a 00                	push   $0x0
  802a6a:	6a 1c                	push   $0x1c
  802a6c:	e8 d1 fc ff ff       	call   802742 <syscall>
  802a71:	83 c4 18             	add    $0x18,%esp
}
  802a74:	90                   	nop
  802a75:	c9                   	leave  
  802a76:	c3                   	ret    

00802a77 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802a77:	55                   	push   %ebp
  802a78:	89 e5                	mov    %esp,%ebp
  802a7a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802a7d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a80:	8d 50 04             	lea    0x4(%eax),%edx
  802a83:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a86:	6a 00                	push   $0x0
  802a88:	6a 00                	push   $0x0
  802a8a:	6a 00                	push   $0x0
  802a8c:	52                   	push   %edx
  802a8d:	50                   	push   %eax
  802a8e:	6a 1d                	push   $0x1d
  802a90:	e8 ad fc ff ff       	call   802742 <syscall>
  802a95:	83 c4 18             	add    $0x18,%esp
	return result;
  802a98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802aa1:	89 01                	mov    %eax,(%ecx)
  802aa3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa9:	c9                   	leave  
  802aaa:	c2 04 00             	ret    $0x4

00802aad <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802aad:	55                   	push   %ebp
  802aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	ff 75 10             	pushl  0x10(%ebp)
  802ab7:	ff 75 0c             	pushl  0xc(%ebp)
  802aba:	ff 75 08             	pushl  0x8(%ebp)
  802abd:	6a 13                	push   $0x13
  802abf:	e8 7e fc ff ff       	call   802742 <syscall>
  802ac4:	83 c4 18             	add    $0x18,%esp
	return ;
  802ac7:	90                   	nop
}
  802ac8:	c9                   	leave  
  802ac9:	c3                   	ret    

00802aca <sys_rcr2>:
uint32 sys_rcr2()
{
  802aca:	55                   	push   %ebp
  802acb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802acd:	6a 00                	push   $0x0
  802acf:	6a 00                	push   $0x0
  802ad1:	6a 00                	push   $0x0
  802ad3:	6a 00                	push   $0x0
  802ad5:	6a 00                	push   $0x0
  802ad7:	6a 1e                	push   $0x1e
  802ad9:	e8 64 fc ff ff       	call   802742 <syscall>
  802ade:	83 c4 18             	add    $0x18,%esp
}
  802ae1:	c9                   	leave  
  802ae2:	c3                   	ret    

00802ae3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802ae3:	55                   	push   %ebp
  802ae4:	89 e5                	mov    %esp,%ebp
  802ae6:	83 ec 04             	sub    $0x4,%esp
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802aef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802af3:	6a 00                	push   $0x0
  802af5:	6a 00                	push   $0x0
  802af7:	6a 00                	push   $0x0
  802af9:	6a 00                	push   $0x0
  802afb:	50                   	push   %eax
  802afc:	6a 1f                	push   $0x1f
  802afe:	e8 3f fc ff ff       	call   802742 <syscall>
  802b03:	83 c4 18             	add    $0x18,%esp
	return ;
  802b06:	90                   	nop
}
  802b07:	c9                   	leave  
  802b08:	c3                   	ret    

00802b09 <rsttst>:
void rsttst()
{
  802b09:	55                   	push   %ebp
  802b0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802b0c:	6a 00                	push   $0x0
  802b0e:	6a 00                	push   $0x0
  802b10:	6a 00                	push   $0x0
  802b12:	6a 00                	push   $0x0
  802b14:	6a 00                	push   $0x0
  802b16:	6a 21                	push   $0x21
  802b18:	e8 25 fc ff ff       	call   802742 <syscall>
  802b1d:	83 c4 18             	add    $0x18,%esp
	return ;
  802b20:	90                   	nop
}
  802b21:	c9                   	leave  
  802b22:	c3                   	ret    

00802b23 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802b23:	55                   	push   %ebp
  802b24:	89 e5                	mov    %esp,%ebp
  802b26:	83 ec 04             	sub    $0x4,%esp
  802b29:	8b 45 14             	mov    0x14(%ebp),%eax
  802b2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802b2f:	8b 55 18             	mov    0x18(%ebp),%edx
  802b32:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b36:	52                   	push   %edx
  802b37:	50                   	push   %eax
  802b38:	ff 75 10             	pushl  0x10(%ebp)
  802b3b:	ff 75 0c             	pushl  0xc(%ebp)
  802b3e:	ff 75 08             	pushl  0x8(%ebp)
  802b41:	6a 20                	push   $0x20
  802b43:	e8 fa fb ff ff       	call   802742 <syscall>
  802b48:	83 c4 18             	add    $0x18,%esp
	return ;
  802b4b:	90                   	nop
}
  802b4c:	c9                   	leave  
  802b4d:	c3                   	ret    

00802b4e <chktst>:
void chktst(uint32 n)
{
  802b4e:	55                   	push   %ebp
  802b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b51:	6a 00                	push   $0x0
  802b53:	6a 00                	push   $0x0
  802b55:	6a 00                	push   $0x0
  802b57:	6a 00                	push   $0x0
  802b59:	ff 75 08             	pushl  0x8(%ebp)
  802b5c:	6a 22                	push   $0x22
  802b5e:	e8 df fb ff ff       	call   802742 <syscall>
  802b63:	83 c4 18             	add    $0x18,%esp
	return ;
  802b66:	90                   	nop
}
  802b67:	c9                   	leave  
  802b68:	c3                   	ret    

00802b69 <inctst>:

void inctst()
{
  802b69:	55                   	push   %ebp
  802b6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 23                	push   $0x23
  802b78:	e8 c5 fb ff ff       	call   802742 <syscall>
  802b7d:	83 c4 18             	add    $0x18,%esp
	return ;
  802b80:	90                   	nop
}
  802b81:	c9                   	leave  
  802b82:	c3                   	ret    

00802b83 <gettst>:
uint32 gettst()
{
  802b83:	55                   	push   %ebp
  802b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802b86:	6a 00                	push   $0x0
  802b88:	6a 00                	push   $0x0
  802b8a:	6a 00                	push   $0x0
  802b8c:	6a 00                	push   $0x0
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 24                	push   $0x24
  802b92:	e8 ab fb ff ff       	call   802742 <syscall>
  802b97:	83 c4 18             	add    $0x18,%esp
}
  802b9a:	c9                   	leave  
  802b9b:	c3                   	ret    

00802b9c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802b9c:	55                   	push   %ebp
  802b9d:	89 e5                	mov    %esp,%ebp
  802b9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ba2:	6a 00                	push   $0x0
  802ba4:	6a 00                	push   $0x0
  802ba6:	6a 00                	push   $0x0
  802ba8:	6a 00                	push   $0x0
  802baa:	6a 00                	push   $0x0
  802bac:	6a 25                	push   $0x25
  802bae:	e8 8f fb ff ff       	call   802742 <syscall>
  802bb3:	83 c4 18             	add    $0x18,%esp
  802bb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802bb9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802bbd:	75 07                	jne    802bc6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802bbf:	b8 01 00 00 00       	mov    $0x1,%eax
  802bc4:	eb 05                	jmp    802bcb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802bc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bcb:	c9                   	leave  
  802bcc:	c3                   	ret    

00802bcd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802bcd:	55                   	push   %ebp
  802bce:	89 e5                	mov    %esp,%ebp
  802bd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bd3:	6a 00                	push   $0x0
  802bd5:	6a 00                	push   $0x0
  802bd7:	6a 00                	push   $0x0
  802bd9:	6a 00                	push   $0x0
  802bdb:	6a 00                	push   $0x0
  802bdd:	6a 25                	push   $0x25
  802bdf:	e8 5e fb ff ff       	call   802742 <syscall>
  802be4:	83 c4 18             	add    $0x18,%esp
  802be7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802bea:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802bee:	75 07                	jne    802bf7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802bf0:	b8 01 00 00 00       	mov    $0x1,%eax
  802bf5:	eb 05                	jmp    802bfc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802bf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bfc:	c9                   	leave  
  802bfd:	c3                   	ret    

00802bfe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802bfe:	55                   	push   %ebp
  802bff:	89 e5                	mov    %esp,%ebp
  802c01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c04:	6a 00                	push   $0x0
  802c06:	6a 00                	push   $0x0
  802c08:	6a 00                	push   $0x0
  802c0a:	6a 00                	push   $0x0
  802c0c:	6a 00                	push   $0x0
  802c0e:	6a 25                	push   $0x25
  802c10:	e8 2d fb ff ff       	call   802742 <syscall>
  802c15:	83 c4 18             	add    $0x18,%esp
  802c18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802c1b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802c1f:	75 07                	jne    802c28 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802c21:	b8 01 00 00 00       	mov    $0x1,%eax
  802c26:	eb 05                	jmp    802c2d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802c28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c2d:	c9                   	leave  
  802c2e:	c3                   	ret    

00802c2f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802c2f:	55                   	push   %ebp
  802c30:	89 e5                	mov    %esp,%ebp
  802c32:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c35:	6a 00                	push   $0x0
  802c37:	6a 00                	push   $0x0
  802c39:	6a 00                	push   $0x0
  802c3b:	6a 00                	push   $0x0
  802c3d:	6a 00                	push   $0x0
  802c3f:	6a 25                	push   $0x25
  802c41:	e8 fc fa ff ff       	call   802742 <syscall>
  802c46:	83 c4 18             	add    $0x18,%esp
  802c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802c4c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802c50:	75 07                	jne    802c59 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802c52:	b8 01 00 00 00       	mov    $0x1,%eax
  802c57:	eb 05                	jmp    802c5e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802c59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5e:	c9                   	leave  
  802c5f:	c3                   	ret    

00802c60 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c60:	55                   	push   %ebp
  802c61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802c63:	6a 00                	push   $0x0
  802c65:	6a 00                	push   $0x0
  802c67:	6a 00                	push   $0x0
  802c69:	6a 00                	push   $0x0
  802c6b:	ff 75 08             	pushl  0x8(%ebp)
  802c6e:	6a 26                	push   $0x26
  802c70:	e8 cd fa ff ff       	call   802742 <syscall>
  802c75:	83 c4 18             	add    $0x18,%esp
	return ;
  802c78:	90                   	nop
}
  802c79:	c9                   	leave  
  802c7a:	c3                   	ret    

00802c7b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802c7b:	55                   	push   %ebp
  802c7c:	89 e5                	mov    %esp,%ebp
  802c7e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802c7f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	6a 00                	push   $0x0
  802c8d:	53                   	push   %ebx
  802c8e:	51                   	push   %ecx
  802c8f:	52                   	push   %edx
  802c90:	50                   	push   %eax
  802c91:	6a 27                	push   $0x27
  802c93:	e8 aa fa ff ff       	call   802742 <syscall>
  802c98:	83 c4 18             	add    $0x18,%esp
}
  802c9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c9e:	c9                   	leave  
  802c9f:	c3                   	ret    

00802ca0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802ca0:	55                   	push   %ebp
  802ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	6a 00                	push   $0x0
  802cab:	6a 00                	push   $0x0
  802cad:	6a 00                	push   $0x0
  802caf:	52                   	push   %edx
  802cb0:	50                   	push   %eax
  802cb1:	6a 28                	push   $0x28
  802cb3:	e8 8a fa ff ff       	call   802742 <syscall>
  802cb8:	83 c4 18             	add    $0x18,%esp
}
  802cbb:	c9                   	leave  
  802cbc:	c3                   	ret    

00802cbd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802cbd:	55                   	push   %ebp
  802cbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802cc0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	6a 00                	push   $0x0
  802ccb:	51                   	push   %ecx
  802ccc:	ff 75 10             	pushl  0x10(%ebp)
  802ccf:	52                   	push   %edx
  802cd0:	50                   	push   %eax
  802cd1:	6a 29                	push   $0x29
  802cd3:	e8 6a fa ff ff       	call   802742 <syscall>
  802cd8:	83 c4 18             	add    $0x18,%esp
}
  802cdb:	c9                   	leave  
  802cdc:	c3                   	ret    

00802cdd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802cdd:	55                   	push   %ebp
  802cde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802ce0:	6a 00                	push   $0x0
  802ce2:	6a 00                	push   $0x0
  802ce4:	ff 75 10             	pushl  0x10(%ebp)
  802ce7:	ff 75 0c             	pushl  0xc(%ebp)
  802cea:	ff 75 08             	pushl  0x8(%ebp)
  802ced:	6a 12                	push   $0x12
  802cef:	e8 4e fa ff ff       	call   802742 <syscall>
  802cf4:	83 c4 18             	add    $0x18,%esp
	return ;
  802cf7:	90                   	nop
}
  802cf8:	c9                   	leave  
  802cf9:	c3                   	ret    

00802cfa <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802cfa:	55                   	push   %ebp
  802cfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	6a 00                	push   $0x0
  802d05:	6a 00                	push   $0x0
  802d07:	6a 00                	push   $0x0
  802d09:	52                   	push   %edx
  802d0a:	50                   	push   %eax
  802d0b:	6a 2a                	push   $0x2a
  802d0d:	e8 30 fa ff ff       	call   802742 <syscall>
  802d12:	83 c4 18             	add    $0x18,%esp
	return;
  802d15:	90                   	nop
}
  802d16:	c9                   	leave  
  802d17:	c3                   	ret    

00802d18 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802d18:	55                   	push   %ebp
  802d19:	89 e5                	mov    %esp,%ebp
  802d1b:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802d1e:	83 ec 04             	sub    $0x4,%esp
  802d21:	68 36 39 80 00       	push   $0x803936
  802d26:	68 2e 01 00 00       	push   $0x12e
  802d2b:	68 4a 39 80 00       	push   $0x80394a
  802d30:	e8 8c e8 ff ff       	call   8015c1 <_panic>

00802d35 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802d35:	55                   	push   %ebp
  802d36:	89 e5                	mov    %esp,%ebp
  802d38:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802d3b:	83 ec 04             	sub    $0x4,%esp
  802d3e:	68 36 39 80 00       	push   $0x803936
  802d43:	68 35 01 00 00       	push   $0x135
  802d48:	68 4a 39 80 00       	push   $0x80394a
  802d4d:	e8 6f e8 ff ff       	call   8015c1 <_panic>

00802d52 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802d52:	55                   	push   %ebp
  802d53:	89 e5                	mov    %esp,%ebp
  802d55:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802d58:	83 ec 04             	sub    $0x4,%esp
  802d5b:	68 36 39 80 00       	push   $0x803936
  802d60:	68 3b 01 00 00       	push   $0x13b
  802d65:	68 4a 39 80 00       	push   $0x80394a
  802d6a:	e8 52 e8 ff ff       	call   8015c1 <_panic>
  802d6f:	90                   	nop

00802d70 <__udivdi3>:
  802d70:	55                   	push   %ebp
  802d71:	57                   	push   %edi
  802d72:	56                   	push   %esi
  802d73:	53                   	push   %ebx
  802d74:	83 ec 1c             	sub    $0x1c,%esp
  802d77:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d7b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d87:	89 ca                	mov    %ecx,%edx
  802d89:	89 f8                	mov    %edi,%eax
  802d8b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d8f:	85 f6                	test   %esi,%esi
  802d91:	75 2d                	jne    802dc0 <__udivdi3+0x50>
  802d93:	39 cf                	cmp    %ecx,%edi
  802d95:	77 65                	ja     802dfc <__udivdi3+0x8c>
  802d97:	89 fd                	mov    %edi,%ebp
  802d99:	85 ff                	test   %edi,%edi
  802d9b:	75 0b                	jne    802da8 <__udivdi3+0x38>
  802d9d:	b8 01 00 00 00       	mov    $0x1,%eax
  802da2:	31 d2                	xor    %edx,%edx
  802da4:	f7 f7                	div    %edi
  802da6:	89 c5                	mov    %eax,%ebp
  802da8:	31 d2                	xor    %edx,%edx
  802daa:	89 c8                	mov    %ecx,%eax
  802dac:	f7 f5                	div    %ebp
  802dae:	89 c1                	mov    %eax,%ecx
  802db0:	89 d8                	mov    %ebx,%eax
  802db2:	f7 f5                	div    %ebp
  802db4:	89 cf                	mov    %ecx,%edi
  802db6:	89 fa                	mov    %edi,%edx
  802db8:	83 c4 1c             	add    $0x1c,%esp
  802dbb:	5b                   	pop    %ebx
  802dbc:	5e                   	pop    %esi
  802dbd:	5f                   	pop    %edi
  802dbe:	5d                   	pop    %ebp
  802dbf:	c3                   	ret    
  802dc0:	39 ce                	cmp    %ecx,%esi
  802dc2:	77 28                	ja     802dec <__udivdi3+0x7c>
  802dc4:	0f bd fe             	bsr    %esi,%edi
  802dc7:	83 f7 1f             	xor    $0x1f,%edi
  802dca:	75 40                	jne    802e0c <__udivdi3+0x9c>
  802dcc:	39 ce                	cmp    %ecx,%esi
  802dce:	72 0a                	jb     802dda <__udivdi3+0x6a>
  802dd0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802dd4:	0f 87 9e 00 00 00    	ja     802e78 <__udivdi3+0x108>
  802dda:	b8 01 00 00 00       	mov    $0x1,%eax
  802ddf:	89 fa                	mov    %edi,%edx
  802de1:	83 c4 1c             	add    $0x1c,%esp
  802de4:	5b                   	pop    %ebx
  802de5:	5e                   	pop    %esi
  802de6:	5f                   	pop    %edi
  802de7:	5d                   	pop    %ebp
  802de8:	c3                   	ret    
  802de9:	8d 76 00             	lea    0x0(%esi),%esi
  802dec:	31 ff                	xor    %edi,%edi
  802dee:	31 c0                	xor    %eax,%eax
  802df0:	89 fa                	mov    %edi,%edx
  802df2:	83 c4 1c             	add    $0x1c,%esp
  802df5:	5b                   	pop    %ebx
  802df6:	5e                   	pop    %esi
  802df7:	5f                   	pop    %edi
  802df8:	5d                   	pop    %ebp
  802df9:	c3                   	ret    
  802dfa:	66 90                	xchg   %ax,%ax
  802dfc:	89 d8                	mov    %ebx,%eax
  802dfe:	f7 f7                	div    %edi
  802e00:	31 ff                	xor    %edi,%edi
  802e02:	89 fa                	mov    %edi,%edx
  802e04:	83 c4 1c             	add    $0x1c,%esp
  802e07:	5b                   	pop    %ebx
  802e08:	5e                   	pop    %esi
  802e09:	5f                   	pop    %edi
  802e0a:	5d                   	pop    %ebp
  802e0b:	c3                   	ret    
  802e0c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802e11:	89 eb                	mov    %ebp,%ebx
  802e13:	29 fb                	sub    %edi,%ebx
  802e15:	89 f9                	mov    %edi,%ecx
  802e17:	d3 e6                	shl    %cl,%esi
  802e19:	89 c5                	mov    %eax,%ebp
  802e1b:	88 d9                	mov    %bl,%cl
  802e1d:	d3 ed                	shr    %cl,%ebp
  802e1f:	89 e9                	mov    %ebp,%ecx
  802e21:	09 f1                	or     %esi,%ecx
  802e23:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e27:	89 f9                	mov    %edi,%ecx
  802e29:	d3 e0                	shl    %cl,%eax
  802e2b:	89 c5                	mov    %eax,%ebp
  802e2d:	89 d6                	mov    %edx,%esi
  802e2f:	88 d9                	mov    %bl,%cl
  802e31:	d3 ee                	shr    %cl,%esi
  802e33:	89 f9                	mov    %edi,%ecx
  802e35:	d3 e2                	shl    %cl,%edx
  802e37:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e3b:	88 d9                	mov    %bl,%cl
  802e3d:	d3 e8                	shr    %cl,%eax
  802e3f:	09 c2                	or     %eax,%edx
  802e41:	89 d0                	mov    %edx,%eax
  802e43:	89 f2                	mov    %esi,%edx
  802e45:	f7 74 24 0c          	divl   0xc(%esp)
  802e49:	89 d6                	mov    %edx,%esi
  802e4b:	89 c3                	mov    %eax,%ebx
  802e4d:	f7 e5                	mul    %ebp
  802e4f:	39 d6                	cmp    %edx,%esi
  802e51:	72 19                	jb     802e6c <__udivdi3+0xfc>
  802e53:	74 0b                	je     802e60 <__udivdi3+0xf0>
  802e55:	89 d8                	mov    %ebx,%eax
  802e57:	31 ff                	xor    %edi,%edi
  802e59:	e9 58 ff ff ff       	jmp    802db6 <__udivdi3+0x46>
  802e5e:	66 90                	xchg   %ax,%ax
  802e60:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e64:	89 f9                	mov    %edi,%ecx
  802e66:	d3 e2                	shl    %cl,%edx
  802e68:	39 c2                	cmp    %eax,%edx
  802e6a:	73 e9                	jae    802e55 <__udivdi3+0xe5>
  802e6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e6f:	31 ff                	xor    %edi,%edi
  802e71:	e9 40 ff ff ff       	jmp    802db6 <__udivdi3+0x46>
  802e76:	66 90                	xchg   %ax,%ax
  802e78:	31 c0                	xor    %eax,%eax
  802e7a:	e9 37 ff ff ff       	jmp    802db6 <__udivdi3+0x46>
  802e7f:	90                   	nop

00802e80 <__umoddi3>:
  802e80:	55                   	push   %ebp
  802e81:	57                   	push   %edi
  802e82:	56                   	push   %esi
  802e83:	53                   	push   %ebx
  802e84:	83 ec 1c             	sub    $0x1c,%esp
  802e87:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e8b:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e93:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e9b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e9f:	89 f3                	mov    %esi,%ebx
  802ea1:	89 fa                	mov    %edi,%edx
  802ea3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ea7:	89 34 24             	mov    %esi,(%esp)
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	75 1a                	jne    802ec8 <__umoddi3+0x48>
  802eae:	39 f7                	cmp    %esi,%edi
  802eb0:	0f 86 a2 00 00 00    	jbe    802f58 <__umoddi3+0xd8>
  802eb6:	89 c8                	mov    %ecx,%eax
  802eb8:	89 f2                	mov    %esi,%edx
  802eba:	f7 f7                	div    %edi
  802ebc:	89 d0                	mov    %edx,%eax
  802ebe:	31 d2                	xor    %edx,%edx
  802ec0:	83 c4 1c             	add    $0x1c,%esp
  802ec3:	5b                   	pop    %ebx
  802ec4:	5e                   	pop    %esi
  802ec5:	5f                   	pop    %edi
  802ec6:	5d                   	pop    %ebp
  802ec7:	c3                   	ret    
  802ec8:	39 f0                	cmp    %esi,%eax
  802eca:	0f 87 ac 00 00 00    	ja     802f7c <__umoddi3+0xfc>
  802ed0:	0f bd e8             	bsr    %eax,%ebp
  802ed3:	83 f5 1f             	xor    $0x1f,%ebp
  802ed6:	0f 84 ac 00 00 00    	je     802f88 <__umoddi3+0x108>
  802edc:	bf 20 00 00 00       	mov    $0x20,%edi
  802ee1:	29 ef                	sub    %ebp,%edi
  802ee3:	89 fe                	mov    %edi,%esi
  802ee5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ee9:	89 e9                	mov    %ebp,%ecx
  802eeb:	d3 e0                	shl    %cl,%eax
  802eed:	89 d7                	mov    %edx,%edi
  802eef:	89 f1                	mov    %esi,%ecx
  802ef1:	d3 ef                	shr    %cl,%edi
  802ef3:	09 c7                	or     %eax,%edi
  802ef5:	89 e9                	mov    %ebp,%ecx
  802ef7:	d3 e2                	shl    %cl,%edx
  802ef9:	89 14 24             	mov    %edx,(%esp)
  802efc:	89 d8                	mov    %ebx,%eax
  802efe:	d3 e0                	shl    %cl,%eax
  802f00:	89 c2                	mov    %eax,%edx
  802f02:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f06:	d3 e0                	shl    %cl,%eax
  802f08:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f0c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f10:	89 f1                	mov    %esi,%ecx
  802f12:	d3 e8                	shr    %cl,%eax
  802f14:	09 d0                	or     %edx,%eax
  802f16:	d3 eb                	shr    %cl,%ebx
  802f18:	89 da                	mov    %ebx,%edx
  802f1a:	f7 f7                	div    %edi
  802f1c:	89 d3                	mov    %edx,%ebx
  802f1e:	f7 24 24             	mull   (%esp)
  802f21:	89 c6                	mov    %eax,%esi
  802f23:	89 d1                	mov    %edx,%ecx
  802f25:	39 d3                	cmp    %edx,%ebx
  802f27:	0f 82 87 00 00 00    	jb     802fb4 <__umoddi3+0x134>
  802f2d:	0f 84 91 00 00 00    	je     802fc4 <__umoddi3+0x144>
  802f33:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f37:	29 f2                	sub    %esi,%edx
  802f39:	19 cb                	sbb    %ecx,%ebx
  802f3b:	89 d8                	mov    %ebx,%eax
  802f3d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802f41:	d3 e0                	shl    %cl,%eax
  802f43:	89 e9                	mov    %ebp,%ecx
  802f45:	d3 ea                	shr    %cl,%edx
  802f47:	09 d0                	or     %edx,%eax
  802f49:	89 e9                	mov    %ebp,%ecx
  802f4b:	d3 eb                	shr    %cl,%ebx
  802f4d:	89 da                	mov    %ebx,%edx
  802f4f:	83 c4 1c             	add    $0x1c,%esp
  802f52:	5b                   	pop    %ebx
  802f53:	5e                   	pop    %esi
  802f54:	5f                   	pop    %edi
  802f55:	5d                   	pop    %ebp
  802f56:	c3                   	ret    
  802f57:	90                   	nop
  802f58:	89 fd                	mov    %edi,%ebp
  802f5a:	85 ff                	test   %edi,%edi
  802f5c:	75 0b                	jne    802f69 <__umoddi3+0xe9>
  802f5e:	b8 01 00 00 00       	mov    $0x1,%eax
  802f63:	31 d2                	xor    %edx,%edx
  802f65:	f7 f7                	div    %edi
  802f67:	89 c5                	mov    %eax,%ebp
  802f69:	89 f0                	mov    %esi,%eax
  802f6b:	31 d2                	xor    %edx,%edx
  802f6d:	f7 f5                	div    %ebp
  802f6f:	89 c8                	mov    %ecx,%eax
  802f71:	f7 f5                	div    %ebp
  802f73:	89 d0                	mov    %edx,%eax
  802f75:	e9 44 ff ff ff       	jmp    802ebe <__umoddi3+0x3e>
  802f7a:	66 90                	xchg   %ax,%ax
  802f7c:	89 c8                	mov    %ecx,%eax
  802f7e:	89 f2                	mov    %esi,%edx
  802f80:	83 c4 1c             	add    $0x1c,%esp
  802f83:	5b                   	pop    %ebx
  802f84:	5e                   	pop    %esi
  802f85:	5f                   	pop    %edi
  802f86:	5d                   	pop    %ebp
  802f87:	c3                   	ret    
  802f88:	3b 04 24             	cmp    (%esp),%eax
  802f8b:	72 06                	jb     802f93 <__umoddi3+0x113>
  802f8d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f91:	77 0f                	ja     802fa2 <__umoddi3+0x122>
  802f93:	89 f2                	mov    %esi,%edx
  802f95:	29 f9                	sub    %edi,%ecx
  802f97:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802f9b:	89 14 24             	mov    %edx,(%esp)
  802f9e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802fa2:	8b 44 24 04          	mov    0x4(%esp),%eax
  802fa6:	8b 14 24             	mov    (%esp),%edx
  802fa9:	83 c4 1c             	add    $0x1c,%esp
  802fac:	5b                   	pop    %ebx
  802fad:	5e                   	pop    %esi
  802fae:	5f                   	pop    %edi
  802faf:	5d                   	pop    %ebp
  802fb0:	c3                   	ret    
  802fb1:	8d 76 00             	lea    0x0(%esi),%esi
  802fb4:	2b 04 24             	sub    (%esp),%eax
  802fb7:	19 fa                	sbb    %edi,%edx
  802fb9:	89 d1                	mov    %edx,%ecx
  802fbb:	89 c6                	mov    %eax,%esi
  802fbd:	e9 71 ff ff ff       	jmp    802f33 <__umoddi3+0xb3>
  802fc2:	66 90                	xchg   %ax,%ax
  802fc4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802fc8:	72 ea                	jb     802fb4 <__umoddi3+0x134>
  802fca:	89 d9                	mov    %ebx,%ecx
  802fcc:	e9 62 ff ff ff       	jmp    802f33 <__umoddi3+0xb3>
