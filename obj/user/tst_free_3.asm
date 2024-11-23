
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
  8000a3:	68 00 4e 80 00       	push   $0x804e00
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 41 4e 80 00       	push   $0x804e41
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
  8000d9:	68 00 4e 80 00       	push   $0x804e00
  8000de:	6a 21                	push   $0x21
  8000e0:	68 41 4e 80 00       	push   $0x804e41
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
  80010f:	68 00 4e 80 00       	push   $0x804e00
  800114:	6a 22                	push   $0x22
  800116:	68 41 4e 80 00       	push   $0x804e41
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
  800145:	68 00 4e 80 00       	push   $0x804e00
  80014a:	6a 23                	push   $0x23
  80014c:	68 41 4e 80 00       	push   $0x804e41
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
  80017b:	68 00 4e 80 00       	push   $0x804e00
  800180:	6a 24                	push   $0x24
  800182:	68 41 4e 80 00       	push   $0x804e41
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
  8001b1:	68 00 4e 80 00       	push   $0x804e00
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 41 4e 80 00       	push   $0x804e41
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
  8001e9:	68 00 4e 80 00       	push   $0x804e00
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 41 4e 80 00       	push   $0x804e41
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
  800221:	68 00 4e 80 00       	push   $0x804e00
  800226:	6a 27                	push   $0x27
  800228:	68 41 4e 80 00       	push   $0x804e41
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
  800259:	68 00 4e 80 00       	push   $0x804e00
  80025e:	6a 28                	push   $0x28
  800260:	68 41 4e 80 00       	push   $0x804e41
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
  800291:	68 00 4e 80 00       	push   $0x804e00
  800296:	6a 29                	push   $0x29
  800298:	68 41 4e 80 00       	push   $0x804e41
  80029d:	e8 11 13 00 00       	call   8015b3 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8002a7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 54 4e 80 00       	push   $0x804e54
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 41 4e 80 00       	push   $0x804e41
  8002c0:	e8 ee 12 00 00       	call   8015b3 <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 28 29 00 00       	call   802bf2 <sys_calculate_free_frames>
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
  8002e1:	e8 57 29 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  80031d:	68 9c 4e 80 00       	push   $0x804e9c
  800322:	6a 39                	push   $0x39
  800324:	68 41 4e 80 00       	push   $0x804e41
  800329:	e8 85 12 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 0a 29 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 04 4f 80 00       	push   $0x804f04
  800345:	6a 3a                	push   $0x3a
  800347:	68 41 4e 80 00       	push   $0x804e41
  80034c:	e8 62 12 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 e7 28 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  8003a6:	68 9c 4e 80 00       	push   $0x804e9c
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 41 4e 80 00       	push   $0x804e41
  8003b2:	e8 fc 11 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 81 28 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  8003dd:	68 04 4f 80 00       	push   $0x804f04
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 41 4e 80 00       	push   $0x804e41
  8003e9:	e8 c5 11 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 4a 28 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  80044a:	68 9c 4e 80 00       	push   $0x804e9c
  80044f:	6a 47                	push   $0x47
  800451:	68 41 4e 80 00       	push   $0x804e41
  800456:	e8 58 11 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 dd 27 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  80047e:	68 04 4f 80 00       	push   $0x804f04
  800483:	6a 48                	push   $0x48
  800485:	68 41 4e 80 00       	push   $0x804e41
  80048a:	e8 24 11 00 00       	call   8015b3 <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 a9 27 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  8004fa:	68 9c 4e 80 00       	push   $0x804e9c
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 41 4e 80 00       	push   $0x804e41
  800506:	e8 a8 10 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 2d 27 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  800535:	68 04 4f 80 00       	push   $0x804f04
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 41 4e 80 00       	push   $0x804e41
  800541:	e8 6d 10 00 00       	call   8015b3 <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 a7 26 00 00       	call   802bf2 <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 b8 26 00 00       	call   802c0b <sys_calculate_modified_frames>
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
  80060f:	e8 de 25 00 00       	call   802bf2 <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 f0 25 00 00       	call   802c0b <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 34 4f 80 00       	push   $0x804f34
  80062e:	6a 67                	push   $0x67
  800630:	68 41 4e 80 00       	push   $0x804e41
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
  8006d8:	68 78 4f 80 00       	push   $0x804f78
  8006dd:	6a 73                	push   $0x73
  8006df:	68 41 4e 80 00       	push   $0x804e41
  8006e4:	e8 ca 0e 00 00       	call   8015b3 <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e9:	e8 04 25 00 00       	call   802bf2 <sys_calculate_free_frames>
  8006ee:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006f1:	e8 15 25 00 00       	call   802c0b <sys_calculate_modified_frames>
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
  8007f2:	e8 fb 23 00 00       	call   802bf2 <sys_calculate_free_frames>
  8007f7:	29 c3                	sub    %eax,%ebx
  8007f9:	89 d8                	mov    %ebx,%eax
  8007fb:	83 f8 04             	cmp    $0x4,%eax
  8007fe:	74 17                	je     800817 <_main+0x7df>
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	68 34 4f 80 00       	push   $0x804f34
  800808:	68 8e 00 00 00       	push   $0x8e
  80080d:	68 41 4e 80 00       	push   $0x804e41
  800812:	e8 9c 0d 00 00       	call   8015b3 <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800817:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  80081a:	e8 ec 23 00 00       	call   802c0b <sys_calculate_modified_frames>
  80081f:	29 c3                	sub    %eax,%ebx
  800821:	89 d8                	mov    %ebx,%eax
  800823:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800826:	74 17                	je     80083f <_main+0x807>
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 34 4f 80 00       	push   $0x804f34
  800830:	68 8f 00 00 00       	push   $0x8f
  800835:	68 41 4e 80 00       	push   $0x804e41
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
  8008df:	68 78 4f 80 00       	push   $0x804f78
  8008e4:	68 9b 00 00 00       	push   $0x9b
  8008e9:	68 41 4e 80 00       	push   $0x804e41
  8008ee:	e8 c0 0c 00 00       	call   8015b3 <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008f3:	e8 fa 22 00 00       	call   802bf2 <sys_calculate_free_frames>
  8008f8:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008fb:	e8 0b 23 00 00       	call   802c0b <sys_calculate_modified_frames>
  800900:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800903:	e8 35 23 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800908:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  80090b:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800911:	83 ec 0c             	sub    $0xc,%esp
  800914:	50                   	push   %eax
  800915:	e8 25 1f 00 00       	call   80283f <free>
  80091a:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80091d:	e8 1b 23 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  800945:	68 98 4f 80 00       	push   $0x804f98
  80094a:	68 a5 00 00 00       	push   $0xa5
  80094f:	68 41 4e 80 00       	push   $0x804e41
  800954:	e8 5a 0c 00 00       	call   8015b3 <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  800959:	e8 94 22 00 00       	call   802bf2 <sys_calculate_free_frames>
  80095e:	89 c2                	mov    %eax,%edx
  800960:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800963:	29 c2                	sub    %eax,%edx
  800965:	89 d0                	mov    %edx,%eax
  800967:	83 f8 07             	cmp    $0x7,%eax
  80096a:	74 17                	je     800983 <_main+0x94b>
  80096c:	83 ec 04             	sub    $0x4,%esp
  80096f:	68 d4 4f 80 00       	push   $0x804fd4
  800974:	68 a7 00 00 00       	push   $0xa7
  800979:	68 41 4e 80 00       	push   $0x804e41
  80097e:	e8 30 0c 00 00       	call   8015b3 <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800983:	e8 83 22 00 00       	call   802c0b <sys_calculate_modified_frames>
  800988:	89 c2                	mov    %eax,%edx
  80098a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80098d:	29 c2                	sub    %eax,%edx
  80098f:	89 d0                	mov    %edx,%eax
  800991:	83 f8 02             	cmp    $0x2,%eax
  800994:	74 17                	je     8009ad <_main+0x975>
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	68 28 50 80 00       	push   $0x805028
  80099e:	68 a8 00 00 00       	push   $0xa8
  8009a3:	68 41 4e 80 00       	push   $0x804e41
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
  800a1c:	68 60 50 80 00       	push   $0x805060
  800a21:	68 b0 00 00 00       	push   $0xb0
  800a26:	68 41 4e 80 00       	push   $0x804e41
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
  800a56:	e8 97 21 00 00       	call   802bf2 <sys_calculate_free_frames>
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
  800aa3:	e8 4a 21 00 00       	call   802bf2 <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 02             	cmp    $0x2,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 34 4f 80 00       	push   $0x804f34
  800ab9:	68 bc 00 00 00       	push   $0xbc
  800abe:	68 41 4e 80 00       	push   $0x804e41
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
  800ba1:	68 78 4f 80 00       	push   $0x804f78
  800ba6:	68 c5 00 00 00       	push   $0xc5
  800bab:	68 41 4e 80 00       	push   $0x804e41
  800bb0:	e8 fe 09 00 00       	call   8015b3 <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bb5:	e8 83 20 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  800c05:	68 9c 4e 80 00       	push   $0x804e9c
  800c0a:	68 ca 00 00 00       	push   $0xca
  800c0f:	68 41 4e 80 00       	push   $0x804e41
  800c14:	e8 9a 09 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c19:	e8 1f 20 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800c1e:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c21:	83 f8 01             	cmp    $0x1,%eax
  800c24:	74 17                	je     800c3d <_main+0xc05>
  800c26:	83 ec 04             	sub    $0x4,%esp
  800c29:	68 04 4f 80 00       	push   $0x804f04
  800c2e:	68 cb 00 00 00       	push   $0xcb
  800c33:	68 41 4e 80 00       	push   $0x804e41
  800c38:	e8 76 09 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c3d:	e8 b0 1f 00 00       	call   802bf2 <sys_calculate_free_frames>
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
  800c88:	e8 65 1f 00 00       	call   802bf2 <sys_calculate_free_frames>
  800c8d:	29 c3                	sub    %eax,%ebx
  800c8f:	89 d8                	mov    %ebx,%eax
  800c91:	83 f8 02             	cmp    $0x2,%eax
  800c94:	74 17                	je     800cad <_main+0xc75>
  800c96:	83 ec 04             	sub    $0x4,%esp
  800c99:	68 34 4f 80 00       	push   $0x804f34
  800c9e:	68 d2 00 00 00       	push   $0xd2
  800ca3:	68 41 4e 80 00       	push   $0x804e41
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
  800d89:	68 78 4f 80 00       	push   $0x804f78
  800d8e:	68 db 00 00 00       	push   $0xdb
  800d93:	68 41 4e 80 00       	push   $0x804e41
  800d98:	e8 16 08 00 00       	call   8015b3 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d9d:	e8 50 1e 00 00       	call   802bf2 <sys_calculate_free_frames>
  800da2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800da5:	e8 93 1e 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  800e09:	68 9c 4e 80 00       	push   $0x804e9c
  800e0e:	68 e1 00 00 00       	push   $0xe1
  800e13:	68 41 4e 80 00       	push   $0x804e41
  800e18:	e8 96 07 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e1d:	e8 1b 1e 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800e22:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e25:	83 f8 01             	cmp    $0x1,%eax
  800e28:	74 17                	je     800e41 <_main+0xe09>
  800e2a:	83 ec 04             	sub    $0x4,%esp
  800e2d:	68 04 4f 80 00       	push   $0x804f04
  800e32:	68 e2 00 00 00       	push   $0xe2
  800e37:	68 41 4e 80 00       	push   $0x804e41
  800e3c:	e8 72 07 00 00       	call   8015b3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e41:	e8 f7 1d 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  800ead:	68 9c 4e 80 00       	push   $0x804e9c
  800eb2:	68 e8 00 00 00       	push   $0xe8
  800eb7:	68 41 4e 80 00       	push   $0x804e41
  800ebc:	e8 f2 06 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ec1:	e8 77 1d 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  800ec6:	2b 45 90             	sub    -0x70(%ebp),%eax
  800ec9:	83 f8 02             	cmp    $0x2,%eax
  800ecc:	74 17                	je     800ee5 <_main+0xead>
  800ece:	83 ec 04             	sub    $0x4,%esp
  800ed1:	68 04 4f 80 00       	push   $0x804f04
  800ed6:	68 e9 00 00 00       	push   $0xe9
  800edb:	68 41 4e 80 00       	push   $0x804e41
  800ee0:	e8 ce 06 00 00       	call   8015b3 <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800ee5:	e8 08 1d 00 00       	call   802bf2 <sys_calculate_free_frames>
  800eea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800eed:	e8 4b 1d 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  800f58:	68 9c 4e 80 00       	push   $0x804e9c
  800f5d:	68 f0 00 00 00       	push   $0xf0
  800f62:	68 41 4e 80 00       	push   $0x804e41
  800f67:	e8 47 06 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f6c:	e8 cc 1c 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  800f92:	68 04 4f 80 00       	push   $0x804f04
  800f97:	68 f1 00 00 00       	push   $0xf1
  800f9c:	68 41 4e 80 00       	push   $0x804e41
  800fa1:	e8 0d 06 00 00       	call   8015b3 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800fa6:	e8 92 1c 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  801021:	68 9c 4e 80 00       	push   $0x804e9c
  801026:	68 f7 00 00 00       	push   $0xf7
  80102b:	68 41 4e 80 00       	push   $0x804e41
  801030:	e8 7e 05 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  801035:	e8 03 1c 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  80105d:	68 04 4f 80 00       	push   $0x804f04
  801062:	68 f8 00 00 00       	push   $0xf8
  801067:	68 41 4e 80 00       	push   $0x804e41
  80106c:	e8 42 05 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801071:	e8 7c 1b 00 00       	call   802bf2 <sys_calculate_free_frames>
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
  8010e2:	e8 0b 1b 00 00       	call   802bf2 <sys_calculate_free_frames>
  8010e7:	29 c3                	sub    %eax,%ebx
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	83 f8 05             	cmp    $0x5,%eax
  8010ee:	74 17                	je     801107 <_main+0x10cf>
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 34 4f 80 00       	push   $0x804f34
  8010f8:	68 00 01 00 00       	push   $0x100
  8010fd:	68 41 4e 80 00       	push   $0x804e41
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
  80123b:	68 78 4f 80 00       	push   $0x804f78
  801240:	68 0b 01 00 00       	push   $0x10b
  801245:	68 41 4e 80 00       	push   $0x804e41
  80124a:	e8 64 03 00 00       	call   8015b3 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80124f:	e8 e9 19 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
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
  8012cd:	68 9c 4e 80 00       	push   $0x804e9c
  8012d2:	68 10 01 00 00       	push   $0x110
  8012d7:	68 41 4e 80 00       	push   $0x804e41
  8012dc:	e8 d2 02 00 00       	call   8015b3 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012e1:	e8 57 19 00 00       	call   802c3d <sys_pf_calculate_allocated_pages>
  8012e6:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012e9:	83 f8 04             	cmp    $0x4,%eax
  8012ec:	74 17                	je     801305 <_main+0x12cd>
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 04 4f 80 00       	push   $0x804f04
  8012f6:	68 11 01 00 00       	push   $0x111
  8012fb:	68 41 4e 80 00       	push   $0x804e41
  801300:	e8 ae 02 00 00       	call   8015b3 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801305:	e8 e8 18 00 00       	call   802bf2 <sys_calculate_free_frames>
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
  801359:	e8 94 18 00 00       	call   802bf2 <sys_calculate_free_frames>
  80135e:	29 c3                	sub    %eax,%ebx
  801360:	89 d8                	mov    %ebx,%eax
  801362:	83 f8 02             	cmp    $0x2,%eax
  801365:	74 17                	je     80137e <_main+0x1346>
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	68 34 4f 80 00       	push   $0x804f34
  80136f:	68 18 01 00 00       	push   $0x118
  801374:	68 41 4e 80 00       	push   $0x804e41
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
  801457:	68 78 4f 80 00       	push   $0x804f78
  80145c:	68 21 01 00 00       	push   $0x121
  801461:	68 41 4e 80 00       	push   $0x804e41
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
  80147a:	e8 3c 19 00 00       	call   802dbb <sys_getenvindex>
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
  8014e8:	e8 52 16 00 00       	call   802b3f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8014ed:	83 ec 0c             	sub    $0xc,%esp
  8014f0:	68 9c 50 80 00       	push   $0x80509c
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
  801518:	68 c4 50 80 00       	push   $0x8050c4
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
  801549:	68 ec 50 80 00       	push   $0x8050ec
  80154e:	e8 1d 03 00 00       	call   801870 <cprintf>
  801553:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801556:	a1 20 60 80 00       	mov    0x806020,%eax
  80155b:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  801561:	83 ec 08             	sub    $0x8,%esp
  801564:	50                   	push   %eax
  801565:	68 44 51 80 00       	push   $0x805144
  80156a:	e8 01 03 00 00       	call   801870 <cprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 9c 50 80 00       	push   $0x80509c
  80157a:	e8 f1 02 00 00       	call   801870 <cprintf>
  80157f:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  801582:	e8 d2 15 00 00       	call   802b59 <sys_unlock_cons>
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
  80159a:	e8 e8 17 00 00       	call   802d87 <sys_destroy_env>
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
  8015ab:	e8 3d 18 00 00       	call   802ded <sys_exit_env>
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
  8015d4:	68 58 51 80 00       	push   $0x805158
  8015d9:	e8 92 02 00 00       	call   801870 <cprintf>
  8015de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015e1:	a1 00 60 80 00       	mov    0x806000,%eax
  8015e6:	ff 75 0c             	pushl  0xc(%ebp)
  8015e9:	ff 75 08             	pushl  0x8(%ebp)
  8015ec:	50                   	push   %eax
  8015ed:	68 5d 51 80 00       	push   $0x80515d
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
  801611:	68 79 51 80 00       	push   $0x805179
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
  801640:	68 7c 51 80 00       	push   $0x80517c
  801645:	6a 26                	push   $0x26
  801647:	68 c8 51 80 00       	push   $0x8051c8
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
  801715:	68 d4 51 80 00       	push   $0x8051d4
  80171a:	6a 3a                	push   $0x3a
  80171c:	68 c8 51 80 00       	push   $0x8051c8
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
  801788:	68 28 52 80 00       	push   $0x805228
  80178d:	6a 44                	push   $0x44
  80178f:	68 c8 51 80 00       	push   $0x8051c8
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
  8017e2:	e8 16 13 00 00       	call   802afd <sys_cputs>
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
  801859:	e8 9f 12 00 00       	call   802afd <sys_cputs>
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
  8018a3:	e8 97 12 00 00       	call   802b3f <sys_lock_cons>
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
  8018c3:	e8 91 12 00 00       	call   802b59 <sys_unlock_cons>
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
  80190d:	e8 82 32 00 00       	call   804b94 <__udivdi3>
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
  80195d:	e8 42 33 00 00       	call   804ca4 <__umoddi3>
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	05 94 54 80 00       	add    $0x805494,%eax
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
  801ab8:	8b 04 85 b8 54 80 00 	mov    0x8054b8(,%eax,4),%eax
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
  801b99:	8b 34 9d 00 53 80 00 	mov    0x805300(,%ebx,4),%esi
  801ba0:	85 f6                	test   %esi,%esi
  801ba2:	75 19                	jne    801bbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801ba4:	53                   	push   %ebx
  801ba5:	68 a5 54 80 00       	push   $0x8054a5
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
  801bbe:	68 ae 54 80 00       	push   $0x8054ae
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
  801beb:	be b1 54 80 00       	mov    $0x8054b1,%esi
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
  8025f6:	68 28 56 80 00       	push   $0x805628
  8025fb:	68 3f 01 00 00       	push   $0x13f
  802600:	68 4a 56 80 00       	push   $0x80564a
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
  802616:	e8 8d 0a 00 00       	call   8030a8 <sys_sbrk>
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
  802691:	e8 96 08 00 00       	call   802f2c <sys_isUHeapPlacementStrategyFIRSTFIT>
  802696:	85 c0                	test   %eax,%eax
  802698:	74 16                	je     8026b0 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80269a:	83 ec 0c             	sub    $0xc,%esp
  80269d:	ff 75 08             	pushl  0x8(%ebp)
  8026a0:	e8 d6 0d 00 00       	call   80347b <alloc_block_FF>
  8026a5:	83 c4 10             	add    $0x10,%esp
  8026a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ab:	e9 8a 01 00 00       	jmp    80283a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8026b0:	e8 a8 08 00 00       	call   802f5d <sys_isUHeapPlacementStrategyBESTFIT>
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	0f 84 7d 01 00 00    	je     80283a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	ff 75 08             	pushl  0x8(%ebp)
  8026c3:	e8 6f 12 00 00       	call   803937 <alloc_block_BF>
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
  802829:	e8 b1 08 00 00       	call   8030df <sys_allocate_user_mem>
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
  802871:	e8 85 08 00 00       	call   8030fb <get_block_size>
  802876:	83 c4 10             	add    $0x10,%esp
  802879:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80287c:	83 ec 0c             	sub    $0xc,%esp
  80287f:	ff 75 08             	pushl  0x8(%ebp)
  802882:	e8 b8 1a 00 00       	call   80433f <free_block>
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
  802919:	e8 a5 07 00 00       	call   8030c3 <sys_free_user_mem>
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
  802927:	68 58 56 80 00       	push   $0x805658
  80292c:	68 84 00 00 00       	push   $0x84
  802931:	68 82 56 80 00       	push   $0x805682
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
  802954:	eb 64                	jmp    8029ba <smalloc+0x7d>
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
  802989:	eb 2f                	jmp    8029ba <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80298b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80298f:	ff 75 ec             	pushl  -0x14(%ebp)
  802992:	50                   	push   %eax
  802993:	ff 75 0c             	pushl  0xc(%ebp)
  802996:	ff 75 08             	pushl  0x8(%ebp)
  802999:	e8 2c 03 00 00       	call   802cca <sys_createSharedObject>
  80299e:	83 c4 10             	add    $0x10,%esp
  8029a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8029a4:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8029a8:	74 06                	je     8029b0 <smalloc+0x73>
  8029aa:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8029ae:	75 07                	jne    8029b7 <smalloc+0x7a>
  8029b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b5:	eb 03                	jmp    8029ba <smalloc+0x7d>
	 return ptr;
  8029b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8029ba:	c9                   	leave  
  8029bb:	c3                   	ret    

