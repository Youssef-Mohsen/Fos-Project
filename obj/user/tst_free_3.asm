
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
  800079:	e8 9a 25 00 00       	call   802618 <malloc>
  80007e:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800081:	a1 04 40 80 00       	mov    0x804004,%eax
  800086:	8b 80 7c 05 00 00    	mov    0x57c(%eax),%eax
  80008c:	8b 00                	mov    (%eax),%eax
  80008e:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800091:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800099:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80009e:	74 14                	je     8000b4 <_main+0x7c>
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 c0 2f 80 00       	push   $0x802fc0
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 01 30 80 00       	push   $0x803001
  8000af:	e8 f7 14 00 00       	call   8015ab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000b4:	a1 04 40 80 00       	mov    0x804004,%eax
  8000b9:	8b 80 7c 05 00 00    	mov    0x57c(%eax),%eax
  8000bf:	83 c0 18             	add    $0x18,%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8000c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8000ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000cf:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 c0 2f 80 00       	push   $0x802fc0
  8000de:	6a 21                	push   $0x21
  8000e0:	68 01 30 80 00       	push   $0x803001
  8000e5:	e8 c1 14 00 00       	call   8015ab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8000ef:	8b 80 7c 05 00 00    	mov    0x57c(%eax),%eax
  8000f5:	83 c0 30             	add    $0x30,%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000fd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800105:	3d 00 20 20 00       	cmp    $0x202000,%eax
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 c0 2f 80 00       	push   $0x802fc0
  800114:	6a 22                	push   $0x22
  800116:	68 01 30 80 00       	push   $0x803001
  80011b:	e8 8b 14 00 00       	call   8015ab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800120:	a1 04 40 80 00       	mov    0x804004,%eax
  800125:	8b 80 7c 05 00 00    	mov    0x57c(%eax),%eax
  80012b:	83 c0 48             	add    $0x48,%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800133:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800136:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80013b:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 c0 2f 80 00       	push   $0x802fc0
  80014a:	6a 23                	push   $0x23
  80014c:	68 01 30 80 00       	push   $0x803001
  800151:	e8 55 14 00 00       	call   8015ab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800156:	a1 04 40 80 00       	mov    0x804004,%eax
  80015b:	8b 80 7c 05 00 00    	mov    0x57c(%eax),%eax
  800161:	83 c0 60             	add    $0x60,%eax
  800164:	8b 00                	mov    (%eax),%eax
  800166:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800169:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80016c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800171:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800176:	74 14                	je     80018c <_main+0x154>
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	68 c0 2f 80 00       	push   $0x802fc0
  800180:	6a 24                	push   $0x24
  800182:	68 01 30 80 00       	push   $0x803001
  800187:	e8 1f 14 00 00       	call   8015ab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80018c:	a1 04 40 80 00       	mov    0x804004,%eax
  800191:	8b 80 7c 05 00 00    	mov    0x57c(%eax),%eax
  800197:	83 c0 78             	add    $0x78,%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80019f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a7:	3d 00 50 20 00       	cmp    $0x205000,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 c0 2f 80 00       	push   $0x802fc0
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 01 30 80 00       	push   $0x803001
  8001bd:	e8 e9 13 00 00       	call   8015ab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001c2:	a1 04 40 80 00       	mov    0x804004,%eax
  8001c7:	8b 80 7c 05 00 00    	mov    0x57c(%eax),%eax
  8001cd:	05 90 00 00 00       	add    $0x90,%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8001d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001df:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001e4:	74 14                	je     8001fa <_main+0x1c2>
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	68 c0 2f 80 00       	push   $0x802fc0
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 01 30 80 00       	push   $0x803001
  8001f5:	e8 b1 13 00 00       	call   8015ab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8001ff:	8b 80 7c 05 00 00    	mov    0x57c(%eax),%eax
  800205:	05 a8 00 00 00       	add    $0xa8,%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80020f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800212:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800217:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80021c:	74 14                	je     800232 <_main+0x1fa>
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 c0 2f 80 00       	push   $0x802fc0
  800226:	6a 27                	push   $0x27
  800228:	68 01 30 80 00       	push   $0x803001
  80022d:	e8 79 13 00 00       	call   8015ab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800232:	a1 04 40 80 00       	mov    0x804004,%eax
  800237:	8b 80 7c 05 00 00    	mov    0x57c(%eax),%eax
  80023d:	05 c0 00 00 00       	add    $0xc0,%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800247:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80024a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 c0 2f 80 00       	push   $0x802fc0
  80025e:	6a 28                	push   $0x28
  800260:	68 01 30 80 00       	push   $0x803001
  800265:	e8 41 13 00 00       	call   8015ab <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026a:	a1 04 40 80 00       	mov    0x804004,%eax
  80026f:	8b 80 7c 05 00 00    	mov    0x57c(%eax),%eax
  800275:	05 d8 00 00 00       	add    $0xd8,%eax
  80027a:	8b 00                	mov    (%eax),%eax
  80027c:	89 45 98             	mov    %eax,-0x68(%ebp)
  80027f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800282:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800287:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 c0 2f 80 00       	push   $0x802fc0
  800296:	6a 29                	push   $0x29
  800298:	68 01 30 80 00       	push   $0x803001
  80029d:	e8 09 13 00 00       	call   8015ab <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 04 40 80 00       	mov    0x804004,%eax
  8002a7:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 14 30 80 00       	push   $0x803014
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 01 30 80 00       	push   $0x803001
  8002c0:	e8 e6 12 00 00       	call   8015ab <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 82 25 00 00       	call   80284c <sys_calculate_free_frames>
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
  8002e1:	e8 b1 25 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
  8002e6:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8002e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	50                   	push   %eax
  8002f5:	e8 1e 23 00 00       	call   802618 <malloc>
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
  80031d:	68 5c 30 80 00       	push   $0x80305c
  800322:	6a 39                	push   $0x39
  800324:	68 01 30 80 00       	push   $0x803001
  800329:	e8 7d 12 00 00       	call   8015ab <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 64 25 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 c4 30 80 00       	push   $0x8030c4
  800345:	6a 3a                	push   $0x3a
  800347:	68 01 30 80 00       	push   $0x803001
  80034c:	e8 5a 12 00 00       	call   8015ab <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 41 25 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
  800356:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035c:	89 c2                	mov    %eax,%edx
  80035e:	01 d2                	add    %edx,%edx
  800360:	01 d0                	add    %edx,%eax
  800362:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	50                   	push   %eax
  800369:	e8 aa 22 00 00       	call   802618 <malloc>
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
  8003a6:	68 5c 30 80 00       	push   $0x80305c
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 01 30 80 00       	push   $0x803001
  8003b2:	e8 f4 11 00 00       	call   8015ab <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 db 24 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
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
  8003dd:	68 c4 30 80 00       	push   $0x8030c4
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 01 30 80 00       	push   $0x803001
  8003e9:	e8 bd 11 00 00       	call   8015ab <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 a4 24 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
  8003f3:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(8*Mega-kilo);
  8003f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f9:	c1 e0 03             	shl    $0x3,%eax
  8003fc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8003ff:	83 ec 0c             	sub    $0xc,%esp
  800402:	50                   	push   %eax
  800403:	e8 10 22 00 00       	call   802618 <malloc>
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
  80044a:	68 5c 30 80 00       	push   $0x80305c
  80044f:	6a 47                	push   $0x47
  800451:	68 01 30 80 00       	push   $0x803001
  800456:	e8 50 11 00 00       	call   8015ab <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 37 24 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
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
  80047e:	68 c4 30 80 00       	push   $0x8030c4
  800483:	6a 48                	push   $0x48
  800485:	68 01 30 80 00       	push   $0x803001
  80048a:	e8 1c 11 00 00       	call   8015ab <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 03 24 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
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
  8004ab:	e8 68 21 00 00       	call   802618 <malloc>
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
  8004fa:	68 5c 30 80 00       	push   $0x80305c
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 01 30 80 00       	push   $0x803001
  800506:	e8 a0 10 00 00       	call   8015ab <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 87 23 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
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
  800535:	68 c4 30 80 00       	push   $0x8030c4
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 01 30 80 00       	push   $0x803001
  800541:	e8 65 10 00 00       	call   8015ab <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 01 23 00 00       	call   80284c <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 12 23 00 00       	call   802865 <sys_calculate_modified_frames>
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
  80060f:	e8 38 22 00 00       	call   80284c <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 4a 22 00 00       	call   802865 <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 f4 30 80 00       	push   $0x8030f4
  80062e:	6a 67                	push   $0x67
  800630:	68 01 30 80 00       	push   $0x803001
  800635:	e8 71 0f 00 00       	call   8015ab <_panic>
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
  800658:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  8006d8:	68 38 31 80 00       	push   $0x803138
  8006dd:	6a 73                	push   $0x73
  8006df:	68 01 30 80 00       	push   $0x803001
  8006e4:	e8 c2 0e 00 00       	call   8015ab <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e9:	e8 5e 21 00 00       	call   80284c <sys_calculate_free_frames>
  8006ee:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006f1:	e8 6f 21 00 00       	call   802865 <sys_calculate_modified_frames>
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
  8007f2:	e8 55 20 00 00       	call   80284c <sys_calculate_free_frames>
  8007f7:	29 c3                	sub    %eax,%ebx
  8007f9:	89 d8                	mov    %ebx,%eax
  8007fb:	83 f8 04             	cmp    $0x4,%eax
  8007fe:	74 17                	je     800817 <_main+0x7df>
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	68 f4 30 80 00       	push   $0x8030f4
  800808:	68 8e 00 00 00       	push   $0x8e
  80080d:	68 01 30 80 00       	push   $0x803001
  800812:	e8 94 0d 00 00       	call   8015ab <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800817:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  80081a:	e8 46 20 00 00       	call   802865 <sys_calculate_modified_frames>
  80081f:	29 c3                	sub    %eax,%ebx
  800821:	89 d8                	mov    %ebx,%eax
  800823:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800826:	74 17                	je     80083f <_main+0x807>
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 f4 30 80 00       	push   $0x8030f4
  800830:	68 8f 00 00 00       	push   $0x8f
  800835:	68 01 30 80 00       	push   $0x803001
  80083a:	e8 6c 0d 00 00       	call   8015ab <_panic>
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
  80085d:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  8008df:	68 38 31 80 00       	push   $0x803138
  8008e4:	68 9b 00 00 00       	push   $0x9b
  8008e9:	68 01 30 80 00       	push   $0x803001
  8008ee:	e8 b8 0c 00 00       	call   8015ab <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008f3:	e8 54 1f 00 00       	call   80284c <sys_calculate_free_frames>
  8008f8:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008fb:	e8 65 1f 00 00       	call   802865 <sys_calculate_modified_frames>
  800900:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800903:	e8 8f 1f 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
  800908:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  80090b:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800911:	83 ec 0c             	sub    $0xc,%esp
  800914:	50                   	push   %eax
  800915:	e8 27 1d 00 00       	call   802641 <free>
  80091a:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80091d:	e8 75 1f 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
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
  800945:	68 58 31 80 00       	push   $0x803158
  80094a:	68 a5 00 00 00       	push   $0xa5
  80094f:	68 01 30 80 00       	push   $0x803001
  800954:	e8 52 0c 00 00       	call   8015ab <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  800959:	e8 ee 1e 00 00       	call   80284c <sys_calculate_free_frames>
  80095e:	89 c2                	mov    %eax,%edx
  800960:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800963:	29 c2                	sub    %eax,%edx
  800965:	89 d0                	mov    %edx,%eax
  800967:	83 f8 07             	cmp    $0x7,%eax
  80096a:	74 17                	je     800983 <_main+0x94b>
  80096c:	83 ec 04             	sub    $0x4,%esp
  80096f:	68 94 31 80 00       	push   $0x803194
  800974:	68 a7 00 00 00       	push   $0xa7
  800979:	68 01 30 80 00       	push   $0x803001
  80097e:	e8 28 0c 00 00       	call   8015ab <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800983:	e8 dd 1e 00 00       	call   802865 <sys_calculate_modified_frames>
  800988:	89 c2                	mov    %eax,%edx
  80098a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80098d:	29 c2                	sub    %eax,%edx
  80098f:	89 d0                	mov    %edx,%eax
  800991:	83 f8 02             	cmp    $0x2,%eax
  800994:	74 17                	je     8009ad <_main+0x975>
  800996:	83 ec 04             	sub    $0x4,%esp
  800999:	68 e8 31 80 00       	push   $0x8031e8
  80099e:	68 a8 00 00 00       	push   $0xa8
  8009a3:	68 01 30 80 00       	push   $0x803001
  8009a8:	e8 fe 0b 00 00       	call   8015ab <_panic>
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
  8009c7:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800a1c:	68 20 32 80 00       	push   $0x803220
  800a21:	68 b0 00 00 00       	push   $0xb0
  800a26:	68 01 30 80 00       	push   $0x803001
  800a2b:	e8 7b 0b 00 00       	call   8015ab <_panic>
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
  800a56:	e8 f1 1d 00 00       	call   80284c <sys_calculate_free_frames>
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
  800aa3:	e8 a4 1d 00 00       	call   80284c <sys_calculate_free_frames>
  800aa8:	29 c3                	sub    %eax,%ebx
  800aaa:	89 d8                	mov    %ebx,%eax
  800aac:	83 f8 02             	cmp    $0x2,%eax
  800aaf:	74 17                	je     800ac8 <_main+0xa90>
  800ab1:	83 ec 04             	sub    $0x4,%esp
  800ab4:	68 f4 30 80 00       	push   $0x8030f4
  800ab9:	68 bc 00 00 00       	push   $0xbc
  800abe:	68 01 30 80 00       	push   $0x803001
  800ac3:	e8 e3 0a 00 00       	call   8015ab <_panic>
		found = 0;
  800ac8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800acf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ad6:	e9 a7 00 00 00       	jmp    800b82 <_main+0xb4a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800adb:	a1 04 40 80 00       	mov    0x804004,%eax
  800ae0:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800b2c:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800ba1:	68 38 31 80 00       	push   $0x803138
  800ba6:	68 c5 00 00 00       	push   $0xc5
  800bab:	68 01 30 80 00       	push   $0x803001
  800bb0:	e8 f6 09 00 00       	call   8015ab <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bb5:	e8 dd 1c 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
  800bba:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800bbd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc0:	01 c0                	add    %eax,%eax
  800bc2:	83 ec 0c             	sub    $0xc,%esp
  800bc5:	50                   	push   %eax
  800bc6:	e8 4d 1a 00 00       	call   802618 <malloc>
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
  800c05:	68 5c 30 80 00       	push   $0x80305c
  800c0a:	68 ca 00 00 00       	push   $0xca
  800c0f:	68 01 30 80 00       	push   $0x803001
  800c14:	e8 92 09 00 00       	call   8015ab <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c19:	e8 79 1c 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
  800c1e:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c21:	83 f8 01             	cmp    $0x1,%eax
  800c24:	74 17                	je     800c3d <_main+0xc05>
  800c26:	83 ec 04             	sub    $0x4,%esp
  800c29:	68 c4 30 80 00       	push   $0x8030c4
  800c2e:	68 cb 00 00 00       	push   $0xcb
  800c33:	68 01 30 80 00       	push   $0x803001
  800c38:	e8 6e 09 00 00       	call   8015ab <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c3d:	e8 0a 1c 00 00       	call   80284c <sys_calculate_free_frames>
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
  800c88:	e8 bf 1b 00 00       	call   80284c <sys_calculate_free_frames>
  800c8d:	29 c3                	sub    %eax,%ebx
  800c8f:	89 d8                	mov    %ebx,%eax
  800c91:	83 f8 02             	cmp    $0x2,%eax
  800c94:	74 17                	je     800cad <_main+0xc75>
  800c96:	83 ec 04             	sub    $0x4,%esp
  800c99:	68 f4 30 80 00       	push   $0x8030f4
  800c9e:	68 d2 00 00 00       	push   $0xd2
  800ca3:	68 01 30 80 00       	push   $0x803001
  800ca8:	e8 fe 08 00 00       	call   8015ab <_panic>
		found = 0;
  800cad:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800cb4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800cbb:	e9 aa 00 00 00       	jmp    800d6a <_main+0xd32>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800cc0:	a1 04 40 80 00       	mov    0x804004,%eax
  800cc5:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800d11:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  800d89:	68 38 31 80 00       	push   $0x803138
  800d8e:	68 db 00 00 00       	push   $0xdb
  800d93:	68 01 30 80 00       	push   $0x803001
  800d98:	e8 0e 08 00 00       	call   8015ab <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d9d:	e8 aa 1a 00 00       	call   80284c <sys_calculate_free_frames>
  800da2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800da5:	e8 ed 1a 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
  800daa:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800dad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800db0:	01 c0                	add    %eax,%eax
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	50                   	push   %eax
  800db6:	e8 5d 18 00 00       	call   802618 <malloc>
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
  800e09:	68 5c 30 80 00       	push   $0x80305c
  800e0e:	68 e1 00 00 00       	push   $0xe1
  800e13:	68 01 30 80 00       	push   $0x803001
  800e18:	e8 8e 07 00 00       	call   8015ab <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e1d:	e8 75 1a 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
  800e22:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e25:	83 f8 01             	cmp    $0x1,%eax
  800e28:	74 17                	je     800e41 <_main+0xe09>
  800e2a:	83 ec 04             	sub    $0x4,%esp
  800e2d:	68 c4 30 80 00       	push   $0x8030c4
  800e32:	68 e2 00 00 00       	push   $0xe2
  800e37:	68 01 30 80 00       	push   $0x803001
  800e3c:	e8 6a 07 00 00       	call   8015ab <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e41:	e8 51 1a 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
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
  800e5a:	e8 b9 17 00 00       	call   802618 <malloc>
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
  800ead:	68 5c 30 80 00       	push   $0x80305c
  800eb2:	68 e8 00 00 00       	push   $0xe8
  800eb7:	68 01 30 80 00       	push   $0x803001
  800ebc:	e8 ea 06 00 00       	call   8015ab <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ec1:	e8 d1 19 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
  800ec6:	2b 45 90             	sub    -0x70(%ebp),%eax
  800ec9:	83 f8 02             	cmp    $0x2,%eax
  800ecc:	74 17                	je     800ee5 <_main+0xead>
  800ece:	83 ec 04             	sub    $0x4,%esp
  800ed1:	68 c4 30 80 00       	push   $0x8030c4
  800ed6:	68 e9 00 00 00       	push   $0xe9
  800edb:	68 01 30 80 00       	push   $0x803001
  800ee0:	e8 c6 06 00 00       	call   8015ab <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800ee5:	e8 62 19 00 00       	call   80284c <sys_calculate_free_frames>
  800eea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800eed:	e8 a5 19 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
  800ef2:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800ef5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ef8:	89 c2                	mov    %eax,%edx
  800efa:	01 d2                	add    %edx,%edx
  800efc:	01 d0                	add    %edx,%eax
  800efe:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800f01:	83 ec 0c             	sub    $0xc,%esp
  800f04:	50                   	push   %eax
  800f05:	e8 0e 17 00 00       	call   802618 <malloc>
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
  800f58:	68 5c 30 80 00       	push   $0x80305c
  800f5d:	68 f0 00 00 00       	push   $0xf0
  800f62:	68 01 30 80 00       	push   $0x803001
  800f67:	e8 3f 06 00 00       	call   8015ab <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f6c:	e8 26 19 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
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
  800f92:	68 c4 30 80 00       	push   $0x8030c4
  800f97:	68 f1 00 00 00       	push   $0xf1
  800f9c:	68 01 30 80 00       	push   $0x803001
  800fa1:	e8 05 06 00 00       	call   8015ab <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800fa6:	e8 ec 18 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
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
  800fc0:	e8 53 16 00 00       	call   802618 <malloc>
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
  801021:	68 5c 30 80 00       	push   $0x80305c
  801026:	68 f7 00 00 00       	push   $0xf7
  80102b:	68 01 30 80 00       	push   $0x803001
  801030:	e8 76 05 00 00       	call   8015ab <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  801035:	e8 5d 18 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
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
  80105d:	68 c4 30 80 00       	push   $0x8030c4
  801062:	68 f8 00 00 00       	push   $0xf8
  801067:	68 01 30 80 00       	push   $0x803001
  80106c:	e8 3a 05 00 00       	call   8015ab <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801071:	e8 d6 17 00 00       	call   80284c <sys_calculate_free_frames>
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
  8010e2:	e8 65 17 00 00       	call   80284c <sys_calculate_free_frames>
  8010e7:	29 c3                	sub    %eax,%ebx
  8010e9:	89 d8                	mov    %ebx,%eax
  8010eb:	83 f8 05             	cmp    $0x5,%eax
  8010ee:	74 17                	je     801107 <_main+0x10cf>
  8010f0:	83 ec 04             	sub    $0x4,%esp
  8010f3:	68 f4 30 80 00       	push   $0x8030f4
  8010f8:	68 00 01 00 00       	push   $0x100
  8010fd:	68 01 30 80 00       	push   $0x803001
  801102:	e8 a4 04 00 00       	call   8015ab <_panic>
		found = 0;
  801107:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80110e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801115:	e9 02 01 00 00       	jmp    80121c <_main+0x11e4>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  80111a:	a1 04 40 80 00       	mov    0x804004,%eax
  80111f:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  80116b:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  8011ca:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  80123b:	68 38 31 80 00       	push   $0x803138
  801240:	68 0b 01 00 00       	push   $0x10b
  801245:	68 01 30 80 00       	push   $0x803001
  80124a:	e8 5c 03 00 00       	call   8015ab <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80124f:	e8 43 16 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
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
  80126a:	e8 a9 13 00 00       	call   802618 <malloc>
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
  8012cd:	68 5c 30 80 00       	push   $0x80305c
  8012d2:	68 10 01 00 00       	push   $0x110
  8012d7:	68 01 30 80 00       	push   $0x803001
  8012dc:	e8 ca 02 00 00       	call   8015ab <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012e1:	e8 b1 15 00 00       	call   802897 <sys_pf_calculate_allocated_pages>
  8012e6:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012e9:	83 f8 04             	cmp    $0x4,%eax
  8012ec:	74 17                	je     801305 <_main+0x12cd>
  8012ee:	83 ec 04             	sub    $0x4,%esp
  8012f1:	68 c4 30 80 00       	push   $0x8030c4
  8012f6:	68 11 01 00 00       	push   $0x111
  8012fb:	68 01 30 80 00       	push   $0x803001
  801300:	e8 a6 02 00 00       	call   8015ab <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801305:	e8 42 15 00 00       	call   80284c <sys_calculate_free_frames>
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
  801359:	e8 ee 14 00 00       	call   80284c <sys_calculate_free_frames>
  80135e:	29 c3                	sub    %eax,%ebx
  801360:	89 d8                	mov    %ebx,%eax
  801362:	83 f8 02             	cmp    $0x2,%eax
  801365:	74 17                	je     80137e <_main+0x1346>
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	68 f4 30 80 00       	push   $0x8030f4
  80136f:	68 18 01 00 00       	push   $0x118
  801374:	68 01 30 80 00       	push   $0x803001
  801379:	e8 2d 02 00 00       	call   8015ab <_panic>
		found = 0;
  80137e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801385:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80138c:	e9 a7 00 00 00       	jmp    801438 <_main+0x1400>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  801391:	a1 04 40 80 00       	mov    0x804004,%eax
  801396:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  8013e2:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
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
  801457:	68 38 31 80 00       	push   $0x803138
  80145c:	68 21 01 00 00       	push   $0x121
  801461:	68 01 30 80 00       	push   $0x803001
  801466:	e8 40 01 00 00       	call   8015ab <_panic>
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
  80147a:	e8 96 15 00 00       	call   802a15 <sys_getenvindex>
  80147f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  801482:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801485:	89 d0                	mov    %edx,%eax
  801487:	c1 e0 02             	shl    $0x2,%eax
  80148a:	01 d0                	add    %edx,%eax
  80148c:	01 c0                	add    %eax,%eax
  80148e:	01 d0                	add    %edx,%eax
  801490:	c1 e0 02             	shl    $0x2,%eax
  801493:	01 d0                	add    %edx,%eax
  801495:	01 c0                	add    %eax,%eax
  801497:	01 d0                	add    %edx,%eax
  801499:	c1 e0 04             	shl    $0x4,%eax
  80149c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014a1:	a3 04 40 80 00       	mov    %eax,0x804004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8014a6:	a1 04 40 80 00       	mov    0x804004,%eax
  8014ab:	8a 40 20             	mov    0x20(%eax),%al
  8014ae:	84 c0                	test   %al,%al
  8014b0:	74 0d                	je     8014bf <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8014b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8014b7:	83 c0 20             	add    $0x20,%eax
  8014ba:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8014bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c3:	7e 0a                	jle    8014cf <libmain+0x5b>
		binaryname = argv[0];
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	8b 00                	mov    (%eax),%eax
  8014ca:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8014cf:	83 ec 08             	sub    $0x8,%esp
  8014d2:	ff 75 0c             	pushl  0xc(%ebp)
  8014d5:	ff 75 08             	pushl  0x8(%ebp)
  8014d8:	e8 5b eb ff ff       	call   800038 <_main>
  8014dd:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8014e0:	e8 b4 12 00 00       	call   802799 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8014e5:	83 ec 0c             	sub    $0xc,%esp
  8014e8:	68 5c 32 80 00       	push   $0x80325c
  8014ed:	e8 76 03 00 00       	call   801868 <cprintf>
  8014f2:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014f5:	a1 04 40 80 00       	mov    0x804004,%eax
  8014fa:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  801500:	a1 04 40 80 00       	mov    0x804004,%eax
  801505:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80150b:	83 ec 04             	sub    $0x4,%esp
  80150e:	52                   	push   %edx
  80150f:	50                   	push   %eax
  801510:	68 84 32 80 00       	push   $0x803284
  801515:	e8 4e 03 00 00       	call   801868 <cprintf>
  80151a:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80151d:	a1 04 40 80 00       	mov    0x804004,%eax
  801522:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  801528:	a1 04 40 80 00       	mov    0x804004,%eax
  80152d:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  801533:	a1 04 40 80 00       	mov    0x804004,%eax
  801538:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80153e:	51                   	push   %ecx
  80153f:	52                   	push   %edx
  801540:	50                   	push   %eax
  801541:	68 ac 32 80 00       	push   $0x8032ac
  801546:	e8 1d 03 00 00       	call   801868 <cprintf>
  80154b:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80154e:	a1 04 40 80 00       	mov    0x804004,%eax
  801553:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  801559:	83 ec 08             	sub    $0x8,%esp
  80155c:	50                   	push   %eax
  80155d:	68 04 33 80 00       	push   $0x803304
  801562:	e8 01 03 00 00       	call   801868 <cprintf>
  801567:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	68 5c 32 80 00       	push   $0x80325c
  801572:	e8 f1 02 00 00       	call   801868 <cprintf>
  801577:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80157a:	e8 34 12 00 00       	call   8027b3 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80157f:	e8 19 00 00 00       	call   80159d <exit>
}
  801584:	90                   	nop
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80158d:	83 ec 0c             	sub    $0xc,%esp
  801590:	6a 00                	push   $0x0
  801592:	e8 4a 14 00 00       	call   8029e1 <sys_destroy_env>
  801597:	83 c4 10             	add    $0x10,%esp
}
  80159a:	90                   	nop
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <exit>:

