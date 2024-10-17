
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
  800042:	e8 d0 1d 00 00       	call   801e17 <sys_getenvid>
  800047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  80004a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	IO_CS = create_semaphore("IO.CS", 1);
  800051:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	6a 01                	push   $0x1
  80005c:	68 60 24 80 00       	push   $0x802460
  800061:	50                   	push   %eax
  800062:	e8 0d 21 00 00       	call   802174 <create_semaphore>
  800067:	83 c4 0c             	add    $0xc,%esp
  80006a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800070:	a3 24 30 80 00       	mov    %eax,0x803024
	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800075:	e8 ed 1b 00 00       	call   801c67 <sys_calculate_free_frames>
  80007a:	89 c3                	mov    %eax,%ebx
  80007c:	e8 ff 1b 00 00       	call   801c80 <sys_calculate_modified_frames>
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
  800092:	e8 11 21 00 00       	call   8021a8 <wait_semaphore>
  800097:	83 c4 10             	add    $0x10,%esp
		{
			readline("Enter the number of elements: ", Line);
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000a3:	50                   	push   %eax
  8000a4:	68 68 24 80 00       	push   $0x802468
  8000a9:	e8 61 10 00 00       	call   80110f <readline>
  8000ae:	83 c4 10             	add    $0x10,%esp
			NumOfElements = strtol(Line, NULL, 10) ;
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	6a 0a                	push   $0xa
  8000b6:	6a 00                	push   $0x0
  8000b8:	8d 85 dd fe ff ff    	lea    -0x123(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 b3 15 00 00       	call   801677 <strtol>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			Elements = malloc(sizeof(int) * NumOfElements) ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c1 e0 02             	shl    $0x2,%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 5a 19 00 00       	call   801a33 <malloc>
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 88 24 80 00       	push   $0x802488
  8000e7:	e8 8f 09 00 00       	call   800a7b <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 ab 24 80 00       	push   $0x8024ab
  8000f7:	e8 7f 09 00 00       	call   800a7b <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
			cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 b9 24 80 00       	push   $0x8024b9
  800107:	e8 6f 09 00 00       	call   800a7b <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
			cprintf("c) Semi random\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 c8 24 80 00       	push   $0x8024c8
  800117:	e8 5f 09 00 00       	call   800a7b <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
			do
			{
				cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 d8 24 80 00       	push   $0x8024d8
  800127:	e8 4f 09 00 00       	call   800a7b <cprintf>
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
  80016f:	e8 4e 20 00 00       	call   8021c2 <signal_semaphore>
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
  800202:	68 e4 24 80 00       	push   $0x8024e4
  800207:	6a 4d                	push   $0x4d
  800209:	68 06 25 80 00       	push   $0x802506
  80020e:	e8 ab 05 00 00       	call   8007be <_panic>
		else
		{
			wait_semaphore(IO_CS);
  800213:	83 ec 0c             	sub    $0xc,%esp
  800216:	ff 35 24 30 80 00    	pushl  0x803024
  80021c:	e8 87 1f 00 00       	call   8021a8 <wait_semaphore>
  800221:	83 c4 10             	add    $0x10,%esp
				cprintf("\n===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 24 25 80 00       	push   $0x802524
  80022c:	e8 4a 08 00 00       	call   800a7b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
				cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 58 25 80 00       	push   $0x802558
  80023c:	e8 3a 08 00 00       	call   800a7b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
				cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 8c 25 80 00       	push   $0x80258c
  80024c:	e8 2a 08 00 00       	call   800a7b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			signal_semaphore(IO_CS);
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	ff 35 24 30 80 00    	pushl  0x803024
  80025d:	e8 60 1f 00 00       	call   8021c2 <signal_semaphore>
  800262:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		wait_semaphore(IO_CS);
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	ff 35 24 30 80 00    	pushl  0x803024
  80026e:	e8 35 1f 00 00       	call   8021a8 <wait_semaphore>
  800273:	83 c4 10             	add    $0x10,%esp
			cprintf("Freeing the Heap...\n\n") ;
  800276:	83 ec 0c             	sub    $0xc,%esp
  800279:	68 be 25 80 00       	push   $0x8025be
  80027e:	e8 f8 07 00 00       	call   800a7b <cprintf>
  800283:	83 c4 10             	add    $0x10,%esp
		signal_semaphore(IO_CS);
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	ff 35 24 30 80 00    	pushl  0x803024
  80028f:	e8 2e 1f 00 00       	call   8021c2 <signal_semaphore>
  800294:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
	//sys_lock_cons();
		wait_semaphore(IO_CS);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 35 24 30 80 00    	pushl  0x803024
  8002a0:	e8 03 1f 00 00       	call   8021a8 <wait_semaphore>
  8002a5:	83 c4 10             	add    $0x10,%esp
			cprintf("Do you want to repeat (y/n): ") ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 d4 25 80 00       	push   $0x8025d4
  8002b0:	e8 c6 07 00 00       	call   800a7b <cprintf>
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
  8002f3:	e8 ca 1e 00 00       	call   8021c2 <signal_semaphore>
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
  80058b:	e8 87 18 00 00       	call   801e17 <sys_getenvid>
  800590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	wait_semaphore(IO_CS);
  800593:	83 ec 0c             	sub    $0xc,%esp
  800596:	ff 35 24 30 80 00    	pushl  0x803024
  80059c:	e8 07 1c 00 00       	call   8021a8 <wait_semaphore>
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
  8005c4:	68 f2 25 80 00       	push   $0x8025f2
  8005c9:	e8 ad 04 00 00       	call   800a7b <cprintf>
  8005ce:	83 c4 10             	add    $0x10,%esp
			cprintf("%d, ",Elements[i]);
  8005d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	01 d0                	add    %edx,%eax
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	83 ec 08             	sub    $0x8,%esp
  8005e5:	50                   	push   %eax
  8005e6:	68 f4 25 80 00       	push   $0x8025f4
  8005eb:	e8 8b 04 00 00       	call   800a7b <cprintf>
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
  800614:	68 f9 25 80 00       	push   $0x8025f9
  800619:	e8 5d 04 00 00       	call   800a7b <cprintf>
  80061e:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(IO_CS);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	ff 35 24 30 80 00    	pushl  0x803024
  80062a:	e8 93 1b 00 00       	call   8021c2 <signal_semaphore>
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
  800649:	e8 b1 16 00 00       	call   801cff <sys_cputc>
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
  80065a:	e8 3c 15 00 00       	call   801b9b <sys_cgetc>
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
  800677:	e8 b4 17 00 00       	call   801e30 <sys_getenvindex>
  80067c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80067f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800682:	89 d0                	mov    %edx,%eax
  800684:	c1 e0 06             	shl    $0x6,%eax
  800687:	29 d0                	sub    %edx,%eax
  800689:	c1 e0 02             	shl    $0x2,%eax
  80068c:	01 d0                	add    %edx,%eax
  80068e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800695:	01 c8                	add    %ecx,%eax
  800697:	c1 e0 03             	shl    $0x3,%eax
  80069a:	01 d0                	add    %edx,%eax
  80069c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a3:	29 c2                	sub    %eax,%edx
  8006a5:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8006ac:	89 c2                	mov    %eax,%edx
  8006ae:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8006b4:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006b9:	a1 08 30 80 00       	mov    0x803008,%eax
  8006be:	8a 40 20             	mov    0x20(%eax),%al
  8006c1:	84 c0                	test   %al,%al
  8006c3:	74 0d                	je     8006d2 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8006c5:	a1 08 30 80 00       	mov    0x803008,%eax
  8006ca:	83 c0 20             	add    $0x20,%eax
  8006cd:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006d6:	7e 0a                	jle    8006e2 <libmain+0x71>
		binaryname = argv[0];
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	ff 75 0c             	pushl  0xc(%ebp)
  8006e8:	ff 75 08             	pushl  0x8(%ebp)
  8006eb:	e8 48 f9 ff ff       	call   800038 <_main>
  8006f0:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8006f3:	e8 bc 14 00 00       	call   801bb4 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	68 18 26 80 00       	push   $0x802618
  800700:	e8 76 03 00 00       	call   800a7b <cprintf>
  800705:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800708:	a1 08 30 80 00       	mov    0x803008,%eax
  80070d:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800713:	a1 08 30 80 00       	mov    0x803008,%eax
  800718:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80071e:	83 ec 04             	sub    $0x4,%esp
  800721:	52                   	push   %edx
  800722:	50                   	push   %eax
  800723:	68 40 26 80 00       	push   $0x802640
  800728:	e8 4e 03 00 00       	call   800a7b <cprintf>
  80072d:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800730:	a1 08 30 80 00       	mov    0x803008,%eax
  800735:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80073b:	a1 08 30 80 00       	mov    0x803008,%eax
  800740:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800746:	a1 08 30 80 00       	mov    0x803008,%eax
  80074b:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800751:	51                   	push   %ecx
  800752:	52                   	push   %edx
  800753:	50                   	push   %eax
  800754:	68 68 26 80 00       	push   $0x802668
  800759:	e8 1d 03 00 00       	call   800a7b <cprintf>
  80075e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800761:	a1 08 30 80 00       	mov    0x803008,%eax
  800766:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	50                   	push   %eax
  800770:	68 c0 26 80 00       	push   $0x8026c0
  800775:	e8 01 03 00 00       	call   800a7b <cprintf>
  80077a:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80077d:	83 ec 0c             	sub    $0xc,%esp
  800780:	68 18 26 80 00       	push   $0x802618
  800785:	e8 f1 02 00 00       	call   800a7b <cprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80078d:	e8 3c 14 00 00       	call   801bce <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800792:	e8 19 00 00 00       	call   8007b0 <exit>
}
  800797:	90                   	nop
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8007a0:	83 ec 0c             	sub    $0xc,%esp
  8007a3:	6a 00                	push   $0x0
  8007a5:	e8 52 16 00 00       	call   801dfc <sys_destroy_env>
  8007aa:	83 c4 10             	add    $0x10,%esp
}
  8007ad:	90                   	nop
  8007ae:	c9                   	leave  
  8007af:	c3                   	ret    

008007b0 <exit>:

void
exit(void)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b6:	e8 a7 16 00 00       	call   801e62 <sys_exit_env>
}
  8007bb:	90                   	nop
  8007bc:	c9                   	leave  
  8007bd:	c3                   	ret    

008007be <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007be:	55                   	push   %ebp
  8007bf:	89 e5                	mov    %esp,%ebp
  8007c1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c4:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c7:	83 c0 04             	add    $0x4,%eax
  8007ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007cd:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8007d2:	85 c0                	test   %eax,%eax
  8007d4:	74 16                	je     8007ec <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d6:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	50                   	push   %eax
  8007df:	68 d4 26 80 00       	push   $0x8026d4
  8007e4:	e8 92 02 00 00       	call   800a7b <cprintf>
  8007e9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ec:	a1 00 30 80 00       	mov    0x803000,%eax
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	ff 75 08             	pushl  0x8(%ebp)
  8007f7:	50                   	push   %eax
  8007f8:	68 d9 26 80 00       	push   $0x8026d9
  8007fd:	e8 79 02 00 00       	call   800a7b <cprintf>
  800802:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800805:	8b 45 10             	mov    0x10(%ebp),%eax
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 f4             	pushl  -0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	e8 fc 01 00 00       	call   800a10 <vcprintf>
  800814:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	6a 00                	push   $0x0
  80081c:	68 f5 26 80 00       	push   $0x8026f5
  800821:	e8 ea 01 00 00       	call   800a10 <vcprintf>
  800826:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800829:	e8 82 ff ff ff       	call   8007b0 <exit>

	// should not return here
	while (1) ;
  80082e:	eb fe                	jmp    80082e <_panic+0x70>

00800830 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800836:	a1 08 30 80 00       	mov    0x803008,%eax
  80083b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800841:	8b 45 0c             	mov    0xc(%ebp),%eax
  800844:	39 c2                	cmp    %eax,%edx
  800846:	74 14                	je     80085c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800848:	83 ec 04             	sub    $0x4,%esp
  80084b:	68 f8 26 80 00       	push   $0x8026f8
  800850:	6a 26                	push   $0x26
  800852:	68 44 27 80 00       	push   $0x802744
  800857:	e8 62 ff ff ff       	call   8007be <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80085c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800863:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80086a:	e9 c5 00 00 00       	jmp    800934 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80086f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800872:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	01 d0                	add    %edx,%eax
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	85 c0                	test   %eax,%eax
  800882:	75 08                	jne    80088c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800884:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800887:	e9 a5 00 00 00       	jmp    800931 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80088c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800893:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80089a:	eb 69                	jmp    800905 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80089c:	a1 08 30 80 00       	mov    0x803008,%eax
  8008a1:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8008a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008aa:	89 d0                	mov    %edx,%eax
  8008ac:	01 c0                	add    %eax,%eax
  8008ae:	01 d0                	add    %edx,%eax
  8008b0:	c1 e0 03             	shl    $0x3,%eax
  8008b3:	01 c8                	add    %ecx,%eax
  8008b5:	8a 40 04             	mov    0x4(%eax),%al
  8008b8:	84 c0                	test   %al,%al
  8008ba:	75 46                	jne    800902 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008bc:	a1 08 30 80 00       	mov    0x803008,%eax
  8008c1:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8008c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008ca:	89 d0                	mov    %edx,%eax
  8008cc:	01 c0                	add    %eax,%eax
  8008ce:	01 d0                	add    %edx,%eax
  8008d0:	c1 e0 03             	shl    $0x3,%eax
  8008d3:	01 c8                	add    %ecx,%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008e2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	01 c8                	add    %ecx,%eax
  8008f3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f5:	39 c2                	cmp    %eax,%edx
  8008f7:	75 09                	jne    800902 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8008f9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800900:	eb 15                	jmp    800917 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800902:	ff 45 e8             	incl   -0x18(%ebp)
  800905:	a1 08 30 80 00       	mov    0x803008,%eax
  80090a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800910:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800913:	39 c2                	cmp    %eax,%edx
  800915:	77 85                	ja     80089c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800917:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80091b:	75 14                	jne    800931 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80091d:	83 ec 04             	sub    $0x4,%esp
  800920:	68 50 27 80 00       	push   $0x802750
  800925:	6a 3a                	push   $0x3a
  800927:	68 44 27 80 00       	push   $0x802744
  80092c:	e8 8d fe ff ff       	call   8007be <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800931:	ff 45 f0             	incl   -0x10(%ebp)
  800934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800937:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80093a:	0f 8c 2f ff ff ff    	jl     80086f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800940:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800947:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80094e:	eb 26                	jmp    800976 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800950:	a1 08 30 80 00       	mov    0x803008,%eax
  800955:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80095b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80095e:	89 d0                	mov    %edx,%eax
  800960:	01 c0                	add    %eax,%eax
  800962:	01 d0                	add    %edx,%eax
  800964:	c1 e0 03             	shl    $0x3,%eax
  800967:	01 c8                	add    %ecx,%eax
  800969:	8a 40 04             	mov    0x4(%eax),%al
  80096c:	3c 01                	cmp    $0x1,%al
  80096e:	75 03                	jne    800973 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800970:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800973:	ff 45 e0             	incl   -0x20(%ebp)
  800976:	a1 08 30 80 00       	mov    0x803008,%eax
  80097b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800981:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800984:	39 c2                	cmp    %eax,%edx
  800986:	77 c8                	ja     800950 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80098b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80098e:	74 14                	je     8009a4 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800990:	83 ec 04             	sub    $0x4,%esp
  800993:	68 a4 27 80 00       	push   $0x8027a4
  800998:	6a 44                	push   $0x44
  80099a:	68 44 27 80 00       	push   $0x802744
  80099f:	e8 1a fe ff ff       	call   8007be <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8009a4:	90                   	nop
  8009a5:	c9                   	leave  
  8009a6:	c3                   	ret    

008009a7 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	89 0a                	mov    %ecx,(%edx)
  8009ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8009bd:	88 d1                	mov    %dl,%cl
  8009bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009d0:	75 2c                	jne    8009fe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009d2:	a0 0c 30 80 00       	mov    0x80300c,%al
  8009d7:	0f b6 c0             	movzbl %al,%eax
  8009da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dd:	8b 12                	mov    (%edx),%edx
  8009df:	89 d1                	mov    %edx,%ecx
  8009e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e4:	83 c2 08             	add    $0x8,%edx
  8009e7:	83 ec 04             	sub    $0x4,%esp
  8009ea:	50                   	push   %eax
  8009eb:	51                   	push   %ecx
  8009ec:	52                   	push   %edx
  8009ed:	e8 80 11 00 00       	call   801b72 <sys_cputs>
  8009f2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a01:	8b 40 04             	mov    0x4(%eax),%eax
  800a04:	8d 50 01             	lea    0x1(%eax),%edx
  800a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a0d:	90                   	nop
  800a0e:	c9                   	leave  
  800a0f:	c3                   	ret    

00800a10 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a19:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a20:	00 00 00 
	b.cnt = 0;
  800a23:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a2a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	ff 75 08             	pushl  0x8(%ebp)
  800a33:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a39:	50                   	push   %eax
  800a3a:	68 a7 09 80 00       	push   $0x8009a7
  800a3f:	e8 11 02 00 00       	call   800c55 <vprintfmt>
  800a44:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a47:	a0 0c 30 80 00       	mov    0x80300c,%al
  800a4c:	0f b6 c0             	movzbl %al,%eax
  800a4f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a55:	83 ec 04             	sub    $0x4,%esp
  800a58:	50                   	push   %eax
  800a59:	52                   	push   %edx
  800a5a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a60:	83 c0 08             	add    $0x8,%eax
  800a63:	50                   	push   %eax
  800a64:	e8 09 11 00 00       	call   801b72 <sys_cputs>
  800a69:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a6c:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800a73:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a81:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800a88:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 f4             	pushl  -0xc(%ebp)
  800a97:	50                   	push   %eax
  800a98:	e8 73 ff ff ff       	call   800a10 <vcprintf>
  800a9d:	83 c4 10             	add    $0x10,%esp
  800aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa6:	c9                   	leave  
  800aa7:	c3                   	ret    

00800aa8 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800aae:	e8 01 11 00 00       	call   801bb4 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800ab3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac2:	50                   	push   %eax
  800ac3:	e8 48 ff ff ff       	call   800a10 <vcprintf>
  800ac8:	83 c4 10             	add    $0x10,%esp
  800acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800ace:	e8 fb 10 00 00       	call   801bce <sys_unlock_cons>
	return cnt;
  800ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ad6:	c9                   	leave  
  800ad7:	c3                   	ret    

00800ad8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	53                   	push   %ebx
  800adc:	83 ec 14             	sub    $0x14,%esp
  800adf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800aeb:	8b 45 18             	mov    0x18(%ebp),%eax
  800aee:	ba 00 00 00 00       	mov    $0x0,%edx
  800af3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800af6:	77 55                	ja     800b4d <printnum+0x75>
  800af8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800afb:	72 05                	jb     800b02 <printnum+0x2a>
  800afd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b00:	77 4b                	ja     800b4d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b02:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b05:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b08:	8b 45 18             	mov    0x18(%ebp),%eax
  800b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b10:	52                   	push   %edx
  800b11:	50                   	push   %eax
  800b12:	ff 75 f4             	pushl  -0xc(%ebp)
  800b15:	ff 75 f0             	pushl  -0x10(%ebp)
  800b18:	e8 cb 16 00 00       	call   8021e8 <__udivdi3>
  800b1d:	83 c4 10             	add    $0x10,%esp
  800b20:	83 ec 04             	sub    $0x4,%esp
  800b23:	ff 75 20             	pushl  0x20(%ebp)
  800b26:	53                   	push   %ebx
  800b27:	ff 75 18             	pushl  0x18(%ebp)
  800b2a:	52                   	push   %edx
  800b2b:	50                   	push   %eax
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	ff 75 08             	pushl  0x8(%ebp)
  800b32:	e8 a1 ff ff ff       	call   800ad8 <printnum>
  800b37:	83 c4 20             	add    $0x20,%esp
  800b3a:	eb 1a                	jmp    800b56 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	ff 75 20             	pushl  0x20(%ebp)
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	ff d0                	call   *%eax
  800b4a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b4d:	ff 4d 1c             	decl   0x1c(%ebp)
  800b50:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b54:	7f e6                	jg     800b3c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b56:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b64:	53                   	push   %ebx
  800b65:	51                   	push   %ecx
  800b66:	52                   	push   %edx
  800b67:	50                   	push   %eax
  800b68:	e8 8b 17 00 00       	call   8022f8 <__umoddi3>
  800b6d:	83 c4 10             	add    $0x10,%esp
  800b70:	05 14 2a 80 00       	add    $0x802a14,%eax
  800b75:	8a 00                	mov    (%eax),%al
  800b77:	0f be c0             	movsbl %al,%eax
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	ff 75 0c             	pushl  0xc(%ebp)
  800b80:	50                   	push   %eax
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	ff d0                	call   *%eax
  800b86:	83 c4 10             	add    $0x10,%esp
}
  800b89:	90                   	nop
  800b8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b8d:	c9                   	leave  
  800b8e:	c3                   	ret    

00800b8f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b92:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b96:	7e 1c                	jle    800bb4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8b 00                	mov    (%eax),%eax
  800b9d:	8d 50 08             	lea    0x8(%eax),%edx
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	89 10                	mov    %edx,(%eax)
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8b 00                	mov    (%eax),%eax
  800baa:	83 e8 08             	sub    $0x8,%eax
  800bad:	8b 50 04             	mov    0x4(%eax),%edx
  800bb0:	8b 00                	mov    (%eax),%eax
  800bb2:	eb 40                	jmp    800bf4 <getuint+0x65>
	else if (lflag)
  800bb4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb8:	74 1e                	je     800bd8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8b 00                	mov    (%eax),%eax
  800bbf:	8d 50 04             	lea    0x4(%eax),%edx
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	89 10                	mov    %edx,(%eax)
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	83 e8 04             	sub    $0x4,%eax
  800bcf:	8b 00                	mov    (%eax),%eax
  800bd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd6:	eb 1c                	jmp    800bf4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	8b 00                	mov    (%eax),%eax
  800bdd:	8d 50 04             	lea    0x4(%eax),%edx
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	89 10                	mov    %edx,(%eax)
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	8b 00                	mov    (%eax),%eax
  800bea:	83 e8 04             	sub    $0x4,%eax
  800bed:	8b 00                	mov    (%eax),%eax
  800bef:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bf9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bfd:	7e 1c                	jle    800c1b <getint+0x25>
		return va_arg(*ap, long long);
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	8b 00                	mov    (%eax),%eax
  800c04:	8d 50 08             	lea    0x8(%eax),%edx
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	89 10                	mov    %edx,(%eax)
  800c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0f:	8b 00                	mov    (%eax),%eax
  800c11:	83 e8 08             	sub    $0x8,%eax
  800c14:	8b 50 04             	mov    0x4(%eax),%edx
  800c17:	8b 00                	mov    (%eax),%eax
  800c19:	eb 38                	jmp    800c53 <getint+0x5d>
	else if (lflag)
  800c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1f:	74 1a                	je     800c3b <getint+0x45>
		return va_arg(*ap, long);
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	8d 50 04             	lea    0x4(%eax),%edx
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	89 10                	mov    %edx,(%eax)
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	8b 00                	mov    (%eax),%eax
  800c33:	83 e8 04             	sub    $0x4,%eax
  800c36:	8b 00                	mov    (%eax),%eax
  800c38:	99                   	cltd   
  800c39:	eb 18                	jmp    800c53 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	8b 00                	mov    (%eax),%eax
  800c40:	8d 50 04             	lea    0x4(%eax),%edx
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	89 10                	mov    %edx,(%eax)
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8b 00                	mov    (%eax),%eax
  800c4d:	83 e8 04             	sub    $0x4,%eax
  800c50:	8b 00                	mov    (%eax),%eax
  800c52:	99                   	cltd   
}
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
  800c5a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c5d:	eb 17                	jmp    800c76 <vprintfmt+0x21>
			if (ch == '\0')
  800c5f:	85 db                	test   %ebx,%ebx
  800c61:	0f 84 c1 03 00 00    	je     801028 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	ff 75 0c             	pushl  0xc(%ebp)
  800c6d:	53                   	push   %ebx
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	ff d0                	call   *%eax
  800c73:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c76:	8b 45 10             	mov    0x10(%ebp),%eax
  800c79:	8d 50 01             	lea    0x1(%eax),%edx
  800c7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	0f b6 d8             	movzbl %al,%ebx
  800c84:	83 fb 25             	cmp    $0x25,%ebx
  800c87:	75 d6                	jne    800c5f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c89:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c8d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c94:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c9b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ca2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	8d 50 01             	lea    0x1(%eax),%edx
  800caf:	89 55 10             	mov    %edx,0x10(%ebp)
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	0f b6 d8             	movzbl %al,%ebx
  800cb7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800cba:	83 f8 5b             	cmp    $0x5b,%eax
  800cbd:	0f 87 3d 03 00 00    	ja     801000 <vprintfmt+0x3ab>
  800cc3:	8b 04 85 38 2a 80 00 	mov    0x802a38(,%eax,4),%eax
  800cca:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ccc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cd0:	eb d7                	jmp    800ca9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cd2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800cd6:	eb d1                	jmp    800ca9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ce2:	89 d0                	mov    %edx,%eax
  800ce4:	c1 e0 02             	shl    $0x2,%eax
  800ce7:	01 d0                	add    %edx,%eax
  800ce9:	01 c0                	add    %eax,%eax
  800ceb:	01 d8                	add    %ebx,%eax
  800ced:	83 e8 30             	sub    $0x30,%eax
  800cf0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cfb:	83 fb 2f             	cmp    $0x2f,%ebx
  800cfe:	7e 3e                	jle    800d3e <vprintfmt+0xe9>
  800d00:	83 fb 39             	cmp    $0x39,%ebx
  800d03:	7f 39                	jg     800d3e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d05:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d08:	eb d5                	jmp    800cdf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0d:	83 c0 04             	add    $0x4,%eax
  800d10:	89 45 14             	mov    %eax,0x14(%ebp)
  800d13:	8b 45 14             	mov    0x14(%ebp),%eax
  800d16:	83 e8 04             	sub    $0x4,%eax
  800d19:	8b 00                	mov    (%eax),%eax
  800d1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d1e:	eb 1f                	jmp    800d3f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d24:	79 83                	jns    800ca9 <vprintfmt+0x54>
				width = 0;
  800d26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d2d:	e9 77 ff ff ff       	jmp    800ca9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d32:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d39:	e9 6b ff ff ff       	jmp    800ca9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d3e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d3f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d43:	0f 89 60 ff ff ff    	jns    800ca9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d4f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d56:	e9 4e ff ff ff       	jmp    800ca9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d5b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d5e:	e9 46 ff ff ff       	jmp    800ca9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d63:	8b 45 14             	mov    0x14(%ebp),%eax
  800d66:	83 c0 04             	add    $0x4,%eax
  800d69:	89 45 14             	mov    %eax,0x14(%ebp)
  800d6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6f:	83 e8 04             	sub    $0x4,%eax
  800d72:	8b 00                	mov    (%eax),%eax
  800d74:	83 ec 08             	sub    $0x8,%esp
  800d77:	ff 75 0c             	pushl  0xc(%ebp)
  800d7a:	50                   	push   %eax
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	ff d0                	call   *%eax
  800d80:	83 c4 10             	add    $0x10,%esp
			break;
  800d83:	e9 9b 02 00 00       	jmp    801023 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d88:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8b:	83 c0 04             	add    $0x4,%eax
  800d8e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d91:	8b 45 14             	mov    0x14(%ebp),%eax
  800d94:	83 e8 04             	sub    $0x4,%eax
  800d97:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d99:	85 db                	test   %ebx,%ebx
  800d9b:	79 02                	jns    800d9f <vprintfmt+0x14a>
				err = -err;
  800d9d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d9f:	83 fb 64             	cmp    $0x64,%ebx
  800da2:	7f 0b                	jg     800daf <vprintfmt+0x15a>
  800da4:	8b 34 9d 80 28 80 00 	mov    0x802880(,%ebx,4),%esi
  800dab:	85 f6                	test   %esi,%esi
  800dad:	75 19                	jne    800dc8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800daf:	53                   	push   %ebx
  800db0:	68 25 2a 80 00       	push   $0x802a25
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	ff 75 08             	pushl  0x8(%ebp)
  800dbb:	e8 70 02 00 00       	call   801030 <printfmt>
  800dc0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dc3:	e9 5b 02 00 00       	jmp    801023 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dc8:	56                   	push   %esi
  800dc9:	68 2e 2a 80 00       	push   $0x802a2e
  800dce:	ff 75 0c             	pushl  0xc(%ebp)
  800dd1:	ff 75 08             	pushl  0x8(%ebp)
  800dd4:	e8 57 02 00 00       	call   801030 <printfmt>
  800dd9:	83 c4 10             	add    $0x10,%esp
			break;
  800ddc:	e9 42 02 00 00       	jmp    801023 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800de1:	8b 45 14             	mov    0x14(%ebp),%eax
  800de4:	83 c0 04             	add    $0x4,%eax
  800de7:	89 45 14             	mov    %eax,0x14(%ebp)
  800dea:	8b 45 14             	mov    0x14(%ebp),%eax
  800ded:	83 e8 04             	sub    $0x4,%eax
  800df0:	8b 30                	mov    (%eax),%esi
  800df2:	85 f6                	test   %esi,%esi
  800df4:	75 05                	jne    800dfb <vprintfmt+0x1a6>
				p = "(null)";
  800df6:	be 31 2a 80 00       	mov    $0x802a31,%esi
			if (width > 0 && padc != '-')
  800dfb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dff:	7e 6d                	jle    800e6e <vprintfmt+0x219>
  800e01:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e05:	74 67                	je     800e6e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	50                   	push   %eax
  800e0e:	56                   	push   %esi
  800e0f:	e8 26 05 00 00       	call   80133a <strnlen>
  800e14:	83 c4 10             	add    $0x10,%esp
  800e17:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e1a:	eb 16                	jmp    800e32 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e1c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e20:	83 ec 08             	sub    $0x8,%esp
  800e23:	ff 75 0c             	pushl  0xc(%ebp)
  800e26:	50                   	push   %eax
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e36:	7f e4                	jg     800e1c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e38:	eb 34                	jmp    800e6e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e3e:	74 1c                	je     800e5c <vprintfmt+0x207>
  800e40:	83 fb 1f             	cmp    $0x1f,%ebx
  800e43:	7e 05                	jle    800e4a <vprintfmt+0x1f5>
  800e45:	83 fb 7e             	cmp    $0x7e,%ebx
  800e48:	7e 12                	jle    800e5c <vprintfmt+0x207>
					putch('?', putdat);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	6a 3f                	push   $0x3f
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	ff d0                	call   *%eax
  800e57:	83 c4 10             	add    $0x10,%esp
  800e5a:	eb 0f                	jmp    800e6b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e5c:	83 ec 08             	sub    $0x8,%esp
  800e5f:	ff 75 0c             	pushl  0xc(%ebp)
  800e62:	53                   	push   %ebx
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	ff d0                	call   *%eax
  800e68:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e6b:	ff 4d e4             	decl   -0x1c(%ebp)
  800e6e:	89 f0                	mov    %esi,%eax
  800e70:	8d 70 01             	lea    0x1(%eax),%esi
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	0f be d8             	movsbl %al,%ebx
  800e78:	85 db                	test   %ebx,%ebx
  800e7a:	74 24                	je     800ea0 <vprintfmt+0x24b>
  800e7c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e80:	78 b8                	js     800e3a <vprintfmt+0x1e5>
  800e82:	ff 4d e0             	decl   -0x20(%ebp)
  800e85:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e89:	79 af                	jns    800e3a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e8b:	eb 13                	jmp    800ea0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e8d:	83 ec 08             	sub    $0x8,%esp
  800e90:	ff 75 0c             	pushl  0xc(%ebp)
  800e93:	6a 20                	push   $0x20
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	ff d0                	call   *%eax
  800e9a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e9d:	ff 4d e4             	decl   -0x1c(%ebp)
  800ea0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ea4:	7f e7                	jg     800e8d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ea6:	e9 78 01 00 00       	jmp    801023 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800eab:	83 ec 08             	sub    $0x8,%esp
  800eae:	ff 75 e8             	pushl  -0x18(%ebp)
  800eb1:	8d 45 14             	lea    0x14(%ebp),%eax
  800eb4:	50                   	push   %eax
  800eb5:	e8 3c fd ff ff       	call   800bf6 <getint>
  800eba:	83 c4 10             	add    $0x10,%esp
  800ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec9:	85 d2                	test   %edx,%edx
  800ecb:	79 23                	jns    800ef0 <vprintfmt+0x29b>
				putch('-', putdat);
  800ecd:	83 ec 08             	sub    $0x8,%esp
  800ed0:	ff 75 0c             	pushl  0xc(%ebp)
  800ed3:	6a 2d                	push   $0x2d
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	ff d0                	call   *%eax
  800eda:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ee3:	f7 d8                	neg    %eax
  800ee5:	83 d2 00             	adc    $0x0,%edx
  800ee8:	f7 da                	neg    %edx
  800eea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ef0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ef7:	e9 bc 00 00 00       	jmp    800fb8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800efc:	83 ec 08             	sub    $0x8,%esp
  800eff:	ff 75 e8             	pushl  -0x18(%ebp)
  800f02:	8d 45 14             	lea    0x14(%ebp),%eax
  800f05:	50                   	push   %eax
  800f06:	e8 84 fc ff ff       	call   800b8f <getuint>
  800f0b:	83 c4 10             	add    $0x10,%esp
  800f0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f11:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f14:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f1b:	e9 98 00 00 00       	jmp    800fb8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	6a 58                	push   $0x58
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	6a 58                	push   $0x58
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	ff d0                	call   *%eax
  800f3d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f40:	83 ec 08             	sub    $0x8,%esp
  800f43:	ff 75 0c             	pushl  0xc(%ebp)
  800f46:	6a 58                	push   $0x58
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	ff d0                	call   *%eax
  800f4d:	83 c4 10             	add    $0x10,%esp
			break;
  800f50:	e9 ce 00 00 00       	jmp    801023 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	6a 30                	push   $0x30
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	ff d0                	call   *%eax
  800f62:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	6a 78                	push   $0x78
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	ff d0                	call   *%eax
  800f72:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f75:	8b 45 14             	mov    0x14(%ebp),%eax
  800f78:	83 c0 04             	add    $0x4,%eax
  800f7b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f81:	83 e8 04             	sub    $0x4,%eax
  800f84:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f90:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f97:	eb 1f                	jmp    800fb8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f99:	83 ec 08             	sub    $0x8,%esp
  800f9c:	ff 75 e8             	pushl  -0x18(%ebp)
  800f9f:	8d 45 14             	lea    0x14(%ebp),%eax
  800fa2:	50                   	push   %eax
  800fa3:	e8 e7 fb ff ff       	call   800b8f <getuint>
  800fa8:	83 c4 10             	add    $0x10,%esp
  800fab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fb1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fb8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fbf:	83 ec 04             	sub    $0x4,%esp
  800fc2:	52                   	push   %edx
  800fc3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fc6:	50                   	push   %eax
  800fc7:	ff 75 f4             	pushl  -0xc(%ebp)
  800fca:	ff 75 f0             	pushl  -0x10(%ebp)
  800fcd:	ff 75 0c             	pushl  0xc(%ebp)
  800fd0:	ff 75 08             	pushl  0x8(%ebp)
  800fd3:	e8 00 fb ff ff       	call   800ad8 <printnum>
  800fd8:	83 c4 20             	add    $0x20,%esp
			break;
  800fdb:	eb 46                	jmp    801023 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fdd:	83 ec 08             	sub    $0x8,%esp
  800fe0:	ff 75 0c             	pushl  0xc(%ebp)
  800fe3:	53                   	push   %ebx
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	ff d0                	call   *%eax
  800fe9:	83 c4 10             	add    $0x10,%esp
			break;
  800fec:	eb 35                	jmp    801023 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800fee:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800ff5:	eb 2c                	jmp    801023 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ff7:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800ffe:	eb 23                	jmp    801023 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801000:	83 ec 08             	sub    $0x8,%esp
  801003:	ff 75 0c             	pushl  0xc(%ebp)
  801006:	6a 25                	push   $0x25
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	ff d0                	call   *%eax
  80100d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801010:	ff 4d 10             	decl   0x10(%ebp)
  801013:	eb 03                	jmp    801018 <vprintfmt+0x3c3>
  801015:	ff 4d 10             	decl   0x10(%ebp)
  801018:	8b 45 10             	mov    0x10(%ebp),%eax
  80101b:	48                   	dec    %eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 25                	cmp    $0x25,%al
  801020:	75 f3                	jne    801015 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801022:	90                   	nop
		}
	}
  801023:	e9 35 fc ff ff       	jmp    800c5d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801028:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801029:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    

