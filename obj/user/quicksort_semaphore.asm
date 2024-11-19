
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
  800042:	e8 ba 1d 00 00       	call   801e01 <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  80004a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	IO_CS = create_semaphore("IO.CS", 1);
  800051:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	6a 01                	push   $0x1
  80005c:	68 40 24 80 00       	push   $0x802440
  800061:	50                   	push   %eax
  800062:	e8 f3 20 00 00       	call   80215a <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 24 30 80 00       	mov    %eax,0x803024
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 d7 1b 00 00       	call   801c51 <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 e9 1b 00 00       	call   801c6a <sys_calculate_modified_frames>
  800081:	01 d8                	add    %ebx,%eax
  800083:	89 45 ec             	mov    %eax,-0x14(%ebp)

		Iteration++ ;
  800086:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

//	sys_lock_cons();
		int NumOfElements, *Elements;
		wait_semaphore(IO_CS);
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	ff 35 24 30 80 00    	pushl  0x803024
  800092:	e8 f7 20 00 00       	call   80218e <wait_semaphore>
  800097:	83 c4 10             	add    $0x10,%esp
		{
			readline("Enter the number of elements: ", Line);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 48 24 80 00       	push   $0x802448
  8000a9:	e8 4b 10 00 00       	call   8010f9 <readline>
  8000ae:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	6a 0a                	push   $0xa
  8000b6:	6a 00                	push   $0x0
  8000b8:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 9d 15 00 00       	call   801661 <strtol>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c1 e0 02             	shl    $0x2,%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 44 19 00 00       	call   801a1d <malloc>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 68 24 80 00       	push   $0x802468
  8000e7:	e8 79 09 00 00       	call   800a65 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 8b 24 80 00       	push   $0x80248b
  8000f7:	e8 69 09 00 00       	call   800a65 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 99 24 80 00       	push   $0x802499
  800107:	e8 59 09 00 00       	call   800a65 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 a8 24 80 00       	push   $0x8024a8
  800117:	e8 49 09 00 00       	call   800a65 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 b8 24 80 00       	push   $0x8024b8
  800127:	e8 39 09 00 00       	call   800a65 <cprintf>
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
  800169:	ff 35 24 30 80 00    	pushl  0x803024
  80016f:	e8 34 20 00 00       	call   8021a8 <signal_semaphore>
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
  800202:	68 c4 24 80 00       	push   $0x8024c4
  800207:	6a 4d                	push   $0x4d
  800209:	68 e6 24 80 00       	push   $0x8024e6
  80020e:	e8 95 05 00 00       	call   8007a8 <_panic>
		else
		{
			wait_semaphore(IO_CS);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 35 24 30 80 00    	pushl  0x803024
  80021c:	e8 6d 1f 00 00       	call   80218e <wait_semaphore>
  800221:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 04 25 80 00       	push   $0x802504
  80022c:	e8 34 08 00 00       	call   800a65 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 38 25 80 00       	push   $0x802538
  80023c:	e8 24 08 00 00       	call   800a65 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 6c 25 80 00       	push   $0x80256c
  80024c:	e8 14 08 00 00       	call   800a65 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			signal_semaphore(IO_CS);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 35 24 30 80 00    	pushl  0x803024
  80025d:	e8 46 1f 00 00       	call   8021a8 <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 24 30 80 00    	pushl  0x803024
  80026e:	e8 1b 1f 00 00       	call   80218e <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 9e 25 80 00       	push   $0x80259e
  80027e:	e8 e2 07 00 00       	call   800a65 <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 24 30 80 00    	pushl  0x803024
  80028f:	e8 14 1f 00 00       	call   8021a8 <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 24 30 80 00    	pushl  0x803024
  8002a0:	e8 e9 1e 00 00       	call   80218e <wait_semaphore>
  8002a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 b4 25 80 00       	push   $0x8025b4
  8002b0:	e8 b0 07 00 00       	call   800a65 <cprintf>
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
  8002ed:	ff 35 24 30 80 00    	pushl  0x803024
  8002f3:	e8 b0 1e 00 00       	call   8021a8 <signal_semaphore>
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
  80058b:	e8 71 18 00 00       	call   801e01 <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 24 30 80 00    	pushl  0x803024
  80059c:	e8 ed 1b 00 00       	call   80218e <wait_semaphore>
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
  8005c4:	68 d2 25 80 00       	push   $0x8025d2
  8005c9:	e8 97 04 00 00       	call   800a65 <cprintf>
  8005ce:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  8005d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	50                   	push   %eax
  8005e6:	68 d4 25 80 00       	push   $0x8025d4
  8005eb:	e8 75 04 00 00       	call   800a65 <cprintf>
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
  800614:	68 d9 25 80 00       	push   $0x8025d9
  800619:	e8 47 04 00 00       	call   800a65 <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(IO_CS);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	ff 35 24 30 80 00    	pushl  0x803024
  80062a:	e8 79 1b 00 00       	call   8021a8 <signal_semaphore>
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
  800649:	e8 9b 16 00 00       	call   801ce9 <sys_cputc>
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
  80065a:	e8 26 15 00 00       	call   801b85 <sys_cgetc>
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
  800677:	e8 9e 17 00 00       	call   801e1a <sys_getenvindex>
  80067c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80067f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800682:	89 d0                	mov    %edx,%eax
  800684:	c1 e0 02             	shl    $0x2,%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	01 c0                	add    %eax,%eax
  80068b:	01 d0                	add    %edx,%eax
  80068d:	c1 e0 02             	shl    $0x2,%eax
  800690:	01 d0                	add    %edx,%eax
  800692:	01 c0                	add    %eax,%eax
  800694:	01 d0                	add    %edx,%eax
  800696:	c1 e0 04             	shl    $0x4,%eax
  800699:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80069e:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006a3:	a1 08 30 80 00       	mov    0x803008,%eax
  8006a8:	8a 40 20             	mov    0x20(%eax),%al
  8006ab:	84 c0                	test   %al,%al
  8006ad:	74 0d                	je     8006bc <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8006af:	a1 08 30 80 00       	mov    0x803008,%eax
  8006b4:	83 c0 20             	add    $0x20,%eax
  8006b7:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006c0:	7e 0a                	jle    8006cc <libmain+0x5b>
		binaryname = argv[0];
  8006c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 5e f9 ff ff       	call   800038 <_main>
  8006da:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8006dd:	e8 bc 14 00 00       	call   801b9e <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8006e2:	83 ec 0c             	sub    $0xc,%esp
  8006e5:	68 f8 25 80 00       	push   $0x8025f8
  8006ea:	e8 76 03 00 00       	call   800a65 <cprintf>
  8006ef:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006f2:	a1 08 30 80 00       	mov    0x803008,%eax
  8006f7:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8006fd:	a1 08 30 80 00       	mov    0x803008,%eax
  800702:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800708:	83 ec 04             	sub    $0x4,%esp
  80070b:	52                   	push   %edx
  80070c:	50                   	push   %eax
  80070d:	68 20 26 80 00       	push   $0x802620
  800712:	e8 4e 03 00 00       	call   800a65 <cprintf>
  800717:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80071a:	a1 08 30 80 00       	mov    0x803008,%eax
  80071f:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800725:	a1 08 30 80 00       	mov    0x803008,%eax
  80072a:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800730:	a1 08 30 80 00       	mov    0x803008,%eax
  800735:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80073b:	51                   	push   %ecx
  80073c:	52                   	push   %edx
  80073d:	50                   	push   %eax
  80073e:	68 48 26 80 00       	push   $0x802648
  800743:	e8 1d 03 00 00       	call   800a65 <cprintf>
  800748:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80074b:	a1 08 30 80 00       	mov    0x803008,%eax
  800750:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	50                   	push   %eax
  80075a:	68 a0 26 80 00       	push   $0x8026a0
  80075f:	e8 01 03 00 00       	call   800a65 <cprintf>
  800764:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800767:	83 ec 0c             	sub    $0xc,%esp
  80076a:	68 f8 25 80 00       	push   $0x8025f8
  80076f:	e8 f1 02 00 00       	call   800a65 <cprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800777:	e8 3c 14 00 00       	call   801bb8 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80077c:	e8 19 00 00 00       	call   80079a <exit>
}
  800781:	90                   	nop
  800782:	c9                   	leave  
  800783:	c3                   	ret    

00800784 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80078a:	83 ec 0c             	sub    $0xc,%esp
  80078d:	6a 00                	push   $0x0
  80078f:	e8 52 16 00 00       	call   801de6 <sys_destroy_env>
  800794:	83 c4 10             	add    $0x10,%esp
}
  800797:	90                   	nop
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <exit>:

void
exit(void)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007a0:	e8 a7 16 00 00       	call   801e4c <sys_exit_env>
}
  8007a5:	90                   	nop
  8007a6:	c9                   	leave  
  8007a7:	c3                   	ret    

008007a8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007ae:	8d 45 10             	lea    0x10(%ebp),%eax
  8007b1:	83 c0 04             	add    $0x4,%eax
  8007b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007b7:	a1 34 30 80 00       	mov    0x803034,%eax
  8007bc:	85 c0                	test   %eax,%eax
  8007be:	74 16                	je     8007d6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007c0:	a1 34 30 80 00       	mov    0x803034,%eax
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	50                   	push   %eax
  8007c9:	68 b4 26 80 00       	push   $0x8026b4
  8007ce:	e8 92 02 00 00       	call   800a65 <cprintf>
  8007d3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007d6:	a1 00 30 80 00       	mov    0x803000,%eax
  8007db:	ff 75 0c             	pushl  0xc(%ebp)
  8007de:	ff 75 08             	pushl  0x8(%ebp)
  8007e1:	50                   	push   %eax
  8007e2:	68 b9 26 80 00       	push   $0x8026b9
  8007e7:	e8 79 02 00 00       	call   800a65 <cprintf>
  8007ec:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f8:	50                   	push   %eax
  8007f9:	e8 fc 01 00 00       	call   8009fa <vcprintf>
  8007fe:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	6a 00                	push   $0x0
  800806:	68 d5 26 80 00       	push   $0x8026d5
  80080b:	e8 ea 01 00 00       	call   8009fa <vcprintf>
  800810:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800813:	e8 82 ff ff ff       	call   80079a <exit>

	// should not return here
	while (1) ;
  800818:	eb fe                	jmp    800818 <_panic+0x70>

