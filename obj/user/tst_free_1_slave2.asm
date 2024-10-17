
obj/user/tst_free_1_slave2:     file format elf32-i386


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
  800031:	e8 74 02 00 00       	call   8002aa <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	}
	//	/*Dummy malloc to enforce the UHEAP initializations*/
	//	malloc(0);
	/*=================================================*/
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800043:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int Mega = 1024*1024;
  80004a:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800051:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	char minByte = 1<<7;
  800058:	c6 45 eb 80          	movb   $0x80,-0x15(%ebp)
	char maxByte = 0x7F;
  80005c:	c6 45 ea 7f          	movb   $0x7f,-0x16(%ebp)
	short minShort = 1<<15 ;
  800060:	66 c7 45 e8 00 80    	movw   $0x8000,-0x18(%ebp)
	short maxShort = 0x7FFF;
  800066:	66 c7 45 e6 ff 7f    	movw   $0x7fff,-0x1a(%ebp)
	int minInt = 1<<31 ;
  80006c:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
	int maxInt = 0x7FFFFFFF;
  800073:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
	char *byteArr ;
	int lastIndexOfByte;

	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  80007a:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  800080:	b9 14 00 00 00       	mov    $0x14,%ecx
  800085:	b8 00 00 00 00       	mov    $0x0,%eax
  80008a:	89 d7                	mov    %edx,%edi
  80008c:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ONE SPACE
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80008e:	e8 05 16 00 00       	call   801698 <sys_calculate_free_frames>
  800093:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800096:	e8 48 16 00 00       	call   8016e3 <sys_pf_calculate_allocated_pages>
  80009b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  80009e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000a1:	01 c0                	add    %eax,%eax
  8000a3:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000a6:	83 ec 0c             	sub    $0xc,%esp
  8000a9:	50                   	push   %eax
  8000aa:	e8 b5 13 00 00       	call   801464 <malloc>
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000b8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 20 1e 80 00       	push   $0x801e20
  8000cb:	6a 34                	push   $0x34
  8000cd:	68 50 1e 80 00       	push   $0x801e50
  8000d2:	e8 20 03 00 00       	call   8003f7 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 07 16 00 00       	call   8016e3 <sys_pf_calculate_allocated_pages>
  8000dc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8000df:	74 14                	je     8000f5 <_main+0xbd>
  8000e1:	83 ec 04             	sub    $0x4,%esp
  8000e4:	68 6c 1e 80 00       	push   $0x801e6c
  8000e9:	6a 35                	push   $0x35
  8000eb:	68 50 1e 80 00       	push   $0x801e50
  8000f0:	e8 02 03 00 00       	call   8003f7 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8000f5:	e8 9e 15 00 00       	call   801698 <sys_calculate_free_frames>
  8000fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8000fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800100:	01 c0                	add    %eax,%eax
  800102:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800105:	48                   	dec    %eax
  800106:	89 45 d0             	mov    %eax,-0x30(%ebp)
			byteArr = (char *) ptr_allocations[0];
  800109:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80010f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr[0] = minByte ;
  800112:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800115:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800118:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  80011a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80011d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800120:	01 c2                	add    %eax,%edx
  800122:	8a 45 ea             	mov    -0x16(%ebp),%al
  800125:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800127:	c7 45 c8 02 00 00 00 	movl   $0x2,-0x38(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80012e:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800131:	e8 62 15 00 00       	call   801698 <sys_calculate_free_frames>
  800136:	29 c3                	sub    %eax,%ebx
  800138:	89 d8                	mov    %ebx,%eax
  80013a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80013d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800140:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800143:	7d 1a                	jge    80015f <_main+0x127>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 c4             	pushl  -0x3c(%ebp)
  80014b:	ff 75 c8             	pushl  -0x38(%ebp)
  80014e:	68 9c 1e 80 00       	push   $0x801e9c
  800153:	6a 3f                	push   $0x3f
  800155:	68 50 1e 80 00       	push   $0x801e50
  80015a:	e8 98 02 00 00       	call   8003f7 <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  80015f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800162:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800165:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800168:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80016d:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800173:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800176:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800179:	01 d0                	add    %edx,%eax
  80017b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80017e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800181:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800186:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80018c:	6a 02                	push   $0x2
  80018e:	6a 00                	push   $0x0
  800190:	6a 02                	push   $0x2
  800192:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800198:	50                   	push   %eax
  800199:	e8 55 19 00 00       	call   801af3 <sys_check_WS_list>
  80019e:	83 c4 10             	add    $0x10,%esp
  8001a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001a4:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001a8:	74 14                	je     8001be <_main+0x186>
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	68 18 1f 80 00       	push   $0x801f18
  8001b2:	6a 43                	push   $0x43
  8001b4:	68 50 1e 80 00       	push   $0x801e50
  8001b9:	e8 39 02 00 00       	call   8003f7 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001be:	e8 d5 14 00 00       	call   801698 <sys_calculate_free_frames>
  8001c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001c6:	e8 18 15 00 00       	call   8016e3 <sys_pf_calculate_allocated_pages>
  8001cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001ce:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	50                   	push   %eax
  8001d8:	e8 b0 12 00 00       	call   80148d <free>
  8001dd:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8001e0:	e8 fe 14 00 00       	call   8016e3 <sys_pf_calculate_allocated_pages>
  8001e5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001e8:	74 14                	je     8001fe <_main+0x1c6>
  8001ea:	83 ec 04             	sub    $0x4,%esp
  8001ed:	68 38 1f 80 00       	push   $0x801f38
  8001f2:	6a 50                	push   $0x50
  8001f4:	68 50 1e 80 00       	push   $0x801e50
  8001f9:	e8 f9 01 00 00       	call   8003f7 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8001fe:	e8 95 14 00 00       	call   801698 <sys_calculate_free_frames>
  800203:	89 c2                	mov    %eax,%edx
  800205:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800208:	29 c2                	sub    %eax,%edx
  80020a:	89 d0                	mov    %edx,%eax
  80020c:	83 f8 02             	cmp    $0x2,%eax
  80020f:	74 14                	je     800225 <_main+0x1ed>
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	68 74 1f 80 00       	push   $0x801f74
  800219:	6a 51                	push   $0x51
  80021b:	68 50 1e 80 00       	push   $0x801e50
  800220:	e8 d2 01 00 00       	call   8003f7 <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800225:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800228:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80022b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800239:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80023c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80023f:	01 d0                	add    %edx,%eax
  800241:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800244:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800247:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024c:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800252:	6a 03                	push   $0x3
  800254:	6a 00                	push   $0x0
  800256:	6a 02                	push   $0x2
  800258:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80025e:	50                   	push   %eax
  80025f:	e8 8f 18 00 00       	call   801af3 <sys_check_WS_list>
  800264:	83 c4 10             	add    $0x10,%esp
  800267:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  80026a:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80026e:	74 14                	je     800284 <_main+0x24c>
  800270:	83 ec 04             	sub    $0x4,%esp
  800273:	68 c0 1f 80 00       	push   $0x801fc0
  800278:	6a 54                	push   $0x54
  80027a:	68 50 1e 80 00       	push   $0x801e50
  80027f:	e8 73 01 00 00       	call   8003f7 <_panic>
		}
	}

	inctst(); //to ensure that it reached here
  800284:	e8 16 17 00 00       	call   80199f <inctst>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  800289:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80028c:	8a 55 eb             	mov    -0x15(%ebp),%dl
  80028f:	88 10                	mov    %dl,(%eax)
		inctst();
  800291:	e8 09 17 00 00       	call   80199f <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  800296:	83 ec 04             	sub    $0x4,%esp
  800299:	68 e4 1f 80 00       	push   $0x801fe4
  80029e:	6a 5e                	push   $0x5e
  8002a0:	68 50 1e 80 00       	push   $0x801e50
  8002a5:	e8 4d 01 00 00       	call   8003f7 <_panic>

008002aa <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002b0:	e8 ac 15 00 00       	call   801861 <sys_getenvindex>
  8002b5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8002b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002bb:	89 d0                	mov    %edx,%eax
  8002bd:	c1 e0 06             	shl    $0x6,%eax
  8002c0:	29 d0                	sub    %edx,%eax
  8002c2:	c1 e0 02             	shl    $0x2,%eax
  8002c5:	01 d0                	add    %edx,%eax
  8002c7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002ce:	01 c8                	add    %ecx,%eax
  8002d0:	c1 e0 03             	shl    $0x3,%eax
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002dc:	29 c2                	sub    %eax,%edx
  8002de:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002e5:	89 c2                	mov    %eax,%edx
  8002e7:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002ed:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f2:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f7:	8a 40 20             	mov    0x20(%eax),%al
  8002fa:	84 c0                	test   %al,%al
  8002fc:	74 0d                	je     80030b <libmain+0x61>
		binaryname = myEnv->prog_name;
  8002fe:	a1 04 30 80 00       	mov    0x803004,%eax
  800303:	83 c0 20             	add    $0x20,%eax
  800306:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80030b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80030f:	7e 0a                	jle    80031b <libmain+0x71>
		binaryname = argv[0];
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	8b 00                	mov    (%eax),%eax
  800316:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80031b:	83 ec 08             	sub    $0x8,%esp
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	e8 0f fd ff ff       	call   800038 <_main>
  800329:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80032c:	e8 b4 12 00 00       	call   8015e5 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800331:	83 ec 0c             	sub    $0xc,%esp
  800334:	68 48 20 80 00       	push   $0x802048
  800339:	e8 76 03 00 00       	call   8006b4 <cprintf>
  80033e:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800341:	a1 04 30 80 00       	mov    0x803004,%eax
  800346:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80034c:	a1 04 30 80 00       	mov    0x803004,%eax
  800351:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800357:	83 ec 04             	sub    $0x4,%esp
  80035a:	52                   	push   %edx
  80035b:	50                   	push   %eax
  80035c:	68 70 20 80 00       	push   $0x802070
  800361:	e8 4e 03 00 00       	call   8006b4 <cprintf>
  800366:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800369:	a1 04 30 80 00       	mov    0x803004,%eax
  80036e:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800374:	a1 04 30 80 00       	mov    0x803004,%eax
  800379:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80037f:	a1 04 30 80 00       	mov    0x803004,%eax
  800384:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80038a:	51                   	push   %ecx
  80038b:	52                   	push   %edx
  80038c:	50                   	push   %eax
  80038d:	68 98 20 80 00       	push   $0x802098
  800392:	e8 1d 03 00 00       	call   8006b4 <cprintf>
  800397:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039a:	a1 04 30 80 00       	mov    0x803004,%eax
  80039f:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	50                   	push   %eax
  8003a9:	68 f0 20 80 00       	push   $0x8020f0
  8003ae:	e8 01 03 00 00       	call   8006b4 <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8003b6:	83 ec 0c             	sub    $0xc,%esp
  8003b9:	68 48 20 80 00       	push   $0x802048
  8003be:	e8 f1 02 00 00       	call   8006b4 <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8003c6:	e8 34 12 00 00       	call   8015ff <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8003cb:	e8 19 00 00 00       	call   8003e9 <exit>
}
  8003d0:	90                   	nop
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d9:	83 ec 0c             	sub    $0xc,%esp
  8003dc:	6a 00                	push   $0x0
  8003de:	e8 4a 14 00 00       	call   80182d <sys_destroy_env>
  8003e3:	83 c4 10             	add    $0x10,%esp
}
  8003e6:	90                   	nop
  8003e7:	c9                   	leave  
  8003e8:	c3                   	ret    