00801030 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801036:	8d 45 10             	lea    0x10(%ebp),%eax
  801039:	83 c0 04             	add    $0x4,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	ff 75 f4             	pushl  -0xc(%ebp)
  801045:	50                   	push   %eax
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	ff 75 08             	pushl  0x8(%ebp)
  80104c:	e8 04 fc ff ff       	call   800c55 <vprintfmt>
  801051:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801054:	90                   	nop
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80105a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105d:	8b 40 08             	mov    0x8(%eax),%eax
  801060:	8d 50 01             	lea    0x1(%eax),%edx
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	8b 10                	mov    (%eax),%edx
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	8b 40 04             	mov    0x4(%eax),%eax
  801074:	39 c2                	cmp    %eax,%edx
  801076:	73 12                	jae    80108a <sprintputch+0x33>
		*b->buf++ = ch;
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	8b 00                	mov    (%eax),%eax
  80107d:	8d 48 01             	lea    0x1(%eax),%ecx
  801080:	8b 55 0c             	mov    0xc(%ebp),%edx
  801083:	89 0a                	mov    %ecx,(%edx)
  801085:	8b 55 08             	mov    0x8(%ebp),%edx
  801088:	88 10                	mov    %dl,(%eax)
}
  80108a:	90                   	nop
  80108b:	5d                   	pop    %ebp
  80108c:	c3                   	ret    

