
obj/user/quicksort_semaphore:     file format elf32-i386


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
  800031:	e8 3b 06 00 00       	call   800671 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);
struct semaphore IO_CS ;
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 34 01 00 00    	sub    $0x134,%esp
	int envID = sys_getenvid();
  800042:	e8 ba 21 00 00       	call   802201 <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  80004a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	IO_CS = create_semaphore("IO.CS", 1);
  800051:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	6a 01                	push   $0x1
  80005c:	68 e0 42 80 00       	push   $0x8042e0
  800061:	50                   	push   %eax
  800062:	e8 8c 3f 00 00       	call   803ff3 <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 44 50 80 00       	mov    %eax,0x805044
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 d7 1f 00 00       	call   802051 <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 e9 1f 00 00       	call   80206a <sys_calculate_modified_frames>
  800081:	01 d8                	add    %ebx,%eax
  800083:	89 45 ec             	mov    %eax,-0x14(%ebp)

		Iteration++ ;
  800086:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_lock_cons();
		int NumOfElements, *Elements;
		wait_semaphore(IO_CS);
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	ff 35 44 50 80 00    	pushl  0x805044
  800092:	e8 90 3f 00 00       	call   804027 <wait_semaphore>
  800097:	83 c4 10             	add    $0x10,%esp
		{
			readline("Enter the number of elements: ", Line);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 e8 42 80 00       	push   $0x8042e8
  8000a9:	e8 53 10 00 00       	call   801101 <readline>
  8000ae:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	6a 0a                	push   $0xa
  8000b6:	6a 00                	push   $0x0
  8000b8:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 a5 15 00 00       	call   801669 <strtol>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c1 e0 02             	shl    $0x2,%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 4c 19 00 00       	call   801a25 <malloc>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 08 43 80 00       	push   $0x804308
  8000e7:	e8 81 09 00 00       	call   800a6d <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 2b 43 80 00       	push   $0x80432b
  8000f7:	e8 71 09 00 00       	call   800a6d <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 39 43 80 00       	push   $0x804339
  800107:	e8 61 09 00 00       	call   800a6d <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 48 43 80 00       	push   $0x804348
  800117:	e8 51 09 00 00       	call   800a6d <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 58 43 80 00       	push   $0x804358
  800127:	e8 41 09 00 00       	call   800a6d <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  80012f:	e8 20 05 00 00       	call   800654 <getchar>
  800134:	88 45 e3             	mov    %al,-0x1d(%ebp)
				cputchar(Chose);
  800137:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 f1 04 00 00       	call   800635 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 e4 04 00 00       	call   800635 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
			} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>

		}
		signal_semaphore(IO_CS);
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 35 44 50 80 00    	pushl  0x805044
  80016f:	e8 cd 3e 00 00       	call   804041 <signal_semaphore>
  800174:	83 c4 10             	add    $0x10,%esp

		//sys_unlock_cons();
		int  i ;
		switch (Chose)
  800177:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80017b:	83 f8 62             	cmp    $0x62,%eax
  80017e:	74 1d                	je     80019d <_main+0x165>
  800180:	83 f8 63             	cmp    $0x63,%eax
  800183:	74 2b                	je     8001b0 <_main+0x178>
  800185:	83 f8 61             	cmp    $0x61,%eax
  800188:	75 39                	jne    8001c3 <_main+0x18b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80018a:	83 ec 08             	sub    $0x8,%esp
  80018d:	ff 75 e8             	pushl  -0x18(%ebp)
  800190:	ff 75 e4             	pushl  -0x1c(%ebp)
  800193:	e8 2e 03 00 00       	call   8004c6 <InitializeAscending>
  800198:	83 c4 10             	add    $0x10,%esp
			break ;
  80019b:	eb 37                	jmp    8001d4 <_main+0x19c>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80019d:	83 ec 08             	sub    $0x8,%esp
  8001a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001a6:	e8 4c 03 00 00       	call   8004f7 <InitializeIdentical>
  8001ab:	83 c4 10             	add    $0x10,%esp
			break ;
  8001ae:	eb 24                	jmp    8001d4 <_main+0x19c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b9:	e8 6e 03 00 00       	call   80052c <InitializeSemiRandom>
  8001be:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c1:	eb 11                	jmp    8001d4 <_main+0x19c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cc:	e8 5b 03 00 00       	call   80052c <InitializeSemiRandom>
  8001d1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001dd:	e8 29 01 00 00       	call   80030b <QuickSort>
  8001e2:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8001eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ee:	e8 29 02 00 00       	call   80041c <CheckSorted>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001fd:	75 14                	jne    800213 <_main+0x1db>
  8001ff:	83 ec 04             	sub    $0x4,%esp
  800202:	68 64 43 80 00       	push   $0x804364
  800207:	6a 4d                	push   $0x4d
  800209:	68 86 43 80 00       	push   $0x804386
  80020e:	e8 9d 05 00 00       	call   8007b0 <_panic>
		else
		{
			wait_semaphore(IO_CS);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 35 44 50 80 00    	pushl  0x805044
  80021c:	e8 06 3e 00 00       	call   804027 <wait_semaphore>
  800221:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 a4 43 80 00       	push   $0x8043a4
  80022c:	e8 3c 08 00 00       	call   800a6d <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 d8 43 80 00       	push   $0x8043d8
  80023c:	e8 2c 08 00 00       	call   800a6d <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 0c 44 80 00       	push   $0x80440c
  80024c:	e8 1c 08 00 00       	call   800a6d <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			signal_semaphore(IO_CS);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 35 44 50 80 00    	pushl  0x805044
  80025d:	e8 df 3d 00 00       	call   804041 <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 44 50 80 00    	pushl  0x805044
  80026e:	e8 b4 3d 00 00       	call   804027 <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 3e 44 80 00       	push   $0x80443e
  80027e:	e8 ea 07 00 00       	call   800a6d <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 44 50 80 00    	pushl  0x805044
  80028f:	e8 ad 3d 00 00       	call   804041 <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 44 50 80 00    	pushl  0x805044
  8002a0:	e8 82 3d 00 00       	call   804027 <wait_semaphore>
  8002a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 54 44 80 00       	push   $0x804454
  8002b0:	e8 b8 07 00 00       	call   800a6d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8002b8:	e8 97 03 00 00       	call   800654 <getchar>
  8002bd:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  8002c0:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  8002c4:	83 ec 0c             	sub    $0xc,%esp
  8002c7:	50                   	push   %eax
  8002c8:	e8 68 03 00 00       	call   800635 <cputchar>
  8002cd:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	6a 0a                	push   $0xa
  8002d5:	e8 5b 03 00 00       	call   800635 <cputchar>
  8002da:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002dd:	83 ec 0c             	sub    $0xc,%esp
  8002e0:	6a 0a                	push   $0xa
  8002e2:	e8 4e 03 00 00       	call   800635 <cputchar>
  8002e7:	83 c4 10             	add    $0x10,%esp
	//sys_unlock_cons();
		signal_semaphore(IO_CS);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 35 44 50 80 00    	pushl  0x805044
  8002f3:	e8 49 3d 00 00       	call   804041 <signal_semaphore>
  8002f8:	83 c4 10             	add    $0x10,%esp

	} while (Chose == 'y');
  8002fb:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  8002ff:	0f 84 70 fd ff ff    	je     800075 <_main+0x3d>

}
  800305:	90                   	nop
  800306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	48                   	dec    %eax
  800315:	50                   	push   %eax
  800316:	6a 00                	push   $0x0
  800318:	ff 75 0c             	pushl  0xc(%ebp)
  80031b:	ff 75 08             	pushl  0x8(%ebp)
  80031e:	e8 06 00 00 00       	call   800329 <QSort>
  800323:	83 c4 10             	add    $0x10,%esp
}
  800326:	90                   	nop
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80032f:	8b 45 10             	mov    0x10(%ebp),%eax
  800332:	3b 45 14             	cmp    0x14(%ebp),%eax
  800335:	0f 8d de 00 00 00    	jge    800419 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  80033b:	8b 45 10             	mov    0x10(%ebp),%eax
  80033e:	40                   	inc    %eax
  80033f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800342:	8b 45 14             	mov    0x14(%ebp),%eax
  800345:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800348:	e9 80 00 00 00       	jmp    8003cd <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  80034d:	ff 45 f4             	incl   -0xc(%ebp)
  800350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800353:	3b 45 14             	cmp    0x14(%ebp),%eax
  800356:	7f 2b                	jg     800383 <QSort+0x5a>
  800358:	8b 45 10             	mov    0x10(%ebp),%eax
  80035b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	01 d0                	add    %edx,%eax
  800367:	8b 10                	mov    (%eax),%edx
  800369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	01 c8                	add    %ecx,%eax
  800378:	8b 00                	mov    (%eax),%eax
  80037a:	39 c2                	cmp    %eax,%edx
  80037c:	7d cf                	jge    80034d <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  80037e:	eb 03                	jmp    800383 <QSort+0x5a>
  800380:	ff 4d f0             	decl   -0x10(%ebp)
  800383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800386:	3b 45 10             	cmp    0x10(%ebp),%eax
  800389:	7e 26                	jle    8003b1 <QSort+0x88>
  80038b:	8b 45 10             	mov    0x10(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 d0                	add    %edx,%eax
  80039a:	8b 10                	mov    (%eax),%edx
  80039c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	01 c8                	add    %ecx,%eax
  8003ab:	8b 00                	mov    (%eax),%eax
  8003ad:	39 c2                	cmp    %eax,%edx
  8003af:	7e cf                	jle    800380 <QSort+0x57>

		if (i <= j)
  8003b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003b7:	7f 14                	jg     8003cd <QSort+0xa4>
		{
			Swap(Elements, i, j);
  8003b9:	83 ec 04             	sub    $0x4,%esp
  8003bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	ff 75 08             	pushl  0x8(%ebp)
  8003c5:	e8 a9 00 00 00       	call   800473 <Swap>
  8003ca:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8003cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d3:	0f 8e 77 ff ff ff    	jle    800350 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8003df:	ff 75 10             	pushl  0x10(%ebp)
  8003e2:	ff 75 08             	pushl  0x8(%ebp)
  8003e5:	e8 89 00 00 00       	call   800473 <Swap>
  8003ea:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f0:	48                   	dec    %eax
  8003f1:	50                   	push   %eax
  8003f2:	ff 75 10             	pushl  0x10(%ebp)
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	e8 29 ff ff ff       	call   800329 <QSort>
  800400:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800403:	ff 75 14             	pushl  0x14(%ebp)
  800406:	ff 75 f4             	pushl  -0xc(%ebp)
  800409:	ff 75 0c             	pushl  0xc(%ebp)
  80040c:	ff 75 08             	pushl  0x8(%ebp)
  80040f:	e8 15 ff ff ff       	call   800329 <QSort>
  800414:	83 c4 10             	add    $0x10,%esp
  800417:	eb 01                	jmp    80041a <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800419:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  80041a:	c9                   	leave  
  80041b:	c3                   	ret    

0080041c <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  80041c:	55                   	push   %ebp
  80041d:	89 e5                	mov    %esp,%ebp
  80041f:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  800422:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800429:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800430:	eb 33                	jmp    800465 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800432:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 10                	mov    (%eax),%edx
  800443:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800446:	40                   	inc    %eax
  800447:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c8                	add    %ecx,%eax
  800453:	8b 00                	mov    (%eax),%eax
  800455:	39 c2                	cmp    %eax,%edx
  800457:	7e 09                	jle    800462 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800460:	eb 0c                	jmp    80046e <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800462:	ff 45 f8             	incl   -0x8(%ebp)
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	48                   	dec    %eax
  800469:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80046c:	7f c4                	jg     800432 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80046e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80048d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800490:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c2                	add    %eax,%edx
  80049c:	8b 45 10             	mov    0x10(%ebp),%eax
  80049f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	01 c8                	add    %ecx,%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8004af:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	01 c2                	add    %eax,%edx
  8004be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c1:	89 02                	mov    %eax,(%edx)
}
  8004c3:	90                   	nop
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004d3:	eb 17                	jmp    8004ec <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8004d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	01 c2                	add    %eax,%edx
  8004e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004e7:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004e9:	ff 45 fc             	incl   -0x4(%ebp)
  8004ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f2:	7c e1                	jl     8004d5 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004f4:	90                   	nop
  8004f5:	c9                   	leave  
  8004f6:	c3                   	ret    

008004f7 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
  8004fa:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1b                	jmp    800521 <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 c2                	add    %eax,%edx
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80051b:	48                   	dec    %eax
  80051c:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80051e:	ff 45 fc             	incl   -0x4(%ebp)
  800521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800524:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800527:	7c dd                	jl     800506 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800529:	90                   	nop
  80052a:	c9                   	leave  
  80052b:	c3                   	ret    

0080052c <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  800532:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800535:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80053a:	f7 e9                	imul   %ecx
  80053c:	c1 f9 1f             	sar    $0x1f,%ecx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	29 c8                	sub    %ecx,%eax
  800543:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  800546:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80054a:	75 07                	jne    800553 <InitializeSemiRandom+0x27>
			Repetition = 3;
  80054c:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800553:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80055a:	eb 1e                	jmp    80057a <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  80055c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80055f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80056c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80056f:	99                   	cltd   
  800570:	f7 7d f8             	idivl  -0x8(%ebp)
  800573:	89 d0                	mov    %edx,%eax
  800575:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800577:	ff 45 fc             	incl   -0x4(%ebp)
  80057a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80057d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800580:	7c da                	jl     80055c <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
	}

}
  800582:	90                   	nop
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	int envID = sys_getenvid();
  80058b:	e8 71 1c 00 00       	call   802201 <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 44 50 80 00    	pushl  0x805044
  80059c:	e8 86 3a 00 00       	call   804027 <wait_semaphore>
  8005a1:	83 c4 10             	add    $0x10,%esp
		int i ;
		int NumsPerLine = 20 ;
  8005a4:	c7 45 ec 14 00 00 00 	movl   $0x14,-0x14(%ebp)
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8005ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005b2:	eb 42                	jmp    8005f6 <PrintElements+0x71>
		{
			if (i%NumsPerLine == 0)
  8005b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b7:	99                   	cltd   
  8005b8:	f7 7d ec             	idivl  -0x14(%ebp)
  8005bb:	89 d0                	mov    %edx,%eax
  8005bd:	85 c0                	test   %eax,%eax
  8005bf:	75 10                	jne    8005d1 <PrintElements+0x4c>
				cprintf("\n");
  8005c1:	83 ec 0c             	sub    $0xc,%esp
  8005c4:	68 72 44 80 00       	push   $0x804472
  8005c9:	e8 9f 04 00 00       	call   800a6d <cprintf>
  8005ce:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  8005d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	50                   	push   %eax
  8005e6:	68 74 44 80 00       	push   $0x804474
  8005eb:	e8 7d 04 00 00       	call   800a6d <cprintf>
  8005f0:	83 c4 10             	add    $0x10,%esp
{
	int envID = sys_getenvid();
	wait_semaphore(IO_CS);
		int i ;
		int NumsPerLine = 20 ;
		for (i = 0 ; i < NumOfElements-1 ; i++)
  8005f3:	ff 45 f4             	incl   -0xc(%ebp)
  8005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f9:	48                   	dec    %eax
  8005fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005fd:	7f b5                	jg     8005b4 <PrintElements+0x2f>
		{
			if (i%NumsPerLine == 0)
				cprintf("\n");
			cprintf("%d, ",Elements[i]);
		}
		cprintf("%d\n",Elements[i]);
  8005ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800602:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	01 d0                	add    %edx,%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	50                   	push   %eax
  800614:	68 79 44 80 00       	push   $0x804479
  800619:	e8 4f 04 00 00       	call   800a6d <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(IO_CS);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	ff 35 44 50 80 00    	pushl  0x805044
  80062a:	e8 12 3a 00 00       	call   804041 <signal_semaphore>
  80062f:	83 c4 10             	add    $0x10,%esp
}
  800632:	90                   	nop
  800633:	c9                   	leave  
  800634:	c3                   	ret    

00800635 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800635:	55                   	push   %ebp
  800636:	89 e5                	mov    %esp,%ebp
  800638:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800641:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800645:	83 ec 0c             	sub    $0xc,%esp
  800648:	50                   	push   %eax
  800649:	e8 9b 1a 00 00       	call   8020e9 <sys_cputc>
  80064e:	83 c4 10             	add    $0x10,%esp
}
  800651:	90                   	nop
  800652:	c9                   	leave  
  800653:	c3                   	ret    

00800654 <getchar>:


int
getchar(void)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80065a:	e8 26 19 00 00       	call   801f85 <sys_cgetc>
  80065f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800662:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800665:	c9                   	leave  
  800666:	c3                   	ret    

00800667 <iscons>:

int iscons(int fdnum)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80066a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80066f:	5d                   	pop    %ebp
  800670:	c3                   	ret    

00800671 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800677:	e8 9e 1b 00 00       	call   80221a <sys_getenvindex>
  80067c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80067f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800682:	89 d0                	mov    %edx,%eax
  800684:	c1 e0 03             	shl    $0x3,%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800690:	01 c8                	add    %ecx,%eax
  800692:	01 c0                	add    %eax,%eax
  800694:	01 d0                	add    %edx,%eax
  800696:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80069d:	01 c8                	add    %ecx,%eax
  80069f:	01 d0                	add    %edx,%eax
  8006a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006a6:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006ab:	a1 24 50 80 00       	mov    0x805024,%eax
  8006b0:	8a 40 20             	mov    0x20(%eax),%al
  8006b3:	84 c0                	test   %al,%al
  8006b5:	74 0d                	je     8006c4 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8006b7:	a1 24 50 80 00       	mov    0x805024,%eax
  8006bc:	83 c0 20             	add    $0x20,%eax
  8006bf:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006c8:	7e 0a                	jle    8006d4 <libmain+0x63>
		binaryname = argv[0];
  8006ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	ff 75 0c             	pushl  0xc(%ebp)
  8006da:	ff 75 08             	pushl  0x8(%ebp)
  8006dd:	e8 56 f9 ff ff       	call   800038 <_main>
  8006e2:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8006e5:	e8 b4 18 00 00       	call   801f9e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	68 98 44 80 00       	push   $0x804498
  8006f2:	e8 76 03 00 00       	call   800a6d <cprintf>
  8006f7:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006fa:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ff:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800705:	a1 24 50 80 00       	mov    0x805024,%eax
  80070a:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	52                   	push   %edx
  800714:	50                   	push   %eax
  800715:	68 c0 44 80 00       	push   $0x8044c0
  80071a:	e8 4e 03 00 00       	call   800a6d <cprintf>
  80071f:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800722:	a1 24 50 80 00       	mov    0x805024,%eax
  800727:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  80072d:	a1 24 50 80 00       	mov    0x805024,%eax
  800732:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  800738:	a1 24 50 80 00       	mov    0x805024,%eax
  80073d:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800743:	51                   	push   %ecx
  800744:	52                   	push   %edx
  800745:	50                   	push   %eax
  800746:	68 e8 44 80 00       	push   $0x8044e8
  80074b:	e8 1d 03 00 00       	call   800a6d <cprintf>
  800750:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800753:	a1 24 50 80 00       	mov    0x805024,%eax
  800758:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	50                   	push   %eax
  800762:	68 40 45 80 00       	push   $0x804540
  800767:	e8 01 03 00 00       	call   800a6d <cprintf>
  80076c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80076f:	83 ec 0c             	sub    $0xc,%esp
  800772:	68 98 44 80 00       	push   $0x804498
  800777:	e8 f1 02 00 00       	call   800a6d <cprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80077f:	e8 34 18 00 00       	call   801fb8 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800784:	e8 19 00 00 00       	call   8007a2 <exit>
}
  800789:	90                   	nop
  80078a:	c9                   	leave  
  80078b:	c3                   	ret    

0080078c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	6a 00                	push   $0x0
  800797:	e8 4a 1a 00 00       	call   8021e6 <sys_destroy_env>
  80079c:	83 c4 10             	add    $0x10,%esp
}
  80079f:	90                   	nop
  8007a0:	c9                   	leave  
  8007a1:	c3                   	ret    

008007a2 <exit>:

void
exit(void)
{
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007a8:	e8 9f 1a 00 00       	call   80224c <sys_exit_env>
}
  8007ad:	90                   	nop
  8007ae:	c9                   	leave  
  8007af:	c3                   	ret    

008007b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007b6:	8d 45 10             	lea    0x10(%ebp),%eax
  8007b9:	83 c0 04             	add    $0x4,%eax
  8007bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007bf:	a1 54 50 80 00       	mov    0x805054,%eax
  8007c4:	85 c0                	test   %eax,%eax
  8007c6:	74 16                	je     8007de <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007c8:	a1 54 50 80 00       	mov    0x805054,%eax
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	50                   	push   %eax
  8007d1:	68 54 45 80 00       	push   $0x804554
  8007d6:	e8 92 02 00 00       	call   800a6d <cprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007de:	a1 00 50 80 00       	mov    0x805000,%eax
  8007e3:	ff 75 0c             	pushl  0xc(%ebp)
  8007e6:	ff 75 08             	pushl  0x8(%ebp)
  8007e9:	50                   	push   %eax
  8007ea:	68 59 45 80 00       	push   $0x804559
  8007ef:	e8 79 02 00 00       	call   800a6d <cprintf>
  8007f4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800800:	50                   	push   %eax
  800801:	e8 fc 01 00 00       	call   800a02 <vcprintf>
  800806:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	6a 00                	push   $0x0
  80080e:	68 75 45 80 00       	push   $0x804575
  800813:	e8 ea 01 00 00       	call   800a02 <vcprintf>
  800818:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80081b:	e8 82 ff ff ff       	call   8007a2 <exit>

	// should not return here
	while (1) ;
  800820:	eb fe                	jmp    800820 <_panic+0x70>

00800822 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800828:	a1 24 50 80 00       	mov    0x805024,%eax
  80082d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800833:	8b 45 0c             	mov    0xc(%ebp),%eax
  800836:	39 c2                	cmp    %eax,%edx
  800838:	74 14                	je     80084e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80083a:	83 ec 04             	sub    $0x4,%esp
  80083d:	68 78 45 80 00       	push   $0x804578
  800842:	6a 26                	push   $0x26
  800844:	68 c4 45 80 00       	push   $0x8045c4
  800849:	e8 62 ff ff ff       	call   8007b0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80084e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800855:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80085c:	e9 c5 00 00 00       	jmp    800926 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800864:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	01 d0                	add    %edx,%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	85 c0                	test   %eax,%eax
  800874:	75 08                	jne    80087e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800876:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800879:	e9 a5 00 00 00       	jmp    800923 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80087e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800885:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80088c:	eb 69                	jmp    8008f7 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80088e:	a1 24 50 80 00       	mov    0x805024,%eax
  800893:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  800899:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089c:	89 d0                	mov    %edx,%eax
  80089e:	01 c0                	add    %eax,%eax
  8008a0:	01 d0                	add    %edx,%eax
  8008a2:	c1 e0 03             	shl    $0x3,%eax
  8008a5:	01 c8                	add    %ecx,%eax
  8008a7:	8a 40 04             	mov    0x4(%eax),%al
  8008aa:	84 c0                	test   %al,%al
  8008ac:	75 46                	jne    8008f4 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008ae:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b3:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8008b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008bc:	89 d0                	mov    %edx,%eax
  8008be:	01 c0                	add    %eax,%eax
  8008c0:	01 d0                	add    %edx,%eax
  8008c2:	c1 e0 03             	shl    $0x3,%eax
  8008c5:	01 c8                	add    %ecx,%eax
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008d4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	01 c8                	add    %ecx,%eax
  8008e5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008e7:	39 c2                	cmp    %eax,%edx
  8008e9:	75 09                	jne    8008f4 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008eb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008f2:	eb 15                	jmp    800909 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008f4:	ff 45 e8             	incl   -0x18(%ebp)
  8008f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008fc:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800902:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800905:	39 c2                	cmp    %eax,%edx
  800907:	77 85                	ja     80088e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800909:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80090d:	75 14                	jne    800923 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80090f:	83 ec 04             	sub    $0x4,%esp
  800912:	68 d0 45 80 00       	push   $0x8045d0
  800917:	6a 3a                	push   $0x3a
  800919:	68 c4 45 80 00       	push   $0x8045c4
  80091e:	e8 8d fe ff ff       	call   8007b0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800923:	ff 45 f0             	incl   -0x10(%ebp)
  800926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800929:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80092c:	0f 8c 2f ff ff ff    	jl     800861 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800932:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800939:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800940:	eb 26                	jmp    800968 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800942:	a1 24 50 80 00       	mov    0x805024,%eax
  800947:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80094d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800950:	89 d0                	mov    %edx,%eax
  800952:	01 c0                	add    %eax,%eax
  800954:	01 d0                	add    %edx,%eax
  800956:	c1 e0 03             	shl    $0x3,%eax
  800959:	01 c8                	add    %ecx,%eax
  80095b:	8a 40 04             	mov    0x4(%eax),%al
  80095e:	3c 01                	cmp    $0x1,%al
  800960:	75 03                	jne    800965 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800962:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800965:	ff 45 e0             	incl   -0x20(%ebp)
  800968:	a1 24 50 80 00       	mov    0x805024,%eax
  80096d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800973:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800976:	39 c2                	cmp    %eax,%edx
  800978:	77 c8                	ja     800942 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80097a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80097d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800980:	74 14                	je     800996 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800982:	83 ec 04             	sub    $0x4,%esp
  800985:	68 24 46 80 00       	push   $0x804624
  80098a:	6a 44                	push   $0x44
  80098c:	68 c4 45 80 00       	push   $0x8045c4
  800991:	e8 1a fe ff ff       	call   8007b0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800996:	90                   	nop
  800997:	c9                   	leave  
  800998:	c3                   	ret    

00800999 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80099f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a2:	8b 00                	mov    (%eax),%eax
  8009a4:	8d 48 01             	lea    0x1(%eax),%ecx
  8009a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009aa:	89 0a                	mov    %ecx,(%edx)
  8009ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8009af:	88 d1                	mov    %dl,%cl
  8009b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c2:	75 2c                	jne    8009f0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009c4:	a0 2c 50 80 00       	mov    0x80502c,%al
  8009c9:	0f b6 c0             	movzbl %al,%eax
  8009cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cf:	8b 12                	mov    (%edx),%edx
  8009d1:	89 d1                	mov    %edx,%ecx
  8009d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d6:	83 c2 08             	add    $0x8,%edx
  8009d9:	83 ec 04             	sub    $0x4,%esp
  8009dc:	50                   	push   %eax
  8009dd:	51                   	push   %ecx
  8009de:	52                   	push   %edx
  8009df:	e8 78 15 00 00       	call   801f5c <sys_cputs>
  8009e4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f3:	8b 40 04             	mov    0x4(%eax),%eax
  8009f6:	8d 50 01             	lea    0x1(%eax),%edx
  8009f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009ff:	90                   	nop
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    