0080081a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800820:	a1 08 30 80 00       	mov    0x803008,%eax
  800825:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80082b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082e:	39 c2                	cmp    %eax,%edx
  800830:	74 14                	je     800846 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800832:	83 ec 04             	sub    $0x4,%esp
  800835:	68 d8 26 80 00       	push   $0x8026d8
  80083a:	6a 26                	push   $0x26
  80083c:	68 24 27 80 00       	push   $0x802724
  800841:	e8 62 ff ff ff       	call   8007a8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800846:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80084d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800854:	e9 c5 00 00 00       	jmp    80091e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	01 d0                	add    %edx,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	85 c0                	test   %eax,%eax
  80086c:	75 08                	jne    800876 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80086e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800871:	e9 a5 00 00 00       	jmp    80091b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800876:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80087d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800884:	eb 69                	jmp    8008ef <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800886:	a1 08 30 80 00       	mov    0x803008,%eax
  80088b:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800891:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800894:	89 d0                	mov    %edx,%eax
  800896:	01 c0                	add    %eax,%eax
  800898:	01 d0                	add    %edx,%eax
  80089a:	c1 e0 03             	shl    $0x3,%eax
  80089d:	01 c8                	add    %ecx,%eax
  80089f:	8a 40 04             	mov    0x4(%eax),%al
  8008a2:	84 c0                	test   %al,%al
  8008a4:	75 46                	jne    8008ec <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008a6:	a1 08 30 80 00       	mov    0x803008,%eax
  8008ab:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8008b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008b4:	89 d0                	mov    %edx,%eax
  8008b6:	01 c0                	add    %eax,%eax
  8008b8:	01 d0                	add    %edx,%eax
  8008ba:	c1 e0 03             	shl    $0x3,%eax
  8008bd:	01 c8                	add    %ecx,%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008cc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	01 c8                	add    %ecx,%eax
  8008dd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008df:	39 c2                	cmp    %eax,%edx
  8008e1:	75 09                	jne    8008ec <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008e3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008ea:	eb 15                	jmp    800901 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008ec:	ff 45 e8             	incl   -0x18(%ebp)
  8008ef:	a1 08 30 80 00       	mov    0x803008,%eax
  8008f4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8008fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008fd:	39 c2                	cmp    %eax,%edx
  8008ff:	77 85                	ja     800886 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800901:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800905:	75 14                	jne    80091b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800907:	83 ec 04             	sub    $0x4,%esp
  80090a:	68 30 27 80 00       	push   $0x802730
  80090f:	6a 3a                	push   $0x3a
  800911:	68 24 27 80 00       	push   $0x802724
  800916:	e8 8d fe ff ff       	call   8007a8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80091b:	ff 45 f0             	incl   -0x10(%ebp)
  80091e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800921:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800924:	0f 8c 2f ff ff ff    	jl     800859 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80092a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800931:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800938:	eb 26                	jmp    800960 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80093a:	a1 08 30 80 00       	mov    0x803008,%eax
  80093f:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  800945:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800948:	89 d0                	mov    %edx,%eax
  80094a:	01 c0                	add    %eax,%eax
  80094c:	01 d0                	add    %edx,%eax
  80094e:	c1 e0 03             	shl    $0x3,%eax
  800951:	01 c8                	add    %ecx,%eax
  800953:	8a 40 04             	mov    0x4(%eax),%al
  800956:	3c 01                	cmp    $0x1,%al
  800958:	75 03                	jne    80095d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80095a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80095d:	ff 45 e0             	incl   -0x20(%ebp)
  800960:	a1 08 30 80 00       	mov    0x803008,%eax
  800965:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80096b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80096e:	39 c2                	cmp    %eax,%edx
  800970:	77 c8                	ja     80093a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800975:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800978:	74 14                	je     80098e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80097a:	83 ec 04             	sub    $0x4,%esp
  80097d:	68 84 27 80 00       	push   $0x802784
  800982:	6a 44                	push   $0x44
  800984:	68 24 27 80 00       	push   $0x802724
  800989:	e8 1a fe ff ff       	call   8007a8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80098e:	90                   	nop
  80098f:	c9                   	leave  
  800990:	c3                   	ret    

00800991 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800997:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	8d 48 01             	lea    0x1(%eax),%ecx
  80099f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a2:	89 0a                	mov    %ecx,(%edx)
  8009a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8009a7:	88 d1                	mov    %dl,%cl
  8009a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ac:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b3:	8b 00                	mov    (%eax),%eax
  8009b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009ba:	75 2c                	jne    8009e8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009bc:	a0 0c 30 80 00       	mov    0x80300c,%al
  8009c1:	0f b6 c0             	movzbl %al,%eax
  8009c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c7:	8b 12                	mov    (%edx),%edx
  8009c9:	89 d1                	mov    %edx,%ecx
  8009cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ce:	83 c2 08             	add    $0x8,%edx
  8009d1:	83 ec 04             	sub    $0x4,%esp
  8009d4:	50                   	push   %eax
  8009d5:	51                   	push   %ecx
  8009d6:	52                   	push   %edx
  8009d7:	e8 80 11 00 00       	call   801b5c <sys_cputs>
  8009dc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009eb:	8b 40 04             	mov    0x4(%eax),%eax
  8009ee:	8d 50 01             	lea    0x1(%eax),%edx
  8009f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009f7:	90                   	nop
  8009f8:	c9                   	leave  
  8009f9:	c3                   	ret    

008009fa <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a03:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a0a:	00 00 00 
	b.cnt = 0;
  800a0d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a14:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a17:	ff 75 0c             	pushl  0xc(%ebp)
  800a1a:	ff 75 08             	pushl  0x8(%ebp)
  800a1d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a23:	50                   	push   %eax
  800a24:	68 91 09 80 00       	push   $0x800991
  800a29:	e8 11 02 00 00       	call   800c3f <vprintfmt>
  800a2e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a31:	a0 0c 30 80 00       	mov    0x80300c,%al
  800a36:	0f b6 c0             	movzbl %al,%eax
  800a39:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a3f:	83 ec 04             	sub    $0x4,%esp
  800a42:	50                   	push   %eax
  800a43:	52                   	push   %edx
  800a44:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a4a:	83 c0 08             	add    $0x8,%eax
  800a4d:	50                   	push   %eax
  800a4e:	e8 09 11 00 00       	call   801b5c <sys_cputs>
  800a53:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a56:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800a5d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a63:	c9                   	leave  
  800a64:	c3                   	ret    

00800a65 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a6b:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800a72:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	83 ec 08             	sub    $0x8,%esp
  800a7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a81:	50                   	push   %eax
  800a82:	e8 73 ff ff ff       	call   8009fa <vcprintf>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a90:	c9                   	leave  
  800a91:	c3                   	ret    

00800a92 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800a98:	e8 01 11 00 00       	call   801b9e <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800a9d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 f4             	pushl  -0xc(%ebp)
  800aac:	50                   	push   %eax
  800aad:	e8 48 ff ff ff       	call   8009fa <vcprintf>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ab8:	e8 fb 10 00 00       	call   801bb8 <sys_unlock_cons>
	return cnt;
  800abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ac0:	c9                   	leave  
  800ac1:	c3                   	ret    

00800ac2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	53                   	push   %ebx
  800ac6:	83 ec 14             	sub    $0x14,%esp
  800ac9:	8b 45 10             	mov    0x10(%ebp),%eax
  800acc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800acf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ad5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ad8:	ba 00 00 00 00       	mov    $0x0,%edx
  800add:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ae0:	77 55                	ja     800b37 <printnum+0x75>
  800ae2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ae5:	72 05                	jb     800aec <printnum+0x2a>
  800ae7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800aea:	77 4b                	ja     800b37 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800aec:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800aef:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800af2:	8b 45 18             	mov    0x18(%ebp),%eax
  800af5:	ba 00 00 00 00       	mov    $0x0,%edx
  800afa:	52                   	push   %edx
  800afb:	50                   	push   %eax
  800afc:	ff 75 f4             	pushl  -0xc(%ebp)
  800aff:	ff 75 f0             	pushl  -0x10(%ebp)
  800b02:	e8 c9 16 00 00       	call   8021d0 <__udivdi3>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	83 ec 04             	sub    $0x4,%esp
  800b0d:	ff 75 20             	pushl  0x20(%ebp)
  800b10:	53                   	push   %ebx
  800b11:	ff 75 18             	pushl  0x18(%ebp)
  800b14:	52                   	push   %edx
  800b15:	50                   	push   %eax
  800b16:	ff 75 0c             	pushl  0xc(%ebp)
  800b19:	ff 75 08             	pushl  0x8(%ebp)
  800b1c:	e8 a1 ff ff ff       	call   800ac2 <printnum>
  800b21:	83 c4 20             	add    $0x20,%esp
  800b24:	eb 1a                	jmp    800b40 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	ff 75 0c             	pushl  0xc(%ebp)
  800b2c:	ff 75 20             	pushl  0x20(%ebp)
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	ff d0                	call   *%eax
  800b34:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b37:	ff 4d 1c             	decl   0x1c(%ebp)
  800b3a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b3e:	7f e6                	jg     800b26 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b40:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b4e:	53                   	push   %ebx
  800b4f:	51                   	push   %ecx
  800b50:	52                   	push   %edx
  800b51:	50                   	push   %eax
  800b52:	e8 89 17 00 00       	call   8022e0 <__umoddi3>
  800b57:	83 c4 10             	add    $0x10,%esp
  800b5a:	05 f4 29 80 00       	add    $0x8029f4,%eax
  800b5f:	8a 00                	mov    (%eax),%al
  800b61:	0f be c0             	movsbl %al,%eax
  800b64:	83 ec 08             	sub    $0x8,%esp
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	50                   	push   %eax
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	ff d0                	call   *%eax
  800b70:	83 c4 10             	add    $0x10,%esp
}
  800b73:	90                   	nop
  800b74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    

00800b79 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b7c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b80:	7e 1c                	jle    800b9e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8b 00                	mov    (%eax),%eax
  800b87:	8d 50 08             	lea    0x8(%eax),%edx
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	89 10                	mov    %edx,(%eax)
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 00                	mov    (%eax),%eax
  800b94:	83 e8 08             	sub    $0x8,%eax
  800b97:	8b 50 04             	mov    0x4(%eax),%edx
  800b9a:	8b 00                	mov    (%eax),%eax
  800b9c:	eb 40                	jmp    800bde <getuint+0x65>
	else if (lflag)
  800b9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba2:	74 1e                	je     800bc2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	8d 50 04             	lea    0x4(%eax),%edx
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	89 10                	mov    %edx,(%eax)
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	8b 00                	mov    (%eax),%eax
  800bb6:	83 e8 04             	sub    $0x4,%eax
  800bb9:	8b 00                	mov    (%eax),%eax
  800bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc0:	eb 1c                	jmp    800bde <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8b 00                	mov    (%eax),%eax
  800bc7:	8d 50 04             	lea    0x4(%eax),%edx
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	89 10                	mov    %edx,(%eax)
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8b 00                	mov    (%eax),%eax
  800bd4:	83 e8 04             	sub    $0x4,%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800be3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800be7:	7e 1c                	jle    800c05 <getint+0x25>
		return va_arg(*ap, long long);
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8b 00                	mov    (%eax),%eax
  800bee:	8d 50 08             	lea    0x8(%eax),%edx
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 10                	mov    %edx,(%eax)
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8b 00                	mov    (%eax),%eax
  800bfb:	83 e8 08             	sub    $0x8,%eax
  800bfe:	8b 50 04             	mov    0x4(%eax),%edx
  800c01:	8b 00                	mov    (%eax),%eax
  800c03:	eb 38                	jmp    800c3d <getint+0x5d>
	else if (lflag)
  800c05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c09:	74 1a                	je     800c25 <getint+0x45>
		return va_arg(*ap, long);
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8b 00                	mov    (%eax),%eax
  800c10:	8d 50 04             	lea    0x4(%eax),%edx
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	89 10                	mov    %edx,(%eax)
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8b 00                	mov    (%eax),%eax
  800c1d:	83 e8 04             	sub    $0x4,%eax
  800c20:	8b 00                	mov    (%eax),%eax
  800c22:	99                   	cltd   
  800c23:	eb 18                	jmp    800c3d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	8b 00                	mov    (%eax),%eax
  800c2a:	8d 50 04             	lea    0x4(%eax),%edx
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	89 10                	mov    %edx,(%eax)
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	8b 00                	mov    (%eax),%eax
  800c37:	83 e8 04             	sub    $0x4,%eax
  800c3a:	8b 00                	mov    (%eax),%eax
  800c3c:	99                   	cltd   
}
  800c3d:	5d                   	pop    %ebp
  800c3e:	c3                   	ret    

