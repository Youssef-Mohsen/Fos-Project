
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
  800042:	e8 cb 21 00 00       	call   802212 <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  80004a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	IO_CS = create_semaphore("IO.CS", 1);
  800051:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	6a 01                	push   $0x1
  80005c:	68 c0 42 80 00       	push   $0x8042c0
  800061:	50                   	push   %eax
  800062:	e8 6a 3f 00 00       	call   803fd1 <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 44 50 80 00       	mov    %eax,0x805044
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 e8 1f 00 00       	call   802062 <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 fa 1f 00 00       	call   80207b <sys_calculate_modified_frames>
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
  800092:	e8 6e 3f 00 00       	call   804005 <wait_semaphore>
  800097:	83 c4 10             	add    $0x10,%esp
		{
			readline("Enter the number of elements: ", Line);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 c8 42 80 00       	push   $0x8042c8
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
  8000e2:	68 e8 42 80 00       	push   $0x8042e8
  8000e7:	e8 81 09 00 00       	call   800a6d <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 0b 43 80 00       	push   $0x80430b
  8000f7:	e8 71 09 00 00       	call   800a6d <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 19 43 80 00       	push   $0x804319
  800107:	e8 61 09 00 00       	call   800a6d <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 28 43 80 00       	push   $0x804328
  800117:	e8 51 09 00 00       	call   800a6d <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 38 43 80 00       	push   $0x804338
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
  80016f:	e8 ab 3e 00 00       	call   80401f <signal_semaphore>
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
  800202:	68 44 43 80 00       	push   $0x804344
  800207:	6a 4d                	push   $0x4d
  800209:	68 66 43 80 00       	push   $0x804366
  80020e:	e8 9d 05 00 00       	call   8007b0 <_panic>
		else
		{
			wait_semaphore(IO_CS);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 35 44 50 80 00    	pushl  0x805044
  80021c:	e8 e4 3d 00 00       	call   804005 <wait_semaphore>
  800221:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 84 43 80 00       	push   $0x804384
  80022c:	e8 3c 08 00 00       	call   800a6d <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 b8 43 80 00       	push   $0x8043b8
  80023c:	e8 2c 08 00 00       	call   800a6d <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 ec 43 80 00       	push   $0x8043ec
  80024c:	e8 1c 08 00 00       	call   800a6d <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			signal_semaphore(IO_CS);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 35 44 50 80 00    	pushl  0x805044
  80025d:	e8 bd 3d 00 00       	call   80401f <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 44 50 80 00    	pushl  0x805044
  80026e:	e8 92 3d 00 00       	call   804005 <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 1e 44 80 00       	push   $0x80441e
  80027e:	e8 ea 07 00 00       	call   800a6d <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 44 50 80 00    	pushl  0x805044
  80028f:	e8 8b 3d 00 00       	call   80401f <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 44 50 80 00    	pushl  0x805044
  8002a0:	e8 60 3d 00 00       	call   804005 <wait_semaphore>
  8002a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 34 44 80 00       	push   $0x804434
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
  8002f3:	e8 27 3d 00 00       	call   80401f <signal_semaphore>
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
  80058b:	e8 82 1c 00 00       	call   802212 <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 44 50 80 00    	pushl  0x805044
  80059c:	e8 64 3a 00 00       	call   804005 <wait_semaphore>
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
  8005c4:	68 52 44 80 00       	push   $0x804452
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
  8005e6:	68 54 44 80 00       	push   $0x804454
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
  800614:	68 59 44 80 00       	push   $0x804459
  800619:	e8 4f 04 00 00       	call   800a6d <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(IO_CS);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	ff 35 44 50 80 00    	pushl  0x805044
  80062a:	e8 f0 39 00 00       	call   80401f <signal_semaphore>
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
  800649:	e8 ac 1a 00 00       	call   8020fa <sys_cputc>
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
  80065a:	e8 37 19 00 00       	call   801f96 <sys_cgetc>
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
  800677:	e8 af 1b 00 00       	call   80222b <sys_getenvindex>
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
  8006e5:	e8 c5 18 00 00       	call   801faf <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	68 78 44 80 00       	push   $0x804478
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
  800715:	68 a0 44 80 00       	push   $0x8044a0
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
  800746:	68 c8 44 80 00       	push   $0x8044c8
  80074b:	e8 1d 03 00 00       	call   800a6d <cprintf>
  800750:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800753:	a1 24 50 80 00       	mov    0x805024,%eax
  800758:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	50                   	push   %eax
  800762:	68 20 45 80 00       	push   $0x804520
  800767:	e8 01 03 00 00       	call   800a6d <cprintf>
  80076c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80076f:	83 ec 0c             	sub    $0xc,%esp
  800772:	68 78 44 80 00       	push   $0x804478
  800777:	e8 f1 02 00 00       	call   800a6d <cprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80077f:	e8 45 18 00 00       	call   801fc9 <sys_unlock_cons>
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
  800797:	e8 5b 1a 00 00       	call   8021f7 <sys_destroy_env>
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
  8007a8:	e8 b0 1a 00 00       	call   80225d <sys_exit_env>
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
  8007d1:	68 34 45 80 00       	push   $0x804534
  8007d6:	e8 92 02 00 00       	call   800a6d <cprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007de:	a1 00 50 80 00       	mov    0x805000,%eax
  8007e3:	ff 75 0c             	pushl  0xc(%ebp)
  8007e6:	ff 75 08             	pushl  0x8(%ebp)
  8007e9:	50                   	push   %eax
  8007ea:	68 39 45 80 00       	push   $0x804539
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
  80080e:	68 55 45 80 00       	push   $0x804555
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
  80083d:	68 58 45 80 00       	push   $0x804558
  800842:	6a 26                	push   $0x26
  800844:	68 a4 45 80 00       	push   $0x8045a4
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
  800912:	68 b0 45 80 00       	push   $0x8045b0
  800917:	6a 3a                	push   $0x3a
  800919:	68 a4 45 80 00       	push   $0x8045a4
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
  800985:	68 04 46 80 00       	push   $0x804604
  80098a:	6a 44                	push   $0x44
  80098c:	68 a4 45 80 00       	push   $0x8045a4
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
  8009df:	e8 89 15 00 00       	call   801f6d <sys_cputs>
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
  800a56:	e8 12 15 00 00       	call   801f6d <sys_cputs>
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
  800aa0:	e8 0a 15 00 00       	call   801faf <sys_lock_cons>
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
  800ac0:	e8 04 15 00 00       	call   801fc9 <sys_unlock_cons>
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
  800b0a:	e8 35 35 00 00       	call   804044 <__udivdi3>
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
  800b5a:	e8 f5 35 00 00       	call   804154 <__umoddi3>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	05 74 48 80 00       	add    $0x804874,%eax
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
  800cb5:	8b 04 85 98 48 80 00 	mov    0x804898(,%eax,4),%eax
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
  800d96:	8b 34 9d e0 46 80 00 	mov    0x8046e0(,%ebx,4),%esi
  800d9d:	85 f6                	test   %esi,%esi
  800d9f:	75 19                	jne    800dba <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da1:	53                   	push   %ebx
  800da2:	68 85 48 80 00       	push   $0x804885
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
  800dbb:	68 8e 48 80 00       	push   $0x80488e
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
  800de8:	be 91 48 80 00       	mov    $0x804891,%esi
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
  801113:	68 08 4a 80 00       	push   $0x804a08
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
  801155:	68 0b 4a 80 00       	push   $0x804a0b
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
  801206:	e8 a4 0d 00 00       	call   801faf <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80120b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80120f:	74 13                	je     801224 <atomic_readline+0x24>
			cprintf("%s", prompt);
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	ff 75 08             	pushl  0x8(%ebp)
  801217:	68 08 4a 80 00       	push   $0x804a08
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
  801259:	68 0b 4a 80 00       	push   $0x804a0b
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
  801301:	e8 c3 0c 00 00       	call   801fc9 <sys_unlock_cons>
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
  8019fb:	68 1c 4a 80 00       	push   $0x804a1c
  801a00:	68 3f 01 00 00       	push   $0x13f
  801a05:	68 3e 4a 80 00       	push   $0x804a3e
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
  801a1b:	e8 f8 0a 00 00       	call   802518 <sys_sbrk>
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
  801a96:	e8 01 09 00 00       	call   80239c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	74 16                	je     801ab5 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801a9f:	83 ec 0c             	sub    $0xc,%esp
  801aa2:	ff 75 08             	pushl  0x8(%ebp)
  801aa5:	e8 41 0e 00 00       	call   8028eb <alloc_block_FF>
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ab0:	e9 8a 01 00 00       	jmp    801c3f <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801ab5:	e8 13 09 00 00       	call   8023cd <sys_isUHeapPlacementStrategyBESTFIT>
  801aba:	85 c0                	test   %eax,%eax
  801abc:	0f 84 7d 01 00 00    	je     801c3f <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801ac2:	83 ec 0c             	sub    $0xc,%esp
  801ac5:	ff 75 08             	pushl  0x8(%ebp)
  801ac8:	e8 da 12 00 00       	call   802da7 <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2a:	05 00 10 00 00       	add    $0x1000,%eax
  801b2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801b32:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  801bd2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bd6:	75 16                	jne    801bee <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801bd8:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  801bdf:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801be6:	0f 86 15 ff ff ff    	jbe    801b01 <malloc+0xdc>
  801bec:	eb 01                	jmp    801bef <malloc+0x1ca>
				}
				

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
  801c2e:	e8 1c 09 00 00       	call   80254f <sys_allocate_user_mem>
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	eb 07                	jmp    801c3f <malloc+0x21a>
		
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
  801c76:	e8 f0 08 00 00       	call   80256b <get_block_size>
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	ff 75 08             	pushl  0x8(%ebp)
  801c87:	e8 00 1b 00 00       	call   80378c <free_block>
  801c8c:	83 c4 10             	add    $0x10,%esp
		}

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
  801cdb:	eb 42                	jmp    801d1f <free+0xdb>
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
			sys_free_user_mem((uint32)va, k);
  801d09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	83 ec 08             	sub    $0x8,%esp
  801d12:	52                   	push   %edx
  801d13:	50                   	push   %eax
  801d14:	e8 1a 08 00 00       	call   802533 <sys_free_user_mem>
  801d19:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801d1c:	ff 45 f4             	incl   -0xc(%ebp)
  801d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d22:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d25:	72 b6                	jb     801cdd <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801d27:	eb 17                	jmp    801d40 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	68 4c 4a 80 00       	push   $0x804a4c
  801d31:	68 87 00 00 00       	push   $0x87
  801d36:	68 76 4a 80 00       	push   $0x804a76
  801d3b:	e8 70 ea ff ff       	call   8007b0 <_panic>
	}
}
  801d40:	90                   	nop
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 28             	sub    $0x28,%esp
  801d49:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4c:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801d4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d53:	75 0a                	jne    801d5f <smalloc+0x1c>
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	e9 87 00 00 00       	jmp    801de6 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d65:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d72:	39 d0                	cmp    %edx,%eax
  801d74:	73 02                	jae    801d78 <smalloc+0x35>
  801d76:	89 d0                	mov    %edx,%eax
  801d78:	83 ec 0c             	sub    $0xc,%esp
  801d7b:	50                   	push   %eax
  801d7c:	e8 a4 fc ff ff       	call   801a25 <malloc>
  801d81:	83 c4 10             	add    $0x10,%esp
  801d84:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801d87:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d8b:	75 07                	jne    801d94 <smalloc+0x51>
  801d8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d92:	eb 52                	jmp    801de6 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801d94:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d98:	ff 75 ec             	pushl  -0x14(%ebp)
  801d9b:	50                   	push   %eax
  801d9c:	ff 75 0c             	pushl  0xc(%ebp)
  801d9f:	ff 75 08             	pushl  0x8(%ebp)
  801da2:	e8 93 03 00 00       	call   80213a <sys_createSharedObject>
  801da7:	83 c4 10             	add    $0x10,%esp
  801daa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801dad:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801db1:	74 06                	je     801db9 <smalloc+0x76>
  801db3:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801db7:	75 07                	jne    801dc0 <smalloc+0x7d>
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbe:	eb 26                	jmp    801de6 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801dc0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801dc3:	a1 24 50 80 00       	mov    0x805024,%eax
  801dc8:	8b 40 78             	mov    0x78(%eax),%eax
  801dcb:	29 c2                	sub    %eax,%edx
  801dcd:	89 d0                	mov    %edx,%eax
  801dcf:	2d 00 10 00 00       	sub    $0x1000,%eax
  801dd4:	c1 e8 0c             	shr    $0xc,%eax
  801dd7:	89 c2                	mov    %eax,%edx
  801dd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ddc:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801de3:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801dee:	83 ec 08             	sub    $0x8,%esp
  801df1:	ff 75 0c             	pushl  0xc(%ebp)
  801df4:	ff 75 08             	pushl  0x8(%ebp)
  801df7:	e8 68 03 00 00       	call   802164 <sys_getSizeOfSharedObject>
  801dfc:	83 c4 10             	add    $0x10,%esp
  801dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801e02:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801e06:	75 07                	jne    801e0f <sget+0x27>
  801e08:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0d:	eb 7f                	jmp    801e8e <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e15:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e22:	39 d0                	cmp    %edx,%eax
  801e24:	73 02                	jae    801e28 <sget+0x40>
  801e26:	89 d0                	mov    %edx,%eax
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	50                   	push   %eax
  801e2c:	e8 f4 fb ff ff       	call   801a25 <malloc>
  801e31:	83 c4 10             	add    $0x10,%esp
  801e34:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801e37:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e3b:	75 07                	jne    801e44 <sget+0x5c>
  801e3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e42:	eb 4a                	jmp    801e8e <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801e44:	83 ec 04             	sub    $0x4,%esp
  801e47:	ff 75 e8             	pushl  -0x18(%ebp)
  801e4a:	ff 75 0c             	pushl  0xc(%ebp)
  801e4d:	ff 75 08             	pushl  0x8(%ebp)
  801e50:	e8 2c 03 00 00       	call   802181 <sys_getSharedObject>
  801e55:	83 c4 10             	add    $0x10,%esp
  801e58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801e5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801e5e:	a1 24 50 80 00       	mov    0x805024,%eax
  801e63:	8b 40 78             	mov    0x78(%eax),%eax
  801e66:	29 c2                	sub    %eax,%edx
  801e68:	89 d0                	mov    %edx,%eax
  801e6a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e6f:	c1 e8 0c             	shr    $0xc,%eax
  801e72:	89 c2                	mov    %eax,%edx
  801e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e77:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801e7e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801e82:	75 07                	jne    801e8b <sget+0xa3>
  801e84:	b8 00 00 00 00       	mov    $0x0,%eax
  801e89:	eb 03                	jmp    801e8e <sget+0xa6>
	return ptr;
  801e8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801e96:	8b 55 08             	mov    0x8(%ebp),%edx
  801e99:	a1 24 50 80 00       	mov    0x805024,%eax
  801e9e:	8b 40 78             	mov    0x78(%eax),%eax
  801ea1:	29 c2                	sub    %eax,%edx
  801ea3:	89 d0                	mov    %edx,%eax
  801ea5:	2d 00 10 00 00       	sub    $0x1000,%eax
  801eaa:	c1 e8 0c             	shr    $0xc,%eax
  801ead:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801eb7:	83 ec 08             	sub    $0x8,%esp
  801eba:	ff 75 08             	pushl  0x8(%ebp)
  801ebd:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec0:	e8 db 02 00 00       	call   8021a0 <sys_freeSharedObject>
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801ecb:	90                   	nop
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ed4:	83 ec 04             	sub    $0x4,%esp
  801ed7:	68 84 4a 80 00       	push   $0x804a84
  801edc:	68 e4 00 00 00       	push   $0xe4
  801ee1:	68 76 4a 80 00       	push   $0x804a76
  801ee6:	e8 c5 e8 ff ff       	call   8007b0 <_panic>

00801eeb <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ef1:	83 ec 04             	sub    $0x4,%esp
  801ef4:	68 aa 4a 80 00       	push   $0x804aaa
  801ef9:	68 f0 00 00 00       	push   $0xf0
  801efe:	68 76 4a 80 00       	push   $0x804a76
  801f03:	e8 a8 e8 ff ff       	call   8007b0 <_panic>

00801f08 <shrink>:

}
void shrink(uint32 newSize)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f0e:	83 ec 04             	sub    $0x4,%esp
  801f11:	68 aa 4a 80 00       	push   $0x804aaa
  801f16:	68 f5 00 00 00       	push   $0xf5
  801f1b:	68 76 4a 80 00       	push   $0x804a76
  801f20:	e8 8b e8 ff ff       	call   8007b0 <_panic>

00801f25 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f2b:	83 ec 04             	sub    $0x4,%esp
  801f2e:	68 aa 4a 80 00       	push   $0x804aaa
  801f33:	68 fa 00 00 00       	push   $0xfa
  801f38:	68 76 4a 80 00       	push   $0x804a76
  801f3d:	e8 6e e8 ff ff       	call   8007b0 <_panic>