008029bc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8029bc:	55                   	push   %ebp
  8029bd:	89 e5                	mov    %esp,%ebp
  8029bf:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8029c2:	83 ec 08             	sub    $0x8,%esp
  8029c5:	ff 75 0c             	pushl  0xc(%ebp)
  8029c8:	ff 75 08             	pushl  0x8(%ebp)
  8029cb:	e8 24 03 00 00       	call   802cf4 <sys_getSizeOfSharedObject>
  8029d0:	83 c4 10             	add    $0x10,%esp
  8029d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8029d6:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8029da:	75 07                	jne    8029e3 <sget+0x27>
  8029dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e1:	eb 5c                	jmp    802a3f <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8029e9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8029f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f6:	39 d0                	cmp    %edx,%eax
  8029f8:	7d 02                	jge    8029fc <sget+0x40>
  8029fa:	89 d0                	mov    %edx,%eax
  8029fc:	83 ec 0c             	sub    $0xc,%esp
  8029ff:	50                   	push   %eax
  802a00:	e8 1b fc ff ff       	call   802620 <malloc>
  802a05:	83 c4 10             	add    $0x10,%esp
  802a08:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  802a0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a0f:	75 07                	jne    802a18 <sget+0x5c>
  802a11:	b8 00 00 00 00       	mov    $0x0,%eax
  802a16:	eb 27                	jmp    802a3f <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  802a18:	83 ec 04             	sub    $0x4,%esp
  802a1b:	ff 75 e8             	pushl  -0x18(%ebp)
  802a1e:	ff 75 0c             	pushl  0xc(%ebp)
  802a21:	ff 75 08             	pushl  0x8(%ebp)
  802a24:	e8 e8 02 00 00       	call   802d11 <sys_getSharedObject>
  802a29:	83 c4 10             	add    $0x10,%esp
  802a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  802a2f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802a33:	75 07                	jne    802a3c <sget+0x80>
  802a35:	b8 00 00 00 00       	mov    $0x0,%eax
  802a3a:	eb 03                	jmp    802a3f <sget+0x83>
	return ptr;
  802a3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  802a3f:	c9                   	leave  
  802a40:	c3                   	ret    

00802a41 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802a41:	55                   	push   %ebp
  802a42:	89 e5                	mov    %esp,%ebp
  802a44:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802a47:	83 ec 04             	sub    $0x4,%esp
  802a4a:	68 90 56 80 00       	push   $0x805690
  802a4f:	68 c1 00 00 00       	push   $0xc1
  802a54:	68 82 56 80 00       	push   $0x805682
  802a59:	e8 55 eb ff ff       	call   8015b3 <_panic>

00802a5e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802a5e:	55                   	push   %ebp
  802a5f:	89 e5                	mov    %esp,%ebp
  802a61:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802a64:	83 ec 04             	sub    $0x4,%esp
  802a67:	68 b4 56 80 00       	push   $0x8056b4
  802a6c:	68 d8 00 00 00       	push   $0xd8
  802a71:	68 82 56 80 00       	push   $0x805682
  802a76:	e8 38 eb ff ff       	call   8015b3 <_panic>

00802a7b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  802a7b:	55                   	push   %ebp
  802a7c:	89 e5                	mov    %esp,%ebp
  802a7e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802a81:	83 ec 04             	sub    $0x4,%esp
  802a84:	68 da 56 80 00       	push   $0x8056da
  802a89:	68 e4 00 00 00       	push   $0xe4
  802a8e:	68 82 56 80 00       	push   $0x805682
  802a93:	e8 1b eb ff ff       	call   8015b3 <_panic>

00802a98 <shrink>:

}
void shrink(uint32 newSize)
{
  802a98:	55                   	push   %ebp
  802a99:	89 e5                	mov    %esp,%ebp
  802a9b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802a9e:	83 ec 04             	sub    $0x4,%esp
  802aa1:	68 da 56 80 00       	push   $0x8056da
  802aa6:	68 e9 00 00 00       	push   $0xe9
  802aab:	68 82 56 80 00       	push   $0x805682
  802ab0:	e8 fe ea ff ff       	call   8015b3 <_panic>

00802ab5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802ab5:	55                   	push   %ebp
  802ab6:	89 e5                	mov    %esp,%ebp
  802ab8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802abb:	83 ec 04             	sub    $0x4,%esp
  802abe:	68 da 56 80 00       	push   $0x8056da
  802ac3:	68 ee 00 00 00       	push   $0xee
  802ac8:	68 82 56 80 00       	push   $0x805682
  802acd:	e8 e1 ea ff ff       	call   8015b3 <_panic>

00802ad2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802ad2:	55                   	push   %ebp
  802ad3:	89 e5                	mov    %esp,%ebp
  802ad5:	57                   	push   %edi
  802ad6:	56                   	push   %esi
  802ad7:	53                   	push   %ebx
  802ad8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ae1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ae4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ae7:	8b 7d 18             	mov    0x18(%ebp),%edi
  802aea:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802aed:	cd 30                	int    $0x30
  802aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802af5:	83 c4 10             	add    $0x10,%esp
  802af8:	5b                   	pop    %ebx
  802af9:	5e                   	pop    %esi
  802afa:	5f                   	pop    %edi
  802afb:	5d                   	pop    %ebp
  802afc:	c3                   	ret    

00802afd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802afd:	55                   	push   %ebp
  802afe:	89 e5                	mov    %esp,%ebp
  802b00:	83 ec 04             	sub    $0x4,%esp
  802b03:	8b 45 10             	mov    0x10(%ebp),%eax
  802b06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802b09:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	6a 00                	push   $0x0
  802b12:	6a 00                	push   $0x0
  802b14:	52                   	push   %edx
  802b15:	ff 75 0c             	pushl  0xc(%ebp)
  802b18:	50                   	push   %eax
  802b19:	6a 00                	push   $0x0
  802b1b:	e8 b2 ff ff ff       	call   802ad2 <syscall>
  802b20:	83 c4 18             	add    $0x18,%esp
}
  802b23:	90                   	nop
  802b24:	c9                   	leave  
  802b25:	c3                   	ret    

00802b26 <sys_cgetc>:

int
sys_cgetc(void)
{
  802b26:	55                   	push   %ebp
  802b27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 00                	push   $0x0
  802b2d:	6a 00                	push   $0x0
  802b2f:	6a 00                	push   $0x0
  802b31:	6a 00                	push   $0x0
  802b33:	6a 02                	push   $0x2
  802b35:	e8 98 ff ff ff       	call   802ad2 <syscall>
  802b3a:	83 c4 18             	add    $0x18,%esp
}
  802b3d:	c9                   	leave  
  802b3e:	c3                   	ret    

00802b3f <sys_lock_cons>:

void sys_lock_cons(void)
{
  802b3f:	55                   	push   %ebp
  802b40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802b42:	6a 00                	push   $0x0
  802b44:	6a 00                	push   $0x0
  802b46:	6a 00                	push   $0x0
  802b48:	6a 00                	push   $0x0
  802b4a:	6a 00                	push   $0x0
  802b4c:	6a 03                	push   $0x3
  802b4e:	e8 7f ff ff ff       	call   802ad2 <syscall>
  802b53:	83 c4 18             	add    $0x18,%esp
}
  802b56:	90                   	nop
  802b57:	c9                   	leave  
  802b58:	c3                   	ret    

00802b59 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802b59:	55                   	push   %ebp
  802b5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	6a 00                	push   $0x0
  802b64:	6a 00                	push   $0x0
  802b66:	6a 04                	push   $0x4
  802b68:	e8 65 ff ff ff       	call   802ad2 <syscall>
  802b6d:	83 c4 18             	add    $0x18,%esp
}
  802b70:	90                   	nop
  802b71:	c9                   	leave  
  802b72:	c3                   	ret    

00802b73 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802b73:	55                   	push   %ebp
  802b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	6a 00                	push   $0x0
  802b7e:	6a 00                	push   $0x0
  802b80:	6a 00                	push   $0x0
  802b82:	52                   	push   %edx
  802b83:	50                   	push   %eax
  802b84:	6a 08                	push   $0x8
  802b86:	e8 47 ff ff ff       	call   802ad2 <syscall>
  802b8b:	83 c4 18             	add    $0x18,%esp
}
  802b8e:	c9                   	leave  
  802b8f:	c3                   	ret    

00802b90 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802b90:	55                   	push   %ebp
  802b91:	89 e5                	mov    %esp,%ebp
  802b93:	56                   	push   %esi
  802b94:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802b95:	8b 75 18             	mov    0x18(%ebp),%esi
  802b98:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	56                   	push   %esi
  802ba5:	53                   	push   %ebx
  802ba6:	51                   	push   %ecx
  802ba7:	52                   	push   %edx
  802ba8:	50                   	push   %eax
  802ba9:	6a 09                	push   $0x9
  802bab:	e8 22 ff ff ff       	call   802ad2 <syscall>
  802bb0:	83 c4 18             	add    $0x18,%esp
}
  802bb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802bb6:	5b                   	pop    %ebx
  802bb7:	5e                   	pop    %esi
  802bb8:	5d                   	pop    %ebp
  802bb9:	c3                   	ret    

00802bba <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802bba:	55                   	push   %ebp
  802bbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	6a 00                	push   $0x0
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	52                   	push   %edx
  802bca:	50                   	push   %eax
  802bcb:	6a 0a                	push   $0xa
  802bcd:	e8 00 ff ff ff       	call   802ad2 <syscall>
  802bd2:	83 c4 18             	add    $0x18,%esp
}
  802bd5:	c9                   	leave  
  802bd6:	c3                   	ret    

00802bd7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802bd7:	55                   	push   %ebp
  802bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802bda:	6a 00                	push   $0x0
  802bdc:	6a 00                	push   $0x0
  802bde:	6a 00                	push   $0x0
  802be0:	ff 75 0c             	pushl  0xc(%ebp)
  802be3:	ff 75 08             	pushl  0x8(%ebp)
  802be6:	6a 0b                	push   $0xb
  802be8:	e8 e5 fe ff ff       	call   802ad2 <syscall>
  802bed:	83 c4 18             	add    $0x18,%esp
}
  802bf0:	c9                   	leave  
  802bf1:	c3                   	ret    

00802bf2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802bf2:	55                   	push   %ebp
  802bf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802bf5:	6a 00                	push   $0x0
  802bf7:	6a 00                	push   $0x0
  802bf9:	6a 00                	push   $0x0
  802bfb:	6a 00                	push   $0x0
  802bfd:	6a 00                	push   $0x0
  802bff:	6a 0c                	push   $0xc
  802c01:	e8 cc fe ff ff       	call   802ad2 <syscall>
  802c06:	83 c4 18             	add    $0x18,%esp
}
  802c09:	c9                   	leave  
  802c0a:	c3                   	ret    

00802c0b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802c0b:	55                   	push   %ebp
  802c0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802c0e:	6a 00                	push   $0x0
  802c10:	6a 00                	push   $0x0
  802c12:	6a 00                	push   $0x0
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	6a 0d                	push   $0xd
  802c1a:	e8 b3 fe ff ff       	call   802ad2 <syscall>
  802c1f:	83 c4 18             	add    $0x18,%esp
}
  802c22:	c9                   	leave  
  802c23:	c3                   	ret    

00802c24 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802c24:	55                   	push   %ebp
  802c25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802c27:	6a 00                	push   $0x0
  802c29:	6a 00                	push   $0x0
  802c2b:	6a 00                	push   $0x0
  802c2d:	6a 00                	push   $0x0
  802c2f:	6a 00                	push   $0x0
  802c31:	6a 0e                	push   $0xe
  802c33:	e8 9a fe ff ff       	call   802ad2 <syscall>
  802c38:	83 c4 18             	add    $0x18,%esp
}
  802c3b:	c9                   	leave  
  802c3c:	c3                   	ret    

00802c3d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802c3d:	55                   	push   %ebp
  802c3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802c40:	6a 00                	push   $0x0
  802c42:	6a 00                	push   $0x0
  802c44:	6a 00                	push   $0x0
  802c46:	6a 00                	push   $0x0
  802c48:	6a 00                	push   $0x0
  802c4a:	6a 0f                	push   $0xf
  802c4c:	e8 81 fe ff ff       	call   802ad2 <syscall>
  802c51:	83 c4 18             	add    $0x18,%esp
}
  802c54:	c9                   	leave  
  802c55:	c3                   	ret    

00802c56 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802c56:	55                   	push   %ebp
  802c57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802c59:	6a 00                	push   $0x0
  802c5b:	6a 00                	push   $0x0
  802c5d:	6a 00                	push   $0x0
  802c5f:	6a 00                	push   $0x0
  802c61:	ff 75 08             	pushl  0x8(%ebp)
  802c64:	6a 10                	push   $0x10
  802c66:	e8 67 fe ff ff       	call   802ad2 <syscall>
  802c6b:	83 c4 18             	add    $0x18,%esp
}
  802c6e:	c9                   	leave  
  802c6f:	c3                   	ret    

00802c70 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802c70:	55                   	push   %ebp
  802c71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802c73:	6a 00                	push   $0x0
  802c75:	6a 00                	push   $0x0
  802c77:	6a 00                	push   $0x0
  802c79:	6a 00                	push   $0x0
  802c7b:	6a 00                	push   $0x0
  802c7d:	6a 11                	push   $0x11
  802c7f:	e8 4e fe ff ff       	call   802ad2 <syscall>
  802c84:	83 c4 18             	add    $0x18,%esp
}
  802c87:	90                   	nop
  802c88:	c9                   	leave  
  802c89:	c3                   	ret    

00802c8a <sys_cputc>:

void
sys_cputc(const char c)
{
  802c8a:	55                   	push   %ebp
  802c8b:	89 e5                	mov    %esp,%ebp
  802c8d:	83 ec 04             	sub    $0x4,%esp
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802c96:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c9a:	6a 00                	push   $0x0
  802c9c:	6a 00                	push   $0x0
  802c9e:	6a 00                	push   $0x0
  802ca0:	6a 00                	push   $0x0
  802ca2:	50                   	push   %eax
  802ca3:	6a 01                	push   $0x1
  802ca5:	e8 28 fe ff ff       	call   802ad2 <syscall>
  802caa:	83 c4 18             	add    $0x18,%esp
}
  802cad:	90                   	nop
  802cae:	c9                   	leave  
  802caf:	c3                   	ret    

00802cb0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802cb0:	55                   	push   %ebp
  802cb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802cb3:	6a 00                	push   $0x0
  802cb5:	6a 00                	push   $0x0
  802cb7:	6a 00                	push   $0x0
  802cb9:	6a 00                	push   $0x0
  802cbb:	6a 00                	push   $0x0
  802cbd:	6a 14                	push   $0x14
  802cbf:	e8 0e fe ff ff       	call   802ad2 <syscall>
  802cc4:	83 c4 18             	add    $0x18,%esp
}
  802cc7:	90                   	nop
  802cc8:	c9                   	leave  
  802cc9:	c3                   	ret    

00802cca <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802cca:	55                   	push   %ebp
  802ccb:	89 e5                	mov    %esp,%ebp
  802ccd:	83 ec 04             	sub    $0x4,%esp
  802cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  802cd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802cd6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802cd9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	6a 00                	push   $0x0
  802ce2:	51                   	push   %ecx
  802ce3:	52                   	push   %edx
  802ce4:	ff 75 0c             	pushl  0xc(%ebp)
  802ce7:	50                   	push   %eax
  802ce8:	6a 15                	push   $0x15
  802cea:	e8 e3 fd ff ff       	call   802ad2 <syscall>
  802cef:	83 c4 18             	add    $0x18,%esp
}
  802cf2:	c9                   	leave  
  802cf3:	c3                   	ret    

00802cf4 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802cf4:	55                   	push   %ebp
  802cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	6a 00                	push   $0x0
  802cff:	6a 00                	push   $0x0
  802d01:	6a 00                	push   $0x0
  802d03:	52                   	push   %edx
  802d04:	50                   	push   %eax
  802d05:	6a 16                	push   $0x16
  802d07:	e8 c6 fd ff ff       	call   802ad2 <syscall>
  802d0c:	83 c4 18             	add    $0x18,%esp
}
  802d0f:	c9                   	leave  
  802d10:	c3                   	ret    

00802d11 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802d11:	55                   	push   %ebp
  802d12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802d14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	6a 00                	push   $0x0
  802d1f:	6a 00                	push   $0x0
  802d21:	51                   	push   %ecx
  802d22:	52                   	push   %edx
  802d23:	50                   	push   %eax
  802d24:	6a 17                	push   $0x17
  802d26:	e8 a7 fd ff ff       	call   802ad2 <syscall>
  802d2b:	83 c4 18             	add    $0x18,%esp
}
  802d2e:	c9                   	leave  
  802d2f:	c3                   	ret    

00802d30 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802d30:	55                   	push   %ebp
  802d31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d36:	8b 45 08             	mov    0x8(%ebp),%eax
  802d39:	6a 00                	push   $0x0
  802d3b:	6a 00                	push   $0x0
  802d3d:	6a 00                	push   $0x0
  802d3f:	52                   	push   %edx
  802d40:	50                   	push   %eax
  802d41:	6a 18                	push   $0x18
  802d43:	e8 8a fd ff ff       	call   802ad2 <syscall>
  802d48:	83 c4 18             	add    $0x18,%esp
}
  802d4b:	c9                   	leave  
  802d4c:	c3                   	ret    

00802d4d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802d4d:	55                   	push   %ebp
  802d4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	6a 00                	push   $0x0
  802d55:	ff 75 14             	pushl  0x14(%ebp)
  802d58:	ff 75 10             	pushl  0x10(%ebp)
  802d5b:	ff 75 0c             	pushl  0xc(%ebp)
  802d5e:	50                   	push   %eax
  802d5f:	6a 19                	push   $0x19
  802d61:	e8 6c fd ff ff       	call   802ad2 <syscall>
  802d66:	83 c4 18             	add    $0x18,%esp
}
  802d69:	c9                   	leave  
  802d6a:	c3                   	ret    

00802d6b <sys_run_env>:

void sys_run_env(int32 envId)
{
  802d6b:	55                   	push   %ebp
  802d6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	6a 00                	push   $0x0
  802d73:	6a 00                	push   $0x0
  802d75:	6a 00                	push   $0x0
  802d77:	6a 00                	push   $0x0
  802d79:	50                   	push   %eax
  802d7a:	6a 1a                	push   $0x1a
  802d7c:	e8 51 fd ff ff       	call   802ad2 <syscall>
  802d81:	83 c4 18             	add    $0x18,%esp
}
  802d84:	90                   	nop
  802d85:	c9                   	leave  
  802d86:	c3                   	ret    

00802d87 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802d87:	55                   	push   %ebp
  802d88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	6a 00                	push   $0x0
  802d8f:	6a 00                	push   $0x0
  802d91:	6a 00                	push   $0x0
  802d93:	6a 00                	push   $0x0
  802d95:	50                   	push   %eax
  802d96:	6a 1b                	push   $0x1b
  802d98:	e8 35 fd ff ff       	call   802ad2 <syscall>
  802d9d:	83 c4 18             	add    $0x18,%esp
}
  802da0:	c9                   	leave  
  802da1:	c3                   	ret    

00802da2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802da2:	55                   	push   %ebp
  802da3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802da5:	6a 00                	push   $0x0
  802da7:	6a 00                	push   $0x0
  802da9:	6a 00                	push   $0x0
  802dab:	6a 00                	push   $0x0
  802dad:	6a 00                	push   $0x0
  802daf:	6a 05                	push   $0x5
  802db1:	e8 1c fd ff ff       	call   802ad2 <syscall>
  802db6:	83 c4 18             	add    $0x18,%esp
}
  802db9:	c9                   	leave  
  802dba:	c3                   	ret    

00802dbb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802dbb:	55                   	push   %ebp
  802dbc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802dbe:	6a 00                	push   $0x0
  802dc0:	6a 00                	push   $0x0
  802dc2:	6a 00                	push   $0x0
  802dc4:	6a 00                	push   $0x0
  802dc6:	6a 00                	push   $0x0
  802dc8:	6a 06                	push   $0x6
  802dca:	e8 03 fd ff ff       	call   802ad2 <syscall>
  802dcf:	83 c4 18             	add    $0x18,%esp
}
  802dd2:	c9                   	leave  
  802dd3:	c3                   	ret    

00802dd4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802dd4:	55                   	push   %ebp
  802dd5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802dd7:	6a 00                	push   $0x0
  802dd9:	6a 00                	push   $0x0
  802ddb:	6a 00                	push   $0x0
  802ddd:	6a 00                	push   $0x0
  802ddf:	6a 00                	push   $0x0
  802de1:	6a 07                	push   $0x7
  802de3:	e8 ea fc ff ff       	call   802ad2 <syscall>
  802de8:	83 c4 18             	add    $0x18,%esp
}
  802deb:	c9                   	leave  
  802dec:	c3                   	ret    