008003e9 <exit>:

void
exit(void)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003ef:	e8 9f 14 00 00       	call   801893 <sys_exit_env>
}
  8003f4:	90                   	nop
  8003f5:	c9                   	leave  
  8003f6:	c3                   	ret    

008003f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f7:	55                   	push   %ebp
  8003f8:	89 e5                	mov    %esp,%ebp
  8003fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003fd:	8d 45 10             	lea    0x10(%ebp),%eax
  800400:	83 c0 04             	add    $0x4,%eax
  800403:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800406:	a1 24 30 80 00       	mov    0x803024,%eax
  80040b:	85 c0                	test   %eax,%eax
  80040d:	74 16                	je     800425 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80040f:	a1 24 30 80 00       	mov    0x803024,%eax
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	50                   	push   %eax
  800418:	68 04 21 80 00       	push   $0x802104
  80041d:	e8 92 02 00 00       	call   8006b4 <cprintf>
  800422:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800425:	a1 00 30 80 00       	mov    0x803000,%eax
  80042a:	ff 75 0c             	pushl  0xc(%ebp)
  80042d:	ff 75 08             	pushl  0x8(%ebp)
  800430:	50                   	push   %eax
  800431:	68 09 21 80 00       	push   $0x802109
  800436:	e8 79 02 00 00       	call   8006b4 <cprintf>
  80043b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80043e:	8b 45 10             	mov    0x10(%ebp),%eax
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	ff 75 f4             	pushl  -0xc(%ebp)
  800447:	50                   	push   %eax
  800448:	e8 fc 01 00 00       	call   800649 <vcprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	6a 00                	push   $0x0
  800455:	68 25 21 80 00       	push   $0x802125
  80045a:	e8 ea 01 00 00       	call   800649 <vcprintf>
  80045f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800462:	e8 82 ff ff ff       	call   8003e9 <exit>

	// should not return here
	while (1) ;
  800467:	eb fe                	jmp    800467 <_panic+0x70>

00800469 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
  80046c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80046f:	a1 04 30 80 00       	mov    0x803004,%eax
  800474:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80047a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047d:	39 c2                	cmp    %eax,%edx
  80047f:	74 14                	je     800495 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800481:	83 ec 04             	sub    $0x4,%esp
  800484:	68 28 21 80 00       	push   $0x802128
  800489:	6a 26                	push   $0x26
  80048b:	68 74 21 80 00       	push   $0x802174
  800490:	e8 62 ff ff ff       	call   8003f7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800495:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80049c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a3:	e9 c5 00 00 00       	jmp    80056d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	01 d0                	add    %edx,%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	85 c0                	test   %eax,%eax
  8004bb:	75 08                	jne    8004c5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004bd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004c0:	e9 a5 00 00 00       	jmp    80056a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004d3:	eb 69                	jmp    80053e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004d5:	a1 04 30 80 00       	mov    0x803004,%eax
  8004da:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8004e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e3:	89 d0                	mov    %edx,%eax
  8004e5:	01 c0                	add    %eax,%eax
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	c1 e0 03             	shl    $0x3,%eax
  8004ec:	01 c8                	add    %ecx,%eax
  8004ee:	8a 40 04             	mov    0x4(%eax),%al
  8004f1:	84 c0                	test   %al,%al
  8004f3:	75 46                	jne    80053b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f5:	a1 04 30 80 00       	mov    0x803004,%eax
  8004fa:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800500:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800503:	89 d0                	mov    %edx,%eax
  800505:	01 c0                	add    %eax,%eax
  800507:	01 d0                	add    %edx,%eax
  800509:	c1 e0 03             	shl    $0x3,%eax
  80050c:	01 c8                	add    %ecx,%eax
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800513:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800516:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80051b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80051d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800520:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800527:	8b 45 08             	mov    0x8(%ebp),%eax
  80052a:	01 c8                	add    %ecx,%eax
  80052c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80052e:	39 c2                	cmp    %eax,%edx
  800530:	75 09                	jne    80053b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800532:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800539:	eb 15                	jmp    800550 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053b:	ff 45 e8             	incl   -0x18(%ebp)
  80053e:	a1 04 30 80 00       	mov    0x803004,%eax
  800543:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800549:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80054c:	39 c2                	cmp    %eax,%edx
  80054e:	77 85                	ja     8004d5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800550:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800554:	75 14                	jne    80056a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 80 21 80 00       	push   $0x802180
  80055e:	6a 3a                	push   $0x3a
  800560:	68 74 21 80 00       	push   $0x802174
  800565:	e8 8d fe ff ff       	call   8003f7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80056a:	ff 45 f0             	incl   -0x10(%ebp)
  80056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800570:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800573:	0f 8c 2f ff ff ff    	jl     8004a8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800579:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800580:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800587:	eb 26                	jmp    8005af <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800589:	a1 04 30 80 00       	mov    0x803004,%eax
  80058e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800594:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800597:	89 d0                	mov    %edx,%eax
  800599:	01 c0                	add    %eax,%eax
  80059b:	01 d0                	add    %edx,%eax
  80059d:	c1 e0 03             	shl    $0x3,%eax
  8005a0:	01 c8                	add    %ecx,%eax
  8005a2:	8a 40 04             	mov    0x4(%eax),%al
  8005a5:	3c 01                	cmp    $0x1,%al
  8005a7:	75 03                	jne    8005ac <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005a9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ac:	ff 45 e0             	incl   -0x20(%ebp)
  8005af:	a1 04 30 80 00       	mov    0x803004,%eax
  8005b4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005bd:	39 c2                	cmp    %eax,%edx
  8005bf:	77 c8                	ja     800589 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c7:	74 14                	je     8005dd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	68 d4 21 80 00       	push   $0x8021d4
  8005d1:	6a 44                	push   $0x44
  8005d3:	68 74 21 80 00       	push   $0x802174
  8005d8:	e8 1a fe ff ff       	call   8003f7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005dd:	90                   	nop
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e9:	8b 00                	mov    (%eax),%eax
  8005eb:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f1:	89 0a                	mov    %ecx,(%edx)
  8005f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f6:	88 d1                	mov    %dl,%cl
  8005f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005fb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	3d ff 00 00 00       	cmp    $0xff,%eax
  800609:	75 2c                	jne    800637 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80060b:	a0 08 30 80 00       	mov    0x803008,%al
  800610:	0f b6 c0             	movzbl %al,%eax
  800613:	8b 55 0c             	mov    0xc(%ebp),%edx
  800616:	8b 12                	mov    (%edx),%edx
  800618:	89 d1                	mov    %edx,%ecx
  80061a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061d:	83 c2 08             	add    $0x8,%edx
  800620:	83 ec 04             	sub    $0x4,%esp
  800623:	50                   	push   %eax
  800624:	51                   	push   %ecx
  800625:	52                   	push   %edx
  800626:	e8 78 0f 00 00       	call   8015a3 <sys_cputs>
  80062b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800631:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063a:	8b 40 04             	mov    0x4(%eax),%eax
  80063d:	8d 50 01             	lea    0x1(%eax),%edx
  800640:	8b 45 0c             	mov    0xc(%ebp),%eax
  800643:	89 50 04             	mov    %edx,0x4(%eax)
}
  800646:	90                   	nop
  800647:	c9                   	leave  
  800648:	c3                   	ret    

00800649 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800649:	55                   	push   %ebp
  80064a:	89 e5                	mov    %esp,%ebp
  80064c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800652:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800659:	00 00 00 
	b.cnt = 0;
  80065c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800663:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800666:	ff 75 0c             	pushl  0xc(%ebp)
  800669:	ff 75 08             	pushl  0x8(%ebp)
  80066c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800672:	50                   	push   %eax
  800673:	68 e0 05 80 00       	push   $0x8005e0
  800678:	e8 11 02 00 00       	call   80088e <vprintfmt>
  80067d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800680:	a0 08 30 80 00       	mov    0x803008,%al
  800685:	0f b6 c0             	movzbl %al,%eax
  800688:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	50                   	push   %eax
  800692:	52                   	push   %edx
  800693:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800699:	83 c0 08             	add    $0x8,%eax
  80069c:	50                   	push   %eax
  80069d:	e8 01 0f 00 00       	call   8015a3 <sys_cputs>
  8006a2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006a5:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8006ac:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006b2:	c9                   	leave  
  8006b3:	c3                   	ret    

008006b4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ba:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8006c1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d0:	50                   	push   %eax
  8006d1:	e8 73 ff ff ff       	call   800649 <vcprintf>
  8006d6:	83 c4 10             	add    $0x10,%esp
  8006d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8006e7:	e8 f9 0e 00 00       	call   8015e5 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8006ec:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	83 ec 08             	sub    $0x8,%esp
  8006f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006fb:	50                   	push   %eax
  8006fc:	e8 48 ff ff ff       	call   800649 <vcprintf>
  800701:	83 c4 10             	add    $0x10,%esp
  800704:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800707:	e8 f3 0e 00 00       	call   8015ff <sys_unlock_cons>
	return cnt;
  80070c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070f:	c9                   	leave  
  800710:	c3                   	ret    