00801f42 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	57                   	push   %edi
  801f46:	56                   	push   %esi
  801f47:	53                   	push   %ebx
  801f48:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f51:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f54:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f57:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f5a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f5d:	cd 30                	int    $0x30
  801f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f65:	83 c4 10             	add    $0x10,%esp
  801f68:	5b                   	pop    %ebx
  801f69:	5e                   	pop    %esi
  801f6a:	5f                   	pop    %edi
  801f6b:	5d                   	pop    %ebp
  801f6c:	c3                   	ret    

00801f6d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 04             	sub    $0x4,%esp
  801f73:	8b 45 10             	mov    0x10(%ebp),%eax
  801f76:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f79:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	52                   	push   %edx
  801f85:	ff 75 0c             	pushl  0xc(%ebp)
  801f88:	50                   	push   %eax
  801f89:	6a 00                	push   $0x0
  801f8b:	e8 b2 ff ff ff       	call   801f42 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	90                   	nop
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 02                	push   $0x2
  801fa5:	e8 98 ff ff ff       	call   801f42 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_lock_cons>:

void sys_lock_cons(void)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 03                	push   $0x3
  801fbe:	e8 7f ff ff ff       	call   801f42 <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
}
  801fc6:	90                   	nop
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 04                	push   $0x4
  801fd8:	e8 65 ff ff ff       	call   801f42 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	90                   	nop
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fe6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	52                   	push   %edx
  801ff3:	50                   	push   %eax
  801ff4:	6a 08                	push   $0x8
  801ff6:	e8 47 ff ff ff       	call   801f42 <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	56                   	push   %esi
  802004:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802005:	8b 75 18             	mov    0x18(%ebp),%esi
  802008:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80200b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80200e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	56                   	push   %esi
  802015:	53                   	push   %ebx
  802016:	51                   	push   %ecx
  802017:	52                   	push   %edx
  802018:	50                   	push   %eax
  802019:	6a 09                	push   $0x9
  80201b:	e8 22 ff ff ff       	call   801f42 <syscall>
  802020:	83 c4 18             	add    $0x18,%esp
}
  802023:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802026:	5b                   	pop    %ebx
  802027:	5e                   	pop    %esi
  802028:	5d                   	pop    %ebp
  802029:	c3                   	ret    

0080202a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80202d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	52                   	push   %edx
  80203a:	50                   	push   %eax
  80203b:	6a 0a                	push   $0xa
  80203d:	e8 00 ff ff ff       	call   801f42 <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	ff 75 0c             	pushl  0xc(%ebp)
  802053:	ff 75 08             	pushl  0x8(%ebp)
  802056:	6a 0b                	push   $0xb
  802058:	e8 e5 fe ff ff       	call   801f42 <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 0c                	push   $0xc
  802071:	e8 cc fe ff ff       	call   801f42 <syscall>
  802076:	83 c4 18             	add    $0x18,%esp
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 0d                	push   $0xd
  80208a:	e8 b3 fe ff ff       	call   801f42 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 0e                	push   $0xe
  8020a3:	e8 9a fe ff ff       	call   801f42 <syscall>
  8020a8:	83 c4 18             	add    $0x18,%esp
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 0f                	push   $0xf
  8020bc:	e8 81 fe ff ff       	call   801f42 <syscall>
  8020c1:	83 c4 18             	add    $0x18,%esp
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	ff 75 08             	pushl  0x8(%ebp)
  8020d4:	6a 10                	push   $0x10
  8020d6:	e8 67 fe ff ff       	call   801f42 <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 11                	push   $0x11
  8020ef:	e8 4e fe ff ff       	call   801f42 <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
}
  8020f7:	90                   	nop
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_cputc>:

void
sys_cputc(const char c)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 04             	sub    $0x4,%esp
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802106:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	50                   	push   %eax
  802113:	6a 01                	push   $0x1
  802115:	e8 28 fe ff ff       	call   801f42 <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
}
  80211d:	90                   	nop
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 14                	push   $0x14
  80212f:	e8 0e fe ff ff       	call   801f42 <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	90                   	nop
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 04             	sub    $0x4,%esp
  802140:	8b 45 10             	mov    0x10(%ebp),%eax
  802143:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802146:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802149:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	6a 00                	push   $0x0
  802152:	51                   	push   %ecx
  802153:	52                   	push   %edx
  802154:	ff 75 0c             	pushl  0xc(%ebp)
  802157:	50                   	push   %eax
  802158:	6a 15                	push   $0x15
  80215a:	e8 e3 fd ff ff       	call   801f42 <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802167:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	52                   	push   %edx
  802174:	50                   	push   %eax
  802175:	6a 16                	push   $0x16
  802177:	e8 c6 fd ff ff       	call   801f42 <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802184:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802187:	8b 55 0c             	mov    0xc(%ebp),%edx
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	51                   	push   %ecx
  802192:	52                   	push   %edx
  802193:	50                   	push   %eax
  802194:	6a 17                	push   $0x17
  802196:	e8 a7 fd ff ff       	call   801f42 <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	52                   	push   %edx
  8021b0:	50                   	push   %eax
  8021b1:	6a 18                	push   $0x18
  8021b3:	e8 8a fd ff ff       	call   801f42 <syscall>
  8021b8:	83 c4 18             	add    $0x18,%esp
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	6a 00                	push   $0x0
  8021c5:	ff 75 14             	pushl  0x14(%ebp)
  8021c8:	ff 75 10             	pushl  0x10(%ebp)
  8021cb:	ff 75 0c             	pushl  0xc(%ebp)
  8021ce:	50                   	push   %eax
  8021cf:	6a 19                	push   $0x19
  8021d1:	e8 6c fd ff ff       	call   801f42 <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <sys_run_env>:

void sys_run_env(int32 envId)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	50                   	push   %eax
  8021ea:	6a 1a                	push   $0x1a
  8021ec:	e8 51 fd ff ff       	call   801f42 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	90                   	nop
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	50                   	push   %eax
  802206:	6a 1b                	push   $0x1b
  802208:	e8 35 fd ff ff       	call   801f42 <syscall>
  80220d:	83 c4 18             	add    $0x18,%esp
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 05                	push   $0x5
  802221:	e8 1c fd ff ff       	call   801f42 <syscall>
  802226:	83 c4 18             	add    $0x18,%esp
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 06                	push   $0x6
  80223a:	e8 03 fd ff ff       	call   801f42 <syscall>
  80223f:	83 c4 18             	add    $0x18,%esp
}
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 07                	push   $0x7
  802253:	e8 ea fc ff ff       	call   801f42 <syscall>
  802258:	83 c4 18             	add    $0x18,%esp
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <sys_exit_env>:


void sys_exit_env(void)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 1c                	push   $0x1c
  80226c:	e8 d1 fc ff ff       	call   801f42 <syscall>
  802271:	83 c4 18             	add    $0x18,%esp
}
  802274:	90                   	nop
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80227d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802280:	8d 50 04             	lea    0x4(%eax),%edx
  802283:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	52                   	push   %edx
  80228d:	50                   	push   %eax
  80228e:	6a 1d                	push   $0x1d
  802290:	e8 ad fc ff ff       	call   801f42 <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
	return result;
  802298:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80229b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80229e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022a1:	89 01                	mov    %eax,(%ecx)
  8022a3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	c9                   	leave  
  8022aa:	c2 04 00             	ret    $0x4

008022ad <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	ff 75 10             	pushl  0x10(%ebp)
  8022b7:	ff 75 0c             	pushl  0xc(%ebp)
  8022ba:	ff 75 08             	pushl  0x8(%ebp)
  8022bd:	6a 13                	push   $0x13
  8022bf:	e8 7e fc ff ff       	call   801f42 <syscall>
  8022c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c7:	90                   	nop
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <sys_rcr2>:
uint32 sys_rcr2()
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 1e                	push   $0x1e
  8022d9:	e8 64 fc ff ff       	call   801f42 <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
}
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
  8022e6:	83 ec 04             	sub    $0x4,%esp
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022ef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	50                   	push   %eax
  8022fc:	6a 1f                	push   $0x1f
  8022fe:	e8 3f fc ff ff       	call   801f42 <syscall>
  802303:	83 c4 18             	add    $0x18,%esp
	return ;
  802306:	90                   	nop
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <rsttst>:
void rsttst()
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 21                	push   $0x21
  802318:	e8 25 fc ff ff       	call   801f42 <syscall>
  80231d:	83 c4 18             	add    $0x18,%esp
	return ;
  802320:	90                   	nop
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	83 ec 04             	sub    $0x4,%esp
  802329:	8b 45 14             	mov    0x14(%ebp),%eax
  80232c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80232f:	8b 55 18             	mov    0x18(%ebp),%edx
  802332:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802336:	52                   	push   %edx
  802337:	50                   	push   %eax
  802338:	ff 75 10             	pushl  0x10(%ebp)
  80233b:	ff 75 0c             	pushl  0xc(%ebp)
  80233e:	ff 75 08             	pushl  0x8(%ebp)
  802341:	6a 20                	push   $0x20
  802343:	e8 fa fb ff ff       	call   801f42 <syscall>
  802348:	83 c4 18             	add    $0x18,%esp
	return ;
  80234b:	90                   	nop
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <chktst>:
void chktst(uint32 n)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	ff 75 08             	pushl  0x8(%ebp)
  80235c:	6a 22                	push   $0x22
  80235e:	e8 df fb ff ff       	call   801f42 <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
	return ;
  802366:	90                   	nop
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <inctst>:

void inctst()
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 23                	push   $0x23
  802378:	e8 c5 fb ff ff       	call   801f42 <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
	return ;
  802380:	90                   	nop
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <gettst>:
uint32 gettst()
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 24                	push   $0x24
  802392:	e8 ab fb ff ff       	call   801f42 <syscall>
  802397:	83 c4 18             	add    $0x18,%esp
}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
  80239f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 25                	push   $0x25
  8023ae:	e8 8f fb ff ff       	call   801f42 <syscall>
  8023b3:	83 c4 18             	add    $0x18,%esp
  8023b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023b9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023bd:	75 07                	jne    8023c6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c4:	eb 05                	jmp    8023cb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 25                	push   $0x25
  8023df:	e8 5e fb ff ff       	call   801f42 <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
  8023e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023ea:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023ee:	75 07                	jne    8023f7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f5:	eb 05                	jmp    8023fc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 25                	push   $0x25
  802410:	e8 2d fb ff ff       	call   801f42 <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
  802418:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80241b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80241f:	75 07                	jne    802428 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802421:	b8 01 00 00 00       	mov    $0x1,%eax
  802426:	eb 05                	jmp    80242d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802428:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 25                	push   $0x25
  802441:	e8 fc fa ff ff       	call   801f42 <syscall>
  802446:	83 c4 18             	add    $0x18,%esp
  802449:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80244c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802450:	75 07                	jne    802459 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802452:	b8 01 00 00 00       	mov    $0x1,%eax
  802457:	eb 05                	jmp    80245e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245e:	c9                   	leave  
  80245f:	c3                   	ret    

00802460 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	ff 75 08             	pushl  0x8(%ebp)
  80246e:	6a 26                	push   $0x26
  802470:	e8 cd fa ff ff       	call   801f42 <syscall>
  802475:	83 c4 18             	add    $0x18,%esp
	return ;
  802478:	90                   	nop
}
  802479:	c9                   	leave  
  80247a:	c3                   	ret    

0080247b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
  80247e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80247f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802482:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802485:	8b 55 0c             	mov    0xc(%ebp),%edx
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	6a 00                	push   $0x0
  80248d:	53                   	push   %ebx
  80248e:	51                   	push   %ecx
  80248f:	52                   	push   %edx
  802490:	50                   	push   %eax
  802491:	6a 27                	push   $0x27
  802493:	e8 aa fa ff ff       	call   801f42 <syscall>
  802498:	83 c4 18             	add    $0x18,%esp
}
  80249b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80249e:	c9                   	leave  
  80249f:	c3                   	ret    

008024a0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	52                   	push   %edx
  8024b0:	50                   	push   %eax
  8024b1:	6a 28                	push   $0x28
  8024b3:	e8 8a fa ff ff       	call   801f42 <syscall>
  8024b8:	83 c4 18             	add    $0x18,%esp
}
  8024bb:	c9                   	leave  
  8024bc:	c3                   	ret    

008024bd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8024c0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	6a 00                	push   $0x0
  8024cb:	51                   	push   %ecx
  8024cc:	ff 75 10             	pushl  0x10(%ebp)
  8024cf:	52                   	push   %edx
  8024d0:	50                   	push   %eax
  8024d1:	6a 29                	push   $0x29
  8024d3:	e8 6a fa ff ff       	call   801f42 <syscall>
  8024d8:	83 c4 18             	add    $0x18,%esp
}
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	ff 75 10             	pushl  0x10(%ebp)
  8024e7:	ff 75 0c             	pushl  0xc(%ebp)
  8024ea:	ff 75 08             	pushl  0x8(%ebp)
  8024ed:	6a 12                	push   $0x12
  8024ef:	e8 4e fa ff ff       	call   801f42 <syscall>
  8024f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f7:	90                   	nop
}
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8024fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802500:	8b 45 08             	mov    0x8(%ebp),%eax
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	52                   	push   %edx
  80250a:	50                   	push   %eax
  80250b:	6a 2a                	push   $0x2a
  80250d:	e8 30 fa ff ff       	call   801f42 <syscall>
  802512:	83 c4 18             	add    $0x18,%esp
	return;
  802515:	90                   	nop
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	50                   	push   %eax
  802527:	6a 2b                	push   $0x2b
  802529:	e8 14 fa ff ff       	call   801f42 <syscall>
  80252e:	83 c4 18             	add    $0x18,%esp
}
  802531:	c9                   	leave  
  802532:	c3                   	ret    

00802533 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	ff 75 0c             	pushl  0xc(%ebp)
  80253f:	ff 75 08             	pushl  0x8(%ebp)
  802542:	6a 2c                	push   $0x2c
  802544:	e8 f9 f9 ff ff       	call   801f42 <syscall>
  802549:	83 c4 18             	add    $0x18,%esp
	return;
  80254c:	90                   	nop
}
  80254d:	c9                   	leave  
  80254e:	c3                   	ret    

0080254f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80254f:	55                   	push   %ebp
  802550:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	ff 75 0c             	pushl  0xc(%ebp)
  80255b:	ff 75 08             	pushl  0x8(%ebp)
  80255e:	6a 2d                	push   $0x2d
  802560:	e8 dd f9 ff ff       	call   801f42 <syscall>
  802565:	83 c4 18             	add    $0x18,%esp
	return;
  802568:	90                   	nop
}
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802571:	8b 45 08             	mov    0x8(%ebp),%eax
  802574:	83 e8 04             	sub    $0x4,%eax
  802577:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80257a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802582:	c9                   	leave  
  802583:	c3                   	ret    

00802584 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	83 e8 04             	sub    $0x4,%eax
  802590:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802593:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	83 e0 01             	and    $0x1,%eax
  80259b:	85 c0                	test   %eax,%eax
  80259d:	0f 94 c0             	sete   %al
}
  8025a0:	c9                   	leave  
  8025a1:	c3                   	ret    