void
exit(void)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8015a3:	e8 9f 14 00 00       	call   802a47 <sys_exit_env>
}
  8015a8:	90                   	nop
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8015b1:	8d 45 10             	lea    0x10(%ebp),%eax
  8015b4:	83 c0 04             	add    $0x4,%eax
  8015b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8015ba:	a1 24 40 80 00       	mov    0x804024,%eax
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	74 16                	je     8015d9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015c3:	a1 24 40 80 00       	mov    0x804024,%eax
  8015c8:	83 ec 08             	sub    $0x8,%esp
  8015cb:	50                   	push   %eax
  8015cc:	68 18 33 80 00       	push   $0x803318
  8015d1:	e8 92 02 00 00       	call   801868 <cprintf>
  8015d6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015d9:	a1 00 40 80 00       	mov    0x804000,%eax
  8015de:	ff 75 0c             	pushl  0xc(%ebp)
  8015e1:	ff 75 08             	pushl  0x8(%ebp)
  8015e4:	50                   	push   %eax
  8015e5:	68 1d 33 80 00       	push   $0x80331d
  8015ea:	e8 79 02 00 00       	call   801868 <cprintf>
  8015ef:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8015f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f5:	83 ec 08             	sub    $0x8,%esp
  8015f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fb:	50                   	push   %eax
  8015fc:	e8 fc 01 00 00       	call   8017fd <vcprintf>
  801601:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801604:	83 ec 08             	sub    $0x8,%esp
  801607:	6a 00                	push   $0x0
  801609:	68 39 33 80 00       	push   $0x803339
  80160e:	e8 ea 01 00 00       	call   8017fd <vcprintf>
  801613:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801616:	e8 82 ff ff ff       	call   80159d <exit>

	// should not return here
	while (1) ;
  80161b:	eb fe                	jmp    80161b <_panic+0x70>