00802ded <sys_exit_env>:


void sys_exit_env(void)
{
  802ded:	55                   	push   %ebp
  802dee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802df0:	6a 00                	push   $0x0
  802df2:	6a 00                	push   $0x0
  802df4:	6a 00                	push   $0x0
  802df6:	6a 00                	push   $0x0
  802df8:	6a 00                	push   $0x0
  802dfa:	6a 1c                	push   $0x1c
  802dfc:	e8 d1 fc ff ff       	call   802ad2 <syscall>
  802e01:	83 c4 18             	add    $0x18,%esp
}
  802e04:	90                   	nop
  802e05:	c9                   	leave  
  802e06:	c3                   	ret    

00802e07 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802e07:	55                   	push   %ebp
  802e08:	89 e5                	mov    %esp,%ebp
  802e0a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802e0d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e10:	8d 50 04             	lea    0x4(%eax),%edx
  802e13:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e16:	6a 00                	push   $0x0
  802e18:	6a 00                	push   $0x0
  802e1a:	6a 00                	push   $0x0
  802e1c:	52                   	push   %edx
  802e1d:	50                   	push   %eax
  802e1e:	6a 1d                	push   $0x1d
  802e20:	e8 ad fc ff ff       	call   802ad2 <syscall>
  802e25:	83 c4 18             	add    $0x18,%esp
	return result;
  802e28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802e31:	89 01                	mov    %eax,(%ecx)
  802e33:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	c9                   	leave  
  802e3a:	c2 04 00             	ret    $0x4

00802e3d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802e3d:	55                   	push   %ebp
  802e3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802e40:	6a 00                	push   $0x0
  802e42:	6a 00                	push   $0x0
  802e44:	ff 75 10             	pushl  0x10(%ebp)
  802e47:	ff 75 0c             	pushl  0xc(%ebp)
  802e4a:	ff 75 08             	pushl  0x8(%ebp)
  802e4d:	6a 13                	push   $0x13
  802e4f:	e8 7e fc ff ff       	call   802ad2 <syscall>
  802e54:	83 c4 18             	add    $0x18,%esp
	return ;
  802e57:	90                   	nop
}
  802e58:	c9                   	leave  
  802e59:	c3                   	ret    

00802e5a <sys_rcr2>:
uint32 sys_rcr2()
{
  802e5a:	55                   	push   %ebp
  802e5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802e5d:	6a 00                	push   $0x0
  802e5f:	6a 00                	push   $0x0
  802e61:	6a 00                	push   $0x0
  802e63:	6a 00                	push   $0x0
  802e65:	6a 00                	push   $0x0
  802e67:	6a 1e                	push   $0x1e
  802e69:	e8 64 fc ff ff       	call   802ad2 <syscall>
  802e6e:	83 c4 18             	add    $0x18,%esp
}
  802e71:	c9                   	leave  
  802e72:	c3                   	ret    

00802e73 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802e73:	55                   	push   %ebp
  802e74:	89 e5                	mov    %esp,%ebp
  802e76:	83 ec 04             	sub    $0x4,%esp
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802e7f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802e83:	6a 00                	push   $0x0
  802e85:	6a 00                	push   $0x0
  802e87:	6a 00                	push   $0x0
  802e89:	6a 00                	push   $0x0
  802e8b:	50                   	push   %eax
  802e8c:	6a 1f                	push   $0x1f
  802e8e:	e8 3f fc ff ff       	call   802ad2 <syscall>
  802e93:	83 c4 18             	add    $0x18,%esp
	return ;
  802e96:	90                   	nop
}
  802e97:	c9                   	leave  
  802e98:	c3                   	ret    

00802e99 <rsttst>:
void rsttst()
{
  802e99:	55                   	push   %ebp
  802e9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 00                	push   $0x0
  802ea0:	6a 00                	push   $0x0
  802ea2:	6a 00                	push   $0x0
  802ea4:	6a 00                	push   $0x0
  802ea6:	6a 21                	push   $0x21
  802ea8:	e8 25 fc ff ff       	call   802ad2 <syscall>
  802ead:	83 c4 18             	add    $0x18,%esp
	return ;
  802eb0:	90                   	nop
}
  802eb1:	c9                   	leave  
  802eb2:	c3                   	ret    

00802eb3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802eb3:	55                   	push   %ebp
  802eb4:	89 e5                	mov    %esp,%ebp
  802eb6:	83 ec 04             	sub    $0x4,%esp
  802eb9:	8b 45 14             	mov    0x14(%ebp),%eax
  802ebc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802ebf:	8b 55 18             	mov    0x18(%ebp),%edx
  802ec2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ec6:	52                   	push   %edx
  802ec7:	50                   	push   %eax
  802ec8:	ff 75 10             	pushl  0x10(%ebp)
  802ecb:	ff 75 0c             	pushl  0xc(%ebp)
  802ece:	ff 75 08             	pushl  0x8(%ebp)
  802ed1:	6a 20                	push   $0x20
  802ed3:	e8 fa fb ff ff       	call   802ad2 <syscall>
  802ed8:	83 c4 18             	add    $0x18,%esp
	return ;
  802edb:	90                   	nop
}
  802edc:	c9                   	leave  
  802edd:	c3                   	ret    

00802ede <chktst>:
void chktst(uint32 n)
{
  802ede:	55                   	push   %ebp
  802edf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802ee1:	6a 00                	push   $0x0
  802ee3:	6a 00                	push   $0x0
  802ee5:	6a 00                	push   $0x0
  802ee7:	6a 00                	push   $0x0
  802ee9:	ff 75 08             	pushl  0x8(%ebp)
  802eec:	6a 22                	push   $0x22
  802eee:	e8 df fb ff ff       	call   802ad2 <syscall>
  802ef3:	83 c4 18             	add    $0x18,%esp
	return ;
  802ef6:	90                   	nop
}
  802ef7:	c9                   	leave  
  802ef8:	c3                   	ret    

00802ef9 <inctst>:

void inctst()
{
  802ef9:	55                   	push   %ebp
  802efa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802efc:	6a 00                	push   $0x0
  802efe:	6a 00                	push   $0x0
  802f00:	6a 00                	push   $0x0
  802f02:	6a 00                	push   $0x0
  802f04:	6a 00                	push   $0x0
  802f06:	6a 23                	push   $0x23
  802f08:	e8 c5 fb ff ff       	call   802ad2 <syscall>
  802f0d:	83 c4 18             	add    $0x18,%esp
	return ;
  802f10:	90                   	nop
}
  802f11:	c9                   	leave  
  802f12:	c3                   	ret    

00802f13 <gettst>:
uint32 gettst()
{
  802f13:	55                   	push   %ebp
  802f14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802f16:	6a 00                	push   $0x0
  802f18:	6a 00                	push   $0x0
  802f1a:	6a 00                	push   $0x0
  802f1c:	6a 00                	push   $0x0
  802f1e:	6a 00                	push   $0x0
  802f20:	6a 24                	push   $0x24
  802f22:	e8 ab fb ff ff       	call   802ad2 <syscall>
  802f27:	83 c4 18             	add    $0x18,%esp
}
  802f2a:	c9                   	leave  
  802f2b:	c3                   	ret    

00802f2c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802f2c:	55                   	push   %ebp
  802f2d:	89 e5                	mov    %esp,%ebp
  802f2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f32:	6a 00                	push   $0x0
  802f34:	6a 00                	push   $0x0
  802f36:	6a 00                	push   $0x0
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	6a 25                	push   $0x25
  802f3e:	e8 8f fb ff ff       	call   802ad2 <syscall>
  802f43:	83 c4 18             	add    $0x18,%esp
  802f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802f49:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802f4d:	75 07                	jne    802f56 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802f4f:	b8 01 00 00 00       	mov    $0x1,%eax
  802f54:	eb 05                	jmp    802f5b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802f56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f5b:	c9                   	leave  
  802f5c:	c3                   	ret    

00802f5d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802f5d:	55                   	push   %ebp
  802f5e:	89 e5                	mov    %esp,%ebp
  802f60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f63:	6a 00                	push   $0x0
  802f65:	6a 00                	push   $0x0
  802f67:	6a 00                	push   $0x0
  802f69:	6a 00                	push   $0x0
  802f6b:	6a 00                	push   $0x0
  802f6d:	6a 25                	push   $0x25
  802f6f:	e8 5e fb ff ff       	call   802ad2 <syscall>
  802f74:	83 c4 18             	add    $0x18,%esp
  802f77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802f7a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802f7e:	75 07                	jne    802f87 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802f80:	b8 01 00 00 00       	mov    $0x1,%eax
  802f85:	eb 05                	jmp    802f8c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f8c:	c9                   	leave  
  802f8d:	c3                   	ret    

00802f8e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802f8e:	55                   	push   %ebp
  802f8f:	89 e5                	mov    %esp,%ebp
  802f91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f94:	6a 00                	push   $0x0
  802f96:	6a 00                	push   $0x0
  802f98:	6a 00                	push   $0x0
  802f9a:	6a 00                	push   $0x0
  802f9c:	6a 00                	push   $0x0
  802f9e:	6a 25                	push   $0x25
  802fa0:	e8 2d fb ff ff       	call   802ad2 <syscall>
  802fa5:	83 c4 18             	add    $0x18,%esp
  802fa8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802fab:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802faf:	75 07                	jne    802fb8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802fb1:	b8 01 00 00 00       	mov    $0x1,%eax
  802fb6:	eb 05                	jmp    802fbd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802fb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fbd:	c9                   	leave  
  802fbe:	c3                   	ret    

00802fbf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802fbf:	55                   	push   %ebp
  802fc0:	89 e5                	mov    %esp,%ebp
  802fc2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	6a 00                	push   $0x0
  802fcd:	6a 00                	push   $0x0
  802fcf:	6a 25                	push   $0x25
  802fd1:	e8 fc fa ff ff       	call   802ad2 <syscall>
  802fd6:	83 c4 18             	add    $0x18,%esp
  802fd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802fdc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802fe0:	75 07                	jne    802fe9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802fe2:	b8 01 00 00 00       	mov    $0x1,%eax
  802fe7:	eb 05                	jmp    802fee <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802fe9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fee:	c9                   	leave  
  802fef:	c3                   	ret    

00802ff0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ff0:	55                   	push   %ebp
  802ff1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802ff3:	6a 00                	push   $0x0
  802ff5:	6a 00                	push   $0x0
  802ff7:	6a 00                	push   $0x0
  802ff9:	6a 00                	push   $0x0
  802ffb:	ff 75 08             	pushl  0x8(%ebp)
  802ffe:	6a 26                	push   $0x26
  803000:	e8 cd fa ff ff       	call   802ad2 <syscall>
  803005:	83 c4 18             	add    $0x18,%esp
	return ;
  803008:	90                   	nop
}
  803009:	c9                   	leave  
  80300a:	c3                   	ret    

0080300b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80300b:	55                   	push   %ebp
  80300c:	89 e5                	mov    %esp,%ebp
  80300e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80300f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803012:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803015:	8b 55 0c             	mov    0xc(%ebp),%edx
  803018:	8b 45 08             	mov    0x8(%ebp),%eax
  80301b:	6a 00                	push   $0x0
  80301d:	53                   	push   %ebx
  80301e:	51                   	push   %ecx
  80301f:	52                   	push   %edx
  803020:	50                   	push   %eax
  803021:	6a 27                	push   $0x27
  803023:	e8 aa fa ff ff       	call   802ad2 <syscall>
  803028:	83 c4 18             	add    $0x18,%esp
}
  80302b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80302e:	c9                   	leave  
  80302f:	c3                   	ret    

00803030 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803030:	55                   	push   %ebp
  803031:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803033:	8b 55 0c             	mov    0xc(%ebp),%edx
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	6a 00                	push   $0x0
  80303b:	6a 00                	push   $0x0
  80303d:	6a 00                	push   $0x0
  80303f:	52                   	push   %edx
  803040:	50                   	push   %eax
  803041:	6a 28                	push   $0x28
  803043:	e8 8a fa ff ff       	call   802ad2 <syscall>
  803048:	83 c4 18             	add    $0x18,%esp
}
  80304b:	c9                   	leave  
  80304c:	c3                   	ret    

0080304d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80304d:	55                   	push   %ebp
  80304e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803050:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803053:	8b 55 0c             	mov    0xc(%ebp),%edx
  803056:	8b 45 08             	mov    0x8(%ebp),%eax
  803059:	6a 00                	push   $0x0
  80305b:	51                   	push   %ecx
  80305c:	ff 75 10             	pushl  0x10(%ebp)
  80305f:	52                   	push   %edx
  803060:	50                   	push   %eax
  803061:	6a 29                	push   $0x29
  803063:	e8 6a fa ff ff       	call   802ad2 <syscall>
  803068:	83 c4 18             	add    $0x18,%esp
}
  80306b:	c9                   	leave  
  80306c:	c3                   	ret    

0080306d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80306d:	55                   	push   %ebp
  80306e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803070:	6a 00                	push   $0x0
  803072:	6a 00                	push   $0x0
  803074:	ff 75 10             	pushl  0x10(%ebp)
  803077:	ff 75 0c             	pushl  0xc(%ebp)
  80307a:	ff 75 08             	pushl  0x8(%ebp)
  80307d:	6a 12                	push   $0x12
  80307f:	e8 4e fa ff ff       	call   802ad2 <syscall>
  803084:	83 c4 18             	add    $0x18,%esp
	return ;
  803087:	90                   	nop
}
  803088:	c9                   	leave  
  803089:	c3                   	ret    

0080308a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80308a:	55                   	push   %ebp
  80308b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80308d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	6a 00                	push   $0x0
  803095:	6a 00                	push   $0x0
  803097:	6a 00                	push   $0x0
  803099:	52                   	push   %edx
  80309a:	50                   	push   %eax
  80309b:	6a 2a                	push   $0x2a
  80309d:	e8 30 fa ff ff       	call   802ad2 <syscall>
  8030a2:	83 c4 18             	add    $0x18,%esp
	return;
  8030a5:	90                   	nop
}
  8030a6:	c9                   	leave  
  8030a7:	c3                   	ret    

008030a8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8030a8:	55                   	push   %ebp
  8030a9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	6a 00                	push   $0x0
  8030b0:	6a 00                	push   $0x0
  8030b2:	6a 00                	push   $0x0
  8030b4:	6a 00                	push   $0x0
  8030b6:	50                   	push   %eax
  8030b7:	6a 2b                	push   $0x2b
  8030b9:	e8 14 fa ff ff       	call   802ad2 <syscall>
  8030be:	83 c4 18             	add    $0x18,%esp
}
  8030c1:	c9                   	leave  
  8030c2:	c3                   	ret    

008030c3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8030c3:	55                   	push   %ebp
  8030c4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8030c6:	6a 00                	push   $0x0
  8030c8:	6a 00                	push   $0x0
  8030ca:	6a 00                	push   $0x0
  8030cc:	ff 75 0c             	pushl  0xc(%ebp)
  8030cf:	ff 75 08             	pushl  0x8(%ebp)
  8030d2:	6a 2c                	push   $0x2c
  8030d4:	e8 f9 f9 ff ff       	call   802ad2 <syscall>
  8030d9:	83 c4 18             	add    $0x18,%esp
	return;
  8030dc:	90                   	nop
}
  8030dd:	c9                   	leave  
  8030de:	c3                   	ret    

008030df <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8030df:	55                   	push   %ebp
  8030e0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8030e2:	6a 00                	push   $0x0
  8030e4:	6a 00                	push   $0x0
  8030e6:	6a 00                	push   $0x0
  8030e8:	ff 75 0c             	pushl  0xc(%ebp)
  8030eb:	ff 75 08             	pushl  0x8(%ebp)
  8030ee:	6a 2d                	push   $0x2d
  8030f0:	e8 dd f9 ff ff       	call   802ad2 <syscall>
  8030f5:	83 c4 18             	add    $0x18,%esp
	return;
  8030f8:	90                   	nop
}
  8030f9:	c9                   	leave  
  8030fa:	c3                   	ret    

008030fb <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8030fb:	55                   	push   %ebp
  8030fc:	89 e5                	mov    %esp,%ebp
  8030fe:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	83 e8 04             	sub    $0x4,%eax
  803107:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80310a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80310d:	8b 00                	mov    (%eax),%eax
  80310f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  803112:	c9                   	leave  
  803113:	c3                   	ret    

00803114 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  803114:	55                   	push   %ebp
  803115:	89 e5                	mov    %esp,%ebp
  803117:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80311a:	8b 45 08             	mov    0x8(%ebp),%eax
  80311d:	83 e8 04             	sub    $0x4,%eax
  803120:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  803123:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	83 e0 01             	and    $0x1,%eax
  80312b:	85 c0                	test   %eax,%eax
  80312d:	0f 94 c0             	sete   %al
}
  803130:	c9                   	leave  
  803131:	c3                   	ret    

00803132 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  803132:	55                   	push   %ebp
  803133:	89 e5                	mov    %esp,%ebp
  803135:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  803138:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80313f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803142:	83 f8 02             	cmp    $0x2,%eax
  803145:	74 2b                	je     803172 <alloc_block+0x40>
  803147:	83 f8 02             	cmp    $0x2,%eax
  80314a:	7f 07                	jg     803153 <alloc_block+0x21>
  80314c:	83 f8 01             	cmp    $0x1,%eax
  80314f:	74 0e                	je     80315f <alloc_block+0x2d>
  803151:	eb 58                	jmp    8031ab <alloc_block+0x79>
  803153:	83 f8 03             	cmp    $0x3,%eax
  803156:	74 2d                	je     803185 <alloc_block+0x53>
  803158:	83 f8 04             	cmp    $0x4,%eax
  80315b:	74 3b                	je     803198 <alloc_block+0x66>
  80315d:	eb 4c                	jmp    8031ab <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80315f:	83 ec 0c             	sub    $0xc,%esp
  803162:	ff 75 08             	pushl  0x8(%ebp)
  803165:	e8 11 03 00 00       	call   80347b <alloc_block_FF>
  80316a:	83 c4 10             	add    $0x10,%esp
  80316d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803170:	eb 4a                	jmp    8031bc <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  803172:	83 ec 0c             	sub    $0xc,%esp
  803175:	ff 75 08             	pushl  0x8(%ebp)
  803178:	e8 fa 19 00 00       	call   804b77 <alloc_block_NF>
  80317d:	83 c4 10             	add    $0x10,%esp
  803180:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803183:	eb 37                	jmp    8031bc <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  803185:	83 ec 0c             	sub    $0xc,%esp
  803188:	ff 75 08             	pushl  0x8(%ebp)
  80318b:	e8 a7 07 00 00       	call   803937 <alloc_block_BF>
  803190:	83 c4 10             	add    $0x10,%esp
  803193:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803196:	eb 24                	jmp    8031bc <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  803198:	83 ec 0c             	sub    $0xc,%esp
  80319b:	ff 75 08             	pushl  0x8(%ebp)
  80319e:	e8 b7 19 00 00       	call   804b5a <alloc_block_WF>
  8031a3:	83 c4 10             	add    $0x10,%esp
  8031a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8031a9:	eb 11                	jmp    8031bc <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8031ab:	83 ec 0c             	sub    $0xc,%esp
  8031ae:	68 ec 56 80 00       	push   $0x8056ec
  8031b3:	e8 b8 e6 ff ff       	call   801870 <cprintf>
  8031b8:	83 c4 10             	add    $0x10,%esp
		break;
  8031bb:	90                   	nop
	}
	return va;
  8031bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8031bf:	c9                   	leave  
  8031c0:	c3                   	ret    

008031c1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8031c1:	55                   	push   %ebp
  8031c2:	89 e5                	mov    %esp,%ebp
  8031c4:	53                   	push   %ebx
  8031c5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8031c8:	83 ec 0c             	sub    $0xc,%esp
  8031cb:	68 0c 57 80 00       	push   $0x80570c
  8031d0:	e8 9b e6 ff ff       	call   801870 <cprintf>
  8031d5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8031d8:	83 ec 0c             	sub    $0xc,%esp
  8031db:	68 37 57 80 00       	push   $0x805737
  8031e0:	e8 8b e6 ff ff       	call   801870 <cprintf>
  8031e5:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ee:	eb 37                	jmp    803227 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8031f0:	83 ec 0c             	sub    $0xc,%esp
  8031f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8031f6:	e8 19 ff ff ff       	call   803114 <is_free_block>
  8031fb:	83 c4 10             	add    $0x10,%esp
  8031fe:	0f be d8             	movsbl %al,%ebx
  803201:	83 ec 0c             	sub    $0xc,%esp
  803204:	ff 75 f4             	pushl  -0xc(%ebp)
  803207:	e8 ef fe ff ff       	call   8030fb <get_block_size>
  80320c:	83 c4 10             	add    $0x10,%esp
  80320f:	83 ec 04             	sub    $0x4,%esp
  803212:	53                   	push   %ebx
  803213:	50                   	push   %eax
  803214:	68 4f 57 80 00       	push   $0x80574f
  803219:	e8 52 e6 ff ff       	call   801870 <cprintf>
  80321e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  803221:	8b 45 10             	mov    0x10(%ebp),%eax
  803224:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322b:	74 07                	je     803234 <print_blocks_list+0x73>
  80322d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803230:	8b 00                	mov    (%eax),%eax
  803232:	eb 05                	jmp    803239 <print_blocks_list+0x78>
  803234:	b8 00 00 00 00       	mov    $0x0,%eax
  803239:	89 45 10             	mov    %eax,0x10(%ebp)
  80323c:	8b 45 10             	mov    0x10(%ebp),%eax
  80323f:	85 c0                	test   %eax,%eax
  803241:	75 ad                	jne    8031f0 <print_blocks_list+0x2f>
  803243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803247:	75 a7                	jne    8031f0 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  803249:	83 ec 0c             	sub    $0xc,%esp
  80324c:	68 0c 57 80 00       	push   $0x80570c
  803251:	e8 1a e6 ff ff       	call   801870 <cprintf>
  803256:	83 c4 10             	add    $0x10,%esp

}
  803259:	90                   	nop
  80325a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80325d:	c9                   	leave  
  80325e:	c3                   	ret    