00800a02 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a0b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a12:	00 00 00 
	b.cnt = 0;
  800a15:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a1c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	ff 75 08             	pushl  0x8(%ebp)
  800a25:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2b:	50                   	push   %eax
  800a2c:	68 99 09 80 00       	push   $0x800999
  800a31:	e8 11 02 00 00       	call   800c47 <vprintfmt>
  800a36:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a39:	a0 2c 50 80 00       	mov    0x80502c,%al
  800a3e:	0f b6 c0             	movzbl %al,%eax
  800a41:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	50                   	push   %eax
  800a4b:	52                   	push   %edx
  800a4c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a52:	83 c0 08             	add    $0x8,%eax
  800a55:	50                   	push   %eax
  800a56:	e8 01 15 00 00       	call   801f5c <sys_cputs>
  800a5b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a5e:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
	return b.cnt;
  800a65:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a6b:	c9                   	leave  
  800a6c:	c3                   	ret    

00800a6d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a73:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
	va_start(ap, fmt);
  800a7a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 f4             	pushl  -0xc(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	e8 73 ff ff ff       	call   800a02 <vcprintf>
  800a8f:	83 c4 10             	add    $0x10,%esp
  800a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a98:	c9                   	leave  
  800a99:	c3                   	ret    

00800a9a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800aa0:	e8 f9 14 00 00       	call   801f9e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800aa5:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab4:	50                   	push   %eax
  800ab5:	e8 48 ff ff ff       	call   800a02 <vcprintf>
  800aba:	83 c4 10             	add    $0x10,%esp
  800abd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ac0:	e8 f3 14 00 00       	call   801fb8 <sys_unlock_cons>
	return cnt;
  800ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ac8:	c9                   	leave  
  800ac9:	c3                   	ret    

00800aca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	53                   	push   %ebx
  800ace:	83 ec 14             	sub    $0x14,%esp
  800ad1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800add:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ae8:	77 55                	ja     800b3f <printnum+0x75>
  800aea:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aed:	72 05                	jb     800af4 <printnum+0x2a>
  800aef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800af2:	77 4b                	ja     800b3f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800af4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800af7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800afa:	8b 45 18             	mov    0x18(%ebp),%eax
  800afd:	ba 00 00 00 00       	mov    $0x0,%edx
  800b02:	52                   	push   %edx
  800b03:	50                   	push   %eax
  800b04:	ff 75 f4             	pushl  -0xc(%ebp)
  800b07:	ff 75 f0             	pushl  -0x10(%ebp)
  800b0a:	e8 59 35 00 00       	call   804068 <__udivdi3>
  800b0f:	83 c4 10             	add    $0x10,%esp
  800b12:	83 ec 04             	sub    $0x4,%esp
  800b15:	ff 75 20             	pushl  0x20(%ebp)
  800b18:	53                   	push   %ebx
  800b19:	ff 75 18             	pushl  0x18(%ebp)
  800b1c:	52                   	push   %edx
  800b1d:	50                   	push   %eax
  800b1e:	ff 75 0c             	pushl  0xc(%ebp)
  800b21:	ff 75 08             	pushl  0x8(%ebp)
  800b24:	e8 a1 ff ff ff       	call   800aca <printnum>
  800b29:	83 c4 20             	add    $0x20,%esp
  800b2c:	eb 1a                	jmp    800b48 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	ff 75 20             	pushl  0x20(%ebp)
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	ff d0                	call   *%eax
  800b3c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b3f:	ff 4d 1c             	decl   0x1c(%ebp)
  800b42:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b46:	7f e6                	jg     800b2e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b48:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b56:	53                   	push   %ebx
  800b57:	51                   	push   %ecx
  800b58:	52                   	push   %edx
  800b59:	50                   	push   %eax
  800b5a:	e8 19 36 00 00       	call   804178 <__umoddi3>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	05 94 48 80 00       	add    $0x804894,%eax
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	0f be c0             	movsbl %al,%eax
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 0c             	pushl  0xc(%ebp)
  800b72:	50                   	push   %eax
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	ff d0                	call   *%eax
  800b78:	83 c4 10             	add    $0x10,%esp
}
  800b7b:	90                   	nop
  800b7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b84:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b88:	7e 1c                	jle    800ba6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	8d 50 08             	lea    0x8(%eax),%edx
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	89 10                	mov    %edx,(%eax)
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8b 00                	mov    (%eax),%eax
  800b9c:	83 e8 08             	sub    $0x8,%eax
  800b9f:	8b 50 04             	mov    0x4(%eax),%edx
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	eb 40                	jmp    800be6 <getuint+0x65>
	else if (lflag)
  800ba6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800baa:	74 1e                	je     800bca <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	8d 50 04             	lea    0x4(%eax),%edx
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 10                	mov    %edx,(%eax)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	83 e8 04             	sub    $0x4,%eax
  800bc1:	8b 00                	mov    (%eax),%eax
  800bc3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc8:	eb 1c                	jmp    800be6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8b 00                	mov    (%eax),%eax
  800bcf:	8d 50 04             	lea    0x4(%eax),%edx
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	89 10                	mov    %edx,(%eax)
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	8b 00                	mov    (%eax),%eax
  800bdc:	83 e8 04             	sub    $0x4,%eax
  800bdf:	8b 00                	mov    (%eax),%eax
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800beb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bef:	7e 1c                	jle    800c0d <getint+0x25>
		return va_arg(*ap, long long);
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	8b 00                	mov    (%eax),%eax
  800bf6:	8d 50 08             	lea    0x8(%eax),%edx
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	89 10                	mov    %edx,(%eax)
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8b 00                	mov    (%eax),%eax
  800c03:	83 e8 08             	sub    $0x8,%eax
  800c06:	8b 50 04             	mov    0x4(%eax),%edx
  800c09:	8b 00                	mov    (%eax),%eax
  800c0b:	eb 38                	jmp    800c45 <getint+0x5d>
	else if (lflag)
  800c0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c11:	74 1a                	je     800c2d <getint+0x45>
		return va_arg(*ap, long);
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8b 00                	mov    (%eax),%eax
  800c18:	8d 50 04             	lea    0x4(%eax),%edx
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	89 10                	mov    %edx,(%eax)
  800c20:	8b 45 08             	mov    0x8(%ebp),%eax
  800c23:	8b 00                	mov    (%eax),%eax
  800c25:	83 e8 04             	sub    $0x4,%eax
  800c28:	8b 00                	mov    (%eax),%eax
  800c2a:	99                   	cltd   
  800c2b:	eb 18                	jmp    800c45 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8b 00                	mov    (%eax),%eax
  800c32:	8d 50 04             	lea    0x4(%eax),%edx
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	89 10                	mov    %edx,(%eax)
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8b 00                	mov    (%eax),%eax
  800c3f:	83 e8 04             	sub    $0x4,%eax
  800c42:	8b 00                	mov    (%eax),%eax
  800c44:	99                   	cltd   
}
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	56                   	push   %esi
  800c4b:	53                   	push   %ebx
  800c4c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c4f:	eb 17                	jmp    800c68 <vprintfmt+0x21>
			if (ch == '\0')
  800c51:	85 db                	test   %ebx,%ebx
  800c53:	0f 84 c1 03 00 00    	je     80101a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	53                   	push   %ebx
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	ff d0                	call   *%eax
  800c65:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c68:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6b:	8d 50 01             	lea    0x1(%eax),%edx
  800c6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c71:	8a 00                	mov    (%eax),%al
  800c73:	0f b6 d8             	movzbl %al,%ebx
  800c76:	83 fb 25             	cmp    $0x25,%ebx
  800c79:	75 d6                	jne    800c51 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c7b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c7f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c86:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c8d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c94:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ca1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca4:	8a 00                	mov    (%eax),%al
  800ca6:	0f b6 d8             	movzbl %al,%ebx
  800ca9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cac:	83 f8 5b             	cmp    $0x5b,%eax
  800caf:	0f 87 3d 03 00 00    	ja     800ff2 <vprintfmt+0x3ab>
  800cb5:	8b 04 85 b8 48 80 00 	mov    0x8048b8(,%eax,4),%eax
  800cbc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cbe:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cc2:	eb d7                	jmp    800c9b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cc4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cc8:	eb d1                	jmp    800c9b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cd1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cd4:	89 d0                	mov    %edx,%eax
  800cd6:	c1 e0 02             	shl    $0x2,%eax
  800cd9:	01 d0                	add    %edx,%eax
  800cdb:	01 c0                	add    %eax,%eax
  800cdd:	01 d8                	add    %ebx,%eax
  800cdf:	83 e8 30             	sub    $0x30,%eax
  800ce2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ced:	83 fb 2f             	cmp    $0x2f,%ebx
  800cf0:	7e 3e                	jle    800d30 <vprintfmt+0xe9>
  800cf2:	83 fb 39             	cmp    $0x39,%ebx
  800cf5:	7f 39                	jg     800d30 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cf7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cfa:	eb d5                	jmp    800cd1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800cff:	83 c0 04             	add    $0x4,%eax
  800d02:	89 45 14             	mov    %eax,0x14(%ebp)
  800d05:	8b 45 14             	mov    0x14(%ebp),%eax
  800d08:	83 e8 04             	sub    $0x4,%eax
  800d0b:	8b 00                	mov    (%eax),%eax
  800d0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d10:	eb 1f                	jmp    800d31 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d16:	79 83                	jns    800c9b <vprintfmt+0x54>
				width = 0;
  800d18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d1f:	e9 77 ff ff ff       	jmp    800c9b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d24:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d2b:	e9 6b ff ff ff       	jmp    800c9b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d30:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d35:	0f 89 60 ff ff ff    	jns    800c9b <vprintfmt+0x54>
				width = precision, precision = -1;
  800d3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d41:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d48:	e9 4e ff ff ff       	jmp    800c9b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d4d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d50:	e9 46 ff ff ff       	jmp    800c9b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d55:	8b 45 14             	mov    0x14(%ebp),%eax
  800d58:	83 c0 04             	add    $0x4,%eax
  800d5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800d61:	83 e8 04             	sub    $0x4,%eax
  800d64:	8b 00                	mov    (%eax),%eax
  800d66:	83 ec 08             	sub    $0x8,%esp
  800d69:	ff 75 0c             	pushl  0xc(%ebp)
  800d6c:	50                   	push   %eax
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	ff d0                	call   *%eax
  800d72:	83 c4 10             	add    $0x10,%esp
			break;
  800d75:	e9 9b 02 00 00       	jmp    801015 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7d:	83 c0 04             	add    $0x4,%eax
  800d80:	89 45 14             	mov    %eax,0x14(%ebp)
  800d83:	8b 45 14             	mov    0x14(%ebp),%eax
  800d86:	83 e8 04             	sub    $0x4,%eax
  800d89:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d8b:	85 db                	test   %ebx,%ebx
  800d8d:	79 02                	jns    800d91 <vprintfmt+0x14a>
				err = -err;
  800d8f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d91:	83 fb 64             	cmp    $0x64,%ebx
  800d94:	7f 0b                	jg     800da1 <vprintfmt+0x15a>
  800d96:	8b 34 9d 00 47 80 00 	mov    0x804700(,%ebx,4),%esi
  800d9d:	85 f6                	test   %esi,%esi
  800d9f:	75 19                	jne    800dba <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da1:	53                   	push   %ebx
  800da2:	68 a5 48 80 00       	push   $0x8048a5
  800da7:	ff 75 0c             	pushl  0xc(%ebp)
  800daa:	ff 75 08             	pushl  0x8(%ebp)
  800dad:	e8 70 02 00 00       	call   801022 <printfmt>
  800db2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800db5:	e9 5b 02 00 00       	jmp    801015 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dba:	56                   	push   %esi
  800dbb:	68 ae 48 80 00       	push   $0x8048ae
  800dc0:	ff 75 0c             	pushl  0xc(%ebp)
  800dc3:	ff 75 08             	pushl  0x8(%ebp)
  800dc6:	e8 57 02 00 00       	call   801022 <printfmt>
  800dcb:	83 c4 10             	add    $0x10,%esp
			break;
  800dce:	e9 42 02 00 00       	jmp    801015 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd6:	83 c0 04             	add    $0x4,%eax
  800dd9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ddc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ddf:	83 e8 04             	sub    $0x4,%eax
  800de2:	8b 30                	mov    (%eax),%esi
  800de4:	85 f6                	test   %esi,%esi
  800de6:	75 05                	jne    800ded <vprintfmt+0x1a6>
				p = "(null)";
  800de8:	be b1 48 80 00       	mov    $0x8048b1,%esi
			if (width > 0 && padc != '-')
  800ded:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df1:	7e 6d                	jle    800e60 <vprintfmt+0x219>
  800df3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800df7:	74 67                	je     800e60 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dfc:	83 ec 08             	sub    $0x8,%esp
  800dff:	50                   	push   %eax
  800e00:	56                   	push   %esi
  800e01:	e8 26 05 00 00       	call   80132c <strnlen>
  800e06:	83 c4 10             	add    $0x10,%esp
  800e09:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e0c:	eb 16                	jmp    800e24 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e0e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e12:	83 ec 08             	sub    $0x8,%esp
  800e15:	ff 75 0c             	pushl  0xc(%ebp)
  800e18:	50                   	push   %eax
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	ff d0                	call   *%eax
  800e1e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e21:	ff 4d e4             	decl   -0x1c(%ebp)
  800e24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e28:	7f e4                	jg     800e0e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2a:	eb 34                	jmp    800e60 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e30:	74 1c                	je     800e4e <vprintfmt+0x207>
  800e32:	83 fb 1f             	cmp    $0x1f,%ebx
  800e35:	7e 05                	jle    800e3c <vprintfmt+0x1f5>
  800e37:	83 fb 7e             	cmp    $0x7e,%ebx
  800e3a:	7e 12                	jle    800e4e <vprintfmt+0x207>
					putch('?', putdat);
  800e3c:	83 ec 08             	sub    $0x8,%esp
  800e3f:	ff 75 0c             	pushl  0xc(%ebp)
  800e42:	6a 3f                	push   $0x3f
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	ff d0                	call   *%eax
  800e49:	83 c4 10             	add    $0x10,%esp
  800e4c:	eb 0f                	jmp    800e5d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e4e:	83 ec 08             	sub    $0x8,%esp
  800e51:	ff 75 0c             	pushl  0xc(%ebp)
  800e54:	53                   	push   %ebx
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	ff d0                	call   *%eax
  800e5a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e5d:	ff 4d e4             	decl   -0x1c(%ebp)
  800e60:	89 f0                	mov    %esi,%eax
  800e62:	8d 70 01             	lea    0x1(%eax),%esi
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	0f be d8             	movsbl %al,%ebx
  800e6a:	85 db                	test   %ebx,%ebx
  800e6c:	74 24                	je     800e92 <vprintfmt+0x24b>
  800e6e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e72:	78 b8                	js     800e2c <vprintfmt+0x1e5>
  800e74:	ff 4d e0             	decl   -0x20(%ebp)
  800e77:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e7b:	79 af                	jns    800e2c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e7d:	eb 13                	jmp    800e92 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 20                	push   $0x20
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e8f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e92:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e96:	7f e7                	jg     800e7f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e98:	e9 78 01 00 00       	jmp    801015 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea6:	50                   	push   %eax
  800ea7:	e8 3c fd ff ff       	call   800be8 <getint>
  800eac:	83 c4 10             	add    $0x10,%esp
  800eaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebb:	85 d2                	test   %edx,%edx
  800ebd:	79 23                	jns    800ee2 <vprintfmt+0x29b>
				putch('-', putdat);
  800ebf:	83 ec 08             	sub    $0x8,%esp
  800ec2:	ff 75 0c             	pushl  0xc(%ebp)
  800ec5:	6a 2d                	push   $0x2d
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	ff d0                	call   *%eax
  800ecc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed5:	f7 d8                	neg    %eax
  800ed7:	83 d2 00             	adc    $0x0,%edx
  800eda:	f7 da                	neg    %edx
  800edc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ee2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee9:	e9 bc 00 00 00       	jmp    800faa <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800eee:	83 ec 08             	sub    $0x8,%esp
  800ef1:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef7:	50                   	push   %eax
  800ef8:	e8 84 fc ff ff       	call   800b81 <getuint>
  800efd:	83 c4 10             	add    $0x10,%esp
  800f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f03:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f06:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f0d:	e9 98 00 00 00       	jmp    800faa <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f12:	83 ec 08             	sub    $0x8,%esp
  800f15:	ff 75 0c             	pushl  0xc(%ebp)
  800f18:	6a 58                	push   $0x58
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	ff d0                	call   *%eax
  800f1f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f22:	83 ec 08             	sub    $0x8,%esp
  800f25:	ff 75 0c             	pushl  0xc(%ebp)
  800f28:	6a 58                	push   $0x58
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	ff d0                	call   *%eax
  800f2f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	6a 58                	push   $0x58
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	ff d0                	call   *%eax
  800f3f:	83 c4 10             	add    $0x10,%esp
			break;
  800f42:	e9 ce 00 00 00       	jmp    801015 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f47:	83 ec 08             	sub    $0x8,%esp
  800f4a:	ff 75 0c             	pushl  0xc(%ebp)
  800f4d:	6a 30                	push   $0x30
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	ff d0                	call   *%eax
  800f54:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f57:	83 ec 08             	sub    $0x8,%esp
  800f5a:	ff 75 0c             	pushl  0xc(%ebp)
  800f5d:	6a 78                	push   $0x78
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	ff d0                	call   *%eax
  800f64:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f67:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6a:	83 c0 04             	add    $0x4,%eax
  800f6d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f70:	8b 45 14             	mov    0x14(%ebp),%eax
  800f73:	83 e8 04             	sub    $0x4,%eax
  800f76:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f82:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f89:	eb 1f                	jmp    800faa <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f8b:	83 ec 08             	sub    $0x8,%esp
  800f8e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f91:	8d 45 14             	lea    0x14(%ebp),%eax
  800f94:	50                   	push   %eax
  800f95:	e8 e7 fb ff ff       	call   800b81 <getuint>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fa3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800faa:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb1:	83 ec 04             	sub    $0x4,%esp
  800fb4:	52                   	push   %edx
  800fb5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fb8:	50                   	push   %eax
  800fb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbc:	ff 75 f0             	pushl  -0x10(%ebp)
  800fbf:	ff 75 0c             	pushl  0xc(%ebp)
  800fc2:	ff 75 08             	pushl  0x8(%ebp)
  800fc5:	e8 00 fb ff ff       	call   800aca <printnum>
  800fca:	83 c4 20             	add    $0x20,%esp
			break;
  800fcd:	eb 46                	jmp    801015 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fcf:	83 ec 08             	sub    $0x8,%esp
  800fd2:	ff 75 0c             	pushl  0xc(%ebp)
  800fd5:	53                   	push   %ebx
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	ff d0                	call   *%eax
  800fdb:	83 c4 10             	add    $0x10,%esp
			break;
  800fde:	eb 35                	jmp    801015 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800fe0:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800fe7:	eb 2c                	jmp    801015 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800fe9:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
			break;
  800ff0:	eb 23                	jmp    801015 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ff2:	83 ec 08             	sub    $0x8,%esp
  800ff5:	ff 75 0c             	pushl  0xc(%ebp)
  800ff8:	6a 25                	push   $0x25
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	ff d0                	call   *%eax
  800fff:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801002:	ff 4d 10             	decl   0x10(%ebp)
  801005:	eb 03                	jmp    80100a <vprintfmt+0x3c3>
  801007:	ff 4d 10             	decl   0x10(%ebp)
  80100a:	8b 45 10             	mov    0x10(%ebp),%eax
  80100d:	48                   	dec    %eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	3c 25                	cmp    $0x25,%al
  801012:	75 f3                	jne    801007 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801014:	90                   	nop
		}
	}
  801015:	e9 35 fc ff ff       	jmp    800c4f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80101a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80101b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80101e:	5b                   	pop    %ebx
  80101f:	5e                   	pop    %esi
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    

00801022 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801028:	8d 45 10             	lea    0x10(%ebp),%eax
  80102b:	83 c0 04             	add    $0x4,%eax
  80102e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801031:	8b 45 10             	mov    0x10(%ebp),%eax
  801034:	ff 75 f4             	pushl  -0xc(%ebp)
  801037:	50                   	push   %eax
  801038:	ff 75 0c             	pushl  0xc(%ebp)
  80103b:	ff 75 08             	pushl  0x8(%ebp)
  80103e:	e8 04 fc ff ff       	call   800c47 <vprintfmt>
  801043:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801046:	90                   	nop
  801047:	c9                   	leave  
  801048:	c3                   	ret    

00801049 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	8b 40 08             	mov    0x8(%eax),%eax
  801052:	8d 50 01             	lea    0x1(%eax),%edx
  801055:	8b 45 0c             	mov    0xc(%ebp),%eax
  801058:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8b 10                	mov    (%eax),%edx
  801060:	8b 45 0c             	mov    0xc(%ebp),%eax
  801063:	8b 40 04             	mov    0x4(%eax),%eax
  801066:	39 c2                	cmp    %eax,%edx
  801068:	73 12                	jae    80107c <sprintputch+0x33>
		*b->buf++ = ch;
  80106a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106d:	8b 00                	mov    (%eax),%eax
  80106f:	8d 48 01             	lea    0x1(%eax),%ecx
  801072:	8b 55 0c             	mov    0xc(%ebp),%edx
  801075:	89 0a                	mov    %ecx,(%edx)
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	88 10                	mov    %dl,(%eax)
}
  80107c:	90                   	nop
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    

0080107f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	01 d0                	add    %edx,%eax
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a4:	74 06                	je     8010ac <vsnprintf+0x2d>
  8010a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010aa:	7f 07                	jg     8010b3 <vsnprintf+0x34>
		return -E_INVAL;
  8010ac:	b8 03 00 00 00       	mov    $0x3,%eax
  8010b1:	eb 20                	jmp    8010d3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010b3:	ff 75 14             	pushl  0x14(%ebp)
  8010b6:	ff 75 10             	pushl  0x10(%ebp)
  8010b9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010bc:	50                   	push   %eax
  8010bd:	68 49 10 80 00       	push   $0x801049
  8010c2:	e8 80 fb ff ff       	call   800c47 <vprintfmt>
  8010c7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010cd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010db:	8d 45 10             	lea    0x10(%ebp),%eax
  8010de:	83 c0 04             	add    $0x4,%eax
  8010e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ea:	50                   	push   %eax
  8010eb:	ff 75 0c             	pushl  0xc(%ebp)
  8010ee:	ff 75 08             	pushl  0x8(%ebp)
  8010f1:	e8 89 ff ff ff       	call   80107f <vsnprintf>
  8010f6:	83 c4 10             	add    $0x10,%esp
  8010f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801107:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80110b:	74 13                	je     801120 <readline+0x1f>
		cprintf("%s", prompt);
  80110d:	83 ec 08             	sub    $0x8,%esp
  801110:	ff 75 08             	pushl  0x8(%ebp)
  801113:	68 28 4a 80 00       	push   $0x804a28
  801118:	e8 50 f9 ff ff       	call   800a6d <cprintf>
  80111d:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801120:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801127:	83 ec 0c             	sub    $0xc,%esp
  80112a:	6a 00                	push   $0x0
  80112c:	e8 36 f5 ff ff       	call   800667 <iscons>
  801131:	83 c4 10             	add    $0x10,%esp
  801134:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801137:	e8 18 f5 ff ff       	call   800654 <getchar>
  80113c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80113f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801143:	79 22                	jns    801167 <readline+0x66>
			if (c != -E_EOF)
  801145:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801149:	0f 84 ad 00 00 00    	je     8011fc <readline+0xfb>
				cprintf("read error: %e\n", c);
  80114f:	83 ec 08             	sub    $0x8,%esp
  801152:	ff 75 ec             	pushl  -0x14(%ebp)
  801155:	68 2b 4a 80 00       	push   $0x804a2b
  80115a:	e8 0e f9 ff ff       	call   800a6d <cprintf>
  80115f:	83 c4 10             	add    $0x10,%esp
			break;
  801162:	e9 95 00 00 00       	jmp    8011fc <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801167:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80116b:	7e 34                	jle    8011a1 <readline+0xa0>
  80116d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801174:	7f 2b                	jg     8011a1 <readline+0xa0>
			if (echoing)
  801176:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80117a:	74 0e                	je     80118a <readline+0x89>
				cputchar(c);
  80117c:	83 ec 0c             	sub    $0xc,%esp
  80117f:	ff 75 ec             	pushl  -0x14(%ebp)
  801182:	e8 ae f4 ff ff       	call   800635 <cputchar>
  801187:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80118a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118d:	8d 50 01             	lea    0x1(%eax),%edx
  801190:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801193:	89 c2                	mov    %eax,%edx
  801195:	8b 45 0c             	mov    0xc(%ebp),%eax
  801198:	01 d0                	add    %edx,%eax
  80119a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80119d:	88 10                	mov    %dl,(%eax)
  80119f:	eb 56                	jmp    8011f7 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8011a1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8011a5:	75 1f                	jne    8011c6 <readline+0xc5>
  8011a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011ab:	7e 19                	jle    8011c6 <readline+0xc5>
			if (echoing)
  8011ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011b1:	74 0e                	je     8011c1 <readline+0xc0>
				cputchar(c);
  8011b3:	83 ec 0c             	sub    $0xc,%esp
  8011b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8011b9:	e8 77 f4 ff ff       	call   800635 <cputchar>
  8011be:	83 c4 10             	add    $0x10,%esp

			i--;
  8011c1:	ff 4d f4             	decl   -0xc(%ebp)
  8011c4:	eb 31                	jmp    8011f7 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8011c6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011ca:	74 0a                	je     8011d6 <readline+0xd5>
  8011cc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011d0:	0f 85 61 ff ff ff    	jne    801137 <readline+0x36>
			if (echoing)
  8011d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011da:	74 0e                	je     8011ea <readline+0xe9>
				cputchar(c);
  8011dc:	83 ec 0c             	sub    $0xc,%esp
  8011df:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e2:	e8 4e f4 ff ff       	call   800635 <cputchar>
  8011e7:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f0:	01 d0                	add    %edx,%eax
  8011f2:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8011f5:	eb 06                	jmp    8011fd <readline+0xfc>
		}
	}
  8011f7:	e9 3b ff ff ff       	jmp    801137 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8011fc:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8011fd:	90                   	nop
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    