0080108d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b2:	74 06                	je     8010ba <vsnprintf+0x2d>
  8010b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010b8:	7f 07                	jg     8010c1 <vsnprintf+0x34>
		return -E_INVAL;
  8010ba:	b8 03 00 00 00       	mov    $0x3,%eax
  8010bf:	eb 20                	jmp    8010e1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010c1:	ff 75 14             	pushl  0x14(%ebp)
  8010c4:	ff 75 10             	pushl  0x10(%ebp)
  8010c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ca:	50                   	push   %eax
  8010cb:	68 57 10 80 00       	push   $0x801057
  8010d0:	e8 80 fb ff ff       	call   800c55 <vprintfmt>
  8010d5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010db:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010e1:	c9                   	leave  
  8010e2:	c3                   	ret    

008010e3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010e9:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ec:	83 c0 04             	add    $0x4,%eax
  8010ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f8:	50                   	push   %eax
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	ff 75 08             	pushl  0x8(%ebp)
  8010ff:	e8 89 ff ff ff       	call   80108d <vsnprintf>
  801104:	83 c4 10             	add    $0x10,%esp
  801107:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80110a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80110d:	c9                   	leave  
  80110e:	c3                   	ret    

0080110f <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801119:	74 13                	je     80112e <readline+0x1f>
		cprintf("%s", prompt);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 08             	pushl  0x8(%ebp)
  801121:	68 a8 2b 80 00       	push   $0x802ba8
  801126:	e8 50 f9 ff ff       	call   800a7b <cprintf>
  80112b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80112e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801135:	83 ec 0c             	sub    $0xc,%esp
  801138:	6a 00                	push   $0x0
  80113a:	e8 28 f5 ff ff       	call   800667 <iscons>
  80113f:	83 c4 10             	add    $0x10,%esp
  801142:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801145:	e8 0a f5 ff ff       	call   800654 <getchar>
  80114a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80114d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801151:	79 22                	jns    801175 <readline+0x66>
			if (c != -E_EOF)
  801153:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801157:	0f 84 ad 00 00 00    	je     80120a <readline+0xfb>
				cprintf("read error: %e\n", c);
  80115d:	83 ec 08             	sub    $0x8,%esp
  801160:	ff 75 ec             	pushl  -0x14(%ebp)
  801163:	68 ab 2b 80 00       	push   $0x802bab
  801168:	e8 0e f9 ff ff       	call   800a7b <cprintf>
  80116d:	83 c4 10             	add    $0x10,%esp
			break;
  801170:	e9 95 00 00 00       	jmp    80120a <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801175:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801179:	7e 34                	jle    8011af <readline+0xa0>
  80117b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801182:	7f 2b                	jg     8011af <readline+0xa0>
			if (echoing)
  801184:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801188:	74 0e                	je     801198 <readline+0x89>
				cputchar(c);
  80118a:	83 ec 0c             	sub    $0xc,%esp
  80118d:	ff 75 ec             	pushl  -0x14(%ebp)
  801190:	e8 a0 f4 ff ff       	call   800635 <cputchar>
  801195:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119b:	8d 50 01             	lea    0x1(%eax),%edx
  80119e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011a1:	89 c2                	mov    %eax,%edx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 d0                	add    %edx,%eax
  8011a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ab:	88 10                	mov    %dl,(%eax)
  8011ad:	eb 56                	jmp    801205 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8011af:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8011b3:	75 1f                	jne    8011d4 <readline+0xc5>
  8011b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8011b9:	7e 19                	jle    8011d4 <readline+0xc5>
			if (echoing)
  8011bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011bf:	74 0e                	je     8011cf <readline+0xc0>
				cputchar(c);
  8011c1:	83 ec 0c             	sub    $0xc,%esp
  8011c4:	ff 75 ec             	pushl  -0x14(%ebp)
  8011c7:	e8 69 f4 ff ff       	call   800635 <cputchar>
  8011cc:	83 c4 10             	add    $0x10,%esp

			i--;
  8011cf:	ff 4d f4             	decl   -0xc(%ebp)
  8011d2:	eb 31                	jmp    801205 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8011d4:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8011d8:	74 0a                	je     8011e4 <readline+0xd5>
  8011da:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8011de:	0f 85 61 ff ff ff    	jne    801145 <readline+0x36>
			if (echoing)
  8011e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011e8:	74 0e                	je     8011f8 <readline+0xe9>
				cputchar(c);
  8011ea:	83 ec 0c             	sub    $0xc,%esp
  8011ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8011f0:	e8 40 f4 ff ff       	call   800635 <cputchar>
  8011f5:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801203:	eb 06                	jmp    80120b <readline+0xfc>
		}
	}
  801205:	e9 3b ff ff ff       	jmp    801145 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80120a:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80120b:	90                   	nop
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801214:	e8 9b 09 00 00       	call   801bb4 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80121d:	74 13                	je     801232 <atomic_readline+0x24>
			cprintf("%s", prompt);
  80121f:	83 ec 08             	sub    $0x8,%esp
  801222:	ff 75 08             	pushl  0x8(%ebp)
  801225:	68 a8 2b 80 00       	push   $0x802ba8
  80122a:	e8 4c f8 ff ff       	call   800a7b <cprintf>
  80122f:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801232:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801239:	83 ec 0c             	sub    $0xc,%esp
  80123c:	6a 00                	push   $0x0
  80123e:	e8 24 f4 ff ff       	call   800667 <iscons>
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801249:	e8 06 f4 ff ff       	call   800654 <getchar>
  80124e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801251:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801255:	79 22                	jns    801279 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801257:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80125b:	0f 84 ad 00 00 00    	je     80130e <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801261:	83 ec 08             	sub    $0x8,%esp
  801264:	ff 75 ec             	pushl  -0x14(%ebp)
  801267:	68 ab 2b 80 00       	push   $0x802bab
  80126c:	e8 0a f8 ff ff       	call   800a7b <cprintf>
  801271:	83 c4 10             	add    $0x10,%esp
				break;
  801274:	e9 95 00 00 00       	jmp    80130e <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801279:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80127d:	7e 34                	jle    8012b3 <atomic_readline+0xa5>
  80127f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801286:	7f 2b                	jg     8012b3 <atomic_readline+0xa5>
				if (echoing)
  801288:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80128c:	74 0e                	je     80129c <atomic_readline+0x8e>
					cputchar(c);
  80128e:	83 ec 0c             	sub    $0xc,%esp
  801291:	ff 75 ec             	pushl  -0x14(%ebp)
  801294:	e8 9c f3 ff ff       	call   800635 <cputchar>
  801299:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80129c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129f:	8d 50 01             	lea    0x1(%eax),%edx
  8012a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012a5:	89 c2                	mov    %eax,%edx
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	01 d0                	add    %edx,%eax
  8012ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012af:	88 10                	mov    %dl,(%eax)
  8012b1:	eb 56                	jmp    801309 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  8012b3:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012b7:	75 1f                	jne    8012d8 <atomic_readline+0xca>
  8012b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012bd:	7e 19                	jle    8012d8 <atomic_readline+0xca>
				if (echoing)
  8012bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012c3:	74 0e                	je     8012d3 <atomic_readline+0xc5>
					cputchar(c);
  8012c5:	83 ec 0c             	sub    $0xc,%esp
  8012c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8012cb:	e8 65 f3 ff ff       	call   800635 <cputchar>
  8012d0:	83 c4 10             	add    $0x10,%esp
				i--;
  8012d3:	ff 4d f4             	decl   -0xc(%ebp)
  8012d6:	eb 31                	jmp    801309 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  8012d8:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012dc:	74 0a                	je     8012e8 <atomic_readline+0xda>
  8012de:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012e2:	0f 85 61 ff ff ff    	jne    801249 <atomic_readline+0x3b>
				if (echoing)
  8012e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ec:	74 0e                	je     8012fc <atomic_readline+0xee>
					cputchar(c);
  8012ee:	83 ec 0c             	sub    $0xc,%esp
  8012f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8012f4:	e8 3c f3 ff ff       	call   800635 <cputchar>
  8012f9:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  8012fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801307:	eb 06                	jmp    80130f <atomic_readline+0x101>
			}
		}
  801309:	e9 3b ff ff ff       	jmp    801249 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  80130e:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  80130f:	e8 ba 08 00 00       	call   801bce <sys_unlock_cons>
}
  801314:	90                   	nop
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80131d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801324:	eb 06                	jmp    80132c <strlen+0x15>
		n++;
  801326:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801329:	ff 45 08             	incl   0x8(%ebp)
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	84 c0                	test   %al,%al
  801333:	75 f1                	jne    801326 <strlen+0xf>
		n++;
	return n;
  801335:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801338:	c9                   	leave  
  801339:	c3                   	ret    