0080161d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801623:	a1 04 40 80 00       	mov    0x804004,%eax
  801628:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80162e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801631:	39 c2                	cmp    %eax,%edx
  801633:	74 14                	je     801649 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	68 3c 33 80 00       	push   $0x80333c
  80163d:	6a 26                	push   $0x26
  80163f:	68 88 33 80 00       	push   $0x803388
  801644:	e8 62 ff ff ff       	call   8015ab <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801650:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801657:	e9 c5 00 00 00       	jmp    801721 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80165c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	01 d0                	add    %edx,%eax
  80166b:	8b 00                	mov    (%eax),%eax
  80166d:	85 c0                	test   %eax,%eax
  80166f:	75 08                	jne    801679 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801671:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801674:	e9 a5 00 00 00       	jmp    80171e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801679:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801680:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801687:	eb 69                	jmp    8016f2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801689:	a1 04 40 80 00       	mov    0x804004,%eax
  80168e:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801694:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801697:	89 d0                	mov    %edx,%eax
  801699:	01 c0                	add    %eax,%eax
  80169b:	01 d0                	add    %edx,%eax
  80169d:	c1 e0 03             	shl    $0x3,%eax
  8016a0:	01 c8                	add    %ecx,%eax
  8016a2:	8a 40 04             	mov    0x4(%eax),%al
  8016a5:	84 c0                	test   %al,%al
  8016a7:	75 46                	jne    8016ef <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016a9:	a1 04 40 80 00       	mov    0x804004,%eax
  8016ae:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8016b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016b7:	89 d0                	mov    %edx,%eax
  8016b9:	01 c0                	add    %eax,%eax
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	c1 e0 03             	shl    $0x3,%eax
  8016c0:	01 c8                	add    %ecx,%eax
  8016c2:	8b 00                	mov    (%eax),%eax
  8016c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016cf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	01 c8                	add    %ecx,%eax
  8016e0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016e2:	39 c2                	cmp    %eax,%edx
  8016e4:	75 09                	jne    8016ef <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8016e6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016ed:	eb 15                	jmp    801704 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016ef:	ff 45 e8             	incl   -0x18(%ebp)
  8016f2:	a1 04 40 80 00       	mov    0x804004,%eax
  8016f7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8016fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801700:	39 c2                	cmp    %eax,%edx
  801702:	77 85                	ja     801689 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801704:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801708:	75 14                	jne    80171e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80170a:	83 ec 04             	sub    $0x4,%esp
  80170d:	68 94 33 80 00       	push   $0x803394
  801712:	6a 3a                	push   $0x3a
  801714:	68 88 33 80 00       	push   $0x803388
  801719:	e8 8d fe ff ff       	call   8015ab <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80171e:	ff 45 f0             	incl   -0x10(%ebp)
  801721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801724:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801727:	0f 8c 2f ff ff ff    	jl     80165c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80172d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801734:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80173b:	eb 26                	jmp    801763 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80173d:	a1 04 40 80 00       	mov    0x804004,%eax
  801742:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801748:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80174b:	89 d0                	mov    %edx,%eax
  80174d:	01 c0                	add    %eax,%eax
  80174f:	01 d0                	add    %edx,%eax
  801751:	c1 e0 03             	shl    $0x3,%eax
  801754:	01 c8                	add    %ecx,%eax
  801756:	8a 40 04             	mov    0x4(%eax),%al
  801759:	3c 01                	cmp    $0x1,%al
  80175b:	75 03                	jne    801760 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80175d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801760:	ff 45 e0             	incl   -0x20(%ebp)
  801763:	a1 04 40 80 00       	mov    0x804004,%eax
  801768:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80176e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801771:	39 c2                	cmp    %eax,%edx
  801773:	77 c8                	ja     80173d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801778:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80177b:	74 14                	je     801791 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80177d:	83 ec 04             	sub    $0x4,%esp
  801780:	68 e8 33 80 00       	push   $0x8033e8
  801785:	6a 44                	push   $0x44
  801787:	68 88 33 80 00       	push   $0x803388
  80178c:	e8 1a fe ff ff       	call   8015ab <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801791:	90                   	nop
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80179a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179d:	8b 00                	mov    (%eax),%eax
  80179f:	8d 48 01             	lea    0x1(%eax),%ecx
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	89 0a                	mov    %ecx,(%edx)
  8017a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8017aa:	88 d1                	mov    %dl,%cl
  8017ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017af:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8017b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b6:	8b 00                	mov    (%eax),%eax
  8017b8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017bd:	75 2c                	jne    8017eb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8017bf:	a0 08 40 80 00       	mov    0x804008,%al
  8017c4:	0f b6 c0             	movzbl %al,%eax
  8017c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ca:	8b 12                	mov    (%edx),%edx
  8017cc:	89 d1                	mov    %edx,%ecx
  8017ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d1:	83 c2 08             	add    $0x8,%edx
  8017d4:	83 ec 04             	sub    $0x4,%esp
  8017d7:	50                   	push   %eax
  8017d8:	51                   	push   %ecx
  8017d9:	52                   	push   %edx
  8017da:	e8 78 0f 00 00       	call   802757 <sys_cputs>
  8017df:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ee:	8b 40 04             	mov    0x4(%eax),%eax
  8017f1:	8d 50 01             	lea    0x1(%eax),%edx
  8017f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8017fa:	90                   	nop
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801806:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80180d:	00 00 00 
	b.cnt = 0;
  801810:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801817:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80181a:	ff 75 0c             	pushl  0xc(%ebp)
  80181d:	ff 75 08             	pushl  0x8(%ebp)
  801820:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801826:	50                   	push   %eax
  801827:	68 94 17 80 00       	push   $0x801794
  80182c:	e8 11 02 00 00       	call   801a42 <vprintfmt>
  801831:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801834:	a0 08 40 80 00       	mov    0x804008,%al
  801839:	0f b6 c0             	movzbl %al,%eax
  80183c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801842:	83 ec 04             	sub    $0x4,%esp
  801845:	50                   	push   %eax
  801846:	52                   	push   %edx
  801847:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80184d:	83 c0 08             	add    $0x8,%eax
  801850:	50                   	push   %eax
  801851:	e8 01 0f 00 00       	call   802757 <sys_cputs>
  801856:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801859:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
	return b.cnt;
  801860:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80186e:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
	va_start(ap, fmt);
  801875:	8d 45 0c             	lea    0xc(%ebp),%eax
  801878:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	83 ec 08             	sub    $0x8,%esp
  801881:	ff 75 f4             	pushl  -0xc(%ebp)
  801884:	50                   	push   %eax
  801885:	e8 73 ff ff ff       	call   8017fd <vcprintf>
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801890:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80189b:	e8 f9 0e 00 00       	call   802799 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8018a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	83 ec 08             	sub    $0x8,%esp
  8018ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8018af:	50                   	push   %eax
  8018b0:	e8 48 ff ff ff       	call   8017fd <vcprintf>
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8018bb:	e8 f3 0e 00 00       	call   8027b3 <sys_unlock_cons>
	return cnt;
  8018c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	53                   	push   %ebx
  8018c9:	83 ec 14             	sub    $0x14,%esp
  8018cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018d8:	8b 45 18             	mov    0x18(%ebp),%eax
  8018db:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018e3:	77 55                	ja     80193a <printnum+0x75>
  8018e5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018e8:	72 05                	jb     8018ef <printnum+0x2a>
  8018ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018ed:	77 4b                	ja     80193a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8018ef:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8018f2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8018f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8018f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fd:	52                   	push   %edx
  8018fe:	50                   	push   %eax
  8018ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801902:	ff 75 f0             	pushl  -0x10(%ebp)
  801905:	e8 4e 14 00 00       	call   802d58 <__udivdi3>
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	ff 75 20             	pushl  0x20(%ebp)
  801913:	53                   	push   %ebx
  801914:	ff 75 18             	pushl  0x18(%ebp)
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	ff 75 0c             	pushl  0xc(%ebp)
  80191c:	ff 75 08             	pushl  0x8(%ebp)
  80191f:	e8 a1 ff ff ff       	call   8018c5 <printnum>
  801924:	83 c4 20             	add    $0x20,%esp
  801927:	eb 1a                	jmp    801943 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801929:	83 ec 08             	sub    $0x8,%esp
  80192c:	ff 75 0c             	pushl  0xc(%ebp)
  80192f:	ff 75 20             	pushl  0x20(%ebp)
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	ff d0                	call   *%eax
  801937:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80193a:	ff 4d 1c             	decl   0x1c(%ebp)
  80193d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801941:	7f e6                	jg     801929 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801943:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801946:	bb 00 00 00 00       	mov    $0x0,%ebx
  80194b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801951:	53                   	push   %ebx
  801952:	51                   	push   %ecx
  801953:	52                   	push   %edx
  801954:	50                   	push   %eax
  801955:	e8 0e 15 00 00       	call   802e68 <__umoddi3>
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	05 54 36 80 00       	add    $0x803654,%eax
  801962:	8a 00                	mov    (%eax),%al
  801964:	0f be c0             	movsbl %al,%eax
  801967:	83 ec 08             	sub    $0x8,%esp
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	50                   	push   %eax
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	ff d0                	call   *%eax
  801973:	83 c4 10             	add    $0x10,%esp
}
  801976:	90                   	nop
  801977:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80197f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801983:	7e 1c                	jle    8019a1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	8b 00                	mov    (%eax),%eax
  80198a:	8d 50 08             	lea    0x8(%eax),%edx
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	89 10                	mov    %edx,(%eax)
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	8b 00                	mov    (%eax),%eax
  801997:	83 e8 08             	sub    $0x8,%eax
  80199a:	8b 50 04             	mov    0x4(%eax),%edx
  80199d:	8b 00                	mov    (%eax),%eax
  80199f:	eb 40                	jmp    8019e1 <getuint+0x65>
	else if (lflag)
  8019a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019a5:	74 1e                	je     8019c5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	8b 00                	mov    (%eax),%eax
  8019ac:	8d 50 04             	lea    0x4(%eax),%edx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	89 10                	mov    %edx,(%eax)
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	8b 00                	mov    (%eax),%eax
  8019b9:	83 e8 04             	sub    $0x4,%eax
  8019bc:	8b 00                	mov    (%eax),%eax
  8019be:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c3:	eb 1c                	jmp    8019e1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	8b 00                	mov    (%eax),%eax
  8019ca:	8d 50 04             	lea    0x4(%eax),%edx
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	89 10                	mov    %edx,(%eax)
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	8b 00                	mov    (%eax),%eax
  8019d7:	83 e8 04             	sub    $0x4,%eax
  8019da:	8b 00                	mov    (%eax),%eax
  8019dc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019e1:	5d                   	pop    %ebp
  8019e2:	c3                   	ret    

008019e3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019e6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019ea:	7e 1c                	jle    801a08 <getint+0x25>
		return va_arg(*ap, long long);
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	8d 50 08             	lea    0x8(%eax),%edx
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	89 10                	mov    %edx,(%eax)
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	8b 00                	mov    (%eax),%eax
  8019fe:	83 e8 08             	sub    $0x8,%eax
  801a01:	8b 50 04             	mov    0x4(%eax),%edx
  801a04:	8b 00                	mov    (%eax),%eax
  801a06:	eb 38                	jmp    801a40 <getint+0x5d>
	else if (lflag)
  801a08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a0c:	74 1a                	je     801a28 <getint+0x45>
		return va_arg(*ap, long);
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	8b 00                	mov    (%eax),%eax
  801a13:	8d 50 04             	lea    0x4(%eax),%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	89 10                	mov    %edx,(%eax)
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	8b 00                	mov    (%eax),%eax
  801a20:	83 e8 04             	sub    $0x4,%eax
  801a23:	8b 00                	mov    (%eax),%eax
  801a25:	99                   	cltd   
  801a26:	eb 18                	jmp    801a40 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	8b 00                	mov    (%eax),%eax
  801a2d:	8d 50 04             	lea    0x4(%eax),%edx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	89 10                	mov    %edx,(%eax)
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	8b 00                	mov    (%eax),%eax
  801a3a:	83 e8 04             	sub    $0x4,%eax
  801a3d:	8b 00                	mov    (%eax),%eax
  801a3f:	99                   	cltd   
}
  801a40:	5d                   	pop    %ebp
  801a41:	c3                   	ret    