00800c3f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	56                   	push   %esi
  800c43:	53                   	push   %ebx
  800c44:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c47:	eb 17                	jmp    800c60 <vprintfmt+0x21>
			if (ch == '\0')
  800c49:	85 db                	test   %ebx,%ebx
  800c4b:	0f 84 c1 03 00 00    	je     801012 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	53                   	push   %ebx
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c60:	8b 45 10             	mov    0x10(%ebp),%eax
  800c63:	8d 50 01             	lea    0x1(%eax),%edx
  800c66:	89 55 10             	mov    %edx,0x10(%ebp)
  800c69:	8a 00                	mov    (%eax),%al
  800c6b:	0f b6 d8             	movzbl %al,%ebx
  800c6e:	83 fb 25             	cmp    $0x25,%ebx
  800c71:	75 d6                	jne    800c49 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c73:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c77:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c7e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c85:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c8c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c93:	8b 45 10             	mov    0x10(%ebp),%eax
  800c96:	8d 50 01             	lea    0x1(%eax),%edx
  800c99:	89 55 10             	mov    %edx,0x10(%ebp)
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	0f b6 d8             	movzbl %al,%ebx
  800ca1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ca4:	83 f8 5b             	cmp    $0x5b,%eax
  800ca7:	0f 87 3d 03 00 00    	ja     800fea <vprintfmt+0x3ab>
  800cad:	8b 04 85 18 2a 80 00 	mov    0x802a18(,%eax,4),%eax
  800cb4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cb6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cba:	eb d7                	jmp    800c93 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cbc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cc0:	eb d1                	jmp    800c93 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cc2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cc9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ccc:	89 d0                	mov    %edx,%eax
  800cce:	c1 e0 02             	shl    $0x2,%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	01 d8                	add    %ebx,%eax
  800cd7:	83 e8 30             	sub    $0x30,%eax
  800cda:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ce5:	83 fb 2f             	cmp    $0x2f,%ebx
  800ce8:	7e 3e                	jle    800d28 <vprintfmt+0xe9>
  800cea:	83 fb 39             	cmp    $0x39,%ebx
  800ced:	7f 39                	jg     800d28 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cef:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cf2:	eb d5                	jmp    800cc9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cf4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf7:	83 c0 04             	add    $0x4,%eax
  800cfa:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfd:	8b 45 14             	mov    0x14(%ebp),%eax
  800d00:	83 e8 04             	sub    $0x4,%eax
  800d03:	8b 00                	mov    (%eax),%eax
  800d05:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d08:	eb 1f                	jmp    800d29 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0e:	79 83                	jns    800c93 <vprintfmt+0x54>
				width = 0;
  800d10:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d17:	e9 77 ff ff ff       	jmp    800c93 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d1c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d23:	e9 6b ff ff ff       	jmp    800c93 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d28:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d2d:	0f 89 60 ff ff ff    	jns    800c93 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d39:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d40:	e9 4e ff ff ff       	jmp    800c93 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d45:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d48:	e9 46 ff ff ff       	jmp    800c93 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d50:	83 c0 04             	add    $0x4,%eax
  800d53:	89 45 14             	mov    %eax,0x14(%ebp)
  800d56:	8b 45 14             	mov    0x14(%ebp),%eax
  800d59:	83 e8 04             	sub    $0x4,%eax
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	83 ec 08             	sub    $0x8,%esp
  800d61:	ff 75 0c             	pushl  0xc(%ebp)
  800d64:	50                   	push   %eax
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	ff d0                	call   *%eax
  800d6a:	83 c4 10             	add    $0x10,%esp
			break;
  800d6d:	e9 9b 02 00 00       	jmp    80100d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d72:	8b 45 14             	mov    0x14(%ebp),%eax
  800d75:	83 c0 04             	add    $0x4,%eax
  800d78:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7e:	83 e8 04             	sub    $0x4,%eax
  800d81:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d83:	85 db                	test   %ebx,%ebx
  800d85:	79 02                	jns    800d89 <vprintfmt+0x14a>
				err = -err;
  800d87:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d89:	83 fb 64             	cmp    $0x64,%ebx
  800d8c:	7f 0b                	jg     800d99 <vprintfmt+0x15a>
  800d8e:	8b 34 9d 60 28 80 00 	mov    0x802860(,%ebx,4),%esi
  800d95:	85 f6                	test   %esi,%esi
  800d97:	75 19                	jne    800db2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d99:	53                   	push   %ebx
  800d9a:	68 05 2a 80 00       	push   $0x802a05
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 08             	pushl  0x8(%ebp)
  800da5:	e8 70 02 00 00       	call   80101a <printfmt>
  800daa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dad:	e9 5b 02 00 00       	jmp    80100d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800db2:	56                   	push   %esi
  800db3:	68 0e 2a 80 00       	push   $0x802a0e
  800db8:	ff 75 0c             	pushl  0xc(%ebp)
  800dbb:	ff 75 08             	pushl  0x8(%ebp)
  800dbe:	e8 57 02 00 00       	call   80101a <printfmt>
  800dc3:	83 c4 10             	add    $0x10,%esp
			break;
  800dc6:	e9 42 02 00 00       	jmp    80100d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dce:	83 c0 04             	add    $0x4,%eax
  800dd1:	89 45 14             	mov    %eax,0x14(%ebp)
  800dd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd7:	83 e8 04             	sub    $0x4,%eax
  800dda:	8b 30                	mov    (%eax),%esi
  800ddc:	85 f6                	test   %esi,%esi
  800dde:	75 05                	jne    800de5 <vprintfmt+0x1a6>
				p = "(null)";
  800de0:	be 11 2a 80 00       	mov    $0x802a11,%esi
			if (width > 0 && padc != '-')
  800de5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800de9:	7e 6d                	jle    800e58 <vprintfmt+0x219>
  800deb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800def:	74 67                	je     800e58 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800df1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800df4:	83 ec 08             	sub    $0x8,%esp
  800df7:	50                   	push   %eax
  800df8:	56                   	push   %esi
  800df9:	e8 26 05 00 00       	call   801324 <strnlen>
  800dfe:	83 c4 10             	add    $0x10,%esp
  800e01:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e04:	eb 16                	jmp    800e1c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e06:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	ff 75 0c             	pushl  0xc(%ebp)
  800e10:	50                   	push   %eax
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	ff d0                	call   *%eax
  800e16:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e19:	ff 4d e4             	decl   -0x1c(%ebp)
  800e1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e20:	7f e4                	jg     800e06 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e22:	eb 34                	jmp    800e58 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e24:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e28:	74 1c                	je     800e46 <vprintfmt+0x207>
  800e2a:	83 fb 1f             	cmp    $0x1f,%ebx
  800e2d:	7e 05                	jle    800e34 <vprintfmt+0x1f5>
  800e2f:	83 fb 7e             	cmp    $0x7e,%ebx
  800e32:	7e 12                	jle    800e46 <vprintfmt+0x207>
					putch('?', putdat);
  800e34:	83 ec 08             	sub    $0x8,%esp
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	6a 3f                	push   $0x3f
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	ff d0                	call   *%eax
  800e41:	83 c4 10             	add    $0x10,%esp
  800e44:	eb 0f                	jmp    800e55 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e46:	83 ec 08             	sub    $0x8,%esp
  800e49:	ff 75 0c             	pushl  0xc(%ebp)
  800e4c:	53                   	push   %ebx
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	ff d0                	call   *%eax
  800e52:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e55:	ff 4d e4             	decl   -0x1c(%ebp)
  800e58:	89 f0                	mov    %esi,%eax
  800e5a:	8d 70 01             	lea    0x1(%eax),%esi
  800e5d:	8a 00                	mov    (%eax),%al
  800e5f:	0f be d8             	movsbl %al,%ebx
  800e62:	85 db                	test   %ebx,%ebx
  800e64:	74 24                	je     800e8a <vprintfmt+0x24b>
  800e66:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e6a:	78 b8                	js     800e24 <vprintfmt+0x1e5>
  800e6c:	ff 4d e0             	decl   -0x20(%ebp)
  800e6f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e73:	79 af                	jns    800e24 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e75:	eb 13                	jmp    800e8a <vprintfmt+0x24b>
				putch(' ', putdat);
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	6a 20                	push   $0x20
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e87:	ff 4d e4             	decl   -0x1c(%ebp)
  800e8a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e8e:	7f e7                	jg     800e77 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e90:	e9 78 01 00 00       	jmp    80100d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e95:	83 ec 08             	sub    $0x8,%esp
  800e98:	ff 75 e8             	pushl  -0x18(%ebp)
  800e9b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e9e:	50                   	push   %eax
  800e9f:	e8 3c fd ff ff       	call   800be0 <getint>
  800ea4:	83 c4 10             	add    $0x10,%esp
  800ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eaa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb3:	85 d2                	test   %edx,%edx
  800eb5:	79 23                	jns    800eda <vprintfmt+0x29b>
				putch('-', putdat);
  800eb7:	83 ec 08             	sub    $0x8,%esp
  800eba:	ff 75 0c             	pushl  0xc(%ebp)
  800ebd:	6a 2d                	push   $0x2d
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	ff d0                	call   *%eax
  800ec4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ecd:	f7 d8                	neg    %eax
  800ecf:	83 d2 00             	adc    $0x0,%edx
  800ed2:	f7 da                	neg    %edx
  800ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800eda:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee1:	e9 bc 00 00 00       	jmp    800fa2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ee6:	83 ec 08             	sub    $0x8,%esp
  800ee9:	ff 75 e8             	pushl  -0x18(%ebp)
  800eec:	8d 45 14             	lea    0x14(%ebp),%eax
  800eef:	50                   	push   %eax
  800ef0:	e8 84 fc ff ff       	call   800b79 <getuint>
  800ef5:	83 c4 10             	add    $0x10,%esp
  800ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800efe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f05:	e9 98 00 00 00       	jmp    800fa2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	6a 58                	push   $0x58
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	ff 75 0c             	pushl  0xc(%ebp)
  800f20:	6a 58                	push   $0x58
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	ff d0                	call   *%eax
  800f27:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f2a:	83 ec 08             	sub    $0x8,%esp
  800f2d:	ff 75 0c             	pushl  0xc(%ebp)
  800f30:	6a 58                	push   $0x58
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	ff d0                	call   *%eax
  800f37:	83 c4 10             	add    $0x10,%esp
			break;
  800f3a:	e9 ce 00 00 00       	jmp    80100d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f3f:	83 ec 08             	sub    $0x8,%esp
  800f42:	ff 75 0c             	pushl  0xc(%ebp)
  800f45:	6a 30                	push   $0x30
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	ff d0                	call   *%eax
  800f4c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	6a 78                	push   $0x78
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	ff d0                	call   *%eax
  800f5c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f62:	83 c0 04             	add    $0x4,%eax
  800f65:	89 45 14             	mov    %eax,0x14(%ebp)
  800f68:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6b:	83 e8 04             	sub    $0x4,%eax
  800f6e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f81:	eb 1f                	jmp    800fa2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f83:	83 ec 08             	sub    $0x8,%esp
  800f86:	ff 75 e8             	pushl  -0x18(%ebp)
  800f89:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8c:	50                   	push   %eax
  800f8d:	e8 e7 fb ff ff       	call   800b79 <getuint>
  800f92:	83 c4 10             	add    $0x10,%esp
  800f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f98:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f9b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fa2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fa9:	83 ec 04             	sub    $0x4,%esp
  800fac:	52                   	push   %edx
  800fad:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fb0:	50                   	push   %eax
  800fb1:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb4:	ff 75 f0             	pushl  -0x10(%ebp)
  800fb7:	ff 75 0c             	pushl  0xc(%ebp)
  800fba:	ff 75 08             	pushl  0x8(%ebp)
  800fbd:	e8 00 fb ff ff       	call   800ac2 <printnum>
  800fc2:	83 c4 20             	add    $0x20,%esp
			break;
  800fc5:	eb 46                	jmp    80100d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	53                   	push   %ebx
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	ff d0                	call   *%eax
  800fd3:	83 c4 10             	add    $0x10,%esp
			break;
  800fd6:	eb 35                	jmp    80100d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800fd8:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800fdf:	eb 2c                	jmp    80100d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800fe1:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800fe8:	eb 23                	jmp    80100d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fea:	83 ec 08             	sub    $0x8,%esp
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	6a 25                	push   $0x25
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	ff d0                	call   *%eax
  800ff7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ffa:	ff 4d 10             	decl   0x10(%ebp)
  800ffd:	eb 03                	jmp    801002 <vprintfmt+0x3c3>
  800fff:	ff 4d 10             	decl   0x10(%ebp)
  801002:	8b 45 10             	mov    0x10(%ebp),%eax
  801005:	48                   	dec    %eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 25                	cmp    $0x25,%al
  80100a:	75 f3                	jne    800fff <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80100c:	90                   	nop
		}
	}
  80100d:	e9 35 fc ff ff       	jmp    800c47 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801012:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801013:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801016:	5b                   	pop    %ebx
  801017:	5e                   	pop    %esi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801020:	8d 45 10             	lea    0x10(%ebp),%eax
  801023:	83 c0 04             	add    $0x4,%eax
  801026:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801029:	8b 45 10             	mov    0x10(%ebp),%eax
  80102c:	ff 75 f4             	pushl  -0xc(%ebp)
  80102f:	50                   	push   %eax
  801030:	ff 75 0c             	pushl  0xc(%ebp)
  801033:	ff 75 08             	pushl  0x8(%ebp)
  801036:	e8 04 fc ff ff       	call   800c3f <vprintfmt>
  80103b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80103e:	90                   	nop
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 40 08             	mov    0x8(%eax),%eax
  80104a:	8d 50 01             	lea    0x1(%eax),%edx
  80104d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801050:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801053:	8b 45 0c             	mov    0xc(%ebp),%eax
  801056:	8b 10                	mov    (%eax),%edx
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	8b 40 04             	mov    0x4(%eax),%eax
  80105e:	39 c2                	cmp    %eax,%edx
  801060:	73 12                	jae    801074 <sprintputch+0x33>
		*b->buf++ = ch;
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	8b 00                	mov    (%eax),%eax
  801067:	8d 48 01             	lea    0x1(%eax),%ecx
  80106a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106d:	89 0a                	mov    %ecx,(%edx)
  80106f:	8b 55 08             	mov    0x8(%ebp),%edx
  801072:	88 10                	mov    %dl,(%eax)
}
  801074:	90                   	nop
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801083:	8b 45 0c             	mov    0xc(%ebp),%eax
  801086:	8d 50 ff             	lea    -0x1(%eax),%edx
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	01 d0                	add    %edx,%eax
  80108e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801091:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801098:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80109c:	74 06                	je     8010a4 <vsnprintf+0x2d>
  80109e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a2:	7f 07                	jg     8010ab <vsnprintf+0x34>
		return -E_INVAL;
  8010a4:	b8 03 00 00 00       	mov    $0x3,%eax
  8010a9:	eb 20                	jmp    8010cb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010ab:	ff 75 14             	pushl  0x14(%ebp)
  8010ae:	ff 75 10             	pushl  0x10(%ebp)
  8010b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010b4:	50                   	push   %eax
  8010b5:	68 41 10 80 00       	push   $0x801041
  8010ba:	e8 80 fb ff ff       	call   800c3f <vprintfmt>
  8010bf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010c5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010d3:	8d 45 10             	lea    0x10(%ebp),%eax
  8010d6:	83 c0 04             	add    $0x4,%eax
  8010d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	ff 75 f4             	pushl  -0xc(%ebp)
  8010e2:	50                   	push   %eax
  8010e3:	ff 75 0c             	pushl  0xc(%ebp)
  8010e6:	ff 75 08             	pushl  0x8(%ebp)
  8010e9:	e8 89 ff ff ff       	call   801077 <vsnprintf>
  8010ee:	83 c4 10             	add    $0x10,%esp
  8010f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010f7:	c9                   	leave  
  8010f8:	c3                   	ret    