00801200 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801206:	e8 93 0d 00 00       	call   801f9e <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80120b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80120f:	74 13                	je     801224 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	ff 75 08             	pushl  0x8(%ebp)
  801217:	68 28 4a 80 00       	push   $0x804a28
  80121c:	e8 4c f8 ff ff       	call   800a6d <cprintf>
  801221:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  80122b:	83 ec 0c             	sub    $0xc,%esp
  80122e:	6a 00                	push   $0x0
  801230:	e8 32 f4 ff ff       	call   800667 <iscons>
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  80123b:	e8 14 f4 ff ff       	call   800654 <getchar>
  801240:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801243:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801247:	79 22                	jns    80126b <atomic_readline+0x6b>
				if (c != -E_EOF)
  801249:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80124d:	0f 84 ad 00 00 00    	je     801300 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801253:	83 ec 08             	sub    $0x8,%esp
  801256:	ff 75 ec             	pushl  -0x14(%ebp)
  801259:	68 2b 4a 80 00       	push   $0x804a2b
  80125e:	e8 0a f8 ff ff       	call   800a6d <cprintf>
  801263:	83 c4 10             	add    $0x10,%esp
				break;
  801266:	e9 95 00 00 00       	jmp    801300 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  80126b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80126f:	7e 34                	jle    8012a5 <atomic_readline+0xa5>
  801271:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801278:	7f 2b                	jg     8012a5 <atomic_readline+0xa5>
				if (echoing)
  80127a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127e:	74 0e                	je     80128e <atomic_readline+0x8e>
					cputchar(c);
  801280:	83 ec 0c             	sub    $0xc,%esp
  801283:	ff 75 ec             	pushl  -0x14(%ebp)
  801286:	e8 aa f3 ff ff       	call   800635 <cputchar>
  80128b:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80128e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801291:	8d 50 01             	lea    0x1(%eax),%edx
  801294:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801297:	89 c2                	mov    %eax,%edx
  801299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129c:	01 d0                	add    %edx,%eax
  80129e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012a1:	88 10                	mov    %dl,(%eax)
  8012a3:	eb 56                	jmp    8012fb <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8012a5:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012a9:	75 1f                	jne    8012ca <atomic_readline+0xca>
  8012ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012af:	7e 19                	jle    8012ca <atomic_readline+0xca>
				if (echoing)
  8012b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b5:	74 0e                	je     8012c5 <atomic_readline+0xc5>
					cputchar(c);
  8012b7:	83 ec 0c             	sub    $0xc,%esp
  8012ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8012bd:	e8 73 f3 ff ff       	call   800635 <cputchar>
  8012c2:	83 c4 10             	add    $0x10,%esp
				i--;
  8012c5:	ff 4d f4             	decl   -0xc(%ebp)
  8012c8:	eb 31                	jmp    8012fb <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8012ca:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012ce:	74 0a                	je     8012da <atomic_readline+0xda>
  8012d0:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012d4:	0f 85 61 ff ff ff    	jne    80123b <atomic_readline+0x3b>
				if (echoing)
  8012da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012de:	74 0e                	je     8012ee <atomic_readline+0xee>
					cputchar(c);
  8012e0:	83 ec 0c             	sub    $0xc,%esp
  8012e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8012e6:	e8 4a f3 ff ff       	call   800635 <cputchar>
  8012eb:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8012ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f4:	01 d0                	add    %edx,%eax
  8012f6:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8012f9:	eb 06                	jmp    801301 <atomic_readline+0x101>
			}
		}
  8012fb:	e9 3b ff ff ff       	jmp    80123b <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801300:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801301:	e8 b2 0c 00 00       	call   801fb8 <sys_unlock_cons>
}
  801306:	90                   	nop
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80130f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801316:	eb 06                	jmp    80131e <strlen+0x15>
		n++;
  801318:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80131b:	ff 45 08             	incl   0x8(%ebp)
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	84 c0                	test   %al,%al
  801325:	75 f1                	jne    801318 <strlen+0xf>
		n++;
	return n;
  801327:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801332:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801339:	eb 09                	jmp    801344 <strnlen+0x18>
		n++;
  80133b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80133e:	ff 45 08             	incl   0x8(%ebp)
  801341:	ff 4d 0c             	decl   0xc(%ebp)
  801344:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801348:	74 09                	je     801353 <strnlen+0x27>
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	84 c0                	test   %al,%al
  801351:	75 e8                	jne    80133b <strnlen+0xf>
		n++;
	return n;
  801353:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801364:	90                   	nop
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	8d 50 01             	lea    0x1(%eax),%edx
  80136b:	89 55 08             	mov    %edx,0x8(%ebp)
  80136e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801371:	8d 4a 01             	lea    0x1(%edx),%ecx
  801374:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801377:	8a 12                	mov    (%edx),%dl
  801379:	88 10                	mov    %dl,(%eax)
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	84 c0                	test   %al,%al
  80137f:	75 e4                	jne    801365 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801381:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801392:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801399:	eb 1f                	jmp    8013ba <strncpy+0x34>
		*dst++ = *src;
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	8d 50 01             	lea    0x1(%eax),%edx
  8013a1:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a7:	8a 12                	mov    (%edx),%dl
  8013a9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	84 c0                	test   %al,%al
  8013b2:	74 03                	je     8013b7 <strncpy+0x31>
			src++;
  8013b4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013b7:	ff 45 fc             	incl   -0x4(%ebp)
  8013ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013c0:	72 d9                	jb     80139b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d7:	74 30                	je     801409 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013d9:	eb 16                	jmp    8013f1 <strlcpy+0x2a>
			*dst++ = *src++;
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8d 50 01             	lea    0x1(%eax),%edx
  8013e1:	89 55 08             	mov    %edx,0x8(%ebp)
  8013e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ea:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013ed:	8a 12                	mov    (%edx),%dl
  8013ef:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013f1:	ff 4d 10             	decl   0x10(%ebp)
  8013f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f8:	74 09                	je     801403 <strlcpy+0x3c>
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	8a 00                	mov    (%eax),%al
  8013ff:	84 c0                	test   %al,%al
  801401:	75 d8                	jne    8013db <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801409:	8b 55 08             	mov    0x8(%ebp),%edx
  80140c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140f:	29 c2                	sub    %eax,%edx
  801411:	89 d0                	mov    %edx,%eax
}
  801413:	c9                   	leave  
  801414:	c3                   	ret    

00801415 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801418:	eb 06                	jmp    801420 <strcmp+0xb>
		p++, q++;
  80141a:	ff 45 08             	incl   0x8(%ebp)
  80141d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	84 c0                	test   %al,%al
  801427:	74 0e                	je     801437 <strcmp+0x22>
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 10                	mov    (%eax),%dl
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	38 c2                	cmp    %al,%dl
  801435:	74 e3                	je     80141a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	0f b6 d0             	movzbl %al,%edx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	0f b6 c0             	movzbl %al,%eax
  801447:	29 c2                	sub    %eax,%edx
  801449:	89 d0                	mov    %edx,%eax
}
  80144b:	5d                   	pop    %ebp
  80144c:	c3                   	ret    

0080144d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801450:	eb 09                	jmp    80145b <strncmp+0xe>
		n--, p++, q++;
  801452:	ff 4d 10             	decl   0x10(%ebp)
  801455:	ff 45 08             	incl   0x8(%ebp)
  801458:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80145b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80145f:	74 17                	je     801478 <strncmp+0x2b>
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	84 c0                	test   %al,%al
  801468:	74 0e                	je     801478 <strncmp+0x2b>
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 10                	mov    (%eax),%dl
  80146f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	38 c2                	cmp    %al,%dl
  801476:	74 da                	je     801452 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801478:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80147c:	75 07                	jne    801485 <strncmp+0x38>
		return 0;
  80147e:	b8 00 00 00 00       	mov    $0x0,%eax
  801483:	eb 14                	jmp    801499 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	0f b6 d0             	movzbl %al,%edx
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	0f b6 c0             	movzbl %al,%eax
  801495:	29 c2                	sub    %eax,%edx
  801497:	89 d0                	mov    %edx,%eax
}
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 04             	sub    $0x4,%esp
  8014a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014a7:	eb 12                	jmp    8014bb <strchr+0x20>
		if (*s == c)
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014b1:	75 05                	jne    8014b8 <strchr+0x1d>
			return (char *) s;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	eb 11                	jmp    8014c9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014b8:	ff 45 08             	incl   0x8(%ebp)
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	8a 00                	mov    (%eax),%al
  8014c0:	84 c0                	test   %al,%al
  8014c2:	75 e5                	jne    8014a9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014d7:	eb 0d                	jmp    8014e6 <strfind+0x1b>
		if (*s == c)
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014e1:	74 0e                	je     8014f1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014e3:	ff 45 08             	incl   0x8(%ebp)
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	8a 00                	mov    (%eax),%al
  8014eb:	84 c0                	test   %al,%al
  8014ed:	75 ea                	jne    8014d9 <strfind+0xe>
  8014ef:	eb 01                	jmp    8014f2 <strfind+0x27>
		if (*s == c)
			break;
  8014f1:	90                   	nop
	return (char *) s;
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801503:	8b 45 10             	mov    0x10(%ebp),%eax
  801506:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801509:	eb 0e                	jmp    801519 <memset+0x22>
		*p++ = c;
  80150b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80150e:	8d 50 01             	lea    0x1(%eax),%edx
  801511:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801514:	8b 55 0c             	mov    0xc(%ebp),%edx
  801517:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801519:	ff 4d f8             	decl   -0x8(%ebp)
  80151c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801520:	79 e9                	jns    80150b <memset+0x14>
		*p++ = c;

	return v;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801539:	eb 16                	jmp    801551 <memcpy+0x2a>
		*d++ = *s++;
  80153b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153e:	8d 50 01             	lea    0x1(%eax),%edx
  801541:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801544:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801547:	8d 4a 01             	lea    0x1(%edx),%ecx
  80154a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80154d:	8a 12                	mov    (%edx),%dl
  80154f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801551:	8b 45 10             	mov    0x10(%ebp),%eax
  801554:	8d 50 ff             	lea    -0x1(%eax),%edx
  801557:	89 55 10             	mov    %edx,0x10(%ebp)
  80155a:	85 c0                	test   %eax,%eax
  80155c:	75 dd                	jne    80153b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801575:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801578:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80157b:	73 50                	jae    8015cd <memmove+0x6a>
  80157d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801580:	8b 45 10             	mov    0x10(%ebp),%eax
  801583:	01 d0                	add    %edx,%eax
  801585:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801588:	76 43                	jbe    8015cd <memmove+0x6a>
		s += n;
  80158a:	8b 45 10             	mov    0x10(%ebp),%eax
  80158d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801590:	8b 45 10             	mov    0x10(%ebp),%eax
  801593:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801596:	eb 10                	jmp    8015a8 <memmove+0x45>
			*--d = *--s;
  801598:	ff 4d f8             	decl   -0x8(%ebp)
  80159b:	ff 4d fc             	decl   -0x4(%ebp)
  80159e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a1:	8a 10                	mov    (%eax),%dl
  8015a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015a6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	75 e3                	jne    801598 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015b5:	eb 23                	jmp    8015da <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8015b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ba:	8d 50 01             	lea    0x1(%eax),%edx
  8015bd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015c6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015c9:	8a 12                	mov    (%edx),%dl
  8015cb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8015cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d6:	85 c0                	test   %eax,%eax
  8015d8:	75 dd                	jne    8015b7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
  8015e2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ee:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015f1:	eb 2a                	jmp    80161d <memcmp+0x3e>
		if (*s1 != *s2)
  8015f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f6:	8a 10                	mov    (%eax),%dl
  8015f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fb:	8a 00                	mov    (%eax),%al
  8015fd:	38 c2                	cmp    %al,%dl
  8015ff:	74 16                	je     801617 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801601:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801604:	8a 00                	mov    (%eax),%al
  801606:	0f b6 d0             	movzbl %al,%edx
  801609:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160c:	8a 00                	mov    (%eax),%al
  80160e:	0f b6 c0             	movzbl %al,%eax
  801611:	29 c2                	sub    %eax,%edx
  801613:	89 d0                	mov    %edx,%eax
  801615:	eb 18                	jmp    80162f <memcmp+0x50>
		s1++, s2++;
  801617:	ff 45 fc             	incl   -0x4(%ebp)
  80161a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80161d:	8b 45 10             	mov    0x10(%ebp),%eax
  801620:	8d 50 ff             	lea    -0x1(%eax),%edx
  801623:	89 55 10             	mov    %edx,0x10(%ebp)
  801626:	85 c0                	test   %eax,%eax
  801628:	75 c9                	jne    8015f3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80162a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801637:	8b 55 08             	mov    0x8(%ebp),%edx
  80163a:	8b 45 10             	mov    0x10(%ebp),%eax
  80163d:	01 d0                	add    %edx,%eax
  80163f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801642:	eb 15                	jmp    801659 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801644:	8b 45 08             	mov    0x8(%ebp),%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	0f b6 d0             	movzbl %al,%edx
  80164c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164f:	0f b6 c0             	movzbl %al,%eax
  801652:	39 c2                	cmp    %eax,%edx
  801654:	74 0d                	je     801663 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801656:	ff 45 08             	incl   0x8(%ebp)
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80165f:	72 e3                	jb     801644 <memfind+0x13>
  801661:	eb 01                	jmp    801664 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801663:	90                   	nop
	return (void *) s;
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80166f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801676:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80167d:	eb 03                	jmp    801682 <strtol+0x19>
		s++;
  80167f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	3c 20                	cmp    $0x20,%al
  801689:	74 f4                	je     80167f <strtol+0x16>
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	8a 00                	mov    (%eax),%al
  801690:	3c 09                	cmp    $0x9,%al
  801692:	74 eb                	je     80167f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	8a 00                	mov    (%eax),%al
  801699:	3c 2b                	cmp    $0x2b,%al
  80169b:	75 05                	jne    8016a2 <strtol+0x39>
		s++;
  80169d:	ff 45 08             	incl   0x8(%ebp)
  8016a0:	eb 13                	jmp    8016b5 <strtol+0x4c>
	else if (*s == '-')
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	8a 00                	mov    (%eax),%al
  8016a7:	3c 2d                	cmp    $0x2d,%al
  8016a9:	75 0a                	jne    8016b5 <strtol+0x4c>
		s++, neg = 1;
  8016ab:	ff 45 08             	incl   0x8(%ebp)
  8016ae:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b9:	74 06                	je     8016c1 <strtol+0x58>
  8016bb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8016bf:	75 20                	jne    8016e1 <strtol+0x78>
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	8a 00                	mov    (%eax),%al
  8016c6:	3c 30                	cmp    $0x30,%al
  8016c8:	75 17                	jne    8016e1 <strtol+0x78>
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	40                   	inc    %eax
  8016ce:	8a 00                	mov    (%eax),%al
  8016d0:	3c 78                	cmp    $0x78,%al
  8016d2:	75 0d                	jne    8016e1 <strtol+0x78>
		s += 2, base = 16;
  8016d4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8016d8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016df:	eb 28                	jmp    801709 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016e5:	75 15                	jne    8016fc <strtol+0x93>
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	3c 30                	cmp    $0x30,%al
  8016ee:	75 0c                	jne    8016fc <strtol+0x93>
		s++, base = 8;
  8016f0:	ff 45 08             	incl   0x8(%ebp)
  8016f3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016fa:	eb 0d                	jmp    801709 <strtol+0xa0>
	else if (base == 0)
  8016fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801700:	75 07                	jne    801709 <strtol+0xa0>
		base = 10;
  801702:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	3c 2f                	cmp    $0x2f,%al
  801710:	7e 19                	jle    80172b <strtol+0xc2>
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8a 00                	mov    (%eax),%al
  801717:	3c 39                	cmp    $0x39,%al
  801719:	7f 10                	jg     80172b <strtol+0xc2>
			dig = *s - '0';
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	8a 00                	mov    (%eax),%al
  801720:	0f be c0             	movsbl %al,%eax
  801723:	83 e8 30             	sub    $0x30,%eax
  801726:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801729:	eb 42                	jmp    80176d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8a 00                	mov    (%eax),%al
  801730:	3c 60                	cmp    $0x60,%al
  801732:	7e 19                	jle    80174d <strtol+0xe4>
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	8a 00                	mov    (%eax),%al
  801739:	3c 7a                	cmp    $0x7a,%al
  80173b:	7f 10                	jg     80174d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	0f be c0             	movsbl %al,%eax
  801745:	83 e8 57             	sub    $0x57,%eax
  801748:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80174b:	eb 20                	jmp    80176d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	8a 00                	mov    (%eax),%al
  801752:	3c 40                	cmp    $0x40,%al
  801754:	7e 39                	jle    80178f <strtol+0x126>
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	8a 00                	mov    (%eax),%al
  80175b:	3c 5a                	cmp    $0x5a,%al
  80175d:	7f 30                	jg     80178f <strtol+0x126>
			dig = *s - 'A' + 10;
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	8a 00                	mov    (%eax),%al
  801764:	0f be c0             	movsbl %al,%eax
  801767:	83 e8 37             	sub    $0x37,%eax
  80176a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801770:	3b 45 10             	cmp    0x10(%ebp),%eax
  801773:	7d 19                	jge    80178e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801775:	ff 45 08             	incl   0x8(%ebp)
  801778:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80177f:	89 c2                	mov    %eax,%edx
  801781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801784:	01 d0                	add    %edx,%eax
  801786:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801789:	e9 7b ff ff ff       	jmp    801709 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80178e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80178f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801793:	74 08                	je     80179d <strtol+0x134>
		*endptr = (char *) s;
  801795:	8b 45 0c             	mov    0xc(%ebp),%eax
  801798:	8b 55 08             	mov    0x8(%ebp),%edx
  80179b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80179d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017a1:	74 07                	je     8017aa <strtol+0x141>
  8017a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a6:	f7 d8                	neg    %eax
  8017a8:	eb 03                	jmp    8017ad <strtol+0x144>
  8017aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <ltostr>:

void
ltostr(long value, char *str)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8017b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8017bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8017c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017c7:	79 13                	jns    8017dc <ltostr+0x2d>
	{
		neg = 1;
  8017c9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8017d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8017d6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8017d9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017e4:	99                   	cltd   
  8017e5:	f7 f9                	idiv   %ecx
  8017e7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017ed:	8d 50 01             	lea    0x1(%eax),%edx
  8017f0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017f3:	89 c2                	mov    %eax,%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017fd:	83 c2 30             	add    $0x30,%edx
  801800:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801802:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801805:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80180a:	f7 e9                	imul   %ecx
  80180c:	c1 fa 02             	sar    $0x2,%edx
  80180f:	89 c8                	mov    %ecx,%eax
  801811:	c1 f8 1f             	sar    $0x1f,%eax
  801814:	29 c2                	sub    %eax,%edx
  801816:	89 d0                	mov    %edx,%eax
  801818:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80181b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80181f:	75 bb                	jne    8017dc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801821:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801828:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182b:	48                   	dec    %eax
  80182c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80182f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801833:	74 3d                	je     801872 <ltostr+0xc3>
		start = 1 ;
  801835:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80183c:	eb 34                	jmp    801872 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80183e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801841:	8b 45 0c             	mov    0xc(%ebp),%eax
  801844:	01 d0                	add    %edx,%eax
  801846:	8a 00                	mov    (%eax),%al
  801848:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80184b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801851:	01 c2                	add    %eax,%edx
  801853:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801856:	8b 45 0c             	mov    0xc(%ebp),%eax
  801859:	01 c8                	add    %ecx,%eax
  80185b:	8a 00                	mov    (%eax),%al
  80185d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80185f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801862:	8b 45 0c             	mov    0xc(%ebp),%eax
  801865:	01 c2                	add    %eax,%edx
  801867:	8a 45 eb             	mov    -0x15(%ebp),%al
  80186a:	88 02                	mov    %al,(%edx)
		start++ ;
  80186c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80186f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801875:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801878:	7c c4                	jl     80183e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80187a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80187d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801880:	01 d0                	add    %edx,%eax
  801882:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801885:	90                   	nop
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80188e:	ff 75 08             	pushl  0x8(%ebp)
  801891:	e8 73 fa ff ff       	call   801309 <strlen>
  801896:	83 c4 04             	add    $0x4,%esp
  801899:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80189c:	ff 75 0c             	pushl  0xc(%ebp)
  80189f:	e8 65 fa ff ff       	call   801309 <strlen>
  8018a4:	83 c4 04             	add    $0x4,%esp
  8018a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8018aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8018b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018b8:	eb 17                	jmp    8018d1 <strcconcat+0x49>
		final[s] = str1[s] ;
  8018ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c0:	01 c2                	add    %eax,%edx
  8018c2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	01 c8                	add    %ecx,%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018ce:	ff 45 fc             	incl   -0x4(%ebp)
  8018d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018d4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018d7:	7c e1                	jl     8018ba <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018e7:	eb 1f                	jmp    801908 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ec:	8d 50 01             	lea    0x1(%eax),%edx
  8018ef:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018f2:	89 c2                	mov    %eax,%edx
  8018f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f7:	01 c2                	add    %eax,%edx
  8018f9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ff:	01 c8                	add    %ecx,%eax
  801901:	8a 00                	mov    (%eax),%al
  801903:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801905:	ff 45 f8             	incl   -0x8(%ebp)
  801908:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80190e:	7c d9                	jl     8018e9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801910:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801913:	8b 45 10             	mov    0x10(%ebp),%eax
  801916:	01 d0                	add    %edx,%eax
  801918:	c6 00 00             	movb   $0x0,(%eax)
}
  80191b:	90                   	nop
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801921:	8b 45 14             	mov    0x14(%ebp),%eax
  801924:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80192a:	8b 45 14             	mov    0x14(%ebp),%eax
  80192d:	8b 00                	mov    (%eax),%eax
  80192f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801936:	8b 45 10             	mov    0x10(%ebp),%eax
  801939:	01 d0                	add    %edx,%eax
  80193b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801941:	eb 0c                	jmp    80194f <strsplit+0x31>
			*string++ = 0;
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	8d 50 01             	lea    0x1(%eax),%edx
  801949:	89 55 08             	mov    %edx,0x8(%ebp)
  80194c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	8a 00                	mov    (%eax),%al
  801954:	84 c0                	test   %al,%al
  801956:	74 18                	je     801970 <strsplit+0x52>
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8a 00                	mov    (%eax),%al
  80195d:	0f be c0             	movsbl %al,%eax
  801960:	50                   	push   %eax
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	e8 32 fb ff ff       	call   80149b <strchr>
  801969:	83 c4 08             	add    $0x8,%esp
  80196c:	85 c0                	test   %eax,%eax
  80196e:	75 d3                	jne    801943 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	8a 00                	mov    (%eax),%al
  801975:	84 c0                	test   %al,%al
  801977:	74 5a                	je     8019d3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801979:	8b 45 14             	mov    0x14(%ebp),%eax
  80197c:	8b 00                	mov    (%eax),%eax
  80197e:	83 f8 0f             	cmp    $0xf,%eax
  801981:	75 07                	jne    80198a <strsplit+0x6c>
		{
			return 0;
  801983:	b8 00 00 00 00       	mov    $0x0,%eax
  801988:	eb 66                	jmp    8019f0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80198a:	8b 45 14             	mov    0x14(%ebp),%eax
  80198d:	8b 00                	mov    (%eax),%eax
  80198f:	8d 48 01             	lea    0x1(%eax),%ecx
  801992:	8b 55 14             	mov    0x14(%ebp),%edx
  801995:	89 0a                	mov    %ecx,(%edx)
  801997:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80199e:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a1:	01 c2                	add    %eax,%edx
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019a8:	eb 03                	jmp    8019ad <strsplit+0x8f>
			string++;
  8019aa:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8a 00                	mov    (%eax),%al
  8019b2:	84 c0                	test   %al,%al
  8019b4:	74 8b                	je     801941 <strsplit+0x23>
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	0f be c0             	movsbl %al,%eax
  8019be:	50                   	push   %eax
  8019bf:	ff 75 0c             	pushl  0xc(%ebp)
  8019c2:	e8 d4 fa ff ff       	call   80149b <strchr>
  8019c7:	83 c4 08             	add    $0x8,%esp
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	74 dc                	je     8019aa <strsplit+0x8c>
			string++;
	}
  8019ce:	e9 6e ff ff ff       	jmp    801941 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019d3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d7:	8b 00                	mov    (%eax),%eax
  8019d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e3:	01 d0                	add    %edx,%eax
  8019e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019eb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	68 3c 4a 80 00       	push   $0x804a3c
  801a00:	68 3f 01 00 00       	push   $0x13f
  801a05:	68 5e 4a 80 00       	push   $0x804a5e
  801a0a:	e8 a1 ed ff ff       	call   8007b0 <_panic>