00801a42 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	56                   	push   %esi
  801a46:	53                   	push   %ebx
  801a47:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a4a:	eb 17                	jmp    801a63 <vprintfmt+0x21>
			if (ch == '\0')
  801a4c:	85 db                	test   %ebx,%ebx
  801a4e:	0f 84 c1 03 00 00    	je     801e15 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801a54:	83 ec 08             	sub    $0x8,%esp
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	53                   	push   %ebx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	ff d0                	call   *%eax
  801a60:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a63:	8b 45 10             	mov    0x10(%ebp),%eax
  801a66:	8d 50 01             	lea    0x1(%eax),%edx
  801a69:	89 55 10             	mov    %edx,0x10(%ebp)
  801a6c:	8a 00                	mov    (%eax),%al
  801a6e:	0f b6 d8             	movzbl %al,%ebx
  801a71:	83 fb 25             	cmp    $0x25,%ebx
  801a74:	75 d6                	jne    801a4c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a76:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a7a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a81:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a88:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801a8f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a96:	8b 45 10             	mov    0x10(%ebp),%eax
  801a99:	8d 50 01             	lea    0x1(%eax),%edx
  801a9c:	89 55 10             	mov    %edx,0x10(%ebp)
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	0f b6 d8             	movzbl %al,%ebx
  801aa4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801aa7:	83 f8 5b             	cmp    $0x5b,%eax
  801aaa:	0f 87 3d 03 00 00    	ja     801ded <vprintfmt+0x3ab>
  801ab0:	8b 04 85 78 36 80 00 	mov    0x803678(,%eax,4),%eax
  801ab7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801ab9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801abd:	eb d7                	jmp    801a96 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801abf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801ac3:	eb d1                	jmp    801a96 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801ac5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801acc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801acf:	89 d0                	mov    %edx,%eax
  801ad1:	c1 e0 02             	shl    $0x2,%eax
  801ad4:	01 d0                	add    %edx,%eax
  801ad6:	01 c0                	add    %eax,%eax
  801ad8:	01 d8                	add    %ebx,%eax
  801ada:	83 e8 30             	sub    $0x30,%eax
  801add:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801ae0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae3:	8a 00                	mov    (%eax),%al
  801ae5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801ae8:	83 fb 2f             	cmp    $0x2f,%ebx
  801aeb:	7e 3e                	jle    801b2b <vprintfmt+0xe9>
  801aed:	83 fb 39             	cmp    $0x39,%ebx
  801af0:	7f 39                	jg     801b2b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801af2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801af5:	eb d5                	jmp    801acc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801af7:	8b 45 14             	mov    0x14(%ebp),%eax
  801afa:	83 c0 04             	add    $0x4,%eax
  801afd:	89 45 14             	mov    %eax,0x14(%ebp)
  801b00:	8b 45 14             	mov    0x14(%ebp),%eax
  801b03:	83 e8 04             	sub    $0x4,%eax
  801b06:	8b 00                	mov    (%eax),%eax
  801b08:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b0b:	eb 1f                	jmp    801b2c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b11:	79 83                	jns    801a96 <vprintfmt+0x54>
				width = 0;
  801b13:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b1a:	e9 77 ff ff ff       	jmp    801a96 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b1f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b26:	e9 6b ff ff ff       	jmp    801a96 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b2b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b30:	0f 89 60 ff ff ff    	jns    801a96 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b3c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b43:	e9 4e ff ff ff       	jmp    801a96 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b48:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b4b:	e9 46 ff ff ff       	jmp    801a96 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b50:	8b 45 14             	mov    0x14(%ebp),%eax
  801b53:	83 c0 04             	add    $0x4,%eax
  801b56:	89 45 14             	mov    %eax,0x14(%ebp)
  801b59:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5c:	83 e8 04             	sub    $0x4,%eax
  801b5f:	8b 00                	mov    (%eax),%eax
  801b61:	83 ec 08             	sub    $0x8,%esp
  801b64:	ff 75 0c             	pushl  0xc(%ebp)
  801b67:	50                   	push   %eax
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	ff d0                	call   *%eax
  801b6d:	83 c4 10             	add    $0x10,%esp
			break;
  801b70:	e9 9b 02 00 00       	jmp    801e10 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b75:	8b 45 14             	mov    0x14(%ebp),%eax
  801b78:	83 c0 04             	add    $0x4,%eax
  801b7b:	89 45 14             	mov    %eax,0x14(%ebp)
  801b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b81:	83 e8 04             	sub    $0x4,%eax
  801b84:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b86:	85 db                	test   %ebx,%ebx
  801b88:	79 02                	jns    801b8c <vprintfmt+0x14a>
				err = -err;
  801b8a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801b8c:	83 fb 64             	cmp    $0x64,%ebx
  801b8f:	7f 0b                	jg     801b9c <vprintfmt+0x15a>
  801b91:	8b 34 9d c0 34 80 00 	mov    0x8034c0(,%ebx,4),%esi
  801b98:	85 f6                	test   %esi,%esi
  801b9a:	75 19                	jne    801bb5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801b9c:	53                   	push   %ebx
  801b9d:	68 65 36 80 00       	push   $0x803665
  801ba2:	ff 75 0c             	pushl  0xc(%ebp)
  801ba5:	ff 75 08             	pushl  0x8(%ebp)
  801ba8:	e8 70 02 00 00       	call   801e1d <printfmt>
  801bad:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801bb0:	e9 5b 02 00 00       	jmp    801e10 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801bb5:	56                   	push   %esi
  801bb6:	68 6e 36 80 00       	push   $0x80366e
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	ff 75 08             	pushl  0x8(%ebp)
  801bc1:	e8 57 02 00 00       	call   801e1d <printfmt>
  801bc6:	83 c4 10             	add    $0x10,%esp
			break;
  801bc9:	e9 42 02 00 00       	jmp    801e10 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801bce:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd1:	83 c0 04             	add    $0x4,%eax
  801bd4:	89 45 14             	mov    %eax,0x14(%ebp)
  801bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bda:	83 e8 04             	sub    $0x4,%eax
  801bdd:	8b 30                	mov    (%eax),%esi
  801bdf:	85 f6                	test   %esi,%esi
  801be1:	75 05                	jne    801be8 <vprintfmt+0x1a6>
				p = "(null)";
  801be3:	be 71 36 80 00       	mov    $0x803671,%esi
			if (width > 0 && padc != '-')
  801be8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bec:	7e 6d                	jle    801c5b <vprintfmt+0x219>
  801bee:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801bf2:	74 67                	je     801c5b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf7:	83 ec 08             	sub    $0x8,%esp
  801bfa:	50                   	push   %eax
  801bfb:	56                   	push   %esi
  801bfc:	e8 1e 03 00 00       	call   801f1f <strnlen>
  801c01:	83 c4 10             	add    $0x10,%esp
  801c04:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c07:	eb 16                	jmp    801c1f <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c09:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c0d:	83 ec 08             	sub    $0x8,%esp
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	50                   	push   %eax
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	ff d0                	call   *%eax
  801c19:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c1c:	ff 4d e4             	decl   -0x1c(%ebp)
  801c1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c23:	7f e4                	jg     801c09 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c25:	eb 34                	jmp    801c5b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c27:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c2b:	74 1c                	je     801c49 <vprintfmt+0x207>
  801c2d:	83 fb 1f             	cmp    $0x1f,%ebx
  801c30:	7e 05                	jle    801c37 <vprintfmt+0x1f5>
  801c32:	83 fb 7e             	cmp    $0x7e,%ebx
  801c35:	7e 12                	jle    801c49 <vprintfmt+0x207>
					putch('?', putdat);
  801c37:	83 ec 08             	sub    $0x8,%esp
  801c3a:	ff 75 0c             	pushl  0xc(%ebp)
  801c3d:	6a 3f                	push   $0x3f
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	ff d0                	call   *%eax
  801c44:	83 c4 10             	add    $0x10,%esp
  801c47:	eb 0f                	jmp    801c58 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c49:	83 ec 08             	sub    $0x8,%esp
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	53                   	push   %ebx
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	ff d0                	call   *%eax
  801c55:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c58:	ff 4d e4             	decl   -0x1c(%ebp)
  801c5b:	89 f0                	mov    %esi,%eax
  801c5d:	8d 70 01             	lea    0x1(%eax),%esi
  801c60:	8a 00                	mov    (%eax),%al
  801c62:	0f be d8             	movsbl %al,%ebx
  801c65:	85 db                	test   %ebx,%ebx
  801c67:	74 24                	je     801c8d <vprintfmt+0x24b>
  801c69:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c6d:	78 b8                	js     801c27 <vprintfmt+0x1e5>
  801c6f:	ff 4d e0             	decl   -0x20(%ebp)
  801c72:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c76:	79 af                	jns    801c27 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c78:	eb 13                	jmp    801c8d <vprintfmt+0x24b>
				putch(' ', putdat);
  801c7a:	83 ec 08             	sub    $0x8,%esp
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	6a 20                	push   $0x20
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	ff d0                	call   *%eax
  801c87:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c8a:	ff 4d e4             	decl   -0x1c(%ebp)
  801c8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c91:	7f e7                	jg     801c7a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801c93:	e9 78 01 00 00       	jmp    801e10 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801c98:	83 ec 08             	sub    $0x8,%esp
  801c9b:	ff 75 e8             	pushl  -0x18(%ebp)
  801c9e:	8d 45 14             	lea    0x14(%ebp),%eax
  801ca1:	50                   	push   %eax
  801ca2:	e8 3c fd ff ff       	call   8019e3 <getint>
  801ca7:	83 c4 10             	add    $0x10,%esp
  801caa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cb6:	85 d2                	test   %edx,%edx
  801cb8:	79 23                	jns    801cdd <vprintfmt+0x29b>
				putch('-', putdat);
  801cba:	83 ec 08             	sub    $0x8,%esp
  801cbd:	ff 75 0c             	pushl  0xc(%ebp)
  801cc0:	6a 2d                	push   $0x2d
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	ff d0                	call   *%eax
  801cc7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd0:	f7 d8                	neg    %eax
  801cd2:	83 d2 00             	adc    $0x0,%edx
  801cd5:	f7 da                	neg    %edx
  801cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801cdd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ce4:	e9 bc 00 00 00       	jmp    801da5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801ce9:	83 ec 08             	sub    $0x8,%esp
  801cec:	ff 75 e8             	pushl  -0x18(%ebp)
  801cef:	8d 45 14             	lea    0x14(%ebp),%eax
  801cf2:	50                   	push   %eax
  801cf3:	e8 84 fc ff ff       	call   80197c <getuint>
  801cf8:	83 c4 10             	add    $0x10,%esp
  801cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d01:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d08:	e9 98 00 00 00       	jmp    801da5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d0d:	83 ec 08             	sub    $0x8,%esp
  801d10:	ff 75 0c             	pushl  0xc(%ebp)
  801d13:	6a 58                	push   $0x58
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	ff d0                	call   *%eax
  801d1a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d1d:	83 ec 08             	sub    $0x8,%esp
  801d20:	ff 75 0c             	pushl  0xc(%ebp)
  801d23:	6a 58                	push   $0x58
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	ff d0                	call   *%eax
  801d2a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d2d:	83 ec 08             	sub    $0x8,%esp
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	6a 58                	push   $0x58
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	ff d0                	call   *%eax
  801d3a:	83 c4 10             	add    $0x10,%esp
			break;
  801d3d:	e9 ce 00 00 00       	jmp    801e10 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801d42:	83 ec 08             	sub    $0x8,%esp
  801d45:	ff 75 0c             	pushl  0xc(%ebp)
  801d48:	6a 30                	push   $0x30
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	ff d0                	call   *%eax
  801d4f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d52:	83 ec 08             	sub    $0x8,%esp
  801d55:	ff 75 0c             	pushl  0xc(%ebp)
  801d58:	6a 78                	push   $0x78
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	ff d0                	call   *%eax
  801d5f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d62:	8b 45 14             	mov    0x14(%ebp),%eax
  801d65:	83 c0 04             	add    $0x4,%eax
  801d68:	89 45 14             	mov    %eax,0x14(%ebp)
  801d6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6e:	83 e8 04             	sub    $0x4,%eax
  801d71:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d7d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d84:	eb 1f                	jmp    801da5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d86:	83 ec 08             	sub    $0x8,%esp
  801d89:	ff 75 e8             	pushl  -0x18(%ebp)
  801d8c:	8d 45 14             	lea    0x14(%ebp),%eax
  801d8f:	50                   	push   %eax
  801d90:	e8 e7 fb ff ff       	call   80197c <getuint>
  801d95:	83 c4 10             	add    $0x10,%esp
  801d98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801d9e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801da5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dac:	83 ec 04             	sub    $0x4,%esp
  801daf:	52                   	push   %edx
  801db0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801db3:	50                   	push   %eax
  801db4:	ff 75 f4             	pushl  -0xc(%ebp)
  801db7:	ff 75 f0             	pushl  -0x10(%ebp)
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	ff 75 08             	pushl  0x8(%ebp)
  801dc0:	e8 00 fb ff ff       	call   8018c5 <printnum>
  801dc5:	83 c4 20             	add    $0x20,%esp
			break;
  801dc8:	eb 46                	jmp    801e10 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801dca:	83 ec 08             	sub    $0x8,%esp
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	53                   	push   %ebx
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	ff d0                	call   *%eax
  801dd6:	83 c4 10             	add    $0x10,%esp
			break;
  801dd9:	eb 35                	jmp    801e10 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801ddb:	c6 05 08 40 80 00 00 	movb   $0x0,0x804008
			break;
  801de2:	eb 2c                	jmp    801e10 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801de4:	c6 05 08 40 80 00 01 	movb   $0x1,0x804008
			break;
  801deb:	eb 23                	jmp    801e10 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ded:	83 ec 08             	sub    $0x8,%esp
  801df0:	ff 75 0c             	pushl  0xc(%ebp)
  801df3:	6a 25                	push   $0x25
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	ff d0                	call   *%eax
  801dfa:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801dfd:	ff 4d 10             	decl   0x10(%ebp)
  801e00:	eb 03                	jmp    801e05 <vprintfmt+0x3c3>
  801e02:	ff 4d 10             	decl   0x10(%ebp)
  801e05:	8b 45 10             	mov    0x10(%ebp),%eax
  801e08:	48                   	dec    %eax
  801e09:	8a 00                	mov    (%eax),%al
  801e0b:	3c 25                	cmp    $0x25,%al
  801e0d:	75 f3                	jne    801e02 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801e0f:	90                   	nop
		}
	}
  801e10:	e9 35 fc ff ff       	jmp    801a4a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e15:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e19:	5b                   	pop    %ebx
  801e1a:	5e                   	pop    %esi
  801e1b:	5d                   	pop    %ebp
  801e1c:	c3                   	ret    

00801e1d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e23:	8d 45 10             	lea    0x10(%ebp),%eax
  801e26:	83 c0 04             	add    $0x4,%eax
  801e29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e32:	50                   	push   %eax
  801e33:	ff 75 0c             	pushl  0xc(%ebp)
  801e36:	ff 75 08             	pushl  0x8(%ebp)
  801e39:	e8 04 fc ff ff       	call   801a42 <vprintfmt>
  801e3e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e41:	90                   	nop
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4a:	8b 40 08             	mov    0x8(%eax),%eax
  801e4d:	8d 50 01             	lea    0x1(%eax),%edx
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e59:	8b 10                	mov    (%eax),%edx
  801e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5e:	8b 40 04             	mov    0x4(%eax),%eax
  801e61:	39 c2                	cmp    %eax,%edx
  801e63:	73 12                	jae    801e77 <sprintputch+0x33>
		*b->buf++ = ch;
  801e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e68:	8b 00                	mov    (%eax),%eax
  801e6a:	8d 48 01             	lea    0x1(%eax),%ecx
  801e6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e70:	89 0a                	mov    %ecx,(%edx)
  801e72:	8b 55 08             	mov    0x8(%ebp),%edx
  801e75:	88 10                	mov    %dl,(%eax)
}
  801e77:	90                   	nop
  801e78:	5d                   	pop    %ebp
  801e79:	c3                   	ret    

00801e7a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e89:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8f:	01 d0                	add    %edx,%eax
  801e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e9f:	74 06                	je     801ea7 <vsnprintf+0x2d>
  801ea1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ea5:	7f 07                	jg     801eae <vsnprintf+0x34>
		return -E_INVAL;
  801ea7:	b8 03 00 00 00       	mov    $0x3,%eax
  801eac:	eb 20                	jmp    801ece <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801eae:	ff 75 14             	pushl  0x14(%ebp)
  801eb1:	ff 75 10             	pushl  0x10(%ebp)
  801eb4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801eb7:	50                   	push   %eax
  801eb8:	68 44 1e 80 00       	push   $0x801e44
  801ebd:	e8 80 fb ff ff       	call   801a42 <vprintfmt>
  801ec2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801ed6:	8d 45 10             	lea    0x10(%ebp),%eax
  801ed9:	83 c0 04             	add    $0x4,%eax
  801edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801edf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee5:	50                   	push   %eax
  801ee6:	ff 75 0c             	pushl  0xc(%ebp)
  801ee9:	ff 75 08             	pushl  0x8(%ebp)
  801eec:	e8 89 ff ff ff       	call   801e7a <vsnprintf>
  801ef1:	83 c4 10             	add    $0x10,%esp
  801ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f09:	eb 06                	jmp    801f11 <strlen+0x15>
		n++;
  801f0b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f0e:	ff 45 08             	incl   0x8(%ebp)
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8a 00                	mov    (%eax),%al
  801f16:	84 c0                	test   %al,%al
  801f18:	75 f1                	jne    801f0b <strlen+0xf>
		n++;
	return n;
  801f1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f2c:	eb 09                	jmp    801f37 <strnlen+0x18>
		n++;
  801f2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f31:	ff 45 08             	incl   0x8(%ebp)
  801f34:	ff 4d 0c             	decl   0xc(%ebp)
  801f37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f3b:	74 09                	je     801f46 <strnlen+0x27>
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	8a 00                	mov    (%eax),%al
  801f42:	84 c0                	test   %al,%al
  801f44:	75 e8                	jne    801f2e <strnlen+0xf>
		n++;
	return n;
  801f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f57:	90                   	nop
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	8d 50 01             	lea    0x1(%eax),%edx
  801f5e:	89 55 08             	mov    %edx,0x8(%ebp)
  801f61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f64:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f67:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f6a:	8a 12                	mov    (%edx),%dl
  801f6c:	88 10                	mov    %dl,(%eax)
  801f6e:	8a 00                	mov    (%eax),%al
  801f70:	84 c0                	test   %al,%al
  801f72:	75 e4                	jne    801f58 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f82:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f8c:	eb 1f                	jmp    801fad <strncpy+0x34>
		*dst++ = *src;
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	8d 50 01             	lea    0x1(%eax),%edx
  801f94:	89 55 08             	mov    %edx,0x8(%ebp)
  801f97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9a:	8a 12                	mov    (%edx),%dl
  801f9c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa1:	8a 00                	mov    (%eax),%al
  801fa3:	84 c0                	test   %al,%al
  801fa5:	74 03                	je     801faa <strncpy+0x31>
			src++;
  801fa7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801faa:	ff 45 fc             	incl   -0x4(%ebp)
  801fad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb0:	3b 45 10             	cmp    0x10(%ebp),%eax
  801fb3:	72 d9                	jb     801f8e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801fc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fca:	74 30                	je     801ffc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801fcc:	eb 16                	jmp    801fe4 <strlcpy+0x2a>
			*dst++ = *src++;
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	8d 50 01             	lea    0x1(%eax),%edx
  801fd4:	89 55 08             	mov    %edx,0x8(%ebp)
  801fd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fda:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fdd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fe0:	8a 12                	mov    (%edx),%dl
  801fe2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801fe4:	ff 4d 10             	decl   0x10(%ebp)
  801fe7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801feb:	74 09                	je     801ff6 <strlcpy+0x3c>
  801fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff0:	8a 00                	mov    (%eax),%al
  801ff2:	84 c0                	test   %al,%al
  801ff4:	75 d8                	jne    801fce <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ffc:	8b 55 08             	mov    0x8(%ebp),%edx
  801fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802002:	29 c2                	sub    %eax,%edx
  802004:	89 d0                	mov    %edx,%eax
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80200b:	eb 06                	jmp    802013 <strcmp+0xb>
		p++, q++;
  80200d:	ff 45 08             	incl   0x8(%ebp)
  802010:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	8a 00                	mov    (%eax),%al
  802018:	84 c0                	test   %al,%al
  80201a:	74 0e                	je     80202a <strcmp+0x22>
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	8a 10                	mov    (%eax),%dl
  802021:	8b 45 0c             	mov    0xc(%ebp),%eax
  802024:	8a 00                	mov    (%eax),%al
  802026:	38 c2                	cmp    %al,%dl
  802028:	74 e3                	je     80200d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	8a 00                	mov    (%eax),%al
  80202f:	0f b6 d0             	movzbl %al,%edx
  802032:	8b 45 0c             	mov    0xc(%ebp),%eax
  802035:	8a 00                	mov    (%eax),%al
  802037:	0f b6 c0             	movzbl %al,%eax
  80203a:	29 c2                	sub    %eax,%edx
  80203c:	89 d0                	mov    %edx,%eax
}
  80203e:	5d                   	pop    %ebp
  80203f:	c3                   	ret    

00802040 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802043:	eb 09                	jmp    80204e <strncmp+0xe>
		n--, p++, q++;
  802045:	ff 4d 10             	decl   0x10(%ebp)
  802048:	ff 45 08             	incl   0x8(%ebp)
  80204b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80204e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802052:	74 17                	je     80206b <strncmp+0x2b>
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	8a 00                	mov    (%eax),%al
  802059:	84 c0                	test   %al,%al
  80205b:	74 0e                	je     80206b <strncmp+0x2b>
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	8a 10                	mov    (%eax),%dl
  802062:	8b 45 0c             	mov    0xc(%ebp),%eax
  802065:	8a 00                	mov    (%eax),%al
  802067:	38 c2                	cmp    %al,%dl
  802069:	74 da                	je     802045 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80206b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80206f:	75 07                	jne    802078 <strncmp+0x38>
		return 0;
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
  802076:	eb 14                	jmp    80208c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	8a 00                	mov    (%eax),%al
  80207d:	0f b6 d0             	movzbl %al,%edx
  802080:	8b 45 0c             	mov    0xc(%ebp),%eax
  802083:	8a 00                	mov    (%eax),%al
  802085:	0f b6 c0             	movzbl %al,%eax
  802088:	29 c2                	sub    %eax,%edx
  80208a:	89 d0                	mov    %edx,%eax
}
  80208c:	5d                   	pop    %ebp
  80208d:	c3                   	ret    