008010f9 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8010ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801103:	74 13                	je     801118 <readline+0x1f>
		cprintf("%s", prompt);
  801105:	83 ec 08             	sub    $0x8,%esp
  801108:	ff 75 08             	pushl  0x8(%ebp)
  80110b:	68 88 2b 80 00       	push   $0x802b88
  801110:	e8 50 f9 ff ff       	call   800a65 <cprintf>
  801115:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801118:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80111f:	83 ec 0c             	sub    $0xc,%esp
  801122:	6a 00                	push   $0x0
  801124:	e8 3e f5 ff ff       	call   800667 <iscons>
  801129:	83 c4 10             	add    $0x10,%esp
  80112c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80112f:	e8 20 f5 ff ff       	call   800654 <getchar>
  801134:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801137:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80113b:	79 22                	jns    80115f <readline+0x66>
			if (c != -E_EOF)
  80113d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801141:	0f 84 ad 00 00 00    	je     8011f4 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801147:	83 ec 08             	sub    $0x8,%esp
  80114a:	ff 75 ec             	pushl  -0x14(%ebp)
  80114d:	68 8b 2b 80 00       	push   $0x802b8b
  801152:	e8 0e f9 ff ff       	call   800a65 <cprintf>
  801157:	83 c4 10             	add    $0x10,%esp
			break;
  80115a:	e9 95 00 00 00       	jmp    8011f4 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80115f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801163:	7e 34                	jle    801199 <readline+0xa0>
  801165:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80116c:	7f 2b                	jg     801199 <readline+0xa0>
			if (echoing)
  80116e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801172:	74 0e                	je     801182 <readline+0x89>
				cputchar(c);
  801174:	83 ec 0c             	sub    $0xc,%esp
  801177:	ff 75 ec             	pushl  -0x14(%ebp)
  80117a:	e8 b6 f4 ff ff       	call   800635 <cputchar>
  80117f:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801185:	8d 50 01             	lea    0x1(%eax),%edx
  801188:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80118b:	89 c2                	mov    %eax,%edx
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	01 d0                	add    %edx,%eax
  801192:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801195:	88 10                	mov    %dl,(%eax)
  801197:	eb 56                	jmp    8011ef <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801199:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80119d:	75 1f                	jne    8011be <readline+0xc5>
  80119f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011a3:	7e 19                	jle    8011be <readline+0xc5>
			if (echoing)
  8011a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011a9:	74 0e                	je     8011b9 <readline+0xc0>
				cputchar(c);
  8011ab:	83 ec 0c             	sub    $0xc,%esp
  8011ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8011b1:	e8 7f f4 ff ff       	call   800635 <cputchar>
  8011b6:	83 c4 10             	add    $0x10,%esp

			i--;
  8011b9:	ff 4d f4             	decl   -0xc(%ebp)
  8011bc:	eb 31                	jmp    8011ef <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8011be:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011c2:	74 0a                	je     8011ce <readline+0xd5>
  8011c4:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011c8:	0f 85 61 ff ff ff    	jne    80112f <readline+0x36>
			if (echoing)
  8011ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011d2:	74 0e                	je     8011e2 <readline+0xe9>
				cputchar(c);
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	ff 75 ec             	pushl  -0x14(%ebp)
  8011da:	e8 56 f4 ff ff       	call   800635 <cputchar>
  8011df:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e8:	01 d0                	add    %edx,%eax
  8011ea:	c6 00 00             	movb   $0x0,(%eax)
			break;
  8011ed:	eb 06                	jmp    8011f5 <readline+0xfc>
		}
	}
  8011ef:	e9 3b ff ff ff       	jmp    80112f <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  8011f4:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  8011f5:	90                   	nop
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    

008011f8 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  8011fe:	e8 9b 09 00 00       	call   801b9e <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801203:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801207:	74 13                	je     80121c <atomic_readline+0x24>
			cprintf("%s", prompt);
  801209:	83 ec 08             	sub    $0x8,%esp
  80120c:	ff 75 08             	pushl  0x8(%ebp)
  80120f:	68 88 2b 80 00       	push   $0x802b88
  801214:	e8 4c f8 ff ff       	call   800a65 <cprintf>
  801219:	83 c4 10             	add    $0x10,%esp

		i = 0;
  80121c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801223:	83 ec 0c             	sub    $0xc,%esp
  801226:	6a 00                	push   $0x0
  801228:	e8 3a f4 ff ff       	call   800667 <iscons>
  80122d:	83 c4 10             	add    $0x10,%esp
  801230:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801233:	e8 1c f4 ff ff       	call   800654 <getchar>
  801238:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  80123b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80123f:	79 22                	jns    801263 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801241:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801245:	0f 84 ad 00 00 00    	je     8012f8 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  80124b:	83 ec 08             	sub    $0x8,%esp
  80124e:	ff 75 ec             	pushl  -0x14(%ebp)
  801251:	68 8b 2b 80 00       	push   $0x802b8b
  801256:	e8 0a f8 ff ff       	call   800a65 <cprintf>
  80125b:	83 c4 10             	add    $0x10,%esp
				break;
  80125e:	e9 95 00 00 00       	jmp    8012f8 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801263:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801267:	7e 34                	jle    80129d <atomic_readline+0xa5>
  801269:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801270:	7f 2b                	jg     80129d <atomic_readline+0xa5>
				if (echoing)
  801272:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801276:	74 0e                	je     801286 <atomic_readline+0x8e>
					cputchar(c);
  801278:	83 ec 0c             	sub    $0xc,%esp
  80127b:	ff 75 ec             	pushl  -0x14(%ebp)
  80127e:	e8 b2 f3 ff ff       	call   800635 <cputchar>
  801283:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801289:	8d 50 01             	lea    0x1(%eax),%edx
  80128c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80128f:	89 c2                	mov    %eax,%edx
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	01 d0                	add    %edx,%eax
  801296:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801299:	88 10                	mov    %dl,(%eax)
  80129b:	eb 56                	jmp    8012f3 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  80129d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012a1:	75 1f                	jne    8012c2 <atomic_readline+0xca>
  8012a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012a7:	7e 19                	jle    8012c2 <atomic_readline+0xca>
				if (echoing)
  8012a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ad:	74 0e                	je     8012bd <atomic_readline+0xc5>
					cputchar(c);
  8012af:	83 ec 0c             	sub    $0xc,%esp
  8012b2:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b5:	e8 7b f3 ff ff       	call   800635 <cputchar>
  8012ba:	83 c4 10             	add    $0x10,%esp
				i--;
  8012bd:	ff 4d f4             	decl   -0xc(%ebp)
  8012c0:	eb 31                	jmp    8012f3 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8012c2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012c6:	74 0a                	je     8012d2 <atomic_readline+0xda>
  8012c8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012cc:	0f 85 61 ff ff ff    	jne    801233 <atomic_readline+0x3b>
				if (echoing)
  8012d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012d6:	74 0e                	je     8012e6 <atomic_readline+0xee>
					cputchar(c);
  8012d8:	83 ec 0c             	sub    $0xc,%esp
  8012db:	ff 75 ec             	pushl  -0x14(%ebp)
  8012de:	e8 52 f3 ff ff       	call   800635 <cputchar>
  8012e3:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8012e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	c6 00 00             	movb   $0x0,(%eax)
				break;
  8012f1:	eb 06                	jmp    8012f9 <atomic_readline+0x101>
			}
		}
  8012f3:	e9 3b ff ff ff       	jmp    801233 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  8012f8:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  8012f9:	e8 ba 08 00 00       	call   801bb8 <sys_unlock_cons>
}
  8012fe:	90                   	nop
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801307:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80130e:	eb 06                	jmp    801316 <strlen+0x15>
		n++;
  801310:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801313:	ff 45 08             	incl   0x8(%ebp)
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	84 c0                	test   %al,%al
  80131d:	75 f1                	jne    801310 <strlen+0xf>
		n++;
	return n;
  80131f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80132a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801331:	eb 09                	jmp    80133c <strnlen+0x18>
		n++;
  801333:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	ff 4d 0c             	decl   0xc(%ebp)
  80133c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801340:	74 09                	je     80134b <strnlen+0x27>
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	8a 00                	mov    (%eax),%al
  801347:	84 c0                	test   %al,%al
  801349:	75 e8                	jne    801333 <strnlen+0xf>
		n++;
	return n;
  80134b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80135c:	90                   	nop
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	8d 50 01             	lea    0x1(%eax),%edx
  801363:	89 55 08             	mov    %edx,0x8(%ebp)
  801366:	8b 55 0c             	mov    0xc(%ebp),%edx
  801369:	8d 4a 01             	lea    0x1(%edx),%ecx
  80136c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80136f:	8a 12                	mov    (%edx),%dl
  801371:	88 10                	mov    %dl,(%eax)
  801373:	8a 00                	mov    (%eax),%al
  801375:	84 c0                	test   %al,%al
  801377:	75 e4                	jne    80135d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801379:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80138a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801391:	eb 1f                	jmp    8013b2 <strncpy+0x34>
		*dst++ = *src;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	8d 50 01             	lea    0x1(%eax),%edx
  801399:	89 55 08             	mov    %edx,0x8(%ebp)
  80139c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139f:	8a 12                	mov    (%edx),%dl
  8013a1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a6:	8a 00                	mov    (%eax),%al
  8013a8:	84 c0                	test   %al,%al
  8013aa:	74 03                	je     8013af <strncpy+0x31>
			src++;
  8013ac:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013af:	ff 45 fc             	incl   -0x4(%ebp)
  8013b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013b8:	72 d9                	jb     801393 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013cf:	74 30                	je     801401 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013d1:	eb 16                	jmp    8013e9 <strlcpy+0x2a>
			*dst++ = *src++;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8d 50 01             	lea    0x1(%eax),%edx
  8013d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8013dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013df:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013e2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013e5:	8a 12                	mov    (%edx),%dl
  8013e7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013e9:	ff 4d 10             	decl   0x10(%ebp)
  8013ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f0:	74 09                	je     8013fb <strlcpy+0x3c>
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	84 c0                	test   %al,%al
  8013f9:	75 d8                	jne    8013d3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801401:	8b 55 08             	mov    0x8(%ebp),%edx
  801404:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801407:	29 c2                	sub    %eax,%edx
  801409:	89 d0                	mov    %edx,%eax
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801410:	eb 06                	jmp    801418 <strcmp+0xb>
		p++, q++;
  801412:	ff 45 08             	incl   0x8(%ebp)
  801415:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8a 00                	mov    (%eax),%al
  80141d:	84 c0                	test   %al,%al
  80141f:	74 0e                	je     80142f <strcmp+0x22>
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	8a 10                	mov    (%eax),%dl
  801426:	8b 45 0c             	mov    0xc(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	38 c2                	cmp    %al,%dl
  80142d:	74 e3                	je     801412 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	0f b6 d0             	movzbl %al,%edx
  801437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143a:	8a 00                	mov    (%eax),%al
  80143c:	0f b6 c0             	movzbl %al,%eax
  80143f:	29 c2                	sub    %eax,%edx
  801441:	89 d0                	mov    %edx,%eax
}
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    