008025a2 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025a2:	55                   	push   %ebp
  8025a3:	89 e5                	mov    %esp,%ebp
  8025a5:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8025a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8025af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b2:	83 f8 02             	cmp    $0x2,%eax
  8025b5:	74 2b                	je     8025e2 <alloc_block+0x40>
  8025b7:	83 f8 02             	cmp    $0x2,%eax
  8025ba:	7f 07                	jg     8025c3 <alloc_block+0x21>
  8025bc:	83 f8 01             	cmp    $0x1,%eax
  8025bf:	74 0e                	je     8025cf <alloc_block+0x2d>
  8025c1:	eb 58                	jmp    80261b <alloc_block+0x79>
  8025c3:	83 f8 03             	cmp    $0x3,%eax
  8025c6:	74 2d                	je     8025f5 <alloc_block+0x53>
  8025c8:	83 f8 04             	cmp    $0x4,%eax
  8025cb:	74 3b                	je     802608 <alloc_block+0x66>
  8025cd:	eb 4c                	jmp    80261b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8025cf:	83 ec 0c             	sub    $0xc,%esp
  8025d2:	ff 75 08             	pushl  0x8(%ebp)
  8025d5:	e8 11 03 00 00       	call   8028eb <alloc_block_FF>
  8025da:	83 c4 10             	add    $0x10,%esp
  8025dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025e0:	eb 4a                	jmp    80262c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8025e2:	83 ec 0c             	sub    $0xc,%esp
  8025e5:	ff 75 08             	pushl  0x8(%ebp)
  8025e8:	e8 c7 19 00 00       	call   803fb4 <alloc_block_NF>
  8025ed:	83 c4 10             	add    $0x10,%esp
  8025f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025f3:	eb 37                	jmp    80262c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8025f5:	83 ec 0c             	sub    $0xc,%esp
  8025f8:	ff 75 08             	pushl  0x8(%ebp)
  8025fb:	e8 a7 07 00 00       	call   802da7 <alloc_block_BF>
  802600:	83 c4 10             	add    $0x10,%esp
  802603:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802606:	eb 24                	jmp    80262c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802608:	83 ec 0c             	sub    $0xc,%esp
  80260b:	ff 75 08             	pushl  0x8(%ebp)
  80260e:	e8 84 19 00 00       	call   803f97 <alloc_block_WF>
  802613:	83 c4 10             	add    $0x10,%esp
  802616:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802619:	eb 11                	jmp    80262c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80261b:	83 ec 0c             	sub    $0xc,%esp
  80261e:	68 bc 4a 80 00       	push   $0x804abc
  802623:	e8 45 e4 ff ff       	call   800a6d <cprintf>
  802628:	83 c4 10             	add    $0x10,%esp
		break;
  80262b:	90                   	nop
	}
	return va;
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	53                   	push   %ebx
  802635:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802638:	83 ec 0c             	sub    $0xc,%esp
  80263b:	68 dc 4a 80 00       	push   $0x804adc
  802640:	e8 28 e4 ff ff       	call   800a6d <cprintf>
  802645:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802648:	83 ec 0c             	sub    $0xc,%esp
  80264b:	68 07 4b 80 00       	push   $0x804b07
  802650:	e8 18 e4 ff ff       	call   800a6d <cprintf>
  802655:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802658:	8b 45 08             	mov    0x8(%ebp),%eax
  80265b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265e:	eb 37                	jmp    802697 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802660:	83 ec 0c             	sub    $0xc,%esp
  802663:	ff 75 f4             	pushl  -0xc(%ebp)
  802666:	e8 19 ff ff ff       	call   802584 <is_free_block>
  80266b:	83 c4 10             	add    $0x10,%esp
  80266e:	0f be d8             	movsbl %al,%ebx
  802671:	83 ec 0c             	sub    $0xc,%esp
  802674:	ff 75 f4             	pushl  -0xc(%ebp)
  802677:	e8 ef fe ff ff       	call   80256b <get_block_size>
  80267c:	83 c4 10             	add    $0x10,%esp
  80267f:	83 ec 04             	sub    $0x4,%esp
  802682:	53                   	push   %ebx
  802683:	50                   	push   %eax
  802684:	68 1f 4b 80 00       	push   $0x804b1f
  802689:	e8 df e3 ff ff       	call   800a6d <cprintf>
  80268e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802691:	8b 45 10             	mov    0x10(%ebp),%eax
  802694:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269b:	74 07                	je     8026a4 <print_blocks_list+0x73>
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	8b 00                	mov    (%eax),%eax
  8026a2:	eb 05                	jmp    8026a9 <print_blocks_list+0x78>
  8026a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a9:	89 45 10             	mov    %eax,0x10(%ebp)
  8026ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	75 ad                	jne    802660 <print_blocks_list+0x2f>
  8026b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b7:	75 a7                	jne    802660 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8026b9:	83 ec 0c             	sub    $0xc,%esp
  8026bc:	68 dc 4a 80 00       	push   $0x804adc
  8026c1:	e8 a7 e3 ff ff       	call   800a6d <cprintf>
  8026c6:	83 c4 10             	add    $0x10,%esp

}
  8026c9:	90                   	nop
  8026ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
  8026d2:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8026d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026d8:	83 e0 01             	and    $0x1,%eax
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	74 03                	je     8026e2 <initialize_dynamic_allocator+0x13>
  8026df:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8026e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026e6:	0f 84 c7 01 00 00    	je     8028b3 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8026ec:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8026f3:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8026f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026fc:	01 d0                	add    %edx,%eax
  8026fe:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802703:	0f 87 ad 01 00 00    	ja     8028b6 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802709:	8b 45 08             	mov    0x8(%ebp),%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	0f 89 a5 01 00 00    	jns    8028b9 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802714:	8b 55 08             	mov    0x8(%ebp),%edx
  802717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80271a:	01 d0                	add    %edx,%eax
  80271c:	83 e8 04             	sub    $0x4,%eax
  80271f:	a3 4c 50 80 00       	mov    %eax,0x80504c
     struct BlockElement * element = NULL;
  802724:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80272b:	a1 30 50 80 00       	mov    0x805030,%eax
  802730:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802733:	e9 87 00 00 00       	jmp    8027bf <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802738:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273c:	75 14                	jne    802752 <initialize_dynamic_allocator+0x83>
  80273e:	83 ec 04             	sub    $0x4,%esp
  802741:	68 37 4b 80 00       	push   $0x804b37
  802746:	6a 79                	push   $0x79
  802748:	68 55 4b 80 00       	push   $0x804b55
  80274d:	e8 5e e0 ff ff       	call   8007b0 <_panic>
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 00                	mov    (%eax),%eax
  802757:	85 c0                	test   %eax,%eax
  802759:	74 10                	je     80276b <initialize_dynamic_allocator+0x9c>
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 00                	mov    (%eax),%eax
  802760:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802763:	8b 52 04             	mov    0x4(%edx),%edx
  802766:	89 50 04             	mov    %edx,0x4(%eax)
  802769:	eb 0b                	jmp    802776 <initialize_dynamic_allocator+0xa7>
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	8b 40 04             	mov    0x4(%eax),%eax
  802771:	a3 34 50 80 00       	mov    %eax,0x805034
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 40 04             	mov    0x4(%eax),%eax
  80277c:	85 c0                	test   %eax,%eax
  80277e:	74 0f                	je     80278f <initialize_dynamic_allocator+0xc0>
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 40 04             	mov    0x4(%eax),%eax
  802786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802789:	8b 12                	mov    (%edx),%edx
  80278b:	89 10                	mov    %edx,(%eax)
  80278d:	eb 0a                	jmp    802799 <initialize_dynamic_allocator+0xca>
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 00                	mov    (%eax),%eax
  802794:	a3 30 50 80 00       	mov    %eax,0x805030
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ac:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027b1:	48                   	dec    %eax
  8027b2:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8027b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8027bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c3:	74 07                	je     8027cc <initialize_dynamic_allocator+0xfd>
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 00                	mov    (%eax),%eax
  8027ca:	eb 05                	jmp    8027d1 <initialize_dynamic_allocator+0x102>
  8027cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8027d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	0f 85 55 ff ff ff    	jne    802738 <initialize_dynamic_allocator+0x69>
  8027e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e7:	0f 85 4b ff ff ff    	jne    802738 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8027f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8027fc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802801:	a3 48 50 80 00       	mov    %eax,0x805048
    end_block->info = 1;
  802806:	a1 48 50 80 00       	mov    0x805048,%eax
  80280b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802811:	8b 45 08             	mov    0x8(%ebp),%eax
  802814:	83 c0 08             	add    $0x8,%eax
  802817:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	83 c0 04             	add    $0x4,%eax
  802820:	8b 55 0c             	mov    0xc(%ebp),%edx
  802823:	83 ea 08             	sub    $0x8,%edx
  802826:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	01 d0                	add    %edx,%eax
  802830:	83 e8 08             	sub    $0x8,%eax
  802833:	8b 55 0c             	mov    0xc(%ebp),%edx
  802836:	83 ea 08             	sub    $0x8,%edx
  802839:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80283b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802847:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80284e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802852:	75 17                	jne    80286b <initialize_dynamic_allocator+0x19c>
  802854:	83 ec 04             	sub    $0x4,%esp
  802857:	68 70 4b 80 00       	push   $0x804b70
  80285c:	68 90 00 00 00       	push   $0x90
  802861:	68 55 4b 80 00       	push   $0x804b55
  802866:	e8 45 df ff ff       	call   8007b0 <_panic>
  80286b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802871:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802874:	89 10                	mov    %edx,(%eax)
  802876:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	74 0d                	je     80288c <initialize_dynamic_allocator+0x1bd>
  80287f:	a1 30 50 80 00       	mov    0x805030,%eax
  802884:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802887:	89 50 04             	mov    %edx,0x4(%eax)
  80288a:	eb 08                	jmp    802894 <initialize_dynamic_allocator+0x1c5>
  80288c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288f:	a3 34 50 80 00       	mov    %eax,0x805034
  802894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802897:	a3 30 50 80 00       	mov    %eax,0x805030
  80289c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8028ab:	40                   	inc    %eax
  8028ac:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8028b1:	eb 07                	jmp    8028ba <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8028b3:	90                   	nop
  8028b4:	eb 04                	jmp    8028ba <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8028b6:	90                   	nop
  8028b7:	eb 01                	jmp    8028ba <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8028b9:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8028ba:	c9                   	leave  
  8028bb:	c3                   	ret    

008028bc <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8028bc:	55                   	push   %ebp
  8028bd:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8028bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c2:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8028cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ce:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8028d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d3:	83 e8 04             	sub    $0x4,%eax
  8028d6:	8b 00                	mov    (%eax),%eax
  8028d8:	83 e0 fe             	and    $0xfffffffe,%eax
  8028db:	8d 50 f8             	lea    -0x8(%eax),%edx
  8028de:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e1:	01 c2                	add    %eax,%edx
  8028e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e6:	89 02                	mov    %eax,(%edx)
}
  8028e8:	90                   	nop
  8028e9:	5d                   	pop    %ebp
  8028ea:	c3                   	ret    

008028eb <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8028eb:	55                   	push   %ebp
  8028ec:	89 e5                	mov    %esp,%ebp
  8028ee:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	83 e0 01             	and    $0x1,%eax
  8028f7:	85 c0                	test   %eax,%eax
  8028f9:	74 03                	je     8028fe <alloc_block_FF+0x13>
  8028fb:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8028fe:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802902:	77 07                	ja     80290b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802904:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80290b:	a1 28 50 80 00       	mov    0x805028,%eax
  802910:	85 c0                	test   %eax,%eax
  802912:	75 73                	jne    802987 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802914:	8b 45 08             	mov    0x8(%ebp),%eax
  802917:	83 c0 10             	add    $0x10,%eax
  80291a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80291d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802924:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802927:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292a:	01 d0                	add    %edx,%eax
  80292c:	48                   	dec    %eax
  80292d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802930:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802933:	ba 00 00 00 00       	mov    $0x0,%edx
  802938:	f7 75 ec             	divl   -0x14(%ebp)
  80293b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293e:	29 d0                	sub    %edx,%eax
  802940:	c1 e8 0c             	shr    $0xc,%eax
  802943:	83 ec 0c             	sub    $0xc,%esp
  802946:	50                   	push   %eax
  802947:	e8 c3 f0 ff ff       	call   801a0f <sbrk>
  80294c:	83 c4 10             	add    $0x10,%esp
  80294f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802952:	83 ec 0c             	sub    $0xc,%esp
  802955:	6a 00                	push   $0x0
  802957:	e8 b3 f0 ff ff       	call   801a0f <sbrk>
  80295c:	83 c4 10             	add    $0x10,%esp
  80295f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802962:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802965:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802968:	83 ec 08             	sub    $0x8,%esp
  80296b:	50                   	push   %eax
  80296c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80296f:	e8 5b fd ff ff       	call   8026cf <initialize_dynamic_allocator>
  802974:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802977:	83 ec 0c             	sub    $0xc,%esp
  80297a:	68 93 4b 80 00       	push   $0x804b93
  80297f:	e8 e9 e0 ff ff       	call   800a6d <cprintf>
  802984:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802987:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80298b:	75 0a                	jne    802997 <alloc_block_FF+0xac>
	        return NULL;
  80298d:	b8 00 00 00 00       	mov    $0x0,%eax
  802992:	e9 0e 04 00 00       	jmp    802da5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80299e:	a1 30 50 80 00       	mov    0x805030,%eax
  8029a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a6:	e9 f3 02 00 00       	jmp    802c9e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8029b1:	83 ec 0c             	sub    $0xc,%esp
  8029b4:	ff 75 bc             	pushl  -0x44(%ebp)
  8029b7:	e8 af fb ff ff       	call   80256b <get_block_size>
  8029bc:	83 c4 10             	add    $0x10,%esp
  8029bf:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	83 c0 08             	add    $0x8,%eax
  8029c8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029cb:	0f 87 c5 02 00 00    	ja     802c96 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	83 c0 18             	add    $0x18,%eax
  8029d7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8029da:	0f 87 19 02 00 00    	ja     802bf9 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8029e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029e3:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e6:	83 e8 08             	sub    $0x8,%eax
  8029e9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	8d 50 08             	lea    0x8(%eax),%edx
  8029f2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029f5:	01 d0                	add    %edx,%eax
  8029f7:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	83 c0 08             	add    $0x8,%eax
  802a00:	83 ec 04             	sub    $0x4,%esp
  802a03:	6a 01                	push   $0x1
  802a05:	50                   	push   %eax
  802a06:	ff 75 bc             	pushl  -0x44(%ebp)
  802a09:	e8 ae fe ff ff       	call   8028bc <set_block_data>
  802a0e:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a14:	8b 40 04             	mov    0x4(%eax),%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	75 68                	jne    802a83 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a1b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a1f:	75 17                	jne    802a38 <alloc_block_FF+0x14d>
  802a21:	83 ec 04             	sub    $0x4,%esp
  802a24:	68 70 4b 80 00       	push   $0x804b70
  802a29:	68 d7 00 00 00       	push   $0xd7
  802a2e:	68 55 4b 80 00       	push   $0x804b55
  802a33:	e8 78 dd ff ff       	call   8007b0 <_panic>
  802a38:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a3e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a41:	89 10                	mov    %edx,(%eax)
  802a43:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	74 0d                	je     802a59 <alloc_block_FF+0x16e>
  802a4c:	a1 30 50 80 00       	mov    0x805030,%eax
  802a51:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802a54:	89 50 04             	mov    %edx,0x4(%eax)
  802a57:	eb 08                	jmp    802a61 <alloc_block_FF+0x176>
  802a59:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a5c:	a3 34 50 80 00       	mov    %eax,0x805034
  802a61:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a64:	a3 30 50 80 00       	mov    %eax,0x805030
  802a69:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a73:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a78:	40                   	inc    %eax
  802a79:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a7e:	e9 dc 00 00 00       	jmp    802b5f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 00                	mov    (%eax),%eax
  802a88:	85 c0                	test   %eax,%eax
  802a8a:	75 65                	jne    802af1 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a8c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802a90:	75 17                	jne    802aa9 <alloc_block_FF+0x1be>
  802a92:	83 ec 04             	sub    $0x4,%esp
  802a95:	68 a4 4b 80 00       	push   $0x804ba4
  802a9a:	68 db 00 00 00       	push   $0xdb
  802a9f:	68 55 4b 80 00       	push   $0x804b55
  802aa4:	e8 07 dd ff ff       	call   8007b0 <_panic>
  802aa9:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802aaf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ab2:	89 50 04             	mov    %edx,0x4(%eax)
  802ab5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ab8:	8b 40 04             	mov    0x4(%eax),%eax
  802abb:	85 c0                	test   %eax,%eax
  802abd:	74 0c                	je     802acb <alloc_block_FF+0x1e0>
  802abf:	a1 34 50 80 00       	mov    0x805034,%eax
  802ac4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802ac7:	89 10                	mov    %edx,(%eax)
  802ac9:	eb 08                	jmp    802ad3 <alloc_block_FF+0x1e8>
  802acb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ace:	a3 30 50 80 00       	mov    %eax,0x805030
  802ad3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ad6:	a3 34 50 80 00       	mov    %eax,0x805034
  802adb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ade:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ae9:	40                   	inc    %eax
  802aea:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802aef:	eb 6e                	jmp    802b5f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802af1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af5:	74 06                	je     802afd <alloc_block_FF+0x212>
  802af7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802afb:	75 17                	jne    802b14 <alloc_block_FF+0x229>
  802afd:	83 ec 04             	sub    $0x4,%esp
  802b00:	68 c8 4b 80 00       	push   $0x804bc8
  802b05:	68 df 00 00 00       	push   $0xdf
  802b0a:	68 55 4b 80 00       	push   $0x804b55
  802b0f:	e8 9c dc ff ff       	call   8007b0 <_panic>
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 10                	mov    (%eax),%edx
  802b19:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b1c:	89 10                	mov    %edx,(%eax)
  802b1e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	85 c0                	test   %eax,%eax
  802b25:	74 0b                	je     802b32 <alloc_block_FF+0x247>
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 00                	mov    (%eax),%eax
  802b2c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b2f:	89 50 04             	mov    %edx,0x4(%eax)
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802b38:	89 10                	mov    %edx,(%eax)
  802b3a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b40:	89 50 04             	mov    %edx,0x4(%eax)
  802b43:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b46:	8b 00                	mov    (%eax),%eax
  802b48:	85 c0                	test   %eax,%eax
  802b4a:	75 08                	jne    802b54 <alloc_block_FF+0x269>
  802b4c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b4f:	a3 34 50 80 00       	mov    %eax,0x805034
  802b54:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b59:	40                   	inc    %eax
  802b5a:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802b5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b63:	75 17                	jne    802b7c <alloc_block_FF+0x291>
  802b65:	83 ec 04             	sub    $0x4,%esp
  802b68:	68 37 4b 80 00       	push   $0x804b37
  802b6d:	68 e1 00 00 00       	push   $0xe1
  802b72:	68 55 4b 80 00       	push   $0x804b55
  802b77:	e8 34 dc ff ff       	call   8007b0 <_panic>
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	74 10                	je     802b95 <alloc_block_FF+0x2aa>
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8d:	8b 52 04             	mov    0x4(%edx),%edx
  802b90:	89 50 04             	mov    %edx,0x4(%eax)
  802b93:	eb 0b                	jmp    802ba0 <alloc_block_FF+0x2b5>
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 40 04             	mov    0x4(%eax),%eax
  802b9b:	a3 34 50 80 00       	mov    %eax,0x805034
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 40 04             	mov    0x4(%eax),%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	74 0f                	je     802bb9 <alloc_block_FF+0x2ce>
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 40 04             	mov    0x4(%eax),%eax
  802bb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb3:	8b 12                	mov    (%edx),%edx
  802bb5:	89 10                	mov    %edx,(%eax)
  802bb7:	eb 0a                	jmp    802bc3 <alloc_block_FF+0x2d8>
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 00                	mov    (%eax),%eax
  802bbe:	a3 30 50 80 00       	mov    %eax,0x805030
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bdb:	48                   	dec    %eax
  802bdc:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802be1:	83 ec 04             	sub    $0x4,%esp
  802be4:	6a 00                	push   $0x0
  802be6:	ff 75 b4             	pushl  -0x4c(%ebp)
  802be9:	ff 75 b0             	pushl  -0x50(%ebp)
  802bec:	e8 cb fc ff ff       	call   8028bc <set_block_data>
  802bf1:	83 c4 10             	add    $0x10,%esp
  802bf4:	e9 95 00 00 00       	jmp    802c8e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802bf9:	83 ec 04             	sub    $0x4,%esp
  802bfc:	6a 01                	push   $0x1
  802bfe:	ff 75 b8             	pushl  -0x48(%ebp)
  802c01:	ff 75 bc             	pushl  -0x44(%ebp)
  802c04:	e8 b3 fc ff ff       	call   8028bc <set_block_data>
  802c09:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802c0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c10:	75 17                	jne    802c29 <alloc_block_FF+0x33e>
  802c12:	83 ec 04             	sub    $0x4,%esp
  802c15:	68 37 4b 80 00       	push   $0x804b37
  802c1a:	68 e8 00 00 00       	push   $0xe8
  802c1f:	68 55 4b 80 00       	push   $0x804b55
  802c24:	e8 87 db ff ff       	call   8007b0 <_panic>
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	85 c0                	test   %eax,%eax
  802c30:	74 10                	je     802c42 <alloc_block_FF+0x357>
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3a:	8b 52 04             	mov    0x4(%edx),%edx
  802c3d:	89 50 04             	mov    %edx,0x4(%eax)
  802c40:	eb 0b                	jmp    802c4d <alloc_block_FF+0x362>
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 40 04             	mov    0x4(%eax),%eax
  802c48:	a3 34 50 80 00       	mov    %eax,0x805034
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	85 c0                	test   %eax,%eax
  802c55:	74 0f                	je     802c66 <alloc_block_FF+0x37b>
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 40 04             	mov    0x4(%eax),%eax
  802c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c60:	8b 12                	mov    (%edx),%edx
  802c62:	89 10                	mov    %edx,(%eax)
  802c64:	eb 0a                	jmp    802c70 <alloc_block_FF+0x385>
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	a3 30 50 80 00       	mov    %eax,0x805030
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c83:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c88:	48                   	dec    %eax
  802c89:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802c8e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c91:	e9 0f 01 00 00       	jmp    802da5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802c96:	a1 38 50 80 00       	mov    0x805038,%eax
  802c9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca2:	74 07                	je     802cab <alloc_block_FF+0x3c0>
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 00                	mov    (%eax),%eax
  802ca9:	eb 05                	jmp    802cb0 <alloc_block_FF+0x3c5>
  802cab:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb0:	a3 38 50 80 00       	mov    %eax,0x805038
  802cb5:	a1 38 50 80 00       	mov    0x805038,%eax
  802cba:	85 c0                	test   %eax,%eax
  802cbc:	0f 85 e9 fc ff ff    	jne    8029ab <alloc_block_FF+0xc0>
  802cc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc6:	0f 85 df fc ff ff    	jne    8029ab <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	83 c0 08             	add    $0x8,%eax
  802cd2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cd5:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802cdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cdf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ce2:	01 d0                	add    %edx,%eax
  802ce4:	48                   	dec    %eax
  802ce5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802ce8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf0:	f7 75 d8             	divl   -0x28(%ebp)
  802cf3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cf6:	29 d0                	sub    %edx,%eax
  802cf8:	c1 e8 0c             	shr    $0xc,%eax
  802cfb:	83 ec 0c             	sub    $0xc,%esp
  802cfe:	50                   	push   %eax
  802cff:	e8 0b ed ff ff       	call   801a0f <sbrk>
  802d04:	83 c4 10             	add    $0x10,%esp
  802d07:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802d0a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d0e:	75 0a                	jne    802d1a <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802d10:	b8 00 00 00 00       	mov    $0x0,%eax
  802d15:	e9 8b 00 00 00       	jmp    802da5 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d1a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d21:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d24:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d27:	01 d0                	add    %edx,%eax
  802d29:	48                   	dec    %eax
  802d2a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802d2d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d30:	ba 00 00 00 00       	mov    $0x0,%edx
  802d35:	f7 75 cc             	divl   -0x34(%ebp)
  802d38:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d3b:	29 d0                	sub    %edx,%eax
  802d3d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d40:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d43:	01 d0                	add    %edx,%eax
  802d45:	a3 48 50 80 00       	mov    %eax,0x805048
			end_block->info = 1;
  802d4a:	a1 48 50 80 00       	mov    0x805048,%eax
  802d4f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d55:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802d5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d5f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d62:	01 d0                	add    %edx,%eax
  802d64:	48                   	dec    %eax
  802d65:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802d68:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d70:	f7 75 c4             	divl   -0x3c(%ebp)
  802d73:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d76:	29 d0                	sub    %edx,%eax
  802d78:	83 ec 04             	sub    $0x4,%esp
  802d7b:	6a 01                	push   $0x1
  802d7d:	50                   	push   %eax
  802d7e:	ff 75 d0             	pushl  -0x30(%ebp)
  802d81:	e8 36 fb ff ff       	call   8028bc <set_block_data>
  802d86:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802d89:	83 ec 0c             	sub    $0xc,%esp
  802d8c:	ff 75 d0             	pushl  -0x30(%ebp)
  802d8f:	e8 f8 09 00 00       	call   80378c <free_block>
  802d94:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802d97:	83 ec 0c             	sub    $0xc,%esp
  802d9a:	ff 75 08             	pushl  0x8(%ebp)
  802d9d:	e8 49 fb ff ff       	call   8028eb <alloc_block_FF>
  802da2:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802da5:	c9                   	leave  
  802da6:	c3                   	ret    