00801a0f <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801a15:	83 ec 0c             	sub    $0xc,%esp
  801a18:	ff 75 08             	pushl  0x8(%ebp)
  801a1b:	e8 e7 0a 00 00       	call   802507 <sys_sbrk>
  801a20:	83 c4 10             	add    $0x10,%esp
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801a2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a2f:	75 0a                	jne    801a3b <malloc+0x16>
  801a31:	b8 00 00 00 00       	mov    $0x0,%eax
  801a36:	e9 07 02 00 00       	jmp    801c42 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801a3b:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801a42:	8b 55 08             	mov    0x8(%ebp),%edx
  801a45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a48:	01 d0                	add    %edx,%eax
  801a4a:	48                   	dec    %eax
  801a4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a51:	ba 00 00 00 00       	mov    $0x0,%edx
  801a56:	f7 75 dc             	divl   -0x24(%ebp)
  801a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a5c:	29 d0                	sub    %edx,%eax
  801a5e:	c1 e8 0c             	shr    $0xc,%eax
  801a61:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  801a64:	a1 24 50 80 00       	mov    0x805024,%eax
  801a69:	8b 40 78             	mov    0x78(%eax),%eax
  801a6c:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801a71:	29 c2                	sub    %eax,%edx
  801a73:	89 d0                	mov    %edx,%eax
  801a75:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801a78:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a80:	c1 e8 0c             	shr    $0xc,%eax
  801a83:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801a8d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801a94:	77 42                	ja     801ad8 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a96:	e8 f0 08 00 00       	call   80238b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	74 16                	je     801ab5 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801a9f:	83 ec 0c             	sub    $0xc,%esp
  801aa2:	ff 75 08             	pushl  0x8(%ebp)
  801aa5:	e8 30 0e 00 00       	call   8028da <alloc_block_FF>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ab0:	e9 8a 01 00 00       	jmp    801c3f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801ab5:	e8 02 09 00 00       	call   8023bc <sys_isUHeapPlacementStrategyBESTFIT>
  801aba:	85 c0                	test   %eax,%eax
  801abc:	0f 84 7d 01 00 00    	je     801c3f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801ac2:	83 ec 0c             	sub    $0xc,%esp
  801ac5:	ff 75 08             	pushl  0x8(%ebp)
  801ac8:	e8 c9 12 00 00       	call   802d96 <alloc_block_BF>
  801acd:	83 c4 10             	add    $0x10,%esp
  801ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ad3:	e9 67 01 00 00       	jmp    801c3f <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801ad8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801adb:	48                   	dec    %eax
  801adc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801adf:	0f 86 53 01 00 00    	jbe    801c38 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801ae5:	a1 24 50 80 00       	mov    0x805024,%eax
  801aea:	8b 40 78             	mov    0x78(%eax),%eax
  801aed:	05 00 10 00 00       	add    $0x1000,%eax
  801af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801af5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801afc:	e9 de 00 00 00       	jmp    801bdf <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  801b01:	a1 24 50 80 00       	mov    0x805024,%eax
  801b06:	8b 40 78             	mov    0x78(%eax),%eax
  801b09:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b0c:	29 c2                	sub    %eax,%edx
  801b0e:	89 d0                	mov    %edx,%eax
  801b10:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b15:	c1 e8 0c             	shr    $0xc,%eax
  801b18:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	0f 85 ab 00 00 00    	jne    801bd2 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2a:	05 00 10 00 00       	add    $0x1000,%eax
  801b2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801b32:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801b39:	eb 47                	jmp    801b82 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801b3b:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801b42:	76 0a                	jbe    801b4e <malloc+0x129>
  801b44:	b8 00 00 00 00       	mov    $0x0,%eax
  801b49:	e9 f4 00 00 00       	jmp    801c42 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801b4e:	a1 24 50 80 00       	mov    0x805024,%eax
  801b53:	8b 40 78             	mov    0x78(%eax),%eax
  801b56:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b59:	29 c2                	sub    %eax,%edx
  801b5b:	89 d0                	mov    %edx,%eax
  801b5d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b62:	c1 e8 0c             	shr    $0xc,%eax
  801b65:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801b6c:	85 c0                	test   %eax,%eax
  801b6e:	74 08                	je     801b78 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  801b70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801b76:	eb 5a                	jmp    801bd2 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801b78:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801b7f:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801b82:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b85:	48                   	dec    %eax
  801b86:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b89:	77 b0                	ja     801b3b <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801b8b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801b92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b99:	eb 2f                	jmp    801bca <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801b9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b9e:	c1 e0 0c             	shl    $0xc,%eax
  801ba1:	89 c2                	mov    %eax,%edx
  801ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba6:	01 c2                	add    %eax,%edx
  801ba8:	a1 24 50 80 00       	mov    0x805024,%eax
  801bad:	8b 40 78             	mov    0x78(%eax),%eax
  801bb0:	29 c2                	sub    %eax,%edx
  801bb2:	89 d0                	mov    %edx,%eax
  801bb4:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bb9:	c1 e8 0c             	shr    $0xc,%eax
  801bbc:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801bc3:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801bc7:	ff 45 e0             	incl   -0x20(%ebp)
  801bca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bcd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801bd0:	72 c9                	jb     801b9b <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801bd2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bd6:	75 16                	jne    801bee <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801bd8:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801bdf:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801be6:	0f 86 15 ff ff ff    	jbe    801b01 <malloc+0xdc>
  801bec:	eb 01                	jmp    801bef <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801bee:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  801bef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bf3:	75 07                	jne    801bfc <malloc+0x1d7>
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfa:	eb 46                	jmp    801c42 <malloc+0x21d>
		ptr = (void*)i;
  801bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801c02:	a1 24 50 80 00       	mov    0x805024,%eax
  801c07:	8b 40 78             	mov    0x78(%eax),%eax
  801c0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c0d:	29 c2                	sub    %eax,%edx
  801c0f:	89 d0                	mov    %edx,%eax
  801c11:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c16:	c1 e8 0c             	shr    $0xc,%eax
  801c19:	89 c2                	mov    %eax,%edx
  801c1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c1e:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801c25:	83 ec 08             	sub    $0x8,%esp
  801c28:	ff 75 08             	pushl  0x8(%ebp)
  801c2b:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2e:	e8 0b 09 00 00       	call   80253e <sys_allocate_user_mem>
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	eb 07                	jmp    801c3f <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801c38:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3d:	eb 03                	jmp    801c42 <malloc+0x21d>
	}
	return ptr;
  801c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801c4a:	a1 24 50 80 00       	mov    0x805024,%eax
  801c4f:	8b 40 78             	mov    0x78(%eax),%eax
  801c52:	05 00 10 00 00       	add    $0x1000,%eax
  801c57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801c5a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801c61:	a1 24 50 80 00       	mov    0x805024,%eax
  801c66:	8b 50 78             	mov    0x78(%eax),%edx
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	39 c2                	cmp    %eax,%edx
  801c6e:	76 24                	jbe    801c94 <free+0x50>
		size = get_block_size(va);
  801c70:	83 ec 0c             	sub    $0xc,%esp
  801c73:	ff 75 08             	pushl  0x8(%ebp)
  801c76:	e8 df 08 00 00       	call   80255a <get_block_size>
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	ff 75 08             	pushl  0x8(%ebp)
  801c87:	e8 12 1b 00 00       	call   80379e <free_block>
  801c8c:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801c8f:	e9 ac 00 00 00       	jmp    801d40 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c9a:	0f 82 89 00 00 00    	jb     801d29 <free+0xe5>
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801ca8:	77 7f                	ja     801d29 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801caa:	8b 55 08             	mov    0x8(%ebp),%edx
  801cad:	a1 24 50 80 00       	mov    0x805024,%eax
  801cb2:	8b 40 78             	mov    0x78(%eax),%eax
  801cb5:	29 c2                	sub    %eax,%edx
  801cb7:	89 d0                	mov    %edx,%eax
  801cb9:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cbe:	c1 e8 0c             	shr    $0xc,%eax
  801cc1:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801cc8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801ccb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cce:	c1 e0 0c             	shl    $0xc,%eax
  801cd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801cd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801cdb:	eb 2f                	jmp    801d0c <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce0:	c1 e0 0c             	shl    $0xc,%eax
  801ce3:	89 c2                	mov    %eax,%edx
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	01 c2                	add    %eax,%edx
  801cea:	a1 24 50 80 00       	mov    0x805024,%eax
  801cef:	8b 40 78             	mov    0x78(%eax),%eax
  801cf2:	29 c2                	sub    %eax,%edx
  801cf4:	89 d0                	mov    %edx,%eax
  801cf6:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cfb:	c1 e8 0c             	shr    $0xc,%eax
  801cfe:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801d05:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801d09:	ff 45 f4             	incl   -0xc(%ebp)
  801d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d12:	72 c9                	jb     801cdd <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	83 ec 08             	sub    $0x8,%esp
  801d1a:	ff 75 ec             	pushl  -0x14(%ebp)
  801d1d:	50                   	push   %eax
  801d1e:	e8 ff 07 00 00       	call   802522 <sys_free_user_mem>
  801d23:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801d26:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801d27:	eb 17                	jmp    801d40 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	68 6c 4a 80 00       	push   $0x804a6c
  801d31:	68 85 00 00 00       	push   $0x85
  801d36:	68 96 4a 80 00       	push   $0x804a96
  801d3b:	e8 70 ea ff ff       	call   8007b0 <_panic>
	}
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 28             	sub    $0x28,%esp
  801d48:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4b:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801d4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d52:	75 0a                	jne    801d5e <smalloc+0x1c>
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
  801d59:	e9 9a 00 00 00       	jmp    801df8 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d64:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d71:	39 d0                	cmp    %edx,%eax
  801d73:	73 02                	jae    801d77 <smalloc+0x35>
  801d75:	89 d0                	mov    %edx,%eax
  801d77:	83 ec 0c             	sub    $0xc,%esp
  801d7a:	50                   	push   %eax
  801d7b:	e8 a5 fc ff ff       	call   801a25 <malloc>
  801d80:	83 c4 10             	add    $0x10,%esp
  801d83:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801d86:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d8a:	75 07                	jne    801d93 <smalloc+0x51>
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d91:	eb 65                	jmp    801df8 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d93:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d97:	ff 75 ec             	pushl  -0x14(%ebp)
  801d9a:	50                   	push   %eax
  801d9b:	ff 75 0c             	pushl  0xc(%ebp)
  801d9e:	ff 75 08             	pushl  0x8(%ebp)
  801da1:	e8 83 03 00 00       	call   802129 <sys_createSharedObject>
  801da6:	83 c4 10             	add    $0x10,%esp
  801da9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801dac:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801db0:	74 06                	je     801db8 <smalloc+0x76>
  801db2:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801db6:	75 07                	jne    801dbf <smalloc+0x7d>
  801db8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbd:	eb 39                	jmp    801df8 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801dbf:	83 ec 08             	sub    $0x8,%esp
  801dc2:	ff 75 ec             	pushl  -0x14(%ebp)
  801dc5:	68 a2 4a 80 00       	push   $0x804aa2
  801dca:	e8 9e ec ff ff       	call   800a6d <cprintf>
  801dcf:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801dd2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dd5:	a1 24 50 80 00       	mov    0x805024,%eax
  801dda:	8b 40 78             	mov    0x78(%eax),%eax
  801ddd:	29 c2                	sub    %eax,%edx
  801ddf:	89 d0                	mov    %edx,%eax
  801de1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801de6:	c1 e8 0c             	shr    $0xc,%eax
  801de9:	89 c2                	mov    %eax,%edx
  801deb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dee:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e00:	83 ec 08             	sub    $0x8,%esp
  801e03:	ff 75 0c             	pushl  0xc(%ebp)
  801e06:	ff 75 08             	pushl  0x8(%ebp)
  801e09:	e8 45 03 00 00       	call   802153 <sys_getSizeOfSharedObject>
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801e14:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801e18:	75 07                	jne    801e21 <sget+0x27>
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1f:	eb 5c                	jmp    801e7d <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e27:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e2e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e34:	39 d0                	cmp    %edx,%eax
  801e36:	7d 02                	jge    801e3a <sget+0x40>
  801e38:	89 d0                	mov    %edx,%eax
  801e3a:	83 ec 0c             	sub    $0xc,%esp
  801e3d:	50                   	push   %eax
  801e3e:	e8 e2 fb ff ff       	call   801a25 <malloc>
  801e43:	83 c4 10             	add    $0x10,%esp
  801e46:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801e49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e4d:	75 07                	jne    801e56 <sget+0x5c>
  801e4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e54:	eb 27                	jmp    801e7d <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801e56:	83 ec 04             	sub    $0x4,%esp
  801e59:	ff 75 e8             	pushl  -0x18(%ebp)
  801e5c:	ff 75 0c             	pushl  0xc(%ebp)
  801e5f:	ff 75 08             	pushl  0x8(%ebp)
  801e62:	e8 09 03 00 00       	call   802170 <sys_getSharedObject>
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801e6d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801e71:	75 07                	jne    801e7a <sget+0x80>
  801e73:	b8 00 00 00 00       	mov    $0x0,%eax
  801e78:	eb 03                	jmp    801e7d <sget+0x83>
	return ptr;
  801e7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801e85:	8b 55 08             	mov    0x8(%ebp),%edx
  801e88:	a1 24 50 80 00       	mov    0x805024,%eax
  801e8d:	8b 40 78             	mov    0x78(%eax),%eax
  801e90:	29 c2                	sub    %eax,%edx
  801e92:	89 d0                	mov    %edx,%eax
  801e94:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e99:	c1 e8 0c             	shr    $0xc,%eax
  801e9c:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801ea6:	83 ec 08             	sub    $0x8,%esp
  801ea9:	ff 75 08             	pushl  0x8(%ebp)
  801eac:	ff 75 f4             	pushl  -0xc(%ebp)
  801eaf:	e8 db 02 00 00       	call   80218f <sys_freeSharedObject>
  801eb4:	83 c4 10             	add    $0x10,%esp
  801eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801eba:	90                   	nop
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	68 b4 4a 80 00       	push   $0x804ab4
  801ecb:	68 dd 00 00 00       	push   $0xdd
  801ed0:	68 96 4a 80 00       	push   $0x804a96
  801ed5:	e8 d6 e8 ff ff       	call   8007b0 <_panic>

00801eda <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	68 da 4a 80 00       	push   $0x804ada
  801ee8:	68 e9 00 00 00       	push   $0xe9
  801eed:	68 96 4a 80 00       	push   $0x804a96
  801ef2:	e8 b9 e8 ff ff       	call   8007b0 <_panic>

00801ef7 <shrink>:

}
void shrink(uint32 newSize)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801efd:	83 ec 04             	sub    $0x4,%esp
  801f00:	68 da 4a 80 00       	push   $0x804ada
  801f05:	68 ee 00 00 00       	push   $0xee
  801f0a:	68 96 4a 80 00       	push   $0x804a96
  801f0f:	e8 9c e8 ff ff       	call   8007b0 <_panic>

00801f14 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f1a:	83 ec 04             	sub    $0x4,%esp
  801f1d:	68 da 4a 80 00       	push   $0x804ada
  801f22:	68 f3 00 00 00       	push   $0xf3
  801f27:	68 96 4a 80 00       	push   $0x804a96
  801f2c:	e8 7f e8 ff ff       	call   8007b0 <_panic>

00801f31 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	57                   	push   %edi
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
  801f37:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f46:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f49:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f4c:	cd 30                	int    $0x30
  801f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	8b 45 10             	mov    0x10(%ebp),%eax
  801f65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f68:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	52                   	push   %edx
  801f74:	ff 75 0c             	pushl  0xc(%ebp)
  801f77:	50                   	push   %eax
  801f78:	6a 00                	push   $0x0
  801f7a:	e8 b2 ff ff ff       	call   801f31 <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	90                   	nop
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 02                	push   $0x2
  801f94:	e8 98 ff ff ff       	call   801f31 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_lock_cons>:

void sys_lock_cons(void)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 03                	push   $0x3
  801fad:	e8 7f ff ff ff       	call   801f31 <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
}
  801fb5:	90                   	nop
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 04                	push   $0x4
  801fc7:	e8 65 ff ff ff       	call   801f31 <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
}
  801fcf:	90                   	nop
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	52                   	push   %edx
  801fe2:	50                   	push   %eax
  801fe3:	6a 08                	push   $0x8
  801fe5:	e8 47 ff ff ff       	call   801f31 <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	56                   	push   %esi
  801ff3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ff4:	8b 75 18             	mov    0x18(%ebp),%esi
  801ff7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ffa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ffd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	56                   	push   %esi
  802004:	53                   	push   %ebx
  802005:	51                   	push   %ecx
  802006:	52                   	push   %edx
  802007:	50                   	push   %eax
  802008:	6a 09                	push   $0x9
  80200a:	e8 22 ff ff ff       	call   801f31 <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
}
  802012:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802015:	5b                   	pop    %ebx
  802016:	5e                   	pop    %esi
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80201c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	52                   	push   %edx
  802029:	50                   	push   %eax
  80202a:	6a 0a                	push   $0xa
  80202c:	e8 00 ff ff ff       	call   801f31 <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	ff 75 0c             	pushl  0xc(%ebp)
  802042:	ff 75 08             	pushl  0x8(%ebp)
  802045:	6a 0b                	push   $0xb
  802047:	e8 e5 fe ff ff       	call   801f31 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 0c                	push   $0xc
  802060:	e8 cc fe ff ff       	call   801f31 <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 0d                	push   $0xd
  802079:	e8 b3 fe ff ff       	call   801f31 <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 0e                	push   $0xe
  802092:	e8 9a fe ff ff       	call   801f31 <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
}
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 0f                	push   $0xf
  8020ab:	e8 81 fe ff ff       	call   801f31 <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
}
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	ff 75 08             	pushl  0x8(%ebp)
  8020c3:	6a 10                	push   $0x10
  8020c5:	e8 67 fe ff ff       	call   801f31 <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 11                	push   $0x11
  8020de:	e8 4e fe ff ff       	call   801f31 <syscall>
  8020e3:	83 c4 18             	add    $0x18,%esp
}
  8020e6:	90                   	nop
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <sys_cputc>:

void
sys_cputc(const char c)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 04             	sub    $0x4,%esp
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020f5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	50                   	push   %eax
  802102:	6a 01                	push   $0x1
  802104:	e8 28 fe ff ff       	call   801f31 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	90                   	nop
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 14                	push   $0x14
  80211e:	e8 0e fe ff ff       	call   801f31 <syscall>
  802123:	83 c4 18             	add    $0x18,%esp
}
  802126:	90                   	nop
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	83 ec 04             	sub    $0x4,%esp
  80212f:	8b 45 10             	mov    0x10(%ebp),%eax
  802132:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802135:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802138:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	6a 00                	push   $0x0
  802141:	51                   	push   %ecx
  802142:	52                   	push   %edx
  802143:	ff 75 0c             	pushl  0xc(%ebp)
  802146:	50                   	push   %eax
  802147:	6a 15                	push   $0x15
  802149:	e8 e3 fd ff ff       	call   801f31 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802156:	8b 55 0c             	mov    0xc(%ebp),%edx
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	52                   	push   %edx
  802163:	50                   	push   %eax
  802164:	6a 16                	push   $0x16
  802166:	e8 c6 fd ff ff       	call   801f31 <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802173:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802176:	8b 55 0c             	mov    0xc(%ebp),%edx
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	51                   	push   %ecx
  802181:	52                   	push   %edx
  802182:	50                   	push   %eax
  802183:	6a 17                	push   $0x17
  802185:	e8 a7 fd ff ff       	call   801f31 <syscall>
  80218a:	83 c4 18             	add    $0x18,%esp
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802192:	8b 55 0c             	mov    0xc(%ebp),%edx
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	52                   	push   %edx
  80219f:	50                   	push   %eax
  8021a0:	6a 18                	push   $0x18
  8021a2:	e8 8a fd ff ff       	call   801f31 <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	6a 00                	push   $0x0
  8021b4:	ff 75 14             	pushl  0x14(%ebp)
  8021b7:	ff 75 10             	pushl  0x10(%ebp)
  8021ba:	ff 75 0c             	pushl  0xc(%ebp)
  8021bd:	50                   	push   %eax
  8021be:	6a 19                	push   $0x19
  8021c0:	e8 6c fd ff ff       	call   801f31 <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <sys_run_env>:

void sys_run_env(int32 envId)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	50                   	push   %eax
  8021d9:	6a 1a                	push   $0x1a
  8021db:	e8 51 fd ff ff       	call   801f31 <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
}
  8021e3:	90                   	nop
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	50                   	push   %eax
  8021f5:	6a 1b                	push   $0x1b
  8021f7:	e8 35 fd ff ff       	call   801f31 <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 05                	push   $0x5
  802210:	e8 1c fd ff ff       	call   801f31 <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 06                	push   $0x6
  802229:	e8 03 fd ff ff       	call   801f31 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 07                	push   $0x7
  802242:	e8 ea fc ff ff       	call   801f31 <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_exit_env>:


void sys_exit_env(void)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 1c                	push   $0x1c
  80225b:	e8 d1 fc ff ff       	call   801f31 <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
}
  802263:	90                   	nop
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80226c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80226f:	8d 50 04             	lea    0x4(%eax),%edx
  802272:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	52                   	push   %edx
  80227c:	50                   	push   %eax
  80227d:	6a 1d                	push   $0x1d
  80227f:	e8 ad fc ff ff       	call   801f31 <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
	return result;
  802287:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80228a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80228d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802290:	89 01                	mov    %eax,(%ecx)
  802292:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	c9                   	leave  
  802299:	c2 04 00             	ret    $0x4

0080229c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	ff 75 10             	pushl  0x10(%ebp)
  8022a6:	ff 75 0c             	pushl  0xc(%ebp)
  8022a9:	ff 75 08             	pushl  0x8(%ebp)
  8022ac:	6a 13                	push   $0x13
  8022ae:	e8 7e fc ff ff       	call   801f31 <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b6:	90                   	nop
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 1e                	push   $0x1e
  8022c8:	e8 64 fc ff ff       	call   801f31 <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	83 ec 04             	sub    $0x4,%esp
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022de:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	50                   	push   %eax
  8022eb:	6a 1f                	push   $0x1f
  8022ed:	e8 3f fc ff ff       	call   801f31 <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f5:	90                   	nop
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <rsttst>:
void rsttst()
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 21                	push   $0x21
  802307:	e8 25 fc ff ff       	call   801f31 <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
	return ;
  80230f:	90                   	nop
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	83 ec 04             	sub    $0x4,%esp
  802318:	8b 45 14             	mov    0x14(%ebp),%eax
  80231b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80231e:	8b 55 18             	mov    0x18(%ebp),%edx
  802321:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802325:	52                   	push   %edx
  802326:	50                   	push   %eax
  802327:	ff 75 10             	pushl  0x10(%ebp)
  80232a:	ff 75 0c             	pushl  0xc(%ebp)
  80232d:	ff 75 08             	pushl  0x8(%ebp)
  802330:	6a 20                	push   $0x20
  802332:	e8 fa fb ff ff       	call   801f31 <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
	return ;
  80233a:	90                   	nop
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <chktst>:
void chktst(uint32 n)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	ff 75 08             	pushl  0x8(%ebp)
  80234b:	6a 22                	push   $0x22
  80234d:	e8 df fb ff ff       	call   801f31 <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
	return ;
  802355:	90                   	nop
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <inctst>:

void inctst()
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 23                	push   $0x23
  802367:	e8 c5 fb ff ff       	call   801f31 <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
	return ;
  80236f:	90                   	nop
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <gettst>:
uint32 gettst()
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 24                	push   $0x24
  802381:	e8 ab fb ff ff       	call   801f31 <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 25                	push   $0x25
  80239d:	e8 8f fb ff ff       	call   801f31 <syscall>
  8023a2:	83 c4 18             	add    $0x18,%esp
  8023a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023a8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023ac:	75 07                	jne    8023b5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	eb 05                	jmp    8023ba <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 25                	push   $0x25
  8023ce:	e8 5e fb ff ff       	call   801f31 <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
  8023d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023d9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023dd:	75 07                	jne    8023e6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023df:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e4:	eb 05                	jmp    8023eb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
  8023f0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 25                	push   $0x25
  8023ff:	e8 2d fb ff ff       	call   801f31 <syscall>
  802404:	83 c4 18             	add    $0x18,%esp
  802407:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80240a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80240e:	75 07                	jne    802417 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802410:	b8 01 00 00 00       	mov    $0x1,%eax
  802415:	eb 05                	jmp    80241c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 25                	push   $0x25
  802430:	e8 fc fa ff ff       	call   801f31 <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
  802438:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80243b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80243f:	75 07                	jne    802448 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802441:	b8 01 00 00 00       	mov    $0x1,%eax
  802446:	eb 05                	jmp    80244d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	ff 75 08             	pushl  0x8(%ebp)
  80245d:	6a 26                	push   $0x26
  80245f:	e8 cd fa ff ff       	call   801f31 <syscall>
  802464:	83 c4 18             	add    $0x18,%esp
	return ;
  802467:	90                   	nop
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80246e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802471:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802474:	8b 55 0c             	mov    0xc(%ebp),%edx
  802477:	8b 45 08             	mov    0x8(%ebp),%eax
  80247a:	6a 00                	push   $0x0
  80247c:	53                   	push   %ebx
  80247d:	51                   	push   %ecx
  80247e:	52                   	push   %edx
  80247f:	50                   	push   %eax
  802480:	6a 27                	push   $0x27
  802482:	e8 aa fa ff ff       	call   801f31 <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
}
  80248a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802492:	8b 55 0c             	mov    0xc(%ebp),%edx
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	52                   	push   %edx
  80249f:	50                   	push   %eax
  8024a0:	6a 28                	push   $0x28
  8024a2:	e8 8a fa ff ff       	call   801f31 <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8024af:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	6a 00                	push   $0x0
  8024ba:	51                   	push   %ecx
  8024bb:	ff 75 10             	pushl  0x10(%ebp)
  8024be:	52                   	push   %edx
  8024bf:	50                   	push   %eax
  8024c0:	6a 29                	push   $0x29
  8024c2:	e8 6a fa ff ff       	call   801f31 <syscall>
  8024c7:	83 c4 18             	add    $0x18,%esp
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	ff 75 10             	pushl  0x10(%ebp)
  8024d6:	ff 75 0c             	pushl  0xc(%ebp)
  8024d9:	ff 75 08             	pushl  0x8(%ebp)
  8024dc:	6a 12                	push   $0x12
  8024de:	e8 4e fa ff ff       	call   801f31 <syscall>
  8024e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e6:	90                   	nop
}
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8024ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	52                   	push   %edx
  8024f9:	50                   	push   %eax
  8024fa:	6a 2a                	push   $0x2a
  8024fc:	e8 30 fa ff ff       	call   801f31 <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
	return;
  802504:	90                   	nop
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	50                   	push   %eax
  802516:	6a 2b                	push   $0x2b
  802518:	e8 14 fa ff ff       	call   801f31 <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
}
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	ff 75 0c             	pushl  0xc(%ebp)
  80252e:	ff 75 08             	pushl  0x8(%ebp)
  802531:	6a 2c                	push   $0x2c
  802533:	e8 f9 f9 ff ff       	call   801f31 <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
	return;
  80253b:	90                   	nop
}
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	ff 75 0c             	pushl  0xc(%ebp)
  80254a:	ff 75 08             	pushl  0x8(%ebp)
  80254d:	6a 2d                	push   $0x2d
  80254f:	e8 dd f9 ff ff       	call   801f31 <syscall>
  802554:	83 c4 18             	add    $0x18,%esp
	return;
  802557:	90                   	nop
}
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802560:	8b 45 08             	mov    0x8(%ebp),%eax
  802563:	83 e8 04             	sub    $0x4,%eax
  802566:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802569:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	83 e8 04             	sub    $0x4,%eax
  80257f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802582:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	83 e0 01             	and    $0x1,%eax
  80258a:	85 c0                	test   %eax,%eax
  80258c:	0f 94 c0             	sete   %al
}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
  802594:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802597:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80259e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a1:	83 f8 02             	cmp    $0x2,%eax
  8025a4:	74 2b                	je     8025d1 <alloc_block+0x40>
  8025a6:	83 f8 02             	cmp    $0x2,%eax
  8025a9:	7f 07                	jg     8025b2 <alloc_block+0x21>
  8025ab:	83 f8 01             	cmp    $0x1,%eax
  8025ae:	74 0e                	je     8025be <alloc_block+0x2d>
  8025b0:	eb 58                	jmp    80260a <alloc_block+0x79>
  8025b2:	83 f8 03             	cmp    $0x3,%eax
  8025b5:	74 2d                	je     8025e4 <alloc_block+0x53>
  8025b7:	83 f8 04             	cmp    $0x4,%eax
  8025ba:	74 3b                	je     8025f7 <alloc_block+0x66>
  8025bc:	eb 4c                	jmp    80260a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8025be:	83 ec 0c             	sub    $0xc,%esp
  8025c1:	ff 75 08             	pushl  0x8(%ebp)
  8025c4:	e8 11 03 00 00       	call   8028da <alloc_block_FF>
  8025c9:	83 c4 10             	add    $0x10,%esp
  8025cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025cf:	eb 4a                	jmp    80261b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8025d1:	83 ec 0c             	sub    $0xc,%esp
  8025d4:	ff 75 08             	pushl  0x8(%ebp)
  8025d7:	e8 fa 19 00 00       	call   803fd6 <alloc_block_NF>
  8025dc:	83 c4 10             	add    $0x10,%esp
  8025df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025e2:	eb 37                	jmp    80261b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8025e4:	83 ec 0c             	sub    $0xc,%esp
  8025e7:	ff 75 08             	pushl  0x8(%ebp)
  8025ea:	e8 a7 07 00 00       	call   802d96 <alloc_block_BF>
  8025ef:	83 c4 10             	add    $0x10,%esp
  8025f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025f5:	eb 24                	jmp    80261b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8025f7:	83 ec 0c             	sub    $0xc,%esp
  8025fa:	ff 75 08             	pushl  0x8(%ebp)
  8025fd:	e8 b7 19 00 00       	call   803fb9 <alloc_block_WF>
  802602:	83 c4 10             	add    $0x10,%esp
  802605:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802608:	eb 11                	jmp    80261b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80260a:	83 ec 0c             	sub    $0xc,%esp
  80260d:	68 ec 4a 80 00       	push   $0x804aec
  802612:	e8 56 e4 ff ff       	call   800a6d <cprintf>
  802617:	83 c4 10             	add    $0x10,%esp
		break;
  80261a:	90                   	nop
	}
	return va;
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	53                   	push   %ebx
  802624:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802627:	83 ec 0c             	sub    $0xc,%esp
  80262a:	68 0c 4b 80 00       	push   $0x804b0c
  80262f:	e8 39 e4 ff ff       	call   800a6d <cprintf>
  802634:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802637:	83 ec 0c             	sub    $0xc,%esp
  80263a:	68 37 4b 80 00       	push   $0x804b37
  80263f:	e8 29 e4 ff ff       	call   800a6d <cprintf>
  802644:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264d:	eb 37                	jmp    802686 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80264f:	83 ec 0c             	sub    $0xc,%esp
  802652:	ff 75 f4             	pushl  -0xc(%ebp)
  802655:	e8 19 ff ff ff       	call   802573 <is_free_block>
  80265a:	83 c4 10             	add    $0x10,%esp
  80265d:	0f be d8             	movsbl %al,%ebx
  802660:	83 ec 0c             	sub    $0xc,%esp
  802663:	ff 75 f4             	pushl  -0xc(%ebp)
  802666:	e8 ef fe ff ff       	call   80255a <get_block_size>
  80266b:	83 c4 10             	add    $0x10,%esp
  80266e:	83 ec 04             	sub    $0x4,%esp
  802671:	53                   	push   %ebx
  802672:	50                   	push   %eax
  802673:	68 4f 4b 80 00       	push   $0x804b4f
  802678:	e8 f0 e3 ff ff       	call   800a6d <cprintf>
  80267d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802680:	8b 45 10             	mov    0x10(%ebp),%eax
  802683:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268a:	74 07                	je     802693 <print_blocks_list+0x73>
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	eb 05                	jmp    802698 <print_blocks_list+0x78>
  802693:	b8 00 00 00 00       	mov    $0x0,%eax
  802698:	89 45 10             	mov    %eax,0x10(%ebp)
  80269b:	8b 45 10             	mov    0x10(%ebp),%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	75 ad                	jne    80264f <print_blocks_list+0x2f>
  8026a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a6:	75 a7                	jne    80264f <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8026a8:	83 ec 0c             	sub    $0xc,%esp
  8026ab:	68 0c 4b 80 00       	push   $0x804b0c
  8026b0:	e8 b8 e3 ff ff       	call   800a6d <cprintf>
  8026b5:	83 c4 10             	add    $0x10,%esp

}
  8026b8:	90                   	nop
  8026b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026bc:	c9                   	leave  
  8026bd:	c3                   	ret    

008026be <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8026c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c7:	83 e0 01             	and    $0x1,%eax
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	74 03                	je     8026d1 <initialize_dynamic_allocator+0x13>
  8026ce:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8026d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026d5:	0f 84 c7 01 00 00    	je     8028a2 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8026db:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8026e2:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8026e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026eb:	01 d0                	add    %edx,%eax
  8026ed:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8026f2:	0f 87 ad 01 00 00    	ja     8028a5 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	0f 89 a5 01 00 00    	jns    8028a8 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802703:	8b 55 08             	mov    0x8(%ebp),%edx
  802706:	8b 45 0c             	mov    0xc(%ebp),%eax
  802709:	01 d0                	add    %edx,%eax
  80270b:	83 e8 04             	sub    $0x4,%eax
  80270e:	a3 4c 50 80 00       	mov    %eax,0x80504c
     struct BlockElement * element = NULL;
  802713:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80271a:	a1 30 50 80 00       	mov    0x805030,%eax
  80271f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802722:	e9 87 00 00 00       	jmp    8027ae <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802727:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272b:	75 14                	jne    802741 <initialize_dynamic_allocator+0x83>
  80272d:	83 ec 04             	sub    $0x4,%esp
  802730:	68 67 4b 80 00       	push   $0x804b67
  802735:	6a 79                	push   $0x79
  802737:	68 85 4b 80 00       	push   $0x804b85
  80273c:	e8 6f e0 ff ff       	call   8007b0 <_panic>
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	85 c0                	test   %eax,%eax
  802748:	74 10                	je     80275a <initialize_dynamic_allocator+0x9c>
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 00                	mov    (%eax),%eax
  80274f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802752:	8b 52 04             	mov    0x4(%edx),%edx
  802755:	89 50 04             	mov    %edx,0x4(%eax)
  802758:	eb 0b                	jmp    802765 <initialize_dynamic_allocator+0xa7>
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 40 04             	mov    0x4(%eax),%eax
  802760:	a3 34 50 80 00       	mov    %eax,0x805034
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 40 04             	mov    0x4(%eax),%eax
  80276b:	85 c0                	test   %eax,%eax
  80276d:	74 0f                	je     80277e <initialize_dynamic_allocator+0xc0>
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 40 04             	mov    0x4(%eax),%eax
  802775:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802778:	8b 12                	mov    (%edx),%edx
  80277a:	89 10                	mov    %edx,(%eax)
  80277c:	eb 0a                	jmp    802788 <initialize_dynamic_allocator+0xca>
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 00                	mov    (%eax),%eax
  802783:	a3 30 50 80 00       	mov    %eax,0x805030
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027a0:	48                   	dec    %eax
  8027a1:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8027a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8027ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b2:	74 07                	je     8027bb <initialize_dynamic_allocator+0xfd>
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 00                	mov    (%eax),%eax
  8027b9:	eb 05                	jmp    8027c0 <initialize_dynamic_allocator+0x102>
  8027bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c0:	a3 38 50 80 00       	mov    %eax,0x805038
  8027c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	0f 85 55 ff ff ff    	jne    802727 <initialize_dynamic_allocator+0x69>
  8027d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d6:	0f 85 4b ff ff ff    	jne    802727 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8027e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e5:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8027eb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027f0:	a3 48 50 80 00       	mov    %eax,0x805048
    end_block->info = 1;
  8027f5:	a1 48 50 80 00       	mov    0x805048,%eax
  8027fa:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802800:	8b 45 08             	mov    0x8(%ebp),%eax
  802803:	83 c0 08             	add    $0x8,%eax
  802806:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	83 c0 04             	add    $0x4,%eax
  80280f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802812:	83 ea 08             	sub    $0x8,%edx
  802815:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	01 d0                	add    %edx,%eax
  80281f:	83 e8 08             	sub    $0x8,%eax
  802822:	8b 55 0c             	mov    0xc(%ebp),%edx
  802825:	83 ea 08             	sub    $0x8,%edx
  802828:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80282a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802836:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80283d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802841:	75 17                	jne    80285a <initialize_dynamic_allocator+0x19c>
  802843:	83 ec 04             	sub    $0x4,%esp
  802846:	68 a0 4b 80 00       	push   $0x804ba0
  80284b:	68 90 00 00 00       	push   $0x90
  802850:	68 85 4b 80 00       	push   $0x804b85
  802855:	e8 56 df ff ff       	call   8007b0 <_panic>
  80285a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802863:	89 10                	mov    %edx,(%eax)
  802865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	85 c0                	test   %eax,%eax
  80286c:	74 0d                	je     80287b <initialize_dynamic_allocator+0x1bd>
  80286e:	a1 30 50 80 00       	mov    0x805030,%eax
  802873:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802876:	89 50 04             	mov    %edx,0x4(%eax)
  802879:	eb 08                	jmp    802883 <initialize_dynamic_allocator+0x1c5>
  80287b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287e:	a3 34 50 80 00       	mov    %eax,0x805034
  802883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802886:	a3 30 50 80 00       	mov    %eax,0x805030
  80288b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802895:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80289a:	40                   	inc    %eax
  80289b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8028a0:	eb 07                	jmp    8028a9 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8028a2:	90                   	nop
  8028a3:	eb 04                	jmp    8028a9 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8028a5:	90                   	nop
  8028a6:	eb 01                	jmp    8028a9 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8028a8:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8028a9:	c9                   	leave  
  8028aa:	c3                   	ret    

008028ab <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8028ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8028b1:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8028b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028bd:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	83 e8 04             	sub    $0x4,%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	83 e0 fe             	and    $0xfffffffe,%eax
  8028ca:	8d 50 f8             	lea    -0x8(%eax),%edx
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	01 c2                	add    %eax,%edx
  8028d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028d5:	89 02                	mov    %eax,(%edx)
}
  8028d7:	90                   	nop
  8028d8:	5d                   	pop    %ebp
  8028d9:	c3                   	ret    