0080325f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80325f:	55                   	push   %ebp
  803260:	89 e5                	mov    %esp,%ebp
  803262:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  803265:	8b 45 0c             	mov    0xc(%ebp),%eax
  803268:	83 e0 01             	and    $0x1,%eax
  80326b:	85 c0                	test   %eax,%eax
  80326d:	74 03                	je     803272 <initialize_dynamic_allocator+0x13>
  80326f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  803272:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803276:	0f 84 c7 01 00 00    	je     803443 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80327c:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  803283:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  803286:	8b 55 08             	mov    0x8(%ebp),%edx
  803289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80328c:	01 d0                	add    %edx,%eax
  80328e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  803293:	0f 87 ad 01 00 00    	ja     803446 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	85 c0                	test   %eax,%eax
  80329e:	0f 89 a5 01 00 00    	jns    803449 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8032a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032aa:	01 d0                	add    %edx,%eax
  8032ac:	83 e8 04             	sub    $0x4,%eax
  8032af:	a3 44 60 80 00       	mov    %eax,0x806044
     struct BlockElement * element = NULL;
  8032b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8032bb:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8032c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032c3:	e9 87 00 00 00       	jmp    80334f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8032c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032cc:	75 14                	jne    8032e2 <initialize_dynamic_allocator+0x83>
  8032ce:	83 ec 04             	sub    $0x4,%esp
  8032d1:	68 67 57 80 00       	push   $0x805767
  8032d6:	6a 79                	push   $0x79
  8032d8:	68 85 57 80 00       	push   $0x805785
  8032dd:	e8 d1 e2 ff ff       	call   8015b3 <_panic>
  8032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	85 c0                	test   %eax,%eax
  8032e9:	74 10                	je     8032fb <initialize_dynamic_allocator+0x9c>
  8032eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ee:	8b 00                	mov    (%eax),%eax
  8032f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f3:	8b 52 04             	mov    0x4(%edx),%edx
  8032f6:	89 50 04             	mov    %edx,0x4(%eax)
  8032f9:	eb 0b                	jmp    803306 <initialize_dynamic_allocator+0xa7>
  8032fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fe:	8b 40 04             	mov    0x4(%eax),%eax
  803301:	a3 30 60 80 00       	mov    %eax,0x806030
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	8b 40 04             	mov    0x4(%eax),%eax
  80330c:	85 c0                	test   %eax,%eax
  80330e:	74 0f                	je     80331f <initialize_dynamic_allocator+0xc0>
  803310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803313:	8b 40 04             	mov    0x4(%eax),%eax
  803316:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803319:	8b 12                	mov    (%edx),%edx
  80331b:	89 10                	mov    %edx,(%eax)
  80331d:	eb 0a                	jmp    803329 <initialize_dynamic_allocator+0xca>
  80331f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803322:	8b 00                	mov    (%eax),%eax
  803324:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803335:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333c:	a1 38 60 80 00       	mov    0x806038,%eax
  803341:	48                   	dec    %eax
  803342:	a3 38 60 80 00       	mov    %eax,0x806038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  803347:	a1 34 60 80 00       	mov    0x806034,%eax
  80334c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80334f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803353:	74 07                	je     80335c <initialize_dynamic_allocator+0xfd>
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	8b 00                	mov    (%eax),%eax
  80335a:	eb 05                	jmp    803361 <initialize_dynamic_allocator+0x102>
  80335c:	b8 00 00 00 00       	mov    $0x0,%eax
  803361:	a3 34 60 80 00       	mov    %eax,0x806034
  803366:	a1 34 60 80 00       	mov    0x806034,%eax
  80336b:	85 c0                	test   %eax,%eax
  80336d:	0f 85 55 ff ff ff    	jne    8032c8 <initialize_dynamic_allocator+0x69>
  803373:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803377:	0f 85 4b ff ff ff    	jne    8032c8 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  803383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803386:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80338c:	a1 44 60 80 00       	mov    0x806044,%eax
  803391:	a3 40 60 80 00       	mov    %eax,0x806040
    end_block->info = 1;
  803396:	a1 40 60 80 00       	mov    0x806040,%eax
  80339b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8033a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a4:	83 c0 08             	add    $0x8,%eax
  8033a7:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	83 c0 04             	add    $0x4,%eax
  8033b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033b3:	83 ea 08             	sub    $0x8,%edx
  8033b6:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8033b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	01 d0                	add    %edx,%eax
  8033c0:	83 e8 08             	sub    $0x8,%eax
  8033c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033c6:	83 ea 08             	sub    $0x8,%edx
  8033c9:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8033cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8033d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8033de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033e2:	75 17                	jne    8033fb <initialize_dynamic_allocator+0x19c>
  8033e4:	83 ec 04             	sub    $0x4,%esp
  8033e7:	68 a0 57 80 00       	push   $0x8057a0
  8033ec:	68 90 00 00 00       	push   $0x90
  8033f1:	68 85 57 80 00       	push   $0x805785
  8033f6:	e8 b8 e1 ff ff       	call   8015b3 <_panic>
  8033fb:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803404:	89 10                	mov    %edx,(%eax)
  803406:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803409:	8b 00                	mov    (%eax),%eax
  80340b:	85 c0                	test   %eax,%eax
  80340d:	74 0d                	je     80341c <initialize_dynamic_allocator+0x1bd>
  80340f:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803414:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803417:	89 50 04             	mov    %edx,0x4(%eax)
  80341a:	eb 08                	jmp    803424 <initialize_dynamic_allocator+0x1c5>
  80341c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80341f:	a3 30 60 80 00       	mov    %eax,0x806030
  803424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803427:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80342c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803436:	a1 38 60 80 00       	mov    0x806038,%eax
  80343b:	40                   	inc    %eax
  80343c:	a3 38 60 80 00       	mov    %eax,0x806038
  803441:	eb 07                	jmp    80344a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  803443:	90                   	nop
  803444:	eb 04                	jmp    80344a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  803446:	90                   	nop
  803447:	eb 01                	jmp    80344a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  803449:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80344a:	c9                   	leave  
  80344b:	c3                   	ret    

0080344c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80344c:	55                   	push   %ebp
  80344d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80344f:	8b 45 10             	mov    0x10(%ebp),%eax
  803452:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	8d 50 fc             	lea    -0x4(%eax),%edx
  80345b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80345e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  803460:	8b 45 08             	mov    0x8(%ebp),%eax
  803463:	83 e8 04             	sub    $0x4,%eax
  803466:	8b 00                	mov    (%eax),%eax
  803468:	83 e0 fe             	and    $0xfffffffe,%eax
  80346b:	8d 50 f8             	lea    -0x8(%eax),%edx
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	01 c2                	add    %eax,%edx
  803473:	8b 45 0c             	mov    0xc(%ebp),%eax
  803476:	89 02                	mov    %eax,(%edx)
}
  803478:	90                   	nop
  803479:	5d                   	pop    %ebp
  80347a:	c3                   	ret    

0080347b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80347b:	55                   	push   %ebp
  80347c:	89 e5                	mov    %esp,%ebp
  80347e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803481:	8b 45 08             	mov    0x8(%ebp),%eax
  803484:	83 e0 01             	and    $0x1,%eax
  803487:	85 c0                	test   %eax,%eax
  803489:	74 03                	je     80348e <alloc_block_FF+0x13>
  80348b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80348e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803492:	77 07                	ja     80349b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803494:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80349b:	a1 24 60 80 00       	mov    0x806024,%eax
  8034a0:	85 c0                	test   %eax,%eax
  8034a2:	75 73                	jne    803517 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8034a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a7:	83 c0 10             	add    $0x10,%eax
  8034aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8034ad:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8034b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ba:	01 d0                	add    %edx,%eax
  8034bc:	48                   	dec    %eax
  8034bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8034c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8034c8:	f7 75 ec             	divl   -0x14(%ebp)
  8034cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ce:	29 d0                	sub    %edx,%eax
  8034d0:	c1 e8 0c             	shr    $0xc,%eax
  8034d3:	83 ec 0c             	sub    $0xc,%esp
  8034d6:	50                   	push   %eax
  8034d7:	e8 2e f1 ff ff       	call   80260a <sbrk>
  8034dc:	83 c4 10             	add    $0x10,%esp
  8034df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8034e2:	83 ec 0c             	sub    $0xc,%esp
  8034e5:	6a 00                	push   $0x0
  8034e7:	e8 1e f1 ff ff       	call   80260a <sbrk>
  8034ec:	83 c4 10             	add    $0x10,%esp
  8034ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8034f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034f5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8034f8:	83 ec 08             	sub    $0x8,%esp
  8034fb:	50                   	push   %eax
  8034fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034ff:	e8 5b fd ff ff       	call   80325f <initialize_dynamic_allocator>
  803504:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  803507:	83 ec 0c             	sub    $0xc,%esp
  80350a:	68 c3 57 80 00       	push   $0x8057c3
  80350f:	e8 5c e3 ff ff       	call   801870 <cprintf>
  803514:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  803517:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80351b:	75 0a                	jne    803527 <alloc_block_FF+0xac>
	        return NULL;
  80351d:	b8 00 00 00 00       	mov    $0x0,%eax
  803522:	e9 0e 04 00 00       	jmp    803935 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  803527:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80352e:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803533:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803536:	e9 f3 02 00 00       	jmp    80382e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80353b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  803541:	83 ec 0c             	sub    $0xc,%esp
  803544:	ff 75 bc             	pushl  -0x44(%ebp)
  803547:	e8 af fb ff ff       	call   8030fb <get_block_size>
  80354c:	83 c4 10             	add    $0x10,%esp
  80354f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  803552:	8b 45 08             	mov    0x8(%ebp),%eax
  803555:	83 c0 08             	add    $0x8,%eax
  803558:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80355b:	0f 87 c5 02 00 00    	ja     803826 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803561:	8b 45 08             	mov    0x8(%ebp),%eax
  803564:	83 c0 18             	add    $0x18,%eax
  803567:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80356a:	0f 87 19 02 00 00    	ja     803789 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  803570:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803573:	2b 45 08             	sub    0x8(%ebp),%eax
  803576:	83 e8 08             	sub    $0x8,%eax
  803579:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80357c:	8b 45 08             	mov    0x8(%ebp),%eax
  80357f:	8d 50 08             	lea    0x8(%eax),%edx
  803582:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803585:	01 d0                	add    %edx,%eax
  803587:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	83 c0 08             	add    $0x8,%eax
  803590:	83 ec 04             	sub    $0x4,%esp
  803593:	6a 01                	push   $0x1
  803595:	50                   	push   %eax
  803596:	ff 75 bc             	pushl  -0x44(%ebp)
  803599:	e8 ae fe ff ff       	call   80344c <set_block_data>
  80359e:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a4:	8b 40 04             	mov    0x4(%eax),%eax
  8035a7:	85 c0                	test   %eax,%eax
  8035a9:	75 68                	jne    803613 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8035ab:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8035af:	75 17                	jne    8035c8 <alloc_block_FF+0x14d>
  8035b1:	83 ec 04             	sub    $0x4,%esp
  8035b4:	68 a0 57 80 00       	push   $0x8057a0
  8035b9:	68 d7 00 00 00       	push   $0xd7
  8035be:	68 85 57 80 00       	push   $0x805785
  8035c3:	e8 eb df ff ff       	call   8015b3 <_panic>
  8035c8:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8035ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035d1:	89 10                	mov    %edx,(%eax)
  8035d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035d6:	8b 00                	mov    (%eax),%eax
  8035d8:	85 c0                	test   %eax,%eax
  8035da:	74 0d                	je     8035e9 <alloc_block_FF+0x16e>
  8035dc:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8035e1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8035e4:	89 50 04             	mov    %edx,0x4(%eax)
  8035e7:	eb 08                	jmp    8035f1 <alloc_block_FF+0x176>
  8035e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035ec:	a3 30 60 80 00       	mov    %eax,0x806030
  8035f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035f4:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8035f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8035fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803603:	a1 38 60 80 00       	mov    0x806038,%eax
  803608:	40                   	inc    %eax
  803609:	a3 38 60 80 00       	mov    %eax,0x806038
  80360e:	e9 dc 00 00 00       	jmp    8036ef <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	8b 00                	mov    (%eax),%eax
  803618:	85 c0                	test   %eax,%eax
  80361a:	75 65                	jne    803681 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80361c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  803620:	75 17                	jne    803639 <alloc_block_FF+0x1be>
  803622:	83 ec 04             	sub    $0x4,%esp
  803625:	68 d4 57 80 00       	push   $0x8057d4
  80362a:	68 db 00 00 00       	push   $0xdb
  80362f:	68 85 57 80 00       	push   $0x805785
  803634:	e8 7a df ff ff       	call   8015b3 <_panic>
  803639:	8b 15 30 60 80 00    	mov    0x806030,%edx
  80363f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803642:	89 50 04             	mov    %edx,0x4(%eax)
  803645:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803648:	8b 40 04             	mov    0x4(%eax),%eax
  80364b:	85 c0                	test   %eax,%eax
  80364d:	74 0c                	je     80365b <alloc_block_FF+0x1e0>
  80364f:	a1 30 60 80 00       	mov    0x806030,%eax
  803654:	8b 55 b0             	mov    -0x50(%ebp),%edx
  803657:	89 10                	mov    %edx,(%eax)
  803659:	eb 08                	jmp    803663 <alloc_block_FF+0x1e8>
  80365b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80365e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803663:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803666:	a3 30 60 80 00       	mov    %eax,0x806030
  80366b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80366e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803674:	a1 38 60 80 00       	mov    0x806038,%eax
  803679:	40                   	inc    %eax
  80367a:	a3 38 60 80 00       	mov    %eax,0x806038
  80367f:	eb 6e                	jmp    8036ef <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  803681:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803685:	74 06                	je     80368d <alloc_block_FF+0x212>
  803687:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80368b:	75 17                	jne    8036a4 <alloc_block_FF+0x229>
  80368d:	83 ec 04             	sub    $0x4,%esp
  803690:	68 f8 57 80 00       	push   $0x8057f8
  803695:	68 df 00 00 00       	push   $0xdf
  80369a:	68 85 57 80 00       	push   $0x805785
  80369f:	e8 0f df ff ff       	call   8015b3 <_panic>
  8036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a7:	8b 10                	mov    (%eax),%edx
  8036a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036ac:	89 10                	mov    %edx,(%eax)
  8036ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036b1:	8b 00                	mov    (%eax),%eax
  8036b3:	85 c0                	test   %eax,%eax
  8036b5:	74 0b                	je     8036c2 <alloc_block_FF+0x247>
  8036b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ba:	8b 00                	mov    (%eax),%eax
  8036bc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8036bf:	89 50 04             	mov    %edx,0x4(%eax)
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8036c8:	89 10                	mov    %edx,(%eax)
  8036ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036d0:	89 50 04             	mov    %edx,0x4(%eax)
  8036d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036d6:	8b 00                	mov    (%eax),%eax
  8036d8:	85 c0                	test   %eax,%eax
  8036da:	75 08                	jne    8036e4 <alloc_block_FF+0x269>
  8036dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8036df:	a3 30 60 80 00       	mov    %eax,0x806030
  8036e4:	a1 38 60 80 00       	mov    0x806038,%eax
  8036e9:	40                   	inc    %eax
  8036ea:	a3 38 60 80 00       	mov    %eax,0x806038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8036ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036f3:	75 17                	jne    80370c <alloc_block_FF+0x291>
  8036f5:	83 ec 04             	sub    $0x4,%esp
  8036f8:	68 67 57 80 00       	push   $0x805767
  8036fd:	68 e1 00 00 00       	push   $0xe1
  803702:	68 85 57 80 00       	push   $0x805785
  803707:	e8 a7 de ff ff       	call   8015b3 <_panic>
  80370c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370f:	8b 00                	mov    (%eax),%eax
  803711:	85 c0                	test   %eax,%eax
  803713:	74 10                	je     803725 <alloc_block_FF+0x2aa>
  803715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803718:	8b 00                	mov    (%eax),%eax
  80371a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80371d:	8b 52 04             	mov    0x4(%edx),%edx
  803720:	89 50 04             	mov    %edx,0x4(%eax)
  803723:	eb 0b                	jmp    803730 <alloc_block_FF+0x2b5>
  803725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803728:	8b 40 04             	mov    0x4(%eax),%eax
  80372b:	a3 30 60 80 00       	mov    %eax,0x806030
  803730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803733:	8b 40 04             	mov    0x4(%eax),%eax
  803736:	85 c0                	test   %eax,%eax
  803738:	74 0f                	je     803749 <alloc_block_FF+0x2ce>
  80373a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373d:	8b 40 04             	mov    0x4(%eax),%eax
  803740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803743:	8b 12                	mov    (%edx),%edx
  803745:	89 10                	mov    %edx,(%eax)
  803747:	eb 0a                	jmp    803753 <alloc_block_FF+0x2d8>
  803749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374c:	8b 00                	mov    (%eax),%eax
  80374e:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803756:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80375c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803766:	a1 38 60 80 00       	mov    0x806038,%eax
  80376b:	48                   	dec    %eax
  80376c:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(new_block_va, remaining_size, 0);
  803771:	83 ec 04             	sub    $0x4,%esp
  803774:	6a 00                	push   $0x0
  803776:	ff 75 b4             	pushl  -0x4c(%ebp)
  803779:	ff 75 b0             	pushl  -0x50(%ebp)
  80377c:	e8 cb fc ff ff       	call   80344c <set_block_data>
  803781:	83 c4 10             	add    $0x10,%esp
  803784:	e9 95 00 00 00       	jmp    80381e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  803789:	83 ec 04             	sub    $0x4,%esp
  80378c:	6a 01                	push   $0x1
  80378e:	ff 75 b8             	pushl  -0x48(%ebp)
  803791:	ff 75 bc             	pushl  -0x44(%ebp)
  803794:	e8 b3 fc ff ff       	call   80344c <set_block_data>
  803799:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80379c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037a0:	75 17                	jne    8037b9 <alloc_block_FF+0x33e>
  8037a2:	83 ec 04             	sub    $0x4,%esp
  8037a5:	68 67 57 80 00       	push   $0x805767
  8037aa:	68 e8 00 00 00       	push   $0xe8
  8037af:	68 85 57 80 00       	push   $0x805785
  8037b4:	e8 fa dd ff ff       	call   8015b3 <_panic>
  8037b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bc:	8b 00                	mov    (%eax),%eax
  8037be:	85 c0                	test   %eax,%eax
  8037c0:	74 10                	je     8037d2 <alloc_block_FF+0x357>
  8037c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c5:	8b 00                	mov    (%eax),%eax
  8037c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037ca:	8b 52 04             	mov    0x4(%edx),%edx
  8037cd:	89 50 04             	mov    %edx,0x4(%eax)
  8037d0:	eb 0b                	jmp    8037dd <alloc_block_FF+0x362>
  8037d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d5:	8b 40 04             	mov    0x4(%eax),%eax
  8037d8:	a3 30 60 80 00       	mov    %eax,0x806030
  8037dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e0:	8b 40 04             	mov    0x4(%eax),%eax
  8037e3:	85 c0                	test   %eax,%eax
  8037e5:	74 0f                	je     8037f6 <alloc_block_FF+0x37b>
  8037e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ea:	8b 40 04             	mov    0x4(%eax),%eax
  8037ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037f0:	8b 12                	mov    (%edx),%edx
  8037f2:	89 10                	mov    %edx,(%eax)
  8037f4:	eb 0a                	jmp    803800 <alloc_block_FF+0x385>
  8037f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f9:	8b 00                	mov    (%eax),%eax
  8037fb:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803803:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803813:	a1 38 60 80 00       	mov    0x806038,%eax
  803818:	48                   	dec    %eax
  803819:	a3 38 60 80 00       	mov    %eax,0x806038
	            }
	            return va;
  80381e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803821:	e9 0f 01 00 00       	jmp    803935 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  803826:	a1 34 60 80 00       	mov    0x806034,%eax
  80382b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80382e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803832:	74 07                	je     80383b <alloc_block_FF+0x3c0>
  803834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803837:	8b 00                	mov    (%eax),%eax
  803839:	eb 05                	jmp    803840 <alloc_block_FF+0x3c5>
  80383b:	b8 00 00 00 00       	mov    $0x0,%eax
  803840:	a3 34 60 80 00       	mov    %eax,0x806034
  803845:	a1 34 60 80 00       	mov    0x806034,%eax
  80384a:	85 c0                	test   %eax,%eax
  80384c:	0f 85 e9 fc ff ff    	jne    80353b <alloc_block_FF+0xc0>
  803852:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803856:	0f 85 df fc ff ff    	jne    80353b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80385c:	8b 45 08             	mov    0x8(%ebp),%eax
  80385f:	83 c0 08             	add    $0x8,%eax
  803862:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803865:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80386c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80386f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803872:	01 d0                	add    %edx,%eax
  803874:	48                   	dec    %eax
  803875:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803878:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80387b:	ba 00 00 00 00       	mov    $0x0,%edx
  803880:	f7 75 d8             	divl   -0x28(%ebp)
  803883:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803886:	29 d0                	sub    %edx,%eax
  803888:	c1 e8 0c             	shr    $0xc,%eax
  80388b:	83 ec 0c             	sub    $0xc,%esp
  80388e:	50                   	push   %eax
  80388f:	e8 76 ed ff ff       	call   80260a <sbrk>
  803894:	83 c4 10             	add    $0x10,%esp
  803897:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80389a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80389e:	75 0a                	jne    8038aa <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8038a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038a5:	e9 8b 00 00 00       	jmp    803935 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8038aa:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8038b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8038b7:	01 d0                	add    %edx,%eax
  8038b9:	48                   	dec    %eax
  8038ba:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8038bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8038c5:	f7 75 cc             	divl   -0x34(%ebp)
  8038c8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8038cb:	29 d0                	sub    %edx,%eax
  8038cd:	8d 50 fc             	lea    -0x4(%eax),%edx
  8038d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8038d3:	01 d0                	add    %edx,%eax
  8038d5:	a3 40 60 80 00       	mov    %eax,0x806040
			end_block->info = 1;
  8038da:	a1 40 60 80 00       	mov    0x806040,%eax
  8038df:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8038e5:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8038ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8038ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038f2:	01 d0                	add    %edx,%eax
  8038f4:	48                   	dec    %eax
  8038f5:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8038f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8038fb:	ba 00 00 00 00       	mov    $0x0,%edx
  803900:	f7 75 c4             	divl   -0x3c(%ebp)
  803903:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803906:	29 d0                	sub    %edx,%eax
  803908:	83 ec 04             	sub    $0x4,%esp
  80390b:	6a 01                	push   $0x1
  80390d:	50                   	push   %eax
  80390e:	ff 75 d0             	pushl  -0x30(%ebp)
  803911:	e8 36 fb ff ff       	call   80344c <set_block_data>
  803916:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  803919:	83 ec 0c             	sub    $0xc,%esp
  80391c:	ff 75 d0             	pushl  -0x30(%ebp)
  80391f:	e8 1b 0a 00 00       	call   80433f <free_block>
  803924:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  803927:	83 ec 0c             	sub    $0xc,%esp
  80392a:	ff 75 08             	pushl  0x8(%ebp)
  80392d:	e8 49 fb ff ff       	call   80347b <alloc_block_FF>
  803932:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  803935:	c9                   	leave  
  803936:	c3                   	ret    