00802da7 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802da7:	55                   	push   %ebp
  802da8:	89 e5                	mov    %esp,%ebp
  802daa:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	83 e0 01             	and    $0x1,%eax
  802db3:	85 c0                	test   %eax,%eax
  802db5:	74 03                	je     802dba <alloc_block_BF+0x13>
  802db7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802dba:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802dbe:	77 07                	ja     802dc7 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802dc0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802dc7:	a1 28 50 80 00       	mov    0x805028,%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	75 73                	jne    802e43 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	83 c0 10             	add    $0x10,%eax
  802dd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802dd9:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802de0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802de3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802de6:	01 d0                	add    %edx,%eax
  802de8:	48                   	dec    %eax
  802de9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802dec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802def:	ba 00 00 00 00       	mov    $0x0,%edx
  802df4:	f7 75 e0             	divl   -0x20(%ebp)
  802df7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dfa:	29 d0                	sub    %edx,%eax
  802dfc:	c1 e8 0c             	shr    $0xc,%eax
  802dff:	83 ec 0c             	sub    $0xc,%esp
  802e02:	50                   	push   %eax
  802e03:	e8 07 ec ff ff       	call   801a0f <sbrk>
  802e08:	83 c4 10             	add    $0x10,%esp
  802e0b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802e0e:	83 ec 0c             	sub    $0xc,%esp
  802e11:	6a 00                	push   $0x0
  802e13:	e8 f7 eb ff ff       	call   801a0f <sbrk>
  802e18:	83 c4 10             	add    $0x10,%esp
  802e1b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802e1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e21:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802e24:	83 ec 08             	sub    $0x8,%esp
  802e27:	50                   	push   %eax
  802e28:	ff 75 d8             	pushl  -0x28(%ebp)
  802e2b:	e8 9f f8 ff ff       	call   8026cf <initialize_dynamic_allocator>
  802e30:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802e33:	83 ec 0c             	sub    $0xc,%esp
  802e36:	68 93 4b 80 00       	push   $0x804b93
  802e3b:	e8 2d dc ff ff       	call   800a6d <cprintf>
  802e40:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802e43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802e4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802e51:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802e58:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802e5f:	a1 30 50 80 00       	mov    0x805030,%eax
  802e64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e67:	e9 1d 01 00 00       	jmp    802f89 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802e72:	83 ec 0c             	sub    $0xc,%esp
  802e75:	ff 75 a8             	pushl  -0x58(%ebp)
  802e78:	e8 ee f6 ff ff       	call   80256b <get_block_size>
  802e7d:	83 c4 10             	add    $0x10,%esp
  802e80:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	83 c0 08             	add    $0x8,%eax
  802e89:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e8c:	0f 87 ef 00 00 00    	ja     802f81 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	83 c0 18             	add    $0x18,%eax
  802e98:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802e9b:	77 1d                	ja     802eba <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802e9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ea3:	0f 86 d8 00 00 00    	jbe    802f81 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802ea9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802eaf:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802eb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802eb5:	e9 c7 00 00 00       	jmp    802f81 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	83 c0 08             	add    $0x8,%eax
  802ec0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802ec3:	0f 85 9d 00 00 00    	jne    802f66 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802ec9:	83 ec 04             	sub    $0x4,%esp
  802ecc:	6a 01                	push   $0x1
  802ece:	ff 75 a4             	pushl  -0x5c(%ebp)
  802ed1:	ff 75 a8             	pushl  -0x58(%ebp)
  802ed4:	e8 e3 f9 ff ff       	call   8028bc <set_block_data>
  802ed9:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee0:	75 17                	jne    802ef9 <alloc_block_BF+0x152>
  802ee2:	83 ec 04             	sub    $0x4,%esp
  802ee5:	68 37 4b 80 00       	push   $0x804b37
  802eea:	68 2c 01 00 00       	push   $0x12c
  802eef:	68 55 4b 80 00       	push   $0x804b55
  802ef4:	e8 b7 d8 ff ff       	call   8007b0 <_panic>
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	85 c0                	test   %eax,%eax
  802f00:	74 10                	je     802f12 <alloc_block_BF+0x16b>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 00                	mov    (%eax),%eax
  802f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0a:	8b 52 04             	mov    0x4(%edx),%edx
  802f0d:	89 50 04             	mov    %edx,0x4(%eax)
  802f10:	eb 0b                	jmp    802f1d <alloc_block_BF+0x176>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 40 04             	mov    0x4(%eax),%eax
  802f18:	a3 34 50 80 00       	mov    %eax,0x805034
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 40 04             	mov    0x4(%eax),%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	74 0f                	je     802f36 <alloc_block_BF+0x18f>
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 40 04             	mov    0x4(%eax),%eax
  802f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f30:	8b 12                	mov    (%edx),%edx
  802f32:	89 10                	mov    %edx,(%eax)
  802f34:	eb 0a                	jmp    802f40 <alloc_block_BF+0x199>
  802f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f39:	8b 00                	mov    (%eax),%eax
  802f3b:	a3 30 50 80 00       	mov    %eax,0x805030
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f53:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f58:	48                   	dec    %eax
  802f59:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802f5e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f61:	e9 01 04 00 00       	jmp    803367 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f69:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802f6c:	76 13                	jbe    802f81 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802f6e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802f75:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802f7b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802f7e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802f81:	a1 38 50 80 00       	mov    0x805038,%eax
  802f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8d:	74 07                	je     802f96 <alloc_block_BF+0x1ef>
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	8b 00                	mov    (%eax),%eax
  802f94:	eb 05                	jmp    802f9b <alloc_block_BF+0x1f4>
  802f96:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9b:	a3 38 50 80 00       	mov    %eax,0x805038
  802fa0:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa5:	85 c0                	test   %eax,%eax
  802fa7:	0f 85 bf fe ff ff    	jne    802e6c <alloc_block_BF+0xc5>
  802fad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb1:	0f 85 b5 fe ff ff    	jne    802e6c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802fb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fbb:	0f 84 26 02 00 00    	je     8031e7 <alloc_block_BF+0x440>
  802fc1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fc5:	0f 85 1c 02 00 00    	jne    8031e7 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802fcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fce:	2b 45 08             	sub    0x8(%ebp),%eax
  802fd1:	83 e8 08             	sub    $0x8,%eax
  802fd4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	8d 50 08             	lea    0x8(%eax),%edx
  802fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe0:	01 d0                	add    %edx,%eax
  802fe2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	83 c0 08             	add    $0x8,%eax
  802feb:	83 ec 04             	sub    $0x4,%esp
  802fee:	6a 01                	push   $0x1
  802ff0:	50                   	push   %eax
  802ff1:	ff 75 f0             	pushl  -0x10(%ebp)
  802ff4:	e8 c3 f8 ff ff       	call   8028bc <set_block_data>
  802ff9:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fff:	8b 40 04             	mov    0x4(%eax),%eax
  803002:	85 c0                	test   %eax,%eax
  803004:	75 68                	jne    80306e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  803006:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80300a:	75 17                	jne    803023 <alloc_block_BF+0x27c>
  80300c:	83 ec 04             	sub    $0x4,%esp
  80300f:	68 70 4b 80 00       	push   $0x804b70
  803014:	68 45 01 00 00       	push   $0x145
  803019:	68 55 4b 80 00       	push   $0x804b55
  80301e:	e8 8d d7 ff ff       	call   8007b0 <_panic>
  803023:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803029:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80302c:	89 10                	mov    %edx,(%eax)
  80302e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803031:	8b 00                	mov    (%eax),%eax
  803033:	85 c0                	test   %eax,%eax
  803035:	74 0d                	je     803044 <alloc_block_BF+0x29d>
  803037:	a1 30 50 80 00       	mov    0x805030,%eax
  80303c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80303f:	89 50 04             	mov    %edx,0x4(%eax)
  803042:	eb 08                	jmp    80304c <alloc_block_BF+0x2a5>
  803044:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803047:	a3 34 50 80 00       	mov    %eax,0x805034
  80304c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80304f:	a3 30 50 80 00       	mov    %eax,0x805030
  803054:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803057:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803063:	40                   	inc    %eax
  803064:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803069:	e9 dc 00 00 00       	jmp    80314a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80306e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	75 65                	jne    8030dc <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  803077:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80307b:	75 17                	jne    803094 <alloc_block_BF+0x2ed>
  80307d:	83 ec 04             	sub    $0x4,%esp
  803080:	68 a4 4b 80 00       	push   $0x804ba4
  803085:	68 4a 01 00 00       	push   $0x14a
  80308a:	68 55 4b 80 00       	push   $0x804b55
  80308f:	e8 1c d7 ff ff       	call   8007b0 <_panic>
  803094:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80309a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80309d:	89 50 04             	mov    %edx,0x4(%eax)
  8030a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030a3:	8b 40 04             	mov    0x4(%eax),%eax
  8030a6:	85 c0                	test   %eax,%eax
  8030a8:	74 0c                	je     8030b6 <alloc_block_BF+0x30f>
  8030aa:	a1 34 50 80 00       	mov    0x805034,%eax
  8030af:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8030b2:	89 10                	mov    %edx,(%eax)
  8030b4:	eb 08                	jmp    8030be <alloc_block_BF+0x317>
  8030b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8030be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c1:	a3 34 50 80 00       	mov    %eax,0x805034
  8030c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8030c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030cf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030d4:	40                   	inc    %eax
  8030d5:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8030da:	eb 6e                	jmp    80314a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8030dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030e0:	74 06                	je     8030e8 <alloc_block_BF+0x341>
  8030e2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8030e6:	75 17                	jne    8030ff <alloc_block_BF+0x358>
  8030e8:	83 ec 04             	sub    $0x4,%esp
  8030eb:	68 c8 4b 80 00       	push   $0x804bc8
  8030f0:	68 4f 01 00 00       	push   $0x14f
  8030f5:	68 55 4b 80 00       	push   $0x804b55
  8030fa:	e8 b1 d6 ff ff       	call   8007b0 <_panic>
  8030ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803102:	8b 10                	mov    (%eax),%edx
  803104:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803107:	89 10                	mov    %edx,(%eax)
  803109:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80310c:	8b 00                	mov    (%eax),%eax
  80310e:	85 c0                	test   %eax,%eax
  803110:	74 0b                	je     80311d <alloc_block_BF+0x376>
  803112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803115:	8b 00                	mov    (%eax),%eax
  803117:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80311a:	89 50 04             	mov    %edx,0x4(%eax)
  80311d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803120:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803123:	89 10                	mov    %edx,(%eax)
  803125:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803128:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80312b:	89 50 04             	mov    %edx,0x4(%eax)
  80312e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	85 c0                	test   %eax,%eax
  803135:	75 08                	jne    80313f <alloc_block_BF+0x398>
  803137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80313a:	a3 34 50 80 00       	mov    %eax,0x805034
  80313f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803144:	40                   	inc    %eax
  803145:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80314a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80314e:	75 17                	jne    803167 <alloc_block_BF+0x3c0>
  803150:	83 ec 04             	sub    $0x4,%esp
  803153:	68 37 4b 80 00       	push   $0x804b37
  803158:	68 51 01 00 00       	push   $0x151
  80315d:	68 55 4b 80 00       	push   $0x804b55
  803162:	e8 49 d6 ff ff       	call   8007b0 <_panic>
  803167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316a:	8b 00                	mov    (%eax),%eax
  80316c:	85 c0                	test   %eax,%eax
  80316e:	74 10                	je     803180 <alloc_block_BF+0x3d9>
  803170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803173:	8b 00                	mov    (%eax),%eax
  803175:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803178:	8b 52 04             	mov    0x4(%edx),%edx
  80317b:	89 50 04             	mov    %edx,0x4(%eax)
  80317e:	eb 0b                	jmp    80318b <alloc_block_BF+0x3e4>
  803180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803183:	8b 40 04             	mov    0x4(%eax),%eax
  803186:	a3 34 50 80 00       	mov    %eax,0x805034
  80318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318e:	8b 40 04             	mov    0x4(%eax),%eax
  803191:	85 c0                	test   %eax,%eax
  803193:	74 0f                	je     8031a4 <alloc_block_BF+0x3fd>
  803195:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803198:	8b 40 04             	mov    0x4(%eax),%eax
  80319b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80319e:	8b 12                	mov    (%edx),%edx
  8031a0:	89 10                	mov    %edx,(%eax)
  8031a2:	eb 0a                	jmp    8031ae <alloc_block_BF+0x407>
  8031a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a7:	8b 00                	mov    (%eax),%eax
  8031a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8031ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031c6:	48                   	dec    %eax
  8031c7:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  8031cc:	83 ec 04             	sub    $0x4,%esp
  8031cf:	6a 00                	push   $0x0
  8031d1:	ff 75 d0             	pushl  -0x30(%ebp)
  8031d4:	ff 75 cc             	pushl  -0x34(%ebp)
  8031d7:	e8 e0 f6 ff ff       	call   8028bc <set_block_data>
  8031dc:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8031df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e2:	e9 80 01 00 00       	jmp    803367 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  8031e7:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8031eb:	0f 85 9d 00 00 00    	jne    80328e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8031f1:	83 ec 04             	sub    $0x4,%esp
  8031f4:	6a 01                	push   $0x1
  8031f6:	ff 75 ec             	pushl  -0x14(%ebp)
  8031f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8031fc:	e8 bb f6 ff ff       	call   8028bc <set_block_data>
  803201:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  803204:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803208:	75 17                	jne    803221 <alloc_block_BF+0x47a>
  80320a:	83 ec 04             	sub    $0x4,%esp
  80320d:	68 37 4b 80 00       	push   $0x804b37
  803212:	68 58 01 00 00       	push   $0x158
  803217:	68 55 4b 80 00       	push   $0x804b55
  80321c:	e8 8f d5 ff ff       	call   8007b0 <_panic>
  803221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	85 c0                	test   %eax,%eax
  803228:	74 10                	je     80323a <alloc_block_BF+0x493>
  80322a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803232:	8b 52 04             	mov    0x4(%edx),%edx
  803235:	89 50 04             	mov    %edx,0x4(%eax)
  803238:	eb 0b                	jmp    803245 <alloc_block_BF+0x49e>
  80323a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323d:	8b 40 04             	mov    0x4(%eax),%eax
  803240:	a3 34 50 80 00       	mov    %eax,0x805034
  803245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803248:	8b 40 04             	mov    0x4(%eax),%eax
  80324b:	85 c0                	test   %eax,%eax
  80324d:	74 0f                	je     80325e <alloc_block_BF+0x4b7>
  80324f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803252:	8b 40 04             	mov    0x4(%eax),%eax
  803255:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803258:	8b 12                	mov    (%edx),%edx
  80325a:	89 10                	mov    %edx,(%eax)
  80325c:	eb 0a                	jmp    803268 <alloc_block_BF+0x4c1>
  80325e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	a3 30 50 80 00       	mov    %eax,0x805030
  803268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803274:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803280:	48                   	dec    %eax
  803281:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  803286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803289:	e9 d9 00 00 00       	jmp    803367 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	83 c0 08             	add    $0x8,%eax
  803294:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  803297:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80329e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032a1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8032a4:	01 d0                	add    %edx,%eax
  8032a6:	48                   	dec    %eax
  8032a7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8032aa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8032b2:	f7 75 c4             	divl   -0x3c(%ebp)
  8032b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8032b8:	29 d0                	sub    %edx,%eax
  8032ba:	c1 e8 0c             	shr    $0xc,%eax
  8032bd:	83 ec 0c             	sub    $0xc,%esp
  8032c0:	50                   	push   %eax
  8032c1:	e8 49 e7 ff ff       	call   801a0f <sbrk>
  8032c6:	83 c4 10             	add    $0x10,%esp
  8032c9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8032cc:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8032d0:	75 0a                	jne    8032dc <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8032d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d7:	e9 8b 00 00 00       	jmp    803367 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8032dc:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8032e3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8032e9:	01 d0                	add    %edx,%eax
  8032eb:	48                   	dec    %eax
  8032ec:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8032ef:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8032f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8032f7:	f7 75 b8             	divl   -0x48(%ebp)
  8032fa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8032fd:	29 d0                	sub    %edx,%eax
  8032ff:	8d 50 fc             	lea    -0x4(%eax),%edx
  803302:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803305:	01 d0                	add    %edx,%eax
  803307:	a3 48 50 80 00       	mov    %eax,0x805048
				end_block->info = 1;
  80330c:	a1 48 50 80 00       	mov    0x805048,%eax
  803311:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  803317:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80331e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803321:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803324:	01 d0                	add    %edx,%eax
  803326:	48                   	dec    %eax
  803327:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80332a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80332d:	ba 00 00 00 00       	mov    $0x0,%edx
  803332:	f7 75 b0             	divl   -0x50(%ebp)
  803335:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803338:	29 d0                	sub    %edx,%eax
  80333a:	83 ec 04             	sub    $0x4,%esp
  80333d:	6a 01                	push   $0x1
  80333f:	50                   	push   %eax
  803340:	ff 75 bc             	pushl  -0x44(%ebp)
  803343:	e8 74 f5 ff ff       	call   8028bc <set_block_data>
  803348:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  80334b:	83 ec 0c             	sub    $0xc,%esp
  80334e:	ff 75 bc             	pushl  -0x44(%ebp)
  803351:	e8 36 04 00 00       	call   80378c <free_block>
  803356:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  803359:	83 ec 0c             	sub    $0xc,%esp
  80335c:	ff 75 08             	pushl  0x8(%ebp)
  80335f:	e8 43 fa ff ff       	call   802da7 <alloc_block_BF>
  803364:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  803367:	c9                   	leave  
  803368:	c3                   	ret    