00800711 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	53                   	push   %ebx
  800715:	83 ec 14             	sub    $0x14,%esp
  800718:	8b 45 10             	mov    0x10(%ebp),%eax
  80071b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800724:	8b 45 18             	mov    0x18(%ebp),%eax
  800727:	ba 00 00 00 00       	mov    $0x0,%edx
  80072c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072f:	77 55                	ja     800786 <printnum+0x75>
  800731:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800734:	72 05                	jb     80073b <printnum+0x2a>
  800736:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800739:	77 4b                	ja     800786 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80073b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80073e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800741:	8b 45 18             	mov    0x18(%ebp),%eax
  800744:	ba 00 00 00 00       	mov    $0x0,%edx
  800749:	52                   	push   %edx
  80074a:	50                   	push   %eax
  80074b:	ff 75 f4             	pushl  -0xc(%ebp)
  80074e:	ff 75 f0             	pushl  -0x10(%ebp)
  800751:	e8 52 14 00 00       	call   801ba8 <__udivdi3>
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	83 ec 04             	sub    $0x4,%esp
  80075c:	ff 75 20             	pushl  0x20(%ebp)
  80075f:	53                   	push   %ebx
  800760:	ff 75 18             	pushl  0x18(%ebp)
  800763:	52                   	push   %edx
  800764:	50                   	push   %eax
  800765:	ff 75 0c             	pushl  0xc(%ebp)
  800768:	ff 75 08             	pushl  0x8(%ebp)
  80076b:	e8 a1 ff ff ff       	call   800711 <printnum>
  800770:	83 c4 20             	add    $0x20,%esp
  800773:	eb 1a                	jmp    80078f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	ff 75 20             	pushl  0x20(%ebp)
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	ff d0                	call   *%eax
  800783:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800786:	ff 4d 1c             	decl   0x1c(%ebp)
  800789:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80078d:	7f e6                	jg     800775 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80078f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800792:	bb 00 00 00 00       	mov    $0x0,%ebx
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80079d:	53                   	push   %ebx
  80079e:	51                   	push   %ecx
  80079f:	52                   	push   %edx
  8007a0:	50                   	push   %eax
  8007a1:	e8 12 15 00 00       	call   801cb8 <__umoddi3>
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	05 34 24 80 00       	add    $0x802434,%eax
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f be c0             	movsbl %al,%eax
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	ff d0                	call   *%eax
  8007bf:	83 c4 10             	add    $0x10,%esp
}
  8007c2:	90                   	nop
  8007c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c6:	c9                   	leave  
  8007c7:	c3                   	ret    

008007c8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007cf:	7e 1c                	jle    8007ed <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	8d 50 08             	lea    0x8(%eax),%edx
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	89 10                	mov    %edx,(%eax)
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	83 e8 08             	sub    $0x8,%eax
  8007e6:	8b 50 04             	mov    0x4(%eax),%edx
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	eb 40                	jmp    80082d <getuint+0x65>
	else if (lflag)
  8007ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f1:	74 1e                	je     800811 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	8b 00                	mov    (%eax),%eax
  8007f8:	8d 50 04             	lea    0x4(%eax),%edx
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	89 10                	mov    %edx,(%eax)
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	8b 00                	mov    (%eax),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	ba 00 00 00 00       	mov    $0x0,%edx
  80080f:	eb 1c                	jmp    80082d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	8d 50 04             	lea    0x4(%eax),%edx
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	89 10                	mov    %edx,(%eax)
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	83 e8 04             	sub    $0x4,%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800832:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800836:	7e 1c                	jle    800854 <getint+0x25>
		return va_arg(*ap, long long);
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	8d 50 08             	lea    0x8(%eax),%edx
  800840:	8b 45 08             	mov    0x8(%ebp),%eax
  800843:	89 10                	mov    %edx,(%eax)
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	8b 00                	mov    (%eax),%eax
  80084a:	83 e8 08             	sub    $0x8,%eax
  80084d:	8b 50 04             	mov    0x4(%eax),%edx
  800850:	8b 00                	mov    (%eax),%eax
  800852:	eb 38                	jmp    80088c <getint+0x5d>
	else if (lflag)
  800854:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800858:	74 1a                	je     800874 <getint+0x45>
		return va_arg(*ap, long);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8d 50 04             	lea    0x4(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 10                	mov    %edx,(%eax)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	83 e8 04             	sub    $0x4,%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	99                   	cltd   
  800872:	eb 18                	jmp    80088c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	8b 00                	mov    (%eax),%eax
  800879:	8d 50 04             	lea    0x4(%eax),%edx
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	89 10                	mov    %edx,(%eax)
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	8b 00                	mov    (%eax),%eax
  800886:	83 e8 04             	sub    $0x4,%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	99                   	cltd   
}
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	56                   	push   %esi
  800892:	53                   	push   %ebx
  800893:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800896:	eb 17                	jmp    8008af <vprintfmt+0x21>
			if (ch == '\0')
  800898:	85 db                	test   %ebx,%ebx
  80089a:	0f 84 c1 03 00 00    	je     800c61 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	53                   	push   %ebx
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	ff d0                	call   *%eax
  8008ac:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008af:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b2:	8d 50 01             	lea    0x1(%eax),%edx
  8008b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b8:	8a 00                	mov    (%eax),%al
  8008ba:	0f b6 d8             	movzbl %al,%ebx
  8008bd:	83 fb 25             	cmp    $0x25,%ebx
  8008c0:	75 d6                	jne    800898 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008c2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008cd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e5:	8d 50 01             	lea    0x1(%eax),%edx
  8008e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8008eb:	8a 00                	mov    (%eax),%al
  8008ed:	0f b6 d8             	movzbl %al,%ebx
  8008f0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008f3:	83 f8 5b             	cmp    $0x5b,%eax
  8008f6:	0f 87 3d 03 00 00    	ja     800c39 <vprintfmt+0x3ab>
  8008fc:	8b 04 85 58 24 80 00 	mov    0x802458(,%eax,4),%eax
  800903:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800905:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800909:	eb d7                	jmp    8008e2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80090b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80090f:	eb d1                	jmp    8008e2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800911:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800918:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091b:	89 d0                	mov    %edx,%eax
  80091d:	c1 e0 02             	shl    $0x2,%eax
  800920:	01 d0                	add    %edx,%eax
  800922:	01 c0                	add    %eax,%eax
  800924:	01 d8                	add    %ebx,%eax
  800926:	83 e8 30             	sub    $0x30,%eax
  800929:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80092c:	8b 45 10             	mov    0x10(%ebp),%eax
  80092f:	8a 00                	mov    (%eax),%al
  800931:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800934:	83 fb 2f             	cmp    $0x2f,%ebx
  800937:	7e 3e                	jle    800977 <vprintfmt+0xe9>
  800939:	83 fb 39             	cmp    $0x39,%ebx
  80093c:	7f 39                	jg     800977 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800941:	eb d5                	jmp    800918 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800943:	8b 45 14             	mov    0x14(%ebp),%eax
  800946:	83 c0 04             	add    $0x4,%eax
  800949:	89 45 14             	mov    %eax,0x14(%ebp)
  80094c:	8b 45 14             	mov    0x14(%ebp),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800957:	eb 1f                	jmp    800978 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800959:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095d:	79 83                	jns    8008e2 <vprintfmt+0x54>
				width = 0;
  80095f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800966:	e9 77 ff ff ff       	jmp    8008e2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80096b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800972:	e9 6b ff ff ff       	jmp    8008e2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800977:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800978:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80097c:	0f 89 60 ff ff ff    	jns    8008e2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800982:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800985:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800988:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80098f:	e9 4e ff ff ff       	jmp    8008e2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800994:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800997:	e9 46 ff ff ff       	jmp    8008e2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80099c:	8b 45 14             	mov    0x14(%ebp),%eax
  80099f:	83 c0 04             	add    $0x4,%eax
  8009a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a8:	83 e8 04             	sub    $0x4,%eax
  8009ab:	8b 00                	mov    (%eax),%eax
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	ff 75 0c             	pushl  0xc(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	ff d0                	call   *%eax
  8009b9:	83 c4 10             	add    $0x10,%esp
			break;
  8009bc:	e9 9b 02 00 00       	jmp    800c5c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c4:	83 c0 04             	add    $0x4,%eax
  8009c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cd:	83 e8 04             	sub    $0x4,%eax
  8009d0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009d2:	85 db                	test   %ebx,%ebx
  8009d4:	79 02                	jns    8009d8 <vprintfmt+0x14a>
				err = -err;
  8009d6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d8:	83 fb 64             	cmp    $0x64,%ebx
  8009db:	7f 0b                	jg     8009e8 <vprintfmt+0x15a>
  8009dd:	8b 34 9d a0 22 80 00 	mov    0x8022a0(,%ebx,4),%esi
  8009e4:	85 f6                	test   %esi,%esi
  8009e6:	75 19                	jne    800a01 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e8:	53                   	push   %ebx
  8009e9:	68 45 24 80 00       	push   $0x802445
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	ff 75 08             	pushl  0x8(%ebp)
  8009f4:	e8 70 02 00 00       	call   800c69 <printfmt>
  8009f9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009fc:	e9 5b 02 00 00       	jmp    800c5c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a01:	56                   	push   %esi
  800a02:	68 4e 24 80 00       	push   $0x80244e
  800a07:	ff 75 0c             	pushl  0xc(%ebp)
  800a0a:	ff 75 08             	pushl  0x8(%ebp)
  800a0d:	e8 57 02 00 00       	call   800c69 <printfmt>
  800a12:	83 c4 10             	add    $0x10,%esp
			break;
  800a15:	e9 42 02 00 00       	jmp    800c5c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1d:	83 c0 04             	add    $0x4,%eax
  800a20:	89 45 14             	mov    %eax,0x14(%ebp)
  800a23:	8b 45 14             	mov    0x14(%ebp),%eax
  800a26:	83 e8 04             	sub    $0x4,%eax
  800a29:	8b 30                	mov    (%eax),%esi
  800a2b:	85 f6                	test   %esi,%esi
  800a2d:	75 05                	jne    800a34 <vprintfmt+0x1a6>
				p = "(null)";
  800a2f:	be 51 24 80 00       	mov    $0x802451,%esi
			if (width > 0 && padc != '-')
  800a34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a38:	7e 6d                	jle    800aa7 <vprintfmt+0x219>
  800a3a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a3e:	74 67                	je     800aa7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	50                   	push   %eax
  800a47:	56                   	push   %esi
  800a48:	e8 1e 03 00 00       	call   800d6b <strnlen>
  800a4d:	83 c4 10             	add    $0x10,%esp
  800a50:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a53:	eb 16                	jmp    800a6b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a55:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	50                   	push   %eax
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	ff d0                	call   *%eax
  800a65:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a68:	ff 4d e4             	decl   -0x1c(%ebp)
  800a6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6f:	7f e4                	jg     800a55 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a71:	eb 34                	jmp    800aa7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a73:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a77:	74 1c                	je     800a95 <vprintfmt+0x207>
  800a79:	83 fb 1f             	cmp    $0x1f,%ebx
  800a7c:	7e 05                	jle    800a83 <vprintfmt+0x1f5>
  800a7e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a81:	7e 12                	jle    800a95 <vprintfmt+0x207>
					putch('?', putdat);
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	6a 3f                	push   $0x3f
  800a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8e:	ff d0                	call   *%eax
  800a90:	83 c4 10             	add    $0x10,%esp
  800a93:	eb 0f                	jmp    800aa4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa4:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa7:	89 f0                	mov    %esi,%eax
  800aa9:	8d 70 01             	lea    0x1(%eax),%esi
  800aac:	8a 00                	mov    (%eax),%al
  800aae:	0f be d8             	movsbl %al,%ebx
  800ab1:	85 db                	test   %ebx,%ebx
  800ab3:	74 24                	je     800ad9 <vprintfmt+0x24b>
  800ab5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab9:	78 b8                	js     800a73 <vprintfmt+0x1e5>
  800abb:	ff 4d e0             	decl   -0x20(%ebp)
  800abe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ac2:	79 af                	jns    800a73 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac4:	eb 13                	jmp    800ad9 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac6:	83 ec 08             	sub    $0x8,%esp
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	6a 20                	push   $0x20
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	ff d0                	call   *%eax
  800ad3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800add:	7f e7                	jg     800ac6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800adf:	e9 78 01 00 00       	jmp    800c5c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 e8             	pushl  -0x18(%ebp)
  800aea:	8d 45 14             	lea    0x14(%ebp),%eax
  800aed:	50                   	push   %eax
  800aee:	e8 3c fd ff ff       	call   80082f <getint>
  800af3:	83 c4 10             	add    $0x10,%esp
  800af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b02:	85 d2                	test   %edx,%edx
  800b04:	79 23                	jns    800b29 <vprintfmt+0x29b>
				putch('-', putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	6a 2d                	push   $0x2d
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1c:	f7 d8                	neg    %eax
  800b1e:	83 d2 00             	adc    $0x0,%edx
  800b21:	f7 da                	neg    %edx
  800b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b26:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b29:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b30:	e9 bc 00 00 00       	jmp    800bf1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	ff 75 e8             	pushl  -0x18(%ebp)
  800b3b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3e:	50                   	push   %eax
  800b3f:	e8 84 fc ff ff       	call   8007c8 <getuint>
  800b44:	83 c4 10             	add    $0x10,%esp
  800b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b4d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b54:	e9 98 00 00 00       	jmp    800bf1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 58                	push   $0x58
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b69:	83 ec 08             	sub    $0x8,%esp
  800b6c:	ff 75 0c             	pushl  0xc(%ebp)
  800b6f:	6a 58                	push   $0x58
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	ff d0                	call   *%eax
  800b76:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b79:	83 ec 08             	sub    $0x8,%esp
  800b7c:	ff 75 0c             	pushl  0xc(%ebp)
  800b7f:	6a 58                	push   $0x58
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	ff d0                	call   *%eax
  800b86:	83 c4 10             	add    $0x10,%esp
			break;
  800b89:	e9 ce 00 00 00       	jmp    800c5c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800b8e:	83 ec 08             	sub    $0x8,%esp
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	6a 30                	push   $0x30
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	ff d0                	call   *%eax
  800b9b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	6a 78                	push   $0x78
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	ff d0                	call   *%eax
  800bab:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bae:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb1:	83 c0 04             	add    $0x4,%eax
  800bb4:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bba:	83 e8 04             	sub    $0x4,%eax
  800bbd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bd0:	eb 1f                	jmp    800bf1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bd2:	83 ec 08             	sub    $0x8,%esp
  800bd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdb:	50                   	push   %eax
  800bdc:	e8 e7 fb ff ff       	call   8007c8 <getuint>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bea:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf8:	83 ec 04             	sub    $0x4,%esp
  800bfb:	52                   	push   %edx
  800bfc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bff:	50                   	push   %eax
  800c00:	ff 75 f4             	pushl  -0xc(%ebp)
  800c03:	ff 75 f0             	pushl  -0x10(%ebp)
  800c06:	ff 75 0c             	pushl  0xc(%ebp)
  800c09:	ff 75 08             	pushl  0x8(%ebp)
  800c0c:	e8 00 fb ff ff       	call   800711 <printnum>
  800c11:	83 c4 20             	add    $0x20,%esp
			break;
  800c14:	eb 46                	jmp    800c5c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c16:	83 ec 08             	sub    $0x8,%esp
  800c19:	ff 75 0c             	pushl  0xc(%ebp)
  800c1c:	53                   	push   %ebx
  800c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c20:	ff d0                	call   *%eax
  800c22:	83 c4 10             	add    $0x10,%esp
			break;
  800c25:	eb 35                	jmp    800c5c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c27:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800c2e:	eb 2c                	jmp    800c5c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c30:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800c37:	eb 23                	jmp    800c5c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c39:	83 ec 08             	sub    $0x8,%esp
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	6a 25                	push   $0x25
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	ff d0                	call   *%eax
  800c46:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c49:	ff 4d 10             	decl   0x10(%ebp)
  800c4c:	eb 03                	jmp    800c51 <vprintfmt+0x3c3>
  800c4e:	ff 4d 10             	decl   0x10(%ebp)
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	48                   	dec    %eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	3c 25                	cmp    $0x25,%al
  800c59:	75 f3                	jne    800c4e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c5b:	90                   	nop
		}
	}
  800c5c:	e9 35 fc ff ff       	jmp    800896 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c61:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c6f:	8d 45 10             	lea    0x10(%ebp),%eax
  800c72:	83 c0 04             	add    $0x4,%eax
  800c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c78:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c7e:	50                   	push   %eax
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	ff 75 08             	pushl  0x8(%ebp)
  800c85:	e8 04 fc ff ff       	call   80088e <vprintfmt>
  800c8a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c8d:	90                   	nop
  800c8e:	c9                   	leave  
  800c8f:	c3                   	ret    