008028da <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8028da:	55                   	push   %ebp
  8028db:	89 e5                	mov    %esp,%ebp
  8028dd:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	83 e0 01             	and    $0x1,%eax
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	74 03                	je     8028ed <alloc_block_FF+0x13>
  8028ea:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028ed:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8028f1:	77 07                	ja     8028fa <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8028f3:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8028fa:	a1 28 50 80 00       	mov    0x805028,%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	75 73                	jne    802976 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	83 c0 10             	add    $0x10,%eax
  802909:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80290c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802913:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802919:	01 d0                	add    %edx,%eax
  80291b:	48                   	dec    %eax
  80291c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80291f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802922:	ba 00 00 00 00       	mov    $0x0,%edx
  802927:	f7 75 ec             	divl   -0x14(%ebp)
  80292a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292d:	29 d0                	sub    %edx,%eax
  80292f:	c1 e8 0c             	shr    $0xc,%eax
  802932:	83 ec 0c             	sub    $0xc,%esp
  802935:	50                   	push   %eax
  802936:	e8 d4 f0 ff ff       	call   801a0f <sbrk>
  80293b:	83 c4 10             	add    $0x10,%esp
  80293e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802941:	83 ec 0c             	sub    $0xc,%esp
  802944:	6a 00                	push   $0x0
  802946:	e8 c4 f0 ff ff       	call   801a0f <sbrk>
  80294b:	83 c4 10             	add    $0x10,%esp
  80294e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802954:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802957:	83 ec 08             	sub    $0x8,%esp
  80295a:	50                   	push   %eax
  80295b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80295e:	e8 5b fd ff ff       	call   8026be <initialize_dynamic_allocator>
  802963:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802966:	83 ec 0c             	sub    $0xc,%esp
  802969:	68 c3 4b 80 00       	push   $0x804bc3
  80296e:	e8 fa e0 ff ff       	call   800a6d <cprintf>
  802973:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802976:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80297a:	75 0a                	jne    802986 <alloc_block_FF+0xac>
	        return NULL;
  80297c:	b8 00 00 00 00       	mov    $0x0,%eax
  802981:	e9 0e 04 00 00       	jmp    802d94 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802986:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80298d:	a1 30 50 80 00       	mov    0x805030,%eax
  802992:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802995:	e9 f3 02 00 00       	jmp    802c8d <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8029a0:	83 ec 0c             	sub    $0xc,%esp
  8029a3:	ff 75 bc             	pushl  -0x44(%ebp)
  8029a6:	e8 af fb ff ff       	call   80255a <get_block_size>
  8029ab:	83 c4 10             	add    $0x10,%esp
  8029ae:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	83 c0 08             	add    $0x8,%eax
  8029b7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029ba:	0f 87 c5 02 00 00    	ja     802c85 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	83 c0 18             	add    $0x18,%eax
  8029c6:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029c9:	0f 87 19 02 00 00    	ja     802be8 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8029cf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029d2:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d5:	83 e8 08             	sub    $0x8,%eax
  8029d8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8029db:	8b 45 08             	mov    0x8(%ebp),%eax
  8029de:	8d 50 08             	lea    0x8(%eax),%edx
  8029e1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029e4:	01 d0                	add    %edx,%eax
  8029e6:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8029e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ec:	83 c0 08             	add    $0x8,%eax
  8029ef:	83 ec 04             	sub    $0x4,%esp
  8029f2:	6a 01                	push   $0x1
  8029f4:	50                   	push   %eax
  8029f5:	ff 75 bc             	pushl  -0x44(%ebp)
  8029f8:	e8 ae fe ff ff       	call   8028ab <set_block_data>
  8029fd:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 40 04             	mov    0x4(%eax),%eax
  802a06:	85 c0                	test   %eax,%eax
  802a08:	75 68                	jne    802a72 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a0a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a0e:	75 17                	jne    802a27 <alloc_block_FF+0x14d>
  802a10:	83 ec 04             	sub    $0x4,%esp
  802a13:	68 a0 4b 80 00       	push   $0x804ba0
  802a18:	68 d7 00 00 00       	push   $0xd7
  802a1d:	68 85 4b 80 00       	push   $0x804b85
  802a22:	e8 89 dd ff ff       	call   8007b0 <_panic>
  802a27:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a2d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a30:	89 10                	mov    %edx,(%eax)
  802a32:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a35:	8b 00                	mov    (%eax),%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	74 0d                	je     802a48 <alloc_block_FF+0x16e>
  802a3b:	a1 30 50 80 00       	mov    0x805030,%eax
  802a40:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a43:	89 50 04             	mov    %edx,0x4(%eax)
  802a46:	eb 08                	jmp    802a50 <alloc_block_FF+0x176>
  802a48:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a4b:	a3 34 50 80 00       	mov    %eax,0x805034
  802a50:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a53:	a3 30 50 80 00       	mov    %eax,0x805030
  802a58:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a62:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a67:	40                   	inc    %eax
  802a68:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a6d:	e9 dc 00 00 00       	jmp    802b4e <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	85 c0                	test   %eax,%eax
  802a79:	75 65                	jne    802ae0 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a7b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a7f:	75 17                	jne    802a98 <alloc_block_FF+0x1be>
  802a81:	83 ec 04             	sub    $0x4,%esp
  802a84:	68 d4 4b 80 00       	push   $0x804bd4
  802a89:	68 db 00 00 00       	push   $0xdb
  802a8e:	68 85 4b 80 00       	push   $0x804b85
  802a93:	e8 18 dd ff ff       	call   8007b0 <_panic>
  802a98:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802a9e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aa1:	89 50 04             	mov    %edx,0x4(%eax)
  802aa4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aa7:	8b 40 04             	mov    0x4(%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 0c                	je     802aba <alloc_block_FF+0x1e0>
  802aae:	a1 34 50 80 00       	mov    0x805034,%eax
  802ab3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ab6:	89 10                	mov    %edx,(%eax)
  802ab8:	eb 08                	jmp    802ac2 <alloc_block_FF+0x1e8>
  802aba:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802abd:	a3 30 50 80 00       	mov    %eax,0x805030
  802ac2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac5:	a3 34 50 80 00       	mov    %eax,0x805034
  802aca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802acd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ad8:	40                   	inc    %eax
  802ad9:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ade:	eb 6e                	jmp    802b4e <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802ae0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae4:	74 06                	je     802aec <alloc_block_FF+0x212>
  802ae6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802aea:	75 17                	jne    802b03 <alloc_block_FF+0x229>
  802aec:	83 ec 04             	sub    $0x4,%esp
  802aef:	68 f8 4b 80 00       	push   $0x804bf8
  802af4:	68 df 00 00 00       	push   $0xdf
  802af9:	68 85 4b 80 00       	push   $0x804b85
  802afe:	e8 ad dc ff ff       	call   8007b0 <_panic>
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 10                	mov    (%eax),%edx
  802b08:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b0b:	89 10                	mov    %edx,(%eax)
  802b0d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b10:	8b 00                	mov    (%eax),%eax
  802b12:	85 c0                	test   %eax,%eax
  802b14:	74 0b                	je     802b21 <alloc_block_FF+0x247>
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 00                	mov    (%eax),%eax
  802b1b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b1e:	89 50 04             	mov    %edx,0x4(%eax)
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b27:	89 10                	mov    %edx,(%eax)
  802b29:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2f:	89 50 04             	mov    %edx,0x4(%eax)
  802b32:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b35:	8b 00                	mov    (%eax),%eax
  802b37:	85 c0                	test   %eax,%eax
  802b39:	75 08                	jne    802b43 <alloc_block_FF+0x269>
  802b3b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b3e:	a3 34 50 80 00       	mov    %eax,0x805034
  802b43:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b48:	40                   	inc    %eax
  802b49:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802b4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b52:	75 17                	jne    802b6b <alloc_block_FF+0x291>
  802b54:	83 ec 04             	sub    $0x4,%esp
  802b57:	68 67 4b 80 00       	push   $0x804b67
  802b5c:	68 e1 00 00 00       	push   $0xe1
  802b61:	68 85 4b 80 00       	push   $0x804b85
  802b66:	e8 45 dc ff ff       	call   8007b0 <_panic>
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 00                	mov    (%eax),%eax
  802b70:	85 c0                	test   %eax,%eax
  802b72:	74 10                	je     802b84 <alloc_block_FF+0x2aa>
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7c:	8b 52 04             	mov    0x4(%edx),%edx
  802b7f:	89 50 04             	mov    %edx,0x4(%eax)
  802b82:	eb 0b                	jmp    802b8f <alloc_block_FF+0x2b5>
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 40 04             	mov    0x4(%eax),%eax
  802b8a:	a3 34 50 80 00       	mov    %eax,0x805034
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 40 04             	mov    0x4(%eax),%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	74 0f                	je     802ba8 <alloc_block_FF+0x2ce>
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 40 04             	mov    0x4(%eax),%eax
  802b9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba2:	8b 12                	mov    (%edx),%edx
  802ba4:	89 10                	mov    %edx,(%eax)
  802ba6:	eb 0a                	jmp    802bb2 <alloc_block_FF+0x2d8>
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	a3 30 50 80 00       	mov    %eax,0x805030
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bca:	48                   	dec    %eax
  802bcb:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802bd0:	83 ec 04             	sub    $0x4,%esp
  802bd3:	6a 00                	push   $0x0
  802bd5:	ff 75 b4             	pushl  -0x4c(%ebp)
  802bd8:	ff 75 b0             	pushl  -0x50(%ebp)
  802bdb:	e8 cb fc ff ff       	call   8028ab <set_block_data>
  802be0:	83 c4 10             	add    $0x10,%esp
  802be3:	e9 95 00 00 00       	jmp    802c7d <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802be8:	83 ec 04             	sub    $0x4,%esp
  802beb:	6a 01                	push   $0x1
  802bed:	ff 75 b8             	pushl  -0x48(%ebp)
  802bf0:	ff 75 bc             	pushl  -0x44(%ebp)
  802bf3:	e8 b3 fc ff ff       	call   8028ab <set_block_data>
  802bf8:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802bfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bff:	75 17                	jne    802c18 <alloc_block_FF+0x33e>
  802c01:	83 ec 04             	sub    $0x4,%esp
  802c04:	68 67 4b 80 00       	push   $0x804b67
  802c09:	68 e8 00 00 00       	push   $0xe8
  802c0e:	68 85 4b 80 00       	push   $0x804b85
  802c13:	e8 98 db ff ff       	call   8007b0 <_panic>
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	8b 00                	mov    (%eax),%eax
  802c1d:	85 c0                	test   %eax,%eax
  802c1f:	74 10                	je     802c31 <alloc_block_FF+0x357>
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c29:	8b 52 04             	mov    0x4(%edx),%edx
  802c2c:	89 50 04             	mov    %edx,0x4(%eax)
  802c2f:	eb 0b                	jmp    802c3c <alloc_block_FF+0x362>
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 40 04             	mov    0x4(%eax),%eax
  802c37:	a3 34 50 80 00       	mov    %eax,0x805034
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	8b 40 04             	mov    0x4(%eax),%eax
  802c42:	85 c0                	test   %eax,%eax
  802c44:	74 0f                	je     802c55 <alloc_block_FF+0x37b>
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 40 04             	mov    0x4(%eax),%eax
  802c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4f:	8b 12                	mov    (%edx),%edx
  802c51:	89 10                	mov    %edx,(%eax)
  802c53:	eb 0a                	jmp    802c5f <alloc_block_FF+0x385>
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 00                	mov    (%eax),%eax
  802c5a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c72:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c77:	48                   	dec    %eax
  802c78:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802c7d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c80:	e9 0f 01 00 00       	jmp    802d94 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c85:	a1 38 50 80 00       	mov    0x805038,%eax
  802c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c91:	74 07                	je     802c9a <alloc_block_FF+0x3c0>
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 00                	mov    (%eax),%eax
  802c98:	eb 05                	jmp    802c9f <alloc_block_FF+0x3c5>
  802c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9f:	a3 38 50 80 00       	mov    %eax,0x805038
  802ca4:	a1 38 50 80 00       	mov    0x805038,%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	0f 85 e9 fc ff ff    	jne    80299a <alloc_block_FF+0xc0>
  802cb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb5:	0f 85 df fc ff ff    	jne    80299a <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	83 c0 08             	add    $0x8,%eax
  802cc1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cc4:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802ccb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cd1:	01 d0                	add    %edx,%eax
  802cd3:	48                   	dec    %eax
  802cd4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802cd7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cda:	ba 00 00 00 00       	mov    $0x0,%edx
  802cdf:	f7 75 d8             	divl   -0x28(%ebp)
  802ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ce5:	29 d0                	sub    %edx,%eax
  802ce7:	c1 e8 0c             	shr    $0xc,%eax
  802cea:	83 ec 0c             	sub    $0xc,%esp
  802ced:	50                   	push   %eax
  802cee:	e8 1c ed ff ff       	call   801a0f <sbrk>
  802cf3:	83 c4 10             	add    $0x10,%esp
  802cf6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802cf9:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802cfd:	75 0a                	jne    802d09 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802cff:	b8 00 00 00 00       	mov    $0x0,%eax
  802d04:	e9 8b 00 00 00       	jmp    802d94 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d09:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d10:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d13:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d16:	01 d0                	add    %edx,%eax
  802d18:	48                   	dec    %eax
  802d19:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802d1c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d1f:	ba 00 00 00 00       	mov    $0x0,%edx
  802d24:	f7 75 cc             	divl   -0x34(%ebp)
  802d27:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d2a:	29 d0                	sub    %edx,%eax
  802d2c:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d32:	01 d0                	add    %edx,%eax
  802d34:	a3 48 50 80 00       	mov    %eax,0x805048
			end_block->info = 1;
  802d39:	a1 48 50 80 00       	mov    0x805048,%eax
  802d3e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d44:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d4e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d51:	01 d0                	add    %edx,%eax
  802d53:	48                   	dec    %eax
  802d54:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d57:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d5a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5f:	f7 75 c4             	divl   -0x3c(%ebp)
  802d62:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d65:	29 d0                	sub    %edx,%eax
  802d67:	83 ec 04             	sub    $0x4,%esp
  802d6a:	6a 01                	push   $0x1
  802d6c:	50                   	push   %eax
  802d6d:	ff 75 d0             	pushl  -0x30(%ebp)
  802d70:	e8 36 fb ff ff       	call   8028ab <set_block_data>
  802d75:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802d78:	83 ec 0c             	sub    $0xc,%esp
  802d7b:	ff 75 d0             	pushl  -0x30(%ebp)
  802d7e:	e8 1b 0a 00 00       	call   80379e <free_block>
  802d83:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802d86:	83 ec 0c             	sub    $0xc,%esp
  802d89:	ff 75 08             	pushl  0x8(%ebp)
  802d8c:	e8 49 fb ff ff       	call   8028da <alloc_block_FF>
  802d91:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802d94:	c9                   	leave  
  802d95:	c3                   	ret    

00802d96 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802d96:	55                   	push   %ebp
  802d97:	89 e5                	mov    %esp,%ebp
  802d99:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	83 e0 01             	and    $0x1,%eax
  802da2:	85 c0                	test   %eax,%eax
  802da4:	74 03                	je     802da9 <alloc_block_BF+0x13>
  802da6:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802da9:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802dad:	77 07                	ja     802db6 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802daf:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802db6:	a1 28 50 80 00       	mov    0x805028,%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	75 73                	jne    802e32 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	83 c0 10             	add    $0x10,%eax
  802dc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802dc8:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802dcf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd5:	01 d0                	add    %edx,%eax
  802dd7:	48                   	dec    %eax
  802dd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ddb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dde:	ba 00 00 00 00       	mov    $0x0,%edx
  802de3:	f7 75 e0             	divl   -0x20(%ebp)
  802de6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de9:	29 d0                	sub    %edx,%eax
  802deb:	c1 e8 0c             	shr    $0xc,%eax
  802dee:	83 ec 0c             	sub    $0xc,%esp
  802df1:	50                   	push   %eax
  802df2:	e8 18 ec ff ff       	call   801a0f <sbrk>
  802df7:	83 c4 10             	add    $0x10,%esp
  802dfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802dfd:	83 ec 0c             	sub    $0xc,%esp
  802e00:	6a 00                	push   $0x0
  802e02:	e8 08 ec ff ff       	call   801a0f <sbrk>
  802e07:	83 c4 10             	add    $0x10,%esp
  802e0a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e10:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802e13:	83 ec 08             	sub    $0x8,%esp
  802e16:	50                   	push   %eax
  802e17:	ff 75 d8             	pushl  -0x28(%ebp)
  802e1a:	e8 9f f8 ff ff       	call   8026be <initialize_dynamic_allocator>
  802e1f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e22:	83 ec 0c             	sub    $0xc,%esp
  802e25:	68 c3 4b 80 00       	push   $0x804bc3
  802e2a:	e8 3e dc ff ff       	call   800a6d <cprintf>
  802e2f:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802e32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802e39:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802e40:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802e47:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802e4e:	a1 30 50 80 00       	mov    0x805030,%eax
  802e53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e56:	e9 1d 01 00 00       	jmp    802f78 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e61:	83 ec 0c             	sub    $0xc,%esp
  802e64:	ff 75 a8             	pushl  -0x58(%ebp)
  802e67:	e8 ee f6 ff ff       	call   80255a <get_block_size>
  802e6c:	83 c4 10             	add    $0x10,%esp
  802e6f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	83 c0 08             	add    $0x8,%eax
  802e78:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e7b:	0f 87 ef 00 00 00    	ja     802f70 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	83 c0 18             	add    $0x18,%eax
  802e87:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e8a:	77 1d                	ja     802ea9 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802e8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e92:	0f 86 d8 00 00 00    	jbe    802f70 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802e98:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802e9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802e9e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ea1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ea4:	e9 c7 00 00 00       	jmp    802f70 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	83 c0 08             	add    $0x8,%eax
  802eaf:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802eb2:	0f 85 9d 00 00 00    	jne    802f55 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802eb8:	83 ec 04             	sub    $0x4,%esp
  802ebb:	6a 01                	push   $0x1
  802ebd:	ff 75 a4             	pushl  -0x5c(%ebp)
  802ec0:	ff 75 a8             	pushl  -0x58(%ebp)
  802ec3:	e8 e3 f9 ff ff       	call   8028ab <set_block_data>
  802ec8:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802ecb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecf:	75 17                	jne    802ee8 <alloc_block_BF+0x152>
  802ed1:	83 ec 04             	sub    $0x4,%esp
  802ed4:	68 67 4b 80 00       	push   $0x804b67
  802ed9:	68 2c 01 00 00       	push   $0x12c
  802ede:	68 85 4b 80 00       	push   $0x804b85
  802ee3:	e8 c8 d8 ff ff       	call   8007b0 <_panic>
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 00                	mov    (%eax),%eax
  802eed:	85 c0                	test   %eax,%eax
  802eef:	74 10                	je     802f01 <alloc_block_BF+0x16b>
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef9:	8b 52 04             	mov    0x4(%edx),%edx
  802efc:	89 50 04             	mov    %edx,0x4(%eax)
  802eff:	eb 0b                	jmp    802f0c <alloc_block_BF+0x176>
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 40 04             	mov    0x4(%eax),%eax
  802f07:	a3 34 50 80 00       	mov    %eax,0x805034
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 40 04             	mov    0x4(%eax),%eax
  802f12:	85 c0                	test   %eax,%eax
  802f14:	74 0f                	je     802f25 <alloc_block_BF+0x18f>
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	8b 40 04             	mov    0x4(%eax),%eax
  802f1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1f:	8b 12                	mov    (%edx),%edx
  802f21:	89 10                	mov    %edx,(%eax)
  802f23:	eb 0a                	jmp    802f2f <alloc_block_BF+0x199>
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	a3 30 50 80 00       	mov    %eax,0x805030
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f42:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f47:	48                   	dec    %eax
  802f48:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802f4d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f50:	e9 24 04 00 00       	jmp    803379 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f58:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f5b:	76 13                	jbe    802f70 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f5d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f64:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f67:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802f6a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f6d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802f70:	a1 38 50 80 00       	mov    0x805038,%eax
  802f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7c:	74 07                	je     802f85 <alloc_block_BF+0x1ef>
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	eb 05                	jmp    802f8a <alloc_block_BF+0x1f4>
  802f85:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8a:	a3 38 50 80 00       	mov    %eax,0x805038
  802f8f:	a1 38 50 80 00       	mov    0x805038,%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	0f 85 bf fe ff ff    	jne    802e5b <alloc_block_BF+0xc5>
  802f9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa0:	0f 85 b5 fe ff ff    	jne    802e5b <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802fa6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802faa:	0f 84 26 02 00 00    	je     8031d6 <alloc_block_BF+0x440>
  802fb0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fb4:	0f 85 1c 02 00 00    	jne    8031d6 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802fba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbd:	2b 45 08             	sub    0x8(%ebp),%eax
  802fc0:	83 e8 08             	sub    $0x8,%eax
  802fc3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	8d 50 08             	lea    0x8(%eax),%edx
  802fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcf:	01 d0                	add    %edx,%eax
  802fd1:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	83 c0 08             	add    $0x8,%eax
  802fda:	83 ec 04             	sub    $0x4,%esp
  802fdd:	6a 01                	push   $0x1
  802fdf:	50                   	push   %eax
  802fe0:	ff 75 f0             	pushl  -0x10(%ebp)
  802fe3:	e8 c3 f8 ff ff       	call   8028ab <set_block_data>
  802fe8:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802feb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fee:	8b 40 04             	mov    0x4(%eax),%eax
  802ff1:	85 c0                	test   %eax,%eax
  802ff3:	75 68                	jne    80305d <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802ff5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ff9:	75 17                	jne    803012 <alloc_block_BF+0x27c>
  802ffb:	83 ec 04             	sub    $0x4,%esp
  802ffe:	68 a0 4b 80 00       	push   $0x804ba0
  803003:	68 45 01 00 00       	push   $0x145
  803008:	68 85 4b 80 00       	push   $0x804b85
  80300d:	e8 9e d7 ff ff       	call   8007b0 <_panic>
  803012:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803018:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80301b:	89 10                	mov    %edx,(%eax)
  80301d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	85 c0                	test   %eax,%eax
  803024:	74 0d                	je     803033 <alloc_block_BF+0x29d>
  803026:	a1 30 50 80 00       	mov    0x805030,%eax
  80302b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80302e:	89 50 04             	mov    %edx,0x4(%eax)
  803031:	eb 08                	jmp    80303b <alloc_block_BF+0x2a5>
  803033:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803036:	a3 34 50 80 00       	mov    %eax,0x805034
  80303b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80303e:	a3 30 50 80 00       	mov    %eax,0x805030
  803043:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803046:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803052:	40                   	inc    %eax
  803053:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803058:	e9 dc 00 00 00       	jmp    803139 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80305d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803060:	8b 00                	mov    (%eax),%eax
  803062:	85 c0                	test   %eax,%eax
  803064:	75 65                	jne    8030cb <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803066:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80306a:	75 17                	jne    803083 <alloc_block_BF+0x2ed>
  80306c:	83 ec 04             	sub    $0x4,%esp
  80306f:	68 d4 4b 80 00       	push   $0x804bd4
  803074:	68 4a 01 00 00       	push   $0x14a
  803079:	68 85 4b 80 00       	push   $0x804b85
  80307e:	e8 2d d7 ff ff       	call   8007b0 <_panic>
  803083:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803089:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80308c:	89 50 04             	mov    %edx,0x4(%eax)
  80308f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803092:	8b 40 04             	mov    0x4(%eax),%eax
  803095:	85 c0                	test   %eax,%eax
  803097:	74 0c                	je     8030a5 <alloc_block_BF+0x30f>
  803099:	a1 34 50 80 00       	mov    0x805034,%eax
  80309e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030a1:	89 10                	mov    %edx,(%eax)
  8030a3:	eb 08                	jmp    8030ad <alloc_block_BF+0x317>
  8030a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a8:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b0:	a3 34 50 80 00       	mov    %eax,0x805034
  8030b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030be:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030c3:	40                   	inc    %eax
  8030c4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8030c9:	eb 6e                	jmp    803139 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8030cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030cf:	74 06                	je     8030d7 <alloc_block_BF+0x341>
  8030d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030d5:	75 17                	jne    8030ee <alloc_block_BF+0x358>
  8030d7:	83 ec 04             	sub    $0x4,%esp
  8030da:	68 f8 4b 80 00       	push   $0x804bf8
  8030df:	68 4f 01 00 00       	push   $0x14f
  8030e4:	68 85 4b 80 00       	push   $0x804b85
  8030e9:	e8 c2 d6 ff ff       	call   8007b0 <_panic>
  8030ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f1:	8b 10                	mov    (%eax),%edx
  8030f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030f6:	89 10                	mov    %edx,(%eax)
  8030f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	85 c0                	test   %eax,%eax
  8030ff:	74 0b                	je     80310c <alloc_block_BF+0x376>
  803101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803104:	8b 00                	mov    (%eax),%eax
  803106:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803109:	89 50 04             	mov    %edx,0x4(%eax)
  80310c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803112:	89 10                	mov    %edx,(%eax)
  803114:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803117:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80311a:	89 50 04             	mov    %edx,0x4(%eax)
  80311d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	85 c0                	test   %eax,%eax
  803124:	75 08                	jne    80312e <alloc_block_BF+0x398>
  803126:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803129:	a3 34 50 80 00       	mov    %eax,0x805034
  80312e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803133:	40                   	inc    %eax
  803134:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  803139:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80313d:	75 17                	jne    803156 <alloc_block_BF+0x3c0>
  80313f:	83 ec 04             	sub    $0x4,%esp
  803142:	68 67 4b 80 00       	push   $0x804b67
  803147:	68 51 01 00 00       	push   $0x151
  80314c:	68 85 4b 80 00       	push   $0x804b85
  803151:	e8 5a d6 ff ff       	call   8007b0 <_panic>
  803156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803159:	8b 00                	mov    (%eax),%eax
  80315b:	85 c0                	test   %eax,%eax
  80315d:	74 10                	je     80316f <alloc_block_BF+0x3d9>
  80315f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803162:	8b 00                	mov    (%eax),%eax
  803164:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803167:	8b 52 04             	mov    0x4(%edx),%edx
  80316a:	89 50 04             	mov    %edx,0x4(%eax)
  80316d:	eb 0b                	jmp    80317a <alloc_block_BF+0x3e4>
  80316f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803172:	8b 40 04             	mov    0x4(%eax),%eax
  803175:	a3 34 50 80 00       	mov    %eax,0x805034
  80317a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317d:	8b 40 04             	mov    0x4(%eax),%eax
  803180:	85 c0                	test   %eax,%eax
  803182:	74 0f                	je     803193 <alloc_block_BF+0x3fd>
  803184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803187:	8b 40 04             	mov    0x4(%eax),%eax
  80318a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80318d:	8b 12                	mov    (%edx),%edx
  80318f:	89 10                	mov    %edx,(%eax)
  803191:	eb 0a                	jmp    80319d <alloc_block_BF+0x407>
  803193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803196:	8b 00                	mov    (%eax),%eax
  803198:	a3 30 50 80 00       	mov    %eax,0x805030
  80319d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031b5:	48                   	dec    %eax
  8031b6:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8031bb:	83 ec 04             	sub    $0x4,%esp
  8031be:	6a 00                	push   $0x0
  8031c0:	ff 75 d0             	pushl  -0x30(%ebp)
  8031c3:	ff 75 cc             	pushl  -0x34(%ebp)
  8031c6:	e8 e0 f6 ff ff       	call   8028ab <set_block_data>
  8031cb:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8031ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d1:	e9 a3 01 00 00       	jmp    803379 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8031d6:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8031da:	0f 85 9d 00 00 00    	jne    80327d <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8031e0:	83 ec 04             	sub    $0x4,%esp
  8031e3:	6a 01                	push   $0x1
  8031e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8031e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8031eb:	e8 bb f6 ff ff       	call   8028ab <set_block_data>
  8031f0:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8031f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031f7:	75 17                	jne    803210 <alloc_block_BF+0x47a>
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 67 4b 80 00       	push   $0x804b67
  803201:	68 58 01 00 00       	push   $0x158
  803206:	68 85 4b 80 00       	push   $0x804b85
  80320b:	e8 a0 d5 ff ff       	call   8007b0 <_panic>
  803210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 10                	je     803229 <alloc_block_BF+0x493>
  803219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803221:	8b 52 04             	mov    0x4(%edx),%edx
  803224:	89 50 04             	mov    %edx,0x4(%eax)
  803227:	eb 0b                	jmp    803234 <alloc_block_BF+0x49e>
  803229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322c:	8b 40 04             	mov    0x4(%eax),%eax
  80322f:	a3 34 50 80 00       	mov    %eax,0x805034
  803234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803237:	8b 40 04             	mov    0x4(%eax),%eax
  80323a:	85 c0                	test   %eax,%eax
  80323c:	74 0f                	je     80324d <alloc_block_BF+0x4b7>
  80323e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803241:	8b 40 04             	mov    0x4(%eax),%eax
  803244:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803247:	8b 12                	mov    (%edx),%edx
  803249:	89 10                	mov    %edx,(%eax)
  80324b:	eb 0a                	jmp    803257 <alloc_block_BF+0x4c1>
  80324d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	a3 30 50 80 00       	mov    %eax,0x805030
  803257:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803263:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80326f:	48                   	dec    %eax
  803270:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  803275:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803278:	e9 fc 00 00 00       	jmp    803379 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80327d:	8b 45 08             	mov    0x8(%ebp),%eax
  803280:	83 c0 08             	add    $0x8,%eax
  803283:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803286:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80328d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803290:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803293:	01 d0                	add    %edx,%eax
  803295:	48                   	dec    %eax
  803296:	89 45 c0             	mov    %eax,-0x40(%ebp)
  803299:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80329c:	ba 00 00 00 00       	mov    $0x0,%edx
  8032a1:	f7 75 c4             	divl   -0x3c(%ebp)
  8032a4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032a7:	29 d0                	sub    %edx,%eax
  8032a9:	c1 e8 0c             	shr    $0xc,%eax
  8032ac:	83 ec 0c             	sub    $0xc,%esp
  8032af:	50                   	push   %eax
  8032b0:	e8 5a e7 ff ff       	call   801a0f <sbrk>
  8032b5:	83 c4 10             	add    $0x10,%esp
  8032b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8032bb:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8032bf:	75 0a                	jne    8032cb <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8032c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c6:	e9 ae 00 00 00       	jmp    803379 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8032cb:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8032d2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8032d8:	01 d0                	add    %edx,%eax
  8032da:	48                   	dec    %eax
  8032db:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8032de:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8032e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8032e6:	f7 75 b8             	divl   -0x48(%ebp)
  8032e9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8032ec:	29 d0                	sub    %edx,%eax
  8032ee:	8d 50 fc             	lea    -0x4(%eax),%edx
  8032f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8032f4:	01 d0                	add    %edx,%eax
  8032f6:	a3 48 50 80 00       	mov    %eax,0x805048
				end_block->info = 1;
  8032fb:	a1 48 50 80 00       	mov    0x805048,%eax
  803300:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  803306:	83 ec 0c             	sub    $0xc,%esp
  803309:	68 2c 4c 80 00       	push   $0x804c2c
  80330e:	e8 5a d7 ff ff       	call   800a6d <cprintf>
  803313:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  803316:	83 ec 08             	sub    $0x8,%esp
  803319:	ff 75 bc             	pushl  -0x44(%ebp)
  80331c:	68 31 4c 80 00       	push   $0x804c31
  803321:	e8 47 d7 ff ff       	call   800a6d <cprintf>
  803326:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803329:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803330:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803333:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803336:	01 d0                	add    %edx,%eax
  803338:	48                   	dec    %eax
  803339:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80333c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80333f:	ba 00 00 00 00       	mov    $0x0,%edx
  803344:	f7 75 b0             	divl   -0x50(%ebp)
  803347:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80334a:	29 d0                	sub    %edx,%eax
  80334c:	83 ec 04             	sub    $0x4,%esp
  80334f:	6a 01                	push   $0x1
  803351:	50                   	push   %eax
  803352:	ff 75 bc             	pushl  -0x44(%ebp)
  803355:	e8 51 f5 ff ff       	call   8028ab <set_block_data>
  80335a:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80335d:	83 ec 0c             	sub    $0xc,%esp
  803360:	ff 75 bc             	pushl  -0x44(%ebp)
  803363:	e8 36 04 00 00       	call   80379e <free_block>
  803368:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80336b:	83 ec 0c             	sub    $0xc,%esp
  80336e:	ff 75 08             	pushl  0x8(%ebp)
  803371:	e8 20 fa ff ff       	call   802d96 <alloc_block_BF>
  803376:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803379:	c9                   	leave  
  80337a:	c3                   	ret    

0080337b <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80337b:	55                   	push   %ebp
  80337c:	89 e5                	mov    %esp,%ebp
  80337e:	53                   	push   %ebx
  80337f:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803389:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  803390:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803394:	74 1e                	je     8033b4 <merging+0x39>
  803396:	ff 75 08             	pushl  0x8(%ebp)
  803399:	e8 bc f1 ff ff       	call   80255a <get_block_size>
  80339e:	83 c4 04             	add    $0x4,%esp
  8033a1:	89 c2                	mov    %eax,%edx
  8033a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a6:	01 d0                	add    %edx,%eax
  8033a8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8033ab:	75 07                	jne    8033b4 <merging+0x39>
		prev_is_free = 1;
  8033ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8033b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033b8:	74 1e                	je     8033d8 <merging+0x5d>
  8033ba:	ff 75 10             	pushl  0x10(%ebp)
  8033bd:	e8 98 f1 ff ff       	call   80255a <get_block_size>
  8033c2:	83 c4 04             	add    $0x4,%esp
  8033c5:	89 c2                	mov    %eax,%edx
  8033c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8033ca:	01 d0                	add    %edx,%eax
  8033cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033cf:	75 07                	jne    8033d8 <merging+0x5d>
		next_is_free = 1;
  8033d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8033d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033dc:	0f 84 cc 00 00 00    	je     8034ae <merging+0x133>
  8033e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033e6:	0f 84 c2 00 00 00    	je     8034ae <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8033ec:	ff 75 08             	pushl  0x8(%ebp)
  8033ef:	e8 66 f1 ff ff       	call   80255a <get_block_size>
  8033f4:	83 c4 04             	add    $0x4,%esp
  8033f7:	89 c3                	mov    %eax,%ebx
  8033f9:	ff 75 10             	pushl  0x10(%ebp)
  8033fc:	e8 59 f1 ff ff       	call   80255a <get_block_size>
  803401:	83 c4 04             	add    $0x4,%esp
  803404:	01 c3                	add    %eax,%ebx
  803406:	ff 75 0c             	pushl  0xc(%ebp)
  803409:	e8 4c f1 ff ff       	call   80255a <get_block_size>
  80340e:	83 c4 04             	add    $0x4,%esp
  803411:	01 d8                	add    %ebx,%eax
  803413:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803416:	6a 00                	push   $0x0
  803418:	ff 75 ec             	pushl  -0x14(%ebp)
  80341b:	ff 75 08             	pushl  0x8(%ebp)
  80341e:	e8 88 f4 ff ff       	call   8028ab <set_block_data>
  803423:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803426:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80342a:	75 17                	jne    803443 <merging+0xc8>
  80342c:	83 ec 04             	sub    $0x4,%esp
  80342f:	68 67 4b 80 00       	push   $0x804b67
  803434:	68 7d 01 00 00       	push   $0x17d
  803439:	68 85 4b 80 00       	push   $0x804b85
  80343e:	e8 6d d3 ff ff       	call   8007b0 <_panic>
  803443:	8b 45 0c             	mov    0xc(%ebp),%eax
  803446:	8b 00                	mov    (%eax),%eax
  803448:	85 c0                	test   %eax,%eax
  80344a:	74 10                	je     80345c <merging+0xe1>
  80344c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344f:	8b 00                	mov    (%eax),%eax
  803451:	8b 55 0c             	mov    0xc(%ebp),%edx
  803454:	8b 52 04             	mov    0x4(%edx),%edx
  803457:	89 50 04             	mov    %edx,0x4(%eax)
  80345a:	eb 0b                	jmp    803467 <merging+0xec>
  80345c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80345f:	8b 40 04             	mov    0x4(%eax),%eax
  803462:	a3 34 50 80 00       	mov    %eax,0x805034
  803467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346a:	8b 40 04             	mov    0x4(%eax),%eax
  80346d:	85 c0                	test   %eax,%eax
  80346f:	74 0f                	je     803480 <merging+0x105>
  803471:	8b 45 0c             	mov    0xc(%ebp),%eax
  803474:	8b 40 04             	mov    0x4(%eax),%eax
  803477:	8b 55 0c             	mov    0xc(%ebp),%edx
  80347a:	8b 12                	mov    (%edx),%edx
  80347c:	89 10                	mov    %edx,(%eax)
  80347e:	eb 0a                	jmp    80348a <merging+0x10f>
  803480:	8b 45 0c             	mov    0xc(%ebp),%eax
  803483:	8b 00                	mov    (%eax),%eax
  803485:	a3 30 50 80 00       	mov    %eax,0x805030
  80348a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803493:	8b 45 0c             	mov    0xc(%ebp),%eax
  803496:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034a2:	48                   	dec    %eax
  8034a3:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  8034a8:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034a9:	e9 ea 02 00 00       	jmp    803798 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  8034ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b2:	74 3b                	je     8034ef <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8034b4:	83 ec 0c             	sub    $0xc,%esp
  8034b7:	ff 75 08             	pushl  0x8(%ebp)
  8034ba:	e8 9b f0 ff ff       	call   80255a <get_block_size>
  8034bf:	83 c4 10             	add    $0x10,%esp
  8034c2:	89 c3                	mov    %eax,%ebx
  8034c4:	83 ec 0c             	sub    $0xc,%esp
  8034c7:	ff 75 10             	pushl  0x10(%ebp)
  8034ca:	e8 8b f0 ff ff       	call   80255a <get_block_size>
  8034cf:	83 c4 10             	add    $0x10,%esp
  8034d2:	01 d8                	add    %ebx,%eax
  8034d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034d7:	83 ec 04             	sub    $0x4,%esp
  8034da:	6a 00                	push   $0x0
  8034dc:	ff 75 e8             	pushl  -0x18(%ebp)
  8034df:	ff 75 08             	pushl  0x8(%ebp)
  8034e2:	e8 c4 f3 ff ff       	call   8028ab <set_block_data>
  8034e7:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034ea:	e9 a9 02 00 00       	jmp    803798 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8034ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034f3:	0f 84 2d 01 00 00    	je     803626 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8034f9:	83 ec 0c             	sub    $0xc,%esp
  8034fc:	ff 75 10             	pushl  0x10(%ebp)
  8034ff:	e8 56 f0 ff ff       	call   80255a <get_block_size>
  803504:	83 c4 10             	add    $0x10,%esp
  803507:	89 c3                	mov    %eax,%ebx
  803509:	83 ec 0c             	sub    $0xc,%esp
  80350c:	ff 75 0c             	pushl  0xc(%ebp)
  80350f:	e8 46 f0 ff ff       	call   80255a <get_block_size>
  803514:	83 c4 10             	add    $0x10,%esp
  803517:	01 d8                	add    %ebx,%eax
  803519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80351c:	83 ec 04             	sub    $0x4,%esp
  80351f:	6a 00                	push   $0x0
  803521:	ff 75 e4             	pushl  -0x1c(%ebp)
  803524:	ff 75 10             	pushl  0x10(%ebp)
  803527:	e8 7f f3 ff ff       	call   8028ab <set_block_data>
  80352c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80352f:	8b 45 10             	mov    0x10(%ebp),%eax
  803532:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803535:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803539:	74 06                	je     803541 <merging+0x1c6>
  80353b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80353f:	75 17                	jne    803558 <merging+0x1dd>
  803541:	83 ec 04             	sub    $0x4,%esp
  803544:	68 40 4c 80 00       	push   $0x804c40
  803549:	68 8d 01 00 00       	push   $0x18d
  80354e:	68 85 4b 80 00       	push   $0x804b85
  803553:	e8 58 d2 ff ff       	call   8007b0 <_panic>
  803558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355b:	8b 50 04             	mov    0x4(%eax),%edx
  80355e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803561:	89 50 04             	mov    %edx,0x4(%eax)
  803564:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803567:	8b 55 0c             	mov    0xc(%ebp),%edx
  80356a:	89 10                	mov    %edx,(%eax)
  80356c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80356f:	8b 40 04             	mov    0x4(%eax),%eax
  803572:	85 c0                	test   %eax,%eax
  803574:	74 0d                	je     803583 <merging+0x208>
  803576:	8b 45 0c             	mov    0xc(%ebp),%eax
  803579:	8b 40 04             	mov    0x4(%eax),%eax
  80357c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80357f:	89 10                	mov    %edx,(%eax)
  803581:	eb 08                	jmp    80358b <merging+0x210>
  803583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803586:	a3 30 50 80 00       	mov    %eax,0x805030
  80358b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80358e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803591:	89 50 04             	mov    %edx,0x4(%eax)
  803594:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803599:	40                   	inc    %eax
  80359a:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80359f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035a3:	75 17                	jne    8035bc <merging+0x241>
  8035a5:	83 ec 04             	sub    $0x4,%esp
  8035a8:	68 67 4b 80 00       	push   $0x804b67
  8035ad:	68 8e 01 00 00       	push   $0x18e
  8035b2:	68 85 4b 80 00       	push   $0x804b85
  8035b7:	e8 f4 d1 ff ff       	call   8007b0 <_panic>
  8035bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	85 c0                	test   %eax,%eax
  8035c3:	74 10                	je     8035d5 <merging+0x25a>
  8035c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c8:	8b 00                	mov    (%eax),%eax
  8035ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035cd:	8b 52 04             	mov    0x4(%edx),%edx
  8035d0:	89 50 04             	mov    %edx,0x4(%eax)
  8035d3:	eb 0b                	jmp    8035e0 <merging+0x265>
  8035d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d8:	8b 40 04             	mov    0x4(%eax),%eax
  8035db:	a3 34 50 80 00       	mov    %eax,0x805034
  8035e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e3:	8b 40 04             	mov    0x4(%eax),%eax
  8035e6:	85 c0                	test   %eax,%eax
  8035e8:	74 0f                	je     8035f9 <merging+0x27e>
  8035ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ed:	8b 40 04             	mov    0x4(%eax),%eax
  8035f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035f3:	8b 12                	mov    (%edx),%edx
  8035f5:	89 10                	mov    %edx,(%eax)
  8035f7:	eb 0a                	jmp    803603 <merging+0x288>
  8035f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fc:	8b 00                	mov    (%eax),%eax
  8035fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803603:	8b 45 0c             	mov    0xc(%ebp),%eax
  803606:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80360c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80360f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803616:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80361b:	48                   	dec    %eax
  80361c:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803621:	e9 72 01 00 00       	jmp    803798 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803626:	8b 45 10             	mov    0x10(%ebp),%eax
  803629:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80362c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803630:	74 79                	je     8036ab <merging+0x330>
  803632:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803636:	74 73                	je     8036ab <merging+0x330>
  803638:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80363c:	74 06                	je     803644 <merging+0x2c9>
  80363e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803642:	75 17                	jne    80365b <merging+0x2e0>
  803644:	83 ec 04             	sub    $0x4,%esp
  803647:	68 f8 4b 80 00       	push   $0x804bf8
  80364c:	68 94 01 00 00       	push   $0x194
  803651:	68 85 4b 80 00       	push   $0x804b85
  803656:	e8 55 d1 ff ff       	call   8007b0 <_panic>
  80365b:	8b 45 08             	mov    0x8(%ebp),%eax
  80365e:	8b 10                	mov    (%eax),%edx
  803660:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803663:	89 10                	mov    %edx,(%eax)
  803665:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803668:	8b 00                	mov    (%eax),%eax
  80366a:	85 c0                	test   %eax,%eax
  80366c:	74 0b                	je     803679 <merging+0x2fe>
  80366e:	8b 45 08             	mov    0x8(%ebp),%eax
  803671:	8b 00                	mov    (%eax),%eax
  803673:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803676:	89 50 04             	mov    %edx,0x4(%eax)
  803679:	8b 45 08             	mov    0x8(%ebp),%eax
  80367c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80367f:	89 10                	mov    %edx,(%eax)
  803681:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803684:	8b 55 08             	mov    0x8(%ebp),%edx
  803687:	89 50 04             	mov    %edx,0x4(%eax)
  80368a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	85 c0                	test   %eax,%eax
  803691:	75 08                	jne    80369b <merging+0x320>
  803693:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803696:	a3 34 50 80 00       	mov    %eax,0x805034
  80369b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036a0:	40                   	inc    %eax
  8036a1:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036a6:	e9 ce 00 00 00       	jmp    803779 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8036ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036af:	74 65                	je     803716 <merging+0x39b>
  8036b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036b5:	75 17                	jne    8036ce <merging+0x353>
  8036b7:	83 ec 04             	sub    $0x4,%esp
  8036ba:	68 d4 4b 80 00       	push   $0x804bd4
  8036bf:	68 95 01 00 00       	push   $0x195
  8036c4:	68 85 4b 80 00       	push   $0x804b85
  8036c9:	e8 e2 d0 ff ff       	call   8007b0 <_panic>
  8036ce:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8036d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036d7:	89 50 04             	mov    %edx,0x4(%eax)
  8036da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036dd:	8b 40 04             	mov    0x4(%eax),%eax
  8036e0:	85 c0                	test   %eax,%eax
  8036e2:	74 0c                	je     8036f0 <merging+0x375>
  8036e4:	a1 34 50 80 00       	mov    0x805034,%eax
  8036e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036ec:	89 10                	mov    %edx,(%eax)
  8036ee:	eb 08                	jmp    8036f8 <merging+0x37d>
  8036f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8036f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036fb:	a3 34 50 80 00       	mov    %eax,0x805034
  803700:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803703:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803709:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80370e:	40                   	inc    %eax
  80370f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803714:	eb 63                	jmp    803779 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803716:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80371a:	75 17                	jne    803733 <merging+0x3b8>
  80371c:	83 ec 04             	sub    $0x4,%esp
  80371f:	68 a0 4b 80 00       	push   $0x804ba0
  803724:	68 98 01 00 00       	push   $0x198
  803729:	68 85 4b 80 00       	push   $0x804b85
  80372e:	e8 7d d0 ff ff       	call   8007b0 <_panic>
  803733:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803739:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80373c:	89 10                	mov    %edx,(%eax)
  80373e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803741:	8b 00                	mov    (%eax),%eax
  803743:	85 c0                	test   %eax,%eax
  803745:	74 0d                	je     803754 <merging+0x3d9>
  803747:	a1 30 50 80 00       	mov    0x805030,%eax
  80374c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80374f:	89 50 04             	mov    %edx,0x4(%eax)
  803752:	eb 08                	jmp    80375c <merging+0x3e1>
  803754:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803757:	a3 34 50 80 00       	mov    %eax,0x805034
  80375c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80375f:	a3 30 50 80 00       	mov    %eax,0x805030
  803764:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803767:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80376e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803773:	40                   	inc    %eax
  803774:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803779:	83 ec 0c             	sub    $0xc,%esp
  80377c:	ff 75 10             	pushl  0x10(%ebp)
  80377f:	e8 d6 ed ff ff       	call   80255a <get_block_size>
  803784:	83 c4 10             	add    $0x10,%esp
  803787:	83 ec 04             	sub    $0x4,%esp
  80378a:	6a 00                	push   $0x0
  80378c:	50                   	push   %eax
  80378d:	ff 75 10             	pushl  0x10(%ebp)
  803790:	e8 16 f1 ff ff       	call   8028ab <set_block_data>
  803795:	83 c4 10             	add    $0x10,%esp
	}
}
  803798:	90                   	nop
  803799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80379c:	c9                   	leave  
  80379d:	c3                   	ret    