00803369 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  803369:	55                   	push   %ebp
  80336a:	89 e5                	mov    %esp,%ebp
  80336c:	53                   	push   %ebx
  80336d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  803370:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803377:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  80337e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803382:	74 1e                	je     8033a2 <merging+0x39>
  803384:	ff 75 08             	pushl  0x8(%ebp)
  803387:	e8 df f1 ff ff       	call   80256b <get_block_size>
  80338c:	83 c4 04             	add    $0x4,%esp
  80338f:	89 c2                	mov    %eax,%edx
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	01 d0                	add    %edx,%eax
  803396:	3b 45 10             	cmp    0x10(%ebp),%eax
  803399:	75 07                	jne    8033a2 <merging+0x39>
		prev_is_free = 1;
  80339b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8033a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8033a6:	74 1e                	je     8033c6 <merging+0x5d>
  8033a8:	ff 75 10             	pushl  0x10(%ebp)
  8033ab:	e8 bb f1 ff ff       	call   80256b <get_block_size>
  8033b0:	83 c4 04             	add    $0x4,%esp
  8033b3:	89 c2                	mov    %eax,%edx
  8033b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8033b8:	01 d0                	add    %edx,%eax
  8033ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033bd:	75 07                	jne    8033c6 <merging+0x5d>
		next_is_free = 1;
  8033bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8033c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ca:	0f 84 cc 00 00 00    	je     80349c <merging+0x133>
  8033d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033d4:	0f 84 c2 00 00 00    	je     80349c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  8033da:	ff 75 08             	pushl  0x8(%ebp)
  8033dd:	e8 89 f1 ff ff       	call   80256b <get_block_size>
  8033e2:	83 c4 04             	add    $0x4,%esp
  8033e5:	89 c3                	mov    %eax,%ebx
  8033e7:	ff 75 10             	pushl  0x10(%ebp)
  8033ea:	e8 7c f1 ff ff       	call   80256b <get_block_size>
  8033ef:	83 c4 04             	add    $0x4,%esp
  8033f2:	01 c3                	add    %eax,%ebx
  8033f4:	ff 75 0c             	pushl  0xc(%ebp)
  8033f7:	e8 6f f1 ff ff       	call   80256b <get_block_size>
  8033fc:	83 c4 04             	add    $0x4,%esp
  8033ff:	01 d8                	add    %ebx,%eax
  803401:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  803404:	6a 00                	push   $0x0
  803406:	ff 75 ec             	pushl  -0x14(%ebp)
  803409:	ff 75 08             	pushl  0x8(%ebp)
  80340c:	e8 ab f4 ff ff       	call   8028bc <set_block_data>
  803411:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  803414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803418:	75 17                	jne    803431 <merging+0xc8>
  80341a:	83 ec 04             	sub    $0x4,%esp
  80341d:	68 37 4b 80 00       	push   $0x804b37
  803422:	68 7d 01 00 00       	push   $0x17d
  803427:	68 55 4b 80 00       	push   $0x804b55
  80342c:	e8 7f d3 ff ff       	call   8007b0 <_panic>
  803431:	8b 45 0c             	mov    0xc(%ebp),%eax
  803434:	8b 00                	mov    (%eax),%eax
  803436:	85 c0                	test   %eax,%eax
  803438:	74 10                	je     80344a <merging+0xe1>
  80343a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80343d:	8b 00                	mov    (%eax),%eax
  80343f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803442:	8b 52 04             	mov    0x4(%edx),%edx
  803445:	89 50 04             	mov    %edx,0x4(%eax)
  803448:	eb 0b                	jmp    803455 <merging+0xec>
  80344a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344d:	8b 40 04             	mov    0x4(%eax),%eax
  803450:	a3 34 50 80 00       	mov    %eax,0x805034
  803455:	8b 45 0c             	mov    0xc(%ebp),%eax
  803458:	8b 40 04             	mov    0x4(%eax),%eax
  80345b:	85 c0                	test   %eax,%eax
  80345d:	74 0f                	je     80346e <merging+0x105>
  80345f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803462:	8b 40 04             	mov    0x4(%eax),%eax
  803465:	8b 55 0c             	mov    0xc(%ebp),%edx
  803468:	8b 12                	mov    (%edx),%edx
  80346a:	89 10                	mov    %edx,(%eax)
  80346c:	eb 0a                	jmp    803478 <merging+0x10f>
  80346e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803471:	8b 00                	mov    (%eax),%eax
  803473:	a3 30 50 80 00       	mov    %eax,0x805030
  803478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80347b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803481:	8b 45 0c             	mov    0xc(%ebp),%eax
  803484:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80348b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803490:	48                   	dec    %eax
  803491:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  803496:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803497:	e9 ea 02 00 00       	jmp    803786 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  80349c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a0:	74 3b                	je     8034dd <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  8034a2:	83 ec 0c             	sub    $0xc,%esp
  8034a5:	ff 75 08             	pushl  0x8(%ebp)
  8034a8:	e8 be f0 ff ff       	call   80256b <get_block_size>
  8034ad:	83 c4 10             	add    $0x10,%esp
  8034b0:	89 c3                	mov    %eax,%ebx
  8034b2:	83 ec 0c             	sub    $0xc,%esp
  8034b5:	ff 75 10             	pushl  0x10(%ebp)
  8034b8:	e8 ae f0 ff ff       	call   80256b <get_block_size>
  8034bd:	83 c4 10             	add    $0x10,%esp
  8034c0:	01 d8                	add    %ebx,%eax
  8034c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  8034c5:	83 ec 04             	sub    $0x4,%esp
  8034c8:	6a 00                	push   $0x0
  8034ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8034cd:	ff 75 08             	pushl  0x8(%ebp)
  8034d0:	e8 e7 f3 ff ff       	call   8028bc <set_block_data>
  8034d5:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  8034d8:	e9 a9 02 00 00       	jmp    803786 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  8034dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034e1:	0f 84 2d 01 00 00    	je     803614 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  8034e7:	83 ec 0c             	sub    $0xc,%esp
  8034ea:	ff 75 10             	pushl  0x10(%ebp)
  8034ed:	e8 79 f0 ff ff       	call   80256b <get_block_size>
  8034f2:	83 c4 10             	add    $0x10,%esp
  8034f5:	89 c3                	mov    %eax,%ebx
  8034f7:	83 ec 0c             	sub    $0xc,%esp
  8034fa:	ff 75 0c             	pushl  0xc(%ebp)
  8034fd:	e8 69 f0 ff ff       	call   80256b <get_block_size>
  803502:	83 c4 10             	add    $0x10,%esp
  803505:	01 d8                	add    %ebx,%eax
  803507:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  80350a:	83 ec 04             	sub    $0x4,%esp
  80350d:	6a 00                	push   $0x0
  80350f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803512:	ff 75 10             	pushl  0x10(%ebp)
  803515:	e8 a2 f3 ff ff       	call   8028bc <set_block_data>
  80351a:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  80351d:	8b 45 10             	mov    0x10(%ebp),%eax
  803520:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  803523:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803527:	74 06                	je     80352f <merging+0x1c6>
  803529:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80352d:	75 17                	jne    803546 <merging+0x1dd>
  80352f:	83 ec 04             	sub    $0x4,%esp
  803532:	68 fc 4b 80 00       	push   $0x804bfc
  803537:	68 8d 01 00 00       	push   $0x18d
  80353c:	68 55 4b 80 00       	push   $0x804b55
  803541:	e8 6a d2 ff ff       	call   8007b0 <_panic>
  803546:	8b 45 0c             	mov    0xc(%ebp),%eax
  803549:	8b 50 04             	mov    0x4(%eax),%edx
  80354c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80354f:	89 50 04             	mov    %edx,0x4(%eax)
  803552:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803555:	8b 55 0c             	mov    0xc(%ebp),%edx
  803558:	89 10                	mov    %edx,(%eax)
  80355a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355d:	8b 40 04             	mov    0x4(%eax),%eax
  803560:	85 c0                	test   %eax,%eax
  803562:	74 0d                	je     803571 <merging+0x208>
  803564:	8b 45 0c             	mov    0xc(%ebp),%eax
  803567:	8b 40 04             	mov    0x4(%eax),%eax
  80356a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80356d:	89 10                	mov    %edx,(%eax)
  80356f:	eb 08                	jmp    803579 <merging+0x210>
  803571:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803574:	a3 30 50 80 00       	mov    %eax,0x805030
  803579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80357c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80357f:	89 50 04             	mov    %edx,0x4(%eax)
  803582:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803587:	40                   	inc    %eax
  803588:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  80358d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803591:	75 17                	jne    8035aa <merging+0x241>
  803593:	83 ec 04             	sub    $0x4,%esp
  803596:	68 37 4b 80 00       	push   $0x804b37
  80359b:	68 8e 01 00 00       	push   $0x18e
  8035a0:	68 55 4b 80 00       	push   $0x804b55
  8035a5:	e8 06 d2 ff ff       	call   8007b0 <_panic>
  8035aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ad:	8b 00                	mov    (%eax),%eax
  8035af:	85 c0                	test   %eax,%eax
  8035b1:	74 10                	je     8035c3 <merging+0x25a>
  8035b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035b6:	8b 00                	mov    (%eax),%eax
  8035b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035bb:	8b 52 04             	mov    0x4(%edx),%edx
  8035be:	89 50 04             	mov    %edx,0x4(%eax)
  8035c1:	eb 0b                	jmp    8035ce <merging+0x265>
  8035c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c6:	8b 40 04             	mov    0x4(%eax),%eax
  8035c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8035ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d1:	8b 40 04             	mov    0x4(%eax),%eax
  8035d4:	85 c0                	test   %eax,%eax
  8035d6:	74 0f                	je     8035e7 <merging+0x27e>
  8035d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035db:	8b 40 04             	mov    0x4(%eax),%eax
  8035de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035e1:	8b 12                	mov    (%edx),%edx
  8035e3:	89 10                	mov    %edx,(%eax)
  8035e5:	eb 0a                	jmp    8035f1 <merging+0x288>
  8035e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ea:	8b 00                	mov    (%eax),%eax
  8035ec:	a3 30 50 80 00       	mov    %eax,0x805030
  8035f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803604:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803609:	48                   	dec    %eax
  80360a:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80360f:	e9 72 01 00 00       	jmp    803786 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803614:	8b 45 10             	mov    0x10(%ebp),%eax
  803617:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  80361a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80361e:	74 79                	je     803699 <merging+0x330>
  803620:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803624:	74 73                	je     803699 <merging+0x330>
  803626:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80362a:	74 06                	je     803632 <merging+0x2c9>
  80362c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803630:	75 17                	jne    803649 <merging+0x2e0>
  803632:	83 ec 04             	sub    $0x4,%esp
  803635:	68 c8 4b 80 00       	push   $0x804bc8
  80363a:	68 94 01 00 00       	push   $0x194
  80363f:	68 55 4b 80 00       	push   $0x804b55
  803644:	e8 67 d1 ff ff       	call   8007b0 <_panic>
  803649:	8b 45 08             	mov    0x8(%ebp),%eax
  80364c:	8b 10                	mov    (%eax),%edx
  80364e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803651:	89 10                	mov    %edx,(%eax)
  803653:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803656:	8b 00                	mov    (%eax),%eax
  803658:	85 c0                	test   %eax,%eax
  80365a:	74 0b                	je     803667 <merging+0x2fe>
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	8b 00                	mov    (%eax),%eax
  803661:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803664:	89 50 04             	mov    %edx,0x4(%eax)
  803667:	8b 45 08             	mov    0x8(%ebp),%eax
  80366a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80366d:	89 10                	mov    %edx,(%eax)
  80366f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803672:	8b 55 08             	mov    0x8(%ebp),%edx
  803675:	89 50 04             	mov    %edx,0x4(%eax)
  803678:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80367b:	8b 00                	mov    (%eax),%eax
  80367d:	85 c0                	test   %eax,%eax
  80367f:	75 08                	jne    803689 <merging+0x320>
  803681:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803684:	a3 34 50 80 00       	mov    %eax,0x805034
  803689:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80368e:	40                   	inc    %eax
  80368f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803694:	e9 ce 00 00 00       	jmp    803767 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803699:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80369d:	74 65                	je     803704 <merging+0x39b>
  80369f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8036a3:	75 17                	jne    8036bc <merging+0x353>
  8036a5:	83 ec 04             	sub    $0x4,%esp
  8036a8:	68 a4 4b 80 00       	push   $0x804ba4
  8036ad:	68 95 01 00 00       	push   $0x195
  8036b2:	68 55 4b 80 00       	push   $0x804b55
  8036b7:	e8 f4 d0 ff ff       	call   8007b0 <_panic>
  8036bc:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8036c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036c5:	89 50 04             	mov    %edx,0x4(%eax)
  8036c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036cb:	8b 40 04             	mov    0x4(%eax),%eax
  8036ce:	85 c0                	test   %eax,%eax
  8036d0:	74 0c                	je     8036de <merging+0x375>
  8036d2:	a1 34 50 80 00       	mov    0x805034,%eax
  8036d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036da:	89 10                	mov    %edx,(%eax)
  8036dc:	eb 08                	jmp    8036e6 <merging+0x37d>
  8036de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036e9:	a3 34 50 80 00       	mov    %eax,0x805034
  8036ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8036f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036fc:	40                   	inc    %eax
  8036fd:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803702:	eb 63                	jmp    803767 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803704:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803708:	75 17                	jne    803721 <merging+0x3b8>
  80370a:	83 ec 04             	sub    $0x4,%esp
  80370d:	68 70 4b 80 00       	push   $0x804b70
  803712:	68 98 01 00 00       	push   $0x198
  803717:	68 55 4b 80 00       	push   $0x804b55
  80371c:	e8 8f d0 ff ff       	call   8007b0 <_panic>
  803721:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803727:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80372a:	89 10                	mov    %edx,(%eax)
  80372c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	85 c0                	test   %eax,%eax
  803733:	74 0d                	je     803742 <merging+0x3d9>
  803735:	a1 30 50 80 00       	mov    0x805030,%eax
  80373a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80373d:	89 50 04             	mov    %edx,0x4(%eax)
  803740:	eb 08                	jmp    80374a <merging+0x3e1>
  803742:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803745:	a3 34 50 80 00       	mov    %eax,0x805034
  80374a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80374d:	a3 30 50 80 00       	mov    %eax,0x805030
  803752:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803755:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803761:	40                   	inc    %eax
  803762:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803767:	83 ec 0c             	sub    $0xc,%esp
  80376a:	ff 75 10             	pushl  0x10(%ebp)
  80376d:	e8 f9 ed ff ff       	call   80256b <get_block_size>
  803772:	83 c4 10             	add    $0x10,%esp
  803775:	83 ec 04             	sub    $0x4,%esp
  803778:	6a 00                	push   $0x0
  80377a:	50                   	push   %eax
  80377b:	ff 75 10             	pushl  0x10(%ebp)
  80377e:	e8 39 f1 ff ff       	call   8028bc <set_block_data>
  803783:	83 c4 10             	add    $0x10,%esp
	}
}
  803786:	90                   	nop
  803787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80378a:	c9                   	leave  
  80378b:	c3                   	ret    