00801445 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801448:	eb 09                	jmp    801453 <strncmp+0xe>
		n--, p++, q++;
  80144a:	ff 4d 10             	decl   0x10(%ebp)
  80144d:	ff 45 08             	incl   0x8(%ebp)
  801450:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801453:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801457:	74 17                	je     801470 <strncmp+0x2b>
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
  80145c:	8a 00                	mov    (%eax),%al
  80145e:	84 c0                	test   %al,%al
  801460:	74 0e                	je     801470 <strncmp+0x2b>
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	8a 10                	mov    (%eax),%dl
  801467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	38 c2                	cmp    %al,%dl
  80146e:	74 da                	je     80144a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801470:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801474:	75 07                	jne    80147d <strncmp+0x38>
		return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	eb 14                	jmp    801491 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	0f b6 d0             	movzbl %al,%edx
  801485:	8b 45 0c             	mov    0xc(%ebp),%eax
  801488:	8a 00                	mov    (%eax),%al
  80148a:	0f b6 c0             	movzbl %al,%eax
  80148d:	29 c2                	sub    %eax,%edx
  80148f:	89 d0                	mov    %edx,%eax
}
  801491:	5d                   	pop    %ebp
  801492:	c3                   	ret    

00801493 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	83 ec 04             	sub    $0x4,%esp
  801499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80149f:	eb 12                	jmp    8014b3 <strchr+0x20>
		if (*s == c)
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a9:	75 05                	jne    8014b0 <strchr+0x1d>
			return (char *) s;
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	eb 11                	jmp    8014c1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014b0:	ff 45 08             	incl   0x8(%ebp)
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	8a 00                	mov    (%eax),%al
  8014b8:	84 c0                	test   %al,%al
  8014ba:	75 e5                	jne    8014a1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014cf:	eb 0d                	jmp    8014de <strfind+0x1b>
		if (*s == c)
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014d9:	74 0e                	je     8014e9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014db:	ff 45 08             	incl   0x8(%ebp)
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	84 c0                	test   %al,%al
  8014e5:	75 ea                	jne    8014d1 <strfind+0xe>
  8014e7:	eb 01                	jmp    8014ea <strfind+0x27>
		if (*s == c)
			break;
  8014e9:	90                   	nop
	return (char *) s;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801501:	eb 0e                	jmp    801511 <memset+0x22>
		*p++ = c;
  801503:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801506:	8d 50 01             	lea    0x1(%eax),%edx
  801509:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80150c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801511:	ff 4d f8             	decl   -0x8(%ebp)
  801514:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801518:	79 e9                	jns    801503 <memset+0x14>
		*p++ = c;

	return v;
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801531:	eb 16                	jmp    801549 <memcpy+0x2a>
		*d++ = *s++;
  801533:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801536:	8d 50 01             	lea    0x1(%eax),%edx
  801539:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80153c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80153f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801542:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801545:	8a 12                	mov    (%edx),%dl
  801547:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801549:	8b 45 10             	mov    0x10(%ebp),%eax
  80154c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154f:	89 55 10             	mov    %edx,0x10(%ebp)
  801552:	85 c0                	test   %eax,%eax
  801554:	75 dd                	jne    801533 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80156d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801570:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801573:	73 50                	jae    8015c5 <memmove+0x6a>
  801575:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801578:	8b 45 10             	mov    0x10(%ebp),%eax
  80157b:	01 d0                	add    %edx,%eax
  80157d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801580:	76 43                	jbe    8015c5 <memmove+0x6a>
		s += n;
  801582:	8b 45 10             	mov    0x10(%ebp),%eax
  801585:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801588:	8b 45 10             	mov    0x10(%ebp),%eax
  80158b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80158e:	eb 10                	jmp    8015a0 <memmove+0x45>
			*--d = *--s;
  801590:	ff 4d f8             	decl   -0x8(%ebp)
  801593:	ff 4d fc             	decl   -0x4(%ebp)
  801596:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801599:	8a 10                	mov    (%eax),%dl
  80159b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	75 e3                	jne    801590 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015ad:	eb 23                	jmp    8015d2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8015af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b2:	8d 50 01             	lea    0x1(%eax),%edx
  8015b5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015bb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015be:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015c1:	8a 12                	mov    (%edx),%dl
  8015c3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8015c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	75 dd                	jne    8015af <memmove+0x54>
			*d++ = *s++;

	return dst;
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015e9:	eb 2a                	jmp    801615 <memcmp+0x3e>
		if (*s1 != *s2)
  8015eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ee:	8a 10                	mov    (%eax),%dl
  8015f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	38 c2                	cmp    %al,%dl
  8015f7:	74 16                	je     80160f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015fc:	8a 00                	mov    (%eax),%al
  8015fe:	0f b6 d0             	movzbl %al,%edx
  801601:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801604:	8a 00                	mov    (%eax),%al
  801606:	0f b6 c0             	movzbl %al,%eax
  801609:	29 c2                	sub    %eax,%edx
  80160b:	89 d0                	mov    %edx,%eax
  80160d:	eb 18                	jmp    801627 <memcmp+0x50>
		s1++, s2++;
  80160f:	ff 45 fc             	incl   -0x4(%ebp)
  801612:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801615:	8b 45 10             	mov    0x10(%ebp),%eax
  801618:	8d 50 ff             	lea    -0x1(%eax),%edx
  80161b:	89 55 10             	mov    %edx,0x10(%ebp)
  80161e:	85 c0                	test   %eax,%eax
  801620:	75 c9                	jne    8015eb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801622:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80162f:	8b 55 08             	mov    0x8(%ebp),%edx
  801632:	8b 45 10             	mov    0x10(%ebp),%eax
  801635:	01 d0                	add    %edx,%eax
  801637:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80163a:	eb 15                	jmp    801651 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8a 00                	mov    (%eax),%al
  801641:	0f b6 d0             	movzbl %al,%edx
  801644:	8b 45 0c             	mov    0xc(%ebp),%eax
  801647:	0f b6 c0             	movzbl %al,%eax
  80164a:	39 c2                	cmp    %eax,%edx
  80164c:	74 0d                	je     80165b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80164e:	ff 45 08             	incl   0x8(%ebp)
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801657:	72 e3                	jb     80163c <memfind+0x13>
  801659:	eb 01                	jmp    80165c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80165b:	90                   	nop
	return (void *) s;
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801667:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80166e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801675:	eb 03                	jmp    80167a <strtol+0x19>
		s++;
  801677:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	8a 00                	mov    (%eax),%al
  80167f:	3c 20                	cmp    $0x20,%al
  801681:	74 f4                	je     801677 <strtol+0x16>
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	8a 00                	mov    (%eax),%al
  801688:	3c 09                	cmp    $0x9,%al
  80168a:	74 eb                	je     801677 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	8a 00                	mov    (%eax),%al
  801691:	3c 2b                	cmp    $0x2b,%al
  801693:	75 05                	jne    80169a <strtol+0x39>
		s++;
  801695:	ff 45 08             	incl   0x8(%ebp)
  801698:	eb 13                	jmp    8016ad <strtol+0x4c>
	else if (*s == '-')
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	3c 2d                	cmp    $0x2d,%al
  8016a1:	75 0a                	jne    8016ad <strtol+0x4c>
		s++, neg = 1;
  8016a3:	ff 45 08             	incl   0x8(%ebp)
  8016a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b1:	74 06                	je     8016b9 <strtol+0x58>
  8016b3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8016b7:	75 20                	jne    8016d9 <strtol+0x78>
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	3c 30                	cmp    $0x30,%al
  8016c0:	75 17                	jne    8016d9 <strtol+0x78>
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	40                   	inc    %eax
  8016c6:	8a 00                	mov    (%eax),%al
  8016c8:	3c 78                	cmp    $0x78,%al
  8016ca:	75 0d                	jne    8016d9 <strtol+0x78>
		s += 2, base = 16;
  8016cc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8016d0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016d7:	eb 28                	jmp    801701 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016dd:	75 15                	jne    8016f4 <strtol+0x93>
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	3c 30                	cmp    $0x30,%al
  8016e6:	75 0c                	jne    8016f4 <strtol+0x93>
		s++, base = 8;
  8016e8:	ff 45 08             	incl   0x8(%ebp)
  8016eb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016f2:	eb 0d                	jmp    801701 <strtol+0xa0>
	else if (base == 0)
  8016f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016f8:	75 07                	jne    801701 <strtol+0xa0>
		base = 10;
  8016fa:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	3c 2f                	cmp    $0x2f,%al
  801708:	7e 19                	jle    801723 <strtol+0xc2>
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	8a 00                	mov    (%eax),%al
  80170f:	3c 39                	cmp    $0x39,%al
  801711:	7f 10                	jg     801723 <strtol+0xc2>
			dig = *s - '0';
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	0f be c0             	movsbl %al,%eax
  80171b:	83 e8 30             	sub    $0x30,%eax
  80171e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801721:	eb 42                	jmp    801765 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	3c 60                	cmp    $0x60,%al
  80172a:	7e 19                	jle    801745 <strtol+0xe4>
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	3c 7a                	cmp    $0x7a,%al
  801733:	7f 10                	jg     801745 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	8a 00                	mov    (%eax),%al
  80173a:	0f be c0             	movsbl %al,%eax
  80173d:	83 e8 57             	sub    $0x57,%eax
  801740:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801743:	eb 20                	jmp    801765 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	8a 00                	mov    (%eax),%al
  80174a:	3c 40                	cmp    $0x40,%al
  80174c:	7e 39                	jle    801787 <strtol+0x126>
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	3c 5a                	cmp    $0x5a,%al
  801755:	7f 30                	jg     801787 <strtol+0x126>
			dig = *s - 'A' + 10;
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	0f be c0             	movsbl %al,%eax
  80175f:	83 e8 37             	sub    $0x37,%eax
  801762:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801768:	3b 45 10             	cmp    0x10(%ebp),%eax
  80176b:	7d 19                	jge    801786 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80176d:	ff 45 08             	incl   0x8(%ebp)
  801770:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801773:	0f af 45 10          	imul   0x10(%ebp),%eax
  801777:	89 c2                	mov    %eax,%edx
  801779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177c:	01 d0                	add    %edx,%eax
  80177e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801781:	e9 7b ff ff ff       	jmp    801701 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801786:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801787:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178b:	74 08                	je     801795 <strtol+0x134>
		*endptr = (char *) s;
  80178d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801790:	8b 55 08             	mov    0x8(%ebp),%edx
  801793:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801795:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801799:	74 07                	je     8017a2 <strtol+0x141>
  80179b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80179e:	f7 d8                	neg    %eax
  8017a0:	eb 03                	jmp    8017a5 <strtol+0x144>
  8017a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <ltostr>:

void
ltostr(long value, char *str)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8017ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8017b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8017bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017bf:	79 13                	jns    8017d4 <ltostr+0x2d>
	{
		neg = 1;
  8017c1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8017c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8017ce:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8017d1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017dc:	99                   	cltd   
  8017dd:	f7 f9                	idiv   %ecx
  8017df:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e5:	8d 50 01             	lea    0x1(%eax),%edx
  8017e8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017eb:	89 c2                	mov    %eax,%edx
  8017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f0:	01 d0                	add    %edx,%eax
  8017f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017f5:	83 c2 30             	add    $0x30,%edx
  8017f8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017fd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801802:	f7 e9                	imul   %ecx
  801804:	c1 fa 02             	sar    $0x2,%edx
  801807:	89 c8                	mov    %ecx,%eax
  801809:	c1 f8 1f             	sar    $0x1f,%eax
  80180c:	29 c2                	sub    %eax,%edx
  80180e:	89 d0                	mov    %edx,%eax
  801810:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801813:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801817:	75 bb                	jne    8017d4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801819:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801820:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801823:	48                   	dec    %eax
  801824:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801827:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80182b:	74 3d                	je     80186a <ltostr+0xc3>
		start = 1 ;
  80182d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801834:	eb 34                	jmp    80186a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801836:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183c:	01 d0                	add    %edx,%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801843:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801846:	8b 45 0c             	mov    0xc(%ebp),%eax
  801849:	01 c2                	add    %eax,%edx
  80184b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80184e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801851:	01 c8                	add    %ecx,%eax
  801853:	8a 00                	mov    (%eax),%al
  801855:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801857:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80185a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185d:	01 c2                	add    %eax,%edx
  80185f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801862:	88 02                	mov    %al,(%edx)
		start++ ;
  801864:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801867:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80186a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801870:	7c c4                	jl     801836 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801872:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801875:	8b 45 0c             	mov    0xc(%ebp),%eax
  801878:	01 d0                	add    %edx,%eax
  80187a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80187d:	90                   	nop
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801886:	ff 75 08             	pushl  0x8(%ebp)
  801889:	e8 73 fa ff ff       	call   801301 <strlen>
  80188e:	83 c4 04             	add    $0x4,%esp
  801891:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	e8 65 fa ff ff       	call   801301 <strlen>
  80189c:	83 c4 04             	add    $0x4,%esp
  80189f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8018a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8018a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018b0:	eb 17                	jmp    8018c9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8018b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b8:	01 c2                	add    %eax,%edx
  8018ba:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	01 c8                	add    %ecx,%eax
  8018c2:	8a 00                	mov    (%eax),%al
  8018c4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018c6:	ff 45 fc             	incl   -0x4(%ebp)
  8018c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018cf:	7c e1                	jl     8018b2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018df:	eb 1f                	jmp    801900 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e4:	8d 50 01             	lea    0x1(%eax),%edx
  8018e7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018ea:	89 c2                	mov    %eax,%edx
  8018ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ef:	01 c2                	add    %eax,%edx
  8018f1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f7:	01 c8                	add    %ecx,%eax
  8018f9:	8a 00                	mov    (%eax),%al
  8018fb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018fd:	ff 45 f8             	incl   -0x8(%ebp)
  801900:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801903:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801906:	7c d9                	jl     8018e1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801908:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80190b:	8b 45 10             	mov    0x10(%ebp),%eax
  80190e:	01 d0                	add    %edx,%eax
  801910:	c6 00 00             	movb   $0x0,(%eax)
}
  801913:	90                   	nop
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801919:	8b 45 14             	mov    0x14(%ebp),%eax
  80191c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801922:	8b 45 14             	mov    0x14(%ebp),%eax
  801925:	8b 00                	mov    (%eax),%eax
  801927:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80192e:	8b 45 10             	mov    0x10(%ebp),%eax
  801931:	01 d0                	add    %edx,%eax
  801933:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801939:	eb 0c                	jmp    801947 <strsplit+0x31>
			*string++ = 0;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8d 50 01             	lea    0x1(%eax),%edx
  801941:	89 55 08             	mov    %edx,0x8(%ebp)
  801944:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	8a 00                	mov    (%eax),%al
  80194c:	84 c0                	test   %al,%al
  80194e:	74 18                	je     801968 <strsplit+0x52>
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	8a 00                	mov    (%eax),%al
  801955:	0f be c0             	movsbl %al,%eax
  801958:	50                   	push   %eax
  801959:	ff 75 0c             	pushl  0xc(%ebp)
  80195c:	e8 32 fb ff ff       	call   801493 <strchr>
  801961:	83 c4 08             	add    $0x8,%esp
  801964:	85 c0                	test   %eax,%eax
  801966:	75 d3                	jne    80193b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	8a 00                	mov    (%eax),%al
  80196d:	84 c0                	test   %al,%al
  80196f:	74 5a                	je     8019cb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801971:	8b 45 14             	mov    0x14(%ebp),%eax
  801974:	8b 00                	mov    (%eax),%eax
  801976:	83 f8 0f             	cmp    $0xf,%eax
  801979:	75 07                	jne    801982 <strsplit+0x6c>
		{
			return 0;
  80197b:	b8 00 00 00 00       	mov    $0x0,%eax
  801980:	eb 66                	jmp    8019e8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801982:	8b 45 14             	mov    0x14(%ebp),%eax
  801985:	8b 00                	mov    (%eax),%eax
  801987:	8d 48 01             	lea    0x1(%eax),%ecx
  80198a:	8b 55 14             	mov    0x14(%ebp),%edx
  80198d:	89 0a                	mov    %ecx,(%edx)
  80198f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801996:	8b 45 10             	mov    0x10(%ebp),%eax
  801999:	01 c2                	add    %eax,%edx
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019a0:	eb 03                	jmp    8019a5 <strsplit+0x8f>
			string++;
  8019a2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8a 00                	mov    (%eax),%al
  8019aa:	84 c0                	test   %al,%al
  8019ac:	74 8b                	je     801939 <strsplit+0x23>
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8a 00                	mov    (%eax),%al
  8019b3:	0f be c0             	movsbl %al,%eax
  8019b6:	50                   	push   %eax
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	e8 d4 fa ff ff       	call   801493 <strchr>
  8019bf:	83 c4 08             	add    $0x8,%esp
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	74 dc                	je     8019a2 <strsplit+0x8c>
			string++;
	}
  8019c6:	e9 6e ff ff ff       	jmp    801939 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019cb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cf:	8b 00                	mov    (%eax),%eax
  8019d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019db:	01 d0                	add    %edx,%eax
  8019dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8019f0:	83 ec 04             	sub    $0x4,%esp
  8019f3:	68 9c 2b 80 00       	push   $0x802b9c
  8019f8:	68 3f 01 00 00       	push   $0x13f
  8019fd:	68 be 2b 80 00       	push   $0x802bbe
  801a02:	e8 a1 ed ff ff       	call   8007a8 <_panic>

00801a07 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801a0d:	83 ec 0c             	sub    $0xc,%esp
  801a10:	ff 75 08             	pushl  0x8(%ebp)
  801a13:	e8 ef 06 00 00       	call   802107 <sys_sbrk>
  801a18:	83 c4 10             	add    $0x10,%esp
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801a23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a27:	75 07                	jne    801a30 <malloc+0x13>
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2e:	eb 14                	jmp    801a44 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801a30:	83 ec 04             	sub    $0x4,%esp
  801a33:	68 cc 2b 80 00       	push   $0x802bcc
  801a38:	6a 1b                	push   $0x1b
  801a3a:	68 f1 2b 80 00       	push   $0x802bf1
  801a3f:	e8 64 ed ff ff       	call   8007a8 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801a4c:	83 ec 04             	sub    $0x4,%esp
  801a4f:	68 00 2c 80 00       	push   $0x802c00
  801a54:	6a 29                	push   $0x29
  801a56:	68 f1 2b 80 00       	push   $0x802bf1
  801a5b:	e8 48 ed ff ff       	call   8007a8 <_panic>

00801a60 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 18             	sub    $0x18,%esp
  801a66:	8b 45 10             	mov    0x10(%ebp),%eax
  801a69:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801a6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a70:	75 07                	jne    801a79 <smalloc+0x19>
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
  801a77:	eb 14                	jmp    801a8d <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801a79:	83 ec 04             	sub    $0x4,%esp
  801a7c:	68 24 2c 80 00       	push   $0x802c24
  801a81:	6a 38                	push   $0x38
  801a83:	68 f1 2b 80 00       	push   $0x802bf1
  801a88:	e8 1b ed ff ff       	call   8007a8 <_panic>
	return NULL;
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a95:	83 ec 04             	sub    $0x4,%esp
  801a98:	68 4c 2c 80 00       	push   $0x802c4c
  801a9d:	6a 43                	push   $0x43
  801a9f:	68 f1 2b 80 00       	push   $0x802bf1
  801aa4:	e8 ff ec ff ff       	call   8007a8 <_panic>

00801aa9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	68 70 2c 80 00       	push   $0x802c70
  801ab7:	6a 5b                	push   $0x5b
  801ab9:	68 f1 2b 80 00       	push   $0x802bf1
  801abe:	e8 e5 ec ff ff       	call   8007a8 <_panic>

00801ac3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ac9:	83 ec 04             	sub    $0x4,%esp
  801acc:	68 94 2c 80 00       	push   $0x802c94
  801ad1:	6a 72                	push   $0x72
  801ad3:	68 f1 2b 80 00       	push   $0x802bf1
  801ad8:	e8 cb ec ff ff       	call   8007a8 <_panic>

00801add <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ae3:	83 ec 04             	sub    $0x4,%esp
  801ae6:	68 ba 2c 80 00       	push   $0x802cba
  801aeb:	6a 7e                	push   $0x7e
  801aed:	68 f1 2b 80 00       	push   $0x802bf1
  801af2:	e8 b1 ec ff ff       	call   8007a8 <_panic>

00801af7 <shrink>:

}
void shrink(uint32 newSize)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801afd:	83 ec 04             	sub    $0x4,%esp
  801b00:	68 ba 2c 80 00       	push   $0x802cba
  801b05:	68 83 00 00 00       	push   $0x83
  801b0a:	68 f1 2b 80 00       	push   $0x802bf1
  801b0f:	e8 94 ec ff ff       	call   8007a8 <_panic>

00801b14 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b1a:	83 ec 04             	sub    $0x4,%esp
  801b1d:	68 ba 2c 80 00       	push   $0x802cba
  801b22:	68 88 00 00 00       	push   $0x88
  801b27:	68 f1 2b 80 00       	push   $0x802bf1
  801b2c:	e8 77 ec ff ff       	call   8007a8 <_panic>

00801b31 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	57                   	push   %edi
  801b35:	56                   	push   %esi
  801b36:	53                   	push   %ebx
  801b37:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b46:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b49:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b4c:	cd 30                	int    $0x30
  801b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b54:	83 c4 10             	add    $0x10,%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5f                   	pop    %edi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    

00801b5c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	83 ec 04             	sub    $0x4,%esp
  801b62:	8b 45 10             	mov    0x10(%ebp),%eax
  801b65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b68:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	52                   	push   %edx
  801b74:	ff 75 0c             	pushl  0xc(%ebp)
  801b77:	50                   	push   %eax
  801b78:	6a 00                	push   $0x0
  801b7a:	e8 b2 ff ff ff       	call   801b31 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	90                   	nop
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 02                	push   $0x2
  801b94:	e8 98 ff ff ff       	call   801b31 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_lock_cons>:

void sys_lock_cons(void)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 03                	push   $0x3
  801bad:	e8 7f ff ff ff       	call   801b31 <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	90                   	nop
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 04                	push   $0x4
  801bc7:	e8 65 ff ff ff       	call   801b31 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	90                   	nop
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	52                   	push   %edx
  801be2:	50                   	push   %eax
  801be3:	6a 08                	push   $0x8
  801be5:	e8 47 ff ff ff       	call   801b31 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	56                   	push   %esi
  801bf3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bf4:	8b 75 18             	mov    0x18(%ebp),%esi
  801bf7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	56                   	push   %esi
  801c04:	53                   	push   %ebx
  801c05:	51                   	push   %ecx
  801c06:	52                   	push   %edx
  801c07:	50                   	push   %eax
  801c08:	6a 09                	push   $0x9
  801c0a:	e8 22 ff ff ff       	call   801b31 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c15:	5b                   	pop    %ebx
  801c16:	5e                   	pop    %esi
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    