0080379e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80379e:	55                   	push   %ebp
  80379f:	89 e5                	mov    %esp,%ebp
  8037a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8037a4:	a1 30 50 80 00       	mov    0x805030,%eax
  8037a9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8037ac:	a1 34 50 80 00       	mov    0x805034,%eax
  8037b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037b4:	73 1b                	jae    8037d1 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8037b6:	a1 34 50 80 00       	mov    0x805034,%eax
  8037bb:	83 ec 04             	sub    $0x4,%esp
  8037be:	ff 75 08             	pushl  0x8(%ebp)
  8037c1:	6a 00                	push   $0x0
  8037c3:	50                   	push   %eax
  8037c4:	e8 b2 fb ff ff       	call   80337b <merging>
  8037c9:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037cc:	e9 8b 00 00 00       	jmp    80385c <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8037d1:	a1 30 50 80 00       	mov    0x805030,%eax
  8037d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037d9:	76 18                	jbe    8037f3 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8037db:	a1 30 50 80 00       	mov    0x805030,%eax
  8037e0:	83 ec 04             	sub    $0x4,%esp
  8037e3:	ff 75 08             	pushl  0x8(%ebp)
  8037e6:	50                   	push   %eax
  8037e7:	6a 00                	push   $0x0
  8037e9:	e8 8d fb ff ff       	call   80337b <merging>
  8037ee:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037f1:	eb 69                	jmp    80385c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037f3:	a1 30 50 80 00       	mov    0x805030,%eax
  8037f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037fb:	eb 39                	jmp    803836 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8037fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803800:	3b 45 08             	cmp    0x8(%ebp),%eax
  803803:	73 29                	jae    80382e <free_block+0x90>
  803805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803808:	8b 00                	mov    (%eax),%eax
  80380a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80380d:	76 1f                	jbe    80382e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80380f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803812:	8b 00                	mov    (%eax),%eax
  803814:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803817:	83 ec 04             	sub    $0x4,%esp
  80381a:	ff 75 08             	pushl  0x8(%ebp)
  80381d:	ff 75 f0             	pushl  -0x10(%ebp)
  803820:	ff 75 f4             	pushl  -0xc(%ebp)
  803823:	e8 53 fb ff ff       	call   80337b <merging>
  803828:	83 c4 10             	add    $0x10,%esp
			break;
  80382b:	90                   	nop
		}
	}
}
  80382c:	eb 2e                	jmp    80385c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80382e:	a1 38 50 80 00       	mov    0x805038,%eax
  803833:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80383a:	74 07                	je     803843 <free_block+0xa5>
  80383c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383f:	8b 00                	mov    (%eax),%eax
  803841:	eb 05                	jmp    803848 <free_block+0xaa>
  803843:	b8 00 00 00 00       	mov    $0x0,%eax
  803848:	a3 38 50 80 00       	mov    %eax,0x805038
  80384d:	a1 38 50 80 00       	mov    0x805038,%eax
  803852:	85 c0                	test   %eax,%eax
  803854:	75 a7                	jne    8037fd <free_block+0x5f>
  803856:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80385a:	75 a1                	jne    8037fd <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80385c:	90                   	nop
  80385d:	c9                   	leave  
  80385e:	c3                   	ret    

0080385f <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80385f:	55                   	push   %ebp
  803860:	89 e5                	mov    %esp,%ebp
  803862:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803865:	ff 75 08             	pushl  0x8(%ebp)
  803868:	e8 ed ec ff ff       	call   80255a <get_block_size>
  80386d:	83 c4 04             	add    $0x4,%esp
  803870:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803873:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80387a:	eb 17                	jmp    803893 <copy_data+0x34>
  80387c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80387f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803882:	01 c2                	add    %eax,%edx
  803884:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803887:	8b 45 08             	mov    0x8(%ebp),%eax
  80388a:	01 c8                	add    %ecx,%eax
  80388c:	8a 00                	mov    (%eax),%al
  80388e:	88 02                	mov    %al,(%edx)
  803890:	ff 45 fc             	incl   -0x4(%ebp)
  803893:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803896:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803899:	72 e1                	jb     80387c <copy_data+0x1d>
}
  80389b:	90                   	nop
  80389c:	c9                   	leave  
  80389d:	c3                   	ret    