0080378c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80378c:	55                   	push   %ebp
  80378d:	89 e5                	mov    %esp,%ebp
  80378f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803792:	a1 30 50 80 00       	mov    0x805030,%eax
  803797:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80379a:	a1 34 50 80 00       	mov    0x805034,%eax
  80379f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037a2:	73 1b                	jae    8037bf <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8037a4:	a1 34 50 80 00       	mov    0x805034,%eax
  8037a9:	83 ec 04             	sub    $0x4,%esp
  8037ac:	ff 75 08             	pushl  0x8(%ebp)
  8037af:	6a 00                	push   $0x0
  8037b1:	50                   	push   %eax
  8037b2:	e8 b2 fb ff ff       	call   803369 <merging>
  8037b7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037ba:	e9 8b 00 00 00       	jmp    80384a <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8037bf:	a1 30 50 80 00       	mov    0x805030,%eax
  8037c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037c7:	76 18                	jbe    8037e1 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8037c9:	a1 30 50 80 00       	mov    0x805030,%eax
  8037ce:	83 ec 04             	sub    $0x4,%esp
  8037d1:	ff 75 08             	pushl  0x8(%ebp)
  8037d4:	50                   	push   %eax
  8037d5:	6a 00                	push   $0x0
  8037d7:	e8 8d fb ff ff       	call   803369 <merging>
  8037dc:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8037df:	eb 69                	jmp    80384a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8037e1:	a1 30 50 80 00       	mov    0x805030,%eax
  8037e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037e9:	eb 39                	jmp    803824 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8037eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037f1:	73 29                	jae    80381c <free_block+0x90>
  8037f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f6:	8b 00                	mov    (%eax),%eax
  8037f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037fb:	76 1f                	jbe    80381c <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8037fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803800:	8b 00                	mov    (%eax),%eax
  803802:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803805:	83 ec 04             	sub    $0x4,%esp
  803808:	ff 75 08             	pushl  0x8(%ebp)
  80380b:	ff 75 f0             	pushl  -0x10(%ebp)
  80380e:	ff 75 f4             	pushl  -0xc(%ebp)
  803811:	e8 53 fb ff ff       	call   803369 <merging>
  803816:	83 c4 10             	add    $0x10,%esp
			break;
  803819:	90                   	nop
		}
	}
}
  80381a:	eb 2e                	jmp    80384a <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80381c:	a1 38 50 80 00       	mov    0x805038,%eax
  803821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803824:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803828:	74 07                	je     803831 <free_block+0xa5>
  80382a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382d:	8b 00                	mov    (%eax),%eax
  80382f:	eb 05                	jmp    803836 <free_block+0xaa>
  803831:	b8 00 00 00 00       	mov    $0x0,%eax
  803836:	a3 38 50 80 00       	mov    %eax,0x805038
  80383b:	a1 38 50 80 00       	mov    0x805038,%eax
  803840:	85 c0                	test   %eax,%eax
  803842:	75 a7                	jne    8037eb <free_block+0x5f>
  803844:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803848:	75 a1                	jne    8037eb <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80384a:	90                   	nop
  80384b:	c9                   	leave  
  80384c:	c3                   	ret    

0080384d <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80384d:	55                   	push   %ebp
  80384e:	89 e5                	mov    %esp,%ebp
  803850:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803853:	ff 75 08             	pushl  0x8(%ebp)
  803856:	e8 10 ed ff ff       	call   80256b <get_block_size>
  80385b:	83 c4 04             	add    $0x4,%esp
  80385e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803861:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803868:	eb 17                	jmp    803881 <copy_data+0x34>
  80386a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80386d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803870:	01 c2                	add    %eax,%edx
  803872:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803875:	8b 45 08             	mov    0x8(%ebp),%eax
  803878:	01 c8                	add    %ecx,%eax
  80387a:	8a 00                	mov    (%eax),%al
  80387c:	88 02                	mov    %al,(%edx)
  80387e:	ff 45 fc             	incl   -0x4(%ebp)
  803881:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803884:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803887:	72 e1                	jb     80386a <copy_data+0x1d>
}
  803889:	90                   	nop
  80388a:	c9                   	leave  
  80388b:	c3                   	ret    