00801c19 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	52                   	push   %edx
  801c29:	50                   	push   %eax
  801c2a:	6a 0a                	push   $0xa
  801c2c:	e8 00 ff ff ff       	call   801b31 <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	ff 75 0c             	pushl  0xc(%ebp)
  801c42:	ff 75 08             	pushl  0x8(%ebp)
  801c45:	6a 0b                	push   $0xb
  801c47:	e8 e5 fe ff ff       	call   801b31 <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 0c                	push   $0xc
  801c60:	e8 cc fe ff ff       	call   801b31 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 0d                	push   $0xd
  801c79:	e8 b3 fe ff ff       	call   801b31 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 0e                	push   $0xe
  801c92:	e8 9a fe ff ff       	call   801b31 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 0f                	push   $0xf
  801cab:	e8 81 fe ff ff       	call   801b31 <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	ff 75 08             	pushl  0x8(%ebp)
  801cc3:	6a 10                	push   $0x10
  801cc5:	e8 67 fe ff ff       	call   801b31 <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 11                	push   $0x11
  801cde:	e8 4e fe ff ff       	call   801b31 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	90                   	nop
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_cputc>:

void
sys_cputc(const char c)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cf5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	50                   	push   %eax
  801d02:	6a 01                	push   $0x1
  801d04:	e8 28 fe ff ff       	call   801b31 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	90                   	nop
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 14                	push   $0x14
  801d1e:	e8 0e fe ff ff       	call   801b31 <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	90                   	nop
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 04             	sub    $0x4,%esp
  801d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d32:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d35:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d38:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	6a 00                	push   $0x0
  801d41:	51                   	push   %ecx
  801d42:	52                   	push   %edx
  801d43:	ff 75 0c             	pushl  0xc(%ebp)
  801d46:	50                   	push   %eax
  801d47:	6a 15                	push   $0x15
  801d49:	e8 e3 fd ff ff       	call   801b31 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	52                   	push   %edx
  801d63:	50                   	push   %eax
  801d64:	6a 16                	push   $0x16
  801d66:	e8 c6 fd ff ff       	call   801b31 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	51                   	push   %ecx
  801d81:	52                   	push   %edx
  801d82:	50                   	push   %eax
  801d83:	6a 17                	push   $0x17
  801d85:	e8 a7 fd ff ff       	call   801b31 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	52                   	push   %edx
  801d9f:	50                   	push   %eax
  801da0:	6a 18                	push   $0x18
  801da2:	e8 8a fd ff ff       	call   801b31 <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	6a 00                	push   $0x0
  801db4:	ff 75 14             	pushl  0x14(%ebp)
  801db7:	ff 75 10             	pushl  0x10(%ebp)
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	50                   	push   %eax
  801dbe:	6a 19                	push   $0x19
  801dc0:	e8 6c fd ff ff       	call   801b31 <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_run_env>:

void sys_run_env(int32 envId)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	50                   	push   %eax
  801dd9:	6a 1a                	push   $0x1a
  801ddb:	e8 51 fd ff ff       	call   801b31 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	90                   	nop
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	50                   	push   %eax
  801df5:	6a 1b                	push   $0x1b
  801df7:	e8 35 fd ff ff       	call   801b31 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 05                	push   $0x5
  801e10:	e8 1c fd ff ff       	call   801b31 <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 06                	push   $0x6
  801e29:	e8 03 fd ff ff       	call   801b31 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 07                	push   $0x7
  801e42:	e8 ea fc ff ff       	call   801b31 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sys_exit_env>:


void sys_exit_env(void)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 1c                	push   $0x1c
  801e5b:	e8 d1 fc ff ff       	call   801b31 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
}
  801e63:	90                   	nop
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e6c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e6f:	8d 50 04             	lea    0x4(%eax),%edx
  801e72:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	52                   	push   %edx
  801e7c:	50                   	push   %eax
  801e7d:	6a 1d                	push   $0x1d
  801e7f:	e8 ad fc ff ff       	call   801b31 <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
	return result;
  801e87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e90:	89 01                	mov    %eax,(%ecx)
  801e92:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	c9                   	leave  
  801e99:	c2 04 00             	ret    $0x4

00801e9c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	ff 75 10             	pushl  0x10(%ebp)
  801ea6:	ff 75 0c             	pushl  0xc(%ebp)
  801ea9:	ff 75 08             	pushl  0x8(%ebp)
  801eac:	6a 13                	push   $0x13
  801eae:	e8 7e fc ff ff       	call   801b31 <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb6:	90                   	nop
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 1e                	push   $0x1e
  801ec8:	e8 64 fc ff ff       	call   801b31 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 04             	sub    $0x4,%esp
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ede:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	50                   	push   %eax
  801eeb:	6a 1f                	push   $0x1f
  801eed:	e8 3f fc ff ff       	call   801b31 <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef5:	90                   	nop
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <rsttst>:
void rsttst()
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 21                	push   $0x21
  801f07:	e8 25 fc ff ff       	call   801b31 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0f:	90                   	nop
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	8b 45 14             	mov    0x14(%ebp),%eax
  801f1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f1e:	8b 55 18             	mov    0x18(%ebp),%edx
  801f21:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f25:	52                   	push   %edx
  801f26:	50                   	push   %eax
  801f27:	ff 75 10             	pushl  0x10(%ebp)
  801f2a:	ff 75 0c             	pushl  0xc(%ebp)
  801f2d:	ff 75 08             	pushl  0x8(%ebp)
  801f30:	6a 20                	push   $0x20
  801f32:	e8 fa fb ff ff       	call   801b31 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3a:	90                   	nop
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <chktst>:
void chktst(uint32 n)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	ff 75 08             	pushl  0x8(%ebp)
  801f4b:	6a 22                	push   $0x22
  801f4d:	e8 df fb ff ff       	call   801b31 <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
	return ;
  801f55:	90                   	nop
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <inctst>:

void inctst()
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 23                	push   $0x23
  801f67:	e8 c5 fb ff ff       	call   801b31 <syscall>
  801f6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f6f:	90                   	nop
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <gettst>:
uint32 gettst()
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 24                	push   $0x24
  801f81:	e8 ab fb ff ff       	call   801b31 <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 25                	push   $0x25
  801f9d:	e8 8f fb ff ff       	call   801b31 <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
  801fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fa8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fac:	75 07                	jne    801fb5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fae:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb3:	eb 05                	jmp    801fba <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 25                	push   $0x25
  801fce:	e8 5e fb ff ff       	call   801b31 <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
  801fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fd9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fdd:	75 07                	jne    801fe6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fdf:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe4:	eb 05                	jmp    801feb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 25                	push   $0x25
  801fff:	e8 2d fb ff ff       	call   801b31 <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
  802007:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80200a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80200e:	75 07                	jne    802017 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802010:	b8 01 00 00 00       	mov    $0x1,%eax
  802015:	eb 05                	jmp    80201c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 25                	push   $0x25
  802030:	e8 fc fa ff ff       	call   801b31 <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
  802038:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80203b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80203f:	75 07                	jne    802048 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802041:	b8 01 00 00 00       	mov    $0x1,%eax
  802046:	eb 05                	jmp    80204d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	ff 75 08             	pushl  0x8(%ebp)
  80205d:	6a 26                	push   $0x26
  80205f:	e8 cd fa ff ff       	call   801b31 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
	return ;
  802067:	90                   	nop
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80206e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802071:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802074:	8b 55 0c             	mov    0xc(%ebp),%edx
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	6a 00                	push   $0x0
  80207c:	53                   	push   %ebx
  80207d:	51                   	push   %ecx
  80207e:	52                   	push   %edx
  80207f:	50                   	push   %eax
  802080:	6a 27                	push   $0x27
  802082:	e8 aa fa ff ff       	call   801b31 <syscall>
  802087:	83 c4 18             	add    $0x18,%esp
}
  80208a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802092:	8b 55 0c             	mov    0xc(%ebp),%edx
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	52                   	push   %edx
  80209f:	50                   	push   %eax
  8020a0:	6a 28                	push   $0x28
  8020a2:	e8 8a fa ff ff       	call   801b31 <syscall>
  8020a7:	83 c4 18             	add    $0x18,%esp
}
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8020af:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	6a 00                	push   $0x0
  8020ba:	51                   	push   %ecx
  8020bb:	ff 75 10             	pushl  0x10(%ebp)
  8020be:	52                   	push   %edx
  8020bf:	50                   	push   %eax
  8020c0:	6a 29                	push   $0x29
  8020c2:	e8 6a fa ff ff       	call   801b31 <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	ff 75 10             	pushl  0x10(%ebp)
  8020d6:	ff 75 0c             	pushl  0xc(%ebp)
  8020d9:	ff 75 08             	pushl  0x8(%ebp)
  8020dc:	6a 12                	push   $0x12
  8020de:	e8 4e fa ff ff       	call   801b31 <syscall>
  8020e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e6:	90                   	nop
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8020ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	52                   	push   %edx
  8020f9:	50                   	push   %eax
  8020fa:	6a 2a                	push   $0x2a
  8020fc:	e8 30 fa ff ff       	call   801b31 <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
	return;
  802104:	90                   	nop
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	50                   	push   %eax
  802116:	6a 2b                	push   $0x2b
  802118:	e8 14 fa ff ff       	call   801b31 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	ff 75 0c             	pushl  0xc(%ebp)
  80212e:	ff 75 08             	pushl  0x8(%ebp)
  802131:	6a 2c                	push   $0x2c
  802133:	e8 f9 f9 ff ff       	call   801b31 <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
	return;
  80213b:	90                   	nop
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	ff 75 08             	pushl  0x8(%ebp)
  80214d:	6a 2d                	push   $0x2d
  80214f:	e8 dd f9 ff ff       	call   801b31 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
	return;
  802157:	90                   	nop
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	68 cc 2c 80 00       	push   $0x802ccc
  802168:	6a 09                	push   $0x9
  80216a:	68 f4 2c 80 00       	push   $0x802cf4
  80216f:	e8 34 e6 ff ff       	call   8007a8 <_panic>

00802174 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	68 04 2d 80 00       	push   $0x802d04
  802182:	6a 10                	push   $0x10
  802184:	68 f4 2c 80 00       	push   $0x802cf4
  802189:	e8 1a e6 ff ff       	call   8007a8 <_panic>

0080218e <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  802194:	83 ec 04             	sub    $0x4,%esp
  802197:	68 2c 2d 80 00       	push   $0x802d2c
  80219c:	6a 18                	push   $0x18
  80219e:	68 f4 2c 80 00       	push   $0x802cf4
  8021a3:	e8 00 e6 ff ff       	call   8007a8 <_panic>

008021a8 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	68 54 2d 80 00       	push   $0x802d54
  8021b6:	6a 20                	push   $0x20
  8021b8:	68 f4 2c 80 00       	push   $0x802cf4
  8021bd:	e8 e6 e5 ff ff       	call   8007a8 <_panic>

008021c2 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	8b 40 10             	mov    0x10(%eax),%eax
}
  8021cb:	5d                   	pop    %ebp
  8021cc:	c3                   	ret    
  8021cd:	66 90                	xchg   %ax,%ax
  8021cf:	90                   	nop