0080208e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 04             	sub    $0x4,%esp
  802094:	8b 45 0c             	mov    0xc(%ebp),%eax
  802097:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80209a:	eb 12                	jmp    8020ae <strchr+0x20>
		if (*s == c)
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	8a 00                	mov    (%eax),%al
  8020a1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020a4:	75 05                	jne    8020ab <strchr+0x1d>
			return (char *) s;
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	eb 11                	jmp    8020bc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020ab:	ff 45 08             	incl   0x8(%ebp)
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	8a 00                	mov    (%eax),%al
  8020b3:	84 c0                	test   %al,%al
  8020b5:	75 e5                	jne    80209c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	83 ec 04             	sub    $0x4,%esp
  8020c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020ca:	eb 0d                	jmp    8020d9 <strfind+0x1b>
		if (*s == c)
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	8a 00                	mov    (%eax),%al
  8020d1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020d4:	74 0e                	je     8020e4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8020d6:	ff 45 08             	incl   0x8(%ebp)
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	8a 00                	mov    (%eax),%al
  8020de:	84 c0                	test   %al,%al
  8020e0:	75 ea                	jne    8020cc <strfind+0xe>
  8020e2:	eb 01                	jmp    8020e5 <strfind+0x27>
		if (*s == c)
			break;
  8020e4:	90                   	nop
	return (char *) s;
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8020f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8020fc:	eb 0e                	jmp    80210c <memset+0x22>
		*p++ = c;
  8020fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802101:	8d 50 01             	lea    0x1(%eax),%edx
  802104:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802107:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80210c:	ff 4d f8             	decl   -0x8(%ebp)
  80210f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802113:	79 e9                	jns    8020fe <memset+0x14>
		*p++ = c;

	return v;
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802120:	8b 45 0c             	mov    0xc(%ebp),%eax
  802123:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80212c:	eb 16                	jmp    802144 <memcpy+0x2a>
		*d++ = *s++;
  80212e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802131:	8d 50 01             	lea    0x1(%eax),%edx
  802134:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802137:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80213a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80213d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802140:	8a 12                	mov    (%edx),%dl
  802142:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  802144:	8b 45 10             	mov    0x10(%ebp),%eax
  802147:	8d 50 ff             	lea    -0x1(%eax),%edx
  80214a:	89 55 10             	mov    %edx,0x10(%ebp)
  80214d:	85 c0                	test   %eax,%eax
  80214f:	75 dd                	jne    80212e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80215c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802168:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80216e:	73 50                	jae    8021c0 <memmove+0x6a>
  802170:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802173:	8b 45 10             	mov    0x10(%ebp),%eax
  802176:	01 d0                	add    %edx,%eax
  802178:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80217b:	76 43                	jbe    8021c0 <memmove+0x6a>
		s += n;
  80217d:	8b 45 10             	mov    0x10(%ebp),%eax
  802180:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802183:	8b 45 10             	mov    0x10(%ebp),%eax
  802186:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802189:	eb 10                	jmp    80219b <memmove+0x45>
			*--d = *--s;
  80218b:	ff 4d f8             	decl   -0x8(%ebp)
  80218e:	ff 4d fc             	decl   -0x4(%ebp)
  802191:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802194:	8a 10                	mov    (%eax),%dl
  802196:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802199:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80219b:	8b 45 10             	mov    0x10(%ebp),%eax
  80219e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021a1:	89 55 10             	mov    %edx,0x10(%ebp)
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	75 e3                	jne    80218b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8021a8:	eb 23                	jmp    8021cd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8021aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021ad:	8d 50 01             	lea    0x1(%eax),%edx
  8021b0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021b6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021b9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8021bc:	8a 12                	mov    (%edx),%dl
  8021be:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8021c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021c6:	89 55 10             	mov    %edx,0x10(%ebp)
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	75 dd                	jne    8021aa <memmove+0x54>
			*d++ = *s++;

	return dst;
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8021de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8021e4:	eb 2a                	jmp    802210 <memcmp+0x3e>
		if (*s1 != *s2)
  8021e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e9:	8a 10                	mov    (%eax),%dl
  8021eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021ee:	8a 00                	mov    (%eax),%al
  8021f0:	38 c2                	cmp    %al,%dl
  8021f2:	74 16                	je     80220a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8021f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f7:	8a 00                	mov    (%eax),%al
  8021f9:	0f b6 d0             	movzbl %al,%edx
  8021fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021ff:	8a 00                	mov    (%eax),%al
  802201:	0f b6 c0             	movzbl %al,%eax
  802204:	29 c2                	sub    %eax,%edx
  802206:	89 d0                	mov    %edx,%eax
  802208:	eb 18                	jmp    802222 <memcmp+0x50>
		s1++, s2++;
  80220a:	ff 45 fc             	incl   -0x4(%ebp)
  80220d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802210:	8b 45 10             	mov    0x10(%ebp),%eax
  802213:	8d 50 ff             	lea    -0x1(%eax),%edx
  802216:	89 55 10             	mov    %edx,0x10(%ebp)
  802219:	85 c0                	test   %eax,%eax
  80221b:	75 c9                	jne    8021e6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80221d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80222a:	8b 55 08             	mov    0x8(%ebp),%edx
  80222d:	8b 45 10             	mov    0x10(%ebp),%eax
  802230:	01 d0                	add    %edx,%eax
  802232:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802235:	eb 15                	jmp    80224c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	8a 00                	mov    (%eax),%al
  80223c:	0f b6 d0             	movzbl %al,%edx
  80223f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802242:	0f b6 c0             	movzbl %al,%eax
  802245:	39 c2                	cmp    %eax,%edx
  802247:	74 0d                	je     802256 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802249:	ff 45 08             	incl   0x8(%ebp)
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802252:	72 e3                	jb     802237 <memfind+0x13>
  802254:	eb 01                	jmp    802257 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802256:	90                   	nop
	return (void *) s;
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802262:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802269:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802270:	eb 03                	jmp    802275 <strtol+0x19>
		s++;
  802272:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	8a 00                	mov    (%eax),%al
  80227a:	3c 20                	cmp    $0x20,%al
  80227c:	74 f4                	je     802272 <strtol+0x16>
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	8a 00                	mov    (%eax),%al
  802283:	3c 09                	cmp    $0x9,%al
  802285:	74 eb                	je     802272 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	8a 00                	mov    (%eax),%al
  80228c:	3c 2b                	cmp    $0x2b,%al
  80228e:	75 05                	jne    802295 <strtol+0x39>
		s++;
  802290:	ff 45 08             	incl   0x8(%ebp)
  802293:	eb 13                	jmp    8022a8 <strtol+0x4c>
	else if (*s == '-')
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	8a 00                	mov    (%eax),%al
  80229a:	3c 2d                	cmp    $0x2d,%al
  80229c:	75 0a                	jne    8022a8 <strtol+0x4c>
		s++, neg = 1;
  80229e:	ff 45 08             	incl   0x8(%ebp)
  8022a1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8022a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022ac:	74 06                	je     8022b4 <strtol+0x58>
  8022ae:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8022b2:	75 20                	jne    8022d4 <strtol+0x78>
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	8a 00                	mov    (%eax),%al
  8022b9:	3c 30                	cmp    $0x30,%al
  8022bb:	75 17                	jne    8022d4 <strtol+0x78>
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	40                   	inc    %eax
  8022c1:	8a 00                	mov    (%eax),%al
  8022c3:	3c 78                	cmp    $0x78,%al
  8022c5:	75 0d                	jne    8022d4 <strtol+0x78>
		s += 2, base = 16;
  8022c7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8022cb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8022d2:	eb 28                	jmp    8022fc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8022d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022d8:	75 15                	jne    8022ef <strtol+0x93>
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	8a 00                	mov    (%eax),%al
  8022df:	3c 30                	cmp    $0x30,%al
  8022e1:	75 0c                	jne    8022ef <strtol+0x93>
		s++, base = 8;
  8022e3:	ff 45 08             	incl   0x8(%ebp)
  8022e6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8022ed:	eb 0d                	jmp    8022fc <strtol+0xa0>
	else if (base == 0)
  8022ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022f3:	75 07                	jne    8022fc <strtol+0xa0>
		base = 10;
  8022f5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	8a 00                	mov    (%eax),%al
  802301:	3c 2f                	cmp    $0x2f,%al
  802303:	7e 19                	jle    80231e <strtol+0xc2>
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	8a 00                	mov    (%eax),%al
  80230a:	3c 39                	cmp    $0x39,%al
  80230c:	7f 10                	jg     80231e <strtol+0xc2>
			dig = *s - '0';
  80230e:	8b 45 08             	mov    0x8(%ebp),%eax
  802311:	8a 00                	mov    (%eax),%al
  802313:	0f be c0             	movsbl %al,%eax
  802316:	83 e8 30             	sub    $0x30,%eax
  802319:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231c:	eb 42                	jmp    802360 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	8a 00                	mov    (%eax),%al
  802323:	3c 60                	cmp    $0x60,%al
  802325:	7e 19                	jle    802340 <strtol+0xe4>
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	8a 00                	mov    (%eax),%al
  80232c:	3c 7a                	cmp    $0x7a,%al
  80232e:	7f 10                	jg     802340 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	8a 00                	mov    (%eax),%al
  802335:	0f be c0             	movsbl %al,%eax
  802338:	83 e8 57             	sub    $0x57,%eax
  80233b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233e:	eb 20                	jmp    802360 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	8a 00                	mov    (%eax),%al
  802345:	3c 40                	cmp    $0x40,%al
  802347:	7e 39                	jle    802382 <strtol+0x126>
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	8a 00                	mov    (%eax),%al
  80234e:	3c 5a                	cmp    $0x5a,%al
  802350:	7f 30                	jg     802382 <strtol+0x126>
			dig = *s - 'A' + 10;
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	8a 00                	mov    (%eax),%al
  802357:	0f be c0             	movsbl %al,%eax
  80235a:	83 e8 37             	sub    $0x37,%eax
  80235d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	3b 45 10             	cmp    0x10(%ebp),%eax
  802366:	7d 19                	jge    802381 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802368:	ff 45 08             	incl   0x8(%ebp)
  80236b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80236e:	0f af 45 10          	imul   0x10(%ebp),%eax
  802372:	89 c2                	mov    %eax,%edx
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	01 d0                	add    %edx,%eax
  802379:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80237c:	e9 7b ff ff ff       	jmp    8022fc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802381:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802382:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802386:	74 08                	je     802390 <strtol+0x134>
		*endptr = (char *) s;
  802388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238b:	8b 55 08             	mov    0x8(%ebp),%edx
  80238e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802390:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802394:	74 07                	je     80239d <strtol+0x141>
  802396:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802399:	f7 d8                	neg    %eax
  80239b:	eb 03                	jmp    8023a0 <strtol+0x144>
  80239d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <ltostr>:

void
ltostr(long value, char *str)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8023a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8023af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8023b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ba:	79 13                	jns    8023cf <ltostr+0x2d>
	{
		neg = 1;
  8023bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8023c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8023c9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8023cc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8023d7:	99                   	cltd   
  8023d8:	f7 f9                	idiv   %ecx
  8023da:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8023dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023e0:	8d 50 01             	lea    0x1(%eax),%edx
  8023e3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023e6:	89 c2                	mov    %eax,%edx
  8023e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023eb:	01 d0                	add    %edx,%eax
  8023ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023f0:	83 c2 30             	add    $0x30,%edx
  8023f3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8023f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023f8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023fd:	f7 e9                	imul   %ecx
  8023ff:	c1 fa 02             	sar    $0x2,%edx
  802402:	89 c8                	mov    %ecx,%eax
  802404:	c1 f8 1f             	sar    $0x1f,%eax
  802407:	29 c2                	sub    %eax,%edx
  802409:	89 d0                	mov    %edx,%eax
  80240b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80240e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802412:	75 bb                	jne    8023cf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802414:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80241b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80241e:	48                   	dec    %eax
  80241f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802422:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802426:	74 3d                	je     802465 <ltostr+0xc3>
		start = 1 ;
  802428:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80242f:	eb 34                	jmp    802465 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802431:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802434:	8b 45 0c             	mov    0xc(%ebp),%eax
  802437:	01 d0                	add    %edx,%eax
  802439:	8a 00                	mov    (%eax),%al
  80243b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80243e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802441:	8b 45 0c             	mov    0xc(%ebp),%eax
  802444:	01 c2                	add    %eax,%edx
  802446:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244c:	01 c8                	add    %ecx,%eax
  80244e:	8a 00                	mov    (%eax),%al
  802450:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802455:	8b 45 0c             	mov    0xc(%ebp),%eax
  802458:	01 c2                	add    %eax,%edx
  80245a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80245d:	88 02                	mov    %al,(%edx)
		start++ ;
  80245f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802462:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80246b:	7c c4                	jl     802431 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80246d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802470:	8b 45 0c             	mov    0xc(%ebp),%eax
  802473:	01 d0                	add    %edx,%eax
  802475:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802478:	90                   	nop
  802479:	c9                   	leave  
  80247a:	c3                   	ret    

0080247b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
  80247e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802481:	ff 75 08             	pushl  0x8(%ebp)
  802484:	e8 73 fa ff ff       	call   801efc <strlen>
  802489:	83 c4 04             	add    $0x4,%esp
  80248c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80248f:	ff 75 0c             	pushl  0xc(%ebp)
  802492:	e8 65 fa ff ff       	call   801efc <strlen>
  802497:	83 c4 04             	add    $0x4,%esp
  80249a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80249d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8024a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024ab:	eb 17                	jmp    8024c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8024ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b3:	01 c2                	add    %eax,%edx
  8024b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	01 c8                	add    %ecx,%eax
  8024bd:	8a 00                	mov    (%eax),%al
  8024bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8024c1:	ff 45 fc             	incl   -0x4(%ebp)
  8024c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024ca:	7c e1                	jl     8024ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8024cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8024d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8024da:	eb 1f                	jmp    8024fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8024dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024df:	8d 50 01             	lea    0x1(%eax),%edx
  8024e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8024e5:	89 c2                	mov    %eax,%edx
  8024e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ea:	01 c2                	add    %eax,%edx
  8024ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8024ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f2:	01 c8                	add    %ecx,%eax
  8024f4:	8a 00                	mov    (%eax),%al
  8024f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8024f8:	ff 45 f8             	incl   -0x8(%ebp)
  8024fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802501:	7c d9                	jl     8024dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802503:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802506:	8b 45 10             	mov    0x10(%ebp),%eax
  802509:	01 d0                	add    %edx,%eax
  80250b:	c6 00 00             	movb   $0x0,(%eax)
}
  80250e:	90                   	nop
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802514:	8b 45 14             	mov    0x14(%ebp),%eax
  802517:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80251d:	8b 45 14             	mov    0x14(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802529:	8b 45 10             	mov    0x10(%ebp),%eax
  80252c:	01 d0                	add    %edx,%eax
  80252e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802534:	eb 0c                	jmp    802542 <strsplit+0x31>
			*string++ = 0;
  802536:	8b 45 08             	mov    0x8(%ebp),%eax
  802539:	8d 50 01             	lea    0x1(%eax),%edx
  80253c:	89 55 08             	mov    %edx,0x8(%ebp)
  80253f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	8a 00                	mov    (%eax),%al
  802547:	84 c0                	test   %al,%al
  802549:	74 18                	je     802563 <strsplit+0x52>
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	8a 00                	mov    (%eax),%al
  802550:	0f be c0             	movsbl %al,%eax
  802553:	50                   	push   %eax
  802554:	ff 75 0c             	pushl  0xc(%ebp)
  802557:	e8 32 fb ff ff       	call   80208e <strchr>
  80255c:	83 c4 08             	add    $0x8,%esp
  80255f:	85 c0                	test   %eax,%eax
  802561:	75 d3                	jne    802536 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	8a 00                	mov    (%eax),%al
  802568:	84 c0                	test   %al,%al
  80256a:	74 5a                	je     8025c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80256c:	8b 45 14             	mov    0x14(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	83 f8 0f             	cmp    $0xf,%eax
  802574:	75 07                	jne    80257d <strsplit+0x6c>
		{
			return 0;
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
  80257b:	eb 66                	jmp    8025e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80257d:	8b 45 14             	mov    0x14(%ebp),%eax
  802580:	8b 00                	mov    (%eax),%eax
  802582:	8d 48 01             	lea    0x1(%eax),%ecx
  802585:	8b 55 14             	mov    0x14(%ebp),%edx
  802588:	89 0a                	mov    %ecx,(%edx)
  80258a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802591:	8b 45 10             	mov    0x10(%ebp),%eax
  802594:	01 c2                	add    %eax,%edx
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80259b:	eb 03                	jmp    8025a0 <strsplit+0x8f>
			string++;
  80259d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	8a 00                	mov    (%eax),%al
  8025a5:	84 c0                	test   %al,%al
  8025a7:	74 8b                	je     802534 <strsplit+0x23>
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	8a 00                	mov    (%eax),%al
  8025ae:	0f be c0             	movsbl %al,%eax
  8025b1:	50                   	push   %eax
  8025b2:	ff 75 0c             	pushl  0xc(%ebp)
  8025b5:	e8 d4 fa ff ff       	call   80208e <strchr>
  8025ba:	83 c4 08             	add    $0x8,%esp
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	74 dc                	je     80259d <strsplit+0x8c>
			string++;
	}
  8025c1:	e9 6e ff ff ff       	jmp    802534 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8025c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8025c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8025ca:	8b 00                	mov    (%eax),%eax
  8025cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8025d6:	01 d0                	add    %edx,%eax
  8025d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8025de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025e3:	c9                   	leave  
  8025e4:	c3                   	ret    

008025e5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8025e5:	55                   	push   %ebp
  8025e6:	89 e5                	mov    %esp,%ebp
  8025e8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8025eb:	83 ec 04             	sub    $0x4,%esp
  8025ee:	68 e8 37 80 00       	push   $0x8037e8
  8025f3:	68 3f 01 00 00       	push   $0x13f
  8025f8:	68 0a 38 80 00       	push   $0x80380a
  8025fd:	e8 a9 ef ff ff       	call   8015ab <_panic>

00802602 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  802608:	83 ec 0c             	sub    $0xc,%esp
  80260b:	ff 75 08             	pushl  0x8(%ebp)
  80260e:	e8 ef 06 00 00       	call   802d02 <sys_sbrk>
  802613:	83 c4 10             	add    $0x10,%esp
}
  802616:	c9                   	leave  
  802617:	c3                   	ret    

00802618 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802618:	55                   	push   %ebp
  802619:	89 e5                	mov    %esp,%ebp
  80261b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80261e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802622:	75 07                	jne    80262b <malloc+0x13>
  802624:	b8 00 00 00 00       	mov    $0x0,%eax
  802629:	eb 14                	jmp    80263f <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80262b:	83 ec 04             	sub    $0x4,%esp
  80262e:	68 18 38 80 00       	push   $0x803818
  802633:	6a 1b                	push   $0x1b
  802635:	68 3d 38 80 00       	push   $0x80383d
  80263a:	e8 6c ef ff ff       	call   8015ab <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80263f:	c9                   	leave  
  802640:	c3                   	ret    

00802641 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802641:	55                   	push   %ebp
  802642:	89 e5                	mov    %esp,%ebp
  802644:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802647:	83 ec 04             	sub    $0x4,%esp
  80264a:	68 4c 38 80 00       	push   $0x80384c
  80264f:	6a 29                	push   $0x29
  802651:	68 3d 38 80 00       	push   $0x80383d
  802656:	e8 50 ef ff ff       	call   8015ab <_panic>

0080265b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	83 ec 18             	sub    $0x18,%esp
  802661:	8b 45 10             	mov    0x10(%ebp),%eax
  802664:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  802667:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80266b:	75 07                	jne    802674 <smalloc+0x19>
  80266d:	b8 00 00 00 00       	mov    $0x0,%eax
  802672:	eb 14                	jmp    802688 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  802674:	83 ec 04             	sub    $0x4,%esp
  802677:	68 70 38 80 00       	push   $0x803870
  80267c:	6a 38                	push   $0x38
  80267e:	68 3d 38 80 00       	push   $0x80383d
  802683:	e8 23 ef ff ff       	call   8015ab <_panic>
	return NULL;
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802690:	83 ec 04             	sub    $0x4,%esp
  802693:	68 98 38 80 00       	push   $0x803898
  802698:	6a 43                	push   $0x43
  80269a:	68 3d 38 80 00       	push   $0x80383d
  80269f:	e8 07 ef ff ff       	call   8015ab <_panic>

008026a4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8026aa:	83 ec 04             	sub    $0x4,%esp
  8026ad:	68 bc 38 80 00       	push   $0x8038bc
  8026b2:	6a 5b                	push   $0x5b
  8026b4:	68 3d 38 80 00       	push   $0x80383d
  8026b9:	e8 ed ee ff ff       	call   8015ab <_panic>

008026be <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8026c4:	83 ec 04             	sub    $0x4,%esp
  8026c7:	68 e0 38 80 00       	push   $0x8038e0
  8026cc:	6a 72                	push   $0x72
  8026ce:	68 3d 38 80 00       	push   $0x80383d
  8026d3:	e8 d3 ee ff ff       	call   8015ab <_panic>

008026d8 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8026d8:	55                   	push   %ebp
  8026d9:	89 e5                	mov    %esp,%ebp
  8026db:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026de:	83 ec 04             	sub    $0x4,%esp
  8026e1:	68 06 39 80 00       	push   $0x803906
  8026e6:	6a 7e                	push   $0x7e
  8026e8:	68 3d 38 80 00       	push   $0x80383d
  8026ed:	e8 b9 ee ff ff       	call   8015ab <_panic>

008026f2 <shrink>:

}
void shrink(uint32 newSize)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8026f8:	83 ec 04             	sub    $0x4,%esp
  8026fb:	68 06 39 80 00       	push   $0x803906
  802700:	68 83 00 00 00       	push   $0x83
  802705:	68 3d 38 80 00       	push   $0x80383d
  80270a:	e8 9c ee ff ff       	call   8015ab <_panic>