0080388c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80388c:	55                   	push   %ebp
  80388d:	89 e5                	mov    %esp,%ebp
  80388f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803892:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803896:	75 23                	jne    8038bb <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803898:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80389c:	74 13                	je     8038b1 <realloc_block_FF+0x25>
  80389e:	83 ec 0c             	sub    $0xc,%esp
  8038a1:	ff 75 0c             	pushl  0xc(%ebp)
  8038a4:	e8 42 f0 ff ff       	call   8028eb <alloc_block_FF>
  8038a9:	83 c4 10             	add    $0x10,%esp
  8038ac:	e9 e4 06 00 00       	jmp    803f95 <realloc_block_FF+0x709>
		return NULL;
  8038b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b6:	e9 da 06 00 00       	jmp    803f95 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8038bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8038bf:	75 18                	jne    8038d9 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8038c1:	83 ec 0c             	sub    $0xc,%esp
  8038c4:	ff 75 08             	pushl  0x8(%ebp)
  8038c7:	e8 c0 fe ff ff       	call   80378c <free_block>
  8038cc:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8038cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8038d4:	e9 bc 06 00 00       	jmp    803f95 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8038d9:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8038dd:	77 07                	ja     8038e6 <realloc_block_FF+0x5a>
  8038df:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8038e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e9:	83 e0 01             	and    $0x1,%eax
  8038ec:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8038ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f2:	83 c0 08             	add    $0x8,%eax
  8038f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8038f8:	83 ec 0c             	sub    $0xc,%esp
  8038fb:	ff 75 08             	pushl  0x8(%ebp)
  8038fe:	e8 68 ec ff ff       	call   80256b <get_block_size>
  803903:	83 c4 10             	add    $0x10,%esp
  803906:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803909:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80390c:	83 e8 08             	sub    $0x8,%eax
  80390f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803912:	8b 45 08             	mov    0x8(%ebp),%eax
  803915:	83 e8 04             	sub    $0x4,%eax
  803918:	8b 00                	mov    (%eax),%eax
  80391a:	83 e0 fe             	and    $0xfffffffe,%eax
  80391d:	89 c2                	mov    %eax,%edx
  80391f:	8b 45 08             	mov    0x8(%ebp),%eax
  803922:	01 d0                	add    %edx,%eax
  803924:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803927:	83 ec 0c             	sub    $0xc,%esp
  80392a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80392d:	e8 39 ec ff ff       	call   80256b <get_block_size>
  803932:	83 c4 10             	add    $0x10,%esp
  803935:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803938:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80393b:	83 e8 08             	sub    $0x8,%eax
  80393e:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803941:	8b 45 0c             	mov    0xc(%ebp),%eax
  803944:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803947:	75 08                	jne    803951 <realloc_block_FF+0xc5>
	{
		 return va;
  803949:	8b 45 08             	mov    0x8(%ebp),%eax
  80394c:	e9 44 06 00 00       	jmp    803f95 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803951:	8b 45 0c             	mov    0xc(%ebp),%eax
  803954:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803957:	0f 83 d5 03 00 00    	jae    803d32 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80395d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803960:	2b 45 0c             	sub    0xc(%ebp),%eax
  803963:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803966:	83 ec 0c             	sub    $0xc,%esp
  803969:	ff 75 e4             	pushl  -0x1c(%ebp)
  80396c:	e8 13 ec ff ff       	call   802584 <is_free_block>
  803971:	83 c4 10             	add    $0x10,%esp
  803974:	84 c0                	test   %al,%al
  803976:	0f 84 3b 01 00 00    	je     803ab7 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80397c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80397f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803982:	01 d0                	add    %edx,%eax
  803984:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803987:	83 ec 04             	sub    $0x4,%esp
  80398a:	6a 01                	push   $0x1
  80398c:	ff 75 f0             	pushl  -0x10(%ebp)
  80398f:	ff 75 08             	pushl  0x8(%ebp)
  803992:	e8 25 ef ff ff       	call   8028bc <set_block_data>
  803997:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80399a:	8b 45 08             	mov    0x8(%ebp),%eax
  80399d:	83 e8 04             	sub    $0x4,%eax
  8039a0:	8b 00                	mov    (%eax),%eax
  8039a2:	83 e0 fe             	and    $0xfffffffe,%eax
  8039a5:	89 c2                	mov    %eax,%edx
  8039a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039aa:	01 d0                	add    %edx,%eax
  8039ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8039af:	83 ec 04             	sub    $0x4,%esp
  8039b2:	6a 00                	push   $0x0
  8039b4:	ff 75 cc             	pushl  -0x34(%ebp)
  8039b7:	ff 75 c8             	pushl  -0x38(%ebp)
  8039ba:	e8 fd ee ff ff       	call   8028bc <set_block_data>
  8039bf:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8039c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039c6:	74 06                	je     8039ce <realloc_block_FF+0x142>
  8039c8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8039cc:	75 17                	jne    8039e5 <realloc_block_FF+0x159>
  8039ce:	83 ec 04             	sub    $0x4,%esp
  8039d1:	68 c8 4b 80 00       	push   $0x804bc8
  8039d6:	68 f6 01 00 00       	push   $0x1f6
  8039db:	68 55 4b 80 00       	push   $0x804b55
  8039e0:	e8 cb cd ff ff       	call   8007b0 <_panic>
  8039e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e8:	8b 10                	mov    (%eax),%edx
  8039ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039ed:	89 10                	mov    %edx,(%eax)
  8039ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8039f2:	8b 00                	mov    (%eax),%eax
  8039f4:	85 c0                	test   %eax,%eax
  8039f6:	74 0b                	je     803a03 <realloc_block_FF+0x177>
  8039f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fb:	8b 00                	mov    (%eax),%eax
  8039fd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a00:	89 50 04             	mov    %edx,0x4(%eax)
  803a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a06:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803a09:	89 10                	mov    %edx,(%eax)
  803a0b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a11:	89 50 04             	mov    %edx,0x4(%eax)
  803a14:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a17:	8b 00                	mov    (%eax),%eax
  803a19:	85 c0                	test   %eax,%eax
  803a1b:	75 08                	jne    803a25 <realloc_block_FF+0x199>
  803a1d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803a20:	a3 34 50 80 00       	mov    %eax,0x805034
  803a25:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803a2a:	40                   	inc    %eax
  803a2b:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a34:	75 17                	jne    803a4d <realloc_block_FF+0x1c1>
  803a36:	83 ec 04             	sub    $0x4,%esp
  803a39:	68 37 4b 80 00       	push   $0x804b37
  803a3e:	68 f7 01 00 00       	push   $0x1f7
  803a43:	68 55 4b 80 00       	push   $0x804b55
  803a48:	e8 63 cd ff ff       	call   8007b0 <_panic>
  803a4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a50:	8b 00                	mov    (%eax),%eax
  803a52:	85 c0                	test   %eax,%eax
  803a54:	74 10                	je     803a66 <realloc_block_FF+0x1da>
  803a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a59:	8b 00                	mov    (%eax),%eax
  803a5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a5e:	8b 52 04             	mov    0x4(%edx),%edx
  803a61:	89 50 04             	mov    %edx,0x4(%eax)
  803a64:	eb 0b                	jmp    803a71 <realloc_block_FF+0x1e5>
  803a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a69:	8b 40 04             	mov    0x4(%eax),%eax
  803a6c:	a3 34 50 80 00       	mov    %eax,0x805034
  803a71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a74:	8b 40 04             	mov    0x4(%eax),%eax
  803a77:	85 c0                	test   %eax,%eax
  803a79:	74 0f                	je     803a8a <realloc_block_FF+0x1fe>
  803a7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a7e:	8b 40 04             	mov    0x4(%eax),%eax
  803a81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a84:	8b 12                	mov    (%edx),%edx
  803a86:	89 10                	mov    %edx,(%eax)
  803a88:	eb 0a                	jmp    803a94 <realloc_block_FF+0x208>
  803a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a8d:	8b 00                	mov    (%eax),%eax
  803a8f:	a3 30 50 80 00       	mov    %eax,0x805030
  803a94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aa7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803aac:	48                   	dec    %eax
  803aad:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803ab2:	e9 73 02 00 00       	jmp    803d2a <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803ab7:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803abb:	0f 86 69 02 00 00    	jbe    803d2a <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803ac1:	83 ec 04             	sub    $0x4,%esp
  803ac4:	6a 01                	push   $0x1
  803ac6:	ff 75 f0             	pushl  -0x10(%ebp)
  803ac9:	ff 75 08             	pushl  0x8(%ebp)
  803acc:	e8 eb ed ff ff       	call   8028bc <set_block_data>
  803ad1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad7:	83 e8 04             	sub    $0x4,%eax
  803ada:	8b 00                	mov    (%eax),%eax
  803adc:	83 e0 fe             	and    $0xfffffffe,%eax
  803adf:	89 c2                	mov    %eax,%edx
  803ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae4:	01 d0                	add    %edx,%eax
  803ae6:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803ae9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803aee:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803af1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803af5:	75 68                	jne    803b5f <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803af7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803afb:	75 17                	jne    803b14 <realloc_block_FF+0x288>
  803afd:	83 ec 04             	sub    $0x4,%esp
  803b00:	68 70 4b 80 00       	push   $0x804b70
  803b05:	68 06 02 00 00       	push   $0x206
  803b0a:	68 55 4b 80 00       	push   $0x804b55
  803b0f:	e8 9c cc ff ff       	call   8007b0 <_panic>
  803b14:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b1d:	89 10                	mov    %edx,(%eax)
  803b1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b22:	8b 00                	mov    (%eax),%eax
  803b24:	85 c0                	test   %eax,%eax
  803b26:	74 0d                	je     803b35 <realloc_block_FF+0x2a9>
  803b28:	a1 30 50 80 00       	mov    0x805030,%eax
  803b2d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b30:	89 50 04             	mov    %edx,0x4(%eax)
  803b33:	eb 08                	jmp    803b3d <realloc_block_FF+0x2b1>
  803b35:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b38:	a3 34 50 80 00       	mov    %eax,0x805034
  803b3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b40:	a3 30 50 80 00       	mov    %eax,0x805030
  803b45:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b4f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803b54:	40                   	inc    %eax
  803b55:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803b5a:	e9 b0 01 00 00       	jmp    803d0f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803b5f:	a1 30 50 80 00       	mov    0x805030,%eax
  803b64:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803b67:	76 68                	jbe    803bd1 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803b69:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803b6d:	75 17                	jne    803b86 <realloc_block_FF+0x2fa>
  803b6f:	83 ec 04             	sub    $0x4,%esp
  803b72:	68 70 4b 80 00       	push   $0x804b70
  803b77:	68 0b 02 00 00       	push   $0x20b
  803b7c:	68 55 4b 80 00       	push   $0x804b55
  803b81:	e8 2a cc ff ff       	call   8007b0 <_panic>
  803b86:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803b8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b8f:	89 10                	mov    %edx,(%eax)
  803b91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b94:	8b 00                	mov    (%eax),%eax
  803b96:	85 c0                	test   %eax,%eax
  803b98:	74 0d                	je     803ba7 <realloc_block_FF+0x31b>
  803b9a:	a1 30 50 80 00       	mov    0x805030,%eax
  803b9f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ba2:	89 50 04             	mov    %edx,0x4(%eax)
  803ba5:	eb 08                	jmp    803baf <realloc_block_FF+0x323>
  803ba7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803baa:	a3 34 50 80 00       	mov    %eax,0x805034
  803baf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bb2:	a3 30 50 80 00       	mov    %eax,0x805030
  803bb7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803bba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bc1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803bc6:	40                   	inc    %eax
  803bc7:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803bcc:	e9 3e 01 00 00       	jmp    803d0f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803bd1:	a1 30 50 80 00       	mov    0x805030,%eax
  803bd6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803bd9:	73 68                	jae    803c43 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803bdb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803bdf:	75 17                	jne    803bf8 <realloc_block_FF+0x36c>
  803be1:	83 ec 04             	sub    $0x4,%esp
  803be4:	68 a4 4b 80 00       	push   $0x804ba4
  803be9:	68 10 02 00 00       	push   $0x210
  803bee:	68 55 4b 80 00       	push   $0x804b55
  803bf3:	e8 b8 cb ff ff       	call   8007b0 <_panic>
  803bf8:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803bfe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c01:	89 50 04             	mov    %edx,0x4(%eax)
  803c04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c07:	8b 40 04             	mov    0x4(%eax),%eax
  803c0a:	85 c0                	test   %eax,%eax
  803c0c:	74 0c                	je     803c1a <realloc_block_FF+0x38e>
  803c0e:	a1 34 50 80 00       	mov    0x805034,%eax
  803c13:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803c16:	89 10                	mov    %edx,(%eax)
  803c18:	eb 08                	jmp    803c22 <realloc_block_FF+0x396>
  803c1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c1d:	a3 30 50 80 00       	mov    %eax,0x805030
  803c22:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c25:	a3 34 50 80 00       	mov    %eax,0x805034
  803c2a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c33:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803c38:	40                   	inc    %eax
  803c39:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803c3e:	e9 cc 00 00 00       	jmp    803d0f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803c43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803c4a:	a1 30 50 80 00       	mov    0x805030,%eax
  803c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c52:	e9 8a 00 00 00       	jmp    803ce1 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c5d:	73 7a                	jae    803cd9 <realloc_block_FF+0x44d>
  803c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c62:	8b 00                	mov    (%eax),%eax
  803c64:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803c67:	73 70                	jae    803cd9 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803c69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c6d:	74 06                	je     803c75 <realloc_block_FF+0x3e9>
  803c6f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c73:	75 17                	jne    803c8c <realloc_block_FF+0x400>
  803c75:	83 ec 04             	sub    $0x4,%esp
  803c78:	68 c8 4b 80 00       	push   $0x804bc8
  803c7d:	68 1a 02 00 00       	push   $0x21a
  803c82:	68 55 4b 80 00       	push   $0x804b55
  803c87:	e8 24 cb ff ff       	call   8007b0 <_panic>
  803c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8f:	8b 10                	mov    (%eax),%edx
  803c91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c94:	89 10                	mov    %edx,(%eax)
  803c96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803c99:	8b 00                	mov    (%eax),%eax
  803c9b:	85 c0                	test   %eax,%eax
  803c9d:	74 0b                	je     803caa <realloc_block_FF+0x41e>
  803c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca2:	8b 00                	mov    (%eax),%eax
  803ca4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803ca7:	89 50 04             	mov    %edx,0x4(%eax)
  803caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cb0:	89 10                	mov    %edx,(%eax)
  803cb2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cb8:	89 50 04             	mov    %edx,0x4(%eax)
  803cbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cbe:	8b 00                	mov    (%eax),%eax
  803cc0:	85 c0                	test   %eax,%eax
  803cc2:	75 08                	jne    803ccc <realloc_block_FF+0x440>
  803cc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cc7:	a3 34 50 80 00       	mov    %eax,0x805034
  803ccc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803cd1:	40                   	inc    %eax
  803cd2:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803cd7:	eb 36                	jmp    803d0f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803cd9:	a1 38 50 80 00       	mov    0x805038,%eax
  803cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ce1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ce5:	74 07                	je     803cee <realloc_block_FF+0x462>
  803ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cea:	8b 00                	mov    (%eax),%eax
  803cec:	eb 05                	jmp    803cf3 <realloc_block_FF+0x467>
  803cee:	b8 00 00 00 00       	mov    $0x0,%eax
  803cf3:	a3 38 50 80 00       	mov    %eax,0x805038
  803cf8:	a1 38 50 80 00       	mov    0x805038,%eax
  803cfd:	85 c0                	test   %eax,%eax
  803cff:	0f 85 52 ff ff ff    	jne    803c57 <realloc_block_FF+0x3cb>
  803d05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d09:	0f 85 48 ff ff ff    	jne    803c57 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803d0f:	83 ec 04             	sub    $0x4,%esp
  803d12:	6a 00                	push   $0x0
  803d14:	ff 75 d8             	pushl  -0x28(%ebp)
  803d17:	ff 75 d4             	pushl  -0x2c(%ebp)
  803d1a:	e8 9d eb ff ff       	call   8028bc <set_block_data>
  803d1f:	83 c4 10             	add    $0x10,%esp
				return va;
  803d22:	8b 45 08             	mov    0x8(%ebp),%eax
  803d25:	e9 6b 02 00 00       	jmp    803f95 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d2d:	e9 63 02 00 00       	jmp    803f95 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d35:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d38:	0f 86 4d 02 00 00    	jbe    803f8b <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803d3e:	83 ec 0c             	sub    $0xc,%esp
  803d41:	ff 75 e4             	pushl  -0x1c(%ebp)
  803d44:	e8 3b e8 ff ff       	call   802584 <is_free_block>
  803d49:	83 c4 10             	add    $0x10,%esp
  803d4c:	84 c0                	test   %al,%al
  803d4e:	0f 84 37 02 00 00    	je     803f8b <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  803d57:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803d5d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d60:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803d63:	76 38                	jbe    803d9d <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803d65:	83 ec 0c             	sub    $0xc,%esp
  803d68:	ff 75 0c             	pushl  0xc(%ebp)
  803d6b:	e8 7b eb ff ff       	call   8028eb <alloc_block_FF>
  803d70:	83 c4 10             	add    $0x10,%esp
  803d73:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803d76:	83 ec 08             	sub    $0x8,%esp
  803d79:	ff 75 c0             	pushl  -0x40(%ebp)
  803d7c:	ff 75 08             	pushl  0x8(%ebp)
  803d7f:	e8 c9 fa ff ff       	call   80384d <copy_data>
  803d84:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803d87:	83 ec 0c             	sub    $0xc,%esp
  803d8a:	ff 75 08             	pushl  0x8(%ebp)
  803d8d:	e8 fa f9 ff ff       	call   80378c <free_block>
  803d92:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803d95:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803d98:	e9 f8 01 00 00       	jmp    803f95 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803da0:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803da3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803da6:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803daa:	0f 87 a0 00 00 00    	ja     803e50 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803db0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803db4:	75 17                	jne    803dcd <realloc_block_FF+0x541>
  803db6:	83 ec 04             	sub    $0x4,%esp
  803db9:	68 37 4b 80 00       	push   $0x804b37
  803dbe:	68 38 02 00 00       	push   $0x238
  803dc3:	68 55 4b 80 00       	push   $0x804b55
  803dc8:	e8 e3 c9 ff ff       	call   8007b0 <_panic>
  803dcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd0:	8b 00                	mov    (%eax),%eax
  803dd2:	85 c0                	test   %eax,%eax
  803dd4:	74 10                	je     803de6 <realloc_block_FF+0x55a>
  803dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd9:	8b 00                	mov    (%eax),%eax
  803ddb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dde:	8b 52 04             	mov    0x4(%edx),%edx
  803de1:	89 50 04             	mov    %edx,0x4(%eax)
  803de4:	eb 0b                	jmp    803df1 <realloc_block_FF+0x565>
  803de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de9:	8b 40 04             	mov    0x4(%eax),%eax
  803dec:	a3 34 50 80 00       	mov    %eax,0x805034
  803df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df4:	8b 40 04             	mov    0x4(%eax),%eax
  803df7:	85 c0                	test   %eax,%eax
  803df9:	74 0f                	je     803e0a <realloc_block_FF+0x57e>
  803dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dfe:	8b 40 04             	mov    0x4(%eax),%eax
  803e01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803e04:	8b 12                	mov    (%edx),%edx
  803e06:	89 10                	mov    %edx,(%eax)
  803e08:	eb 0a                	jmp    803e14 <realloc_block_FF+0x588>
  803e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e0d:	8b 00                	mov    (%eax),%eax
  803e0f:	a3 30 50 80 00       	mov    %eax,0x805030
  803e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e27:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803e2c:	48                   	dec    %eax
  803e2d:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803e32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e38:	01 d0                	add    %edx,%eax
  803e3a:	83 ec 04             	sub    $0x4,%esp
  803e3d:	6a 01                	push   $0x1
  803e3f:	50                   	push   %eax
  803e40:	ff 75 08             	pushl  0x8(%ebp)
  803e43:	e8 74 ea ff ff       	call   8028bc <set_block_data>
  803e48:	83 c4 10             	add    $0x10,%esp
  803e4b:	e9 36 01 00 00       	jmp    803f86 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803e50:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e53:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803e56:	01 d0                	add    %edx,%eax
  803e58:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803e5b:	83 ec 04             	sub    $0x4,%esp
  803e5e:	6a 01                	push   $0x1
  803e60:	ff 75 f0             	pushl  -0x10(%ebp)
  803e63:	ff 75 08             	pushl  0x8(%ebp)
  803e66:	e8 51 ea ff ff       	call   8028bc <set_block_data>
  803e6b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e71:	83 e8 04             	sub    $0x4,%eax
  803e74:	8b 00                	mov    (%eax),%eax
  803e76:	83 e0 fe             	and    $0xfffffffe,%eax
  803e79:	89 c2                	mov    %eax,%edx
  803e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e7e:	01 d0                	add    %edx,%eax
  803e80:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803e83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e87:	74 06                	je     803e8f <realloc_block_FF+0x603>
  803e89:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803e8d:	75 17                	jne    803ea6 <realloc_block_FF+0x61a>
  803e8f:	83 ec 04             	sub    $0x4,%esp
  803e92:	68 c8 4b 80 00       	push   $0x804bc8
  803e97:	68 44 02 00 00       	push   $0x244
  803e9c:	68 55 4b 80 00       	push   $0x804b55
  803ea1:	e8 0a c9 ff ff       	call   8007b0 <_panic>
  803ea6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea9:	8b 10                	mov    (%eax),%edx
  803eab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803eae:	89 10                	mov    %edx,(%eax)
  803eb0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803eb3:	8b 00                	mov    (%eax),%eax
  803eb5:	85 c0                	test   %eax,%eax
  803eb7:	74 0b                	je     803ec4 <realloc_block_FF+0x638>
  803eb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ebc:	8b 00                	mov    (%eax),%eax
  803ebe:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803ec1:	89 50 04             	mov    %edx,0x4(%eax)
  803ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ec7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803eca:	89 10                	mov    %edx,(%eax)
  803ecc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ecf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ed2:	89 50 04             	mov    %edx,0x4(%eax)
  803ed5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ed8:	8b 00                	mov    (%eax),%eax
  803eda:	85 c0                	test   %eax,%eax
  803edc:	75 08                	jne    803ee6 <realloc_block_FF+0x65a>
  803ede:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803ee1:	a3 34 50 80 00       	mov    %eax,0x805034
  803ee6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803eeb:	40                   	inc    %eax
  803eec:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803ef1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803ef5:	75 17                	jne    803f0e <realloc_block_FF+0x682>
  803ef7:	83 ec 04             	sub    $0x4,%esp
  803efa:	68 37 4b 80 00       	push   $0x804b37
  803eff:	68 45 02 00 00       	push   $0x245
  803f04:	68 55 4b 80 00       	push   $0x804b55
  803f09:	e8 a2 c8 ff ff       	call   8007b0 <_panic>
  803f0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f11:	8b 00                	mov    (%eax),%eax
  803f13:	85 c0                	test   %eax,%eax
  803f15:	74 10                	je     803f27 <realloc_block_FF+0x69b>
  803f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f1a:	8b 00                	mov    (%eax),%eax
  803f1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f1f:	8b 52 04             	mov    0x4(%edx),%edx
  803f22:	89 50 04             	mov    %edx,0x4(%eax)
  803f25:	eb 0b                	jmp    803f32 <realloc_block_FF+0x6a6>
  803f27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f2a:	8b 40 04             	mov    0x4(%eax),%eax
  803f2d:	a3 34 50 80 00       	mov    %eax,0x805034
  803f32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f35:	8b 40 04             	mov    0x4(%eax),%eax
  803f38:	85 c0                	test   %eax,%eax
  803f3a:	74 0f                	je     803f4b <realloc_block_FF+0x6bf>
  803f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f3f:	8b 40 04             	mov    0x4(%eax),%eax
  803f42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f45:	8b 12                	mov    (%edx),%edx
  803f47:	89 10                	mov    %edx,(%eax)
  803f49:	eb 0a                	jmp    803f55 <realloc_block_FF+0x6c9>
  803f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f4e:	8b 00                	mov    (%eax),%eax
  803f50:	a3 30 50 80 00       	mov    %eax,0x805030
  803f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f68:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803f6d:	48                   	dec    %eax
  803f6e:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803f73:	83 ec 04             	sub    $0x4,%esp
  803f76:	6a 00                	push   $0x0
  803f78:	ff 75 bc             	pushl  -0x44(%ebp)
  803f7b:	ff 75 b8             	pushl  -0x48(%ebp)
  803f7e:	e8 39 e9 ff ff       	call   8028bc <set_block_data>
  803f83:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803f86:	8b 45 08             	mov    0x8(%ebp),%eax
  803f89:	eb 0a                	jmp    803f95 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803f8b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803f92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803f95:	c9                   	leave  
  803f96:	c3                   	ret    

00803f97 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803f97:	55                   	push   %ebp
  803f98:	89 e5                	mov    %esp,%ebp
  803f9a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803f9d:	83 ec 04             	sub    $0x4,%esp
  803fa0:	68 34 4c 80 00       	push   $0x804c34
  803fa5:	68 58 02 00 00       	push   $0x258
  803faa:	68 55 4b 80 00       	push   $0x804b55
  803faf:	e8 fc c7 ff ff       	call   8007b0 <_panic>

00803fb4 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803fb4:	55                   	push   %ebp
  803fb5:	89 e5                	mov    %esp,%ebp
  803fb7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803fba:	83 ec 04             	sub    $0x4,%esp
  803fbd:	68 5c 4c 80 00       	push   $0x804c5c
  803fc2:	68 61 02 00 00       	push   $0x261
  803fc7:	68 55 4b 80 00       	push   $0x804b55
  803fcc:	e8 df c7 ff ff       	call   8007b0 <_panic>

00803fd1 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803fd1:	55                   	push   %ebp
  803fd2:	89 e5                	mov    %esp,%ebp
  803fd4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803fd7:	83 ec 04             	sub    $0x4,%esp
  803fda:	68 84 4c 80 00       	push   $0x804c84
  803fdf:	6a 09                	push   $0x9
  803fe1:	68 ac 4c 80 00       	push   $0x804cac
  803fe6:	e8 c5 c7 ff ff       	call   8007b0 <_panic>

00803feb <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803feb:	55                   	push   %ebp
  803fec:	89 e5                	mov    %esp,%ebp
  803fee:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803ff1:	83 ec 04             	sub    $0x4,%esp
  803ff4:	68 bc 4c 80 00       	push   $0x804cbc
  803ff9:	6a 10                	push   $0x10
  803ffb:	68 ac 4c 80 00       	push   $0x804cac
  804000:	e8 ab c7 ff ff       	call   8007b0 <_panic>

00804005 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  804005:	55                   	push   %ebp
  804006:	89 e5                	mov    %esp,%ebp
  804008:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  80400b:	83 ec 04             	sub    $0x4,%esp
  80400e:	68 e4 4c 80 00       	push   $0x804ce4
  804013:	6a 18                	push   $0x18
  804015:	68 ac 4c 80 00       	push   $0x804cac
  80401a:	e8 91 c7 ff ff       	call   8007b0 <_panic>

0080401f <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80401f:	55                   	push   %ebp
  804020:	89 e5                	mov    %esp,%ebp
  804022:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  804025:	83 ec 04             	sub    $0x4,%esp
  804028:	68 0c 4d 80 00       	push   $0x804d0c
  80402d:	6a 20                	push   $0x20
  80402f:	68 ac 4c 80 00       	push   $0x804cac
  804034:	e8 77 c7 ff ff       	call   8007b0 <_panic>

00804039 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  804039:	55                   	push   %ebp
  80403a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80403c:	8b 45 08             	mov    0x8(%ebp),%eax
  80403f:	8b 40 10             	mov    0x10(%eax),%eax
}
  804042:	5d                   	pop    %ebp
  804043:	c3                   	ret    