00803937 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803937:	55                   	push   %ebp
  803938:	89 e5                	mov    %esp,%ebp
  80393a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80393d:	8b 45 08             	mov    0x8(%ebp),%eax
  803940:	83 e0 01             	and    $0x1,%eax
  803943:	85 c0                	test   %eax,%eax
  803945:	74 03                	je     80394a <alloc_block_BF+0x13>
  803947:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80394a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80394e:	77 07                	ja     803957 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803950:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803957:	a1 24 60 80 00       	mov    0x806024,%eax
  80395c:	85 c0                	test   %eax,%eax
  80395e:	75 73                	jne    8039d3 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803960:	8b 45 08             	mov    0x8(%ebp),%eax
  803963:	83 c0 10             	add    $0x10,%eax
  803966:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803969:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  803970:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803973:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803976:	01 d0                	add    %edx,%eax
  803978:	48                   	dec    %eax
  803979:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80397c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80397f:	ba 00 00 00 00       	mov    $0x0,%edx
  803984:	f7 75 e0             	divl   -0x20(%ebp)
  803987:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80398a:	29 d0                	sub    %edx,%eax
  80398c:	c1 e8 0c             	shr    $0xc,%eax
  80398f:	83 ec 0c             	sub    $0xc,%esp
  803992:	50                   	push   %eax
  803993:	e8 72 ec ff ff       	call   80260a <sbrk>
  803998:	83 c4 10             	add    $0x10,%esp
  80399b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80399e:	83 ec 0c             	sub    $0xc,%esp
  8039a1:	6a 00                	push   $0x0
  8039a3:	e8 62 ec ff ff       	call   80260a <sbrk>
  8039a8:	83 c4 10             	add    $0x10,%esp
  8039ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8039ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8039b1:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8039b4:	83 ec 08             	sub    $0x8,%esp
  8039b7:	50                   	push   %eax
  8039b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8039bb:	e8 9f f8 ff ff       	call   80325f <initialize_dynamic_allocator>
  8039c0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8039c3:	83 ec 0c             	sub    $0xc,%esp
  8039c6:	68 c3 57 80 00       	push   $0x8057c3
  8039cb:	e8 a0 de ff ff       	call   801870 <cprintf>
  8039d0:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8039d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8039da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8039e1:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8039e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8039ef:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8039f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039f7:	e9 1d 01 00 00       	jmp    803b19 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8039fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ff:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  803a02:	83 ec 0c             	sub    $0xc,%esp
  803a05:	ff 75 a8             	pushl  -0x58(%ebp)
  803a08:	e8 ee f6 ff ff       	call   8030fb <get_block_size>
  803a0d:	83 c4 10             	add    $0x10,%esp
  803a10:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  803a13:	8b 45 08             	mov    0x8(%ebp),%eax
  803a16:	83 c0 08             	add    $0x8,%eax
  803a19:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803a1c:	0f 87 ef 00 00 00    	ja     803b11 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  803a22:	8b 45 08             	mov    0x8(%ebp),%eax
  803a25:	83 c0 18             	add    $0x18,%eax
  803a28:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803a2b:	77 1d                	ja     803a4a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  803a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a30:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803a33:	0f 86 d8 00 00 00    	jbe    803b11 <alloc_block_BF+0x1da>
				{
					best_va = va;
  803a39:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  803a3f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803a42:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803a45:	e9 c7 00 00 00       	jmp    803b11 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  803a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4d:	83 c0 08             	add    $0x8,%eax
  803a50:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803a53:	0f 85 9d 00 00 00    	jne    803af6 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  803a59:	83 ec 04             	sub    $0x4,%esp
  803a5c:	6a 01                	push   $0x1
  803a5e:	ff 75 a4             	pushl  -0x5c(%ebp)
  803a61:	ff 75 a8             	pushl  -0x58(%ebp)
  803a64:	e8 e3 f9 ff ff       	call   80344c <set_block_data>
  803a69:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  803a6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a70:	75 17                	jne    803a89 <alloc_block_BF+0x152>
  803a72:	83 ec 04             	sub    $0x4,%esp
  803a75:	68 67 57 80 00       	push   $0x805767
  803a7a:	68 2c 01 00 00       	push   $0x12c
  803a7f:	68 85 57 80 00       	push   $0x805785
  803a84:	e8 2a db ff ff       	call   8015b3 <_panic>
  803a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8c:	8b 00                	mov    (%eax),%eax
  803a8e:	85 c0                	test   %eax,%eax
  803a90:	74 10                	je     803aa2 <alloc_block_BF+0x16b>
  803a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a95:	8b 00                	mov    (%eax),%eax
  803a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a9a:	8b 52 04             	mov    0x4(%edx),%edx
  803a9d:	89 50 04             	mov    %edx,0x4(%eax)
  803aa0:	eb 0b                	jmp    803aad <alloc_block_BF+0x176>
  803aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa5:	8b 40 04             	mov    0x4(%eax),%eax
  803aa8:	a3 30 60 80 00       	mov    %eax,0x806030
  803aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab0:	8b 40 04             	mov    0x4(%eax),%eax
  803ab3:	85 c0                	test   %eax,%eax
  803ab5:	74 0f                	je     803ac6 <alloc_block_BF+0x18f>
  803ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aba:	8b 40 04             	mov    0x4(%eax),%eax
  803abd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ac0:	8b 12                	mov    (%edx),%edx
  803ac2:	89 10                	mov    %edx,(%eax)
  803ac4:	eb 0a                	jmp    803ad0 <alloc_block_BF+0x199>
  803ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac9:	8b 00                	mov    (%eax),%eax
  803acb:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ae3:	a1 38 60 80 00       	mov    0x806038,%eax
  803ae8:	48                   	dec    %eax
  803ae9:	a3 38 60 80 00       	mov    %eax,0x806038
					return va;
  803aee:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803af1:	e9 24 04 00 00       	jmp    803f1a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  803af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af9:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  803afc:	76 13                	jbe    803b11 <alloc_block_BF+0x1da>
					{
						internal = 1;
  803afe:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  803b05:	8b 45 a8             	mov    -0x58(%ebp),%eax
  803b08:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  803b0b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803b0e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  803b11:	a1 34 60 80 00       	mov    0x806034,%eax
  803b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b1d:	74 07                	je     803b26 <alloc_block_BF+0x1ef>
  803b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b22:	8b 00                	mov    (%eax),%eax
  803b24:	eb 05                	jmp    803b2b <alloc_block_BF+0x1f4>
  803b26:	b8 00 00 00 00       	mov    $0x0,%eax
  803b2b:	a3 34 60 80 00       	mov    %eax,0x806034
  803b30:	a1 34 60 80 00       	mov    0x806034,%eax
  803b35:	85 c0                	test   %eax,%eax
  803b37:	0f 85 bf fe ff ff    	jne    8039fc <alloc_block_BF+0xc5>
  803b3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b41:	0f 85 b5 fe ff ff    	jne    8039fc <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  803b47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b4b:	0f 84 26 02 00 00    	je     803d77 <alloc_block_BF+0x440>
  803b51:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b55:	0f 85 1c 02 00 00    	jne    803d77 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  803b5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b5e:	2b 45 08             	sub    0x8(%ebp),%eax
  803b61:	83 e8 08             	sub    $0x8,%eax
  803b64:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  803b67:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6a:	8d 50 08             	lea    0x8(%eax),%edx
  803b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b70:	01 d0                	add    %edx,%eax
  803b72:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  803b75:	8b 45 08             	mov    0x8(%ebp),%eax
  803b78:	83 c0 08             	add    $0x8,%eax
  803b7b:	83 ec 04             	sub    $0x4,%esp
  803b7e:	6a 01                	push   $0x1
  803b80:	50                   	push   %eax
  803b81:	ff 75 f0             	pushl  -0x10(%ebp)
  803b84:	e8 c3 f8 ff ff       	call   80344c <set_block_data>
  803b89:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  803b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b8f:	8b 40 04             	mov    0x4(%eax),%eax
  803b92:	85 c0                	test   %eax,%eax
  803b94:	75 68                	jne    803bfe <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803b96:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803b9a:	75 17                	jne    803bb3 <alloc_block_BF+0x27c>
  803b9c:	83 ec 04             	sub    $0x4,%esp
  803b9f:	68 a0 57 80 00       	push   $0x8057a0
  803ba4:	68 45 01 00 00       	push   $0x145
  803ba9:	68 85 57 80 00       	push   $0x805785
  803bae:	e8 00 da ff ff       	call   8015b3 <_panic>
  803bb3:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  803bb9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803bbc:	89 10                	mov    %edx,(%eax)
  803bbe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803bc1:	8b 00                	mov    (%eax),%eax
  803bc3:	85 c0                	test   %eax,%eax
  803bc5:	74 0d                	je     803bd4 <alloc_block_BF+0x29d>
  803bc7:	a1 2c 60 80 00       	mov    0x80602c,%eax
  803bcc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803bcf:	89 50 04             	mov    %edx,0x4(%eax)
  803bd2:	eb 08                	jmp    803bdc <alloc_block_BF+0x2a5>
  803bd4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803bd7:	a3 30 60 80 00       	mov    %eax,0x806030
  803bdc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803bdf:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803be4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803be7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bee:	a1 38 60 80 00       	mov    0x806038,%eax
  803bf3:	40                   	inc    %eax
  803bf4:	a3 38 60 80 00       	mov    %eax,0x806038
  803bf9:	e9 dc 00 00 00       	jmp    803cda <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  803bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c01:	8b 00                	mov    (%eax),%eax
  803c03:	85 c0                	test   %eax,%eax
  803c05:	75 65                	jne    803c6c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803c07:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803c0b:	75 17                	jne    803c24 <alloc_block_BF+0x2ed>
  803c0d:	83 ec 04             	sub    $0x4,%esp
  803c10:	68 d4 57 80 00       	push   $0x8057d4
  803c15:	68 4a 01 00 00       	push   $0x14a
  803c1a:	68 85 57 80 00       	push   $0x805785
  803c1f:	e8 8f d9 ff ff       	call   8015b3 <_panic>
  803c24:	8b 15 30 60 80 00    	mov    0x806030,%edx
  803c2a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c2d:	89 50 04             	mov    %edx,0x4(%eax)
  803c30:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c33:	8b 40 04             	mov    0x4(%eax),%eax
  803c36:	85 c0                	test   %eax,%eax
  803c38:	74 0c                	je     803c46 <alloc_block_BF+0x30f>
  803c3a:	a1 30 60 80 00       	mov    0x806030,%eax
  803c3f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803c42:	89 10                	mov    %edx,(%eax)
  803c44:	eb 08                	jmp    803c4e <alloc_block_BF+0x317>
  803c46:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c49:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803c4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c51:	a3 30 60 80 00       	mov    %eax,0x806030
  803c56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c5f:	a1 38 60 80 00       	mov    0x806038,%eax
  803c64:	40                   	inc    %eax
  803c65:	a3 38 60 80 00       	mov    %eax,0x806038
  803c6a:	eb 6e                	jmp    803cda <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  803c6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c70:	74 06                	je     803c78 <alloc_block_BF+0x341>
  803c72:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803c76:	75 17                	jne    803c8f <alloc_block_BF+0x358>
  803c78:	83 ec 04             	sub    $0x4,%esp
  803c7b:	68 f8 57 80 00       	push   $0x8057f8
  803c80:	68 4f 01 00 00       	push   $0x14f
  803c85:	68 85 57 80 00       	push   $0x805785
  803c8a:	e8 24 d9 ff ff       	call   8015b3 <_panic>
  803c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c92:	8b 10                	mov    (%eax),%edx
  803c94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c97:	89 10                	mov    %edx,(%eax)
  803c99:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803c9c:	8b 00                	mov    (%eax),%eax
  803c9e:	85 c0                	test   %eax,%eax
  803ca0:	74 0b                	je     803cad <alloc_block_BF+0x376>
  803ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ca5:	8b 00                	mov    (%eax),%eax
  803ca7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803caa:	89 50 04             	mov    %edx,0x4(%eax)
  803cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cb0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803cb3:	89 10                	mov    %edx,(%eax)
  803cb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cbb:	89 50 04             	mov    %edx,0x4(%eax)
  803cbe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cc1:	8b 00                	mov    (%eax),%eax
  803cc3:	85 c0                	test   %eax,%eax
  803cc5:	75 08                	jne    803ccf <alloc_block_BF+0x398>
  803cc7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803cca:	a3 30 60 80 00       	mov    %eax,0x806030
  803ccf:	a1 38 60 80 00       	mov    0x806038,%eax
  803cd4:	40                   	inc    %eax
  803cd5:	a3 38 60 80 00       	mov    %eax,0x806038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803cda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803cde:	75 17                	jne    803cf7 <alloc_block_BF+0x3c0>
  803ce0:	83 ec 04             	sub    $0x4,%esp
  803ce3:	68 67 57 80 00       	push   $0x805767
  803ce8:	68 51 01 00 00       	push   $0x151
  803ced:	68 85 57 80 00       	push   $0x805785
  803cf2:	e8 bc d8 ff ff       	call   8015b3 <_panic>
  803cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cfa:	8b 00                	mov    (%eax),%eax
  803cfc:	85 c0                	test   %eax,%eax
  803cfe:	74 10                	je     803d10 <alloc_block_BF+0x3d9>
  803d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d03:	8b 00                	mov    (%eax),%eax
  803d05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d08:	8b 52 04             	mov    0x4(%edx),%edx
  803d0b:	89 50 04             	mov    %edx,0x4(%eax)
  803d0e:	eb 0b                	jmp    803d1b <alloc_block_BF+0x3e4>
  803d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d13:	8b 40 04             	mov    0x4(%eax),%eax
  803d16:	a3 30 60 80 00       	mov    %eax,0x806030
  803d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d1e:	8b 40 04             	mov    0x4(%eax),%eax
  803d21:	85 c0                	test   %eax,%eax
  803d23:	74 0f                	je     803d34 <alloc_block_BF+0x3fd>
  803d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d28:	8b 40 04             	mov    0x4(%eax),%eax
  803d2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d2e:	8b 12                	mov    (%edx),%edx
  803d30:	89 10                	mov    %edx,(%eax)
  803d32:	eb 0a                	jmp    803d3e <alloc_block_BF+0x407>
  803d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d37:	8b 00                	mov    (%eax),%eax
  803d39:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d51:	a1 38 60 80 00       	mov    0x806038,%eax
  803d56:	48                   	dec    %eax
  803d57:	a3 38 60 80 00       	mov    %eax,0x806038
			set_block_data(new_block_va, remaining_size, 0);
  803d5c:	83 ec 04             	sub    $0x4,%esp
  803d5f:	6a 00                	push   $0x0
  803d61:	ff 75 d0             	pushl  -0x30(%ebp)
  803d64:	ff 75 cc             	pushl  -0x34(%ebp)
  803d67:	e8 e0 f6 ff ff       	call   80344c <set_block_data>
  803d6c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  803d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d72:	e9 a3 01 00 00       	jmp    803f1a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  803d77:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  803d7b:	0f 85 9d 00 00 00    	jne    803e1e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  803d81:	83 ec 04             	sub    $0x4,%esp
  803d84:	6a 01                	push   $0x1
  803d86:	ff 75 ec             	pushl  -0x14(%ebp)
  803d89:	ff 75 f0             	pushl  -0x10(%ebp)
  803d8c:	e8 bb f6 ff ff       	call   80344c <set_block_data>
  803d91:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803d94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d98:	75 17                	jne    803db1 <alloc_block_BF+0x47a>
  803d9a:	83 ec 04             	sub    $0x4,%esp
  803d9d:	68 67 57 80 00       	push   $0x805767
  803da2:	68 58 01 00 00       	push   $0x158
  803da7:	68 85 57 80 00       	push   $0x805785
  803dac:	e8 02 d8 ff ff       	call   8015b3 <_panic>
  803db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803db4:	8b 00                	mov    (%eax),%eax
  803db6:	85 c0                	test   %eax,%eax
  803db8:	74 10                	je     803dca <alloc_block_BF+0x493>
  803dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dbd:	8b 00                	mov    (%eax),%eax
  803dbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803dc2:	8b 52 04             	mov    0x4(%edx),%edx
  803dc5:	89 50 04             	mov    %edx,0x4(%eax)
  803dc8:	eb 0b                	jmp    803dd5 <alloc_block_BF+0x49e>
  803dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dcd:	8b 40 04             	mov    0x4(%eax),%eax
  803dd0:	a3 30 60 80 00       	mov    %eax,0x806030
  803dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dd8:	8b 40 04             	mov    0x4(%eax),%eax
  803ddb:	85 c0                	test   %eax,%eax
  803ddd:	74 0f                	je     803dee <alloc_block_BF+0x4b7>
  803ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803de2:	8b 40 04             	mov    0x4(%eax),%eax
  803de5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803de8:	8b 12                	mov    (%edx),%edx
  803dea:	89 10                	mov    %edx,(%eax)
  803dec:	eb 0a                	jmp    803df8 <alloc_block_BF+0x4c1>
  803dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803df1:	8b 00                	mov    (%eax),%eax
  803df3:	a3 2c 60 80 00       	mov    %eax,0x80602c
  803df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803dfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e0b:	a1 38 60 80 00       	mov    0x806038,%eax
  803e10:	48                   	dec    %eax
  803e11:	a3 38 60 80 00       	mov    %eax,0x806038
		return best_va;
  803e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e19:	e9 fc 00 00 00       	jmp    803f1a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  803e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e21:	83 c0 08             	add    $0x8,%eax
  803e24:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803e27:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  803e2e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803e31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e34:	01 d0                	add    %edx,%eax
  803e36:	48                   	dec    %eax
  803e37:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803e3a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e3d:	ba 00 00 00 00       	mov    $0x0,%edx
  803e42:	f7 75 c4             	divl   -0x3c(%ebp)
  803e45:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803e48:	29 d0                	sub    %edx,%eax
  803e4a:	c1 e8 0c             	shr    $0xc,%eax
  803e4d:	83 ec 0c             	sub    $0xc,%esp
  803e50:	50                   	push   %eax
  803e51:	e8 b4 e7 ff ff       	call   80260a <sbrk>
  803e56:	83 c4 10             	add    $0x10,%esp
  803e59:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  803e5c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  803e60:	75 0a                	jne    803e6c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  803e62:	b8 00 00 00 00       	mov    $0x0,%eax
  803e67:	e9 ae 00 00 00       	jmp    803f1a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  803e6c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  803e73:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803e76:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803e79:	01 d0                	add    %edx,%eax
  803e7b:	48                   	dec    %eax
  803e7c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  803e7f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803e82:	ba 00 00 00 00       	mov    $0x0,%edx
  803e87:	f7 75 b8             	divl   -0x48(%ebp)
  803e8a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  803e8d:	29 d0                	sub    %edx,%eax
  803e8f:	8d 50 fc             	lea    -0x4(%eax),%edx
  803e92:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803e95:	01 d0                	add    %edx,%eax
  803e97:	a3 40 60 80 00       	mov    %eax,0x806040
				end_block->info = 1;
  803e9c:	a1 40 60 80 00       	mov    0x806040,%eax
  803ea1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803ea7:	83 ec 0c             	sub    $0xc,%esp
  803eaa:	68 2c 58 80 00       	push   $0x80582c
  803eaf:	e8 bc d9 ff ff       	call   801870 <cprintf>
  803eb4:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803eb7:	83 ec 08             	sub    $0x8,%esp
  803eba:	ff 75 bc             	pushl  -0x44(%ebp)
  803ebd:	68 31 58 80 00       	push   $0x805831
  803ec2:	e8 a9 d9 ff ff       	call   801870 <cprintf>
  803ec7:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803eca:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803ed1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803ed4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803ed7:	01 d0                	add    %edx,%eax
  803ed9:	48                   	dec    %eax
  803eda:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803edd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803ee0:	ba 00 00 00 00       	mov    $0x0,%edx
  803ee5:	f7 75 b0             	divl   -0x50(%ebp)
  803ee8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803eeb:	29 d0                	sub    %edx,%eax
  803eed:	83 ec 04             	sub    $0x4,%esp
  803ef0:	6a 01                	push   $0x1
  803ef2:	50                   	push   %eax
  803ef3:	ff 75 bc             	pushl  -0x44(%ebp)
  803ef6:	e8 51 f5 ff ff       	call   80344c <set_block_data>
  803efb:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  803efe:	83 ec 0c             	sub    $0xc,%esp
  803f01:	ff 75 bc             	pushl  -0x44(%ebp)
  803f04:	e8 36 04 00 00       	call   80433f <free_block>
  803f09:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803f0c:	83 ec 0c             	sub    $0xc,%esp
  803f0f:	ff 75 08             	pushl  0x8(%ebp)
  803f12:	e8 20 fa ff ff       	call   803937 <alloc_block_BF>
  803f17:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803f1a:	c9                   	leave  
  803f1b:	c3                   	ret    

00803f1c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803f1c:	55                   	push   %ebp
  803f1d:	89 e5                	mov    %esp,%ebp
  803f1f:	53                   	push   %ebx
  803f20:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803f23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803f2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803f31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f35:	74 1e                	je     803f55 <merging+0x39>
  803f37:	ff 75 08             	pushl  0x8(%ebp)
  803f3a:	e8 bc f1 ff ff       	call   8030fb <get_block_size>
  803f3f:	83 c4 04             	add    $0x4,%esp
  803f42:	89 c2                	mov    %eax,%edx
  803f44:	8b 45 08             	mov    0x8(%ebp),%eax
  803f47:	01 d0                	add    %edx,%eax
  803f49:	3b 45 10             	cmp    0x10(%ebp),%eax
  803f4c:	75 07                	jne    803f55 <merging+0x39>
		prev_is_free = 1;
  803f4e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  803f55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803f59:	74 1e                	je     803f79 <merging+0x5d>
  803f5b:	ff 75 10             	pushl  0x10(%ebp)
  803f5e:	e8 98 f1 ff ff       	call   8030fb <get_block_size>
  803f63:	83 c4 04             	add    $0x4,%esp
  803f66:	89 c2                	mov    %eax,%edx
  803f68:	8b 45 10             	mov    0x10(%ebp),%eax
  803f6b:	01 d0                	add    %edx,%eax
  803f6d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803f70:	75 07                	jne    803f79 <merging+0x5d>
		next_is_free = 1;
  803f72:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  803f79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f7d:	0f 84 cc 00 00 00    	je     80404f <merging+0x133>
  803f83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803f87:	0f 84 c2 00 00 00    	je     80404f <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  803f8d:	ff 75 08             	pushl  0x8(%ebp)
  803f90:	e8 66 f1 ff ff       	call   8030fb <get_block_size>
  803f95:	83 c4 04             	add    $0x4,%esp
  803f98:	89 c3                	mov    %eax,%ebx
  803f9a:	ff 75 10             	pushl  0x10(%ebp)
  803f9d:	e8 59 f1 ff ff       	call   8030fb <get_block_size>
  803fa2:	83 c4 04             	add    $0x4,%esp
  803fa5:	01 c3                	add    %eax,%ebx
  803fa7:	ff 75 0c             	pushl  0xc(%ebp)
  803faa:	e8 4c f1 ff ff       	call   8030fb <get_block_size>
  803faf:	83 c4 04             	add    $0x4,%esp
  803fb2:	01 d8                	add    %ebx,%eax
  803fb4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803fb7:	6a 00                	push   $0x0
  803fb9:	ff 75 ec             	pushl  -0x14(%ebp)
  803fbc:	ff 75 08             	pushl  0x8(%ebp)
  803fbf:	e8 88 f4 ff ff       	call   80344c <set_block_data>
  803fc4:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803fc7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803fcb:	75 17                	jne    803fe4 <merging+0xc8>
  803fcd:	83 ec 04             	sub    $0x4,%esp
  803fd0:	68 67 57 80 00       	push   $0x805767
  803fd5:	68 7d 01 00 00       	push   $0x17d
  803fda:	68 85 57 80 00       	push   $0x805785
  803fdf:	e8 cf d5 ff ff       	call   8015b3 <_panic>
  803fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fe7:	8b 00                	mov    (%eax),%eax
  803fe9:	85 c0                	test   %eax,%eax
  803feb:	74 10                	je     803ffd <merging+0xe1>
  803fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ff0:	8b 00                	mov    (%eax),%eax
  803ff2:	8b 55 0c             	mov    0xc(%ebp),%edx
  803ff5:	8b 52 04             	mov    0x4(%edx),%edx
  803ff8:	89 50 04             	mov    %edx,0x4(%eax)
  803ffb:	eb 0b                	jmp    804008 <merging+0xec>
  803ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  804000:	8b 40 04             	mov    0x4(%eax),%eax
  804003:	a3 30 60 80 00       	mov    %eax,0x806030
  804008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80400b:	8b 40 04             	mov    0x4(%eax),%eax
  80400e:	85 c0                	test   %eax,%eax
  804010:	74 0f                	je     804021 <merging+0x105>
  804012:	8b 45 0c             	mov    0xc(%ebp),%eax
  804015:	8b 40 04             	mov    0x4(%eax),%eax
  804018:	8b 55 0c             	mov    0xc(%ebp),%edx
  80401b:	8b 12                	mov    (%edx),%edx
  80401d:	89 10                	mov    %edx,(%eax)
  80401f:	eb 0a                	jmp    80402b <merging+0x10f>
  804021:	8b 45 0c             	mov    0xc(%ebp),%eax
  804024:	8b 00                	mov    (%eax),%eax
  804026:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80402b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80402e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804034:	8b 45 0c             	mov    0xc(%ebp),%eax
  804037:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80403e:	a1 38 60 80 00       	mov    0x806038,%eax
  804043:	48                   	dec    %eax
  804044:	a3 38 60 80 00       	mov    %eax,0x806038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  804049:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80404a:	e9 ea 02 00 00       	jmp    804339 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80404f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804053:	74 3b                	je     804090 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  804055:	83 ec 0c             	sub    $0xc,%esp
  804058:	ff 75 08             	pushl  0x8(%ebp)
  80405b:	e8 9b f0 ff ff       	call   8030fb <get_block_size>
  804060:	83 c4 10             	add    $0x10,%esp
  804063:	89 c3                	mov    %eax,%ebx
  804065:	83 ec 0c             	sub    $0xc,%esp
  804068:	ff 75 10             	pushl  0x10(%ebp)
  80406b:	e8 8b f0 ff ff       	call   8030fb <get_block_size>
  804070:	83 c4 10             	add    $0x10,%esp
  804073:	01 d8                	add    %ebx,%eax
  804075:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  804078:	83 ec 04             	sub    $0x4,%esp
  80407b:	6a 00                	push   $0x0
  80407d:	ff 75 e8             	pushl  -0x18(%ebp)
  804080:	ff 75 08             	pushl  0x8(%ebp)
  804083:	e8 c4 f3 ff ff       	call   80344c <set_block_data>
  804088:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80408b:	e9 a9 02 00 00       	jmp    804339 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  804090:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804094:	0f 84 2d 01 00 00    	je     8041c7 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  80409a:	83 ec 0c             	sub    $0xc,%esp
  80409d:	ff 75 10             	pushl  0x10(%ebp)
  8040a0:	e8 56 f0 ff ff       	call   8030fb <get_block_size>
  8040a5:	83 c4 10             	add    $0x10,%esp
  8040a8:	89 c3                	mov    %eax,%ebx
  8040aa:	83 ec 0c             	sub    $0xc,%esp
  8040ad:	ff 75 0c             	pushl  0xc(%ebp)
  8040b0:	e8 46 f0 ff ff       	call   8030fb <get_block_size>
  8040b5:	83 c4 10             	add    $0x10,%esp
  8040b8:	01 d8                	add    %ebx,%eax
  8040ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  8040bd:	83 ec 04             	sub    $0x4,%esp
  8040c0:	6a 00                	push   $0x0
  8040c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8040c5:	ff 75 10             	pushl  0x10(%ebp)
  8040c8:	e8 7f f3 ff ff       	call   80344c <set_block_data>
  8040cd:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  8040d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8040d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  8040d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8040da:	74 06                	je     8040e2 <merging+0x1c6>
  8040dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8040e0:	75 17                	jne    8040f9 <merging+0x1dd>
  8040e2:	83 ec 04             	sub    $0x4,%esp
  8040e5:	68 40 58 80 00       	push   $0x805840
  8040ea:	68 8d 01 00 00       	push   $0x18d
  8040ef:	68 85 57 80 00       	push   $0x805785
  8040f4:	e8 ba d4 ff ff       	call   8015b3 <_panic>
  8040f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040fc:	8b 50 04             	mov    0x4(%eax),%edx
  8040ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804102:	89 50 04             	mov    %edx,0x4(%eax)
  804105:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804108:	8b 55 0c             	mov    0xc(%ebp),%edx
  80410b:	89 10                	mov    %edx,(%eax)
  80410d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804110:	8b 40 04             	mov    0x4(%eax),%eax
  804113:	85 c0                	test   %eax,%eax
  804115:	74 0d                	je     804124 <merging+0x208>
  804117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80411a:	8b 40 04             	mov    0x4(%eax),%eax
  80411d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804120:	89 10                	mov    %edx,(%eax)
  804122:	eb 08                	jmp    80412c <merging+0x210>
  804124:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804127:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80412c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80412f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804132:	89 50 04             	mov    %edx,0x4(%eax)
  804135:	a1 38 60 80 00       	mov    0x806038,%eax
  80413a:	40                   	inc    %eax
  80413b:	a3 38 60 80 00       	mov    %eax,0x806038
		LIST_REMOVE(&freeBlocksList, next_block);
  804140:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804144:	75 17                	jne    80415d <merging+0x241>
  804146:	83 ec 04             	sub    $0x4,%esp
  804149:	68 67 57 80 00       	push   $0x805767
  80414e:	68 8e 01 00 00       	push   $0x18e
  804153:	68 85 57 80 00       	push   $0x805785
  804158:	e8 56 d4 ff ff       	call   8015b3 <_panic>
  80415d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804160:	8b 00                	mov    (%eax),%eax
  804162:	85 c0                	test   %eax,%eax
  804164:	74 10                	je     804176 <merging+0x25a>
  804166:	8b 45 0c             	mov    0xc(%ebp),%eax
  804169:	8b 00                	mov    (%eax),%eax
  80416b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80416e:	8b 52 04             	mov    0x4(%edx),%edx
  804171:	89 50 04             	mov    %edx,0x4(%eax)
  804174:	eb 0b                	jmp    804181 <merging+0x265>
  804176:	8b 45 0c             	mov    0xc(%ebp),%eax
  804179:	8b 40 04             	mov    0x4(%eax),%eax
  80417c:	a3 30 60 80 00       	mov    %eax,0x806030
  804181:	8b 45 0c             	mov    0xc(%ebp),%eax
  804184:	8b 40 04             	mov    0x4(%eax),%eax
  804187:	85 c0                	test   %eax,%eax
  804189:	74 0f                	je     80419a <merging+0x27e>
  80418b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80418e:	8b 40 04             	mov    0x4(%eax),%eax
  804191:	8b 55 0c             	mov    0xc(%ebp),%edx
  804194:	8b 12                	mov    (%edx),%edx
  804196:	89 10                	mov    %edx,(%eax)
  804198:	eb 0a                	jmp    8041a4 <merging+0x288>
  80419a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80419d:	8b 00                	mov    (%eax),%eax
  80419f:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8041a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8041ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8041b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041b7:	a1 38 60 80 00       	mov    0x806038,%eax
  8041bc:	48                   	dec    %eax
  8041bd:	a3 38 60 80 00       	mov    %eax,0x806038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8041c2:	e9 72 01 00 00       	jmp    804339 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  8041c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8041ca:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  8041cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041d1:	74 79                	je     80424c <merging+0x330>
  8041d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8041d7:	74 73                	je     80424c <merging+0x330>
  8041d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041dd:	74 06                	je     8041e5 <merging+0x2c9>
  8041df:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8041e3:	75 17                	jne    8041fc <merging+0x2e0>
  8041e5:	83 ec 04             	sub    $0x4,%esp
  8041e8:	68 f8 57 80 00       	push   $0x8057f8
  8041ed:	68 94 01 00 00       	push   $0x194
  8041f2:	68 85 57 80 00       	push   $0x805785
  8041f7:	e8 b7 d3 ff ff       	call   8015b3 <_panic>
  8041fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ff:	8b 10                	mov    (%eax),%edx
  804201:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804204:	89 10                	mov    %edx,(%eax)
  804206:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804209:	8b 00                	mov    (%eax),%eax
  80420b:	85 c0                	test   %eax,%eax
  80420d:	74 0b                	je     80421a <merging+0x2fe>
  80420f:	8b 45 08             	mov    0x8(%ebp),%eax
  804212:	8b 00                	mov    (%eax),%eax
  804214:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804217:	89 50 04             	mov    %edx,0x4(%eax)
  80421a:	8b 45 08             	mov    0x8(%ebp),%eax
  80421d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804220:	89 10                	mov    %edx,(%eax)
  804222:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804225:	8b 55 08             	mov    0x8(%ebp),%edx
  804228:	89 50 04             	mov    %edx,0x4(%eax)
  80422b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80422e:	8b 00                	mov    (%eax),%eax
  804230:	85 c0                	test   %eax,%eax
  804232:	75 08                	jne    80423c <merging+0x320>
  804234:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804237:	a3 30 60 80 00       	mov    %eax,0x806030
  80423c:	a1 38 60 80 00       	mov    0x806038,%eax
  804241:	40                   	inc    %eax
  804242:	a3 38 60 80 00       	mov    %eax,0x806038
  804247:	e9 ce 00 00 00       	jmp    80431a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  80424c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804250:	74 65                	je     8042b7 <merging+0x39b>
  804252:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804256:	75 17                	jne    80426f <merging+0x353>
  804258:	83 ec 04             	sub    $0x4,%esp
  80425b:	68 d4 57 80 00       	push   $0x8057d4
  804260:	68 95 01 00 00       	push   $0x195
  804265:	68 85 57 80 00       	push   $0x805785
  80426a:	e8 44 d3 ff ff       	call   8015b3 <_panic>
  80426f:	8b 15 30 60 80 00    	mov    0x806030,%edx
  804275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804278:	89 50 04             	mov    %edx,0x4(%eax)
  80427b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80427e:	8b 40 04             	mov    0x4(%eax),%eax
  804281:	85 c0                	test   %eax,%eax
  804283:	74 0c                	je     804291 <merging+0x375>
  804285:	a1 30 60 80 00       	mov    0x806030,%eax
  80428a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80428d:	89 10                	mov    %edx,(%eax)
  80428f:	eb 08                	jmp    804299 <merging+0x37d>
  804291:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804294:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804299:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80429c:	a3 30 60 80 00       	mov    %eax,0x806030
  8042a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8042aa:	a1 38 60 80 00       	mov    0x806038,%eax
  8042af:	40                   	inc    %eax
  8042b0:	a3 38 60 80 00       	mov    %eax,0x806038
  8042b5:	eb 63                	jmp    80431a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8042b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8042bb:	75 17                	jne    8042d4 <merging+0x3b8>
  8042bd:	83 ec 04             	sub    $0x4,%esp
  8042c0:	68 a0 57 80 00       	push   $0x8057a0
  8042c5:	68 98 01 00 00       	push   $0x198
  8042ca:	68 85 57 80 00       	push   $0x805785
  8042cf:	e8 df d2 ff ff       	call   8015b3 <_panic>
  8042d4:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8042da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042dd:	89 10                	mov    %edx,(%eax)
  8042df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042e2:	8b 00                	mov    (%eax),%eax
  8042e4:	85 c0                	test   %eax,%eax
  8042e6:	74 0d                	je     8042f5 <merging+0x3d9>
  8042e8:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8042ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8042f0:	89 50 04             	mov    %edx,0x4(%eax)
  8042f3:	eb 08                	jmp    8042fd <merging+0x3e1>
  8042f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8042f8:	a3 30 60 80 00       	mov    %eax,0x806030
  8042fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804300:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804305:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80430f:	a1 38 60 80 00       	mov    0x806038,%eax
  804314:	40                   	inc    %eax
  804315:	a3 38 60 80 00       	mov    %eax,0x806038
		}
		set_block_data(va, get_block_size(va), 0);
  80431a:	83 ec 0c             	sub    $0xc,%esp
  80431d:	ff 75 10             	pushl  0x10(%ebp)
  804320:	e8 d6 ed ff ff       	call   8030fb <get_block_size>
  804325:	83 c4 10             	add    $0x10,%esp
  804328:	83 ec 04             	sub    $0x4,%esp
  80432b:	6a 00                	push   $0x0
  80432d:	50                   	push   %eax
  80432e:	ff 75 10             	pushl  0x10(%ebp)
  804331:	e8 16 f1 ff ff       	call   80344c <set_block_data>
  804336:	83 c4 10             	add    $0x10,%esp
	}
}
  804339:	90                   	nop
  80433a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80433d:	c9                   	leave  
  80433e:	c3                   	ret    