0080133a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801340:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801347:	eb 09                	jmp    801352 <strnlen+0x18>
		n++;
  801349:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80134c:	ff 45 08             	incl   0x8(%ebp)
  80134f:	ff 4d 0c             	decl   0xc(%ebp)
  801352:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801356:	74 09                	je     801361 <strnlen+0x27>
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	8a 00                	mov    (%eax),%al
  80135d:	84 c0                	test   %al,%al
  80135f:	75 e8                	jne    801349 <strnlen+0xf>
		n++;
	return n;
  801361:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801372:	90                   	nop
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8d 50 01             	lea    0x1(%eax),%edx
  801379:	89 55 08             	mov    %edx,0x8(%ebp)
  80137c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801382:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801385:	8a 12                	mov    (%edx),%dl
  801387:	88 10                	mov    %dl,(%eax)
  801389:	8a 00                	mov    (%eax),%al
  80138b:	84 c0                	test   %al,%al
  80138d:	75 e4                	jne    801373 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80138f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013a7:	eb 1f                	jmp    8013c8 <strncpy+0x34>
		*dst++ = *src;
  8013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ac:	8d 50 01             	lea    0x1(%eax),%edx
  8013af:	89 55 08             	mov    %edx,0x8(%ebp)
  8013b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b5:	8a 12                	mov    (%edx),%dl
  8013b7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bc:	8a 00                	mov    (%eax),%al
  8013be:	84 c0                	test   %al,%al
  8013c0:	74 03                	je     8013c5 <strncpy+0x31>
			src++;
  8013c2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013c5:	ff 45 fc             	incl   -0x4(%ebp)
  8013c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013ce:	72 d9                	jb     8013a9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e5:	74 30                	je     801417 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013e7:	eb 16                	jmp    8013ff <strlcpy+0x2a>
			*dst++ = *src++;
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8d 50 01             	lea    0x1(%eax),%edx
  8013ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8013f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013f8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013fb:	8a 12                	mov    (%edx),%dl
  8013fd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013ff:	ff 4d 10             	decl   0x10(%ebp)
  801402:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801406:	74 09                	je     801411 <strlcpy+0x3c>
  801408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	84 c0                	test   %al,%al
  80140f:	75 d8                	jne    8013e9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801417:	8b 55 08             	mov    0x8(%ebp),%edx
  80141a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80141d:	29 c2                	sub    %eax,%edx
  80141f:	89 d0                	mov    %edx,%eax
}
  801421:	c9                   	leave  
  801422:	c3                   	ret    