00800c90 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8b 40 08             	mov    0x8(%eax),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca5:	8b 10                	mov    (%eax),%edx
  800ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caa:	8b 40 04             	mov    0x4(%eax),%eax
  800cad:	39 c2                	cmp    %eax,%edx
  800caf:	73 12                	jae    800cc3 <sprintputch+0x33>
		*b->buf++ = ch;
  800cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb4:	8b 00                	mov    (%eax),%eax
  800cb6:	8d 48 01             	lea    0x1(%eax),%ecx
  800cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbc:	89 0a                	mov    %ecx,(%edx)
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	88 10                	mov    %dl,(%eax)
}
  800cc3:	90                   	nop
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	01 d0                	add    %edx,%eax
  800cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ce7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ceb:	74 06                	je     800cf3 <vsnprintf+0x2d>
  800ced:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf1:	7f 07                	jg     800cfa <vsnprintf+0x34>
		return -E_INVAL;
  800cf3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf8:	eb 20                	jmp    800d1a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cfa:	ff 75 14             	pushl  0x14(%ebp)
  800cfd:	ff 75 10             	pushl  0x10(%ebp)
  800d00:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d03:	50                   	push   %eax
  800d04:	68 90 0c 80 00       	push   $0x800c90
  800d09:	e8 80 fb ff ff       	call   80088e <vprintfmt>
  800d0e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d14:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d22:	8d 45 10             	lea    0x10(%ebp),%eax
  800d25:	83 c0 04             	add    $0x4,%eax
  800d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d31:	50                   	push   %eax
  800d32:	ff 75 0c             	pushl  0xc(%ebp)
  800d35:	ff 75 08             	pushl  0x8(%ebp)
  800d38:	e8 89 ff ff ff       	call   800cc6 <vsnprintf>
  800d3d:	83 c4 10             	add    $0x10,%esp
  800d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d46:	c9                   	leave  
  800d47:	c3                   	ret    

00800d48 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d55:	eb 06                	jmp    800d5d <strlen+0x15>
		n++;
  800d57:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d5a:	ff 45 08             	incl   0x8(%ebp)
  800d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d60:	8a 00                	mov    (%eax),%al
  800d62:	84 c0                	test   %al,%al
  800d64:	75 f1                	jne    800d57 <strlen+0xf>
		n++;
	return n;
  800d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    

00800d6b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d78:	eb 09                	jmp    800d83 <strnlen+0x18>
		n++;
  800d7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d7d:	ff 45 08             	incl   0x8(%ebp)
  800d80:	ff 4d 0c             	decl   0xc(%ebp)
  800d83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d87:	74 09                	je     800d92 <strnlen+0x27>
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	75 e8                	jne    800d7a <strnlen+0xf>
		n++;
	return n;
  800d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800da3:	90                   	nop
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8d 50 01             	lea    0x1(%eax),%edx
  800daa:	89 55 08             	mov    %edx,0x8(%ebp)
  800dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db6:	8a 12                	mov    (%edx),%dl
  800db8:	88 10                	mov    %dl,(%eax)
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	75 e4                	jne    800da4 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800dc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd8:	eb 1f                	jmp    800df9 <strncpy+0x34>
		*dst++ = *src;
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8d 50 01             	lea    0x1(%eax),%edx
  800de0:	89 55 08             	mov    %edx,0x8(%ebp)
  800de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de6:	8a 12                	mov    (%edx),%dl
  800de8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	84 c0                	test   %al,%al
  800df1:	74 03                	je     800df6 <strncpy+0x31>
			src++;
  800df3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800df6:	ff 45 fc             	incl   -0x4(%ebp)
  800df9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dff:	72 d9                	jb     800dda <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e01:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e16:	74 30                	je     800e48 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e18:	eb 16                	jmp    800e30 <strlcpy+0x2a>
			*dst++ = *src++;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8d 50 01             	lea    0x1(%eax),%edx
  800e20:	89 55 08             	mov    %edx,0x8(%ebp)
  800e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e29:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2c:	8a 12                	mov    (%edx),%dl
  800e2e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e30:	ff 4d 10             	decl   0x10(%ebp)
  800e33:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e37:	74 09                	je     800e42 <strlcpy+0x3c>
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 d8                	jne    800e1a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4e:	29 c2                	sub    %eax,%edx
  800e50:	89 d0                	mov    %edx,%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e57:	eb 06                	jmp    800e5f <strcmp+0xb>
		p++, q++;
  800e59:	ff 45 08             	incl   0x8(%ebp)
  800e5c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	84 c0                	test   %al,%al
  800e66:	74 0e                	je     800e76 <strcmp+0x22>
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8a 10                	mov    (%eax),%dl
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	38 c2                	cmp    %al,%dl
  800e74:	74 e3                	je     800e59 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	0f b6 d0             	movzbl %al,%edx
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	8a 00                	mov    (%eax),%al
  800e83:	0f b6 c0             	movzbl %al,%eax
  800e86:	29 c2                	sub    %eax,%edx
  800e88:	89 d0                	mov    %edx,%eax
}
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e8f:	eb 09                	jmp    800e9a <strncmp+0xe>
		n--, p++, q++;
  800e91:	ff 4d 10             	decl   0x10(%ebp)
  800e94:	ff 45 08             	incl   0x8(%ebp)
  800e97:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9e:	74 17                	je     800eb7 <strncmp+0x2b>
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	84 c0                	test   %al,%al
  800ea7:	74 0e                	je     800eb7 <strncmp+0x2b>
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 10                	mov    (%eax),%dl
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	38 c2                	cmp    %al,%dl
  800eb5:	74 da                	je     800e91 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800eb7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebb:	75 07                	jne    800ec4 <strncmp+0x38>
		return 0;
  800ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec2:	eb 14                	jmp    800ed8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	0f b6 d0             	movzbl %al,%edx
  800ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 c0             	movzbl %al,%eax
  800ed4:	29 c2                	sub    %eax,%edx
  800ed6:	89 d0                	mov    %edx,%eax
}
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ee6:	eb 12                	jmp    800efa <strchr+0x20>
		if (*s == c)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef0:	75 05                	jne    800ef7 <strchr+0x1d>
			return (char *) s;
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	eb 11                	jmp    800f08 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 e5                	jne    800ee8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f08:	c9                   	leave  
  800f09:	c3                   	ret    