0080433f <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80433f:	55                   	push   %ebp
  804340:	89 e5                	mov    %esp,%ebp
  804342:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  804345:	a1 2c 60 80 00       	mov    0x80602c,%eax
  80434a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80434d:	a1 30 60 80 00       	mov    0x806030,%eax
  804352:	3b 45 08             	cmp    0x8(%ebp),%eax
  804355:	73 1b                	jae    804372 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  804357:	a1 30 60 80 00       	mov    0x806030,%eax
  80435c:	83 ec 04             	sub    $0x4,%esp
  80435f:	ff 75 08             	pushl  0x8(%ebp)
  804362:	6a 00                	push   $0x0
  804364:	50                   	push   %eax
  804365:	e8 b2 fb ff ff       	call   803f1c <merging>
  80436a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80436d:	e9 8b 00 00 00       	jmp    8043fd <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  804372:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804377:	3b 45 08             	cmp    0x8(%ebp),%eax
  80437a:	76 18                	jbe    804394 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80437c:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804381:	83 ec 04             	sub    $0x4,%esp
  804384:	ff 75 08             	pushl  0x8(%ebp)
  804387:	50                   	push   %eax
  804388:	6a 00                	push   $0x0
  80438a:	e8 8d fb ff ff       	call   803f1c <merging>
  80438f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  804392:	eb 69                	jmp    8043fd <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  804394:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804399:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80439c:	eb 39                	jmp    8043d7 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80439e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8043a4:	73 29                	jae    8043cf <free_block+0x90>
  8043a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043a9:	8b 00                	mov    (%eax),%eax
  8043ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8043ae:	76 1f                	jbe    8043cf <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8043b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043b3:	8b 00                	mov    (%eax),%eax
  8043b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8043b8:	83 ec 04             	sub    $0x4,%esp
  8043bb:	ff 75 08             	pushl  0x8(%ebp)
  8043be:	ff 75 f0             	pushl  -0x10(%ebp)
  8043c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8043c4:	e8 53 fb ff ff       	call   803f1c <merging>
  8043c9:	83 c4 10             	add    $0x10,%esp
			break;
  8043cc:	90                   	nop
		}
	}
}
  8043cd:	eb 2e                	jmp    8043fd <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8043cf:	a1 34 60 80 00       	mov    0x806034,%eax
  8043d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043db:	74 07                	je     8043e4 <free_block+0xa5>
  8043dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043e0:	8b 00                	mov    (%eax),%eax
  8043e2:	eb 05                	jmp    8043e9 <free_block+0xaa>
  8043e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8043e9:	a3 34 60 80 00       	mov    %eax,0x806034
  8043ee:	a1 34 60 80 00       	mov    0x806034,%eax
  8043f3:	85 c0                	test   %eax,%eax
  8043f5:	75 a7                	jne    80439e <free_block+0x5f>
  8043f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8043fb:	75 a1                	jne    80439e <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8043fd:	90                   	nop
  8043fe:	c9                   	leave  
  8043ff:	c3                   	ret    