0080270f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
  802712:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802715:	83 ec 04             	sub    $0x4,%esp
  802718:	68 06 39 80 00       	push   $0x803906
  80271d:	68 88 00 00 00       	push   $0x88
  802722:	68 3d 38 80 00       	push   $0x80383d
  802727:	e8 7f ee ff ff       	call   8015ab <_panic>

0080272c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
  80272f:	57                   	push   %edi
  802730:	56                   	push   %esi
  802731:	53                   	push   %ebx
  802732:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80273b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80273e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802741:	8b 7d 18             	mov    0x18(%ebp),%edi
  802744:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802747:	cd 30                	int    $0x30
  802749:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80274c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80274f:	83 c4 10             	add    $0x10,%esp
  802752:	5b                   	pop    %ebx
  802753:	5e                   	pop    %esi
  802754:	5f                   	pop    %edi
  802755:	5d                   	pop    %ebp
  802756:	c3                   	ret    

00802757 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
  80275a:	83 ec 04             	sub    $0x4,%esp
  80275d:	8b 45 10             	mov    0x10(%ebp),%eax
  802760:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802763:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802767:	8b 45 08             	mov    0x8(%ebp),%eax
  80276a:	6a 00                	push   $0x0
  80276c:	6a 00                	push   $0x0
  80276e:	52                   	push   %edx
  80276f:	ff 75 0c             	pushl  0xc(%ebp)
  802772:	50                   	push   %eax
  802773:	6a 00                	push   $0x0
  802775:	e8 b2 ff ff ff       	call   80272c <syscall>
  80277a:	83 c4 18             	add    $0x18,%esp
}
  80277d:	90                   	nop
  80277e:	c9                   	leave  
  80277f:	c3                   	ret    

00802780 <sys_cgetc>:

int
sys_cgetc(void)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802783:	6a 00                	push   $0x0
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 02                	push   $0x2
  80278f:	e8 98 ff ff ff       	call   80272c <syscall>
  802794:	83 c4 18             	add    $0x18,%esp
}
  802797:	c9                   	leave  
  802798:	c3                   	ret    

00802799 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 03                	push   $0x3
  8027a8:	e8 7f ff ff ff       	call   80272c <syscall>
  8027ad:	83 c4 18             	add    $0x18,%esp
}
  8027b0:	90                   	nop
  8027b1:	c9                   	leave  
  8027b2:	c3                   	ret    

008027b3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 00                	push   $0x0
  8027ba:	6a 00                	push   $0x0
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 04                	push   $0x4
  8027c2:	e8 65 ff ff ff       	call   80272c <syscall>
  8027c7:	83 c4 18             	add    $0x18,%esp
}
  8027ca:	90                   	nop
  8027cb:	c9                   	leave  
  8027cc:	c3                   	ret    

008027cd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8027cd:	55                   	push   %ebp
  8027ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8027d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	52                   	push   %edx
  8027dd:	50                   	push   %eax
  8027de:	6a 08                	push   $0x8
  8027e0:	e8 47 ff ff ff       	call   80272c <syscall>
  8027e5:	83 c4 18             	add    $0x18,%esp
}
  8027e8:	c9                   	leave  
  8027e9:	c3                   	ret    

008027ea <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	56                   	push   %esi
  8027ee:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8027ef:	8b 75 18             	mov    0x18(%ebp),%esi
  8027f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fe:	56                   	push   %esi
  8027ff:	53                   	push   %ebx
  802800:	51                   	push   %ecx
  802801:	52                   	push   %edx
  802802:	50                   	push   %eax
  802803:	6a 09                	push   $0x9
  802805:	e8 22 ff ff ff       	call   80272c <syscall>
  80280a:	83 c4 18             	add    $0x18,%esp
}
  80280d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802810:	5b                   	pop    %ebx
  802811:	5e                   	pop    %esi
  802812:	5d                   	pop    %ebp
  802813:	c3                   	ret    

00802814 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	6a 00                	push   $0x0
  80281f:	6a 00                	push   $0x0
  802821:	6a 00                	push   $0x0
  802823:	52                   	push   %edx
  802824:	50                   	push   %eax
  802825:	6a 0a                	push   $0xa
  802827:	e8 00 ff ff ff       	call   80272c <syscall>
  80282c:	83 c4 18             	add    $0x18,%esp
}
  80282f:	c9                   	leave  
  802830:	c3                   	ret    

00802831 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802831:	55                   	push   %ebp
  802832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802834:	6a 00                	push   $0x0
  802836:	6a 00                	push   $0x0
  802838:	6a 00                	push   $0x0
  80283a:	ff 75 0c             	pushl  0xc(%ebp)
  80283d:	ff 75 08             	pushl  0x8(%ebp)
  802840:	6a 0b                	push   $0xb
  802842:	e8 e5 fe ff ff       	call   80272c <syscall>
  802847:	83 c4 18             	add    $0x18,%esp
}
  80284a:	c9                   	leave  
  80284b:	c3                   	ret    

0080284c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	6a 00                	push   $0x0
  802859:	6a 0c                	push   $0xc
  80285b:	e8 cc fe ff ff       	call   80272c <syscall>
  802860:	83 c4 18             	add    $0x18,%esp
}
  802863:	c9                   	leave  
  802864:	c3                   	ret    

00802865 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 00                	push   $0x0
  80286e:	6a 00                	push   $0x0
  802870:	6a 00                	push   $0x0
  802872:	6a 0d                	push   $0xd
  802874:	e8 b3 fe ff ff       	call   80272c <syscall>
  802879:	83 c4 18             	add    $0x18,%esp
}
  80287c:	c9                   	leave  
  80287d:	c3                   	ret    

0080287e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80287e:	55                   	push   %ebp
  80287f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 0e                	push   $0xe
  80288d:	e8 9a fe ff ff       	call   80272c <syscall>
  802892:	83 c4 18             	add    $0x18,%esp
}
  802895:	c9                   	leave  
  802896:	c3                   	ret    

00802897 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802897:	55                   	push   %ebp
  802898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 0f                	push   $0xf
  8028a6:	e8 81 fe ff ff       	call   80272c <syscall>
  8028ab:	83 c4 18             	add    $0x18,%esp
}
  8028ae:	c9                   	leave  
  8028af:	c3                   	ret    

008028b0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 00                	push   $0x0
  8028bb:	ff 75 08             	pushl  0x8(%ebp)
  8028be:	6a 10                	push   $0x10
  8028c0:	e8 67 fe ff ff       	call   80272c <syscall>
  8028c5:	83 c4 18             	add    $0x18,%esp
}
  8028c8:	c9                   	leave  
  8028c9:	c3                   	ret    

008028ca <sys_scarce_memory>:

void sys_scarce_memory()
{
  8028ca:	55                   	push   %ebp
  8028cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	6a 00                	push   $0x0
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 00                	push   $0x0
  8028d7:	6a 11                	push   $0x11
  8028d9:	e8 4e fe ff ff       	call   80272c <syscall>
  8028de:	83 c4 18             	add    $0x18,%esp
}
  8028e1:	90                   	nop
  8028e2:	c9                   	leave  
  8028e3:	c3                   	ret    

008028e4 <sys_cputc>:

void
sys_cputc(const char c)
{
  8028e4:	55                   	push   %ebp
  8028e5:	89 e5                	mov    %esp,%ebp
  8028e7:	83 ec 04             	sub    $0x4,%esp
  8028ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8028f0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028f4:	6a 00                	push   $0x0
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 00                	push   $0x0
  8028fa:	6a 00                	push   $0x0
  8028fc:	50                   	push   %eax
  8028fd:	6a 01                	push   $0x1
  8028ff:	e8 28 fe ff ff       	call   80272c <syscall>
  802904:	83 c4 18             	add    $0x18,%esp
}
  802907:	90                   	nop
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80290d:	6a 00                	push   $0x0
  80290f:	6a 00                	push   $0x0
  802911:	6a 00                	push   $0x0
  802913:	6a 00                	push   $0x0
  802915:	6a 00                	push   $0x0
  802917:	6a 14                	push   $0x14
  802919:	e8 0e fe ff ff       	call   80272c <syscall>
  80291e:	83 c4 18             	add    $0x18,%esp
}
  802921:	90                   	nop
  802922:	c9                   	leave  
  802923:	c3                   	ret    

00802924 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802924:	55                   	push   %ebp
  802925:	89 e5                	mov    %esp,%ebp
  802927:	83 ec 04             	sub    $0x4,%esp
  80292a:	8b 45 10             	mov    0x10(%ebp),%eax
  80292d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802930:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802933:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	6a 00                	push   $0x0
  80293c:	51                   	push   %ecx
  80293d:	52                   	push   %edx
  80293e:	ff 75 0c             	pushl  0xc(%ebp)
  802941:	50                   	push   %eax
  802942:	6a 15                	push   $0x15
  802944:	e8 e3 fd ff ff       	call   80272c <syscall>
  802949:	83 c4 18             	add    $0x18,%esp
}
  80294c:	c9                   	leave  
  80294d:	c3                   	ret    

0080294e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802951:	8b 55 0c             	mov    0xc(%ebp),%edx
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	6a 00                	push   $0x0
  802959:	6a 00                	push   $0x0
  80295b:	6a 00                	push   $0x0
  80295d:	52                   	push   %edx
  80295e:	50                   	push   %eax
  80295f:	6a 16                	push   $0x16
  802961:	e8 c6 fd ff ff       	call   80272c <syscall>
  802966:	83 c4 18             	add    $0x18,%esp
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80296e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802971:	8b 55 0c             	mov    0xc(%ebp),%edx
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	6a 00                	push   $0x0
  802979:	6a 00                	push   $0x0
  80297b:	51                   	push   %ecx
  80297c:	52                   	push   %edx
  80297d:	50                   	push   %eax
  80297e:	6a 17                	push   $0x17
  802980:	e8 a7 fd ff ff       	call   80272c <syscall>
  802985:	83 c4 18             	add    $0x18,%esp
}
  802988:	c9                   	leave  
  802989:	c3                   	ret    

0080298a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80298a:	55                   	push   %ebp
  80298b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80298d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	6a 00                	push   $0x0
  802995:	6a 00                	push   $0x0
  802997:	6a 00                	push   $0x0
  802999:	52                   	push   %edx
  80299a:	50                   	push   %eax
  80299b:	6a 18                	push   $0x18
  80299d:	e8 8a fd ff ff       	call   80272c <syscall>
  8029a2:	83 c4 18             	add    $0x18,%esp
}
  8029a5:	c9                   	leave  
  8029a6:	c3                   	ret    