00800f0a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 04             	sub    $0x4,%esp
  800f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f13:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f16:	eb 0d                	jmp    800f25 <strfind+0x1b>
		if (*s == c)
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	8a 00                	mov    (%eax),%al
  800f1d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f20:	74 0e                	je     800f30 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f22:	ff 45 08             	incl   0x8(%ebp)
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	84 c0                	test   %al,%al
  800f2c:	75 ea                	jne    800f18 <strfind+0xe>
  800f2e:	eb 01                	jmp    800f31 <strfind+0x27>
		if (*s == c)
			break;
  800f30:	90                   	nop
	return (char *) s;
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f34:	c9                   	leave  
  800f35:	c3                   	ret    

00800f36 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f42:	8b 45 10             	mov    0x10(%ebp),%eax
  800f45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f48:	eb 0e                	jmp    800f58 <memset+0x22>
		*p++ = c;
  800f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4d:	8d 50 01             	lea    0x1(%eax),%edx
  800f50:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f56:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f58:	ff 4d f8             	decl   -0x8(%ebp)
  800f5b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f5f:	79 e9                	jns    800f4a <memset+0x14>
		*p++ = c;

	return v;
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f78:	eb 16                	jmp    800f90 <memcpy+0x2a>
		*d++ = *s++;
  800f7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7d:	8d 50 01             	lea    0x1(%eax),%edx
  800f80:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f83:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f89:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f8c:	8a 12                	mov    (%edx),%dl
  800f8e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f90:	8b 45 10             	mov    0x10(%ebp),%eax
  800f93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f96:	89 55 10             	mov    %edx,0x10(%ebp)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	75 dd                	jne    800f7a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa0:	c9                   	leave  
  800fa1:	c3                   	ret    

00800fa2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fba:	73 50                	jae    80100c <memmove+0x6a>
  800fbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	01 d0                	add    %edx,%eax
  800fc4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fc7:	76 43                	jbe    80100c <memmove+0x6a>
		s += n;
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fd5:	eb 10                	jmp    800fe7 <memmove+0x45>
			*--d = *--s;
  800fd7:	ff 4d f8             	decl   -0x8(%ebp)
  800fda:	ff 4d fc             	decl   -0x4(%ebp)
  800fdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe0:	8a 10                	mov    (%eax),%dl
  800fe2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fed:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	75 e3                	jne    800fd7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff4:	eb 23                	jmp    801019 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ff6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff9:	8d 50 01             	lea    0x1(%eax),%edx
  800ffc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801002:	8d 4a 01             	lea    0x1(%edx),%ecx
  801005:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801008:	8a 12                	mov    (%edx),%dl
  80100a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80100c:	8b 45 10             	mov    0x10(%ebp),%eax
  80100f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801012:	89 55 10             	mov    %edx,0x10(%ebp)
  801015:	85 c0                	test   %eax,%eax
  801017:	75 dd                	jne    800ff6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80101c:	c9                   	leave  
  80101d:	c3                   	ret    

0080101e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80101e:	55                   	push   %ebp
  80101f:	89 e5                	mov    %esp,%ebp
  801021:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801030:	eb 2a                	jmp    80105c <memcmp+0x3e>
		if (*s1 != *s2)
  801032:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801035:	8a 10                	mov    (%eax),%dl
  801037:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	38 c2                	cmp    %al,%dl
  80103e:	74 16                	je     801056 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801040:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	0f b6 c0             	movzbl %al,%eax
  801050:	29 c2                	sub    %eax,%edx
  801052:	89 d0                	mov    %edx,%eax
  801054:	eb 18                	jmp    80106e <memcmp+0x50>
		s1++, s2++;
  801056:	ff 45 fc             	incl   -0x4(%ebp)
  801059:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80105c:	8b 45 10             	mov    0x10(%ebp),%eax
  80105f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801062:	89 55 10             	mov    %edx,0x10(%ebp)
  801065:	85 c0                	test   %eax,%eax
  801067:	75 c9                	jne    801032 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801069:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106e:	c9                   	leave  
  80106f:	c3                   	ret    

00801070 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	8b 45 10             	mov    0x10(%ebp),%eax
  80107c:	01 d0                	add    %edx,%eax
  80107e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801081:	eb 15                	jmp    801098 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	0f b6 d0             	movzbl %al,%edx
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	0f b6 c0             	movzbl %al,%eax
  801091:	39 c2                	cmp    %eax,%edx
  801093:	74 0d                	je     8010a2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801095:	ff 45 08             	incl   0x8(%ebp)
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80109e:	72 e3                	jb     801083 <memfind+0x13>
  8010a0:	eb 01                	jmp    8010a3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010a2:	90                   	nop
	return (void *) s;
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a6:	c9                   	leave  
  8010a7:	c3                   	ret    

008010a8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010bc:	eb 03                	jmp    8010c1 <strtol+0x19>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	3c 20                	cmp    $0x20,%al
  8010c8:	74 f4                	je     8010be <strtol+0x16>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	3c 09                	cmp    $0x9,%al
  8010d1:	74 eb                	je     8010be <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 2b                	cmp    $0x2b,%al
  8010da:	75 05                	jne    8010e1 <strtol+0x39>
		s++;
  8010dc:	ff 45 08             	incl   0x8(%ebp)
  8010df:	eb 13                	jmp    8010f4 <strtol+0x4c>
	else if (*s == '-')
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 2d                	cmp    $0x2d,%al
  8010e8:	75 0a                	jne    8010f4 <strtol+0x4c>
		s++, neg = 1;
  8010ea:	ff 45 08             	incl   0x8(%ebp)
  8010ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f8:	74 06                	je     801100 <strtol+0x58>
  8010fa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010fe:	75 20                	jne    801120 <strtol+0x78>
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	3c 30                	cmp    $0x30,%al
  801107:	75 17                	jne    801120 <strtol+0x78>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	40                   	inc    %eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 78                	cmp    $0x78,%al
  801111:	75 0d                	jne    801120 <strtol+0x78>
		s += 2, base = 16;
  801113:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801117:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80111e:	eb 28                	jmp    801148 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801120:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801124:	75 15                	jne    80113b <strtol+0x93>
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 30                	cmp    $0x30,%al
  80112d:	75 0c                	jne    80113b <strtol+0x93>
		s++, base = 8;
  80112f:	ff 45 08             	incl   0x8(%ebp)
  801132:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801139:	eb 0d                	jmp    801148 <strtol+0xa0>
	else if (base == 0)
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	75 07                	jne    801148 <strtol+0xa0>
		base = 10;
  801141:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 2f                	cmp    $0x2f,%al
  80114f:	7e 19                	jle    80116a <strtol+0xc2>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 39                	cmp    $0x39,%al
  801158:	7f 10                	jg     80116a <strtol+0xc2>
			dig = *s - '0';
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	0f be c0             	movsbl %al,%eax
  801162:	83 e8 30             	sub    $0x30,%eax
  801165:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801168:	eb 42                	jmp    8011ac <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 60                	cmp    $0x60,%al
  801171:	7e 19                	jle    80118c <strtol+0xe4>
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 7a                	cmp    $0x7a,%al
  80117a:	7f 10                	jg     80118c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	0f be c0             	movsbl %al,%eax
  801184:	83 e8 57             	sub    $0x57,%eax
  801187:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80118a:	eb 20                	jmp    8011ac <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	3c 40                	cmp    $0x40,%al
  801193:	7e 39                	jle    8011ce <strtol+0x126>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 5a                	cmp    $0x5a,%al
  80119c:	7f 30                	jg     8011ce <strtol+0x126>
			dig = *s - 'A' + 10;
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f be c0             	movsbl %al,%eax
  8011a6:	83 e8 37             	sub    $0x37,%eax
  8011a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011b2:	7d 19                	jge    8011cd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011b4:	ff 45 08             	incl   0x8(%ebp)
  8011b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ba:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011be:	89 c2                	mov    %eax,%edx
  8011c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c3:	01 d0                	add    %edx,%eax
  8011c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011c8:	e9 7b ff ff ff       	jmp    801148 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011cd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d2:	74 08                	je     8011dc <strtol+0x134>
		*endptr = (char *) s;
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011da:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e0:	74 07                	je     8011e9 <strtol+0x141>
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	f7 d8                	neg    %eax
  8011e7:	eb 03                	jmp    8011ec <strtol+0x144>
  8011e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <ltostr>:

void
ltostr(long value, char *str)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801206:	79 13                	jns    80121b <ltostr+0x2d>
	{
		neg = 1;
  801208:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801215:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801218:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801223:	99                   	cltd   
  801224:	f7 f9                	idiv   %ecx
  801226:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801229:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80122c:	8d 50 01             	lea    0x1(%eax),%edx
  80122f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801232:	89 c2                	mov    %eax,%edx
  801234:	8b 45 0c             	mov    0xc(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80123c:	83 c2 30             	add    $0x30,%edx
  80123f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801241:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801244:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801249:	f7 e9                	imul   %ecx
  80124b:	c1 fa 02             	sar    $0x2,%edx
  80124e:	89 c8                	mov    %ecx,%eax
  801250:	c1 f8 1f             	sar    $0x1f,%eax
  801253:	29 c2                	sub    %eax,%edx
  801255:	89 d0                	mov    %edx,%eax
  801257:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80125a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80125e:	75 bb                	jne    80121b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801260:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801267:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126a:	48                   	dec    %eax
  80126b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801272:	74 3d                	je     8012b1 <ltostr+0xc3>
		start = 1 ;
  801274:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127b:	eb 34                	jmp    8012b1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80127d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801280:	8b 45 0c             	mov    0xc(%ebp),%eax
  801283:	01 d0                	add    %edx,%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801290:	01 c2                	add    %eax,%edx
  801292:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801295:	8b 45 0c             	mov    0xc(%ebp),%eax
  801298:	01 c8                	add    %ecx,%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 c2                	add    %eax,%edx
  8012a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b7:	7c c4                	jl     80127d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c4:	90                   	nop
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    

008012c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012cd:	ff 75 08             	pushl  0x8(%ebp)
  8012d0:	e8 73 fa ff ff       	call   800d48 <strlen>
  8012d5:	83 c4 04             	add    $0x4,%esp
  8012d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012db:	ff 75 0c             	pushl  0xc(%ebp)
  8012de:	e8 65 fa ff ff       	call   800d48 <strlen>
  8012e3:	83 c4 04             	add    $0x4,%esp
  8012e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f7:	eb 17                	jmp    801310 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 c2                	add    %eax,%edx
  801301:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	01 c8                	add    %ecx,%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130d:	ff 45 fc             	incl   -0x4(%ebp)
  801310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801313:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801316:	7c e1                	jl     8012f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801318:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80131f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801326:	eb 1f                	jmp    801347 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801328:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132b:	8d 50 01             	lea    0x1(%eax),%edx
  80132e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801331:	89 c2                	mov    %eax,%edx
  801333:	8b 45 10             	mov    0x10(%ebp),%eax
  801336:	01 c2                	add    %eax,%edx
  801338:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c8                	add    %ecx,%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801344:	ff 45 f8             	incl   -0x8(%ebp)
  801347:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134d:	7c d9                	jl     801328 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80134f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c6 00 00             	movb   $0x0,(%eax)
}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801360:	8b 45 14             	mov    0x14(%ebp),%eax
  801363:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801369:	8b 45 14             	mov    0x14(%ebp),%eax
  80136c:	8b 00                	mov    (%eax),%eax
  80136e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801375:	8b 45 10             	mov    0x10(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801380:	eb 0c                	jmp    80138e <strsplit+0x31>
			*string++ = 0;
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8d 50 01             	lea    0x1(%eax),%edx
  801388:	89 55 08             	mov    %edx,0x8(%ebp)
  80138b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	84 c0                	test   %al,%al
  801395:	74 18                	je     8013af <strsplit+0x52>
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	0f be c0             	movsbl %al,%eax
  80139f:	50                   	push   %eax
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	e8 32 fb ff ff       	call   800eda <strchr>
  8013a8:	83 c4 08             	add    $0x8,%esp
  8013ab:	85 c0                	test   %eax,%eax
  8013ad:	75 d3                	jne    801382 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8a 00                	mov    (%eax),%al
  8013b4:	84 c0                	test   %al,%al
  8013b6:	74 5a                	je     801412 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bb:	8b 00                	mov    (%eax),%eax
  8013bd:	83 f8 0f             	cmp    $0xf,%eax
  8013c0:	75 07                	jne    8013c9 <strsplit+0x6c>
		{
			return 0;
  8013c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c7:	eb 66                	jmp    80142f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cc:	8b 00                	mov    (%eax),%eax
  8013ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d4:	89 0a                	mov    %ecx,(%edx)
  8013d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	01 c2                	add    %eax,%edx
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e7:	eb 03                	jmp    8013ec <strsplit+0x8f>
			string++;
  8013e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8a 00                	mov    (%eax),%al
  8013f1:	84 c0                	test   %al,%al
  8013f3:	74 8b                	je     801380 <strsplit+0x23>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	0f be c0             	movsbl %al,%eax
  8013fd:	50                   	push   %eax
  8013fe:	ff 75 0c             	pushl  0xc(%ebp)
  801401:	e8 d4 fa ff ff       	call   800eda <strchr>
  801406:	83 c4 08             	add    $0x8,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	74 dc                	je     8013e9 <strsplit+0x8c>
			string++;
	}
  80140d:	e9 6e ff ff ff       	jmp    801380 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801412:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801413:	8b 45 14             	mov    0x14(%ebp),%eax
  801416:	8b 00                	mov    (%eax),%eax
  801418:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141f:	8b 45 10             	mov    0x10(%ebp),%eax
  801422:	01 d0                	add    %edx,%eax
  801424:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801437:	83 ec 04             	sub    $0x4,%esp
  80143a:	68 c8 25 80 00       	push   $0x8025c8
  80143f:	68 3f 01 00 00       	push   $0x13f
  801444:	68 ea 25 80 00       	push   $0x8025ea
  801449:	e8 a9 ef ff ff       	call   8003f7 <_panic>

0080144e <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801454:	83 ec 0c             	sub    $0xc,%esp
  801457:	ff 75 08             	pushl  0x8(%ebp)
  80145a:	e8 ef 06 00 00       	call   801b4e <sys_sbrk>
  80145f:	83 c4 10             	add    $0x10,%esp
}
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80146a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80146e:	75 07                	jne    801477 <malloc+0x13>
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	eb 14                	jmp    80148b <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801477:	83 ec 04             	sub    $0x4,%esp
  80147a:	68 f8 25 80 00       	push   $0x8025f8
  80147f:	6a 1b                	push   $0x1b
  801481:	68 1d 26 80 00       	push   $0x80261d
  801486:	e8 6c ef ff ff       	call   8003f7 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801493:	83 ec 04             	sub    $0x4,%esp
  801496:	68 2c 26 80 00       	push   $0x80262c
  80149b:	6a 29                	push   $0x29
  80149d:	68 1d 26 80 00       	push   $0x80261d
  8014a2:	e8 50 ef ff ff       	call   8003f7 <_panic>

008014a7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	83 ec 18             	sub    $0x18,%esp
  8014ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b0:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8014b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014b7:	75 07                	jne    8014c0 <smalloc+0x19>
  8014b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8014be:	eb 14                	jmp    8014d4 <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	68 50 26 80 00       	push   $0x802650
  8014c8:	6a 38                	push   $0x38
  8014ca:	68 1d 26 80 00       	push   $0x80261d
  8014cf:	e8 23 ef ff ff       	call   8003f7 <_panic>
	return NULL;
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	68 78 26 80 00       	push   $0x802678
  8014e4:	6a 43                	push   $0x43
  8014e6:	68 1d 26 80 00       	push   $0x80261d
  8014eb:	e8 07 ef ff ff       	call   8003f7 <_panic>

008014f0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014f6:	83 ec 04             	sub    $0x4,%esp
  8014f9:	68 9c 26 80 00       	push   $0x80269c
  8014fe:	6a 5b                	push   $0x5b
  801500:	68 1d 26 80 00       	push   $0x80261d
  801505:	e8 ed ee ff ff       	call   8003f7 <_panic>

0080150a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	68 c0 26 80 00       	push   $0x8026c0
  801518:	6a 72                	push   $0x72
  80151a:	68 1d 26 80 00       	push   $0x80261d
  80151f:	e8 d3 ee ff ff       	call   8003f7 <_panic>

00801524 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80152a:	83 ec 04             	sub    $0x4,%esp
  80152d:	68 e6 26 80 00       	push   $0x8026e6
  801532:	6a 7e                	push   $0x7e
  801534:	68 1d 26 80 00       	push   $0x80261d
  801539:	e8 b9 ee ff ff       	call   8003f7 <_panic>

0080153e <shrink>:

}
void shrink(uint32 newSize)
{
  80153e:	55                   	push   %ebp
  80153f:	89 e5                	mov    %esp,%ebp
  801541:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	68 e6 26 80 00       	push   $0x8026e6
  80154c:	68 83 00 00 00       	push   $0x83
  801551:	68 1d 26 80 00       	push   $0x80261d
  801556:	e8 9c ee ff ff       	call   8003f7 <_panic>

0080155b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801561:	83 ec 04             	sub    $0x4,%esp
  801564:	68 e6 26 80 00       	push   $0x8026e6
  801569:	68 88 00 00 00       	push   $0x88
  80156e:	68 1d 26 80 00       	push   $0x80261d
  801573:	e8 7f ee ff ff       	call   8003f7 <_panic>

00801578 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	57                   	push   %edi
  80157c:	56                   	push   %esi
  80157d:	53                   	push   %ebx
  80157e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	8b 55 0c             	mov    0xc(%ebp),%edx
  801587:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80158a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80158d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801590:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801593:	cd 30                	int    $0x30
  801595:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801598:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	5b                   	pop    %ebx
  80159f:	5e                   	pop    %esi
  8015a0:	5f                   	pop    %edi
  8015a1:	5d                   	pop    %ebp
  8015a2:	c3                   	ret    

008015a3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 04             	sub    $0x4,%esp
  8015a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015af:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	52                   	push   %edx
  8015bb:	ff 75 0c             	pushl  0xc(%ebp)
  8015be:	50                   	push   %eax
  8015bf:	6a 00                	push   $0x0
  8015c1:	e8 b2 ff ff ff       	call   801578 <syscall>
  8015c6:	83 c4 18             	add    $0x18,%esp
}
  8015c9:	90                   	nop
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <sys_cgetc>:

int
sys_cgetc(void)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 02                	push   $0x2
  8015db:	e8 98 ff ff ff       	call   801578 <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 03                	push   $0x3
  8015f4:	e8 7f ff ff ff       	call   801578 <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
}
  8015fc:	90                   	nop
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 04                	push   $0x4
  80160e:	e8 65 ff ff ff       	call   801578 <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
}
  801616:	90                   	nop
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80161c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	52                   	push   %edx
  801629:	50                   	push   %eax
  80162a:	6a 08                	push   $0x8
  80162c:	e8 47 ff ff ff       	call   801578 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	56                   	push   %esi
  80163a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80163b:	8b 75 18             	mov    0x18(%ebp),%esi
  80163e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801641:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801644:	8b 55 0c             	mov    0xc(%ebp),%edx
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	56                   	push   %esi
  80164b:	53                   	push   %ebx
  80164c:	51                   	push   %ecx
  80164d:	52                   	push   %edx
  80164e:	50                   	push   %eax
  80164f:	6a 09                	push   $0x9
  801651:	e8 22 ff ff ff       	call   801578 <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80165c:	5b                   	pop    %ebx
  80165d:	5e                   	pop    %esi
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    

00801660 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801663:	8b 55 0c             	mov    0xc(%ebp),%edx
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	52                   	push   %edx
  801670:	50                   	push   %eax
  801671:	6a 0a                	push   $0xa
  801673:	e8 00 ff ff ff       	call   801578 <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	ff 75 0c             	pushl  0xc(%ebp)
  801689:	ff 75 08             	pushl  0x8(%ebp)
  80168c:	6a 0b                	push   $0xb
  80168e:	e8 e5 fe ff ff       	call   801578 <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 0c                	push   $0xc
  8016a7:	e8 cc fe ff ff       	call   801578 <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 0d                	push   $0xd
  8016c0:	e8 b3 fe ff ff       	call   801578 <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 0e                	push   $0xe
  8016d9:	e8 9a fe ff ff       	call   801578 <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 0f                	push   $0xf
  8016f2:	e8 81 fe ff ff       	call   801578 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	ff 75 08             	pushl  0x8(%ebp)
  80170a:	6a 10                	push   $0x10
  80170c:	e8 67 fe ff ff       	call   801578 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 11                	push   $0x11
  801725:	e8 4e fe ff ff       	call   801578 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	90                   	nop
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_cputc>:

void
sys_cputc(const char c)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 04             	sub    $0x4,%esp
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80173c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	50                   	push   %eax
  801749:	6a 01                	push   $0x1
  80174b:	e8 28 fe ff ff       	call   801578 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	90                   	nop
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 14                	push   $0x14
  801765:	e8 0e fe ff ff       	call   801578 <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
}
  80176d:	90                   	nop
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 04             	sub    $0x4,%esp
  801776:	8b 45 10             	mov    0x10(%ebp),%eax
  801779:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80177c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80177f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	6a 00                	push   $0x0
  801788:	51                   	push   %ecx
  801789:	52                   	push   %edx
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	50                   	push   %eax
  80178e:	6a 15                	push   $0x15
  801790:	e8 e3 fd ff ff       	call   801578 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80179d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	52                   	push   %edx
  8017aa:	50                   	push   %eax
  8017ab:	6a 16                	push   $0x16
  8017ad:	e8 c6 fd ff ff       	call   801578 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	51                   	push   %ecx
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	6a 17                	push   $0x17
  8017cc:	e8 a7 fd ff ff       	call   801578 <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	52                   	push   %edx
  8017e6:	50                   	push   %eax
  8017e7:	6a 18                	push   $0x18
  8017e9:	e8 8a fd ff ff       	call   801578 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	6a 00                	push   $0x0
  8017fb:	ff 75 14             	pushl  0x14(%ebp)
  8017fe:	ff 75 10             	pushl  0x10(%ebp)
  801801:	ff 75 0c             	pushl  0xc(%ebp)
  801804:	50                   	push   %eax
  801805:	6a 19                	push   $0x19
  801807:	e8 6c fd ff ff       	call   801578 <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	50                   	push   %eax
  801820:	6a 1a                	push   $0x1a
  801822:	e8 51 fd ff ff       	call   801578 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	90                   	nop
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	50                   	push   %eax
  80183c:	6a 1b                	push   $0x1b
  80183e:	e8 35 fd ff ff       	call   801578 <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 05                	push   $0x5
  801857:	e8 1c fd ff ff       	call   801578 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 06                	push   $0x6
  801870:	e8 03 fd ff ff       	call   801578 <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 07                	push   $0x7
  801889:	e8 ea fc ff ff       	call   801578 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_exit_env>:


void sys_exit_env(void)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 1c                	push   $0x1c
  8018a2:	e8 d1 fc ff ff       	call   801578 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	90                   	nop
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018b3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018b6:	8d 50 04             	lea    0x4(%eax),%edx
  8018b9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 1d                	push   $0x1d
  8018c6:	e8 ad fc ff ff       	call   801578 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
	return result;
  8018ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d7:	89 01                	mov    %eax,(%ecx)
  8018d9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	c9                   	leave  
  8018e0:	c2 04 00             	ret    $0x4

008018e3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	ff 75 10             	pushl  0x10(%ebp)
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	6a 13                	push   $0x13
  8018f5:	e8 7e fc ff ff       	call   801578 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fd:	90                   	nop
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_rcr2>:
uint32 sys_rcr2()
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 1e                	push   $0x1e
  80190f:	e8 64 fc ff ff       	call   801578 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801925:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	50                   	push   %eax
  801932:	6a 1f                	push   $0x1f
  801934:	e8 3f fc ff ff       	call   801578 <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
	return ;
  80193c:	90                   	nop
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <rsttst>:
void rsttst()
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 21                	push   $0x21
  80194e:	e8 25 fc ff ff       	call   801578 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
	return ;
  801956:	90                   	nop
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	8b 45 14             	mov    0x14(%ebp),%eax
  801962:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801965:	8b 55 18             	mov    0x18(%ebp),%edx
  801968:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80196c:	52                   	push   %edx
  80196d:	50                   	push   %eax
  80196e:	ff 75 10             	pushl  0x10(%ebp)
  801971:	ff 75 0c             	pushl  0xc(%ebp)
  801974:	ff 75 08             	pushl  0x8(%ebp)
  801977:	6a 20                	push   $0x20
  801979:	e8 fa fb ff ff       	call   801578 <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
	return ;
  801981:	90                   	nop
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <chktst>:
void chktst(uint32 n)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	6a 22                	push   $0x22
  801994:	e8 df fb ff ff       	call   801578 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
	return ;
  80199c:	90                   	nop
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <inctst>:

void inctst()
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 23                	push   $0x23
  8019ae:	e8 c5 fb ff ff       	call   801578 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b6:	90                   	nop
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <gettst>:
uint32 gettst()
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 24                	push   $0x24
  8019c8:	e8 ab fb ff ff       	call   801578 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 25                	push   $0x25
  8019e4:	e8 8f fb ff ff       	call   801578 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
  8019ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019ef:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019f3:	75 07                	jne    8019fc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fa:	eb 05                	jmp    801a01 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 25                	push   $0x25
  801a15:	e8 5e fb ff ff       	call   801578 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
  801a1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a20:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a24:	75 07                	jne    801a2d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a26:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2b:	eb 05                	jmp    801a32 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 25                	push   $0x25
  801a46:	e8 2d fb ff ff       	call   801578 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
  801a4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a51:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a55:	75 07                	jne    801a5e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a57:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5c:	eb 05                	jmp    801a63 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 25                	push   $0x25
  801a77:	e8 fc fa ff ff       	call   801578 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
  801a7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a82:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a86:	75 07                	jne    801a8f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a88:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8d:	eb 05                	jmp    801a94 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	ff 75 08             	pushl  0x8(%ebp)
  801aa4:	6a 26                	push   $0x26
  801aa6:	e8 cd fa ff ff       	call   801578 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
	return ;
  801aae:	90                   	nop
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ab5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	53                   	push   %ebx
  801ac4:	51                   	push   %ecx
  801ac5:	52                   	push   %edx
  801ac6:	50                   	push   %eax
  801ac7:	6a 27                	push   $0x27
  801ac9:	e8 aa fa ff ff       	call   801578 <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	52                   	push   %edx
  801ae6:	50                   	push   %eax
  801ae7:	6a 28                	push   $0x28
  801ae9:	e8 8a fa ff ff       	call   801578 <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801af6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afc:	8b 45 08             	mov    0x8(%ebp),%eax
  801aff:	6a 00                	push   $0x0
  801b01:	51                   	push   %ecx
  801b02:	ff 75 10             	pushl  0x10(%ebp)
  801b05:	52                   	push   %edx
  801b06:	50                   	push   %eax
  801b07:	6a 29                	push   $0x29
  801b09:	e8 6a fa ff ff       	call   801578 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	ff 75 10             	pushl  0x10(%ebp)
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	ff 75 08             	pushl  0x8(%ebp)
  801b23:	6a 12                	push   $0x12
  801b25:	e8 4e fa ff ff       	call   801578 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2d:	90                   	nop
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	52                   	push   %edx
  801b40:	50                   	push   %eax
  801b41:	6a 2a                	push   $0x2a
  801b43:	e8 30 fa ff ff       	call   801578 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
	return;
  801b4b:	90                   	nop
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b54:	83 ec 04             	sub    $0x4,%esp
  801b57:	68 f6 26 80 00       	push   $0x8026f6
  801b5c:	68 2e 01 00 00       	push   $0x12e
  801b61:	68 0a 27 80 00       	push   $0x80270a
  801b66:	e8 8c e8 ff ff       	call   8003f7 <_panic>

00801b6b <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b71:	83 ec 04             	sub    $0x4,%esp
  801b74:	68 f6 26 80 00       	push   $0x8026f6
  801b79:	68 35 01 00 00       	push   $0x135
  801b7e:	68 0a 27 80 00       	push   $0x80270a
  801b83:	e8 6f e8 ff ff       	call   8003f7 <_panic>

00801b88 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801b8e:	83 ec 04             	sub    $0x4,%esp
  801b91:	68 f6 26 80 00       	push   $0x8026f6
  801b96:	68 3b 01 00 00       	push   $0x13b
  801b9b:	68 0a 27 80 00       	push   $0x80270a
  801ba0:	e8 52 e8 ff ff       	call   8003f7 <_panic>
  801ba5:	66 90                	xchg   %ax,%ax
  801ba7:	90                   	nop