00801423 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801426:	eb 06                	jmp    80142e <strcmp+0xb>
		p++, q++;
  801428:	ff 45 08             	incl   0x8(%ebp)
  80142b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 00                	mov    (%eax),%al
  801433:	84 c0                	test   %al,%al
  801435:	74 0e                	je     801445 <strcmp+0x22>
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8a 10                	mov    (%eax),%dl
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	38 c2                	cmp    %al,%dl
  801443:	74 e3                	je     801428 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	0f b6 d0             	movzbl %al,%edx
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	8a 00                	mov    (%eax),%al
  801452:	0f b6 c0             	movzbl %al,%eax
  801455:	29 c2                	sub    %eax,%edx
  801457:	89 d0                	mov    %edx,%eax
}
  801459:	5d                   	pop    %ebp
  80145a:	c3                   	ret    

0080145b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80145e:	eb 09                	jmp    801469 <strncmp+0xe>
		n--, p++, q++;
  801460:	ff 4d 10             	decl   0x10(%ebp)
  801463:	ff 45 08             	incl   0x8(%ebp)
  801466:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801469:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146d:	74 17                	je     801486 <strncmp+0x2b>
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	84 c0                	test   %al,%al
  801476:	74 0e                	je     801486 <strncmp+0x2b>
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	8a 10                	mov    (%eax),%dl
  80147d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	38 c2                	cmp    %al,%dl
  801484:	74 da                	je     801460 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801486:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80148a:	75 07                	jne    801493 <strncmp+0x38>
		return 0;
  80148c:	b8 00 00 00 00       	mov    $0x0,%eax
  801491:	eb 14                	jmp    8014a7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	0f b6 d0             	movzbl %al,%edx
  80149b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	0f b6 c0             	movzbl %al,%eax
  8014a3:	29 c2                	sub    %eax,%edx
  8014a5:	89 d0                	mov    %edx,%eax
}
  8014a7:	5d                   	pop    %ebp
  8014a8:	c3                   	ret    

008014a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014b5:	eb 12                	jmp    8014c9 <strchr+0x20>
		if (*s == c)
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	8a 00                	mov    (%eax),%al
  8014bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014bf:	75 05                	jne    8014c6 <strchr+0x1d>
			return (char *) s;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	eb 11                	jmp    8014d7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014c6:	ff 45 08             	incl   0x8(%ebp)
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cc:	8a 00                	mov    (%eax),%al
  8014ce:	84 c0                	test   %al,%al
  8014d0:	75 e5                	jne    8014b7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014e5:	eb 0d                	jmp    8014f4 <strfind+0x1b>
		if (*s == c)
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014ef:	74 0e                	je     8014ff <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014f1:	ff 45 08             	incl   0x8(%ebp)
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	84 c0                	test   %al,%al
  8014fb:	75 ea                	jne    8014e7 <strfind+0xe>
  8014fd:	eb 01                	jmp    801500 <strfind+0x27>
		if (*s == c)
			break;
  8014ff:	90                   	nop
	return (char *) s;
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801511:	8b 45 10             	mov    0x10(%ebp),%eax
  801514:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801517:	eb 0e                	jmp    801527 <memset+0x22>
		*p++ = c;
  801519:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80151c:	8d 50 01             	lea    0x1(%eax),%edx
  80151f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801522:	8b 55 0c             	mov    0xc(%ebp),%edx
  801525:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801527:	ff 4d f8             	decl   -0x8(%ebp)
  80152a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80152e:	79 e9                	jns    801519 <memset+0x14>
		*p++ = c;

	return v;
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80153b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801547:	eb 16                	jmp    80155f <memcpy+0x2a>
		*d++ = *s++;
  801549:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154c:	8d 50 01             	lea    0x1(%eax),%edx
  80154f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801552:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801555:	8d 4a 01             	lea    0x1(%edx),%ecx
  801558:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80155b:	8a 12                	mov    (%edx),%dl
  80155d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80155f:	8b 45 10             	mov    0x10(%ebp),%eax
  801562:	8d 50 ff             	lea    -0x1(%eax),%edx
  801565:	89 55 10             	mov    %edx,0x10(%ebp)
  801568:	85 c0                	test   %eax,%eax
  80156a:	75 dd                	jne    801549 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801577:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801583:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801586:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801589:	73 50                	jae    8015db <memmove+0x6a>
  80158b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	01 d0                	add    %edx,%eax
  801593:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801596:	76 43                	jbe    8015db <memmove+0x6a>
		s += n;
  801598:	8b 45 10             	mov    0x10(%ebp),%eax
  80159b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80159e:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015a4:	eb 10                	jmp    8015b6 <memmove+0x45>
			*--d = *--s;
  8015a6:	ff 4d f8             	decl   -0x8(%ebp)
  8015a9:	ff 4d fc             	decl   -0x4(%ebp)
  8015ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015af:	8a 10                	mov    (%eax),%dl
  8015b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8015bf:	85 c0                	test   %eax,%eax
  8015c1:	75 e3                	jne    8015a6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015c3:	eb 23                	jmp    8015e8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8015c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c8:	8d 50 01             	lea    0x1(%eax),%edx
  8015cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015d4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015d7:	8a 12                	mov    (%edx),%dl
  8015d9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8015db:	8b 45 10             	mov    0x10(%ebp),%eax
  8015de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	75 dd                	jne    8015c5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015ff:	eb 2a                	jmp    80162b <memcmp+0x3e>
		if (*s1 != *s2)
  801601:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801604:	8a 10                	mov    (%eax),%dl
  801606:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801609:	8a 00                	mov    (%eax),%al
  80160b:	38 c2                	cmp    %al,%dl
  80160d:	74 16                	je     801625 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80160f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801612:	8a 00                	mov    (%eax),%al
  801614:	0f b6 d0             	movzbl %al,%edx
  801617:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80161a:	8a 00                	mov    (%eax),%al
  80161c:	0f b6 c0             	movzbl %al,%eax
  80161f:	29 c2                	sub    %eax,%edx
  801621:	89 d0                	mov    %edx,%eax
  801623:	eb 18                	jmp    80163d <memcmp+0x50>
		s1++, s2++;
  801625:	ff 45 fc             	incl   -0x4(%ebp)
  801628:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80162b:	8b 45 10             	mov    0x10(%ebp),%eax
  80162e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801631:	89 55 10             	mov    %edx,0x10(%ebp)
  801634:	85 c0                	test   %eax,%eax
  801636:	75 c9                	jne    801601 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801638:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801645:	8b 55 08             	mov    0x8(%ebp),%edx
  801648:	8b 45 10             	mov    0x10(%ebp),%eax
  80164b:	01 d0                	add    %edx,%eax
  80164d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801650:	eb 15                	jmp    801667 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	8a 00                	mov    (%eax),%al
  801657:	0f b6 d0             	movzbl %al,%edx
  80165a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165d:	0f b6 c0             	movzbl %al,%eax
  801660:	39 c2                	cmp    %eax,%edx
  801662:	74 0d                	je     801671 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801664:	ff 45 08             	incl   0x8(%ebp)
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80166d:	72 e3                	jb     801652 <memfind+0x13>
  80166f:	eb 01                	jmp    801672 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801671:	90                   	nop
	return (void *) s;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80167d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801684:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80168b:	eb 03                	jmp    801690 <strtol+0x19>
		s++;
  80168d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	3c 20                	cmp    $0x20,%al
  801697:	74 f4                	je     80168d <strtol+0x16>
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	8a 00                	mov    (%eax),%al
  80169e:	3c 09                	cmp    $0x9,%al
  8016a0:	74 eb                	je     80168d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	8a 00                	mov    (%eax),%al
  8016a7:	3c 2b                	cmp    $0x2b,%al
  8016a9:	75 05                	jne    8016b0 <strtol+0x39>
		s++;
  8016ab:	ff 45 08             	incl   0x8(%ebp)
  8016ae:	eb 13                	jmp    8016c3 <strtol+0x4c>
	else if (*s == '-')
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	3c 2d                	cmp    $0x2d,%al
  8016b7:	75 0a                	jne    8016c3 <strtol+0x4c>
		s++, neg = 1;
  8016b9:	ff 45 08             	incl   0x8(%ebp)
  8016bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c7:	74 06                	je     8016cf <strtol+0x58>
  8016c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8016cd:	75 20                	jne    8016ef <strtol+0x78>
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	3c 30                	cmp    $0x30,%al
  8016d6:	75 17                	jne    8016ef <strtol+0x78>
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	40                   	inc    %eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	3c 78                	cmp    $0x78,%al
  8016e0:	75 0d                	jne    8016ef <strtol+0x78>
		s += 2, base = 16;
  8016e2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8016e6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016ed:	eb 28                	jmp    801717 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016f3:	75 15                	jne    80170a <strtol+0x93>
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	8a 00                	mov    (%eax),%al
  8016fa:	3c 30                	cmp    $0x30,%al
  8016fc:	75 0c                	jne    80170a <strtol+0x93>
		s++, base = 8;
  8016fe:	ff 45 08             	incl   0x8(%ebp)
  801701:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801708:	eb 0d                	jmp    801717 <strtol+0xa0>
	else if (base == 0)
  80170a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170e:	75 07                	jne    801717 <strtol+0xa0>
		base = 10;
  801710:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	3c 2f                	cmp    $0x2f,%al
  80171e:	7e 19                	jle    801739 <strtol+0xc2>
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8a 00                	mov    (%eax),%al
  801725:	3c 39                	cmp    $0x39,%al
  801727:	7f 10                	jg     801739 <strtol+0xc2>
			dig = *s - '0';
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	8a 00                	mov    (%eax),%al
  80172e:	0f be c0             	movsbl %al,%eax
  801731:	83 e8 30             	sub    $0x30,%eax
  801734:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801737:	eb 42                	jmp    80177b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	3c 60                	cmp    $0x60,%al
  801740:	7e 19                	jle    80175b <strtol+0xe4>
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	8a 00                	mov    (%eax),%al
  801747:	3c 7a                	cmp    $0x7a,%al
  801749:	7f 10                	jg     80175b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	8a 00                	mov    (%eax),%al
  801750:	0f be c0             	movsbl %al,%eax
  801753:	83 e8 57             	sub    $0x57,%eax
  801756:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801759:	eb 20                	jmp    80177b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	3c 40                	cmp    $0x40,%al
  801762:	7e 39                	jle    80179d <strtol+0x126>
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 5a                	cmp    $0x5a,%al
  80176b:	7f 30                	jg     80179d <strtol+0x126>
			dig = *s - 'A' + 10;
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	0f be c0             	movsbl %al,%eax
  801775:	83 e8 37             	sub    $0x37,%eax
  801778:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80177b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801781:	7d 19                	jge    80179c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801783:	ff 45 08             	incl   0x8(%ebp)
  801786:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801789:	0f af 45 10          	imul   0x10(%ebp),%eax
  80178d:	89 c2                	mov    %eax,%edx
  80178f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801792:	01 d0                	add    %edx,%eax
  801794:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801797:	e9 7b ff ff ff       	jmp    801717 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80179c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80179d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017a1:	74 08                	je     8017ab <strtol+0x134>
		*endptr = (char *) s;
  8017a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017af:	74 07                	je     8017b8 <strtol+0x141>
  8017b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b4:	f7 d8                	neg    %eax
  8017b6:	eb 03                	jmp    8017bb <strtol+0x144>
  8017b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <ltostr>:

void
ltostr(long value, char *str)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8017c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8017ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8017d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017d5:	79 13                	jns    8017ea <ltostr+0x2d>
	{
		neg = 1;
  8017d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8017de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8017e4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8017e7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017f2:	99                   	cltd   
  8017f3:	f7 f9                	idiv   %ecx
  8017f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fb:	8d 50 01             	lea    0x1(%eax),%edx
  8017fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801801:	89 c2                	mov    %eax,%edx
  801803:	8b 45 0c             	mov    0xc(%ebp),%eax
  801806:	01 d0                	add    %edx,%eax
  801808:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80180b:	83 c2 30             	add    $0x30,%edx
  80180e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801810:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801813:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801818:	f7 e9                	imul   %ecx
  80181a:	c1 fa 02             	sar    $0x2,%edx
  80181d:	89 c8                	mov    %ecx,%eax
  80181f:	c1 f8 1f             	sar    $0x1f,%eax
  801822:	29 c2                	sub    %eax,%edx
  801824:	89 d0                	mov    %edx,%eax
  801826:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801829:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80182d:	75 bb                	jne    8017ea <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80182f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801836:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801839:	48                   	dec    %eax
  80183a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80183d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801841:	74 3d                	je     801880 <ltostr+0xc3>
		start = 1 ;
  801843:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80184a:	eb 34                	jmp    801880 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80184c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801852:	01 d0                	add    %edx,%eax
  801854:	8a 00                	mov    (%eax),%al
  801856:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801859:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	01 c2                	add    %eax,%edx
  801861:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801864:	8b 45 0c             	mov    0xc(%ebp),%eax
  801867:	01 c8                	add    %ecx,%eax
  801869:	8a 00                	mov    (%eax),%al
  80186b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80186d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801870:	8b 45 0c             	mov    0xc(%ebp),%eax
  801873:	01 c2                	add    %eax,%edx
  801875:	8a 45 eb             	mov    -0x15(%ebp),%al
  801878:	88 02                	mov    %al,(%edx)
		start++ ;
  80187a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80187d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801883:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801886:	7c c4                	jl     80184c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801888:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80188b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80189c:	ff 75 08             	pushl  0x8(%ebp)
  80189f:	e8 73 fa ff ff       	call   801317 <strlen>
  8018a4:	83 c4 04             	add    $0x4,%esp
  8018a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8018aa:	ff 75 0c             	pushl  0xc(%ebp)
  8018ad:	e8 65 fa ff ff       	call   801317 <strlen>
  8018b2:	83 c4 04             	add    $0x4,%esp
  8018b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8018b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8018bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018c6:	eb 17                	jmp    8018df <strcconcat+0x49>
		final[s] = str1[s] ;
  8018c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ce:	01 c2                	add    %eax,%edx
  8018d0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	01 c8                	add    %ecx,%eax
  8018d8:	8a 00                	mov    (%eax),%al
  8018da:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018dc:	ff 45 fc             	incl   -0x4(%ebp)
  8018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018e5:	7c e1                	jl     8018c8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018f5:	eb 1f                	jmp    801916 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018fa:	8d 50 01             	lea    0x1(%eax),%edx
  8018fd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801900:	89 c2                	mov    %eax,%edx
  801902:	8b 45 10             	mov    0x10(%ebp),%eax
  801905:	01 c2                	add    %eax,%edx
  801907:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80190a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190d:	01 c8                	add    %ecx,%eax
  80190f:	8a 00                	mov    (%eax),%al
  801911:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801913:	ff 45 f8             	incl   -0x8(%ebp)
  801916:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801919:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80191c:	7c d9                	jl     8018f7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80191e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801921:	8b 45 10             	mov    0x10(%ebp),%eax
  801924:	01 d0                	add    %edx,%eax
  801926:	c6 00 00             	movb   $0x0,(%eax)
}
  801929:	90                   	nop
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80192f:	8b 45 14             	mov    0x14(%ebp),%eax
  801932:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801938:	8b 45 14             	mov    0x14(%ebp),%eax
  80193b:	8b 00                	mov    (%eax),%eax
  80193d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801944:	8b 45 10             	mov    0x10(%ebp),%eax
  801947:	01 d0                	add    %edx,%eax
  801949:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80194f:	eb 0c                	jmp    80195d <strsplit+0x31>
			*string++ = 0;
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	8d 50 01             	lea    0x1(%eax),%edx
  801957:	89 55 08             	mov    %edx,0x8(%ebp)
  80195a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	8a 00                	mov    (%eax),%al
  801962:	84 c0                	test   %al,%al
  801964:	74 18                	je     80197e <strsplit+0x52>
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	8a 00                	mov    (%eax),%al
  80196b:	0f be c0             	movsbl %al,%eax
  80196e:	50                   	push   %eax
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	e8 32 fb ff ff       	call   8014a9 <strchr>
  801977:	83 c4 08             	add    $0x8,%esp
  80197a:	85 c0                	test   %eax,%eax
  80197c:	75 d3                	jne    801951 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	8a 00                	mov    (%eax),%al
  801983:	84 c0                	test   %al,%al
  801985:	74 5a                	je     8019e1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801987:	8b 45 14             	mov    0x14(%ebp),%eax
  80198a:	8b 00                	mov    (%eax),%eax
  80198c:	83 f8 0f             	cmp    $0xf,%eax
  80198f:	75 07                	jne    801998 <strsplit+0x6c>
		{
			return 0;
  801991:	b8 00 00 00 00       	mov    $0x0,%eax
  801996:	eb 66                	jmp    8019fe <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801998:	8b 45 14             	mov    0x14(%ebp),%eax
  80199b:	8b 00                	mov    (%eax),%eax
  80199d:	8d 48 01             	lea    0x1(%eax),%ecx
  8019a0:	8b 55 14             	mov    0x14(%ebp),%edx
  8019a3:	89 0a                	mov    %ecx,(%edx)
  8019a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8019af:	01 c2                	add    %eax,%edx
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019b6:	eb 03                	jmp    8019bb <strsplit+0x8f>
			string++;
  8019b8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	8a 00                	mov    (%eax),%al
  8019c0:	84 c0                	test   %al,%al
  8019c2:	74 8b                	je     80194f <strsplit+0x23>
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	8a 00                	mov    (%eax),%al
  8019c9:	0f be c0             	movsbl %al,%eax
  8019cc:	50                   	push   %eax
  8019cd:	ff 75 0c             	pushl  0xc(%ebp)
  8019d0:	e8 d4 fa ff ff       	call   8014a9 <strchr>
  8019d5:	83 c4 08             	add    $0x8,%esp
  8019d8:	85 c0                	test   %eax,%eax
  8019da:	74 dc                	je     8019b8 <strsplit+0x8c>
			string++;
	}
  8019dc:	e9 6e ff ff ff       	jmp    80194f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019e1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e5:	8b 00                	mov    (%eax),%eax
  8019e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f1:	01 d0                	add    %edx,%eax
  8019f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019f9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	68 bc 2b 80 00       	push   $0x802bbc
  801a0e:	68 3f 01 00 00       	push   $0x13f
  801a13:	68 de 2b 80 00       	push   $0x802bde
  801a18:	e8 a1 ed ff ff       	call   8007be <_panic>

00801a1d <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801a23:	83 ec 0c             	sub    $0xc,%esp
  801a26:	ff 75 08             	pushl  0x8(%ebp)
  801a29:	e8 ef 06 00 00       	call   80211d <sys_sbrk>
  801a2e:	83 c4 10             	add    $0x10,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801a39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a3d:	75 07                	jne    801a46 <malloc+0x13>
  801a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a44:	eb 14                	jmp    801a5a <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	68 ec 2b 80 00       	push   $0x802bec
  801a4e:	6a 1b                	push   $0x1b
  801a50:	68 11 2c 80 00       	push   $0x802c11
  801a55:	e8 64 ed ff ff       	call   8007be <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801a62:	83 ec 04             	sub    $0x4,%esp
  801a65:	68 20 2c 80 00       	push   $0x802c20
  801a6a:	6a 29                	push   $0x29
  801a6c:	68 11 2c 80 00       	push   $0x802c11
  801a71:	e8 48 ed ff ff       	call   8007be <_panic>

00801a76 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 18             	sub    $0x18,%esp
  801a7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801a82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a86:	75 07                	jne    801a8f <smalloc+0x19>
  801a88:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8d:	eb 14                	jmp    801aa3 <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801a8f:	83 ec 04             	sub    $0x4,%esp
  801a92:	68 44 2c 80 00       	push   $0x802c44
  801a97:	6a 38                	push   $0x38
  801a99:	68 11 2c 80 00       	push   $0x802c11
  801a9e:	e8 1b ed ff ff       	call   8007be <_panic>
	return NULL;
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801aab:	83 ec 04             	sub    $0x4,%esp
  801aae:	68 6c 2c 80 00       	push   $0x802c6c
  801ab3:	6a 43                	push   $0x43
  801ab5:	68 11 2c 80 00       	push   $0x802c11
  801aba:	e8 ff ec ff ff       	call   8007be <_panic>

00801abf <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ac5:	83 ec 04             	sub    $0x4,%esp
  801ac8:	68 90 2c 80 00       	push   $0x802c90
  801acd:	6a 5b                	push   $0x5b
  801acf:	68 11 2c 80 00       	push   $0x802c11
  801ad4:	e8 e5 ec ff ff       	call   8007be <_panic>

00801ad9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	68 b4 2c 80 00       	push   $0x802cb4
  801ae7:	6a 72                	push   $0x72
  801ae9:	68 11 2c 80 00       	push   $0x802c11
  801aee:	e8 cb ec ff ff       	call   8007be <_panic>

00801af3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801af9:	83 ec 04             	sub    $0x4,%esp
  801afc:	68 da 2c 80 00       	push   $0x802cda
  801b01:	6a 7e                	push   $0x7e
  801b03:	68 11 2c 80 00       	push   $0x802c11
  801b08:	e8 b1 ec ff ff       	call   8007be <_panic>

00801b0d <shrink>:

}
void shrink(uint32 newSize)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b13:	83 ec 04             	sub    $0x4,%esp
  801b16:	68 da 2c 80 00       	push   $0x802cda
  801b1b:	68 83 00 00 00       	push   $0x83
  801b20:	68 11 2c 80 00       	push   $0x802c11
  801b25:	e8 94 ec ff ff       	call   8007be <_panic>

00801b2a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b30:	83 ec 04             	sub    $0x4,%esp
  801b33:	68 da 2c 80 00       	push   $0x802cda
  801b38:	68 88 00 00 00       	push   $0x88
  801b3d:	68 11 2c 80 00       	push   $0x802c11
  801b42:	e8 77 ec ff ff       	call   8007be <_panic>

00801b47 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	57                   	push   %edi
  801b4b:	56                   	push   %esi
  801b4c:	53                   	push   %ebx
  801b4d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b59:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b5c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b5f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b62:	cd 30                	int    $0x30
  801b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b6a:	83 c4 10             	add    $0x10,%esp
  801b6d:	5b                   	pop    %ebx
  801b6e:	5e                   	pop    %esi
  801b6f:	5f                   	pop    %edi
  801b70:	5d                   	pop    %ebp
  801b71:	c3                   	ret    

00801b72 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b7e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	52                   	push   %edx
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	50                   	push   %eax
  801b8e:	6a 00                	push   $0x0
  801b90:	e8 b2 ff ff ff       	call   801b47 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	90                   	nop
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_cgetc>:

int
sys_cgetc(void)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 02                	push   $0x2
  801baa:	e8 98 ff ff ff       	call   801b47 <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 03                	push   $0x3
  801bc3:	e8 7f ff ff ff       	call   801b47 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	90                   	nop
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 04                	push   $0x4
  801bdd:	e8 65 ff ff ff       	call   801b47 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	90                   	nop
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801beb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	52                   	push   %edx
  801bf8:	50                   	push   %eax
  801bf9:	6a 08                	push   $0x8
  801bfb:	e8 47 ff ff ff       	call   801b47 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	56                   	push   %esi
  801c09:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c0a:	8b 75 18             	mov    0x18(%ebp),%esi
  801c0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	56                   	push   %esi
  801c1a:	53                   	push   %ebx
  801c1b:	51                   	push   %ecx
  801c1c:	52                   	push   %edx
  801c1d:	50                   	push   %eax
  801c1e:	6a 09                	push   $0x9
  801c20:	e8 22 ff ff ff       	call   801b47 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5d                   	pop    %ebp
  801c2e:	c3                   	ret    

00801c2f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	52                   	push   %edx
  801c3f:	50                   	push   %eax
  801c40:	6a 0a                	push   $0xa
  801c42:	e8 00 ff ff ff       	call   801b47 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	ff 75 0c             	pushl  0xc(%ebp)
  801c58:	ff 75 08             	pushl  0x8(%ebp)
  801c5b:	6a 0b                	push   $0xb
  801c5d:	e8 e5 fe ff ff       	call   801b47 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 0c                	push   $0xc
  801c76:	e8 cc fe ff ff       	call   801b47 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 0d                	push   $0xd
  801c8f:	e8 b3 fe ff ff       	call   801b47 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 0e                	push   $0xe
  801ca8:	e8 9a fe ff ff       	call   801b47 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 0f                	push   $0xf
  801cc1:	e8 81 fe ff ff       	call   801b47 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	ff 75 08             	pushl  0x8(%ebp)
  801cd9:	6a 10                	push   $0x10
  801cdb:	e8 67 fe ff ff       	call   801b47 <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 11                	push   $0x11
  801cf4:	e8 4e fe ff ff       	call   801b47 <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
}
  801cfc:	90                   	nop
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_cputc>:

void
sys_cputc(const char c)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d0b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	50                   	push   %eax
  801d18:	6a 01                	push   $0x1
  801d1a:	e8 28 fe ff ff       	call   801b47 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	90                   	nop
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 14                	push   $0x14
  801d34:	e8 0e fe ff ff       	call   801b47 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
}
  801d3c:	90                   	nop
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 04             	sub    $0x4,%esp
  801d45:	8b 45 10             	mov    0x10(%ebp),%eax
  801d48:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d4b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d4e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	6a 00                	push   $0x0
  801d57:	51                   	push   %ecx
  801d58:	52                   	push   %edx
  801d59:	ff 75 0c             	pushl  0xc(%ebp)
  801d5c:	50                   	push   %eax
  801d5d:	6a 15                	push   $0x15
  801d5f:	e8 e3 fd ff ff       	call   801b47 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	52                   	push   %edx
  801d79:	50                   	push   %eax
  801d7a:	6a 16                	push   $0x16
  801d7c:	e8 c6 fd ff ff       	call   801b47 <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	51                   	push   %ecx
  801d97:	52                   	push   %edx
  801d98:	50                   	push   %eax
  801d99:	6a 17                	push   $0x17
  801d9b:	e8 a7 fd ff ff       	call   801b47 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801da8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	52                   	push   %edx
  801db5:	50                   	push   %eax
  801db6:	6a 18                	push   $0x18
  801db8:	e8 8a fd ff ff       	call   801b47 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	6a 00                	push   $0x0
  801dca:	ff 75 14             	pushl  0x14(%ebp)
  801dcd:	ff 75 10             	pushl  0x10(%ebp)
  801dd0:	ff 75 0c             	pushl  0xc(%ebp)
  801dd3:	50                   	push   %eax
  801dd4:	6a 19                	push   $0x19
  801dd6:	e8 6c fd ff ff       	call   801b47 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801de3:	8b 45 08             	mov    0x8(%ebp),%eax
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	50                   	push   %eax
  801def:	6a 1a                	push   $0x1a
  801df1:	e8 51 fd ff ff       	call   801b47 <syscall>
  801df6:	83 c4 18             	add    $0x18,%esp
}
  801df9:	90                   	nop
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	50                   	push   %eax
  801e0b:	6a 1b                	push   $0x1b
  801e0d:	e8 35 fd ff ff       	call   801b47 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 05                	push   $0x5
  801e26:	e8 1c fd ff ff       	call   801b47 <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 06                	push   $0x6
  801e3f:	e8 03 fd ff ff       	call   801b47 <syscall>
  801e44:	83 c4 18             	add    $0x18,%esp
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 07                	push   $0x7
  801e58:	e8 ea fc ff ff       	call   801b47 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_exit_env>:


void sys_exit_env(void)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 1c                	push   $0x1c
  801e71:	e8 d1 fc ff ff       	call   801b47 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
}
  801e79:	90                   	nop
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e82:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e85:	8d 50 04             	lea    0x4(%eax),%edx
  801e88:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	52                   	push   %edx
  801e92:	50                   	push   %eax
  801e93:	6a 1d                	push   $0x1d
  801e95:	e8 ad fc ff ff       	call   801b47 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
	return result;
  801e9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ea3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ea6:	89 01                	mov    %eax,(%ecx)
  801ea8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	c9                   	leave  
  801eaf:	c2 04 00             	ret    $0x4

00801eb2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	ff 75 10             	pushl  0x10(%ebp)
  801ebc:	ff 75 0c             	pushl  0xc(%ebp)
  801ebf:	ff 75 08             	pushl  0x8(%ebp)
  801ec2:	6a 13                	push   $0x13
  801ec4:	e8 7e fc ff ff       	call   801b47 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecc:	90                   	nop
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_rcr2>:
uint32 sys_rcr2()
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 1e                	push   $0x1e
  801ede:	e8 64 fc ff ff       	call   801b47 <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 04             	sub    $0x4,%esp
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ef4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	50                   	push   %eax
  801f01:	6a 1f                	push   $0x1f
  801f03:	e8 3f fc ff ff       	call   801b47 <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0b:	90                   	nop
}
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <rsttst>:
void rsttst()
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 21                	push   $0x21
  801f1d:	e8 25 fc ff ff       	call   801b47 <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
	return ;
  801f25:	90                   	nop
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	83 ec 04             	sub    $0x4,%esp
  801f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f34:	8b 55 18             	mov    0x18(%ebp),%edx
  801f37:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f3b:	52                   	push   %edx
  801f3c:	50                   	push   %eax
  801f3d:	ff 75 10             	pushl  0x10(%ebp)
  801f40:	ff 75 0c             	pushl  0xc(%ebp)
  801f43:	ff 75 08             	pushl  0x8(%ebp)
  801f46:	6a 20                	push   $0x20
  801f48:	e8 fa fb ff ff       	call   801b47 <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f50:	90                   	nop
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <chktst>:
void chktst(uint32 n)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	ff 75 08             	pushl  0x8(%ebp)
  801f61:	6a 22                	push   $0x22
  801f63:	e8 df fb ff ff       	call   801b47 <syscall>
  801f68:	83 c4 18             	add    $0x18,%esp
	return ;
  801f6b:	90                   	nop
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <inctst>:

void inctst()
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 23                	push   $0x23
  801f7d:	e8 c5 fb ff ff       	call   801b47 <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
	return ;
  801f85:	90                   	nop
}
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <gettst>:
uint32 gettst()
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 24                	push   $0x24
  801f97:	e8 ab fb ff ff       	call   801b47 <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 25                	push   $0x25
  801fb3:	e8 8f fb ff ff       	call   801b47 <syscall>
  801fb8:	83 c4 18             	add    $0x18,%esp
  801fbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fbe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fc2:	75 07                	jne    801fcb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fc4:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc9:	eb 05                	jmp    801fd0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 25                	push   $0x25
  801fe4:	e8 5e fb ff ff       	call   801b47 <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
  801fec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fef:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ff3:	75 07                	jne    801ffc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ff5:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffa:	eb 05                	jmp    802001 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ffc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 25                	push   $0x25
  802015:	e8 2d fb ff ff       	call   801b47 <syscall>
  80201a:	83 c4 18             	add    $0x18,%esp
  80201d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802020:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802024:	75 07                	jne    80202d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802026:	b8 01 00 00 00       	mov    $0x1,%eax
  80202b:	eb 05                	jmp    802032 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80202d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 25                	push   $0x25
  802046:	e8 fc fa ff ff       	call   801b47 <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
  80204e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802051:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802055:	75 07                	jne    80205e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802057:	b8 01 00 00 00       	mov    $0x1,%eax
  80205c:	eb 05                	jmp    802063 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	ff 75 08             	pushl  0x8(%ebp)
  802073:	6a 26                	push   $0x26
  802075:	e8 cd fa ff ff       	call   801b47 <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
	return ;
  80207d:	90                   	nop
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802084:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802087:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80208a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	6a 00                	push   $0x0
  802092:	53                   	push   %ebx
  802093:	51                   	push   %ecx
  802094:	52                   	push   %edx
  802095:	50                   	push   %eax
  802096:	6a 27                	push   $0x27
  802098:	e8 aa fa ff ff       	call   801b47 <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
}
  8020a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	52                   	push   %edx
  8020b5:	50                   	push   %eax
  8020b6:	6a 28                	push   $0x28
  8020b8:	e8 8a fa ff ff       	call   801b47 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8020c5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	6a 00                	push   $0x0
  8020d0:	51                   	push   %ecx
  8020d1:	ff 75 10             	pushl  0x10(%ebp)
  8020d4:	52                   	push   %edx
  8020d5:	50                   	push   %eax
  8020d6:	6a 29                	push   $0x29
  8020d8:	e8 6a fa ff ff       	call   801b47 <syscall>
  8020dd:	83 c4 18             	add    $0x18,%esp
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	ff 75 10             	pushl  0x10(%ebp)
  8020ec:	ff 75 0c             	pushl  0xc(%ebp)
  8020ef:	ff 75 08             	pushl  0x8(%ebp)
  8020f2:	6a 12                	push   $0x12
  8020f4:	e8 4e fa ff ff       	call   801b47 <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8020fc:	90                   	nop
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802102:	8b 55 0c             	mov    0xc(%ebp),%edx
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	52                   	push   %edx
  80210f:	50                   	push   %eax
  802110:	6a 2a                	push   $0x2a
  802112:	e8 30 fa ff ff       	call   801b47 <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
	return;
  80211a:	90                   	nop
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802123:	83 ec 04             	sub    $0x4,%esp
  802126:	68 ea 2c 80 00       	push   $0x802cea
  80212b:	68 2e 01 00 00       	push   $0x12e
  802130:	68 fe 2c 80 00       	push   $0x802cfe
  802135:	e8 84 e6 ff ff       	call   8007be <_panic>

0080213a <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  802140:	83 ec 04             	sub    $0x4,%esp
  802143:	68 ea 2c 80 00       	push   $0x802cea
  802148:	68 35 01 00 00       	push   $0x135
  80214d:	68 fe 2c 80 00       	push   $0x802cfe
  802152:	e8 67 e6 ff ff       	call   8007be <_panic>

00802157 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80215d:	83 ec 04             	sub    $0x4,%esp
  802160:	68 ea 2c 80 00       	push   $0x802cea
  802165:	68 3b 01 00 00       	push   $0x13b
  80216a:	68 fe 2c 80 00       	push   $0x802cfe
  80216f:	e8 4a e6 ff ff       	call   8007be <_panic>

00802174 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	68 0c 2d 80 00       	push   $0x802d0c
  802182:	6a 09                	push   $0x9
  802184:	68 34 2d 80 00       	push   $0x802d34
  802189:	e8 30 e6 ff ff       	call   8007be <_panic>

0080218e <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  802194:	83 ec 04             	sub    $0x4,%esp
  802197:	68 44 2d 80 00       	push   $0x802d44
  80219c:	6a 10                	push   $0x10
  80219e:	68 34 2d 80 00       	push   $0x802d34
  8021a3:	e8 16 e6 ff ff       	call   8007be <_panic>

008021a8 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	68 6c 2d 80 00       	push   $0x802d6c
  8021b6:	6a 18                	push   $0x18
  8021b8:	68 34 2d 80 00       	push   $0x802d34
  8021bd:	e8 fc e5 ff ff       	call   8007be <_panic>

008021c2 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8021c8:	83 ec 04             	sub    $0x4,%esp
  8021cb:	68 94 2d 80 00       	push   $0x802d94
  8021d0:	6a 20                	push   $0x20
  8021d2:	68 34 2d 80 00       	push   $0x802d34
  8021d7:	e8 e2 e5 ff ff       	call   8007be <_panic>

008021dc <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	8b 40 10             	mov    0x10(%eax),%eax
}
  8021e5:	5d                   	pop    %ebp
  8021e6:	c3                   	ret    
  8021e7:	90                   	nop