008029a7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8029a7:	55                   	push   %ebp
  8029a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	6a 00                	push   $0x0
  8029af:	ff 75 14             	pushl  0x14(%ebp)
  8029b2:	ff 75 10             	pushl  0x10(%ebp)
  8029b5:	ff 75 0c             	pushl  0xc(%ebp)
  8029b8:	50                   	push   %eax
  8029b9:	6a 19                	push   $0x19
  8029bb:	e8 6c fd ff ff       	call   80272c <syscall>
  8029c0:	83 c4 18             	add    $0x18,%esp
}
  8029c3:	c9                   	leave  
  8029c4:	c3                   	ret    

008029c5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8029c5:	55                   	push   %ebp
  8029c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 00                	push   $0x0
  8029cf:	6a 00                	push   $0x0
  8029d1:	6a 00                	push   $0x0
  8029d3:	50                   	push   %eax
  8029d4:	6a 1a                	push   $0x1a
  8029d6:	e8 51 fd ff ff       	call   80272c <syscall>
  8029db:	83 c4 18             	add    $0x18,%esp
}
  8029de:	90                   	nop
  8029df:	c9                   	leave  
  8029e0:	c3                   	ret    

008029e1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8029e1:	55                   	push   %ebp
  8029e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	6a 00                	push   $0x0
  8029e9:	6a 00                	push   $0x0
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	50                   	push   %eax
  8029f0:	6a 1b                	push   $0x1b
  8029f2:	e8 35 fd ff ff       	call   80272c <syscall>
  8029f7:	83 c4 18             	add    $0x18,%esp
}
  8029fa:	c9                   	leave  
  8029fb:	c3                   	ret    

008029fc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8029fc:	55                   	push   %ebp
  8029fd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8029ff:	6a 00                	push   $0x0
  802a01:	6a 00                	push   $0x0
  802a03:	6a 00                	push   $0x0
  802a05:	6a 00                	push   $0x0
  802a07:	6a 00                	push   $0x0
  802a09:	6a 05                	push   $0x5
  802a0b:	e8 1c fd ff ff       	call   80272c <syscall>
  802a10:	83 c4 18             	add    $0x18,%esp
}
  802a13:	c9                   	leave  
  802a14:	c3                   	ret    

00802a15 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802a18:	6a 00                	push   $0x0
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	6a 00                	push   $0x0
  802a20:	6a 00                	push   $0x0
  802a22:	6a 06                	push   $0x6
  802a24:	e8 03 fd ff ff       	call   80272c <syscall>
  802a29:	83 c4 18             	add    $0x18,%esp
}
  802a2c:	c9                   	leave  
  802a2d:	c3                   	ret    

00802a2e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802a2e:	55                   	push   %ebp
  802a2f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802a31:	6a 00                	push   $0x0
  802a33:	6a 00                	push   $0x0
  802a35:	6a 00                	push   $0x0
  802a37:	6a 00                	push   $0x0
  802a39:	6a 00                	push   $0x0
  802a3b:	6a 07                	push   $0x7
  802a3d:	e8 ea fc ff ff       	call   80272c <syscall>
  802a42:	83 c4 18             	add    $0x18,%esp
}
  802a45:	c9                   	leave  
  802a46:	c3                   	ret    

00802a47 <sys_exit_env>:


void sys_exit_env(void)
{
  802a47:	55                   	push   %ebp
  802a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a4a:	6a 00                	push   $0x0
  802a4c:	6a 00                	push   $0x0
  802a4e:	6a 00                	push   $0x0
  802a50:	6a 00                	push   $0x0
  802a52:	6a 00                	push   $0x0
  802a54:	6a 1c                	push   $0x1c
  802a56:	e8 d1 fc ff ff       	call   80272c <syscall>
  802a5b:	83 c4 18             	add    $0x18,%esp
}
  802a5e:	90                   	nop
  802a5f:	c9                   	leave  
  802a60:	c3                   	ret    

00802a61 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802a61:	55                   	push   %ebp
  802a62:	89 e5                	mov    %esp,%ebp
  802a64:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802a67:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a6a:	8d 50 04             	lea    0x4(%eax),%edx
  802a6d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a70:	6a 00                	push   $0x0
  802a72:	6a 00                	push   $0x0
  802a74:	6a 00                	push   $0x0
  802a76:	52                   	push   %edx
  802a77:	50                   	push   %eax
  802a78:	6a 1d                	push   $0x1d
  802a7a:	e8 ad fc ff ff       	call   80272c <syscall>
  802a7f:	83 c4 18             	add    $0x18,%esp
	return result;
  802a82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a8b:	89 01                	mov    %eax,(%ecx)
  802a8d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802a90:	8b 45 08             	mov    0x8(%ebp),%eax
  802a93:	c9                   	leave  
  802a94:	c2 04 00             	ret    $0x4

00802a97 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a97:	55                   	push   %ebp
  802a98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a9a:	6a 00                	push   $0x0
  802a9c:	6a 00                	push   $0x0
  802a9e:	ff 75 10             	pushl  0x10(%ebp)
  802aa1:	ff 75 0c             	pushl  0xc(%ebp)
  802aa4:	ff 75 08             	pushl  0x8(%ebp)
  802aa7:	6a 13                	push   $0x13
  802aa9:	e8 7e fc ff ff       	call   80272c <syscall>
  802aae:	83 c4 18             	add    $0x18,%esp
	return ;
  802ab1:	90                   	nop
}
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <sys_rcr2>:
uint32 sys_rcr2()
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 00                	push   $0x0
  802abd:	6a 00                	push   $0x0
  802abf:	6a 00                	push   $0x0
  802ac1:	6a 1e                	push   $0x1e
  802ac3:	e8 64 fc ff ff       	call   80272c <syscall>
  802ac8:	83 c4 18             	add    $0x18,%esp
}
  802acb:	c9                   	leave  
  802acc:	c3                   	ret    

00802acd <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802acd:	55                   	push   %ebp
  802ace:	89 e5                	mov    %esp,%ebp
  802ad0:	83 ec 04             	sub    $0x4,%esp
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ad9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802add:	6a 00                	push   $0x0
  802adf:	6a 00                	push   $0x0
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	50                   	push   %eax
  802ae6:	6a 1f                	push   $0x1f
  802ae8:	e8 3f fc ff ff       	call   80272c <syscall>
  802aed:	83 c4 18             	add    $0x18,%esp
	return ;
  802af0:	90                   	nop
}
  802af1:	c9                   	leave  
  802af2:	c3                   	ret    

00802af3 <rsttst>:
void rsttst()
{
  802af3:	55                   	push   %ebp
  802af4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802af6:	6a 00                	push   $0x0
  802af8:	6a 00                	push   $0x0
  802afa:	6a 00                	push   $0x0
  802afc:	6a 00                	push   $0x0
  802afe:	6a 00                	push   $0x0
  802b00:	6a 21                	push   $0x21
  802b02:	e8 25 fc ff ff       	call   80272c <syscall>
  802b07:	83 c4 18             	add    $0x18,%esp
	return ;
  802b0a:	90                   	nop
}
  802b0b:	c9                   	leave  
  802b0c:	c3                   	ret    

00802b0d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802b0d:	55                   	push   %ebp
  802b0e:	89 e5                	mov    %esp,%ebp
  802b10:	83 ec 04             	sub    $0x4,%esp
  802b13:	8b 45 14             	mov    0x14(%ebp),%eax
  802b16:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802b19:	8b 55 18             	mov    0x18(%ebp),%edx
  802b1c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b20:	52                   	push   %edx
  802b21:	50                   	push   %eax
  802b22:	ff 75 10             	pushl  0x10(%ebp)
  802b25:	ff 75 0c             	pushl  0xc(%ebp)
  802b28:	ff 75 08             	pushl  0x8(%ebp)
  802b2b:	6a 20                	push   $0x20
  802b2d:	e8 fa fb ff ff       	call   80272c <syscall>
  802b32:	83 c4 18             	add    $0x18,%esp
	return ;
  802b35:	90                   	nop
}
  802b36:	c9                   	leave  
  802b37:	c3                   	ret    

00802b38 <chktst>:
void chktst(uint32 n)
{
  802b38:	55                   	push   %ebp
  802b39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 00                	push   $0x0
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	ff 75 08             	pushl  0x8(%ebp)
  802b46:	6a 22                	push   $0x22
  802b48:	e8 df fb ff ff       	call   80272c <syscall>
  802b4d:	83 c4 18             	add    $0x18,%esp
	return ;
  802b50:	90                   	nop
}
  802b51:	c9                   	leave  
  802b52:	c3                   	ret    

00802b53 <inctst>:

void inctst()
{
  802b53:	55                   	push   %ebp
  802b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b56:	6a 00                	push   $0x0
  802b58:	6a 00                	push   $0x0
  802b5a:	6a 00                	push   $0x0
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 23                	push   $0x23
  802b62:	e8 c5 fb ff ff       	call   80272c <syscall>
  802b67:	83 c4 18             	add    $0x18,%esp
	return ;
  802b6a:	90                   	nop
}
  802b6b:	c9                   	leave  
  802b6c:	c3                   	ret    

00802b6d <gettst>:
uint32 gettst()
{
  802b6d:	55                   	push   %ebp
  802b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802b70:	6a 00                	push   $0x0
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 00                	push   $0x0
  802b78:	6a 00                	push   $0x0
  802b7a:	6a 24                	push   $0x24
  802b7c:	e8 ab fb ff ff       	call   80272c <syscall>
  802b81:	83 c4 18             	add    $0x18,%esp
}
  802b84:	c9                   	leave  
  802b85:	c3                   	ret    

00802b86 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802b86:	55                   	push   %ebp
  802b87:	89 e5                	mov    %esp,%ebp
  802b89:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b8c:	6a 00                	push   $0x0
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 00                	push   $0x0
  802b92:	6a 00                	push   $0x0
  802b94:	6a 00                	push   $0x0
  802b96:	6a 25                	push   $0x25
  802b98:	e8 8f fb ff ff       	call   80272c <syscall>
  802b9d:	83 c4 18             	add    $0x18,%esp
  802ba0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802ba3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802ba7:	75 07                	jne    802bb0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802ba9:	b8 01 00 00 00       	mov    $0x1,%eax
  802bae:	eb 05                	jmp    802bb5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802bb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb5:	c9                   	leave  
  802bb6:	c3                   	ret    

00802bb7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802bb7:	55                   	push   %ebp
  802bb8:	89 e5                	mov    %esp,%ebp
  802bba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bbd:	6a 00                	push   $0x0
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 00                	push   $0x0
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 25                	push   $0x25
  802bc9:	e8 5e fb ff ff       	call   80272c <syscall>
  802bce:	83 c4 18             	add    $0x18,%esp
  802bd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802bd4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802bd8:	75 07                	jne    802be1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802bda:	b8 01 00 00 00       	mov    $0x1,%eax
  802bdf:	eb 05                	jmp    802be6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be6:	c9                   	leave  
  802be7:	c3                   	ret    

00802be8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802be8:	55                   	push   %ebp
  802be9:	89 e5                	mov    %esp,%ebp
  802beb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bee:	6a 00                	push   $0x0
  802bf0:	6a 00                	push   $0x0
  802bf2:	6a 00                	push   $0x0
  802bf4:	6a 00                	push   $0x0
  802bf6:	6a 00                	push   $0x0
  802bf8:	6a 25                	push   $0x25
  802bfa:	e8 2d fb ff ff       	call   80272c <syscall>
  802bff:	83 c4 18             	add    $0x18,%esp
  802c02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802c05:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802c09:	75 07                	jne    802c12 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802c0b:	b8 01 00 00 00       	mov    $0x1,%eax
  802c10:	eb 05                	jmp    802c17 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802c12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c17:	c9                   	leave  
  802c18:	c3                   	ret    

00802c19 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802c19:	55                   	push   %ebp
  802c1a:	89 e5                	mov    %esp,%ebp
  802c1c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c1f:	6a 00                	push   $0x0
  802c21:	6a 00                	push   $0x0
  802c23:	6a 00                	push   $0x0
  802c25:	6a 00                	push   $0x0
  802c27:	6a 00                	push   $0x0
  802c29:	6a 25                	push   $0x25
  802c2b:	e8 fc fa ff ff       	call   80272c <syscall>
  802c30:	83 c4 18             	add    $0x18,%esp
  802c33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802c36:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802c3a:	75 07                	jne    802c43 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802c3c:	b8 01 00 00 00       	mov    $0x1,%eax
  802c41:	eb 05                	jmp    802c48 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802c43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c48:	c9                   	leave  
  802c49:	c3                   	ret    

00802c4a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c4a:	55                   	push   %ebp
  802c4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802c4d:	6a 00                	push   $0x0
  802c4f:	6a 00                	push   $0x0
  802c51:	6a 00                	push   $0x0
  802c53:	6a 00                	push   $0x0
  802c55:	ff 75 08             	pushl  0x8(%ebp)
  802c58:	6a 26                	push   $0x26
  802c5a:	e8 cd fa ff ff       	call   80272c <syscall>
  802c5f:	83 c4 18             	add    $0x18,%esp
	return ;
  802c62:	90                   	nop
}
  802c63:	c9                   	leave  
  802c64:	c3                   	ret    

00802c65 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802c65:	55                   	push   %ebp
  802c66:	89 e5                	mov    %esp,%ebp
  802c68:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802c69:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	6a 00                	push   $0x0
  802c77:	53                   	push   %ebx
  802c78:	51                   	push   %ecx
  802c79:	52                   	push   %edx
  802c7a:	50                   	push   %eax
  802c7b:	6a 27                	push   $0x27
  802c7d:	e8 aa fa ff ff       	call   80272c <syscall>
  802c82:	83 c4 18             	add    $0x18,%esp
}
  802c85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c88:	c9                   	leave  
  802c89:	c3                   	ret    

00802c8a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802c8a:	55                   	push   %ebp
  802c8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	6a 00                	push   $0x0
  802c95:	6a 00                	push   $0x0
  802c97:	6a 00                	push   $0x0
  802c99:	52                   	push   %edx
  802c9a:	50                   	push   %eax
  802c9b:	6a 28                	push   $0x28
  802c9d:	e8 8a fa ff ff       	call   80272c <syscall>
  802ca2:	83 c4 18             	add    $0x18,%esp
}
  802ca5:	c9                   	leave  
  802ca6:	c3                   	ret    

00802ca7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802ca7:	55                   	push   %ebp
  802ca8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802caa:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb3:	6a 00                	push   $0x0
  802cb5:	51                   	push   %ecx
  802cb6:	ff 75 10             	pushl  0x10(%ebp)
  802cb9:	52                   	push   %edx
  802cba:	50                   	push   %eax
  802cbb:	6a 29                	push   $0x29
  802cbd:	e8 6a fa ff ff       	call   80272c <syscall>
  802cc2:	83 c4 18             	add    $0x18,%esp
}
  802cc5:	c9                   	leave  
  802cc6:	c3                   	ret    

00802cc7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802cc7:	55                   	push   %ebp
  802cc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802cca:	6a 00                	push   $0x0
  802ccc:	6a 00                	push   $0x0
  802cce:	ff 75 10             	pushl  0x10(%ebp)
  802cd1:	ff 75 0c             	pushl  0xc(%ebp)
  802cd4:	ff 75 08             	pushl  0x8(%ebp)
  802cd7:	6a 12                	push   $0x12
  802cd9:	e8 4e fa ff ff       	call   80272c <syscall>
  802cde:	83 c4 18             	add    $0x18,%esp
	return ;
  802ce1:	90                   	nop
}
  802ce2:	c9                   	leave  
  802ce3:	c3                   	ret    

00802ce4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802ce4:	55                   	push   %ebp
  802ce5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	6a 00                	push   $0x0
  802cef:	6a 00                	push   $0x0
  802cf1:	6a 00                	push   $0x0
  802cf3:	52                   	push   %edx
  802cf4:	50                   	push   %eax
  802cf5:	6a 2a                	push   $0x2a
  802cf7:	e8 30 fa ff ff       	call   80272c <syscall>
  802cfc:	83 c4 18             	add    $0x18,%esp
	return;
  802cff:	90                   	nop
}
  802d00:	c9                   	leave  
  802d01:	c3                   	ret    