00801ba8 <__udivdi3>:
  801ba8:	55                   	push   %ebp
  801ba9:	57                   	push   %edi
  801baa:	56                   	push   %esi
  801bab:	53                   	push   %ebx
  801bac:	83 ec 1c             	sub    $0x1c,%esp
  801baf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bb3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bbb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bbf:	89 ca                	mov    %ecx,%edx
  801bc1:	89 f8                	mov    %edi,%eax
  801bc3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bc7:	85 f6                	test   %esi,%esi
  801bc9:	75 2d                	jne    801bf8 <__udivdi3+0x50>
  801bcb:	39 cf                	cmp    %ecx,%edi
  801bcd:	77 65                	ja     801c34 <__udivdi3+0x8c>
  801bcf:	89 fd                	mov    %edi,%ebp
  801bd1:	85 ff                	test   %edi,%edi
  801bd3:	75 0b                	jne    801be0 <__udivdi3+0x38>
  801bd5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bda:	31 d2                	xor    %edx,%edx
  801bdc:	f7 f7                	div    %edi
  801bde:	89 c5                	mov    %eax,%ebp
  801be0:	31 d2                	xor    %edx,%edx
  801be2:	89 c8                	mov    %ecx,%eax
  801be4:	f7 f5                	div    %ebp
  801be6:	89 c1                	mov    %eax,%ecx
  801be8:	89 d8                	mov    %ebx,%eax
  801bea:	f7 f5                	div    %ebp
  801bec:	89 cf                	mov    %ecx,%edi
  801bee:	89 fa                	mov    %edi,%edx
  801bf0:	83 c4 1c             	add    $0x1c,%esp
  801bf3:	5b                   	pop    %ebx
  801bf4:	5e                   	pop    %esi
  801bf5:	5f                   	pop    %edi
  801bf6:	5d                   	pop    %ebp
  801bf7:	c3                   	ret    
  801bf8:	39 ce                	cmp    %ecx,%esi
  801bfa:	77 28                	ja     801c24 <__udivdi3+0x7c>
  801bfc:	0f bd fe             	bsr    %esi,%edi
  801bff:	83 f7 1f             	xor    $0x1f,%edi
  801c02:	75 40                	jne    801c44 <__udivdi3+0x9c>
  801c04:	39 ce                	cmp    %ecx,%esi
  801c06:	72 0a                	jb     801c12 <__udivdi3+0x6a>
  801c08:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c0c:	0f 87 9e 00 00 00    	ja     801cb0 <__udivdi3+0x108>
  801c12:	b8 01 00 00 00       	mov    $0x1,%eax
  801c17:	89 fa                	mov    %edi,%edx
  801c19:	83 c4 1c             	add    $0x1c,%esp
  801c1c:	5b                   	pop    %ebx
  801c1d:	5e                   	pop    %esi
  801c1e:	5f                   	pop    %edi
  801c1f:	5d                   	pop    %ebp
  801c20:	c3                   	ret    
  801c21:	8d 76 00             	lea    0x0(%esi),%esi
  801c24:	31 ff                	xor    %edi,%edi
  801c26:	31 c0                	xor    %eax,%eax
  801c28:	89 fa                	mov    %edi,%edx
  801c2a:	83 c4 1c             	add    $0x1c,%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5f                   	pop    %edi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    
  801c32:	66 90                	xchg   %ax,%ax
  801c34:	89 d8                	mov    %ebx,%eax
  801c36:	f7 f7                	div    %edi
  801c38:	31 ff                	xor    %edi,%edi
  801c3a:	89 fa                	mov    %edi,%edx
  801c3c:	83 c4 1c             	add    $0x1c,%esp
  801c3f:	5b                   	pop    %ebx
  801c40:	5e                   	pop    %esi
  801c41:	5f                   	pop    %edi
  801c42:	5d                   	pop    %ebp
  801c43:	c3                   	ret    
  801c44:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c49:	89 eb                	mov    %ebp,%ebx
  801c4b:	29 fb                	sub    %edi,%ebx
  801c4d:	89 f9                	mov    %edi,%ecx
  801c4f:	d3 e6                	shl    %cl,%esi
  801c51:	89 c5                	mov    %eax,%ebp
  801c53:	88 d9                	mov    %bl,%cl
  801c55:	d3 ed                	shr    %cl,%ebp
  801c57:	89 e9                	mov    %ebp,%ecx
  801c59:	09 f1                	or     %esi,%ecx
  801c5b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c5f:	89 f9                	mov    %edi,%ecx
  801c61:	d3 e0                	shl    %cl,%eax
  801c63:	89 c5                	mov    %eax,%ebp
  801c65:	89 d6                	mov    %edx,%esi
  801c67:	88 d9                	mov    %bl,%cl
  801c69:	d3 ee                	shr    %cl,%esi
  801c6b:	89 f9                	mov    %edi,%ecx
  801c6d:	d3 e2                	shl    %cl,%edx
  801c6f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c73:	88 d9                	mov    %bl,%cl
  801c75:	d3 e8                	shr    %cl,%eax
  801c77:	09 c2                	or     %eax,%edx
  801c79:	89 d0                	mov    %edx,%eax
  801c7b:	89 f2                	mov    %esi,%edx
  801c7d:	f7 74 24 0c          	divl   0xc(%esp)
  801c81:	89 d6                	mov    %edx,%esi
  801c83:	89 c3                	mov    %eax,%ebx
  801c85:	f7 e5                	mul    %ebp
  801c87:	39 d6                	cmp    %edx,%esi
  801c89:	72 19                	jb     801ca4 <__udivdi3+0xfc>
  801c8b:	74 0b                	je     801c98 <__udivdi3+0xf0>
  801c8d:	89 d8                	mov    %ebx,%eax
  801c8f:	31 ff                	xor    %edi,%edi
  801c91:	e9 58 ff ff ff       	jmp    801bee <__udivdi3+0x46>
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c9c:	89 f9                	mov    %edi,%ecx
  801c9e:	d3 e2                	shl    %cl,%edx
  801ca0:	39 c2                	cmp    %eax,%edx
  801ca2:	73 e9                	jae    801c8d <__udivdi3+0xe5>
  801ca4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ca7:	31 ff                	xor    %edi,%edi
  801ca9:	e9 40 ff ff ff       	jmp    801bee <__udivdi3+0x46>
  801cae:	66 90                	xchg   %ax,%ax
  801cb0:	31 c0                	xor    %eax,%eax
  801cb2:	e9 37 ff ff ff       	jmp    801bee <__udivdi3+0x46>
  801cb7:	90                   	nop

00801cb8 <__umoddi3>:
  801cb8:	55                   	push   %ebp
  801cb9:	57                   	push   %edi
  801cba:	56                   	push   %esi
  801cbb:	53                   	push   %ebx
  801cbc:	83 ec 1c             	sub    $0x1c,%esp
  801cbf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cc3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ccb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ccf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cd3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cd7:	89 f3                	mov    %esi,%ebx
  801cd9:	89 fa                	mov    %edi,%edx
  801cdb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cdf:	89 34 24             	mov    %esi,(%esp)
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	75 1a                	jne    801d00 <__umoddi3+0x48>
  801ce6:	39 f7                	cmp    %esi,%edi
  801ce8:	0f 86 a2 00 00 00    	jbe    801d90 <__umoddi3+0xd8>
  801cee:	89 c8                	mov    %ecx,%eax
  801cf0:	89 f2                	mov    %esi,%edx
  801cf2:	f7 f7                	div    %edi
  801cf4:	89 d0                	mov    %edx,%eax
  801cf6:	31 d2                	xor    %edx,%edx
  801cf8:	83 c4 1c             	add    $0x1c,%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5f                   	pop    %edi
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    
  801d00:	39 f0                	cmp    %esi,%eax
  801d02:	0f 87 ac 00 00 00    	ja     801db4 <__umoddi3+0xfc>
  801d08:	0f bd e8             	bsr    %eax,%ebp
  801d0b:	83 f5 1f             	xor    $0x1f,%ebp
  801d0e:	0f 84 ac 00 00 00    	je     801dc0 <__umoddi3+0x108>
  801d14:	bf 20 00 00 00       	mov    $0x20,%edi
  801d19:	29 ef                	sub    %ebp,%edi
  801d1b:	89 fe                	mov    %edi,%esi
  801d1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d21:	89 e9                	mov    %ebp,%ecx
  801d23:	d3 e0                	shl    %cl,%eax
  801d25:	89 d7                	mov    %edx,%edi
  801d27:	89 f1                	mov    %esi,%ecx
  801d29:	d3 ef                	shr    %cl,%edi
  801d2b:	09 c7                	or     %eax,%edi
  801d2d:	89 e9                	mov    %ebp,%ecx
  801d2f:	d3 e2                	shl    %cl,%edx
  801d31:	89 14 24             	mov    %edx,(%esp)
  801d34:	89 d8                	mov    %ebx,%eax
  801d36:	d3 e0                	shl    %cl,%eax
  801d38:	89 c2                	mov    %eax,%edx
  801d3a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d3e:	d3 e0                	shl    %cl,%eax
  801d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d44:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d48:	89 f1                	mov    %esi,%ecx
  801d4a:	d3 e8                	shr    %cl,%eax
  801d4c:	09 d0                	or     %edx,%eax
  801d4e:	d3 eb                	shr    %cl,%ebx
  801d50:	89 da                	mov    %ebx,%edx
  801d52:	f7 f7                	div    %edi
  801d54:	89 d3                	mov    %edx,%ebx
  801d56:	f7 24 24             	mull   (%esp)
  801d59:	89 c6                	mov    %eax,%esi
  801d5b:	89 d1                	mov    %edx,%ecx
  801d5d:	39 d3                	cmp    %edx,%ebx
  801d5f:	0f 82 87 00 00 00    	jb     801dec <__umoddi3+0x134>
  801d65:	0f 84 91 00 00 00    	je     801dfc <__umoddi3+0x144>
  801d6b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d6f:	29 f2                	sub    %esi,%edx
  801d71:	19 cb                	sbb    %ecx,%ebx
  801d73:	89 d8                	mov    %ebx,%eax
  801d75:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d79:	d3 e0                	shl    %cl,%eax
  801d7b:	89 e9                	mov    %ebp,%ecx
  801d7d:	d3 ea                	shr    %cl,%edx
  801d7f:	09 d0                	or     %edx,%eax
  801d81:	89 e9                	mov    %ebp,%ecx
  801d83:	d3 eb                	shr    %cl,%ebx
  801d85:	89 da                	mov    %ebx,%edx
  801d87:	83 c4 1c             	add    $0x1c,%esp
  801d8a:	5b                   	pop    %ebx
  801d8b:	5e                   	pop    %esi
  801d8c:	5f                   	pop    %edi
  801d8d:	5d                   	pop    %ebp
  801d8e:	c3                   	ret    
  801d8f:	90                   	nop
  801d90:	89 fd                	mov    %edi,%ebp
  801d92:	85 ff                	test   %edi,%edi
  801d94:	75 0b                	jne    801da1 <__umoddi3+0xe9>
  801d96:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9b:	31 d2                	xor    %edx,%edx
  801d9d:	f7 f7                	div    %edi
  801d9f:	89 c5                	mov    %eax,%ebp
  801da1:	89 f0                	mov    %esi,%eax
  801da3:	31 d2                	xor    %edx,%edx
  801da5:	f7 f5                	div    %ebp
  801da7:	89 c8                	mov    %ecx,%eax
  801da9:	f7 f5                	div    %ebp
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	e9 44 ff ff ff       	jmp    801cf6 <__umoddi3+0x3e>
  801db2:	66 90                	xchg   %ax,%ax
  801db4:	89 c8                	mov    %ecx,%eax
  801db6:	89 f2                	mov    %esi,%edx
  801db8:	83 c4 1c             	add    $0x1c,%esp
  801dbb:	5b                   	pop    %ebx
  801dbc:	5e                   	pop    %esi
  801dbd:	5f                   	pop    %edi
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    
  801dc0:	3b 04 24             	cmp    (%esp),%eax
  801dc3:	72 06                	jb     801dcb <__umoddi3+0x113>
  801dc5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dc9:	77 0f                	ja     801dda <__umoddi3+0x122>
  801dcb:	89 f2                	mov    %esi,%edx
  801dcd:	29 f9                	sub    %edi,%ecx
  801dcf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dd3:	89 14 24             	mov    %edx,(%esp)
  801dd6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dda:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dde:	8b 14 24             	mov    (%esp),%edx
  801de1:	83 c4 1c             	add    $0x1c,%esp
  801de4:	5b                   	pop    %ebx
  801de5:	5e                   	pop    %esi
  801de6:	5f                   	pop    %edi
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    
  801de9:	8d 76 00             	lea    0x0(%esi),%esi
  801dec:	2b 04 24             	sub    (%esp),%eax
  801def:	19 fa                	sbb    %edi,%edx
  801df1:	89 d1                	mov    %edx,%ecx
  801df3:	89 c6                	mov    %eax,%esi
  801df5:	e9 71 ff ff ff       	jmp    801d6b <__umoddi3+0xb3>
  801dfa:	66 90                	xchg   %ax,%ax
  801dfc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e00:	72 ea                	jb     801dec <__umoddi3+0x134>
  801e02:	89 d9                	mov    %ebx,%ecx
  801e04:	e9 62 ff ff ff       	jmp    801d6b <__umoddi3+0xb3>