008021e8 <__udivdi3>:
  8021e8:	55                   	push   %ebp
  8021e9:	57                   	push   %edi
  8021ea:	56                   	push   %esi
  8021eb:	53                   	push   %ebx
  8021ec:	83 ec 1c             	sub    $0x1c,%esp
  8021ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021ff:	89 ca                	mov    %ecx,%edx
  802201:	89 f8                	mov    %edi,%eax
  802203:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802207:	85 f6                	test   %esi,%esi
  802209:	75 2d                	jne    802238 <__udivdi3+0x50>
  80220b:	39 cf                	cmp    %ecx,%edi
  80220d:	77 65                	ja     802274 <__udivdi3+0x8c>
  80220f:	89 fd                	mov    %edi,%ebp
  802211:	85 ff                	test   %edi,%edi
  802213:	75 0b                	jne    802220 <__udivdi3+0x38>
  802215:	b8 01 00 00 00       	mov    $0x1,%eax
  80221a:	31 d2                	xor    %edx,%edx
  80221c:	f7 f7                	div    %edi
  80221e:	89 c5                	mov    %eax,%ebp
  802220:	31 d2                	xor    %edx,%edx
  802222:	89 c8                	mov    %ecx,%eax
  802224:	f7 f5                	div    %ebp
  802226:	89 c1                	mov    %eax,%ecx
  802228:	89 d8                	mov    %ebx,%eax
  80222a:	f7 f5                	div    %ebp
  80222c:	89 cf                	mov    %ecx,%edi
  80222e:	89 fa                	mov    %edi,%edx
  802230:	83 c4 1c             	add    $0x1c,%esp
  802233:	5b                   	pop    %ebx
  802234:	5e                   	pop    %esi
  802235:	5f                   	pop    %edi
  802236:	5d                   	pop    %ebp
  802237:	c3                   	ret    
  802238:	39 ce                	cmp    %ecx,%esi
  80223a:	77 28                	ja     802264 <__udivdi3+0x7c>
  80223c:	0f bd fe             	bsr    %esi,%edi
  80223f:	83 f7 1f             	xor    $0x1f,%edi
  802242:	75 40                	jne    802284 <__udivdi3+0x9c>
  802244:	39 ce                	cmp    %ecx,%esi
  802246:	72 0a                	jb     802252 <__udivdi3+0x6a>
  802248:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80224c:	0f 87 9e 00 00 00    	ja     8022f0 <__udivdi3+0x108>
  802252:	b8 01 00 00 00       	mov    $0x1,%eax
  802257:	89 fa                	mov    %edi,%edx
  802259:	83 c4 1c             	add    $0x1c,%esp
  80225c:	5b                   	pop    %ebx
  80225d:	5e                   	pop    %esi
  80225e:	5f                   	pop    %edi
  80225f:	5d                   	pop    %ebp
  802260:	c3                   	ret    
  802261:	8d 76 00             	lea    0x0(%esi),%esi
  802264:	31 ff                	xor    %edi,%edi
  802266:	31 c0                	xor    %eax,%eax
  802268:	89 fa                	mov    %edi,%edx
  80226a:	83 c4 1c             	add    $0x1c,%esp
  80226d:	5b                   	pop    %ebx
  80226e:	5e                   	pop    %esi
  80226f:	5f                   	pop    %edi
  802270:	5d                   	pop    %ebp
  802271:	c3                   	ret    
  802272:	66 90                	xchg   %ax,%ax
  802274:	89 d8                	mov    %ebx,%eax
  802276:	f7 f7                	div    %edi
  802278:	31 ff                	xor    %edi,%edi
  80227a:	89 fa                	mov    %edi,%edx
  80227c:	83 c4 1c             	add    $0x1c,%esp
  80227f:	5b                   	pop    %ebx
  802280:	5e                   	pop    %esi
  802281:	5f                   	pop    %edi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    
  802284:	bd 20 00 00 00       	mov    $0x20,%ebp
  802289:	89 eb                	mov    %ebp,%ebx
  80228b:	29 fb                	sub    %edi,%ebx
  80228d:	89 f9                	mov    %edi,%ecx
  80228f:	d3 e6                	shl    %cl,%esi
  802291:	89 c5                	mov    %eax,%ebp
  802293:	88 d9                	mov    %bl,%cl
  802295:	d3 ed                	shr    %cl,%ebp
  802297:	89 e9                	mov    %ebp,%ecx
  802299:	09 f1                	or     %esi,%ecx
  80229b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80229f:	89 f9                	mov    %edi,%ecx
  8022a1:	d3 e0                	shl    %cl,%eax
  8022a3:	89 c5                	mov    %eax,%ebp
  8022a5:	89 d6                	mov    %edx,%esi
  8022a7:	88 d9                	mov    %bl,%cl
  8022a9:	d3 ee                	shr    %cl,%esi
  8022ab:	89 f9                	mov    %edi,%ecx
  8022ad:	d3 e2                	shl    %cl,%edx
  8022af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022b3:	88 d9                	mov    %bl,%cl
  8022b5:	d3 e8                	shr    %cl,%eax
  8022b7:	09 c2                	or     %eax,%edx
  8022b9:	89 d0                	mov    %edx,%eax
  8022bb:	89 f2                	mov    %esi,%edx
  8022bd:	f7 74 24 0c          	divl   0xc(%esp)
  8022c1:	89 d6                	mov    %edx,%esi
  8022c3:	89 c3                	mov    %eax,%ebx
  8022c5:	f7 e5                	mul    %ebp
  8022c7:	39 d6                	cmp    %edx,%esi
  8022c9:	72 19                	jb     8022e4 <__udivdi3+0xfc>
  8022cb:	74 0b                	je     8022d8 <__udivdi3+0xf0>
  8022cd:	89 d8                	mov    %ebx,%eax
  8022cf:	31 ff                	xor    %edi,%edi
  8022d1:	e9 58 ff ff ff       	jmp    80222e <__udivdi3+0x46>
  8022d6:	66 90                	xchg   %ax,%ax
  8022d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022dc:	89 f9                	mov    %edi,%ecx
  8022de:	d3 e2                	shl    %cl,%edx
  8022e0:	39 c2                	cmp    %eax,%edx
  8022e2:	73 e9                	jae    8022cd <__udivdi3+0xe5>
  8022e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022e7:	31 ff                	xor    %edi,%edi
  8022e9:	e9 40 ff ff ff       	jmp    80222e <__udivdi3+0x46>
  8022ee:	66 90                	xchg   %ax,%ax
  8022f0:	31 c0                	xor    %eax,%eax
  8022f2:	e9 37 ff ff ff       	jmp    80222e <__udivdi3+0x46>
  8022f7:	90                   	nop

008022f8 <__umoddi3>:
  8022f8:	55                   	push   %ebp
  8022f9:	57                   	push   %edi
  8022fa:	56                   	push   %esi
  8022fb:	53                   	push   %ebx
  8022fc:	83 ec 1c             	sub    $0x1c,%esp
  8022ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802303:	8b 74 24 34          	mov    0x34(%esp),%esi
  802307:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80230b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80230f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802313:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802317:	89 f3                	mov    %esi,%ebx
  802319:	89 fa                	mov    %edi,%edx
  80231b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80231f:	89 34 24             	mov    %esi,(%esp)
  802322:	85 c0                	test   %eax,%eax
  802324:	75 1a                	jne    802340 <__umoddi3+0x48>
  802326:	39 f7                	cmp    %esi,%edi
  802328:	0f 86 a2 00 00 00    	jbe    8023d0 <__umoddi3+0xd8>
  80232e:	89 c8                	mov    %ecx,%eax
  802330:	89 f2                	mov    %esi,%edx
  802332:	f7 f7                	div    %edi
  802334:	89 d0                	mov    %edx,%eax
  802336:	31 d2                	xor    %edx,%edx
  802338:	83 c4 1c             	add    $0x1c,%esp
  80233b:	5b                   	pop    %ebx
  80233c:	5e                   	pop    %esi
  80233d:	5f                   	pop    %edi
  80233e:	5d                   	pop    %ebp
  80233f:	c3                   	ret    
  802340:	39 f0                	cmp    %esi,%eax
  802342:	0f 87 ac 00 00 00    	ja     8023f4 <__umoddi3+0xfc>
  802348:	0f bd e8             	bsr    %eax,%ebp
  80234b:	83 f5 1f             	xor    $0x1f,%ebp
  80234e:	0f 84 ac 00 00 00    	je     802400 <__umoddi3+0x108>
  802354:	bf 20 00 00 00       	mov    $0x20,%edi
  802359:	29 ef                	sub    %ebp,%edi
  80235b:	89 fe                	mov    %edi,%esi
  80235d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802361:	89 e9                	mov    %ebp,%ecx
  802363:	d3 e0                	shl    %cl,%eax
  802365:	89 d7                	mov    %edx,%edi
  802367:	89 f1                	mov    %esi,%ecx
  802369:	d3 ef                	shr    %cl,%edi
  80236b:	09 c7                	or     %eax,%edi
  80236d:	89 e9                	mov    %ebp,%ecx
  80236f:	d3 e2                	shl    %cl,%edx
  802371:	89 14 24             	mov    %edx,(%esp)
  802374:	89 d8                	mov    %ebx,%eax
  802376:	d3 e0                	shl    %cl,%eax
  802378:	89 c2                	mov    %eax,%edx
  80237a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80237e:	d3 e0                	shl    %cl,%eax
  802380:	89 44 24 04          	mov    %eax,0x4(%esp)
  802384:	8b 44 24 08          	mov    0x8(%esp),%eax
  802388:	89 f1                	mov    %esi,%ecx
  80238a:	d3 e8                	shr    %cl,%eax
  80238c:	09 d0                	or     %edx,%eax
  80238e:	d3 eb                	shr    %cl,%ebx
  802390:	89 da                	mov    %ebx,%edx
  802392:	f7 f7                	div    %edi
  802394:	89 d3                	mov    %edx,%ebx
  802396:	f7 24 24             	mull   (%esp)
  802399:	89 c6                	mov    %eax,%esi
  80239b:	89 d1                	mov    %edx,%ecx
  80239d:	39 d3                	cmp    %edx,%ebx
  80239f:	0f 82 87 00 00 00    	jb     80242c <__umoddi3+0x134>
  8023a5:	0f 84 91 00 00 00    	je     80243c <__umoddi3+0x144>
  8023ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023af:	29 f2                	sub    %esi,%edx
  8023b1:	19 cb                	sbb    %ecx,%ebx
  8023b3:	89 d8                	mov    %ebx,%eax
  8023b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8023b9:	d3 e0                	shl    %cl,%eax
  8023bb:	89 e9                	mov    %ebp,%ecx
  8023bd:	d3 ea                	shr    %cl,%edx
  8023bf:	09 d0                	or     %edx,%eax
  8023c1:	89 e9                	mov    %ebp,%ecx
  8023c3:	d3 eb                	shr    %cl,%ebx
  8023c5:	89 da                	mov    %ebx,%edx
  8023c7:	83 c4 1c             	add    $0x1c,%esp
  8023ca:	5b                   	pop    %ebx
  8023cb:	5e                   	pop    %esi
  8023cc:	5f                   	pop    %edi
  8023cd:	5d                   	pop    %ebp
  8023ce:	c3                   	ret    
  8023cf:	90                   	nop
  8023d0:	89 fd                	mov    %edi,%ebp
  8023d2:	85 ff                	test   %edi,%edi
  8023d4:	75 0b                	jne    8023e1 <__umoddi3+0xe9>
  8023d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023db:	31 d2                	xor    %edx,%edx
  8023dd:	f7 f7                	div    %edi
  8023df:	89 c5                	mov    %eax,%ebp
  8023e1:	89 f0                	mov    %esi,%eax
  8023e3:	31 d2                	xor    %edx,%edx
  8023e5:	f7 f5                	div    %ebp
  8023e7:	89 c8                	mov    %ecx,%eax
  8023e9:	f7 f5                	div    %ebp
  8023eb:	89 d0                	mov    %edx,%eax
  8023ed:	e9 44 ff ff ff       	jmp    802336 <__umoddi3+0x3e>
  8023f2:	66 90                	xchg   %ax,%ax
  8023f4:	89 c8                	mov    %ecx,%eax
  8023f6:	89 f2                	mov    %esi,%edx
  8023f8:	83 c4 1c             	add    $0x1c,%esp
  8023fb:	5b                   	pop    %ebx
  8023fc:	5e                   	pop    %esi
  8023fd:	5f                   	pop    %edi
  8023fe:	5d                   	pop    %ebp
  8023ff:	c3                   	ret    
  802400:	3b 04 24             	cmp    (%esp),%eax
  802403:	72 06                	jb     80240b <__umoddi3+0x113>
  802405:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802409:	77 0f                	ja     80241a <__umoddi3+0x122>
  80240b:	89 f2                	mov    %esi,%edx
  80240d:	29 f9                	sub    %edi,%ecx
  80240f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802413:	89 14 24             	mov    %edx,(%esp)
  802416:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80241a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80241e:	8b 14 24             	mov    (%esp),%edx
  802421:	83 c4 1c             	add    $0x1c,%esp
  802424:	5b                   	pop    %ebx
  802425:	5e                   	pop    %esi
  802426:	5f                   	pop    %edi
  802427:	5d                   	pop    %ebp
  802428:	c3                   	ret    
  802429:	8d 76 00             	lea    0x0(%esi),%esi
  80242c:	2b 04 24             	sub    (%esp),%eax
  80242f:	19 fa                	sbb    %edi,%edx
  802431:	89 d1                	mov    %edx,%ecx
  802433:	89 c6                	mov    %eax,%esi
  802435:	e9 71 ff ff ff       	jmp    8023ab <__umoddi3+0xb3>
  80243a:	66 90                	xchg   %ax,%ax
  80243c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802440:	72 ea                	jb     80242c <__umoddi3+0x134>
  802442:	89 d9                	mov    %ebx,%ecx
  802444:	e9 62 ff ff ff       	jmp    8023ab <__umoddi3+0xb3>