00804044 <__udivdi3>:
  804044:	55                   	push   %ebp
  804045:	57                   	push   %edi
  804046:	56                   	push   %esi
  804047:	53                   	push   %ebx
  804048:	83 ec 1c             	sub    $0x1c,%esp
  80404b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80404f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804053:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804057:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80405b:	89 ca                	mov    %ecx,%edx
  80405d:	89 f8                	mov    %edi,%eax
  80405f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804063:	85 f6                	test   %esi,%esi
  804065:	75 2d                	jne    804094 <__udivdi3+0x50>
  804067:	39 cf                	cmp    %ecx,%edi
  804069:	77 65                	ja     8040d0 <__udivdi3+0x8c>
  80406b:	89 fd                	mov    %edi,%ebp
  80406d:	85 ff                	test   %edi,%edi
  80406f:	75 0b                	jne    80407c <__udivdi3+0x38>
  804071:	b8 01 00 00 00       	mov    $0x1,%eax
  804076:	31 d2                	xor    %edx,%edx
  804078:	f7 f7                	div    %edi
  80407a:	89 c5                	mov    %eax,%ebp
  80407c:	31 d2                	xor    %edx,%edx
  80407e:	89 c8                	mov    %ecx,%eax
  804080:	f7 f5                	div    %ebp
  804082:	89 c1                	mov    %eax,%ecx
  804084:	89 d8                	mov    %ebx,%eax
  804086:	f7 f5                	div    %ebp
  804088:	89 cf                	mov    %ecx,%edi
  80408a:	89 fa                	mov    %edi,%edx
  80408c:	83 c4 1c             	add    $0x1c,%esp
  80408f:	5b                   	pop    %ebx
  804090:	5e                   	pop    %esi
  804091:	5f                   	pop    %edi
  804092:	5d                   	pop    %ebp
  804093:	c3                   	ret    
  804094:	39 ce                	cmp    %ecx,%esi
  804096:	77 28                	ja     8040c0 <__udivdi3+0x7c>
  804098:	0f bd fe             	bsr    %esi,%edi
  80409b:	83 f7 1f             	xor    $0x1f,%edi
  80409e:	75 40                	jne    8040e0 <__udivdi3+0x9c>
  8040a0:	39 ce                	cmp    %ecx,%esi
  8040a2:	72 0a                	jb     8040ae <__udivdi3+0x6a>
  8040a4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8040a8:	0f 87 9e 00 00 00    	ja     80414c <__udivdi3+0x108>
  8040ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8040b3:	89 fa                	mov    %edi,%edx
  8040b5:	83 c4 1c             	add    $0x1c,%esp
  8040b8:	5b                   	pop    %ebx
  8040b9:	5e                   	pop    %esi
  8040ba:	5f                   	pop    %edi
  8040bb:	5d                   	pop    %ebp
  8040bc:	c3                   	ret    
  8040bd:	8d 76 00             	lea    0x0(%esi),%esi
  8040c0:	31 ff                	xor    %edi,%edi
  8040c2:	31 c0                	xor    %eax,%eax
  8040c4:	89 fa                	mov    %edi,%edx
  8040c6:	83 c4 1c             	add    $0x1c,%esp
  8040c9:	5b                   	pop    %ebx
  8040ca:	5e                   	pop    %esi
  8040cb:	5f                   	pop    %edi
  8040cc:	5d                   	pop    %ebp
  8040cd:	c3                   	ret    
  8040ce:	66 90                	xchg   %ax,%ax
  8040d0:	89 d8                	mov    %ebx,%eax
  8040d2:	f7 f7                	div    %edi
  8040d4:	31 ff                	xor    %edi,%edi
  8040d6:	89 fa                	mov    %edi,%edx
  8040d8:	83 c4 1c             	add    $0x1c,%esp
  8040db:	5b                   	pop    %ebx
  8040dc:	5e                   	pop    %esi
  8040dd:	5f                   	pop    %edi
  8040de:	5d                   	pop    %ebp
  8040df:	c3                   	ret    
  8040e0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040e5:	89 eb                	mov    %ebp,%ebx
  8040e7:	29 fb                	sub    %edi,%ebx
  8040e9:	89 f9                	mov    %edi,%ecx
  8040eb:	d3 e6                	shl    %cl,%esi
  8040ed:	89 c5                	mov    %eax,%ebp
  8040ef:	88 d9                	mov    %bl,%cl
  8040f1:	d3 ed                	shr    %cl,%ebp
  8040f3:	89 e9                	mov    %ebp,%ecx
  8040f5:	09 f1                	or     %esi,%ecx
  8040f7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040fb:	89 f9                	mov    %edi,%ecx
  8040fd:	d3 e0                	shl    %cl,%eax
  8040ff:	89 c5                	mov    %eax,%ebp
  804101:	89 d6                	mov    %edx,%esi
  804103:	88 d9                	mov    %bl,%cl
  804105:	d3 ee                	shr    %cl,%esi
  804107:	89 f9                	mov    %edi,%ecx
  804109:	d3 e2                	shl    %cl,%edx
  80410b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80410f:	88 d9                	mov    %bl,%cl
  804111:	d3 e8                	shr    %cl,%eax
  804113:	09 c2                	or     %eax,%edx
  804115:	89 d0                	mov    %edx,%eax
  804117:	89 f2                	mov    %esi,%edx
  804119:	f7 74 24 0c          	divl   0xc(%esp)
  80411d:	89 d6                	mov    %edx,%esi
  80411f:	89 c3                	mov    %eax,%ebx
  804121:	f7 e5                	mul    %ebp
  804123:	39 d6                	cmp    %edx,%esi
  804125:	72 19                	jb     804140 <__udivdi3+0xfc>
  804127:	74 0b                	je     804134 <__udivdi3+0xf0>
  804129:	89 d8                	mov    %ebx,%eax
  80412b:	31 ff                	xor    %edi,%edi
  80412d:	e9 58 ff ff ff       	jmp    80408a <__udivdi3+0x46>
  804132:	66 90                	xchg   %ax,%ax
  804134:	8b 54 24 08          	mov    0x8(%esp),%edx
  804138:	89 f9                	mov    %edi,%ecx
  80413a:	d3 e2                	shl    %cl,%edx
  80413c:	39 c2                	cmp    %eax,%edx
  80413e:	73 e9                	jae    804129 <__udivdi3+0xe5>
  804140:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804143:	31 ff                	xor    %edi,%edi
  804145:	e9 40 ff ff ff       	jmp    80408a <__udivdi3+0x46>
  80414a:	66 90                	xchg   %ax,%ax
  80414c:	31 c0                	xor    %eax,%eax
  80414e:	e9 37 ff ff ff       	jmp    80408a <__udivdi3+0x46>
  804153:	90                   	nop

00804154 <__umoddi3>:
  804154:	55                   	push   %ebp
  804155:	57                   	push   %edi
  804156:	56                   	push   %esi
  804157:	53                   	push   %ebx
  804158:	83 ec 1c             	sub    $0x1c,%esp
  80415b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80415f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804163:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804167:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80416b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80416f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804173:	89 f3                	mov    %esi,%ebx
  804175:	89 fa                	mov    %edi,%edx
  804177:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80417b:	89 34 24             	mov    %esi,(%esp)
  80417e:	85 c0                	test   %eax,%eax
  804180:	75 1a                	jne    80419c <__umoddi3+0x48>
  804182:	39 f7                	cmp    %esi,%edi
  804184:	0f 86 a2 00 00 00    	jbe    80422c <__umoddi3+0xd8>
  80418a:	89 c8                	mov    %ecx,%eax
  80418c:	89 f2                	mov    %esi,%edx
  80418e:	f7 f7                	div    %edi
  804190:	89 d0                	mov    %edx,%eax
  804192:	31 d2                	xor    %edx,%edx
  804194:	83 c4 1c             	add    $0x1c,%esp
  804197:	5b                   	pop    %ebx
  804198:	5e                   	pop    %esi
  804199:	5f                   	pop    %edi
  80419a:	5d                   	pop    %ebp
  80419b:	c3                   	ret    
  80419c:	39 f0                	cmp    %esi,%eax
  80419e:	0f 87 ac 00 00 00    	ja     804250 <__umoddi3+0xfc>
  8041a4:	0f bd e8             	bsr    %eax,%ebp
  8041a7:	83 f5 1f             	xor    $0x1f,%ebp
  8041aa:	0f 84 ac 00 00 00    	je     80425c <__umoddi3+0x108>
  8041b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8041b5:	29 ef                	sub    %ebp,%edi
  8041b7:	89 fe                	mov    %edi,%esi
  8041b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8041bd:	89 e9                	mov    %ebp,%ecx
  8041bf:	d3 e0                	shl    %cl,%eax
  8041c1:	89 d7                	mov    %edx,%edi
  8041c3:	89 f1                	mov    %esi,%ecx
  8041c5:	d3 ef                	shr    %cl,%edi
  8041c7:	09 c7                	or     %eax,%edi
  8041c9:	89 e9                	mov    %ebp,%ecx
  8041cb:	d3 e2                	shl    %cl,%edx
  8041cd:	89 14 24             	mov    %edx,(%esp)
  8041d0:	89 d8                	mov    %ebx,%eax
  8041d2:	d3 e0                	shl    %cl,%eax
  8041d4:	89 c2                	mov    %eax,%edx
  8041d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041da:	d3 e0                	shl    %cl,%eax
  8041dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041e4:	89 f1                	mov    %esi,%ecx
  8041e6:	d3 e8                	shr    %cl,%eax
  8041e8:	09 d0                	or     %edx,%eax
  8041ea:	d3 eb                	shr    %cl,%ebx
  8041ec:	89 da                	mov    %ebx,%edx
  8041ee:	f7 f7                	div    %edi
  8041f0:	89 d3                	mov    %edx,%ebx
  8041f2:	f7 24 24             	mull   (%esp)
  8041f5:	89 c6                	mov    %eax,%esi
  8041f7:	89 d1                	mov    %edx,%ecx
  8041f9:	39 d3                	cmp    %edx,%ebx
  8041fb:	0f 82 87 00 00 00    	jb     804288 <__umoddi3+0x134>
  804201:	0f 84 91 00 00 00    	je     804298 <__umoddi3+0x144>
  804207:	8b 54 24 04          	mov    0x4(%esp),%edx
  80420b:	29 f2                	sub    %esi,%edx
  80420d:	19 cb                	sbb    %ecx,%ebx
  80420f:	89 d8                	mov    %ebx,%eax
  804211:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804215:	d3 e0                	shl    %cl,%eax
  804217:	89 e9                	mov    %ebp,%ecx
  804219:	d3 ea                	shr    %cl,%edx
  80421b:	09 d0                	or     %edx,%eax
  80421d:	89 e9                	mov    %ebp,%ecx
  80421f:	d3 eb                	shr    %cl,%ebx
  804221:	89 da                	mov    %ebx,%edx
  804223:	83 c4 1c             	add    $0x1c,%esp
  804226:	5b                   	pop    %ebx
  804227:	5e                   	pop    %esi
  804228:	5f                   	pop    %edi
  804229:	5d                   	pop    %ebp
  80422a:	c3                   	ret    
  80422b:	90                   	nop
  80422c:	89 fd                	mov    %edi,%ebp
  80422e:	85 ff                	test   %edi,%edi
  804230:	75 0b                	jne    80423d <__umoddi3+0xe9>
  804232:	b8 01 00 00 00       	mov    $0x1,%eax
  804237:	31 d2                	xor    %edx,%edx
  804239:	f7 f7                	div    %edi
  80423b:	89 c5                	mov    %eax,%ebp
  80423d:	89 f0                	mov    %esi,%eax
  80423f:	31 d2                	xor    %edx,%edx
  804241:	f7 f5                	div    %ebp
  804243:	89 c8                	mov    %ecx,%eax
  804245:	f7 f5                	div    %ebp
  804247:	89 d0                	mov    %edx,%eax
  804249:	e9 44 ff ff ff       	jmp    804192 <__umoddi3+0x3e>
  80424e:	66 90                	xchg   %ax,%ax
  804250:	89 c8                	mov    %ecx,%eax
  804252:	89 f2                	mov    %esi,%edx
  804254:	83 c4 1c             	add    $0x1c,%esp
  804257:	5b                   	pop    %ebx
  804258:	5e                   	pop    %esi
  804259:	5f                   	pop    %edi
  80425a:	5d                   	pop    %ebp
  80425b:	c3                   	ret    
  80425c:	3b 04 24             	cmp    (%esp),%eax
  80425f:	72 06                	jb     804267 <__umoddi3+0x113>
  804261:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804265:	77 0f                	ja     804276 <__umoddi3+0x122>
  804267:	89 f2                	mov    %esi,%edx
  804269:	29 f9                	sub    %edi,%ecx
  80426b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80426f:	89 14 24             	mov    %edx,(%esp)
  804272:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804276:	8b 44 24 04          	mov    0x4(%esp),%eax
  80427a:	8b 14 24             	mov    (%esp),%edx
  80427d:	83 c4 1c             	add    $0x1c,%esp
  804280:	5b                   	pop    %ebx
  804281:	5e                   	pop    %esi
  804282:	5f                   	pop    %edi
  804283:	5d                   	pop    %ebp
  804284:	c3                   	ret    
  804285:	8d 76 00             	lea    0x0(%esi),%esi
  804288:	2b 04 24             	sub    (%esp),%eax
  80428b:	19 fa                	sbb    %edi,%edx
  80428d:	89 d1                	mov    %edx,%ecx
  80428f:	89 c6                	mov    %eax,%esi
  804291:	e9 71 ff ff ff       	jmp    804207 <__umoddi3+0xb3>
  804296:	66 90                	xchg   %ax,%ax
  804298:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80429c:	72 ea                	jb     804288 <__umoddi3+0x134>
  80429e:	89 d9                	mov    %ebx,%ecx
  8042a0:	e9 62 ff ff ff       	jmp    804207 <__umoddi3+0xb3>