008021d0 <__udivdi3>:
  8021d0:	55                   	push   %ebp
  8021d1:	57                   	push   %edi
  8021d2:	56                   	push   %esi
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 1c             	sub    $0x1c,%esp
  8021d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e7:	89 ca                	mov    %ecx,%edx
  8021e9:	89 f8                	mov    %edi,%eax
  8021eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8021ef:	85 f6                	test   %esi,%esi
  8021f1:	75 2d                	jne    802220 <__udivdi3+0x50>
  8021f3:	39 cf                	cmp    %ecx,%edi
  8021f5:	77 65                	ja     80225c <__udivdi3+0x8c>
  8021f7:	89 fd                	mov    %edi,%ebp
  8021f9:	85 ff                	test   %edi,%edi
  8021fb:	75 0b                	jne    802208 <__udivdi3+0x38>
  8021fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802202:	31 d2                	xor    %edx,%edx
  802204:	f7 f7                	div    %edi
  802206:	89 c5                	mov    %eax,%ebp
  802208:	31 d2                	xor    %edx,%edx
  80220a:	89 c8                	mov    %ecx,%eax
  80220c:	f7 f5                	div    %ebp
  80220e:	89 c1                	mov    %eax,%ecx
  802210:	89 d8                	mov    %ebx,%eax
  802212:	f7 f5                	div    %ebp
  802214:	89 cf                	mov    %ecx,%edi
  802216:	89 fa                	mov    %edi,%edx
  802218:	83 c4 1c             	add    $0x1c,%esp
  80221b:	5b                   	pop    %ebx
  80221c:	5e                   	pop    %esi
  80221d:	5f                   	pop    %edi
  80221e:	5d                   	pop    %ebp
  80221f:	c3                   	ret    
  802220:	39 ce                	cmp    %ecx,%esi
  802222:	77 28                	ja     80224c <__udivdi3+0x7c>
  802224:	0f bd fe             	bsr    %esi,%edi
  802227:	83 f7 1f             	xor    $0x1f,%edi
  80222a:	75 40                	jne    80226c <__udivdi3+0x9c>
  80222c:	39 ce                	cmp    %ecx,%esi
  80222e:	72 0a                	jb     80223a <__udivdi3+0x6a>
  802230:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802234:	0f 87 9e 00 00 00    	ja     8022d8 <__udivdi3+0x108>
  80223a:	b8 01 00 00 00       	mov    $0x1,%eax
  80223f:	89 fa                	mov    %edi,%edx
  802241:	83 c4 1c             	add    $0x1c,%esp
  802244:	5b                   	pop    %ebx
  802245:	5e                   	pop    %esi
  802246:	5f                   	pop    %edi
  802247:	5d                   	pop    %ebp
  802248:	c3                   	ret    
  802249:	8d 76 00             	lea    0x0(%esi),%esi
  80224c:	31 ff                	xor    %edi,%edi
  80224e:	31 c0                	xor    %eax,%eax
  802250:	89 fa                	mov    %edi,%edx
  802252:	83 c4 1c             	add    $0x1c,%esp
  802255:	5b                   	pop    %ebx
  802256:	5e                   	pop    %esi
  802257:	5f                   	pop    %edi
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    
  80225a:	66 90                	xchg   %ax,%ax
  80225c:	89 d8                	mov    %ebx,%eax
  80225e:	f7 f7                	div    %edi
  802260:	31 ff                	xor    %edi,%edi
  802262:	89 fa                	mov    %edi,%edx
  802264:	83 c4 1c             	add    $0x1c,%esp
  802267:	5b                   	pop    %ebx
  802268:	5e                   	pop    %esi
  802269:	5f                   	pop    %edi
  80226a:	5d                   	pop    %ebp
  80226b:	c3                   	ret    
  80226c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802271:	89 eb                	mov    %ebp,%ebx
  802273:	29 fb                	sub    %edi,%ebx
  802275:	89 f9                	mov    %edi,%ecx
  802277:	d3 e6                	shl    %cl,%esi
  802279:	89 c5                	mov    %eax,%ebp
  80227b:	88 d9                	mov    %bl,%cl
  80227d:	d3 ed                	shr    %cl,%ebp
  80227f:	89 e9                	mov    %ebp,%ecx
  802281:	09 f1                	or     %esi,%ecx
  802283:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802287:	89 f9                	mov    %edi,%ecx
  802289:	d3 e0                	shl    %cl,%eax
  80228b:	89 c5                	mov    %eax,%ebp
  80228d:	89 d6                	mov    %edx,%esi
  80228f:	88 d9                	mov    %bl,%cl
  802291:	d3 ee                	shr    %cl,%esi
  802293:	89 f9                	mov    %edi,%ecx
  802295:	d3 e2                	shl    %cl,%edx
  802297:	8b 44 24 08          	mov    0x8(%esp),%eax
  80229b:	88 d9                	mov    %bl,%cl
  80229d:	d3 e8                	shr    %cl,%eax
  80229f:	09 c2                	or     %eax,%edx
  8022a1:	89 d0                	mov    %edx,%eax
  8022a3:	89 f2                	mov    %esi,%edx
  8022a5:	f7 74 24 0c          	divl   0xc(%esp)
  8022a9:	89 d6                	mov    %edx,%esi
  8022ab:	89 c3                	mov    %eax,%ebx
  8022ad:	f7 e5                	mul    %ebp
  8022af:	39 d6                	cmp    %edx,%esi
  8022b1:	72 19                	jb     8022cc <__udivdi3+0xfc>
  8022b3:	74 0b                	je     8022c0 <__udivdi3+0xf0>
  8022b5:	89 d8                	mov    %ebx,%eax
  8022b7:	31 ff                	xor    %edi,%edi
  8022b9:	e9 58 ff ff ff       	jmp    802216 <__udivdi3+0x46>
  8022be:	66 90                	xchg   %ax,%ax
  8022c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022c4:	89 f9                	mov    %edi,%ecx
  8022c6:	d3 e2                	shl    %cl,%edx
  8022c8:	39 c2                	cmp    %eax,%edx
  8022ca:	73 e9                	jae    8022b5 <__udivdi3+0xe5>
  8022cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022cf:	31 ff                	xor    %edi,%edi
  8022d1:	e9 40 ff ff ff       	jmp    802216 <__udivdi3+0x46>
  8022d6:	66 90                	xchg   %ax,%ax
  8022d8:	31 c0                	xor    %eax,%eax
  8022da:	e9 37 ff ff ff       	jmp    802216 <__udivdi3+0x46>
  8022df:	90                   	nop

008022e0 <__umoddi3>:
  8022e0:	55                   	push   %ebp
  8022e1:	57                   	push   %edi
  8022e2:	56                   	push   %esi
  8022e3:	53                   	push   %ebx
  8022e4:	83 ec 1c             	sub    $0x1c,%esp
  8022e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8022eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022ff:	89 f3                	mov    %esi,%ebx
  802301:	89 fa                	mov    %edi,%edx
  802303:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802307:	89 34 24             	mov    %esi,(%esp)
  80230a:	85 c0                	test   %eax,%eax
  80230c:	75 1a                	jne    802328 <__umoddi3+0x48>
  80230e:	39 f7                	cmp    %esi,%edi
  802310:	0f 86 a2 00 00 00    	jbe    8023b8 <__umoddi3+0xd8>
  802316:	89 c8                	mov    %ecx,%eax
  802318:	89 f2                	mov    %esi,%edx
  80231a:	f7 f7                	div    %edi
  80231c:	89 d0                	mov    %edx,%eax
  80231e:	31 d2                	xor    %edx,%edx
  802320:	83 c4 1c             	add    $0x1c,%esp
  802323:	5b                   	pop    %ebx
  802324:	5e                   	pop    %esi
  802325:	5f                   	pop    %edi
  802326:	5d                   	pop    %ebp
  802327:	c3                   	ret    
  802328:	39 f0                	cmp    %esi,%eax
  80232a:	0f 87 ac 00 00 00    	ja     8023dc <__umoddi3+0xfc>
  802330:	0f bd e8             	bsr    %eax,%ebp
  802333:	83 f5 1f             	xor    $0x1f,%ebp
  802336:	0f 84 ac 00 00 00    	je     8023e8 <__umoddi3+0x108>
  80233c:	bf 20 00 00 00       	mov    $0x20,%edi
  802341:	29 ef                	sub    %ebp,%edi
  802343:	89 fe                	mov    %edi,%esi
  802345:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802349:	89 e9                	mov    %ebp,%ecx
  80234b:	d3 e0                	shl    %cl,%eax
  80234d:	89 d7                	mov    %edx,%edi
  80234f:	89 f1                	mov    %esi,%ecx
  802351:	d3 ef                	shr    %cl,%edi
  802353:	09 c7                	or     %eax,%edi
  802355:	89 e9                	mov    %ebp,%ecx
  802357:	d3 e2                	shl    %cl,%edx
  802359:	89 14 24             	mov    %edx,(%esp)
  80235c:	89 d8                	mov    %ebx,%eax
  80235e:	d3 e0                	shl    %cl,%eax
  802360:	89 c2                	mov    %eax,%edx
  802362:	8b 44 24 08          	mov    0x8(%esp),%eax
  802366:	d3 e0                	shl    %cl,%eax
  802368:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802370:	89 f1                	mov    %esi,%ecx
  802372:	d3 e8                	shr    %cl,%eax
  802374:	09 d0                	or     %edx,%eax
  802376:	d3 eb                	shr    %cl,%ebx
  802378:	89 da                	mov    %ebx,%edx
  80237a:	f7 f7                	div    %edi
  80237c:	89 d3                	mov    %edx,%ebx
  80237e:	f7 24 24             	mull   (%esp)
  802381:	89 c6                	mov    %eax,%esi
  802383:	89 d1                	mov    %edx,%ecx
  802385:	39 d3                	cmp    %edx,%ebx
  802387:	0f 82 87 00 00 00    	jb     802414 <__umoddi3+0x134>
  80238d:	0f 84 91 00 00 00    	je     802424 <__umoddi3+0x144>
  802393:	8b 54 24 04          	mov    0x4(%esp),%edx
  802397:	29 f2                	sub    %esi,%edx
  802399:	19 cb                	sbb    %ecx,%ebx
  80239b:	89 d8                	mov    %ebx,%eax
  80239d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8023a1:	d3 e0                	shl    %cl,%eax
  8023a3:	89 e9                	mov    %ebp,%ecx
  8023a5:	d3 ea                	shr    %cl,%edx
  8023a7:	09 d0                	or     %edx,%eax
  8023a9:	89 e9                	mov    %ebp,%ecx
  8023ab:	d3 eb                	shr    %cl,%ebx
  8023ad:	89 da                	mov    %ebx,%edx
  8023af:	83 c4 1c             	add    $0x1c,%esp
  8023b2:	5b                   	pop    %ebx
  8023b3:	5e                   	pop    %esi
  8023b4:	5f                   	pop    %edi
  8023b5:	5d                   	pop    %ebp
  8023b6:	c3                   	ret    
  8023b7:	90                   	nop
  8023b8:	89 fd                	mov    %edi,%ebp
  8023ba:	85 ff                	test   %edi,%edi
  8023bc:	75 0b                	jne    8023c9 <__umoddi3+0xe9>
  8023be:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c3:	31 d2                	xor    %edx,%edx
  8023c5:	f7 f7                	div    %edi
  8023c7:	89 c5                	mov    %eax,%ebp
  8023c9:	89 f0                	mov    %esi,%eax
  8023cb:	31 d2                	xor    %edx,%edx
  8023cd:	f7 f5                	div    %ebp
  8023cf:	89 c8                	mov    %ecx,%eax
  8023d1:	f7 f5                	div    %ebp
  8023d3:	89 d0                	mov    %edx,%eax
  8023d5:	e9 44 ff ff ff       	jmp    80231e <__umoddi3+0x3e>
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	89 c8                	mov    %ecx,%eax
  8023de:	89 f2                	mov    %esi,%edx
  8023e0:	83 c4 1c             	add    $0x1c,%esp
  8023e3:	5b                   	pop    %ebx
  8023e4:	5e                   	pop    %esi
  8023e5:	5f                   	pop    %edi
  8023e6:	5d                   	pop    %ebp
  8023e7:	c3                   	ret    
  8023e8:	3b 04 24             	cmp    (%esp),%eax
  8023eb:	72 06                	jb     8023f3 <__umoddi3+0x113>
  8023ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8023f1:	77 0f                	ja     802402 <__umoddi3+0x122>
  8023f3:	89 f2                	mov    %esi,%edx
  8023f5:	29 f9                	sub    %edi,%ecx
  8023f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8023fb:	89 14 24             	mov    %edx,(%esp)
  8023fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802402:	8b 44 24 04          	mov    0x4(%esp),%eax
  802406:	8b 14 24             	mov    (%esp),%edx
  802409:	83 c4 1c             	add    $0x1c,%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
  802411:	8d 76 00             	lea    0x0(%esi),%esi
  802414:	2b 04 24             	sub    (%esp),%eax
  802417:	19 fa                	sbb    %edi,%edx
  802419:	89 d1                	mov    %edx,%ecx
  80241b:	89 c6                	mov    %eax,%esi
  80241d:	e9 71 ff ff ff       	jmp    802393 <__umoddi3+0xb3>
  802422:	66 90                	xchg   %ax,%ax
  802424:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802428:	72 ea                	jb     802414 <__umoddi3+0x134>
  80242a:	89 d9                	mov    %ebx,%ecx
  80242c:	e9 62 ff ff ff       	jmp    802393 <__umoddi3+0xb3>