00804400 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  804400:	55                   	push   %ebp
  804401:	89 e5                	mov    %esp,%ebp
  804403:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  804406:	ff 75 08             	pushl  0x8(%ebp)
  804409:	e8 ed ec ff ff       	call   8030fb <get_block_size>
  80440e:	83 c4 04             	add    $0x4,%esp
  804411:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  804414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80441b:	eb 17                	jmp    804434 <copy_data+0x34>
  80441d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804420:	8b 45 0c             	mov    0xc(%ebp),%eax
  804423:	01 c2                	add    %eax,%edx
  804425:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  804428:	8b 45 08             	mov    0x8(%ebp),%eax
  80442b:	01 c8                	add    %ecx,%eax
  80442d:	8a 00                	mov    (%eax),%al
  80442f:	88 02                	mov    %al,(%edx)
  804431:	ff 45 fc             	incl   -0x4(%ebp)
  804434:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804437:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80443a:	72 e1                	jb     80441d <copy_data+0x1d>
}
  80443c:	90                   	nop
  80443d:	c9                   	leave  
  80443e:	c3                   	ret    

0080443f <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80443f:	55                   	push   %ebp
  804440:	89 e5                	mov    %esp,%ebp
  804442:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  804445:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804449:	75 23                	jne    80446e <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80444b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80444f:	74 13                	je     804464 <realloc_block_FF+0x25>
  804451:	83 ec 0c             	sub    $0xc,%esp
  804454:	ff 75 0c             	pushl  0xc(%ebp)
  804457:	e8 1f f0 ff ff       	call   80347b <alloc_block_FF>
  80445c:	83 c4 10             	add    $0x10,%esp
  80445f:	e9 f4 06 00 00       	jmp    804b58 <realloc_block_FF+0x719>
		return NULL;
  804464:	b8 00 00 00 00       	mov    $0x0,%eax
  804469:	e9 ea 06 00 00       	jmp    804b58 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80446e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804472:	75 18                	jne    80448c <realloc_block_FF+0x4d>
	{
		free_block(va);
  804474:	83 ec 0c             	sub    $0xc,%esp
  804477:	ff 75 08             	pushl  0x8(%ebp)
  80447a:	e8 c0 fe ff ff       	call   80433f <free_block>
  80447f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  804482:	b8 00 00 00 00       	mov    $0x0,%eax
  804487:	e9 cc 06 00 00       	jmp    804b58 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80448c:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  804490:	77 07                	ja     804499 <realloc_block_FF+0x5a>
  804492:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  804499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80449c:	83 e0 01             	and    $0x1,%eax
  80449f:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8044a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044a5:	83 c0 08             	add    $0x8,%eax
  8044a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8044ab:	83 ec 0c             	sub    $0xc,%esp
  8044ae:	ff 75 08             	pushl  0x8(%ebp)
  8044b1:	e8 45 ec ff ff       	call   8030fb <get_block_size>
  8044b6:	83 c4 10             	add    $0x10,%esp
  8044b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8044bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8044bf:	83 e8 08             	sub    $0x8,%eax
  8044c2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8044c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8044c8:	83 e8 04             	sub    $0x4,%eax
  8044cb:	8b 00                	mov    (%eax),%eax
  8044cd:	83 e0 fe             	and    $0xfffffffe,%eax
  8044d0:	89 c2                	mov    %eax,%edx
  8044d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8044d5:	01 d0                	add    %edx,%eax
  8044d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8044da:	83 ec 0c             	sub    $0xc,%esp
  8044dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8044e0:	e8 16 ec ff ff       	call   8030fb <get_block_size>
  8044e5:	83 c4 10             	add    $0x10,%esp
  8044e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8044eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8044ee:	83 e8 08             	sub    $0x8,%eax
  8044f1:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8044f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044f7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8044fa:	75 08                	jne    804504 <realloc_block_FF+0xc5>
	{
		 return va;
  8044fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ff:	e9 54 06 00 00       	jmp    804b58 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  804504:	8b 45 0c             	mov    0xc(%ebp),%eax
  804507:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80450a:	0f 83 e5 03 00 00    	jae    8048f5 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  804510:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804513:	2b 45 0c             	sub    0xc(%ebp),%eax
  804516:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  804519:	83 ec 0c             	sub    $0xc,%esp
  80451c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80451f:	e8 f0 eb ff ff       	call   803114 <is_free_block>
  804524:	83 c4 10             	add    $0x10,%esp
  804527:	84 c0                	test   %al,%al
  804529:	0f 84 3b 01 00 00    	je     80466a <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80452f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804532:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804535:	01 d0                	add    %edx,%eax
  804537:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80453a:	83 ec 04             	sub    $0x4,%esp
  80453d:	6a 01                	push   $0x1
  80453f:	ff 75 f0             	pushl  -0x10(%ebp)
  804542:	ff 75 08             	pushl  0x8(%ebp)
  804545:	e8 02 ef ff ff       	call   80344c <set_block_data>
  80454a:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80454d:	8b 45 08             	mov    0x8(%ebp),%eax
  804550:	83 e8 04             	sub    $0x4,%eax
  804553:	8b 00                	mov    (%eax),%eax
  804555:	83 e0 fe             	and    $0xfffffffe,%eax
  804558:	89 c2                	mov    %eax,%edx
  80455a:	8b 45 08             	mov    0x8(%ebp),%eax
  80455d:	01 d0                	add    %edx,%eax
  80455f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  804562:	83 ec 04             	sub    $0x4,%esp
  804565:	6a 00                	push   $0x0
  804567:	ff 75 cc             	pushl  -0x34(%ebp)
  80456a:	ff 75 c8             	pushl  -0x38(%ebp)
  80456d:	e8 da ee ff ff       	call   80344c <set_block_data>
  804572:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804575:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804579:	74 06                	je     804581 <realloc_block_FF+0x142>
  80457b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80457f:	75 17                	jne    804598 <realloc_block_FF+0x159>
  804581:	83 ec 04             	sub    $0x4,%esp
  804584:	68 f8 57 80 00       	push   $0x8057f8
  804589:	68 f6 01 00 00       	push   $0x1f6
  80458e:	68 85 57 80 00       	push   $0x805785
  804593:	e8 1b d0 ff ff       	call   8015b3 <_panic>
  804598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80459b:	8b 10                	mov    (%eax),%edx
  80459d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8045a0:	89 10                	mov    %edx,(%eax)
  8045a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8045a5:	8b 00                	mov    (%eax),%eax
  8045a7:	85 c0                	test   %eax,%eax
  8045a9:	74 0b                	je     8045b6 <realloc_block_FF+0x177>
  8045ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045ae:	8b 00                	mov    (%eax),%eax
  8045b0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8045b3:	89 50 04             	mov    %edx,0x4(%eax)
  8045b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8045b9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8045bc:	89 10                	mov    %edx,(%eax)
  8045be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8045c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8045c4:	89 50 04             	mov    %edx,0x4(%eax)
  8045c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8045ca:	8b 00                	mov    (%eax),%eax
  8045cc:	85 c0                	test   %eax,%eax
  8045ce:	75 08                	jne    8045d8 <realloc_block_FF+0x199>
  8045d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8045d3:	a3 30 60 80 00       	mov    %eax,0x806030
  8045d8:	a1 38 60 80 00       	mov    0x806038,%eax
  8045dd:	40                   	inc    %eax
  8045de:	a3 38 60 80 00       	mov    %eax,0x806038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8045e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8045e7:	75 17                	jne    804600 <realloc_block_FF+0x1c1>
  8045e9:	83 ec 04             	sub    $0x4,%esp
  8045ec:	68 67 57 80 00       	push   $0x805767
  8045f1:	68 f7 01 00 00       	push   $0x1f7
  8045f6:	68 85 57 80 00       	push   $0x805785
  8045fb:	e8 b3 cf ff ff       	call   8015b3 <_panic>
  804600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804603:	8b 00                	mov    (%eax),%eax
  804605:	85 c0                	test   %eax,%eax
  804607:	74 10                	je     804619 <realloc_block_FF+0x1da>
  804609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80460c:	8b 00                	mov    (%eax),%eax
  80460e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804611:	8b 52 04             	mov    0x4(%edx),%edx
  804614:	89 50 04             	mov    %edx,0x4(%eax)
  804617:	eb 0b                	jmp    804624 <realloc_block_FF+0x1e5>
  804619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80461c:	8b 40 04             	mov    0x4(%eax),%eax
  80461f:	a3 30 60 80 00       	mov    %eax,0x806030
  804624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804627:	8b 40 04             	mov    0x4(%eax),%eax
  80462a:	85 c0                	test   %eax,%eax
  80462c:	74 0f                	je     80463d <realloc_block_FF+0x1fe>
  80462e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804631:	8b 40 04             	mov    0x4(%eax),%eax
  804634:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804637:	8b 12                	mov    (%edx),%edx
  804639:	89 10                	mov    %edx,(%eax)
  80463b:	eb 0a                	jmp    804647 <realloc_block_FF+0x208>
  80463d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804640:	8b 00                	mov    (%eax),%eax
  804642:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80464a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804653:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80465a:	a1 38 60 80 00       	mov    0x806038,%eax
  80465f:	48                   	dec    %eax
  804660:	a3 38 60 80 00       	mov    %eax,0x806038
  804665:	e9 83 02 00 00       	jmp    8048ed <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80466a:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80466e:	0f 86 69 02 00 00    	jbe    8048dd <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  804674:	83 ec 04             	sub    $0x4,%esp
  804677:	6a 01                	push   $0x1
  804679:	ff 75 f0             	pushl  -0x10(%ebp)
  80467c:	ff 75 08             	pushl  0x8(%ebp)
  80467f:	e8 c8 ed ff ff       	call   80344c <set_block_data>
  804684:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804687:	8b 45 08             	mov    0x8(%ebp),%eax
  80468a:	83 e8 04             	sub    $0x4,%eax
  80468d:	8b 00                	mov    (%eax),%eax
  80468f:	83 e0 fe             	and    $0xfffffffe,%eax
  804692:	89 c2                	mov    %eax,%edx
  804694:	8b 45 08             	mov    0x8(%ebp),%eax
  804697:	01 d0                	add    %edx,%eax
  804699:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80469c:	a1 38 60 80 00       	mov    0x806038,%eax
  8046a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8046a4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8046a8:	75 68                	jne    804712 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8046aa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8046ae:	75 17                	jne    8046c7 <realloc_block_FF+0x288>
  8046b0:	83 ec 04             	sub    $0x4,%esp
  8046b3:	68 a0 57 80 00       	push   $0x8057a0
  8046b8:	68 06 02 00 00       	push   $0x206
  8046bd:	68 85 57 80 00       	push   $0x805785
  8046c2:	e8 ec ce ff ff       	call   8015b3 <_panic>
  8046c7:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  8046cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8046d0:	89 10                	mov    %edx,(%eax)
  8046d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8046d5:	8b 00                	mov    (%eax),%eax
  8046d7:	85 c0                	test   %eax,%eax
  8046d9:	74 0d                	je     8046e8 <realloc_block_FF+0x2a9>
  8046db:	a1 2c 60 80 00       	mov    0x80602c,%eax
  8046e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8046e3:	89 50 04             	mov    %edx,0x4(%eax)
  8046e6:	eb 08                	jmp    8046f0 <realloc_block_FF+0x2b1>
  8046e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8046eb:	a3 30 60 80 00       	mov    %eax,0x806030
  8046f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8046f3:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8046f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8046fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804702:	a1 38 60 80 00       	mov    0x806038,%eax
  804707:	40                   	inc    %eax
  804708:	a3 38 60 80 00       	mov    %eax,0x806038
  80470d:	e9 b0 01 00 00       	jmp    8048c2 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  804712:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804717:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80471a:	76 68                	jbe    804784 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80471c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804720:	75 17                	jne    804739 <realloc_block_FF+0x2fa>
  804722:	83 ec 04             	sub    $0x4,%esp
  804725:	68 a0 57 80 00       	push   $0x8057a0
  80472a:	68 0b 02 00 00       	push   $0x20b
  80472f:	68 85 57 80 00       	push   $0x805785
  804734:	e8 7a ce ff ff       	call   8015b3 <_panic>
  804739:	8b 15 2c 60 80 00    	mov    0x80602c,%edx
  80473f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804742:	89 10                	mov    %edx,(%eax)
  804744:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804747:	8b 00                	mov    (%eax),%eax
  804749:	85 c0                	test   %eax,%eax
  80474b:	74 0d                	je     80475a <realloc_block_FF+0x31b>
  80474d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804752:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804755:	89 50 04             	mov    %edx,0x4(%eax)
  804758:	eb 08                	jmp    804762 <realloc_block_FF+0x323>
  80475a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80475d:	a3 30 60 80 00       	mov    %eax,0x806030
  804762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804765:	a3 2c 60 80 00       	mov    %eax,0x80602c
  80476a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80476d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804774:	a1 38 60 80 00       	mov    0x806038,%eax
  804779:	40                   	inc    %eax
  80477a:	a3 38 60 80 00       	mov    %eax,0x806038
  80477f:	e9 3e 01 00 00       	jmp    8048c2 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  804784:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804789:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80478c:	73 68                	jae    8047f6 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80478e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804792:	75 17                	jne    8047ab <realloc_block_FF+0x36c>
  804794:	83 ec 04             	sub    $0x4,%esp
  804797:	68 d4 57 80 00       	push   $0x8057d4
  80479c:	68 10 02 00 00       	push   $0x210
  8047a1:	68 85 57 80 00       	push   $0x805785
  8047a6:	e8 08 ce ff ff       	call   8015b3 <_panic>
  8047ab:	8b 15 30 60 80 00    	mov    0x806030,%edx
  8047b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047b4:	89 50 04             	mov    %edx,0x4(%eax)
  8047b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047ba:	8b 40 04             	mov    0x4(%eax),%eax
  8047bd:	85 c0                	test   %eax,%eax
  8047bf:	74 0c                	je     8047cd <realloc_block_FF+0x38e>
  8047c1:	a1 30 60 80 00       	mov    0x806030,%eax
  8047c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8047c9:	89 10                	mov    %edx,(%eax)
  8047cb:	eb 08                	jmp    8047d5 <realloc_block_FF+0x396>
  8047cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047d0:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8047d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047d8:	a3 30 60 80 00       	mov    %eax,0x806030
  8047dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8047e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047e6:	a1 38 60 80 00       	mov    0x806038,%eax
  8047eb:	40                   	inc    %eax
  8047ec:	a3 38 60 80 00       	mov    %eax,0x806038
  8047f1:	e9 cc 00 00 00       	jmp    8048c2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8047f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8047fd:	a1 2c 60 80 00       	mov    0x80602c,%eax
  804802:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804805:	e9 8a 00 00 00       	jmp    804894 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80480a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80480d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804810:	73 7a                	jae    80488c <realloc_block_FF+0x44d>
  804812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804815:	8b 00                	mov    (%eax),%eax
  804817:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80481a:	73 70                	jae    80488c <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80481c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804820:	74 06                	je     804828 <realloc_block_FF+0x3e9>
  804822:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  804826:	75 17                	jne    80483f <realloc_block_FF+0x400>
  804828:	83 ec 04             	sub    $0x4,%esp
  80482b:	68 f8 57 80 00       	push   $0x8057f8
  804830:	68 1a 02 00 00       	push   $0x21a
  804835:	68 85 57 80 00       	push   $0x805785
  80483a:	e8 74 cd ff ff       	call   8015b3 <_panic>
  80483f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804842:	8b 10                	mov    (%eax),%edx
  804844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804847:	89 10                	mov    %edx,(%eax)
  804849:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80484c:	8b 00                	mov    (%eax),%eax
  80484e:	85 c0                	test   %eax,%eax
  804850:	74 0b                	je     80485d <realloc_block_FF+0x41e>
  804852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804855:	8b 00                	mov    (%eax),%eax
  804857:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80485a:	89 50 04             	mov    %edx,0x4(%eax)
  80485d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804860:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804863:	89 10                	mov    %edx,(%eax)
  804865:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804868:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80486b:	89 50 04             	mov    %edx,0x4(%eax)
  80486e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  804871:	8b 00                	mov    (%eax),%eax
  804873:	85 c0                	test   %eax,%eax
  804875:	75 08                	jne    80487f <realloc_block_FF+0x440>
  804877:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80487a:	a3 30 60 80 00       	mov    %eax,0x806030
  80487f:	a1 38 60 80 00       	mov    0x806038,%eax
  804884:	40                   	inc    %eax
  804885:	a3 38 60 80 00       	mov    %eax,0x806038
							break;
  80488a:	eb 36                	jmp    8048c2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80488c:	a1 34 60 80 00       	mov    0x806034,%eax
  804891:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804894:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804898:	74 07                	je     8048a1 <realloc_block_FF+0x462>
  80489a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80489d:	8b 00                	mov    (%eax),%eax
  80489f:	eb 05                	jmp    8048a6 <realloc_block_FF+0x467>
  8048a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8048a6:	a3 34 60 80 00       	mov    %eax,0x806034
  8048ab:	a1 34 60 80 00       	mov    0x806034,%eax
  8048b0:	85 c0                	test   %eax,%eax
  8048b2:	0f 85 52 ff ff ff    	jne    80480a <realloc_block_FF+0x3cb>
  8048b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8048bc:	0f 85 48 ff ff ff    	jne    80480a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8048c2:	83 ec 04             	sub    $0x4,%esp
  8048c5:	6a 00                	push   $0x0
  8048c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8048ca:	ff 75 d4             	pushl  -0x2c(%ebp)
  8048cd:	e8 7a eb ff ff       	call   80344c <set_block_data>
  8048d2:	83 c4 10             	add    $0x10,%esp
				return va;
  8048d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8048d8:	e9 7b 02 00 00       	jmp    804b58 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8048dd:	83 ec 0c             	sub    $0xc,%esp
  8048e0:	68 75 58 80 00       	push   $0x805875
  8048e5:	e8 86 cf ff ff       	call   801870 <cprintf>
  8048ea:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8048ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8048f0:	e9 63 02 00 00       	jmp    804b58 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8048f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8048f8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8048fb:	0f 86 4d 02 00 00    	jbe    804b4e <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  804901:	83 ec 0c             	sub    $0xc,%esp
  804904:	ff 75 e4             	pushl  -0x1c(%ebp)
  804907:	e8 08 e8 ff ff       	call   803114 <is_free_block>
  80490c:	83 c4 10             	add    $0x10,%esp
  80490f:	84 c0                	test   %al,%al
  804911:	0f 84 37 02 00 00    	je     804b4e <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  804917:	8b 45 0c             	mov    0xc(%ebp),%eax
  80491a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80491d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  804920:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804923:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804926:	76 38                	jbe    804960 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  804928:	83 ec 0c             	sub    $0xc,%esp
  80492b:	ff 75 08             	pushl  0x8(%ebp)
  80492e:	e8 0c fa ff ff       	call   80433f <free_block>
  804933:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  804936:	83 ec 0c             	sub    $0xc,%esp
  804939:	ff 75 0c             	pushl  0xc(%ebp)
  80493c:	e8 3a eb ff ff       	call   80347b <alloc_block_FF>
  804941:	83 c4 10             	add    $0x10,%esp
  804944:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  804947:	83 ec 08             	sub    $0x8,%esp
  80494a:	ff 75 c0             	pushl  -0x40(%ebp)
  80494d:	ff 75 08             	pushl  0x8(%ebp)
  804950:	e8 ab fa ff ff       	call   804400 <copy_data>
  804955:	83 c4 10             	add    $0x10,%esp
				return new_va;
  804958:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80495b:	e9 f8 01 00 00       	jmp    804b58 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  804960:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804963:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  804966:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  804969:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80496d:	0f 87 a0 00 00 00    	ja     804a13 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  804973:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804977:	75 17                	jne    804990 <realloc_block_FF+0x551>
  804979:	83 ec 04             	sub    $0x4,%esp
  80497c:	68 67 57 80 00       	push   $0x805767
  804981:	68 38 02 00 00       	push   $0x238
  804986:	68 85 57 80 00       	push   $0x805785
  80498b:	e8 23 cc ff ff       	call   8015b3 <_panic>
  804990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804993:	8b 00                	mov    (%eax),%eax
  804995:	85 c0                	test   %eax,%eax
  804997:	74 10                	je     8049a9 <realloc_block_FF+0x56a>
  804999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80499c:	8b 00                	mov    (%eax),%eax
  80499e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049a1:	8b 52 04             	mov    0x4(%edx),%edx
  8049a4:	89 50 04             	mov    %edx,0x4(%eax)
  8049a7:	eb 0b                	jmp    8049b4 <realloc_block_FF+0x575>
  8049a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049ac:	8b 40 04             	mov    0x4(%eax),%eax
  8049af:	a3 30 60 80 00       	mov    %eax,0x806030
  8049b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049b7:	8b 40 04             	mov    0x4(%eax),%eax
  8049ba:	85 c0                	test   %eax,%eax
  8049bc:	74 0f                	je     8049cd <realloc_block_FF+0x58e>
  8049be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049c1:	8b 40 04             	mov    0x4(%eax),%eax
  8049c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8049c7:	8b 12                	mov    (%edx),%edx
  8049c9:	89 10                	mov    %edx,(%eax)
  8049cb:	eb 0a                	jmp    8049d7 <realloc_block_FF+0x598>
  8049cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049d0:	8b 00                	mov    (%eax),%eax
  8049d2:	a3 2c 60 80 00       	mov    %eax,0x80602c
  8049d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8049e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8049e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8049ea:	a1 38 60 80 00       	mov    0x806038,%eax
  8049ef:	48                   	dec    %eax
  8049f0:	a3 38 60 80 00       	mov    %eax,0x806038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8049f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8049f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8049fb:	01 d0                	add    %edx,%eax
  8049fd:	83 ec 04             	sub    $0x4,%esp
  804a00:	6a 01                	push   $0x1
  804a02:	50                   	push   %eax
  804a03:	ff 75 08             	pushl  0x8(%ebp)
  804a06:	e8 41 ea ff ff       	call   80344c <set_block_data>
  804a0b:	83 c4 10             	add    $0x10,%esp
  804a0e:	e9 36 01 00 00       	jmp    804b49 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  804a13:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804a16:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  804a19:	01 d0                	add    %edx,%eax
  804a1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  804a1e:	83 ec 04             	sub    $0x4,%esp
  804a21:	6a 01                	push   $0x1
  804a23:	ff 75 f0             	pushl  -0x10(%ebp)
  804a26:	ff 75 08             	pushl  0x8(%ebp)
  804a29:	e8 1e ea ff ff       	call   80344c <set_block_data>
  804a2e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  804a31:	8b 45 08             	mov    0x8(%ebp),%eax
  804a34:	83 e8 04             	sub    $0x4,%eax
  804a37:	8b 00                	mov    (%eax),%eax
  804a39:	83 e0 fe             	and    $0xfffffffe,%eax
  804a3c:	89 c2                	mov    %eax,%edx
  804a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  804a41:	01 d0                	add    %edx,%eax
  804a43:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  804a46:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804a4a:	74 06                	je     804a52 <realloc_block_FF+0x613>
  804a4c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  804a50:	75 17                	jne    804a69 <realloc_block_FF+0x62a>
  804a52:	83 ec 04             	sub    $0x4,%esp
  804a55:	68 f8 57 80 00       	push   $0x8057f8
  804a5a:	68 44 02 00 00       	push   $0x244
  804a5f:	68 85 57 80 00       	push   $0x805785
  804a64:	e8 4a cb ff ff       	call   8015b3 <_panic>
  804a69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a6c:	8b 10                	mov    (%eax),%edx
  804a6e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804a71:	89 10                	mov    %edx,(%eax)
  804a73:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804a76:	8b 00                	mov    (%eax),%eax
  804a78:	85 c0                	test   %eax,%eax
  804a7a:	74 0b                	je     804a87 <realloc_block_FF+0x648>
  804a7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a7f:	8b 00                	mov    (%eax),%eax
  804a81:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804a84:	89 50 04             	mov    %edx,0x4(%eax)
  804a87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804a8a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  804a8d:	89 10                	mov    %edx,(%eax)
  804a8f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804a92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804a95:	89 50 04             	mov    %edx,0x4(%eax)
  804a98:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804a9b:	8b 00                	mov    (%eax),%eax
  804a9d:	85 c0                	test   %eax,%eax
  804a9f:	75 08                	jne    804aa9 <realloc_block_FF+0x66a>
  804aa1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  804aa4:	a3 30 60 80 00       	mov    %eax,0x806030
  804aa9:	a1 38 60 80 00       	mov    0x806038,%eax
  804aae:	40                   	inc    %eax
  804aaf:	a3 38 60 80 00       	mov    %eax,0x806038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  804ab4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804ab8:	75 17                	jne    804ad1 <realloc_block_FF+0x692>
  804aba:	83 ec 04             	sub    $0x4,%esp
  804abd:	68 67 57 80 00       	push   $0x805767
  804ac2:	68 45 02 00 00       	push   $0x245
  804ac7:	68 85 57 80 00       	push   $0x805785
  804acc:	e8 e2 ca ff ff       	call   8015b3 <_panic>
  804ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804ad4:	8b 00                	mov    (%eax),%eax
  804ad6:	85 c0                	test   %eax,%eax
  804ad8:	74 10                	je     804aea <realloc_block_FF+0x6ab>
  804ada:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804add:	8b 00                	mov    (%eax),%eax
  804adf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804ae2:	8b 52 04             	mov    0x4(%edx),%edx
  804ae5:	89 50 04             	mov    %edx,0x4(%eax)
  804ae8:	eb 0b                	jmp    804af5 <realloc_block_FF+0x6b6>
  804aea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804aed:	8b 40 04             	mov    0x4(%eax),%eax
  804af0:	a3 30 60 80 00       	mov    %eax,0x806030
  804af5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804af8:	8b 40 04             	mov    0x4(%eax),%eax
  804afb:	85 c0                	test   %eax,%eax
  804afd:	74 0f                	je     804b0e <realloc_block_FF+0x6cf>
  804aff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b02:	8b 40 04             	mov    0x4(%eax),%eax
  804b05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b08:	8b 12                	mov    (%edx),%edx
  804b0a:	89 10                	mov    %edx,(%eax)
  804b0c:	eb 0a                	jmp    804b18 <realloc_block_FF+0x6d9>
  804b0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b11:	8b 00                	mov    (%eax),%eax
  804b13:	a3 2c 60 80 00       	mov    %eax,0x80602c
  804b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804b2b:	a1 38 60 80 00       	mov    0x806038,%eax
  804b30:	48                   	dec    %eax
  804b31:	a3 38 60 80 00       	mov    %eax,0x806038
				set_block_data(next_new_va, remaining_size, 0);
  804b36:	83 ec 04             	sub    $0x4,%esp
  804b39:	6a 00                	push   $0x0
  804b3b:	ff 75 bc             	pushl  -0x44(%ebp)
  804b3e:	ff 75 b8             	pushl  -0x48(%ebp)
  804b41:	e8 06 e9 ff ff       	call   80344c <set_block_data>
  804b46:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  804b49:	8b 45 08             	mov    0x8(%ebp),%eax
  804b4c:	eb 0a                	jmp    804b58 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  804b4e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  804b55:	8b 45 08             	mov    0x8(%ebp),%eax
}
  804b58:	c9                   	leave  
  804b59:	c3                   	ret    

00804b5a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804b5a:	55                   	push   %ebp
  804b5b:	89 e5                	mov    %esp,%ebp
  804b5d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804b60:	83 ec 04             	sub    $0x4,%esp
  804b63:	68 7c 58 80 00       	push   $0x80587c
  804b68:	68 58 02 00 00       	push   $0x258
  804b6d:	68 85 57 80 00       	push   $0x805785
  804b72:	e8 3c ca ff ff       	call   8015b3 <_panic>

00804b77 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  804b77:	55                   	push   %ebp
  804b78:	89 e5                	mov    %esp,%ebp
  804b7a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804b7d:	83 ec 04             	sub    $0x4,%esp
  804b80:	68 a4 58 80 00       	push   $0x8058a4
  804b85:	68 61 02 00 00       	push   $0x261
  804b8a:	68 85 57 80 00       	push   $0x805785
  804b8f:	e8 1f ca ff ff       	call   8015b3 <_panic>

00804b94 <__udivdi3>:
  804b94:	55                   	push   %ebp
  804b95:	57                   	push   %edi
  804b96:	56                   	push   %esi
  804b97:	53                   	push   %ebx
  804b98:	83 ec 1c             	sub    $0x1c,%esp
  804b9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804b9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804ba3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804ba7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804bab:	89 ca                	mov    %ecx,%edx
  804bad:	89 f8                	mov    %edi,%eax
  804baf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804bb3:	85 f6                	test   %esi,%esi
  804bb5:	75 2d                	jne    804be4 <__udivdi3+0x50>
  804bb7:	39 cf                	cmp    %ecx,%edi
  804bb9:	77 65                	ja     804c20 <__udivdi3+0x8c>
  804bbb:	89 fd                	mov    %edi,%ebp
  804bbd:	85 ff                	test   %edi,%edi
  804bbf:	75 0b                	jne    804bcc <__udivdi3+0x38>
  804bc1:	b8 01 00 00 00       	mov    $0x1,%eax
  804bc6:	31 d2                	xor    %edx,%edx
  804bc8:	f7 f7                	div    %edi
  804bca:	89 c5                	mov    %eax,%ebp
  804bcc:	31 d2                	xor    %edx,%edx
  804bce:	89 c8                	mov    %ecx,%eax
  804bd0:	f7 f5                	div    %ebp
  804bd2:	89 c1                	mov    %eax,%ecx
  804bd4:	89 d8                	mov    %ebx,%eax
  804bd6:	f7 f5                	div    %ebp
  804bd8:	89 cf                	mov    %ecx,%edi
  804bda:	89 fa                	mov    %edi,%edx
  804bdc:	83 c4 1c             	add    $0x1c,%esp
  804bdf:	5b                   	pop    %ebx
  804be0:	5e                   	pop    %esi
  804be1:	5f                   	pop    %edi
  804be2:	5d                   	pop    %ebp
  804be3:	c3                   	ret    
  804be4:	39 ce                	cmp    %ecx,%esi
  804be6:	77 28                	ja     804c10 <__udivdi3+0x7c>
  804be8:	0f bd fe             	bsr    %esi,%edi
  804beb:	83 f7 1f             	xor    $0x1f,%edi
  804bee:	75 40                	jne    804c30 <__udivdi3+0x9c>
  804bf0:	39 ce                	cmp    %ecx,%esi
  804bf2:	72 0a                	jb     804bfe <__udivdi3+0x6a>
  804bf4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804bf8:	0f 87 9e 00 00 00    	ja     804c9c <__udivdi3+0x108>
  804bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  804c03:	89 fa                	mov    %edi,%edx
  804c05:	83 c4 1c             	add    $0x1c,%esp
  804c08:	5b                   	pop    %ebx
  804c09:	5e                   	pop    %esi
  804c0a:	5f                   	pop    %edi
  804c0b:	5d                   	pop    %ebp
  804c0c:	c3                   	ret    
  804c0d:	8d 76 00             	lea    0x0(%esi),%esi
  804c10:	31 ff                	xor    %edi,%edi
  804c12:	31 c0                	xor    %eax,%eax
  804c14:	89 fa                	mov    %edi,%edx
  804c16:	83 c4 1c             	add    $0x1c,%esp
  804c19:	5b                   	pop    %ebx
  804c1a:	5e                   	pop    %esi
  804c1b:	5f                   	pop    %edi
  804c1c:	5d                   	pop    %ebp
  804c1d:	c3                   	ret    
  804c1e:	66 90                	xchg   %ax,%ax
  804c20:	89 d8                	mov    %ebx,%eax
  804c22:	f7 f7                	div    %edi
  804c24:	31 ff                	xor    %edi,%edi
  804c26:	89 fa                	mov    %edi,%edx
  804c28:	83 c4 1c             	add    $0x1c,%esp
  804c2b:	5b                   	pop    %ebx
  804c2c:	5e                   	pop    %esi
  804c2d:	5f                   	pop    %edi
  804c2e:	5d                   	pop    %ebp
  804c2f:	c3                   	ret    
  804c30:	bd 20 00 00 00       	mov    $0x20,%ebp
  804c35:	89 eb                	mov    %ebp,%ebx
  804c37:	29 fb                	sub    %edi,%ebx
  804c39:	89 f9                	mov    %edi,%ecx
  804c3b:	d3 e6                	shl    %cl,%esi
  804c3d:	89 c5                	mov    %eax,%ebp
  804c3f:	88 d9                	mov    %bl,%cl
  804c41:	d3 ed                	shr    %cl,%ebp
  804c43:	89 e9                	mov    %ebp,%ecx
  804c45:	09 f1                	or     %esi,%ecx
  804c47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804c4b:	89 f9                	mov    %edi,%ecx
  804c4d:	d3 e0                	shl    %cl,%eax
  804c4f:	89 c5                	mov    %eax,%ebp
  804c51:	89 d6                	mov    %edx,%esi
  804c53:	88 d9                	mov    %bl,%cl
  804c55:	d3 ee                	shr    %cl,%esi
  804c57:	89 f9                	mov    %edi,%ecx
  804c59:	d3 e2                	shl    %cl,%edx
  804c5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  804c5f:	88 d9                	mov    %bl,%cl
  804c61:	d3 e8                	shr    %cl,%eax
  804c63:	09 c2                	or     %eax,%edx
  804c65:	89 d0                	mov    %edx,%eax
  804c67:	89 f2                	mov    %esi,%edx
  804c69:	f7 74 24 0c          	divl   0xc(%esp)
  804c6d:	89 d6                	mov    %edx,%esi
  804c6f:	89 c3                	mov    %eax,%ebx
  804c71:	f7 e5                	mul    %ebp
  804c73:	39 d6                	cmp    %edx,%esi
  804c75:	72 19                	jb     804c90 <__udivdi3+0xfc>
  804c77:	74 0b                	je     804c84 <__udivdi3+0xf0>
  804c79:	89 d8                	mov    %ebx,%eax
  804c7b:	31 ff                	xor    %edi,%edi
  804c7d:	e9 58 ff ff ff       	jmp    804bda <__udivdi3+0x46>
  804c82:	66 90                	xchg   %ax,%ax
  804c84:	8b 54 24 08          	mov    0x8(%esp),%edx
  804c88:	89 f9                	mov    %edi,%ecx
  804c8a:	d3 e2                	shl    %cl,%edx
  804c8c:	39 c2                	cmp    %eax,%edx
  804c8e:	73 e9                	jae    804c79 <__udivdi3+0xe5>
  804c90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804c93:	31 ff                	xor    %edi,%edi
  804c95:	e9 40 ff ff ff       	jmp    804bda <__udivdi3+0x46>
  804c9a:	66 90                	xchg   %ax,%ax
  804c9c:	31 c0                	xor    %eax,%eax
  804c9e:	e9 37 ff ff ff       	jmp    804bda <__udivdi3+0x46>
  804ca3:	90                   	nop

00804ca4 <__umoddi3>:
  804ca4:	55                   	push   %ebp
  804ca5:	57                   	push   %edi
  804ca6:	56                   	push   %esi
  804ca7:	53                   	push   %ebx
  804ca8:	83 ec 1c             	sub    $0x1c,%esp
  804cab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804caf:	8b 74 24 34          	mov    0x34(%esp),%esi
  804cb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804cb7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804cbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804cbf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804cc3:	89 f3                	mov    %esi,%ebx
  804cc5:	89 fa                	mov    %edi,%edx
  804cc7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804ccb:	89 34 24             	mov    %esi,(%esp)
  804cce:	85 c0                	test   %eax,%eax
  804cd0:	75 1a                	jne    804cec <__umoddi3+0x48>
  804cd2:	39 f7                	cmp    %esi,%edi
  804cd4:	0f 86 a2 00 00 00    	jbe    804d7c <__umoddi3+0xd8>
  804cda:	89 c8                	mov    %ecx,%eax
  804cdc:	89 f2                	mov    %esi,%edx
  804cde:	f7 f7                	div    %edi
  804ce0:	89 d0                	mov    %edx,%eax
  804ce2:	31 d2                	xor    %edx,%edx
  804ce4:	83 c4 1c             	add    $0x1c,%esp
  804ce7:	5b                   	pop    %ebx
  804ce8:	5e                   	pop    %esi
  804ce9:	5f                   	pop    %edi
  804cea:	5d                   	pop    %ebp
  804ceb:	c3                   	ret    
  804cec:	39 f0                	cmp    %esi,%eax
  804cee:	0f 87 ac 00 00 00    	ja     804da0 <__umoddi3+0xfc>
  804cf4:	0f bd e8             	bsr    %eax,%ebp
  804cf7:	83 f5 1f             	xor    $0x1f,%ebp
  804cfa:	0f 84 ac 00 00 00    	je     804dac <__umoddi3+0x108>
  804d00:	bf 20 00 00 00       	mov    $0x20,%edi
  804d05:	29 ef                	sub    %ebp,%edi
  804d07:	89 fe                	mov    %edi,%esi
  804d09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804d0d:	89 e9                	mov    %ebp,%ecx
  804d0f:	d3 e0                	shl    %cl,%eax
  804d11:	89 d7                	mov    %edx,%edi
  804d13:	89 f1                	mov    %esi,%ecx
  804d15:	d3 ef                	shr    %cl,%edi
  804d17:	09 c7                	or     %eax,%edi
  804d19:	89 e9                	mov    %ebp,%ecx
  804d1b:	d3 e2                	shl    %cl,%edx
  804d1d:	89 14 24             	mov    %edx,(%esp)
  804d20:	89 d8                	mov    %ebx,%eax
  804d22:	d3 e0                	shl    %cl,%eax
  804d24:	89 c2                	mov    %eax,%edx
  804d26:	8b 44 24 08          	mov    0x8(%esp),%eax
  804d2a:	d3 e0                	shl    %cl,%eax
  804d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804d30:	8b 44 24 08          	mov    0x8(%esp),%eax
  804d34:	89 f1                	mov    %esi,%ecx
  804d36:	d3 e8                	shr    %cl,%eax
  804d38:	09 d0                	or     %edx,%eax
  804d3a:	d3 eb                	shr    %cl,%ebx
  804d3c:	89 da                	mov    %ebx,%edx
  804d3e:	f7 f7                	div    %edi
  804d40:	89 d3                	mov    %edx,%ebx
  804d42:	f7 24 24             	mull   (%esp)
  804d45:	89 c6                	mov    %eax,%esi
  804d47:	89 d1                	mov    %edx,%ecx
  804d49:	39 d3                	cmp    %edx,%ebx
  804d4b:	0f 82 87 00 00 00    	jb     804dd8 <__umoddi3+0x134>
  804d51:	0f 84 91 00 00 00    	je     804de8 <__umoddi3+0x144>
  804d57:	8b 54 24 04          	mov    0x4(%esp),%edx
  804d5b:	29 f2                	sub    %esi,%edx
  804d5d:	19 cb                	sbb    %ecx,%ebx
  804d5f:	89 d8                	mov    %ebx,%eax
  804d61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804d65:	d3 e0                	shl    %cl,%eax
  804d67:	89 e9                	mov    %ebp,%ecx
  804d69:	d3 ea                	shr    %cl,%edx
  804d6b:	09 d0                	or     %edx,%eax
  804d6d:	89 e9                	mov    %ebp,%ecx
  804d6f:	d3 eb                	shr    %cl,%ebx
  804d71:	89 da                	mov    %ebx,%edx
  804d73:	83 c4 1c             	add    $0x1c,%esp
  804d76:	5b                   	pop    %ebx
  804d77:	5e                   	pop    %esi
  804d78:	5f                   	pop    %edi
  804d79:	5d                   	pop    %ebp
  804d7a:	c3                   	ret    
  804d7b:	90                   	nop
  804d7c:	89 fd                	mov    %edi,%ebp
  804d7e:	85 ff                	test   %edi,%edi
  804d80:	75 0b                	jne    804d8d <__umoddi3+0xe9>
  804d82:	b8 01 00 00 00       	mov    $0x1,%eax
  804d87:	31 d2                	xor    %edx,%edx
  804d89:	f7 f7                	div    %edi
  804d8b:	89 c5                	mov    %eax,%ebp
  804d8d:	89 f0                	mov    %esi,%eax
  804d8f:	31 d2                	xor    %edx,%edx
  804d91:	f7 f5                	div    %ebp
  804d93:	89 c8                	mov    %ecx,%eax
  804d95:	f7 f5                	div    %ebp
  804d97:	89 d0                	mov    %edx,%eax
  804d99:	e9 44 ff ff ff       	jmp    804ce2 <__umoddi3+0x3e>
  804d9e:	66 90                	xchg   %ax,%ax
  804da0:	89 c8                	mov    %ecx,%eax
  804da2:	89 f2                	mov    %esi,%edx
  804da4:	83 c4 1c             	add    $0x1c,%esp
  804da7:	5b                   	pop    %ebx
  804da8:	5e                   	pop    %esi
  804da9:	5f                   	pop    %edi
  804daa:	5d                   	pop    %ebp
  804dab:	c3                   	ret    
  804dac:	3b 04 24             	cmp    (%esp),%eax
  804daf:	72 06                	jb     804db7 <__umoddi3+0x113>
  804db1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804db5:	77 0f                	ja     804dc6 <__umoddi3+0x122>
  804db7:	89 f2                	mov    %esi,%edx
  804db9:	29 f9                	sub    %edi,%ecx
  804dbb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804dbf:	89 14 24             	mov    %edx,(%esp)
  804dc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804dc6:	8b 44 24 04          	mov    0x4(%esp),%eax
  804dca:	8b 14 24             	mov    (%esp),%edx
  804dcd:	83 c4 1c             	add    $0x1c,%esp
  804dd0:	5b                   	pop    %ebx
  804dd1:	5e                   	pop    %esi
  804dd2:	5f                   	pop    %edi
  804dd3:	5d                   	pop    %ebp
  804dd4:	c3                   	ret    
  804dd5:	8d 76 00             	lea    0x0(%esi),%esi
  804dd8:	2b 04 24             	sub    (%esp),%eax
  804ddb:	19 fa                	sbb    %edi,%edx
  804ddd:	89 d1                	mov    %edx,%ecx
  804ddf:	89 c6                	mov    %eax,%esi
  804de1:	e9 71 ff ff ff       	jmp    804d57 <__umoddi3+0xb3>
  804de6:	66 90                	xchg   %ax,%ax
  804de8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804dec:	72 ea                	jb     804dd8 <__umoddi3+0x134>
  804dee:	89 d9                	mov    %ebx,%ecx
  804df0:	e9 62 ff ff ff       	jmp    804d57 <__umoddi3+0xb3>