0080389e <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80389e:	55                   	push   %ebp
  80389f:	89 e5                	mov    %esp,%ebp
  8038a1:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8038a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038a8:	75 23                	jne    8038cd <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8038aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038ae:	74 13                	je     8038c3 <realloc_block_FF+0x25>
  8038b0:	83 ec 0c             	sub    $0xc,%esp
  8038b3:	ff 75 0c             	pushl  0xc(%ebp)
  8038b6:	e8 1f f0 ff ff       	call   8028da <alloc_block_FF>
  8038bb:	83 c4 10             	add    $0x10,%esp
  8038be:	e9 f4 06 00 00       	jmp    803fb7 <realloc_block_FF+0x719>
		return NULL;
  8038c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c8:	e9 ea 06 00 00       	jmp    803fb7 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8038cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038d1:	75 18                	jne    8038eb <realloc_block_FF+0x4d>
	{
		free_block(va);
  8038d3:	83 ec 0c             	sub    $0xc,%esp
  8038d6:	ff 75 08             	pushl  0x8(%ebp)
  8038d9:	e8 c0 fe ff ff       	call   80379e <free_block>
  8038de:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8038e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e6:	e9 cc 06 00 00       	jmp    803fb7 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8038eb:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8038ef:	77 07                	ja     8038f8 <realloc_block_FF+0x5a>
  8038f1:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8038f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038fb:	83 e0 01             	and    $0x1,%eax
  8038fe:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803901:	8b 45 0c             	mov    0xc(%ebp),%eax
  803904:	83 c0 08             	add    $0x8,%eax
  803907:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80390a:	83 ec 0c             	sub    $0xc,%esp
  80390d:	ff 75 08             	pushl  0x8(%ebp)
  803910:	e8 45 ec ff ff       	call   80255a <get_block_size>
  803915:	83 c4 10             	add    $0x10,%esp
  803918:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80391b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80391e:	83 e8 08             	sub    $0x8,%eax
  803921:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803924:	8b 45 08             	mov    0x8(%ebp),%eax
  803927:	83 e8 04             	sub    $0x4,%eax
  80392a:	8b 00                	mov    (%eax),%eax
  80392c:	83 e0 fe             	and    $0xfffffffe,%eax
  80392f:	89 c2                	mov    %eax,%edx
  803931:	8b 45 08             	mov    0x8(%ebp),%eax
  803934:	01 d0                	add    %edx,%eax
  803936:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803939:	83 ec 0c             	sub    $0xc,%esp
  80393c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80393f:	e8 16 ec ff ff       	call   80255a <get_block_size>
  803944:	83 c4 10             	add    $0x10,%esp
  803947:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80394a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80394d:	83 e8 08             	sub    $0x8,%eax
  803950:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803953:	8b 45 0c             	mov    0xc(%ebp),%eax
  803956:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803959:	75 08                	jne    803963 <realloc_block_FF+0xc5>
	{
		 return va;
  80395b:	8b 45 08             	mov    0x8(%ebp),%eax
  80395e:	e9 54 06 00 00       	jmp    803fb7 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803963:	8b 45 0c             	mov    0xc(%ebp),%eax
  803966:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803969:	0f 83 e5 03 00 00    	jae    803d54 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80396f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803972:	2b 45 0c             	sub    0xc(%ebp),%eax
  803975:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803978:	83 ec 0c             	sub    $0xc,%esp
  80397b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80397e:	e8 f0 eb ff ff       	call   802573 <is_free_block>
  803983:	83 c4 10             	add    $0x10,%esp
  803986:	84 c0                	test   %al,%al
  803988:	0f 84 3b 01 00 00    	je     803ac9 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80398e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803991:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803994:	01 d0                	add    %edx,%eax
  803996:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803999:	83 ec 04             	sub    $0x4,%esp
  80399c:	6a 01                	push   $0x1
  80399e:	ff 75 f0             	pushl  -0x10(%ebp)
  8039a1:	ff 75 08             	pushl  0x8(%ebp)
  8039a4:	e8 02 ef ff ff       	call   8028ab <set_block_data>
  8039a9:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8039ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8039af:	83 e8 04             	sub    $0x4,%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	83 e0 fe             	and    $0xfffffffe,%eax
  8039b7:	89 c2                	mov    %eax,%edx
  8039b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039bc:	01 d0                	add    %edx,%eax
  8039be:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8039c1:	83 ec 04             	sub    $0x4,%esp
  8039c4:	6a 00                	push   $0x0
  8039c6:	ff 75 cc             	pushl  -0x34(%ebp)
  8039c9:	ff 75 c8             	pushl  -0x38(%ebp)
  8039cc:	e8 da ee ff ff       	call   8028ab <set_block_data>
  8039d1:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039d8:	74 06                	je     8039e0 <realloc_block_FF+0x142>
  8039da:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8039de:	75 17                	jne    8039f7 <realloc_block_FF+0x159>
  8039e0:	83 ec 04             	sub    $0x4,%esp
  8039e3:	68 f8 4b 80 00       	push   $0x804bf8
  8039e8:	68 f6 01 00 00       	push   $0x1f6
  8039ed:	68 85 4b 80 00       	push   $0x804b85
  8039f2:	e8 b9 cd ff ff       	call   8007b0 <_panic>
  8039f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fa:	8b 10                	mov    (%eax),%edx
  8039fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039ff:	89 10                	mov    %edx,(%eax)
  803a01:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a04:	8b 00                	mov    (%eax),%eax
  803a06:	85 c0                	test   %eax,%eax
  803a08:	74 0b                	je     803a15 <realloc_block_FF+0x177>
  803a0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a0d:	8b 00                	mov    (%eax),%eax
  803a0f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a12:	89 50 04             	mov    %edx,0x4(%eax)
  803a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a18:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a1b:	89 10                	mov    %edx,(%eax)
  803a1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a23:	89 50 04             	mov    %edx,0x4(%eax)
  803a26:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a29:	8b 00                	mov    (%eax),%eax
  803a2b:	85 c0                	test   %eax,%eax
  803a2d:	75 08                	jne    803a37 <realloc_block_FF+0x199>
  803a2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a32:	a3 34 50 80 00       	mov    %eax,0x805034
  803a37:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a3c:	40                   	inc    %eax
  803a3d:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a46:	75 17                	jne    803a5f <realloc_block_FF+0x1c1>
  803a48:	83 ec 04             	sub    $0x4,%esp
  803a4b:	68 67 4b 80 00       	push   $0x804b67
  803a50:	68 f7 01 00 00       	push   $0x1f7
  803a55:	68 85 4b 80 00       	push   $0x804b85
  803a5a:	e8 51 cd ff ff       	call   8007b0 <_panic>
  803a5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a62:	8b 00                	mov    (%eax),%eax
  803a64:	85 c0                	test   %eax,%eax
  803a66:	74 10                	je     803a78 <realloc_block_FF+0x1da>
  803a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a6b:	8b 00                	mov    (%eax),%eax
  803a6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a70:	8b 52 04             	mov    0x4(%edx),%edx
  803a73:	89 50 04             	mov    %edx,0x4(%eax)
  803a76:	eb 0b                	jmp    803a83 <realloc_block_FF+0x1e5>
  803a78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7b:	8b 40 04             	mov    0x4(%eax),%eax
  803a7e:	a3 34 50 80 00       	mov    %eax,0x805034
  803a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a86:	8b 40 04             	mov    0x4(%eax),%eax
  803a89:	85 c0                	test   %eax,%eax
  803a8b:	74 0f                	je     803a9c <realloc_block_FF+0x1fe>
  803a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a90:	8b 40 04             	mov    0x4(%eax),%eax
  803a93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a96:	8b 12                	mov    (%edx),%edx
  803a98:	89 10                	mov    %edx,(%eax)
  803a9a:	eb 0a                	jmp    803aa6 <realloc_block_FF+0x208>
  803a9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9f:	8b 00                	mov    (%eax),%eax
  803aa1:	a3 30 50 80 00       	mov    %eax,0x805030
  803aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ab9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803abe:	48                   	dec    %eax
  803abf:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803ac4:	e9 83 02 00 00       	jmp    803d4c <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803ac9:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803acd:	0f 86 69 02 00 00    	jbe    803d3c <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803ad3:	83 ec 04             	sub    $0x4,%esp
  803ad6:	6a 01                	push   $0x1
  803ad8:	ff 75 f0             	pushl  -0x10(%ebp)
  803adb:	ff 75 08             	pushl  0x8(%ebp)
  803ade:	e8 c8 ed ff ff       	call   8028ab <set_block_data>
  803ae3:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae9:	83 e8 04             	sub    $0x4,%eax
  803aec:	8b 00                	mov    (%eax),%eax
  803aee:	83 e0 fe             	and    $0xfffffffe,%eax
  803af1:	89 c2                	mov    %eax,%edx
  803af3:	8b 45 08             	mov    0x8(%ebp),%eax
  803af6:	01 d0                	add    %edx,%eax
  803af8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803afb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b00:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803b03:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803b07:	75 68                	jne    803b71 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b09:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b0d:	75 17                	jne    803b26 <realloc_block_FF+0x288>
  803b0f:	83 ec 04             	sub    $0x4,%esp
  803b12:	68 a0 4b 80 00       	push   $0x804ba0
  803b17:	68 06 02 00 00       	push   $0x206
  803b1c:	68 85 4b 80 00       	push   $0x804b85
  803b21:	e8 8a cc ff ff       	call   8007b0 <_panic>
  803b26:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b2f:	89 10                	mov    %edx,(%eax)
  803b31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b34:	8b 00                	mov    (%eax),%eax
  803b36:	85 c0                	test   %eax,%eax
  803b38:	74 0d                	je     803b47 <realloc_block_FF+0x2a9>
  803b3a:	a1 30 50 80 00       	mov    0x805030,%eax
  803b3f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b42:	89 50 04             	mov    %edx,0x4(%eax)
  803b45:	eb 08                	jmp    803b4f <realloc_block_FF+0x2b1>
  803b47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b4a:	a3 34 50 80 00       	mov    %eax,0x805034
  803b4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b52:	a3 30 50 80 00       	mov    %eax,0x805030
  803b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b61:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b66:	40                   	inc    %eax
  803b67:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b6c:	e9 b0 01 00 00       	jmp    803d21 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803b71:	a1 30 50 80 00       	mov    0x805030,%eax
  803b76:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b79:	76 68                	jbe    803be3 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b7b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b7f:	75 17                	jne    803b98 <realloc_block_FF+0x2fa>
  803b81:	83 ec 04             	sub    $0x4,%esp
  803b84:	68 a0 4b 80 00       	push   $0x804ba0
  803b89:	68 0b 02 00 00       	push   $0x20b
  803b8e:	68 85 4b 80 00       	push   $0x804b85
  803b93:	e8 18 cc ff ff       	call   8007b0 <_panic>
  803b98:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba1:	89 10                	mov    %edx,(%eax)
  803ba3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ba6:	8b 00                	mov    (%eax),%eax
  803ba8:	85 c0                	test   %eax,%eax
  803baa:	74 0d                	je     803bb9 <realloc_block_FF+0x31b>
  803bac:	a1 30 50 80 00       	mov    0x805030,%eax
  803bb1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803bb4:	89 50 04             	mov    %edx,0x4(%eax)
  803bb7:	eb 08                	jmp    803bc1 <realloc_block_FF+0x323>
  803bb9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bbc:	a3 34 50 80 00       	mov    %eax,0x805034
  803bc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bc4:	a3 30 50 80 00       	mov    %eax,0x805030
  803bc9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bd3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bd8:	40                   	inc    %eax
  803bd9:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803bde:	e9 3e 01 00 00       	jmp    803d21 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803be3:	a1 30 50 80 00       	mov    0x805030,%eax
  803be8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803beb:	73 68                	jae    803c55 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803bed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bf1:	75 17                	jne    803c0a <realloc_block_FF+0x36c>
  803bf3:	83 ec 04             	sub    $0x4,%esp
  803bf6:	68 d4 4b 80 00       	push   $0x804bd4
  803bfb:	68 10 02 00 00       	push   $0x210
  803c00:	68 85 4b 80 00       	push   $0x804b85
  803c05:	e8 a6 cb ff ff       	call   8007b0 <_panic>
  803c0a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803c10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c13:	89 50 04             	mov    %edx,0x4(%eax)
  803c16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c19:	8b 40 04             	mov    0x4(%eax),%eax
  803c1c:	85 c0                	test   %eax,%eax
  803c1e:	74 0c                	je     803c2c <realloc_block_FF+0x38e>
  803c20:	a1 34 50 80 00       	mov    0x805034,%eax
  803c25:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c28:	89 10                	mov    %edx,(%eax)
  803c2a:	eb 08                	jmp    803c34 <realloc_block_FF+0x396>
  803c2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2f:	a3 30 50 80 00       	mov    %eax,0x805030
  803c34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c37:	a3 34 50 80 00       	mov    %eax,0x805034
  803c3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c45:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c4a:	40                   	inc    %eax
  803c4b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c50:	e9 cc 00 00 00       	jmp    803d21 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803c55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c5c:	a1 30 50 80 00       	mov    0x805030,%eax
  803c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c64:	e9 8a 00 00 00       	jmp    803cf3 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c6c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c6f:	73 7a                	jae    803ceb <realloc_block_FF+0x44d>
  803c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c74:	8b 00                	mov    (%eax),%eax
  803c76:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c79:	73 70                	jae    803ceb <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c7f:	74 06                	je     803c87 <realloc_block_FF+0x3e9>
  803c81:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c85:	75 17                	jne    803c9e <realloc_block_FF+0x400>
  803c87:	83 ec 04             	sub    $0x4,%esp
  803c8a:	68 f8 4b 80 00       	push   $0x804bf8
  803c8f:	68 1a 02 00 00       	push   $0x21a
  803c94:	68 85 4b 80 00       	push   $0x804b85
  803c99:	e8 12 cb ff ff       	call   8007b0 <_panic>
  803c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca1:	8b 10                	mov    (%eax),%edx
  803ca3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803ca6:	89 10                	mov    %edx,(%eax)
  803ca8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cab:	8b 00                	mov    (%eax),%eax
  803cad:	85 c0                	test   %eax,%eax
  803caf:	74 0b                	je     803cbc <realloc_block_FF+0x41e>
  803cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb4:	8b 00                	mov    (%eax),%eax
  803cb6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cb9:	89 50 04             	mov    %edx,0x4(%eax)
  803cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cc2:	89 10                	mov    %edx,(%eax)
  803cc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cca:	89 50 04             	mov    %edx,0x4(%eax)
  803ccd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cd0:	8b 00                	mov    (%eax),%eax
  803cd2:	85 c0                	test   %eax,%eax
  803cd4:	75 08                	jne    803cde <realloc_block_FF+0x440>
  803cd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cd9:	a3 34 50 80 00       	mov    %eax,0x805034
  803cde:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803ce3:	40                   	inc    %eax
  803ce4:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803ce9:	eb 36                	jmp    803d21 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803ceb:	a1 38 50 80 00       	mov    0x805038,%eax
  803cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cf7:	74 07                	je     803d00 <realloc_block_FF+0x462>
  803cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfc:	8b 00                	mov    (%eax),%eax
  803cfe:	eb 05                	jmp    803d05 <realloc_block_FF+0x467>
  803d00:	b8 00 00 00 00       	mov    $0x0,%eax
  803d05:	a3 38 50 80 00       	mov    %eax,0x805038
  803d0a:	a1 38 50 80 00       	mov    0x805038,%eax
  803d0f:	85 c0                	test   %eax,%eax
  803d11:	0f 85 52 ff ff ff    	jne    803c69 <realloc_block_FF+0x3cb>
  803d17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d1b:	0f 85 48 ff ff ff    	jne    803c69 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803d21:	83 ec 04             	sub    $0x4,%esp
  803d24:	6a 00                	push   $0x0
  803d26:	ff 75 d8             	pushl  -0x28(%ebp)
  803d29:	ff 75 d4             	pushl  -0x2c(%ebp)
  803d2c:	e8 7a eb ff ff       	call   8028ab <set_block_data>
  803d31:	83 c4 10             	add    $0x10,%esp
				return va;
  803d34:	8b 45 08             	mov    0x8(%ebp),%eax
  803d37:	e9 7b 02 00 00       	jmp    803fb7 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803d3c:	83 ec 0c             	sub    $0xc,%esp
  803d3f:	68 75 4c 80 00       	push   $0x804c75
  803d44:	e8 24 cd ff ff       	call   800a6d <cprintf>
  803d49:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4f:	e9 63 02 00 00       	jmp    803fb7 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d57:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d5a:	0f 86 4d 02 00 00    	jbe    803fad <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803d60:	83 ec 0c             	sub    $0xc,%esp
  803d63:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d66:	e8 08 e8 ff ff       	call   802573 <is_free_block>
  803d6b:	83 c4 10             	add    $0x10,%esp
  803d6e:	84 c0                	test   %al,%al
  803d70:	0f 84 37 02 00 00    	je     803fad <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d79:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d7c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803d7f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d82:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d85:	76 38                	jbe    803dbf <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803d87:	83 ec 0c             	sub    $0xc,%esp
  803d8a:	ff 75 08             	pushl  0x8(%ebp)
  803d8d:	e8 0c fa ff ff       	call   80379e <free_block>
  803d92:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d95:	83 ec 0c             	sub    $0xc,%esp
  803d98:	ff 75 0c             	pushl  0xc(%ebp)
  803d9b:	e8 3a eb ff ff       	call   8028da <alloc_block_FF>
  803da0:	83 c4 10             	add    $0x10,%esp
  803da3:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803da6:	83 ec 08             	sub    $0x8,%esp
  803da9:	ff 75 c0             	pushl  -0x40(%ebp)
  803dac:	ff 75 08             	pushl  0x8(%ebp)
  803daf:	e8 ab fa ff ff       	call   80385f <copy_data>
  803db4:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803db7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803dba:	e9 f8 01 00 00       	jmp    803fb7 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dc2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803dc5:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803dc8:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803dcc:	0f 87 a0 00 00 00    	ja     803e72 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803dd2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803dd6:	75 17                	jne    803def <realloc_block_FF+0x551>
  803dd8:	83 ec 04             	sub    $0x4,%esp
  803ddb:	68 67 4b 80 00       	push   $0x804b67
  803de0:	68 38 02 00 00       	push   $0x238
  803de5:	68 85 4b 80 00       	push   $0x804b85
  803dea:	e8 c1 c9 ff ff       	call   8007b0 <_panic>
  803def:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df2:	8b 00                	mov    (%eax),%eax
  803df4:	85 c0                	test   %eax,%eax
  803df6:	74 10                	je     803e08 <realloc_block_FF+0x56a>
  803df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dfb:	8b 00                	mov    (%eax),%eax
  803dfd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e00:	8b 52 04             	mov    0x4(%edx),%edx
  803e03:	89 50 04             	mov    %edx,0x4(%eax)
  803e06:	eb 0b                	jmp    803e13 <realloc_block_FF+0x575>
  803e08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e0b:	8b 40 04             	mov    0x4(%eax),%eax
  803e0e:	a3 34 50 80 00       	mov    %eax,0x805034
  803e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e16:	8b 40 04             	mov    0x4(%eax),%eax
  803e19:	85 c0                	test   %eax,%eax
  803e1b:	74 0f                	je     803e2c <realloc_block_FF+0x58e>
  803e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e20:	8b 40 04             	mov    0x4(%eax),%eax
  803e23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e26:	8b 12                	mov    (%edx),%edx
  803e28:	89 10                	mov    %edx,(%eax)
  803e2a:	eb 0a                	jmp    803e36 <realloc_block_FF+0x598>
  803e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e2f:	8b 00                	mov    (%eax),%eax
  803e31:	a3 30 50 80 00       	mov    %eax,0x805030
  803e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e49:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e4e:	48                   	dec    %eax
  803e4f:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803e54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e5a:	01 d0                	add    %edx,%eax
  803e5c:	83 ec 04             	sub    $0x4,%esp
  803e5f:	6a 01                	push   $0x1
  803e61:	50                   	push   %eax
  803e62:	ff 75 08             	pushl  0x8(%ebp)
  803e65:	e8 41 ea ff ff       	call   8028ab <set_block_data>
  803e6a:	83 c4 10             	add    $0x10,%esp
  803e6d:	e9 36 01 00 00       	jmp    803fa8 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803e72:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e75:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e78:	01 d0                	add    %edx,%eax
  803e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803e7d:	83 ec 04             	sub    $0x4,%esp
  803e80:	6a 01                	push   $0x1
  803e82:	ff 75 f0             	pushl  -0x10(%ebp)
  803e85:	ff 75 08             	pushl  0x8(%ebp)
  803e88:	e8 1e ea ff ff       	call   8028ab <set_block_data>
  803e8d:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e90:	8b 45 08             	mov    0x8(%ebp),%eax
  803e93:	83 e8 04             	sub    $0x4,%eax
  803e96:	8b 00                	mov    (%eax),%eax
  803e98:	83 e0 fe             	and    $0xfffffffe,%eax
  803e9b:	89 c2                	mov    %eax,%edx
  803e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803ea0:	01 d0                	add    %edx,%eax
  803ea2:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803ea5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ea9:	74 06                	je     803eb1 <realloc_block_FF+0x613>
  803eab:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803eaf:	75 17                	jne    803ec8 <realloc_block_FF+0x62a>
  803eb1:	83 ec 04             	sub    $0x4,%esp
  803eb4:	68 f8 4b 80 00       	push   $0x804bf8
  803eb9:	68 44 02 00 00       	push   $0x244
  803ebe:	68 85 4b 80 00       	push   $0x804b85
  803ec3:	e8 e8 c8 ff ff       	call   8007b0 <_panic>
  803ec8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ecb:	8b 10                	mov    (%eax),%edx
  803ecd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ed0:	89 10                	mov    %edx,(%eax)
  803ed2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ed5:	8b 00                	mov    (%eax),%eax
  803ed7:	85 c0                	test   %eax,%eax
  803ed9:	74 0b                	je     803ee6 <realloc_block_FF+0x648>
  803edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ede:	8b 00                	mov    (%eax),%eax
  803ee0:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ee3:	89 50 04             	mov    %edx,0x4(%eax)
  803ee6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803eec:	89 10                	mov    %edx,(%eax)
  803eee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ef1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ef4:	89 50 04             	mov    %edx,0x4(%eax)
  803ef7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803efa:	8b 00                	mov    (%eax),%eax
  803efc:	85 c0                	test   %eax,%eax
  803efe:	75 08                	jne    803f08 <realloc_block_FF+0x66a>
  803f00:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803f03:	a3 34 50 80 00       	mov    %eax,0x805034
  803f08:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f0d:	40                   	inc    %eax
  803f0e:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803f13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803f17:	75 17                	jne    803f30 <realloc_block_FF+0x692>
  803f19:	83 ec 04             	sub    $0x4,%esp
  803f1c:	68 67 4b 80 00       	push   $0x804b67
  803f21:	68 45 02 00 00       	push   $0x245
  803f26:	68 85 4b 80 00       	push   $0x804b85
  803f2b:	e8 80 c8 ff ff       	call   8007b0 <_panic>
  803f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f33:	8b 00                	mov    (%eax),%eax
  803f35:	85 c0                	test   %eax,%eax
  803f37:	74 10                	je     803f49 <realloc_block_FF+0x6ab>
  803f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f3c:	8b 00                	mov    (%eax),%eax
  803f3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f41:	8b 52 04             	mov    0x4(%edx),%edx
  803f44:	89 50 04             	mov    %edx,0x4(%eax)
  803f47:	eb 0b                	jmp    803f54 <realloc_block_FF+0x6b6>
  803f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f4c:	8b 40 04             	mov    0x4(%eax),%eax
  803f4f:	a3 34 50 80 00       	mov    %eax,0x805034
  803f54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f57:	8b 40 04             	mov    0x4(%eax),%eax
  803f5a:	85 c0                	test   %eax,%eax
  803f5c:	74 0f                	je     803f6d <realloc_block_FF+0x6cf>
  803f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f61:	8b 40 04             	mov    0x4(%eax),%eax
  803f64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f67:	8b 12                	mov    (%edx),%edx
  803f69:	89 10                	mov    %edx,(%eax)
  803f6b:	eb 0a                	jmp    803f77 <realloc_block_FF+0x6d9>
  803f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f70:	8b 00                	mov    (%eax),%eax
  803f72:	a3 30 50 80 00       	mov    %eax,0x805030
  803f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f8a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f8f:	48                   	dec    %eax
  803f90:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803f95:	83 ec 04             	sub    $0x4,%esp
  803f98:	6a 00                	push   $0x0
  803f9a:	ff 75 bc             	pushl  -0x44(%ebp)
  803f9d:	ff 75 b8             	pushl  -0x48(%ebp)
  803fa0:	e8 06 e9 ff ff       	call   8028ab <set_block_data>
  803fa5:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  803fab:	eb 0a                	jmp    803fb7 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803fad:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803fb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803fb7:	c9                   	leave  
  803fb8:	c3                   	ret    

00803fb9 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803fb9:	55                   	push   %ebp
  803fba:	89 e5                	mov    %esp,%ebp
  803fbc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803fbf:	83 ec 04             	sub    $0x4,%esp
  803fc2:	68 7c 4c 80 00       	push   $0x804c7c
  803fc7:	68 58 02 00 00       	push   $0x258
  803fcc:	68 85 4b 80 00       	push   $0x804b85
  803fd1:	e8 da c7 ff ff       	call   8007b0 <_panic>

00803fd6 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803fd6:	55                   	push   %ebp
  803fd7:	89 e5                	mov    %esp,%ebp
  803fd9:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803fdc:	83 ec 04             	sub    $0x4,%esp
  803fdf:	68 a4 4c 80 00       	push   $0x804ca4
  803fe4:	68 61 02 00 00       	push   $0x261
  803fe9:	68 85 4b 80 00       	push   $0x804b85
  803fee:	e8 bd c7 ff ff       	call   8007b0 <_panic>

00803ff3 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803ff3:	55                   	push   %ebp
  803ff4:	89 e5                	mov    %esp,%ebp
  803ff6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803ff9:	83 ec 04             	sub    $0x4,%esp
  803ffc:	68 cc 4c 80 00       	push   $0x804ccc
  804001:	6a 09                	push   $0x9
  804003:	68 f4 4c 80 00       	push   $0x804cf4
  804008:	e8 a3 c7 ff ff       	call   8007b0 <_panic>

0080400d <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80400d:	55                   	push   %ebp
  80400e:	89 e5                	mov    %esp,%ebp
  804010:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  804013:	83 ec 04             	sub    $0x4,%esp
  804016:	68 04 4d 80 00       	push   $0x804d04
  80401b:	6a 10                	push   $0x10
  80401d:	68 f4 4c 80 00       	push   $0x804cf4
  804022:	e8 89 c7 ff ff       	call   8007b0 <_panic>

00804027 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  804027:	55                   	push   %ebp
  804028:	89 e5                	mov    %esp,%ebp
  80402a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  80402d:	83 ec 04             	sub    $0x4,%esp
  804030:	68 2c 4d 80 00       	push   $0x804d2c
  804035:	6a 18                	push   $0x18
  804037:	68 f4 4c 80 00       	push   $0x804cf4
  80403c:	e8 6f c7 ff ff       	call   8007b0 <_panic>

00804041 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  804041:	55                   	push   %ebp
  804042:	89 e5                	mov    %esp,%ebp
  804044:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  804047:	83 ec 04             	sub    $0x4,%esp
  80404a:	68 54 4d 80 00       	push   $0x804d54
  80404f:	6a 20                	push   $0x20
  804051:	68 f4 4c 80 00       	push   $0x804cf4
  804056:	e8 55 c7 ff ff       	call   8007b0 <_panic>

0080405b <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80405b:	55                   	push   %ebp
  80405c:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80405e:	8b 45 08             	mov    0x8(%ebp),%eax
  804061:	8b 40 10             	mov    0x10(%eax),%eax
}
  804064:	5d                   	pop    %ebp
  804065:	c3                   	ret    
  804066:	66 90                	xchg   %ax,%ax

00804068 <__udivdi3>:
  804068:	55                   	push   %ebp
  804069:	57                   	push   %edi
  80406a:	56                   	push   %esi
  80406b:	53                   	push   %ebx
  80406c:	83 ec 1c             	sub    $0x1c,%esp
  80406f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804073:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804077:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80407b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80407f:	89 ca                	mov    %ecx,%edx
  804081:	89 f8                	mov    %edi,%eax
  804083:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804087:	85 f6                	test   %esi,%esi
  804089:	75 2d                	jne    8040b8 <__udivdi3+0x50>
  80408b:	39 cf                	cmp    %ecx,%edi
  80408d:	77 65                	ja     8040f4 <__udivdi3+0x8c>
  80408f:	89 fd                	mov    %edi,%ebp
  804091:	85 ff                	test   %edi,%edi
  804093:	75 0b                	jne    8040a0 <__udivdi3+0x38>
  804095:	b8 01 00 00 00       	mov    $0x1,%eax
  80409a:	31 d2                	xor    %edx,%edx
  80409c:	f7 f7                	div    %edi
  80409e:	89 c5                	mov    %eax,%ebp
  8040a0:	31 d2                	xor    %edx,%edx
  8040a2:	89 c8                	mov    %ecx,%eax
  8040a4:	f7 f5                	div    %ebp
  8040a6:	89 c1                	mov    %eax,%ecx
  8040a8:	89 d8                	mov    %ebx,%eax
  8040aa:	f7 f5                	div    %ebp
  8040ac:	89 cf                	mov    %ecx,%edi
  8040ae:	89 fa                	mov    %edi,%edx
  8040b0:	83 c4 1c             	add    $0x1c,%esp
  8040b3:	5b                   	pop    %ebx
  8040b4:	5e                   	pop    %esi
  8040b5:	5f                   	pop    %edi
  8040b6:	5d                   	pop    %ebp
  8040b7:	c3                   	ret    
  8040b8:	39 ce                	cmp    %ecx,%esi
  8040ba:	77 28                	ja     8040e4 <__udivdi3+0x7c>
  8040bc:	0f bd fe             	bsr    %esi,%edi
  8040bf:	83 f7 1f             	xor    $0x1f,%edi
  8040c2:	75 40                	jne    804104 <__udivdi3+0x9c>
  8040c4:	39 ce                	cmp    %ecx,%esi
  8040c6:	72 0a                	jb     8040d2 <__udivdi3+0x6a>
  8040c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040cc:	0f 87 9e 00 00 00    	ja     804170 <__udivdi3+0x108>
  8040d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8040d7:	89 fa                	mov    %edi,%edx
  8040d9:	83 c4 1c             	add    $0x1c,%esp
  8040dc:	5b                   	pop    %ebx
  8040dd:	5e                   	pop    %esi
  8040de:	5f                   	pop    %edi
  8040df:	5d                   	pop    %ebp
  8040e0:	c3                   	ret    
  8040e1:	8d 76 00             	lea    0x0(%esi),%esi
  8040e4:	31 ff                	xor    %edi,%edi
  8040e6:	31 c0                	xor    %eax,%eax
  8040e8:	89 fa                	mov    %edi,%edx
  8040ea:	83 c4 1c             	add    $0x1c,%esp
  8040ed:	5b                   	pop    %ebx
  8040ee:	5e                   	pop    %esi
  8040ef:	5f                   	pop    %edi
  8040f0:	5d                   	pop    %ebp
  8040f1:	c3                   	ret    
  8040f2:	66 90                	xchg   %ax,%ax
  8040f4:	89 d8                	mov    %ebx,%eax
  8040f6:	f7 f7                	div    %edi
  8040f8:	31 ff                	xor    %edi,%edi
  8040fa:	89 fa                	mov    %edi,%edx
  8040fc:	83 c4 1c             	add    $0x1c,%esp
  8040ff:	5b                   	pop    %ebx
  804100:	5e                   	pop    %esi
  804101:	5f                   	pop    %edi
  804102:	5d                   	pop    %ebp
  804103:	c3                   	ret    
  804104:	bd 20 00 00 00       	mov    $0x20,%ebp
  804109:	89 eb                	mov    %ebp,%ebx
  80410b:	29 fb                	sub    %edi,%ebx
  80410d:	89 f9                	mov    %edi,%ecx
  80410f:	d3 e6                	shl    %cl,%esi
  804111:	89 c5                	mov    %eax,%ebp
  804113:	88 d9                	mov    %bl,%cl
  804115:	d3 ed                	shr    %cl,%ebp
  804117:	89 e9                	mov    %ebp,%ecx
  804119:	09 f1                	or     %esi,%ecx
  80411b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80411f:	89 f9                	mov    %edi,%ecx
  804121:	d3 e0                	shl    %cl,%eax
  804123:	89 c5                	mov    %eax,%ebp
  804125:	89 d6                	mov    %edx,%esi
  804127:	88 d9                	mov    %bl,%cl
  804129:	d3 ee                	shr    %cl,%esi
  80412b:	89 f9                	mov    %edi,%ecx
  80412d:	d3 e2                	shl    %cl,%edx
  80412f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804133:	88 d9                	mov    %bl,%cl
  804135:	d3 e8                	shr    %cl,%eax
  804137:	09 c2                	or     %eax,%edx
  804139:	89 d0                	mov    %edx,%eax
  80413b:	89 f2                	mov    %esi,%edx
  80413d:	f7 74 24 0c          	divl   0xc(%esp)
  804141:	89 d6                	mov    %edx,%esi
  804143:	89 c3                	mov    %eax,%ebx
  804145:	f7 e5                	mul    %ebp
  804147:	39 d6                	cmp    %edx,%esi
  804149:	72 19                	jb     804164 <__udivdi3+0xfc>
  80414b:	74 0b                	je     804158 <__udivdi3+0xf0>
  80414d:	89 d8                	mov    %ebx,%eax
  80414f:	31 ff                	xor    %edi,%edi
  804151:	e9 58 ff ff ff       	jmp    8040ae <__udivdi3+0x46>
  804156:	66 90                	xchg   %ax,%ax
  804158:	8b 54 24 08          	mov    0x8(%esp),%edx
  80415c:	89 f9                	mov    %edi,%ecx
  80415e:	d3 e2                	shl    %cl,%edx
  804160:	39 c2                	cmp    %eax,%edx
  804162:	73 e9                	jae    80414d <__udivdi3+0xe5>
  804164:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804167:	31 ff                	xor    %edi,%edi
  804169:	e9 40 ff ff ff       	jmp    8040ae <__udivdi3+0x46>
  80416e:	66 90                	xchg   %ax,%ax
  804170:	31 c0                	xor    %eax,%eax
  804172:	e9 37 ff ff ff       	jmp    8040ae <__udivdi3+0x46>
  804177:	90                   	nop

00804178 <__umoddi3>:
  804178:	55                   	push   %ebp
  804179:	57                   	push   %edi
  80417a:	56                   	push   %esi
  80417b:	53                   	push   %ebx
  80417c:	83 ec 1c             	sub    $0x1c,%esp
  80417f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804183:	8b 74 24 34          	mov    0x34(%esp),%esi
  804187:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80418b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80418f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804193:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804197:	89 f3                	mov    %esi,%ebx
  804199:	89 fa                	mov    %edi,%edx
  80419b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80419f:	89 34 24             	mov    %esi,(%esp)
  8041a2:	85 c0                	test   %eax,%eax
  8041a4:	75 1a                	jne    8041c0 <__umoddi3+0x48>
  8041a6:	39 f7                	cmp    %esi,%edi
  8041a8:	0f 86 a2 00 00 00    	jbe    804250 <__umoddi3+0xd8>
  8041ae:	89 c8                	mov    %ecx,%eax
  8041b0:	89 f2                	mov    %esi,%edx
  8041b2:	f7 f7                	div    %edi
  8041b4:	89 d0                	mov    %edx,%eax
  8041b6:	31 d2                	xor    %edx,%edx
  8041b8:	83 c4 1c             	add    $0x1c,%esp
  8041bb:	5b                   	pop    %ebx
  8041bc:	5e                   	pop    %esi
  8041bd:	5f                   	pop    %edi
  8041be:	5d                   	pop    %ebp
  8041bf:	c3                   	ret    
  8041c0:	39 f0                	cmp    %esi,%eax
  8041c2:	0f 87 ac 00 00 00    	ja     804274 <__umoddi3+0xfc>
  8041c8:	0f bd e8             	bsr    %eax,%ebp
  8041cb:	83 f5 1f             	xor    $0x1f,%ebp
  8041ce:	0f 84 ac 00 00 00    	je     804280 <__umoddi3+0x108>
  8041d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8041d9:	29 ef                	sub    %ebp,%edi
  8041db:	89 fe                	mov    %edi,%esi
  8041dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041e1:	89 e9                	mov    %ebp,%ecx
  8041e3:	d3 e0                	shl    %cl,%eax
  8041e5:	89 d7                	mov    %edx,%edi
  8041e7:	89 f1                	mov    %esi,%ecx
  8041e9:	d3 ef                	shr    %cl,%edi
  8041eb:	09 c7                	or     %eax,%edi
  8041ed:	89 e9                	mov    %ebp,%ecx
  8041ef:	d3 e2                	shl    %cl,%edx
  8041f1:	89 14 24             	mov    %edx,(%esp)
  8041f4:	89 d8                	mov    %ebx,%eax
  8041f6:	d3 e0                	shl    %cl,%eax
  8041f8:	89 c2                	mov    %eax,%edx
  8041fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041fe:	d3 e0                	shl    %cl,%eax
  804200:	89 44 24 04          	mov    %eax,0x4(%esp)
  804204:	8b 44 24 08          	mov    0x8(%esp),%eax
  804208:	89 f1                	mov    %esi,%ecx
  80420a:	d3 e8                	shr    %cl,%eax
  80420c:	09 d0                	or     %edx,%eax
  80420e:	d3 eb                	shr    %cl,%ebx
  804210:	89 da                	mov    %ebx,%edx
  804212:	f7 f7                	div    %edi
  804214:	89 d3                	mov    %edx,%ebx
  804216:	f7 24 24             	mull   (%esp)
  804219:	89 c6                	mov    %eax,%esi
  80421b:	89 d1                	mov    %edx,%ecx
  80421d:	39 d3                	cmp    %edx,%ebx
  80421f:	0f 82 87 00 00 00    	jb     8042ac <__umoddi3+0x134>
  804225:	0f 84 91 00 00 00    	je     8042bc <__umoddi3+0x144>
  80422b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80422f:	29 f2                	sub    %esi,%edx
  804231:	19 cb                	sbb    %ecx,%ebx
  804233:	89 d8                	mov    %ebx,%eax
  804235:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804239:	d3 e0                	shl    %cl,%eax
  80423b:	89 e9                	mov    %ebp,%ecx
  80423d:	d3 ea                	shr    %cl,%edx
  80423f:	09 d0                	or     %edx,%eax
  804241:	89 e9                	mov    %ebp,%ecx
  804243:	d3 eb                	shr    %cl,%ebx
  804245:	89 da                	mov    %ebx,%edx
  804247:	83 c4 1c             	add    $0x1c,%esp
  80424a:	5b                   	pop    %ebx
  80424b:	5e                   	pop    %esi
  80424c:	5f                   	pop    %edi
  80424d:	5d                   	pop    %ebp
  80424e:	c3                   	ret    
  80424f:	90                   	nop
  804250:	89 fd                	mov    %edi,%ebp
  804252:	85 ff                	test   %edi,%edi
  804254:	75 0b                	jne    804261 <__umoddi3+0xe9>
  804256:	b8 01 00 00 00       	mov    $0x1,%eax
  80425b:	31 d2                	xor    %edx,%edx
  80425d:	f7 f7                	div    %edi
  80425f:	89 c5                	mov    %eax,%ebp
  804261:	89 f0                	mov    %esi,%eax
  804263:	31 d2                	xor    %edx,%edx
  804265:	f7 f5                	div    %ebp
  804267:	89 c8                	mov    %ecx,%eax
  804269:	f7 f5                	div    %ebp
  80426b:	89 d0                	mov    %edx,%eax
  80426d:	e9 44 ff ff ff       	jmp    8041b6 <__umoddi3+0x3e>
  804272:	66 90                	xchg   %ax,%ax
  804274:	89 c8                	mov    %ecx,%eax
  804276:	89 f2                	mov    %esi,%edx
  804278:	83 c4 1c             	add    $0x1c,%esp
  80427b:	5b                   	pop    %ebx
  80427c:	5e                   	pop    %esi
  80427d:	5f                   	pop    %edi
  80427e:	5d                   	pop    %ebp
  80427f:	c3                   	ret    
  804280:	3b 04 24             	cmp    (%esp),%eax
  804283:	72 06                	jb     80428b <__umoddi3+0x113>
  804285:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804289:	77 0f                	ja     80429a <__umoddi3+0x122>
  80428b:	89 f2                	mov    %esi,%edx
  80428d:	29 f9                	sub    %edi,%ecx
  80428f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804293:	89 14 24             	mov    %edx,(%esp)
  804296:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80429a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80429e:	8b 14 24             	mov    (%esp),%edx
  8042a1:	83 c4 1c             	add    $0x1c,%esp
  8042a4:	5b                   	pop    %ebx
  8042a5:	5e                   	pop    %esi
  8042a6:	5f                   	pop    %edi
  8042a7:	5d                   	pop    %ebp
  8042a8:	c3                   	ret    
  8042a9:	8d 76 00             	lea    0x0(%esi),%esi
  8042ac:	2b 04 24             	sub    (%esp),%eax
  8042af:	19 fa                	sbb    %edi,%edx
  8042b1:	89 d1                	mov    %edx,%ecx
  8042b3:	89 c6                	mov    %eax,%esi
  8042b5:	e9 71 ff ff ff       	jmp    80422b <__umoddi3+0xb3>
  8042ba:	66 90                	xchg   %ax,%ax
  8042bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8042c0:	72 ea                	jb     8042ac <__umoddi3+0x134>
  8042c2:	89 d9                	mov    %ebx,%ecx
  8042c4:	e9 62 ff ff ff       	jmp    80422b <__umoddi3+0xb3>