00802d02 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802d02:	55                   	push   %ebp
  802d03:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	6a 00                	push   $0x0
  802d0a:	6a 00                	push   $0x0
  802d0c:	6a 00                	push   $0x0
  802d0e:	6a 00                	push   $0x0
  802d10:	50                   	push   %eax
  802d11:	6a 2b                	push   $0x2b
  802d13:	e8 14 fa ff ff       	call   80272c <syscall>
  802d18:	83 c4 18             	add    $0x18,%esp
}
  802d1b:	c9                   	leave  
  802d1c:	c3                   	ret    

00802d1d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802d1d:	55                   	push   %ebp
  802d1e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802d20:	6a 00                	push   $0x0
  802d22:	6a 00                	push   $0x0
  802d24:	6a 00                	push   $0x0
  802d26:	ff 75 0c             	pushl  0xc(%ebp)
  802d29:	ff 75 08             	pushl  0x8(%ebp)
  802d2c:	6a 2c                	push   $0x2c
  802d2e:	e8 f9 f9 ff ff       	call   80272c <syscall>
  802d33:	83 c4 18             	add    $0x18,%esp
	return;
  802d36:	90                   	nop
}
  802d37:	c9                   	leave  
  802d38:	c3                   	ret    

00802d39 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802d39:	55                   	push   %ebp
  802d3a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802d3c:	6a 00                	push   $0x0
  802d3e:	6a 00                	push   $0x0
  802d40:	6a 00                	push   $0x0
  802d42:	ff 75 0c             	pushl  0xc(%ebp)
  802d45:	ff 75 08             	pushl  0x8(%ebp)
  802d48:	6a 2d                	push   $0x2d
  802d4a:	e8 dd f9 ff ff       	call   80272c <syscall>
  802d4f:	83 c4 18             	add    $0x18,%esp
	return;
  802d52:	90                   	nop
}
  802d53:	c9                   	leave  
  802d54:	c3                   	ret    
  802d55:	66 90                	xchg   %ax,%ax
  802d57:	90                   	nop

00802d58 <__udivdi3>:
  802d58:	55                   	push   %ebp
  802d59:	57                   	push   %edi
  802d5a:	56                   	push   %esi
  802d5b:	53                   	push   %ebx
  802d5c:	83 ec 1c             	sub    $0x1c,%esp
  802d5f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d63:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d6f:	89 ca                	mov    %ecx,%edx
  802d71:	89 f8                	mov    %edi,%eax
  802d73:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d77:	85 f6                	test   %esi,%esi
  802d79:	75 2d                	jne    802da8 <__udivdi3+0x50>
  802d7b:	39 cf                	cmp    %ecx,%edi
  802d7d:	77 65                	ja     802de4 <__udivdi3+0x8c>
  802d7f:	89 fd                	mov    %edi,%ebp
  802d81:	85 ff                	test   %edi,%edi
  802d83:	75 0b                	jne    802d90 <__udivdi3+0x38>
  802d85:	b8 01 00 00 00       	mov    $0x1,%eax
  802d8a:	31 d2                	xor    %edx,%edx
  802d8c:	f7 f7                	div    %edi
  802d8e:	89 c5                	mov    %eax,%ebp
  802d90:	31 d2                	xor    %edx,%edx
  802d92:	89 c8                	mov    %ecx,%eax
  802d94:	f7 f5                	div    %ebp
  802d96:	89 c1                	mov    %eax,%ecx
  802d98:	89 d8                	mov    %ebx,%eax
  802d9a:	f7 f5                	div    %ebp
  802d9c:	89 cf                	mov    %ecx,%edi
  802d9e:	89 fa                	mov    %edi,%edx
  802da0:	83 c4 1c             	add    $0x1c,%esp
  802da3:	5b                   	pop    %ebx
  802da4:	5e                   	pop    %esi
  802da5:	5f                   	pop    %edi
  802da6:	5d                   	pop    %ebp
  802da7:	c3                   	ret    
  802da8:	39 ce                	cmp    %ecx,%esi
  802daa:	77 28                	ja     802dd4 <__udivdi3+0x7c>
  802dac:	0f bd fe             	bsr    %esi,%edi
  802daf:	83 f7 1f             	xor    $0x1f,%edi
  802db2:	75 40                	jne    802df4 <__udivdi3+0x9c>
  802db4:	39 ce                	cmp    %ecx,%esi
  802db6:	72 0a                	jb     802dc2 <__udivdi3+0x6a>
  802db8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802dbc:	0f 87 9e 00 00 00    	ja     802e60 <__udivdi3+0x108>
  802dc2:	b8 01 00 00 00       	mov    $0x1,%eax
  802dc7:	89 fa                	mov    %edi,%edx
  802dc9:	83 c4 1c             	add    $0x1c,%esp
  802dcc:	5b                   	pop    %ebx
  802dcd:	5e                   	pop    %esi
  802dce:	5f                   	pop    %edi
  802dcf:	5d                   	pop    %ebp
  802dd0:	c3                   	ret    
  802dd1:	8d 76 00             	lea    0x0(%esi),%esi
  802dd4:	31 ff                	xor    %edi,%edi
  802dd6:	31 c0                	xor    %eax,%eax
  802dd8:	89 fa                	mov    %edi,%edx
  802dda:	83 c4 1c             	add    $0x1c,%esp
  802ddd:	5b                   	pop    %ebx
  802dde:	5e                   	pop    %esi
  802ddf:	5f                   	pop    %edi
  802de0:	5d                   	pop    %ebp
  802de1:	c3                   	ret    
  802de2:	66 90                	xchg   %ax,%ax
  802de4:	89 d8                	mov    %ebx,%eax
  802de6:	f7 f7                	div    %edi
  802de8:	31 ff                	xor    %edi,%edi
  802dea:	89 fa                	mov    %edi,%edx
  802dec:	83 c4 1c             	add    $0x1c,%esp
  802def:	5b                   	pop    %ebx
  802df0:	5e                   	pop    %esi
  802df1:	5f                   	pop    %edi
  802df2:	5d                   	pop    %ebp
  802df3:	c3                   	ret    
  802df4:	bd 20 00 00 00       	mov    $0x20,%ebp
  802df9:	89 eb                	mov    %ebp,%ebx
  802dfb:	29 fb                	sub    %edi,%ebx
  802dfd:	89 f9                	mov    %edi,%ecx
  802dff:	d3 e6                	shl    %cl,%esi
  802e01:	89 c5                	mov    %eax,%ebp
  802e03:	88 d9                	mov    %bl,%cl
  802e05:	d3 ed                	shr    %cl,%ebp
  802e07:	89 e9                	mov    %ebp,%ecx
  802e09:	09 f1                	or     %esi,%ecx
  802e0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802e0f:	89 f9                	mov    %edi,%ecx
  802e11:	d3 e0                	shl    %cl,%eax
  802e13:	89 c5                	mov    %eax,%ebp
  802e15:	89 d6                	mov    %edx,%esi
  802e17:	88 d9                	mov    %bl,%cl
  802e19:	d3 ee                	shr    %cl,%esi
  802e1b:	89 f9                	mov    %edi,%ecx
  802e1d:	d3 e2                	shl    %cl,%edx
  802e1f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e23:	88 d9                	mov    %bl,%cl
  802e25:	d3 e8                	shr    %cl,%eax
  802e27:	09 c2                	or     %eax,%edx
  802e29:	89 d0                	mov    %edx,%eax
  802e2b:	89 f2                	mov    %esi,%edx
  802e2d:	f7 74 24 0c          	divl   0xc(%esp)
  802e31:	89 d6                	mov    %edx,%esi
  802e33:	89 c3                	mov    %eax,%ebx
  802e35:	f7 e5                	mul    %ebp
  802e37:	39 d6                	cmp    %edx,%esi
  802e39:	72 19                	jb     802e54 <__udivdi3+0xfc>
  802e3b:	74 0b                	je     802e48 <__udivdi3+0xf0>
  802e3d:	89 d8                	mov    %ebx,%eax
  802e3f:	31 ff                	xor    %edi,%edi
  802e41:	e9 58 ff ff ff       	jmp    802d9e <__udivdi3+0x46>
  802e46:	66 90                	xchg   %ax,%ax
  802e48:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e4c:	89 f9                	mov    %edi,%ecx
  802e4e:	d3 e2                	shl    %cl,%edx
  802e50:	39 c2                	cmp    %eax,%edx
  802e52:	73 e9                	jae    802e3d <__udivdi3+0xe5>
  802e54:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e57:	31 ff                	xor    %edi,%edi
  802e59:	e9 40 ff ff ff       	jmp    802d9e <__udivdi3+0x46>
  802e5e:	66 90                	xchg   %ax,%ax
  802e60:	31 c0                	xor    %eax,%eax
  802e62:	e9 37 ff ff ff       	jmp    802d9e <__udivdi3+0x46>
  802e67:	90                   	nop

00802e68 <__umoddi3>:
  802e68:	55                   	push   %ebp
  802e69:	57                   	push   %edi
  802e6a:	56                   	push   %esi
  802e6b:	53                   	push   %ebx
  802e6c:	83 ec 1c             	sub    $0x1c,%esp
  802e6f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e73:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e87:	89 f3                	mov    %esi,%ebx
  802e89:	89 fa                	mov    %edi,%edx
  802e8b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e8f:	89 34 24             	mov    %esi,(%esp)
  802e92:	85 c0                	test   %eax,%eax
  802e94:	75 1a                	jne    802eb0 <__umoddi3+0x48>
  802e96:	39 f7                	cmp    %esi,%edi
  802e98:	0f 86 a2 00 00 00    	jbe    802f40 <__umoddi3+0xd8>
  802e9e:	89 c8                	mov    %ecx,%eax
  802ea0:	89 f2                	mov    %esi,%edx
  802ea2:	f7 f7                	div    %edi
  802ea4:	89 d0                	mov    %edx,%eax
  802ea6:	31 d2                	xor    %edx,%edx
  802ea8:	83 c4 1c             	add    $0x1c,%esp
  802eab:	5b                   	pop    %ebx
  802eac:	5e                   	pop    %esi
  802ead:	5f                   	pop    %edi
  802eae:	5d                   	pop    %ebp
  802eaf:	c3                   	ret    
  802eb0:	39 f0                	cmp    %esi,%eax
  802eb2:	0f 87 ac 00 00 00    	ja     802f64 <__umoddi3+0xfc>
  802eb8:	0f bd e8             	bsr    %eax,%ebp
  802ebb:	83 f5 1f             	xor    $0x1f,%ebp
  802ebe:	0f 84 ac 00 00 00    	je     802f70 <__umoddi3+0x108>
  802ec4:	bf 20 00 00 00       	mov    $0x20,%edi
  802ec9:	29 ef                	sub    %ebp,%edi
  802ecb:	89 fe                	mov    %edi,%esi
  802ecd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ed1:	89 e9                	mov    %ebp,%ecx
  802ed3:	d3 e0                	shl    %cl,%eax
  802ed5:	89 d7                	mov    %edx,%edi
  802ed7:	89 f1                	mov    %esi,%ecx
  802ed9:	d3 ef                	shr    %cl,%edi
  802edb:	09 c7                	or     %eax,%edi
  802edd:	89 e9                	mov    %ebp,%ecx
  802edf:	d3 e2                	shl    %cl,%edx
  802ee1:	89 14 24             	mov    %edx,(%esp)
  802ee4:	89 d8                	mov    %ebx,%eax
  802ee6:	d3 e0                	shl    %cl,%eax
  802ee8:	89 c2                	mov    %eax,%edx
  802eea:	8b 44 24 08          	mov    0x8(%esp),%eax
  802eee:	d3 e0                	shl    %cl,%eax
  802ef0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ef4:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ef8:	89 f1                	mov    %esi,%ecx
  802efa:	d3 e8                	shr    %cl,%eax
  802efc:	09 d0                	or     %edx,%eax
  802efe:	d3 eb                	shr    %cl,%ebx
  802f00:	89 da                	mov    %ebx,%edx
  802f02:	f7 f7                	div    %edi
  802f04:	89 d3                	mov    %edx,%ebx
  802f06:	f7 24 24             	mull   (%esp)
  802f09:	89 c6                	mov    %eax,%esi
  802f0b:	89 d1                	mov    %edx,%ecx
  802f0d:	39 d3                	cmp    %edx,%ebx
  802f0f:	0f 82 87 00 00 00    	jb     802f9c <__umoddi3+0x134>
  802f15:	0f 84 91 00 00 00    	je     802fac <__umoddi3+0x144>
  802f1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f1f:	29 f2                	sub    %esi,%edx
  802f21:	19 cb                	sbb    %ecx,%ebx
  802f23:	89 d8                	mov    %ebx,%eax
  802f25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802f29:	d3 e0                	shl    %cl,%eax
  802f2b:	89 e9                	mov    %ebp,%ecx
  802f2d:	d3 ea                	shr    %cl,%edx
  802f2f:	09 d0                	or     %edx,%eax
  802f31:	89 e9                	mov    %ebp,%ecx
  802f33:	d3 eb                	shr    %cl,%ebx
  802f35:	89 da                	mov    %ebx,%edx
  802f37:	83 c4 1c             	add    $0x1c,%esp
  802f3a:	5b                   	pop    %ebx
  802f3b:	5e                   	pop    %esi
  802f3c:	5f                   	pop    %edi
  802f3d:	5d                   	pop    %ebp
  802f3e:	c3                   	ret    
  802f3f:	90                   	nop
  802f40:	89 fd                	mov    %edi,%ebp
  802f42:	85 ff                	test   %edi,%edi
  802f44:	75 0b                	jne    802f51 <__umoddi3+0xe9>
  802f46:	b8 01 00 00 00       	mov    $0x1,%eax
  802f4b:	31 d2                	xor    %edx,%edx
  802f4d:	f7 f7                	div    %edi
  802f4f:	89 c5                	mov    %eax,%ebp
  802f51:	89 f0                	mov    %esi,%eax
  802f53:	31 d2                	xor    %edx,%edx
  802f55:	f7 f5                	div    %ebp
  802f57:	89 c8                	mov    %ecx,%eax
  802f59:	f7 f5                	div    %ebp
  802f5b:	89 d0                	mov    %edx,%eax
  802f5d:	e9 44 ff ff ff       	jmp    802ea6 <__umoddi3+0x3e>
  802f62:	66 90                	xchg   %ax,%ax
  802f64:	89 c8                	mov    %ecx,%eax
  802f66:	89 f2                	mov    %esi,%edx
  802f68:	83 c4 1c             	add    $0x1c,%esp
  802f6b:	5b                   	pop    %ebx
  802f6c:	5e                   	pop    %esi
  802f6d:	5f                   	pop    %edi
  802f6e:	5d                   	pop    %ebp
  802f6f:	c3                   	ret    
  802f70:	3b 04 24             	cmp    (%esp),%eax
  802f73:	72 06                	jb     802f7b <__umoddi3+0x113>
  802f75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f79:	77 0f                	ja     802f8a <__umoddi3+0x122>
  802f7b:	89 f2                	mov    %esi,%edx
  802f7d:	29 f9                	sub    %edi,%ecx
  802f7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802f83:	89 14 24             	mov    %edx,(%esp)
  802f86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f8e:	8b 14 24             	mov    (%esp),%edx
  802f91:	83 c4 1c             	add    $0x1c,%esp
  802f94:	5b                   	pop    %ebx
  802f95:	5e                   	pop    %esi
  802f96:	5f                   	pop    %edi
  802f97:	5d                   	pop    %ebp
  802f98:	c3                   	ret    
  802f99:	8d 76 00             	lea    0x0(%esi),%esi
  802f9c:	2b 04 24             	sub    (%esp),%eax
  802f9f:	19 fa                	sbb    %edi,%edx
  802fa1:	89 d1                	mov    %edx,%ecx
  802fa3:	89 c6                	mov    %eax,%esi
  802fa5:	e9 71 ff ff ff       	jmp    802f1b <__umoddi3+0xb3>
  802faa:	66 90                	xchg   %ax,%ax
  802fac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802fb0:	72 ea                	jb     802f9c <__umoddi3+0x134>
  802fb2:	89 d9                	mov    %ebx,%ecx
  802fb4:	e9 62 ff ff ff       	jmp    802f1b <__umoddi3+0xb3>
